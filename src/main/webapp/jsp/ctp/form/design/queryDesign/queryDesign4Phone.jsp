<%--
  Created by IntelliJ IDEA.
  User: chenxb
  Date: 2016/3/7
  Time: 14:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script type="text/javascript" src="${path}/ajax.do?managerName=formQueryDesignManager,formManager"></script>
</head>
<body style="margin-top: 10px;" class="font_size12">
<div>
    <div>
        <table width="100%" border="0" cellpadding="2" cellspacing="0">
            <tr height="25px" class="nomore">
                <td colspan="4">
                    <div class="left" style="width: 250px;text-align: center">${ctp:i18n('form.query.phoneviewset.indicator.pc.item')}</div>
                    <div class="right" style="width: 250px;text-align: center">${ctp:i18n('form.query.phoneviewset.indicator.mobile.item')}</div>
                </td>
            </tr>
            <tr height="10px" class="nomore">
                <td colspan="4">
                    <div class="common_txtbox_wrap" style="margin-left: 12px;margin-right: 22px;"></div>
                </td>
            </tr>
            <tr height="35px" class="nomore">
                <td align="right" nowrap="nowrap" style="width:95px;">
                    <div style="text-align: right;float: right;">
                        <label>${ctp:i18n('form.query.queryname.label')}：</label></div>
                </td>
                <td nowrap="nowrap" colspan="3">
                    <div class="common_txtbox_wrap" style="width: 185px;text-align: left;float: left;padding-left: 3px;padding-right: 1px;">
                        <input readonly="readonly" disabled="disabled" id="queryName" name="queryName" class="w100b"
                               type="text"
                               value="${queryName}">
                    </div>
                </td>
            </tr>
            <tr height="35px">
                <td align="right" nowrap="nowrap" style="width:95px;">
                    <!-- 输出数据项 -->
                    <label>${ctp:i18n('form.query.phoneviewset.showfield')}：</label>
                </td>
                <td nowrap="nowrap">
                    <div class=common_txtbox_wrap style="width: 185px;text-align: left;float: left;padding-left: 3px;padding-right: 1px;">
                        <input type="text" class="hidden" id="showFieldIdList" value="${showFieldIdList}">
                        <input readonly="readonly" disabled="disabled" id="showFieldList" name="showFieldList"
                               class="w100b" type="text" value="${showFieldList}">
                    </div>
                </td>
                <td align="right" nowrap="nowrap" style="width:94px;">
                    <!-- 输出数据项 -->
                    <label>${ctp:i18n('form.query.phoneviewset.showfield')}：</label>
                </td>
                <td nowrap="nowrap">
                    <div class=common_txtbox_wrap style="width: 165px;text-align: left;float: left;padding-left: 3px;padding-right: 1px;">
                        <input readonly="readonly" id="showFieldList4Phone"
                               name="showFieldList4Phone" onclick="showFieldListSet()"
                               class="w100b validate" style="cursor: pointer;" type="text" mytype="4" hideText="showFieldNameList4Phone"
                               validate="name:'${ctp:i18n('form.query.querydatafield.label')}',type:'string',notNull:true"
                               value="${showFieldList4Phone}">
                        <input id="showFieldNameList4Phone" name="showFieldNameList4Phone" class="w100b"
                               type="hidden" value="${showFieldNameList4Phone}">
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div class="clearfix margin_t_5 margin_l_5">
        <fieldset style="padding: 0px;width:93%;margin-left:15px;">
            <legend>${ctp:i18n('form.query.phoneviewset.indicator.item')}</legend>
            <div style="height: 280px;overflow: auto;margin-top:10px;" id="indicatorSet">
                <c:forEach var="indicator" items="${indicatorList }" varStatus="status">
                    <div class="clearfix margin_t_5 rowdata" style="line-height: 20px;height:30px;" id="dataDiv">
                        <input type="text" class="hidden indicatorId" id="indicatorId_${status.index}" value="${indicator.id}">
                        <div class="left" style="width:65px;text-align:right;">
                            <select id="indicatorType_${status.index}" oldType="${indicator.type}" index="${status.index}"
                                    style="width:50px;" class="indicatorType" onchange="confirmChangeType($(this))">
                                <option value=""></option>
                                <c:forEach var="type" items="${typeList }">
                                    <option <c:if test="${type.key eq indicator.type }">selected=true</c:if>
                                            value="${type.key }">${type.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="left <c:if test="${indicator.type ne 'count' }">common_txtbox_wrap</c:if>"
                             style="margin-left: 10px;width: 130px;padding-left: 3px;padding-right: 1px;">
                            <input type="text" id="display_${status.index}" readonly="readonly" onclick="setIndicatorField($(this))"
                                   class="display <c:if test="${indicator.type eq 'count' }">hidden</c:if>"
                                   hideText="field${status.index}" style="cursor: pointer;" value="${indicator.fieldDisplay}" index="${status.index}">
                            <input type="text" class="hidden field" id="field_${status.index}" value="${indicator.indicateField}"/>
                        </div>
                        <div class="left" style="width:90px;text-align:right;margin-left: <c:if test="${'count' eq indicator.type }">146</c:if>px">
                            <font color="red">*</font>${ctp:i18n('form.query.phoneviewset.indicator.showtitle')}：
                        </div>
                        <div class="left common_txtbox_wrap" style="margin-left: 5px;width: 150px;padding-left: 3px;padding-right: 1px;">
                            <input type="text" id="showTitle_${status.index}" value="${indicator.showTitle}" style="width:150px;" class="showTitle validate" onblur="resetWidth($(this))"
                                   validate="name:'${ctp:i18n('form.query.phoneviewset.indicator.showtitle') }',type:'string',notNull:true,maxLength:10,avoidChar:'\&#39;&quot;<>!@#$%^&*()'">
                        </div>
                        <div class="left" style="width: 51px;text-align: right;">
                            <span class="delButton ico16 repeater_reduce_16" index="${status.index}"></span>
                            <span class="addButton ico16 repeater_plus_16" index="${status.index}"> </span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </fieldset>
    </div>
</div>
<div class="clearfix margin_t_5 rowdata hidden" style="line-height: 20px;height:30px;" id="cloneDiv">
    <input type="text" class="hidden indicatorId" id="indicatorId">
    <div class="left" style="width:65px;text-align:right;">
        <select id="indicatorType" style="width:50px" class="indicatorType">
            <option value=""></option>
            <c:forEach var="type" items="${typeList }">
                <option value="${type.key }">${type.text}</option>
            </c:forEach>
        </select>
    </div>
    <div class="left common_txtbox_wrap" style="margin-left: 10px;width: 130px;padding-left: 3px;padding-right: 1px;">
        <input type="text" id="display" readonly="readonly" disabled="disabled" class="display" style="cursor: pointer;width:130px;" hideText="field">
        <input type="text" class="hidden field" id="field" name="field"/>
    </div>
    <div class="left" style="width:90px;text-align:right;">
        <font color="red" class="hidden">*</font>${ctp:i18n('form.query.phoneviewset.indicator.showtitle')}：
    </div>
    <div class="left common_txtbox_wrap" style="margin-left: 5px;width: 150px;padding-left: 3px;padding-right: 1px;">
        <input type="text" id="showTitle" style="width:150px;" disabled="disabled" class="showTitle validate"
               validate="name:'${ctp:i18n('form.query.phoneviewset.indicator.showtitle') }',type:'string',notNull:true,maxLength:10,avoidChar:'\&#39;&quot;<>!@#$%^&*()'">
    </div>
    <div class="left" style="width: 51px;text-align: right;">
        <span class="delButton ico16 repeater_reduce_16"></span>
        <span class="addButton ico16 repeater_plus_16"> </span>
    </div>
</div>
</body>
<%@ include file="../../common/common.js.jsp" %>
<script type="text/javascript">
    var indicatorCount = ${indicatorCount};
    $(document).ready(function () {
        $(".addButton").click(function () {
            addIndicator($(this));
        });
        $(".delButton").click(function () {
            delIndicator($(this));
        });
        initIndicatorData();
    });

    function initIndicatorData(){
        if(indicatorCount == 0){
            addIndicator();
        }
    }

    function addIndicator(obj) {
        var tempset = $("#cloneDiv").clone();
        tempset.removeClass("hidden");
        tempset.attr("id", "dataDiv");
        tempset.find(".addButton").attr("index", indicatorCount);
        tempset.find(".addButton").click(function () {
            addIndicator(tempset.find(".addButton"));
        });
        tempset.find(".delButton").attr("index", indicatorCount);
        tempset.find(".delButton").click(function () {
            delIndicator(tempset.find(".delButton"));
        });

        tempset.find("#indicatorId").attr("id", "indicatorId_" + indicatorCount);

        tempset.find("#indicatorType").attr("id", "indicatorType_" + indicatorCount);
        tempset.find("#indicatorType").attr("oldType", "");
        tempset.find(".indicatorType").attr("index", indicatorCount);
        tempset.find(".indicatorType").change(function () {
            confirmChangeType(tempset.find(".indicatorType"));
        });

        tempset.find("#display").attr("id", "display_" + indicatorCount);
        tempset.find(".display").attr("index", indicatorCount);
        tempset.find("#field").attr("id", "field_" + indicatorCount);
        tempset.find(".display").click(function () {
            setIndicatorField(tempset.find(".display"));
        });

        tempset.find("#showTitle").attr("id", "showTitle_" + indicatorCount);
        tempset.find(".showTitle").blur(function(){
            resetWidth(tempset.find(".showTitle"));
        });

        var index = $(obj).attr("index");
        if (index) {
            var currentSet = $(obj).parents("div:eq(0)").parents("div:eq(0)");
            currentSet.after(tempset);
        } else {
            $("#indicatorSet").append(tempset);
        }
        indicatorCount++;
    }

    function delIndicator(obj) {
        var currentSet = $(obj).parents("div:eq(0)").parents("div:eq(0)");
        var index = $(obj).attr("index");
        if ($("#indicatorSet").children().length != 1) {
            currentSet.remove();
        } else {
            currentSet.find("#indicatorType_" + index).val("");
            currentSet.find("#indicatorType_" + index).attr("oldType", "");
            currentSet.find("#display_" + index).val("");
            currentSet.find("#display_" + index).removeClass("hidden");
            currentSet.children("div:eq(1)").addClass("common_txtbox_wrap");
            currentSet.find("#field_" + index).val("");
            currentSet.find("#showTitle_" + index).val("");
            currentSet.find("#display_" + index).attr("disabled","disabled");
            currentSet.children("div:eq(2)").css("margin-left", "0px");
            currentSet.find("#showTitle_" + index).attr("disabled","disabled");
            currentSet.find("#showTitle_" + index).attr("readonly","readonly");
            currentSet.find("font").addClass("hidden");
        }
    }

    //输出项
    function showFieldListSet() {
        selectChoose("showFieldList4Phone", null, $.parseJSON("{'byTable':'wee','byInputType':'handwrite,attachment,document,image'}"), {IsWriteBlak: false, PcShowFields: $("#showFieldIdList").val()}, function (valueObj) {
            var key = "";
            var value = "";
            for (var i = 0; i < valueObj.length; i++) {
                if (i == valueObj.length - 1) {
                    key += valueObj[i].key;
                    value += valueObj[i].value;
                } else {
                    key += valueObj[i].key + ",";
                    value += valueObj[i].value + ",";
                }
            }
            if (checkFunction("showFieldList4Phone", value)) {
                $("#showFieldNameList4Phone").val(key);
            } else {
                return false;
            }
        });
    }

    function checkFunction(t, v) {
        var param = {};
        param.showFieldList4Phone = $("#showFieldList4Phone").val();//显示项
        if(!v){
            $.alert($.i18n('form.query.phoneviewset.showfield.notnull.alert'));
            return false;
        }
        if (t != null) {
            param[t] = v;
        }
        if (!checkHasDiffTables(param)) {
            $("#" + t).val(v);
            return true;
        }
        return false;
    }

    //false 表示没有多个重复表字段
    //true表示有多个重复表字段
    function checkHasDiffTables(param) {
        var formulaStr = "";
        var showL = param.showFieldList4Phone;//显示项
        if (showL != "") {
            var s = showL.split(",");
            for (var i = 0; i < s.length; i++) {
                formulaStr = formulaStr + " {" + s[i] + "} = '1' and ";
            }
        }
        if (formulaStr != "") {
            formulaStr = formulaStr.substring(0, formulaStr.length - 4);
            var formMgr = new formManager();
            var value = formMgr.hasDifferSubTable(0, formulaStr);
            if (value) {
                //输出数据域的字段不是同一表字段!
                $.alert($.i18n('form.query.hasDiffTableField.error'));
                return true;
            }
        }
        return false;
    }

    //类型改变事件
    function confirmChangeType(obj) {
        var newType = $(obj).val();
        var oldType = $(obj).attr("oldType");
        var index = $(obj).attr("index");
        if(newType == oldType){
            return;
        }
        if (newType) {
            if (newType == "count") {
                $("#display_" + index).addClass("hidden");
                $("#display_" + index).parents("div:eq(0)").removeClass("common_txtbox_wrap");
                $("#showTitle_" + index).parents("div:eq(0)").parents("div:eq(0)").find("font").parent().css("margin-left", "146px");
            } else {
                $("#display_" + index).removeClass("hidden");
                $("#display_" + index).parents("div:eq(0)").addClass("common_txtbox_wrap");
                $("#showTitle_" + index).parents("div:eq(0)").parents("div:eq(0)").find("font").parent().css("margin-left", "0px");
            }
            $("#display_" + index).removeAttr("disabled");
            $("#showTitle_" + index).removeAttr("disabled");
            $("#showTitle_" + index).removeAttr("readonly");
            $("#showTitle_" + index).parents("div:eq(0)").parents("div:eq(0)").find("font").removeClass("hidden");
        } else {
            $("#display_" + index).removeClass("hidden");
            $("#display_" + index).parents("div:eq(0)").addClass("common_txtbox_wrap");
            $("#display_" + index).attr("disabled","disabled");
            $("#showTitle_" + index).attr("disabled","disabled");
            $("#showTitle_" + index).attr("readonly","readonly");
            $("#showTitle_" + index).parents("div:eq(0)").parents("div:eq(0)").find("font").addClass("hidden");
            $("#showTitle_" + index).parents("div:eq(0)").parents("div:eq(0)").find("font").parent().css("margin-left", "0px");
        }
        obj.val( newType);
        obj.attr("oldType", newType);
        $("#display_" + index).val("");
        $("#field_" + index).val("");
        $("#showTitle_" + index).val("");
    }

    //计算字段设置
    function setIndicatorField(typeO) {
        var index = $(typeO).attr("index");
        var type = $("#indicatorType_" + index).val();
        if(!type){
            $.alert($.i18n('form.query.phoneviewset.indicator.type.set.error'));
            return;
        }
        var obj = {};
        obj.title = $.i18n('form.query.phoneviewset.indicator.field.set');
        obj.valueTitle = $.i18n('form.query.phoneviewset.indicator.field.set.selected');
        obj.showSysArea = true;
        obj.canSort = false;
        obj.needMaster = false;
        var relationValue = {};
        relationValue.value = "field_" + index;
        relationValue.display = "display_" + index;
        obj.relationValue = relationValue;
        obj.result = {
            value: 'field_' + index,
            display: 'display_' + index
        };
        var fieldType;
        if (type == "earliest" || type == "latest") {
            fieldType = "datetime,timestamp";
        } else {
            fieldType = "decimal";
            obj.showSysArea = false;
        }
        obj.filter = {
            fieldType: fieldType,
            inputType: "text,textarea,checkbox,date,datetime,lable,linenumber"//只有这些类型的数字字段能参与指标设置
        };
        obj.callBack = function(result){
            if(result.display.indexOf(",") > 0){
                $.alert($.i18n('form.query.phoneviewset.indicator.field.set.selected.error'));
                return;
            }
            return true;
        };
        selectFormField("showItem", obj);
    }

    //显示标题失去焦点后会变宽，因为有校验
    function resetWidth(obj){
        $(obj).parent().css("width", "150px");
    }

    function OK() {
        var error = "";
        var errorType = "";
        var tempShowFieldDis = $("#showFieldList4Phone").val();
        var tempShowField = $("#showFieldNameList4Phone").val();
        if(tempShowField != "" && tempShowField.split(",").length > 255){
            //输出数据项不能设置超过255项,请重新设置!
            $.alert($.i18n('form.query.design.showListCout.error'));
            //error = "error";
            return "error";
        }
        var valMsg = "";
        var errorMsg = "";
        var i= 0;
        //var jsonData = "{showFieldList:\"" + tempShowFieldDis + "\",showFieldNameList:\"" + tempShowField + "\"," + "indicatorList:[";
        var jsonData = "{indicatorList:[";
        $("div#dataDiv").each(function () {
            i++;
            var tempId = $(".indicatorId", $(this)).val();
            var tempType = $(".indicatorType", $(this)).val();
            var tempField = $(".field", $(this)).val();
            var tempFieldDis = $(".display", $(this)).val();
            var tempTitle = $(".showTitle", $(this)).val();

            //当只有一行且所有值都为空时，则表示删除全部
            if ($("#indicatorSet").children().length == 1
                    && !tempType
                    && !tempField
                    && !tempTitle) {
            } else {
                if (tempType == "" || tempType == "undefined") {
                    errorType = "1";
                } else {
                    if (tempType == "count") {
                        if (tempTitle == "" || tempTitle == "undefined") {
                            errorType = "2";
                        }
                    } else {
                        if ((tempField == "" || tempField == "undefined")
                                || (tempTitle == "" || tempTitle == "undefined")) {
                            errorType = "2";
                        }
                    }
                }
            }
            //将页面的显示标题的引号进行转译
            if (tempTitle.indexOf("\"") > -1){
                tempTitle = tempTitle.replaceAll("\"","\\\"");
            }
            //校验显示标题是否合法
            if(!$(".showTitle", $(this)).validate()){
                //errorMsg += "第 " + i + " 行显示标题非法，" + $(".error-title", $(this)).attr("title") + "<br/>";
                errorMsg += $.i18n('form.query.phoneviewset.indicator.showfield.validate.error', i) + $(".error-title", $(this)).attr("title") + "<br/>";
            }
            resetWidth($(".showTitle", $(this)));

            jsonData += "{id:\"" + tempId + "\",type:\"" + tempType + "\",field:\"" + tempField + "\",display:\"" + tempFieldDis + "\",title:\"" + tempTitle + "\"},";
        });

        if (errorType) {
            error = "error";
            if (errorType == "1") {
                $.alert($.i18n('form.query.phoneviewset.indicator.field.set.error'));
            }
            if (errorType == "2") {
                $.alert($.i18n('form.query.phoneviewset.indicator.field.set.error'));
            }
        }else if(errorMsg){
            error = "error";
            $.alert(errorMsg);
        }
        if (error == "error") {
            return "error";
        }

        jsonData = jsonData.substring(0, jsonData.length - 1);
        jsonData += "]}";

        var returnValue = {};
        returnValue.tempShowFieldDis = tempShowFieldDis;
        returnValue.tempShowField = tempShowField;
        returnValue.jsonData = jsonData;
        return returnValue;
    }

    function del(){

    }
</script>
</html>