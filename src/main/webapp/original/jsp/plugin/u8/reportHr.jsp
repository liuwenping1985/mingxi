<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.seeyon.apps.u8.po.U8UserMapperBean"%>
<%@page import="com.seeyon.apps.u8.manager.U8ReportHrManager"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.lang.Exception"%>
<%@page import="com.seeyon.ctp.common.AppContext"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%
	String token = "";
	String retStr = "";
	String U8_Flag = (String)request.getAttribute("U8_Flag");
	String reportType = (String)request.getAttribute("U8_MenuId");
	if(("NE0102".equals(reportType) || "NE0103".equals(reportType) || "NE0104".equals(reportType)) && !"1".equals(U8_Flag)){
		Date date = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		String loginDate = format.format(date);
		U8UserMapperBean u8Bean = (U8UserMapperBean)request.getAttribute("u8Bean");
		U8ReportHrManager u8ReportHrManager = (U8ReportHrManager)AppContext.getBean("u8ReportHrManager");
		token = u8ReportHrManager.getU8Token(u8Bean,loginDate);
		if(token.indexOf("u8err:") > -1){
			U8_Flag = token.replace("u8err:", "");
			U8_Flag = token.replaceAll("\"", "");
		}else{
			U8_Flag = "0";
			retStr = token;
			request.setAttribute("retStr", retStr);
		}
	}
		
%>
<html>
<head>
<script type="text/javascript">
<!--
//
var loginInf = {zt:"${account_no}",year:"${account_year}",date:"${login_date}",uid:"${U8_UserNumber}",pwd:"${U8_Password}",server:"${U8_Server_Address}",menuid:"${U8_MenuId}",webaddress:"${u8_web_address}"};
var U8_Flag = "<%=U8_Flag%>";
$(function(){
	var U8Token = $("#u8Txt").val();
	if(parseInt(U8_Flag) != 0){
		webReportErrorMsg();
		return;
	}
	if(loginInf.menuid == "NE0306"){
		webReportLogin(loginInf);
	}
	else{
		hrshow(loginInf,U8Token);
	}
	
});
function selfShutDown(){ 
	window.opener = ""; 
	window.close(); 
} 

function chkU8Srv(loginmsg){
/*	var head = document.getElementsByTagName("head")[0];         
    var longinScript = document.createElement("script");         
    longinScript.src = "http://" +loginInf.server+"/u8sl/default.asp";         
//    longinScript.src = "http://192.168.1.222/u8sl/default.asp";         
    longinScript.onload = longinScript.onreadystatechange = function()         
	{         
    	if (!this.readyState || this.readyState == "loaded" || this.readyState == "complete")         
		{     
         head.removeChild(longinScript);     
         webReportLogin(loginmsg);    
    	} 
//		alert(this.readyState);
	}         
	head.appendChild(longinScript); 
*/	
	var url = "http://"+loginmsg.webaddress+"/u8sl/default.asp";
//	debugger;
	loadScript(url, test); 
/*	if (window.XDomainRequest){
		var xdr = new XDomainRequest();
		if(xdr){
          	xdr.onerror = function(){alert(1)};
          	xdr.ontimeout = function(){alert(2)};
          	xdr.onprogress = function(){alert(3)};
          	xdr.onload = function(){alert(4)};;
			xdr.timeout = 10000;
          	xdr.open("get", url);
          	xdr.send();
		}
		else{
			alert(5);	
		}
	}
	else{
		alert(6);	
	}
*/
}

function loadScript(src, callback) {  
	var u8Script = document.createElement('script');  
    u8Script.setAttribute('language', 'javascript');  
    u8Script.setAttribute('src', src);
	
	
	var obj = document.getElementsByTagName("head")[0];
//	var obj = document.body;
	alert(document.readyState);
//	obj.appendChild(u8Script);
    if(document.all) {  
        u8Script.onreadystatechange = function() {  
            if(this.readyState == 4 || this.readyState == 'complete' || this.readyState == 'loaded') {  
                callback();  
           }  
        };  
    } 
	else {  
        u8Script.onload = function() {  
            callback();  
        };  
    }  
}  

function test(){
alert(1);
//	alert(document.getElementsByTagName("head")[0].innerHTML);
//    document.getElementsByTagName("head")[0].appendChild(u8Script);  
}

function errorMessageTip(){
	$.popDialog({
		//title:'提示对话框',
	    ico:'tell',
	    content:"必须先设置U8登录设置的操作员",
	    buttons:{
			确定:function(){
				this.close();
			}
	    }
	});
}

