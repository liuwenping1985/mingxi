<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/INC/noCache.jsp" %>
<%@ include file="inquiryHeader.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/addressbook/js/prototype.js${v3x:resSuffix()}" />"></script>
<fmt:setBundle basename="com.seeyon.v3x.meeting.resources.i18n.MeetingResources" var="mtResource"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title><fmt:message key="inquiry.select.template.label" /></title>
<script type="text/javascript">
<!--
	var tempId = "";
	
	//单击某一个模板所响应的事件
	function chooseTemplate(obj){
		tempId = obj;
		$(obj).checked="checked";
	
	}
	
	//单击确定按钮响应的事件
	function loadTemplate(){
		if(tempId==""){
			alert(v3x.getMessage("InquiryLang.inquiry_choose_template"));
			return;
		}
		
		var obj  = parent.v3x.getParentWindow();
		obj.document.getElementById("tem").value=tempId;
		obj.document.getElementById("surveytypeId").value=document.getElementById("surveytypeid").value;
		parent.window.close();
	}
	
	//双击某个模板响应的事件
	function loadTemplateByDoubleClick(tempId){
		  var obj  = parent.v3x.getParentWindow();
		  obj.document.getElementById("tem").value=tempId;
		  obj.document.getElementById("surveytypeId").value=document.getElementById("surveytypeid").value;
		  parent.window.close();
	}
	
	function OK(){
		if(tempId==""){
			alert(v3x.getMessage("InquiryLang.inquiry_choose_template"));
			return;
		}
		var obj = window.parent;
		obj.document.getElementById("tem").value=tempId;
		var surveytypeid = document.getElementById("surveytypeid").value;
		return tempId + "," + surveytypeid;
	}
//-->
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
	<form name="mainForm" method="post" action="">
	<input type="hidden" id="surveytypeid" name="surveytypeid" value="${param.surveytypeid}">
	<table class="popupTitleRight" border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
		<tr>
		    <td height="20" class="PopupTitle" colspan="2">
				<fmt:message key="inquiry.select.template.label" />
		    </td>	
		</tr>
		<tr>
			<td class="tab-body-bg-copy" height="100%">
			
				<div id="fieldOne" class="scrollList">
					<table cellpadding="0" cellspacing="0" width="100%" border="0" height="100%" align="center">
						<tr>
						 		<c:set value="0" var="loop"/>
								<c:forEach items="${tlist}" var="personTemp">
									<td height="100" align="center">
										<a href="###" onclick="chooseTemplate('${personTemp.id}');" ondblclick="loadTemplateByDoubleClick('${personTemp.id}');" title="${v3x:toHTML(personTemp.surveyName)}">
											<img border="0" src="<c:url value="/apps_res/v3xmain/images/template_personal.gif"/>"><br><input type="radio" id="${personTemp.id}" name="chooseRadio" />
											<label for="${personTemp.id}">${v3x:toHTML(v3x:getLimitLengthString(personTemp.surveyName,12,"..."))}</label>
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
								
								<c:if test="${fn:length(tlist)==0}">
									<td align="center" style="font-size: 32px;color: #6c82ac">
										<fmt:message key="mt.templet.no.create" bundle="${mtResource}"/>
									</td>
								</c:if>
						 </tr>
						 
					</table>
				</div>
				
			</td>
		</tr>
		<c:if test="${v3x:getBrowserFlagByRequest('HideButtons', pageContext.request)}">
		<tr>
			<td>
				<div  class="bg-advance-bottom" align="right" style="padding-top: 10px;">
					<input type="button" class="button-default-2"  value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" name="B1" onclick="loadTemplate();">&nbsp;&nbsp;&nbsp;
					<input type="button" class="button-default-2"  value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" name="B2" onclick="parent.window.close();">
				</div>
			</td>
		</tr>
		</c:if>
	</table>
	</form>
</body>
</html>