<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
<script type="text/javascript">
var parWin = window.dialogArguments;
function OK(){
	//add by chencm 2016-03-29
	//获取触发时间方式
	var selectedValue = $("input[name='refreshOperate']:checked").val();
	//若为选择触发日期则需要进行验证：若触发日期为表单字段，则需要进行验证
    if(selectedValue == "2"){
        //首先判断是否为表单数据域
        var result = checkedIsField();
        if(!result){
        	$.alert("${ctp:i18n('form.trigger.datetimeset.checkwarning')}");return "error";
        }
    }
	//end add by chencm
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
	//edit by chencm 2016-05-19 原因页面有且只有一个radio为checked，现情况不一样，有可能为多个，所以需要修改
	var cycleType = $("input[name='cycleType']:checked").val();
	//if($("input:checked").val()=="once"){
// 		retValue = $("input:checked").val() + "|";
	if(cycleType == "once"){
		retValue = cycleType + "|";
	}else{
		retValue = $("#periodicalStyle").val()+"|";
	}
	retValue = retValue +dateType +"("+$("#dateField").val()+$("#SpecifiedTimeCal").val()+","+parseInt($("#operationType").val()+$("#days").val())+")";
	//edit by chencm 2016-03-29
	var selectedValue = $("input[name='refreshOperate']:checked").val();
	if(selectedValue == "2"){
		retValue = retValue + "|"  +"time("+$("#dateField").val()+")"+"|";
	}else{
		retValue = retValue + "|" +$("#datetimeHour").val()+":"+$("#datetimeMinute").val()+"|";
	}
// 	retValue = retValue +dateType +"("+$("#dateField").val()+$("#SpecifiedTimeCal").val()+","+parseInt($("#operationType").val()+$("#days").val())+")";
// 	retValue = retValue + "|" +$("#datetimeHour").val()+":"+$("#datetimeMinute").val()+"|";
    //end edit by chencm
    $("#runConditionData",parWin[0].document).val($("#runConditionValue").val());
    $("#stopConditionData",parWin[0].document).val($("#stopConditionValue").val());
    if(!$("#cyclePeriodical").prop("checked")){
    	$("#runConditionData",parWin[0].document).val("");
        $("#stopConditionData",parWin[0].document).val("");
        $("#runConditionDataId",parWin[0].document).val("");
        $("#stopConditionDataId",parWin[0].document).val("");
    }
	return retValue;
}

