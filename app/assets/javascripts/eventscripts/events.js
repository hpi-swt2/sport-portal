// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$( document ).on('turbolinks:load', function() {
  var location = window.location.pathname;
  var param = window.location.search.slice(1);
  var checkbox = document.querySelector('#shown_events');
  var state = localStorage.getItem('checked');

  checkbox.addEventListener('click', function() {
    localStorage.setItem('checked',checkbox.checked);
    $("form").submit();
  });

  if(state == 'true')
  {
    checkbox.checked = true;

    if(location == "/events" && param != "showAll=on")
    {
      checkbox.checked = false;
      localStorage.setItem('checked',checkbox.checked);
    }
  }
});