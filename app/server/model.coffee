_.extend Notifications,
  send: (userId, type, data) ->
    notification =
      createdAt: new Date()
      seen: false
      clicked: false
      toUserId: userId
      type: type

    if data
      notification = _.extend data, notification

    Notifications.insert notification