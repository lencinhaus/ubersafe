# publish user contacts
Meteor.publish "contacts", ->
  unless @userId then null

  check @userId, Match.NotEmptyString

  Contacts.find
    userId: @userId

Meteor.methods
  # check if a user with this username and/or email exists
  checkUserExists: (value) ->
    check @userId, Match.NotEmptyString
    check value, Match.NotEmptyString

    Meteor.users.find
      $or: [
        username: value
      ,
        emails:
          $elemMatch:
            address: value
      ]
    .count() > 0

  # add a contact request
  addContactRequest: (value) ->
    check @userId, Match.NotEmptyString
    check value, Match.NotEmptyString

    # get the user
    user = Meteor.users.findOne
      $and: [
          _id:
            $ne: @userId
        ,
          $or: [
            username: value
          ,
            emails:
              $elemMatch:
                address: value
          ]
      ]

    check user, Object

    # check if a contact request is already present
    alreadySent = Notifications.find
      type: "contactRequest"
      fromUserId: @userId
      toUserId: user._id
    .count() > 0

    if alreadySent then return false

    # add a contact request notification for the user
    Notifications.insert
      createdAt: new Date()
      seen: false
      toUserId: user._id
      type: "contactRequest"
      fromUserId: @userId
      fromUsername: Meteor.user().username

    true