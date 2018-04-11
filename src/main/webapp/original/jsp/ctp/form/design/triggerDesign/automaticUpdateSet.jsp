<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%">
<head>
<script type="text/javascript">
var formBeanType = "${formBean.formType}";
var needSourceField = "${needSourceField}";
var actionType = "${actionType}";

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

function resetData() {
    var tfillBackType = $("#fillBackType", window.dialogArguments.window.currentTr).val();
    var fillBackSource = $("#fillBackKey", window.dialogArguments.window.currentTr).val();
    var fillBackValue = $("#fillBackValue", window.dialogArguments.window.currentTr).val();
    resetDatas(tfillBackType, fillBackSource, fillBackValue);
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
    $("#add, #add1", cloneObj).unbind("click").bind("click", function() {
        add(this);
    });
    $("#del, #del1", cloneObj).unbind("click").bind("click", function() {
        del(this);
    });
    $("#fromField, #fromField1", cloneObj).val("");
    $("#toField, #toField1", cloneObj).val("");
    //bug OA-95894 新增行后未将上一行的类型、是否包含重复表清空，导致上一行是计算式的，下一行为文本的，其类型也变为formula了 edit by chenxb 2016-04-27
    $("#tfillBackType, #tfillBackType1", cloneObj).val("");
    $("#isIncludeSub, #isIncludeSub1", cloneObj).val("");
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

function resetDatas(tfillBackType, fillBackSource, fillBackValue) {
    var typeSplit = tfillBackType.split("|");
    var sourceSplit = fillBackSource.split("|");
    var valueSplit = fillBackValue.split("|");
    var source = $("#fromField_bak").val();
    var target = $("#toField_bak").val();
    for (var i = 0; i < typeSplit.length; i++) {
        var cTr;
        var cloneTr;
        var dataTableb = $("#dataTable");
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
        if(actionType == "autoInsert" && (sourceSplit[i].split("#")[1] == "VARCHAR" || sourceSplit[i].split("#")[1] == "LONGTEXT")) {
            target = target.replace("onclick=\"setFieldFormula(this)\"", "onclick=\"\"");
        }else {
            target = target.indexOf("onclick=\"setFieldFormula(this)\"") > 0 ? target : target.replace("onclick=\"\"","onclick=\"setFieldFormula(this)\"");
        }
        $("#sourceTD", cTr).html(source);
        $("#targetTD", cTr).html(target);
        $("#fromField", cTr).val(sourceSplit[i]);
        $("#tfillBackType", cTr).val(typeSplit[i]);
        $("#formulaValue", cTr).val(valueSplit[i].split("#")[0]);
        $("#isIncludeSub",cTr).val(typeSplit[i]=="formula"?"true":"false");
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
    var error = "";

    $("tr", "#dataTable").each(function() {
        var tempSource = $("#fromField", $(this)).val();
        var tempValue = $("#formulaValue", $(this)).val();
        var isIncludeSub = $("#isIncludeSub",$(this)).val();
        var obj = $("#fromField option[value='"+tempSource+"']", $(this));
        var isMaster = obj.attr("isMaster");
        var fieldtype = obj.attr("fieldtype");
        if (tempSource === "" && tempValue === "") {
            return true;
        }
        if (tempSource == "" || tempValue == "") {
            $.alert("${ctp:i18n('form.trigger.triggerSet.fillback.select.tocheck')}");
            error = "error";
            return false;
        }
        //var tempType = $("#tfillBackType", $(this)).val();
        //var tempType = actionType=="autoInsert" && isMaster=="false" && fieldtype=="VARCHAR" ? "copy" : (isIncludeSub=="true" ? "formula" : (tempSource.split("#")[1] == "DECIMAL" ? "formula" : "copy"));//isMaster=="true" &&
        var tempType;
        //数字类型都是formula，纯数字的如果不是formula的话，在遇到数字型枚举/复选框的时候更新为纯数字会出现问题
        if(tempSource.split("#")[1] == "DECIMAL"){
            tempType = "formula";
        }else{
            var temp = tempValue;
            var reg = /(\{[^\}]*\})|(\[[^\]]*\])/;// 先替换表达式中的{字段显示名}再判断
            temp = temp.replace(reg,"");
            if(temp.indexOf("+") > -1 || temp.indexOf("-") > -1 || temp.indexOf("*") > -1 || temp.indexOf("/") > -1 || temp.indexOf("(") > -1){
                tempType = "formula";
            }else{
                tempType = "copy";
            }
        }
        tfillBackType += tempType + "|";
        fillBackSource += tempSource + "|";
        fillBackValue += tempValue + "|";
    });
    if (error == "error") {
        return "error";
    }

    var result = new Array();
    result[0] = tfillBackType.substring(0, tfillBackType.length - 1);
    result[1] = fillBackSource.substring(0, fillBackSource.length - 1);
    result[2] = fillBackValue.substring(0, fillBackValue.length - 1);
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

function setFieldFormula(obj){
    if($(obj).parents("tr:eq(0)").find("#fromField").val() == ""){
        $.alert("${ctp:i18n('form.trigger.automatic.selectfield.label')}");
        return;
    }
    var formulaArgs = getFormulaArgs(function (formulaStr,formulaDes,formulaData,headHTML,forceCheck,isIncludeSub){
                $(obj).parents("tr:eq(0)").find("#isIncludeSub").val(isIncludeSub);
                $(obj).val(formulaStr);
            },'0',getFormulaTypeByFieldType2($(obj).parents("tr:eq(0)").find("#fromField").val().split("#")[1]),
            $(obj).val(),null);
    formulaArgs.title = $.i18n('form.trigger.automatic.updateformulaset.label');
    if(actionType == "billOuter") {
        formulaArgs.qsType = 2;
    }
    //单据自动新增过滤掉本身字段
    /*if(actionType == "autoInsert") {
        var fieldname = $(obj).parents("tr:eq(0)").find("#fromField").val().split("#")[0].split(".")[1];
        formulaArgs.filterFields = typeof fieldname == "undefined" ? "" : fieldname;
    }*/
    var option = $(obj).parents("tr:eq(0)").find("option[value='" + $(obj).parents("tr:eq(0)").find("#fromField").val() + "']","#fromField");
    var selText = option.text();
    if(option.attr("isMaster") == "false") {
        formulaArgs.subField = selText.substring(1, selText.indexOf("]"));
    }
    formulaArgs.isMaster = option.attr("isMaster");
    formulaArgs.fieldTableName = option.attr("tablename");
    formulaArgs.allowSubFieldAloneUse = option.attr("isMaster")=="true"?false:true;
    formulaArgs.checkSubFieldMethod = option.attr("isMaster")=="true"?true:false;;//重复表字段必须配合重复表方法使用
    formulaArgs.isAutoupdate = true;
    formulaArgs.actionType = actionType;
    //$(obj).parents("tr:eq(0)").find("#fromField").val()  tablename.fieldname
    var selectField = $(obj).parents("tr:eq(0)").find("#fromField").val();
    formulaArgs.fieldType = selectField.split("#")[1];
    formulaArgs.selectedFieldName = selectField.substring(selectField.indexOf(".")+1,selectField.indexOf("#"));
    formulaArgs.selectedFieldDisplay = "{"+$(obj).parents("tr:eq(0)").find("#fromField").find("option:selected").attr("title")+"}";
    showFormula(formulaArgs);
}

//auto_varchar,auto_decimal,auto_timestamp,auto_datetime,
function getFormulaTypeByFieldType2(fieldType) {
    var formulaType = "";
    switch(fieldType){
        case "<%=FieldType.VARCHAR.getKey()%>" : {
            formulaType = "<%=FormulaEnums.formulaType_auto_varchar%>";
            break;
        };
        case "<%=FieldType.DECIMAL.getKey()%>" : {
            formulaType = "<%=FormulaEnums.formulaType_auto_number%>";
            break;
        };
        case "<%=FieldType.TIMESTAMP.getKey()%>" : {
            formulaType = "<%=FormulaEnums.formulaType_auto_date%>";
            break;
        };
        case "<%=FieldType.DATETIME.getKey()%>" : {
            formulaType = "<%=FormulaEnums.formulaType_auto_datetime%>";
            break;
        };
    }
    return formulaType;
}

function setFormulaByFieldType(obj) {
    if($(":selected[value='"+$(obj).val()+"']",$(obj).parents("#dataTable")).length > 1) {
        $.alert('${ctp:i18n('form.trigger.automatic.selectfield.duplicate.label')}');
        //$(obj).val("");
        //$(obj).parents("tr:eq(0)").find("#formulaValue").val("");
        add(obj);
        del(obj);
        return;
    }
    if(actionType == "autoInsert") {
        var fieldType = $(obj).val().split("#")[1];
        if (typeof fieldType != "undefined" && (fieldType == "VARCHAR" || fieldType == "LONGTEXT")) {
            $(obj).parents("tr:eq(0)").find("#formulaValue").val("{" + $(obj).find("option[value='" + $(obj).val() + "']", obj).attr("title") + "}");
            $(obj).parents("tr:eq(0)").find("#formulaValue").attr("onclick", false);
        } else {
            $(obj).parents("tr:eq(0)").find("#formulaValue").attr("onclick", "setFieldFormula(this)");
            $(obj).parents("tr:eq(0)").find("#formulaValue").val("");
        }
    }else {
        $(obj).parents("tr:eq(0)").find("#formulaValue").attr("onclick", "setFieldFormula(this)");
        $(obj).parents("tr:eq(0)").find("#formulaValue").val("");
    }
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
        <tr height="5">
            <td></td>
        </tr>
        <tr>
            <td>
                <fieldset class="form_area padding_5 margin_t_5 margin_lr_10">
                    <legend>&nbsp;
                        <c:if test="${actionType eq 'billInner' || actionType eq 'billOuter'}" >${ctp:i18n("form.trigger.automatic.updatedatalist.label")}</c:if>
                        <c:if test="${actionType eq 'autoInsert'}" >${ctp:i18n("form.trigger.automatic.billnew.label")}${ctp:i18n("form.data.items.label")}</c:if>
                    &nbsp;
                    </legend>
                    <div style="height: 380px;overflow: auto;">
                        <table id="dataTable" border="0" cellspacing="0" cellpadding="0" width="430" align="center" style="overflow: auto;">
                            <tr height="22" style="margin-top: 5px;">
                                <td width="35%" height="20" class="source">
                                    <div  id="sourceTD" style="margin-top: 5px;">
                                        <select style="width: 150px;margin-top: 5px;" id="fromField" name="fromField" onchange="" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
                                            <option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
                                            <c:forEach items="${formFields}" var="field">
                                                <option value="${field.ownerTableName}.${field.name}#${field.fieldType}" tablename="${field.ownerTableName}" inputtype="${field.inputType}" fieldtype="${field.fieldType}" title="${field.display}" isMaster="${field.masterField}"><c:if test="${field.masterField}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!field.masterField}">[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex}]</c:if>${field.display}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </td>
                                <td width="15%" align="center">
                                    <input type="hidden" id="tfillBackType" value="copy">=
                                    <input type="hidden" id="isIncludeSub" />
                                </td>
                                <td width="35%" class="target" style="margin-top: 5px;">
                                    <div id="targetTD">
                                        <input type="text" id="formulaValue" name="formulaValue"  style="width: 150px;margin-top: 5px;cursor: pointer;" readonly onclick="setFieldFormula(this)" />
                                    </div>
                                </td>
                                <td width="15%">
                                    <span id="del" class="ico16 revoked_process_16 repeater_reduce_16"></span>
                                    <span id="add" class="ico16 repeater_plus_16"></span>
                                </td>
                            </tr>
                        </table>
                    </div>
                </fieldset>
                <div class="align_left margin_l_5 margin_b_5 margin_t_5">
                    <a id="btnreset" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('common.button.reset.label')}</a>
                </div>
            </td>
        </tr>
    </table>
<div id="hiddenArea" class="hidden">
    <textarea id="fromField_bak">
        <select style="width: 150px;margin-top: 5px;" id="fromField" name="fromField" onchange="setFormulaByFieldType(this)" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete">
            <option value="">${ctp:i18n('form.trigger.triggerSet.fillback.select')}</option>
            <c:forEach items="${formFields}" var="field">
                <option value="${field.ownerTableName}.${field.name}#${field.fieldType}" tablename="${field.ownerTableName}" inputtype="${field.inputType}" fieldtype="${field.fieldType}" title="${field.display}" isMaster="${field.masterField}"><c:if test="${field.masterField}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!field.masterField}">[${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex}]</c:if>${field.display}</option>
            </c:forEach>
        </select>
    </textarea>
    <textarea id="toField_bak">
        <input type="text" id="formulaValue" name="formulaValue"  style="width: 150px;margin-top: 5px;cursor: pointer;" readonly onclick="setFieldFormula(this)" />
    </textarea>
</div>
</body>
<%@ include file="../../common/common.js.jsp" %>
</html>