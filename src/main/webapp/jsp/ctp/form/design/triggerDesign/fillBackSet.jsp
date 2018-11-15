<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%">
<head>
<script type="text/javascript">
var fromFormBeanType = "${fromFormBean.formType}";
var needSourceField = "${needSourceField}";
var needBackField = "${needBackField}";//双向回触发源拷贝能拷贝到的源表单字段
var sub2MainRelationFrom = "${sub2MainRelationFrom}";
var sub2MainRelationTo = "${sub2MainRelationTo}";
var parentWinObj = window.dialogArguments[0];

$(document).ready(function() {
    $("#add, #add1").click(function() {
        add(this);
    });

    $("#del, #del1").click(function() {
        del(this);
    });

    $("#btnreset").click(resetData);

    resetData();
});

function add(obj) {
    var currentTr = $(obj).parents("tr:eq(0)");
    var cloneObj = $.ctpClone(currentTr);
    var source = $("#fromField_bak").val();
    var source1 = $("#fromField_bak1").val();
    var target = $("#toField_bak").val();
    var target1 = $("#toField_bak1").val();
    $("#sourceTD", cloneObj).html(source);
    $("#targetTD", cloneObj).html(target);
    $("#sourceTD1", cloneObj).html(source1);
    $("#targetTD1", cloneObj).html(target1);
    $("#add, #add1", cloneObj).unbind("click").bind("click", function() {
        add(this);
    });
    $("#del, #del1", cloneObj).unbind("click").bind("click", function() {
        del(this);
    });
    $("#fromField, #fromField1", cloneObj).val("");
    $("#toField, #toField1", cloneObj).val("");
    cloneObj.insertAfter(currentTr);
    cloneObj.comp();
}

function del(obj) {
    var currentTr = $(obj).parents("tr:eq(0)");
    if (currentTr.parent().children().length == 1) {
        add(obj);
        currentTr.remove();
        return;
    }else{
        currentTr.remove();
        currentTr=null;
    }
}

function resetData() {
    var tfillBackType = $("#fillBackType", parentWinObj.currentTr).val();
    var fillBackSource = $("#fillBackKey", parentWinObj.currentTr).val();
    var fillBackValue = $("#fillBackValue", parentWinObj.currentTr).val();
    resetDatas(tfillBackType, fillBackSource, fillBackValue, "");

    if (${param.actionType eq 'bilateralgo'}) {
        var tfillBackType1 = $("#fillBackType1", parentWinObj.currentTr).val();
        var fillBackSource1 = $("#fillBackKey1", parentWinObj.currentTr).val();
        var fillBackValue1 = $("#fillBackValue1", parentWinObj.currentTr).val();
        resetDatas(tfillBackType1, fillBackSource1, fillBackValue1, "1");
    }
}

function resetDatas(tfillBackType, fillBackSource, fillBackValue, suffix) {
    var typeSplit = tfillBackType.split("|");
    var sourceSplit = fillBackSource.split("|");
    var valueSplit = fillBackValue.split("|");
    var source = $("#fromField_bak"+suffix).val();
    var target = $("#toField_bak"+suffix).val();
    for (var i = 0; i < typeSplit.length; i++) {
        var cTr;
        var cloneTr;
        var dataTableb = $("#dataTable" + suffix);
        if (i == 0) {
            if ($("tr", dataTableb).length > 1) {
                $("tr", dataTableb).each(function(index) {
                    if (index != 0) {
                        $(this).remove();
                    }
                });
            }
            var firstRow = $("tr:eq(0)", dataTableb);
            cloneTr = firstRow.clone(true);
            cTr = firstRow;
        } else {
            cTr = cloneTr.clone(true);
            cTr.appendTo(dataTableb);
        }
        $("#sourceTD"+suffix, cTr).html(source);
        $("#targetTD"+suffix, cTr).html(target);
        $("#fromField" + suffix, cTr).val(sourceSplit[i]);
        $("#tfillBackType" + suffix, cTr).val("copy");
        $("#toField" + suffix, cTr).val(valueSplit[i]);
        cTr.comp();
    }
}

function OK(obj) {
    if (obj == "reset") {
        resetData();
        return "";
    } else {
        return checkData();
    }
}

