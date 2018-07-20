<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="bg_color_white">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${path}/ajax.do?managerName=templateManager"></script>
<title></title>
<script type="text/javascript">
<!--
var hasWorkflow = ${ctp:escapeJavascript(hasWorkflow)};
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
	
    if (!notNull_self(subjectObj) || !isDeaultValue(subjectObj)) {
        return 3;
    }
	
	try {
		var callerResponder = new CallerResponder();
	    var temManager = new templateManager();
	 	var ids =[];
	 	ids[0] = type;
	 	ids[1] = subjectObj.value;
	 	var idList = temManager.checkSubject4Personal(ids);

		if(!idList){
			return 0;
		}
		
		var count = idList.length;
				
		if(count < 1) return true;
		
		if(count == 1 && id == idList[0]){ //修改，存在的数据就是它自己
			overId = idList[0];
			return 1;
		}
      	//模板subjectObj.value已经存在，是否将原模板覆盖?
		if(window.confirm("${ctp:i18n_1('collaboration.saveAsTemplate.isHaveTemplate','"+subjectObj.value+"')}")){
			overId = idList[0];
            return 1;
		}else{
			return 2;
		}
        
	}
	catch (ex1) {
	    $.alert("Exception : " + ex1.message);
	}
	return 0;
}

/**
 * 验证是否为空，不允许空格
 */
function notNull_self(element){
	var value = element.value;
	value = value.replace(/[\r\n]/g, "");
	var inputName = element.getAttribute("inputName");
	
	if(value == null || value == "" || value.trim() == ""){
		writeValidateInfo_self(element,"${ctp:i18n('collaboration.common.titleNotNull')}");  //标题不能为空
		return false;
	}
	
	var maxLength = element.getAttribute("maxlength");
	
	if(maxLength && value.length > maxLength){
		writeValidateInfo(element, $.i18n("formValidate_maxLength", inputName, maxLength, value.length));
		return false;
	}
	
	return true;
};

/**
 * 打印出提示消息，并聚焦
 */
function writeValidateInfo_self(element, message){
	$.alert(message);
	var onAfterAlert = element.getAttribute("onAfterAlert");
	if(onAfterAlert){
		try{
			eval(onAfterAlert);
		}
		catch(e){
		}
	}
	else{
		try{
			element.focus();
			element.select();
        }
		catch(e){
		}
	}
};

function checkSpecialChar(element){
	//标题非空开始
	var value = element.value;
	value = value.replace(/[\r\n]/g, "");
	var inputName = element.getAttribute("inputName");
	
	if(value == null || value == "" || value.trim() == ""){
		writeValidateInfo_self(element,"${ctp:i18n('collaboration.common.titleNotNull')}");  //标题不能为空
		return false;
	}
	//标题非空结束
	//defaultvalue开始	
	var deaultValue = getDefaultValue(element);
	if(value == deaultValue){
    	writeValidateInfo(element, $.i18n("formValidate_notNull", inputName));
        return false;
	}
    return true;
}

function writeErrorInfo(element, message){
		$.alert(message);
		try{
			element.focus();
			element.select();
	   }catch(e){}
}

function OK(){
	if(!checkSpecialChar(document.getElementById('subject'))) {
    	return;
    }
	var subjectObj = document.getElementById("subject");
    var type = "template"
    var over = 0; 
    var overId = "";
    try {
          var callerResponder = new CallerResponder();
          var temManager = new templateManager();
          var ids =[];
          ids[0] = type;
          ids[1] = subjectObj.value;
          var idList = temManager.checkSubject4Personal(ids);
    
          if(!idList){
              over =  0;
          }
          var count = idList.length;       
          if(count < 1) {
              over =  0;
          }else{//修改 存在的数据就是他本身
              overId = idList[0];
              over = 5;
          }
     }
     catch (ex1) {
          $.alert("Exception : " + ex1.message);
     }
	window.returnValue = [over, overId, type, document.getElementById("subject").value];
	return window.returnValue;
}

window.onload = function(){
	var parentSubjectObj = '${ctp:escapeJavascript(subject)}';
	var defaultValue = "${ctp:escapeJavascript(defaultValue)}";
	if(defaultValue != parentSubjectObj){
		document.getElementById("subject").value = (parentSubjectObj);
	}
}
//-->
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<div class="margin_l_10">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"></td>
	</tr>
	<tr>
		<td class="bg-advance-middel" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="3">
				<tr>
                    <!-- 标题 -->
					<td nowrap height="30" align="right" class="font_size12">${ctp:i18n('collaboration.newcoll.subject')}:&nbsp; </td>
					<td width="100%"><input class="input-100per" inputName="${ctp:i18n('collaboration.newcoll.subject')}" id="subject"  value="" maxlength="85" /></td>
				</tr>
				<tr valign="top" class="margin_t_10">
					<td align="right" nowrap class="font_size12 padding_t_10">${ctp:i18n('collaboration.saveAsTemplate.templateType')}:&nbsp;</td><!-- 模板类型 -->
					<td>
						<div style="vertical-align:middle;" class="font_size12 margin_t_10">
							个人模板
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	</tr>
</table>
</div>
</body>
</html>