function webReportLogin(loginmsg){
	var url = "http://" + loginmsg.webaddress + "/U8SL/Login.aspx";
	var name = "";
	var keys = ["loginData"];
	var data = loginmsg;
	var sessionInfo = '{"PSubId":"DP","AppServer":"' + data.server + '","UserId":"' + data.uid + '","Password":"' + data.pwd + '",';
	sessionInfo += '"DataSource":"' + data.zt + '","OperDate":"' + data.date + '","Language":"zh-CN","RSAKeyID":"",';
	sessionInfo += '"MenuId":"' + data.menuid + '"}';
	var values = [sessionInfo];
	openWindowWithPost(url,"",keys,values);
	selfShutDown();
}

function hrshow(loginmsg,token){
		try{
			 var url;
			 var type= loginmsg.menuid;
			 if("NE0102" == type){
			 //工资查询
			 	url =  'http://'+loginmsg.webaddress+'/U8Portal/DesktopModules/HR/SS/BridgePage.aspx?cSender=OA&CMenuID=SS010601&cMsgInfo=P_SalarySearch&token='+token+'&psn='+loginmsg.uid;
			 }else if("NE0103" == type){
			 //考勤查询
			 	url = 'http://'+loginmsg.webaddress +'/U8Portal/DesktopModules/HR/SS/BridgePage.aspx?cSender=OA&CMenuID=SS010701&cMsgInfo=P_TMSeach&token='+token+'&psn='+loginmsg.uid;
			 }else if("NE0104" == type){
			 //考勤申请
			 	url = 'http://'+loginmsg.webaddress+'/U8Portal/DesktopModules/HR/SS/BridgePage.aspx?cSender=OA&CMenuID=SS010703&cMsgInfo=P_Leave&token='+token+'&psn='+loginmsg.uid;
			 }
			 //linkWorkSpace(url);
			 //var msg=showModalDialog(url,window,'dialogWidth='+width+'px;dialogHeight='+height+'px;resizable=no;');
			 //V11.1中取消了信任站点的添加 单点登录hr做对应修改
			 openWindowWithPost(url,'','','');
			 selfShutDown();
			}catch(e){
				alert(strtitle);
				return;
			}
		}

function webReportErrorMsg(){
	var type = loginInf.menuid;
	var style ="";
	var msgerr;
	if(type=="NE0306"){
		msgerr = "访问U8网上报销异常,出现问题的可能原因:<br>1.U8系统中未启用网报产品;<br>2.U8网报若是分离部署,请系统管理员检查是否设置U8网报服务器信息;<br>3.当前登录人员不是从U8操作员同步的或U8登录信息未设置;<br>4.当前登录人员没有U8网报权限;";
	}else if(type=="NE0102"){
		style = "工资查询";
	}else if(type=="NE0103"){
		style = "考勤查询";
	}else if(type == "NE0104"){
		style = "考勤申请";
	}else{
		msgerr = "访问U8网上报销或HR自助服务异常,出现问题的可能原因:<br>1.U8系统中未启用对应产品;<br>2.U8服务若是分离部署,请系统管理员检查是否设置其服务器信息;<br>3.当前登录人员不是从U8操作员同步的或U8登录信息未设置;<br>4.当前登录人员没有服务权限;";
	}
	if(style!=""){
		msgerr = "访问U8"+style+"异常,出现问题的可能原因:<br>1.U8系统中未启用HR自助产品;<br>2.U8HR自助若是分离部署,请系统管理员检查是否设置U8HR自助服务器信息;<br>3.当前登录人员不是从U8操作员同步的或U8登录信息未设置;<br>4.当前登录人员没有U8HR自助权限;";
	}
	$.messageBox({
	    'title':'提示对话框',
        'type' : 0,
		'imgType':1,
        'msg' : msgerr,
        ok_fn : function() {
          selfShutDown();
        }
      });
}

function openWindowWithPost(url, name, keys, values) {
    var sWidth = window.screen.availWidth - 10;
    var sHeight = window.screen.availHeight - 85;
    var newWindow = window.open('', name, 'top=0,left=0,toolbar=no,menubar=no,location=yes,resizable=yes,status=yes,Width=' + sWidth + ',height=' + sHeight);
    if (!newWindow) return false;
    var html = "";
    html += "<html><head></head><body><form id='postformid' method='post' action='" + url + "'>";
    if (keys && values && (keys.length == values.length)) {
        for (var i = 0; i < keys.length; i++)
            html += "<input type='hidden' name='" + keys[i] + "' value='" + values[i] + "'/>";
    }
    html += "</form><script type='text/javascript'>document.getElementById(\"postformid\").submit()</script></body></html>";
    newWindow.document.write(html);
    return newWindow;
}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>U8</title>
</head>
<body>
<textarea id="u8Txt" style="display:none"><%=token %></textarea>
</body>
</html>