Package.describe({
    summary: "UberSafe core stuff"
});

Package.on_use(function (api, where) {
    api.use(['underscore', 'coffeescript']);
    api.add_files('underscore.mixin.deepExtend.coffee', ['client', 'server']);
    api.add_files('settings.default.coffee', ['client', 'server']);
});
