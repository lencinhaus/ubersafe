Package.describe({
    summary: "Parsley.js with support for asynchronous validation via promises"
});

Package.on_use(function (api, where) {
    api.use('jquery', 'client');
    api.add_files('parsleyjs/parsley.js', 'client');
});
