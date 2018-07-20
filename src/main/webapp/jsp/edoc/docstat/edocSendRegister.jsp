<%@ taglib prefix="fmt" uri="http://java.sun.com/jsf/html" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>

    <title>${ctp:i18n('edoc.send.register')}<%-- 发文登记簿 --%></title>
    <script type="text/javascript">
        var hasSursen = "${v3x:hasPlugin('sursenExchange')}";
        var defalutPushName = "${ctp:escapeJavascript(defalutPushName)}";
        var registerName = "${ctp:i18n('edoc.send.register')}";
        var fromListType = "${listType}";

        var initCondition = {};
        try {
            initCondition = ${initCondition};//未升级数据可能有问题先括起来
        } catch (e) {
        }

        var showColumn = "${showColumn}";
        var dataRight = "${dataRight}";
        var dataNum4Section = '${dataNum}';
        var isSignReport = "${param.isSignReport}";
    </script>
    <%--<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/docstat/edoc_stat.js${v3x:resSuffix()}" />"></script>--%>
    <script type="text/javascript" src="${path}/apps_res/edoc/js/docstat/edocRegister.js${ctp:resSuffix()}"></script>
    <script type="text/javascript"
            src="${path}/apps_res/edoc/js/docstat/edocSendRegister.js${ctp:resSuffix()}"></script>
