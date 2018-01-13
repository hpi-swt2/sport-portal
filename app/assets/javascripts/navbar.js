$(document).ready(function(){
    if($('.mobile-avatar')){
        $('.mobile-avatar').on('click', function() {
            $('#default-mobile-menu').addClass('hidden');
            $('#user-mobile-menu').removeClass('hidden');
        });
    }
})