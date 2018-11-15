<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
</script>
</head>
<body scroll="no" class="padding5">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="popupTitleRight">
	<tr>
	  <td class="PopupTitle">
	    <fmt:message key='metadata.manager.binding'/>
	  </td>
	</tr>   
	
	<tr>
		<td height="10px;"></td>
	</tr>

	   <tr>
	      <td valign="bottom" height="26" class="tab-tag">
				<div class="div-float">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='<html:link renderURL='/metadata.do?method=showSystemMetadataIframe' />'">
						<fmt:message key='metadata.manager.public' bundle="${v3xMainI18N}"/>
					</div>
					<div class="tab-tag-right"></div>
					
					<div class="tab-separator"></div>	
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel cursor-hand" onclick="location.reload();">
					 	<fmt:message key='metadata.manager.account' bundle="${v3xMainI18N}"/>
					</div>
					<div class="tab-tag-right-sel"></div>
				</div>
		  </td>
	  </tr>

	  <tr>
	    <td valign="top" width="100%" height="100%" align="center" class="page-list-border-LRD">
		    <iframe width="100%" height="100%" frameborder="0" src="${metadataMgrURL}?method=selectOrgTreeFrame" name="selectTreeFrame" id="selectTreeFrame" />
		</td>
	</tr>
</table>
</body>		
</html>