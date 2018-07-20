<%--
 $Author: zhaifeng $
 $Rev: 9416 $
 $Date:: 2014-11-18 12:46:11#$:
  
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
        <script type="text/javascript" src="${path}/ajax.do?managerName=formManager"></script>
        <script type="text/javascript" src="${path}/ajax.do?managerName=formDataManager"></script>
    </head>
    
    <script type="text/javascript">
	    //主数据ID
	    var _moduleId = '${_moduleId}';
	    //正文类型
	    var _moduleType = '${_moduleType}';
	    //视图权限ID
	    var _view_rightId = '${_rightId}';
	    //模板名称
        var _templateName = '${_templateName}';
        //表单ID
        var _formId = '${_formId}';
        //模板ID
        var _formTemplateId = '${_formTemplateId}';
        //视图ID和新建权限ID
        var _editAuth = '${ctp:escapeJavascript(editAuth)}';
        $(document).ready(function() {  
        	//查看模式 1 可编辑状态  2不可编辑状态 3 可编辑但没有JS事件状态 4 表单设计态
        	//window.location.href = getUnflowFormViewUrl(true, _moduleId, _moduleType, _view_rightId, 2);
        	if($.trim(_moduleId) != ""){
       		    $("#singleDataBody").attr("src",getUnflowFormViewUrl(true, _moduleId, _moduleType, _view_rightId, 2));
        	}
        	
        	$("#singleDataBody").load(function(){
                var iframeBody = $("#singleDataBody").contents().find("html");
                if($.trim(_moduleId) != ""){
                    iframeBody.css("cursor","pointer");//添加手型样式
                }
                //处理单击和双击错乱，导致双击执行2次单击问题
                var timer = null;
                //绑定单击事件
                iframeBody.bind("click",function(event){
                	clearTimeout(timer);
                	//判断是否点击了正文内容，如果正文内容中包含了其它点击事件，会导致触发多次，防止这种冒泡事件发生，添加判断
                    var target = event.target || event.srcElement
                    if(!isClick(event)){
                        return;
                    }
                    if(typeof target.onclick !== 'function'){
                    	timer = setTimeout(function() {
                    		//获得多视图时当前显示的是哪个视图
                    		var _currentDiv = iframeBody.find("#_currentDiv").val();
                    		openUnflowFormViewForSingleData(_templateName,_moduleId,_moduleType,_view_rightId,_currentDiv);
                        }, 300);
                    }
                });
                //绑定双击事件
                iframeBody.bind("dblclick",function(event){
                	clearTimeout(timer); 
                	//判断是否点击了正文内容，如果正文内容中包含了其它点击事件，会导致触发多次，防止这种冒泡事件发生，添加判断
                    var target = event.target || event.srcElement
                    if(!isClick(event)){
                    	return;
                    }
                    if(typeof target.onclick !== 'function'){
                    	//没有修改权限时，进入查看页面
                        if(_editAuth == "" || $.parseJSON(_editAuth) == ""){
                            iframeBody.click();
                        }else{
                            // 有修改权限，进入修改页面
                            dblclickFun(_moduleId,_formId,_formTemplateId,_moduleType,_editAuth,"unflowSection");
                        }
                    }
                });
                
            });
        }); 
        
    </script>
    <body class='h100b bg_color_white bg_color_none'>    
        <iframe frameborder="0" width="100%" height="100%" id="singleDataBody"> </iframe>
    </body>
</html>