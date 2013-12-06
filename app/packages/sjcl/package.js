Package.describe({
    summary: "Stanford Javascript Crypto Library with public key cryptography support"
});

Package.on_use(function (api, where) {
    api.export('sjcl', 'client');
    api.add_files('sjcl.js', 'client', {
      bare: true
    });
});
