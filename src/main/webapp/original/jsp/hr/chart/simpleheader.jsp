<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<c:if test="${CurrentUser.skin != null}">
<link rel="stylesheet" href="<c:url value="/common/skin/${CurrentUser.skin}/skin.css" />">
</c:if>
<c:if test="${CurrentUser.skin == null}">
<link rel="stylesheet" href="<c:url value="/common/skin/default/skin.css" />">
</c:if>
<script>
var elements = ['article', 'nav', 'section', 'header', 'aside', 'footer','canvas','shape','fill'];
for (var i=elements.length-1; i>=0; i--) {
	document.createElement(elements[i]);
}

function getDetailPageBreak(isShowButton){
	var showButtonFlag = true; 
	if(isShowButton != true && (window.dialogArguments || window.opener)){
		showButtonFlag = false;
	}

	
	document.write("<table id='pagebreakspare' border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" align=\"center\">");
	document.write("<tr align=\"center\">");
	document.write("<td style='overflow:hidden;' class=\"detail-top\" valign='top'>");
	if(showButtonFlag){
		document.write("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">");
		document.write("<tr>");
		document.write("<td valign='top'>");
			document.write("<div class='break-up' onclick=\"previewFrame('Up')\"></div>");
		document.write("</td>");
		document.write("<td valign='top'>");
			document.write("<div class='break-down' onclick=\"previewFrame('Down')\"></div>");
		document.write("</td>");
		document.write("</tr>");
		document.write("</table>");
	}
	document.write("</td>");
	document.write("</tr>");
	document.write("</table>");
	document.close();
	previewFrame('Middle');
}

function previewFrame(direction){
	if(!direction) return;
	var obj = parent.document.getElementById("sx");
	
	if(obj == null){
		return;
	}
	
	if(indexFlag > 1){
		indexFlag = 0;
	}
		
	var status = eval("sx" + direction + "Constants.status_" + indexFlag);
	obj.rows = status;
	
	if(direction != "Middle"){
		indexFlag++;
	}
}
</script>