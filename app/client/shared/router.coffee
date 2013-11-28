# router configuration
Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"

# common hooks
checkAuthenticatedHook = ->
  # if the user is not logged in redirect to login (if he already logged in in the past) or signup (otherwise)
  if not Meteor.loggingIn() and not Meteor.user()
    if UberSafe.getLastUsername()
      @redirect "login"
    else
      @redirect "signup"

    return

checkGuestHook = ->
  # if the user is already logged in, got to the dashboard
  if not Meteor.loggingIn() and Meteor.user()
    @redirect "dashboard"

# routes
Router.map ->
  @route "dashboard",
    path: "/"
    before: checkAuthenticatedHook

  @route "login",
    before: checkGuestHook

  @route "signup",
    before: checkGuestHook