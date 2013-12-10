types = [
  "accepted",
  "requests",
  "pending"
]

# get a contacts selector for a specific type of contacts
getSelectorByType = (type, status) ->
  selector = null

  switch type
    when "accepted"
      selector =
        status: "accepted"
        $or: [
          toUserId: Meteor.userId()
        ,
          fromUserId: Meteor.userId()
        ]

    when "requests", "pending"
      property = if "requests" is type then "fromUserId" else "toUserId"
      selector = {}
      selector[property] = Meteor.userId()

      if status
        selector.status = status
      else
        selector.status =
          $in: ["requested", "declined"]

  selector

class @ContactsController extends RouteController
  before: ->
    @subscribe("contacts").wait()

  data: ->
    if @ready()
      type = if @params.type and _.contains types, @params.type then @params.type else "accepted"
      selector = getSelectorByType type
      contacts = Contacts.find selector,
        sort:
          username: 1
      if "accepted" isnt type and contacts.count() is 0
        @redirect "contacts"
        return

      contacts: contacts
      type: type
    else
      @stop()
      return

# check current contacts type
Template.contacts.isType = (type) ->
  @type is type

# check current contact status
Template.contacts.isStatus = (status) ->
  @status is status

# check if an accepted contact has been requested by the current user or not
Template.contacts.isRequestedByMe = ->
  @fromUserId is Meteor.userId()

# count requested contacts of a specific type
Template.contacts.countNonDeclinedContacts = (type) ->
  status = if "accepted" is type then null else "requested"
  selector = getSelectorByType type, status
  Contacts.find(selector).count()

# check if we have contacts of a specific type (any status)
Template.contacts.haveContacts = (type) ->
  if @type is type
    return @contacts.count() > 0

  selector = getSelectorByType type
  Contacts.find(selector).count() > 0

# get the path for a type of contacts
Template.contacts.pathForContacts = (type) ->
  params = null
  if "accepted" isnt type
    params =
      type: type
  Router.routes["contacts"].path(params)

Template.contacts.created = ->
  @firstRender = true
  return

Template.contacts.rendered = ->
  if @firstRender
    @firstRender = false

    # when the add contact modal is showing...
    $("#modal-add-contact").on "show.bs.modal", ->
      # setup form validation
      parsleyOptions = getBaseParsleyOptions()

      $("#form-add-contact").parsley parsleyOptions

      # clear and selectize the user-id input
      $('#input-add-user-id').val('').selectize
        valueField: "_id"
        labelField: "username"
        searchField: "username"
        maxItems: 1
        load: (query, callback) ->
          if query and query.trim().length > 0
            # find users on the server
            Meteor.call "queryUsers", query, (error, contacts) ->
              if error
                console.error error
              else
                callback contacts
              return
            return
          else
            []

    # when it is shown...
    $("#modal-add-contact").on "shown.bs.modal", ->
      # focus on the user-id selectized input
      $("#input-add-user-id").parent().find(".selectize-control input[type=text]").focus()

    # when it is closed...
    $("#modal-add-contact").on "hidden.bs.modal", ->
      # de-selectize the user-id input
      $('#input-add-user-id')[0].selectize.destroy()

      # teardown parsley
      $("#form-add-contact").parsley "destroy"

Template.contacts.events
  "keyup #form-add-contact input": (evt) ->
    if evt.which is 13
      $("#button-add-contact").click()

  "click #button-add-contact": ->
    # validate the form
    $("#form-add-contact").parsley("validate").done (valid) ->
      unless valid then return

      # add a contact request
      userId = $("#input-add-user-id").val()

      Meteor.call "addContactRequest", userId, (error, result) ->
        if error
          FlashMessages.sendError __ "contacts.create.flash.error"
        else if result isnt true
          FlashMessages.sendInfo __ "contacts.create.flash.#{result}",
            pendingContactsPath: Router.routes["contacts"].path
              type: "pending"
            contactsPath: Router.routes["contacts"].path()
        else
          FlashMessages.sendSuccess __ "contacts.create.flash.success"

          # close the modal
          $("#modal-add-contact").modal "hide"

          # clear the form
          $("#input-add-contact-user").val ""




