<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body class="h100b over_hidden  font_size12">
<div class="margin_t_10">
<table width="100%" border="0" cellpadding="0"
	cellspacing="0" class="popupTitleRight">
	<tr>
		<td class=bg-advance-middel>
		<table border="0" cellpadding="0" cellspacing="0" width="95%" height="100%"
			align="center">
			<tr>
				<td width="27%" align="right"><label><font color="red">*</font></label>${ctp:i18n('form.query.conditionname.label' )}:</td>
				<td colspan="3">
				<div class=common_txtbox_wrap>
				<input type="text" name="${ctp:i18n('form.query.conditionname.label' )}" id="name" maxlength="255" class="input-100 validate" validate="type:'string',notNull:true,avoidChar:'\',$#\\&quot;&lt;&gt;()'">
				</div>
				</td>
				<td width="20%">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>
			<tr>
				<td align="right"><label><font color="red">*</font></label>${ctp:i18n('common.subject.label' )}:</td>
				<td colspan="3">
				<div class=common_txtbox_wrap>
				<input type="text" name="${ctp:i18n('common.subject.label' )}" maxlength="255" id="title" class="input-100 validate" validate="type:'string',notNull:true,avoidChar:'\',$#\\&quot;&lt;&gt;()'">
				</div>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>
			<tr>
				<td align="right" width="27%">${ctp:i18n('form.input.inputtype.label')}:</td>
				<td colspan="3">
				<select name="inputType" class="w100b" id="inputType">
					<c:forEach var="it" items="${userInputTypes }">
						<option value="${it.key }">${it.text }</option>
					</c:forEach>
				</select>
				</td>
				<td width="">&nbsp;</td>
			</tr>
			<tr class="radioShow hidden">
				<td colspan="5">&nbsp;</td>
			</tr>
			<tr id="trRadioclass" class="radioShow hidden">
				<td align="right">${ctp:i18n('form.formenum.enumtype')}:</td>
				<td colspan="3">
				<div class="common_selectbox_wrap" >
				<select name="enumId" class="comp" id="enumId" comp="type:'autocomplete'" style="width: 245px">
					<option value="" selected></option>
					<c:forEach var="it" items="${enums }">
					<option value="${it.id }">${it.enumname }</option>
					</c:forEach>
				</select>
				</div>
				</td>
				<td>&nbsp;</td>
			</tr>
            <tr class="selectShow hidden">
                <td colspan="5">&nbsp;</td>
            </tr>
            <tr id="trSelectclass" class="selectShow hidden">
                <td align="right">${ctp:i18n('form.formenum.enumtype')}:</td>
                <td colspan="3">
                <div class="common_txtbox_wrap" >
                    <input type='text' id="selectName" class="input-100 validate" value='' onclick='selectEnums()'>
                    <input type='hidden' id="selectId"  value='' >
                    <input type='hidden' id="enumMaxLevel"  value='' >
                    <input type='hidden' id="finalChecked"  value='' >
                    <input type='hidden' id="hasMoreLevel"  value='' >
                </div>
                </td>
                <td>&nbsp;</td>
            </tr>
            <tr class="selectReturnShow hidden">
                <td colspan="5">&nbsp;</td>
            </tr>
            <tr id="trSelectReturnclass" class="selectReturnShow hidden">
                <td align="right" id="trSelectReturnclassId">${ctp:i18n('form.formenum.enumlevel')}:</td>
                <td colspan="3">
                <div class="common_selectbox_wrap" >
                    <select name="enumLevel"  id="enumLevel" style="display:none">
                    </select>
                </div>
                </td>
                <td>&nbsp;</td>
            </tr>
			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>
			<tr class="inputShow">
				<td align="right">${ctp:i18n('form.query.defaultvalue.label')}:</td>
				<td>
				<input type="hidden" id="valueType" value="text">
				<label class="margin_t_5 hand display_block" for="handTo"> <input type="radio" class="radio_com" name="defaultvalue" id="handTo" checked="checked" value="text">${ctp:i18n('form.operhigh.handwork.label')} </label>
				</td>
				<td colspan="2">
				<div class=common_txtbox_wrap>
				<input type="text" name="${ctp:i18n('form.query.defaultvalue.label')}" id="handValue" class="input-100 validate" validate="type:'string',avoidChar:'&&quot;&lt;&gt;'">
				</div>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr height='30px' class="inputShow">
				<td align="right">&nbsp;</td>
				<td width="15%">
				<label class="margin_t_5 hand display_block" for="systemTo"> 
				<input class="radio_com" type="radio" name="defaultvalue" id="systemTo" value="extend">${ctp:i18n('form.operhigh.systemvar.label')} 
				</label>
				</td>
				<td colspan="2">
				<select name="systemValue" class="w100b input-disabled" id="systemValue">
					<option value=""></option>
					<c:forEach var="it" items="${systemVarList }">
					<option value="${it.key }">${it.text }</option>
					</c:forEach>
				</select>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>
		</table>
		</td>
	</tr>
