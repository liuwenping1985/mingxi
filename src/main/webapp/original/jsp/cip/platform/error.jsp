<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<title>Insert title here</title>
</head>
<script type="text/javascript">
$().ready(function(){
	$("#example").click(function(){
		var dialog = getCtpTop().$.dialog({
            url:"${path}/cip/appIntegrationController.do?method=showExample&enumKey="+$("#enumKey").val(),
            width: 900,
            height: 500,
            title: "${ctp:i18n('cip.plugin.message.example.view')}",//示例查看
            buttons: [{
                text: "${ctp:i18n('common.button.cancel.label')}", //取消
                handler: function () {
                    dialog.close();
                }
            }]
    	});
	});
	if($("#enumKey").val()==""||$("#enumKey").val()==null){
		$("#example").unbind("click");
		$("#examplebutton").hide();
		
	}
	
});
</script>
<body>
	<form name="addForm" id="addForm" method="post" target="delIframe">
	<div class="form_area" >
		<div class="one_row" style="width:35%; margin-top: 100px;" >
			<div align="center"><img alt="" src="/seeyon/apps_res/cip/common/img/1.png"></div>
			<div align="center" style="margin-top: 10px;margin-bottom: 30px;"><span><font color="#A8A8A8" size="4">${errMsg}</font></span></div>
			<div align="center" id="examplebutton"><a href="javascript:void(0)" id="example" class="common_button common_button_emphasize">${ctp:i18n('cip.plugin.message.example')}</a></div>
			<input type="hidden" id="enumKey" value="${pluginEnum.key}">
		</div>
	</div>
	</form>
</body>
</html>