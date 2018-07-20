<%--
 $Author:  xiangq$
 $Rev:  280$
 $Date:: 2013-01-17 14:38:52#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>任务统计新增</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>

<script type="text/javascript">
    function OK(obj) {
        var valid = false;
        var taskAjax = new taskAjaxManager();
        var statisticsId = $("#id").val();
        if(statisticsId.length > 0) {
            var name = $("#statistics_name").val();
            var objParams = new Object();
            objParams.name = name;
            objParams.statisticsId = statisticsId;           
            if(taskAjax.isTaskStatisticsExist(objParams)) {
                var confirm = $.confirm({
                    'msg' : "确认覆盖原有的任务统计吗？",
                    ok_fn : function() {
                        valid = saveTaskStatistics(obj);
                    },
                    cancel_fn : function() {
                    }
                });
            }
        } else {
            valid = saveTaskStatistics(obj);
        }
        return valid;
    }
    
    /**
     * 提交保存任务统计数据
     * @param obj 参数条件
     * @return 保存是否成功
     */
    function saveTaskStatistics(obj) {
        var parentWindowData = window.dialogArguments;
        var valid = $("#statistics_form").validate();
        if ((valid == true || valid == "true") && validateStatisticsName()) {
            $("#statistics_form").jsonSubmit({
                domains : [ "domain_statistics_info" ],
                debug : false,
                callback : function(res) {
                    if(res.indexOf("1") > -1 ) {
                        res = 1;
                    }
                    if (res == 1) {
                        obj.dialogObj.close();
                        if(parentWindowData.refresh) {
                            parentWindowData.refresh();
                        }
                    }
                }
            });
        }
        return valid;
    }
    
    /**
     * 初始化页面数据
     */
    function initPageData () {
        var parentWindowData = window.dialogArguments;
        if(parentWindowData.frmobj) {
            $("#statisticsType").val(parentWindowData.frmobj.statisticsType);
            $("#userId").val(parentWindowData.frmobj.userId);
            $("#roleType").val(parentWindowData.frmobj.roleType);
            $("#status").val(parentWindowData.frmobj.status);
            $("#riskLevel").val(parentWindowData.frmobj.riskLevel);
            $("#importantLevel").val(parentWindowData.frmobj.importantLevel);
            $("#id").val(parentWindowData.frmobj.statistics_id);
        }
    }
    
    /**
     * 验证统计名称是否重复
     */
    function validateStatisticsName () {
        var bool = true;
        var statisticsId = $("#id").val();
        var taskAjax = new taskAjaxManager();
        if(statisticsId.length == 0) {
            var name = $("#statistics_name").val();
            var obj = new Object();
            obj.name = name;
            if(taskAjax.isTaskStatisticsExist(obj)) {
                $.alert("您设置的统计名称已存在，请重新设置！");
                bool = false;
            }
        }
        return bool;
    }
    
    /**
     * 初始化按钮事件
     */
    function initBtnEvent () {
        $("#statistics_name").keyup(function (){
            if($("#id").val().length > 0) {
                $("#id").val("");
            }
        });
    }
    
    $(document).ready(function() {
        initPageData();
        initBtnEvent();
    });
</script>
</head>
<body class="page_color">
    <div class="form_area  margin_5" id="statistics_info">
        <form id="statistics_form" name="statistics_form" method="post" action="${path}/taskmanage/taskstatistics.do?method=saveStatistics">
            <table id="domain_statistics_info" border="0" cellspacing="0" cellpadding="0" width="90%" align="center">
                <tr>
                    <th nowrap="nowrap"></th>
                    <td width="100%" colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <th nowrap="nowrap"></th>
                    <td width="100%" colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>我的统计:</label></th>
                    <td width="100%" colspan="4"><input type="hidden" id="task_id" name="task_id" />
                        <div class="common_txtbox_wrap">
                            <input type="hidden" id="statisticsType" name="statisticsType" />
                            <input type="hidden" id="userId" name="userId" />
                            <input type="hidden" id="roleType" name="roleType" />
                            <input type="hidden" id="status" name="status" />
                            <input type="hidden" id="riskLevel" name="riskLevel" />
                            <input type="hidden" id="importantLevel" name="importantLevel" />
                            <input type="hidden" id="id" name="id" />
                            <input id="statistics_name" type="text" name="statistics_name" class="validate"
                                validate="type:'string',name:'我的统计',notNull:true,maxLength:85" />
                        </div></td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>