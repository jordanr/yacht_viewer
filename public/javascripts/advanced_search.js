var count = 0;
function add_one() {
  var container = document.getElementById('where_clause');
  var term = document.getElementById('where_term');

  var new_term = term.cloneNode(true);
  new_term.style.display = "";

  var column = new_term.childNodes[1];
  var op = new_term.childNodes[3];
  var value = new_term.childNodes[5];

  column.name="sql[where]["+count+"][column]";
  op.name="sql[where]["+count+"][operation]";
  value.name="sql[where]["+count+"][value]";

  container.appendChild(new_term);
  count++;
}
  
function remove_one(el) {
  var container = document.getElementById('where_clause');
  container.removeChild(el);
}
  
