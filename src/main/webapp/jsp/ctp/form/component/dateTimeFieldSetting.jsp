<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:2017-02-16
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>日期设置</title>
    <style type="text/css">
        .stadic_body_top_bottom { bottom: 0px; top: 0px; }
    </style>
    <script type="text/javascript" src="${path}/common/form/component/dateTimeFieldSetting.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
    	var parentArgs = window.parentDialogObj["formFieldRename4Yzxx"].getTransParams();
        var inputType = "${inputType}";
        var fieldType = "${fieldType}";
    </script>
</head>
<body class="h100b over_hidden">
    <div class="stadic_layout_body stadic_body_top_bottom border_t page_color">
            <table align="center" class="margin_t_10 font_size12">
                <tr>
                    <td>
                        ${ctp:i18n('permission.operation.wait.choose')}<%--候选操作 --%><br />
                        <select id="reserve" name="reserve" multiple="multiple" class="margin_t_10" 
                            style="width: 230px; height: 290px;">
                            <c:forEach items="${dateVarList}" var="unSelectedDateTime">
                                <option value="${unSelectedDateTime[0]}" isSystemVar="${unSelectedDateTime[2]}">${ctp:i18n(unSelectedDateTime[1])}</option>
                            </c:forEach>
                        </select>
                        <%-- 自定义 --%>
                        <div style="width: 230px; height: 30px;margin-top: 10px;">
                        	<a href="javascript:void(0)" id="userDefId" class="common_button common_button_gray margin_l_5" style="text-align: center;">${ctp:i18n('form.oper.new.label')}</a>
                            <a href="javascript:void(0)" id="userDelete" class="common_button common_button_gray margin_l_5" style="text-align: center;">${ctp:i18n('common.toolbar.delete.label')}</a>
                        </div>
                    </td>
                    <td>
                        <em class="ico16 select_selected" id="toRight"></em><br /><br />
                        <em class="ico16 select_unselect" id="toLeft"></em>
                    </td>
                    <td>
                        ${ctp:i18n('permission.operation.check.choose')}<%--选中操作 --%><br />
                        <select id="selected" name="selected" multiple="multiple" class="margin_t_10" 
                            style="width: 230px; height: 330px;">
                            
                        </select>
                    </td>
                    <td>
                        <em class="ico16 sort_up" id="toUp"></em><br /><br/>
                        <em class="ico16 sort_down" id="toDown"></em>
                    </td>
                </tr>
            </table>
        </div>
</body>
</html>
