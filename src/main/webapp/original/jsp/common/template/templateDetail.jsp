<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/template/template_print.js.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<title></title>
<script>
  var isHide = true;
  var isTemplatePage = true;
  $(function() {
    var layout = $("#layout").layout();
    layout.setEast(55);
    $("#tabs2").hide();
    $("#right_tab_btn").show();
    //附件控制
    if ('${hasAttachments}' != 'true') {
      $("#nm").css("display", "none");
    } else {
      $("#kzdiv").css("height", parseInt($("#kzdiv").css("height")) + 30);
    }
    $(".slideUpBtn",parent.document).click(function(){
      if(isHide)
        try{setTimeout("layoutEastClose()",10);}catch(e){}
    });
    $(".slideDownBtn",parent.document).click(function(){
      if(isHide)
        try{setTimeout("layoutEastClose()",10);}catch(e){}
    });
    
    $(window).resize(function(){
        $("#tabs2").tab().resetSize();
    });
    var contentType;
    if(typeof(getMainBodyDataDiv$) != 'undefined'){
	    contentType = $("#contentType", getMainBodyDataDiv$()).val();
    }
    if(contentType=='41' 
      ||contentType=='10' 
      || contentType=='42' 
      || contentType=='43' 
      || contentType=='44' 
      || contentType=='45'){
       $("#cc").css("height",'500px').css("font-size",'2px');//.css("padding-top",'0px').css("padding-left",'5px').css("padding-right",'0px').css("padding-bottom",'0px');
       $("#cc .content_text").css("padding-top",'0px').css("padding-left",'5px').css("padding-right",'0px').css("padding-bottom",'0px');
    }
  })
  function layoutEastClose() {
    isHide = true;
    var layout = $("#layout").layout();
    layout.setEast(55);
    $("#tabs2").hide();
    $("#right_tab_btn").show();
  }
  function layoutEastShow(n) {
    isHide = false;
    var layout = $("#layout").layout();
    if (n == 0 || n == 1) {
        layout.setEast(250);
        $("#tabs2").show();
        $("#tabs2").tab().resetSize();
        $("#right_tab_btn").hide();
    }
    if(${template.type ne 'text'}){
	    $("#tabs2_head li:eq(" + n + ") a").trigger("click");
    }else{
    	$("#tabs2_head li:eq(" + (n-1) + ") a").trigger("click");
    }
  }
  function getWFinfo(wfId) {
    var url = '${path}/workflow/designer.do?method=showDiagram&isTemplate=true&showPeopleTip=false&isDebugger=false&scene=2&isModalDialog=false&processId='
        + wfId;
    $("#showWFinfo").attr("src", url);
    $("#tabs2_body").removeClass("over_auto");
    //window.location = url;
  }
  function setCname() {
    $("#tabs2_body").addClass("over_auto");
  }
</script>
<style type="text/css">
.stadic_head_height {
  height: 82px;
}

