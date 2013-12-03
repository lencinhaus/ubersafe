progress = sjcl.random.getProgress()
progressDependency = new Deps.Dependency

entropyProgress = (updatedProgress) ->
  progress = updatedProgress
  progressDependency.changed()

entropySeeded = ->
  # send a success note
  FlashMessages.sendSuccess __ "entropy.flash.success"

  # restore previous route or dashboard
  Router.current().restore()

class @EntropyController extends RouteController
  load: ->
    # attach entropy listeners
    sjcl.random.addEventListener "progress", entropyProgress
    sjcl.random.addEventListener "seeded", entropySeeded

  before: ->
    # if random is already seeded, immediately redirect
    if sjcl.random.isReady()
      @restore()

  data: ->
    progressDependency.depend()
    progressPercentage = (progress * 100).toPrecision 2

    progress: progressPercentage
    progressStyle: "width: #{progressPercentage}%;"

  unload: ->
    # detach entropy listeners
    sjcl.random.removeEventListener "progress", entropyProgress
    sjcl.random.removeEventListener "seeded", entropySeeded
