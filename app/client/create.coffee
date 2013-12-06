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

      # create the document key
      key = UberSafe.generateDocumentKey()

      # encrypt the content with the created key
      promise = CryptoBot.encryptString content, key
      promise.done (encryptedContent) ->
        # encrypt the document's key
        encryptedKey = UberSafe.encryptDocumentKey key

        # create the document
        document =
          type: "text"
          title: title
          content: encryptedContent

        Meteor.call "createDocument", document, encryptedKey, (error) ->
          if error
            console.error error
            FlashMessages.sendError __ "create.flash.error"
          else
            FlashMessages.sendSuccess __ "create.flash.success",
              title: title

            Router.go "dashboard"

      promise.fail (error) ->
        console.error error