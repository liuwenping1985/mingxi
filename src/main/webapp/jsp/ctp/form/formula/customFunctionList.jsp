<%--
 $Author: dengxj $
 $Rev: 32451 $
 $Date:: 2014-02-17 13:51:02#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>函数自定义页面</title>
</head>
<body scrolling="no">
	<div class="comp" comp="type:'layout'" id="layout">
		<%-- 顶部按钮区域 --%>
		 <div id="north" style="border-top:1px solid #b6b6b6;border-left: none;" class="layout_north" layout="width:260,height:40,maxHeight:40,minHeight:40,sprit:false,spiretBar:{show:false}">
         <div id="toolbar"></div>
        </div>
        <div class="layout_center" id="center" style="overflow:hidden;">
			<div class="" id="content" style="width:100%;height:456px;bottom:0;top:0;border-left: 1px solid #b6b6b6;">
				<table id="mytable" class="flexme3" style="display: none;height:80px;overflow:auto;"></table>
				<div id="grid_detail" style="overflow:auto;">
					<iframe id="bottomIframe" src=""  width="100%" height="100%" frameBorder="no" scrolling="no"></iframe>
				</div>
			</div>
			<!-- 作为删除或者其他动作用的,对于页面显示没有任何作用的 -->
			<iframe class="hidden" id="delIframe" src=""></iframe>
        </div>
    </div>
