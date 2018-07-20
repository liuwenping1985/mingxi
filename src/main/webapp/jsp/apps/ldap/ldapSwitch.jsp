<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.plugin.ldap.resource.i18n.LDAPSynchronResources"/>
<html>
<head>
<title>ldap/ad</title>
<script type="text/javascript">
showCtpLocation("T02_ldapSetup");
//getCTPTop().hiddenNavigationFrameset(2308);
function checkAutoForm(form) {
  if (document.getElementById("ldapEnabled1").checked) {
    if (document.getElementById("count").value.indexOf("\"") != -1) {
      alert("<fmt:message key='ldap.switch.prompt'/>");
      return false;
    }
    return true;
  }
  if (checkForm(form)) {
    if (!document.getElementById("ldapEnabled1").checked) {
      document.getElementById("ldapEnabled1").checked = true;
      document.getElementById("ldapEnabled1").value = "1";
    }
    if (document.getElementById("count").value.indexOf("\"") != -1) {
      alert("<fmt:message key='ldap.switch.prompt'/>");
      return false;
    }
    return true;
  } else {
    return false;
  }
}
function changeEnable() {
  document.getElementById("ldapEnabled1").checked = false;

  document.getElementById("ldapEnabled1").value = "1";
  if (document.getElementsByName("ldapAdEnabled")[1].checked) {
    document.getElementById("ldapselectTR").style.display = "none";
    document.getElementById("ldapADTR").style.display = "";
    document.getElementById("ldapADTR1").style.display = "";

  } else {
    document.getElementById("ldapselectTR").style.display = "";
    document.getElementById("ldapADTR").style.display = "none";
    document.getElementById("ldapADTR1").style.display = "none";
  }

}
function changeEnabled() {
  if (document.getElementsByName("ldapAdEnabled")[1]) {
    document.getElementsByName("ldapAdEnabled")[1].checked = false;
  }
  if (document.getElementsByName("ldapAdEnabled")[0]) {
    document.getElementsByName("ldapAdEnabled")[0].checked = false;
  }
  document.getElementById("ldapEnabled1").value = "0";
  document.getElementById("ldapselectTR").style.display = "none";
  document.getElementById("ldapADTR").style.display = "none";
  document.getElementById("ldapADTR1").style.display = "none";
}

//增加用户体验,如果端口号是389并支持SSL自动把端口改为686
//如果端口号不是389并支持SSL，那保留用户所设置端口号
function checkPort() {
  var portValue = document.getElementById("ldapPort").value;
  var defaultPort = "389";
  var isEnbleAD = document.getElementById("ldapEnabled3").checked;
  var ldapSSLEnabled = document.getElementById("ldapSSLEnabled").checked
  if (ldapSSLEnabled && isEnbleAD) {
    document.getElementById("ldapPort").value = "636";
  } else if (!ldapSSLEnabled) {
    document.getElementById("ldapPort").value = defaultPort;
  }
}