function checkData() {
    var tfillBackType = "";
    var fillBackSource = "";
    var fillBackValue = "";
    var fillBackSourceList = new ArrayList();
    var fillBackValueList = new ArrayList();
    var error = "";

    var tfillBackType1 = "";
    var fillBackSource1 = "";
    var fillBackValue1 = "";
    var fillBackSource1List = new ArrayList();
    var fillBackValue1List = new ArrayList();

    $("tr", "#dataTable").each(function() {
        var tempSource = $("#fromField", $(this)).val();
        var tempValue = $("#toField", $(this)).val();
        if (tempSource === "" && tempValue === "") {
            return true;
        }
        if (tempSource == "" || tempValue == "") {
            $.alert("${ctp:i18n('form.trigger.triggerSet.fillback.select.tocheck')}");
            error = "error";
            return false;
        }
        var tempType = $("#tfillBackType", $(this)).val();
        tfillBackType += tempType + "|";
        fillBackSource += tempSource + "|";
        fillBackValue += tempValue + "|";
        fillBackSourceList.add(tempSource);
        fillBackValueList.add(tempValue);
    });
    if (error == "error") {
        return "error";
    }

    if (${param.actionType eq 'distribution'}) { //分发
        if (!check("dataTable", "fromField", "toField", "", true, false, true, true)) {
            return "error";
        }
    } else if (${param.actionType eq 'gather'}) { //汇总
        if (!check("dataTable", "fromField", "toField", "", false, false, true, true)) {
            return "error";
        }
    } else if (${param.actionType eq 'bilateralgo'}) { //双向
        var error1 = "";
        $("tr", "#dataTable1").each(function() {
            var tempSource1 = $("#fromField1", $(this)).val();
            var tempValue1 = $("#toField1", $(this)).val();
            if (tempSource1 == "" && tempValue1 == "") {
                return true;
            }
            if (tempSource1 == "" || tempValue1 == "") {
                $.alert("${ctp:i18n('form.trigger.triggerSet.fillback.select.tocheck')}");
                error1 = "error";
                return false;
            }
            var tempType1 = $("#tfillBackType1", $(this)).val();
            tfillBackType1 += tempType1 + "|";
            fillBackSource1 += tempSource1 + "|";
            fillBackValue1 += tempValue1 + "|";
            fillBackSource1List.add(tempSource1);
            fillBackValue1List.add(tempValue1);
        });
        if (error1 == "error") {
            return "error";
        }
        if (!check("dataTable", "fromField", "toField", "${ctp:i18n('form.trigger.triggerSet.linkage.bilateralgo.label')}：", true, true, true, true)) {
            return "error";
        }
        if (tfillBackType == "" && tfillBackType1 != "") {
            $.alert($.i18n("form.trigger.triggerSet.linkage.fillback.type1.js"));
            return "error";
        }
        if (!fillBackSource1List.isEmpty()) {
            var hasSonToMain = false;//分发有从到主
            var hasSonToSon = false;//分发有从到从
            var hasMainToSon = false;//分发有主到从
            var hasSub2MainRelation = false;//是否有触发源拷贝到目标表关联源表的从表
            var subTableList = new ArrayList();//分发中出现的重复表
            for (var k = 0; k < fillBackSourceList.size(); k++) {
                var tempSource2 = srcFieldMap.get(fillBackSourceList.get(k));
                var tempValue2 = targetFieldMap.get(fillBackValueList.get(k));
                if (tempSource2.isMasterField == 'false') {
                    subTableList.addSingle(tempSource2.tableName);
                }
                if (tempValue2.isMasterField == 'false') {
                    subTableList.addSingle(tempValue2.tableName);
                }
                if (tempSource2.isMasterField == 'false' && tempValue2.isMasterField == 'true') {
                    hasSonToMain = true;
                    continue;
                }
                if (tempSource2.isMasterField == 'false' && tempValue2.isMasterField == 'false') {
                    hasSonToSon = true;
                    continue;
                }
                if (tempSource2.isMasterField == 'true' && tempValue2.isMasterField == 'false') {
                    hasMainToSon = true;
                    continue;
                }
                if(sub2MainRelationTo.indexOf(tempValue2.fieldName) > -1){
                    hasSub2MainRelation = true;
                    continue;
                }
            }

            var canSonToMain = false;//反馈允许从到主
            var canSonToSon = hasSonToSon;//反馈允许从到从
            var canMainToSon = hasSonToMain;//反馈允许主到从
            if ("${param.senderType}" == "SubField") {
                canMainToSon = true;
            }
            if (!check("dataTable1", "toField1", "fromField1", "${ctp:i18n('form.trigger.triggerSet.linkage.bilateralback.label')}：", false, canSonToMain, canSonToSon, canMainToSon)) {
                return "error";
            }
            for (var i = 0; i < fillBackSource1List.size(); i++) {
                var tempSource2 = srcFieldMap.get(fillBackSource1List.get(i));
                if (tempSource2.isMasterField == 'false' && !subTableList.contains(tempSource2.tableName)) {
                    $.alert($.i18n("form.trigger.triggerSet.linkage.fillback.type4.js", tempSource2.display));
                    return "error";
                }
                if (fillBackSourceList.contains(fillBackSource1List.get(i))) {
                    $.alert($.i18n("form.trigger.triggerSet.linkage.fillback.type2.js", tempSource2.display));
                    return "error";
                }
                //如果不存在触发源拷贝到目标表关联源表的从表，那么反馈的时候也不能设置触发源反馈到源表关联目标表的主表
                if(sub2MainRelationFrom.indexOf(tempSource2.fieldName) > -1 && !hasSub2MainRelation){
                    var msg = "${ctp:i18n('form.trigger.triggerSet.linkage.bilateralback.label')}：";
                    //您设置的从目标表单【触发源】拷贝到源表单【{0}】不正确，触发源不能拷贝到源表重复表关联目标表主表字段的控件中！
                    msg += $.i18n('form.trigger.triggerSet.fillback.maintoson.not.js1', tempSource2.display);
                    $.alert(msg);
                    return "error";
                }
            }
            for (var j = 0; j < fillBackValue1List.size(); j++) {
                var tempValue2 = targetFieldMap.get(fillBackValue1List.get(j));
                if (tempValue2.isMasterField == 'false' && !subTableList.contains(tempValue2.tableName)) {
                    $.alert($.i18n("form.trigger.triggerSet.linkage.fillback.type4.js", tempValue2.display));
                    return "error";
                }
                if (fillBackValueList.contains(fillBackValue1List.get(j))) {
                    $.alert($.i18n("form.trigger.triggerSet.linkage.fillback.type3.js", tempValue2.display));
                    return "error";
                }
            }
        }
    } else {
        if (!check("dataTable", "fromField", "toField", "", true, true, true, true)) {
            return "error";
        }
    }

    var result = new Array();
    result[0] = tfillBackType.substring(0, tfillBackType.length - 1);
    result[1] = fillBackSource.substring(0, fillBackSource.length - 1);
    result[2] = fillBackValue.substring(0, fillBackValue.length - 1);
    result[3] = tfillBackType1.substring(0, tfillBackType1.length - 1);
    result[4] = fillBackSource1.substring(0, fillBackSource1.length - 1);
    result[5] = fillBackValue1.substring(0, fillBackValue1.length - 1);
    return result;
}

