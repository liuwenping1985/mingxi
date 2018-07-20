<%@page import="com.seeyon.apps.allinone.manager.IAioMessageManager"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "../seeyonoa/ui/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<!-- <script type="text/javascript" src="../seeyonoa/common/js/common.js"></script>

<link href="../seeyonoa/ui/style/common.css" rel="stylesheet"/>
<link href="../seeyonoa/ui/style/business.css" rel="stylesheet"/> -->
<title>All-in-One消息</title>
<%@include file="header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script>
//导航菜单
showCtpLocation("aio_person08");
var allInOneClient;

var allInOneWebServiceAddress = "${aioAddress}";
var curPage = parseInt("${curPage}");//全局变量，当前页面是消息列表第几页
var curPageType;//全局变量，当前页签(ERP、CRM和PDM)
var pageCount = parseInt("${pageCount}");
var mytypeOld = "${mytype}"; 
function init(){
}
//页签切换
function change(mytype){
	document.getElementById("productCode").value = mytype;
	document.getElementById("msgForm").submit();
}

//穿透用友子产品中
function doIt(productCode,command){
	if(command.length<1){
		alert('<fmt:message key="allinone.message.doit.notsupport.error"/>');
		return true;
	}
	document.getElementById("myform").productCode.value=productCode;
	document.getElementById("myform").command.value=command;
	document.getElementById("myform").submit();
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
<body class="overflow-hidden" onload="init();">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
    	<table class="border-left border-right border-top" height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
    		<tr>
				<td height="22" class="webfx-menu-bar">
	
				<script>
				var _mode = parent.parent.WebFXMenuBar_mode || 'blue'; //取得HR外围frame中的菜单样式
				var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />",_mode);
				myBar.add(new WebFXMenuButton("mod","U8","change('U8')","<c:url value='/common/images/toolbar/update.gif'/>","U8", null));
				myBar.add(new WebFXMenuButton("mod","PLM","change('PLM')","<c:url value='/common/images/toolbar/update.gif'/>","PLM", null));
				document.write(myBar);
		    	document.close();
				</script>
				</td>
			</tr>
    	</table>
    </div>
    <div class="center_div_row2 overflow-hidden" id="scrollListDiv" ">
    <form id="userMapperForm" method="post" action="/seeyon/u8AioMessageController.do?method=aioMessage" target="exportIFrame" >
	<v3x:table htmlId="userMapperlist" data="list" var="msg" showHeader="true" className="sort ellipsis">
	<c:set var="dbclick" value="doIt('${msg.productcode}','${msg.command}')"/>
	<v3x:column width="10%" align="left" label="allinone.message.sender.label" type="String"
					value="${msg.sender}" className="cursor-hand sort" 
					 alt="${msg.sender}" onClick="" onDblClick="${dbclick}"/>
	<v3x:column width="10%" align="left" label="allinone.message.receive.label" type="String"
					value="${msg.receiver}" className="cursor-hand sort" 
					 alt="${msg.receiver}" onClick="" onDblClick="${dbclick}"/>
	<v3x:column width="15%" align="left" label="allinone.message.time.label" type="String"
			value="${msg.sendDate}" className="cursor-hand sort" 
		 alt="${msg.sendDate }" onClick="" onDblClick="${dbclick}"/>
	<v3x:column width="45%" align="left" label="allinone.message.content.label" type="String"
			value="${msg.title}" className="cursor-hand sort" 
		 alt="${msg.title}" onClick="" onDblClick="${dbclick}"/>
	<v3x:column width="10%" align="left" label="allinone.message.type.label" type="String"
			value="${msg.msgtype}" className="cursor-hand sort" 
		 alt="${msg.msgtype}" onClick="" onDblClick="${dbclick}"/>
	<v3x:column width="10%" align="left" label="allinone.message.status.label" type="String"
			value="${msg.msgstate}" className="cursor-hand sort" 
		 alt="${msg.msgstate}" onClick="" onDblClick="${dbclick}"/>
	</v3x:table>
	
   </form>
    </div>
</div>
</div>
	<form action="/seeyon/u8AioMessageController.do?method=aioMessage" name="msgForm" id="msgForm" method="post">
		<input type="hidden" id="productCode" name="productCode" value="">
	</form>
	<form action="/seeyon/u8AioMessageController.do?method=command" name="myform" id="myform" target="myframe" method="post">
		<input type="hidden" name="productCode" value="">
		<input type="hidden" name="command" value="">
	</form>
</body>
</html>
