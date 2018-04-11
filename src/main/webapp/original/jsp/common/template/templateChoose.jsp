<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/common/template/specialCharUtil.js.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/template/js/templateChoose.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
// 是否我的模板配置
var templateChoose = "${templateChoose}";
var category ='${category}';
var accountId='${accountId}'; 
var searchType = '${searchType}';
var smtype = '${smtype}';

</script>
<style>
.spiret_T,.spiret_L{ background: #fafafa;}
.layout_center,.layout_west{ background: #fff;}
</style>
</head>
<body class="dialog_bg">
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north page_color" layout="height:30,border:false">
             <div class="clearfix margin_t_5 margin_l_10 margin_b_10">
                <span class="valign_m font_size12">${ctp:i18n('template.templateChoose.inquiry')}:</span><!-- 查询 -->
                <select id="searchType" class="valign_m" onchange='javascript:doSerch(this)'>
                    <option value="0">${ctp:i18n('template.templateChoose.query')}</option><!-- --查询条件-- -->
                    <!-- 模版名称 -->
                    <option value="1" <c:if test='${searchType eq "1"}'>selected</c:if>>${ctp:i18n('template.templateChoose.templateName')}</option>
                    <!-- 所属应用 -->
                    <option value="2" <c:if test='${searchType eq "2"}'>selected</c:if>>${ctp:i18n('template.selectSourceTem.transformationOfApplied')}</option>
                </select>
                <input id="templateName" type="text" class="valign_m" value='${sName}'></input>
                <select id="templateTypes" class="valign_m">
                	'${htmlStr}'                
                </select>
                <span id="searchSpan"><a><em class="ico16 search_16"></em></a></span>
            </div>
        </div>
        <div class="layout_center over_hidden"  layout="border:true" id="layout_center_id">
            <div class="common_tabs clearfix" id="common_tabs_id">
                <ul class="left">
                    <li id="articleBut" style="display:none" class="current"><a hidefocus="true" href="javascript:showDocPage()" class="border_b">${ctp:i18n('template.templateChoose.textAlone')}</a></li><!-- 文单 -->
                    <li id="formlist"  style="display:none" class="current"><a hidefocus="true" href="javascript:showFormListView()">${ctp:i18n('govform.label.formcreat.infoform')}<!-- 报送单 --></a></li>
                    <li id="contentInfoBut" style="display:none"><a hidefocus="true" href="javascript:showContentViewInfo()">${ctp:i18n('collaboration.summary.text')}</a></li><!-- 正文 -->
                    <li id="articleContentBut" style="display:none"><a hidefocus="true" href="javascript:showDocContentView()">${ctp:i18n('collaboration.summary.text')}</a></li><!-- 正文 -->
                    <li id="contentBut" class="current"><a hidefocus="true" href="javascript:showContentView()">${ctp:i18n('collaboration.summary.text')}</a></li><!-- 正文 -->
                    <li id="workFlowBut"><a hidefocus="true" href="javascript:showWorkFlow()">${ctp:i18n('collaboration.workflow.label')}</a></li><!-- 流程 -->
                    <li id="workFlowDescBut"><a hidefocus="true" href="javascript:showHelp()" class="last_tab">${ctp:i18n('template.templateChoose.instructionsForUse')}</a></li><!-- 使用说明 -->
                </ul>
            </div>
            <div class="hr_heng" id="hr_heng_id"></div>
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