# i18n
Handlebars.registerHelper "__", (message, params, escape) ->
  __(message, params)


# locales
Handlebars.registerHelper "locale", ->
  language = "en"
  if Meteor.getLocale() then [language] = Meteor.getLocale().split "_"
  language

Handlebars.registerHelper "supportedLocales", ->
  locales = []
  _.each Meteor.supportedLocales, (code) ->
    locales.push
      code: code
      name: __ "locales.locale_#{code}"

  _.sortBy locales, (obj) ->
    obj.name

  locales

Handlebars.registerHelper "isCurrentLocale", (locale) ->
  Meteor.getLocale() and Meteor.getLocale().startsWith locale

Handlebars.registerHelper "localeName", (locale) ->
  __ "locales.locale_#{locale}"

# dates with momentjs
Handlebars.registerHelper "formatDate", (date) ->
  moment(date).format "lll"

Handlebars.registerHelper "formatDateFromNow", (date) ->
  moment(date).fromNow()

# settings
Handlebars.registerHelper "settings", (path) ->
  # retrieve a setting by specifying its property path inside Meteor.settings.public
  parent = Meteor.settings.public
  props = path.split "."
  for i in [0...(props.length - 1)]
    prop = props[i]
    unless parent[prop] then return null
    parent = parent[prop]

  parent[props[props.length - 1]]

# debug
Handlebars.registerHelper "dump", (obj) ->
  new Handlebars.SafeString("<pre>#{JSON.stringify(obj)}</pre>")