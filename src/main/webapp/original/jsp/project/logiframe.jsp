<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="projectHeader.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='project.showlog'/></title>	
<script type="text/javascript">

</script>


</head>

<body scroll="no" style="overflow: no">
<table width="100%" border="0" cellspacing="0" align = "center" class="line_project"
	cellpadding="0" height="100%">
	<tr>
	<td class="webfx-menu-bar" >
	&nbsp;&nbsp;<fmt:message key='project.showlog'/>
	</td>
	</tr>
	<tr>

			<td colspan="2">
			<div class="scrollList">
				<form id="form1" method="post">
					<v3x:table data="${operationLogs}" var="operationLog" htmlId="operationLoglist" >
					<v3x:column width="10%" label="project.user"
							value="${v3x:showMemberName(operationLog.memberId)}" className="sort"
					 		symbol="..." alt="${v3x:showMemberName(operationLog.memberId)}"
					></v3x:column>
					
					<v3x:column width="16%" label="project.log.oper.type.label"	className="sort">
						<fmt:message key="${operationLog.actionType}" />
					</v3x:column>			        
			        
					<v3x:column width="20%" type="Date" label="project.time" className="sort">
		               <fmt:formatDate value="${operationLog.actionTime}" type="both" dateStyle="full" pattern="${datetimePattern}"  />
                 	</v3x:column>                	                	
                 	
                 		<v3x:column width="54%" type="String" label="project.help" className="sort"
                 		value="${v3x:messageOfParameterXML(pageContext, operationLog.contentLabel, operationLog.contentParameters)}"
                 		alt="${v3x:messageOfParameterXML(pageContext, operationLog.contentLabel, operationLog.contentParameters)}"
                 		maxLength="80" symbol="...">
               
                 	</v3x:column>
                 
                 					
					</v3x:table>
				
				</form>
			</div>
		</td>
	</tr>
</table>

</body>
</html>