<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/common/template/specialCharUtil.js.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/info/js/templateGovChoose.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var category='32';
var accountId ='${accountId}';
var searchType = '${searchType}';
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north page_color" layout="height:30,border:false">
             <div class="clearfix margin_t_5 margin_l_10 margin_b_10">
                <span class="valign_m font_size12">${ctp:i18n('template.templateChoose.inquiry')}:</span><!-- 查询 -->
                <select id="searchType" class="valign_m" onchange='javascript:doSerch(this)'>
                    <option value="0">${ctp:i18n('template.templateChoose.query')}</option><!-- --查询条件-- -->
                    <!-- 模版名称 -->
                    <option value="1" <c:if test='${searchType eq "1"}'>selected</c:if>>${ctp:i18n('template.templateChoose.templateName')}</option>
                </select>
                <input id="templateName" type="text" class="valign_m" value='${sName}'></input>
                <span id="searchSpan"><a href="#"><em class="ico16 search_16"></em></a></span>
            </div>
        </div>
        <div class="layout_center over_hidden" layout="border:true" id="layout_center_id">
            <div class="common_tabs clearfix">
                <ul class="left">
                    <li id="formlist" class="current"><a hidefocus="true" href="javascript:showFormListView()">${ctp:i18n('govform.label.formcreat.infoform')}<!-- 报送单 --></a></li>
                    <li id="contentBut"><a hidefocus="true" href="javascript:showContentView()">${ctp:i18n('collaboration.summary.text')}</a></li><!-- 正文 -->
                    <li id="workFlowBut"><a hidefocus="true" href="javascript:showWorkFlow()">${ctp:i18n('collaboration.workflow.label')}</a></li><!-- 流程 -->
                	<li id="workFlowDescBut"><a hidefocus="true" href="javascript:showHelp()" class="last_tab">${ctp:i18n('template.templateChoose.instructionsForUse')}</a></li><!-- 使用说明 -->
                </ul>
            </div>
            <div class="hr_heng"></div>
            <div>
                  <iframe id="displayIframe" style="width:100%;height:100%;overflow:scroll" frameborder="0"></iframe>          
            </div>            
        </div>
        <div class="layout_west" layout="width:200">
            <div class="padding_5">
                <ul id="tree" class="treeDemo_0 ztree"></ul>
            </div>
        </div>
    </div>
</body>
</html>