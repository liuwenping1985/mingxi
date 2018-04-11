<%--
  Created by IntelliJ IDEA.
  User: wangh
  Date: 2016-1-6 0006
  Time: 14:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ page import="com.seeyon.ctp.form.util.Enums.BarcodeCorrectionOption"%>
<html>
<head>
    <title>设置二维码内容</title>
    <style>
        .titleLabel{
            height: 25px;
            vertical-align: middle;
            line-height: 25px;
        }
    </style>
</head>
<body>
<form method="post" action="" >
    <div class="font_size12">
    <!-- 二维码内容组成 -->
    <div class = "margin_t_10 margin_l_10 clearfix">
        <div style="width: 250px;" class="left margin_l_5 margin_t_5" id="leftSelect">
            <div id="fieldHead" class="clearfix">
                <div class="left titleLabel">${ctp:i18n('form.forminputchoose.formdata')}:</div>
                <div id="searchArea" class="left">
                    <ul class="common_search">
                        <li id="inputBorder" class="common_search_input">
                            <input id="searchValue" class="search_input" type="text">
                        </li>
                        <li>
                            <a id="serachbtn" class="common_button search_buttonHand" href="javascript:void(0)">
                                <em></em>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <div id="optionarea">
                <select name="dataItem" id="dataItem" style="width:250px;" class="margin_t_5" onchange="selectDataArea(this)">
                    <c:forEach items="${dataList}" var="item" varStatus="status">
                        <option value="${status.index}" title="${item}">${item}</option>
                    </c:forEach>
                </select>
                <%--表单数据域--%>
                <div id="itemarea0">
                <select name='dataToSelect0' id='dataToSelect0' multiple='multiple' style='width:250px;height:300px;' ondblclick="selectToRight()">
                    <c:forEach items = "${fieldList}" var = "field">
                        <option value="${field['name']}" tableName="${field['ownerTableName']}" displayName="{${field['display']}}" title="${field['display']}"><c:if test="${field['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if><c:if test="${!field['masterField']}">[${ctp:i18n('formoper.dupform.label')}${field['ownerTableIndex'] }]</c:if>${field['display']}</option>
                    </c:forEach>
                </select>
                </div>
                <%--组织机构数据域--%>
                <div id="itemarea1" class="hidden">
                    <select id="dataToSelect1"  name="dataToSelect1" multiple='multiple' style='width:250px;height:300px;' ondblclick="selectToRight()">
                        <c:forEach items="${org}" var="obj" varStatus="status">
                            <option value="${obj.key}" displayName="[${obj.value}]" title="${obj.value}">${obj.value}</option>
                        </c:forEach>
                    </select>
                </div>
                <%--日期数据域--%>
                <div id="itemarea2" class="hidden">
                    <select id="dataToSelect2"  name="dataToSelect2" multiple='multiple' style='width:250px;height:300px;'  ondblclick="selectToRight()">
                        <c:forEach items="${date}" var="obj" varStatus="status">
                            <option value="${obj.key}" displayName="[${obj.value}]" title="${obj.value}">${obj.value}</option>
                        </c:forEach>
                    </select>
                </div>
                <%--系统数据域--%>
                <div id="itemarea3" class="hidden">
                    <select id="dataToSelect3"  name="dataToSelect3" multiple='multiple' style='width:250px;height:300px;' ondblclick="selectToRight()">
                        <c:forEach items="${sys}" var="obj" varStatus="status">
                            <option value="${obj.key}" displayName="[${obj.value}]" title="${obj.value}">${obj.value}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>
        <div type="select" class="left margin_l_5 margin_t_5" style="width: 35px;margin-top: 170px;">
            <span class="ico16 select_selected" id="select_selected" style="cursor:hand;"></span>
            <br>
            <span class="ico16 select_unselect" id="select_unselect" style="cursor:hand;"></span>
        </div>
        <div style="width: 250px;overflow-y: auto;overflow-x: hidden;" class="left margin_l_5 margin_t_5" id="rightSelect">
            <div id="valueHead" class="titleLabel">${ctp:i18n('form.barcode.components.label')}</div>
            <div id="selectedarea">
                <select name="hasSelect" id="hasSelect" style="width: 250px;height:320px;" multiple="multiple" class="margin_t_5">
                    <c:forEach items = "${hasSelectList}" var = "selected">
                        <option value="${selected.key}" title="${selected.name}">${selected.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div type="select" class="left margin_l_5 margin_t_5" style="width: 35px;margin-top: 170px;">
            <span class="ico16 sort_up" id="sort_up" style="cursor:hand;"></span>
            <br>
            <span class="ico16 sort_down" id="sort_down" style="cursor:hand;"></span>
        </div>
    </div>
    <!-- 二维码属性 -->
    <div class="clearfix margin_t_20">
        <div class="left margin_l_15">
            <label for="barcodeType">${ctp:i18n("form.barcode.type.label")}：
            <select name="barcodeType" id="barcodeType" style="width: 80px;">
                <c:forEach items = "${barcodeType}" var = "barcodeType">
                    <option value="${barcodeType.key}" title="${barcodeType.text}">${barcodeType.text}</option>
                </c:forEach>
            </select></label>
        </div>
        <div class="left margin_l_20">
            <c:set var="optionDefault" value="<%=BarcodeCorrectionOption.middle.getKey()%>"></c:set>
            <label for="correctionOption">${ctp:i18n("form.barcode.correction.label")}：
                <select name="correctionOption" id="correctionOption" style="width: 80px;">
                    <c:forEach items = "${optionList}" var = "optionItem">
                        <option value="${optionItem.key}" <c:if test='${optionItem.key eq optionDefault}'>selected </c:if> title="${optionItem.text}">${optionItem.text}</option>
                    </c:forEach>
                </select></label>
        </div>
        <div class="left margin_l_20">
            <label for="sizeOption">${ctp:i18n("form.barcode.sizeoption.label")}：
            <select name="sizeOption" id="sizeOption" style="width:80px;">
                <c:forEach items = "${sizeList}" var = "sizeItem">
                    <option value="${sizeItem}" <c:if test="${sizeItem eq '4'}">selected</c:if> title="${sizeItem}">${sizeItem}</option>
                </c:forEach>
            </select></label>
        </div>
        <div class="left margin_t_5 margin_l_20">
            <label class="margin_r_10 hand" for="encrypt">
                <input name="encrypt" class="radio_com encrypt" id="encrypt" type="checkbox"  value="1">${ctp:i18n("form.barcode.encrypt.label")}</label>
        </div>
    </div>
        <div class="clearfix margin_t_10 margin_l_15">
            <label for="text"><font color="green" id="text">${ctp:i18n('form.barcode.set.description.label' )}</font></label>
        </div>
    <!--<div class="clearfix" style="margin-left: 520px;">
        <a id="abandon" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('form.trigger.triggerSet.reset.label')}</a>
    </div>-->
    </div>
    <div id="bakarea" class="hidden"></div>
</form>
<%@ include file="setBarCodeContent.js.jsp" %>
</body>
</html>
