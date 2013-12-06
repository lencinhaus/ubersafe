Meteor.subscribe "notifications"

Template.notifications.notifications = ->
  Notifications.find().fetch()

Template.notifications.unseen = ->
  Notifications.find
    seen: false
  .count()

Template.notifications.isContactRequest = ->
  @type is "contactRequest"

Template.notifications.events
  "click #link-open-notifications": ->
    # mark the current unseen notifications as seen
    unseenIds = (notification._id for notification in Notifications.find({ seen: false }).fetch())

    if unseenIds.length
      Meteor.call "markSeenNotifications", unseenIds
