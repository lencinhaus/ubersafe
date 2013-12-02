class @ViewController extends RouteController
  before: ->
    @subscribe("viewDocument", @params.documentId).wait()

  data: ->
    if @ready()
      Documents.findOne @params.documentId
    else
      @stop()