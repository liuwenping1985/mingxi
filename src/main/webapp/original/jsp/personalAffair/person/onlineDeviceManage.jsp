<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>在线设备管理</title>
<script type="text/javascript">
	//下线操作
	function offlineDevice(device) {
		var requestCaller = new XMLHttpRequestCaller(this, "onlineManager",
				"offlineDevice", false);
		requestCaller.addParameter(1, "String", device);
		var rs = requestCaller.serviceRequest();
		if (rs == "success") {
			var success = "<fmt:message key='kick.off.success'  bundle='${v3xCommonI18N}'/>";
			alert(success);
			$("#phoneDiv").hide();
		} else {
			var fail = "<fmt:message key='kick.off.fail'  bundle='${v3xCommonI18N}'/>";
			alert(fail);
		}
	}
	//更新移动登录提醒设置
	function updateMobileLoginRemind() {
		var isRemind = $("#mobileLoginRemind").attr("checked");
		var requestCaller = new XMLHttpRequestCaller(this, "onlineManager","updateMobileLoginRemind", false);
		var mobileLoginRemind = "disable";
		if (isRemind) {
			mobileLoginRemind = "enable";
		}
		requestCaller.addParameter(1, "String", mobileLoginRemind);
		var rs = requestCaller.serviceRequest();
	}
</script>
<style type="text/css">
.picDiv{
	float: left;
 	height: 55px;
    width: 20%; 
    padding-top: 20px;
    text-align:center;
}
.middleDiv{
	 float: left;
	 height: 55px;
	 width: 60%; 
	 padding-top: 20px;
	 font-size:12px;
}
.rightDiv{
	float: right; 
	height: 47px; 
	width: 20%; 
	padding-top: 28px;
	text-align:center;
	font-size:15px;"
}
</style>
</head>
<body style="background-color: #EDEDED;overflow:hidden;">
	<div class="layout_center over_hidden"  style="background-color: white; margin: 10px 50px 30px 50px; boarder: 1px #333">
			<div style="display: block" id="pcDiv">
			 <div class="picDiv" >
				<img  alt="pc图标" src="/seeyon/apps_res/personal/img/pc.png">
			 </div>
			<div class="middleDiv" >
				<span><fmt:message key='pc.device.online.label' /> </span>
				 <br/>
				<span><font color="grey">${pcDevice.onlineTime}</font></span>
			</div>
			<div class="rightDiv" >
				<span><font color="grey"><fmt:message key='self.device' /></font></span>
			</div>
			</div>
			<div style="clear: both;"></div>
			<c:if test='${not empty phoneDevice }' >
			<div  id="phoneDiv" style='display:block;' >
			<hr color="grey">
			  <div class="picDiv" >
				<img  alt="phone图标" src="/seeyon/apps_res/personal/img/phone.png">
			  </div>
			  <div class="middleDiv" >
			  	<span><fmt:message key='mobile.device.online.label' />${phoneDevice.type}</span>
			  	 <br/>
				<span><font color="grey" >${phoneDevice.onlineTime}</font></span>
			  </div>
			  <div class="rightDiv" >
				 <input type="button" onclick='offlineDevice("${phoneDevice.deviceName}")'
				style="cursor: pointer; border: 1px solid #3232CD; border-radius: 3px; width: 50px; height: 25px; color: #3232CD;font-size:15px"
				value=<fmt:message key='kick.off.label'/>>
			  </div>
			</div>
			<div style="clear: both;"></div>
			</c:if> 
	</div>
	<div>
		<label for="mobileLoginRemind" class="margin_t_5 hand">
		<input id="mobileLoginRemind" type="checkbox" ${MOBILE_LOGIN_REMIND != "enable"?"":"checked"} onchange="updateMobileLoginRemind()" />
		<fmt:message key='message.remind.mobile.login' /></label>
	</div>
</body>
</html>