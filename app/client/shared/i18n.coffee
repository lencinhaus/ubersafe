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
      username:
        en: "Username"
        it: "Nome Utente"
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
    flash:
      logoutSuccess:
        en: "Farewell {{username}}, I'll keep your data safe while you're away."
        it: "A presto {{username}}, terrò al sicuro i tuoi dati mentre sei via."
      logoutError:
        en: "An error occurred, can't let you go right now. I'm overly attached, I know."
        it: "Si è verificato un errore, non riesco a lasciarti andare in questo momento. Sono troppo attaccato, lo so."
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
      error:
        en: "Ouch! An error occurred, but someone will surely fix it soon. No really, please have faith and try again later."
        it: "Ahia! C'è stato un errore, ma senz'altro qualcuno lo correggerà presto. No veramente, abbi fede e riprova più tardi."
  login:
    title: "Login"
    form:
      username:
        placeholder:
          en: "Your username"
          it: "Il tuo nome utente"
      password:
        placeholder:
          en: "Your password"
          it: "La tua password"
      submit:
        en: "Sign In"
        it: "Entra"
      signup:
        en: "Register"
        it: "Registrati"
    flash:
      success:
        en: "Welcome back to {{appName}}, {{username}}!"
        it: "Bentornato su {{appName}}, {{username}}!"
      error:
        en: "Hmm, these credentials seem to be fake, sorry."
        it: "Hmm, queste credenziali sembrano essere finte, mi spiace."