/**
 * 
 * checkMainToMain 校验必须要有主到主
 * canSonToMain 允许从到主
 * canSonToSon 允许从到从
 * canMainToSon 允许主到从
 */
function check(checkArea, fromField, toField, prefix, checkMainToMain, canSonToMain, canSonToSon, canMainToSon) {
    var hasMainToMain = false; //必须要有主表到主表的拷贝

    var fieldTypeNotSame = new Array(); //字段类型不同

    var tarMultField = new Properties(); //临时装载目标表单字段，用于判断是否有重复
    var tarMultFieldName = new Array();
    
    var canSonToMainErr = new Array(); //重复表的字段不能拷贝到主表中
    var canSonToSonErr = new Array(); //重复表的字段不能拷贝到重复表中
    var canMainToSonErr = new Array(); //主表的字段不能拷贝到重复表中

    var srcFieldIsSonTable = new Properties(); //同一个从表的字段不能到不同的从表，不能同时到主表和从表中
    var srcFieldIsSonTableErr = new Array();

    var tarIsMasterSrcIsSon = new Properties(); //多个从表的字段不能到主表
    var tarIsMasterSrcIsSonErr = new Array();

    var tarSonAndNotSameSrcTable = new Properties(); //不同从表的字段不能到同一个从表中，源表字段是主表字段不考虑
    var tarSonAndNotSameSrcTableErr = new Array();

    //没有设置
    if ($("tr", "#" + checkArea).length == 1) {
        if ($("#" + fromField, "#" + checkArea).val() == "" && $("#" + toField, "#" + checkArea).val() == "") {
            return true;
        }
    }

    $("tr", "#" + checkArea).each(function() {
        var tempSource;
        var tempValue;
        if (fromField == "fromField") {
            tempSource = srcFieldMap.get($("#" + fromField, $(this)).val());
            tempValue = targetFieldMap.get($("#" + toField, $(this)).val());
        } else {
            tempSource = targetFieldMap.get($("#" + fromField, $(this)).val());
            tempValue = srcFieldMap.get($("#" + toField, $(this)).val());
        }
        if (!tempSource && !tempValue) {
            return true;
        }

        //必须要有主表到主表的拷贝
        if ((tempSource.isMasterField == 'source' || tempSource.isMasterField == 'true') && tempValue.isMasterField == 'true') {
            hasMainToMain = true;
        }

        //触发源可以拷贝到的控件类型
        if (tempSource.fieldName == "source") {
            if (fromField == "fromField") {
                if (needSourceField.indexOf(tempValue.fieldName) == -1) {
                    addErrMsg(tempSource, tempValue, fieldTypeNotSame, "source");
                    return false;
                }
                //分发/汇总不支持触发源拷贝到主关联从(从到主的拷贝)的字段中，借用sub2MainRelationTo来做判断
                else if(!canSonToMain && sub2MainRelationTo.indexOf(tempValue.fieldName) > -1){
                    addErrMsg(tempSource, tempValue, fieldTypeNotSame, "source-MainRelationSub");
                    return false;
                } else {
                    return true;
                }
            }else{//双向回触发源拷贝校验
                if (needBackField.indexOf(tempValue.fieldName) == -1) {
                    addErrMsg(tempSource, tempValue, fieldTypeNotSame, "source");
                    return false;
                } else {
                    return true;
                }
            }
        }

        //关联的表单不一致
        if (tempSource.relation && tempValue.relation) {
            if (tempSource.relation.isRelationForm == "true" && tempValue.relation.isRelationForm == "true") {
                if (tempSource.relation.toRelationObj != tempValue.relation.toRelationObj) {
                    addErrMsg(tempSource, tempValue, fieldTypeNotSame, "relation");
                    return false;
                }
            }
        }

        //目标显示格式为url页面，源没有，不允许设置
        if ("urlPage" == tempValue.formatType && "urlPage" != tempSource.formatType) {
            addErrMsg(tempSource, tempValue, fieldTypeNotSame, "formatType");
            return false;
        }

        //类型不一致
        if (tempValue.inputType == "outwrite" || tempValue.inputType == "externalwrite-ahead" || tempSource.inputType == "outwrite" || tempSource.inputType == "externalwrite-ahead") {
            if (tempSource.fieldType != tempValue.fieldType) {
                addErrMsg(tempSource, tempValue, fieldTypeNotSame, "fieldType");
                return false;
            }
        } else if (tempSource.inputType == "select" || tempSource.inputType == "radio") {
            if (tempValue.inputType == "select" || tempValue.inputType == "radio") {
                if (tempSource.enumId != tempValue.enumId) {
                    addErrMsg(tempSource, tempValue, fieldTypeNotSame, "enumId");
                    return false;
                }
            } else {
                addErrMsg(tempSource, tempValue, fieldTypeNotSame, "inputType");
                return false;
            }
        } else if (tempSource.inputType == "label" || tempSource.inputType == "textarea" || tempSource.inputType == "text" || tempSource.inputType == "outwrite" || tempSource.inputType == "externalwrite-ahead") {
            if (tempValue.inputType == "label" || tempValue.inputType == "textarea" || tempValue.inputType == "text") {
                if (tempSource.fieldType != tempValue.fieldType) {
                    addErrMsg(tempSource, tempValue, fieldTypeNotSame, "fieldType");
                    return false;
                }
            } else {
                addErrMsg(tempSource, tempValue, fieldTypeNotSame, "inputType");
                return false;
            }
        } else if (tempSource.inputType == "relationform" || tempSource.inputType == "relation") {
            if (tempSource.fieldType != tempValue.fieldType) {
                addErrMsg(tempSource, tempValue, fieldTypeNotSame, "fieldType");
                return false;
            }
        } else if (tempSource.inputType == "flowdealoption") {
            if (tempValue.inputType != "textarea") {
                addErrMsg(tempSource, tempValue, fieldTypeNotSame, "flowdealoption");
                return false;
            }
        }else if(tempSource.inputType == "barcode"){
            //二维码触发，联动都写到图片中
            if(tempValue.inputType != "image"){
                addErrMsg(tempSource, tempValue, fieldTypeNotSame, "barcodeToImage");
                return false;
            }
        } else {
            if (tempSource.inputType != tempValue.inputType) {
                addErrMsg(tempSource, tempValue, fieldTypeNotSame, "inputType");
                return false;
            }
            
            //V-Join
            if (tempSource.externalType != tempValue.externalType) {
                addErrMsg(tempSource, tempValue, fieldTypeNotSame, "inputType");
                return false;
            }
        }

        //文本长度
        if (tempSource.fieldType == "VARCHAR" && tempSource.inputType != "flowdealoption") {
            var length1 = parseInt(tempSource.length);
            var length2 = parseInt(tempValue.length);
            if (length1 > length2) {
                addErrMsg(tempSource, tempValue, fieldTypeNotSame, "length");
                return false;
            }
        }

        //数字长度
        if (tempSource.fieldType == "DECIMAL") {
            var length1 = parseInt(tempSource.digitNum);
            var length2 = parseInt(tempValue.digitNum);
            if (length1 != length2) {
                addErrMsg(tempSource, tempValue, fieldTypeNotSame, "decimal");
                return false;
            }
        }

        //目标表字段重复
        if (tarMultField.containsKey(tempValue.fieldName)) {
            tarMultFieldName[tarMultFieldName.length] = tempValue.display;
            return false;
        } else {
            tarMultField.put(tempValue.fieldName, tempValue.fieldName);
        }

        //同一个从表的字段不能到不同的从表，不能同时到主表和从表中
        if (tempSource.isMasterField == 'false') {
            if (srcFieldIsSonTable.containsKey(tempSource.tableName)) {
                if (srcFieldIsSonTable.get(tempSource.tableName) != tempValue.tableName) {
                    addErrMsg(tempSource, tempValue, srcFieldIsSonTableErr);
                    return false;
                }
            } else {
                srcFieldIsSonTable.put(tempSource.tableName, tempValue.tableName);
            }
        }

        //多个从表的字段不能到主表
        if (tempSource.isMasterField == 'false' && tempValue.isMasterField == 'true') {
            if (!canSonToMain) {
                addErrMsg(tempSource, tempValue, canSonToMainErr);
                return false;
            }
            if (tarIsMasterSrcIsSon.containsKey(tempValue.tableName)) {
                if (tarIsMasterSrcIsSon.get(tempValue.tableName) != tempSource.tableName) {
                    addErrMsg(tempSource, tempValue, tarIsMasterSrcIsSonErr);
                    return false;
                }
            } else {
                tarIsMasterSrcIsSon.put(tempValue.tableName, tempSource.tableName);
            }
        }

        //不同从表的字段不能到同一个从表中，源表字段是主表字段不考虑
        if (tempSource.isMasterField == 'false' && tempValue.isMasterField == 'false') {
            if (!canSonToSon) {
                addErrMsg(tempSource, tempValue, canSonToSonErr);
                return false;
            }
            if (tarSonAndNotSameSrcTable.containsKey(tempValue.tableName)) {
                if (tarSonAndNotSameSrcTable.get(tempValue.tableName) != tempSource.tableName) {
                    addErrMsg(tempSource, tempValue, tarSonAndNotSameSrcTableErr);
                    return false;
                }
            } else {
                tarSonAndNotSameSrcTable.put(tempValue.tableName, tempSource.tableName);
            }
        }
        
        //主表的字段不能到从表
        if (tempSource.isMasterField == 'true' && tempValue.isMasterField == 'false') {
            if (!canMainToSon) {
                addErrMsg(tempSource, tempValue, canMainToSonErr);
                return false;
            }
        }
    });

    var errorFrom;
    var errorTo;
    if (fromField == "fromField") {
        errorFrom = "${ctp:i18n('form.source.label')}";
        errorTo = "${ctp:i18n('form.target.label')}";
    } else {
        errorFrom = "${ctp:i18n('form.target.label')}";
        errorTo = "${ctp:i18n('form.source.label')}";
    }
    
    if (fieldTypeNotSame.length > 0) {
        var f1;
        var f2;
        if (fromField == "fromField") {
            f1 = getFieldByDisplay(fieldTypeNotSame[0][0], srcFieldMap);
            f2 = getFieldByDisplay(fieldTypeNotSame[0][1], targetFieldMap);
        } else {
            f1 = getFieldByDisplay(fieldTypeNotSame[0][0], targetFieldMap);
            f2 = getFieldByDisplay(fieldTypeNotSame[0][1], srcFieldMap);
        }
        var type = "${ctp:i18n('form.trigger.triggerSet.fillback.type1')}";
        var aStr = $.i18n('form.trigger.triggerSet.fillback.notsamedatatype', fieldTypeNotSame[0][0], type, f1.showFieldType, fieldTypeNotSame[0][1], type, f2.showFieldType, type, errorFrom, errorTo);

        if ("inputType" == fieldTypeNotSame[0][2]) {
            type = "${ctp:i18n('form.trigger.triggerSet.fillback.type2')}";
            aStr = $.i18n('form.trigger.triggerSet.fillback.notsamedatatype', fieldTypeNotSame[0][0], type, f1.showInputType, fieldTypeNotSame[0][1], type, f2.showInputType, type, errorFrom, errorTo);
        } else if ("enumId" == fieldTypeNotSame[0][2]) {
            type = "${ctp:i18n('form.trigger.triggerSet.fillback.type3')}";
            aStr = $.i18n('form.trigger.triggerSet.fillback.notsameenumtype', fieldTypeNotSame[0][0], fieldTypeNotSame[0][1], errorFrom, errorTo);
        } else if ("length" == fieldTypeNotSame[0][2]) {
            type = "${ctp:i18n('form.trigger.triggerSet.fillback.type4')}";
            aStr = $.i18n('form.trigger.triggerSet.fillback.notsamedatatype', fieldTypeNotSame[0][0], type, f1.length, fieldTypeNotSame[0][1], type, f2.length, type, errorFrom, errorTo);
        } else if ("decimal" == fieldTypeNotSame[0][2]) {
            type = "${ctp:i18n('form.trigger.triggerSet.fillback.type5')}";
            aStr = $.i18n('form.trigger.triggerSet.fillback.notsamedatatype', fieldTypeNotSame[0][0], type, f1.digitNum, fieldTypeNotSame[0][1], type, f2.digitNum, type, errorFrom, errorTo);
        } else if ("relation" == fieldTypeNotSame[0][2]) {
            aStr = $.i18n('form.trigger.triggerSet.fillback.relationform', fieldTypeNotSame[0][0], fieldTypeNotSame[0][1], errorFrom, errorTo);
        } else if ("flowdealoption" == fieldTypeNotSame[0][2]) {
            aStr = "流程意见控件类型只能拷贝到文本域类型字段中，请修正！";
        } else if ("source" == fieldTypeNotSame[0][2]) {
            if (fromFormBeanType == "1") {
                //您设置的从{1}【触发源】拷贝到{2}【{0}】不正确，触发源只能拷贝到{3}中将此{4}作为选择关联表单的控件中,关联文档控件中，请修正
                aStr = $.i18n('form.trigger.triggerSet.fillback.source.copy.flow1', fieldTypeNotSame[0][1], errorFrom, errorTo, errorTo, errorFrom);
            } else {
                if (fromField == "fromField") {
                    //您设置的从{1}【触发源】拷贝到{2}【{0}】不正确，触发源只能拷贝到{3}中将此{4}作为选择关联表单的控件中，请修正
                    aStr = $.i18n('form.trigger.triggerSet.fillback.source.copy1', fieldTypeNotSame[0][1], errorFrom, errorTo, errorTo, errorFrom);
                }else{
                    //双向回触发源拷贝校验失败
                    //您设置的从{1}【触发源】拷贝到{2}【{0}】不正确，触发源只能拷贝到{3}中将此{4}作为选择关联表单的控件中(不支持主表关联重复表字段)，请修正
                    aStr = $.i18n('form.trigger.triggerSet.fillback.sourceback.copy', fieldTypeNotSame[0][1], errorFrom, errorTo, errorTo, errorFrom);
                }
            }
        } else if ("source-MainRelationSub" == fieldTypeNotSame[0][2]) {//分发/汇总不支持触发源拷贝到主关联从(从到主的拷贝)的字段中
            //您设置的从源表单【触发源】拷贝到目标表单【{0}】不正确，触发源不能拷贝到目标表主表关联源表重复表字段的控件中，请修正
            aStr = $.i18n('form.trigger.triggerSet.fillback.source.copy2', fieldTypeNotSame[0][1]);
        } else if ("formatType" == fieldTypeNotSame[0][2]){
            type = "${ctp:i18n("form.input.displayformat.label")}";

            aStr = $.i18n('form.trigger.triggerSet.fillback.notsamedatatype', fieldTypeNotSame[0][0], type, getFormtTypeName(f1.formatType), fieldTypeNotSame[0][1], type, getFormtTypeName(f2.formatType), type, errorFrom, errorTo);
        } else if("barcodeToImage" == fieldTypeNotSame[0][2]){
            aStr = $.i18n('form.barcode.copy.to.image.tips', fieldTypeNotSame[0][0],f1.showInputType, fieldTypeNotSame[0][1],f2.showInputType, errorFrom, errorTo);
        }
        $.alert(prefix + aStr);
        return false;
    }

    if (tarMultFieldName.length > 0) {
        $.alert(prefix + $.i18n('form.trigger.triggerSet.fillback.notsamevalue', tarMultFieldName[0]));
        return false;
    }
    if (canSonToMainErr.length > 0) {
        $.alert(prefix + $.i18n('form.trigger.triggerSet.fillback.sontomain.not.js', canSonToMainErr[0][0], canSonToMainErr[0][1], errorFrom, errorTo));
        return false;
    }
    if (canSonToSonErr.length > 0) {
        $.alert(prefix + $.i18n('form.trigger.triggerSet.fillback.sontoson.not.js', canSonToSonErr[0][0], canSonToSonErr[0][1], errorFrom, errorTo));
        return false;
    }
    if (canMainToSonErr.length > 0) {
        $.alert(prefix + $.i18n('form.trigger.triggerSet.fillback.maintoson.not.js', canMainToSonErr[0][0], canMainToSonErr[0][1], errorFrom, errorTo));
        return false;
    }
    if (srcFieldIsSonTableErr.length > 0) {
        $.alert(prefix + $.i18n('form.trigger.triggerSet.fillback.notsamerepeattable', srcFieldIsSonTableErr[0][0], srcFieldIsSonTableErr[0][1], errorFrom, errorTo));
        return false;
    }
    if (tarIsMasterSrcIsSonErr.length > 0) {
        $.alert(prefix + $.i18n('form.trigger.triggerSet.fillback.sontomain', tarIsMasterSrcIsSonErr[0][0], tarIsMasterSrcIsSonErr[0][1], errorFrom, errorTo));
        return false;
    }
    if (tarSonAndNotSameSrcTableErr.length > 0) {
        $.alert(prefix + $.i18n('form.trigger.triggerSet.fillback.notsametable', tarSonAndNotSameSrcTableErr[0][0], tarSonAndNotSameSrcTableErr[0][1], errorFrom, errorTo));
        return false;
    }
    if (checkMainToMain && !hasMainToMain) {
        $.alert(prefix + "${ctp:i18n('form.trigger.triggerSet.fillback.maintomain')}");
        return false;
    }
    return true;
}

