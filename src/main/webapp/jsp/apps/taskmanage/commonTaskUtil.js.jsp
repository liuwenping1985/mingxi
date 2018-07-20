<%--
 $Author: xiangq $
 $Rev: 1783 $
 $Date:: 2012-11-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script type="text/javascript">
    /**
     * 将日期转换成对应的字符串日期格式
     * @param dateObj 日期数据
     * @return 转换后的日期字符串
     */
    function convertDateToStr(dateObj) {
        var dt = null;
        var dateStr = null;
        var dateFormatStr = null;
        if (dateObj != null && dateObj.length > 0) {
            dt = new Date(dateObj.replace(/\-/g, '/'));
        }
        if (dateObj.length > 10) {
            dateFormatStr = "%Y${ctp:i18n('taskmanage.year.label')}%m${ctp:i18n('metadata.manager.month')}%d${ctp:i18n('menu.tools.calendar.ri')} %H:%M";
        } else {
            dateFormatStr = "%Y${ctp:i18n('taskmanage.year.label')}%m${ctp:i18n('metadata.manager.month')}%d${ctp:i18n('menu.tools.calendar.ri')}";
        }
        if(dt != null){
            dateStr = dt.print(dateFormatStr);
        } else{
            dateStr = "";
        }
        return dateStr;
    }
    
    /**
     * 替换字符当中的尖括号
     * @param str 要替换的字符串
     * @param enterString 替换的字符
     * @return 转换后的字符串
     */
    function replaceTag(str, enterString){
        var temp = "";
        if(typeof(str)=="string"){
            enterString = enterString==null?"<br/>":enterString;
            temp = str.replace(/&/g, "&gt;");
            temp = temp.replace(/</g,"&lt;");
            temp = temp.replace(/>/g,"&gt;");
            temp = temp.replace(/ /g, "&nbsp;");
            temp = temp.replace(/\'/g, "&#39;");
            temp = temp.replace(/\"/g, "&quot;");
            temp = temp.replace(/\r\n/g, enterString);
            temp = temp.replace(/\n/g, enterString);
        }
        return temp;
    }
    
    /**
     * 验证任务信息的合法性
     * @param taskId 任务编号
     * @param fromObj 功能来源
     * @param runFunc 要执行的方法
     * @return 验证是否合法
     */
    function validateTaskInfo(taskId, fromObj, runFunc) {
        var taskAjax = new taskAjaxManager();
        var isTask = taskAjax.validateTask(taskId);
        if(isTask != null && !isTask) {
            $.alert({
                'msg' : "${ctp:i18n('taskmanage.task_deleted')}",
                ok_fn : function() {
                    if (runFunc instanceof Function) {
                        runFunc();
                    }
                }
            });
            return false;
        }
        if(fromObj != "Manage" && fromObj != "Project"){
            var isView = true;
            var isFromTree = "${empty param.isFromTree ? 0 : param.isFromTree}";
            if(isFromTree > 0) {
                isView = taskAjax.validateTreeTaskDetails(taskId);
            } else {
                isView = taskAjax.validateTaskView(taskId);
            }
            if(isView != null && !isView) {
                $.alert({
                    'msg' : "${ctp:i18n('taskmanage.alert.no_auth_view_task')}",
                    ok_fn : function() {
                        if (runFunc instanceof Function) {
                            runFunc();
                        }
                    }
                });
                return false;
            }
        }
        return true;
    }
    
    /**
     * 关闭所有的弹出窗口
     * @param tw 页面对象
     */
    function closeAllDlg(tw){
        var targetWindow = window; 
        if(tw){
          targetWindow = tw;
        }
        targetWindow.$('.mask').remove();
        targetWindow.$('.dialog_box').remove();
        targetWindow.$('.shield').remove();
        targetWindow.$('.mxt-window').remove();
    }
</script>