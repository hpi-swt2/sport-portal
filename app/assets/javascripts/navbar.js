$(document).ready(function(){
    if($('.mobile-avatar')){
        $('.mobile-avatar').on('click', function() {
            $('#default-mobile-menu').addClass('hidden');
            $('#user-mobile-menu').removeClass('hidden');
            $('#user-mobile-back').removeClass('hidden');
        });
    }
    if($('#user-mobile-back')){
        $('#user-mobile-back').on('click', function(){
            $('#default-mobile-menu').removeClass('hidden');
            $('#user-mobile-menu').addClass('hidden');
            $('#user-mobile-back').addClass('hidden');
        })
    }

    changeNavbarTransparency();
})

changeNavbarTransparency = function() {
    if($('body').hasClass('background')){
        $('.navbar-fixed-top').addClass('transparent');
    } else {
        $('.navbar-fixed-top').removeClass('transparent');
    }
}


