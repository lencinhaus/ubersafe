# constants
DASHBOARD_DOCUMENTS_LIMIT = 20

class @DashboardController extends RouteController
  before: ->
    unless Session.get "dashboardDocumentsPage"
      Session.set "dashboardDocumentsPage", 1

    unless Session.get "dashboardDocumentsSort"
      Session.set "dashboardDocumentsSort",
        title: 1

    @subscribe("dashboardDocuments",
      page: Session.get "dashboardDocumentsPage"
      limit: DASHBOARD_DOCUMENTS_LIMIT
      sort: Session.get "dashboardDocumentsSort"
    ).wait()

  data: ->
    if @ready()
      documents: Documents.find({},
        sort: Session.get "dashboardDocumentsSort"
      ).fetch()
    else
      @stop()
      return

Template.dashboard.haveDocuments = ->
  @documents and @documents.length > 0

Template.dashboard.documentsColumns = ["title", "createdAt", "modifiedAt"]

Template.dashboard.documentsColumnName = (column) ->
  __ "dashboard.documents.columns.#{column}"

Template.dashboard.documentsColumnSortClasses = ->
  sort = Session.get "dashboardDocumentsSort"
  if sort and sort[this]
    direction = if -1 is sort[this] then "desc" else "asc"
    oppositeDirection = if -1 is sort[this] then "asc" else "desc"
    "current-sort-#{direction} sort-#{oppositeDirection}"
  else
    "sort-asc"

Template.dashboard.events
  "click #table-documents .sort": (evt) ->
    evt.preventDefault()
    $this = $ evt.target
    field = $this.attr "data-field"
    direction = if $this.hasClass "sort-desc" then -1 else 1
    sort = {}
    sort[field] = direction
    Session.set "dashboardDocumentsSort", sort

  "click #table-documents tbody tr": (evt) ->
    $tr = $(evt.target).closest "tr"
    documentId = $tr.attr "data-document-id"
    Router.go "view",
      documentId: documentId