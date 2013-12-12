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
      .fetch()

      if "accepted" isnt type and contacts.length is 0
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

Template.contacts.statusLabel = ->
  __ "contacts.status.#{@status}"

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
    return @contacts and @contacts.length > 0

  selector = getSelectorByType type
  Contacts.find(selector).count() > 0

# get the path for a type of contacts
Template.contacts.pathForContacts = (type) ->
  params = null
  if "accepted" isnt type
    params =
      type: type
  Router.routes["contacts"].path(params)

Template.contacts.rendered = ->
  # table button confirms
  $("#table-contacts .button-remove").confirm __ "contacts.buttons.remove.confirm"
  $("#table-contacts .button-forget").confirm __ "contacts.buttons.forget.confirm"

  unless @firstRenderDone
    @firstRenderDone = true

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
  "click #table-contacts .button-accept": (evt) ->
    self = this

    # get the buttons
    acceptButton = $(evt.target)
    declineButton = acceptButton.parent().find('.button-decline')

    # hide the decline button
    declineButton.css "visibility", "hidden"

    # set accept button to loading
    acceptButton.button "loading"

    Meteor.call "answerContactRequest", @_id, true, (error) ->
      if error
        console.error error

        # restore the buttons
        acceptButton.button "reset"
        declineButton.css "visibility", "visible"

        # show an error flash
        FlashMessages.sendError __ "common.flash.error"
      else
        # show a success flash
        FlashMessages.sendSuccess __ "contacts.flash.acceptSuccess", self

        # go to accepted contacts
        Router.go "contacts"

  "click #table-contacts .button-decline": (evt) ->
    self = this

    # get the buttons
    declineButton = $(evt.target)
    acceptButton = declineButton.parent().find('.button-accept')

    # hide the accept button
    acceptButton.css "visibility", "hidden"

    # set decline button to loading
    declineButton.button "loading"

    Meteor.call "answerContactRequest", @_id, false, (error) ->
      if error
        console.error error

        # restore the buttons
        declineButton.button "reset"
        acceptButton.css "visibility", "visible"

        # show an error flash
        FlashMessages.sendError __ "common.flash.error"
      else
        # show a success flash
        FlashMessages.sendSuccess __ "contacts.flash.declineSuccess", self

  "confirmed.ubersafe.confirm #table-contacts .button-forget": (evt) ->
    self = this

    # get the button
    forgetButton = $(evt.target)

    # set button to loading
    forgetButton.button "loading"

    Meteor.call "removeContact", @_id, (error) ->
      if error
        console.error error

        # restore the buttons
        forgetButton.button "reset"

        # show an error flash
        FlashMessages.sendError __ "common.flash.error"
      else
        # show a success flash
        FlashMessages.sendSuccess __ "contacts.flash.forgetSuccess", self

  "confirmed.ubersafe.confirm #table-contacts .button-remove": (evt) ->
    self = this

    # get the button
    removeButton = $(evt.target)

    # set button to loading
    removeButton.button "loading"

    Meteor.call "removeContact", @_id, (error) ->
      if error
        console.error error

        # restore the buttons
        removeButton.button "reset"

        # show an error flash
        FlashMessages.sendError __ "common.flash.error"
      else
        # show a success flash
        FlashMessages.sendSuccess __ "contacts.flash.removeSuccess", self

  "click #table-contacts .button-withdraw": (evt) ->
    self = this

    # get the button
    withdrawButton = $(evt.target)

    # set button to loading
    withdrawButton.button "loading"

    Meteor.call "removeContact", @_id, (error) ->
      if error
        console.error error

        # restore the buttons
        withdrawButton.button "reset"

        # show an error flash
        FlashMessages.sendError __ "common.flash.error"
      else
        # show a success flash
        FlashMessages.sendSuccess __ "contacts.flash.withdrawSuccess", self

  "keyup #form-add-contact input": (evt) ->
    if evt.which is 13
      $("#button-add-contact").click()

  "click #button-add-contact": ->
    self = this

    # validate the form
    $("#form-add-contact").parsley("validate").done (valid) ->
      unless valid then return

      # add a contact request
      userId = $("#input-add-user-id").val()

      # pause deps
      #Deps.pause()

      Meteor.call "addContactRequest", userId, (error, result) ->
        if error
          FlashMessages.sendError __ "common.flash.error"
          Deps.resume()
        else if result isnt true
          FlashMessages.sendInfo __ "contacts.create.flash.#{result}",
            pendingContactsPath: Router.routes["contacts"].path
              type: "pending"
            contactsPath: Router.routes["contacts"].path()

          Deps.resume()
        else
          FlashMessages.sendSuccess __ "contacts.create.flash.success"

          $("#modal-add-contact").one "hidden.bs.modal", ->
            Deps.resume()

            # if we are not on requests, redirect there
            if "requests" isnt self.type
              Router.go "contacts",
                type: "requests"

          # close the modal
          $("#modal-add-contact").modal "hide"



