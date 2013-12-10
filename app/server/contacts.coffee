# publish user contacts
getContactWithUsername = (userId, contact) ->
  contactWithUsernames = _.clone contact

  if contact.fromUserId is userId
    user = Meteor.users.findOne
      _id: contact.toUserId
  else
    user = Meteor.users.findOne
      _id: contact.fromUserId

  if user
    contactWithUsernames.username = user.username

  contactWithUsernames

Meteor.publish "contacts", ->
  check @userId, Match.NotEmptyString
  self = this

  cursor = Contacts.find
    $or: [
        fromUserId: @userId
      ,
        toUserId: @userId
    ]

  handle = cursor.observe
    added: (contact) ->
      self.added "contacts", contact._id, getContactWithUsername(self.userId, contact)

    changed: (contact) ->
      self.changed "contacts", contact._id, getContactWithUsername(self.userId, contact)

    removed: (contact) ->
      self.removed "contacts", contact._id

  @onStop ->
    handle.stop()

  @ready()
  return

Meteor.methods
  # find users whose username matches query
  queryUsers: (query) ->
    check @userId, Match.NotEmptyString
    check query, Match.NotEmptyString

    # create a regex pattern from query, see http://stackoverflow.com/a/6969486/282034
    queryPattern = query.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"

    Meteor.users.find
      _id:
        $ne: @userId
      username:
        $regex: new RegExp queryPattern, "i"
    ,
      sort:
        username: 1
      limit:
        20
      fields:
        _id: 1
        username: 1
    .fetch()

  # add a contact request
  addContactRequest: (contactUserId) ->
    self = this
    check @userId, Match.NotEmptyString
    check contactUserId, Match.Where (userId) ->
      check userId, Match.NotEmptyString
      userId isnt self.userId

    # get the user
    user = Meteor.users.findOne
      _id: contactUserId

    check user, Object

    # check if the current user already has this contact
    contact = Contacts.findOne
      fromUserId: @userId
      toUserId: user._id

    # return the current status of the contact
    if contact then return contact.status

    # check if the requested contact has already requested the current user
    contact = Contacts.findOne
      fromUserId: user._id
      toUserId: @userId

    if contact then return "pending"

    # add the contact request
    contactId = Contacts.insert
      fromUserId: @userId
      toUserId: user._id
      status: "requested"
      requestedAt: new Date()
      answeredAt: null

    # add a contact request notification for the user
    Notifications.send user._id, "contactRequest",
      contactId: contactId
      fromUsername: Meteor.user().username

    true

  # accept a contact request
  acceptContactRequest: (contactId) ->
    check @userId, Match.NotEmptyString
