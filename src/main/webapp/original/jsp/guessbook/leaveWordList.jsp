<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ include file="../common/INC/noCache.jsp"%>
<html:link renderURL="/guestbook.do" var="guestbookURL"/>
<html:link renderURL="/project.do" var="basicURL" />
<script type="text/javascript">
<c:if test="${!project && !isSpaceManager && param.isManager=='true'}">
	alert(_("MainLang.no_acl_department_leavework_manage"));
</c:if>

	var genericURL = "${guestbookURL}";	
	getA8Top().hiddenNavigationFrameset();
	function showLeaveWordDlgFromPoroject(departmentId) {
		var leaveWordURL = "<html:link renderURL='/guestbook.do' psml='default-page.psml' />?method=showLeaveWordDlg&departmentId=" + departmentId + "&from=project";
		var result = getA8Top().v3x.openWindow({
			url: leaveWordURL,
			width:"500",
			height:"350",
			scrollbars:"no"
		});
		if(!result) 
			return;
		location.reload(true);
	}
	
	var locationHref = "<html:link renderURL='/guestbook.do?method=moreLeaveWord&departmentId=${param.departmentId}&project=${param.project}' psml='default-page.psml' />";
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/guestbook.js${v3x:resSuffix()}" />"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body scroll="no">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td width="100%" height="60" valign="top">
			 <table width="100%"  border="0" cellpadding="0" cellspacing="0">
		     <tr class="page2-header-line" height="60">
		        <td width="80" height="60"><img src="<c:url value="/apps_res/peoplerelate/images/pic1.gif" />" width="80" height="60" /></td>		       
			        <td class="page2-header-bg">
			        	<c:if test="${!project}">
				        	<fmt:message key="guestbook.title">			        	 	
		        				<fmt:param value="${preFix}"/>
		        			</fmt:message>
	        			</c:if>
	        			<c:if test="${project}">
	        			  <span title="${dispProjectName}"> ${v3x:getLimitLengthString(dispProjectName,20,"...")}  </span> <br/><fmt:message key="guestbook.title.message"/> <br/>
	        			</c:if>
	        		</td>
		        <td class="page2-header-line page2-header-link" align="right">
		        <c:if test="${isProjectManager || isSpaceManager}">
   		        	<a  href="javascript:delLeaveWord(listForm)">[<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />]</a>&nbsp;&nbsp;
   		        </c:if>
                <c:if test="${project}">
                  <a  href="javascript:showLeaveWordDlgFromPoroject('${departmentId}')">[<fmt:message key="guestbook.leaveword.label"/>]</a>&nbsp;&nbsp;
				</c:if>
				 <c:if test="${!project}">
		        <a href="javascript:showLeaveWordDlgFromMore('${departmentId}')">[<fmt:message key="guestbook.leaveword.label"/>]</a>&nbsp;&nbsp;
				</c:if>
		        <c:if test="${!project}">
		        	<a href="javascript:getA8Top().back()" id="btnBack">[<fmt:message key='common.toolbar.back.label' bundle="${v3xCommonI18N}"/>]</a>
		        </c:if>
		         <c:if test="${project}">
		        	<a href="${basicURL}?method=projectInfo&projectId=${departmentId}" id="btnBack">[<fmt:message key='common.toolbar.back.label' bundle="${v3xCommonI18N}"/>]</a>
		        </c:if>
		        </td>
			</tr>
			</table>
		</td>
	</tr>
<tr>
<script type="text/javascript">
	if(isOpenFromGenius()){
		document.getElementById('btnBack').style.display='none';
	}
</script>
<td valign="top" class="padding5">
<table align="center" width="100%" height="100%" cellpadding="0" cellspacing="0" class="page2-list-border">	
    <tr>
	   <td height="22" class="webfx-menu-bar page2-list-header">
       <fmt:message key="guestbook.leaveword.count"><fmt:param value="${leaveWordCount}"/></fmt:message>
       </td>
	</tr>
	<tr>
	  <td>
	  <div class="scrollList">
	  <form action="${guestbookURL}?method=moreLeaveWord" name="listForm" id="listForm" method="post" onsubmit="return false" style="margin: 0px">
		<v3x:table htmlId="leaveWord" data="leaveWordList" var="leaveWord">
			 <c:if test="${isProjectManager || isSpaceManager}">
			 <v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
			<input type='checkbox' name='id' value="${leaveWord.id}" />
			</v3x:column>	
			</c:if>	      
			 <v3x:column width="14%" type="String" align="left" label="guestbook.creatorName.label"
			  value="${v3x:showMemberName(leaveWord.creatorId)}">
			</v3x:column>
			   <v3x:column width="56%" type="String" className="sort" align="left" label="guestbook.content.label" 
			  alt="${leaveWord.content}" value="${leaveWord.content}" escapeHtml="true"/>
			  <v3x:column width="20%" type="Date" align="left" label="guestbook.createTime.label">
				   <fmt:formatDate value="${leaveWord.createTime}" pattern="${datetimePattern}"/>
			</v3x:column>
			<%--
			<c:if test="${param.isManager == 'true'}">
			 <v3x:column width="8%" align="center" label="common.toolbar.delete.label">
			 <a  href="${guestbookURL}?method=clearLeaveWord&id=${leaveWord.id}&departmentId=${departmentId}" onclick="return confirm(v3x.getMessage('MainLang.guestbook_del_confirm'))"><fmt:message key="common.button.delete.label" bundle="${v3xCommonI18N}"/>	   
			</v3x:column>
			</c:if>
			--%>
		</v3x:table>			
		</form>
		</div>
	    </td>
    </tr>
</table>
</td>
</tr>
</table>
</body>
</html>