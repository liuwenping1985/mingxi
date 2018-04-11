<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
<script type="text/javascript">
var parWin = window.dialogArguments;
var resultExpress = "${result}";
function OK(){
	if($("#dateField").val()==""){$.alert("${ctp:i18n('form.trigger.triggerSet.datetime.msg')}");return "error";}
	if(!$("#myform").validate({errorAlert:true})){
		//$.alert("${ctp:i18n('form.trigger.triggerSet.datetime.biggerthan0')}");
		return "error";
	}
    
    if($("#dateField").val() == "[SpecifiedTime]" && !$("#SpecifiedTimeCal").val()){
        $.alert('${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.specifiedTime.label")}' + $.i18n('validate.notNull.js'));
        return "error";
    }
    
	var retValue = "";
	var dateType = $("#dateType").val();
	if($("input:checked").val()=="once"){
		retValue = $("input:checked").val() + "|";
	}else{
		retValue = $("#periodicalStyle").val()+"|";
	}
	retValue = retValue +dateType +"("+$("#dateField").val()+$("#SpecifiedTimeCal").val()+","+parseInt($("#operationType").val()+$("#days").val())+")";
	retValue = retValue + "|" +$("#datetimeHour").val()+":"+$("#datetimeMinute").val()+"|";
	return retValue;
}

$(document).ready(function(){
    $(function () {
        $("select").attr("disabled", "disabled");
        $("select").attr("readonly", "readonly");
        $("input").attr("disabled", "disabled");
        $("input").attr("readonly", "readonly");
    });

    var timequartz = resultExpress;
	timequartz = timequartz.replace(/ /g,"");

    //once|calcDateByWorkDay({表单字段},0)|9:00
    //month|calcDateByWorkDay([PerMonthEnd],0)|9:00
    //season|calcDateByWorkDay([PerSeasonEnd],-2)|11:00
    //once|calcDate([SpecifiedTime]2013-03-22,0)|11:00   //calcDate无所谓
    //week|calcDate({创建时间},-5)|11:00

	if(timequartz.trim() != ""){
		var times = timequartz.split("|");
		if(times[0]=="once"){
			$("#cycleOnetime").prop("checked",true);
		}else{
			$("#cyclePeriodical").prop("checked",true);
			$("#periodicalStyle").val(times[0]);
		}
		//var ts = times[1].split(" and ");
		var te = new RegExp("calcDateByWorkDay|calcDate","g");
		$("#dateType").val(times[1].match(te));

		te = new RegExp("\[SpecifiedTime\]","g");
        var PerMatchStr = times[1].match(te); 
        
        if(times[1].indexOf("SpecifiedTime") > 0){
            $("#dateField").val("[SpecifiedTime]");

            var SpecifiedTimeIndex = times[1].indexOf("SpecifiedTime");
            var SpecifiedTimeStr = times[1].substring(SpecifiedTimeIndex + 13, SpecifiedTimeIndex + 13 + 10);

            $("#SpecifiedTimeCal").val(SpecifiedTimeStr);
        }
        else{
    		te = new RegExp("PerMonthBegin|PerMonthEnd|PerSeasonBegin|PerSeasonEnd|PerHalfYearBegin|PerHalfYear|PerYearBegin|PerYearEnd","g");
            if(times[1].match(te)){
        		$("#dateField").val("[" + times[1].match(te) + "]");
            }
            else{
                te = new RegExp("\{.*\}","g");
        		$("#dateField").val(times[1].match(te));
            }
        }
        //BUG_普通_V5_V5.1sp1_安徽国元融资租赁有限公司_触发日期设置的是表单控件+X，确定之后重新打开加号变成减号_20151130014427
        te = new RegExp("(\\+|\\-)[0-9]+\\)","g");
        var op = new RegExp("\\+|\\-","g");
        var num = times[1].match(te) || "";
        var opera = "+";
        if (num && num[0]){
            opera = num[0].match(op);
        }
        $("#operationType").val(opera);
		te = new RegExp("[0-9]+\\)","g");
		var ditte = new RegExp("[0-9]+","g");
		var day = times[1].match(te);
		if(day!=null&&day[0]!=null){
			$("#days").val(day[0].match(ditte));
		}
        
		var timehourAndmin = times[2].match(ditte);
		$("#datetimeHour").val(timehourAndmin[0]);
        $("#datetimeMinute").val(timehourAndmin[1]);

        specifiedTime(true);
	}
    else{
	  timequartz = "${timeQuartz}";
	  var timehourAndmin = timequartz.split(":");
		$("#datetimeHour").val(timehourAndmin[0]);
        $("#datetimeMinute").val(timehourAndmin[1]);
	}
});

