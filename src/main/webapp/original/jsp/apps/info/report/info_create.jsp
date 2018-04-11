<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/gov/govtemplate/templateGov.js.jsp" %>
<html class="h100b over_hidden">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" charset="UTF-8" src="${path}/ajax.do?managerName=govformAjaxManager,govTemplateManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path }/common/office/js/office.js${ctp:resSuffix()}" /></script>
<script type="text/javascript" charset="UTF-8" src="${path }/apps_res/info/js/common/gov_content.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path }/apps_res/info/js/common/gov_pigeonhole.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path }/apps_res/info/js/info_create/info_create.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path }/apps_res/info/js/info_create/info_template.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path }/apps_res/info/js/summary/info_opinion.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var isSubmitOperation; //直接离开窗口做出提示的标记位
var newInfo_layout;//动态布局layout对象
var tb;
var bodyType = "${contentList[0].contentType }";
var contentType = "${contentList[0].contentType }";
var isSystemTemplete = '${summaryVO.isSystemTemplete}'=='true';
var uuidlong = '${uuidlong}';
var zdgzid ="${summaryVO.forGZShow}";
var tracktypeeq2 = ${trackType eq 2};
var fgzids = '${forGZIds}';
var tracktypeeq0 = ${trackType eq 0};
var wfXmlInfo= '${summaryVO.wfXMLInfo}';
var vobjtrackids = "${vobj.trackIds}";
var isSysTem = false;
var deadl = '${summaryVO.summary.deadline}';
var summaryId = '${summaryVO.summary.id}';
var _currentUserId = '${user.id}';
var advanceR = '${summaryVO.summary.advanceRemind}';
var frompeoplecardflag = '${peopeleCardInfo != null}' == 'true';

var fromCallTemplate ='${callTemplate}';

/** 指定回退发送 start */
var fromSendBack = ${fromSendBack=='true'};
var optionType = '${optionType}';
${opinionsJs}
${opinionElementsJs}
var isOutOpinions = false;
var orgnialTemplateFlag ='${orgnialTemplate}';
var formDisableWarning = '${formDisableWarning}'=='true';
var magazineFilePath = "${folder}";//期刊转信息时，保存期刊的文件路径
/** 指定回退发送 end */
</script>
<body class="h100b page_color" >
<form method="post" id="sendForm"  name="sendForm" class="h100b">

