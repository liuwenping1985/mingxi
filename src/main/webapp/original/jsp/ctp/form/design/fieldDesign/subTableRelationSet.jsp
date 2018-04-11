<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%">
<head>
<script type="text/javascript">
var formBeanType = "${formBean.formType}";
var needSourceField = "${needSourceField}";

$(document).ready(function() {
    $("#add").click(function() {
        add(this);
    });

    $("#del").click(function() {
        del(this);
    });
    resetData();
});

function resetData() {
    var relationStr = $("#relations",window.dialogArguments.document).val();
    if(relationStr != "") {
        var relations = $.parseJSON(relationStr);
        //var relations = eval("("+relationStr+")");
        if(relations && relations.length > 0) {
            resetDatas(relations);
        }
    }
}

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
    $("#add", cloneObj).unbind("click").bind("click", function() {
        add(this);
    });
    $("#del", cloneObj).unbind("click").bind("click", function() {
        del(this);
    });
    $("#fromField, #fromField1", cloneObj).val("");
    $("#toField, #toField1", cloneObj).val("");
    $("#relationStr",cloneObj).val("");
    $("#fromFieldNameStr",cloneObj).val("");
    $("#fromFieldDisplayStr",cloneObj).val("");
    $("#toFieldNameStr",cloneObj).val("");
    $("#toFieldDisplayStr",cloneObj).val("");
    $("#fillBackKey",cloneObj).val("");
    $("#fillBackValue",cloneObj).val("");
    cloneObj.insertAfter(currentTr);
    cloneObj.comp();
}

function addTd(obj) {
    var currentTd = $(obj).parents("tr:eq(0)").find("td:eq(2)");
    var cloneObj = $.ctpClone(currentTd);
    var target = $("#toField_bak").val();
    var target1 = $("#toField_bak1").val();
    $("#targetTD", cloneObj).html(target);
    $("#targetTD1", cloneObj).html(target1);
    $("#add", cloneObj).unbind("click").bind("click", function() {
        add(this);
    });
    $("#del", cloneObj).unbind("click").bind("click", function() {
        del(this);
    });
    //$("#fromField, #fromField1", cloneObj).val("");
    $("#toField, #toField1", cloneObj).val("");
    cloneObj.insertAfter(currentTd);
    currentTd.remove();
    cloneObj.comp();
}

function del(obj) {
    var currentTable = $(obj).parents("table:eq(0)");
    if ($("tr", currentTable).length <= 1) {
        /*$("#fromField, #fromField1", currentTable).val("");
        $("#toField, #toField1", currentTable).val("");
        return;*/
        add(obj);
    }
    var currentTr = $(obj).parents("tr:eq(0)");
    currentTr.remove();
}

