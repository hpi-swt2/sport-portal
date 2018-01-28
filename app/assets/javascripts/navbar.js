$(document).on('turbolinks:load', function(){
   setupPage();
})

setupPage = function() {
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

    if($('.navbar-toggle')){
        $('.navbar-toggle').on('click', function() {
            if($('.navbar-toggle').hasClass('expanded')){
                $('.navbar-toggle').removeClass('expanded');
            }else {
                $('.navbar-toggle').addClass('expanded');
            }
        })
    }

    $('.navbar').removeClass("navbar-fixed-top");
    changeNavbarTransparency();
}

changeNavbarTransparency = function() {
     if($('body > div').hasClass('background')){
         $('.navbar').addClass('transparent');
         $('.navbar').removeClass('not-transparent');
     } else if (window.location.pathname == '/'){
         $('.navbar').addClass('transparent');
         $('.navbar').removeClass('not-transparent');
     } else {
         $('.navbar').removeClass('transparent');
         $('.navbar').addClass('not-transparent');
     }
}


