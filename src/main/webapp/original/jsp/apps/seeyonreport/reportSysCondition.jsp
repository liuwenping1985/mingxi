<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:2014-04-23
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/select2.js.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${path}/common/seeyonreport/commonMap.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/seeyonreport/reportSysCondition.js${ctp:resSuffix()}"></script>
<title>报表系统条件设置</title>
<script type="text/javascript">
	//模板中调用的数据集
	var datasetNames = ${datasetName};
	//组织机构变量
	var orgJson = ${orgJson};
	//日期变量
	var dateJson = ${dateJson};
	//初始化 数据集
	var dsMap = new Map();
	initMap();
	
	$(document).ready(function(){
		//去掉回车事件
		document.onkeydown=function(event){
			var e = event || window.event || arguments.callee.caller.arguments[0];
            if(e && e.keyCode==13){ // enter 键
                 return false;
            }
        }; 
        
        var systemCondtionVal = window.parentDialogObj["conditionSet"].getTransParams();
		if(systemCondtionVal != "" && systemCondtionVal.length > 0 && systemCondtionVal[0] != ""){
			var reVal = "";
			for(var i=0;i<systemCondtionVal.length;i++){
				if(i == 0){
					$("#dataTableForm").html(systemCondtionVal[i]);
				}else{
					reVal = $.parseJSON(systemCondtionVal[i]);
				}
			}
			if(reVal != "" && reVal.length > 0){
				var index = 0;
				for(var j = 0;j < reVal.length;j++){
					var reObj = reVal[j];
					for(var k = 0;k < reObj.length;k++){
						var obj = reObj[k];
						var id = $($("#dataTableForm tr")[index]).attr("id").substr(2);
						//左括号置为选中
						$("#leftBrackets"+id).val(obj.leftBrackets);
						//数据集置为选中
						$("#dataSetName"+id).val(obj.formTableName);
						//数据集字段置为选中状态
					    $("#dataColumn"+id).val(obj.dsColumn);
						//将操作符置为选中状态
						$("#rowOperationTd"+id + " select[id^=operation]").val(obj.operVal);
						
						//将数据值类型置为选中状态
						$("#paramType"+id).val(obj.paramTypeVal);
						if(obj.paramTypeVal == "type_kj" ){
							var inputType = obj.inputType;
							var extendDsColumnVal = obj.extendDsColumnVal;
							if(inputType == 'select' || inputType == 'project' || inputType == 'checkbox'){
		             		 	var param = new Object();
			         		  	//操作符的值
			         		  	param.operation = obj.operVal;
			         		  	//数据字段的值
			         		  	param.fieldValue = obj.extendDsColumnVal;
		             		 	changeDatacolunm(id,param);
		             		 	//关联的枚举
		             		 	if(inputType == 'select'){
		                            var _selectObj = $("#strTypeTd"+id).find("select[id='"+ id +"']");
		                            if(_selectObj[0] && (_selectObj[0].nodeName == "SELECT" ||_selectObj[0].nodeName == "select")){
		                                //下拉列表不处理
		                            }else{
		                                $("#strTypeTd"+id).find("input[id='"+obj.dsColumn+"']").val(obj.dsColumnValDisplay);
		                                $("#strTypeTd"+id).find("input[id='"+obj.dsColumn+"_enumval']").val(obj.dsColumnVal);
		                                $("#strTypeTd"+id).find("input[id='fieldValue']").val(obj.dsColumnVal);
		                            }
		             		 	}
							}else if(inputType == 'radio'){
								var param = new Object();
			         		  	//操作符的值
			         		  	param.operation = obj.operVal;
			         		  	//数据字段的值
			         		  	var fieldValue = obj.extendDsColumnVal.split("、");
			         		  	param.fieldValue = obj.extendDsColumnVal;
			         		  	$("#strTypeTd"+id + " span input").each(function(){
			         		  		$(this).removeAttr("checked");
			         		  	});
			         		  	for(var i = 0;i < fieldValue.length;i++){
			         		  		$("#strTypeTd"+id + " span input[value='"+fieldValue[i]+"']").attr("checked",'true');
			         		  	}
							}else if(inputType == "text"){
								$("#strTypeTd"+id + " span input").val(obj.dsColumnValDisplay);
							}else {
								//赋值并且激活控件
								var $t = $("#strTypeTd"+id + " .comp");
		         		  		$t.val(obj.dsColumnValDisplay);
								$t.comp();
								//调整样式
				       		 	$t.css('height', '20px').css('width', "110px");
							}
							//日期或者日期时间控件时调整样式，把图标靠右，防止遮盖
							if(inputType == "datetime" || inputType == "date") {
								$("#strTypeTd"+id + " span.calendar_icon").css('left', "-5px");
							}
						}else{
							$("#cloumnVal"+id).val(obj.dsColumnVal);
						}
						//右括号置为选中
						$("#rightBrackets"+id).val(obj.rightBrackets);
						//逻辑关系置为选中
						$("#logicalOperators"+id).val(obj.logicalOperators);
						
						index ++;
					}
				}
			}
		}else{
			$("#allDataTable").append(showTableStyle($.now()));
		}
		
	});

</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_center" id="center" layout="border:true">
            <fieldset class="fieldset_box margin_10 padding_10">
            	<legend>${ctp:i18n('form.query.condition.label')}:</legend>
            		<div style="height:340px;overflow:auto">
            		<form id="dataTableForm">
            			<table width="100%" border="0" cellspacing="5" cellpadding="0" align="center" id="allDataTable"></table>
            		</form>
            		</div>	
            </fieldset>
        </div>
     </div>
     
</body>
</html>