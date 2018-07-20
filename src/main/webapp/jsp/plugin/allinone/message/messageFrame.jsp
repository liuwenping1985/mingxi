<%@page import="com.seeyon.apps.allinone.manager.IAioMessageManager"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "../seeyonoa/ui/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>All-in-One消息</title>
<%@include file="header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script>
var allInOneClient;

var allInOneWebServiceAddress = "${aioAddress}";
var curPageType;//全局变量，当前页签(ERP、CRM和PDM)
function init(){
	/* top.initYYOA(this,"All-in-One消息"); */
	curPageType = "${productCode}";
	getMessages(curPageType,1);
}
/**
 * 获取allinone产品的最新消息
 * mytype 页签类型
 * pageindex 页码
 */
function getMessages(mytype,pageindex){
	var index = 1;
	if(pageindex>1){
		index = pageindex;
	}
	var msgList = "";
	var msgType = "<%=IAioMessageManager.PRODUCT_1_U8ERP%>"
	if(mytype=='CRM'){
		msgType = "<%=IAioMessageManager.PRODUCT_4_CRM%>"
	}else if(mytype=='PLM'){
		msgType = "<%=IAioMessageManager.PRODUCT_5_PLM%>"
	}
	try{
		if(!StartAllInOneService()){
			return false;
		}
		msgList = allInOneClient.GetMessages("<%=IAioMessageManager.PRODUCT_CODE_OA%>","<%=IAioMessageManager.VERSION_ALL_IN_ONE%>",msgType,"${aioUserMappingBean.aioLoginName}","<pageinfo pagesize=\'30\' pageindex=\'"+index+"\' messagetype=\'\'/>");
		if(allInOneClient.ErrorDescription !=""){
	    	alert('<fmt:message key="allinone.message.get.error"/>'+allInOneClient.ErrorDescription);
	    	return false;
	    }
	}catch(e){
		//alert("嗯，貌似出错了："+e.description);
	}
	/* alert(document.frames("myframe").document.getElementById("flag").value); */
	 //通过获取到的window对象操作HTML元素，这和普通页面一样
	document.getElementById("msgList").value = msgList;
	document.getElementById("productCode").value = msgType;
	document.getElementById("flag").value = '0';
	document.getElementById("msgForm").submit();
	
}
/**
 * allinone客户端代码ActiveXObject对象
 */

//启动客户端远程代理
function StartAllInOneService(){
	if (allInOneWebServiceAddress==""){
		alert('<fmt:message key="allinone.message.address.error"/>');
		return false;
	}
	if(!CreateAllInOneClientProxy()){
		return false;
	}
	if (typeof(allInOneClient)=='undefined'){
		alert('<fmt:message key="allinone.message.client.error"/>');
		return false;
	}
	allInOneClient.AllInOneWebServiceAddress = allInOneWebServiceAddress;
    allInOneClient.StartWebService();
    if(allInOneClient.ErrorDescription !=""){
    	alert(allInOneClient.ErrorDescription);
    	return false;
    }
	return true;
}
//创建客户端远程代理
function CreateAllInOneClientProxy() {
    try{
        allInOneClient = new ActiveXObject("U8AllInOne.ClientProxy");
    }catch(e) {
    	alert("创建客户端远程代理对象异常："+e.name+"："+e.message+"\n请检测是否正确安装客户端和U8ERP-PortalClient.msi。");
    	return false;
    }
    return true;
}

</script>
</head>
<body class="overflow-hidden" onload="init();">
</div>
	<form action="/seeyon/u8AioMessageController.do?method=aioMessage" name="msgForm" id="msgForm" method="post">
		<input type="hidden" id="msgList" name="msgList" value="">
		<input type="hidden" id="productCode" name="productCode" value="">
		<input type="hidden" id="flag" name="flag" value="0">
	</form>
</body>
</html>
