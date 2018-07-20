<%@page import="com.seeyon.apps.allinone.manager.IAioMessageManager"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@include file="header.jsp"%>
<script type="text/javascript">
var allInOneClient;
var allInOneWebServiceAddress;
allInOneWebServiceAddress = "${aioAddress}";
function init(){
	var productCode = "${productCode}";
	var command = '${command}';
	try{
		StartAllInOneService();
		allInOneClient.ExecuteCommandLine("<%=IAioMessageManager.PRODUCT_CODE_OA%>","<%=IAioMessageManager.VERSION_ALL_IN_ONE%>",productCode,"${aioUserMappingBean.aioLoginName}",command);
	    if(allInOneClient.ErrorDescription !=""){
	    	alert('<fmt:message key="allinone.message.doit.failed.error"/>'+"："+allInOneClient.ErrorDescription);
	    }
	}catch(e){
		alert('<fmt:message key="allinone.message.doit.error"/>'+"："+e.description);
	}
}


//启动客户端远程代理
function StartAllInOneService(){
	if (allInOneWebServiceAddress==""){
		alert('<fmt:message key="allinone.message.address.error"/>');
		return false;
	}
	CreateAllInOneClientProxy();
	if (typeof(allInOneClient)=='undefined'){
		alert('<fmt:message key="allinone.message.client.error"/>');
		return false;
	}
	allInOneClient.AllInOneWebServiceAddress = allInOneWebServiceAddress;
    allInOneClient.StartWebService();
    if(allInOneClient.ErrorDescription !=""){
    	alert(allInOneClient.ErrorDescription);
    }
	
}
//创建客户端远程代理
function CreateAllInOneClientProxy() {
    try{
        allInOneClient = new ActiveXObject("U8AllInOne.ClientProxy");
    }catch(e) {
    	//alert("创建客户端远程代理对象异常："+e.name+"："+e.message+"\n请检测是否正确安装客户端和U8ERP-PortalClient.msi。");
    }
}
</script>
</head>
<body onload="init();">
</body>
</html>