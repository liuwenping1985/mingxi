<%@page import="com.seeyon.ctp.util.DateUtil"%>
<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>editUserMapper</title>
<%@include file="head.jsp"%>
<OBJECT ID="runUC_U8Login" CLASSID="CLSID:F11BA142-3738-4632-9364-E873BA72DAA9" codebase="<%=request.getContextPath()%>/UFSoft.U8.Framework.Login.UI.dll" width=0 heigh=0></OBJECT>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js" />"></script>
<style type="text/css">
	#myselectAcc{
		overflow:auto;
	}
</style>
<script>
	showCtpLocation("U8system02");
	if("${success}" == '1')
		alert('<fmt:message key="u8.setuser.alert.success.error"/>');
	if("${success}" == '0')
		alert('<fmt:message key="u8.setuser.alert.fail.error"/>');
</script>
<script>
var msgerr = '<fmt:message key="u8.setuser.alert.message.error"/>';
var logindate = '<%=DateUtil.getDate("yyyy-MM-dd HH")%>'+":00";
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
		} //End Function
		function getXMLAttValue(aNode,aAttName){
			  if (aNode==null) return null;
			  if (aNode.attributes==null) return null;
			  var fatt=aNode.attributes.getNamedItem(aAttName);
			  if (fatt==null) return null;
			  return fatt.nodeValue;
			}


	function check_find_u8ServerName()
	{
	   window.location.href="/seeyon/u8UserInfoController.do?method=initU8UserInfo&u8ServerName=" + document.getElementById("u8_server_name").value;
	}
	function U8users(account,username,password,server,accountyear,logindate,servername){
	    this.account=account;//账套
	    this.username=username;//操作员
	    this.password=password;//操作员密码
	    this.server= server;//U8服务器
	    this.accountyear=accountyear;//会计年份
	    this.logindate=logindate;//登录日期
	    this.servername=servername;//服务器名称login_date
	}
	function check_account_no()
	{
		var select = document.getElementById("u8_server_name");
		if(select.options.length<=0){
			alert('<fmt:message key="u8.setuser.alert.noserver.error"/>');
			return;
		}
		var address = select.options[select.selectedIndex].getAttribute("u8ServerAddress");
		var uerName = document.getElementById("u8_user").value;
		if(uerName==""||uerName==null){
			alert('<fmt:message key="u8.setuser.alert.u8perator.error"/>');
			return;
		}
		var u8Xml;
		try{
			u8Xml = runUC_U8Login.GetDataSource_2(address,uerName);
		}catch(e){
			alert('<fmt:message key="u8.setuser.alert.causes.error"/>'+"：\n"+msgerr);
			return;
		}
		paraseXml(u8Xml);
	}
	function paraseXml(aXML)
	{
		var xmlDom;
		try{
		    xmlDom= new ActiveXObject("MSXML2.DOMDocument");
		}
		catch (e)
		{
		    throw '<fmt:message key="u8.setuser.alert.xmlparse.error"/>';
		}
		   
		xmlDom.loadXML(LTrimCN(aXML));
		var root = xmlDom.documentElement;
		var temptable = new StringBuffer("");
		if (root.tagName=="ufsoft")
		{
			 var fNodelist = root.childNodes;
		     if (fNodelist!=null)
			{
		       var fNodelist = fNodelist[0].childNodes;
		       if (fNodelist!=null)
				{
		          var flen = fNodelist.length;
		          var facccode,faccname;
		          temptable.append("<tr><td style=\"background:#DFDEDC; border-left:1px solid #FFFFFF; border-right:1px solid #ACA899; text-align:center;\">"+'<fmt:message key="u8.setuser.accountcode.label"/>'+"</td><td style=\"background:#DFDEDC; text-align:center; border-left:1px solid #fff;\">"+'<fmt:message key="u8.setuser.account.name.label"/>'+"</td></tr>");
		          for (var i = 0; i < flen; i++)
				{
		             if (fNodelist[i].tagName == "DataSource")
					{
		                facccode=getXMLAttValue(fNodelist[i],"code");
		                faccname=getXMLAttValue(fNodelist[i],"name");
		                temptable.append("<tr style:\"cursor:hand\" ondblclick=\"selecUserAcc(this)\" onMouseOver=\"this.style.background='#ACA899'\" onMouseOut=\"this.style.background='#F1F1EF'\"><td style=\"color:#575757;\" acccode=\""+ facccode +"\" nowrap>"+facccode+"</td><td style=\"color:#575757;\" nowrap>"+faccname+"</td></tr>");
		             }
		          }
		       }
		     }
		   }
	//	   return temptable.toSt	       
		  document.all.table2.outerHTML = "<table id=\"table2\" style=\"width:298px;font-size:12px;\" cellspacing=\"0\">"+temptable.toString()+"</table>";
			try{
				changewidth();
				}catch(e){}
		}
	
		function selecUserAcc(td)
		{
 			document.getElementById("account_no").value = td.children[0].getAttribute("acccode");
			document.all.myselectAcc.style.display="none";
		}
		
		function closeAcclist(){
			  myselectAcc.style.display="none";
		}
		//更具table宽度去设置div的宽度
		function changewidth(){
			$("#myselectAcc").css("display","");
			$("#myselectAcc").css("width",$("#table2").css("width"));
			$("#table1").css("width",$("#table2").css("width"));
		}

	function check_form(){
		var select = document.getElementById("u8_server_name");
		if(select.options.length<=0){
			alert('<fmt:message key="u8.setuser.alert.noserver.error"/>');
			return false;
		}
		var u8_user = document.getElementById("u8_user").value;
		var account_no = document.getElementById("account_no").value;
		var account_year = document.getElementById("account_year").value;
		var login_date = document.getElementById("login_date").value;
		if(u8_user == null || u8_user.replace(/(^\s*)|(\s*$)/g, "").length<=0){
			alert('<fmt:message key="u8.setuser.alert.notnull.operator.error"/>');
			return false;
		}
		if(account_no == "undefined" || account_no.replace(/(^\s*)|(\s*$)/g, "").length<=0){
			alert('<fmt:message key="u8.setuser.alert.notnull.accountno.error"/>');
			return false;
		}
		if(account_year == "undefined" || account_year.replace(/(^\s*)|(\s*$)/g, "").length<=0){
			alert('<fmt:message key="u8.setuser.alert.notnull.accountyear.error"/>');
			return false;
		}
		if(account_year.replace(/(^\s*)|(\s*$)/g, "").length!=4){
			alert('<fmt:message key="u8.setuser.alert.accountyear.error"/>');
			return false;
		}
		if(login_date == "undefined" || login_date.replace(/(^\s*)|(\s*$)/g, "").length<=0){
			alert('<fmt:message key="u8.setuser.alert.notnull.logindate.error"/>');
			return false;
		}
		
		try{
			//校验U8服务器是否为主数据
			if(checkU8Key()){
				return false;
			}
			var address = select.options[select.selectedIndex].getAttribute("u8ServerAddress");
			var password = document.getElementById("u8_password").value;
			var oLogin = new ActiveXObject("U8Login.clsLogin");
			if(login_date.indexOf(" ")!=-1){
				login_date = login_date.substring(0,login_date.indexOf(" "));
			}
			var loginFlag = oLogin.Login("DP", account_no,account_year,u8_user, password,login_date,address);
			if (loginFlag) {
				document.getElementById("dataSource").value = oLogin.UFDataConnstringForNet;
				return true;
			}else{
				alert(oLogin.ShareString);
				return false;
			}
		}catch(e){
			alert('<fmt:message key="u8.message.user.operatorerror"/>');
			return false;
		}
		return true;
	}
		
	/**
	 * 通过ajax查询后台，判断主数据是否已存在，存在则不允许将当前服务器设为主数据，
	 *以及当前服务器原为主数据下，判断是否已进行了同步操作，如果是，不允许修改主数据为否
	 */
	 function checkU8Key(){
		var u8_keyY = document.getElementById("u8_keyY");
		var u8_keyN = document.getElementById("u8_keyN");
		var u8ServerName = document.getElementById("u8_server_name").value;
		var oldU8Key = document.getElementById("u8Key").value;
		var flag = false;
		if(oldU8Key=='1'){
			if(u8_keyY.checked==true)
				return flag;
		}else{
			if(u8_keyN.checked==true)
				return flag;
		}
		var u8Key = u8_keyY.checked==true?"1":"0";
		var url = "${pageContext.request.contextPath}/u8UserInfoController.do?method=checkU8Key&u8serverName="+u8ServerName+"&u8Key="+u8Key;
		$.ajax({
			async:false,
			url:url,
			type:"GET",
			success:function(data){
				if(data=="0"){
					alert('<fmt:message key="u8.setuser.alert.u8key.exist.error"/>');
					if(u8_keyY.checked==true){
						u8_keyN.checked=true;
					}else if(u8_keyN.checked==true){
						u8_keyY.checked=true;
					}
					flag = true;
				}
			},
			error:function(){
				alert('<fmt:message key="u8.setuser.alert.u8key.validate.error"/>');
				flag = true;
			}
		}); 
		return flag;
	}

	function init(){
		document.getElementById("login_date").value = logindate;
	}
