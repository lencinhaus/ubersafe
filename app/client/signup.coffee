Template.signup.minPasswordLength = Meteor.settings.public.password.minLength

Template.signup.created = ->
  @firstRender = true
  return

Template.signup.rendered = ->
  if @firstRender
    @firstRender = false

    # setup form validation
    parsleyOptions = getBaseParsleyOptions()

    _.extend parsleyOptions,
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
        unique: __ "signup.validation.unique"


    $("#form-signup").parsley parsleyOptions

    # focus on the email
    $("#input-signup-email").focus()

Template.signup.events
  "keyup #form-signup input": (evt) ->
    if evt.which is 13
      $("#button-signup").click()

  "click #button-signup": ->
    # validate the form
    $("#form-signup").parsley("validate").done (valid) ->
      unless valid then return

      # create the user
      password = $('#input-signup-password').val()

      user =
        username: $("#input-signup-username").val()
        email: $("#input-signup-email").val()
        password: password

      Accounts.createUser user, (error) ->
        if error
          console.error error
        else
          # add a success flash
          FlashMessages.sendSuccess __ "signup.flash.success",
            username: user.username
            appName: Meteor.settings.public.name