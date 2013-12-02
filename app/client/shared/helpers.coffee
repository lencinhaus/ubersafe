#i18n
Handlebars.registerHelper "__", (message, params) ->
  new Handlebars.SafeString(__(message, params))


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

# debug
Handlebars.registerHelper "dump", (obj) ->
  new Handlebars.SafeString("<pre>#{JSON.stringify(obj)}</pre>")