// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function App() {}

App.prototype.setState = function(state) {
  localStorage.setItem('checked', state);
}

App.prototype.getState = function() {
  return localStorage.getItem('checked');
}

function init() {
  var app = new App();
  var state = app.getState();
  var checkbox = document.querySelector('#shown_events');

  if (state == 'true') {
    checkbox.checked = true;
  }

  checkbox.addEventListener('click', function() {
    app.setState(checkbox.checked);
    $("form").submit();
  });
}


$( document ).on('turbolinks:load', function() {
      init();
  });