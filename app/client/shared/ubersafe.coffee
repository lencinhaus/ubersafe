# constants
COOKIE_LAST_USERNAME = 'ubersafe-last-username'

@UberSafe =
  getLastUsername: ->
    Cookie.get COOKIE_LAST_USERNAME

  setLastUsername: (username) ->
    if username
      Cookie.set COOKIE_LAST_USERNAME, username,
        path: '/'
    else
      Cookie.remove COOKIE_LAST_USERNAME

  dummy: ->
    console.log "dummy"