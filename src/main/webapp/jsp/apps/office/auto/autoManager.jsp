<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>车辆编辑</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script>
$(function() {
	fninitAutoMan();
});

/**
*	点击设置管理员或驾驶员事件
*/
function fninitAutoMan(){
	var _type = window.parentDialogObj["manOrdriver"].getTransParams();
	if(_type==="manager"){ //设置管理员
		var ajaxM = new autoInfoManager();
		var managers = ajaxM.listAutoManager();
		for(var i = 0 ; i < managers.length ; i ++) {
			var arrValue = new Array();
			arrValue.push(managers[i].id);
			arrValue.push(managers[i].name);
			var id = "checkBox"+i;
			$("#autoManDiv").append("<label class='margin_t_5 hand display_block' for='"+id+"'>"+
					"<input id='"+id+"' class='radio_com' name='option' value='"+arrValue+"' type='checkbox'>"+managers[i].name+"</label>");
		}
	}else if(_type==="driver"){//设置驾驶员
		var ajaxM = new autoDriverManager();
		var drivers = ajaxM.getAll();
		for(var i = 0 ; i < drivers.length ; i ++) {
			var arrValue = new Array();
			arrValue.push(drivers[i].id);
			arrValue.push(drivers[i].memberName);
			var id = "checkBox"+i;
			$("#autoManDiv").append("<label class='margin_t_5 hand display_block' for='"+id+"'>"+
					"<input id='"+id+"' class='radio_com' name='option' value='"+arrValue+"' type='radio'>"+drivers[i].memberName+"</label>");
		}
	}
}
function OK(){
	var selected = $("input[name='option']");
	var objs = new Array();
	for(var i=0;i<selected.length;i++){
		if(selected[i].checked){
			objs.push(selected[i].value);
		}
	}
	return objs;
}
</script>
</head>
<body class="h100b w100b over_auto">
	<div class="w100b ">
		<div id="autoManDiv" class="common_checkbox_box clearfix" style="margin: 40px">
		</div>
	</div>
</body>
</html>