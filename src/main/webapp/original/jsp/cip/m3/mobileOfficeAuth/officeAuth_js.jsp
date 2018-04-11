<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.apps.m1.authorization.resouces.i18n.MobileManageResources" var="mobileManageBundle"/>
<script type="text/javascript">
$(document).ready(function(){
	init();
	$('#btnok').click(function(){
		confirm();
	});
	$('#btncancel').click(function(){
		cancel();
	});
	$("#highSafeList").click(function(){
		var tempVal = $("#entityId").val();
		$.selectPeople({
		      type: 'selectPeople',
		      text:'${entityName}',
		      value:'${entityId}',
		      panels: 'Department,Team,Post,Outworker,RelatePeople',
		      selectType: 'Account,Department,Member,Team,Post',
		      minSize:0,
		      params: {value:tempVal},
		      showConcurrentMember:false,
		     // onlyLoginAccount: true,
		      returnValueNeedType: true,
		      isConfirmExcludeSubDepartment: true,
		      callback: function(ret) {
		    	  document.getElementById("highSafeList").value = ret.text;
		    	  document.getElementById("entityId").value = ret.value;
		    }
		});
	});
});
function init() {
	var success="${success}";
	var mes = "${mes}";
	if(success =="true"){
		alert(mes);
	} else {
		
	}
}
function confirm() {
	document.getElementById("form1").submit();
}
function cancel() {
	window.location = "<c:url value='/m3/mobileOfficeGuide.do'/>?method=index";
}
</script>
