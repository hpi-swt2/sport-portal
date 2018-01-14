$( document ).on('turbolinks:load', function() {
    var password_block = $('.form-group:has(#user_current_password)');
    password_block.hide();
    $('#user_password').on('change', function () {
        password_block.show();
    });
    $('#user_email').on('change', function () {
        password_block.show();
    });
});

