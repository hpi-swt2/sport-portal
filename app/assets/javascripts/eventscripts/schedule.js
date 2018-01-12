
$(function() {
    var $container = $("#gameday-slider");

    var $arrowLeft = $container.find(".arrow-left");
    var $arrowRight = $container.find(".arrow-right");

    var $items = $(".gameday-slider-item");
    var $selected = $items.filter(".selected");

    var disableArrowsIfRequired = function() {
        var index = $items.index($selected);

        if(index === 0)
            $arrowLeft.prop("disabled", true);
        else if($arrowLeft.prop("disabled", true)) {
            $arrowLeft.prop("disabled", false);
        }

        if(index === $items.length - 1)
            $arrowRight.prop("disabled", true);
        else if($arrowRight.prop("disabled", true)) {
            $arrowRight.prop("disabled", false);
        }
    };

    $arrowLeft.click(function() {
        if($items.index($selected) === 0)
            return false;

        $selected = $selected
            .removeClass("selected")
            .prev()
            .addClass("selected");

        disableArrowsIfRequired();
    });

    $arrowRight.click(function() {
        if($items.index($selected) === $items.length - 1)
            return false;

        $selected = $selected
            .removeClass("selected")
            .next()
            .addClass("selected");

        disableArrowsIfRequired();
    });

    disableArrowsIfRequired();
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