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
    <title>编辑通用栏目</title>
    <style type="text/css">
        .sub_indicator_row{
            line-height: 25px;background:#F8F8FF;margin: 2px;
        }
        .sub_indicator_row_fieldname{
            display: inline-block;vertical-align: middle;width: 210px;
        }
        .sub_indicator_row_color{
            display: inline-block;width: 12px;height: 12px;background: #3AADFB; vertical-align: middle;cursor:pointer;
        }
    </style>
</head>
<%--<script type="text/javascript" src="${path}/common/form/bizDashboard/jquery.colorpicker.js"></script>--%>
<link rel="stylesheet" href="${path}/common/form/bizDashboard/css/colpick.css" type="text/css" />
<!--[if lt IE 9]>
<script type="text/javascript" src="${path}/common/form/bizDashboard/html5shiv.js${ctp:resSuffix()}"></script>
<![endif]-->
<script type="text/javascript" src="${path}/common/form/bizDashboard/colpick.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/form/bizDashboard/editGeneralSection.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
    //测试数据  改成从父页面获取
    var data= $.parseJSON($(".currentSection",parent.document).find("#sectionContent").val());
    var defaultName = "${ctp:i18n('form.biz.mobile.dashboard.general.indicator.section')}";

    $().ready(function() {
        $("#mainIndicatorName").click(function (){
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
        $("#editSubIndicator").click(function (){
            editSubIndicatorFun();
        });
        //栏目连接
        $("#linkName").click(function (){
            linkFun();
        });

        setFieldsValue(data);//设置值
        initColButton("mainIndicatorColorDiv","mainIndicatorColor",(data.mainIndicator && data.mainIndicator.mainColor)?data.mainIndicator.mainColor:'#FF4141');//初始化主指标颜色选择
        setIframeHeight();
    });
</script>
<body class="font_size12" style="overflow: hidden">
<div style="width: 369px;" class="form_area" id="mainDiv">
    <!-- 栏目名称 -->
    <div style="line-height: 24px;margin-top: 5px;width: 400px;height: 24px;">
        <div class="left" style="text-align: right;width: 100px;"><font color="red">*</font>${ctp:i18n("form.biz.mobile.dashboard.section.name")}</div>
        <div class="left margin_l_5">
            <div class="common_txtbox_wrap" style="text-align: left;">
                <input type="text" id="sectionName" style="width: 140px;" name="sectionName"  class="validate" validate="avoidChar:'\&#39;&quot;&lt;&gt;!\\/|@#$%^&*(){}[]',type:'string',name:'${ctp:i18n('form.biz.mobile.dashboard.section.name') }',maxLength:10,notNullWithoutTrim:true">
            </div>
        </div>
    </div>
    <div style="height: 1px;margin:10px;margin-top:13px;background:#dcdbdb;"></div>

    <!-- 栏目类型 -->
    <div class="clearfix" style="line-height: 24px;height:24px;margin-top: 10px;width: 400px;">
        <div class="left" style="text-align: right;width: 100px;"><font color="red">*</font>${ctp:i18n("form.biz.mobile.dashboard.section.type")}</div>
        <div class="left margin_l_5">
            <select id="showType" style="width: 152px;" onchange="changeSectionType()">
                <c:forEach items="${showTypeList}" var="showType" varStatus="status">
                    <option value="${showType.key}">${showType.text}</option>
                </c:forEach>
            </select>
        </div>
        <div class="left">&nbsp;&nbsp;<span class="ico16 help_16" id="demo" title="${ctp:i18n("form.biz.dashboard.demo.label")}"></span></div>
    </div>
    <!-- 主指标 -->
    <div class="clearfix" style="line-height: 24px;height:24px;margin-top: 10px;" id="mainIndicatorDiv">
        <div class="left" style="text-align: right;width: 100px;"><font color="red">*</font>${ctp:i18n("form.biz.mobile.dashboard.main.indicator")}</div>
        <div class="left margin_l_5">
            <div class="common_txtbox_wrap" style="text-align: left;">
                <input type="hidden" id="mainIndicator" name="mainIndicator">
                <input type="hidden" id="mainIndicatorQueryId" name="mainIndicatorQueryId">
                <input type="text" id="mainIndicatorName" class="hand" readonly="readonly" style="width: 140px;" name="mainIndicatorName">
            </div>
        </div>
        <div id="color_box" class="left margin_l_5 common_txtbox_wrap" style="width:14px;height: 14px;padding:5px;margin-left:5px;background: #f6f6f6;cursor:pointer;">
            <div id="mainIndicatorColorDiv" style="background:#FF4141;width:100%;height: 100%;">
                <input type="hidden" id="mainIndicatorColor" value="#FF4141">
            </div>
        </div>
    </div>
    <!-- 副指标 -->
    <div class="clearfix" style="line-height: 24px;margin-top: 10px;" id="sub_indicator_div">
        <div class="left" style="text-align: right;width: 100px;"><font color="red">*</font>${ctp:i18n("form.biz.mobile.dashboard.sub.indicator")}</div>
        <div class="left margin_l_5">
            <a href="javascript:void(0)" id="editSubIndicator" class="common_button common_button_emphasize">${ctp:i18n("form.biz.mobile.dashboard.sub.indicator.selectButton")}</a>
            <div id="sub_indicator_field_box" style="width:258px;">
            </div>
        </div>
    </div>
    <!-- 是否穿透 -->
    <div class="clearfix" style="line-height: 24px;margin-top: 10px;">
        <div class="left" style="text-align: right;width: 100px;">${ctp:i18n('form.biz.mobile.dashboard.indicator.through' )}</div>
        <div class="left margin_l_5">
            <div class="common_radio_box clearfix">
                <label class="margin_r_10 hand"><input class="radio_com" type="radio" value="true" id="through1" name="through" checked="checked"  >${ctp:i18n('form.biz.mobile.dashboard.show.more.yes' )}</label>&nbsp;&nbsp;&nbsp;
                <label class="margin_r_10 hand"><input class="radio_com" type="radio" value="false" id="through2" name="through"  >${ctp:i18n('form.biz.mobile.dashboard.show.more.no' )}</label>
            </div>
        </div>
    </div>
    <div style="height: 1px;margin:10px;margin-top:8px;background:#dcdbdb;"></div>
    <!-- 栏目链接 -->
    <div class="clearfix" style="line-height: 24px;height:24px;margin-top: 5px;">
        <div class="left" style="text-align: right;width: 100px;">${ctp:i18n('form.biz.mobile.dashboard.section.link')}</div>
        <div class="left margin_l_5">
            <div class="common_txtbox_wrap" style="text-align: left;">
                <input type="hidden" id="linkId"/>
                <input type="hidden" id="linkType"/>
                <input id="linkName" type="text" readonly="readonly" class="hand" style="width: 140px;">
            </div>
        </div>
    </div>
    <!-- 按钮 -->
    <div class="clearfix" style="line-height: 24px;height:24px;margin-top: 10px;">
        <div style="text-align: right;margin-right: 50px;">
            <a href="javascript:void(0)" id="confirm" class="common_button common_button_emphasize">${ctp:i18n("form.trigger.triggerSet.confirm.label")}</a>
            <a href="javascript:void(0)" id="cancel" class="common_button common_button_gray">${ctp:i18n("form.query.cancel.label")}</a>
        </div>
    </div>
</div>
</body>
</html>