.stadic_body_top_bottom {
  bottom: 0px;
  top: 82px;
}
</style>
</head>
<body>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="layout_east" class="layout_east over_hidden" layout="width:250,border:false">
            <div id="right_tab_btn" class="hidden">
                <c:if test="${template.type ne 'text'}"><a href="javascript:void(0)" class="common_button common_button_gray" onclick="layoutEastShow(0)">${ctp:i18n('collaboration.workflow.label')}</a><br /></c:if><!-- 流程 -->
                <a href="javascript:void(0)" class="common_button common_button_gray margin_t_5" onclick="layoutEastShow(1)">${ctp:i18n('template.templateDeatail.property')}</a><br /><!-- 属性 -->
                <c:if test="${template.type ne 'workflow' && openFrom ne 'tempConfigFrame'}"><a href="javascript:void(0)" class="common_button common_button_gray margin_t_5" onclick="layoutEastShow(2)">${ctp:i18n('collaboration.newcoll.print')}</a></c:if><!-- 打印 -->
            </div>
            <div id="tabs2" class="comp" comp="type:'tab',parentId:'layout_east'">
                <div id="tabs2_head" class="common_tabs clearfix">
                    <div class="left padding_t_5 padding_l_10 padding_r_5" onclick="layoutEastClose()"><span class="ico16 arrow_2_r"></span></div>
                    <ul class="left">
                        <c:if test="${template.type ne 'text'}"><li class="current"><a href="javascript:void(0)" tgt="tab1_div" onclick="getWFinfo('${wfId}')"><span>${ctp:i18n('collaboration.workflow.label')}</span></a></li></c:if><!-- 流程 -->
                        <li><a href="javascript:void(0)" tgt="tab2_div" onclick="setCname()"><span>${ctp:i18n('template.templateDeatail.property')}</span></a></li><!-- 属性 -->
                        <c:if test="${template.type ne 'workflow' && openFrom ne 'tempConfigFrame'}"><li><a class="last_tab" onclick="doPrint('template')"><span>${ctp:i18n('collaboration.newcoll.print')}</span></a></li></c:if><!-- 打印 -->
                    </ul>
                </div>
                <div id="tabs2_body" class="common_tabs_body border_all over_auto">
                    <div id="tab1_div" style="border: 20px;">
                    	<iframe id="showWFinfo" src="" style="width:100%;height:100%;" frameborder="0" scrolling="no"></iframe>
                    </div>
                    <div id="tab2_div" class="hidden">
                        <table class="font_size12 line_height100 margin_t_10" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <!-- 流程期限 -->
                                <td width="60" align="right" class="padding_r_10">${ctp:i18n("collaboration.process.cycle.label")}:</td>
                                <td><input type="text" name="name" disabled='true' value="${deadLine}" /></td>
                            </tr>
                            <tr>
                                <td width="60" align="right" class="padding_r_10">${ctp:i18n('common.remind.time.label')}:</td><!-- 提醒 -->
                                <td><input type="text" name="name" disabled='true' value="${remind}" /></td>
                            </tr>
                            <c:if test="${v3x:getSysFlagByName('col_showRelatedProject') == true && ctp:hasPlugin('doc')}">
                            <tr>
                                <td width="60" align="right" class="padding_r_10">${ctp:i18n('collaboration.newcoll.relatepro2')}:</td><!-- 关联项目 -->
                                <td><input type="text" name="name" disabled='true' value="${projectName}" /></td>
                            </tr>
                            </c:if>
                            <c:if test="${ctp:hasPlugin('doc')}">
                            <tr>
                                <td width="60" align="right" class="padding_r_10">${ctp:i18n('template.templateDeatail.prearchivedTo')}:</td><!-- 预归档到 -->
                                <td><input type="text" title="${archiveAllName}" name="name" disabled='true' value="${archiveName}" /></td>
                            </tr>
                            <tr>
                                <td width="60" align="right" class="padding_r_10">${ctp:i18n('template.templateDeatail.prearchivedAttTo')}:</td><!-- 附件归档目录 -->
                                <td><input type="text" title="${attachmentArchiveAllName}" name="name" disabled='true' value="${attachmentArchiveName}" /></td>
                            </tr>
                            </c:if>
                            <tr>
                                <td width="60" align="right" class="padding_r_10">${ctp:i18n('collaboration.newcoll.isNoProcess')}</td><!-- 是否追溯流程 -->
                                <td>
									<c:if test="${temTraceType eq 0}">${ctp:i18n('trace.label.designby')}</c:if>
                    				<c:if test="${temTraceType eq 1}">${ctp:i18n('trace.label.zhuisuo')}</c:if>
                    				<c:if test="${temTraceType eq 2}">${ctp:i18n('trace.label.buzhuisuo')}</c:if> 
								</td>
                            </tr>
                            <tr>
                                <td width="60" align="right" class="padding_r_10"></td>
                                <td>
                                    <div class="common_checkbox_box clearfix ">
                                        <label for="Checkbox5" class="margin_t_5 hand display_block">
                                            <input type="checkbox" value="0" id="Checkbox5" name="option" disabled='true' <c:if test="${summary.canForward}">checked</c:if> class="radio_com">${ctp:i18n('common.toolbar.transmit.label')}</label><!-- 转发 -->
                                        <label for="Checkbox6" class="margin_t_5 hand display_block">
                                            <input type="checkbox" value="0" id="Checkbox6" name="option" disabled='true' <c:if test="${summary.canModify}">checked</c:if> class="radio_com">${ctp:i18n('collaboration.allow.chanage.flow.label')}</label><!-- 改变流程 -->
                                        <label for="Checkbox7" class="margin_t_5 hand display_block">
                                            <input type="checkbox" value="0" id="Checkbox7" name="option" disabled='true' <c:if test="${summary.canEdit}">checked</c:if> class="radio_com">${ctp:i18n('collaboration.allow.edit.label')}</label><!-- 修改正文 -->
                                        <label for="Checkbox7" class="margin_t_5 hand display_block">
                                            <input type="checkbox" value="0" id="Checkbox7" name="option" disabled='true' <c:if test="${summary.canEditAttachment}">checked</c:if> class="radio_com">${ctp:i18n('collaboration.newcoll.xgfj')}</label><!-- 修改附件 -->
                                        <c:if test="${ctp:hasPlugin('doc')}">
	                                        <label for="Checkbox8" class="margin_t_5 hand display_block">
	                                            <input type="checkbox" value="0" id="Checkbox8" name="option" disabled='true' <c:if test="${summary.canArchive}">checked</c:if> class="radio_com">${ctp:i18n('common.toolbar.pigeonhole.label')}</label><!-- 归档 -->
                                    	</c:if>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="layout_center" layout="border:false">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height" id='kzdiv'>
                    <table class="font_size12 line_height100" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td width="80" align="right" class="padding_t_10">${ctp:i18n('collaboration.newcoll.subject')}&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                            <td class="padding_t_10"><span id="subject">${ctp:toHTMLWithoutSpace(template.subject)}</span></td>
                        </tr>
                        <tr>
                            <td width="80" align="right" class="padding_t_10"  nowrap="nowrap">${ctp:i18n('template.temPrint.createMember')}&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                            <td class="padding_t_10"><span id="senderInfo">${senderInfo}</span></td>
                        </tr>
                        <tr id="nm">
                        	<td width="80" align="right" class="padding_t_10">${ctp:i18n('common.attachment.label')}&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                            <td>
                                <table>
                                    <tr>
                                        <td class="padding_t_10">(<span id="attachmentNumberDiv22"></span>)</td>
                                        <td class="padding_t_10" align="left">
                                            <c:choose>
                                                <c:when test="${openFrom eq 'tempConfigFrame'}">
                                                     <input id="myfile" type="text" class="comp" comp="type:'fileupload',applicationCategory:'1',attachmentTrId:'22',canDeleteOriginalAtts:false,originalAttsNeedClone:'${cloneOriginalAtts}'"
                                                attsdata='${attListJSON}' />
                                                </c:when>
                                                <c:otherwise>
                                                    <input id="myfile" type="text" class="comp" comp="type:'fileupload',applicationCategory:'1',canFavourite:false,attachmentTrId:'22',canDeleteOriginalAtts:false,originalAttsNeedClone:'${cloneOriginalAtts}'"
                                                attsdata='${attListJSON}' />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="hr_heng"></div>
                <!-- 正文组建开始 -->
                <div id="content_workFlow" class="stadic_body_top_bottom content_view processing_view align_center">
                  <ul class="view_ul align_left content_view" id='display_content_view'>
                    <li id="cc" class="view_li" style="margin-bottom: 2px;width:auto;min-width:786px">
                        <jsp:include page="/WEB-INF/jsp/common/content/content.jsp" />
                    </li>
                    <!--附言区域-->
						<jsp:include
							page="/WEB-INF/jsp/common/content/commentForSummary.jsp" />
					</ul>
                </div>
                <!-- 正文组件结束 -->
      </div>
        </div>
    </div>
</body>
</html>
<script>
</script>