function getFormtTypeName(key) {
    var srcFormatType = key;
    if (srcFormatType) {
        srcFormatType = $.i18n(formatTypeMap.get(srcFormatType));
    } else {
        srcFormatType = "无";
    }
    return srcFormatType;
}

function addErrMsg(tempSource, tempValue, errArray, type) {
    var temArray = new Array();
    temArray[0] = tempSource.display;
    temArray[1] = tempValue.display;
    if (type) {
        temArray[2] = type;
    }
    errArray[errArray.length] = temArray;
}

function field(fieldName, display, tableName, isMasterField, fieldType, inputType, enumId, showInputType, showFieldType, length, digitNum, formatType, externalType) {
    this.fieldName = fieldName;
    this.display = display;
    this.tableName = tableName;
    this.isMasterField = isMasterField;
    this.fieldType = fieldType;
    this.inputType = inputType;
    this.enumId = enumId;
    this.showInputType = showInputType;
    this.showFieldType = showFieldType;
    this.length = length;
    this.digitNum = digitNum;
    this.formatType = formatType;
    this.externalType = externalType;
}

function relation(toRelationObj, toRelationAttrType, isRelationForm) {
    this.toRelationObj = toRelationObj;
    this.toRelationAttrType = toRelationAttrType;
    this.isRelationForm = isRelationForm;
}

