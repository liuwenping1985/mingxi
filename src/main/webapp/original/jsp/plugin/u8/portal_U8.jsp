<%@page import="com.seeyon.ctp.util.DateUtil"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page session="true" isThreadSafe="true"%>
<html>
<%@include file="header.jsp"%>
<head>
<title></title>

<style>
<!--
#tim{position:absolute;left:0px;top:1px;width:450px;height:100px;}
-->
</style>

<OBJECT id='clientOA' classid='CLSID:C3474273-859B-444A-AA12-FA4BF8D0DCD7' style='display:none' codebase="<%=request.getContextPath()%>/U8WebClient.CAB#version=8,60,0,1">
  <PARAM NAME='_ExtentX' VALUE='0'>
  <PARAM NAME='_ExtentY' VALUE='0'>
</OBJECT>
<OBJECT ID="runUC_CS" CLASSID="CLSID:0EB1A30A-D7BB-40BE-8A13-EB5C1A2CA8D8" codebase="<%=request.getContextPath()%>/OpenUC.dll" width=0 heigh=0></OBJECT>
<OBJECT ID="runUC_U8Login" CLASSID="CLSID:F11BA142-3738-4632-9364-E873BA72DAA9" codebase="<%=request.getContextPath()%>/UFSoft.U8.Framework.Login.UI.dll" width=0 heigh=0></OBJECT>
 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<link type="text/css" rel="stylesheet" href="<c:url value='/common/js/u8/DocMgr.css'></c:url>" id="menuStyleSheet">
<style type="text/css">
	#myselectAcc{
		overflow:auto;
	}
</style>
<SCRIPT src="<c:url value='/common/js/u8/selAccount.js'></c:url>" type="text/javascript"></SCRIPT>

