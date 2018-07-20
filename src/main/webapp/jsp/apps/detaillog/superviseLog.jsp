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
    <title>${ctp:i18n('common.life.log.label')}</title>
    <script type="text/javascript" src="${path}/ajax.do?managerName=detaillogManager"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#showSuperviseInfo').ajaxgrid({
                colModel: [
                           {
                               display: "${ctp:i18n('processLog.list.number.label')}",//序号
                               name: 'number',
                               sortable : true,
                               width: '6%'
                           }, {
                               display: "${ctp:i18n('supervise.col.hastener')}",//催办人
                               name: 'senderName',
                               sortname : 'a.sender',
                               sortable : true,
                               width: '14%'
                           }, {
                               display: "${ctp:i18n('supervise.col.hastenTime')}",//催办时间
                               name: 'sendTime',
                               sortname : 'a.sendTime',
                               sortable : true,
                               width: '14%'
                           }, {
                               display: "${ctp:i18n('supervise.col.receiver')}",//被催办人
                               name: 'receiverName',
                               sortname : 'mem.name',
                               sortable : true,
                               width: '13%'
                           }, {
                               display: "${ctp:i18n('collaboration.supervise.life.content')}",//催办附言
                               name: 'content',
                               sortname : 'a.content',
                               sortable : true,
                               width: '52%'
                           }],
                isHaveIframe:true,
                render : rend,
                managerName : "detaillogManager",
                managerMethod : "getRemindersLog",
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
<body class="page_color h100b over_hidden" id='print'>
    <!-- 督办日志 -->
    <table class="flexme3" id="showSuperviseInfo"></table>
</body>
</html>
