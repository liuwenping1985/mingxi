<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-09-18

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/business/bizRedirect/bizRedirectUtil.jsp"%>
<html style="width: 100%;height: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务重定向</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager"></script>
</head>
<body style="width: 100%;height: 100%">
	<div id='baseSetRedirect'>

	</div>
<!-- 工具方法 -->
<script>
var grid;
$().ready(function() {
	var jsonData = parent.getData();
	var tableDataArray = eval("("+jsonData+")");
	grid = new RedirectGrid({
		  data:tableDataArray,  //必备参数，传入Javascript对象，对应Java后台的List<FormValidateResultBean>
		  dom:document.getElementById("baseSetRedirect")  //选填参数，期望在页面哪个元素里显示表格内容,默认body下
	});
    parent.window.endLoadingData();
});

/**
 * 重定向
 */
function actionRedirect(obj){
	var locationKey = $(currentTr.find("#location4System")[0]).val();
	locationKey = isNaN(locationKey) ? 0 : parseInt(locationKey);
	switch(locationKey){
		case 101 : //校验设置
			break;
		case 102 : //计算公式条件
			break;
		case 103 : //(HR)关联属性
			var fieldType = $(currentTr.find("#firstReference")[0]).val();
			var dialog = $.dialog({
				url:"${path}/form/business.do?method=dataRelationHRSet&fieldType="+fieldType,
			    title : '选择人员属性',
			    width:300,
				height:200,
			    buttons : [{
			      text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",
			      id:"sure",
					isEmphasize: true,
			      handler : function() {
			    	  var result = dialog.getReturnValue();
			    	  if(result != false) {
                          setNewValue4Formula(result,false);
			  		  	dialog.close();
			    	  }
			      }
			    }, {
			      text : "${ctp:i18n('form.query.cancel.label')}",
			      id:"exit",
			      handler : function() {
			        dialog.close();
			      }
			    }]
			  });
			break;
		case 104 : //(DEE)插件
			break;
		case 105 : //自定义控件
			break;
		default:;
	}
}

/**
 * 拼装重定向后的数据返回
 */
function pieceData4JSON(){
	return $.toJSON($("#baseSetRedirect").formobj());
}
/**
 * 切换页签回掉函数,返回obj 对象
 * obj.complateRedirect 是否完成当前页面所有重定向
 * obj.bizObj 当前页面返回的 json 对象
 */
function getResultJSON(){
  var obj = {};
  //一定要先拼装值，才能确定是否重定向完成
  obj.bizObj = pieceData4JSON();
  //这里先对dee插件，自定义控件等重定向进行判断。
  obj.completeRedirect = grid.checkRedirectRight();
  return obj;
}
</script>
</body>
</html>