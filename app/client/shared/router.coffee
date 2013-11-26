# an abstract controller class that redirects to home if the user is not authenticated
class @AuthenticatedController extends RouteController
  before: ->
    if not Meteor.loggingIn() and not Meteor.user()
      console.warn "unauthenticated access to route #{Router.current().route.name} is not allowed"
      @redirect "home"

    return

Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"

Router.map ->
  @route "home",
    path: "/"