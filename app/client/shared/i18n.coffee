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
      close:
        en: "Close"
        it: "Chiudi"
      add:
        en: "Add"
        it: "Aggiungi"
      ok: "Ok"
      cancel:
        en: "Cancel"
        it: "Annulla"
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
    flash:
      error:
        en: "Ouch! An error occurred, but someone will surely fix it soon. No really, please have faith and try again later."
        it: "Ahia! C'è stato un errore, ma senz'altro qualcuno lo correggerà presto. No veramente, abbi fede e riprova più tardi."
    columns:
      actions:
        en: "Actions"
        it: "Azioni"
  layout:
    nav:
      logout: "Logout"
      showPublicKey:
        en: "View your Public Key"
        it: "Visualizza la tua Chiave Pubblica"
      create:
        en: "Create"
        it: "Crea"
      contacts:
        en: "Contacts"
        it: "Contatti"
      notifications:
        en: "Messages"
        it: "Messaggi"
    flash:
      logoutSuccess:
        en: "Farewell {{username}}, I'll keep your data safe while you're away."
        it: "A presto {{username}}, terrò al sicuro i tuoi dati mentre sei via."
      logoutError:
        en: "An error occurred, can't let you go right now. I'm overly attached, I know."
        it: "Si è verificato un errore, non riesco a lasciarti andare in questo momento. Sono troppo attaccato, lo so."
    publicKey:
      title:
        en: "Your Public Key"
        it: "La tua Chiave Pubblica"
  notifications:
    contactRequest:
      en: "<strong>{{fromUsername}}</strong> wants to add you to his contacts"
      it: "<strong>{{fromUsername}}</strong> vuole aggiungerti ai suoi contatti"
    contactRequestAnswer:
      accepted:
        en: "<strong>{{fromUsername}}</strong> has accepted your contact request!"
        it: "<strong>{{fromUsername}}</strong> ha accettato la tua richiesta di contatto!"
      declined:
        en: "<strong>{{fromUsername}}</strong> has declined your contact request :("
        it: "<strong>{{fromUsername}}</strong> ha declinato la tua richiesta di contatto :("
    contactRemoved:
      en: "<strong>{{fromUsername}}</strong> has removed you from her contacts"
      it: "<strong>{{fromUsername}}</strong> ti ha rimosso dai suoi contatti"
    contactRequestWithdrawn:
      en: "<strong>{{fromUsername}}</strong> has withdrawn her contact request"
      it: "<strong>{{fromUsername}}</strong> ha annullato la sua richiesta di contatto"
    contactRequestForgotten:
      en: "Now you can send a contact request to <strong>{{fromUsername}}</strong> again"
      it: "Ora puoi inviare nuovamente una richiesta di contatto a <strong>{{fromUsername}}</strong>"
  confirm:
    title:
      en: "Attention Please!"
      it: "Attenzione Attenzione!"
  signup:
    title:
      en: "Registration"
      it: "Registrazione"
    form:
      validation:
        unique:
          en: "Another user exists with these credentials"
          it: "Esiste già un altro utente con queste credenziali"
      email:
        placeholder:
          en: "Your email here"
          it: "La tua mail"
      password:
        placeholder:
          en: "Your password here"
          it: "La tua password"
        popover:
          title:
            en: "Password strength"
            it: "Sicurezza della password"
          content:
            en: "It is very important that your password will be strong, and that you'll remember it because noone, including us, can restore it"
            it: "E' molto importante che la tua password sia forte, e che te la ricordi perchè nessuno, noi compresi, può recuperarla"
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
        it: "Ahia, non riesco a salvare questo documento ora. Per favore riprova più tardi"
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
    search:
      placeholder:
        en: "search a document"
        it: "cerca un documento"
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
  contacts:
    title:
      en: "Contacts"
      it: "Contatti"
    subtitle:
      en: "your little circle of trust"
      it: "il tuo piccolo cerchio della fiducia"
    search:
      placeholder:
        en: "search by username"
        it: "cerca per nome utente"
    empty:
      text:
        en: "No contacts so far :("
        it: "Non hai ancora nessun contatto :("
      add:
        en: "Don't be a sociopath and add someone now!"
        it: "Non essere un sociopatico e aggiungi qualcuno ora!"
      search:
        en: "No contact matches your search"
        it: "Nessun contatto corrisponde alla tua ricerca"
    nav:
      accepted:
        en: "Your contacts"
        it: "I tuoi contatti"
      requests:
        en: "Your requests"
        it: "Le tue richieste"
      pending:
        en: "Requests from others"
        it: "Richieste da altri"
    columns:
      user:
        en: "User"
        it: "Utente"
      requested:
        en: "Requested"
        it: "Richiesto"
      accepted:
        en: "Accepted"
        it: "Accettato"
      answer:
        en: "Answer"
        it: "Risposta"
      fromUser:
        en: "From user"
        it: "Dall'utente"
    rows:
      byYou:
        en: "by you"
        it: "da te"
      byOther:
        en: "by her"
        it: "da lui"
      noAnswer:
        en: "none"
        it: "nessuna"
    status:
      requested:
        en: "requested"
        it: "richiesto"
      accepted:
        en: "accepted"
        it: "accettato"
      declined:
        en: "declined"
        it: "declinato"
    buttons:
      remove:
        text:
          en: "Remove"
          it: "Rimuovi"
        loading:
          en: "Removing"
          it: "Sto rimuovendo"
        confirm:
          en: "<p>Removing this contact will have the following consequences:</p><ul><li>You and this user will not be able to share documents with each other anymore.</li><li>You will not be able to view or edit any document owned by this user, even if she already shared it with you.</li><li>This user will not be able to view or edit any document you own, even if you already shared it with her.</li></ul><p>Proceed?</p>"
          it: "<p>Rimuovere questo contatto avrà i seguenti effetti:</p><ul><li>Tu e questo utente non sarete più in grado di condividere documenti l'uno con l'altro.</li><li>Non sarai più in grado di visualizzare o modificare alcun documento di proprietà di questo utente, anche se l'ha già condiviso con te.</li><li>Questo utente non sarà più in grado di visualizzare o modificare alcun documento di tua proprietà, anche se l'hai già condiviso con lui.</li></ul><p>Procedo?</p>"
      accept:
        text:
          en: "Accept"
          it: "Accetta"
        loading:
          en: "Accepting"
          it: "Sto accettando"
      decline:
        text:
          en: "Decline"
          it: "Declina"
        loading:
          en: "Declining"
          it: "Sto declinando"
      withdraw:
        text:
          en: "Withdraw"
          it: "Annulla"
        loading:
          en: "Withdrawing"
          it: "Sto annullando"
      forget:
        text:
          en: "Forget"
          it: "Dimentica"
        loading:
          en: "Forgetting"
          it: "Sto dimenticando"
        confirm:
          en: "<p>This user will be able to send you a contact request again.</p><p>Proceed?</p>"
          it: "<p>Questo utente potrà inviarti nuovamente una richiesta di contatto.</p><p>Procedo?</p>"
    flash:
      acceptSuccess:
        en: "Now <strong>{{username}}</strong> is one of your contacts"
        it: "Ora <strong>{{username}}</strong> è un tuo contatto"
      declineSuccess:
        en: "<strong>{{username}}</strong>'s contact request has been declined. She won't disturb you again until you <em>Forget</em> this decision"
        it: "La richiesta di contatto di <strong>{{username}}</strong> è stata declinata. Non ti disturberà più finche non deciderai di <em>Dimentica</em>re questa decisione"
      forgetSuccess:
        en: "Now <strong>{{username}}</strong> can send you a contact request again"
        it: "Ora <strong>{{username}}</strong> può nuovamente inviarti una richiesta di contatto"
      removeSuccess:
        en: "You and <strong>{{username}}</strong> are no longer contacts of each other"
        it: "Tu e <strong>{{username}}</strong> non siete più tra i contatti l'uno dell'altro"
      withdrawSuccess:
        en: "Your contact request has been withdrawn"
        it: "La tua richiesta di contatto è stata annullata"
    create:
      title:
        en: "Add a contact"
        it: "Aggiungi un contatto"
      form:
        validation:
          username:
            en: "You must choose a valid username"
            it: "Devi scegliere un nome utente valido"
        username:
          placeholder:
            en: "Start typing an username and I'll suggest"
            it: "Comincia a scrivere un nome utente e ti suggerirò"
        add:
          en: "Add"
          it: "Aggiungi"
      flash:
        success:
          en: "Your contact request has been sent! I'll notify you when the user accepts or declines your request."
          it: "La tua richiesta di contatto è stata inviata! Ti avviserò quando l'utente avrà accettato o declinato la tua richiesta."
        accepted:
          en: "You already have this user in your contacts!"
          it: "Hai già questo utente tra i tuoi contatti!"
        requested:
          en: "You've already sent a contact request to this user. I'll notify you when she accepts or declines your request."
          it: "Hai già inviato una richiesta di contatto a questo utente. Ti avviserò quando avrà accettato o declinato la richiesta."
        declined:
          en: "You've already sent a contact request to this user, and she has declined. Too bad."
          it: "Hai già inviato una richiesta di contatto a questo utente, e lui ha declinato. Peccato."
        pending:
          en: "This user has already requested to add you to his contacts. You can approve her request in the <a href=\"{{pendingContactsPath}}\">pending requests list</a>."
          it: "Questo utente ha già richiesto di aggiungerti ai suoi contatti. Puoi accettare la sua richiesta nella lista delle richieste in attesa."