</script>
</head>
<body onload="init();">
<form id="userInfoForm" name= "userInfoForm" target="editMemberFrame" action="/seeyon/u8UserInfoController.do?method=saveU8UserInfo" onsubmit="return (check_form())" method="post" >
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="90%" align="center" class="">

	<tr>
		<td height="90%" class="">
			<div class="scrollList">
<table width="100%" border="0" cellspacing="0" height="90%" cellpadding="0" align="center">
  <tr valign="top">
    <td width="100%">
    <fieldset style="width:95%;border:0px;" align="center">
    	<div>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td class="bg-gray" nowrap="nowrap" align="right">
					<div class="hr-blue-font"><strong><fmt:message key="u8.setuser.label"/>：</strong></div>
				</td>
				<td>&nbsp;</td>				
			</tr>	
			<tr>
				<td>
   					<input type="hidden"  id ="id" name ="id" value="${u8UserInfoBean.id}">
   					<input type="hidden"  id ="u8Key" name ="u8Key" value="${u8UserInfoBean.u8_key}">

				</td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="45%" nowrap="nowrap"><label for="name"><span style="color:red;">*</span><fmt:message key="u8.server.label"/>:</label></td>
				<td class="new-column" width="25%" nowrap="nowrap">
					<select name ="u8_server_name" id="u8_server_name" class="input-100per" onchange="check_find_u8ServerName();">
						<c:forEach var="server" items="${u8ServerList}">
							<option id ="${server.u8_server_name}" u8ServerAddress="${server.u8_server_address}" value="${server.u8_server_name}" >${server.u8_server_name}</option>
						</c:forEach>
					</select>
				</td>
				<td class="bg-gray" width="" nowrap="nowrap">
				<label for="name"><span style="color:red;">*</span><fmt:message key="u8.setuser.isu8key.label"/>:</label>
