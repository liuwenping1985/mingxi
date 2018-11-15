<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-09-18

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.seeyon.ctp.form.util.*"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>设置回写/汇总表单</title>
</head>
<body scroll="no" style="overflow: hidden;" class="hidden">
<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0" height="100%" class="popupTitleRight font_size12 margin_t_10">
    <tr>
        <td>
            <table cellSpacing="2" cellPadding="2" width="95%" border="0" id="rtable">
                <tr>
                    <td align="right" width="10px" class="padding_t_10">&nbsp;</td>
                    <td width="90px" align="right" class="padding_t_10">${ctp:i18n('form.create.input.relation.label') }：</td>
                    <td width="300px" class="padding_t_10">
                        <div class=common_txtbox_wrap>
                            <input type="text" id="relFormName" name="relFormName" value=""  readonly="readonly" />
                            <input type="hidden" id="relFormId" name="relFormId" value="" />
                            <input type="hidden" id=system value="2" />
                        </div>
                    </td>
                    <td align="left" class="padding_t_10">
                        <a id="setRelFormBtn" class="common_button common_button_gray margin_l_5" href="javascript:void(0)">${ctp:i18n('formsection.config.choose.template.set') }</a>
                    </td>
                    <td width="50px"></td>
                </tr>
                <tr>
                    <td width="10px">&nbsp;</td>
                    <td height="120px" colspan="4" width="490px" class="padding_t_10">
                        <table width="100%" id="relationCondition" Grid="true" class="hidden" border="0">
                            <tr>
                                <td colspan="5" class="padding_l_30">${ctp:i18n('form.relation.condition.label') }：<input type="hidden" id="currentFormId" value="${formBean.id}" /></td>
                            </tr>
                            <tr>
                                <td class="padding_l_30 padding_t_10" style="width:200px;">${formBean.formName}</td>
                                <td class="padding_l_30 padding_t_10" style="width:200px;"></td>
                                <td colspan="3">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="5" width="100%" class="padding_t_10" style="padding-left:24px;">
                                    <div style="overflow: auto; height: 120px; width: 470px" id="conditionDiv">
                                        <table width="450" id="rCondition">
                                            <tr id="conditionRow" class="conditionRow">
                                                <td class="padding_l_5 padding_t_5">
                                                    <div class=common_selectbox_wrap style="line-height: 20px; height: 26px;">
                                                        <select id="fieldName" name="fieldName" style="width: 115px; margin: 0px; padding: 0px;">
                                                        </select>
                                                    </div>
                                                </td>
                                                <td class=" padding_l_5 padding_t_5">
                                                    <div class=common_selectbox_wrap style="line-height: 20px; height: 26px;">
                                                        <select id="operation" name="operation" style="width: 50px; margin: 0px; padding: 0px;">
                                                            <option value="=" selected>=</option>
                                                        </select>
                                                    </div>
                                                </td>
                                                <td class=" padding_l_5 padding_t_5">
                                                    <div class=common_selectbox_wrap style="line-height: 20px; height: 26px;">
                                                        <select id="fieldValue" name="fieldValue" style="width: 135px; margin: 0px; padding: 0px;">
                                                        </select>
                                                    </div>
                                                </td>
                                                <td class=" padding_l_5 padding_t_5">
                                                    <div class=common_selectbox_wrap style="line-height: 20px; height: 26px;">
                                                        <select id="rowOperation" name="rowOperation" style="width: 50px; margin: 0px; padding: 0px;">
                                                            <option value="and" selected>and</option>
                                                        </select>
                                                    </div>
                                                </td>
                                                <td class=" padding_l_5 padding_t_5" width="60">
                                                    <span id="delButton" class="repeater_reduce_16 ico16 revoked_process_16"></span>
                                                    <span id="addButton" class="repeater_plus_16 ico16"></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</TABLE>
