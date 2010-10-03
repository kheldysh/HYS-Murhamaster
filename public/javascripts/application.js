// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function resize(which, max) {

  console.log("RESIZE CALLED");
  var elem = document.getElementById(which);
  if (elem == undefined || elem == null) return false;
  if (max == undefined) max = 100;
  if (elem.width > elem.height) {
    if (elem.width > max) elem.width = max;
  } else {
    if (elem.height > max) elem.height = max;
  }
}
