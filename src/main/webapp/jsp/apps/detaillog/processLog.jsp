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
    <script type="text/javascript" src="${path}/ajax.do?managerName=detaillogManager"></script>
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
                               width: '16%'
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
                               width: '44%'
                           }],
                isHaveIframe:true,
                render : rend,
                managerName : "detaillogManager",
                managerMethod : "getProcessLog",
                height:$(document).height()-38,
                resizable :false
            });
            //回调函数
            function rend(txt, data, r, c) {
                if(txt == null || txt === ""){
                    return "-";
                }
                return txt;
           }  
        });
                
    </script>
</head>
<body class="page_color  h100b over_hidden" id='print'>
    <!-- 处理明细 -->
    <table class="flexme3" id="showProcessInfo"></table>
</body>
</html>
