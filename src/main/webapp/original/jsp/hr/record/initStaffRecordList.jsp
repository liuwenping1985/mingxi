<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">	
<head>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>    
<script type="text/javascript">
	function viewStaffRecord(recordId){
		parent.detailFrame.location.href = hrRecordURL+"?method=viewStaffRecord&recordId="+recordId;
	}
</script>
</head>
<body>
			<input type="hidden" id="resultCount" value="${resultCount}" />
				<form id="recordform" name="recordform" method="post">
					
					<v3x:table data="${records}" var="webRecord" leastSize="${leastSize }" htmlId="salarylist">					
					
					<c:set var="click" value="viewStaffRecord('${webRecord.record.id}')"/>
					
					<v3x:column width="10%" type="String"  label="hr.staffInfo.name.label" onClick="${click}"
							value="${v3x:showMemberName(webRecord.record.staffer_id)}" className="cursor-hand sort" maxLength="15" symbol="..." alt="${v3x:showMemberName(webRecord.record.staffer_id)}"
					></v3x:column>
					
					<v3x:column width="10%" label="hr.record.department.label" onClick="${click}"
							value="${webRecord.department}" className="cursor-hand sort" symbol="..." alt="${webRecord.department}"
					></v3x:column>
					
					<v3x:column width="15%" type="String" label="hr.record.checkinTime.actually.label" className="cursor-hand sort" onClick="${click}">
		              <c:if test="${webRecord.record.state.id != 3}">
		              <fmt:formatDate value="${webRecord.record.begin_work_time}" type="both" dateStyle="full" pattern="yyyy/MM/dd E H:mm:ss"  />
		              </c:if>
                 	</v3x:column>
			
					<v3x:column width="10%" type="String"  label="hr.record.checkinTime.stated.label" onClick="${click}"
							value="${webRecord.record.begin_hour}:${webRecord.record.begin_minute}" className="cursor-hand sort" symbol="..." alt="${webRecord.record.begin_hour}:${webRecord.record.begin_minute}"
					></v3x:column>
			
					<v3x:column width="10%" type="String" label="hr.record.sign.in.ip.label" className="cursor-hand sort" onClick="${click}"
						value="${webRecord.record.signInIP}" >
					</v3x:column>
			
					<v3x:column width="15%" type="String" label="hr.record.checkoutTime.actually.label" className="cursor-hand sort" onClick="${click}">
		              <c:if test="${webRecord.record.state.id != 3}">
		              <fmt:formatDate value="${webRecord.record.end_work_time}" type="both" dateStyle="full" pattern="yyyy/MM/dd H:mm:ss"  />
		              </c:if>
                 	</v3x:column>
					
					<v3x:column width="10%" type="String"  label="hr.record.checkoutTime.stated.label" onClick="${click}"
							value="${webRecord.record.end_hour}:${webRecord.record.end_minute}" className="cursor-hand sort" symbol="..." alt="${webRecord.record.end_hour}:${webRecord.record.end_minute}"
					></v3x:column>
					
					<v3x:column width="10%" type="String" label="hr.record.sign.out.ip.label" className="cursor-hand sort" onClick="${click}"
						value="${webRecord.record.signOutIP}" >
					</v3x:column>
					
					<v3x:column width="10%" type="String" label="hr.record.state.label"  className="cursor-hand sort" onClick="${click}">
		              <fmt:message key="${webRecord.record.state.state_name }" bundle="${v3xHRI18N}"/>
                 	</v3x:column>
                 	
					</v3x:table>
				</form>
<c:if test="${param.isShowDetail != false}">
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='hr.statisticStaff.manager.label' bundle='${v3xHRI18N}'/>", [2,4], pageQueryMap.get('count'),  v3x.getMessage("HRLang.detail_hr_1204"));
</script>
</c:if>
</body>
</html>