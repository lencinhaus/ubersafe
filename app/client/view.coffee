class @ViewController extends RouteController
  before: ->
    @subscribe("viewDocument", @params.documentId).wait()

  data: ->
    if @ready()
      Documents.findOne @params.documentId
    else
      @stop()

contentReady = false
decryptionDependency = new Deps.Dependency()

Template.viewContent.created = ->
  # start content decryption
  self = this
  contentReady = false
  key = UberSafe.decryptDocumentKey @data.users[Meteor.userId()].key
  promise = CryptoBot.decryptString @data.content, key
  promise.done (decryptedContent) ->
    self.data.content = decryptedContent
    contentReady = true
    decryptionDependency.changed()

Template.viewContent.contentReady = ->
  decryptionDependency.depend()
  contentReady