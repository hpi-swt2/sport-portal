$( document ).on('turbolinks:load', function() {
    var password_block = $('.form-group:has(#user_current_password:not([data-show=\'true\']))');
    password_block.hide();
    $('#user_password').on('input', function () {
        password_block.show();
    });
    $('#user_email').on('input', function () {
        password_block.show();
    });
    $('#user_avatar').on('change', function (evt) {
        if (evt.target.files && evt.target.files.length === 1) {
            var file = evt.target.files[0];
            var fileReader = new FileReader();
            fileReader.onload = function () {
                $('#preview').attr('src', fileReader.result);
            };
            fileReader.readAsDataURL(file);
        }
    });
});