function getFieldByDisplay(displayName, m) {
    var ss = m.entrySet();
    for (var s = 0; s < ss.length; s++) {
        var f = ss[s].value;
        if (f != null && f.display == displayName) {
            return f;
        }
    }
    return null;
}
var formatTypeMap = new Properties();
formatTypeMap.put("urlPage","form.input.format.urlpage.label");
var srcFieldMap = new Properties(); //源表单
var temField;
<c:if test="${needSource}">
    temField = new field('source', '${ctp:i18n("form.trigger.triggerSet.fillback.source")}', 'source', 'source', 'source', 'source', 'source', 'source', 'source', 'source', 'source');
    srcFieldMap.put('source.source', temField);
</c:if>
<c:forEach items="${fromFormFields}" var="field">
    temField = new field('${field.name}', '${field.display}', '${field.ownerTableName }', '${field.masterField }', '${field.fieldType}', '${field.inputType }', '${field.enumId }${field.enumLevel }', '${field.extraMap.showInputType}', '${field.extraMap.showFieldType}', '${field.fieldLength }', '${field.digitNum }', '${field.formatType}', '${field.externalType}');
    <c:if test = "${field.formRelation ne null}">
        temField.relation = new relation('${field.formRelation.toRelationObj}', '${field.formRelation.toRelationAttrType}', "${field.formRelation.formRelation}");
    </c:if>
    srcFieldMap.put('${field.ownerTableName }' + '.' + '${field.name}', temField);
