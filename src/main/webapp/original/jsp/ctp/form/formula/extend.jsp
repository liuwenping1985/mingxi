
<%--
 $Author: wangfeng $
 $Rev: 261 $
 $Date:: 2013-3-17 14:00:30#$:
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums"%>
<%@ page import="com.seeyon.ctp.form.bean.*"%>
<%@page import="com.seeyon.ctp.form.util.Enums.*"%>
<html class="over_hidden h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>extend设置界面</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=formManager"></script>
<!--  设置了表单关联的外部写入字段并有千分号、百分位显示的设置可以使用extend，但是会报错，需要引入form.js中一系列该类型字段有关的方法 -->
<script type="text/javascript" src="${path}/common/content/form.js${ctp:resSuffix()}"></script>
<%@ include file="/WEB-INF/jsp/common/select2.js.jsp"%>
<script type="text/javascript">
var enumSplitStr = "<%=FormFormulaBean.ENUM_SPLIT_STR%>";
//配置参数
var dialogArg = window.dialogArguments;//所有参数
var conditionType = dialogArg.conditionType;
function OK(){
  var str =  $("#field1Name").val() + " "+$("#operation").val();
  if($("#radio1").attr("checked")){
	  //普通复选框控件
	  if($("#valueDiv1").find("input[type=checkbox]").length==1){
		  //普通复选框，选中返回 1，没选中返回 0
		  var value = ($("#valueDiv1").find("input[type=checkbox]").prop("checked") ? 1 : 0 );
		  //数字类型复选框的值不包含引号
		  if('DECIMAL' == '${field.fieldType}'){
			  str = str+" "+value+ " ";
		  }else{
			  str = str+"'"+value+"'";
		  }
	  }//如果是多选状态    如审核状态、核定状态、流程状态 则返回or关系的多个条件如  “{流程状态} =0 or {流程状态} =1”
	  else if($("#valueDiv1").find("input[type=checkbox]").length>1){
		  var baseStr = str;
		  str = "";
		  $("#valueDiv1").find("input[type=checkbox]").each(function(){
					if($(this).prop('checked')){
						var tempStr = baseStr + $(this).val();
						if(str != ''){
							tempStr = " or "+tempStr;
						}
						str += tempStr;
					}
			  });
	  }else{
	      var isEnum = false;
		  var v ="";
		  var enumId = ${field.enumId};
		  var formatEnumId= ${field.formatEnumId};
		  var rformatEnumId= ${realField.formatEnumId}; 
		  if($("#valueDiv1").find("input[type=hidden]").attr("id")==null){
			  if($("#valueDiv1").find("input:radio").length > 0){//单选			  
				  var id = $("#valueDiv1").find("input:radio:checked").val();	
				  var name = $("#valueDiv1").find("input:radio:checked").parent().text();
				  v = id==null?null:(id+enumSplitStr+name+enumSplitStr);
				  isEnum = true;
			  }else if($("#valueDiv1").find("select").length > 0){//下拉	   
				  if($.trim($("#valueDiv1").find("select option:selected").text())==""){   	
			      	  v = null;
				  }else{
					  v = $("#valueDiv1").find("select").val()+enumSplitStr+$("#valueDiv1").find("select option:selected").text()+enumSplitStr;
				  }
				  isEnum = true;
			  }else if(((enumId&& enumId !=0) || (formatEnumId && formatEnumId != 0)||(rformatEnumId && rformatEnumId != 0)) && $("#valueDiv1").find("input[type=text]")){
			      if(!$("#valueDiv1").find("input[type=hidden]").val()){
			          v = null;
			      }else{
			          v = $("#valueDiv1").find("input[type=hidden]").val()+enumSplitStr+$("#valueDiv1").find("input[type=text]").val()+enumSplitStr;
			      }
			      isEnum = true;
			  }else if($("#valueDiv1").find("textarea").length > 0){//文本域  
				  v = $("#valueDiv1").find("textarea").val();
			  }else{
				  v = $("#valueDiv1").find("input").val();
			  }
		  }else{//如果有隐藏区域的，证明是ID单元格，需要取ID
			  var divArea = $("#valueDiv1");
			  var hiddenInput4txt = divArea.find("input[id$='_txt']");
			  //如果没有找到的话，需要去找textarea，即逻辑保留原来的
			  if(hiddenInput4txt.length == 0){
				  hiddenInput4txt = divArea.find("textarea");
			  }
			  var fieldName = hiddenInput4txt.attr("id").split("_t")[0];
			  var hiddenInput4id = divArea.find("input[id='"+fieldName+"']");
		      v = hiddenInput4id.val();
              var fieldVal = $("#"+fieldName+"_span",divArea).attr("fieldVal");
              fieldVal = $.parseJSON(fieldVal);
              var fieldType = fieldVal.inputType;
              if(v.indexOf("|")>=0){//如果是组织机构类的控件，值是用|分割开的
                  var orgId = v.substring(v.indexOf("|")+1);
                  var vs = v.split(",");
				  var orgName = "";
				  if(hiddenInput4txt.length>0){
					  orgName = hiddenInput4txt.val();
				  }
                  var orgNames = orgName.split("、");
                  var vstr="";
                  for(var i=0;i < vs.length;i++){
                  	 vstr += vs[i].substring(vs[i].indexOf("|")+1)+enumSplitStr+orgNames[i]+enumSplitStr;
					if(i != vs.length - 1){
						vstr =vstr+",";
					}
                  }
                  v = vstr;
              } else if (fieldType == "project"){//关联项目也需要按照组织机构处理
				  if (v){
					  var projectName = $("#"+fieldName+"_txt").val();
					  v = v+enumSplitStr+projectName+enumSplitStr;
				  }
              }
		  }
		  //判断是都需要将值转成字符串
		  if((isEnum || needToStr())&&v!=null){
			  v = " '"+v+"'";
		  }
		  v = getValue($("#field1Name"),v);
		  str = str + " "+v+"";
	  	  if (isEnum){
		  	  var strs = str.split(" ");
		  	  str = "compareEnumValue("+strs[0] + ","+strs[1]+"," +v+")";
	  	  }
	  	  if ($("#operation").val() == "include"){
		  	  if(v != null){
		  	    str = "include("+$("#field1Name").val() + "," +v+")";
		  	  }else{
		  	    str = $("#field1Name").val() + "=" +v;
		  	  }
	  	  }
	  }
  }else if($("#radio2").attr("checked")){
      var field = $("#valueDiv2").find("option:selected");
      var v = getValue(field, field.val());
	  str = str + " " + v + "";

	  if ($("#operation").val() == "include"){
          if(v != null){
              str = "include(" + $("#field1Name").val() + "," + v + ")";
          }else{
              str = $("#field1Name").val() + "=" + v;
          }
      }
  }else if($("#radio3").attr("checked")){
	  var selectValue = $("#valueDiv3").find("option:selected").val();
	  if(selectValue != null){
		  str = "include(" + $("#field1Name").val() + "," + selectValue + ")";
	  }else{
		  str = $("#field1Name").val() + "=" + selectValue;
	  }
  }else if($("#radio4").attr("checked")){
	  var selectValue = $("#roleId").val();
	  var properties = "";
	  var operator = $("#operation").val();
	  if(selectValue != null && selectValue != ""){
		  $("[name='postType']","#postProperty").each(function(){
			  if(this.checked){
				  properties += "true,";
			  }else{
				  properties += "false,";
			  }
		  });
		  if(properties && properties.length>0){
			  properties = properties.substring(0,properties.length-1);
		  }
		  if(properties == "false,false,false"){
			  $.alert('${ctp:i18n("form.formula.chooserole.isNotNull")}');
			  return ;
		  }
		  if(operator == "="){
			  str = "isRole("+$("#field1Name").val()+",'"+selectValue+"',"+properties+")";
		  }
		  if(operator == "<>"){
			  str = "isNotRole("+$("#field1Name").val()+",'"+selectValue+"',"+properties+")";
		  }
	  }else{
		  str = $("#field1Name").val() + operator + "null";
	  }
  } else if($("#radio5").attr("checked")){
      var field = $("#valueDiv5").find("option:selected");
      var v = getValue(field, field.val());
      str = str + " " + v + "";

      if ($("#operation").val() == "include"){
          if(v != null){
              str = "include(" + $("#field1Name").val() + "," + v + ")";
          }else{
              str = $("#field1Name").val() + "=" + v;
          }
      }
  } else if($("#radio6").attr("checked")){
	  var field = $("#valueDiv6").find("option:selected");
	  var v = getValue(field, field.val());
	  str = str + " " + v + "";

	  if ($("#operation").val() == "include"){
		  if(v != null){
			  str = "include(" + $("#field1Name").val() + "," + v + ")";
		  }else{
			  str = $("#field1Name").val() + "=" + v;
		  }
	  }
  }
  return str;
}
//处理值
function getValue(field, v){
	var ret=v;
	if(ret==null||$.trim(ret)==""||$.trim(ret)=="''"){return null;}
	//日期时间的要做to_date函数处理
	if(field.attr("fieldType")=="<%=FieldType.TIMESTAMP.getKey()%>"||field.attr("fieldType")=="<%=FieldType.DATETIME.getKey()%>"){
		ret = "to_date("+v+")";
	}
	return ret;
}
//根据当前字段的类型，判断是否需要将返回的值专为字符串。
function needToStr(){
	//数字类型文本框    不需要
	if($("#field1Name").attr("fieldType")=="DECIMAL"&&$("#field1Name").attr("inputType")!="select"&&$("#field1Name").attr("inputType")!="radio"){
		return false;
	}
	return true;
}