function resetDatas(relations) {
    var source = $("#fromField_bak").val();
    var target = $("#toField_bak").val();
    for(var i=0;i<relations.length;i++) {
        var cTr;
        var cloneTr;
        var dataTableb = $("#dataTable");
        if (i == 0) {
            if ($("tr", dataTableb).length > 1) {
                $("tr", dataTableb).each(function (index) {
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
        $("#sourceTD", cTr).html(source);
        $("#targetTD", cTr).html(target);
        $("#fromField", cTr).val(relations[i].fromTable);
        $("#toField", cTr).val(relations[i].toTable);
        $("#fromFieldNameStr", cTr).val(relations[i].fromFieldNameStr);
        $("#fromFieldDisplayStr", cTr).val(relations[i].fromFieldDisplayStr);
        $("#toFieldNameStr", cTr).val(relations[i].toFieldNameStr);
        $("#toFieldDisplayStr", cTr).val(relations[i].toFieldDisplayStr);
        $("#fillBackKey", cTr).val(relations[i].fillBackKey);
        $("#fillBackValue", cTr).val(relations[i].fillBackValue);
        cTr.comp();
    }
}

function OK() {
    var returnValue = new Array();
    var unfinished = false;
    var n = 0;
    $("tr", "#dataTable").each(function() {
        var fromField = $("#fromField", $(this)).val();
        var toField = $("#toField", $(this)).val();
//        if (fromField === "" && toField === "") {
//            return true;
//        }
        if (fromField == "" || toField == "") {
            return true;
        }
        if(fromField != "" && toField != "") {
            var fromFieldNameStr = $("#fromFieldNameStr", $(this)).val();
            var fromFieldDisplayStr = $("#fromFieldDisplayStr", $(this)).val();
            var toFieldNameStr = $("#toFieldNameStr", $(this)).val();
            var toFieldDisplayStr = $("#toFieldDisplayStr", $(this)).val();
            var fillBackKey = $("#fillBackKey", $(this)).val();
            var fillBackValue = $("#fillBackValue", $(this)).val();
            if(fromFieldNameStr=="" || fromFieldDisplayStr=="" || toFieldNameStr=="" || toFieldDisplayStr=="" || fillBackKey=="" || fillBackValue==""){
                unfinished = true;
                return false;
            }
            returnValue[n] = {"fromTable":fromField,
                "toTable":toField,
                "fromFieldNameStr":fromFieldNameStr,
                "fromFieldDisplayStr":fromFieldDisplayStr,
                "toFieldNameStr":toFieldNameStr,
                "toFieldDisplayStr":toFieldDisplayStr,
                "fillBackKey":fillBackKey,
                "fillBackValue":fillBackValue
            };
            n ++;
        }
    });
    if(unfinished) {
        $.alert("${ctp:i18n('form.baseinfo.subtable.relation.relatiosettingunfinised.alert')}");
        return;
    }
    return returnValue;
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
            if (needSourceField.indexOf(tempValue.fieldName) == -1) {
                addErrMsg(tempSource, tempValue, fieldTypeNotSame, "source");
                return false;
            } else {
                return true;
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
        } else {
            if (tempSource.inputType != tempValue.inputType) {
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
            aStr = $.i18n('form.trigger.triggerSet.fillback.relationform', fieldTypeNotSame[0][0], fieldTypeNotSame[0][1]);
        } else if ("flowdealoption" == fieldTypeNotSame[0][2]) {
            aStr = "流程意见控件类型只能拷贝到文本域类型字段中，请修正！";
        } else if ("source" == fieldTypeNotSame[0][2]) {
            if (formBeanType == "1") {
                aStr = "${ctp:i18n('form.trigger.triggerSet.fillback.source.copy.flow')}";
            } else {
                aStr = "${ctp:i18n('form.trigger.triggerSet.fillback.source.copy')}";
            }
        } else if ("formatType" == fieldTypeNotSame[0][2]){
            type = "${ctp:i18n("form.input.displayformat.label")}";

            aStr = $.i18n('form.trigger.triggerSet.fillback.notsamedatatype', fieldTypeNotSame[0][0], type, getFormtTypeName(f1.formatType), fieldTypeNotSame[0][1], type, getFormtTypeName(f2.formatType), type, errorFrom, errorTo);
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

function field(fieldName, display, tableName, isMasterField, fieldType, inputType, enumId, showInputType, showFieldType, length, digitNum,formatType) {
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

/**
*验证重复表间关系
* @param obj
 */
function validateRelation(obj) {
    var fromSub = $(obj).parents("tr:eq(0)").find("#fromField");
    var toSub = $(obj).parents("tr:eq(0)").find("#toField");
    if(fromSub.val() != "" && toSub.val() != "") {
        if (fromSub.val() == toSub.val()) {// || $("#fromField :selected[value='" + toSub.val() + "']", $(obj).parents("#dataTable")).length > 1
            $.alert("${ctp:i18n('form.baseinfo.subtable.relation.selectederror.alert')}");
            addTd(toSub);
            return;
        }
        var rightEqLenth = $("#toField :selected[value='" + toSub.val() + "']", $(obj).parents("#dataTable")).length;
        if (rightEqLenth > 1) {
            $.alert("${ctp:i18n('form.baseinfo.subtable.relation.selectedduplicate.alert')}");
            addTd(toSub);
            return;
        }
        var fromSelected = $("#fromField :selected", $(obj).parents("#dataTable"));
        if(fromSelected.length > 1) {
            if(fromSelected.val() == toSub.val()) {
                $.alert("${ctp:i18n('form.baseinfo.subtable.relation.selecteddead.alert')}");
                addTd(toSub);
                return;
            }
        }
        /*$("#fromField :selected", $(obj).parents("#dataTable")).each(function(obj){
            alert(obj+'---'+$(this).val());
        });*/
    }
    var thisObj = $(obj).parents("tr:eq(0)");
    thisObj.find("#fromFieldNameStr").val("");
    thisObj.find("#fromFieldDisplayStr").val("");
    thisObj.find("#toFieldNameStr").val("");
    thisObj.find("#toFieldDisplayStr").val("");
    thisObj.find("#fillBackKey").val("");
    thisObj.find("#fillBackValue").val("");
}

function setRelation(obj) {
    var thisObj = $(obj).parents("tr:eq(0)");
    var fromSub = thisObj.find("#fromField");
    var toSub = thisObj.find("#toField");
    if(fromSub.val() == "" || toSub.val() == "") {
        $.alert("${ctp:i18n('form.baseinfo.subtable.relation.createfirst.alert')}");
        return;
    }
    var params = {
        "fromFieldName":thisObj.find("#fromFieldNameStr").val(),
        "fromFieldDisplay":thisObj.find("#fromFieldDisplayStr").val(),
        "toFieldName":thisObj.find("#toFieldNameStr").val(),
        "toFieldDisplay":thisObj.find("#toFieldDisplayStr").val(),
        "fillBackKey":thisObj.find("#fillBackKey").val(),
        "fillBackValue":thisObj.find("#fillBackValue").val()
    };
    dialog = $.dialog({
        url:_ctxPath + "/form/fieldDesign.do?method=subTableRelationSet&step=2&fromSub="+fromSub.val()+"&toSub="+toSub.val(),
        title : $.i18n('form.baseinfo.subtable.relation.data.setting.title'),
        transParams:params,
        targetWindow:getCtpTop(),
        width:610,
        height:550,
        buttons : [ {
            text : $.i18n('form.trigger.triggerSet.confirm.label'),
            id:"sure",
            isEmphasize: true,
            handler : function() {
                var rv=dialog.getReturnValue();
                if(typeof rv != "undefined"){
                    var relations = rv[0].relation;
                    var formulas = rv[1].formula;
                    var fromFieldName="";
                    var fromFieldDisplay = "";
                    var toFieldName="";
                    var toFieldDisplay = "";
                    for ( var i = 0; i < relations.length; i++) {
                        if(i==relations.length-1){
                            fromFieldName += relations[i].fromFieldName;
                            fromFieldDisplay += relations[i].fromFieldDisplay;
                            toFieldName += relations[i].toFieldName;
                            toFieldDisplay += relations[i].toFieldDisplay;
                        }else{
                            fromFieldName += relations[i].fromFieldName+",";
                            fromFieldDisplay += relations[i].fromFieldDisplay+",";
                            toFieldName += relations[i].toFieldName+",";
                            toFieldDisplay += relations[i].toFieldDisplay+",";
                        }
                    }
                    thisObj.find("#fromFieldNameStr").val(fromFieldName);
                    thisObj.find("#fromFieldDisplayStr").val(fromFieldDisplay);
                    thisObj.find("#toFieldNameStr").val(toFieldName);
                    thisObj.find("#toFieldDisplayStr").val(toFieldDisplay);

                    var fillbackKeys = "";
                    var fillbackValues = "";
                    for ( var i = 0; i < formulas.length; i++) {
                        if(i==formulas.length-1){
                            fillbackKeys += formulas[i].fillBackKey;
                            fillbackValues += formulas[i].fillBackValue;
                        }else{
                            fillbackKeys += formulas[i].fillBackKey+",";
                            fillbackValues += formulas[i].fillBackValue+",";
                        }
                    }
                    thisObj.find("#fillBackKey").val(fillbackKeys);
                    thisObj.find("#fillBackValue").val(fillbackValues);
                    //alert(rv[0].key+rv[0].value);
                    //dialog.close();
                    //alert(rv[0].relation[0].key);
                    //var thisRelationStr = $(obj).parents("tr:eq(0)").find("#relationStr");
                    //thisRelationStr.val(rv[0].relation[0].key);
                    dialog.close();
                }
            }
        }, {
            text : $.i18n('form.query.cancel.label'),
            id:"exit",
            handler : function() {
                dialog.close();
            }
        } ]
    });
}

var formatTypeMap = new Properties();
formatTypeMap.put("urlPage","form.input.format.urlpage.label");
var srcFieldMap = new Properties(); //源表单
var temField;
<c:if test="${needSource}">
    temField = new field('source', '${ctp:i18n("form.trigger.triggerSet.fillback.source")}', 'source', 'source', 'source', 'source', 'source', 'source', 'source', 'source', 'source');
    srcFieldMap.put('source.source', temField);
</c:if>
<c:forEach items="${formFields}" var="field">
    temField = new field('${field.name}', '${field.display}', '${field.ownerTableName }', '${field.masterField }', '${field.fieldType}', '${field.inputType }', '${field.enumId }${field.enumLevel }', '${field.extraMap.showInputType}', '${field.extraMap.showFieldType}', '${field.fieldLength }', '${field.digitNum }', '${field.formatType}');
    <c:if test = "${field.formRelation ne null}">
        temField.relation = new relation('${field.formRelation.toRelationObj}', '${field.formRelation.toRelationAttrType}', "${field.formRelation.formRelation}");
    </c:if>
    srcFieldMap.put('${field.ownerTableName }' + '.' + '${field.name}', temField);
</c:forEach>

var targetFieldMap = new Properties(); //目标表单
<c:forEach items="${toFormFields}" var="field">
    temField = new field('${field.name}', '${field.display}', '${field.ownerTableName }', '${field.masterField }', '${field.fieldType}', '${field.inputType }', '${field.enumId }${field.enumLevel }', '${field.extraMap.showInputType}', '${field.extraMap.showFieldType}', '${field.fieldLength }', '${field.digitNum }', '${field.formatType}');
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
        <tr height="30">
            <td>
                <table width="430" height="100%" border="0" cellpadding="0" cellspacing="0" width="430" align="center" style="overflow: auto;">
                    <tr>
                        <td width="40%">${ctp:i18n('form.baseinfo.subtable.relation.selectitem.label')}:</td>
                        <td>${ctp:i18n('form.baseinfo.subtable.relation.selectcollect.label')}:</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <div style="height: 380px;overflow: auto;">
                    <table id="dataTable" border="0" cellspacing="0" cellpadding="0" width="430" align="center" style="overflow: auto;">
                        <tr height="22" style="margin-top: 5px;">
                            <td width="35%" height="20" class="source">
                                <div  id="sourceTD" style="margin-top: 5px;">
                                    <select style="width: 150px;margin-top: 5px;" id="fromField" name="fromField" onchange="validateRelation(this)" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
                                        <option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
                                        <c:forEach items="${subTables}" var="subTable">
                                            <option value="${subTable.tableName}" subTableIndex="${subTable.tableIndex}">${ctp:i18n('formoper.dupform.label')}${subTable.tableIndex}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </td>
                            <td width="5%" align="center">
                            </td>
                            <td width="35%" class="target" style="margin-top: 5px;">
                                <div id="targetTD" style="margin-top: 5px;">
                                    <select style="width: 150px;margin-top: 5px;" id="toField" name="toField" onchange="validateRelation(this)" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
                                        <option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
                                        <c:forEach items="${subTables}" var="subTable">
                                            <option value="${subTable.tableName}" subTableIndex="${subTable.tableIndex}">${ctp:i18n('formoper.dupform.label')}${subTable.tableIndex}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </td>
                            <td width="35">
                                <span id="del" class="ico16 revoked_process_16 repeater_reduce_16"></span>
                                <span id="add" class="ico16 repeater_plus_16"></span>
                            </td>
                            <td width="15%" align="left">
                                <input id="relationStr" name ="relationStr" value="" type="hidden" readonly mytype="14" />
                                <input id="fromFieldNameStr" name ="fromFieldNameStr" value="" type="hidden" />
                                <input id="fromFieldDisplayStr" name ="fromFieldDisplayStr" value="" type="hidden" />
                                <input id="toFieldNameStr" name ="toFieldNameStr" value="" type="hidden" />
                                <input id="toFieldDisplayStr" name ="toFieldDisplayStr" value="" type="hidden" />
                                <input id="fillBackKey" type="hidden" />
                                <input id="fillBackValue" type="hidden" />
                                <a class="common_button common_button_gray margin_l_5" href="javascript:void(0)"  onclick="setRelation(this)">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
<div id="hiddenArea" class="hidden">
    <textarea id="fromField_bak">
        <select style="width: 150px;margin-top: 5px;" id="fromField" name="fromField" onchange="validateRelation(this)" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
            <option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
            <c:forEach items="${subTables}" var="subTable">
                <option value="${subTable.tableName}" subTableIndex="${subTable.tableIndex}">${ctp:i18n('formoper.dupform.label')}${subTable.tableIndex}</option>
            </c:forEach>
        </select>
    </textarea>
    <textarea id="toField_bak">
        <select style="width: 150px;margin-top: 5px;" id="toField" name="toField" onchange="validateRelation(this)" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
            <option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
            <c:forEach items="${subTables}" var="subTable">
                <option value="${subTable.tableName}" subTableIndex="${subTable.tableIndex}">${ctp:i18n('formoper.dupform.label')}${subTable.tableIndex}</option>
            </c:forEach>
        </select>
    </textarea>
</div>
</body>
<%@ include file="../../common/common.js.jsp" %>
</html>