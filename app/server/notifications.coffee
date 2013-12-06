Meteor.startup ->
  Notifications.allow
    insert: (userId, notification) ->
      true
    remove: ->
      true

Meteor.publish "notifications", ->
  unless @userId then null

  Notifications.find
    toUserId: @userId
  ,
    sort:
      createdAt: -1

Meteor.methods
  markSeenNotifications: (ids) ->
    self = this
    check @userId, Match.NotEmptyString
    check ids, [Match.NotEmptyString]

    check ids, Match.Where (ids) ->
      # check that these are valid notification ids for the current user
      console.log ids, self.userId, Notifications.find
        _id:
          $in: ids
        toUserId:
          $ne: self.userId
      .fetch()
      Notifications.find
        _id:
          $in: ids
        toUserId:
          $ne: self.userId
      .count() is 0

    # update the seen status of these notifications
    Notifications.update
      _id:
        $in: ids
    ,
      $set:
        seen: true
    ,
      multi: true

