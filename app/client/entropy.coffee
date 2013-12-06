progress = sjcl.random.getProgress()
progressDependency = new Deps.Dependency

entropyProgress = (updatedProgress) ->
  progress = updatedProgress
  progressDependency.changed()

entropySeeded = ->
  # send a success note
  FlashMessages.sendSuccess __ "entropy.flash.success"

  detachListeners()

  # restore previous route or dashboard
  Router.current().restore()

attachListeners = ->
  # attach entropy listeners
  sjcl.random.addEventListener "progress", entropyProgress
  sjcl.random.addEventListener "seeded", entropySeeded

detachListeners = ->
  # detach entropy listeners
  sjcl.random.removeEventListener "progress", entropyProgress
  sjcl.random.removeEventListener "seeded", entropySeeded

class @EntropyController extends RouteController
  load: ->
    # if random is already seeded, immediately redirect
    if sjcl.random.isReady()
      Router.current().restore()
    else
      attachListeners()

  data: ->
    progressDependency.depend()
    progressPercentage = (progress * 100).toPrecision 2

    progress: progressPercentage
    progressStyle: "width: #{progressPercentage}%;"
