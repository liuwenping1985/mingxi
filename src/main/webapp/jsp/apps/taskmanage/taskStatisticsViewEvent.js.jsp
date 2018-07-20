<%--
 $Author: xiangq $
 $Rev: 1783 $
 $Date:: 2012-01-15 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script type="text/javascript">
    /**
     * 条件设置展示事件
     */
    function showConditionSetPanel(){
        initConditionSet();
        if($.browser.msie && ($.browser.version == "6.0") && !$.support.style) {
            $("#condition_set").slideToggle("normal",function(){
                if ($(this).is(':hidden')) {
                    layout.setNorth(80);
                    $("#condition_content_area").css("height","60px");
                    return;
                }
                $("#condition_set").css("height","135px");
            });
            
            layout.setNorth(220);
            $("#condition_content_area").css("height","200px");
        } else {
            $("#condition_set").slideToggle("normal",function(){
    			if ($(this).is(':hidden')) {
    				layout.setNorth(80);
    				return;
    			}
    		});
    		layout.setNorth(220);
        }
    }
    
    /**
     * 切换本周或本月时间
     * @type 日期类型
     */
    function changeWeekOrMonth(type) {
        var taskAjax = new taskAjaxManager();
        taskAjax.receiveWeekOrMonth(type, {
            success : function(ret){
                if(ret != null && ret.length > 0){
                    var dateStr = ret.split(",");
                    $("#startTime").val(dateStr[0]);
                    $("#endTime").val(dateStr[1]);
                }
            }, 
            error : function(request, settings, e){
                $.alert(e);
            }
        });
    }
    
    /**
     * 切换统计图
     */
    function changeStatisticsPic(){
        var val = $(this).val();
        if(val == "pie") {
            $("#statistics_table").addClass("hidden");
            $("#statistics_chart").removeClass("hidden");
            statistics_chart.params.chartType = ChartType.pie;
            statistics_chart.params.is3d = true;
            statistics_chart.params.insideLabel = "{%YPercentOfTotal}%";
            statistics_chart.params.outsideLabel = null;
            statistics_chart.refreshChart();
        } else if(val == "line"){
            $("#statistics_table").addClass("hidden");
            $("#statistics_chart").removeClass("hidden");
            statistics_chart.params.chartType = ChartType.line_vertical;
            statistics_chart.params.is3d = false;
            statistics_chart.params.insideLabel = null;
            statistics_chart.params.outsideLabel = "{%Value}{numDecimals:0}";
            statistics_chart.refreshChart();
        } else if(val == "histogram"){
            $("#statistics_table").addClass("hidden");
            $("#statistics_chart").removeClass("hidden");
            statistics_chart.params.chartType = ChartType.column;
            statistics_chart.params.is3d = false;
            statistics_chart.params.insideLabel = null;
            statistics_chart.params.outsideLabel = "{%Value}{numDecimals:0}";
            statistics_chart.refreshChart();
        } else if(val == "biaoge"){
            $("#statistics_chart").addClass("hidden");
            $("#statistics_table").removeClass("hidden");
            var indexNames = $("#index_names").val();
            var dataList = $("#data_list").val();
            var htmlStr = "<thead><tr><th>标题</th><th>个数</th><th>比重</th></tr></thead>";
            htmlStr +="<tbody>";
            if(indexNames.length > 0 && dataList.length > 0){
                var indexs = indexNames.split(",");
                var datas = dataList.split(",");
                var total = 0;
                for(var c = 0;c < datas.length; c++){
                    total += parseInt(datas[c]);
                }
                for(var i = 0;i < indexs.length;i++){
                    var weight = 0;
                    if(total != 0) {
                        weight = (datas[i] / total) * 100;
                    }
                    htmlStr += "<tr><td>" + indexs[i] + "</td><td><a href='javascript:void(0)' onclick='viewTaskStatistics(\""+indexs[i]+"\")'>" + datas[i] + "</a></td><td><a href='javascript:void(0)' onclick='viewTaskStatistics(\""+indexs[i]+"\")'>" + weight.toFixed(2) + "%</a></td></tr>";
                }
            } else {
                htmlStr += "<tr><td>无</td><td>0</td><td>0%</td></tr>";
            }
            htmlStr += "</tbody>";
            $("#statistics_table").html(htmlStr);
        }
    }

    function onPointClick(e) {
        var param = e.data.Name;
        viewTaskStatistics(param);
    }

    /**
     * 查看任务信息
     * @param condParam 条件参数
     */
    function viewTaskStatistics(condParam) {
        //"&status=" +$("#status").val() +
        var title = "任务统计穿透信息查看";
        var dialog = $.dialog({
            id : 'view',
            url : _ctxPath + '/taskmanage/taskinfo.do?method=listTasks&listType=Statistic&userId='+$("#userId").val() 
                    + "&startTime=" + $("#startTime").val() + "&endTime=" + $("#endTime").val() + getCondition(condParam) 
                    + "&source=statistics",
            width : $(getCtpTop()).width()-100,
            height : $(getCtpTop()).height()-100,
            title : title,
            targetWindow : getCtpTop(),
            buttons: [{
                text: "${ctp:i18n('common.button.close.label')}",
                handler: function () {
                    dialog.close();
                }
            }]
        });
    }
    
    /**
     * 查看任务信息
     * @param condParam 条件参数
     */
    function getCondition(condParam) {
        var tempStr = "";
        if($("#statisticsType").val() == "status") {
            if(condParam == "${ctp:i18n('taskmanage.status.notstarted')}") {
                tempStr = "&status=1&roleType="+ $("#roleType").val() + "&riskLevel=" + $("#riskLevel").val()
                          + "&importantLevel=" + $("#importantLevel").val();
            } else if(condParam == "${ctp:i18n('taskmanage.status.marching')}") {
                tempStr = "&status=2&roleType="+ $("#roleType").val() + "&riskLevel=" + $("#riskLevel").val()
                + "&importantLevel=" + $("#importantLevel").val();
            } else if(condParam == "${ctp:i18n('taskmanage.status.delayed')}") {
                tempStr = "&status=3&roleType="+ $("#roleType").val() + "&riskLevel=" + $("#riskLevel").val()
                + "&importantLevel=" + $("#importantLevel").val();
            } else if(condParam == "${ctp:i18n('taskmanage.status.finished')}") {
                tempStr = "&status=4&roleType="+ $("#roleType").val() + "&riskLevel=" + $("#riskLevel").val()
                + "&importantLevel=" + $("#importantLevel").val();
            } else if(condParam == "${ctp:i18n('taskmanage.status.canceled')}") {
                tempStr = "&status=5&roleType="+ $("#roleType").val() + "&riskLevel=" + $("#riskLevel").val()
                + "&importantLevel=" + $("#importantLevel").val();
            }
        } else if($("#statisticsType").val() == "riskLevel") {
            if(condParam == "${ctp:i18n('taskmanage.risk.no')}") {
                tempStr = "&status="+ $("#status").val() +"&roleType="+ $("#roleType").val() 
                        + "&riskLevel=0&importantLevel=" + $("#importantLevel").val();
            } else if(condParam == "${ctp:i18n('taskmanage.risk.low')}") {
                tempStr = "&status="+ $("#status").val() +"&roleType="+ $("#roleType").val() 
                        + "&riskLevel=1&importantLevel=" + $("#importantLevel").val();
            } else if(condParam == "${ctp:i18n('taskmanage.risk.normal')}") {
                tempStr = "&status="+ $("#status").val() +"&roleType="+ $("#roleType").val() 
                        + "&riskLevel=2&importantLevel=" + $("#importantLevel").val();
            } else if(condParam == "${ctp:i18n('taskmanage.risk.high')}") {
                tempStr = "&status="+ $("#status").val() +"&roleType="+ $("#roleType").val() 
                        + "&riskLevel=3&importantLevel=" + $("#importantLevel").val();
            }
        } else if($("#statisticsType").val() == "roleType") {
            if(condParam == "${ctp:i18n('common.creater.label')}") {
                tempStr = "&status=" + $("#status").val() + "&roleType=0&riskLevel=" + $("#riskLevel").val() 
                        + "&importantLevel=" + $("#importantLevel").val();
            } else if(condParam == "${ctp:i18n('taskmanage.manager')}") {
                tempStr = "&status=" + $("#status").val() + "&roleType=1&riskLevel=" + $("#riskLevel").val() 
                        + "&importantLevel=" + $("#importantLevel").val();
            } else if(condParam == "${ctp:i18n('taskmanage.participator')}") {
                tempStr = "&status=" + $("#status").val() + "&roleType=2&riskLevel=" + $("#riskLevel").val() 
                        + "&importantLevel=" + $("#importantLevel").val();
            } else if(condParam == "${ctp:i18n('taskmanage.inspector')}") {
                tempStr = "&status=" + $("#status").val() + "&roleType=3&riskLevel=" + $("#riskLevel").val() 
                        + "&importantLevel=" + $("#importantLevel").val();
            }
        } else if($("#statisticsType").val() == "importantLevel") {
            if(condParam == "${ctp:i18n('common.importance.putong')}") {
                tempStr = "&status=" + $("#status").val() + "&roleType=" + $("#roleType").val() 
                        +"&riskLevel=" + $("#riskLevel").val() + "&importantLevel=1";
            } else if(condParam == "${ctp:i18n('common.importance.zhongyao')}") {
                tempStr = "&status=" + $("#status").val() + "&roleType=" + $("#roleType").val() 
                        +"&riskLevel=" + $("#riskLevel").val() + "&importantLevel=2";
            } else if(condParam == "${ctp:i18n('common.importance.feichangzhongyao')}") {
                tempStr = "&status=" + $("#status").val() + "&roleType=" + $("#roleType").val() 
                        +"&riskLevel=" + $("#riskLevel").val() + "&importantLevel=3";
            }
        }
        return tempStr;
    }
    
    /**
     * 查询统计结果
     * 
     */
    function searchStatistics() {
        var callerResponder = new CallerResponder();
        var taskAjax = new taskAjaxManager();
        var frmobj = $("#statistics_frm").formobj();
        var startTime = new Date(parseDate(frmobj.startTime));
        var endTime = new Date(parseDate(frmobj.endTime));
        if (startTime > endTime) {
            $.alert('开始时间不能大于结束时间!');
            return;
        }
        callerResponder.success = function(retObj) {
            if (retObj != null && retObj.length > 0) {
                var tempStr = retObj.split("*");
                $("#index_names").val(tempStr[0]);
                $("#data_list").val(tempStr[1]);
                $('#chart_radio1').attr("checked", "checked");
                $("#statistics_table").addClass("hidden");
                $("#statistics_chart").removeClass("hidden");
                initStatisticsPic();
            }
        };
        callerResponder.sendHandler = function(b, d, c) {
        }
        //表单局部提交
        taskAjax.searchStatistics(frmobj, callerResponder);
    }
    
    /**
     * 验证自定义条件是否为空
     * @frmobj 条件参数
     * @return 是否为空
     */
    function checkCondIsNull(frmobj){
        var userId = frmobj.userId;
        var roleType = frmobj.roleType;
        var status = frmobj.status;
        var riskLevel = frmobj.riskLevel;
        var importantLevel = frmobj.importantLevel;
        var bool = false;
        var statisticsType = frmobj.statisticsType;
        if(statisticsType == "status") {
            if(userId.length > 0 && roleType.length > 0 && riskLevel.length > 0 && importantLevel.length > 0) {
                bool = true;
            }
        } else if(statisticsType == "riskLevel") {
            if(userId.length > 0 && roleType.length > 0 && status.length > 0 && importantLevel.length > 0) {
                bool = true;
            }
        } else if(statisticsType == "roleType") {
            if(userId.length > 0 && status.length > 0 && riskLevel.length > 0 && importantLevel.length > 0) {
                bool = true;
            }
        } else if(statisticsType == "importantLevel") {
            if(userId.length > 0 && roleType.length > 0 && status.length > 0 && riskLevel.length > 0) {
                bool = true;
            }
        }
        return bool;
    }
    
    /**
     * 保存我的统计
     * 
     */
    function saveStatistics(){
      var frmobj = $("#statistics_frm").formobj();
      var urlPath = _ctxPath + '/taskmanage/taskstatistics.do?method=saveStatisticsPage';
      if($("#statistics_id").val().length > 0){
          urlPath = _ctxPath + '/taskmanage/taskstatistics.do?method=saveStatisticsPage&statisticsId=' + $("#statistics_id").val();
      }
      if(!checkCondIsNull(frmobj)) {
          $.alert("自定义条件中不允许有空条件！");
          return;
      }
      var  dialog = $.dialog({
            id : 'save_taskStatistics',
            url : urlPath,
            width : 350,
            height : 120,
            title : '我的统计',
            targetWindow : getCtpTop(),
            transParams : {
                frmobj : frmobj,
                refresh : refreshPage
            },
            buttons : [ {
                text : "确定",isEmphasize:true,
                handler : function() {
                    dialog.getReturnValue({'dialogObj' : dialog});
                }
            }, {
                text : "取消",
                handler : function() {
                    dialog.close();
                }
            } ]
        });
    }
    
    /**
     * 删除任务信息操作
     */
    function deleteTaskStatistics() {
        var taskAjax = new taskAjaxManager();
        var idValues = $("#statistics_id").val();
        var ret = "该操作不能恢复，是否进行删除统计的操作？";
        var confirm = $.confirm({
            'msg' : ret,
            ok_fn : function() {
                taskAjax.deleteTaskStatistics(idValues, {
                    success : function(bool) {
                        if (bool == true || bool == "true") {
                            refreshPage();
                        }
                    },
                    error : function(request, settings, e) {
                        $.error("删除任务失败，服务器报错！");
                    }
                });
            },
            cancel_fn : function() {
            }
        });
    }

    /**
     * 导出excel
     */
    function exportToExcel() {
        var url = _ctxPath + "/taskmanage/taskstatistics.do?method=exportToExcel&sid=${param.sid}";
        var exportExcelIframe = $("#exportExcelIframe");
        exportExcelIframe.attr("src", url);
    }
    
    /**
     * 弹出选择人员
     */
    function showPerson() {
        var memberCond = "";
        if($("#select_user option:eq(0)").val() != 0) {
            memberCond = "&memberId=" + $("#select_user option:eq(0)").val();
        }
        var dialog = $.dialog({
            id: 'url',
            url: _ctxPath + '/taskmanage/taskstatistics.do?method=listSelectMember' + memberCond,
            width: 400,
            height:300,
            title: '选择人员',
            buttons: [{
                text: "确定",isEmphasize:true,
                handler: function () {
                    var retId = dialog.getReturnValue();
                    initSelectUser(retId);
                    $("#userId").val(retId);
                    dialog.close();
                }
            }, {
                text: "取消",
                handler: function () {
                    dialog.close();
                }
            }]
        });
        $("#select_user").get(0).selectedIndex=0;
    }
    
    /**
     * 刷新页面
     */
    function refreshPage() {
        parent.location.reload();
    }
</script>