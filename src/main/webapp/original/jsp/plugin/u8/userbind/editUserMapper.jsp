<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@include file="header_userMapper.jsp"%>

<script type="text/javascript">
	function submitForm(){
		var serverName = document.getElementById("serverName").value;
		if(serverName == ""){
			alert('<fmt:message key="u8.bind.noserver.error"/>');
			return false;
		}
		var oldNcUserCodes = "${member.stateName}";
		var valideLogin = document.getElementById("valideLogin").value;
        var u8UserCodes = encodeURI(document.getElementById("u8UserCodes").value);
        var newNcUserCodes = (document.getElementById("u8UserCodes").value).replace(/\s+/g,"");

		if(oldNcUserCodes=='' && newNcUserCodes==''){
			alert('<fmt:message key="u8.bind.bindno.error"/>');
			document.getElementById("u8UserCodes").value = "";
			document.getElementById("u8UserCodes").focus();
			return false;
		}
	    var form = document.getElementById("userMapperForm");
	   /*  if(checkForm(form)){ */
	   parent.detailFrame.location.href = "${urlU8UserMapper}?method=updateUserMapper&id=${member.v3xOrgMember.id}&valideLogin="+valideLogin+"&u8UserCodes="+u8UserCodes+"&oper=update&serverName="+serverName;
	    /* } */
	}
	
	function init(){
		if(!"${u8User}" && "${u8UserInfoBean}" && "${v3x:escapeJavascript(oper)}"!= 'edit'){
			document.getElementById("serverName").value = "${u8UserInfoBean.u8_server_name}";
		}
		if("${v3x:escapeJavascript(oper)}"!= 'edit' && (document.getElementById("serverName").length==0 || document.getElementById("serverName").options[document.getElementById("serverName").selectedIndex].text.indexOf("[")!=-1)){
			var option = new Option("","");
			document.getElementById("serverName").options.add(option);
			document.getElementById("serverName").value = "";
		}
	}
</script>
</head>
<body scroll="no" style="overflow: no" onload="init();">
<form id="userMapperForm" method="post" target="editMemberFrame" action="${urlU8UserMapper}?method=updateUserMapper&id=${member.v3xOrgMember.id}" onsubmit="return (submitForm(this))">
	<input type="hidden" name="id" value="${member.v3xOrgMember.id}" />
	<input type="hidden" name="orgAccountId" value="${member.v3xOrgMember.orgAccountId}" />
	<input type="hidden" id="valideLogin" name="valideLogin"  value="${member.v3xOrgMember.loginName}">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
			getDetailPageBreak(); 
		</script>
		</td>
	</tr>
	<tr>
		<td class="">
			<div class="scrollList">
<table width="100%" border="0" cellspacing="0" height="96%" cellpadding="0" align="center">
  <tr valign="top">
    <td width="50%">
    <fieldset style="width:95%;border:0px;" align="center">
		<table width="50%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td class="bg-gray" nowrap="nowrap" align="right">
					<div class="hr-blue-font"></div>
				</td>
				<td>&nbsp;</td>				
			</tr>	
			<tr>
			  	<td class="bg-gray" width="45%" nowrap="nowrap"><fmt:message key="u8.server.label"/>:</td>
				<td class="new-column" width="55%" nowrap="nowrap">
					<c:if test="${oper != 'edit'}">
					<select name="serverName" id="serverName"  class="input-100per" deaultValue="${u8User.u8ServerName}"
						inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />" maxSize="40" maxlength="20" validate="notNull,isDeaultValue,maxLength,isWord" character="|,"
					     escapeXml="true" default='${defName}' />
					     <c:forEach items="${serverList }" var="server">
					     	<c:if test="${server.has_u8==1}">
					     		<c:if test="${server.u8_server_name==u8User.u8ServerName}">
					     			<c:if test="${server.dataSource!=null }">
					     				<option value="${server.u8_server_name}" selected="selected" title="${server.u8_server_name}">${server.u8_server_name}</option>
					     			</c:if>
					     			<c:if test="${server.dataSource==null }">
					     				<option value="${server.u8_server_name}" disabled="disabled" selected="selected" title="${server.u8_server_name}" >${server.u8_server_name}<font><fmt:message key="u8.bind.noinitial.label"/></font></option>
					     			</c:if>
					     		</c:if>
					     		<c:if test="${server.u8_server_name!=u8User.u8ServerName}">
		                 			<c:if test="${server.dataSource!=null }">
						     				<option value="${server.u8_server_name}" title="${server.u8_server_name}">${server.u8_server_name}</option>
						     			</c:if>
						     			<c:if test="${server.dataSource==null }">
						     				<option value="${server.u8_server_name}" disabled="disabled" title="${server.u8_server_name}" >${server.u8_server_name}<font><fmt:message key="u8.bind.noinitial.label"/></font></option>
						     			</c:if>
		                 			</c:if>
	                 		</c:if>
					     </c:forEach>
					    
					</select>
					</c:if>
					<c:if test="${oper == 'edit'}">
						<input type="text" id="serverName" value="${u8User.u8ServerName}" disabled="disabled" class="input-100per" maxSize="40" maxLength="20">
					</c:if>
				</td>	
			</tr>
			<tr>
			  	<!-- <td class="bg-gray" width="45%" nowrap="nowrap">操&nbsp;作&nbsp;员:</td> -->
			  	<td class="bg-gray" width="45%" nowrap="nowrap"><fmt:message key="u8.bind.account.label"/>:</td>
				<td class="new-column" width="55%" nowrap="nowrap">
				<input class="input-100per" type="text" name="u8UserCodes" maxSize="40" maxLength="100" <c:if test="${oper == 'edit'}">disabled readonly="readonly"</c:if>
					id="u8UserCodes" value="${member.stateName}" validate="isWord" character="，"
					inputName="<fmt:message key="nc.user.account" />" /></td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"></td>
				<td class="new-column" width="75%" nowrap="nowrap"><font color="#008000"><fmt:message key="u8.bind.node.label"/></font></td>
			</tr>
		</table>
	</fieldset>
	<p></p>
    	
    </td width="50%">
    <td  valign="top">
    <fmt:message key="org.member.noPost" var="noPostLabel"/>
    	<fieldset style="width:95%;border:0px;" align="center">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
			<td colspan="2">
			<div id="intenalDiv">
			</div>
			</td>
			</tr>				   
		</table>
	</fieldset>
	<p></p>    	
    </td>
  </tr>  
</table>
			</div>		
		</td>
	</tr>
	<c:if test="${!readOnly}">
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input id="submintButton" type="button" <c:if test="${oper == 'edit'}">style="display:none"</c:if> onclick="submitForm()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
			<input id="submintCancel" type="button" <c:if test="${oper == 'edit'}">style="display:none"</c:if> onclick="previewFrame('Down');" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
	</c:if>
</table>

</form>
<iframe name="editMemberFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>

</body>
</html>