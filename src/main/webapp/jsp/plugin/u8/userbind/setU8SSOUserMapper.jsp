<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.util.DateUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jsp/common/common.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/common/css/default.css">
<link rel="stylesheet" type="text/css" href="${path}/apps_res/systemmanager/css/css.css">
<link rel="stylesheet" type="text/css" href="${path}/apps_res/collaboration/css/collaboration.css">
<link rel="stylesheet" type="text/css" href="${path}/common/css/default.css">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>${ctp:i18n("u8.wborhr.title")}</title>
<OBJECT ID="runUC_U8Login" CLASSID="CLSID:F11BA142-3738-4632-9364-E873BA72DAA9" codebase="<%=request.getContextPath()%>/UFSoft.U8.Framework.Login.UI.dll" width=0 heigh=0></OBJECT>
<style type="text/css">
	#myselectAcc{
		overflow:auto;
	}
</style>
<script type="text/javascript">
//	showCtpLocation("U8person01");
	var msgerr = '${ctp:i18n("u8.initial.message.error")}';
	var logindate = '<%=DateUtil.getDate("yyyy-MM-dd")%>';
	var retFlag="${retType}";
	var uerName = '${user_name}';
	var obj;
		
$(document).ready(function() {
	var srvName='',accountNo='',accountYear='';	
    $("#btnUsrMappingSave").click(function() {
		if(parseInt(retFlag) == 0){
			if($.trim($("#u8_server_name_wb").val()) == ""){
				showMsg(1,'${ctp:i18n("u8.initial.fillwbserver.error")}');
				return;
			}
			if($.trim($("#wb_account_no").val()) == ""){
				showMsg(1,'${ctp:i18n("u8.sso.notnull.wbaccount.error")}');
				return;
			}
			if($.trim($("#wb_account_year").val()) == ""){
				showMsg(1,'${ctp:i18n("u8.sso.notnull.wbaccountyear.error")}');
				return;
			}
			srvName = $.trim($("#u8_server_name_wb").val());
			accountNo = $.trim($("#wb_account_no").val());
			accountYear = $.trim($("#wb_account_year").val());
		}
		else if(parseInt(retFlag) == 1){
			if($.trim($("#u8_server_name_zz").val()) == ""){
				showMsg(1,'${ctp:i18n("u8.initial.fillhrserver.error")}');
				return;
			}
			if($.trim($("#zz_account_no").val()) == ""){
				showMsg(1,'${ctp:i18n("u8.sso.notnull.hraccount.error")}');
				return;
			}
			if($.trim($("#zz_account_year").val()) == ""){
				showMsg(1,'${ctp:i18n("u8.sso.notnull.hraccountyear.error")}');
				return;
			}
			srvName = $.trim($("#u8_server_name_zz").val());
			accountNo = $.trim($("#zz_account_no").val());
			accountYear = $.trim($("#zz_account_year").val());
		}
		if(checkU8Info(parseInt(retFlag),uerName,$.trim($("#user_pwd").val()),srvName,accountNo,accountYear,logindate))
			return;
    	$("#frmUsrMapping").submit();
//		selfShutDown();
    });
	$("#chkIsSave").click(function(){
		$("#chkIsSave").val($("#chkIsSave").attr("checked")?"0":"1");
	});
});
function showMsg(imgType,msg){
	$.messageBox({
	    'title':'${ctp:i18n("u8.prompt.box")}',
        'type' : 0,
		'imgType':imgType,
        'msg' : msg
      });
}
function selfShutDown(){ 
	window.opener = ""; 
	window.close(); 
} 
	function checkU8Info(retFlag,username,password,server,account,accountyear,logindate){
		var isOK = true;
		var u8Xml= "";
		try{
			u8Xml = runUC_U8Login.GetDataSource_2(server,username);
			if(typeof(u8Xml)=="undefined"){
				if(retFlag == 0){
					showMsg(1,'${ctp:i18n("u8.initial.u8server.error")}');
				}else{
					showMsg(1,'${ctp:i18n("u8.initial.wborhr.error")}');
				}
				return true;
			}
		}catch(e){
			if(retFlag == 0){
				showMsg(1,'${ctp:i18n("u8.initial.u8server.error")}');
			}else{
				showMsg(1,'${ctp:i18n("u8.initial.wborhr.error")}');
			}
			return true;
		}
		var xmlDom;
		try{
		   xmlDom= new ActiveXObject("MSXML2.DOMDocument");
		}
		catch (e)
		{
		  throw '${ctp:i18n("u8.initial.xmlparse.error")}';
		}
		xmlDom.loadXML(LTrimCN(u8Xml));
		var root = xmlDom.documentElement;
		var temptable = new StringBuffer("");
		if (root.tagName=="ufsoft") {
			var fNodelist = root.childNodes;
				if (fNodelist!=null){
					var fNodelist = fNodelist[0].childNodes;
					if (fNodelist!=null){
					var flen = fNodelist.length;
					var facccode,faccname;
					temptable.append("<tr><td style=\"background:#DFDEDC; border-left:1px solid #FFFFFF; border-right:1px solid #ACA899; text-align:center;\">账套编码</td><td style=\"background:#DFDEDC; text-align:left; border-left:1px solid #fff;\">账套名称</td></tr>");
					for (var i = 0; i < flen; i++) {
						if (fNodelist[i].tagName == "DataSource"&&getXMLAttValue(fNodelist[i],"code")==account) {
							isOK=false;
						}
					}
				}
			}
		}
		if(isOK){
			showMsg(1,'${ctp:i18n("u8.initial.accountset.error")}');
			return true;
		}	
		if (retFlag == 0) {
			var oLogin;
			if (window.ActiveXObject && account != "") {
				oLogin = new ActiveXObject("U8Login.clsLogin");
				if(!oLogin.Login("DP", account, accountyear, username, password, logindate, server)){
					showMsg(1,'${ctp:i18n("u8.sso.loginfail.error")}');
					return true;
				}				
			}
		}else{
			if (!runUC_U8Login.login("GL", username, password, server, logindate, account, "")) {
				showMsg(1,runUC_U8Login.ErrDescript);
				return true;
			}
		}
		return false;
	}
		function check_account_no(image,index)
		{
			obj = image;
			var address;
			if(index == 2){
				address = document.getElementById("u8_server_name_wb").value;
				if(address.replace(/(^\s*)|(\s*$)/g, "").length<=0){
					alert('${ctp:i18n("u8.initial.fillwbserver.error")}');
					return;
				}
			}else if(index == 3){
				address = document.getElementById("u8_server_name_zz").value;
				if(address.replace(/(^\s*)|(\s*$)/g, "").length<=0){
					alert('${ctp:i18n("u8.initial.fillhrserver.error")}');
					return;
				}
			}
			try{
				var u8Xml = runUC_U8Login.GetDataSource_2(address,uerName);
			}catch(e){
				alert('${ctp:i18n("u8.setuser.alert.causes.error")}'+"：\n"+msgerr);
				return;
			}
			 var x = image.offsetLeft;
			 var y = image.offsetTop; 
			while(image=image.offsetParent)
		    {
		       x   +=   image.offsetLeft;  
		       y   +=   image.offsetTop;
		    }
			$("#myselectAcc").css("top",y+10);
		    $("#myselectAcc").css("left",x+10); 
			paraseXml(u8Xml);
		}
		
		function paraseXml(aXML){
			  var xmlDom;
			   try{
			      xmlDom= new ActiveXObject("MSXML2.DOMDocument");
			   }
			   catch (e)
			   {
			     throw '${ctp:i18n("u8.initial.xmlparse.error")}';
			   }
			   
			   xmlDom.loadXML(LTrimCN(aXML));
			   var root = xmlDom.documentElement;
			   var temptable = new StringBuffer("");
			   if (root.tagName=="ufsoft") {
			     var fNodelist = root.childNodes;
			     if (fNodelist!=null){
			       var fNodelist = fNodelist[0].childNodes;
			       if (fNodelist!=null){
			          var flen = fNodelist.length;
			          var facccode,faccname;
			          temptable.append("<tr><td style=\"background:#DFDEDC; border-left:1px solid #FFFFFF; border-right:1px solid #ACA899; text-align:center;\">"+'${ctp:i18n("u8.setuser.accountcode.label")}'+"</td><td style=\"background:#DFDEDC; text-align:center; border-left:1px solid #fff;\">"+'${ctp:i18n("u8.setuser.account.name.label")}'+"</td></tr>");
			          for (var i = 0; i < flen; i++) {
			             if (fNodelist[i].tagName == "DataSource") {
			                facccode=getXMLAttValue(fNodelist[i],"code");
			                faccname=getXMLAttValue(fNodelist[i],"name");
			                temptable.append("<tr style:\"cursor:hand\" ondblclick=\"selecUserAcc(this,'AccountNo')\" onMouseOver=\"this.style.background='#ACA899'\" onMouseOut=\"this.style.background='#F1F1EF'\"><td style=\"color:#575757;\" acccode=\""+ facccode +"\" nowrap>"+facccode+"</td><td style=\"color:#575757;\" align='left' nowrap>"+faccname+"</td></tr>");
			             }
			          }
			       }
			     }
			   }
			  /*  return temptable.toString(); */
			  document.all.table2.outerHTML = "<table id=\"table2\" style=\"width:298px;font-size:12px;\" cellspacing=\"0\">"+temptable.toString()+"</table>";
				try{
					changewidth();
					}catch(e){}
			}
		//根据table宽度去设置div的宽度
		function changewidth(){
			$("#myselectAcc").css("display","");
			$("#myselectAcc").css("width",$("#table2").css("width"));
			$("#table1").css("width",$("#table2").css("width"));
		}
		function LTrimCN(VALUE){
			  var w_space = String.fromCharCode(32);
			  var w_cr = String.fromCharCode(13);
			  var w_ln = String.fromCharCode(10);
			  if(v_length < 1){
			    return "";
			  }
			  var v_length = VALUE.length;
			  var strTemp = "";

			  var iTemp = 0;

			  while(iTemp < v_length){
			    if((VALUE.charAt(iTemp) == w_space) || (VALUE.charAt(iTemp) == w_cr) || (VALUE.charAt(iTemp) == w_ln)){
			    }
			    else{
			      strTemp = VALUE.substring(iTemp,v_length);
			      break;
			    }
			    iTemp = iTemp + 1;
			  } //End While
			  return strTemp;
			}
		function getXMLAttValue(aNode,aAttName){
			  if (aNode==null) return null;
			  if (aNode.attributes==null) return null;
			  var fatt=aNode.attributes.getNamedItem(aAttName);
			  if (fatt==null) return null;
			  return fatt.nodeValue;
			}
		
		function selecUserAcc(td){
			$(obj).parent().children("INPUT").val(td.children[0].getAttribute("acccode"));
			/* document.all.table2.style.display="none"; */
			document.all.myselectAcc.style.display="none";
		}
		function closeAcclist(){
			  myselectAcc.style.display="none";
			}
