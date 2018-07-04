<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="bg_color_white">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${path}/ajax.do?managerName=govTemplateManager"></script>
<title></title>
<script type="text/javascript">
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
    var category = "32";
    var over = 0; 
    var overId = "";
    try {
          var callerResponder = new CallerResponder();
          var gManager = new govTemplateManager();
          var ids =[];
          ids[0] = category;
          ids[1] = subjectObj.value;
          var idList = gManager.checkSubject4Personal(ids);
    
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
	window.returnValue = [over, overId, category, document.getElementById("subject").value];
	return window.returnValue;
}

window.onload = function(){
	var parentSubjectObj = '${ctp:escapeJavascript(subject)}';
	document.getElementById("subject").value=parentSubjectObj;
}
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()" style="height:100%;width:100%">
	<div style="text-align:center;height:100%;width:100%;margin-top:50px">
				<table width="100%" height="100%" border="0">
					<tr>
	                    <!-- 标题 -->
						<td nowrap class="font_size12"  style="padding-left:40px">${ctp:i18n('collaboration.newcoll.subject')}:</td>
						<td style="text-align:left"><input class="input-100per" inputName="${ctp:i18n('collaboration.newcoll.subject')}" id="subject"  value="" maxlength="85" /></td>
					</tr>
				</table>
	</div>
</body>
</html>