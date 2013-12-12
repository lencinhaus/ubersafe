if typeof String::startsWith isnt 'function'
  String::startsWith = (str) ->
    @slice(0, str.length) == str

if typeof String::endsWith isnt 'function'
  String::endsWith = (str) ->
    @slice(-str.length) == str

@getBaseParsleyOptions = ->
  options =
    successClass: "has-success"
    errorClass: "has-error"
    messages:
      type: {}
    errors:
      classHandler: (el) ->
        $(el).closest ".form-group"
      container: (el) ->
        # if the field is inside an input group, use the input group's parent
        $parent = $(el).parent()
        if $parent.hasClass "input-group"
          return $parent.parent()

        return $parent
      errorsWrapper: "<div class=\"help-block\"></div>"
      errorElem: "<div></div>"

  for own key of Meteor.i18nMessages.common.validation
    if key is "type" then continue
    options.messages[key] = __ "common.validation.#{key}"
  for own key of Meteor.i18nMessages.common.validation.type
    options.messages.type[key] = __ "common.validation.type.#{key}"

  options