</script>
	</head>

	<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" onkeydown="return(!(event.keyCode==78&&event.ctrlKey))" oncontextmenu="self.event.returnValue =false">
	<form id="frmUsrMapping" name="frmUsrMapping" method="post" action="/seeyon/u8ReportHr.do?method=reportSave">
	  <input id="reportType" name="reportType" type="hidden" value="${reportType }"/>
	  <input id="user_pwd" name="user_pwd" type="hidden" value="${user_pwd }"/>
	  <table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:145">
	          <tr>
	            <td width="96%" id="mytd" align="center">              
	            <!-- summer -->
				<fieldset id="wbzz"><legend>&nbsp;&nbsp;<font size="2"><b><c:if test="${retType == '0'}">${ctp:i18n("u8.sso.wbinfo.label")}</c:if><c:if test="${retType == '1'}">${ctp:i18n("u8.sso.hrinfo.label")}</c:if></b></font>&nbsp;&nbsp;</legend><br><br>
					<table style="line-height:28px">
					<c:if test="${retType == '0'}">
						<tr class="wb">
							<td  height="20" class="r_word" align="right">${ctp:i18n("u8.initial.wbserver.label")}：</td>
							<td  height="20" align="left">
								<input type="text" value="${wb_server }" id="u8_server_name_wb" name="wb_server_name" style="width:144px;">
							</td>
						</tr>
						<tr class="wb">
							<td  height="20" class="r_word" align="right">${ctp:i18n("u8.initial.wbaccount.label") }：</td>
							<td  height="20" align="left">
							<input id="wb_account_no" name="wb_account_no" style="width:144px;HEIGHT:20;" type="text" value="${wb_account_no }"  ></input>
							<img border="0" style="cursor:hand" src="<c:url value='/common/images/search-gray.gif'/>" width="16" height="16" onClick="check_account_no(this,2);" title="点击连接U8服务器提取用户对应账套">
							</td>
						</tr>
						<tr class="wb">
						<td  height="20" class="r_word" align="right">${ctp:i18n("u8.initial.wbaccountyear.label") }：</td>
						<td  height="20" align="left"><input id="wb_account_year" name="wb_account_year" style="width:144px;HEIGHT:20;" type="text" value="${wb_account_year }"/></td>
						</tr>
						</c:if>
					    <c:if test="${retType == '1'}">
						<tr class="hr">
							<td  height="20" class="r_word" align="right">${ctp:i18n("u8.initial.hrserver.label") }：</td>
							<td  height="20" align="left">
								<input id="u8_server_name_zz" name="zz_server_name" style="width:144px;" type="text" value="${hr_server }">
							</td>
						</tr>
						<tr class="hr">
							<td  height="20" class="r_word" align="right">${ctp:i18n("u8.initial.hraccount.label") }：</td>
							<td  height="20" align="left">
							<input id="zz_account_no" name="zz_account_no" style="width:144px;HEIGHT:20;" type="text" value="${hr_account_no }" />
							<img border="0" style="cursor:hand" src="<c:url value='/common/images/search-gray.gif'/>" width="16" height="16" onClick="check_account_no(this,3);" title="点击连接U8服务器提取用户对应账套">
							</td>
						</tr>
						<tr class="hr">
							<td  height="20" class="r_word" align="right">${ctp:i18n("u8.initial.hraccountyear.label") }：</td>
							<td  height="20" align="left"><input id="zz_account_year" name="zz_account_year" style="width:144px;HEIGHT:20;" type="text" value="${hr_account_year }"/></td>
						</tr>
						</c:if>
					</table>
				</fieldset>
