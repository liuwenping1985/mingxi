/***********************************************
 * 处理界面的按钮切换
 */
function docPanel(id, label, deafaultselected, isnotUse, onclick) {
    this.id = id;
    this.label = label;
    this.deafaultselected = deafaultselected;
    this.isnotUse = isnotUse;
    this.onclick = onclick || "";
}

docPanel.prototype.docToString = function() {
	
    return "<div id='button" + this.id + "' onClick=\"docChangeLocation('" + this.id + "');" + this.onclick + "\" class='" + this.deafaultselected + "' " + this.isnotUse + ">" + this.label + "</div>" +
           "<div class=\"sign-button-line\"></div>";
}

function docShowPanels() {
    for (var i = 0; i < panels.size(); i++) {
        document.write(panels.get(i).docToString());
        
    }
    //added by lius.
    
    document.close();
}

function docChangeLocation(id) {
	try{
	    for (var i = 0; i < panels.size(); i++) {
        var id_ = panels.get(i).id;
        if (id_ == id) continue;

        document.getElementById('button' + id_).className = "sign-button";
        var o = docPropertyIframe.document.getElementById(id_ + "TR");
        if (o) {
            o.style.display = "none";
        }
    }

    document.getElementById("button" + id).className = "sign-button-sel";
    docPropertyIframe.document.getElementById(id + "TR").style.display = "";
	}catch(e){
		
	}
}