<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<html>
<head>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>	
<script type="text/javascript">
	showCurrentHrefLocation();
	function showCurrentHrefLocation(){
      var html = "<span class='nowLocation_ico'><img src='/seeyon/main/skin/frame/harmony/menuIcon/personal.png'/></span>";
      html += "<span class='nowLocation_content'>";
      html += "<a class=\"hand\" onclick=\"showMenu('/seeyon/portal/portalController.do?method=personalInfo')\">个人事务</a>";
  	  html += " &gt; <span><fmt:message key="menu.hr.personal.attendance.manager" bundle="${v3xHRI18N}" /></span>";
      html += "</span>";
      getA8Top().showLocation(html);
	}
	
	function viewRecord(recordId){
		parent.detailFrame.location.href = hrRecordURL+"?method=viewRecord&recordId="+recordId;
	}
</script>
</head>
<body>

<div class="main_div_center">
	<div class="right_div_center">
		<div class="center_div_center" id="scrollListDiv">
		<form id="salaryform" name="salaryform" method="post"><v3x:table
			data="${records}" var="record" htmlId="recordlist"
			leastSize="${leastSize}">
			<c:set var="click" value="viewRecord('${record.id}')" />
			<v3x:column width="20%" type="String"
				label="hr.record.checkinTime.actually.label"
				className="cursor-hand sort" onClick="${click}">
				<c:if test="${record.state.id != 3}">
				<fmt:formatDate value="${record.begin_work_time}" type="both"
					dateStyle="full" pattern="yyyy/MM/dd E H:mm:ss" />
				</c:if>
			</v3x:column>

			<v3x:column width="10%" type="String"
				label="hr.record.checkinTime.stated.label" onClick="${click}"
				value="${record.begin_hour}:${record.begin_minute}"
				className="cursor-hand sort" symbol="..."
				alt="${record.begin_hour}:${record.begin_minute}">
			</v3x:column>
			
			<v3x:column width="15%" type="String" label="hr.record.sign.in.ip.label"
				className="cursor-hand sort" onClick="${click}"
				value="${record.signInIP}" >
			</v3x:column>
			
			<v3x:column width="15%" label="hr.record.checkoutTime.actually.label"
				type="String" className="cursor-hand sort" onClick="${click}">
				<c:if test="${record.state.id != 3}">
				<fmt:formatDate value="${record.end_work_time}" type="both"
					dateStyle="full" pattern="yyyy/MM/dd H:mm:ss" />
				</c:if>
			</v3x:column>

			<v3x:column width="10%" type="String"
				label="hr.record.checkoutTime.stated.label" onClick="${click}"
				value="${record.end_hour}:${record.end_minute}"
				className="cursor-hand sort" symbol="..."
				alt="${record.end_hour}:${record.end_minute}">
			</v3x:column>

			<v3x:column width="15%" type="String" label="hr.record.sign.out.ip.label"
				className="cursor-hand sort" onClick="${click}"
				value="${record.signOutIP}" >
			</v3x:column>

			<v3x:column width="15%" type="String" label="hr.record.state.label"
				className="cursor-hand sort" onClick="${click}">
				<fmt:message key="${record.state.state_name }" bundle="${v3xHRI18N}" />
			</v3x:column>

		</v3x:table></form>
		</div>
	</div>
</div>
<c:if test="${param.isShowDetail != false}">		
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='hr.userDefined.model.record.label' bundle='${v3xHRI18N}'/>", [2,4], pageQueryMap.get('count'),  v3x.getMessage("HRLang.detail_hr_803"));
</script>
</c:if>
</body>
</html>
