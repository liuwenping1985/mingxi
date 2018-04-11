<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<script type="text/javascript">
	function viewRecord(recordId){
		var staffName = document.recordform.staffName.value;
		parent.detailFrame.location.href = hrRecordURL+"?method=viewRecord&recordId="+recordId+"&name="+staffName;
	}
</script>
</head>
<body>
<input type="hidden" id="resultCount" value="${resultCount}" />
<form id="recordform" name="recordform" method="post">
	<input type="hidden" name="staffName" value="${staffName}" />
	<v3x:table data="${records}" var="record"  htmlId="recordlist" leastSize="${leastSize }" >					
	
	<c:set var="click" value="viewRecord('${record.id}')"/>
	
	<v3x:column width="10%" type="String" label="hr.staffInfo.name.label"  onClick="${click}"
			value="${staffName}" className="cursor-hand sort" symbol="..." alt="${staffName}"
	></v3x:column>
	
	<v3x:column width="10%" label="hr.record.department.label" onClick="${click}"
			value="${department}" className="cursor-hand sort" symbol="..." alt="${department}"
	></v3x:column>
	
	<v3x:column width="18%" type="String" label="hr.record.checkinTime.actually.label" className="cursor-hand sort" onClick="${click}">
            <fmt:formatDate value="${record.begin_work_time}" type="both" dateStyle="full" pattern="yyyy/MM/dd E H:mm:ss"  />
             	</v3x:column>

	<v3x:column width="10%" type="String" label="hr.record.checkinTime.stated.label"  onClick="${click}"
			value="${record.begin_hour}:${record.begin_minute}" className="cursor-hand sort" symbol="..." alt="${record.begin_hour}:${record.begin_minute}"
	></v3x:column>
	
	<v3x:column width="10%" type="String" label="hr.record.sign.in.ip.label" className="cursor-hand sort" 
		value="${record.signInIP}" >
	</v3x:column>

	<v3x:column width="12%" type="String" label="hr.record.checkoutTime.actually.label" className="cursor-hand sort" onClick="${click}">
            <fmt:formatDate value="${record.end_work_time}" type="both" dateStyle="full" pattern="yyyy/MM/dd H:mm:ss"  />
             	</v3x:column>
	
	<v3x:column width="10%"  type="String" label="hr.record.checkoutTime.stated.label" onClick="${click}"
			value="${record.end_hour}:${record.end_minute}" className="cursor-hand sort" symbol="..." alt="${record.end_hour}:${record.end_minute}"
	></v3x:column>
	
	<v3x:column width="10%" type="String" label="hr.record.sign.out.ip.label" className="cursor-hand sort" 
		value="${record.signOutIP}" >
	</v3x:column>
	
	<v3x:column width="10%" type="String" label="hr.record.state.label"  className="cursor-hand sort" onClick="${click}">
            <fmt:message key="${record.state.state_name }" bundle="${v3xHRI18N}"/>
             	</v3x:column>
             	
	</v3x:table>
</form>
<script type="text/javascript">
	//showDetailPageBaseInfo("detailFrame", getA8Top().findMenuItemName(1204), [2,4], pageQueryMap.get('count'),  v3x.getMessage("HRLang.detail_hr_1204"));
</script>

</body>
</html>
