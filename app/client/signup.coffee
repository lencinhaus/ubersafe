Template.signup.minPasswordLength = Meteor.settings.public.password.minLength

Template.signup.rendered = ->
  # setup form validation
  parsleyOptions = getBaseParsleyOptions()

  _.deepExtend parsleyOptions,
    validators:
      unique: ->
        validate: (value, property, self) ->
          deferred = $.Deferred()
          Meteor.call "checkUserUniqueProperty", property, value, (error, unique) ->
            if error
              deferred.reject
            else
              deferred.resolveWith self, [unique]

          deferred.promise()
        priority: 64

    messages:
      unique: __ "signup.form.validation.unique"

  $("#form-signup").parsley("destroy").parsley parsleyOptions

  # password popover
  $("#input-signup-password").popover("destroy").popover
    trigger: "focus"
    title: __ "signup.form.password.popover.title"
    content: __ "signup.form.password.popover.content"

  unless @renderedOnce
    @renderedOnce = true

    # focus on the username
    $("#input-signup-username").focus()

Template.signup.events
  "keyup #form-signup input": (evt) ->
    if evt.which is 13
      $("#button-signup").click()

  "click #button-signup": ->
    # validate the form
    $("#form-signup").parsley("validate").done (valid) ->
      unless valid then return

      password = $("#input-signup-password").val()

      # set the password
      UberSafe.setPassword password

      user =
        username: $("#input-signup-username").val()
        email: $("#input-signup-email").val()
        password: password
        ubersafe:
          keys: UberSafe.generateKeys()

      # create the user
      Accounts.createUser user, (error) ->
        if error
          # clear the password
          UberSafe.clearPassword()

          console.error error

          # add an error flash
          FlashMessages.sendError __ "common.flash.error"
        else
          # save the last username
          UberSafe.setLastUsername user.username

          # add a success flash
          FlashMessages.sendSuccess __ "signup.flash.success",
            username: user.username
            appName: Meteor.settings.public.name

          # restore previous route
          Router.current().restore()