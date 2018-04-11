<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/meeting_taglib.jsp" %>
<html class="h100b w100b">
<head>
<%@ include file="../include/meeting_header.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />"/>
<title>
	<fmt:message key='mt.templet.load' />
</title>
<script type="text/javascript">
var parentWindow = null; //获得父窗口对象
var parentCallback = null;
if(typeof(transParams) != "undefined") {
	parentWindow = transParams.parentWin;
	parentCallback = transParams.callback;
} else {
	parentWindow = dialogArguments;
}

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
function chooseTemplate(obj, bodyType){
	document.getElementById("tempId").value = obj;
	document.getElementById("bodyType").value = bodyType;
}

function checkIsYoZoWps(bodyType){
	var retValue=false;
	if(bodyType && (bodyType == "WpsWord" || bodyType == "WpsExcel")){
		retValue = true; 
	}
	return retValue;
}

//单击确定按钮响应的事件
function loadTemplate(){
	var tempId = document.getElementById("tempId").value;
	var _bodyType = document.getElementById("bodyType").value;
	if(tempId==""){
		alert(v3x.getMessage("meetingLang.please_choose_template"));
		return;
	}
	//YozoOffice
	//本地是否安装的永中office，并且模板正文是wps正文则给出提示并返回
    var isYozoWps = checkIsYoZoWps(_bodyType);
    var isYoZoOffice = parent.isYoZoOffice();
    if(isYozoWps && isYoZoOffice){
 	   //对不起，您本地office软件不支持当前所选模板的正文类型！
 	   alert("${ctp:i18n('collaboration.template.alertWpsYozoOffice')}");
 	   return;
    }
    if(parentCallback) {
    	parentCallback(tempId);
    } else {
    	parentWindow.showTemplateCallback(tempId);
    }
	closeWindow();
}
	
//双击某个模板响应的事件
function loadTemplateByDoubleClick(tempId){
	var parentObj = parent.window.dialogArguments;
	parentObj.window.dataForm.target="_self";
	parentObj.window.isFormSumit = true;
	parentObj.window.dataForm.action='meeting.do?method=create&formOper=createByTemplate&templateId='+tempId;
	parentObj.window.dataForm.selectFormat.value=tempId;
	parentObj.window.dataForm.submit();
	window.close();
}
	
function closeWindow() {
	commonDialogClose('win123');
}
	
</script>
<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<style>
.dialog_main_footer {
	bottom: 0px;
}
.padding_t_15 {
	padding-top:15px;
}
</style>
</head>
<body onkeydown="listenerKeyESC()" style="overflow: hidden;" class="w100b h100b bg_color_gray">

<input type="hidden" id="tempId" name="tempId" value=""/>
<input type="hidden" id="bodyType" name="bodyType" value=""/>

<div class="margin_l_10 margin_tb_10" style="color:#a3a3a3;height: 20px;">
    <fmt:message key='mt.templet.personal1' />
</div>

<div id="dialog_main" class="bg_color_white margin_tb_5 margin_l_5" style="height:210px;">

<div id="dialog_main_body" class="center bg_color_white" style="overflow: auto;height:100%">

<table id="fieldOne" class="w100b padding_b_10">
	<tr>
 		<c:set value="0" var="loop"/>
		<c:forEach items="${personTemplateList}" var="personTemp">
			<td  valign="top" class="padding_t_15 w30b padding_l_30" nowrap="nowrap">
				<a href="###" onclick="chooseTemplate('${personTemp.id}', '${personTemp.dataFormat}');" ondblclick="loadTemplateByDoubleClick('${personTemp.id}');" title="${personTemp.templateName}">
					<img border="0" class="margin_l_20" src="<c:url value="/apps_res/v3xmain/images/template_personal.gif"/>" width="30" height="30"/>
					<div class="margin_r_5 align_left">
						<input type="radio" id="${personTemp.id}" name="chooseRadio"/>
						<label class="margin_r_5" for="${personTemp.id}">${v3x:toHTML(personTemp.title)}</label>
					</div>
				</a>
			</td>
		
			<c:set value="${loop+1}" var="loop"/>
			<c:if test="${loop%3==0}">
				</tr>
				<tr>
			</c:if>
		</c:forEach>
		
		<c:if test="${loop%3!=0}">
			<c:forEach begin="1" end="${3-loop%3}">
				<td >&nbsp;</td>
			</c:forEach>
		</c:if>
		
		<c:if test="${fn:length(personTemplateList)==0}">
			<td align="center" style="font-size: 32px;color: #6c82ac">
				<fmt:message key="mt.templet.no.create"/>
			</td>
		</c:if>
	 </tr> 
</table>
	
<table id="fieldTwo" class="w100b h100b" style="display: none;">
	 <tr>
 		<c:set value="0" var="loop"/>
		<c:forEach items="${systemTemplateList}" var="systemTemp">
			<td height="100" align="center">
				<a href="###" onclick="chooseTemplate('${systemTemp.id}', '${systemTemp.dataFormat}');" ondblclick="loadTemplateByDoubleClick('${systemTemp.id}');" title="${systemTemp.templateName}">
					<img border="0" src="<c:url value="/apps_res/v3xmain/images/template_system.gif"/>"><br>
					${v3x:toHTML(systemTemp.title)}
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

</div><!-- dialog_main_body -->
</div><!-- dialog_main -->

<div class="dialog_main_footer bg-advance-bottom padding_t_5 margin_r_10 align_right" style="width:98%;">
    <c:choose>
        <c:when test="${fn:length(personTemplateList)==0}">
            <input type="button" class="button-default-2" style="margin-right:5px;" value="<fmt:message key='common.button.close.label' bundle='${v3xCommonI18N}' />" name="B2" onclick="closeWindow()">
        </c:when>
        <c:otherwise>
            <input type="button" class="button-default_emphasize"  value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" name="B1" onclick="loadTemplate();">&nbsp;
            <input type="button" class="button-default-2" style="margin-right:5px;" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" name="B2" onclick="closeWindow()">
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>