function reset() {
    $("#cyclePeriodical").attr("disabled",false);
    $("#cycleOnetime").attr("disabled", false);
    $("#periodicalStyle").attr("disabled", false);
    $("#days").attr("disabled", false);
    $("#operationType").attr("disabled", false);
    $("#datetimeHour").attr("disabled", false);
    $("#datetimeMinute").attr("disabled", false);
    $("#dateType").attr("disabled", false);
    $("#datetimeHour").attr("disabled", false);
    $("#datetimeMinute").attr("disabled", false);
    $("#SpecifiedTimeCalDiv").addClass("hidden");
    $("#SpecifiedTimeCal").val("");
}

function specifiedTime(isInit){
    var dateFieldStr = $(":selected","#dateField");

    if(!isInit){
        reset();
    }

    var fun = dateFieldStr.attr("func");
    if (fun) {
        eval(fun+"()");
    }
}

function func4SpecifiedTime(){
    $("#SpecifiedTimeCalDiv").removeClass("hidden");
    disableHandsDay();
}

function func4PerMonthEnd(){
    func4PerEnd("month");
}

function func4PerSeasonEnd(){
    func4PerEnd("season");
}

function func4PerHalfYear(){
    func4PerEnd("halfyear");
}

function func4PerYearEnd(){
    func4PerEnd("year");
}

function func4PerEnd(val){
    $("#periodicalStyle").val(val);
    $("#periodicalStyle").attr("disabled",true);
    $("#cycleOnetime").attr("disabled",true);
    $("#cyclePeriodical").prop("checked",true);

    disableHandsDay();
}

function func4PerMonthBegin(){
    func4PerBegin("month");
}

function func4PerSeasonBegin(){
    func4PerBegin("season");
}

function func4PerHalfYearBegin(){
    func4PerBegin("halfyear");
}

function func4PerYearBegin(){
    func4PerBegin("year");
}

