<%--
 $Author: maxc $
 $Rev: 2034 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=templateManager"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- 模版选择 -->
<title>${ctp:i18n('template.templateChooseM.templateSelect')}</title>
<script type="text/javascript">
var isShowTreeBySearch=false;
var moduletype='${type}';
var isMul="${ctp:escapeJavascript(isMul)}";
var isCanSelectCategory = ${empty isCanSelectCategory ? false : true};
var isPortal = '${param.isPortal}';
var isComponent = "${ctp:escapeJavascript(param.isComponent)}";
var hasSelectedTemplateIds = '${param._tids}';
</script>
<script type="text/javascript" src="${path}/apps_res/template/js/templateChooseM.js${ctp:resSuffix()}"></script>
</head>
<body class="page_color">
	<input type="hidden" id="moduleType" value="${moduleType}"/>
	<input type="hidden" id="accountId" value="${v3x:toHTML(accountId)}"/>
	<input type="hidden" id="isMul" value="${isMul}"/>
	<input type="hidden" id="scope" value="${v3x:toHTML(scope)}"/>
    <input type="hidden" id="excludeTemplateIds" value="${v3x:toHTML(param.excludeTemplateIds)}"/>
    <input type="hidden" id="memberId" value="${param.memberId}"/>
    <input type="hidden" id="reportId" value="${param.reportId}"/>
    <div id="htmlID" class="">
        <div class="padding_b_10 padding_l_10 padding_t_0 font_size12" style="margin-left: 10px;">
            <div class="clearfix">
                <span class="valign_m">${ctp:i18n('template.templateChoose.inquiry')}:</span><!-- 查询 -->
                <select id="searchType" class="valign_m">
                    <option value="0">${ctp:i18n('template.templateChoose.query')}</option><!-- --查询条件-- -->
                    <option value="1">${ctp:i18n('template.templateChoose.templateName')}</option><!-- 模版名称 -->
                    <option value="2">${ctp:i18n('template.selectSourceTem.transformationOfApplied')}</option><!-- 所属应用 -->
                </select>
                <input id="templateName" type="text" class="valign_m" />
                <select id="templateTypes" class="valign_m">
                ${categoryHTML}
                </select>
                <span id="searchSpan"><a href="javascript:void(0)"><em class="ico16 search_16"></em></a></span>
            </div>
            <div class="hr_heng margin_t_5" style="border:none;background:rgb(250,250,250)"></div>
            <table cellpadding="0" cellspacing="0" border="0" height="380" class="w100b margin_t_5" style="*margin-top:2px;">
                <tr height="25">
                    <td style="color:#333">${ctp:i18n('template.templateChooseM.options')}</td><!-- 可选项 -->
                    <td style="color:#333"></td>
                    <td style="color:#333">${ctp:i18n('template.templateChooseM.hasOptions')}</td><!-- 已选项 -->
                    <td style="color:#333"></td>
                </tr>
                <tr>
                    <td valign="top" width="225" height="420">
                        <div class="border_all" style="width:305px;height:100%;overflow:auto;background-color: white;padding-left: 10px;">
                        	<div id="templateTree">
                        	</div>
                        </div>
                    </td>
                    <td width="20" class="padding_lr_10" style="    text-align: center;">
                        <span id="select_selected" class="ico16 select_selected margin_b_10"></span><br /><span id="select_unselect" class="ico16 select_unselect"></span>
                    </td>
                    <td valign="top" width="225" height="420">
                        <select id="selectedNodes" class="border_all" multiple="multiple" style="height:100%;width:305px;overflow:auto;background-color: white;">
                        
                        </select>
                    </td>
                    <td width="16" class="padding_lr_10" style="    text-align: center;">
                    	<c:if test="${isMul}">
                    	<span id="sort_up" class="ico16 sort_up margin_b_10"></span> <br />
                        <span id="sort_down" class="ico16 sort_down"></span>
                        </c:if>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>