<div id='newInfo_layout' class="comp" comp="type:'layout'">
	<div class="layout_north" layout="height:105,border:false,sprit:false">
		<div id="north_area_h">
			<div class="padding_l_5">
				<div id="toolbar"></div>
			</div>
			<div class="hr_heng"></div>

			<div id="colMainData" class="form_area new_page">
				<input type="hidden" id="subState" name="subState" value="${subState }">
				<input type="hidden" id="fromSendBack" value="${fromSendBack }" />
				<input type="hidden" id="optionType" value="${optionType }" />
				<input type="hidden" id="stepBackWay" />

				<input type="hidden" id="temformParentId" name="temformParentId" value="${temformParentId}" />
			    <INPUT TYPE="hidden" id="curTemId" name="curTemId" value="${curTemId}" />
			    <input type="hidden" id="resend" name="resend" value="" />
			    <input type="hidden" id="newBusiness" name="newBusiness" value="" />
			    <input type="hidden" id="parentSummaryId" name="parentSummaryId" value=""/>
			    <input type="hidden" id="tId" name="tId" value='${curTemId}'/>
			    <input type="hidden" id="resentTime" name="resentTime" value=""/>
			    <input type="hidden" id="archiveId" name="archiveId" value="${summaryVO.summary.archiveId }" />
			    <input type="hidden" id="prevArchiveId" name="prevArchiveId" value="${summaryVO.summary.archiveId }" />
			    <input type="hidden" id="tembodyType" name="tembodyType" value="" />
			    <input type="hidden" id="formtitle" name="formtitle" value="<c:out value='' escapeXml='true' />" />
			    <input type="hidden" id="saveAsTempleteSubject" name="saveAsTempleteSubject" value="">
			    <input type="hidden" id="phaseId" name="phaseId" value="" />
	            <input type="hidden" id="caseId" name="caseId" value="${summaryVO.summary.caseId }">
	            <input type="hidden" id="currentaffairId" name="currentaffairId" value="${summaryVO.affair.id }">
	            <input type="hidden" id="createDate" name="createDate" value="" />
	            <input type="hidden" id="useForSaveTemplate" name="useForSaveTemplate" value='no'/>
	            <input type="hidden" id="oldProcessId" name="oldProcessId" value="${summaryVO.summary.processId }"/>
	            <input type="hidden" id="temCanSupervise" name="temCanSupervise" value="${template.canSupervise}" />
	            <input type="hidden" id="standardDuration" name="standardDuration"  value=""></input>
	            <input type="hidden" id="forwardMember" name="forwardMember" value="" />
	            <input type="hidden" id="saveAsFlag" name="saveAsFlag"/>
	            <input type="hidden" id='transtoColl' name='transtoColl' value='0'></input>
	            <input type="hidden" id='bzmenuId' name='bzmenuId' value=''></input>
	            <input type="hidden" id='newflowType' name='newflowType' value=''></input>
	            <input type="hidden" id='contentViewState' name='contentViewState' value='${contentViewState}'></input>
	            <input type="hidden" id="id" name="id" value="${summaryVO.summary.id }" />
	            <input type="hidden" id="infoType" name="infoType" value="0" />
	            <input type="hidden" id="moduleId" name="moduleId" value="${summaryVO.summary.id }" />
	            <input type="hidden" id="contentId" name="contentId" value="${contentList[0].id }" />
	            <input type="hidden" id="action" name="action" value="${action }" />
	            <input type="hidden" id="bodyType" name="bodyType" value="${contentList[0].contentType }" />
	            <input type="hidden" id="state" name="state" value="${summaryVO.summary.state }" />
	            <input type="hidden" id="auditState" name="auditState" value="${summaryVO.summary.auditState }" />
	            <input type="hidden" id="publishState" name="publishState" value="${summaryVO.summary.publishState }" />
	            <input type="hidden" id="isFailure" name="isFailure" value="${summaryVO.summary.isFailure }" />
	            <input type="hidden" id="infoSubject" name="infoSubject" value="${ctp:toHTML(summaryVO.summary.subject)}" />
		      	<%@ include file="info_property.jsp" %>
		     	<div id="attachmentTRAtt" style="display:none;">
		             <table border="0" cellspacing="0" cellpadding="0" width="100%" class="line_height180">
		                 <tr id="attList">
		                     <td width="3%">&nbsp;</td>
		                     <td class="align_right"  width="88" nowrap="nowrap"><div class="div-float" >${ctp:i18n('common.attachment.label')}<!-- 附件 -->：(<span id="attachmentNumberDivAtt"></span>) </div></td>
		                     <td class="align_left">
		                         <div id="attFileDomain"  class="comp" comp="type:'fileupload',attachmentTrId:'Att',applicationCategory:'32',canFavourite:false,canDeleteOriginalAtts:${canDeleteOriginalAtts},originalAttsNeedClone:${originalAttsNeedClone },callMethod:'insertAtt_AttCallback',takeOver:false" attsdata='${attListJSON }'></div>
		                     </td>
		                 </tr>
		             </table>
		         </div><!-- attachmentTRAtt -->
		         <div id="attachment2TRDoc1" style="display:none;">
		             <table border="0" cellspacing="0" cellpadding="0" width="100%" class="line_height180">
		                 <tr id="docList">
		                     <td width="3%">&nbsp;</td>
		                     <td class="align_right"  width="88" nowrap="nowrap"><div class="div-float">${ctp:i18n('common.mydocument.label')}<!-- 关联文档 -->：(<span id="attachment2NumberDivDoc1"></span>) </div></td>
		                     <td class="align_left">
		                         <div class="comp" id="assDocDomain" comp="type:'assdoc',attachmentTrId:'Doc1',modids:'1,3',applicationCategory:'32',referenceId:'0',canDeleteOriginalAtts:${canDeleteOriginalAtts },originalAttsNeedClone:${originalAttsNeedClone },callMethod:'quoteDoc_Doc1Callback'" attsdata='${attListJSON }'></div>
		                     </td>
		                 </tr>
		             </table>
		         </div><!-- attachment2TRDoc1 -->

		        
 <div style="width:0px;height:0px;overflow:hidden; position: absolute;"><jsp:include page="/WEB-INF/jsp/common/content/content.jsp" /></div>
		    </div><!-- infoMainData -->
	    </div><!-- north_area_h -->
	</div><!-- layout_north -->

	<div class="layout_center" style="overflow:auto;background:#fff;" layout="border:false,spiretBar:{show:false}">
		<%@ include file="../../gov/govform/form_show.jsp" %>
	</div>

	<div class="layout_east over_hidden padding_l_5" id="comment_deal" layout="width:35,border:false,sprit:false">
		<input type="hidden" id="id" value="${summaryVO.sendOpinion.id }">
		<input type="hidden" id="affairId" value="${summaryVO.sendOpinion.affairId }">
		<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="border_all">
			<tr>
				<td valign="top" height="20" class="padding_t_5 align_center font_size12">
                       <em id="adtional_ico" class="ico16 arrow_2_l"></em>
                       <span class="adtional_text display_block margin_t_5">${ctp:i18n('collaboration.newcoll.dangfu')}</span>
						<span class="adtional_text display_block margin_t_5">${ctp:i18n('collaboration.newcoll.dangyan')}</span>
						<div class="color_gray editadt_title margin_lr_5 padding_tb_5 hidden font_size12">${ctp:i18n('collaboration.newcoll.fywbzyl')}</div>
				</td>
			</tr>
			<tr>
				<td id="fuyan" valign="top" align="center" class="editadt_box hidden">
					<textarea style="width:150px; padding: 0 5px;font-size:12px;" class="h100b validate" validate="maxLength:500" id="content" name="content">${summaryVO.sendOpinion.content }${summaryVO.summary.comment}</textarea>
				</td>
			</tr>
		</table>
	</div>
</div>

</form>
</body>
</html>