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
    <title>编辑查询栏目</title>
</head>
<script type="text/javascript">
    var queryName = "${queryName}";
    var queryId = "${formQueryBean.id}";
    $().ready(function() {
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
        //setIframeHeight();
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
        if(obj.indicator){
            $("#indicator").val(obj.indicator);
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
            $("#sectionName").val(queryName);
        }
        if($("#mainDiv").validate({errorAlert:false}) && checkRows()){
            var map = $("#mainDiv").formobj();
            parent.callBack4Ok(JSON.stringify(map),map.sectionName);
        };
    }
    //判断显示行数是否正确
    function checkRows(){
        var showType = $("#showType").val();
        var rows = $("#rows").val();
        var rowsText = $("#rowsText").text();
        if(showType == "sectionList"){
            if(rows < 6 || rows > 10){
                $.alert(rowsText+"${ctp:i18n_2('form.biz.dashboard.section.row.limit',"6","10" )}");
                return false;
            }
        }else{
            if(rows < 1 || rows > 5){
                $.alert(rowsText+"${ctp:i18n_2('form.biz.dashboard.section.row.limit',"1","5" )}")
                return false;
            }
            var indicator = $("#indicator").val();
            if(indicator == null || "" == indicator){
                //判断是否选择了指标
                $.alert($.i18n('biz.dashboard.validate.not.null.label',"${ctp:i18n("form.biz.mobile.dashboard.edit.indicator")}"));
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
            url:_ctxPath + "/form/bizDashboard.do?method=previewSection&type=formQuery",
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
        var rows = $("#rows").val();
        if(showType == "sectionList"){//列表的时候不显示指标
            $("#indicatorDiv").hide();
            $("#indicator").val("");
            if(!init){
                $("#rows").val("6");
            }
        }else{
            $("#indicatorDiv").show();
            if(!init){
                $("#rows").val("1");
            }
        }
        $("#mainDiv").resetValidate();
        setIframeHeight();
    }
</script>
<body class="font_size12" style="overflow: hidden">
<div style="width: 400px;" class="form_area" id="mainDiv">
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
        <div class="left" style="text-align: right;width: 100px;"><font color="red">*</font>${ctp:i18n("form.biz.mobile.dashboard.section.type")}</div>
        <div class="left margin_l_5">
            <select id="showType" style="width: 152px;" onchange="showTypeChangeEvent()">
            <c:forEach items="${showTypeList}" var="showType" varStatus="status">
                <option value="${showType.key}">${showType.text}</option>
            </c:forEach>
            </select>
        </div>
        <div class="left">&nbsp;&nbsp;<span class="ico16 help_16" id="demo" title="${ctp:i18n("form.biz.dashboard.demo.label")}"></span></div>
    </div>
    <!-- 指标值 -->
    <div class="clearfix" style="line-height: 20px;height:20px;margin-top: 10px;" id="indicatorDiv">
        <div class="left" style="text-align: right;width: 100px;"><font color="red">*</font>${ctp:i18n("form.biz.mobile.dashboard.edit.indicator")}</div>
        <div class="left margin_l_5">
            <select id="indicator" style="width: 152px;">
                <option value=""></option>
                <c:forEach items="${indicatorList}" var="temp" varStatus="status">
                    <option value="${temp.id}">${temp.showTitle}</option>
                </c:forEach>
            </select>
        </div>
    </div>
    <!-- 显示条数 -->
    <div class="clearfix" style="line-height: 20px;margin-top: 10px;">
        <div class="left" style="text-align: right;width: 100px;"><font color="red">*</font><label id="rowsText">${ctp:i18n("form.biz.mobile.dashboard.display.row")}</label></div>
        <div class="left margin_l_5">
            <div class="common_txtbox_wrap" style="text-align: left;">
                <input type="text" id="rows" style="width: 140px;" name="rows" class="validate" validate='notNull:true,isInteger:true,name:"${ctp:i18n('form.biz.mobile.dashboard.display.row') }"' value="6"/>
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
