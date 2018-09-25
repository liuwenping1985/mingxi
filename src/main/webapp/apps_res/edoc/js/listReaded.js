$(document).ready(function () {
	$("#deduplication").val(isGourpBy);
	$("#isGourpBy").click(function(){
	    var isDedupCheck =  $("#isGourpBy:checked").size();
	    if (isDedupCheck != 0) {
	      	$("#deduplication").val("true");
	    } else {
	    	$("#deduplication").val("false");
		}
	    doSearch();
	});
});