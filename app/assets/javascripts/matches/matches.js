// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

document.addEventListener("turbolinks:load", function() {
  $('FORM').nestedFields({
    containerSelector: '.results',
    itemSelector: '.result',
  });
});

$(function() {
    $('.input-daterange').datepicker({
        format: 'dd.mm.yy'
    });
});