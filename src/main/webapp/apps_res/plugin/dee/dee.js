function showNextSpecialCondition(conditionObject) {
	var options = conditionObject.options;

	for (var i = 0; i < options.length; i++) {
	    var d = document.getElementById(options[i].value + "Div");
	    //alert(d);
	    if (d) {
	        d.style.display = "none";
	 	}
	}
	if(document.getElementById(conditionObject.value + "Div") == null) return;
		    document.getElementById(conditionObject.value + "Div").style.display = "block";
}
