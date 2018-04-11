<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>A8</title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
v3x.loadLanguage("/apps_res/systemmanager/js/i18n");
getA8Top().showCtpLocation("F16_UCcenter_Cloud");
</script>
<style>
html,body{height:100%;}
</style>
</head>
<body scroll="no" style="overflow: no">
    <div id="fromDiv"></div>
  <input type="hidden" value="${path }" id="pathmall"/>
  <input type="hidden" value="${appLable }" id="appLable"/>
  <form action="${path}/cloudapp/cloudapp.do?method=save" method="post" style="height:100%">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
    <tr>
        <td valign="top" class="padding5">
            <table align="center" width="550" cellpadding="0" cellspacing="0">  
                <tr>
                    <td height="50">&nbsp;</td>
                    <td height="50">&nbsp;</td>
                </tr>
                <tr>
                <td width="120" align="right">显示应用中心入口:&nbsp;&nbsp; </td>
                <td height="26"> 
                    <input type="radio" name="cloudapp" value="1" checked="checked" id="radioYes"/>是
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="cloudapp" value="0" id="radioNo"/>否
                 </td>
                </tr>
                <tr height="20"></tr>
                <tr>
                <td align="right">设置云管理员:&nbsp;&nbsp;</td>
                <td height="80"> 
                    <div>
                        <div style="display:inline-block;">
                            <textarea id="peopleid" cols="60" rows="6" name="comment" inputName="${commentLabel}" validate="notNull" maxSize="50">${cloudAdmin }</textarea>
                        </div>
                        <a id="cloudappset" style="display:inline-block;margin-left:3px; cursor:pointer;">设置</a> 
                    </div>
                    <input type="hidden" id="authValue" name="authValue" value="${value }"/>
                    <input type="hidden" id="memberIds" name="memberIds" value="${memberIds }"/>
                    <input type="hidden" id="setResult" name="setResult" value="${setResult }"/>
                </td>
                </tr>
                <tr height="30"></tr>
                <tr>
                    <td colspan="2">
                        <p class="description-lable">
                            <b>
                                <fmt:message key="common.instructions.label" bundle="${v3xCommonI18N}" />
                            </b><br/>
                            <b>
                                1、应用中心管理员可以在协同中收到致远服务进度消息、使用数据清理等服务工具
                            </b>
                            <b><br/>
                                 2、只有在应用中心做了账号验证的用户，才能被设置为应用中心管理员
                            </b>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr height="100">
        <td></td>
    </tr>
    <tr>
        <td height="42" align="center" class="bg-advance-bottom">
            <input type="submit" ${isShutdown?'disabled':''} value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">
            &nbsp;&nbsp;&nbsp;&nbsp; 
            <input type="button" name="Input2" onclick="getA8Top().backToHome()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
            &nbsp;&nbsp;&nbsp;&nbsp;<a href="${path}/mallindex.do" target="_blank" class="button-default_emphasize">去应用中心看看</a>
        </td>
    </tr>
</table>
</form>
</body>
<script src="${path}/apps_res/cloud/js/cloudset.js"></script>
</html>