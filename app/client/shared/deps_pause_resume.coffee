paused = false
shouldFlush = false
realFlush = Deps.flush

_.extend Deps,
  flush: ->
    if paused
      shouldFlush = true
    else
    realFlush()

  pause: ->
    if paused then return
    paused = true
    shouldFlush = false
    return

  resume: ->
    if not paused then return
    paused = false
    if shouldFlush then @flush()
    return