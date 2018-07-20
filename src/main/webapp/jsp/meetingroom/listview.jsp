<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<%@ include file="../migrate/INC/noCache.jsp" %>
		<title></title>
		<%@ include file="headerbyopen.jsp" %>
		<script type="text/javascript">
		var show = 0;
		var myFmt = parent.document.all('sx');
		var width = parent.window.dialogWidth;
		function showCalendar(node){	
			if(show == 0){
				myFmt.rows = "300,400";
				show = 1;
				node.value = "<fmt:message key='mr.button.hiddencalendar'/>";
				parent.window.resizeBy(0, 400);
				parent.window.dialogHeight = 42;
			}else{
				myFmt.rows = "300,0";
				show = 0;
				node.value = "<fmt:message key='mr.button.showcalendar'/>";
				parent.window.resizeBy(0, -400);
				parent.window.dialogHeight = 18;
			}
		}

		function initShow(){
			if(myFmt.rows.indexOf(",0") == -1){
				document.getElementById("showButton").value = "<fmt:message key='mr.button.hiddencalendar'/>";
				show = 1;
			}
		}
		</script>
	</head>
	<body onload="initShow()" style="overflow: hidden" style="padding: 0px">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   		<tr>
	   			<td height="100%">
	<div class="scrollList">
    <form name="listForm" id="listForm" method="post" style="margin: 0px">
    <v3x:table htmlId="listTable" data="list" var="bean" pageSize="${pageSize }" size="${size }" showHeader="true" showPager="true" isChangeTRColor="true">
		<v3x:column width="30%" type="String" onDblClick="" onClick="" 
			label="mr.alert.meetingtitle" className="cursor-hand sort" alt="">
			<c:choose>
				<c:when test="${bean.meeting.title != null }"><c:out value="${bean.meeting.title }"/></c:when>
				<c:otherwise>（<fmt:message key='mr.label.yuding'/>）</c:otherwise>
			</c:choose>
		</v3x:column>
		<v3x:column width="20%" type="String" 
			label="mr.label.meetingroom" className="cursor-hand sort" alt="">
			<c:out value="${bean.meetingRoom.name }" />
			<c:if test="${bean.meetingRoom.needApp == MRConstants.Type_MeetingRoom_NoNeedApp }">※</c:if>
		</v3x:column>
		<v3x:column width="20%" type="String" 
			label="mr.label.start" className="cursor-hand sort" alt="">
			<fmt:formatDate value="${bean.startDatetime}" pattern="yyyy-MM-dd HH:mm"/>
		</v3x:column>
		<v3x:column width="20%" type="String" 
			label="mr.label.end" className="cursor-hand sort" alt="">
			<fmt:formatDate value="${bean.endDatetime}" pattern="yyyy-MM-dd HH:mm"/>
		</v3x:column>
		<v3x:column width="10%" type="String" 
			label="mr.label.firstperson" className="cursor-hand sort" alt="">
			<c:choose>
				<c:when test="${bean.meeting==null }">
					${bean.v3xOrgMember.name }
					<c:if test="${bean.v3xOrgMember.id != v3x:currentUser().id }">
						<span onClick="sendMessageForCard(false, '${bean.v3xOrgMember.id}')"><img src="<c:url value='/apps_res/v3xmain/images/online.gif'/>"/></span>
					</c:if>
				</c:when>
				<c:otherwise>
					<c:out value="${bean.meeting.createUserName }" />
					<c:if test="${bean.meeting.createUser != v3x:currentUser().id }">
						<span onClick="sendMessageForCard(false, '${bean.meeting.createUser}')"><img src="<c:url value='/apps_res/v3xmain/images/online.gif'/>"/></span>
					</c:if>
				</c:otherwise>
			</c:choose>
		</v3x:column>
	</v3x:table>
	</form>
	</div>
	   			</td>
	   		</tr>
	   		<tr>
	   			<td align="center" height="26" class="bg-advance-bottom">
	   				<input type="button" id="showButton" value="<fmt:message key='mr.button.showcalendar'/>" onclick="showCalendar(this)" />&nbsp;&nbsp; 
	   				<input type="button" value=" <fmt:message key='common.button.close.label' bundle='${v3xCommonI18N}'/> " onclick="parent.window.close()" />
	   			</td>
	   		</tr>
	   	</table>
	</body>
</html>