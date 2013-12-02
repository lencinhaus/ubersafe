# router configuration
Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"

# common hooks
checkAuthenticatedHook = ->
  # if the user is not logged in redirect to login (if he already logged in in the past) or signup (otherwise)
  if not Meteor.loggingIn() and not Meteor.user()
    # mark the current route so we can redirect to it once logged in
    loginRedirect =
      route: @route.name
      params: {}

    for key in Object.keys @params
      loginRedirect.params[key] = @params[key]

    Session.set "loginRedirect", loginRedirect

    redirectRoute = if UberSafe.getLastUsername() then "login" else "signup"
    @redirect redirectRoute, null,
        replaceState: true

    return

checkGuestHook = ->
  # if the user is already logged in, got to the dashboard
  if not Meteor.loggingIn() and Meteor.user()
    redirect =
      route: "dashboard"
      params: null
    loginRedirect = Session.get "loginRedirect"
    if loginRedirect
      redirect = loginRedirect
      Session.set "loginRedirect", null
    @redirect redirect.route, redirect.params,
      replaceState: true

    return

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

  @route "login",
    before: checkGuestHook

  @route "signup",
    before: checkGuestHook