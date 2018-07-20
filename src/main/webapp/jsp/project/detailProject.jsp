<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="projectHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='project.showprojectdetail.label' /></title>
</head>
<body scroll = "auto">

   <form name="project" action="" method="get">
    <table border="0"  cellpadding="0" cellspacing="0" width="95" align="left">
       <tr>
        <td width="20%" align="right">
           <fmt:message key='project.body.projectName.label' />:</td>
        <td width="30%">${v3x:toHTML(projectCompose.projectSummary.projectName)}<input
			type="hidden" id="hiddenProjectName" name="hiddenProjectName"
			value="${v3x:toHTML(projectCompose.projectSummary.projectName)}">
        </td>
        <td width="20%" align="left">
           <fmt:message key='project.body.responsible.label' />:</td>
        <td width="30%">${projectCompose.principal.name}</td>
       </tr>
       <tr>
          <td align="right"><fmt:message key='project.department' />：</td>
          <td>${projectCompose.deparment.name}</td>
          <td align="right"><fmt:message key='project.team ' />：</td> 
          <td><c:if test="${projectCompose.projectSummary.publicState =='0'}"><fmt:message key='project.opengroup' /></c:if>
            <c:if test="${projectCompose.projectSummary.publicState =='1'}"><fmt:message key='project.notopengroup' /></c:if>
          </td>
       </tr>
       <tr>
        <td align="right">
           <fmt:message key='project.startime'/>：</td><td><fmt:formatDate value="${projectCompose.projectSummary.begintime}" pattern="${datePattern}" />
        </td>
        <td align="right">
        <fmt:message key='project.endtime'/>：</td><td><fmt:formatDate value="${projectCompose.projectSummary.closetime}" pattern="${datePattern}" /></td>
        </tr>
        <tr>
		<td align="right"><fmt:message key='project.status'/>：</td>
		<td colspan="3">
		   <c:if test="${projectCompose.projectSummary.projectState == '0'}">
		      <fmt:message key='project.body.projectstate.0'/>
		   </c:if>
		   <c:if test="${projectCompose.projectSummary.projectState == '1'}">
		       <fmt:message key='project.body.projectstate.1'/>
		   </c:if>
		   <c:if test="${projectCompose.projectSummary.projectState == '2'}">
		      <fmt:message key='project.body.projectstate.2'/>
		   </c:if>
		    <c:if test="${projectCompose.projectSummary.projectState == '3'}">
		       <fmt:message key='project.body.projectstate.3'/>
		   </c:if>
		    <c:if test="${projectCompose.projectSummary.projectState == '-1'}">
		         <fmt:message key='project.body.projectstate.5'/>
		   </c:if>
		</td>
	</tr>
       <tr>
        <td align="right">
           <fmt:message key='project.body.manger.label'/>：</td><td colspan="3"><c:forEach var="chargeList"  items="${projectCompose.chargeLists}">
                       <c:out value="${chargeList.name}"></c:out>
                 </c:forEach>
        </td>
       </tr>
          <tr>
        <td align="right">
            <fmt:message key='project.body.members.label'/>：</td><td colspan="3"><c:forEach var="memberList"  items="${projectCompose.memberLists}">
                       <c:out value="${memberList.name}"></c:out>
                 </c:forEach>
        </td>
       </tr>
       <tr>
        <td align="right">
            <fmt:message key='project.body.related.label'/>：</td><td colspan="3"><c:forEach var="interfixList"  items="${projectCompose.interfixLists}">
                       <c:out value="${interfixList.name}"></c:out>
                 </c:forEach>
        </td>
       </tr>
      <tr>
        <td align="right">
            <fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> ：
        </td>
        
        
        <td colspan="3" align="left">
               <v3x:attachmentDefine attachments="${attachments}" />
			   <script type="text/javascript">
			        showAttachment('${projectCompose.projectSummary.id}', 0, 'attsDiv${projectCompose.projectSummary.id}');
			   </script></td>
      </tr>
       
       <tr>
        <td align="right">
           <fmt:message key='project.detail'/>：</td><td colspan="3">
           <div style=" width: 200px;overflow:hidden; text-overflow:ellipsis; cursor: hand" title="${projectCompose.projectSummary.projectDesc}"><nobr>
              <c:out value="${projectCompose.projectSummary.projectDesc}" escapeXml="true"></c:out>
           </nobr></div>
        </td>
       </tr>
       <tr>
        <td align="right" valign="top">
           <fmt:message key='project.stage'/>：</td><td colspan="3">
                       <table border="0"  cellpadding="0" cellspacing="0" width="100%" align="center">
                       <c:forEach var="phases"  items="${projectCompose.projectSummary.projectPhases}">
                       <tr>
                         <td><fmt:message key='project.phase.name.label'/></td><td>${phases.phaseName}</td>
                       </tr>
                       <tr>
                         <td><fmt:message key='project.startime'/></td><td><fmt:formatDate value="${phases.phaseBegintime}" pattern="${datePattern}" /></td>
                       </tr>
                       <tr>
                         <td><fmt:message key='project.endtime'/></td><td><fmt:formatDate value="${phases.phaseClosetime}" pattern="${datePattern}" /></td>
                       </tr>
                        <tr>
                         <td><fmt:message key='project.progress'/></td><td>${phases.phasePercent}%</td>
                       </tr>
                        <tr>
                         <td><fmt:message key='project.desc'/></td><td>${phases.phaseDesc}</td>
                       </tr>
                       <tr>
                        <td>&nbsp;</td>
                       </tr>
                       <c:out value="${interfixList.name}"></c:out>
                 </c:forEach>
                  </table>
        </td>
       </tr>
     </table>
   </form>
</body>
</html>