<div class="common_checkbox_box clearfix ">
    <label class="margin_r_10 hand" for="chkIsSave"><input id="chkIsSave" class="radio_com" name="chkIsSave" value="0" type="checkbox" checked="checked">${ctp:i18n("u8.sso.node.label") }</label>
</div>
	            </td>
	          </tr>
	  </table>
	  		<br>
	        <p align="center">
	          <a id="btnUsrMappingSave" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n("common.button.ok.label") }</a>
	  </p>
	  </form>

<div id="myselectAcc"  align="center" style="display:none; position:absolute; border:1px solid #737168; height:120px; left: 100px; top:200px; background:#F1F1EF;" title='${ctp:i18n("u8.initial.title.account.label")}' onClick="">
    <table border="0" width="100%" cellpadding="0" id="table1" cellspacing="0">
      <tr>
        <td align="left" valign="top" nowrap style="font-weight:bold; color:#FFFFFF; background:#7B99E1; line-height:18px; padding-left:5px; border-bottom:1px solid #C0C0C0;">${ctp:i18n("u8.initial.title.accountselect.label") }<br></td>
      </tr>
      <tr>
        <table id="table2">

        </table>
      </tr>
    </table>
    <div style="margin-top:30px; border-top:1px solid #D6D6D3; padding-top:5px;">
      <input type="button" value='${ctp:i18n("u8.common.cancel.label") }' name="B2" onClick="closeAcclist()" style="width:50">
    </div>
</div>
</body>
</html>