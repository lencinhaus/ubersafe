Package.describe({
    summary: "UberSafe core stuff"
});

Package.on_use(function (api, where) {
  api.use(['underscore', 'coffeescript', 'moment', 'sjcl', 'jquery']);

  api.add_files('underscore.mixin.deepExtend.coffee', ['client', 'server']);
  api.add_files('settings.default.coffee', ['client', 'server']);
  api.add_files('ubersafe.coffee', 'client');
  api.add_files('cryptobot.coffee', 'client');

  // load moment locales
  api.add_files('../moment/lib/moment/lang/it.js', 'client');

  // exports
  api.export('UberSafe', 'client');
  api.export('CryptoBot', 'client');
});
