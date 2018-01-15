$(document).ready(function(){
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;
        
    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

if(getUrlParameter('filter') == "true"){
    $('.filterSelect').val($(".filterSelect option:eq(1)").val())
}
});