</BODY>
<script type="text/javascript">
    var formType = "${relForm.formType}";
    var uniqueFieldList = new Array();
    var fieldlist = new Array();
    var relation;
    var isCanChange = "${ctp:escapeJavascript(isCanChange)}";
    if (window.dialogArguments[1]) {
        relation = window.dialogArguments[1];
    }

    $().ready(function () {
        $("#conditionDiv").css("height", "210");
        $("body").show();
        $("#system").attr("checked",true);

        if ($.browser.msie || $.browser.mozilla) {
            $("label>span").css("vertical-align", "middle");
        }
        $("#addButton").click(function () {
            if (isCanChange != "false") {
                addConditionRow($(this).parents("tr:eq(0)"));
            }
        });
        $("#delButton").click(function () {
            if (isCanChange != "false") {
                if ($("tr", "#rCondition").length > 1) {
                    $(this).parents("tr:eq(0)").remove();
                } else {
                    $(this).parents("tr:eq(0)").remove();
                    addConditionRow();
                }
            }
        });

        $("body").data("conditionRow", $("#conditionRow").clone(true));
        showViewType("${relForm.id}", "${relForm.formName}", "${relForm.formType}");
        initRelationConditionField("${relForm.id}", "${relForm.formName}", "${relForm.formType}", relation);
        showConditionField();

        if (isCanChange != "false") {
            //保存表单基础信息
            $("#setRelFormBtn").click(function () {
                var dialog = $.dialog({
                    url: "${path}/form/fieldDesign.do?method=relationFormList&formtype=${param.formtype}&uniquetype=${param.uniquetype}",
                    title: '${ctp:i18n('form.create.input.setting.relation.label')}',
                    width: 800,
                    height: 480,
                    targetWindow: getCtpTop(),
                    transParams: window,
                    buttons: [{
                        text: "${ctp:i18n('common.button.ok.label')}",
                        id: "sure",
                        isEmphasize: true,
                        handler: function () {
                            var condi = dialog.getReturnValue();
                            if (condi) dialog.close();
                        }
                    }, {
                        text: "${ctp:i18n('common.button.cancel.label')}",
                        id: "exit",
                        handler: function () {
                            dialog.close();
                        }
                    }]
                });
            });
        }
        if (isCanChange == "false") {
            $("a").attr('href', '#');
            $("input").attr("disabled", true);
            $("select").attr("disabled", true);
            $("span").attr("disabled", true);
        }
    });

    function showViewType(id,name,formType,isSelected){
        if(!id || id==null) return;
        $("#relFormId").val(id);
        $("#relFormName").val(name);
    }

    function initRelationConditionField(id,name,formType,hasConList){
        if(id==null||id==""||id==" ")return;
        var fdManager = new formFieldDesignManager();
        var o = fdManager.getRelationUniqueField(id);
        uniqueFieldList = o.uniqueField;
        fieldlist = o.srcField;
        var obj = $("body").data("conditionRow");
        var srcF = $("#fieldName",obj);
        srcF.addClass("validate comp enumselect common_drop_down").attr("comp","type:'autocomplete',autoSize:true").attr("comptype","autocomplete");
        if(fieldlist.length>0){
            srcF.empty();
            srcF.append('<option value=""></option>');
            var currentFieldName;
            for(var k=0;k<fieldlist.length;k++){
                //过滤流程处理意见字段,过滤本身
                if(fieldlist[k].ownerTableName != undefined && fieldlist[k].inputType != "flowdealoption" && fieldlist[k].name != currentFieldName){
                    var val = ("{a"+fieldlist[k].ownerTableName.substring(fieldlist[k].ownerTableName.indexOf("_")+1))+"."+fieldlist[k].display+"}";
                    srcF.append('<option tableName="'+fieldlist[k].ownerTableName+'" value="'+val+'" fieldType="'+fieldlist[k].fieldType+'" inputType="'+fieldlist[k].inputType+'" isMaster="'+isMasterField(fieldlist[k])+'">'+fieldlist[k].display+'</option>');
                }
            }
        }else{
            srcF.empty();
            srcF.append('<option value=""></option>');
        }
        var tarF = $("#fieldValue",obj);
        if(uniqueFieldList.length>0){
            tarF.empty();
            for (var k = 0; k < uniqueFieldList.length; k++) {
                //联动-汇总：只显示主表唯一字段
                if ("${param.uniquetype}" == "master" && !isMasterField(uniqueFieldList[k])) {
                    continue;
                }
                var val = ("{b" + uniqueFieldList[k].ownerTableName.substring(uniqueFieldList[k].ownerTableName.indexOf("_") + 1)) + "." + uniqueFieldList[k].display + "}";
                tarF.append('<option tableName="' + uniqueFieldList[k].ownerTableName + '" value="' + val + '" fieldType="' + uniqueFieldList[k].fieldType + '" inputType="' + uniqueFieldList[k].inputType + '" isMaster="' + isMasterField(uniqueFieldList[k]) + '">' + uniqueFieldList[k].display + '</option>');
            }
            if(o.unList.length>0){
                for(var k=0;k<o.unList.length;k++){
                    var val = ("{b"+o.unList[k].ownerTableName.substring(o.unList[k].ownerTableName.indexOf("_")+1))+"."+o.unList[k].display+"}";
                    tarF.append('<option tableName="'+o.unList[k].ownerTableName+'" value="'+val+'" fieldType="'+o.unList[k].fieldType+'" inputType="'+o.unList[k].inputType+'" isMaster="'+isMasterField(o.unList[k])+'">'+o.unList[k].display+'</option>');
                }
            }
        }else{
            tarF.empty();
            tarF.append('<option value=""></option>');
        }
        var formNameTd = $("td",$("tr:eq(1)","#relationCondition"));
        formNameTd.eq(0).text("${formBean.formName}");
        formNameTd.eq(1).text(name);
        if(hasConList&&hasConList.length>0){
            $(".conditionRow").remove();
            for(var i=0;i<hasConList.length;i++){
                var row = addConditionRow(null, true);
                for(var s in hasConList[i]){
                    if(s == "rowOperation") {
                        //OA-89355 ie11下这里给and赋值后，保存时取到的为null。
                    }else{
                        $("#"+s,row).val(hasConList[i][s]);
                    }
                }
                row.comp();
            }
        }else{
            setConditionField();
        }
    }

    function setConditionField(){
        $(".conditionRow").remove();
        if(uniqueFieldList.length>0){
            for (var i = 0; i < uniqueFieldList.length; i++) {
                //联动-汇总：只显示主表唯一字段
                if ("${param.uniquetype}" == "master" && !isMasterField(uniqueFieldList[i])) {
                    continue;
                }
                var obj = addConditionRow();
                var val = ("{b" + uniqueFieldList[i].ownerTableName.substring(uniqueFieldList[i].ownerTableName.indexOf("_") + 1)) + "." + uniqueFieldList[i].display + "}";
                $("#fieldValue", obj).val(val);
            }
        }else{
            addConditionRow();
        }
    }

    //是否是主表字段
    function isMasterField(oo){
        if(oo.ownerTableName.indexOf("formmain_")>-1){
            return true;
        }
        return false;
    }

    function addConditionRow(obj, comp){
        var cRow = $("body").data("conditionRow").clone(true);
        if (!comp) {
            cRow.comp();
        }
        if(obj){
            cRow.insertAfter($(obj));
        }else{
            $("#rCondition").append(cRow);
        }
        //设置关联表单下拉框(系统自动增加的控件)样式的高度
        $(":input[name='acToggle']").css("height", "26px");
        return cRow;
    }

    function showConditionField() {
        if ($("#relFormId").val() && (formType == 1 || uniqueFieldList == null || uniqueFieldList.length == 0)) {
            $.alert({
                'msg': "${ctp:i18n('form.base.field.set.relation.needunique.label')}",
                ok_fn: function () {
                    $("#relFormId").val("");
                    $("#relFormName").val("");
                    var formNameTd = $("td", $("tr:eq(1)", "#relationCondition"));
                    formNameTd.eq(0).text("");
                    formNameTd.eq(1).text("");
                    $(".conditionRow").remove();
                    var currentRow = addConditionRow();
                    $("#fieldName", currentRow).empty();
                }
            });
        }
        $("#relationCondition").removeClass("hidden");
        //设置关联表单下拉框(系统自动增加的控件)样式的高度
        $(":input[name='acToggle']").css("height", "26px");
    }

    function OK() {
        var returnVal = "";
        if ($("#relFormName").val() == "") {
            $.alert("${ctp:i18n('form.create.input.select.relation')}");
            return "error";
        }
        var isMasterField = "1";
        var subTableName = "";
        var fromSubTableName = "";
        var lConditionStr = "";
        var rConditionStr = "";
        $(".conditionRow").each(function (index) {
            $("select", $(this)).each(function () {
                if ($(this).val() == "" || $(this).val() == null) {
                    returnVal = "error";
                    return false;
                } else {
                    returnVal = returnVal + " " + $(this).val() + " ";
                }
                if ($(this).attr("id") == "fieldValue") {
                    if ($(":selected", $(this)).attr("isMaster") == "false") {
                        isMasterField = "0";
                        if (!subTableName) {
                            subTableName = $(":selected", $(this)).attr("tableName");
                        } else if (subTableName != $(":selected", $(this)).attr("tableName")) {
                            returnVal = "subTable";
                            $.alert("${ctp:i18n('form.base.field.relation.onlyonesubTable')}");
                            return false;
                        }
                    }
                }
                if ($(this).attr("id") == "fieldName") {
                    if ($(":selected", $(this)).attr("isMaster") == "false") {
                        if (!fromSubTableName) {
                            fromSubTableName = $(":selected", $(this)).attr("tableName");
                        } else if (fromSubTableName != $(":selected", $(this)).attr("tableName")) {
                            returnVal = "subTable";
                            $.alert("${ctp:i18n('form.base.field.relation.onlyonesubTable')}");
                            return false;
                        }
                    }
                }
            });
            if (returnVal == "error" || returnVal == "subTable") {
                return false;
            }
            //对关联条件进行判断是否类型
            var lt = $("#fieldName", this).find("option:selected").attr("fieldType");
            var rt = $("#fieldValue", this).find("option:selected").attr("fieldType");
            var lname = $("#fieldName", this).find("option:selected").val();
            var rname = $("#fieldValue", this).find("option:selected").val();
            var lnameStr = "&" + lname + "&";
            var rnameStr = "&" + rname + "&";
            if (lConditionStr.indexOf(lnameStr) > -1) {
                $.alert("${ctp:i18n('form.relation.condition.exit')}");
                returnVal = "errortype";
                return false;
            } else if (rConditionStr.indexOf(rnameStr) > -1) {
                $.alert("${ctp:i18n('form.relation.condition.exit')}");
                returnVal = "errortype";
                return false;
            } else {
                lConditionStr = lConditionStr + lnameStr;
                rConditionStr = rConditionStr + rnameStr;
            }
            if (lt != rt) {
                var rownumber = index + 1;
                $.alert("${ctp:i18n_1('form.relation.condition.error.2.label', '" + rownumber + "')}");
                returnVal = "errortype";
                return false;
            }
        });
        if (returnVal == "errortype" || returnVal == "subTable") {
            return "error";
        }
        if (returnVal == "error" || returnVal == "") {
            $.alert("${ctp:i18n('form.relation.condition.error.1.label')}");
            return "error";
        }

        var ret = new Object();
        ret.formId = $("#relFormId").val();
        ret.formName = $("#relFormName").val();
        ret.condition = returnVal.substring(0, returnVal.length - 4);
        ret.isMasterField = isMasterField;
        ret.subTableName = subTableName;
        ret.fromSubTableName = fromSubTableName;
        return ret;
    }

    //空方法，设置回写表单时的回函数，但是回写、汇总选择时不行要做特殊处理
    function showSelectValue(id,name,formType){

    }
</script>
<script type="text/javascript" src="${path}/common/form/design/designBaseInfo.js${ctp:resSuffix()}"></script>
</HTML>