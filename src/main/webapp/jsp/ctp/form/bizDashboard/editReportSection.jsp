<%--
  Created by IntelliJ IDEA.
  User: wangh
  Date: 2017/1/9
  Time: 11:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title>编辑统计栏目</title>
</head>
<script type="text/javascript">
    var reportName = "${reportName}";
    var reportId = "${formReportBean.id}";
    $().ready(function() {
        $("#indicator").click(function (){
            indicatorFun();
        });
        $("#confirm").click(function(){
            confirmFun();
        });
        $("#cancel").click(function(){
            cancelFun();
        });
        $("#demo").click(function(){
            demoFun();
        });
        init();
        showTypeChangeEvent(true);
    });
    //初始化
    function init(){
        var sectionContent = parent.getSectionContent();
        var obj = $.parseJSON(sectionContent);
        if(obj.sectionName){
            $("#sectionName").val(obj.sectionName);
        }
        if(obj.showType){
            $("#showType").val(obj.showType);
        }
        if(obj.graphId){
            $("#graphId").val(obj.graphId);
        }
        if(obj.graphType){
            $("#graphType[value='"+obj.graphType+"']").prop("checked","checked");
        }
        if(obj.rows){
            $("#rows").val(obj.rows);
        }
        if(obj.more){
            $("#more[value='"+obj.more+"']").prop("checked","checked");
        }
    }
    //确认操作
    function confirmFun(){
        //先判断栏目名称是否为空，如果是则给一个默认值
        var sectionName = $("#sectionName").val();
        if(sectionName.trim() == ""){
            $("#sectionName").val(reportName);
        }
        if($("#mainDiv").validate({errorAlert:false}) && checkRows()){
            var map = $("#mainDiv").formobj();
            parent.callBack4Ok(JSON.stringify(map),map.sectionName);
        };
    }
    //判断显示行数是否正确
    function checkRows(){
        var rows = $("#rows").val();
        var showType = $("#showType").val();
        var rowsText = $("#rowsText").text();
        if(showType == "sectionList"){
            if(rows < 6 || rows > 10){
                $.alert(rowsText+"${ctp:i18n_2('form.biz.dashboard.section.row.limit',"6","10" )}")
                return false;
            }
        }else{
            var graphId = $("#graphId").val();
            if(graphId == null || "" == graphId){
                $.alert($.i18n('biz.dashboard.validate.not.null.label',"${ctp:i18n("form.biz.mobile.dashboard.chart.label")}"));
                return false;
            }
        }
        return true;
    }
    //取消
    function cancelFun(){
        parent.callBack4Cancel();
    }
    //自适应iframe的高度
    function setIframeHeight(){
        var editSection = $(window.parent.document).find("#editSection");
        var currentHeight = $("#mainDiv").height() + 10;
        editSection.height(currentHeight);
    }
    //展示栏目示例
    function demoFun(){
        var dialog = $.dialog({
            url:_ctxPath + "/form/bizDashboard.do?method=previewSection&type=formReport",
            title : $.i18n('form.biz.dashboard.demo.label'),
            width:400,
            height:500,
            targetWindow:getCtpTop(),
            buttons : [{
                text : $.i18n('form.trigger.triggerSet.confirm.label'),//确定
                id:"sure",
                isEmphasize: true,
                handler : function() {
                    dialog.close();
                }
            }]
        });
    }
    //类型改变后的操作
    function showTypeChangeEvent(init){
        var showType = $("#showType").val();
        if(showType == "sectionList"){//列表的时候不显示指标
            $("#graphTypeDiv").hide();
            $("#graphIdDiv").hide();
            $("#graphId").val("");
            $("#rowsDiv").show();
            if(!init){
                $("#rows").val("6");
            }
        }else{
            $("#graphTypeDiv").show();
            $("#graphIdDiv").show();
            $("#rowsDiv").hide();
            $("#rows").val("");
        }
        changeGraphType();
        setIframeHeight();
    }
    //控制图示样式
    function changeGraphType(){
        var hasMultColum = $("#graphId").find("option:selected").attr("hasMultColum");
        if(hasMultColum == "true"){
            $("#label7").hide();
        }else{
            $("label[id^='label']").show();
        }
    }
