Package.describe({
    summary: "Selectize is the hybrid of a textbox and <select> box."
});

Package.on_use(function (api, where) {
  api.use(['jquery'], 'client');
  api.add_files('selectizejs/dist/js/standalone/selectize.js', 'client');
});
