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
var layout = null;
var statistics_chart = null;

/**
 * 初始化页面参数
 */
function initUI() {
    initLayout();
    var stype = $("#statisticsType").val();
    $("#condition_set").attr("style","width: 474px;margin-left: 5px");
    hiddenDateBtn($("#select_date").val());
    if($("#statistics_id").val().length > 0) {
        $("#delete_statistics").removeClass("hidden");
    }
}
/**
 * 初始化页面布局
 */
function initLayout(){
    layout = new MxtLayout({
        'id': 'layout',
        'northArea': {
            'id': 'north',
            'height': 80,
            'sprit': true,
            'maxHeight': 500,
            'minHeight': 0,
            'border': true,
            'spritBar': true,
            spiretBar: {
                show: true,
                handlerB: function(){
                    layout.setNorth(80);
                },
                handlerT: function(){
                    layout.setNorth(0);
                }
            }
        },
        'centerArea': {
            'id': 'center',
            'border': true,
            'minHeight': 20
        }
    });
}

/**
 * 初始化绑定按钮事件
 */
function initBindEvent() {
    $("#condition_set_btn").bind("click" , showConditionSetPanel);
    $("#select_date").bind("change" , function (){
        var val = $("#select_date").val();
        if(val != "random") {
            changeWeekOrMonth(val);   
        }
        hiddenDateBtn(val);
    });
    $('input:radio[name="chart_option"]').bind("click" ,changeStatisticsPic);
    $("input[name='role_type']").bind("click" ,function (){
        boolCheckBoxAll("role_type","role_type_all");
        checkBoxValueToText("role_type","roleType");
    });
    $("input[name='status_ck']").bind("click" ,function (){
        boolCheckBoxAll("status_ck","status_all");
        checkBoxValueToText("status_ck","status");
    });
    $("input[name='risk_level']").bind("click" ,function (){
        boolCheckBoxAll("risk_level","risk_level_all");
        checkBoxValueToText("risk_level","riskLevel");
    });
    $("input[name='important_level']").bind("click" ,function (){
        boolCheckBoxAll("important_level","importantlevel_all");
        checkBoxValueToText("important_level","importantLevel");
    });
    $("input[name='role_type_all']").bind("click" ,function (){
        allCheckBox("role_type");
        checkBoxValueToText("role_type","roleType");
    });
    $("input[name='status_all']").bind("click" ,function (){
        allCheckBox("status_ck");
        checkBoxValueToText("status_ck","status");
    });
    $("input[name='risk_level_all']").bind("click" ,function (){
        allCheckBox("risk_level");
        checkBoxValueToText("risk_level","riskLevel");
    });
    $("input[name='importantlevel_all']").bind("click" ,function (){
        allCheckBox("important_level");
        checkBoxValueToText("important_level","importantLevel");
    });
    $("#statistics_btn").bind("click" ,searchStatistics);
    $("#save_statistics").bind("click" ,saveStatistics);
    $("#delete_statistics").bind("click" ,deleteTaskStatistics);
    $("#importExcel").bind("click" ,exportToExcel);
}

/**
 * 根据日期类型隐藏日期按钮
 * @type 日期类型
 */
function hiddenDateBtn(type){
    if(type == "random") {
        $("span.calendar_icon_area").each(function() {
            $(this).removeClass("hidden");
        });
    } else {
        $("span.calendar_icon_area").each(function() {
            $(this).addClass("hidden");
        });
    }
}

/**
 * 根据统计类型初始化复选框
 */
function initCheckBoxByStatisticsType() {
    var stype = $("#statisticsType").val();
    if(stype == "status"){
        $("#status_select_info").addClass("hidden");
    } else if(stype == "riskLevel"){
        $("#risk_select_info").addClass("hidden");
    } else if(stype == "roleType"){
        $("#role_select_info").addClass("hidden");
    } else if(stype == "importantLevel"){
        $("#importantlevel_select_info").addClass("hidden");
    }
}

