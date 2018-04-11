<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="taglib.jsp"%>
<%@ include file="header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
<%-- TODO
 if(${v3x:currentUser().groupAdmin}){
 	getA8Top().showLocation(2002);
 }else{
 	getA8Top().showLocation(1515);
 }
--%>
</script>
</head>

<body scroll="no" class="padding5">
 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
 <!-- 原来的页签页面  去掉
 	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div class="div-float"  id="menuTabDiv">
			
			<div class="tab-tag-left"></div>
			<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${mtContentTemplateURL}?method=listMain">
				<fmt:message key="mt.mtIn.common.label"/><fmt:message key="mt.mtContentTemplate_shortname"/>
			</div>
			<div class="tab-tag-right"></div>
			<div class="tab-separator"></div>
			
			<!--
			<div class="tab-tag-left"></div>
			<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="<html:link renderURL='/planSystemMgr.do?method=planSysMgr' />">
				<fmt:message key="menu.plan.style" bundle="${v3xMainI18N}" />
			</div>
			<div class="tab-tag-right"></div>

			--?>
			</div>
			
		</td>
	</tr>
-->	
 	<tr>
		<td class="page-list-border">
			<iframe src="${contentTemplateURL}?method=listMain" noresize="noresize" frameborder="no" id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px"></iframe>					
		</td>
	</tr>
</table>
</body>


</html>