$(document).ready(function(){
    $('#check_all').on("click", function() {
        var cbxs = $('input[type="checkbox"]');
        cbxs.prop("checked", true);
    })
    $('#uncheck_all').on("click", function() {
        var cbxs = $('input[type="checkbox"]');
        cbxs.prop("checked", false);
    })
});
