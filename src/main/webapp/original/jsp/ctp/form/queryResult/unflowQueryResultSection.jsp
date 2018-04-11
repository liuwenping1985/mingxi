<%--
 $Author: zhaifeng $
 $Rev: 9416 $
 $Date:: 2014-11-06 12:46:11#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script type="text/javascript" src="${path}/common/content/formCommon.js${ctp:resSuffix()}"></script>
		<script type="text/javascript" src="${path}/common/form/common/unflowQueryResultSection.js${ctp:resSuffix()}"></script>
        <script type="text/javascript" src="${path}/common/form/common/unFlowCommon.js${ctp:resSuffix()}"></script>
		<script type="text/javascript" src="${path}/ajax.do?managerName=formManager"></script>
		<script type="text/javascript" src="${path}/ajax.do?managerName=formDataManager"></script>
    </head>
    <style>
        .ellipsis{
            overflow:hidden;
            white-space:nowrap;
            text-overflow:ellipsis;
        }
    </style>
    <script type="text/javascript">
        //列表头
        var theadStr = '${theadStr}';
        //正文数据
        var _data = '${ctp:escapeJavascript(_data)}';
        //表单ID
        var _formId = '${_formId}';
        //模板ID
        var _formTemplateId = '${_formTemplateId}';
        //模板名称
        var _templateName = '${_templateName}';
        //正文类型
        var _moduleType = '${_moduleType}';
        //视图权限ID
        var _view_rightId = '${_rightId}';
        //视图ID和新建权限ID
        var _editAuth = '${ctp:escapeJavascript(editAuth)}';
        //url页面的字段
        var urlFieldList = '${urlFieldList}';
        $(document).ready(function() {	
        	//初始化列表样式和数据
        	initGridList($.parseJSON(theadStr),$.parseJSON(_data),$.parseJSON(urlFieldList));
        	$(".clickfun").css("cursor","pointer");
            $(".clickfun").css("max-width","210px");
        	//处理单击和双击错乱，导致双击执行2次单击问题
        	var timer = null;
        	//单击一行记录 ，弹出浏览单据页面
            $(".clickfun").click(function(){
            	clearTimeout(timer);
            	var moduleId = $(this).attr("id");
            	if($.trim(moduleId) == ""){
            	    moduleId = $(this).parent("td").attr("id");
            	}
            	timer = setTimeout(function() {
            		openUnflowFormView(_templateName,moduleId,_moduleType,_view_rightId,_formId,_formTemplateId);
           		}, 300);
                
            });
        	
        	//双击一行记录，弹出编辑单据页面
            $(".clickfun").dblclick(function(){
            	clearTimeout(timer); 
            	//没有修改权限时，进入查看页面
                var moduleId = $(this).attr("id");
                if($.trim(moduleId) == ""){
                    moduleId = $(this).parent("td").attr("id");
                }
            	if(_editAuth == "" || $.parseJSON(_editAuth) == ""){
                    openUnflowFormView(_templateName,moduleId,_moduleType,_view_rightId,_formId,_formTemplateId);
            	}else{
            		// 有修改权限，进入修改页面
            		dblclickFun(moduleId,_formId,_formTemplateId,_moduleType,_editAuth,"unflowSection");
            	}
           	});
            
        }); 
        
        
        
    </script>
    <body class="h100b bg_color_white bg_color_none">
    <div style="height: 100%;overflow: auto">
        <table id="mytable"  width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
        </table>
    </div>
	</body>
</html>