<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<title><fmt:message key="deletePeople.label" bundle="${colI18N}" /></title>
<script type="text/javascript">
var processId = "${processId}";
<!--
function ok(){
    var people = [];
    var userName=[];
    var userType=[];
    var accountId = [];
    var accountShortname = [];
    var activityId = [];

    $("INPUT").each(function() {
        if (this.name == "deletePeople" && this.checked) {
            people[people.length] = this.value;
            userName[userName.length] = this.pname;
            userType[userType.length] = this.ptype;
            accountId[accountId.length] = this.paccountId;
            accountShortname[accountShortname.length] = this.paccountShortName;
            activityId[activityId.length] = this.pActivityId;
        }
    });
    
    if (people.length == 0) {
        alert(v3x.getMessage('edocLang.eodc_least_select_singleton'));
        return false;
    }

	window.returnValue = [people, userName, userType, accountId, accountShortname, activityId];
	window.close();
}
//-->
</script>
</head>
<body scroll="no" style="overflow: hidden" onkeydown="listenerKeyESC()">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key="collaboration.deletePeople.select.label" bundle="${colI18N}" /></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
			<div class="scrollList" style="border: solid 1px #666666;">
				<table class="sort" width="100%"  border="0" cellspacing="0" cellpadding="0" onClick="sortColumn(event, true)">
				<thead>
				<tr class="sort">
					<td width="5%" align="center"><input type='checkbox' id='allCheckbox' onclick='selectAll(this, "deletePeople")'/></td>
					<td type="String"><fmt:message key="common.name.label" bundle="${v3xCommonI18N}" /></td>
				</tr>
				</thead>
				<tbody>
				<c:set value="${col:showDecreaseNode(flowData)}" var="data" />
				<c:choose>
					<c:when test="${data == null}">
						<tr class="sort">
							<td align="center" class="sort" colspan="2"><fmt:message key="collaboration.deletePeople.nobody.label"  bundle="${colI18N}"/></td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach items="${data}" var="d">
						<tr class="sort">
							<td align="center" class="sort" width="5%">${d[0]}</td>
							<td class="sort" type="String">${d[1]}</td>
						</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
				</tbody>
				</table>
			</div>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="button" onclick="ok()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;
			<input type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
</body>
</html>