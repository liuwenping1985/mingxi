<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<%@ include file="header.jsp"%>
</head>
<body class="border-right" scroll="no">
<script type="text/javascript">
var treeSelectId = '${treeSelectId}' ;
var parentId = '' ;
</script>
<table width="100%" height="100%" cellpadding="0" cellspacing="0">
	<tr class="${from == 'metadata'?'show':'hidden'}" id="metadataValueToolbar">
		<td>
			<script type="text/javascript">
				var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");	
				 myBar.add(new WebFXMenuButton("newdata", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>", "newdataItem();", [1,1],"", null));
				 myBar.add(new WebFXMenuButton("editdata", "<fmt:message key='common.toolbar.update.label'  bundle='${v3xCommonI18N}' />", "editdataItem()", [1,2], "", null));
				 myBar.add(new WebFXMenuButton("deldata", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>", "deldatadataItem();", [1,3], "", null));
				 document.write(myBar);
				 document.close() ;
			</script>
		</td>
	</tr>
	<tr class="${from == 'metadata'?'hidden':'show'}" id="unMetadataToolbar">
		<td>
			<script type="text/javascript">			  	 
			//var myBar = new WebFXMenuBar("/seeyon","gray");	
			var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			var transmit = new WebFXMenu;
    		transmit.add(new WebFXMenuItem("", "<fmt:message key='metadata.manager.typename.lable' bundle='${v3xMainI18N}'/>", "createnewMdataFolder('${metadataMgrURL}')"));
			transmit.add(new WebFXMenuItem("", "<fmt:message key='metadata.enum.name' bundle='${v3xMainI18N}'/>", "createnewMdata('${metadataMgrURL}')"));
			
			myBar.add(new WebFXMenuButton("transmit", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>", null, [1,1], "", transmit));
	    	myBar.add(new WebFXMenuButton("pigeonhole", "<fmt:message key='common.toolbar.update.label'  bundle='${v3xCommonI18N}' />", "javascript:editMetadataFolder('${metadataMgrURL}')", [1,2], "", null));
	    	myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>", "javascript:deleetMetadataFolder()", [1,3], "", null));    	
	    	myBar.add(new WebFXMenuButton("refresh", "<fmt:message key='doc.menu.move.label' bundle='${docResource}'/>", "javascript:moveToFolder()", [2,1], "", null));
	
	    	document.write(myBar);
	    	document.close();
			</script>
		</td>
	</tr>
	<tr class="${from == 'metadata'?'hidden':'show'}" id="metadataToolbar">
		<td>
			<script type="text/javascript">			  	 
			//var myBar = new WebFXMenuBar("/seeyon","gray");	
			var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			myBar.add(new WebFXMenuButton("newdata", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>", "createnewMdata('${metadataMgrURL}');", [1,1],"", null));
	    	myBar.add(new WebFXMenuButton("pigeonhole", "<fmt:message key='common.toolbar.update.label'  bundle='${v3xCommonI18N}' />", "javascript:editMetadataFolder('${metadataMgrURL}')", [1,2], "", null));
	    	myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>", "javascript:deleetMetadataFolder()", [1,3], "", null));    	
	    	myBar.add(new WebFXMenuButton("refresh", "<fmt:message key='doc.menu.move.label' bundle='${docResource}'/>", "javascript:moveToFolder()", [2,1], "", null));
	
	    	document.write(myBar);
	    	document.close();
			</script>
		</td>
	</tr>
</table>
</body>
</html>