function func4PerBegin(val){
    $("#periodicalStyle").val(val);
    $("#periodicalStyle").attr("disabled",true);
    $("#cycleOnetime").attr("disabled",true);
    $("#cyclePeriodical").prop("checked",true);

    disableHandsDay();
}

    function disableHandsDay(){
        $("#operationType").attr("disabled",true);
        $("#dateType").attr("disabled",true);
        $("#days").val("0");
        $("#days").attr("disabled", true);
    }
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<form id="myform" name="myform">
<div style="height: 100%;width: 100%;font-size: 12px;overflow: hidden;padding-top: 20px">
    <div style="margin: 5px;margin-left: 30px;line-height: 25px;float: none;display: inline-block;">
        <div style="float: left;width: 65px;">${ctp:i18n('form.trigger.triggerSet.date.label')}：</div>
        <div style="float: left;width: 130px;left: 65px;">
            <select id="dateField" name="dateField" style="width:120px" onchange="specifiedTime()">
                <option value="{创建时间}" title="${ctp:i18n('form.system.createdate.field.label')}">${ctp:i18n('form.system.createdate.field.label')}</option>
                <c:forEach var="field" items="${formBean.allFieldBeans }" >
                <c:if test='${(field.fieldType eq "TIMESTAMP" || field.fieldType eq "DATETIME")}'>
                <option value="{${field.display }}">${field.display } (${ctp:i18n(field.masterField ? "form.base.mastertable.label" : "formoper.dupform.label")})</option>
                </c:if>
                </c:forEach>
                <option value="[PerMonthBegin]" func="func4PerMonthBegin">[${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.monthBegin.label")}]</option>
                <option value="[PerMonthEnd]" func="func4PerMonthEnd">[${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.monthEnd.label")}]</option>
                <option value="[PerSeasonBegin]" func="func4PerSeasonBegin">[${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.seasonBegin.label")}]</option>
                <option value="[PerSeasonEnd]" func="func4PerSeasonEnd">[${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.seasonEnd.label")}]</option>
                <option value="[PerHalfYearBegin]" func="func4PerHalfYearBegin">[${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.halfYearBegin.label")}]</option>
                <option value="[PerHalfYear]" func="func4PerHalfYear">[${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.halfYearEnd.label")}]</option>
                <option value="[PerYearBegin]" func="func4PerYearBegin">[${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.yearBegin.label")}]</option>
                <option value="[PerYearEnd]" func="func4PerYearEnd">[${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.yearEnd.label")}]</option>
                <option value="[SpecifiedTime]" func="func4SpecifiedTime">&lt;${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.specifiedTime.label")}&gt;</option>
            </select>
        </div>
        <div style="float: left;width: 40px;left: 65px;">
            <select id="operationType" name="operationType"  style="width:100%">
                 <option value="+" selected="selected">+</option>
                 <option value="-">-</option>
             </select>
        </div>
        <div style="float: left;width: 60px;margin-left: 10px">
        	<div style="width: 60px;">
            <input id="days" name="day" style="width: 60px;" value="0" class="validate" validate="isInteger:'true',min:'0',max:'1825',name:'${ctp:i18n('form.trigger.triggerSet.datetime.biggerthan0') }'">
        	</div>
        </div>
        <div style="float: left;width: 80px;margin-left: 10px">
            <select id="dateType" name="dateType">
                <option value="calcDateByWorkDay">${ctp:i18n('form.trigger.triggerSet.dateType.workday.label')}</option>
                <option value="calcDate">${ctp:i18n('form.trigger.triggerSet.dateType.everyday.label')}</option>
            </select>
        </div>
    </div>
    <div style="margin: 5px;margin-left: 30px;margin-top:5px;line-height: 30px;" class="hidden" id="SpecifiedTimeCalDiv">
        <span>${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.specifiedTime.label")}：</span>
        <input id="SpecifiedTimeCal" type="text" style="width: 137px;" class="comp"  validate="notNull:true,name:'${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.specifiedTime.label')}'" >
    </div>
    <div style="margin: 5px;margin-left: 30px;margin-top:10px;line-height: 30px;">
        <span>${ctp:i18n('form.trigger.triggerSet.datetime.label')}：</span>
        <span>
            <select id="datetimeHour" name="datetimeHour">
                    <option value="0">00</option>
                    <option value="1">01</option>
                    <option value="2">02</option>
                    <option value="3">03</option>
                    <option value="4">04</option>
                    <option value="5">05</option>
                    <option value="6">06</option>
                    <option value="7">07</option>
                    <option value="8">08</option>
                    <option value="9">09</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                    <option value="13">13</option>
                    <option value="14">14</option>
                    <option value="15">15</option>
                    <option value="16">16</option>
                    <option value="17">17</option>
                    <option value="18">18</option>
                    <option value="19">19</option>
                    <option value="20">20</option>
                    <option value="21">21</option>
                    <option value="22">22</option>
                    <option value="23">23</option>
                </select>
        </span>
        <span>
         &nbsp;:&nbsp;
        </span>
        <span>
            <select id="datetimeMinute" name="datetimeMinute">
                    <option value="00">00</option>
                    <option value="05">05</option>
                    <option value="10">10</option>
                    <option value="15">15</option>
                    <option value="20">20</option>
                    <option value="25">25</option>
                    <option value="30">30</option>
                    <option value="35">35</option>
                    <option value="40">40</option>
                    <option value="45">45</option>
                    <option value="50">50</option>
                    <option value="55">55</option>
                </select>
        </span>
    </div>
    <div class="common_radio_box clearfix" style="margin: 5px;margin-left: 30px;margin-top:10px;line-height: 30px;">
        <span>${ctp:i18n('form.trigger.automatic.type.label')}：</span>
        <label for="cycleOnetime"><input type="radio" name="cycleType" id="cycleOnetime" value="once" checked="checked">${ctp:i18n('form.trigger.triggerSet.cycleOnetime.label')}</label>
        <label for="cyclePeriodical" style=" margin-left: 40px;"><input type="radio" name="cycleType" id="cyclePeriodical" value="cycle" >${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.label')}</label>
        <select id="periodicalStyle" name="periodicalStyle">
            <option value="day">${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.day.label')}</option>
            <option value="week">${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.week.label')}</option>
            <option value="month">${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.month.label')}</option>
            <option value="season">${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.season.label')}</option>
            <option value="halfyear">${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.halfYear.label')}</option>
            <option value="year">${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.year.label')}</option>
        </select>
    </div>
</div>
</form>
</body>
</html>