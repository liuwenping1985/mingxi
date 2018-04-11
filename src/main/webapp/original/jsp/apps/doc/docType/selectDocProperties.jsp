<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<%@ include file="../../../common/INC/noCache.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doctype.selectproperty.label'/></title>
</head>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docManager.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
	function getDefByCategory(obj){
		var str="";
		for(var i=0;i<obj.length;i++){
			if(obj.options[i].selected){
				str=obj.options[i].value;
				break;
			}
		}
		
		if(str == null || str== ""){
			metaIframe.location.href="${managerURL}?method=listDocProperties";
		}
		else{
			metaIframe.location.href="${managerURL}?method=listDocProperties&category="+encodeURI(str);
		}
	}
//-->
</script>
<body scroll="no">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" class="PopupTitle" width="80%" style="div-float"><fmt:message key='doctype.selectproperty.label'/></td><td class="PopupTitle" style="div-float-right"><!--<fmt:message key="metadataDef.selectCategory.label"/>-->
				<select id="selectMetadata" name="selectMetadata" onchange="getDefByCategory(this);" >					
				</select>&nbsp;
			</td>
		</tr>

		<tr>
			<td valign="top" colspan="2">
				<iframe src="${managerURL}?method=listDocProperties" width="100%" height="100%" frameborder="0" name="metaIframe" id="metaIframe" marginheight="0" marginwidth="0" scrolling="yes">
				</iframe>
			</td>
		</tr>
		<tr>
			<td height="42" align="right" class="bg-advance-bottom" colspan="2">
				<input type="button" onclick="addChoiceMeta();" name="b1" id="b1" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
				<input type="button" name="b2" id="b2" onclick="window.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
</table>
	
<script type="text/javascript">
	var theMetadata=document.getElementById("selectMetadata");
	theMetadata.options[theMetadata.length]=new Option("<fmt:message key='doc.property.allcategory.label'/>","all");
	<c:forEach var="item" items="${metaCategory}" >
		theMetadata.options[theMetadata.length]=new Option("${v3x:_(pageContext, item)}", "${item}");
	</c:forEach>
</script>
</body>
</html>