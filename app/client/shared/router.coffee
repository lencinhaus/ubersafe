# extend routecontroller with:
# - replace/restore
# - NProgress integration

baseRedirect = RouteController.prototype.redirect
baseSubscribe = RouteController.prototype.subscribe

_.extend RouteController.prototype,
  redirect: ->
    # stop NProgress before redirecting
    NProgress.done()

    baseRedirect.apply this, arguments

  subscribe: ->
    result = baseSubscribe.apply this, arguments

    # always wait on the subscription
    result.wait()

    # start/stop NProgress after subscribing, based on subscription status
    if @ready()
      NProgress.done()
    else
      NProgress.start()

    # return the subscription handle
    result

  # replace the current route with the specified route,
  # remembering the current route so that we can restore it later
  # and without adding an item to the history
  replace: (route, params, options) ->
    # collect data about the current route
    replacedRoute =
      route: @route.name
      params: {}

    # cannot directly clone params, have to copy properties manually
    for key in Object.keys @params
      replacedRoute.params[key] = @params[key]

    # remember the current route
    Session.set "replacedRoute", replacedRoute

    # redirect to the new route
    unless options then options = {}
    options.replaceState = true

    @redirect route, params, options

  # restore a previously replaced route, or redirect to dashboard if not available
  # without adding an item to the history
  restore: (options) ->
    # dashboard is the default route if no replaced route is available
    redirect =
      route: "dashboard"
      params: null

    # get the last replaced route if available
    replacedRoute = Session.get "replacedRoute"
    if replacedRoute
      if @route.name isnt replacedRoute.route
        redirect = replacedRoute
      Session.set "replacedRoute", null

    # redirect to the previous route
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
  # no loading for now
  #loadingTemplate: "loading"

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
    path: "contacts/:type?"
    before: checkAuthenticatedHook
    controller: "ContactsController"

  @route "login",
    before: checkGuestHook

  @route "signup",
    before: checkGuestHook

  @route "entropy",
    controller: "EntropyController"