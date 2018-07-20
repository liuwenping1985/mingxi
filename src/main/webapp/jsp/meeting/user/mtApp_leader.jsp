<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/taglib.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/shortcut.js${v3x:resSuffix()}" />"></script>
<c:if test="${fromType==2}">
<title><fmt:message key="oper.please.select"/><fmt:message key="mt.list.toolbar.readright"/></title>
</c:if>
<c:if test="${fromType==1}">
<title><fmt:message key="oper.please.select"/><fmt:message key="mt.mtMeeting.approve"/></title>
</c:if>
<script type="text/javascript">

function setDisplayCol(){
	var target = document.getElementById("menuTargetSelect");
	var opvalue = "";
	var opname = "";
	var initW = dialogArguments; //获得父窗口对象
	for(i=0;i<target.options.length;i++){
		var v = target.options[i].value;
		var userId = v.substring(0,v.indexOf("|"));
		var userName = v.substring(v.indexOf("|")+1);
		if(initW.document.getElementById('type')!=null && initW.document.getElementById('type').value=="2") {
			opvalue += "Member|"+userId+",";
		} else {
			opvalue += userId+",";
		}
		var name = userName;
		opname += name+",";
	}
	if(opvalue.lastIndexOf(",") == opvalue.length-1){
		opvalue = opvalue.substring(0,opvalue.length-1);
		opname = opname.substring(0,opname.length-1);
	}
	<c:if test="${fromType!=2}">
	    if(opvalue == ""){
	    	alert(v3x.getMessage("meetingLang.choose_auth_people"));
	    	return false;
	    }
    </c:if>
    if(${fromType!=3}) {
	  //设置收文情况
		initW.document.getElementById('approves').value=opvalue;
		initW.document.getElementById('approvesNames').value=opname;
	} else {
		initW.document.getElementById('auditors').value=opvalue;
		initW.document.getElementById('auditorNames').value=opname;
	}
	var runValue = new Array; 
	runValue[0] = opvalue;
	runValue[1] = opname;
	window.returnValue = runValue;
	window.close();
}

</script>
</head>
<body scroll="no">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle">
			<c:choose>
				<c:when test="${type=='hytz'}">
					<fmt:message key="oper.please.select"/><fmt:message key="mt.list.toolbar.readright"/>
				</c:when>
				<c:otherwise>
					<fmt:message key="oper.please.select"/><fmt:message key="mt.mtMeeting.approve"/>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" align="center" height="100%" border="0" cellpadding="0" cellspacing="0">
              <tr>
		        <td width="100%" valign="top" >
		         <table width="100%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0">
		              <tr>
				        <td width="150" height="30" align="center" >
				        	<b><fmt:message key="shortcut.all.label" bundle="${v3xMainI18N}"/></b>
				        </td>
				        <td width="15">&nbsp;</td>
				        <td width="150" align="center">
				        	<b><fmt:message key="selectPeople.selected.label"  bundle="${v3xMainI18N}"/></b>
				         </td>
				         <td width="20">&nbsp;</td> 
				     </tr>
		              <tr>
				        <td align="center">
						    <SELECT name="menuSourceSelect" size="16" id="menuSourceSelect" multiple style="width:170px; height: 250px;_height: 220px;" ondblclick="addThisItem('menu')">
								<c:forEach items="${leftMap }" var="edoc">
									<option value="${edoc.key }">${edoc.value }</option> 
								</c:forEach>
						    </SELECT>
				        </td>
				        <td align="center">
			         		<img alt="<fmt:message key='selectPeople.alt.select'/>" src="<c:url value="/common/images/arrow_a.gif"/>" width="15"
									height="12" class="cursor-hand" onClick="addThisItem('menu')"><br/><br/>
							<img alt="<fmt:message key='selectPeople.alt.unselect'/>" src="<c:url value="/common/images/arrow_del.gif"/>" width="15"
									height="12" class="cursor-hand" onClick="removeThisItem('menu')">
						</td>
				        <td align="center">
						    <SELECT name="menuTargetSelect" size="16" id="menuTargetSelect" multiple style="width:170px; height: 250px; _height: 220px;" ondblclick="removeThisItem('menu')">
								<c:forEach items="${targetMap }" var="edoc">
									<option value="${edoc.key }">${edoc.value }</option> 
								</c:forEach>
						    </SELECT>
						    <input type="hidden" name="menuSpareIds" id="menuSpareIds" value="">
						    <input type="hidden" name="oldMenuSpareIds" id="oldMenuSpareIds" value="">
				        </td>
				        <td>
			         		<p><img alt="<fmt:message key='selectPeople.alt.up'/>" src="<c:url value="/common/images/arrow_u.gif"/>" width="12"
									height="15" class="cursor-hand" onClick="moveUp('menu')"></p><br/>
							<p><img alt="<fmt:message key='selectPeople.alt.down'/>" src="<c:url value="/common/images/arrow_d.gif"/>" width="12"
									height="15" class="cursor-hand" onClick="moveDown('menu')"></p>
						</td>
				     </tr>
					</table>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
		        <input type="button" onclick="return setDisplayCol();" id="submitButton" name="submitButton" value="<fmt:message key='common.button.ok.label'  bundle="${v3xCommonI18N}"/>" class="button-default_emphasize">&nbsp;&nbsp;
				<input type="button" onclick="window.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>
</body>
</html>