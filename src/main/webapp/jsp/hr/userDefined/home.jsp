<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<style type="text/css">
	.border_b_s{
		border-bottom: 1px solid #b6b6b6;
	}
</style>
<body class="tab-body" onload="setDefaultTab(0);" scroll="no">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
  <td valign="bottom" height="33" class="tab-tag border_b_s">
		<div class="tab-separator"></div>	
	<div id="menuTabDiv" class="div-float">
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" style="border-bottom-width: 0px;" onclick="javascript:changeMenuTab(this);" url="${hrUserDefined}?method=homeEntry&settingType=1"><fmt:message key='hr.userDefined.option.label' bundle='${v3xHRI18N}'/><fmt:message key='hr.userDefined.category.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>	
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" style="border-bottom-width: 0px;" onclick="javascript:changeMenuTab(this);" url="${hrUserDefined}?method=homeEntry&settingType=2"><fmt:message key='hr.userDefined.option.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>	
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" style="border-bottom-width: 0px;" onclick="javascript:changeMenuTab(this);" url="${hrUserDefined}?method=homeEntry&settingType=3"><fmt:message key='hr.userDefined.page.set.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>	
	</div>
  </td>
</tr>
<tr>
	<td colspan="2" class="" style="margin: 0px;padding:0px;">
		<iframe  frameborder="no"  id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px"></iframe>			
	</td>
</tr>
</table>
<script type="text/javascript">
showCtpLocation("F05_hrUserDefined");
</script>
</body>
</html>