</body>
<script type="text/javascript">
	var gridObj;
	var formId = "${formId}";
	var formulaType = "${formulaType}";
	var componentType = "${componentType}";
	var fieldName = "${fieldName}";
	var fieldTableName = "${fieldTableName}";
	$(document).ready(function (){
		createToolBar();
		createTable();
	});
	//******************************toolbar相关操作**************************//
	//创建toolbar
	function createToolBar(){
		var toolBarParam = {
			    toolbar: [{id: "new",name: "${ctp:i18n('common.toolbar.new.label')}",className: "ico16",click:newFunction},
			              {id: "editor",name: "${ctp:i18n('common.toolbar.update.label')}",className: "ico16 editor_16",click:editorFunction},
			              {id: "delete",name: "${ctp:i18n('common.button.delete.label')}",className: "ico16 del_16",click:delFunction}]
		};
		$("#toolbar").toolbar(toolBarParam);
	}
	//新建
	function newFunction(){
		gridObj.grid.resizeGridUpDown('middle');
		$("#bottomIframe").attr("src","${path}/form/formula.do?method=formulaFunctionDesign&formId="+formId+"&formulaType="+formulaType+"&fieldName="+fieldName+"&componentType="+componentType);
	}
	//修改
	function editorFunction(){
		var rows = gridObj.grid.getSelectRows();
		if(rows.length == 0){
			$.alert("${ctp:i18n('form.formlist.pleasechooseone')}");
			return;
		}
		if(rows.length > 1){
			$.alert("${ctp:i18n('form.formlist.canonlychooseone')}");
			return;
		}
		gridObj.grid.resizeGridUpDown('middle');
		$("#bottomIframe").attr("src","${path}/form/formula.do?method=formulaFunctionDesign&pageType=editor&formId="+formId+"&formulaType="+formulaType+"&fieldName="+fieldName+"&id="+rows[0].id+"&componentType="+componentType);
	}
	//删除
	function delFunction(){
		var rows = gridObj.grid.getSelectRows();
		if(rows.length == 0){
			$.alert("${ctp:i18n('form.formlist.pleasechooseone')}");
			return;
		}
		var ids = "";
		for(var i=0;i < rows.length;i++){
			if(ids != ""){
				ids = ids + "," + rows[i].id;
			}else{
				ids = rows[i].id;
			}
		}
		var confirm = $.confirm({
		    'msg': '${ctp:i18n("form.formula.customfunction.confirmtodelete")}',
		    ok_fn: function () { 
		    	//进行计算式判断
				$("#bottomIframe").prop("src","${path}/form/formula.do?method=delCustomFunction&ids="+ids);
				$("#bottomIframe").load(function (){
					window.location.reload();
		    	});
				confirm.close();
		    },
			cancel_fn:function(){
				confirm.close();
			}
		});
	}
	//******************************table相关操作**************************//
	//创建表格结构
	function createTable(){
		var tableParam = {
	            colModel : [ {display : 'id',name : 'id',width : '8%',sortable : false,align : 'center',type : 'checkbox',hide:false,isToggleHideShow:true},
	                         {display : '${ctp:i18n("form.formula.customfunction.functionname.label")}',name : 'functionName',width : '51%',sortable : true,align : 'left',hide:false,isToggleHideShow:true},
	                         {display : '${ctp:i18n("form.formula.customfunction.functionparams.label")}',name : 'functionParam',sortable : true,align : 'left',hide:true,isToggleHideShow:true},
	                         {display : '${ctp:i18n("form.formula.customfunction.selectparam.label")}',name : 'selectParam',sortable : true,align : 'left',hide:true,isToggleHideShow:true},
	                         {display : '${ctp:i18n("form.formula.customfunction.codetype.label")}',name : 'codeType',width : '20%',sortable : true,align : 'left',hide:false,isToggleHideShow:true},
	                         {display : '${ctp:i18n("form.formula.customfunction.returntype.label")}',name : 'returnType',width : '20%',sortable : true,align : 'center',hide:false,isToggleHideShow:true}],
	            showTableToggleBtn: false,
	            parentId: "content",
				showToggleBtn:false,//屏蔽可选显示列的功能
	            usepager:false,
	            customize:false,
	            click :functionClick,
	            isHaveIframe:true,
	            vChange: true,
	     	    vChangeParam: {
	     	    	overflow: "hidden",
	     	   		autoResize:true
	     		},
	            slideToggleBtn: true,
	            managerName : "formCustomFunctionManager",
	            managerMethod : "customFunctionList"
	     };
		var o = new Object();
		o.returnType = formulaType;
		o.componentType = componentType;
		gridObj = $("table.flexme3").ajaxgrid(tableParam);
		$("#mytable").ajaxgridLoad(o);
	}
	function functionClick(data,r,c){
		gridObj.grid.resizeGridUpDown('middle');
		$("#bottomIframe").attr("src","${path}/form/formula.do?method=formulaFunctionDesign&pageType=browser&formId="+formId+"&formulaType="+formulaType+"&fieldName="+fieldName+"&id="+data.id+"&componentType="+componentType);
	}
	//弹出框点击确定方法
	function OK(){
		var rows = gridObj.grid.getSelectRows();
		if(rows.length == 0){
			$.alert('${ctp:i18n("form.formula.customfunction.atleatselectone")}');
			return null;
		}
		if(rows.length > 1){
			$.alert('${ctp:i18n("form.formula.customfunction.onlyselectone")}');
			return null;
		}
		var functionParam = rows[0].functionParam;
		var paramArray = functionParam.split(",");
		var selectParam = rows[0].selectParam;
		var paramValueArray = selectParam.split(",");
		var paramValue = "";
		var currentTableName = "";
		var isExistDifTableName = false;
		for(var j = 0;j < paramValueArray.length;j++){
			if(paramValueArray[j].indexOf(".") > -1){
				currentTableName = paramValueArray[j].substring(0,paramValueArray[j].indexOf("."));
				if(currentTableName.indexOf("formson") > -1 && (fieldTableName.indexOf("formmain") > -1 
						|| (fieldTableName.indexOf("formmain") == -1 && fieldTableName != currentTableName))){
					isExistDifTableName = true;
					break;
				}
			}
		}
		/**
		if(isExistDifTableName == true){
			if(fieldTableName.indexOf("formmain") > -1){
				$.alert("该函数参数设置中存在重复表字段！请重新选择！");
			}else{
				$.alert("该函数参数设置中存在非当前重复表字段！请重新选择！");
			}
			return null;
		}*/
		for(var i = 0;i < paramArray.length;i++){
			if(paramValue != ""){
				paramValue = paramValue + "," + "{"+paramArray[i]+"}";
			}else{
				paramValue = "{"+paramArray[i]+"}";
			}
		}
		return " selfFunction('"+rows[0].functionName+"',"+paramValue+")";
	}
</script>
</html>
