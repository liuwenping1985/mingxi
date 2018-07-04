<%--
 $Author:  zhaifeng$
 $Rev:  $
 $Date:: 2012-11-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title></title>
    <style type="text/css">
        .stadic_head_height { height: 55px; }
        .stadic_body_top_bottom { bottom: 0px; top: 55px; }
        .public_title { text-indent:1em; height:30px; line-height:30px; font-weight: bold;font-size: 14px;font-family:'Microsoft YaHei',SimHei;}
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#showProcessInfo').ajaxgrid({
                colModel: [
                           {
                               display: "${ctp:i18n('processLog.list.number.label')}",//序号
                               name: 'number',
                               sortable : true,
                               width: '6%'
                           }, {
                               display: "${ctp:i18n('processLog.list.actionuser.label')}",//操作人
                               name: 'handler',
                               sortname : 'actionUserId',
                               sortable : true,
                               width: '10%'
                           }, {
                               display: "${ctp:i18n('processLog.list.date.label')}",//操作时间
                               name: 'finishDate',
                               sortname : 'actionTime',
                               sortable : true,
                               width: '18%'
                           }, {
                               display: "${ctp:i18n('processLog.list.content.label')}",//操作内容
                               name: 'content',
                               sortname : 'actionId',
                               sortable : true,
                               width: '22%'
                           }, {
                               display: "${ctp:i18n('processLog.list.description.label')}",//操作描述
                               name: 'desc',
                               sortname : 'actionId',
                               sortable : true,
                               width: '32%'
                           }, {
                               display: "${ctp:i18n('processLog.list.workflowdetail.label')}",//流转明细
                               name: 'detailStatus',
                               sortable : false,
                               width: '10%'
                           }],
                isHaveIframe:true,
                render : rend,
                managerName : "detaillogManager",
                managerMethod : "getProcessLog",
                height:$(document).height()-157,
                resizable :false
            });
            //回调函数
            function rend(txt, data, r, c,clm) {
            	if(c==5){
            		if(data.detailStatus==1){
            			txt= "<a herf=\"javascript:void(0)\" onclick=\"showWorkflowMatchLogListPage('"+data.id+"')\">${ctp:i18n('processLog.detailStatus.1')}</a>";
            		}else{
            			txt= "${ctp:i18n('processLog.detailStatus.0')}";
            		}
            	}else{
            		if(txt == null || txt === ""){
                        return "-";
                    }
            	}
                return txt;
           }  

           $("#logCategory li").bind("click",function(){
              $(this).addClass("current").siblings('li').removeClass('current');
           });

        });
        var _processId = '${_processId}'
         function classificationDisplay(classification){
        	 var obj = new Object();
         		obj.processId = _processId;
         	if(classification == 'editWF'){
         		obj.editWF = 1;
         	}else if(classification == 'editContent'){
         		obj.editContent = 1;
         	}else if(classification == 'sborstop'){
         		obj.sborstop = 1;
         	}
         	$("#showProcessInfo").ajaxgridLoad(obj);
         }
        
        function showWorkflowMatchLogListPage(processLogId){
        	var dialog = $.dialog({
       	        id: 'workflow_dialog_showMatchMsgInfoPage_Id',
       	        isFromModle: true,
       	        url : '<c:url value="/workflow/designer.do?method=showWorkflowMatchLogListPage"/>&processLogId='+processLogId,
       	        width : 1000,
       	        height : 400,
       	        title : '流转明细',
       	        targetWindow:getCtpTop(),
       	        buttons : [ {
       	          text : '${ctp:i18n("common.button.close.label")}',
       	          handler : function() {
       	        	  dialog.close();
       	          }
       	        }]
       	      });
        }
    </script>
    <style type="text/css">
        .stadic_head_height { height: 110px; }
        .stadic_body_top_bottom { overflow-y:hidden; bottom: 0px; top: 117px;}
    </style>
</head>
<body class="page_color  h100b over_hidden" id='print'>
    <!-- 处理明细 -->
    <div class="stadic_layout">
      <div class="stadic_layout_head stadic_head_height">
          <ul class="logCategory" id="logCategory">
              <li class="logAll current" onclick="classificationDisplay('all')" title="${ctp:i18n('common.detail.label.all')}"><span class="logIcon_45"></span><span class="num">${allConut}</span><span class="explain">${ctp:i18n('common.detail.label.all')}</span></li>
              <li class="logEditWorkflow " onclick="classificationDisplay('editWF')" title="${ctp:i18n('common.detail.label.editWf')}"><span class="logIcon_45"></span><span class="num">${editWF}</span><span class="explain">${ctp:i18n('common.detail.label.editWf')}</span></li>
              <li class="logEditContent " onclick="classificationDisplay('editContent')" title="${ctp:i18n('common.detail.label.editContent')}"><span class="logIcon_45"></span><span class="num">${editContent }</span><span class="explain">${ctp:i18n('common.detail.label.editContent')}</span></li>
              <li class="logStepBackOrStop " onclick="classificationDisplay('sborstop')" title="${ctp:i18n('common.detail.label.sborstop')}"><span class="logIcon_45"></span><span class="num">${sborStop}</span><span class="explain">${ctp:i18n('common.detail.label.sborstop')}</span></li>
          </ul>
      </div>
      <div class="stadic_layout_body stadic_body_top_bottom">
        <table class="flexme3" id="showProcessInfo"></table>
      </div>
    </div>
</body>
</html>