function init(){
    var inputType = '${field.realInputType}';
    var formatEnumId= ${field.formatEnumId};
    var formatEnumIsFinalChild= ${field.formatEnumIsFinalChild}; 
    var rinputType = '${realField.realInputType}'; 
    var rformatEnumId= ${realField.formatEnumId}; 
    var rformatEnumIsFinalChild= ${realField.formatEnumIsFinalChild}; 
    if(inputType === 'select' || (inputType ==='outwrite' && (formatEnumId !=0 || formatEnumIsFinalChild==true))
            ||rinputType=== 'select' || (rinputType ==='outwrite' && (rformatEnumId !=0 || rformatEnumIsFinalChild==true))){
        $("#valueDiv1").find("input[type=text]").width($("#valueDiv1").width()-13);
    }else if(inputType&&inputType=='radio'){
    	if($.browser.msie && ($.browser.version == "8.0" || $.browser.version == "7.0")){
			$("#valueDiv1").css({"height":"100px","overflow-y":"auto"});
		}else{
			$("#valueDiv1").css({"max-height":"100px","overflow-y":"auto"});
		}
	}

    var filterFields = "${param.filterFields}";
    if (filterFields) {
    	//如果下拉框只有一个选项的时候，这里的remove会还是显示那个选项，点击以后才会消失
		$("#valueDiv2").attr("disabled","false");
        $("#valueDiv2").find("option[name='" + filterFields + "']").remove();
		$("#valueDiv2").attr("disabled","disabled");
    }
	<!--默认情况下表单域不可操作 -->
	<c:if test="${otherForm eq null && showInclude}">
	$("#radio3").prop("disabled",true);
    if(conditionType == "conditionType_sql"){
        $("#mulitField_div").hide();
    }
    </c:if>
    //因为数据库不支持字段like字段
    <c:if test="${showInclude}">
    $("#radio5").prop("disabled",true);
    </c:if>
    //暂时不支持选择角色支持数据库查询
	if(conditionType == "conditionType_sql"){
		$("#roleSelect_div").hide();
	}
    if (!dialogArg.showCurrentValue) {
        $(".currentValue").hide();
    }
	if(!dialogArg.isAutoupdate) {
		$("#auto_currentField_div").hide();
	}
    $("#operation").focus();
}
//如果是关联项目类型 后台获取的HTML字符串中定义了使用回调函数，此处定义一个空函数作为回调。
function chooseProjectCallBack(){}
//外部写入显示格式是枚举,需要客户手工选择枚举后才能显示值
function selectEnums(rootEnumId,enumLevel){
	var obj = new Array();
	obj[0] = window;
	var isfinal = false;
	var urlStr = '';
	if(rootEnumId){
	    isfinal=0;
	    urlStr = "${path}/enum.do?method=bindEnum&isFinalChild=false&bindId=0&isBind=false&rootEnumId="+rootEnumId+"&enumLevel="+enumLevel+"&isfinal="+isfinal;
	}else{
	    urlStr = "${path}/enum.do?method=bindEnum&isFinalChild=false&bindId=0&isBind=false&isfinal="+isfinal;
	}
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
				isEmphasize: true,
		      handler : function() {
			      var result = dialog.getReturnValue();
			      if(result){
			        if(rootEnumId){
			            var html = $("#valueDiv1").html();
                        html = html+"<input type='hidden'  value='"+result.enumId+"'>";
                        $("#valueDiv1").html(html);
			            $("#valueDiv1").find("input[type=text]").val(result.enumName);
			        }else{
			            var fMgr = new formManager();
	                    var html = fMgr.getFieldHTML4Select(result.enumId,result.isFinalChild==null?false:result.isFinalChild,result.nodeType);
	                    html = "<input type='text' style='width:50%' value='"+result.enumName+"' onclick='selectEnums()'>"+html;
	                    $("#valueDiv1").html(html);
	                    $("#field").css('width','50%');
			        }
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

	function setDisabled(id){
		var filedName = '${field.name}';
		$(".fieldvalue").each(function(){
			var id = $(this).attr("id");
			if(id && id =="valueDiv1" && "member" == $(this).attr("inputtype")){
				//快速选人这里不设置disabled属性，不然要报错。
			}else{
				$(".fieldvalue").prop("disabled",true);
			}

		});
		$("#" + id).prop("disabled",false);
		//灰掉选择的图标
		if(id == "valueDiv1"){
			if($("span","#valueDiv1") != undefined){
				//OA-111216表单设置各种条件时，对于组织控件、枚举、项目等显示问题
				if($(".radio_com.validate")){
					$(".radio_com.validate").attr("disabled",false);
				};
				if($(".ico16").attr("_isrel")||$(".ico16").hasClass("radio_people_16")){
					$(".ico16").show();
				}
				if($(".ico16.correlation_project_16")){
					$(".ico16.correlation_project_16").show();
				}
				if($(".calendar_icon")){
					$(".calendar_icon").show();
				}
				//下拉枚举
				if($("input[name='acToggle']")){
					$("input[name='acToggle']").attr("disabled",false);
				}
				//数据关联2级枚举
				$("#valueDiv1 input").each(function(){
					if($(this).attr("onclick")){
						if($(this).attr("onclick").indexOf("selectEnums")!=-1){
							$(this).attr("disabled",false);
						}
					}
				});
				var tempTxt = $("#"+filedName+"_txt");
				tempTxt.attr("readonly","readonly");
				$("#"+filedName).attr("readonly",false);
				tempTxt.attr("disabled",false);
				$("#"+filedName).attr("disabled",false);
			}
			if($("#postProperty")){
				$("#postProperty").hide();
			}
		}else{
			if(id == "valueDiv4"){
				$("#postProperty").show();
			}
			if($("span","#valueDiv1") != undefined){
				//OA-111216表单设置各种条件时，对于组织控件、枚举、项目等显示问题
				//下拉文本框
				$("#"+filedName+"_txt").attr("readonly",true);
				$("#"+filedName).attr("readonly",true);
				$("#"+filedName+"_txt").attr("disabled",true);
				$("#"+filedName).attr("disabled",true);
				//组织机构组件
				if($(".ico16")){
					$(".ico16").hide();
				}
				//日期
				if($(".calendar_icon")){
					$(".calendar_icon").hide();
				}
				//单选按钮组件
				if($(".radio_com.validate")){
					$(".radio_com.validate").attr("disabled",true);
				}
				//项目关联
				if($(".ico16.correlation_project_16")){
					$(".ico16.correlation_project_16").hide();
				}
				//下拉枚举
				if($("input[name='acToggle']")){
					$("input[name='acToggle']").attr("disabled",true);
				}
				//数据关联2级枚举
				$("#valueDiv1 input").each(function(){
					if($(this).attr("onclick")){
						if($(this).attr("onclick").indexOf("selectEnums")!=-1){
							$(this).attr("disabled",true);
						}
					}
				});
			}
		}
	}
	//当操作符不为include时，灰掉表单域，切默认让值一栏选中。
	function changeOperator(){
		if($("#operation").val() == "include"){
			$("#radio3").prop("disabled",false);
			$("#radio5").prop("disabled",false);
		}else{
            <c:if test="${otherForm eq null && showInclude}">
            $("#radio1").prop("checked",true);
//            $("#radio3").prop("checked",false);
            $("#radio5").prop("disabled",false);
            $("#radio3").prop("disabled",true);
			setDisabled("valueDiv1");
			</c:if>
		}
	}
	//选择角色
	var tempSelected = {text:"",value:""};
	var tempSelectedElements = null;
	function selectRole(){
		$.selectPeople({
			//mode:'open',
			type:'selectPeople',
			targetWindow:window.top,
			panels: "Role",
			selectType:"Role",
			showFlowTypeRadio: false,
			hiddenMultipleRadio: false,
			hiddenColAssignRadio: true,
			maxSize:1,
			minSize:1,
			showFixedRole:true,
			isConfirmExcludeSubDepartment:false,
			onlyLoginAccount:true,
			isCanSelectGroupAccount:false,
			params:tempSelected,
			elements: tempSelectedElements,
			callback:function(ret){
				if(ret && ret.obj){
					//每次只能选一个角色，不用将已选的带回去，不然又要多点一次删掉。
					//tempSelected.text = ret.text;
					//tempSelected.value = ret.value;
					$("#valueDiv4").val(ret.text);
					var obj = ret.obj;
					$("#roleId").val(obj[0].id+enumSplitStr+obj[0].name+enumSplitStr);
					tempSelectedElements = ret.obj;
				}
			}
		});
	}
</script>
<style type="text/css">
.common_txtbox_wrap .radio_com{
	width:15px;
	height:15px;
	margin:3px;
}
</style>
</head>
<BODY scroll=yes onload="init()" class="h100b">
    <form name="formulaDateDiffer" method="post">
        <div class="form_area">
            <div class="clearfix margin_t_5">
                <div id = "field1Label" class="left" style="width: 110px;text-align: right;">${ctp:i18n('form.formula.engin.formdata.label')}：</div>
                <div class="left common_txtbox_wrap" style="width: 200px;">
                    <input id="field1Name" value="${fieldDisplay}" fieldType="${field.fieldType}" inputType="${field.inputType}" type="text" readOnly style="width: 200px;">
                </div>
            </div>
            <div class="clearfix margin_t_5">
                <div id = "operatorLabel" class="left" style="width: 110px;text-align: right;">${ctp:i18n('form.formula.engin.operator.label')}：</div>
                <div class="left" style="width: 212px;">
                    <div class="common_txtbox clearfix">
                        <div class="common_selectbox_wrap">
                        	<select id=operation name="operation" onchange="changeOperator()">
                        	    <c:if test="${field.fieldType eq 'TIMESTAMP' || field.fieldType eq 'DATETIME' || field.fieldType eq 'DECIMAL' && field.name ne 'start_member_id' && field.name ne 'modify_member_id' && field.name ne 'state' && field.name ne 'ratifyflag' && field.name ne 'finishedflag'}">
                        		<option value=">">&gt;</option>
                        		<option value=">=">&gt;=</option>
                        		<option value="<">&lt;</option>
                        		<option value="<=">&lt;=</option>
                        	    </c:if>	
                        		<option selected value="=">=</option>
                        		<c:if test="${field.name ne 'state' && field.name ne 'ratifyflag' && field.name ne 'finishedflag' }">
                        			<option value="<>">&lt;&gt;</option>
                        		</c:if>
                                <c:if test="${showInclude}">
                                    <option value="include">include</option>
                                </c:if>
                        	</select>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clearfix margin_t_5">
                <div id = "valueLabel" class="left hand" style="width: 110px;text-align: right;">
                    <label class="right" for="radio1">${ctp:i18n('form.formula.engin.value.label')}： </label>
                    <input id="radio1" class="radio_com" name="inputType" value="1" type="radio" checked onclick="setDisabled('valueDiv1')">
                </div>
                <div class="left common_txtbox_wrap fieldvalue" style="width: 200px;" inputtype="${inputType}" id="valueDiv1">${html}</div>
            </div>
        </div>

        <c:if test="${otherForm ne null}">
        <div id="otherField_div" class="clearfix margin_t_5">
            <div class="left font_size12" style="width: 110px;text-align: right;">
                <label class="hand" for="radio2">
                    <input type="radio" id="radio2" name="inputType" class="radio_com" value="2" onclick="setDisabled('valueDiv2')">a.${ctp:i18n('form.formula.engin.formdata.label')}：
                </label>
            </div>
            <div class="left" style="width: 212px;">
                <select class="fieldvalue" id="valueDiv2" name="valueDiv2" style="width: 212px;" disabled>
                <c:forEach items="${fieldList}" var="obj" varStatus="status">
                    <option id="${obj['id']}" name="${obj['name']}" value="{<%=FormBean.M_PREFIX%>${fn:substringAfter(obj['ownerTableName'],'_')}.${obj['display']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if> <c:if test="${!obj['masterField']}">isSubField=true</c:if>><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if> <c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}]</c:if>${obj['display']}</option>
				</c:forEach>
                </select>
            </div>
        </div>
        </c:if>
		<c:if test="${otherForm eq null && showInclude}">
			<div id="mulitField_div" class="clearfix margin_t_5">
				<div class="left font_size12" style="width: 110px;text-align: right;">
					<label class="hand" for="radio3">
						<input type="radio" id="radio3" name="inputType" class="radio_com" value="3" onclick="setDisabled('valueDiv3')">${ctp:i18n('form.formula.engin.formdata.label')}：
					</label>
				</div>
				<div class="left" style="width: 212px;">
					<select class="fieldvalue" id="valueDiv3" name="valueDiv3" style="width: 212px;" disabled>
						<c:forEach items="${fieldList}" var="obj" varStatus="status">
							<option id="${obj['id']}" name="${obj['name']}" value="{${obj['display']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if> <c:if test="${!obj['masterField']}">isSubField=true</c:if>><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if> <c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}${obj.ownerTableIndex}]</c:if>${obj['display']}</option>
						</c:forEach>
					</select>
				</div>
			</div>
		</c:if>
        <div class="clearfix margin_t_5 currentValue font_size12">
            <div id = "currentvalueLabel" class="left hand" style="width: 110px;text-align: right;">
                <label class="right" for="radio5">${ctp:i18n('form.formula.engin.formvalue.label')}： </label>
                <input id="radio5" class="radio_com" name="inputType" value="1" type="radio" onclick="setDisabled('valueDiv5')">
            </div>
            <div class="left" style="width: 212px;">
                <select class="valueDiv5 fieldvalue" id="valueDiv5" style="width: 212px;" disabled>
                    <c:forEach items="${currentFieldList}" var="obj">
                        <option id="${obj['id']}" name="${obj['name']}" value="[f.${obj.display}]" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}">
                            [${ctp:i18n('form.base.mastertable.label')}]${obj['display']}
                        </option>
                    </c:forEach>
                </select>
            </div>
        </div>
		<!-- 选择单人控件支持角色选择 -->
		<c:if test="${canSelectRole eq true}" >
			<div id="roleSelect_div" class="clearfix margin_t_5">
				<div class="left font_size12" style="width: 110px;text-align: right;">
					<label class="hand" for="radio4">
						<input type="radio" id="radio4" name="inputType" class="radio_com" value="4" onclick="setDisabled('valueDiv4')">${ctp:i18n('form.formula.engin.role')}：
					</label>
				</div>
				<div class="left" style="width: 212px;">
					<div>
					<input type="hidden" id="roleId" />
					<input class="hand fieldvalue" disabled type="text" name="valueDiv4" readonly="readonly" id="valueDiv4" style="width:212px;"
						   value="${ctp:i18n('form.formula.engin.selectpeople')}" onclick="selectRole()"/>
					</div>
				</div>
			</div>
			<div id="postProperty" class="clearfix margin_t_5" style="display: none">
				<div class="left font_size12" style="width: 110px;text-align: right;">
					&nbsp;
				</div>
				<div>
				<!--主岗部门 -->
				<input type="checkbox" id="primaryPost" checked name="postType" checked="true" value="true"  title="${ctp:i18n('form.formula.mainpost.label')}">
				<label for="primaryPost" class="font_size12">${ctp:i18n('form.formula.mainpost.label')}</label>
				<!--非主岗部门 -->
				<input type="checkbox" id="secondPost" name="postType" value="true" title="${ctp:i18n('form.formula.secondpost.label')}">
				<label for="secondPost" class="font_size12">${ctp:i18n('form.formula.secondpost.label')}</label>
				<!--兼职部门 -->
				<input type="checkbox" id="cntpost" <c:if test="${!needConcurrpost}">class="hidden" </c:if> name="postType" value="true" title="${ctp:i18n('form.formula.concurrpost.label')}">
				<label for="cntpost" <c:if test="${!needConcurrpost}">class="hidden" </c:if>  class="font_size12">${ctp:i18n('form.formula.concurrpost.label')}</label>
				</div>
			</div>
		</c:if>
		<div id="auto_currentField_div" class="clearfix margin_t_5">
			<div class="left font_size12" style="width: 110px;text-align: right;">
				<label class="hand" for="radio6">
					<input type="radio" id="radio6" name="inputType" class="radio_com" value="6" onclick="setDisabled('valueDiv6')">${ctp:i18n('form.formula.engin.flowformvar.label')}：
				</label>
			</div>
			<div class="left" style="width: 212px;">
				<select class="fieldvalue" id="valueDiv6" name="valueDiv6" style="width: 212px;" disabled>
					<c:forEach items="${currentFieldList}" var="obj" varStatus="status">
						<c:if test="${obj['masterField']}">
							<option id="${obj['id']}" name="${obj['name']}" value="[<%=FormBean.FLOW_PREFIX%>${obj['display']}]" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if> <c:if test="${!obj['masterField']}">isSubField=true</c:if>><%=FormBean.FLOW_PREFIX%><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if> <c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}]</c:if>${obj['display']}</option>
						</c:if>
					</c:forEach>
				</select>
			</div>
		</div>
     </form>
</BODY>
</HTML>