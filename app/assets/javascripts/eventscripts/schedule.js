
$(function() {
    var $container = $("#gameday-slider");

    var $arrowLeft = $container.find(".arrow-left");
    var $arrowRight = $container.find(".arrow-right");

    var $items = $(".gameday-slider-item");
    var $selected = $items.filter(".selected");

    $arrowLeft.click(function() {
        var index = $items.index($selected);

        if(index === 0)
            return false;

        $arrowRight.prop("disabled", false);

        $selected = $selected
            .removeClass("selected")
            .prev()
            .addClass("selected");

        if(index - 1 === 0)
            $(this).prop("disabled", true);
    });

    $arrowRight.click(function() {
        var index = $items.index($selected);

        if(index === $items.length - 1)
            return false;

        $arrowLeft.prop("disabled", false);

        $selected = $selected
            .removeClass("selected")
            .next()
            .addClass("selected");

        if(index === $items.length - 2)
            $(this).prop("disabled", true);
    });
});

$(function() {
    var $switchToAll = $(".to-schedule-all-view");
    var $switchToSingle = $(".to-schedule-single-view");

    var $allContainer = $(".schedule-all-view");
    var $singleContainer = $(".schedule-single-view");

    $switchToAll.click(function() {
        $allContainer.show();
        $singleContainer.hide();
        $switchToSingle.show();
        $(this).hide();
    });

    $switchToSingle.click(function() {
        $allContainer.hide();
        $singleContainer.show();
        $switchToAll.show();
        $(this).hide();
    });
});