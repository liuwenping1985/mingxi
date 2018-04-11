<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>${ctp:i18n('taskmanage.advance.label') }</title>
    <style type="text/css">
        .row{height: 26px;margin-bottom: 5px;}
        .row-left{float:left; width: 24%;padding-right: 5px;}
        .row-right{width: 74%; float:left;}
        .span-text{float: right;text-align: center;line-height: 26px;}
    </style>
</head>
<body class="h100b over_hidden" style="background:#fafafa;">
    <%--隐藏时间域 --%>
    <input id="firstDayInWeek" type="hidden" value="${ctp:formatDate(firstDayInWeek) }">
    <input id="lastDayInWeek" type="hidden" value="${ctp:formatDate(lastDayInWeek) }">
    <input id="firstDayInMonth" type="hidden" value="${ctp:formatDate(firstDayInMonth) }">
    <input id="lastDayInMonth" type="hidden" value="${ctp:formatDate(lastDayInMonth) }">
    <input id="firstDayInSeason" type="hidden" value="${ctp:formatDate(firstDayInSeason) }">
    <input id="lastDayInSeason" type="hidden" value="${ctp:formatDate(lastDayInSeason) }">
    <div class="form_area" id="combinedQueryDIV">
        <div class="clearfix row">
            <div class="row-left">
                <span class="span-text">${ctp:i18n('taskmanage.search.time.paragraph')}：</span>
            </div>
            <div class="row-right" style="line-height: 26px;">
                <label for="radio1" class="margin_r_10 hand"><input type="radio" value="1" id="radio1" name="option" class="radio_com">${ctp:i18n("taskmanage.current.week") }</label>
                <label for="radio2" class="margin_r_10 hand"><input type="radio" value="2" id="radio2" name="option" class="radio_com">${ctp:i18n("taskmanage.current.month") }</label>
                <label for="radio3" class="margin_r_10 hand"><input type="radio" value="3" id="radio3" name="option" class="radio_com">${ctp:i18n("taskmanage.current.season") }</label>
            </div>
        </div>
        <div class="clearfix row">
            <div class="row-left" style="height: 26px;"></div>
            <div class="row-right">
                <div class="common_radio_box clearfix">
                    <input id="startDate" name="startDate" class="comp" style="width: 113px;" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]"/>
                    <span class="padding_lr_5">-</span>
                    <input id="endDate" name="endDate" class="comp" style="width: 113px;" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]"/>
                </div>
            </div>
        </div>
        <div class="clearfix row">
            <div class="row-left">
                <span class="span-text">${ctp:i18n('taskmanage.roletype.manager') }：</span>
            </div>
            <div class="row-right">
                <input style="width:251px;color:#333;" id="manager" type="text" name="manager" />
            </div>
        </div>
        <div class="clearfix row">
            <div class="row-left">
                <span class="span-text">${ctp:i18n('taskmanage.roletype.participator') }：</span>
            </div>
            <div class="row-right">
                <input style="width:251px;color:#333;" id="participator" type="text" name="participator" />
            </div>
        </div>
        <div class="clearfix row">
            <div class="row-left">
                <span class="span-text">${ctp:i18n('taskmanage.status') }：</span>
            </div>
            <div class="row-right">
                <div class="common_selectbox_wrap">
                    <select id="status" name="status" class="codecfg" style="width: 251px;" codecfg="codeType:'java',codeId:'com.seeyon.apps.taskmanage.TaskConstants$TaskStatusCondition', defaultValue:'-1'"></select>
                </div>
            </div>
        </div>
        <div class="clearfix row">
            <div class="row-left">
                <span class="span-text">${ctp:i18n('common.importance.label') }：</span>
            </div>
            <div class="row-right">
                <div class="common_selectbox_wrap">
                    <select id="importantLevel" name="importantLevel" style="width: 251px;">
                        <option value="-1">${ctp:i18n('taskmanage.qxz.label') }</option>
                        <option value="1">${ctp:i18n("common.importance.putong")}</option>
                        <option value="2">${ctp:i18n("taskmanage.detail.important.label")}</option>
                        <option value="3">${ctp:i18n("taskmanage.detail.muchimportant.label")}</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="clearfix row">
            <div class="row-left">
                <span class="span-text">${ctp:i18n('taskmanage.risk') }：</span>
            </div>
            <div class="row-right">
                <div class="common_selectbox_wrap">
                    <select id="riskLevel" name="riskLevel" style="width: 251px;">
                        <option value="-1">${ctp:i18n('taskmanage.qxz.label') }</option>
                        <option value="0">${ctp:i18n("taskmanage.risk.no")}</option>
                        <option value="1">${ctp:i18n("taskmanage.risk.low")}</option>
                        <option value="2">${ctp:i18n("taskmanage.risk.normal")}</option>
                        <option value="3">${ctp:i18n("taskmanage.risk.high")}</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="clearfix row">
            <div class="row-left">
                <span class="span-text">${ctp:i18n('taskmanage.milestone.label') }：</span>
            </div>
            <div class="row-right">
                <div class="common_selectbox_wrap">
                    <select id="milestone" name="milestone" style="width: 251px;">
                        <option value="-1">${ctp:i18n('taskmanage.qxz.label') }</option>
                        <option value="1">${ctp:i18n("taskmanage.detail.yes.label")}</option>
                        <option value="0">${ctp:i18n("taskmanage.detail.no.label")}</option>
                    </select>
                </div>
            </div>
        </div>
    </div>
