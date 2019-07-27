// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

document.addEventListener('DOMContentLoaded', function(event) {
  var file = document.getElementById('input_file');
  var name = document.getElementById('file-name');

  file.onchange = function() {
    if (file.files.length > 0) {
      name.innerHTML = file.files[0].name;
      name.style.display = 'inherit';
    }
  };
});