</TABLE>
</div>
</body>
<script type="text/javascript">
var winObj = window.dialogArguments;
var systemVar = [];
<c:forEach var="it" items="${systemVarList }">
systemVar.push({key:'${it.key }',text:'${it.text }'});
</c:forEach>
$(document).ready(function(){
	$("#inputType").change(function(){
		resetShow();
		resetDefaultValue();
		defaultValueDisable();
		$("body").comp();
	});
	$(":radio").click(function(){
		$("#valueType").val($(this).val());
		defaultValueDisable()
	});
	resetShow();
	resetDefaultValue();
	defaultValueDisable();

	if(winObj.dat){
		showdata(winObj.dat);
	}
	$("#name").focus();
});
//根据控件类型 显示默认值或枚举
function resetShow(){
	if($("#inputType").val()=="${text.key}"||$("#inputType").val()=="${textArea.key}"){
		$(".inputShow").removeClass("hidden");
	}else {
		$("#handValue").val("");
		$(".inputShow").removeClass("hidden").addClass("hidden");
	}

	if($("#inputType").val()=="${radio.key}"){
		$(".radioShow").removeClass("hidden");
	}else {
		$(".radioShow").removeClass("hidden").addClass("hidden");
	}
	if($("#inputType").val()=="${select.key}"){
        $(".selectShow").removeClass("hidden");
    }else {
        $(".selectShow").removeClass("hidden").addClass("hidden");
        $(".selectReturnShow").removeClass("hidden").addClass("hidden");
    }
}
//初始化默认值清空
function resetDefaultValue(){
	$("#handTo").prop("checked",true);
	$("#handValue").val("");
	$("#systemValue").val("");
	$("#enumId").val("");
}
//设置radio之后的框的disable状态
function defaultValueDisable(){
	if("text"==$("#valueType").val()){
		$("#handTo").prop("checked",true);
		$("#handValue").prop("disabled",false);
		$("#systemValue").val("");
		$("#systemValue").prop("disabled",true);
	}else if("extend"==$("#valueType").val()){
		$("#systemTo").prop("checked",true);
		$("#handValue").prop("disabled",true);
		$("#handValue").val("");
		$("#systemValue").prop("disabled",false);
	}
}
function showdata(d){
	$("#inputType").val(d.inputType);
	resetShow();
	if(d.enumId){
	    d.selectId = d.enumId;
    }
    if(d.enumName){
        d.selectName = d.enumName;
    }
    if(!d.finalChecked&&d.hasMoreLevel && d.hasMoreLevel != 'false'){
    	var maxLevel = d.enumMaxLevel;
    	var enumLevel = d.enumLevel;
    	var optionHtml = '';
        for(var i=1;i<=parseInt(maxLevel)+1;i++ ){
        	if(i == enumLevel){
				optionHtml = optionHtml+"<option value='"+i+"' checked >"+i+"</option>";
        	}else{
				optionHtml = optionHtml+"<option value='"+i+"'>"+i+"</option>";
        	}
        }
        $("#enumLevel","#trSelectReturnclass").append(optionHtml).show();
        $(".selectReturnShow").removeClass("hidden");
    }
	$("body").fillform(d);
	
	defaultValueDisable();
	if(d.valueType=="extend"){
		$("#systemValue").val(d.value);
	}else{
		$("#handValue").val(d.value);
	}
	$("body").comp();
}

function OK(){
	if(!$("body").validate({errorAlert:true,errorIcon:false})){
		return "error";
	}
	var editName  = $.trim($("#name").val());
	var editTitle = $.trim($("#title").val());
	for(var i=0;i<systemVar.length;i++){
		if(editName==systemVar[i].text||editTitle==systemVar[i].text){
			$.alert("名称或标题不能与系统变量一样,请修改!");
			return "error";
		}
	}
	$("#name").val(editName);
	$("#title").val(editTitle);
	return window;
}
function selectEnums(){
    var obj = new Array();
    obj[0] = window;
    var isFinalChild = $("#finalChecked","#trSelectclass").val();
    var bindId = $("#selectId","#trSelectclass").val();
    var urlStr="${path}/enum.do?method=bindEnum&showLevelDialog=true&isBind=true&isfinal=false&isFinalChild="+isFinalChild+"&bindId="+bindId+"&isNeedImage=1";
    var dialog = $.dialog({
            url:urlStr,
            title : '${ctp:i18n("form.field.bindenum.title.label")}',
            width:500,
            height:520,
            targetWindow:getCtpTop(),
            transParams:obj,
            buttons : [{
              text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",
              id:"sure",
              handler : function() {
                  var result = dialog.getReturnValue();
                  if(result){
                    var finalChecked = result.isFinalChild;
                    //没有选择末级枚举以及有多级枚举的时候才显示层级框
                    var hasMoreLevel = result.hasMoreLevel;
                    var maxLevel = result.maxLevel;
                    var optionHtml ='';
                    var enumType= result.enumType;
                    if((!finalChecked||finalChecked=='false') && hasMoreLevel){
                        for(var i=1;i<=maxLevel+1;i++ ){
                            optionHtml = optionHtml+"<option value='"+i+"'>"+i+"</option>";
                        }
                        $(".selectReturnShow").removeClass("hidden");
                        $("#enumLevel","#trSelectReturnclass").empty().append(optionHtml).show();
                        $("#trSelectReturnclassId").text($.i18n("form.formenum.enumlevel")+":");
                    }else{
                        $(".selectReturnShow").removeClass("hidden").addClass("hidden");
                    }
                    $("#selectName","#trSelectclass").val(result.enumName);
                    $("#enumMaxLevel","#trSelectclass").val(result.maxLevel);
                    $("#selectId","#trSelectclass").val(result.enumId);
                    $("#hasMoreLevel","#trSelectclass").val(result.hasMoreLevel);
                    $("#finalChecked","#trSelectclass").val(result.isFinalChild);
                    dialog.close();
                  }
              }
            }, {
              text : "${ctp:i18n('form.query.cancel.label')}",
              id:"exit",
              handler : function() {
                  returnObj = false;
                  dialog.close();
              }
            }]
    });
}
</script>
</html>