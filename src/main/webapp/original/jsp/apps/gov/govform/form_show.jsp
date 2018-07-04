<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="include/form_header.jsp" %>
<link rel="stylesheet" type="text/css" href="${path }/apps_res/gov/govform/css/formview.css${ctp:resSuffix()}">
<link rel="stylesheet" type="text/css" href="${path }/apps_res/gov/govform/css/formview_extends.css${ctp:resSuffix()}">
<script type="text/javascript" charset="UTF-8" src="${path }/apps_res/gov/govform/js/formview.js${ctp:resSuffix()}"></script>
<style>
.opinion_noborder {
	BORDER-bottom-STYLE: none;
	BORDER-LEFT-STYLE:none;
	BORDER-RIGHT-STYLE: none;
	BORDER-TOP-STYLE: none;
		display:inline-block;
		white-space:nowrap;
		text-overflow:ellipsis;
		padding:1px;
		margin:1px;
		color:windowtext;
		background-color:window;overflow:hidden;
		text-align:left;
}
</style>
<script type="text/javascript">

var formBO = new Object();
function doChangeForm(formObj) {
	 /*var gfAjaxManager = new govformAjaxManager();
	 var obj = new Object();
	 obj.formId = formObj.val();
	 obj.appType = appType;
     gfAjaxManager.ajaxChangeFormList(obj,{
         success : function(map){
             var xml_text = map.xml;
             var xsl_text = map.xsl;
             $("#xml").val(xml_text);
             $("#xsl").val(xsl_text);
             infoEditFormDisplay();
         },
         error : function(request, settings, e) {
             $.alert(e);
         }
     });*/
	var jsonSubmitCallBack = function() {
		var domains = [];
		domains.push('govFormData');
		$("#sendForm").attr("action", _path + "/info/infocreate.do?method=changeInfoForm&formId="+formObj.val()+"&time="+new Date());
        $("#sendForm").jsonSubmit({
			domains : domains,
			debug : false,
			ajax : true,
			callback: function(data) {
				var xml_text = data.substr(0, data.indexOf("formBO"));
	             var xsl_text = data.substr(data.indexOf("formBO")+6, data.length);
            	$("#xml").val(xml_text);
                $("#xsl").val(xsl_text);
                infoEditFormDisplay();
		   	}
		});
     }
     jsonSubmitCallBack();
}

function infoEditFormDisplay(){
	var xml = document.getElementById("xml");
	var xsl = document.getElementById("xsl");
	//document.getElementById("content").value = xsl.value;
	if(xml.value!="" && xsl.value!="") {
		try{
			initSeeyonForm(xml.value, xsl.value);
			setObjEvent();
		}catch(e){
			$.alert("信息单数据读取出现异常! 错误原因 : "+e);
			return false;
		}
		return false;
	} else {
		//autoWidthAndHeight(false);
	}
}
function infoReadFormDisplay(){
	var xml = document.getElementById("xml");
	var xsl = document.getElementById("xsl");
	//document.getElementById("content").value = xsl.value;
	if(xml.value!="" && xsl.value!="") {
		try{
			initReadSeeyonForm(xml.value, xsl.value);
		}catch(e){
			$.alert("信息单数据读取出现异常! 错误原因 : "+e);
			return false;
		}
		return false;
	} else {
		//autoWidthAndHeight(false);
	}
}
function validateGovForm(isValidateInfoNotNull) {
	var elementIsNullMsg = "";
	if(isValidateInfoNotNull!=false) {
		$("#govFormData").find("input[required='true']").each(function(index) {
			if($(this).val() == '') {
				elementIsNullMsg = $.i18n('govform.info.alert.fieldNotNull', $(this).attr("inputName"));//$(this).attr("inputName")+"必填项不为空。";
				return;
			}
		});
		$("#govFormData").find("select[required='true']").each(function(index) {
			if($(this).val() == '') {
				elementIsNullMsg = $.i18n('govform.info.alert.fieldNotNull', $(this).attr("inputName"));//$(this).attr("inputName")+"必填项不为空。";
				return;
			}
		});
		$("#govFormData").find("textarea[required='true']").each(function(index) {
			if($(this).val() == '') {
				elementIsNullMsg = $.i18n('govform.info.alert.fieldNotNull', $(this).attr("inputName"));//$(this).attr("inputName")+"必填项不为空。";
				return;
			}
		});
	}
	
	/*$("#govFormData").find("input[id*='my:']").each(function(index) {
		if($(this).attr("type")!='hidden' && $(this).val()!='') {
			if(!(/^[^\|\\"'<>]*$/.test($(this).val()))) {
				elementIsNullMsg = $(this).attr("inputName") + "不能使用特殊字符！";
				return;
			}
		}
	});
	$("#govFormData").find("select[id*='my:']").each(function(index) {
		if($(this).attr("type")!='hidden' && $(this).val()!='') {
			if(!(/^[^\|\\"'<>]*$/.test($(this).val()))) {
				elementIsNullMsg = $(this).attr("inputName")+"不能使用特殊字符 ！";
			}
		}
	});
	$("#govFormData").find("textarea[id*='my:']").each(function(index) {
		if($(this).attr("type")!='hidden' && $(this).val()!='') {
			if(!(/^[^\|\\"'<>]*$/.test($(this).val()))){
				elementIsNullMsg = $(this).attr("inputName")+"不能使用特殊字符 ！";
			}
		}
	});*/

	if(!validFieldData()) {
		return true;
	}

	if(elementIsNullMsg != "") {
		$.alert(elementIsNullMsg);
		return true;
	}
	return false;
}
</script>

<div id="govFormData">

<!-- 标记是否在创建模版，创建模版时，默认填充字段不进行填充 值为1表示创建模版 -->
<input id="isCreateTemplate" name="isCreateTemplate" type="hidden" value="${isCreateTemplate}">

<%@ include file="unitId.jsp" %>

<div class="hidden">
	<textarea id="xml" cols="40" rows="10">${xml}</textarea>
</div>

<div class="hidden">
   	<textarea id="xsl" cols="40" rows="10">${xsl}</textarea>
</div>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td>
			<div id="html" name="html" style="background-color:window;" ></div>
			<div id="img" name="img" style=""></div>
			<div style="display:none">
				<textarea name="submitstr" id="submitstr" cols="80" rows="20"></textarea><br/>
			</div>
		</td>
	</tr>
</table>

</div>
