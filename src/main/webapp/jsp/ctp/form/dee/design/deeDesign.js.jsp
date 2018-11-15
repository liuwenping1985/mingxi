<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums,com.seeyon.ctp.form.util.*"%>
<script type="text/javascript">
//表单前台dee设置初始化方法
function initDeeDesign(){
	<c:forEach items="${formBean.allFieldBeans}" var="field" varStatus="status">
		var index = "${status.index}";
		if("${field.deeTask}"){
			if("${field.deeTask.selectType}" == "select"){
				var refFieldDisplay = "${field.deeTask.refFieldDisplay}";
				$("#selectBindInput"+index).show();
				$("#selectBindInput"+index).val("${field.deeTask.name}"+"-"+refFieldDisplay);
				$("#selectBindInput"+index).attr("value","${field.deeTask.name}"+"-"+refFieldDisplay);
			}else{
				$("#selectBindInput"+index).show();
				$("#selectBindInput"+index).val("${field.deeTask.name}");
				$("#selectBindInput"+index).attr("value","${field.deeTask.name}");
			}
			var paramStr="";
			<c:forEach items="${field.deeTask.taskParamList}" var="param" varStatus="st">
				paramStr += "${param.name}"+","+"${param.value}"+","+"${param.description}";
				paramStr +="|";
			</c:forEach>
			
			var fieldStr ="";
			<c:forEach items="${field.deeTask.taskFieldList}" var="taskField" varStatus="st">
				fieldStr += "${taskField.name}"+","+"${taskField.display}"+","+"${taskField.fieldtype}"+","+"${taskField.fieldlength}"+","+"${taskField.checked}";
				fieldStr +="|";
			</c:forEach>
			if(paramStr.length>0){
				paramStr = paramStr.substring(0,paramStr.length-1); 
			}
			if(fieldStr.length>0){
				fieldStr = fieldStr.substring(0,fieldStr.length-1);
			}
			$("#paramStr"+index).val(paramStr+"");
			$("#selectBindInput"+index).attr("fieldStr",fieldStr+"");
//			setRelFieldType($("#refTaskField"+index).val(),fieldStr,index);  //升级上来的数据不再修改长度
		}
	</c:forEach>
}
//该方法必须放到后台去！节省性能(这里主要是做初始化dee的数据关联-关联属性)
function initDeeTaskRelation(){
	<c:forEach items="${formBean.allFieldBeans}" var="field" varStatus="status">
		var index = "${status.index}";
		if($("#inputType"+index).val()=="relation"){		
			var _val = "${field.refInputName}";
			var refIndex = $("#"+_val+"tr").attr("index");
			var relType = $("#inputType"+refIndex).val();
			if(relType=="exchangetask"){
				//$("#refInputAttr"+index).empty();
				addRefInputAttr(index,"${field.formRelation.viewAttr}");
				var oldIndex = refIndex;
				$("#relationAttrType"+index).val("6");
				var fieldStr = $("#selectBindInput"+oldIndex).attr("fieldStr");
				if(fieldStr!=""){
					$("#refInputAttr"+index).val("");
					$("#refInputAttr"+index).show();
					var refInputAttr = document.getElementById("refInputAttr"+index);
					var length = refInputAttr.options.length;
					if(length>0){
						for(var m = length -1 ; m >= 0 ; m--){
							refInputAttr.options.remove(m);
						}
					}
					refInputAttr.options.add(new Option("",""));
					var fields = fieldStr.split("|");
					var viewAttr = $("#bindSetAttr"+index).attr("viewAttr");
					if(fields.length>0){
						for(var i= 0; i<fields.length; i++){
							var fieldArr = fields[i].split(",");
                            //if(fieldArr.length>0 && fieldArr[4]=="true"){ 展示所有字段
							if(fieldArr.length>0){
								var option = new Option(fieldArr[1],fieldArr[0]);
								$(option).attr("fieldType",fieldArr[2]);
								$(option).attr("fieldLength",fieldArr[3]);
								refInputAttr.options.add(option);
							}
						}
						if(viewAttr!=""){
							refInputAttr.value = viewAttr;
						}
						$("#refInputAttr"+index).comp();
						
					}
				}
			}
		}
	</c:forEach>
}
//对表单字段关联信息进行展现
function setRelFieldType(relField,fieldStr,index){
	if(relField==""){
		return;
	}
	var fields = fieldStr.split("|");
	if(fields.length>0){
		for(var i= 0; i<fields.length; i++){
			var fieldArr = fields[i].split(",");
			if(fieldArr.length>0 && relField == fieldArr[0]){
				changeInputType(index,fieldArr[2],fieldArr[3],"","");
				break;
			}
		}
	}
}
//弹出设置数据交换任务
function setExchangeTaskDialog(index,isCanChange){
	var obj=new Array();
	obj[0]=window;
	obj[1]=index;
	//var params="";
	var inputType = $("#inputType"+index).val();
	var fieldName = $("#fieldName"+index).attr("value");
	var oldInputType = $("#inputType"+index).attr("oldInputType");
	/* if(oldInputType == extendName){
		var taskId = $("#taskId"+index).val();
		var taskResult = $("#taskResult"+index).val();
		var taskParamStr = $("#taskParam"+index).val();
		var taskFieldStr = $("#fieldStr"+index).val();
		var taskRelField = $("#refTaskField"+index).val();
		params = "&taskId="+taskId+"&taskResult="+encodeURI(taskResult)+"&taskParamStr="
					+encodeURI(taskParamStr)+"&taskFieldStr="+encodeURI(taskFieldStr)+
					"&taskRelField="+encodeURI(taskRelField); 
	} */
	var dialog = $.dialog({
		url:encodeURI("${path}/dee/deeDesign.do?method=setDEETask&fieldName="+fieldName+
				"&isCanChange="+isCanChange+"&inputType="+inputType+"&oldInputType="+oldInputType+"&random="+Math.round()),
	    title : '${ctp:i18n("form.create.input.setting.deetask.label")}',
	    width:500,
		height:300,
		targetWindow:getCtpTop(),
		transParams:obj,
	    buttons : [{
	      text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",
	      id:"sure",
	      handler : function() {
		      var condi = dialog.getReturnValue();
		      if(condi == "error"){
			      return;
		      }else{
		    	  var taskName = condi.taskName;
		    	  var refFieldDisplay = condi.refFieldDisplay;
		    	  if(refFieldDisplay ==""){
		    		  $("#selectBindInput"+index).attr("value",taskName);
		    	  }else{
		    		  $("#selectBindInput"+index).attr("value",taskName+"-"+refFieldDisplay);
		    	  }
		    	  setExchangeTaskData(condi,index);
		      }
	    	  dialog.close();
	      }
	    }, {
	      text : "${ctp:i18n('form.query.cancel.label')}",
	      id:"exit",
	      handler : function() {
	        dialog.close();
	      }
	    }]
	  });
} 

