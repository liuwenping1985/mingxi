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
    <script type="text/javascript" src="${path}/ajax.do?managerName=detaillogManager"></script>
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
                               width: '12%'
                           }, {
                               display: "${ctp:i18n('common.deal.state')}",//处理状态
                               name: 'stateLabel',
                               sortname : 'affair.state',
                               sortable : true,
                               width: '12%'
                           }, {
                               display: "${ctp:i18n('common.workflow.create.date')}",//发起/收到时间
                               name: 'createDate',
                               sortname : 'affair.createDate',
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
                height:$(document).height()-38,
                resizable :false
            });
            //回调函数
            function rend(txt, data, r, c) {
                if(c > 3 && ($.trim(txt) === "")){
                    return "－";
                }
                //超期 变红色
                if(c==6){
                	if(data.coverTime == true){
	                	txt = "<span class='color_red'>"+txt+"</span>";
	                }
                }
                return txt;
           }
        });

    </script>
</head>
<body class="page_color  h100b over_hidden" id='print'>
    <!-- 处理明细 -->
    <table class="flexme3" id="showListInfo"></table>
</body>
</html>
