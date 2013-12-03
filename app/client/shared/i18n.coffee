Meteor.supportedLocales = ["en", "it"]

Meteor.startup ->
  # setup autoruns when locale changes
  Deps.autorun ->
    # set moment locale
    moment.lang Meteor.getLocale()

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
      title:
        en: "Title"
        it: "Titolo"
      content:
        en: "Content"
        it: "Contenuto"
    buttons:
      save:
        en: "Save"
        it: "Salva"
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
      create:
        en: "Create"
        it: "Crea"
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
      login: "Login"
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
  entropy:
    title:
      en: "Entropy"
      it: "Entropia"
    subtitle:
      en: "gimme some randomness"
      it: "dammi un po' di caso"
    heading:
      en: "Computers are so predictable."
      it: "I computer sono così prevedibili."
    text:
      en: "Please move around your mouse or device a little, so that we can collect some genuine human randomness."
      it: "Per favore, muovi un po' il mouse o il dispositivo di qua e di là, così che possa raccogliere un po' di sana casualità umana."
    complete:
      en: "Complete"
      it: "Completo"
    flash:
      success:
        en: "Thanks a lot, I feel so casual now!"
        it: "Grazie mille, ora mi sento molto più casual!"
  create:
    title:
      en: "New Document"
      it: "Nuovo Documento"
    form:
      title:
        placeholder:
          en: "Something super-secret"
          it: "Qualcosa di super-segreto"
      content:
        placeholder:
          en: "Secret stuff!"
          it: "Roba segreta!"
    flash:
      success:
        en: "\"{{title}}\" saved and encrypted!"
        it: "\"{{title}}\" è stato salvato e crittato!"
      error:
        en: "Ouch, can't save this document right now. Please try again later"
        it: "Ahai, non riesco a salvare questo documento ora. Per favore riprova più tardi"
  dashboard:
    title: "Dashboard"
    subtitle:
      en: "manage your documents"
      it: "gestisci i tuoi documenti"
    empty:
      text:
        en: "No documents so far :("
        it: "Non hai ancora nessun documento :("
      create:
        en: "Create one now!"
        it: "Creane uno ora!"
    searchForm:
      search:
        placeholder:
          en: "search"
          it: "cerca"
    documents:
      columns:
        title:
          en: "Title"
          it: "Titolo"
        createdAt:
          en: "Created"
          it: "Creato"
        modifiedAt:
          en: "Modified"
          it: "Modificato"
        actions:
          en: "Actions"
          it: "Azioni"