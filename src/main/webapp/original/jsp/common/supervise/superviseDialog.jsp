<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <!-- 督办 -->
    <title>${ctp:i18n('collaboration.common.flag.showSupervise')}</title>
    <script>
    $(document).ready(function(){
    	//判断是否流程结束，流程结束时不能修改
        if("${param.finished}" == "true"){
        	$('#description').disable();
            $('#awakeDate').disable();
        }
        //督办日志绑定点击事件
        $('#superviseLog').click(function(){
            var superviseDialog = "";
            superviseDialog = $.dialog({
                targetWindow:getCtpTop(),
                title: "${ctp:i18n('common.life.log.label')}",  //催办日志
                url: _ctxPath+'/detaillog/detaillog.do?method=showSuperviseLog&summaryId=${param.summaryId}',
                width: 800,
                height: 450,
                buttons: [{
                    text: "${ctp:i18n('common.button.close.label')}",  //关闭
                    handler: function () {
                        superviseDialog.close();
                    }
                }]
            });
        });
     });
    
    function getTime(){
        var sDate = $.trim($('#awakeDate').val());
        //获取催办日志，用来比较
        var o_awakeDate = "${ffsuperviseDialog.awakeDate}";
        //获得当前系统时间
        var nowDate = getCurrentTime();
        if(compareDate(sDate,nowDate)){
            var confirm = $.confirm({
                'msg': '${ctp:i18n("collaboration.common.supervise.thisTimeXYouset")}', //您设置的督办日期小于当前日期,是否继续?
                ok_fn: function () {
                    $('#awakeDate').val(sDate);
                },
                cancel_fn:function(){
                    $('#awakeDate').val(o_awakeDate);
                }
            });
        }
    }
    //比较日期大小
    function compareDate(start,end){
        var startDates = start.substring(0,10).split('-');
        var startYear = startDates[0];
        var startMonth = startDates[1];
        var startDay = startDates[2];
        var startTime = start.substring(10, 19).split(':');
        var startHour = startTime[0];
        var startMin = startTime[1];
        var endDates = end.substring(0,10).split('-');
        var endYear = endDates[0];
        var endMonth = endDates[1];
        var endDay = endDates[2];
        var endTime = end.substring(10, 19).split(':');
        var endHour = endTime[0];
        var endMin = endTime[1];
        var beginTime = new Date(startYear + "/" + startMonth + "/" + startDay + " " + startHour + ":" + startMin);
        var endTime = new Date(endYear + "/" + endMonth + "/" + endDay + " " + endHour + ":" + endMin);
        return beginTime < endTime;
    }
     
    //获得当前日期时间
    function getCurrentTime(){
        var date = new Date();
        var year = date.getFullYear();
        var month = date.getMonth()+1; 
        if(month < 10) {
            month = '0'+ month;
        }
        var day = date.getDate();
        if(day < 10) {
            day = '0'+ day;
        }
        var hour = date.getHours();
        if(hour < 10) {
            hour = '0'+ hour;
        }
        var time = year+"-"+month+"-"+day+" "+hour+":"+"00";
        return time;
    }
    //定义回调函数,以json字符串形式返回
    function OK(){
        //表单验证
        var description = $.trim($('#description').val());
        if(description!=""){
            var len = description.length;
            if(len>200){
                //督办主题长度不能超过200字,当前共有{0}个字!
                $.alert("${ctp:i18n_1('collaboration.common.supervise.supervisionMaxLang200','"+len+"')}");
                return false;
            }
        }
        //时间校验
        var awakeDate = $.trim($('#awakeDate').val());
        if(awakeDate == ""){
            //请选择督办时间!
            $.alert("${ctp:i18n('collaboration.common.supervise.selectSupervisionDate')}");
            return false;
        }
        var superviseId = $.trim($('#superviseId').val());
        var returnValue = "{\"description\":\""+encodeURIComponent(description)+"\",\"awakeDate\":\""+awakeDate+"\",\"superviseId\":\""+superviseId+"\"}";
        return returnValue;
    }
    </script>
</head>
<body scroll="no" style="overflow: hidden">

<form id="superviseDialog" method="post">
    <input type="hidden" name="superviseId" id="superviseId">
    
    <table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td height="10"></td>
        </tr>
        <tr>
            <td valign="top" class="padding_lr_5">
                <table border="0" cellspacing="0" cellpadding="0" class="font_size12">
                    <tr>
                        <!-- 督办人员 -->
                        <td width="17%" height="28" nowrap="nowrap" align="right" class="padding_r_5 padding_t_5">${ctp:i18n('collaboration.common.supervise.supervisionOfStaff')}:</td>
                        <td width="83%" class="padding_t_5">
                            <div class=common_txtbox_wrap><input type="text" id="supervisors"  name="supervisors" readonly="true"></div>
                        </td>
                    </tr>
                    <tr>
                        <!-- 督办期限 -->
                        <td height="28" align="right" class="padding_r_5 padding_t_5">${ctp:i18n("supervise.col.deadline")}:</td>
                        <td class="padding_t_5">
                            <div>
                                <input name="awakeDate" id="awakeDate" class="comp" readonly="readonly" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,onUpdate:getTime">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <!-- 催办日志 -->
                        <td height="28" align="right" class="padding_r_5 padding_t_5">${ctp:i18n("common.life.log.label")}:</td>
                        <td class="padding_t_5">
                            <span id="countNum"></span>&nbsp;&nbsp;
                            <a class="ico16 view_log_16" title="${ctp:i18n('common.life.log.label')}" id="superviseLog"></a>
                        </td>
                    </tr>
                    <tr>
                        <!-- 督办主题 -->
                        <td valign="top" height="28" align="right" class="padding_r_5 padding_t_5"> ${ctp:i18n('supervise.col.title')}:</td>
                        <td class="padding_t_5">
                            <div class="common_txtbox  clearfix">
                               <TEXTAREA class="padding_5 w100b " name="title" id="title" style="width: 360px;height:80px;" disabled></TEXTAREA>
                            </div>
                        </td>
                    </tr>  
                    <tr>
                        <!-- 督办摘要 -->
                         <td valign="top" height="28" align="right" class="padding_r_5 padding_t_5">${ctp:i18n('supervise.col.remark')}:</td>
                         <td class="padding_t_5">
                             <div class="common_txtbox  clearfix"><TEXTAREA class="padding_5 w100b " name="description" id="description"  style="width: 360px;height:100px;">${description}</TEXTAREA></div>
                         </td>
                    </tr>  
                </table>
            </td>
        </tr>
    </table>
</form>
</body>
</html>