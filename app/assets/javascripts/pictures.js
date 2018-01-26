$( document ).on('turbolinks:load', function() {
    $('#user_avatar, #team_avatar').on('change', function (evt) {
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
