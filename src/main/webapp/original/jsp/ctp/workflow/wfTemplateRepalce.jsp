<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('workflow.replaceNode.01')}</title>
</head>
<body>
<div class="form_area">
        	<div class="form_area_content one_row" style="width:100%;">
<table width="100%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0">
	<tbody>
    <tr>
        <th nowrap="nowrap">
        	<label class="margin_l_5 margin_r_5">
        		${ctp:i18n('workflow.replaceNode.02')} : 
        	</label>
        </th>
        <td width="60%">
        	<div id="replacedAreaDiv" class="common_txtbox_wrap">
        		<input id="replacedArea" class="text_overflow" type="text" value="<${ctp:i18n('workflow.replaceNode.03')}!>" readonly/>
        	</div>
        </td>
        <td><span id="selectRedPeople" class="ico24 enableNode_24" title="${ctp:i18n('workflow.replaceNode.04')}"></span>
        </td>
        <td><span id="selectDelRedPeople" class="ico24 disableNode_24" title="${ctp:i18n('workflow.replaceNode.05')}"></span>
        </td>
        <td>
        	<a id="btnsearch" class="common_button common_button_emphasize margin_r_5" href="javascript:void(0)">&nbsp;&nbsp;
        		${ctp:i18n('workflow.replaceNode.06')}&nbsp;&nbsp;&nbsp;&nbsp;</a>
        </td>
    </tr>
    <c:choose>
    <c:when test="${canEdit==true}">
    <tr id="">
        <th nowrap="nowrap">
        	<label class="margin_l_5 margin_r_5">
        		${ctp:i18n('workflow.replaceNode.07')} : 
        	</label>
        </th>
        <td width="60%">
        	<div id="replaceAreaDiv" class="common_txtbox_wrap">
        		<input id="replaceArea" type="text" value="<${ctp:i18n('workflow.replaceNode.08')}>" readonly/>
        	</div>
        </td>
        <td><span id="selectRePeople" class="ico24 replaceNode_24" title="${ctp:i18n('workflow.replaceNode.04')}"></span>
        </td>
        <td>
        	&nbsp;
        </td>
        <td>
        	<a id="btnreplace" class="common_button common_button_emphasize margin_r_5" href="javascript:void(0)">&nbsp;&nbsp;
        	${ctp:i18n('workflow.replaceNode.09')}&nbsp;&nbsp;&nbsp;&nbsp;
        	</a>
        </td>
    </tr>
    </c:when>
    <c:otherwise>
		<tr id="">
			<th nowrap="nowrap">&nbsp;</th>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
    </c:otherwise>
    </c:choose>
    <tr id="" class="bg_color_gray">
        <th nowrap="nowrap">
        	<div style="border-bottom:#d4d4d4 1px solid;border-top:#d4d4d4 1px solid;height:100%;width:100%;">&nbsp;</div>
        </th>
        <th width="60%">
        	<div style="text-align:center;border-bottom:#d4d4d4 1px solid;border-top:#d4d4d4 1px solid;height:100%;width:100%;">
        	<a id="btnreset" class="common_button common_button_gray" href="javascript:void(0)">&nbsp;&nbsp;&nbsp;
        		${ctp:i18n('workflow.replaceNode.10')}&nbsp;&nbsp;&nbsp;&nbsp;</a>
        	</div>
        </th>
        <th>
        	<div style="border-bottom:#d4d4d4 1px solid;border-top:#d4d4d4 1px solid;height:100%;width:100%;">&nbsp;</div>
        </th>
        <th>
        	<div style="border-bottom:#d4d4d4 1px solid;border-top:#d4d4d4 1px solid;height:100%;width:100%;">&nbsp;</div>
        </th>
        <th>
        	<div style="border-bottom:#d4d4d4 1px solid;border-top:#d4d4d4 1px solid;height:100%;width:100%;">&nbsp;</div>
        </th>
    </tr>
    <tr id="resultTitle" style="display:none;" class="bg_color_gray">
        <th nowrap="nowrap">
        	<label class="margin_l_5 margin_r_5">
        		${ctp:i18n('workflow.replaceNode.11')} : 
        	</label>
        </th>
        <td width="200">
        	<label class="margin_r_10" id="toExcelBtn">
        		<span class="hand"><span class="ico16 export_excel_16"></span>&nbsp;&nbsp;${ctp:i18n('workflow.replaceNode.12')}</span>
        	</label>
        </td>
        <td>
        </td>
        <td>
        	&nbsp;
        </td>
        <td>&nbsp;
        </td>
    </tr>
    </tbody>
</table>
</div>
</div>
			<div id="resultListArea" class="page_color over_hidden" style="display:none;width:100%;height:322px;">
                <table id="resultList" class="flexme3" style="display: none;"></table>
			</div>
<form id="downLoadForm" target="downLoadIframe" style="display:none" method="post">
	<input id="method" name="method" value="toExcelDownload">
	<input id="data" name="data" type="hidden" value="">
	<input id="searchText" name="searchText" type="hidden" value="">
</form>
<iframe id="downLoadIframe" name="downLoadIframe" src="" style="display:none"></iframe>
<%@include file="wfTemplateRepalce_js.jsp"%>
<%@include file="workflowDesigner_js_api.jsp"%>
</body>
</html>