</c:forEach>

var targetFieldMap = new Properties(); //目标表单
<c:if test="${needSource}">
    temField = new field('source', '${ctp:i18n("form.trigger.triggerSet.fillback.source")}', 'source', 'source', 'source', 'source', 'source', 'source', 'source', 'source', 'source');
    targetFieldMap.put('source.source', temField);
</c:if>
<c:forEach items="${toFormFields}" var="field">
    temField = new field('${field.name}', '${field.display}', '${field.ownerTableName }', '${field.masterField }', '${field.fieldType}', '${field.inputType }', '${field.enumId }${field.enumLevel }', '${field.extraMap.showInputType}', '${field.extraMap.showFieldType}', '${field.fieldLength }', '${field.digitNum }', '${field.formatType}', '${field.externalType}');
    <c:if test = "${field.formRelation ne null}">
        temField.relation = new relation("${field.formRelation.toRelationObj}", "${field.formRelation.toRelationAttrType}", "${field.formRelation.formRelation}");
    </c:if>
    targetFieldMap.put('${field.ownerTableName }' + '.' + '${field.name}', temField);
</c:forEach>
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body class="over_hidden font_size12">
    <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
        <tr height="5">
            <td></td>
        </tr>
        <tr>
            <td>
                <fieldset class="form_area padding_5 margin_t_5 margin_lr_10">
                    <c:if test="${not empty param.actionType}">
                        <c:set var="legendLabel" value="form.trigger.triggerSet.linkage.${param.actionType}.label" />
                    </c:if>
                    <c:if test="${empty param.actionType}">
                        <c:set var="legendLabel" value="form.trigger.triggerSet.copy.label" />
                    </c:if>
                    <legend>&nbsp;${ctp:i18n(legendLabel)}&nbsp;</legend>
                    <div style="height: 30px;overflow: hidden;">
                        <table width="530" border="0" cellspacing="0" cellpadding="0" align="center" style=" table-layout:fixed;">
                            <tr>
                                <td align="left" width="50%" style="overflow:hidden;" title="${fromFormBean.formName}">${ctp:i18n('form.source.label')}：${ctp:getLimitLengthString(fromFormBean.formName, 20, '...')}</td>
                                <td align="left" width="50%" title="${toFormBean.formName}">${ctp:i18n('form.target.label')}：${ctp:getLimitLengthString(toFormBean.formName, 20, '...')}</td>
                            </tr>
                            <tr height="5">
                                <td colspan="2">
                                    <hr align="center" width="530" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div style="<c:if test='${param.actionType eq \"bilateralgo\"}'>height: 230px</c:if><c:if test='${param.actionType ne \"bilateralgo\"}'>height: 350px</c:if>;overflow: auto;margin-left:28px;">
                        <table id="dataTable" border="0" cellspacing="0" cellpadding="0" width="530" align="center" style="float:left;overflow: auto;">
                            <tr height="22" style="margin-top: 5px;">
                                <td width="35%" height="20" class="source">
                                    <div  id="sourceTD" style="margin-top: 5px;">
                                        <select style="width: 180px;margin-top: 5px;" id="fromField" name="fromField" onchange="" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
                                            <option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
                                            <c:if test="${needSource}">
                                                <option value="source.source">${ctp:i18n("form.trigger.triggerSet.fillback.source")}</option>
                                            </c:if>
                                            <c:forEach items="${fromFormFields}" var="field">
                                                <option value="${field.ownerTableName}.${field.name}" tablename="${field.ownerTableName}" inputtype="${field.inputType}" fieldtype="${field.fieldType}" title="${field.display}" isMaster="${field.masterField}"><c:if test="${field.masterField && field.name ne 'flowFormContent'}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!field.masterField}">[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex}]</c:if>${field.display}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </td>
                                <td width="15%">
                                    <input type="hidden" id="tfillBackType" value="copy">-----&gt;
                                </td>
                                <td width="35%" class="target">
                                    <div id="targetTD"  style="margin-top: 5px;">
                                        <select style="width: 180px;margin-top: 5px;" id="toField" name="toField" onchange="" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
                                            <option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
                                            <c:forEach items="${toFormFields}" var="field">
                                                <option value="${field.ownerTableName}.${field.name}" tablename="${field.ownerTableName}" inputtype="${field.inputType}" fieldtype="${field.fieldType}" title="${field.display}" isMaster="${field.masterField}"><c:if test="${field.masterField}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!field.masterField}">[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex}]</c:if>${field.display}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </td>
                                <td width="15%">
                                    <span id="del" class="ico16 revoked_process_16 repeater_reduce_16" style="float:left;"></span>
                                    <span id="add" class="ico16 repeater_plus_16" style="float:left;"></span>
                                </td>
                            </tr>
                        </table>
                    </div>
                </fieldset>
                <c:if test="${param.actionType eq 'bilateralgo'}">
                    <fieldset class="form_area padding_5 margin_t_5 margin_lr_10">
                        <legend>${ctp:i18n('form.trigger.triggerSet.linkage.bilateralback.label')}</legend>
                        <div style="height: 30px;overflow: hidden;">
                            <table border="0" cellspacing="0" cellpadding="0" width="530" align="center" style="table-layout:fixed;">
                                <tr>
                                    <td align="left" width="50%" title="${fromFormBean.formName}">${ctp:i18n('form.source.label')}：${ctp:getLimitLengthString(fromFormBean.formName, 20, '...')}</td>
                                    <td align="left" width="50%" title="${toFormBean.formName}">${ctp:i18n('form.target.label')}：${ctp:getLimitLengthString(toFormBean.formName, 20, '...')}</td>
                                </tr>
                                <tr height="5">
                                    <td colspan="6">
                                        <hr align="center" width="530" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div style="height: 125px;overflow: auto;margin-left:28px;">
                            <table id="dataTable1" border="0" cellspacing="0" cellpadding="0" width="530" align="center" style="float:left;overflow: auto;">
                                <tr height="22">
                                    <td width="35%" height="20" >
                                        <div id="sourceTD1" style="margin-top: 5px;">
                                        <select style="width: 180px;margin-top: 5px;" id="fromField1" name="fromField1" onchange="" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
                                            <option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
                                            <c:forEach items="${fromFormFields}" var="field">
                                                <option value="${field.ownerTableName}.${field.name}" tablename="${field.ownerTableName}" inputtype="${field.inputType}" fieldtype="${field.fieldType}" title="${field.display}" isMaster="${field.masterField}"><c:if test="${field.masterField && field.name ne 'flowFormContent'}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!field.masterField}">[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex}]</c:if>${field.display}</option>
                                            </c:forEach>
                                        </select>
                                        </div>
                                    </td>
                                    <td width="15%">
                                        <input type="hidden" id="tfillBackType1" value="copy">&nbsp;&lt;-----
                                    </td>
                                    <td width="35%" >
                                        <div id="targetTD1" style="margin-top: 5px;">
                                        <select style="width: 180px;margin-top: 5px;" id="toField1" name="toField1" onchange="" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
                                            <option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
                                            <c:if test="${needSource}">
                                                <option value="source.source">${ctp:i18n("form.trigger.triggerSet.fillback.source")}</option>
                                            </c:if>
                                            <c:forEach items="${toFormFields}" var="field">
                                                <option value="${field.ownerTableName}.${field.name}" tablename="${field.ownerTableName}" inputtype="${field.inputType}" fieldtype="${field.fieldType}" title="${field.display}" isMaster="${field.masterField}"><c:if test="${field.masterField}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!field.masterField}">[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex}]</c:if>${field.display}</option>
                                            </c:forEach>
                                        </select>
                                        </div>
                                    </td>
                                    <td width="15%">
                                        <span id="del1" class="ico16 revoked_process_16 repeater_reduce_16" style="float:left;"></span>
                                        <span id="add1" class="ico16 repeater_plus_16" style="float:left;"></span>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </fieldset>
                </c:if>
                <div class="align_left margin_l_5 margin_b_5 margin_t_5">
                    <a id="btnreset" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('common.button.reset.label')}</a>
                </div>
            </td>
        </tr>
    </table>
