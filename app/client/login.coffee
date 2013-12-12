Template.login.lastUsername = ->
  UberSafe.getLastUsername() or ""

Template.login.created = ->
  @firstRender = true
  return

Template.login.rendered = ->
  # setup form validation
  parsleyOptions = getBaseParsleyOptions()

  $("#form-login").parsley("destroy").parsley parsleyOptions

  if @firstRender
    @firstRender = false

    if UberSafe.getLastUsername()
      $("#input-login-password").focus()
    else
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

      # set password
      UberSafe.setPassword password

      Meteor.loginWithPassword
        username: username
      , password, (error) ->
          if error
            # forget the password
            UberSafe.clearPassword()

            # show error flash
            FlashMessages.sendError __ "login.flash.error"
          else
            # update last username
            UberSafe.setLastUsername username

            # show success flash
            FlashMessages.sendSuccess __ "login.flash.success",
              username: username
              appName: Meteor.settings.public.name

            # restore previous route
            Router.current().restore()