<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>

<fmt:setBundle
	basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources"
	var="v3xCommonI18N" />
<fmt:setBundle
	basename="com.seeyon.v3x.main.resources.i18n.MainResources" />

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
	<title><fmt:message key="menu.system.service.datatransfer.setting.title"/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
${v3x:skin()}
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/addressbook/js/prototype.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
	var v3x = new V3X();
	v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
	showCtpLocation("F13_DataTransferConfig");
	function init(){
		
		if("${dailyFlag}"=="off"){
			setImmediateOn();
		}else{
			setImmediateOff();
		}
	
		if("${flag}"=="on"){
			setServiceOn();			
		}else{
			setServiceOff();
		}
		
		<c:if test="${showMsg!=null}">
			alert('<fmt:message key="${showMsg}"/>');
		</c:if>
		<c:if test="${confirmMsg!=null}">
            if(confirm('<fmt:message key="${confirmMsg}"/>')){
                window.location.href="microService.do?method=upgradeSlaveDatabase";
            }
        </c:if>
        <c:if test="${isSameVersion!=true}">
            $('dbVersionTD').style.display="";
            $('okBtn').disabled = true;
            $('okBtn').className = "button-default-2";
        </c:if>

	}
	
	function setImmediateOff(){
		if($('immediateOff').disabled){
			return;
		}
		$('immediateOff').checked = "checked";
		setReadOnly($('startHour'),false);
		setReadOnly($('startMinute'),false);
		setReadOnly($('endHour'),false);
		setReadOnly($('endMinute'),false);
	}
	
	function setImmediateOn(){
		if($('immediateOn').disabled){
				return;
			}
		$('immediateOn').checked = "checked";
		setReadOnly($('startHour'),true);
		setReadOnly($('startMinute'),true);
		setReadOnly($('endHour'),true);
		setReadOnly($('endMinute'),true);
	}

	function setServiceOn(){
		$('showOn').checked = "checked";
		setReadOnly($('serverIp'),false);
		setReadOnly($('serverPort'),false);
		if($('immediateOn').checked){
			setReadOnly($('startHour'),true);
			setReadOnly($('startMinute'),true);
			setReadOnly($('endHour'),true);
			setReadOnly($('endMinute'),true);
		}else{
			setReadOnly($('startHour'),false);
			setReadOnly($('startMinute'),false);
			setReadOnly($('endHour'),false);
			setReadOnly($('endMinute'),false);
			
		}
		$('dateBefore').style.color = "";
		setPopClick(true);
		$('immediateOff').disabled = false;
		$('immediateOn').disabled = false;	
	}
	
	
	function setServiceOff(){
		if($('serverIp').value && !checkIpFormatValid()){
			$('showOn').checked = "checked";
			return;
		}
		$('showOff').checked = "checked";
		setReadOnly($('serverIp'),true);
		setReadOnly($('serverPort'),true);
		setReadOnly($('startHour'),true);
		setReadOnly($('startMinute'),true);
		setReadOnly($('endHour'),true);
		setReadOnly($('endMinute'),true);
		$('dateBefore').style.color = "darkgray";
		setPopClick(false);
		$('immediateOff').disabled = true;
		$('immediateOn').disabled = true;	
	}
	
	function changeStatus(){
		$('immediateOff').disabled = false;
		$('immediateOn').disabled = false;
		$('okBtn').disabled = true;
		return true;	
	}
	
	function setReadOnly(obj,flag){
	
		if(flag){
			obj.setAttribute("readOnly",'true');
			obj.style.color = "darkgray";
		}else{
			obj.removeAttribute("readOnly");
			obj.style.color = "";
		}
	}
	
	function checkIpValid(){
		if($('showOn').checked){
			return notNullWithoutTrim($('serverIp'))&&checkIpFormatValid();
		}else{
			return true;
		}
	}
	
	function checkIpFormatValid(){
		return isIPv4($('serverIp'));
	}
	
	function checkDateFormatValid(){
		if($('showOff').checked){
			return true;
		}
		return isDate($('dateBefore'));
	}

	function checkDBVersion(){
         <c:if test="${isSameVersion!=true}">
           alert('<fmt:message key="menu.system.datatransfer.dbconflict.hint "/>');
            return false;
        </c:if>

        <c:if test="${isSameVersion==true}">
            return true;
        </c:if>

	}
	
	//验证IPv4地址 
    function isIPv4(B) { 
	    var E=B.value;
		var A=B.getAttribute("inputName");
		var regex = /^([0-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.([0-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.([0-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.([0-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])$/; 
		if(regx(regex,E)){
			return true;
		}else{
			alert(A+'<fmt:message key="validate.ipAddress.js"/>');
			try{
				B.focus();
				B.select()
			}catch(e){
			}			
			return false;
		}
    }
    
    function isDate(B){    	
    	var E=B.value;
		var A=B.getAttribute("inputName");
		var regex = /^((?:19|20)\d\d)-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/; 
		if(regx(regex,E)){
			if(E > '${lastDate}'){
				alert(A+'<fmt:message key="validate.transfer.twoyear.before"/>');
				try{
					B.focus();
					B.select()
				}catch(e){
				}		
				return false;
			}
			return true;
		}else{
			alert(A+'<fmt:message key="validate.dateFormat.js"/>');
			try{
				B.focus();
				B.select()
			}catch(e){
			}			
			return false;
		}
    }
    
    function regx(r,s)
	{
	    if (r == null || r == ""){
	       return false;
	    }
	    var patrn= new RegExp(r);
	    if (patrn.exec(s))
	       return true
	    return false
	}
	
	function setPopClick(flag){
		if(flag){
			$('dateBefore').onclick = popUpCalendar;
			$('dateBefore').style.cursor = "hand";
		}else{
			$('dateBefore').onclick = "";
			$('dateBefore').style.cursor = "auto";
		}
	}
	
	function popUpCalendar(){
		whenstart('${pageContext.request.contextPath}',$('dateBefore'),575,140, null, false);
	}
</script>
<body scroll="no" onload="init()">
<span id="nowLocation"></span>
<form id="form1" method="post" name="" action="microService.do?method=updateDataTransferCofig" onSubmit="return (checkDBVersion()&&checkForm(this)&&checkIpValid()&&checkDateFormatValid()&&changeStatus());">
	<table border="0" cellpadding="0" cellspacing="0"  align="center" width="100%" height="100%" class="">
		<tr class="page2-header-line">
			<td width="100%" height="41" valign="top" class="border_b">
				<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
				   	<tr class="page2-header-line">
				       <td width="45" class="page2-header-img"><div class="iSearchIndex"></div></td>
				       <td class="page2-header-bg"><fmt:message key="menu.system.service.datatransfer.setting.title"/></td>
				       <td class="page2-header-line padding5" align="right"></td>
				       <td class="page2-header-line padding5" width="20">&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
			
		<tr>
			<td valign="top">
				<br/><br/><br/>
				<table width="80%"  align="center" border="0"
					cellpadding="2" cellspacing="2">
					<tr>
						<td align="right">
							<strong>
								<fmt:message key="menu.system.service.datatransfer.setting.title" />
							</strong>
						</td>
						<td id="dbVersionTD" style="display:none">
						    &nbsp;
						    <fmt:message key="menu.system.microservice.datatransfer.db.main" />
						    <font color="red">
                                ${mainDBVersion}
                            </font>
						    &nbsp;
						    <fmt:message key="menu.system.microservice.datatransfer.db.slave" />
						    <font color="red">
						        ${slaveDBVersion}
						    </font>
						    &nbsp;
						        <input id="upgradeBtn" type="button" onclick="javascript:window.location.href='microService.do?method=upgradeSlaveDatabase'"
                                					value="<fmt:message key='menu.system.microservice.datatransfer.db.upgrade' bundle="${v3xCommonI18N}" />"
                                					class="button-default_emphasize">
						</td>
					</tr>
					<TR>
						<TD align="right" width="40%">
							<font color="red">*</font><fmt:message
									key="menu.system.service.switch" />:
						</TD>
						<TD>

						   <label onclick="setServiceOff()">
							  <input id="showOff" name="flag" type="radio" value="off" ${flag!='on' ? 'checked' : ''}>
							  <fmt:message key="menu.system.service.close" />
						   </label>

						   <label onclick="setServiceOn()">
							  <input id="showOn" name="flag" type="radio" value="on" ${flag=='on' ? 'checked' : ''}>
							<fmt:message key="menu.system.service.open" />
						   </label>
						
						</TD>
					</TR>
					<TR>
						<TD  align="right">
							<font color="red">*</font>
							<fmt:message key='menu.system.index.setting.ipAddress' />
							:
						</TD>
						<TD>
							<input id="serverIp" type="text" name="serverIp"
								inputName="<fmt:message key='menu.system.index.setting.ipAddress' />"
								maxlength="15" value="${serverIp}">
						</TD>
					</TR>
					<TR>
						<TD  align="right">
							<font color="red">*</font>
							<fmt:message key="menu.system.index.setting.Port" />
							:
						</TD>
						<TD>
							<input id="serverPort" type="text" name="serverPort"
								inputName="<fmt:message key='menu.system.index.setting.Port'/>"
								validate="notNull,isNumber" maxlength="5" integerMax="65535" integerMin="1" value="${serverPort}">
						</TD>
					</TR>
					
					<TR>
						<TD align="right" width="40%">
							<font color="red">*</font><fmt:message
									key="menu.system.service.datatransfer.model" />:
						</TD>
						<TD>

						   <label onclick="setImmediateOff()">
							  <input id="immediateOff" name="dailyFlag" type="radio" value="on" ${dailyFlag!='off' ? 'checked' : ''}>
							  <fmt:message key="menu.system.service.datatransfer.daily" />
						   </label>

						   <label onclick="setImmediateOn()">
							  <input id="immediateOn" name="dailyFlag" type="radio" value="off" ${dailyFlag=='off' ? 'checked' : ''}>
							<fmt:message key="menu.system.service.datatransfer.immediately" />
						   </label>
						
						</TD>
					</TR>
					
					<tr>
						<td  align="right">
							<font color="red">*</font>
							<fmt:message key="menu.system.service.datatransfer.strategy.start" />
							:
						</td>
						<td class="description-lable">
							<input id="startHour" maxlength="2" inputName="<fmt:message key='menu.system.service.datatransfer.strategy.start'/>" type="text" size="2" name="startHour" validate="notNull,isNumber" integerMax="23" integerMin="0" value="${startHour}">
							:
							<input id="startMinute" maxlength="2" inputName="<fmt:message key='menu.system.service.datatransfer.strategy.start'/>" type="text" size="2" name="startMinute" validate="notNull,isNumber" integerMax="59" integerMin="0" value="${startMinute}">
						</td>
					</tr>
					<tr>
						<td  align="right">
							<font color="red">*</font>
							<fmt:message key="menu.system.service.datatransfer.strategy.end" />
							:
						</td>
						<td class="description-lable">
							<input id="endHour" maxlength="2" inputName="<fmt:message key='menu.system.service.datatransfer.strategy.end'/>" type="text" size="2" name="endHour" validate="notNull,isNumber" integerMax="23" integerMin="0" value="${endHour}">
							:
							<input id="endMinute" maxlength="2" inputName="<fmt:message key='menu.system.service.datatransfer.strategy.end'/>" type="text" size="2" name="endMinute" validate="notNull,isNumber" integerMax="59" integerMin="0" value="${endMinute}">
							
						</td>
					</tr>
					<tr>
						<td  align="right">
							<font color="red">*</font>
							<fmt:message key="menu.system.service.datatransfer.threshold" />
							:
						</td>
						<td class="description-lable">
							<input id="dateBefore" type="text" class="input-date cursor-hand" 
								name="dateBefore"  value="${dateBefore}" 
								inputName="<fmt:message key='menu.system.service.datatransfer.threshold'/>" 
								type="Date" dateStyle="full" pattern="yyyy-MM-dd" readonly="readonly" 
								onclick="popUpCalendar();">
							<!-- 					
							<input id="dateBefore" type="text" name="dateBefore"
								inputName="<fmt:message key='menu.system.service.datatransfer.threshold'/>"
								validate="notNull" maxlength="10" size="12" value="${dateBefore}">
							-->
							&nbsp;&nbsp;
							<fmt:message key="menu.system.service.datatransfer.threshold.hit" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td  height="42" align="center"
				class="bg-advance-bottom" >
				<input id="okBtn"  type="submit"
					value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">
				&nbsp;&nbsp;
				<input type="button"
					onclick="getA8Top().document.getElementById('homeIcon').click();"
					value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />"
					class="button-default-2">
			</td>
		</tr>
	</TABLE>
</form>
</body>
</html>
