<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">

<title><fmt:message key='mt.templet.load' /></title>
<script type="text/javascript">

	function fieldChoose(){
		var obj1 = document.getElementById("tag0-left");
		obj1.className = "tab-tag-left-sel";
		var obj2 = document.getElementById("tag0-middel");
		obj2.className = "tab-tag-middel-sel";
		var obj3 = document.getElementById("tag0-right");
		obj3.className = "tab-tag-right-sel";
		var obj4 = document.getElementById("tag1-left");
		obj4.className = "tab-tag-left";
		var obj5 = document.getElementById("tag1-middel");
		obj5.className = "tab-tag-middel";
		var obj6 = document.getElementById("tag1-right");
		obj6.className = "tab-tag-right";
		
		var obj_a = document.getElementById("fieldOne");
		obj_a.style.display = "";
		var obj_b = document.getElementById("fieldTwo");
		obj_b.style.display = "none";
	}
	
	function chooseReverse(){
		var obj1 = document.getElementById("tag0-left");
		obj1.className = "tab-tag-left";
		var obj2 = document.getElementById("tag0-middel");
		obj2.className = "tab-tag-middel";
		var obj3 = document.getElementById("tag0-right");
		obj3.className = "tab-tag-right";
		var obj4 = document.getElementById("tag1-left");
		obj4.className = "tab-tag-left-sel";
		var obj5 = document.getElementById("tag1-middel");
		obj5.className = "tab-tag-middel-sel";
		var obj6 = document.getElementById("tag1-right");
		obj6.className = "tab-tag-right-sel";
		
		var obj_a = document.getElementById("fieldOne");
		obj_a.style.display = "none";
		var obj_b = document.getElementById("fieldTwo");
		obj_b.style.display = "";
	}
	
	//单击某一个模板所响应的事件
	function chooseTemplate(obj){
		document.getElementById("tempId").value = obj;
		// TODO 5.0 $(obj).checked="checked";
	}
	
	//单击确定按钮响应的事件
	function loadTemplate(){
		var tempId = document.getElementById("tempId").value;
		if(tempId==""){
			alert(v3x.getMessage("meetingLang.please_choose_template"));
			return;
		}
		var parentObj = parent.window.dialogArguments;
		parentObj.window.dataForm.target="_self";
		parentObj.window.isFormSumit = true;
		parentObj.window.dataForm.action='${mtMeetingURL}?method=create&formOper=createByTemplate&templateId='+tempId;
		parentObj.window.dataForm.selectFormat.value=tempId;
		parentObj.window.dataForm.submit();
		//parentObj.window.location.href='${mtMeetingURL}?method=create&formOper=createByTemplate&templateId='+tempId;
		window.close();
	}
	
	//双击某个模板响应的事件
	function loadTemplateByDoubleClick(tempId){
		var parentObj = parent.window.dialogArguments;
		parentObj.window.dataForm.target="_self";
		parentObj.window.isFormSumit = true;
		parentObj.window.dataForm.action='${mtMeetingURL}?method=create&formOper=createByTemplate&templateId='+tempId;
		parentObj.window.dataForm.selectFormat.value=tempId;
		parentObj.window.dataForm.submit();
		//parentObj.window.location.href='${mtMeetingURL}?method=create&formOper=createByTemplate&templateId='+tempId;
		window.close();
	}
	
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">

	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="popupTitleRight">
		<input type="hidden" id="tempId" name="tempId" value="">
		<tr>
			 <td valign="bottom" height="26" class="PopupTitle">
			 <fmt:message key='mt.templet.personal' /><fmt:message key='label.template' />
			 </td>
		</tr>
		<!-- 
		<tr>
			 <td valign="bottom" height="26" class="tab-tag">
				<div class="div-float">
				
					<div id="tag0-left"   class="tab-tag-left-sel"></div>
					<div id="tag0-middel" class="tab-tag-middel-sel">
						<fmt:message key='mt.templet.personal' /><fmt:message key='label.template' />
					</div>
					<div id="tag0-right"  class="tab-tag-right-sel"></div>
					 -->
					<!-- 屏蔽调用系统模板 -->
					<!-- 
					<div class="tab-separator"></div>
					<div id="tag1-left" class="tab-tag-left"></div>
					<div id="tag1-middel" class="tab-tag-middel" onclick="chooseReverse();">
						<fmt:message key='mt.templet.system' /><fmt:message key='label.template' />
					</div>
					<div id="tag1-right" class="tab-tag-right"></div>
					 -->
					<!--  
				</div>
			 </td>
		 </tr>
		 -->
		
		<tr>
			<td class="" height="100%">
				<div id="fieldOne" class="scrollList">
					<table cellpadding="0" cellspacing="0" width="100%" border="0" height="100%" align="center">
						<tr>
						 		<c:set value="0" var="loop"/>
								<c:forEach items="${personTemplateList}" var="personTemp">
									<td height="100" width="120" align="center" valign="top">
										<a href="###" onclick="chooseTemplate('${personTemp.id}');" ondblclick="loadTemplateByDoubleClick('${personTemp.id}');" title="${personTemp.title}">
											<img border="0" src="<c:url value="/apps_res/v3xmain/images/template_personal.gif"/>" width="40" height="40"/><br><input type="radio" id="${personTemp.id}" name="chooseRadio" />
											<label for="${personTemp.id}">${v3x:getLimitLengthString(personTemp.title,16,"...")}</label>
										</a>
										<br>
									</td>
								
									<c:set value="${loop+1}" var="loop"/>
									<c:if test="${loop%3==0}">
										</tr><tr>
									</c:if>
									</c:forEach>
									<c:if test="${loop%3!=0}">
									<c:forEach begin="1" end="${3-loop%3}">
										<td>&nbsp;</td>
									</c:forEach>
									</c:if>
								
								<c:if test="${fn:length(personTemplateList)==0}">
									<td align="center" style="font-size: 32px;color: #6c82ac">
										<fmt:message key="mt.templet.no.create"/>
									</td>
								</c:if>
								
						 </tr>
						 
					</table>
				</div>
				
				<div id="fieldTwo" style="display: none;" class="scrollList">
					<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0" align="center">
					
						 <tr>
						 		<c:set value="0" var="loop"/>
								<c:forEach items="${systemTemplateList}" var="systemTemp">
									<td height="100" align="center">
										<a href="###" onclick="chooseTemplate('${systemTemp.id}');" ondblclick="loadTemplateByDoubleClick('${systemTemp.id}');" title="${systemTemp.title}">
											<img border="0" src="<c:url value="/apps_res/v3xmain/images/template_system.gif"/>"><br>
											${v3x:getLimitLengthString(systemTemp.title,12,"...")}
										</a>
									</td>
									<c:set value="${loop+1}" var="loop"/>
									<c:if test="${loop%4==0}">
										</tr><tr>
									</c:if>
								</c:forEach>
								<c:if test="${loop%4!=0}">
									<c:forEach begin="1" end="${4-loop%4}">
										<td>&nbsp;</td>
									</c:forEach>
								</c:if>
								
								<c:if test="${fn:length(systemTemplateList)==0}">
									<td align="center" style="font-size: 32px;color: #6c82ac">
										<fmt:message key="mt.templet.no.create"/>
									</td>
								</c:if>
								
						 </tr>
						 
					</table>
				</div>
			</td>
		</tr>
		
		<tr>
			<td>
				<div  class="bg-advance-bottom" align="right">
					<input type="button" class="button-default_emphasize"  value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" name="B1" onclick="loadTemplate();">&nbsp;&nbsp;&nbsp;
					<input type="button" class="button-default-2"  value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" name="B2" onclick="window.close();">
				</div>
			</td>
		</tr>
		 
	</table>

</body>
</html>