</script>
<body class="font_size12 form_area" style="overflow: hidden">
<div style="width: 400px;" id="mainDiv">
    <!-- 栏目名称 -->
    <div style="line-height: 20px;margin-top: 5px;width: 400px;height: 20px;">
        <div class="left" style="text-align: right;width: 100px;"><font color="red">*</font>${ctp:i18n("form.biz.mobile.dashboard.section.name")}</div>
        <div class="left margin_l_5">
            <div class="common_txtbox_wrap" style="text-align: left;">
                <input type="text" id="sectionName" style="width: 140px;" name="sectionName"  class="validate" validate="avoidChar:'\&#39;&quot;&lt;&gt;!\\/|@#$%^&*(){}[]',type:'string',name:'${ctp:i18n('form.biz.mobile.dashboard.section.name') }',maxLength:10,notNullWithoutTrim:true">
            </div>
        </div>
    </div>
    <!-- 栏目类型 -->
    <div class="clearfix" style="line-height: 20px;height:20px;margin-top: 10px;width: 400px;">
        <div class="left" style="text-align: right;width: 100px;">${ctp:i18n("form.biz.mobile.dashboard.section.type")}</div>
        <div class="left margin_l_5">
            <select id="showType" style="width: 152px;" onchange="showTypeChangeEvent()">
                <c:forEach items="${showTypeList}" var="showType" varStatus="status">
                    <option value="${showType.key}">${showType.text}</option>
                </c:forEach>
            </select>
        </div>
        <div class="left">&nbsp;&nbsp;<span class="ico16 help_16" id="demo" title="${ctp:i18n("form.biz.dashboard.demo.label")}"></span></div>
    </div>
    <!-- 选择图形 -->
    <div class="clearfix" style="line-height: 20px;height:20px;margin-top: 10px;" id="graphIdDiv">
        <div class="left" style="text-align: right;width: 100px;"><font color="red">*</font>${ctp:i18n("form.biz.mobile.dashboard.chart.label")}</div>
        <div class="left margin_l_5">
            <select id="graphId" style="width: 152px;" onchange="changeGraphType()">
                <option value=""></option>
                <c:forEach items="${chartCfgList}" var="chart" varStatus="status">
                    <option value="${chart.chartId}" hasMultColum="${chart.hasMultColumn}">${chart.name}</option>
                </c:forEach>
            </select>
        </div>
    </div>
    <!-- 图形类型 -->
    <div class="clearfix" style="height:40px;margin-top: 10px;" id="graphTypeDiv">
        <div class="left" style="line-height: 40px;text-align: right;width: 100px;">${ctp:i18n("form.biz.mobile.dashboard.graph.type")}</div>
        <div class="left margin_l_5">
            <div class="common_radio_box" style="text-align: left;">
            <c:forEach items="${graphList}" var="graph" varStatus="status">
                <c:if test="${status.index%2==0}">
                    <div style="height: 20px;line-height: 20px;">
                </c:if>
                <label class="margin_r_10 hand" id="label${graph.key}"><input class="radio_com" type="radio" value="${graph.key}" id="graphType" name="graphType" <c:if test="${status.first}"> checked="checked" </c:if>  >${graph.text}</label>
                <c:if test="${status.index%2==1}">
                    </div>
                </c:if>
            </c:forEach>
            </div>
        </div>
    </div>
    <!-- 显示条数 -->
    <div class="clearfix" style="line-height: 20px;margin-top: 10px;" id="rowsDiv">
        <div class="left" style="text-align: right;width: 100px;"><font color="red">*</font><label id="rowsText">${ctp:i18n("form.biz.mobile.dashboard.display.row")}</label></div>
        <div class="left margin_l_5">
            <div class="common_txtbox_wrap" style="text-align: left;">
                <input type="text" id="rows" style="width: 140px;" name="rows" class="validate" validate='notNull:true,isInteger:true,name:"${ctp:i18n('form.biz.mobile.dashboard.display.row') }"' value="6">
            </div>
        </div>
    </div>
    <!-- 可否更多 -->
    <div class="clearfix" style="line-height: 20px;margin-top: 10px;">
        <div class="left" style="text-align: right;width: 100px;">${ctp:i18n("form.biz.mobile.dashboard.show.more")}</div>
        <div class="left margin_l_5">
            <div class="common_radio_box clearfix">
                <label class="margin_r_10 hand"><input class="radio_com" type="radio" value="true" id="more" name="more" checked="checked"  >${ctp:i18n('form.biz.mobile.dashboard.show.more.yes' )}</label>&nbsp;&nbsp;&nbsp;
                <label class="margin_r_10 hand"><input class="radio_com" type="radio" value="false" id="more" name="more"  >${ctp:i18n('form.biz.mobile.dashboard.show.more.no' )}</label>
            </div>
        </div>
    </div>
    <!-- 按钮 -->
    <div class="clearfix" style="line-height: 24px;height:24px;margin-top: 5px;">
        <div style="text-align: right;margin-right: 50px;">
            <a href="javascript:void(0)" id="confirm" class="common_button common_button_emphasize">${ctp:i18n("form.trigger.triggerSet.confirm.label")}</a>
            <a href="javascript:void(0)" id="cancel" class="common_button common_button_gray">${ctp:i18n("form.query.cancel.label")}</a>
        </div>
    </div>
</div>
</body>
</html>
