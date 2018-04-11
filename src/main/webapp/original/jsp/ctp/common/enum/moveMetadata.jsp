<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="header.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><fmt:message key='metadata.manager.move' bundle='${v3xMainI18N}'/> </title>
</head>
<script type="text/javascript">
function saveMove(){
   var form = document.getElementById("moveForm") ;
   if(!form){
      return ;
   }
   if(!window.root){
     return ;
   }
   var selected = window.root.getSelected() ;
   
    var selectId = "";
	if(selected){
		selectId = selected.businessId;
	}else{	
		window.root.select();
	}
   form.action = metadataURL + "?method=savaMoveMetadata&toMetadataId="+selectId ;
   form.target = "moveIframe" ;
   form.submit() ;
}


</script>

<body  bgColor="#f6f6f6" scroll="no" onresize="resizeBody(100,'treeandlist','min','left')">
<form action="" name="moveForm" method="post" target="moveIframe" id="moveForm">
<input type="hidden" name="metadataIds" value="${metadataIds }">
<input type="hidden" name="isSystem" value="${isSystem }">
<input type="hidden" name="parentId" value="${parentId }">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="popupTitleRight">
<tr>
  <td class="PopupTitle"><fmt:message key='metadata.manager.move' bundle='${v3xMainI18N}'/></td>
</tr>

<tr>
   <td height="10px;"></td>
</tr>

<tr valign="top">
    
    <td>
	    <div class="scrollList">
			   <script type="text/javascript">
			   var userType = "${userType}" ;
			   if(userType == 'systemAdmin') {
			     var root = new WebFXTree("0", "<fmt:message key='metadata.manager.public' bundle="${v3xMainI18N}"/>");
	             }else{
	               var root = new WebFXTree("0", "<fmt:message key='metadata.manager.account' bundle="${v3xMainI18N}"/>");
	             }
			    root.target = "moveIframe";
			    <c:forEach items="${allMetadataType}" var="meta">
		         var metadata${fn:replace(meta.id, '-', '_')}= new WebFXTreeItem('${meta.id}',"${v3x:escapeJavascript(v3x:messageFromResource(EnumI18N, meta.label))}");
		             metadata${fn:replace(meta.id, '-', '_')}.icon = "${pageContext.request.contextPath}/common/js/xtree/images/foldericon.png" ;
		             metadata${fn:replace(meta.id, '-', '_')}.openIcon = "${pageContext.request.contextPath}/common/js/xtree/images/openfoldericon.png" ;		     
			         metadata${fn:replace(meta.id, '-', '_')}.target = "moveIframe";
			         root.add(metadata${fn:replace(meta.id, '-', '_')}) ;
			    </c:forEach>
			    document.write(root);
		        document.close();      
			   </script>
		  </div>
	</td>
		
</tr>

<tr>
  <td height="42" align="right" class="bg-advance-bottom">
   <input type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" name="b1" class="button-default-2" onclick ="saveMove();">&nbsp;&nbsp;&nbsp;&nbsp;
   <input type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" name="b2" class="button-default-2" onclick="window.close();">
  </td>
</tr>
	   
</table>		   
</form>		   
<iframe width="100%" height="100%" name="moveIframe" frameborder="0" id="moveIframe"></iframe>	   
</body>
</html>