<script>
	showCtpLocation("U8person02");
	var logindate = '<%=DateUtil.getDate("yyyy-MM-dd HH")%>'+":00";
	var msgerr = '<fmt:message key="u8.portal.alert.message.error"/>';
	var cause = '<fmt:message key="u8.setuser.alert.causes.error"/>';
	function init(){
		document.getElementById("U8LoginDate").value = logindate;
  		/* top.initYYOA(this,"U8集成－U8企业门户"); */
		linkage(document.getElementById("u8servername"));
  
	}
	//更具table宽度去设置div的宽度
	function changewidth(){
		$("#myselectAcc").css("width",$("#table2").css("width"));
		$("#table1").css("width",$("#table2").css("width"));
	}
	function changeView(obj){
		/* var value=obj.value;
		if(value>=3){
			document.all.webportalbtn.style.display = "";
			document.all.csportalbtn.value = "U8 应用平台登录";
		}else{
			document.all.webportalbtn.style.display = "none";
			document.all.csportalbtn.value = "U8 应用平台登录";
		} */
	}
	
	function linkage(obj){
		var serverName = obj.value;
		if(obj.options.length<=0){
			return;
		}
		var version =  obj.options[obj.selectedIndex].getAttribute("version");
		if(version == "110"){
			document.getElementById("u8ver").value ="1";
		}
		if(version == "111"){
			document.getElementById("u8ver").value ="2";
		}
		if(serverName != "${bean.serverName}"){
			document.getElementById("userNumber").value = "";
			document.getElementById("password2").value = "";
			document.getElementById("account_no").value = "";
			document.getElementById("account_year").value = "";
		}else{
			document.getElementById("userNumber").value = "${bean.perator}";
			document.getElementById("password2").value = "${bean.password }";
			document.getElementById("account_no").value = "${bean.accountNo}";
			document.getElementById("account_year").value = "${bean.accountYear}";
		}
	}
	
	function check(){
		var u8server = document.getElementById("u8servername");
		if(u8server.options.length<=0){
			alert('<fmt:message key="u8.setuser.alert.noserver.error"/>');
			return;
		}
		showacclist(document.all.u8servername.options[document.all.u8servername.selectedIndex].getAttribute("selfdef"),document.all.userNumber.value);
	}
	
	//选择U8对应的账套
	function showacclist(servername,u8user){
		if (u8user==null || u8user=="" || LTrimCN(document.getElementById("userNumber").value)==""){
	    	alert('<fmt:message key="u8.initial.filloperator.error"/>');
	    	return;
	 	}
		var u8Xml;
		try{
			u8Xml = runUC_U8Login.GetDataSource_2(servername,u8user);
		}catch (e){
	   		alert(cause+"：\n"+msgerr);
	   		return;
		}
		myselectAcc.style.display="block";
		paraseXml(u8Xml);
	}
	
	function paraseXml(aXML){
		   try{
		      xmlDom= new ActiveXObject("MSXML2.DOMDocument");
		   }
		   catch (e)
		   {
		     throw '<fmt:message key="u8.initial.xmlparse.error"/>';
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
		          temptable.append("<tr><td style=\"background:#DFDEDC; border-left:1px solid #FFFFFF; border-right:1px solid #ACA899; text-align:center;\">"+'<fmt:message key="u8.setuser.accountcode.label"/>'+"</td><td style=\"background:#DFDEDC; text-align:center; border-left:1px solid #fff;\">"+'<fmt:message key="u8.setuser.account.name.label"/>'+"</td></tr>");
		          for (var i = 0; i < flen; i++) {
		             if (fNodelist[i].tagName == "DataSource") {
		                facccode=getXMLAttValue(fNodelist[i],"code");
		                faccname=getXMLAttValue(fNodelist[i],"name");
		                temptable.append("<tr style:\"cursor:hand\" ondblclick=\"selecUserAcc(this)\" onMouseOver=\"this.style.background='#ACA899'\" onMouseOut=\"this.style.background='#F1F1EF'\"><td style=\"color:#575757;\" acccode=\""+ facccode +"\" nowrap>"+facccode+"</td><td style=\"color:#575757;\" nowrap>"+faccname+"</td></tr>");
		             }
		          }
		       }
		     }
		   }
		   document.all.table2.outerHTML = "<table id=\"table2\" style=\"width:298px;\" cellspacing=\"0\">"+temptable.toString()+"</table>";
		   try{
				changewidth();
				}catch(e){}
		}
	
	function checkneeddata(){
		var u8server = document.getElementById("u8servername");
		if(u8server.options.length<=0){
			alert('<fmt:message key="u8.setuser.alert.noserver.error"/>');
			return;
		}
	  	if (LTrimCN(document.getElementById("userNumber").value)==""){
	  		alert('<fmt:message key="u8.initial.filloperator.error"/>');
	    	return false;
	  	}
	  	if (document.getElementById("account_no").value==null || LTrimCN(document.getElementById("account_no").value)==""){
	   	 	alert('<fmt:message key="u8.portal.fillaccount.error"/>');
	    	return false;
	  	}
	  	var accountYear = document.all.account_year.value;
	  	if (accountYear==null || accountYear.replace(/(^\s*)|(\s*$)/g, "").length<=0){
		  	alert('<fmt:message key="u8.initial.fillaccountyear.error"/>');
		  	return false;
	  	}
	  	if(accountYear.replace(/(^\s*)|(\s*$)/g, "").length!=4){
		  	alert('<fmt:message key="u8.portal.fillaccountyear.error"/>');
		 	return false;
	  	}
	  	var year = parseInt(accountYear);
	  	if(year < 1000 || year >9999 || isNaN(year)){
	  		alert('<fmt:message key="u8.portal.fillaccountyear.error"/>');
		  	return false;
	  	}
	  	return true;
	}
	
	function CheckRequestState(oHttpReq){
  		var result = 0;// zero is ok code.
  		switch(oHttpReq.status){
      	case 404:{
             alert('<fmt:message key="u8.portal.message404.error"/>');
             result = 404;
             break;
      	}
      	case 403:{
             alert('<fmt:message key="u8.portal.message403.error"/>');
             result = 403;
             break;
      	}
      	case 500:{
             alert('<fmt:message key="u8.portal.message500.error"/>');
             result = 500;
             break;
      	}
  }
  return result;
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" onLoad="init()" leftmargin="0" topmargin="0" onkeydown="return(!(event.keyCode==78&&event.ctrlKey))" oncontextmenu="self.event.returnValue =false">
  <span><!-- <img src="/seeyon/common/images/toolbar/u8_portal.gif" width="454" height="100"> --></span><br><br>
<center>
  <table width="51%" border="0" cellpadding="0" cellspacing="0" style="margin-top:10px">
          <tr>
            <td width="96%" align="center">              <fieldset><legend>&nbsp;&nbsp;<font size="2"><b><fmt:message key="u8.portal.label"/></b></font>&nbsp;&nbsp;</legend><br><br>
<table bgcolor="#ffffff" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td width="100%"></td>
    </tr>
    <tr>
      <td>
  <div align="center">
    <form name="myform" method="post" action="">
                  <table width="480" border="0" cellpadding="0" cellspacing="0" style="line-height:30px">
                  <tr>
                      <td height="20" style="width:95px" nowrap><fmt:message key="u8.server.label"></fmt:message>：</td>
                      <td height="20" nowrap>
                      <select id="u8servername" name="u8servername" style="WIDTH: 144; HEIGHT: 20" onchange="linkage(this);">
                      			<c:forEach  var="server" items="${serverList}">
                      				<c:if test="${server.has_u8 eq 1}">
                      					<c:choose>
                      						<c:when test="${(bean!=null && bean.serverName==server.u8_server_name)}">
                      							<option value="${server.u8_server_name}" selected="selected" title="${server.u8_server_name}" version="${server.u8_version}" u8_web_address="${server.u8_web_address}" has_wb="${server.has_wb}" has_zz="${server.has_zz}" selfdef="${server.u8_server_address}">${server.u8_server_name}</option>
                      						</c:when>
                      						<c:otherwise>
                      							<option value="${server.u8_server_name}" title="${server.u8_server_name}" version="${server.u8_version}" u8_web_address="${server.u8_web_address}" has_wb="${server.has_wb}" has_zz="${server.has_zz}" selfdef="${server.u8_server_address}">${server.u8_server_name}</option>
                      						</c:otherwise>
                      					</c:choose>
                 					</c:if>
                 				</c:forEach>
                      		</select>
                     </td>
                    </tr>
                   <tr>
                      <td  height="20" style="width:95px" nowrap><fmt:message key="u8.bind.account.label"/>：
                      </td>
                      <td  height="20" nowrap>
                          <input id="userNumber" name="userNumber" size="24" type="text" value="${bean.perator }" style="WIDTH: 144; HEIGHT: 20">
                      </td>
                    </tr>
                    <tr>
                      <td  height="20" style="width:95px" nowrap><fmt:message key="u8.initial.password.label"/>：
                      </td>
                      <td  height="20" nowrap>
                        <input id="password2" name="password" size="24" type="password" value="${bean.password }" style="WIDTH: 144; HEIGHT: 20" >
                      </td>
                    </tr>
                    <tr>
                      <td height="20" style="width:95px" nowrap><fmt:message key="u8.setuser.account.label"/>：</td>
                      <td height="20" nowrap>
                        <input id="account_no" name="account_no" size="24" type="text" value="${bean.accountNo }" style="WIDTH: 144; HEIGHT: 20" />
                        <img border="0" src="<c:url value='/common/images/search-gray.gif'/>" width="16" height="16" onClick='check();' title="点击连接U8服务器提取用户对应账套">
                      	<fmt:message key="u8.setuser.like.label"/>：(default)@001
                      </td>
                      
                    </tr>
                    <tr>
                      <td height="20" style="width:95px" nowrap><fmt:message key="u8.setuser.accountyear.label"/>：</td>
                      <td height="20" nowrap>
                         <input maxlength="24" id="account_year" name="account_year" size="24" type="text" value="${bean.accountYear }" style="WIDTH: 144; HEIGHT: 20">
                      </td>
                    </tr>
                    <tr>
                        <td align="right" height="20" style="width:95px" nowrap ><div align="left"><fmt:message key="u8.setuser.logindate.label"/>：</div></td>
                        <td>
                          <input type="text" name="U8LoginDate" id="U8LoginDate" class="cursor-hand" inputName="startTime" validate="notNull" value="" style="WIDTH: 144; HEIGHT: 20" value=""  size="24" onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'datetime');" ${v3x:outConditionExpression(edit == "1", 'disabled', 'readonly')}/>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" height="20" style="width:95px" nowrap><div align="left"><fmt:message key="u8.portal.version.label"/>：</div></td>
                        <td>
                          <select name="u8ver" id="u8ver" style="WIDTH: 144; HEIGHT: 20" size="1" title="" disabled="disabled">
                          	<option value="1">U8V11.0</option>
                            <option value="2">U8V11.1</option>
                          </select>
                        </td>
                    </tr>
                  </table>
      </form>
       <form id="u8webform" name="u8webform" method="post" target="_blank" action="">
      	<input id="logininfo" name="logininfo" type="hidden" value="2178"/>
      </form>
      </div>
      </td>
     </tr>
  </table>
             <p>　</p>
            </fieldset>
            </td>
          </tr>
  </table>
  <div style="margin-top: 5px;">
    <input name="webportalbtn" onClick="initU8User(); openU8Web();" type="button" value='<fmt:message key="u8.portal.login.web.label"/>' title='<fmt:message key="u8.portal.title.bslogin.label"/>' style="margin:0px 20px;">
    <input name="csportalbtn" onClick="initU8User(); openU8Client();" type="button" value='<fmt:message key="u8.portal.login.cs.label"/>' title='<fmt:message key="u8.portal.title.cslogin.label"/>' style="margin:0px 20px;">
  </div>
</center>

<div id="myselectAcc"  align="center" style="display:none; position:absolute; border:1px solid #737168; height:120px; left: 590px; top:270px; background:#F1F1EF;" title='<fmt:message key="u8.initial.title.account.label"/>' onClick="">
    <table border="0" width="100%" cellpadding="0" id="table1" cellspacing="0">
      <tr>
        <td align="left" valign="top" nowrap style="font-weight:bold; color:#FFFFFF; background:#7B99E1; line-height:18px; padding-left:5px; border-bottom:1px solid #C0C0C0;"><fmt:message key="u8.initial.title.accountselect.label"/><br></td>
      </tr>
      <tr>
        <table id="table2">

        </table>
      </tr>
    </table>
    <div style="margin-top:30px; border-top:1px solid #D6D6D3; padding-top:5px;">
      <input type="button" value='<fmt:message key="u8.common.cancel.label"/>' name="B2" onClick="closeAcclist()" style="width:50">
    </div>
</div>
</BODY>
</HTML>

