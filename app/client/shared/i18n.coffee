Meteor.supportedLocales = ["en", "it"]

Meteor.startup ->
  # set the locale from user language if it's not set already
  if not Meteor.getLocale() and navigator.language
    [language] = navigator.language.split "_"
    Meteor.setLocale navigator.language if navigator.language in Meteor.supportedLocales or language in Meteor.supportedLocales

_.extend Meteor.i18nMessages,
  locales:
    locale_it: "Italiano"
    locale_en: "English"
  common:
    labels:
      email: "Email"
      password: "Password"
    validation:
      required:
        en: "This value is required"
        it: "Questo campo è obbligatorio"
      notblank:
        en: "This field cannot be left blank"
        it: "Questo campo non può essere lasciato vuoto"
      unique:
        en: "This value must be unique"
        it: "Questo valore deve essere univoco"
      type:
        email:
          en: "This value should be a valid email"
          it: "Questo valore deve essere un indirizzo email valido"
  client:
    nav:
      logout: "Logout"
  signup:
    title:
      en: "Registration"
      it: "Registrazione"
    validation:
      unique:
        en: "Another user exists with these credentials"
        it: "Esiste già un altro utente con queste credenziali"
    form:
      email:
        placeholder:
          en: "Your email here"
          it: "La tua mail"
      password:
        placeholder:
          en: "Your password here"
          it: "La tua password"
      passwordConfirm:
        label:
          en: "Confirm Password"
          it: "Conferma Password"
        placeholder:
          en: "Your password, again"
          it: "Di nuovo la tua password"
      username:
        label:
          en: "Username"
          it: "Nome Utente"
        placeholder:
          en: "How other users will refer to you"
          it: "Come sarai conosciuto agli altri utenti"
      submit:
        en: "Sign Up"
        it: "Registrami"
      login:
        en: "Sign In"
        it: "Login"
    flash:
      success:
        en: "Welcome to {{appName}}, {{username}}!"
        it: "Benvenuto in {{appName}}, {{username}}!"