<div id="hiddenArea" class="hidden">
    <textarea id="fromField_bak">
        <select style="width: 180px;margin-top: 5px;" id="fromField" name="fromField" onchange="" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
            <option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
            <c:if test="${needSource}">
                <option value="source.source">${ctp:i18n("form.trigger.triggerSet.fillback.source")}</option>
            </c:if>
            <c:forEach items="${fromFormFields}" var="field">
                <option value="${field.ownerTableName}.${field.name}" tablename="${field.ownerTableName}" inputtype="${field.inputType}" fieldtype="${field.fieldType}" title="${field.display}" isMaster="${field.masterField}"><c:if test="${field.masterField && field.name ne 'flowFormContent'}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!field.masterField}">[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex}]</c:if>${field.display}</option>
            </c:forEach>
        </select>
    </textarea>
    <textarea id="fromField_bak1">
        <select style="width: 180px;margin-top: 5px;" id="fromField1" name="fromField" onchange="" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
            <option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
            <c:forEach items="${fromFormFields}" var="field">
                <option value="${field.ownerTableName}.${field.name}" tablename="${field.ownerTableName}" inputtype="${field.inputType}" fieldtype="${field.fieldType}" title="${field.display}" isMaster="${field.masterField}"><c:if test="${field.masterField && field.name ne 'flowFormContent'}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!field.masterField}">[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex}]</c:if>${field.display}</option>
            </c:forEach>
        </select>
    </textarea>
    <textarea id="toField_bak">
        <select style="width: 180px;margin-top: 5px;" id="toField" name="toField" onchange="" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
            <option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
            <c:forEach items="${toFormFields}" var="field">
                <option value="${field.ownerTableName}.${field.name}" tablename="${field.ownerTableName}" inputtype="${field.inputType}" fieldtype="${field.fieldType}" title="${field.display}" isMaster="${field.masterField}"><c:if test="${field.masterField}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!field.masterField}">[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex}]</c:if>${field.display}</option>
            </c:forEach>
        </select>
    </textarea>
    <textarea id="toField_bak1">
        <select style="width: 180px;margin-top: 5px;" id="toField1" name="toField" onchange="" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
            <option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
            <c:if test="${needSource}">
                <option value="source.source">${ctp:i18n("form.trigger.triggerSet.fillback.source")}</option>
            </c:if>
            <c:forEach items="${toFormFields}" var="field">
                <option value="${field.ownerTableName}.${field.name}" tablename="${field.ownerTableName}" inputtype="${field.inputType}" fieldtype="${field.fieldType}" title="${field.display}" isMaster="${field.masterField}"><c:if test="${field.masterField}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!field.masterField}">[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex}]</c:if>${field.display}</option>
            </c:forEach>
        </select>
    </textarea>
</div>
</body>
</html>