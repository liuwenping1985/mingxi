<%@page import="com.seeyon.ctp.util.DateUtil"%>
<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>setU8UserMapper</title>
<%
    response.setHeader("Pragma", "No-cache");
            response.setHeader("Cache-Control", "no-cache");
            response.setDateHeader("Expires", 0);
%>
<%@include file="header_userMapper.jsp"%>
<OBJECT id='clientOA'
    classid='CLSID:C3474273-859B-444A-AA12-FA4BF8D0DCD7'
    style='display: none'
    codebase="<%=request.getContextPath()%>/U8WebClient.CAB#version=8,60,0,1">
    <PARAM NAME='_ExtentX' VALUE='0'>
    <PARAM NAME='_ExtentY' VALUE='0'>
</OBJECT>
<OBJECT ID="runUC_CS"
    CLASSID="CLSID:0EB1A30A-D7BB-40BE-8A13-EB5C1A2CA8D8"
    codebase="<%=request.getContextPath()%>/OpenUC.dll" width=0 heigh=0></OBJECT>
<OBJECT ID="runUC_U8Login"
    CLASSID="CLSID:F11BA142-3738-4632-9364-E873BA72DAA9"
    codebase="<%=request.getContextPath()%>/UFSoft.U8.Framework.Login.UI.dll"
    width=0 heigh=0></OBJECT>
<script type="text/javascript" charset="UTF-8"
    src="<c:url value="/common/jquery/jquery.js" />"></script>
<link type="text/css" rel="stylesheet"
    href="<c:url value='/common/js/u8/DocMgr.css'></c:url>"
    id="menuStyleSheet">
<style type="text/css">
#myselectAcc {
    overflow: auto;
}
</style>
<SCRIPT src="<c:url value='/common/js/u8/selAccount.js'></c:url>"
    type="text/javascript"></SCRIPT>
