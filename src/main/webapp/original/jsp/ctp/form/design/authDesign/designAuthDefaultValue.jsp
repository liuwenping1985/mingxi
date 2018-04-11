<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../../../../common/common.jsp"%>
</head>
<body scroll="no" style="overflow: hidden;">
<table cellpadding="0" cellspacing="0" width="100%" height="100%">
    <tr>
        <td valign="top">

    <div id="ffTable" class="font_size12 margin_l_5 margin_t_5 form_area">
		<div class="clearfix margin_t_10" style="width: 370px;text-align: right;">
		    <div class="left" style="width: 65px;"><font color="red">*</font><span style="display: inline;text-align: right;">${ctp:i18n('form.operhigh.dataarea.label')}：</span></div>
		    <div class="left" style="vertical-align: middle;">
				<select id="select2" name="select2" disabled="disabled" style="width: 290px;">
					<option value=-1></option>
					<option selected inputType="${formFieldBean.inputType}" value="${formFieldBean.name }" digitNum="${formFieldBean.digitNum}" fieldLength="${formFieldBean.fieldLength}" fieldType="${formFieldBean.fieldType }">${formFieldBean.display }</option>
				</select>
		    </div>
		</div>
        <div class="clearfix margin_t_5" style="width: 370px;text-align: right;">
            <div class="left" style="width: 65px;"><font color="red">*</font><span style="display: inline;text-align: right;">${ctp:i18n('form.operhigh.datavalue.label')}：</span></div>
        </div>
	    <div class="clearfix" style="width: 370px;text-align: left;margin-left: 60px;line-height: 25px;margin-top: 5px;">
		    <div class="common_radio_box left" style="width: 80px;white-space:nowrap;">
		        <label for="data1_" class="margin_r_10 hand"><input type="radio" value="text" id="data1_" name="data_" <c:if test="${disableMap.data_handWork eq '' }">checked</c:if> ${disableMap.data_handWork } class="radio_com"/>${ctp:i18n('form.operhigh.handwork.label')}</label>
		    </div>
		   <div class="left" style="width: 215px;text-align: right;line-height: 30px;">
			<c:if test="${data_handWork != null }">
					<select id="data_datavalue"  style="width:215px;" <c:if test="${disableMap.data_handWork ne '' }">disabled</c:if>>
						<option value="" selected></option>
						<c:forEach var="_data" items="${data_handWork }">
							<option value="${_data[0] }">${ctp:toHTML(_data[1]) }</option>
						</c:forEach>
			       	</select>
			</c:if>
			<c:if test="${data_handWork == null }">
			   <div class="common_txtbox clearfix">
				    <div class="common_txtbox_wrap">
			           <input name="${ctp:i18n('form.operhigh.handwork.label')}" id="data_datavalue" <c:if test="${disableMap.data_handWork ne '' }">disabled</c:if> class="validate" validate="type:'string',avoidChar:'&quot;&lt;&gt;'"/> 
				    </div>
				</div>
			</c:if>
		   </div>
	   </div>
        <div class="clearfix" style="width: 370px;text-align: left;margin-left: 60px;margin-top: 5px;">
            <div class="common_radio_box left"  style="width: 80px;">
                <label for="data2_" class="margin_r_10 hand"><input type="radio" value="extend" id="data2_" name="data_" <c:if test="${(disableMap.data_handWork ne '')&& (disableMap.data_system eq '') }">checked</c:if> ${disableMap.data_system }  class="radio_com"/>${ctp:i18n('form.operhigh.systemvar.label')}</label>
            </div>
            <div class="left" style="width: 215px;text-align: right;">
				<select id="data_systemValue"  style="width:215px;" <c:if test="${disableMap.data_handWork eq ''||disableMap.data_system ne '' }">disabled</c:if>>
					<option value="" selected></option>
					<c:forEach var="_data" items="${data_system }">
						<option value="${_data[0] }" isserialnum="${_data[2] }">${_data[1] }</option>
					</c:forEach>
				</select>
            </div>
        </div>
        <div class="clearfix margin_t_10" style="width: 370px;text-align: right;">
            <div class="left" style="width: 65px;"><span style="display: inline;text-align: right;">${ctp:i18n('form.operhigh.showvalue.label')}：</span></div>
        </div>
        <div class="clearfix" style="width: 370px;text-align: left;margin-left: 60px;">
            <div class="common_radio_box left" style="width: 80px;white-space:nowrap;">
               <label for="show1_" class="margin_r_10 hand"><input type="radio" value="text" id="show1_" name="show_"  disabled class="radio_com"/>${ctp:i18n('form.operhigh.handwork.label')}</label>
           </div>
           <div class="left" style="width: 215px;text-align: right;">
            <div class="common_txtbox clearfix">
                   <div class="common_txtbox_wrap">
                      <input name="${ctp:i18n('form.operhigh.handwork.label')}" id="show_datavalue" disabled /> 
                   </div>
               </div>
           </div>
        </div>
	     <div class="clearfix" style="width: 370px;text-align: left;margin-left: 60px;margin-top: 5px;">
	         <div class="common_radio_box left" style="width: 80px;">
                <label for="show2_" class="margin_r_10 hand">
                <input value="extend" type="radio" id="show2_" name="show_" ${disableMap.show_system } class="radio_com">${ctp:i18n('form.operhigh.systemvar.label')}</label>
            </div>
            <div class="left" style="width: 215px;text-align: right;">
                  <select id="show_systemValue" disabled style="width:215px;">
					<option value="" selected></option>
					<c:forEach var="_data" items="${show_system }">
						<option value="${_data[0] }">${_data[1] }</option>
					</c:forEach>
				</select>
              </div>
	     </div>
	     <div class="clearfix" >
	       <div class="common_radio_box left" style="width: 80px;">&nbsp;</div>
	       <c:choose>
	            <c:when test="${disableMap.allowModify eq 'ref' }">
	               <div class = "left"><label for="allowModify">&nbsp;&nbsp;&nbsp;<input type="checkbox" id="allowModify" name="allowModifyRef" value="true">${ctp:i18n('form.authdesign.defaultValue.modify.relation') }</label></div>
	            </c:when>
	            <c:otherwise>
	               <div class = "left" style="display:${disableMap.allowModify }"><label for="allowModify">&nbsp;&nbsp;&nbsp;<input type="checkbox" id="allowModify" name="allowModifyRef" value="true">${ctp:i18n('form.authdesign.defaultValue.modify.def') }</label></div>
	            </c:otherwise>
            </c:choose>
	     </div>
	     <div id ="isInitNullDiv" class="clearfix" style="width: 370px;text-align: left;margin: 5px 0px 0px 15px;">
	      	<div class="common_radio_box left" style="min-width: 180px">
               <label for="isInitNull1_" class="margin_r_10 hand"><input type="radio" value="0" id="isInitNull1_" name="isInitNull_"   class="radio_com"/>${ctp:i18n('form.authdesign.defaultValue.initnull.no') }</label>
           </div>
           <div class="common_radio_box left" style="min-width: 180px;">
               <label for="isInitNull2_" class="margin_r_10 hand"><input type="radio" value="1" id="isInitNull2_" name="isInitNull_"  class="radio_com"/>${ctp:i18n('form.authdesign.defaultValue.initnull.yes') }</label>
           </div>
	     </div>
    </div>
    
        </td>
    </tr>
    <tr>
        <td height="35">
        
	     <div class="clearfix">
	       <div class="left" style="width: 150px;margin-left: 15px;"><a  href="javascript:void(0)" class="common_button common_button_gray margin_r_5" id="delDefault">${ctp:i18n('form.createform.delectinit.label')}</a></div>
	       <div class="left" style="width: 270px;text-align: right;margin-top: 5px"><font color='red' size="2">${ctp:i18n('form.create.manualcannotinput.label')}</font></div>
	     </div>
        
        </td>
    </tr>
