Package.describe({
    summary: "UberSafe core stuff"
});

Npm.depends({mongodb: "1.3.19"});

Package.on_use(function (api, where) {
  api.use(['underscore', 'coffeescript', 'moment', 'sjcl', 'jquery']);

  // load moment locales
  api.add_files('../moment/lib/moment/lang/it.js', 'client');

  api.add_files('underscore.mixin.deepExtend.coffee', ['client', 'server']);
  api.add_files('settings.default.coffee', ['client', 'server']);
  api.add_files('ubersafe.coffee', 'client');
  api.add_files('cryptobot.coffee', 'client');
  api.add_files('server.coffee', 'server');

  // exports
  api.export('UberSafe', 'client');
  api.export('CryptoBot', 'client');
});