<script type="text/javascript">
    showCtpLocation("U8person01");
    var msgerr = '<fmt:message key="u8.initial.message.error"/>';   
    var logindate = '<%=DateUtil.getDate("yyyy-MM-dd HH")%>'+":00";
    var accountYear = '<%=DateUtil.getDate("yyyy")%>';
    function checkU8Info(u8_version,username,password,server,account,accountyear,logindate){
        var isOK = true;
        var u8Xml= "";
        try{
            u8Xml = runUC_U8Login.GetDataSource_2(server,username);
            if(typeof(u8Xml)=="undefined"){
                if(u8_version!=""){
                    alert('<fmt:message key="u8.initial.u8server.error"/>');
                }else{
                    alert('<fmt:message key="u8.initial.wborhr.error"/>');
                }
                return true;
            }
        }catch(e){
            if(u8_version!=""){
                alert('<fmt:message key="u8.initial.u8server.error"/>');
            }else{
                alert('<fmt:message key="u8.initial.wborhr.error"/>');
            }
            return true;
        }
        var xmlDom;
        try{
           xmlDom= new ActiveXObject("MSXML2.DOMDocument");
        }
        catch (e)
        {
          throw '<fmt:message key="u8.initial.xmlparse.error"/>';
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
                    temptable.append("<tr><td style=\"background:#DFDEDC; border-left:1px solid #FFFFFF; border-right:1px solid #ACA899; text-align:center;\">"+'<fmt:message key="u8.setuser.accountcode.label"/>'+"</td><td style=\"background:#DFDEDC; text-align:center; border-left:1px solid #fff;\">"+'<fmt:message key="u8.setuser.account.name.label"/>'+"</td></tr>");
                    for (var i = 0; i < flen; i++) {
                        if (fNodelist[i].tagName == "DataSource"&&getXMLAttValue(fNodelist[i],"code")==account) {
                            isOK=false;
                        }
                    }
                }
            }
        }
        if(isOK){
            alert('<fmt:message key="u8.initial.accountset.error"/>');
            return true;
        }
        if(logindate.indexOf(" ")!=-1){
            logindate = logindate.substring(0,logindate.indexOf(" "));
        }
        if (u8_version!="") {
            var oLogin = new ActiveXObject("U8Login.clsLogin");
            var loginFlag = oLogin.Login("DP", account, accountyear, username, password, logindate, server);
            if (loginFlag) {
                document.getElementById("dataSource").value = oLogin.UFDataConnstringForNet;
                //return true;
            }else{
                alert(oLogin.ShareString);
                return true;
            }
            
        }else{
            if (!runUC_U8Login.login("GL", username, password, server, logindate, account, "")) {
                alert(runUC_U8Login.ErrDescript);
                return true;
            }
        }
        return false;
    }
    
    /* function valaccyear(year,type){
        if(!checkTextValid(year)){
            alert('<fmt:message key="u8.portal.fillaccountyear.error"/>');
            return false;
        }
        if(year.replace(/(^\s*)|(\s*$)/g, "").length<=0 ){
            if(type == "U8"){
                alert('<fmt:message key="u8.initial.fillaccountyear.error"/>');
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
        
    function check(){
        if ($("#U8_UserNumber").val().replace(/(^\s*)|(\s*$)/g, "").length<=0){
            alert('<fmt:message key="u8.setuser.alert.notnull.operator.error"/>');
          return false;
        }
        var password = document.all.U8_Password.value;
        var password2 = document.all.U8_Password2.value;
        if(password != password2){
          alert('<fmt:message key="u8.initial.password.error"/>');
          document.all.U8_Password2.value="";
          document.all.U8_Password.select();
          return false;
        }
        
        var obj = document.getElementById("u8_server_name");
        if(obj.options.length==0){
            alert('<fmt:message key="u8.setuser.alert.noserver.error"/>');
            return false;
        }
        var logindate1= document.getElementById("U8LoginDate").value;
        var u8_version = obj.options[obj.selectedIndex].getAttribute("version");
        var server = obj.options[obj.selectedIndex].getAttribute("selfdef");
        var has_wb = obj.options[obj.selectedIndex].getAttribute("has_wb");
        var has_zz = obj.options[obj.selectedIndex].getAttribute("has_zz");
        var password = document.getElementById("U8_Password").value;
        var username = document.getElementById("U8_UserNumber").value;
        var account = document.getElementById("AccountNo").value;
        var accountyear = document.getElementById("AccountYear").value;
        
        var server_wb = document.getElementById("u8_server_name_wb").value;
        var account_wb = document.getElementById("wb_account_no").value;
        var accountyear_wb = document.getElementById("wb_account_year").value;
        
        var server_zz = document.getElementById("u8_server_name_zz").value;
        var account_zz = document.getElementById("zz_account_no").value;
        var accountyear_zz = document.getElementById("zz_account_year").value;
        //账套年度
        /* if(!valaccyear(accountyear,"U8")){
                return false;
        } */
        if(has_wb=='1'){
            /* if(!valaccyear(accountyear_wb,"wb")){
                return false;
            } */
            if($("#u8_server_name_wb").val().replace(/(^\s*)|(\s*$)/g, "").length<=0){
                $("#u8_server_name_wb").val("");
            }
        }
        if(has_zz=='1'){
            /* if(!valaccyear(accountyear_zz,"zz")){
                return false;
            } */
            if($("#u8_server_name_zz").val().replace(/(^\s*)|(\s*$)/g, "").length<=0){
                $("#u8_server_name_zz").val("");
            }
        }
        //帐套非空校验
        if(account.replace(/(^\s*)|(\s*$)/g, "").length<=0){
            alert('<fmt:message key="u8.initial.defaultaccount.select.error"/>');
            return false;
        }
        if(has_wb=='1' && account_wb.replace(/(^\s*)|(\s*$)/g, "").length<=0){
            document.getElementById("wb_account_no").value = "";
        }
        if(has_zz=='1' && account_zz.replace(/(^\s*)|(\s*$)/g, "").length<=0){
            document.getElementById("zz_account_no").value = "";
        }
        if(checkU8Info(u8_version,username,password,server,account,accountyear,logindate1)){
            return false;
        }
        if(has_wb=='1'&&(account_wb.replace(/(^\s*)|(\s*$)/g, "").length>0)){
            if(checkU8Info("",username,password,server_wb,account_wb,accountyear_wb,logindate1)){
                return false;
            }
        }
        if(has_zz=='1'&&(account_zz.replace(/(^\s*)|(\s*$)/g, "").length>0)){
            if(checkU8Info("",username,password,server_zz,account_zz,accountyear_zz,logindate1)){
                return false;
            }
        }
        
        return true;
    }
    function init(){      
      document.getElementById("U8LoginDate").value = logindate;
      document.getElementById("wb_account_year").value = accountYear;
      document.getElementById("zz_account_year").value = accountYear;
      document.getElementById("AccountYear").value = accountYear;     
     //jquery去取样式
        var iever = $.browser.version;
        if(iever >= 9){
            $("#wbzz").css("height",$("#u8lid").css("height"));
        }else{
            $("#wbzz").css("height",$("#u8lid").css("height"));
        } 
        linkage(document.getElementById("u8_server_name"));
    }
    
    //summer 联动操作
        function linkage(obj){
            if(obj.options.length==0){
                return;
            }
            var selobj = obj.options[obj.selectedIndex];
            var operObj = $(selobj);
            var version = operObj.attr("version");
            if(version == "110"){
                document.getElementById("u8ver").value ="1";
            }
            if(version == "111"){
                document.getElementById("u8ver").value ="2";
            }
            if(version == "120"){
              document.getElementById("u8ver").value ="3";
          }
            var has_wb = operObj.attr("has_wb");
            var has_zz = operObj.attr("has_zz");
            var u8server = "${u8User.u8ServerName}";
            var loginServer = "${u8UserMapperBean.serverName}";
            var flag = ("${u8UserMapperBean}" && operObj.val()==loginServer);
            if(has_wb == "1"){
                $(".wb").css("visibility","");
                if(flag){
                    $("#u8_server_name_wb").val("${u8UserMapperBean.wb_server}");
                }else{
                    $("#u8_server_name_wb").val(operObj.attr("selfdef"));
                }
            }else{
                $(".wb").css("visibility","hidden");
                $("#u8_server_name_wb").val(operObj.attr("selfdef"));
            }
            if(has_zz=="1"){
                $(".hr").css("visibility","");
                if(flag&&"${u8UserMapperBean.hr_server}"!=""){
                    $("#u8_server_name_zz").val("${u8UserMapperBean.hr_server}");
                }else{
                    $("#u8_server_name_zz").val(operObj.attr("selfdef"));
                }
            }else{
                $(".hr").css("visibility","hidden");
                $("#u8_server_name_zz").val(operObj.attr("selfdef"));
            }
            if(has_wb != "1" && has_zz!="1"){
                $("#wbzz").css("display","none");
            }else{
                $("#wbzz").css("display","");
            }
            var user = $("#user");
            user.html("");
            if("${u8User}" && u8server== operObj.val()){
                //管理员绑定存在并且下拉框当前选择与管理员绑定的服务器一致，操作员设置为下拉框形式
                var string = '<select  id="U8_UserNumber" name="U8_UserNumber"  style="WIDTH: 144px; HEIGHT: 20px"></select>';
                user.html(string);
                clear();
                var peratorFlag = true;
                var perator = document.getElementById("U8_UserNumber");
                if("${u8UserMapperBean}"&& operObj.val()==loginServer){
                    initUserMapper();
                    peratorFlag = false;
                    var option = new Option("${u8UserMapperBean.perator}","${u8UserMapperBean.perator}");
                    perator.add(option);
                }
                var u8LoginNames = "${u8User.u8loginNames}";
                var loginNameArr = u8LoginNames.split(",");
                var u8UserIds = "${u8User.u8UserIds}";
                var u8UserIdArr = u8UserIds.split(",");
                for(var i=0; i<loginNameArr.length; i++){
                    if( u8UserIdArr[i]!="${u8UserMapperBean.perator}" || peratorFlag){
                        option = new Option(u8UserIdArr[i],u8UserIdArr[i]);
                        perator.add(option);
                    }
                }
            }else{
                //操作员设置为输入框形式
                var string = '<input id="U8_UserNumber" name="U8_UserNumber" size="24" type="text" value="" style="WIDTH: 144px; HEIGHT: 20px">';
                user.html(string);
                clear();
                if("${u8UserMapperBean}" && operObj.val()==loginServer){
                    document.getElementById("U8_UserNumber").value = "${u8UserMapperBean.perator}";
                    initUserMapper();
                }
            }
            
        }
    
        function deleteOption(select){
            var len = select.length;
            for(var i=0; i<len; i++){
                select.removeChild(select.lastChild);
            } 
            clear();
        }
        
        function clear(){
            $("#U8_Password").val("");
            $("#U8_Password2").val("");
            $("#AccountNo").val("");
            //$("#AccountYear").val("");
            $("#wb_account_no").val("");
            //$("#wb_account_year").val("");
            $("#zz_account_no").val("");
            //$("#AccountYear").val("");
            //$("#zz_account_year").val("");
        }
        function initUserMapper(){
            if("${u8UserMapperBean}"){
                $("#U8_Password").val("${u8UserMapperBean.password}");
                $("#U8_Password2").val("${u8UserMapperBean.password}");
                $("#AccountNo").val("${u8UserMapperBean.accountNo}");
                //$("#AccountYear").val("${u8UserMapperBean.accountYear}");
                $("#wb_account_no").val("${u8UserMapperBean.wb_accountNo}");
                //$("#wb_account_year").val("${u8UserMapperBean.wb_accountYear}");
                //$("#zz_account_year").val("${u8UserMapperBean.hr_accountYear}");
                $("#zz_account_no").val("${u8UserMapperBean.hr_accountNo}");
            }
        }
        
        var obj;
        function check_account_no(image,index)
        {
            obj = image;
            var address;
            if(index == 1){
                var u8server = document.getElementById("u8_server_name");
                if(u8server.options.length<=0){
                    alert('<fmt:message key="u8.setuser.alert.noserver.error"/>');
                    return;
                }
                address = u8server.options[u8server.selectedIndex].getAttribute("selfdef");
            }else if(index == 2){
                address = document.getElementById("u8_server_name_wb").value;
                if(address.replace(/(^\s*)|(\s*$)/g, "").length<=0){
                    alert('<fmt:message key="u8.initial.fillwbserver.error"/>');
                    return;
                }
            }else if(index == 3){
                address = document.getElementById("u8_server_name_zz").value;
                if(address.replace(/(^\s*)|(\s*$)/g, "").length<=0){
                    alert('<fmt:message key="u8.initial.fillhrserver.error"/>');
                    return;
                }
            }
            var uerName = document.getElementById("U8_UserNumber").value;
            if(uerName==""||uerName==null){
                alert('<fmt:message key="u8.initial.filloperator.error"/>');
                return;
            }
            try{
                var u8Xml = runUC_U8Login.GetDataSource_2(address,uerName);
            }catch(e){
                alert('<fmt:message key="u8.setuser.alert.causes.error"/>'+"：\n"+msgerr);
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
                      temptable.append("<tr><td style=\"background:#DFDEDC; border-left:1px solid #FFFFFF; border-right:1px solid #ACA899; text-align:center;\">账套编码</td><td style=\"background:#DFDEDC; text-align:center; border-left:1px solid #fff;\">账套名称</td></tr>");
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
              /*  return temptable.toString(); */
              document.all.table2.outerHTML = "<table id=\"table2\" style=\"width:298px;font-size:12px;\" cellspacing=\"0\">"+temptable.toString()+"</table>";
                try{
                    changewidth();
                    }catch(e){}
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
            document.all.myselectAcc.style.display="none";
        }
        
        //更具table宽度去设置div的宽度
        function changewidth(){
            $("#myselectAcc").css("display","");
            $("#myselectAcc").css("width",$("#table2").css("width"));
            $("#table1").css("width",$("#table2").css("width"));
        }
        
        function formsubmit(){
            var form = document.getElementById("myform");
            form.action = "/seeyon/u8UserMapper.do?method=saveU8UserMapper";
        }
        function closeAcclist(){
              myselectAcc.style.display="none";
            }
        //包换特殊字符返回true
        /* function checkTextValid(text) {
            //记录不含引号的文本框数量
            var resultTag = 0;
            var pattern = new RegExp("^[0-9]*$")
            return pattern.test(text);
        } */
        
    function checkneeddata(){
      var u8server = document.getElementById("u8_server_name");
      if(u8server.options.length<=0){
          alert('<fmt:message key="u8.setuser.alert.noserver.error"/>');
          return;
      }
      if (LTrimCN(document.getElementById("U8_UserNumber").value)==""){
          alert('<fmt:message key="u8.initial.filloperator.error"/>');
          return false;
      }
      if (document.getElementById("AccountNo").value==null || LTrimCN(document.getElementById("AccountNo").value)==""){
          alert('<fmt:message key="u8.portal.fillaccount.error"/>');
          return false;
      }
      var accountYear = document.all.AccountYear.value;
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
    </script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="init()" leftmargin="0"
    topmargin="0" onkeydown="return(!(event.keyCode==78&&event.ctrlKey))"
    oncontextmenu="self.event.returnValue =false">
    <span>
        <!-- <img src="/seeyon/common/images/toolbar/u8_eye.gif" width="454" height="100"> -->
    </span>
    <br>
    <br>
    <form id="myform" name="myform" method="post" action=""
        onsubmit="if(!check()){return false;};formsubmit();">
        <table width="100%" border="0" cellpadding="0" cellspacing="0"
            style="margin-top: 10px">
            <tr>
                <td width="49%" id="mytd" align="center">
                    <fieldset id="u8lid" style="float: left; width: 95%; height:260;">
                        <legend>
                            &nbsp;&nbsp;<font size="2"><b><fmt:message
                                        key="u8.initial.u8info.label" /></b></font>&nbsp;&nbsp;
                        </legend>
                        <br>
                        <br>
                        <table bgcolor="#ffffff" border="0" cellpadding="0"
                            cellspacing="0">
                            
                            <tr>
                                <td>
                                    <div align="center">
                                        <input name="id" type="hidden" id="id"
                                            value="${u8UserMapperBean.id }" />
                                        <table width="400" border="0" cellpadding="0" cellspacing="0"
                                            style="line-height: 24px">
                                            <tr>
                                                <td align="right" height="20" style="width: 100px" nowrap><fmt:message
                                                        key="u8.server.label" />：</td>
                                                <td height="20" nowrap><select id="u8_server_name"
                                                    name="u8_server_name" style="width: 144px;"
                                                    onchange="linkage(this);">
                                                        <c:forEach var="bean" items="${serverList}">
                                                            <c:if test="${bean.has_u8 eq 1}">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${(u8UserMapperBean!=null && u8UserMapperBean.serverName==bean.u8_server_name)
                                            ||(u8UserMapperBean ==null && u8User!=null  && u8User.u8ServerName==bean.u8_server_name)}">
                                                                        <option value="${bean.u8_server_name}"
                                                                            selected="selected" title="${bean.u8_server_name}"
                                                                            version="${bean.u8_version}"
                                                                            u8_web_address="${bean.u8_web_address}"
                                                                            has_wb="${bean.wb_enable}"
                                                                            has_zz='<c:if test="${bean.kc_enable==0 && bean.gz_enable==0 && bean.ks_enable==0}">0</c:if><c:if test="${bean.kc_enable==1 || bean.gz_enable==1 || bean.ks_enable==1}">1</c:if>'
                                                                            selfdef="${bean.u8_server_address}">${bean.u8_server_name}</option>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <option value="${bean.u8_server_name}"
                                                                            title="${bean.u8_server_name}"
                                                                            version="${bean.u8_version}"
                                                                            u8_web_address="${bean.u8_web_address}"
                                                                            has_wb="${bean.wb_enable}"
                                                                            has_zz='<c:if test="${bean.kc_enable==0 && bean.gz_enable==0 && bean.ks_enable==0}">0</c:if><c:if test="${bean.kc_enable==1 || bean.gz_enable==1 || bean.ks_enable==1}">1</c:if>'
                                                                            selfdef="${bean.u8_server_address}">${bean.u8_server_name}</option>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:if>
                                                        </c:forEach>
                                                </select> <input type="hidden" id="dataSource" name="dataSource"
                                                    value=""></td>
                                            </tr>
                                            <tr>
                                                <td align="right" height="20" style="width: 100px" nowrap><fmt:message
                                                        key="u8.bind.account.label" />：</td>
                                                <td height="20" nowrap id="user"><input
                                                    id="U8_UserNumber" name="U8_UserNumber" size="24"
                                                    type="text" value="" style="WIDTH: 144px; HEIGHT: 20px">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right" height="20" style="width: 100px" nowrap><fmt:message
                                                        key="u8.initial.password.label" />：</td>
                                                <td height="20" nowrap><input id="U8_Password"
                                                    name="U8_Password" size="24" type="password"
                                                    value="${u8UserMapperBean.password }"
                                                    style="WIDTH: 144; HEIGHT: 20"></td>
                                            </tr>
                                            <tr>
                                                <td align="right" height="20" style="width: 100px" nowrap><fmt:message
                                                        key="u8.initial.passwordconfirm.label" />：</td>
                                                <td height="20" nowrap><input id="U8_Password2"
                                                    maxlength="24" name="U8_Password2" size="24"
                                                    type="password" value="${u8UserMapperBean.password }"
                                                    style="WIDTH: 144; HEIGHT: 20"></td>
                                            </tr>
                                            <tr>
                                                <td align="right" height="20" style="width: 100px" nowrap><fmt:message
                                                        key="u8.initial.defaultaccount.label" />：</td>
                                                <td height="20" nowrap><input id="AccountNo"
                                                    name="AccountNo" size="24" type="text"
                                                    value="${u8UserMapperBean.accountNo}"
                                                    style="WIDTH: 144; HEIGHT: 20" /> <%-- <%if(!"320".equals(u8_version)) {%> --%>
                                                    <img border="0" style="cursor: hand"
                                                    src="<c:url value='/common/images/search-gray.gif'/>"
                                                    width="16" height="16" onClick="check_account_no(this,1);"
                                                    title='<fmt:message key="u8.setuser.title.label"/>'>
                                                </td>
                                                <td nowrap><fmt:message key="u8.setuser.like.label" />：(default)@001</td>

                                            </tr>
                                            <tr style="display:none">
                                                <td align="right" height="20" style="width: 100px" nowrap><fmt:message
                                                        key="u8.setuser.accountyear.label" />：</td>
                                                <td height="20" nowrap><input maxlength="24"
                                                    id="AccountYear" name="AccountYear" size="24" type="text"                                                    
                                                    style="WIDTH: 144; HEIGHT: 20"></td>
                                            </tr>
                                            <tr>
                                                <td align="right" height="20" style="width: 95px" nowrap><fmt:message
                                                        key="u8.setuser.logindate.label" />:</td>
                                                <td><input type="text" name="U8LoginDate"
                                                    id="U8LoginDate" class="cursor-hand" inputName="startTime"
                                                    validate="notNull" value="" style="WIDTH: 144; HEIGHT: 20"
                                                    value="" size="24"
                                                    onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'datetime');"
                                                    ${v3x:outConditionExpression(edit == "1", 'disabled', 'readonly')} />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><select name="u8ver" id="u8ver"
                                                    style="display: none; WIDTH: 144; HEIGHT: 20" size="1"
                                                    title="" disabled="disabled">
                                                        <option value="1">U8V11.0</option>
                                                        <option value="2">U8V11.1</option>
                                                        <option value="3">U8V12.0</option>
                                                </select></td>
                                            </tr>
                                            <tr>
                                                <td align="center" colspan="3">
                                                    <div style="margin-top: 5px;">
                                                        <input name="webportalbtn"
                                                            onClick="initU8User(); openU8Web();" type="button"
                                                            value='<fmt:message key="u8.portal.login.web.label"/>'
                                                            title='<fmt:message key="u8.portal.title.bslogin.label"/>'
                                                            style=""> <input name="csportalbtn"
                                                            onClick="initU8User(); openU8Client();" type="button"
                                                            value='<fmt:message key="u8.portal.login.cs.label"/>'
                                                            title='<fmt:message key="u8.portal.title.cslogin.label"/>'
                                                            style="">
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>

                                    </div>
                                </td>
                            </tr>
                        </table>
                        <p></p>
                    </fieldset>
                </td>
                <!-- summer -->
                <td width="49%" align="center">
                    <fieldset id="wbzz" style="float: right; width: 95%;">
                    
                        <legend>
                            &nbsp;&nbsp;<font size="2"><b><fmt:message
                                        key="u8.initial.wbandhrinfo.label" /></b></font>&nbsp;&nbsp;
                        </legend>
                        <br>
                        <br>
                        <table style="line-height: 32px">
                            <tr class="wb">
                                <td height="20" class="r_word"><fmt:message
                                        key="u8.initial.wbserver.label" />：</td>
                                <td height="20"><input type="text"
                                    value="${U8UserMapperBean.wb_server}" id="u8_server_name_wb"
                                    name="wb_server_name" style="width: 144px;"></td>
                            </tr>
                            <tr class="wb">
                                <td height="20" class="r_word"><fmt:message
                                        key="u8.initial.wbaccount.label" />：</td>
                                <td height="20"><input id="wb_account_no"
                                    name="wb_account_no" style="width: 144px; HEIGHT: 20;"
                                    type="text" value="${u8UserMapperBean.wb_accountNo }"></input>
                                    <img border="0" style="cursor: hand"
                                    src="<c:url value='/common/images/search-gray.gif'/>"
                                    width="16" height="16" onClick="check_account_no(this,2);"
                                    title='<fmt:message key="u8.setuser.title.label"/>'></td>
                            </tr>
                            <tr class="wb" style="display:none">
                                <td height="20" class="r_word"><fmt:message
                                        key="u8.initial.wbaccountyear.label" />：</td>
                                <td height="20"><input id="wb_account_year"
                                    name="wb_account_year" style="width: 144px; HEIGHT: 20;"
                                    type="text" /></td>
                            </tr>
                            <tr class="hr">
                                <td height="20" class="r_word"><fmt:message
                                        key="u8.initial.hrserver.label" />：</td>
                                <td height="20"><input id="u8_server_name_zz"
                                    name="zz_server_name" style="width: 144px;" type="text"
                                    value="${u8UserMapperBean.hr_server }"></td>
                            </tr>
                            <tr class="hr">
                                <td height="20" class="r_word"><fmt:message
                                        key="u8.initial.hraccount.label" />：</td>
                                <td height="20"><input id="zz_account_no"
                                    name="zz_account_no" style="width: 144px; HEIGHT: 20;"
                                    type="text" value="${u8UserMapperBean.hr_accountNo }" /> <img
                                    border="0" style="cursor: hand"
                                    src="<c:url value='/common/images/search-gray.gif'/>"
                                    width="16" height="16" onClick="check_account_no(this,3);"
                                    title='<fmt:message key="u8.setuser.title.label"/>'></td>
                            </tr>
                            <tr class="hr" style="display:none">
                                <td height="20" class="r_word"><fmt:message
                                        key="u8.initial.hraccountyear.label" />：</td>
                                <td height="20"><input id="zz_account_year"
                                    name="zz_account_year" style="width: 144px; HEIGHT: 20;"
                                    type="text" /></td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
            </tr>
        </table>
        <p align="center">
            <input name="defineFlow" style="width: 70px;" type="submit"
                value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />">

        </p>
    </form>
    <form id="u8webform" name="u8webform" method="post" target="_blank"
        action="">
        <input id="logininfo" name="logininfo" type="hidden" value="2178" />
    </form>
    <div id="myselectAcc" align="center"
        style="display: none; position: absolute; border: 1px solid #737168; height: 120px; left: 400px; top: 200px; background: #F1F1EF;"
        title='<fmt:message key="u8.initial.title.account.label"/>' onClick="">
        <table border="0" width="100%" cellpadding="0" id="table1"
            cellspacing="0">
            <tr>
                <td align="left" valign="top" nowrap
                    style="font-weight: bold; color: #FFFFFF; background: #7B99E1; line-height: 18px; padding-left: 5px; border-bottom: 1px solid #C0C0C0;"><fmt:message
                        key="u8.initial.title.accountselect.label" /><br></td>
            </tr>
            <tr>
                <table id="table2">

                </table>
            </tr>
        </table>
        <div
            style="margin-top: 30px; border-top: 1px solid #D6D6D3; padding-top: 5px;">
            <input type="button"
                value='<fmt:message key="u8.common.cancel.label"/>' name="B2"
                onClick="closeAcclist()" style="width: 50">
        </div>
    </div>
</body>
</html>
<script>
    function msg(){
        if("${msg}"){
            alert('<fmt:message key="u8.setuser.alert.success.error"/>');
        }
    }
    window.setTimeout(msg,100);
</script>