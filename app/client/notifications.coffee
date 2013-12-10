Deps.autorun ->
  if Meteor.user()
    Meteor.subscribe "notifications"

dropdownOpen = false

Template.notifications.notifications = ->
  Notifications.find().fetch()

Template.notifications.unseen = ->
  Notifications.find
    seen: false
  .count()

Template.notifications.typeIs = (type) ->
  @type is type

Template.notifications.pathForPendingContacts = ->
  Router.routes["contacts"].path
    type: "pending"

Template.notifications.dropdownClasses = ->
  classes = "dropdown"
  if dropdownOpen then classes += " open"
  classes

Template.notifications.rendered = ->
  # remember the open state of the dropdown, so that we can keep it open when it's re-rendered
  $("#dropdown-notifications").on "hidden.bs.dropdown", ->
    dropdownOpen = false
    return

  $("#dropdown-notifications").on "shown.bs.dropdown", ->
    dropdownOpen = true

    # mark the current unseen notifications as seen
    unseenIds = (notification._id for notification in Notifications.find({ seen: false }).fetch())

    if unseenIds.length
      Meteor.call "markSeenNotifications", unseenIds

    return

Template.notifications.events
  "click .notification": ->
    # mark the notification as clicked
    Meteor.call "markClickedNotification", @_id

  "click .notification.contactRequest": ->
    # put the contact id in the session, so that we can highlight it once on the contacts page
    Session.set "highlightContact", @contactId