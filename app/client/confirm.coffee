deferred = null
confirmed = null

# API
Confirm =
  # show shows the modal with the provided message and returns a promise
  # the promise is resolved if the user confirms, or rejected otherwise
  show: (message) ->
    if deferred
      console.error "cannot show modal confirm because it is already shown"
      return null

    deferred = $.Deferred()

    $("#confirm-message").html message
    $("#modal-confirm").modal "show"

    deferred.promise()

# use native events so they can be caught using Template.xxx.events
fireConfirmEvent = (target, name) ->
  target.dispatchEvent new Event name,
    bubbles: false
    cancelable: false

# click handler that shows the modal and dispatches custom events after the user makes her choice
handleClick = (target, message) ->
  promise = Confirm.show message

  promise.done ->
    fireConfirmEvent target, "confirmed.ubersafe.confirm"

  promise.fail ->
    fireConfirmEvent target, "canceled.ubersafe.confirm"

# jQuery API, useful to bind a bunch of elements with the same message (table actions etc.)
$.fn.confirm = (message) ->
  @on "click", (evt) ->
    handleClick evt.target, message

# auto-bind elements with the data-confirm attribute, which contains the message
$(document).on "click", "[data-confirm]", (evt) ->
  handleClick evt.target, $(evt.target).attr "data-confirm"

# only fire events once the modal is hidden
# the deferred and result are reset after that
Template.confirm.rendered = ->
  if @rendered then return
  @rendered = true

  $("#modal-confirm").on "hidden.bs.modal", ->
    if null isnt confirmed and null isnt deferred
      if confirmed
        deferred.resolve()
      else
        deferred.reject()

      confirmed = null
      deferred = null

Template.confirm.events
  "click #button-confirm-ok": ->
    confirmed = true
    $("#modal-confirm").modal "hide"

  "click #button-confirm-cancel": ->
    confirmed = false
    $("#modal-confirm").modal "hide"
