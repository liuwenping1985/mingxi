<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.apps.m1.authorization.resouces.i18n.MobileManageResources" var="mobileManageBundle"/>
<script type="text/javascript"
src="${path}/ajax.do?managerName=mClientBindService"></script>
<script type="text/javascript">
$(document).ready(function(){
	init();
	var mBinded = new mClientBindService();
	$("#button_area").hide();
	$('#btnok').click(function(){
		confirm();
	});
	$('#btncancel').click(function(){
		$("#button_area").hide();
		cancel();
	});
	$("#highSafeList").click(function(){
		var tempVal = $("#entityId").val();
		$.selectPeople({
		      type: 'selectPeople',
		      text:'${entityName}',
		     // value:'${entityId}',
		      panels: 'Department,Outworker',
		      selectType: 'Member',
		      minSize:0,
		      params: {value:tempVal},
		      showConcurrentMember:false,
		      onlyLoginAccount: true,
		      returnValueNeedType: false,
		      callback: function(ret) {
		    	  document.getElementById("highSafeList").value = ret.text;
		    	  document.getElementById("entityId").value = mBinded.checkEntityIds(ret.value);
		    }
		});
	});
	
	$("#toolbar").toolbar({
	    toolbar: [{
	    
	      id: "edit",
	      name: "${ctp:i18n('common.button.modify.label')}",
	      className: "ico16 editor_16",
	      click:function(){
	    	  $("#button_area").show();
	    	  $('#highSafeList').attr("disabled",false);
	      }
	    }]
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
	window.location = "<c:url value='/m1/mClientBindController.do'/>?method=toSetSafeLevel";
}
</script>
