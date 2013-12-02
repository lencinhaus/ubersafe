Package.describe({
    summary: "UberSafe core stuff"
});

Package.on_use(function (api, where) {
    api.use(['underscore', 'coffeescript', 'moment']);
    api.add_files('underscore.mixin.deepExtend.coffee', ['client', 'server']);
    api.add_files('settings.default.coffee', ['client', 'server']);

    // load moment locales
    api.add_files('../moment/lib/moment/lang/it.js', 'client');
});