/**
 * 初始化条件设置
 */
function initConditionSet(){
    var userId = $("#userId").val();
    initSelectUser(userId);
    initCheckBoxByStatisticsType();
    setCheckBoxChecked("roleType","role_type");
    setCheckBoxChecked("status","status_ck");
    setCheckBoxChecked("riskLevel","risk_level");
    setCheckBoxChecked("importantLevel","important_level");
    boolCheckBoxAll("role_type","role_type_all");
    boolCheckBoxAll("status_ck","status_all");
    boolCheckBoxAll("risk_level","risk_level_all");
    boolCheckBoxAll("important_level","importantlevel_all");
}

/**
 * 设置对应的checkBox选中
 * @textName 文本内容
 * @chkName 复选框名称
 */
function setCheckBoxChecked(textName,chkName){
    var initVal = $("#" + textName).val();
    if(initVal.length > 0){
        var values = initVal.split(",");
        $("input[name='"+chkName+"']").each(function() {
            var val = $(this).attr("value");
            for(var i=0;i<values.length;i++){
                if (values[i] == val) {
                    $(this).attr("checked", true);
                }
            }
        });
    }
}

/**
 * 判断复选框是否被全部选中
 */
function boolCheckBoxAll(chkName,allChkName){
    var count = 0;
    $("input[name='"+chkName+"']").each(function() {
        if (this.checked == true) {
            count++;
        }
    });
    if(count == $("input[name='"+chkName+"']").length) {
        $("input[name='"+allChkName+"']").attr("checked","true"); 
    } else {
        $("input[name='"+allChkName+"']").removeAttr("checked");
    }
}

/**
 * 全选或全不选 
 */
function allCheckBox(chkName){
    var count = 0;
    $("input[name='"+chkName+"']").each(function() {
        if (this.checked == true) {
            count++;
        }
    });
    if(count != $("input[name='"+chkName+"']").length){
        $("input[name='"+chkName+"']").attr("checked",true);
    } else {
        $("input[name='"+chkName+"']").removeAttr("checked");
    }
}

/**
 * 将选中的值放入隐藏文本框
 */
function checkBoxValueToText(chkName,textName){
    var strTemp;
    var count = 0;
    $("input[name='"+chkName+"']").each(function() {
        if (this.checked == true) {
            if(count == 0){
                strTemp = this.value;
            }else {
                strTemp += ","+this.value;
            }
            count++;
        }
    });
    $("#"+textName).val(strTemp);
}

/**
 * 初始化人员选择
 */
function initSelectUser(userId){
    var taskAjax = new taskAjaxManager();
    var userName = taskAjax.findMemberNames(userId);
    $("#select_user").html('<option value="'+userId+'">'+userName+'</option><option value="0" onclick="showPerson()">人员选择</option>');
}

/**
 * 初始化统计图
 */
function initStatisticsPic(){
    var indexNames = $("#index_names").val().split(",");
    var simpleDataList = new Array($("#data_list").val().split(","));
    statistics_chart = new SeeyonChart({
      htmlId:"statistics_chart",
      width : 400,
      height: 260,
      chartType : ChartType.pie,
      dataList: simpleDataList,
      indexNames : indexNames,
      explodeOnClick : false,
      yLabels : {
        format : "{%Value}{numDecimals:0}" //将值格式化
      },
      is3d : true,
      insideLabel : "{%YPercentOfTotal}%",
      legend : "{%Icon}{%Name}",//{%Icon}{%Name} 比重：{%YPercentOfTotal}% 共{%Value}{numDecimals:0}个
      debugge : true,
      event : [
               {name:"pointClick",func:onPointClick}
               ]
    });
}

/**
 * 将日期字符转换成日期类型
 * 
 * @param dateStr 日期字符串
 * @return 转换后日期
 */
function parseDate(dateStr) {
    return Date.parse(dateStr.replace(/\-/g, '/'));
}
</script>