$(document).ready(function(){
	var timequartz = $("#timeQuartz",parWin[0].document).val();
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
            var SpecifiedTimeStr = times[1].substring(SpecifiedTimeIndex + 14, SpecifiedTimeIndex + 14 + 10);

            $("#SpecifiedTimeCal").val(SpecifiedTimeStr);
        }
        else{
    		te = new RegExp("PerMonthEnd|PerSeasonEnd","g");
            if(times[1].match(te)){
        		$("#dateField").val("[" + times[1].match(te) + "]");
            }
            else{
                te = new RegExp("\{.*\}","g");
        		$("#dateField").val(times[1].match(te));
            }
        }
        

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
        //edit by chencm 2016-03-29
//         var timehourAndmin = times[2].match(ditte);
//         $("#datetimeHour").val(timehourAndmin[0]);
//         $("#datetimeMinute").val(timehourAndmin[1]);
        //检查时间是否包含time字符，若包含，则触发时间即为选定的表单字段的时间
        if(times[2].indexOf("time") >= 0){
        	$("#refreshOperate").attr("checked","checked");
        	$("#refreshDateTime").removeAttr("checked");
        	changeFieldValue();
        }else{
			var timehourAndmin = times[2].match(ditte);
			$("#datetimeHour").val(timehourAndmin[0]);
	        $("#datetimeMinute").val(timehourAndmin[1]);
        }
        //end edit by chencm

        specifiedTime(true);
	}
    else{
	  timequartz = "${timeQuartz}";
	  var timehourAndmin = timequartz.split(":");
		$("#datetimeHour").val(timehourAndmin[0]);
        $("#datetimeMinute").val(timehourAndmin[1]);
	}
    //add by chencm 2016-03-29
    $("input:radio[name='refreshOperate']").change(function(){
    	//选定的值
    	var selectedValue = $("input[name='refreshOperate']:checked").val();
    	if(selectedValue == "1"){
    		$("#selectedField").val("${ctp:i18n('form.trigger.datetimeset.selectwarning')}");
    		//日期radio控件不能修改
    		$("#datetimeHour").attr("disabled",false);
            $("#datetimeMinute").attr("disabled",false);
            //若选择为日期控件
            if($("#dateField").find("option:selected").val()=="[SpecifiedTime]"){
            	$("#SpecifiedTimeCalDiv").removeClass("hidden");
                disableHandsDay();
            }
    	}else{
    		//更改显示
    		changeFieldValue();
    		if($("#dateField").find("option:selected").val()=="[SpecifiedTime]"){
    			$("#SpecifiedTimeCalDiv").attr("class","hidden");
            }
    	}
    });
    //end add by chencm
    $("#runConditionValue").val($("#runConditionData",parWin[0].document).val());
    $("#stopConditionValue").val($("#stopConditionData",parWin[0].document).val());
    $("#cyclePeriodical").bind("click",function(){
    	resetRunAndStop();
    });
    $("#cycleOnetime").bind("click",function(){
    	resetRunAndStop();
    });
    resetRunAndStop();
});
/**
 *  add by chencm 2016-03-29
 *  当触发时间为选择表单中的字段时，显示text框，并让时间框不可更改
 */
function changeFieldValue(){
	//选择的触发日期，检查是否是表单中的字段
    var result = checkedIsField();
    //若不是，则弹出提示---还是保存的时候提示？
    if(!result){
        
    }else{
        var dateFieldName = $("#dateField").find("option:selected").text(); 
        $("#selectedField").val(dateFieldName.trim());
    }
    //日期radio控件不能修改
    $("#datetimeHour").attr("disabled",true);
    $("#datetimeMinute").attr("disabled",true);
}
/**
 * 检查触发时间是否为表单中的字段域
 * add by chencm 2016-03-29
 */
