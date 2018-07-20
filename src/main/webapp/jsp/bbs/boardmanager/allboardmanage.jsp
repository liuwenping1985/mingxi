<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
${v3x:skin()}
</head>
<script type="text/javascript">
var theHtml;
if('18'=='${param.spaceType}'||'17'=='${param.spaceType}'){
  theHtml=toHtml('${spaceName}','<fmt:message key="bbs.latest.post.label"/><fmt:message key="bbs.manager.label"/>');
}else if('3'=='${param.spaceType}'){
    theHtml=toHtml("${v3x:toHTML(spaceName)}",'<fmt:message key="menu.group.bbs.manage" bundle="${v3xMainI18N}"/>');
}else if('2'=='${param.spaceType}'){
       theHtml=toHtml("${v3x:toHTML(spaceName)}",'<fmt:message key="menu.account.bbs.manage" bundle="${v3xMainI18N}"/>');
}
showCtpLocation("",{html:theHtml});

</script>
<body scroll="no" >
	<div class="main_div_row2">
 		<div class="right_div_row2">
    		<div class="top_div_row2">
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
					   <td height="24" class="webfx-menu-bar page2-list-header border-top border-left" ><b><fmt:message key="bbs.boardmanager.allbm.manager" /></b></td>
				       <td height="24" class="webfx-menu-bar border-top border-right">&nbsp;</td>
				    </tr>
				    <input type="hidden" id="spaceTypes" value="${param.spaceType}"/>
				    <input type="hidden" id="spaceIds" value="${param.spaceId}"/>
				</table>
			</div>
			<div class="center_div_row2" id="scrollListDiv" style="overflow:hidden;">
				<form name="fm" method="post" action="" onsubmit="">
					<v3x:table htmlId="pending" data="${boardModelList}" var="col2" isChangeTRColor="true" dragable="true">
						<c:set var="onClick" value="javascript:manageBoardArticle('${col2.id}', '${dept}', '${group}', '${param.where}');" />
						<v3x:column width="20%" type="String" label="bbs.board.label" alt="${col2.boardName}">					
							<a href="###" class="black_link"  onclick="${onClick}" ><b>${v3x:toHTML(v3x:getLimitLengthString(col2.boardName,25,"..."))}</b></a>
						</v3x:column>
						<v3x:column width="30%" type="String" label="common.description.label" value="${col2.boardDescription}" className="cursor-hand sort" maxLength="20" onClick="${onClick}" />
						<v3x:column width="10%" type="Number"  label="bbs.subject.number.label" value="${col2.articleNumber}" className="cursor-hand sort" onClick="${onClick}" />
						<v3x:column width="10%" type="Number"  label="bbs.elite.number.label">
							<a href="${detailURL}?method=listBoardElite&id=${col2.id}&group=${group}">${col2.elitePostNumber}</a>
						</v3x:column>
						<c:set value="${v3x:showOrgEntitiesOfIds(v3x:joinDirectWithSpecialSeparator(col2.board.admins, ','), 'Member', pageContext)}" var="admins" />
						<v3x:column width="30%"  label="bbs.admin.label" className="cursor-hand sort" alt="${admins}" value="${admins}" maxLength="20" symbol="..." onClick="${onClick}" />
					</v3x:table>
				</form>
				</div>
			</div>
		</div>
</body>
</html>