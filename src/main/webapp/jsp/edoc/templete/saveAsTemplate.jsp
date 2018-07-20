<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../edocHeader.jsp" %>
<title><fmt:message key="saveAs.label" /></title>
<script type="text/javascript">
<!--
var hasWorkflow = ${param.hasWorkflow};
var type = "";
var overId = "";
/**
 * 检测标题重复
 * return 0 - 正常进行（直接保存） 1 - 存在同名，进行覆盖  2 - 存在同名，不覆盖，跳过  3 - 其它
 */
function checkRepeatTempleteSubject(){
    var subjectObj = document.getElementById("subject");
	type = getRadioValue("type");
	var id = null;
	
    if (!notNull(subjectObj) || !isDeaultValue(subjectObj)) {
        return 3;
    }
	
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "edocManager", "checkSubject4Personal", false);
		var categoryId = '${param.categoryId}';
		var attr = new Array();
		attr[0] = categoryId;
		attr[1] = subjectObj.value;
		requestCaller.addParameter(1, "String", categoryId);
		requestCaller.addParameter(2, "String", subjectObj.value);
		var idList = requestCaller.serviceRequest();
		if(!idList){
			return 0;
		}
		
		var count = idList.length;
				
		if(count < 1) return true;
		
		if(count == 1 && id == idList[0]){ //修改，存在的数据就是它自己
			overId = idList[0];
			return 1;
		}

		if(confirm(_("edocLang.templete_alertRepeatSubject", subjectObj.value.getLimitLength(20, "...")))){
			overId = idList[0];
			return 1;
		}
		else{
			return 2;
		}
	}
	catch (ex1) {
		alert("Exception : " + ex1.message);
	}

	return 0;
}

function ok(){
	/* 
	//创建模版时名称可以包含特殊字符
	if(!notSpecChar(document.getElementById('subject'))) {
    	return;
    } */
	//OA-34562 集群环境：标题较长时另存为个人模版，没有保存成功
	if(document.getElementById('subject').value.length>60){
	  alert("标题不能超过60字符!");
	  return;
	}
	var over = checkRepeatTempleteSubject();
	if(over == 2 || over == 3){
		return;
	}
	/** 打开进度条 */
	try { getA8Top().startProc(); } catch(e) {}
	
	transParams.parentWin.saveAsTempleteCallback([over, overId, type, document.getElementById("subject").value]);
	transParams.parentWin.saveAsTempleteWin.close();
}

window.onload = function(){
    //另存为个人模板页面的标题，每次都取最新的文单标题
	var parentSubjectObj = transParams.parentWin.document.getElementById("my:subject");
	var parentTembodyType = transParams.parentWin.document.getElementById("tembodyType");
	var parentFormtitle = transParams.parentWin.document.getElementById("formtitle");
	if(getDefaultValue(parentSubjectObj) != parentSubjectObj.value){
		document.getElementById("subject").value = parentSubjectObj.value;
	}

	if(!hasWorkflow){
		document.getElementById("templete").disabled = true;
		document.getElementById("workflow").disabled = true;		
		document.getElementById("text").checked = true;
	}
	else{
		document.getElementById("templete").checked = true;
	}
	//OA-15983  公文拟文页面存为个人模板弹出js错误  
	if(parentTembodyType && parentTembodyType.value =="FORM"){
	    document.getElementById("subject").value = parentFormtitle.value;
	    document.getElementById("workflow").disabled = true;		
		document.getElementById("text").disabled = true;
	}
}
//-->
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key="saveAs.label" /><fmt:message key="templete.personal.label" /></td>
	</tr>
	<tr>
		<td class="bg-advance-middel" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="3">
				<tr>
					<td nowrap height="30" align="right"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />:&nbsp; </td>
					<td width="100%"><input class="input-100per" inputName="<fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />" id="subject"  value="" maxlength="60" /></td>
				</tr>
				<tr valign="top">
					<td align="right" nowrap><fmt:message key="templete.type.label" />:&nbsp;</td>
					<td>
						
						<div style="vertical-align:middle;">
							<label for="templete">
								<c:choose>
								<c:when test="${param.edocType!=1}">
								<input type="radio" name="type" value="templete" id="templete">
								</c:when>
								<c:otherwise>
								<input type="hidden" name="type" value="templete" id="templete">
								</c:otherwise>
								</c:choose>
								<fmt:message key="templete.category.type.${param.edocType==null?0:1}" />
							</label>
						</div>
						<c:choose>
						<c:when test="${param.edocType!=1}">
						<div>
							<label for="text">
								<input type="radio" name="type" value="text" id="text"><fmt:message key="templete.text.label" />
							</label>
						</div>
						<div>
							<label for="workflow">
								<input type="radio" name="type" value="workflow" id="workflow"><fmt:message key="templete.workflow.label" />
							</label>
						</div>
						</c:when>
						</c:choose>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="button" onclick="ok()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;
			<input type="button" onclick="transParams.parentWin.saveAsTempleteWin.close()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
</body>
</html>