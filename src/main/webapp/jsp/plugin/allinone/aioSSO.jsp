<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<script type="text/javascript">
<!--//
var aioClient;
var loginInf = {srv_ip:"${aioSrvIp}",prdt_code:"${PRODUCT_CODE_OA}",version:"${aioVersion}",type:"${aioType}",login_name:"${aioLoginName}"};
$(document).ready(function() {
	try{
		if(!StartAIOSrv()){
			return;
		}
		aioClient.login(loginInf.prdt_code,loginInf.version,loginInf.type,loginInf.login_name);
	    if(aioClient.ErrorDescription !=""){
	    	showMsg(1,"登录失败："+aioClient.ErrorDescription);
			return;
	    }
        selfShutDown();
	}catch(e){
		showMsg(1,"登录异常："+e.name+"："+e.message);
	}
});
function showMsg(imgType,msg){
	$.messageBox({
	    'title':'提示对话框',
        'type' : 0,
		'imgType':imgType,
        'msg' : msg,
        ok_fn : function() {
             selfShutDown();
    		}
      });
}
//创建客户端远程代理
function CreateAIOClientProxy() {
    try{
        aioClient = new ActiveXObject("U8AllInOne.ClientProxy");
		return true;
    }catch(e) {
    	showMsg(1,"创建客户端远程代理对象异常："+e.name+"："+e.message+"\n请检测是否正确安装客户端和U8ERP-PortalClient.msi。");
		return false;
    }
}

//启动客户端远程代理
function StartAIOSrv(){
	if (loginInf.srv_ip==""){
		showMsg(1,"U8ALLINONE服务器地址配置无效！");
		return false;
	}
	if(!CreateAIOClientProxy())
		return false;
	if (typeof(aioClient)=='undefined'){
		showMsg(1,"请安装U8ERP-PortalClient.msi或与管理员联系");
		return false;
	}
	aioClient.AllInOneWebServiceAddress = loginInf.srv_ip;
	aioClient.StartWebService();
    if(aioClient.ErrorDescription !=""){
    	var r = new RegExp("\n","g");
		var errorData = aioClient.ErrorDescription.replace(r,"<br>");
    	showMsg(1,errorData);
		return false;
    }
	return true;
}
function selfShutDown(){ 
	window.opener = ""; 
	window.close(); 
} 
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>U8ALLINONE</title>
</head>
<body>
</body>
</html>