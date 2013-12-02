class @DashboardController extends RouteController
  before: ->
    page = Session.get("dashboardDocumentsPage") or 1
    @subscribe("dashboardDocuments",
      page: page
      limit: 20
    ).wait()

  data: ->
    if @ready
      documents: Documents.find()
    else
      @stop()