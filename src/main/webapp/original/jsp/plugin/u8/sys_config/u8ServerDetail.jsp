<%@page import="com.seeyon.ctp.util.DateUtil"%>
<%@page import="com.seeyon.apps.u8.constants.U8Constants"%>
<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@include file="head.jsp"%>
<OBJECT ID="runUC_U8Login" CLASSID="CLSID:F11BA142-3738-4632-9364-E873BA72DAA9" codebase="<%=request.getContextPath()%>/UFSoft.U8.Framework.Login.UI.dll" width=0 heigh=0></OBJECT>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js" />"></script>
<style type="text/css">
    #myselectAcc{
        overflow:auto;
    }
</style>
<script type="text/javascript">
var logindate = '<%=DateUtil.getDate("yyyy-MM-dd HH")%>'+":00";
var accountYear = '<%=DateUtil.getDate("yyyy")%>';
var defaultpwd='<%=U8Constants.U8_DEFAULT_PWD%>';
var msgerr = '<fmt:message key="u8.setuser.alert.message.error"/>';
//使页面不可编辑
function disableOcx() { 
    var form = document.forms[0]; 
    for ( var i = 0; i < form.length; i++) { 
        var element = form.elements[i]; 
        //部分元素可以编号 element.name 是元素自定义 name 
        if (element.name != "auditEntity.auditContent" 
        && element.name != "auditEntity.auditAutograph" 
        && element.name != "auditEntity.auditTime" 
        && element.name != "auditEntity.auditState" 
        && element.name != "submitBtn" 
        && element.name != "reset" 
        && element.name != "id" 
        && element.name != "processInstanceId" 
        && element.name != "updateForm") { 
            element.disabled = "true"; 
        } 
    } 
} 
/* function checkTextValid(text) {
  //记录不含引号的文本框数量
  var resultTag = 0;
  var pattern = new RegExp("^[0-9]*$")
  return pattern.test(text);
}
function valaccyear(year,type){
  if(!checkTextValid(year)){
      alert('<fmt:message key="u8.portal.fillaccountyear.error"/>');
      return false;
  }
  if(year.replace(/(^\s*)|(\s*$)/g, "").length<=0 ){
      if(type == "U8"){
          alert('<fmt:message key="u8.initial.fillaccountyear2.error"/>');
          return false;
      }else if(type == "zz"){
          document.getElementById("zz_account_year").value = "";
      }else if(type == "wb"){
          document.getElementById("wb_account_year").value = "";
      }
  }else if(year.replace(/(^\s*)|(\s*$)/g, "").length!=4){
      if(type == "U8"){
          alert('<fmt:message key="u8.initial.accountyear.medianwrong.error"/>');
      }else if(type == "zz"){
          alert('<fmt:message key="u8.initial.hraccountyear.medianwrong.error"/>');
      }else if(type == "wb"){
          alert('<fmt:message key="u8.initial.wbaccountyear.medianwrong.error"/>');
      }
      return false;
  }
  return true;
} */
    function check_form()
    {
        if($("#msg").css("display")=="" || $("#msg").css("display")=="block"){
            alert('<fmt:message key="u8.server.detail.msg.error"/>');
            return;
        }
        var u8ServerName = document.getElementById("u8_server_name").value;
        if(u8ServerName == null || u8ServerName =="")
        {
            alert('<fmt:message key="u8.server.detail.namenotnull.error"/>');
            return false;
        }
        else if(document.getElementById("u8_server_address").value == null || document.getElementById("u8_server_address").value =="")
        {
            alert('<fmt:message key="u8.server.detail.addressnotnull.error"/>');
            return false;
        }else{
        	var reg = new RegExp("[><'\"#$%&]","i");  // 创建正则表达式对象。
        	var  r = u8ServerName.match(reg);
        	if(r!=null){
        		alert('<fmt:message key="u8.server.detail.nameinvalid.error"/>');
        		return false;
        	}
        }
        var u8WebAddress = document.getElementById("u8_web_address").value;
        if(u8WebAddress!=null && u8WebAddress!=""){
        	var reg = new RegExp("[^\x00-\xff]","i");  // 创建正则表达式对象。
        	var  r = u8WebAddress.match(reg);
        	if(r!=null){
        		alert('<fmt:message key="u8.server.detail.webaddress.error"/>');
        		return false;
        	}
        }
        if(isU8Key()){
            alert('<fmt:message key="u8.server.label"/>'+document.getElementById("u8_server_name").value+'<fmt:message key="u8.server.detail.notchange.error"/>');
            return false;
        }
        //U8user校验
        var u8_user = document.getElementById("u8_user").value;
        var account_no = document.getElementById("account_no").value;
        var account_year = document.getElementById("account_year").value;
        var login_date = document.getElementById("login_date").value;
        if(u8_user == null || u8_user.replace(/(^\s*)|(\s*$)/g, "").length<=0){
            alert('<fmt:message key="u8.setuser.alert.notnull.operator2.error"/>');
            return false;
        }
        if(account_no == "undefined" || account_no.replace(/(^\s*)|(\s*$)/g, "").length<=0){
            alert('<fmt:message key="u8.setuser.alert.notnull.accountno.error"/>');
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
            debugger;
            //var address = select.options[select.selectedIndex].getAttribute("u8ServerAddress");
            var address = document.getElementById("u8_server_address").value;
            var password = document.getElementById("u8_password").value;
            var oLogin = new ActiveXObject("U8Login.clsLogin");
            if(login_date.indexOf(" ")!=-1){
                login_date = login_date.substring(0,login_date.indexOf(" "));
            }
            var loginFlag;
            if(password!=defaultpwd){
            	loginFlag = oLogin.Login("DP", account_no,account_year,u8_user, password,login_date,address);
            }else{
            	loginFlag = oLogin.Login("DP", account_no,account_year,u8_user, "${password}",login_date,address);
            }
            if (loginFlag) {
                document.getElementById("dataSource").value = oLogin.UFDataConnstringForNet;
                //return true;
            }else{
                alert(oLogin.ShareString);
                return false;
            }
        }catch(e){
            alert('<fmt:message key="u8.message.user.operatorerror"/>');
            return false;
        }
        var form = document.getElementById("userMapperForm");
        var u8ServerName = $("#u8_server_name").val();
        var action = "/seeyon/u8ServerAndUserInfoController.do?method=saveU8ServerAndU8UserInfo&u8_server_name="+encodeURIComponent(u8ServerName);
        form.action = action;
        document.getElementById('submintButton').disabled = true;
        form.submit();
        setTimeout("parent.window.location.reload()",500);
    }
    /*
     * 判断挡墙U8服务器是否为主数据,是主数据时不允许修改为不启用U8服务器
     */
    function isU8Key(){
        var flag = false;
        if('${bean.u8_server_enable}' == 1 && document.getElementById("u8_enableN").checked == true && '${userInfo.u8_key}'=="1"){
            flag = true;
        }
        return flag;
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
      var url = "${pageContext.request.contextPath}/u8UserInfoController.do?method=checkU8Key&u8serverName="+encodeURIComponent(u8ServerName)+"&u8Key="+u8Key;
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
    function check_checkbox(value)
    {
        /* if(value == "U8"){
            if(document.getElementById("U8").checked == true){
                document.getElementById("u8_set").style.display="";
                document.getElementById("u8_enableY").checked=true;
            }else{
                document.getElementById("u8_set").style.display="none";
                document.getElementById("u8_enableY").checked=false;
            }
        }else  */
        if(value == "wangbao"){
            if(document.getElementById("wangbao").checked == true){
                document.getElementById("wangbao_set").style.display="";
                document.getElementById("wb_enableY").checked="true";
            }else{
                document.getElementById("wangbao_set").style.display="none";
                document.getElementById("wb_enableN").checked="true";
            }
        }else if(value == "hrself"){
            if(document.getElementById("hrself").checked == true)
            {
                document.getElementById("checkin_apply").style.display="";
                document.getElementById("checkin_serch").style.display="";
                document.getElementById("pay_serch").style.display="";
                document.getElementById("kc_enableY").checked="true";
                document.getElementById("gz_enableY").checked="true";
                document.getElementById("ks_enableY").checked="true";
            }
            else
            {
                document.getElementById("checkin_apply").style.display="none";
                document.getElementById("checkin_serch").style.display="none";
                document.getElementById("pay_serch").style.display="none";
                document.getElementById("kc_enableN").checked="true";
                document.getElementById("gz_enableN").checked="true";
                document.getElementById("ks_enableN").checked="true";
            }
        }
        check_u8_server_enable();
    }
    function check_u8_server_enable()
    {
        if(document.getElementById("u8_enableY").checked==true){
            document.getElementById("wb_enableY").disabled="";
            document.getElementById("wb_enableN").disabled="";
            document.getElementById("kc_enableY").disabled="";
            document.getElementById("kc_enableN").disabled="";
            document.getElementById("gz_enableY").disabled="";
            document.getElementById("gz_enableN").disabled="";
            document.getElementById("ks_enableY").disabled="";
            document.getElementById("ks_enableN").disabled="";
        }else{
            document.getElementById("wb_enableY").disabled="true";
            document.getElementById("wb_enableN").disabled="true";
            document.getElementById("wb_enableN").checked="true";
            document.getElementById("kc_enableY").disabled="true";
            document.getElementById("kc_enableN").disabled="true";
            document.getElementById("kc_enableN").checked="true";
            document.getElementById("gz_enableY").disabled="true";
            document.getElementById("gz_enableN").disabled="true";
            document.getElementById("gz_enableN").checked="true";
            document.getElementById("ks_enableY").disabled="true";
            document.getElementById("ks_enableN").disabled="true";
            document.getElementById("ks_enableN").checked="true";
        }
    }
    
    function init(){      
        var date = document.getElementById("login_date").value; 
        if(date==''){
        	document.getElementById("login_date").value = logindate;
        }else{
        	accountYear = date.substring(0,4);
        }
        document.getElementById("account_year").value = accountYear;
        if(!"${bean}"){
            document.getElementById("u8_set").style.display="";
            document.getElementById("u8_enableY").checked=true;
        }
        check_u8_server_enable();
        if("${readStyle}" == "read"){
            disableOcx();
        }
        
    }
    
    function checkServerName(){
        var u8serverName = $("#u8_server_name").val();
        var url = "${pageContext.request.contextPath}/u8ServerController.do?method=checkServerName&u8serverName="+encodeURI(u8serverName);
        $.ajax({
            async:true,
            url:url,
            type:"GET",
            success:function(data){
                //服务器名称未重复，可用
                if(data=="1"){
                    $("#msg").css("display","none");
                }else if(data=="0"){
                    $("#msg").css("display","");
                }
            },
            error:function(){
                alert('<fmt:message key="u8.server.detail.verify.error"/>');
                $("#msg").css("display","none");
            }
        });
    }
    
    function initWebAddress(){
        var webAddress = document.getElementById("u8_web_address");
        if(webAddress.value.replace(/(^\s*)|(\s*$)/g, "").length<=0){
            var u8Address = document.getElementById("u8_server_address");
            webAddress.value = u8Address.value;
        }
    }
    function check_account_no()
    {               
        var address = document.getElementById("u8_server_address").value;       
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
        //alert(u8Xml);
        paraseXml(u8Xml);
    }
    function getXMLAttValue(aNode,aAttName){
              if (aNode==null) return null;
              if (aNode.attributes==null) return null;
              var fatt=aNode.attributes.getNamedItem(aAttName);
              if (fatt==null) return null;
              return fatt.nodeValue;
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
    function paraseXml(aXML)
    {   
        var xmlDom;
        try{
            xmlDom= new ActiveXObject("MSXML2.DOMDocument");
        }
        catch (e)
        {
            throw "<fmt:message key='u8.setuser.alert.xmlparse.error'/>";
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
          document.all.table2.outerHTML = "<table id=\"table2\" style=\"width:298px;font-size:12px;\" cellspacing=\"0\">"+temptable.toString()+"</table>";
            try{
                changewidth();
                }catch(e){}
        }
        function changewidth(){
            $("#myselectAcc").css("display","");
            $("#myselectAcc").css("width",$("#table2").css("width"));
            $("#table1").css("width",$("#table2").css("width"));
        }
        function selecUserAcc(td)
        {
            document.getElementById("account_no").value = td.children[0].getAttribute("acccode");
            document.all.myselectAcc.style.display="none";
        }
        
        function closeAcclist(){
              myselectAcc.style.display="none";
        }
        function clearUserinfo(){
            var s=document.getElementById("u8_server_address");
            if(document.getElementById("u8_user").value!=""&&document.getElementById("account_no").value!=""){
                if(window.confirm('<fmt:message key="u8.server.alert.confirm.modify"/>')){
                    document.getElementById("u8_user").value="";
                    document.getElementById("u8_password").value="";
                    document.getElementById("account_no").value="";
                    document.getElementById("account_year").value="";
                    s.focus();
                }else{
                    s.blur();
                }
            }
        }
        function clearpwd(){        	
        	document.getElementById("u8_password").value="";
        	document.getElementById("account_no").value="";
        }
</script>
</head>
<body scroll="yes" style="overflow: no" onload="init();">
<form id="userMapperForm" name= "userMapperForm" target="editMemberFrame" action=""  method="post" >
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
    <tr align="center">
        <td height="8" class="detail-top">
            <script type="text/javascript">
            getDetailPageBreak(); 
        </script>
        </td>
        
    </tr>
    <tr>
        <td width="100%">

<table width="100%" border="0" cellspacing="0" height="96%" cellpadding="0" align="center" >
  <tr valign="top">
    <td width="50%">
    
        <table border="0" cellspacing="0" cellpadding="0" align="right">
            <tr>
                <td class="bg-gray" nowrap="nowrap" align="right">
                    <div class="hr-blue-font"><strong><fmt:message key="u8.server.detail.info.label"/>：</strong></div>
                </td>
                <td>&nbsp;</td>             
            </tr>   
            <tr>
                <td>
                    <input type="hidden"  id ="id" name ="id" value="${bean.id}">
                    <input type="hidden"  id ="u8_enable" name ="u8_enable" value="${bean.u8_server_enable}">
                    <input type="hidden"  id ="server_name" name ="server_name" value="${bean.u8_server_name}">

                </td>
            </tr>
            <tr>
                <td class="bg-gray" width="25%" nowrap="nowrap"><label for="name"><span style="color:red;">*</span><fmt:message key="u8.server.name.label"/>:</label></td>
                <td class="new-column" width="75%" nowrap="nowrap">
                <div style="display:none" id="msg"><font color="red"><fmt:message key="u8.server.detail.exists.label"/></font></div>
                    <input name="u8_server_name" type="text" id="u8_server_name" class="input-100per" onblur="checkServerName();" inputName='<fmt:message key="u8.server.detail.nameofserver.label"/>'  maxSize="40" maxlength="40" validate="notNull,isDeaultValue,maxLength,isWord" value="${bean.u8_server_name}" />
                    <script>
                        if('${bean.u8_server_name}' != "")
                        document.getElementById("u8_server_name").disabled  = true;
                    </script>
                </td>   
            </tr>
            <tr>
                <td class="bg-gray" width="45%" nowrap="nowrap"><label for="name"><span style="color:red;">*</span><fmt:message key="u8.server.address.label"/>:<label></td>
                <td class="new-column" width="55%" nowrap="nowrap">
                <input  onclick="clearUserinfo();" class="input-100per" type="text" name="u8_server_address" id ="u8_server_address" onblur="initWebAddress();" maxSize="40" maxlength="40"  value="${bean.u8_server_address}"/></td>
            </tr>   
            <tr>
                <td class="bg-gray" width="25%" nowrap="nowrap"><label for="name"><fmt:message key="u8.server.detail.webaddress.label"/>:</label>
                </td>
                <td class="new-column" width="75%" nowrap="nowrap">
                    <input class="input-100per" type="text" name="u8_web_address" id ="u8_web_address" maxSize="40" maxlength="40" value="${bean.u8_web_address}"/>
                </td>
            </tr>       
            <tr>
                <td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message key="u8.server.type.label"/>:</td>
                <td class="new-column" width="75%" nowrap="nowrap">
                    <select id="u8_version" name="u8_version">
                    			<option value="130" <c:if test="${bean.u8_version=='130'}">selected="selected"</c:if>>V13.0</option>
                    			<option value="125" <c:if test="${bean.u8_version=='125'}">selected="selected"</c:if>>V12.5</option>              
                                <option value="121" <c:if test="${bean.u8_version=='121'}">selected="selected"</c:if>>V12.1</option>
                                <option value="120" <c:if test="${bean.u8_version=='120'}">selected="selected"</c:if>>V12.0</option>
                                <option value="111" <c:if test="${bean.u8_version=='111'}">selected="selected"</c:if>>V11.1</option>
                                <option value="110" <c:if test="${bean.u8_version=='110'}">selected="selected"</c:if>>V11.0</option>
                    </select>                       
                </td>
            </tr>
            <tr>
                <td class="bg-gray" width="25%" nowrap="nowrap"><fmt:message key="u8.server.detail.app.label"/>:</td>
                <td class="new-column" width="75%" nowrap="nowrap">
            
                        <input id="U8" type="checkbox" name="has_u8" value="U8" onclick="check_checkbox(this.value)" checked="checked" disabled="disabled"/><fmt:message key="u8.server.u8.label"/>     
                        <input id="wangbao" type="checkbox" name="has_wb" value="wangbao" onclick="check_checkbox(this.value)"/><fmt:message key="u8.server.detail.wb.label"/>
                        <input id="hrself" type="checkbox" name="has_zz" value="hrself" onclick="check_checkbox(this.value)"/><fmt:message key="u8.server.detail.hr.label"/>
                    <script type="text/javascript"> 
                                if('${bean.has_u8}' == 1)
                                {
                            //      alert("111111 U8启动");
                                    document.getElementById("U8").checked = true;
//                                  document.getElementById("u8_set").style.display="";
                            //      alert("u8 启动");
                                }
                                if('${bean.has_wb}' == 1)
                                    document.getElementById("wangbao").checked = true;
                                if('${bean.has_zz}' == 1)
                                    document.getElementById("hrself").checked = true;
                    </script>
                </td>
            </tr>
            <tr>
                <td class="bg-gray" width="25%" nowrap="nowrap"></td>
                <td class="new-column" width="75%" nowrap="nowrap"><font color="#008000"><fmt:message key="u8.server.detail.node.label"/></font></td>
            </tr>
        
        
        <fmt:message key="org.member.noPost" var="noPostLabel"/>        
            <tr>
                <td class="bg-gray" nowrap="nowrap" align="right">
                    <div class="hr-blue-font"><strong><fmt:message key="u8.server.detail.switch.label"/>：</strong></div>
                </td>
                <td>&nbsp;</td>             
            </tr>
            <tr id="u8_set" style="display:block;">
                <td class="bg-gray" width="40%" nowrap="nowrap"><fmt:message key="u8.server.detail.enabled.label"/>：</td>
                <td class="new-column" width="60%" nowrap="nowrap">
                        <input id="u8_enableY" type="radio" name="u8_server_enable" value="1"  onclick="check_u8_server_enable()"/><fmt:message key="u8.common.yes.label"/>
                        <input id="u8_enableN" type="radio" name="u8_server_enable" value="0"  onclick="check_u8_server_enable()" /><fmt:message key="u8.common.no.label"/>
                                <script type="text/javascript">
                                    if('${bean.has_u8}' == 1)
                                    {
                                        document.getElementById("u8_set").style.display="";
                                    }

                                    if('${bean.u8_server_enable}' == 1)
                                        document.getElementById("u8_enableY").checked = true;
                                    else
                                        document.getElementById("u8_enableN").checked = true;
                                </script>
              </td>
            </tr>           
            <tr id="wangbao_set" style="display:none;">
                <td class="bg-gray" width="40%" nowrap="nowrap"><fmt:message key="u8.server.detail.enabled.wb.label"/>：</td>
                <td class="new-column" width="60%" nowrap="nowrap">
                        <input id="wb_enableY" type="radio" name="wb_enable" value="1"  onclick=""/><fmt:message key="u8.common.yes.label"/>
                        <input id="wb_enableN" type="radio" name="wb_enable" value="0" /><fmt:message key="u8.common.no.label"/>
                                <script type="text/javascript">

                                    if('${bean.has_wb}'== '1')
                                        document.getElementById("wangbao_set").style.display="";

                                    if('${bean.wb_enable}' == '1')
                                        document.getElementById("wb_enableY").checked = true;
                                    else
                                        document.getElementById("wb_enableN").checked = true;
                                </script>
                </td>

            </tr>
            <tr id="checkin_serch" style="display:none;">
                <td class="bg-gray" width="40%" nowrap="nowrap"><fmt:message key="u8.server.detail.enabled.kc.label"/>：</td>
                <td class="new-column" width="60%" nowrap="nowrap">
                    <input id="kc_enableY" type="radio" name="kc_enable" value="1"onclick=""/><fmt:message key="u8.common.yes.label"/>
                    <input id="kc_enableN" type="radio" name="kc_enable" value="0" /><fmt:message key="u8.common.no.label"/>
                        <script type="text/javascript">
                            if('${bean.has_zz}' == '1')
                            {
                                document.getElementById("checkin_serch").style.display="";
                            }
                            if('${bean.kc_enable}' == '1')
                                document.getElementById("kc_enableY").checked = true;
                            else
                                document.getElementById("kc_enableN").checked = true;
                        </script>  
                </td>
            </tr>   
            <tr id="pay_serch" style="display:none;">
               <td class="bg-gray" width="40%" nowrap="nowrap"><fmt:message key="u8.server.detail.enabled.gz.label"/>：</td>
                <td class="new-column" width="60%" nowrap="nowrap">
                        <input id="gz_enableY" type="radio" name="gz_enable" value="1"   onclick=""/><fmt:message key="u8.common.yes.label"/>
                        <input id="gz_enableN" type="radio" name="gz_enable" value="0"  /><fmt:message key="u8.common.no.label"/>
                            <script type="text/javascript">
                                if('${bean.has_zz}' == '1')
                                    {
                                        document.getElementById("pay_serch").style.display="";
                                    }
                                if('${bean.gz_enable}' == '1')
                                    document.getElementById("gz_enableY").checked = true;
                                else
                                    document.getElementById("gz_enableN").checked = true;
                            </script>
                </td>
            </tr>
            <tr id="checkin_apply"style="display:none;">
                <td class="bg-gray" width="40%" nowrap="nowrap"><fmt:message key="u8.server.detail.enabled.ks.label"/>：</td>
                <td class="new-column" width="60%" nowrap="nowrap">
                        <input id="ks_enableY" type="radio" name="ks_enable" value="1" onclick=""/><fmt:message key="u8.common.yes.label"/>
                        <input id="ks_enableN" type="radio" name="ks_enable" value="0"/><fmt:message key="u8.common.no.label"/>
                            <script type="text/javascript">
                                if('${bean.has_zz}' == 1)
                                    {
                                        document.getElementById("checkin_apply").style.display="";
                                    }
                                if('${bean.ks_enable}' == 1)
                                    document.getElementById("ks_enableY").checked = true;
                                else
                                    document.getElementById("ks_enableN").checked = true;
                            </script>
                </td>
            </tr>
            <tr align="center">
                <td  colspan="2" width="500px" class="new-column" nowrap="nowrap"><font color="#008000"><fmt:message key="u8.server.detail.node2.label"/></font></td>
            </tr>
        </table>
  
    </td>
    
    <td width="50%">
    	<fieldset style="width:95%;border:0px;" align="center">
            <table border="0" cellspacing="0" cellpadding="0" align="center">
            <tr>
                <td class="bg-gray" nowrap="nowrap" >
                    <div class="hr-blue-font"><strong><fmt:message key="u8.setuser.label"/>：</strong></div>
                </td>
                <td colspan="2">&nbsp;</td>
            </tr>   
            <tr>
                <td >
                    <input type="hidden"  id ="id1" name ="id1" value="${userInfo.id}">
                    <input type="hidden"  id ="u8Key" name ="u8Key" value="${userInfo.u8_key}">
                </td>
            </tr>
            <tr>
                <td class="bg-gray" width="30%" nowrap="nowrap"><label for="name"><span style="color:red;">*</span><fmt:message key="u8.bind.account.label"/>:<label></td>
                <td class="new-column" width="70%" nowrap="nowrap">
                <input class="input-100per" type="text" onchange="clearpwd();" name="u8_user" id ="u8_user" maxSize="20" maxlength="20"  value="${userInfo.u8_user}"/></td>
                
            </tr>
            <tr>
            <td class="bg-gray" width="30%" nowrap="nowrap">
                <label for="name"><span style="color:red;">*</span><fmt:message key="u8.setuser.isu8key.label"/>:</label></td>
            <td class="new-column" width="70%" nowrap="nowrap">
                <input id="u8_keyY" type="radio" name="u8_key" value="1" /><fmt:message key="u8.common.yes.label"/>
                <input id="u8_keyN" type="radio" name="u8_key" value="0" checked/><fmt:message key="u8.common.no.label"/>
            </td>
            </tr> 
            <tr>
                <td class="bg-gray" width="30%" nowrap="nowrap"><label for="name"><fmt:message key="u8.initial.password.label"/>:</label></td>
                <td class="new-column" width="70%" nowrap="nowrap">
                <input class="input-100per" type="password" name="u8_password" id ="u8_password" maxSize="40" maxlength="40" value="${userInfo.u8_password}"/><label for="name"></td>           
            </tr>
            <tr>
                <td class="bg-gray" width="30%" nowrap="nowrap"><span style="color:red;">*</span><fmt:message key="u8.setuser.account.label"/>:</td>
                <td class="new-column" width="60%" nowrap="nowrap">
                    <input class="input-100per" type="text" name="account_no" id ="account_no" maxSize="40" maxlength="40" value="${userInfo.account_no}"/></td>
                </td>
                <td width="10%">
                    <img border="0" src="<c:url value='/common/images/search-gray.gif'/>" height="16" onClick="check_account_no()" title='<fmt:message key="u8.setuser.title.label"/>'>
                </td>
            </tr>
            <tr align="top">
            	<td>&nbsp;</td>
            	<td align="top" width="100%" nowrap="nowrap" colspan="2">
            	<fmt:message key="u8.setuser.like.label"/>:
            	（default）@001
            	</td>
            </tr>
            <tr style="display:none">               
                <td class="new-column" nowrap="nowrap" colspan="3">
                    <input class="input-100per" type="hidden" name="account_year" id ="account_year" maxSize="40" maxlength="40" value="${userInfo.account_year}"/></td>
                </td>
            </tr>
            <tr>
                <td class="bg-gray" width="30%" nowrap="nowrap"><span style="color:red;">*</span><fmt:message key="u8.setuser.logindate.label"/>:</td>
                <td class="new-column" nowrap="nowrap" width="70%">
                    <input class="input-100per" type="text" readonly="readonly" name="login_date" id ="login_date" maxSize="40" maxlength="40" value="${userInfo.login_date}" onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'datetime');"/></td>
                <td class="" width="" nowrap="nowrap">
            </tr>
        </table>
        
        <input id="dataSource" name="dataSource"  type="hidden" value=""/> </fieldset>     
    </td>
  </tr>  
  <tr>
</table>
      
        </td>
    </tr>
    <tr>
        <td height="42" align="center" class="bg-advance-bottom">
        <p align="center">
            <input id="submintButton" type="button" style="width:70px;" onclick="check_form()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" >&nbsp;
        </p>
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
     if('${userInfo.u8_key}' == '1')
        document.getElementById("u8_keyY").checked = true;
     if('${userInfo.u8_key}' == '0')
        document.getElementById("u8_keyN").checked = true;                           
</script>