</head>
<body>
<div id='layout' class="comp page_color" comp="type:'layout'">
    <!-- layout_north -->
    <div class="layout_north" id="layout_north"
         layout="height:100,maxHeight:200,minHeight:100,spiretBar:{show:true,handlerT:function(){layout.setNorth(0);relayoutGrid();},handlerB:function(){layout.setNorth(curLastNorth);relayoutGrid();}}">

        <div id="tabs" class="margin_t_5 margin_r_5 ">
            <div class="border_alls">
                <div class="form_area" id="queryCondition">
                    <form id="statConditionForm">
                        <div class="form_area set_search">
                            <table border="0" cellpadding="0" cellspacing="0" class="common_center w90b" >
                                <tbody>
                                <tr>
                                    <%--公文标题--%>
                                    <td align="right" nowrap="nowrap" width="60"
                                        class="padding_r_10">${ctp:i18n("edoc.element.subject") }:
                                    </td>
                                    <td nowrap="nowrap" class="padding_tb_5"><input type="text" name="subject"
                                                                                    id="subject"
                                                                                    style="width:200px"
                                                                                    validate="maxLength" maxSize="20"
                                                                                    inputName="${ctp:i18n("edoc.element.subject") }"/>
                                    </td>
                                    <%--公文文号--%>
                                    <td align="right" nowrap="nowrap" width="60"
                                        class="padding_r_10">${ctp:i18n("edoc.element.wordno.label") }:
                                    </td>
                                    <td nowrap="nowrap" class="padding_tb_5"><input type="text" name="docMark"
                                                                                    id="docMark"
                                                                                    style="width:200px"
                                                                                    validate="maxLength" maxSize="20"
                                                                                    inputName="${ctp:i18n("edoc.element.wordno.label") }"/>
                                    </td>
                                    <%--拟文日期--%>
                                    <td align="right" width="60" nowrap="nowrap"
                                        class="padding_r_10">${ctp:i18n("edoc.edoctitle.createDate.label")}:
                                    </td>
                                    <td class="padding_tb_5">
                                        <input id="startRangeTime" lastTime="${startRangeTime }"
                                               value="${startRangeTime }" readonly="readonly" style="width:92px;"
                                               class="comp validate"
                                               comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false"
                                               validate="name:'开始日期',notNull:true"/>
                                        <span>-</span>
                                        <input id="endRangeTime" lastTime="${endRangeTime }" value="${endRangeTime }"
                                               readonly="readonly" style="width:92px;" class="comp"
                                               comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false"/>
                                        <span class="padding_lr_15"><a id="searchMode" mode="normal"
                                                                       class="hand font_size12">[${ctp:i18n("edoc.label.advancedSearch")}]</a>
                                    </td>
                                </tr>
                                <tr class="hidden">
                                    <%--内部文号--%>
                                    <td align="right" nowrap="nowrap" width="60"
                                        class="padding_r_10">${ctp:i18n("edoc.element.wordinno.label")}:
                                    </td>
                                    <td nowrap="nowrap" class="padding_tb_5"><input type="text" name="serialNo"
                                                                                    id="serialNo"
                                                                                    style="width:200px"
                                                                                    validate="maxLength" maxSize="20"
                                                                                    inputName="${ctp:i18n("edoc.element.wordinno.label")}"/>
                                    </td>
                                    <%--发文部门--%>
                                    <td align="right" nowrap="nowrap"
                                        class="padding_r_10">${ctp:i18n("edoc.element.senddepartment")}:
                                    </td>
                                    <td nowrap="nowrap" class="padding_tb_5"><input type="text" name="departmentName"
                                                                                    id="departmentName"
                                                                                    style="width:200px"
                                                                                    validate="maxLength" maxSize="20"
                                                                                    inputName="${ctp:i18n("edoc.element.senddepartment")}"/>
                                    </td>
                                    <%--发文单位--%>
                                    <td align="right" nowrap="nowrap" width="60"
                                        class="padding_r_10">${ctp:i18n("edoc.element.sendunit")}:
                                    </td>
                                    <td nowrap="nowrap" class="padding_tb_5"><input type="text" name="sendUnit"
                                                                                    id="sendUnit"
                                                                                    style="width:200px"
                                                                                    validate="maxLength" maxSize="20"
                                                                                    inputName="${ctp:i18n("edoc.element.sendunit")}"/>
                                    </td>
                                </tr>
                                <tr class="hidden">
                                    <%--密级--%>
                                    <td align="right" nowrap="nowrap" width="60"
                                        class="padding_r_10">${ctp:i18n("govdoc.secretLevel.label") }:
                                    </td>
                                    <td nowrap="nowrap" class="padding_tb_5">
                                        <select name="secretLevel" id="secretLevel" class="" style="width: 200px">
                                            <option value="" selected>${ctp:i18n("common.pleaseSelect.label")}</option>
                                            <v3x:metadataItem metadata="${secretMeta}" showType="option"
                                                              name="secretLevel" bundle="${colI18N}"
                                                              switchType="zhangh"/>
                                        </select>
                                    </td>
                                    <%-- 签发日期 --%>
                                    <td align="right" width="60" nowrap="nowrap"
                                        class="padding_r_10">${ctp:i18n("edoc.element.sendingdate")}:
                                    </td>

                                    <td class="padding_tb_5">
                                        <input id="sendingDateStart" lastTime="${startRangeTime }"
                                               value="${startRangeTime }" readonly="readonly" style="width:92px;"
                                               class="comp validate"
                                               comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false"
                                               validate="name:'开始日期',notNull:true"/>
                                        <span>-</span>
                                        <input id="sendingDateEnd" lastTime="${endRangeTime }" value="${endRangeTime }"
                                               readonly="readonly" style="width:92px;" class="comp"
                                               comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false"/>
                                    </td>
                                    <%--签发人    --%>
                                    <td align="right" nowrap="nowrap" width="60"
                                        class="padding_r_10">${ctp:i18n("edoc.element.issuer") }:
                                    </td>
                                    <td nowrap="nowrap" class="padding_tb_5"><input type="text" name="issuer"
                                                                                    id="issuer" style="width:200px"
                                                                                    validate="maxLength" maxSize="20"
                                                                                    inputName="${ctp:i18n("edoc.element.issuer") }"/>
                                    </td>

                                </tr>

                                <tr class="hidden">
                                    <%--紧急程度--%>
                                    <td align="right" nowrap="nowrap" width="60"
                                        class="padding_r_10">${ctp:i18n("govdoc.urgentLevel.label") }:
                                    </td>
                                    <td nowrap="nowrap" class="padding_tb_5">
                                        <select name="urgentLevel" id="urgentLevel" class="" style="width: 200px">
                                            <option value="" selected>${ctp:i18n("common.pleaseSelect.label")}</option>
                                            <v3x:metadataItem metadata="${urgentMeta}" showType="option"
                                                              name="urgentLevel" bundle="${colI18N}"
                                                              switchType="zhangh"/>
                                        </select>
                                    </td>
                                    <%-- 公文级别 --%>
                                    <td align="right" width="60" nowrap="nowrap"
                                        class="padding_r_10">${ctp:i18n("edoc.element.unitLevel")}:
                                    </td>

                                    <td nowrap="nowrap" class="padding_tb_5">
                                        <select name="unitLevel" id="unitLevel" class="" style="width: 200px">
                                            <option value="" selected>${ctp:i18n("common.pleaseSelect.label")}</option>
                                            <v3x:metadataItem metadata="${unitLevelMeta}" showType="option"
                                                              name="unitLevel" bundle="${colI18N}" switchType="zhangh"/>
                                        </select>
                                    </td>
 									<%-- 主送单位 --%>
                                    <td align="right" width="60" nowrap="nowrap"
                                        class="padding_r_10">${ctp:i18n("edoc.element.sendtounit")}:
                                    </td>

                                    <td nowrap="nowrap" class="padding_tb_5"><input type="text" name="sendtounit"
                                                                                    id="sendtounit"
                                                                                    style="width:200px"
                                                                                    validate="maxLength" maxSize="20"
                                                                                    inputName="${ctp:i18n("edoc.element.sendtounit")}"/>
                                    </td>
                                </tr>
                                <tr class="hidden">                             
                                    <%-- 分送日期--%>
                                    <td align="right" width="60" nowrap="nowrap"
                                        class="padding_r_10">${ctp:i18n("edoc.element.packTime")}:
                                    </td>

                                    <td class="padding_tb_5">
                                        <input id="packStartTime" lastTime="${packStartTime }"
                                               value="${packStartTime }" readonly="readonly" style="width:92px;"
                                               class="comp validate"
                                               comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false"
                                               validate="name:'开始日期',notNull:true"/>
                                        <span>-</span>
                                        <input id="packEndTime" lastTime="${packEndTime }" value="${packEndTime }"
                                               readonly="readonly" style="width:92px;" class="comp"
                                               comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false"/>
                                    </td>
                                    <%--拟稿人    --%>
                                    <td align="right" nowrap="nowrap" width="60"
                                        class="padding_r_10">${ctp:i18n("edoc.edoctitle.createPerson.label") }:
                                    </td>
                                    <td nowrap="nowrap" class="padding_tb_5"><input type="text" name="createPerson"
                                                                                    id="createPerson" style="width:200px"
                                                                                    validate="maxLength" maxSize="20"
                                                                                    inputName="${ctp:i18n("edoc.edoctitle.createPerson.label ") }"/>
                                    </td>
                                </tr>              
                           
                                <!--页面 "查询" "重置" 按键居中  -->             
                                <tr>
                                	<td class="align_center" colspan="6">
                                        <div style="padding-top:0px;" class="align_center clear padding_lr_5 padding_b_10" id="button_div">
                                            <a href="javascript:void(0)"
                                               class="common_button common_button_emphasize margin_r_5" id="sendStatics"
                                               onclick="">${ctp:i18n("edoc.query.label") }</a><%-- 查询 --%>
                                            <a id="queryReset" class="common_button common_button_gray margin_r_10"
                                               href="javascript:void(0)"
                                               onclick="">${ctp:i18n("edoc.stat.execute.reset") }</a><%-- 重置 --%>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <input type="hidden" id="statTitle" name="statTitle"/>
                    </form>
                </div>
                <form action="#" id="resolveExecel">
                    <div id="execelCondition"></div>
                </form>
            </div>
            <!-- border_alls -->
        </div>
        <!-- tabs -->
    </div>

    <%--layout_center--%>
    <div class="layout_center page_color over_hidden" id="center" layout="border:false">

        <div class="" id="sendRegist_toolbar"></div>
        <table id="sendRegisterDataTabel" class="flexme3" style="display: none;">
        </table>

        <%-- 动态创建 推送条件或导出Excel的查询条件和查询列，采用jsonform分组提交 --%>
        <div id="dynamicForm" style="display: none;">
            <div id="columnDomain"></div>
            <div id="queryDomain"></div>
        </div>
    </div>

    <%--<div class="layout_north common_toolbar_box" layout="height:30,sprit:false,border:false">--%>
    <%--<div class="left" id="sendRegist_toolbar"></div>--%>
    <%--<div class="right" style="margin-top:7px;">--%>
    <%--<a id="combinedQuery" style="margin-right: 5px;" class="font_size14">${ctp:i18n('edoc.label.advanced')}</a>--%>
    <%--</div>--%>
    <%--<div style="clear: both;"></div>--%>
    <%--</div>--%>
    <%--<div class="layout_center page_color over_hidden" id="center" layout="border:false">--%>
    <%--<table id="sendRegisterDataTabel" class="flexme3" style="display: none;">--%>
    <%--</table>--%>
    <%----%>
    <%--&lt;%&ndash; 动态创建 推送条件或导出Excel的查询条件和查询列，采用jsonform分组提交 &ndash;%&gt;--%>
    <%--<div id="dynamicForm" style="display: none;">--%>
    <%--<div id="columnDomain"></div>--%>
    <%--<div id="queryDomain"></div>--%>
    <%--</div>--%>
    <%--</div>--%>
</div>
</body>
</html>