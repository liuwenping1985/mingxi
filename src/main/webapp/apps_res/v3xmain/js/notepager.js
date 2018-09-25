function autoSave() {
	var contentObj = document.getElementById("message");
	if(maxLength(contentObj)){
		this.invoke = function(ds) {
			notepageId = ds;
		}
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxNotepagerManager", "autoSave", true);
		requestCaller.addParameter(1, "String", notepageId);
		requestCaller.addParameter(2, "Long", currentUserId);
		requestCaller.addParameter(3, "String", contentObj.value);
		requestCaller.serviceRequest();
	}
}  

function stateSave(){
	autoSave();
} 

function focusSave(){
    autoSaveTimer=setInterval("autoSave()",autoSaveTime);
}

function blurSave(){
     clearInterval(autoSaveTimer);
}

function saveas(){
	var contentObj = document.getElementById("message");
	if(maxLength(contentObj)){
		var content = contentObj.value;
        content = content.replace(/ /g, "&nbsp;");
        content = content.replace(/\n/g, "<br/>");
		var expwin = window.open("", "expwin");
	    expwin.document.open("text/html", "replace");
	    expwin.document.charset="utf-8";
	    expwin.document.write(content);
		expwin.document.execCommand('SaveAs', false, saveAs);
	}
}