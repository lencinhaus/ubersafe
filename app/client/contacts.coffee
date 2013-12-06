class @ContactsController extends RouteController
  before: ->
    @subscribe("contacts").wait()

  data: ->
    if @ready()
      contacts: Contacts.find().fetch()
    else
      @stop()
      return

Template.contacts.haveContacts = ->
  @contacts and @contacts.length > 0

Template.contacts.created = ->
  @firstRender = true
  return

Template.contacts.rendered = ->
  if @firstRender
    @firstRender = false

    # setup form validation
    parsleyOptions = getBaseParsleyOptions()

    _.extend parsleyOptions,
      validators:
        notcurrent: ->
          validate: (value, enabled, self) ->
            unless enabled then return true

            if Meteor.user().username is value then return false

            true
          priority: 64
        existing: ->
          validate: (value, enabled, self) ->
            unless enabled then true
            deferred = $.Deferred()
            Meteor.call "checkUserExists", value, (error, exists) ->
              if error
                deferred.reject
              else
                deferred.resolveWith self, [exists]

            deferred.promise()
          priority: 64

      messages:
        existing: __ "contacts.create.validation.existing"
        notcurrent: __ "contacts.create.validation.notcurrent"

    $("#form-add-contact").parsley parsleyOptions

    # when the add contact modal is shown...
    $("#modal-add-contact").on "shown.bs.modal", ->
      # focus on the user input
      $("#input-add-contact-user").focus()

Template.contacts.events
  "keyup #form-add-contact input": (evt) ->
    if evt.which is 13
      $("#button-add-contact").click()

  "click #button-add-contact": ->
    # validate the form
    $("#form-add-contact").parsley("validate").done (valid) ->
      unless valid then return

      # add a contact request
      value = $("#input-add-contact-user").val()
      Meteor.call "addContactRequest", value, (error, created) ->
        if error
          FlashMessages.sendError __ "contacts.create.flash.error"
        else if not created
          FlashMessages.sendInfo __ "contacts.create.flash.existing"
        else
          FlashMessages.sendSuccess __ "contacts.create.flash.success"

          # close the modal
          $("#modal-add-contact").modal "hide"

          # clear the form
          $("#input-add-contact-user").val ""

