Template.login.lastUsername = ->
  UberSafe.getLastUsername()

Template.login.created = ->
  @firstRender = true
  return

Template.login.rendered = ->
  if @firstRender
    @firstRender = false

    # setup form validation
    parsleyOptions = getBaseParsleyOptions()

    $("#form-login").parsley parsleyOptions

    # focus on the login
    $("#input-login-username").focus()

Template.login.events
  "keyup #form-login input": (evt) ->
    if evt.which is 13
      $("#button-login").click()

  "click #button-login": ->
    # validate the form
    $("#form-login").parsley("validate").done (valid) ->
      unless valid then return

      username = $("#input-login-username").val()
      password = $("#input-login-password").val()

      Meteor.loginWithPassword
        username: username
      , password, (error) ->
          if error
            # show error flash
            FlashMessages.sendError __ "login.flash.error"
          else
            # show success flash
            FlashMessages.sendSuccess __ "login.flash.success",
              username: username
              appName: Meteor.settings.public.name