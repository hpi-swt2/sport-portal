$( document ).on('turbolinks:load', function() {
    var password_block = $('.form-group:has(#user_current_password:not([data-show=\'true\']))');
    password_block.hide();
    $('#user_password').on('input', function () {
        password_block.show();
    });
    $('#user_email').on('input', function () {
        password_block.show();
    });
});