function checkedIsField(){
	//触发日期
	var dateFieldValue = $("#dateField").val();
	//判断是否等于[每月末]，[每季末]，指定日期；；若等于则不是表单中的字段
	if(dateFieldValue == "[PerMonthEnd]" || dateFieldValue == "[PerSeasonEnd]" || dateFieldValue == "[SpecifiedTime]"){
		return false;
	}
	return true;
}
//end by chencm
function specifiedTime(isInit){
    var dateFieldStr = $("#dateField").val();

    if(!isInit){
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
    
    if("[SpecifiedTime]" == dateFieldStr){
    	//add by chencm 2016-03-30
    	
        //$("#SpecifiedTimeCalDiv").removeClass("hidden");
        //disableHandsDay();
        var selectedValue = $("input[name='refreshOperate']:checked").val();
        if(selectedValue == "1"){//当触发时间的方式为指定时间，才显示，触发时间为表单字段时，则不显示
        	$("#SpecifiedTimeCalDiv").removeClass("hidden");
            disableHandsDay();
        }
        //end add by chencm
    }
    else if("[PerMonthEnd]" == dateFieldStr){
        $("#periodicalStyle").val("month");
        $("#periodicalStyle").attr("disabled",true);
        $("#cycleOnetime").attr("disabled",true);
        $("#cyclePeriodical").prop("checked",true);

        disableHandsDay();
    }
    else if("[PerSeasonEnd]" == dateFieldStr){
        $("#periodicalStyle").val("season");
        $("#periodicalStyle").attr("disabled",true);
        $("#cycleOnetime").attr("disabled",true);
        $("#cyclePeriodical").prop("checked",true);

        disableHandsDay();
    }
    //add by chencm
    //获取radio选定的值：1为设置日期，2为选择触发日期
    if(!isInit){
	    var selectedValue = $("input[name='refreshOperate']:checked").val();
	    if(selectedValue == "2"){
	    	//首先判断是否为表单数据域
	        var result = checkedIsField();
	    	if(result){
		    	//当为触发日期时：更改selectedField文本框的显示值
		    	var dateFieldName = $("#dateField").find("option:selected").text(); 
		        $("#selectedField").val(dateFieldName.trim());
	    	}else{
	    		$("#selectedField").val("${ctp:i18n('form.trigger.datetimeset.selectwarning')}");
	    	}
	    	//将时间控件置为disabled
	    	$("#datetimeHour").attr("disabled",true);
	        $("#datetimeMinute").attr("disabled",true);
	    }
    }
    //end by chencm
}

    function disableHandsDay(){
        $("#operationType").attr("disabled",true);
        $("#dateType").attr("disabled",true);
        $("#days").val("0");
        $("#days").attr("disabled", true);
    }
    
    function setRunCondition(obj) {
    	if($(obj).hasClass("common_button_disable")){return;}
    	var formulaArgs = getConditionArgs(setRunFormulaContent,'0','conditionType_all',
    		  $("#runConditionValue").val(),null,null);
    	//数据域设置
    	formulaArgs.title = "执行条件";
    	formulaArgs.allowSubFieldAloneUse = true;
    	formulaArgs.hasDifferSubField = true;
    	showFormula(formulaArgs);
    }
    function setRunFormulaContent(obj){
      	$("#runConditionValue").val(obj);
    }
    
    function setStopCondition(obj) {
    	if($(obj).hasClass("common_button_disable")){return;}
    	var formulaArgs = getConditionArgs(setStopFormulaContent,'0','conditionType_all',
    		  $("#stopConditionValue").val(),null,null);
    	//数据域设置
    	formulaArgs.title = "结束时间调度条件";
    	formulaArgs.allowSubFieldAloneUse = true;
    	formulaArgs.hasDifferSubField = true;
    	showFormula(formulaArgs);
    }
    function setStopFormulaContent(obj){
      	$("#stopConditionValue").val(obj);
    }
    
    function resetRunAndStop(){
    	if($("#cyclePeriodical").prop("checked")){
    		$("#runDiv").css("display","");
    		$("#stopDiv").css("display","");
    	}else{
    		$("#runDiv").css("display","none");
    		$("#stopDiv").css("display","none");
    	}
    }
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<form id="myform" name="myform">
<div style="height: 100%;width: 100%;font-size: 12px;overflow: hidden;padding-top: 20px">
    <div style="margin: 5px;margin-left: 20px;line-height: 25px;float: none;display: inline-block;">
        <div style="float: left;width: 65px;">${ctp:i18n('form.trigger.triggerSet.date.label')}：</div>
        <div style="float: left;width: 130px;left: 65px;">
            <select id="dateField" name="dateField" style="width:120px" onchange="specifiedTime()">
                <option value="{创建时间}" title="${ctp:i18n('form.system.createdate.field.label')}">${ctp:i18n('form.system.createdate.field.label')}</option>
                <c:forEach var="field" items="${formBean.allFieldBeans }" >
                <c:if test='${(field.fieldType eq "TIMESTAMP" || field.fieldType eq "DATETIME")}'>
                <option value="{${field.display }}">${field.display } (${ctp:i18n(field.masterField ? "form.base.mastertable.label" : "formoper.dupform.label")})</option>
                </c:if>
                </c:forEach>
                <option value="[PerMonthEnd]">[${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.monthEnd.label")}]</option>
                <option value="[PerSeasonEnd]">[${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.seasonEnd.label")}]</option>
                <option value="[SpecifiedTime]">&lt;${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.specifiedTime.label")}&gt;</option>
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
    <div style="margin: 5px;margin-left: 20px;line-height: 30px;" class="hidden" id="SpecifiedTimeCalDiv">
        ${ctp:i18n("form.trigger.triggerSet.cyclePeriodical.specifiedTime.label")}: <input id="SpecifiedTimeCal" type="text" class="comp  validate="notNull:true,name:'${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.specifiedTime.label')}'" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false">
    </div>
    <div style="margin: 5px;margin-left: 20px;line-height: 30px;">
        <span>${ctp:i18n('form.trigger.triggerSet.datetime.label')}：</span>
        <span>
            <!-- add by ccm 2016-03-29 -->
            <input type="radio" name="refreshOperate" id="refreshDateTime" checked value="1"/>
            <!-- end add by ccm 2016-03-29 -->
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
        <!-- add by chencm 2016-03-29 -->
        <span>
         &nbsp;&nbsp;
        </span>
        <input type="radio" name="refreshOperate" id="refreshOperate" value="2">&nbsp;&nbsp;<input type="text" value="${ctp:i18n('form.trigger.datetimeset.selectwarning')}" disabled id="selectedField"/>
        <!-- end add by chencm -->
    </div>
    <div class="common_radio_box clearfix" style="margin: 5px;margin-left: 20px;line-height: 30px;">
        <label for="cycleOnetime"><input type="radio" name="cycleType" id="cycleOnetime" value="once" checked="checked">${ctp:i18n('form.trigger.triggerSet.cycleOnetime.label')}</label>
        <label for="cyclePeriodical" style=" margin-left: 40px;"><input type="radio" name="cycleType" id="cyclePeriodical" value="cycle" >${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.label')}</label>
        <select id="periodicalStyle" name="periodicalStyle">
            <option value="day">${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.day.label')}</option>
            <option value="week">${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.week.label')}</option>
            <option value="month">${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.month.label')}</option>
            <option value="season">${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.season.label')}</option>
            <option value="year">${ctp:i18n('form.trigger.triggerSet.cyclePeriodical.year.label')}</option>
        </select>
    </div>
    
     <div style="margin: 5px;margin-left: 20px;line-height: 25px;float: none;display: inline-block;" id="runDiv">
        <div style="float: left;width: 85px;">执行条件：</div>
        <div style="float: left;width: 160px;left: 65px;" class="common_txtbox_wrap left">
            <textarea id="runConditionValue" style="width: 100%;height: 35px;border: 0px;" class="valign_m" name="runConditionValue" validateat="name:'${ctp:i18n('form.trigger.triggerSet.fieldValue.label')}',notNull:true,type:'string'" readonly="true" inputName="${ctp:i18n('form.trigger.triggerSet.fieldValue.label' )}"></textarea>
        </div>
          <a class="common_button common_button_gray margin_l_5" href="javascript:void(0)"  onclick="setRunCondition(this)">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
      </div>
      <br>
      <div style="margin: 5px;margin-left: 20px;line-height: 25px;float: none;display: inline-block;" id="stopDiv">
        <div style="float: left;width: 85px;">终止调度条件：</div>
        <div style="float: left;width: 160px;left: 65px;" class="common_txtbox_wrap left">
            <textarea id="stopConditionValue" style="width: 100%;height: 35px;border: 0px;" class="valign_m" name="stopConditionValue" validateat="name:'${ctp:i18n('form.trigger.triggerSet.fieldValue.label')}',notNull:true,type:'string'" readonly="true" inputName="${ctp:i18n('form.trigger.triggerSet.fieldValue.label' )}"></textarea>
        </div>
          <a class="common_button common_button_gray margin_l_5" href="javascript:void(0)"  onclick="setStopCondition(this)">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
      </div>
</div>
</form>
</body>
<%@ include file="../../common/common.js.jsp" %>
</html>