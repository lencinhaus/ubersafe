# create a regex pattern by quoting a string, see http://stackoverflow.com/a/6969486/282034
@quoteRegexPattern = (str) ->
  str.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"