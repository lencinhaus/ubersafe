# extend routecontroller with replace/restore functionality
_.extend RouteController.prototype,
  replace: (route, params, options) ->
    replacedRoute =
      route: @route.name
      params: {}

    for key in Object.keys @params
      replacedRoute.params[key] = @params[key]

    Session.set "replacedRoute", replacedRoute

    unless options then options = {}
    options.replaceState = true

    @redirect route, params, options

  restore: (options) ->
    # default route if no replaced route is available
    redirect =
      route: "dashboard"
      params: null

    replacedRoute = Session.get "replacedRoute"
    if replacedRoute
      if @route.name isnt replacedRoute.route
        redirect = replacedRoute
      Session.set "replacedRoute", null

    unless options then options = {}
    options.replaceState = true

    @redirect redirect.route, redirect.params, options


# common hooks
checkEntropy = ->
  if "entropy" isnt @route.name and sjcl.random._NOT_READY is sjcl.random.isReady()
    @replace "entropy"

checkAuthenticatedHook = ->
  # if the user is not logged in redirect to login (if he already logged in in the past) or signup (otherwise)
  if not Meteor.loggingIn() and not Meteor.user()
    redirectRoute = if UberSafe.getLastUsername() then "login" else "signup"
    @replace redirectRoute

    return

checkGuestHook = ->
  # if the user is already logged in, got to the dashboard
  if not Meteor.loggingIn() and Meteor.user()
    @restore

    return

# router configuration
Router.configure
  # always check the entropy before anything else
  before: checkEntropy
  layoutTemplate: "layout"
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"

# routes
Router.map ->
  @route "dashboard",
    path: "/"
    before: checkAuthenticatedHook
    controller: "DashboardController"

  @route "create",
    before: checkAuthenticatedHook
    controller: "CreateController"

  @route "view",
    path: "view/:documentId"
    before: checkAuthenticatedHook
    controller: "ViewController"

  @route "contacts",
    before: checkAuthenticatedHook
    controller: "ContactsController"

  @route "login",
    before: checkGuestHook

  @route "signup",
    before: checkGuestHook

  @route "entropy",
    controller: "EntropyController"