<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<script type="text/javascript">
   

    function onPointClick(e) {
        var param = e.data.Name;
        viewTaskStatistics(param);
    }

    /**
     * 查看任务信息
     * @param condParam 条件参数
     */
    function viewTaskStatistics(condParam) {
        var	startTime = "${param.startTime}";
        var endTime = "${param.endTime}";

        var list = new Array();
        list["${ctp:i18n('common.importance.putong')}"]="importantLevel-1";
        list["${ctp:i18n('common.importance.zhongyao')}"]="importantLevel-2";
        list["${ctp:i18n('common.importance.feichangzhongyao')}"]="importantLevel-3";
        
        list["${ctp:i18n('taskmanage.risk.no')}"]="riskLevel-0";
        list["${ctp:i18n('taskmanage.risk.low')}"]="riskLevel-1";
        list["${ctp:i18n('taskmanage.risk.normal')}"]="riskLevel-2";
        list["${ctp:i18n('taskmanage.risk.high')}"]="riskLevel-3";
        
        list["${ctp:i18n('common.creater.label')}"]="roleType-0";
        list["${ctp:i18n('taskmanage.manager')}"]="roleType-1";
        list["${ctp:i18n('taskmanage.participator')}"]="roleType-2";
        list["${ctp:i18n('taskmanage.inspector')}"]="roleType-3";
        
        list["${ctp:i18n('taskmanage.status.notstarted')}"]="status-1";
        list["${ctp:i18n('taskmanage.status.marching')}"]="status-2";
        list["${ctp:i18n('taskmanage.status.finished')}"]="status-3";
        list["${ctp:i18n('taskmanage.status.delayed')}"]="status-4";
        list["${ctp:i18n('taskmanage.status.canceled')}"]="status-5";


           
        var title = "任务统计穿透信息查看";
        var url = _ctxPath + '/taskmanage/taskinfo.do?method=listTasks4Portal&listType=Statistic&startTime=' + startTime + "&endTime=" + endTime 
						+"&singleBoardId=${param.singleBoardId}&selected="+list[condParam];
        
        var dialog = $.dialog({
            id : 'view',
            url : url,
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
    
   
</script>