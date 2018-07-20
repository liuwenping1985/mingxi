<%--
 $Author: muj $
 $Rev: 5599 $
 $Date:: 2013-03-28 18:46:48#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<script type="text/javascript" src="${path}/ajax.do?managerName=phraseManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/info/js/magazine/summary/audit_deal.js${ctp:resSuffix()}"></script>
<style>
.common_drop_list .common_drop_list_content a.nodePerm,.nodePerm {
	display: none;
}
.back_disable_color{
	cursor: default;
  	color: #000;
    opacity: 0.2;
  	-moz-opacity: 0.2;
  	-khtml-opacity: 0.2;
  	filter: alpha(opacity=20);
}
</style>
<script>
var commentId = '${commentId }';
var useLocalFile = '${magazineVO.infoMagazine.useLocalFile}';
var curUser ='${CurrentUser.id}';
</script>
<div id="dealAreaThisRihgt" class="deal_area padding_lr_10 form_area">

	<div class="clearfix padding_t_10">
		<span class="left">
			<em id="hidden_side" class="ico16 arrow_2_r margin_r_5"></em>
		</span>
	</div>

	<!--处理意见区域-->
	<div class="common_radio_box clearfix">
		<div class="left">
			<div id="toolbar_Pigeonhole" class="toolbar_l" style="display: inline-block;">
				<a href="javascript:void(0)" id="_commonPigeonhole_a">
					<em id="_commonPigeonhole_em" class="ico16 toback_16"></em>
					<span id="_commonPigeonhole_span" class="menu_span">${ctp:i18n('infosend.listInfo.file')}<!-- 归档 --></span>
		        </a>
			</div>

			<%-- 屏蔽掉？在下个迭代实现？？？
			<div id="toolbar_AddNode" class="toolbar_l" style="display: inline-block;">
				<a href="javascript:void(0)" id="_commonAddNode_a">
					<em id="_commonAddNode_em" class="ico16 toback_16"></em>
					<span id="_commonAddNode_span" class="menu_span">${ctp:i18n('infosend.magazine.label.addAuditor')}添加审核人</span>
		        </a>
	        </div>
	         --%>

		</div>
	</div>

	<div class="hr_heng margin_t_10">&nbsp;</div>

	<div class="right" width="90%"><a id="cphrase" curUser="${CurrentUser.id}">${ctp:i18n('collaboration.common.commonLanguage')}<!-- 常用语 --></a></div>


	<div baseAction="Opinion" class="common_txtbox  clearfix margin_t_5">
		<textarea id="content_deal_comment" name="content_deal_comment" class="padding_5" errorIcon="false" style="width: 95%; height: 200px;">${commentDraft.content}</textarea>
	</div>

	<div class="clearfix margin_t_5" id="attachmentAndDoc">
	    <span class="left">
			<!-- 附件 -->
	    	<div class="nodePerm" baseAction="UploadAttachment" style="display: inline;">
	    		<a id="uploadAttachmentID" class="margin_r_5">
	    		<span class="ico16 affix_16  margin_r_5"></span>${ctp:i18n('common.attachment.label')}</a>
	    		(<span id="attachmentNumberDiv${commentId}">0</span>)
	    	</div>
		</span>
	</div>

	<div class="hr_heng margin_t_5">&nbsp;</div>


	<div class="newinfo_area margin_t_5">
		<div id="attachmentTR${commentId}" style="display: none;">
			<div id="content_deal_attach" isGrid="true" class="comp"
				comp="type:'fileupload',applicationCategory:'32',attachmentTrId:'${commentId}',canFavourite:false,canDeleteOriginalAtts:true"
				attsdata='${handleAttachJSON }'>
			</div>
		</div>
	</div>

	<div class="clearfix margin_t_10 right" id="_dealDiv">
		<div align="left">
			<a id="_passAndPublish" onclick="doAudit('passAndPublish')" href="javascript:void(0)" class="common_button common_button_emphasize margin_r_5">${ctp:i18n('infosend.magazine.label.auditAndPublish')}<!-- 通过可发布 --></a>
			<a id="_stepBack" onclick="doAudit('stepBack')" href="javascript:void(0)" class="common_button common_button_gray margin_r_5">${ctp:i18n('infosend.magazine.label.backToEditor')}<!-- 退回采编 --></a>
			<%-- <a id="_passAndNotPublish" onclick="confirmAudit('passAndNotPublish')" href="javascript:void(0)" class="common_button common_button_gray margin_r_5 ${magazineVO.infoMagazine.state=='7'?'common_button_disable':'' }">${ctp:i18n('infosend.magazine.label.auditNotPublish')}<!-- 通过不发布 --></a>  如果有人点击了，通过不发布，这个按钮不可用--%>
			<a id="_passAndNotPublish" onclick="confirmAudit('passAndNotPublish')" href="javascript:void(0)" class="common_button common_button_gray margin_r_5">${ctp:i18n('infosend.magazine.label.auditNotPublish')}<!-- 通过不发布 --></a>
		</div>
	</div><!-- _dealDiv -->

</div><!-- form_area -->

<div id="comment_deal" class="display_none">
	<input type="hidden" id="id" value="${magazineVO.infoMagazine.id}">
	<input type="hidden" id="pid" value="0">
	<input type="hidden" id="clevel" value="1">
	<input type="hidden" id="path" value="${contentContext.commentMaxPath}">
	<input type="hidden" id="moduleType" value="${contentContext.moduleType}">
	<input type="hidden" id="moduleId" value="${contentContext.moduleId}">
	<input type="hidden" id="extAtt1">
	<input type="hidden" id="ctype" value="0">
	<input type="hidden" id="content">
	<input type="hidden" id="hidden">
	<input type="hidden" id="showToId">
	<input type="hidden" id="affairId" value="${magazineVO.affairId}">
	<input type="hidden" id="relateInfo">
	<input type="hidden" id="pushMessage" value="false">
	<input type="hidden" id="pushMessageToMembers">
	<input type="hidden" id="folderId" name="folderId" />
	<%-- 打开文件 --%>
     <input type="hidden" name="isLoadNewFile" id="isLoadNewFile" value="0">
</div>
