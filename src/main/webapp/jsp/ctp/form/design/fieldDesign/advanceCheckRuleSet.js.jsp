<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script type="text/javascript">
    String.prototype.replaceAll = function (s1, s2) {
        return this.replace(new RegExp(s1, "gm"), s2);
    }

    var formId = "${ctp:escapeJavascript(formId)}";
    var parentWin = window.dialogArguments[0].window;
    var parentWinDocument = parentWin.document;

    $().ready(function () {
        init();
        adapterFooter();
    });

    //初始化
    function init() {
        $("#normalSet").click(function () {
            changeNormalSet();
        });
        //重置事件
        $("#reset").click(function () {
            $("#lastResultFormField").val("");
            var trObj = $("#setArea tr");
            var length = trObj.length;
            trObj.each(function (index) {
                if (index === 0) {
                    $($(this).find("textarea")[0]).val("");
                    $($(this).find("textarea")[1]).val("");
                    return true;
                } else if (index === length - 1) {
                    return true;
                } else {
                    $(this).remove();
                }
            });
            adapterFooter();
        });

        initData();
    }

    //切换普通设置
    function changeNormalSet() {
        try {
            var obj = {'formId': formId};
            if(($("#ifFormField").val() != "" && $("#resultFormField").val()!=null) || ($("#resultFormField").val() != "" && $("#resultFormField").val()!=null) || $("#lastResultFormField").val() != ""){
                var cDialog = $.confirm({
                    'msg': '${ctp:i18n("form.baseinfo.formula.change.error.label")}',
                    ok_fn: function () {
                        setTimeout(function() {
                            window.dialogArguments[0].window.changeDialog(window.dialogArguments[0].window.current_dialog, obj, 3);
                        }, 0);
                    },
                    cancel_fn: function () {
                        $("#advancedSet").attr("checked", true);
                        cDialog.close();
                    }
                });
            } else {
                window.dialogArguments[0].window.changeDialog(window.dialogArguments[0].window.current_dialog, obj, 3);
            }
        } catch (e) {

        }
    }

    //初始化高级设置界面
    function initData() {
        var dataValue = $("#checkRuleData", parentWinDocument).val();
        if (dataValue != "" && dataValue.indexOf("{") != -1) {
            var dataObj = eval("(" + dataValue + ")");
            if (dataObj) {
                var dataArray = dataObj.data;
                var value;
                if (dataArray && dataArray.length > 1) {
                    for (var i = 0; i < dataArray.length; i++) {
                        value = dataArray[i];
                        if (value.sort == 0 && value.keyword == "if") {
                            $("#ifFormField").val(value.condition);
                            $("#resultFormField").val(value.result);
                            $("#resultDesc").val(value.desc);
                            $("#resultForceCheck").val(value.forceCheck);
                        } else if (value.sort == dataArray.length - 1 && value.keyword == "else") {
                            $("#lastResultFormField").val(value.result);
                            $("#lastResultDesc").val(value.desc);
                            $("#lastResultForceCheck").val(value.forceCheck);
                        } else {
                            var randomNum = i;
                            var ifName = "ifFormField" + randomNum;
                            var resName = "resultFormField" + randomNum;
                            var descName = "resultDesc" + randomNum;
                            var forceName = "resultForceCheck" + randomNum;
                            var k = i - 1;
                            var trObj = $("#setArea tr");
                            var currentRow = trObj.eq(0).clone(true);
                            currentRow.insertAfter(trObj.eq(k));
                            $(trObj.eq(k).next().find("textarea")[0]).attr("id", ifName);
                            $(trObj.eq(k).next().find("textarea")[1]).attr("id", resName);
                            $($(trObj.eq(k).next().find("textarea")[1]).parent().find("input")[0]).attr("id", descName);
                            $($(trObj.eq(k).next().find("textarea")[1]).parent().find("input")[1]).attr("id", forceName);
                            $("#" + ifName).val(value.condition);
                            $("#" + resName).val(value.result);
                            $("#" + descName).val(value.desc);
                            $("#" + forceName).val(value.forceCheck);
                        }
                    }
                }
            }
        }
    }

    //增加行
    function addRow(obj) {
        if ($(obj).parent().parent().parent().find("tr").length > 40) {
            $.alert("${ctp:i18n('form.field.formula.max.message')}");
            return;
        }
        var randomNum = $(obj).parent().parent().parent().find("tr").length;
        var ifName = "ifFormField" + randomNum;
        var resName = "resultFormField" + randomNum;
        var descName = "resultDesc" + randomNum;
        var forceName = "resultForceCheck" + randomNum;
        var currentRow = $(obj).parents("tr").clone(true);
        currentRow.insertAfter($(obj).parents("tr"));
        $($(obj).parents("tr").next().find("textarea")[0]).attr("id", ifName);
        $($(obj).parents("tr").next().find("textarea")[1]).attr("id", resName);
        $($(obj).parents("tr").next().find("textarea")[0]).val("");
        $($(obj).parents("tr").next().find("textarea")[1]).val("");
        $($($(obj).parents("tr").next().find("textarea")[1]).parent().find("input")[0]).attr("id", descName);
        $($($(obj).parents("tr").next().find("textarea")[1]).parent().find("input")[1]).attr("id", forceName);
        $($($(obj).parents("tr").next().find("textarea")[1]).parent().find("input")[0]).val("");
        $($($(obj).parents("tr").next().find("textarea")[1]).parent().find("input")[1]).val("");
        adapterFooter();
    }

    //删除行
    function delRow(obj) {
        var trObj = $("#setArea tr");
        var trNum = trObj.length;
        if (trNum == 2) {
            trObj.find("textarea").each(function () {
                $(this).val("");
            });
        } else {
            $(obj).parents("tr").remove();
        }
        adapterFooter();
    }

    //调整重置按钮区域的高度
    function adapterFooter() {
        var setArea = $("#setArea");
        var areaDiv = $("#setAreaDiv");
        if(setArea.find("tr").length > 3){
            areaDiv.css("overflow-y", "scroll");
        }else{
            areaDiv.css("overflow-y", "inherit");
        }
        //border: 1px solid rgb(102, 102, 102);
    }

    //设置条件计算式
    function setCondition(obj) {
        var formulaArgs = getConditionArgs(function (formulaStr){
            $(obj).val(formulaStr);
        },"0","conditionType_hign_auth",$.trim($(obj).val()),null,null);
        formulaArgs.title = $.i18n('form.baseinfo.checkRule.set.label');
        formulaArgs.parentWin = window;
        formulaArgs.allowSubFieldAloneUse = true;
        formulaArgs.checkSubFieldMethod = true;
        showFormula(formulaArgs);
    }

    //设置结果计算式
    function setResult(obj) {
        var id = $(obj).attr("id");
        var formulaArgs;
        if(id.indexOf("lastResultFormField") > -1){
            formulaArgs = getConditionArgs(function (formulaStr,formulaDes,dataArray,headHTML,forceCheck){
                $(obj).val(formulaStr);
                $("#lastResultForceCheck").val(forceCheck);
                $("#lastResultDesc").val(formulaDes.replace(/[\r\n]/g,"@formulaDes@"));
            },"0","conditionType_BizCheck",$.trim($(obj).val()),$("#lastResultDesc").val().replaceAll("@formulaDes@","\r"),null);
            formulaArgs.forceCheck = $("#lastResultForceCheck").val();
        }else{
            var index = id.replaceAll("resultFormField", "");
            formulaArgs = getConditionArgs(function (formulaStr,formulaDes,dataArray,headHTML,forceCheck){
                $(obj).val(formulaStr);
                $("#resultForceCheck" + index).val(forceCheck);
                $("#resultDesc" + index).val(formulaDes.replace(/[\r\n]/g,"@formulaDes@"));
            },"0","conditionType_BizCheck",$.trim($(obj).val()),$("#resultDesc" + index).val().replaceAll("@formulaDes@","\r"),null);
            formulaArgs.forceCheck = $("#resultForceCheck" + index).val();
        }
        formulaArgs.title = $.i18n('form.baseinfo.checkRule.set.label');
        formulaArgs.allowSubFieldAloneUse = true;
        formulaArgs.checkSubFieldMethod = true;
        formulaArgs.parentWin = window;
        formulaArgs.advanceCheckRule = "1";
        return showFormula(formulaArgs);
    }

    //展示按钮
    function showButton(obj) {
        $(obj).find("#add").show();
        $(obj).find("#del").show();
    }

    //隐藏按钮
    function hiddenButton(obj) {
        $(obj).find("#add").hide();
        $(obj).find("#del").hide();
    }

    //获得随机数
    function getRandom(n) {
        return getUUID();
    }

    //点击确定返回方法
    function OK() {
        //如果只有两行并且两行都是空的则可以保存。并且不提示。
        if (!($("#setArea").find("tr").length == 2 && $($("#setArea").find("tr").eq(0).find("textarea")[0]).val() === ""
                && $($("#setArea").find("tr").eq(0).find("textarea")[1]).val() === "" && $($("#setArea").find("tr").eq(1).find("textarea")[1]).val() === "")) {
            var dataObj = $("#checkRuleData", parentWinDocument);
            if (dataObj) {
                var dataStart = "{\"data\":[";
                var data = "";
                var condition = "";
                var result = "";
                var desc = "";
                var forceCheck = "";
                var isnull = false;
                var nullObj = null;
                $("#setArea").find("tr").each(function (index) {
                    condition = $($(this).find("textarea")[0]).val();
                    result = $($(this).find("textarea")[1]).val();
                    condition = condition.replaceAll("\"", "'").replaceAll("\n", "");
                    result = result.replaceAll("\"", "'").replaceAll("\n", "");

                    desc = $($($(this).find("textarea")[1]).parent().find("input")[0]).val();
                    forceCheck = $($($(this).find("textarea")[1]).parent().find("input")[1]).val();
                    desc = desc.replaceAll("\"", "'").replaceAll("\n", "");
                    forceCheck = forceCheck.replaceAll("\"", "'").replaceAll("\n", "");
                    if ((condition == "" || result == "") && index != $("#setArea").find("tr").length - 1) {
                        nullObj = $(this).find("textarea")[0];
                        isnull = true;
                        return false;
                    }
                    if (index === 0) {
                        data = data + "{\"keyword\":\"if\",\"condition\":\"" + condition + "\",\"result\":\"" + result + "\",\"sort\":\"" + index + "\",\"desc\":\"" + desc + "\",\"forceCheck\":\"" + forceCheck + "\"},";
                    } else if (index === $("#setArea").find("tr").length - 1) {
                        if (result == "") {
                            nullObj = $(this).find("textarea")[1];
                            isnull = true;
                            return false;
                        }
                        data = data + "{\"keyword\":\"else\",\"condition\":\"" + condition + "\",\"result\":\"" + result + "\",\"sort\":\"" + index + "\",\"desc\":\"" + desc + "\",\"forceCheck\":\"" + forceCheck + "\"},";
                    } else {
                        data = data + "{\"keyword\":\"else if\",\"condition\":\"" + condition + "\",\"result\":\"" + result + "\",\"sort\":\"" + index + "\",\"desc\":\"" + desc + "\",\"forceCheck\":\"" + forceCheck + "\"},";
                    }
                });
                if (isnull && nullObj != null) {
                    $(nullObj).focus();
                    $.alert("${ctp:i18n('form.field.formula.advance.notnull')}");
                    return;
                }
                if (data != "") {
                    //截取最后一个字符
                    var lastChar = data.substring(data.length - 1, data.length);
                    if (lastChar == ",") {
                        data = data.substring(0, data.length - 1);
                    }
                }
                var dataEnd = "]}";
                var dataArray = dataStart + data + dataEnd;
                $(dataObj).attr("value", dataArray);
            }
            $("#checkRule", parentWinDocument).val("${ctp:i18n('form.formula.advance.hasset.laebl')}");
            $("#forceCheck", parentWinDocument).attr("value", "1");//默认为强制校验
            $("#advanceCheckRule", parentWinDocument).attr("value", "1");//设置为高级设置
            $("#checkRuleImg", parentWinDocument).show();
        } else {
            $("#checkRule", parentWinDocument).val("");
            $("#checkRuleData", parentWinDocument).val("");
            $("#checkRuleDescription", parentWinDocument).val("");
            $("#forceCheck", parentWinDocument).attr("value", "1");//默认为强制校验
            $("#advanceCheckRule", parentWinDocument).attr("value", "0");//设置为普通设置
            $("#checkRuleImg", parentWinDocument).hide();
        }
        return true;
    }
</script>