</body>
<script type="text/javascript">
$(document).ready(function(){
    var formData = window.parentDialogObj["openCombineQueryPage"].getTransParams();
    if (!$.isEmptyObject(formData)) {
    	//回填内容
	    formData.startDate &&  $("#startDate").val(formData.startDate);
	    formData.endDate &&  $("#endDate").val(formData.endDate);
	    formData.option && $("#radio" + formData.option).prop("checked", true);
	    formData.manager && $("#manager").val(formData.manager);
	    formData.participator && $("#participator").val(formData.participator);
	    formData.status && $("#status").val(formData.status);
	    formData.importantLevel && $("#importantLevel").val(formData.importantLevel);
	    typeof formData.riskLevel !== "undefined" && $("#riskLevel").val(formData.riskLevel);
	    typeof formData.milestone !== "undefined" && $("#milestone").val(formData.milestone);
    }
    //开始时间&结束时间
    $("#startDate, #endDate").on("change", function(){
    	var s = $("#startDate").val(), e = $("#endDate").val();
    	if (s && e) {
    		if (parseDate(s) > parseDate(e)) {
    			$.alert($.i18n('taskmanage.alert.planTime.start_time_before_end_time'));
    			$(this).val("");
    			return;
    		}
    	}
    });
    //单选按钮: 本周，本月，本季度
    $(":radio").on("click", function(){
    	var val = this.value, $s = $("#startDate"), $e = $("#endDate");
    	if (val == "1") {//本周
    		$s.val($("#firstDayInWeek").val());
    		$e.val($("#lastDayInWeek").val());
    	} else if (val == "2") {//本月 
    		$s.val($("#firstDayInMonth").val());
            $e.val($("#lastDayInMonth").val());
    	} else if (val == "3") {//本季度
    		$s.val($("#firstDayInSeason").val());
            $e.val($("#lastDayInSeason").val());
    	}
    });
});

function OK() {
	var formData = {};
	//时间段
	formData.startDate = $("#startDate").val();
	formData.endDate = $("#endDate").val();
	formData.option = $("input[type='radio']:checked").val();
	//负责人
	formData.manager = $("#manager").val();
	//参与人
	formData.participator = $("#participator").val();
	//状态
	formData.status = $("#status").val();
	//重要程度
	var importantLevel = $("#importantLevel").val();
	if (importantLevel != "-1") {
		formData.importantLevel = importantLevel;
	}
	//风险
	var riskLevel = $("#riskLevel").val();
	if (riskLevel != "-1") {
		formData.riskLevel = riskLevel;
	}
	//里程碑
	var milestone = $("#milestone").val();
	if (milestone != "-1") {
		formData.milestone = milestone;
	}
	return formData;
}

/*字符串转换给时间*/
function parseDate(str) {
	return new Date(str.replace(/-/g, "/"));
}
</script>
</html>