function openHelp() {
  var returnValue = v3x.openWindow({
    url: "${ldapSynchron}?method=openHelp",
    width: 400,
    height: 350,
    dialogType: 'open',
    resizable: "no"
  });
}
function setPrincipal() {
  document.getElementById("principal").value = "HTTP/" + document.getElementById("hostName").value + "." + document.getElementById("domainName").value + "@" + document.getElementById("domainName").value;

}
</script>
</head>
<body scroll="no">
<div class="scrollList">
<form name="ldapSwitchForm" action="${ldapSynchron}?method=saveLdapSwitchParams" method="post" onsubmit="return (checkAutoForm(this))" >
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="border_b">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="setLdapSwitch"></div></td>
						<td class="page2-header-bg">&nbsp;<fmt:message key="ldap.system.name" /></td>
						<td align="right"><a href="javascript:openHelp()" class="like-a"><fmt:message key="common.toolbar.help.label" bundle="${v3xCommonI18N}"/></a></td>
			     		<td class="page2-header-line padding5" width="20">&nbsp;</td>
			      </tr>
			 </table>
		</td>
	</tr>

	<tr>
		<td width="100%" align="center" colspan="2" >
		<fieldset style="width: 80%">
		 <legend><b><fmt:message key='ldap.tip.set' /></b></legend>
				<table  width="100%" height="100%"  border="0" align="center">
				 <tr>
			           <td width="10%"></td>
			           <td width="20%" align="right"  valign="top" style="padding-top:5px"><fmt:message key="ldap.system.state" />:&nbsp;</td>
			            <td width="30%" align="left" colspan="3">
			            <label for="ldapEnabled1">
			            <input type="radio" id="ldapEnabled1" onclick="changeEnabled()" name="ldapEnabled" value="0" <c:if test="${v3xLdapSwitchBean.ldapEnabled==0}">checked="checked"</c:if>><fmt:message key="ldap.system.notenable" /></label>&nbsp;<br>
			            <label for="ldapEnabled2">
			            <input type="radio" id="ldapEnabled2" onclick="changeEnable()" name="ldapAdEnabled" value="ldap" <c:if test="${v3xLdapSwitchBean.ldapEnabled==1}"><c:if test="${v3xLdapSwitchBean.ldapAdEnabled=='ldap'}">checked="checked"</c:if></c:if>><fmt:message key="ldap.system.enabled" /></label>&nbsp;<br>
			            <label for="ldapEnabled3">
			            <input type="radio" id="ldapEnabled3" onclick="changeEnable()" name="ldapAdEnabled" value="ad" <c:if test="${v3xLdapSwitchBean.ldapEnabled==1}"><c:if test="${v3xLdapSwitchBean.ldapAdEnabled=='ad'}">checked="checked"</c:if></c:if>><fmt:message key="ldap.system.enable" /></label>&nbsp;
			            </td>
					     <td width="10%"></td>
			         </tr>
					 <tr>
					    <td width="10%"></td>
			            <td width="20%" align="right"><fmt:message key="ldap.system.url" />:&nbsp;</td>
						<td width="10%" align="left">
						  <input name="ldapUrl" type="text" validate="notNull" inputName="<fmt:message key="ldap.system.url" />" id="count"  style='width: 200px' value="${v3xLdapSwitchBean.ldapUrl }">			
						</td>
					     <td width="10%"></td>
					     <td width="10%"></td>
					     <td width="10%"></td>
			         </tr>
			         <tr>
				         <td width="10%"></td>
				         <td width="20%" align="right"><fmt:message key="ldap.system.port" />:</td>
				         <td width="10%" align="left">
				           <input name="ldapPort" type="text" validate="notNull,isInteger" inputName="<fmt:message key="ldap.system.port" />" id="ldapPort"  maxlength="5" style='width: 200px' value="${v3xLdapSwitchBean.ldapPort}">
						 </td>
						 <td width="10%">
						 </td>
						 <td width="10%"></td>
					     <td width="10%"></td>
				         </tr>
				        
			         <tr>
					    <td width="10%"></td>
			            <td width="20%" align="right"><fmt:message key="ldap.system.basedn" />(Base DN):&nbsp;</td>
						<td width="10%" align="left">
						  <input name="ldapBasedn" type="text" validate="notNull" inputName="<fmt:message key="ldap.system.basedn" />" id="ldapBasedn"  style='width:200px' value="${v3xLdapSwitchBean.ldapBasedn}">			
						</td>
					     <td width="10%"></td>
					     <td width="10%"></td>
					     <td width="10%"></td>
			         </tr>
			 
			         <tr>
					    <td width="10%"></td>
			            <td width="20%" align="right"><fmt:message key="ldap.system.admin" />:&nbsp;</td>
						<td width="10%" align="left">
						  <input name="ldapAdmin" type="text" validate="notNull" inputName="<fmt:message key="ldap.system.admin" />" id="count"  style='width: 200px' value="${v3xLdapSwitchBean.ldapAdmin}">			
						</td>
					     <td width="10%"></td>
					     <td width="10%"></td>
					     <td width="10%"></td>
			         </tr>
			          <tr>
					    <td width="10%"></td>
			            <td width="20%" align="right"><fmt:message key="ldap.system.pw" />:&nbsp;</td>
						<td width="10%" align="left">
						  <input name="ldapPassword" type="password" validate="notNull" inputName="<fmt:message key="ldap.system.pw" />" id="ldapPassword"  style='width: 200px' value="${v3xLdapSwitchBean.ldapPassword}">			
						</td>
					     <td width="10%"></td>
					     <td width="10%"></td>
					     <td width="10%"></td>
			         </tr>
			         <tr  id="ldapselectTR" <c:if test="${v3xLdapSwitchBean.ldapEnabled==0||v3xLdapSwitchBean.ldapAdEnabled=='ad'}">style="display:none;"</c:if>>
					    <td width="10%"></td>
			            <td width="20%" align="right"><fmt:message key="ldap.system.ldaptype" />:&nbsp;</td>
						<td width="10%" align="left">
						  <select name="ldapServerType"  class="condition" style='width: 200px'>
						<c:forEach items="${ldapMap}" var="map1">
						 <option value="<c:out value="${map1.key}"/>" <c:if test="${v3xLdapSwitchBean.ldapServerType==map1.key}">selected</c:if>><c:out value="${map1.value}"/></option>
						  </c:forEach>
						  </select>
						</td>
					     <td width="10%"></td>
					     <td width="10%"></td>
					     <td width="10%"></td>
			         </tr>
			         <tr id="ldapADTR"  <c:if test="${v3xLdapSwitchBean.ldapEnabled==0||v3xLdapSwitchBean.ldapAdEnabled=='ldap'}">style="display:none;" </c:if>>
			         	<td width="10%"></td>
			         	<td width="20%" align="right">
							<fmt:message key='ldap.system.ssl.enable' />:                        	
                        </td>
			         	<td width="10%" align="left">
			         		<label for="ldapSSLEnabled">
			         		<input type="checkbox" id="ldapSSLEnabled"  onclick="checkPort();" name="ldapSSLEnabled" value="1" <c:if test="${v3xLdapSwitchBean.ldapEnabled==1 && v3xLdapSwitchBean.ldapSSLEnabled == 1}">checked="checked"</c:if>/></label>
			         	</td>
			         	  <td width="10%"></td>
					     <td width="10%"></td>
					     <td width="10%"></td>
			         </tr>
				        
			     </table>	
			     </fieldset>	
		</td>
	</tr>
	<tr id="ldapADTR1" <c:if test="${v3xLdapSwitchBean.ldapEnabled==0||v3xLdapSwitchBean.ldapAdEnabled=='ldap'}">style="display:none;" </c:if>>
		<td width="100%" align="center" colspan="2" >
		 	     <fieldset style="width: 80%">
		         <legend><b><fmt:message key='ldap.tip.sso' /></b></legend>
		    <table  width="100%" border="0" align="center">
		      <tr>
			         	 <td width="10%"></td>
			         	<td width="10%" align="right">
							<fmt:message key='ldap.tip.sso.webname' />:                        	
                        </td>
			         	<td width="20%" align="left">
			         		<input name="hostName" type="text"  id="hostName"  style='width: 200px' value="${v3xLdapSwitchBean.hostName}" >
			         	</td>
			         	   <td width="10%"></td>
					     <td width="10%"></td>
					     <td width="10%"></td>
			         	</tr>
			         	 <tr>
			         	 <td width="10%"></td>
			         	<td width="10%" align="right">
							<fmt:message key='ldap.tip.sso.domainname' />:                        	
                        </td>
			         	<td width="20%" align="left">
			         	<input name="domainName" type="text"   id="domainName"  style='width: 200px' value="${v3xLdapSwitchBean.domainName}" onblur="setPrincipal()">
			         	</td>
			         	   <td width="10%"></td>
					     <td width="10%"></td>
					     <td width="10%"></td>
			         </tr>
			            <tr>
			         	 <td width="10%"></td>
			         	<td width="10%" align="right">
							Principal:                        	
                        </td>
			         	<td width="20%" align="left">
			         	<input name="principal" type="text"   id="principal"  style='width: 200px' value="${v3xLdapSwitchBean.principal}">
			         	</td>
			         	   <td width="10%"></td>
					     <td width="10%"></td>
					     <td width="10%"></td>
			         </tr>
			         </table>
		 </fieldset>
		</td>
		</tr>
		
	<tr>
		<td colspan="2" height="42" align="center" class="bg-advance-bottom">
			<input type="submit" value="<fmt:message key="ldap.system.save" />" class="button-default_emphasize">&nbsp;&nbsp;
			<input type="button" onclick="getA8Top().backToHome()" value="<fmt:message key="ldap.system.canel" />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
</div>
</body>
</html>