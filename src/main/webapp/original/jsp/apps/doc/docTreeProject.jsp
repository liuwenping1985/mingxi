<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
<!--
function moveGo() {
	var destResId = "";
	var destLibId = "";		
		
	var selected = tree.getSelected(); 
	if(selected && typeof selected.src == "string") {	
		var url = selected.src;
		destResId = url.substring(url.indexOf("resId=") + 6, url.indexOf("&frType=")); // 目标文档夹id
		destLibId = url.substring(url.indexOf("docLibId=") + 9, url.indexOf("&docLibType=")); // 目标文档库id		
	}
	else {
		alert(parent.parent.v3x.getMessage('DocLang.doc_tree_move_select_alert'));
		//alert("请选择目标文档夹!");
		return false;
	}

	if("${param.ids}" == "null") {
		parent.window.returnValue = destResId + "," + selected.showName;
		parent.close();
	} 
	else {			
		var theForm = document.getElementById("mainForm");
		theForm.target = "moveIframe";				
		theForm.action = "${detailURL}?method=pigeonhole&destLibId=" + destLibId + "&destResId=" + destResId + "&appName=${param.appName}&ids=${param.ids}&atts=${param.atts}";
		theForm.submit();
	}	    
	
}
//-->
</script>
</head>
<body>

<form name='mainForm' method='post'>
	
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">	
		
		<tr valign="top">
			<td>

<div style="margin-left: 10px; margin-top: 10px;"><script type="text/javascript">

webFXTreeConfig.openRootIcon = "<c:url value='/apps_res/doc/images/docIcon/root.gif'/>";
webFXTreeConfig.defaultText = "<fmt:message key='doc.tree.struct.lable'/>";
var tree = new WebFXTree();
tree.target = "moveIframe";

	var tree_${root.docResource.id} = new WebFXLoadTreeItem("${root.docResource.id}", "${v3x:toHTML(root.frName)}", null, null, null, null, "<c:url value='/apps_res/doc/images/docIcon/${root.closeIcon}'/>", "<c:url value='/apps_res/doc/images/docIcon/${root.openIcon}'/>");
	tree_${root.docResource.id}.src = "<c:url value='/doc.do?method=xmlJspProject&resId=${root.docResource.id}&frType=${root.docResource.frType}&docLibId=${root.docResource.docLibId}&docLibType=${root.docLibType}&isShareAndBorrowRoot=false'/>";
	tree_${root.docResource.id}.fileIcon = "<c:url value='/apps_res/doc/images/docIcon/${root.closeIcon}'/>";
	
	tree_${root.docResource.id}.target = "moveIframe";
		
	tree.add(tree_${root.docResource.id});

document.write(tree);
//tree_${root.docResource.id}.expand();
</script></div>
			</td>
		</tr>		
		
	</table>
	
</form>

<iframe name="moveIframe" frameborder="0"	height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"/>

</body>
</html>
