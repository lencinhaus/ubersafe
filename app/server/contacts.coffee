# add the other user's username to a contact
getContactWithUsername = (userId, contact) ->
  contactWithUsername = contact

  otherUserId = if userId is contact.fromUserId then contact.toUserId else contact.fromUserId
  user = Meteor.users.findOne
    _id: otherUserId

  if user
    contactWithUsername = _.clone contact
    contactWithUsername.username = user.username

  contactWithUsername

# publish user contacts
Meteor.publish "contacts", ->
  #TODO: maybe this should be optimized by fetching all the usernames on the first run, and then single ones on updates
  #TODO: we should probably observe users too, and update relevant usernames when they change
  maybeWait()

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
    maybeWait()

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
    maybeWait()

    self = this
    check @userId, Match.NotEmptyString
    check contactUserId, Match.Where (userId) ->
      check userId, Match.NotEmptyString
      userId isnt self.userId

    # get the user
    user = Meteor.users.findOne
      _id: contactUserId

    check user, Object

    # check if there is already a contact between these users
    contact = Contacts.findOne
      $or: [
          fromUserId: @userId
          toUserId: user._id
        ,
          fromUserId: user._id
          toUserId: @userId
      ]

    # if there's a contact, return the status if it is accepted or if
    # it has been requested by the current user, or "pending" otherwise
    if contact
      if "accepted" is contact.status or @userId is contact.fromUserId
        return contact.status

      return "pending"

    # add the contact request
    contactId = Contacts.insert
      fromUserId: @userId
      toUserId: user._id
      status: "requested"
      requestedAt: new Date()
      answeredAt: null

    # remove notifications about contact removal between these users
    Notifications.remove
      type:
        $in: [
          "contactRemoved",
          "contactRequestWithdrawn"
          "contactRequestForgotten"
        ]
      $or: [
          fromUserId: @userId
          toUserId: user._id
        ,
          fromUserId: user._id
          toUserId: @userId
      ]

    # send a contact request notification to the other user
    Notifications.send user._id, "contactRequest",
      contactId: contactId
      fromUsername: Meteor.user().username

    true

  # accept or decline a contact request
  answerContactRequest: (contactId, accepted) ->
    maybeWait()

    self = this

    check @userId, Match.NotEmptyString
    check contactId, Match.NotEmptyString
    check accepted, Boolean

    # check that the contact exists
    contact = Contacts.findOne
      _id: contactId

    check contact, Object

    # check that the contact is addressed to the current user and is in requested status
    check contact, Match.Where (contact) ->
      self.userId is contact.toUserId and "requested" is contact.status

    # update the contact
    status = if accepted then "accepted" else "declined"
    Contacts.update contactId,
      $set:
        status: status
        answeredAt: new Date()

    # remove request notification
    Notifications.remove
      type: "contactRequest"
      contactId: contactId
      toUserId: @userId

    # send request answer notification to the requesting user
    Notifications.send contact.fromUserId, "contactRequestAnswer",
      contactId: contactId
      status: status
      fromUsername: Meteor.user().username

    return

  # remove an accepted contact or forget a declined one
  removeContact: (contactId) ->
    maybeWait()

    self = this

    check @userId, Match.NotEmptyString
    check contactId, Match.NotEmptyString

    # check that the contact exists
    contact = Contacts.findOne
      _id: contactId

    check contact, Object

    # the current user can remove a contact if either:
    # - the contact is from the current user and has status "requested" (withdraw)
    # - the contact is from or to the current user and has status "accepted" (remove)
    # - the contact is to the current user and has status "declined" (forget)
    check contact, Match.Where (contact) ->
      if "requested" is contact.status then return self.userId is contact.fromUserId
      if "accepted" is contact.status then return self.userId is contact.fromUserId or self.userId is contact.toUserId
      if "declined" is contact.status then return self.userId is contact.toUserId
      false

    # remove the contact
    Contacts.remove contactId

    # delete request notifications related to this contact
    Notifications.remove
      type:
        $in: ["contactRequest", "contactRequestAnswer"]
      contactId: contactId

    # infer notification type and other user id
    otherUserId = if @userId is contact.fromUserId then contact.toUserId else contact.fromUserId
    switch contact.status
      when "requested"
        notificationType = "contactRequestWithdrawn"

      when "accepted"
        notificationType = "contactRemoved"

      when "declined"
        notificationType = "contactRequestForgotten"

    # send a notification to the other user about contact removal
    Notifications.send otherUserId, notificationType,
      fromUserId: @userId
      fromUsername: Meteor.user().username

    return

