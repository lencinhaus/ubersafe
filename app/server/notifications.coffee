Meteor.publish "notifications", ->
  maybeWait()

  unless @userId then null

  Notifications.find
    toUserId: @userId
  ,
    sort:
      createdAt: -1

setNotificationsFlag = (userId, ids, flag) ->
  check userId, Match.NotEmptyString
  check ids, [Match.NotEmptyString]

  check ids, Match.Where (ids) ->
    # check that these are valid notification ids for the current user
    Notifications.find
      _id:
        $in: ids
      toUserId:
        $ne: userId
    .count() is 0

  # update the flag of these notifications
  updates =
    $set: {}
  updates["$set"][flag] = true
  Notifications.update
    _id:
      $in: ids
  , updates,
    multi: true

Meteor.methods
  markSeenNotifications: (ids) ->
    maybeWait()
    setNotificationsFlag @userId, ids, "seen"

  markClickedNotification: (notificationId) ->
    maybeWait()
    setNotificationsFlag @userId, [notificationId], "clicked"
