FlashMessages.configure
  autoHide: true
  hideDelay: 5000

Template.layout.currentRouteStartsWith = (prefix) ->
  Router.current()?.route?.name.slice(0, prefix.length) is prefix

Template.layout.events
  # hack for making accounts-ui-bootstrap-3 login buttons play along with iron router history
  "click #login-dropdown-list .dropdown-toggle": (evt) ->
    evt.preventDefault()

  "click .link-switch-locale": (evt) ->
    locale = $(evt.target).data "locale"
    unless locale then return
    Meteor.setLocale locale