</table>
</BODY>
<script type="text/javascript">
var fieldName = '${formFieldBean.name }';
var formatType = '${formFieldBean.formatType }';
var parWin = window.dialogArguments;
$(document).ready(function(){
	$("body").data("detail",$("#ffTable").children().clone(true));
	var fieldTable = $("#authFieldTable",parWin.document);
	var ffMap = new Object();
	ffMap["allowModify"] = $("#"+fieldName+"_allowModify",fieldTable).val();
	ffMap["data_"] = $("#"+fieldName+"_defaultValueType",fieldTable).val();
	if(ffMap["data_"]==""||ffMap["data_"]=="text"){
		ffMap["data1_"] = ffMap["data_"];
		ffMap["data_datavalue"] = $("#"+fieldName+"_defaultValue",fieldTable).val();
	}else{
		ffMap["data2_"] = ffMap["data_"];
		ffMap["data_systemValue"] = $("#"+fieldName+"_defaultValue",fieldTable).val();
	}
	ffMap["show_systemValue"] = $("#"+fieldName+"_display",fieldTable).val();
	ffMap["show_"] = $("#"+fieldName+"_displayType",fieldTable).val();
	ffMap["isInitNull_"] = $("#"+fieldName+"_isInitNull",fieldTable).val();
	if(ffMap["show_"]==""||ffMap["show_"]=="text"){
		ffMap["show1_"] = ffMap["show_"];
	}else{
		ffMap["show2_"] = ffMap["show_"];
	}
	if(ffMap["isInitNull_"]==""||ffMap["isInitNull_"]=="0"){
		ffMap["isInitNull1_"] = "0";
	}else{
		ffMap["isInitNull2_"] = ffMap["isInitNull_"];
	}
	ffMap["showName"] = $("#"+fieldName+"_showName",fieldTable).val();
	$("#ffTable").fillform(ffMap);
	resetEditState();
	$("input:radio").click(
			function(){
				resetEditState();
			}
	);
	$("#delDefault").click(function(){
		if($("#data_datavalue").val()==""&&$("#data_systemValue").val()==""){
			$.alert("${ctp:i18n('form.authdesign.defaultValue.error')}");
      	  return
		}else{
			$.confirm({
			    'msg' : "${ctp:i18n('form.authdesign.delDefaultValue.label')}",
			    ok_fn : function() {
					$("#ffTable").html("");
					$("#ffTable").append($("body").data("detail").clone(true));
					$("#select2").val(fieldName);
					$("input[id='data_']").prop("checked",false);
					parWin.setDefaultValue($("#"+fieldName+"_showName",parWin.window.document));
			    }
			  });
		}
	});
	$("#data_systemValue").change(function(){
	  showIsInitNull();
	});
});
function showIsInitNull(){
  if ($("#data_systemValue").val()){
    if ($("option[value='"+$("#data_systemValue").val()+"']",$("#data_systemValue")).attr("isserialnum")){
	    $("#isInitNullDiv").hide();
    } else {
    $("#isInitNullDiv").show();
    }
  } else{
    $("#isInitNullDiv").show();
  }
}
function resetEditState(){
  
	var data_data = $("input[name='data_']:checked");
	if(data_data.length==1){
		if(data_data.val()=="text"){
			$("#data_datavalue").prop("disabled",false);
			$("#data_systemValue").val("");
			$("#data_systemValue").prop("disabled",true);
		}else{
			$("#data_datavalue").val("");
			$("#data_datavalue").prop("disabled",true);
			$("#data_systemValue").prop("disabled",false);
		}
	}
	var show_data = $("input[name='show_']:checked");
	if(show_data.length==1){
		if(show_data.val()=="text"){
			$("#show_datavalue").prop("disabled",false);
			$("#show_systemValue").val("");
			$("#show_systemValue").prop("disabled",true);
		}else{
			$("#show_datavalue").val("");
			$("#show_datavalue").prop("disabled",true);
			$("#show_systemValue").prop("disabled",false);
		}
	}
	showIsInitNull();
	var inputType = $(":selected","#select2").attr("inputType");
	//这个地方有点问题,需要改成跟显示值等类似，另外要默认都是disabled,后面重构一下吧
	if(inputType == "mapmarked" || inputType == "maplocate" || inputType == "mapphoto" || inputType.indexOf("multi") != -1
	      ||inputType == "relationform" ||inputType == "relation" ||inputType == "project"||inputType == "attachment"
	      ||inputType == "image"||inputType == "document"||inputType == "outwrite"||inputType == "externalwrite-ahead"||inputType == "exchangetask"||inputType == "querytask"
	      ||inputType == "customcontrol"){
		if(inputType != "multiaccount" && inputType != "multidepartment"){
			//OA-85225 选择多部门或多单位设置初始值时，下面的２个单选项无法选择，被置灰了，要求放开也能选择（同选择部门一样）
			$("#isInitNullDiv input[name='isInitNull_']").prop("disabled",true);
		}
	}
	//OA-86713 表单复选框数字或其他字段设置计算公式，初始值设置下面的2项单选没有置灰
	if('${isAllDisableMap.allDisable}' == "true"){
		$("#isInitNullDiv input[name='isInitNull_']").prop("disabled",true);
	}
}
function OK(){
	if(!$("#ffTable").validate()){return "error";}
	var _inputType = $(":selected", "#select2").attr("inputType");
	var _fieldType = $(":selected", "#select2").attr("fieldType");
	if(_fieldType == "DECIMAL"){
		var hObj = $("#data_datavalue");
		var hv = hObj.val();
		if(!hObj.is(":disabled")&&hv!=""&&!$.isANumber(hv)){
			$.alert("${ctp:i18n('form.operhigh.handwork.label')}"+$.i18n('validate.notNumber.js'));
			return "error";
		}
		if(hv && _inputType != "select" && _inputType != "radio"){
		    hv = parseFloat(hv)+'';
		    hObj.val(hv);
		}
		//先判断是否有小数点
		if(hv && hv.indexOf(".") > -1){
			var digitStr = hv.substring(hv.indexOf(".")+1);
			if(digitStr.length > parseInt($(":selected","#select2").attr("digitNum"))){
				$.alert("${ctp:i18n('form.operhigh.handwork.cannot.set.digitnum')}");
				return "error";
			}
			if(parseInt(hv.length-1) > parseInt($(":selected","#select2").attr("fieldLength"))){
				$.alert("${ctp:i18n('form.designauth.defaultvalue.overlength')}");
				return "error";
			}
		}else{
		    //黄奎修改 协同V5OA-123179 文本框数字字段设置字段长度为5，其中包括2位小数，但是设置初始值和自定义查询项缺省值时，输入5位整数没有校验，正常应该只能输入3位整数
			var crrValueLength = getLength($("#data_datavalue").val());//当前输入值总长度
			var allLength = parseInt($(":selected","#select2").attr("fieldLength"));//数字总长度
			var digitNumLength = parseInt($(":selected","#select2").attr("digitNum"));//小数位长度
			var intLength = allLength - digitNumLength;//整数位长度
		    
		    if(crrValueLength > intLength){
		        var dataText = $(":selected","#select2").html();
				$.alert("["+dataText+"], 整数部分限制"+intLength+"位数, 请修改!");
				return "error";
			}
		
			if(crrValueLength > allLength){
				$.alert("${ctp:i18n('form.designauth.defaultvalue.overlength')}");
				return "error";
			}
		}
	}else{
		var fieldSelectOption = $(":selected","#select2");
		if(fieldSelectOption.attr('fieldtype')!='LONGTEXT'&&getLength($("#data_datavalue").val()) > parseInt(fieldSelectOption.attr("fieldLength"))){
			$.alert("初始值长度超出了字段的长度定义范围!");
			return "error";
		}
	}
	var ffMap = new Object();
	ffMap[fieldName+"_allowModify"] = ""+$("#allowModify").prop("checked");
	var data_data =$("input[name='data_']:checked");
	ffMap[fieldName+"_defaultValueType"] = data_data.length==1?data_data.val():"";
	if(ffMap[fieldName+"_defaultValueType"]=="text"){
		var datavalue = $("#data_datavalue");
		var _defaultValue = datavalue.val();
		if(formatType == "urlPage" && _defaultValue){
		      var strRegex = /^(https|http|ftp|rtsp|mms)?:\/\/([0-9A-Za-z_-]+\.?)+(\/[0-9A-Za-z_-]+)*(\.[0-9a-zA-Z-_]*)?(:?[0-9]{1,4})?(\/[\u4E00-\u9FA50-9A-Za-z_-]+\.?[\u4E00-\u9FA50-9A-Za-z_-]+)*(\?([\u4E00-\u9FA50-9a-zA-Z-_]+=[\u4E00-\u9FA50-9a-zA-Z-_%]*(&|&amp;)?)*)?\/?$/;
              var re=new RegExp(strRegex);
              if (!re.test(_defaultValue)){
                  $.alert("${ctp:i18n('form.designauth.defaultvalue.url')}");
                  return "error";
              }
		}
		ffMap[fieldName+"_defaultValue"] = _defaultValue;
		ffMap[fieldName+"_showName"] = datavalue.val();
		if(datavalue[0].tagName.toLowerCase() == "select"){
			ffMap[fieldName+"_showName"] = $("option:selected",datavalue).text();
		}
	}else if(ffMap[fieldName+"_defaultValueType"]=="extend"){
		ffMap[fieldName+"_defaultValue"] = $("#data_systemValue").val();
		ffMap[fieldName+"_showName"] = $("option:selected","#data_systemValue").text();
	}else if("" == ffMap[fieldName+"_defaultValueType"]){
		ffMap[fieldName+"_defaultValue"] = "";
		ffMap[fieldName+"_showName"] = "";
	}
	
	var show_data =$("input[name='show_']:checked");
	
	ffMap[fieldName+"_displayType"] = show_data.length==1?show_data.val():"";
	ffMap[fieldName+"_display"] = $("#show_systemValue").val();
	var _isInitNull = $("input[name='isInitNull_']:checked").val();
	if(_isInitNull == undefined){
		_isInitNull = "";
	}
	ffMap[fieldName+"_isInitNull"] = _isInitNull;
	return ffMap;
}
function getLength(value){
	if(value==null){
  		return 0;
  	}else if(value==""){
  		return 1;
  	}else{
  		var result = 0;
  		for(var i=0, len=value.length; i<len; i++){
  			var ch = value.charCodeAt(i);
  			if(ch<256){
  				result++;
  			}else{
  				result +=3;
  			}
  		}
  		return result;
  	}
}
</script>
</HTML>