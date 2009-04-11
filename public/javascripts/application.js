////////////////////////////////
// An embedded search input box
///////////////////////////////

// We define the function first
function SearchControl() {
}

// To "subclass" the GControl, we set the prototype object to
// an instance of the GControl object
SearchControl.prototype = new GControl();

// Creates form
SearchControl.prototype.initialize = function(map) {
  var container = document.createElement("div");

  // main form
  var searchForm = document.createElement("form");
  searchForm.method = "get";
  searchForm.action = "/search";
  container.appendChild(searchForm);

  // input box
  var inputQuery = document.createElement("input");
  inputQuery.type = "text";
  inputQuery.id = 'query';
  inputQuery.name= 'query';
//  inputQuery.value = 'By name, location, length, year, ...';
  inputQuery.size= '40';
//  GEvent.addDomListener(inputQuery, "focus", function(evt) { this.value = ''; });
  searchForm.appendChild(inputQuery);

  // submit button
  var inputSubmit = document.createElement("input");
  inputSubmit.type = 'submit';
  inputSubmit.name = 'commit';
  inputSubmit.value = 'Search';
  searchForm.appendChild(inputSubmit);

  map.getContainer().appendChild(container);
  return container;
}

// By default, the control will appear in the top left corner of the
// map with 7 pixels of padding.
SearchControl.prototype.getDefaultPosition = function() {
  return new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(7, 7));
}




//////////////////////////////////////////////////////////////////
// A TextualZoomControl is a GControl that displays textual "Zoom In"
// and "Zoom Out" buttons (as opposed to the iconic buttons used in
// Google Maps).
////////////////////////////////////////////////////////

// We define the function first
function TextualZoomControl() {
}

// To "subclass" the GControl, we set the prototype object to
// an instance of the GControl object
TextualZoomControl.prototype = new GControl();

// Creates a one DIV for each of the buttons and places them in a container
// DIV which is returned as our control element. We add the control to
// to the map container and return the element for the map class to
// position properly.
TextualZoomControl.prototype.initialize = function(map) {
  var container = document.createElement("div");

  var zoomInDiv = document.createElement("div");
  this.setButtonStyle_(zoomInDiv);
  container.appendChild(zoomInDiv);
  zoomInDiv.appendChild(document.createTextNode("Zoom In"));
  GEvent.addDomListener(zoomInDiv, "click", function() {
    map.zoomIn();
  });

  var zoomOutDiv = document.createElement("div");
  this.setButtonStyle_(zoomOutDiv);
  container.appendChild(zoomOutDiv);
  zoomOutDiv.appendChild(document.createTextNode("Zoom Out"));
  GEvent.addDomListener(zoomOutDiv, "click", function() {
    map.zoomOut();
  });

  map.getContainer().appendChild(container);
  return container;
}

// By default, the control will appear in the top left corner of the
// map with 7 pixels of padding.
TextualZoomControl.prototype.getDefaultPosition = function() {
  return new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(7, 7));
}

// Sets the proper CSS for the given button element.
TextualZoomControl.prototype.setButtonStyle_ = function(button) {
  button.style.textDecoration = "underline";
  button.style.color = "#0000cc";
  button.style.backgroundColor = "white";
  button.style.font = "small Arial";
  button.style.border = "1px solid black";
  button.style.padding = "2px";
  button.style.marginBottom = "3px";
  button.style.textAlign = "center";
  button.style.width = "6em";
  button.style.cursor = "pointer";
}
