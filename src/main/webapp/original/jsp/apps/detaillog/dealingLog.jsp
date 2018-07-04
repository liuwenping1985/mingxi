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
    <script type="text/javascript">
        $(document).ready(function () {
            var grid = $('#showListInfo').ajaxgrid({
                colModel: [
                           {
                               display: "${ctp:i18n('common.workflow.handler')}",//处理人
                               name: 'handler',
                               sortname : 'affair.memberId',
                               sortable : true,
                               width: '10%'
                           }, {
                               display: "${ctp:i18n('common.workflow.policy')}",//节点权限
                               name: 'policyName',
                               sortname : 'affair.nodePolicy',
                               sortable : true,
                               width: '10%'
                           }, {
                               display: "${ctp:i18n('common.deal.state')}",//处理状态
                               name: 'stateLabel',
                               sortname : 'affair.state',
                               sortable : true,
                               width: '9%'
                           }, {
                               display: "${ctp:i18n('common.workflow.create.date')}",//发起/收到时间
                               name: 'createDate',
                               sortname : 'affair.createDate',
                               sortable : true,
                               width: '14%'
                           }, {
                               display: "${ctp:i18n('common.workflow.first.view.date')}",//首次查看时间
                               name: 'firstViewDate',
                               sortname : 'affair.firstViewDate',
                               sortable : true,
                               width: '14%'
                           }, {
                               display: "${ctp:i18n('common.workflow.finish.date')}",//处理时间
                               name: 'finishDate',
                               sortname : 'affair.completeTime',
                               sortable : true,
                               width: '14%'
                           }, {
                               display: "${ctp:i18n('common.workflow.dealTime.date')}",//处理时长
                               name: 'dealTime',
                               sortname : 'affair.completeTime',
                               sortable : true,
                               width: '12%'
                           }, {
                               display: "${ctp:i18n('common.workflow.deadline.date')}",//处理期限
                               name: 'deadline',
                               sortname : 'affair.deadlineDate',
                               sortable : true,
                               width: '12%'
                           }, {
                               display: "${ctp:i18n('collaboration.timeouts.label')}",//超时时长
                               name: 'deadlineTime',
                               sortname : 'affair.completeTime',
                               sortable : true,
                               width: '12%'
                           }],
                render : rend,
                managerName : "detaillogManager",
                managerMethod : "getFlowNodeDetail",
                height:$(document).height()-157,
                resizable :false
            });
            //回调函数
            function rend(txt, data, r, c) {
                if(c > 3 && ($.trim(txt) === "")){
                    return "－";
                }
                //超期 变红色
                if(c==7){
                	if(data.coverTime == true){
	                	txt = "<span class='color_red'>"+txt+"</span>";
	                }
                }
                return txt;
           }


           $("#logCategory li").bind("click",function(){
              $(this).addClass("current").siblings('li').removeClass('current');
           });
        })
        var summaryId = '${_summaryId}';
        var _isHistoryFlag = '${_isHistoryFlag}';
		function classificationDisplay(classification){
        	var obj = new Object();
        	obj.objectId = summaryId;
        	obj.isHistoryFlag = _isHistoryFlag;
        	if(classification == 'numProcessed'){
        		obj.numProcessed = 1;
        	}else if(classification == 'numPending'){
        		obj.numPending = 1;
        	}else if(classification == 'numViewed'){
        		obj.numViewed = 1;
        	}else if(classification == 'numNotViewed'){
        		obj.numNotViewed = 1;
        	}
        	$("#showListInfo").ajaxgridLoad(obj);
        }
    </script>
    <style type="text/css">
        .stadic_head_height { height: 110px; }
        .stadic_body_top_bottom { overflow-y:hidden; bottom: 0px; top: 117px;overflow-x:hidden;}
    </style>
</head>
<body class="page_color  h100b over_hidden" id='print'>
    <!-- 处理明细 -->
    <div class="stadic_layout">
      <div class="stadic_layout_head stadic_head_height">
          <ul class="logCategory" id="logCategory">
              <li class="logAll current" onclick="classificationDisplay('numTotal')" title="${ctp:i18n('common.detail.label.all')}"><span class="logIcon_45"></span><span id="numTotal" class="num">${numTotal}</span><span class="explain">${ctp:i18n('common.detail.label.all')}</span></li>
              <li class="logProcessed " onclick="classificationDisplay('numProcessed')" title="${ctp:i18n('common.detail.label.done')}"><span class="logIcon_45"></span><span id="numProcessed"  class="num">${numProcessed}</span><span class="explain">${ctp:i18n('common.detail.label.done')}</span></li>
              <li class="logPending " onclick="classificationDisplay('numPending')" title="${ctp:i18n('common.detail.label.pending')}"><span class="logIcon_45"></span><span id="numPending"  class="num">${numPending}</span><span class="explain">${ctp:i18n('common.detail.label.pending')}</span></li>
              <c:if test="${configReadStateEnable ne 'disable'}">
	              <li class="logViewed " onclick="classificationDisplay('numViewed')" title="${ctp:i18n('common.detail.label.viewed')}"><span class="logIcon_45"></span><span id="numViewed"  class="num">${numViewed}</span><span class="explain">${ctp:i18n('common.detail.label.viewed')}</span></li>
	              <li class="logNotViewed " onclick="classificationDisplay('numNotViewed')" title="${ctp:i18n('common.detail.label.noteviewed')}"><span class="logIcon_45"></span><span id="numNotViewed"  class="num">${numNotViewed}</span><span class="explain">${ctp:i18n('common.detail.label.noteviewed')}</span></li>
              </c:if>
          </ul>
      </div>
      <div class="stadic_layout_body stadic_body_top_bottom">
        <table class="flexme3" id="showListInfo"></table>
      </div>
    </div>
</body>
</html>