function setExchangeTaskData(data,index){
	$("#inputType"+index).attr("oldInputType",$("#inputType"+index).val());
	//if(taskId==taskIdOld){
		//return;
	//} 
	var taskRelField  = data.refInputField;
	//var refFieldDisplay = data.refFieldDisplay;
	var fieldStr = data.taskField;
	setRelFieldType(taskRelField,fieldStr,index);
	$("#selectBindInput"+index).attr("fieldStr",fieldStr);
}

//改变关联对象获取关联属性事件
function changeRefInputName4Dee(index,refIndex){
    if(isExistSlaveRelError4Dee(index)){
        $.alert("${ctp:i18n('form.base.slave.field.datarelation.error.label')}");
        if($("#refInputAttr"+index).val() != "" && $("#refInputAttr"+index).val() != null){
            $("#refInputName"+index).val($("#refInputName"+index).attr("oldRefInputName"));
        }else{
            $("#refInputName"+index).val("");
        }
        return;
    }

	$("#refInputAttr"+index).empty();
	var oldIndex = refIndex;
    $("#bindSetAttr"+index).attr("relationAttrType","6");
	var fieldStr = $("#selectBindInput"+oldIndex).attr("fieldStr");
	if(fieldStr!=""){
		$("#refInputAttr"+index).val("");
		$("#refInputAttr"+index).show();
		var refInputAttr = document.getElementById("refInputAttr"+index);
		
		var length = refInputAttr.options.length;
		if(length>0){
			for(var m = length -1 ; m >= 0 ; m--){
				refInputAttr.options.remove(m);
			}
		}
		refInputAttr.options.add(new Option("",""));
		var fields = fieldStr.split("|");
		var viewAttr = $("#bindSetAttr"+index).attr("viewAttr");
		if(fields.length>0){
			for(var i= 0; i<fields.length; i++){
				var fieldArr = fields[i].split(",");
                //if(fieldArr.length>0 && fieldArr[4]=="true"){ 展示所有字段
				if(fieldArr.length>0){
					var option = new Option(fieldArr[1],fieldArr[0]);
					$(option).attr("fieldType",fieldArr[2]);
					$(option).attr("fieldLength",fieldArr[3]);
					refInputAttr.options.add(option);
				}
			}
//			if(viewAttr!=""){
//				refInputAttr.value = viewAttr;
//			}
			$("#refInputAttr"+index).comp();
		}
	}
}
//dee弹出设置框绑定事件
function selectBind4Dee(index,isShow){
	if(!isShow) return;
	if($("#selectBindInput"+index).val()){
        var errorMsg = "";
        var canModify = "false";
		var isExistData = hasData($("#fieldName"+index).attr("value"));
        if (isExistData) {
            errorMsg = "${ctp:i18n('form.base.dataform.inputtype.error.label')}";
        } else if (!checkInputType2Change(index)) {
            errorMsg = "${ctp:i18n('form.base.relation.objct.isref.label')}!";
        } else if (isInCheckRule(index)) {
            errorMsg = $.i18n('form.base.field.isincheckrule.error.label');
        } else {
            var options = getValidateFieldOptions(index);
            var returnStr = vlidateFormFieldChange(options);
            if(returnStr.value != "1" && returnStr.value != "000"){
                errorMsg = returnStr.error;
            } else {
                canModify = "true";
            }
        }
        if (canModify == "true") {
            setExchangeTaskDialog(index,canModify);
        } else {
            $.alert({
                'msg':errorMsg,
                ok_fn:function(){
                    setExchangeTaskDialog(index,canModify);
                }});
        }
	} else {
		setExchangeTaskDialog(index,"true");
	}
}
//验证inputType为exchangetask或querytask时，是否选择了dee任务
function validateExchangeTask(){
	for(var i=0; i<fieldListSize; i++){
		var inputType = $("#inputType"+i).val();
		if(inputType == "exchangetask"){
			var refField = $("#selectBindInput"+i).val();
			if(refField =="" || refField=="undefined"){
				$.alert("${ctp:i18n('form.base.field.exchangetask.error.label')}!");
				return false;
			}
		}else if(inputType == "querytask"){
			var refField = $("#selectBindInput"+i).val();
			if(refField =="" || refField=="undefined"){
				$.alert("${ctp:i18n('form.base.field.querytask.error.label')}!");
				return false;
			}
		}
	}
	return true;
}

//重复表判断是否有不相同的关联对象
function isExistSlaveRelError4Dee(index){
    var isExist = false;
    for(var i=0;i < fieldListSize;i++){
        if(i == index) continue;
        if($("#fieldName"+i).attr("isMasterField") == "true") continue;
        if($("#fieldName"+i).attr("tableName") != $("#fieldName"+index).attr("tableName")) continue;
        if($("#bindSetAttr"+i).attr("relationAttrType") == "6" && $("#inputType"+i).val() == "relation"
                && $("#refInputName"+i).val() != "" && $("#refInputName"+i).val() != null && $("#refInputName"+index).val() != ""
                && $("#refInputName"+index).find("option:selected").attr("ismasterfield") == "true" && $("#refInputName"+i).find("option:selected").attr("ismasterfield") == "true"
                && $("#refInputName"+index).val() != null && $("#refInputName"+i).val() != $("#refInputName"+index).val()){
            isExist = true;
            break;
        }
    }
    return isExist;
}
</script>