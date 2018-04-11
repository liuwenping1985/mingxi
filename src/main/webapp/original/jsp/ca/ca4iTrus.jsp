<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.util.json.JSONUtil,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.constants.ProductEditionEnum,java.util.Locale"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%
    response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setDateHeader("Expires", 0);
	boolean isDevelop = AppContext.isRunningModeDevelop();
    String ctxPath =request.getContextPath(),  ctxServer = request.getScheme()+"://" + request.getServerName() + ":"
                    + request.getServerPort() + ctxPath;
    Locale locale = AppContext.getLocale();
%>
<!DOCTYPE html>
<c:set var="path" value="${pageContext.request.contextPath}" />
<script type="text/javascript">
  var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
  var _locale = '<%=locale%>',_isDevelop = <%=isDevelop%>,_sessionid = '<%=session.getId()%>',_isModalDialog = false;
  var _editionI18nSuffix = '<%=ProductEditionEnum.getCurrentProductEditionEnum().getI18nSuffix()%>';
  <c:if test="${param._isModalDialog == 'true' || param.isFromModel == 'true'}">
  _isModalDialog = true;
  </c:if>
  var _resourceCode = "${ctp:escapeJavascript(param._resourceCode)}";
  var seeyonProductId="${ctp:getSystemProperty("system.ProductId")}";
</script>
<!-- <link href="${path}/common/images/${ctp:getSystemProperty('portal.porletSelectorFlag')}/favicon${ctp:getSystemProperty('portal.favicon')}.ico${ctp:resSuffix()}" type="image/x-icon" rel="icon"/>
<link rel="stylesheet" href="${path}/common/all-min.css${ctp:resSuffix()}">
<link rel="stylesheet" href="${path}/common/css/dd.css${ctp:resSuffix()}"> -->
<c:if test="${CurrentUser.skin != null}">
<link rel="stylesheet" href="${path}/skin/${CurrentUser.skin}/skin${CurrentUser.fontSize}.css${ctp:resSuffix()}">
</c:if>
<c:if test="${CurrentUser.skin == null}">
<link rel="stylesheet" href="${path}/skin/default/skin${CurrentUser.fontSize}.css${ctp:resSuffix()}">
</c:if>
<script type="text/javascript" src="${path}/i18n_<%=locale%>.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/jquery.dd-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/calendar/calendar-<%=locale%>.js${ctp:resSuffix()}"></script>
<c:set var="loginTime" value="${ CurrentUser !=null ? CurrentUser.etagRandom : 0}" />
<script type="text/javascript" src="${path}/main.do?method=headerjs&login=${loginTime}"></script>
<script type="text/javascript">

var addinMenus = new Array();
<c:forEach var="addinMenu" items="${AddinMenus}" varStatus="status">
    var index = ${status.index};
    addinMenus[index] = {pluginId : '${addinMenu.pluginId}',name : '${addinMenu.label}',className : '${addinMenu.icon}',click : '${addinMenu.url}'};
</c:forEach>

$.ctx._currentPathId = '${_currentPathId}';
$.ctx._pageSize = ${ctp:getSystemProperty("paginate.page.size")};
$.ctx.fillmaps = <c:out value="${_FILL_MAP}" default="null" escapeXml="false"/>;
<c:if test="${fn:length(EXTEND_JS)>=0}">

$(document).ready(function() {
    $(window).load(function() {
        <c:forEach var="js" items="${EXTEND_JS}">
            $.getScript("${path}/${js}");
        </c:forEach>
    });
});
</c:if>
$.releaseOnunload();
</script>
<script type="text/javascript" src="${path}/common/js/orgIndex/jquery.tokeninput.js${ctp:resSuffix()}"></script>
<link rel="stylesheet" href="${path}/common/js/orgIndex/token-input.css${ctp:resSuffix()}" type="text/css" />
<%@page import="com.seeyon.ctp.common.constants.SystemProperties"%>
<script src='<c:url value="/apps_res/ca/js/pta.js${v3x:resSuffix()}" />' type="text/javascript"></script>
<script type="text/javascript">
<!--
var arrayCerts;
var CurCert;
var isCa=false;
var isInitedCertList=false;
var userName;
//获取可用证书
function InitCertList(){
	//O=天威诚信（测试）, OU=天威诚信（测试）部, CN=天威诚信（测试）用户CA
	//O=\u5929\u5a01\u8bda\u4fe1\uff08\u6d4b\u8bd5\uff09, OU=\u5929\u5a01\u8bda\u4fe1\uff08\u6d4b\u8bd5\uff09\u90e8, CN=\u5929\u5a01\u8bda\u4fe1\uff08\u6d4b\u8bd5\uff09\u7528\u6237CA
	var arrayIssuerDN = new Array('<%=SystemProperties.getInstance().getProperty("ca.filterstr")%>');
	//证书列表
	try{
	arrayCerts = filterCerts(arrayIssuerDN, 0, "");
	var certMark = document.getElementById("caCertMark");
	certMark.value = "noCaCert";
	$.ajax({
			async: false,
			type : "GET",
			url  : _ctxPath+"/caAccountManagerController.do?method=findKeyNumByLoginName",
			data : {"loginName":userName.value},
			success : function (msg){
				if(msg != "NORecord" && arrayCerts.length > 0){
					if(arrayCerts.length == 1 && GetCertSubject(arrayCerts[0]) == msg){//一个证书
						CurCert=arrayCerts[0];
						isCa = true;
					}else if(arrayCerts.length > 1){ //多个证书
						for(var i=0; i< arrayCerts.length; i++){
							if(GetCertSubject(arrayCerts[i]) == msg){
								CurCert = arrayCerts[i];
								isCa = true;
								break;
							}
						}
					}
					if(isCa){
						certMark.value = "CertMatching";//证书匹配
					}else {
						certMark.value = "noCaCertMatching";
					}
				}
			}
		});
	}catch(e){
		document.getElementById("caCertMark").value = "noCaCert";
	}
}

//检查浏览器CA证书的情况
function checkCaCert(){
	userName = document.getElementById("login_username");
	if(userName){
		InitCertList();
	}
}

function caSign(){	
	var input1=document.createElement("input");
	input1.name="SignedData";
	input1.id="SignedData";
	input1.type="hidden";
	input1.value="";
	var input2=document.createElement("input");
	input2.name="toSign";
	input2.id="toSign";
	input2.type="hidden";
	input2.value="";

	document.loginform.appendChild(input1);
	document.loginform.appendChild(input2);

	<% String toSign = String.valueOf(System.currentTimeMillis());%>
	<% session.setAttribute("ToSign",toSign );%>
	var toS=document.getElementById("toSign");	
	toS.value=<%=toSign%>;
	var signedData = signLogonData(CurCert,toS);
	if(signedData.length > 0){
		document.getElementById("SignedData").value = signedData;
		//alert(toS.value);
		return true;
	} else{
		alert("签名失败，请重新打开登陆页！");
		return false;
	}
}

//-->
</script>