<input id="u8_keyY" type="radio" name="u8_key" value="1" /><fmt:message key="u8.common.yes.label"/>
<input id="u8_keyN" type="radio" name="u8_key" value="0" checked/><fmt:message key="u8.common.no.label"/>

				</td>
				<td class="new-column" width="50%" nowrap="nowrap">
				
				</td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="45%" nowrap="nowrap"><label for="name"><span style="color:red;">*</span><fmt:message key="u8.bind.account.label"/>:<label></td>
				<td class="new-column" width="25%" nowrap="nowrap">
				<input class="input-100per" type="text" name="u8_user" id ="u8_user" maxSize="20" maxlength="20"  value="${u8UserInfoBean.u8_user}"/></td>
			</tr>	
			<tr>
			  	<td class="bg-gray" width="45%" nowrap="nowrap"><label for="name"><fmt:message key="u8.initial.password.label"/>:</label></td>
				<td class="new-column" width="25%" nowrap="nowrap">
				<input class="input-100per" type="password" name="u8_password" id ="u8_password" maxSize="40" maxlength="40" value="${u8UserInfoBean.u8_password}"/><label for="name"></td>
			<!--	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="name">形如：(deafault)001 </label></td>		-->
			</tr>		
			<tr>
				<td class="bg-gray" width="45%" nowrap="nowrap"><span style="color:red;">*</span><fmt:message key="u8.setuser.account.label"/>:</td>
				<td class="new-column" width="25%" nowrap="nowrap">
					<input class="input-100per" type="text" name="account_no" id ="account_no" maxSize="40" maxlength="40" value="${u8UserInfoBean.account_no}"/></td>
				</td>
				<td >
					<img border="0" src="<c:url value='/common/images/search-gray.gif'/>" height="16" onClick="check_account_no()" title='<fmt:message key="u8.setuser.title.label"/>'>
					<fmt:message key="u8.setuser.like.label"/>：(deafault)@001
				</td>
			</tr>
			<tr>
				<td class="bg-gray" width="45%" nowrap="nowrap"><span style="color:red;">*</span><fmt:message key="u8.setuser.accountyear.label"/>:</td>
				<td class="new-column" width="25%" nowrap="nowrap">
					<input class="input-100per" type="text" name="account_year" id ="account_year" maxSize="40" maxlength="40" value="${u8UserInfoBean.account_year}"/></td>
				</td>
			</tr>
			<tr>
				<td class="bg-gray" width="45%" nowrap="nowrap"><span style="color:red;">*</span><fmt:message key="u8.setuser.logindate.label"/>:</td>
				<td class="new-column" width="25%" nowrap="nowrap">
					<input class="input-100per" type="text" readonly="readonly" name="login_date" id ="login_date" maxSize="40" maxlength="40" value="" onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'datetime');"/></td>
				<td class="" width="" nowrap="nowrap">
			</tr>
		</table>
		</div>
		<div style="margin-top:10px;" align="center">
			<span style="font-size:12px; color:#008000;"><fmt:message key="u8.setuser.node.label"/></span><br>
			<input type="submit"  value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" style="margin-top:25px;width:70px;"/> 
		</div>
	</fieldset>
			
			<input id="dataSource" name="dataSource"  type="hidden" value=""/>
    	
    </td width="100%">
  </tr>  
</table>
			</div>		
		</td>
	</tr>

	

</table>

</form>
<iframe name="editMemberFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>

<div id="myselectAcc"  align="center" style="display:none; position:absolute; border:1px solid #737168; height:120px; left: 700px; top:140px; background:#F1F1EF;" title='<fmt:message key="u8.initial.title.account.label"/>' onClick="">
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
</body>
</html>

		<script>
						var obj = document.getElementById('u8_server_name');
						len = obj.length;
						 for(var i=0;i<len;i++)
						{
						//	alert(i);
							if(obj.options[i].value == "${u8UserInfoBean.u8_server_name}") 
							{
							//	alert("选中");
								   obj.options[i].selected = true;
									 break;
							}
						}

						if('${u8UserInfoBean.u8_key}' == '1')
						document.getElementById("u8_keyY").checked = true;
					if('${u8UserInfoBean.u8_key}' == '0')
						document.getElementById("u8_keyN").checked = true;
							
					</script>