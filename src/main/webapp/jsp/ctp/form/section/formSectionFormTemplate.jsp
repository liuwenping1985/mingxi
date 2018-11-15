<%--
 $Author:  $
 $Rev:  $
 $Date:: #$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<style type="text/css">
.oper-instruction{
    position:absolute;
    z-index:3000;
    padding:5px;
    width:360px;
    height:128px;
    border:1px #000000 solid;
    background:#ffffff;
    font-size:12px;
}
.formbizconfig-readonly{
    color:  Gray;
}
.oper-help{
    color:  #0046d5;
    background-color: #FFFFFF;
    font-size:12px;
}
.oper-help2{
    color:  Black;
    font-size:12px;
}
.oper-help-li {
    padding-bottom:3px;
	font-size: 12px;
	line-height: 15px;
	list-style-type: disc;
	margin-left: 20px;
}
.button-style-config-column{
    width: 84px;
    border-right:#3A6080 1px solid;padding-right:2px;
    border-top:#3A6080 1px solid;padding-left:2px;
    font-size:12px;
    filter:
    progid:DXImageTransform.Microsoft.Gradient
    (GradientType=0,StartColorStr=#FFFEFC,
     EndColorStr=#E8E4DC);
    border-left:#3A6080 1px solid;
    cursor:hand;color:black;padding-top:2px;
    border-bottom:#3A6080 1px solid;
    height:20px;
}
</style>
</head>
<body id='layout'>
    <div class="layout_north" id="north">
        <form id="searchForm" name="searchForm" method="post" action="${path}/form/formSection.do?method=searchTemplateTree&type=showAll">
            <div id="">
                <div class="common_radio_box clearfix padding_t_5 padding_l_5">
                    <label for="myTemplate" class="margin_r_10 hand"><input onclick="changeTemplateCategory(1)" type="radio" value="1" id="myTemplate" name="option" class="radio_com" checked="checked"/>${ctp:i18n('formsection.config.template.myformtemps') }</label>
                    <label for="allTemplate" class="hand"><input onclick="changeTemplateCategory(4)" type="radio" value="4" id="allTemplate" name="option" class="radio_com" ${disabled}/>${ctp:i18n('formsection.config.template.allformtemps') }</label>
                    <input type="hidden" id = "type" name="type" value = "1">
                    <input type="hidden" id = "selectType" name ="selectType" value = "1">
                    <input type="hidden" id = "value" name="value" value = "1">
                    <input type="hidden" id = "option" name = "option" value = "1">
                    <input type="hidden" id = "templateCategory" name = "templateCategory" value = "1">
	                <span class="align_right padding_l_10"><a id = struction class="hand font_size12">[${ctp:i18n('formsection.config.operinstruction.label') }]</a></span>
                </div>
            </div>
        </form>
    </div>
    <div class="layout_center padding_l_5" id="center">
        <table>
            <tr>
                <td colspan="2" class="font_size12">${ctp:i18n('formsection.config.column.category.canbeselected') }</td>
                <td colspan="2" class="font_size12">${ctp:i18n('formsection.config.column.category.selected') }</td>
            </tr>
            <tr height="170">
                <%-- 栏目可选项 --%>
                <td width="43%" style="text-align: center;">
                    <div id="allColumns" class="scrollList padding5 border_all" style="height: 300px">
                        <iframe name="allColumnsIFrame" id="allColumnsIFrame" src="${path }/form/formSection.do?method=formTemplateTree&type=showAll&templateId=" height="100%" width="100%"   frameBorder="no" ></iframe>
                    </div>
                </td>

                <td valign="middle" width="7%">
                    <c:if test="${param.type ne 'view' }">
                        <div class="align_center" onClick="allColumnsIFrame.selectColumn(true)"><span class="ico16 select_selected"></span></div>
                        <div class="align_center" style="margin-top: 20px;" onClick="delTemplate()"><span class="ico16 select_unselect"></span></div>
                    </c:if>
                </td>
                <%-- 栏目已选项 --%>
                <td width="43%">
                    <%-- 嵌套一层table，避免已选项中节点文字过多时，可选项部分空间被全部占用无法正常显示并进行操作 --%>
                    <table width="100%" height="100%" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
                        <tr>
                            <td>
                                <div id="selectedColumns" class="scrollList padding5" style="height: 300px">
                                    <select id="selectColumns" multiple="multiple" class="border_all" style="width: 100%;height: 100%;">
                                        <c:forEach items="${templateList }" var="item">
                                        <option value="${item.value }">${item.name }</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>

                <td valign="middle" width="7%">
                    <c:if test="${param.type ne 'view' }">
                        <div class="align_center" onClick="moveColumn('prev')"><span class="ico16 sort_up"></span></div>
                        <div class="align_center" style="margin-top: 20px;" onClick="moveColumn('next')"><span class="ico16 sort_down"></span></div>
                    </c:if>
                </td>
            </tr>
        </table>
    </div>
    <div id="operInstructionDiv"  class=""  style="color:  green;font-size: 12px;display: none;">
        ${ctp:i18n('formsection.config.operinstruction.info2')}
    </div>
    <%@ include file="formSectionFormTemplate.js.jsp" %>
    <script type="text/javascript" src="${path}/ajax.do?managerName=formSectionManager"></script>
    <div id="jsonSubmit"/>
</body>
</html>