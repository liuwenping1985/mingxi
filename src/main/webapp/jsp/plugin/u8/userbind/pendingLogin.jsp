<%@page import="com.seeyon.ctp.util.DateUtil"%>
<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>U8门户登陆中</title>
<%@include file="header_userMapper.jsp"%>
<OBJECT ID="runUC_CS"
    CLASSID="CLSID:0EB1A30A-D7BB-40BE-8A13-EB5C1A2CA8D8"
    codebase="<%=request.getContextPath()%>/OpenUC.dll" width=0 heigh=0></OBJECT>
<OBJECT ID="runUC_U8Login"
    CLASSID="CLSID:F11BA142-3738-4632-9364-E873BA72DAA9"
    codebase="<%=request.getContextPath()%>/UFSoft.U8.Framework.Login.UI.dll"
    width=0 heigh=0></OBJECT>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js" />"></script>
<script type="text/javascript">
var aU8users; //系统管理员/用户连接设置的初始账号
var u8Ver;
var u8operlist; //已经存取在映射表里的u8操作员信息  //oa perid,oa truename,oa username,u8 loginname
var u8userlist; //U8所有操作员的信息 //u8 loginame,u8 truename,U8 pass
var drawlist;
function init(){
  var logindate = '<%=DateUtil.getDate("yyyy-MM-dd HH")%>'+":00";
  document.getElementById("U8LoginDate").value = logindate;
  initU8User();
  openU8Client();
  window.close();
}
function U8users(account,username,password,server,accountyear,logindate){
    this.account=account;//帐套
    this.username=username;//操作员
    this.password=password;//操作员密码
    this.server= server;//U8服务器
    this.accountyear=accountyear;//会计年份
    this.logindate=logindate;//登录日期
}
function initU8User(){
  var logindate = document.all.U8LoginDate.value;
  if(logindate.indexOf(" ")!=-1){
      logindate = logindate.substring(0,logindate.indexOf(" "));
  }  
  aU8users = new U8users(document.all.AccountNo.value ,document.all.U8_UserNumber.value,document.all.U8_Password.value,document.all.u8_server_name.options[document.all.u8_server_name.selectedIndex].getAttribute("selfdef"),logindate.substr(0,4),logindate);
}          
//U8 C/S单点登录
function openU8Client(){    
    var account=aU8users.account;
    var outParam;    
        outParam= "\""+account+""+"\t"
              +aU8users.accountyear+"\t"
              +aU8users.username+"\t"
              +aU8users.password+"\t"
              +aU8users.logindate+"\t"
              +aU8users.server+"\t"
              +"zh-cn\"";    
        openUC(outParam);
}

function openUC(params)
{  
  var szParam="-L:";               
  szParam+=params;
  try{                    
      runUC_CS.OpenUC2("EnterprisePortal.exe",szParam);
    
  }catch(ex){
    alert(ex.message);
    return;
  }
}
</script>
</head>
<body onload="init();">
    <form id="myform" name="myform" method="post" action=""
        onsubmit="if(!check()){return false;};formsubmit();">
        <table width="100%" border="0" cellpadding="0" cellspacing="0"
            style="margin-top: 10px;display: none;">
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
                                                    type="text" value="${u8UserMapperBean.perator }" style="WIDTH: 144px; HEIGHT: 20px">
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
                                                    style="WIDTH: 144; HEIGHT: 20" /> 
                                                    
                                                </td>

                                            </tr>                                           
                                            <tr>
                                                <td align="right" height="20" style="width: 95px" nowrap><fmt:message
                                                        key="u8.setuser.logindate.label" />:</td>
                                                <td><input type="text" name="U8LoginDate"
                                                    id="U8LoginDate" value=""/>
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
            </tr>
        </table>
        
    </form>
    
    
</body>
</html>