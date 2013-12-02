class @CreateController extends RouteController

Template.create.created = ->
  @firstRender = true
  return

Template.create.rendered = ->
  if @firstRender
    @firstRender = false

    # setup form validation
    parsleyOptions = getBaseParsleyOptions()

    $("#form-create").parsley parsleyOptions

    $("#input-create-title").focus()

Template.create.events
  "keyup #form-create input, #form-create textarea": (evt) ->
    if evt.which is 13
      $("#button-create").click()

  "click #button-create": ->
    # validate the form
    $("#form-create").parsley("validate").done (valid) ->
      unless valid then return

      # get data from form
      content = $("#input-create-content").val()
      title = $("#input-create-title").val()

      # create the document random key
      documentKey = sjcl.random.randomWords 8

      # encrypt the content with the created key
      encryptedContent = sjcl.encrypt documentKey, content

      # encrypt the document's key with the user's public key
      encryptedKey = UberSafe.encryptAsymmetric documentKey

      # create the document
      Meteor.call "createDocument", title, encryptedContent, encryptedKey, (error, result) ->
        if error
          console.error error
          FlashMessages.sendError __ "create.flash.error"
        else
          FlashMessages.sendSuccess __ "create.flash.success",
            title: title

          Router.go "dashboard"