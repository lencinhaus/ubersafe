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

  "click #link-show-public-key": (evt) ->
    evt.preventDefault()

Template.flashMessagesEnhanced.helpers
  messages: ->
    if flashMessages.find().count()
      $("html, body").animate
        scrollTop: 0
      , 200
    flashMessages.find()

Template.flashMessageEnhanced.rendered = ->
  message = @.data;
  Meteor.defer ->
    flashMessages.update message._id,
      $set:
        seen: true

  if message.options && message.options.autoHide
    $(@find(".alert")).delay(message.options.hideDelay).fadeOut 400, ->
      flashMessages.remove
        _id: message._id

Template.flashMessageEnhanced.events
  "click .close": (e, tmpl) ->
    e.preventDefault()
    flashMessages.remove tmpl.data._id

Template.publicKey.formattedPublicKey = ->
  formattedPublicKey = ""
  if UberSafe.hasKeys()
    publicKey = UberSafe.getPublicKey()
    tokens = for i in [0..publicKey.length] by 24
      publicKey.substring(i, i + 24)

    formattedPublicKey = tokens.join "\n"

  formattedPublicKey

Template.publicKey.rendered = ->
  $('#modal-public-key').on "shown.bs.modal", ->
    $('#public-key').select().focus()
