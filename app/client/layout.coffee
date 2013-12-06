Template.layout.appName = Meteor.settings.public.name

Template.layout.currentRouteStartsWith = (prefix) ->
  Router.current()?.route?.name.slice(0, prefix.length) is prefix

Template.layout.events
  "click .link-switch-locale": (evt) ->
    locale = $(evt.target).data "locale"
    unless locale then return
    Meteor.setLocale locale

  "click #link-logout": ->
    username = Meteor.user().username
    Meteor.logout (error) ->
      if error
        # show error flash
        FlashMessages.sendError __ "layout.flash.logoutError"
      else
        # show success flash
        FlashMessages.sendSuccess __ "layout.flash.logoutSuccess",
          username: username