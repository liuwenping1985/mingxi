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
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/deal.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var _praisedealCa ="${ctp:i18n('collaboration.summary.label.praisecancel')}";
var _praisedeal ="${ctp:i18n('collaboration.summary.label.praise')}";
</script>

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
.common_toolbar_box { background:none; height: 32px;}
.toolbar_l a { border:solid 1px #F0F6F8;}
.seperate {
	width:1px;
	display:inline-block;
	background:#c0c5c6;
	height:12px;
	vertical-align:middle;
}
#cke_content_deal_comment{
    border: 1px solid #d8d8d8;
    width: 95%;
    background:transparent;
    padding: 0 5px;
}
.cke_contents{
	background:transparent;
}
</style>

<style type="text/css">

</style>
<script>
function GetRequest(url) {

   var url = url||location.search; //获取url中"?"符后的字串

   var theRequest = {};

   if (url.indexOf("?") != -1) {

      var str = url.substr(1);

      strs = str.split("&");

      for(var i = 0; i < strs.length; i ++) {

         theRequest[strs[i].split("=")[0]]=(strs[i].split("=")[1]);

      }

   }

   return theRequest;

}
function passValue2Parent(){
	//console.log(window.location.href);
	var pp = window.parent;

	if(pp){
		var params = GetRequest(pp.location.search);
		//console.log(params);
		//;dealDoZcdbFunc()
		if(params["fromjixiao"] == "true"){

			var ff = _getZWIframe();
			//console.log($(ff.document).find('span[name=field0010]').html());
			if(pp.opener){

				window.opener.valuePass(params["recordId"],$(ff.document).find('span[name=field0123]').html(),$(ff.document).find('span[name=field0051]').html());
			}
		}
	}
	;dealDoZcdbFunc();

}
$(document).ready(function(){
	var con = true;
	var tag2 = 8;
	function hideComment__(){
		var node = $("#commemt_area__");
		if(tag2>0){
			node.hide();
			setTimeout(hideComment__,500);
			tag--;
		}

	}
	var tag=10;
	function locateDom(){

		var dom = $("#dealAreaThisRihgt");
		if(dom.length==0){
			if(tag>0){
				setTimeout(locateDom,500);
			}
			tag--;
		}else{

			$("#toolb").hide();
			hideComment__();
			$("#moreLabel").hide();
			var btns = $(".left.margin_t_20");

			$(btns).each(function(index,item){

				var p = $(item).find("input");
				if(p.length>0){
					if(p.val()=="暂存待办"){
						p.addClass("common_button_emphasize");
						p.val("提交考核");
					}else{
						$(item).hide();
					}
				}


			});

		}

	}

	var pp = window.parent;

	if(pp){
		var params = GetRequest(pp.location.search);
		console.log(params);
		if(params["fromjixiao"] == "true"){
			locateDom();
		}
	}
});

</script>
<div id="dealAreaThisRihgt" class="deal_area padding_b_10 clearfix form_area">
<div class="clearfix msg_title">
	<span>
		<strong>${permissionName}</strong>
	</span>
<%-- <c:if
	test="${summaryVO.summary.templeteId!=null and summaryVO.summary.templeteId!='' }"> --%>
	<%--添加调用模版时候的处理说明
	<a class="right" onclick="colShowNodeExplain()"><span
		class="ico16 handling_of_16"></span></a> --%>
<%-- 	<div data-state="to_be_loaded" id="nodeExplainDiv"
		style="display: none;background-color: #ffffff; height: 100px; width: 260px; z-index: 2; position: absolute; right: 30px; border: 1px solid #c7c7c7; text-align: left;"
		onMouseOut="">
        <div style="vertical-align: bottom;height:20px" align="right">
            <span  style="padding-right: 4px;"><a
                onClick="hiddenNodeIntroduction()">${ctp:i18n('permission.close')}<!-- 关闭 --></a></span>
        </div>
        <div style="overflow: auto;height: 80px">
        	<table onMouseOut="" style="width: 100%;">
        		<tr height="100%" style="vertical-align: top; line-height: 18px;">
        			<td id="nodeExplainTd" style='word-break:break-all'></td>
        		</tr>
        	</table>
        </div>
	</div>
</c:if> --%></div>
<div class="clearfix font_size12 margin_l_10 relative" style="margin-bottom: 5px;">
<div id="toolb" class="left" style="width: 235px; margin-top: 2px;"></div>
<c:if
	test="${contentCfg.useWorkflow and nodePerm_commonActionList ne '[]'}">
	<c:set var="commonActionNodeCount" value="0" />
	<c:forEach items="${commonActionList}" var="operation">
		<c:set var="commonActionNodeCount" value="${commonActionNodeCount+1}" />
		<c:if test="${canModifyWorkFlow && superNodestatus==0}">
			<c:if test="${'AddNode' eq operation}">
				<input type="hidden" id="tool_${commonActionNodeCount}"
					value="_commonAddNode" onclick="addNode()"/>
				<%--加签 --%>
			</c:if>
			<c:if test="${'JointSign' eq operation}">
				<input type="hidden" id="tool_${commonActionNodeCount}"
					value="_commonAssign"  onclick="currentAssign()"/>
				<%--当前会签 --%>
			</c:if>
			<c:if test="${'RemoveNode' eq operation}">
				<input type="hidden" value="_commonDeleteNode"
					id="tool_${commonActionNodeCount}"  onclick="deleteNodeFunc()"/>
				<%--减签 --%>
			</c:if>
			<c:if test="${'Infom' eq operation}">
				<input type="hidden" value="_commonAddInform"
					id="tool_${commonActionNodeCount}"  onclick="addInformFunc()"/>
				<%--知会 --%>
			</c:if>
		</c:if>
		<c:if test="${ ('Return' eq operation) && superNodestatus==0}">
			<input type="hidden" value="_commonStepBack"
				id="tool_${commonActionNodeCount}"  onclick="stepBackCallBack()" />
			<%--回退 --%>
		</c:if>
		<c:if
			test="${('Edit' eq operation && summaryVO.summary.bodyType ne '20' && summaryVO.summary.bodyType ne '45') && superNodestatus==0}">
			<input type="hidden" value="_commonEditContent"
				id="tool_${commonActionNodeCount}"  onclick="editContentFunc()"/>
			<%--修改正文 --%>
		</c:if>
		<c:if test="${('allowUpdateAttachment' eq operation)  && superNodestatus==0 }">
			<input type="hidden" value="_commonUpdateAtt"
				id="tool_${commonActionNodeCount}"  onclick="modifyAttFunc()"/>
			<%--修改附件 --%>
		</c:if>
		<c:if test="${('Terminate' eq operation) && superNodestatus==0}">
			<input type="hidden" value="_commonStepStop"
				id="tool_${commonActionNodeCount}"  onclick="stepStopFunc()"/>
			<%--终止 --%>
		</c:if>
		<c:if test="${ ('Cancel' eq operation  && !summaryVO.isNewflow) && superNodestatus==0 }">
			<input type="hidden" value="_commonCancel"
				id="tool_${commonActionNodeCount}"  onclick="dealCancelFunc()"/>
			<%--撤销--%>
		</c:if>
		<c:if test="${ ('Forward' eq operation)  && superNodestatus==0}">
			<input type="hidden" value="_commonForward"
				id="tool_${commonActionNodeCount}"  onclick="dealForwardFunc()"/>
			<%--转发--%>
		</c:if>
		<c:if test="${ ('Sign' eq operation && summaryVO.summary.bodyType ne '45')  && superNodestatus==0}">
			<input type="hidden" value="_commonSign"
				id="tool_${commonActionNodeCount}"  onclick="openSignature()"/>
			<%--签章 --%>
		</c:if>
		<c:if test="${ ('Transform' eq operation)  && superNodestatus==0 }">
			<input type="hidden" value="_commonTransform"
				id="tool_${commonActionNodeCount}"  onclick="transformFunc()"/>
			<%--转事件 --%>
		</c:if>
		<c:if test="${('SuperviseSet' eq operation)  && superNodestatus==0}">
			<input type="hidden" value="_commonSuperviseSet"
				id="tool_${commonActionNodeCount}"  onclick="superviseSetFunc()"/>
			<%--督办设置--%>
		</c:if>
		<c:if test="${ ('SpecifiesReturn' eq operation )  && superNodestatus==0}">
			<input type="hidden" value="_dealSpecifiesReturn"
				id="tool_${commonActionNodeCount}"  onclick="specifiesReturnFunc()"/>
			<%--指定回退--%>
		</c:if>
		<c:if test="${'Transfer' eq operation}">
			<%--转办--%>
			<input type="hidden" value="_commonTransfer"
				id="tool_${commonActionNodeCount}"  onclick="transferFunc()"/>
		</c:if>
	</c:forEach>
</c:if> <c:if test="${(nodePerm_advanceActionList ne '[]')  && superNodestatus==0 }">
	<span class="more_style more_style_position right margin_l_5" id="moreLabel" style="height:24px;line-height:24px;">
		<a class="margin_l_5">${ctp:i18n('common.more.label')}</a>
		<span class="ico16 arrow_2_b"></span>
	</span>
</c:if></div>

<input type="hidden" id="transferMemberId" />
<!--处理意见区域-->

<div id="commemt_area__" class="opinions margin_l_15 margin_r_15">
<!-- Dialog需要用到 -->
<input type="hidden" id="nodeattitude" value="${nodeattitude}">
<input type="hidden" id="superNodestatus" value="${superNodestatus}">
<c:if test="${nodeattitude!=3}">
<div class="hr_heng">&nbsp;</div>
<div class="common_radio_box padding_t_10 clearfix margin_b_10">
<div class="left">
	<c:if test="${nodeattitude==1}">
		<label class="margin_r_10 hand" for="afterRead"> <input
			id="afterRead" class="radio_com" name="attitude"
			value="collaboration.dealAttitude.haveRead" type="radio"
			<c:if test="${(defaultAttitude == 1 || null == defaultAttitude) && (commentDraft.extAtt1 eq null || commentDraft.extAtt1 eq 'collaboration.dealAttitude.haveRead')}">checked="checked"</c:if>>${ctp:i18n('collaboration.dealAttitude.haveRead')}<!-- 已阅 -->
		</label>
	</c:if>
	<label class="margin_r_10 hand" for="agree"> <input id="agree"
		class="radio_com" name="attitude"
		value="collaboration.dealAttitude.agree" type="radio"
		<c:if test="${defaultAttitude == 2 || (nodeattitude == 2 || commentDraft.extAtt1 eq 'collaboration.dealAttitude.agree')}">checked="checked"</c:if>>${ctp:i18n('collaboration.dealAttitude.agree')}<!-- 同意 -->
	</label>
	<c:if test="${superNodestatus==0 || superNodestatus==3}">
	<label class="margin_r_10 hand font_size14" for="notagree"> <input
		id="notagree" class="radio_com" name="attitude"
		value="collaboration.dealAttitude.disagree" type="radio"
		<c:if test="${commentDraft.extAtt1 eq 'collaboration.dealAttitude.disagree'}">checked="checked"</c:if>>${ctp:i18n('collaboration.dealAttitude.disagree')}<!-- 不同意 -->
	</label>
	</c:if>
</div>
</div>
</c:if>

<c:if test="${ctp:containInCollection(basicActionList, 'Opinion')}">
	<script type="text/javascript">
	function attDivToggle(){
		if($(".upload_files_msg").css("display")=="none"){
			$(".upload_files_msg").show();
		}else{
			$(".upload_files_msg").hide();

		}
	}

	</script>
	<div id="areaTopDiv" class="area_top" <c:if test='${nodeattitude==3}'>style="margin-top:40px;"</c:if>>
		<c:set value="${ctp:containInCollection(basicActionList, 'UploadAttachment')}" var="__canUploadAttachment"/>
		<c:set value="${ctp:containInCollection(basicActionList, 'UploadRelDoc')}" var="__UploadRelDoc"/>
		<c:if test="${(__canUploadAttachment || __UploadRelDoc) && superNodestatus==0}">
			<span class="area_top_icon relative" onmouseout="attDivToggle()" onmouseover="attDivToggle()">			<span class="ico24 attachment_24" id="files_upload_type" ></span>
				<ul class="absolute upload_files_msg">
					<c:if test="${__canUploadAttachment}">
						<li id="uploadAttachmentID" style="float:left;"><span class="ico24 localhost_upload_24 margin_r_10 margin_l_5"></span>${ctp:i18n('permission.operation.UploadAttachment')}</li>
					</c:if>
					<c:if test="${__UploadRelDoc}">
						<li id="uploadRelDocID" style="float:left;"><span class="ico24 related_document_24 margin_r_10 margin_l_5"></span>${ctp:i18n('permission.operation.UploadRelDoc')}</li>
					</c:if>
				</ul>
			</span>
		</c:if>
		<span class="line"></span>
		<%-- @功能 --%>
		<span class="area_top_icon" onclick="showAtSelectWin()">
			<span class="ico24 at_24"></span>
		</span>
		<span class="line"></span>

		<span class="area_top_icon">

			<c:set var="praiseTip" value="${ctp:i18n('collaboration.summary.label.praise') }"/>
			<c:set var="praiseTipCancel" value="${ctp:i18n('collaboration.summary.label.praisecancel') }"/>

			<!-- wxj 允许点赞 -->
            <c:if test="${summaryVO.canPraise}">
	             <c:set var ="parseTitle" value="${commentDraft.praiseToSummary ? praiseTipCancel :praiseTip }"/>
	             <span id="praiseToObj" title="${parseTitle}" class="ico16 ${commentDraft.praiseToSummary ? 'like_16' : 'no_like_16' }" style="width:16px;" onclick='praiseToSummary()'></span>
            </c:if>
		</span>
		<span class="line"></span>

		<span class="area_top_icon" onclick="showEditToolBar()">
			<span class="ico24 editor_24"></span>
		</span>
		<c:if test="${ctp:containInCollection(basicActionList, 'CommonPhrase')}">
			<div class="right margin_r_10"><a id="cphrase" curUser="${CurrentUser.id}" title="${ctp:i18n('collaboration.common.commonLanguage')}">
                 ${ctp:i18n('permission.operation.CommonPhrase')}<!-- 常用语 --></a>
            </div>
		</c:if>
	</div>

	<textarea id="content_deal_comment" name="content_deal_comment"  comp="type:'editor',contentType:'html',height:'220px',defaultStyle:'*{font-size:14px}body.cke_editable{font-size:14px;}',toolbarSet:'VerySimple',autoResize:false,showToolbar:false",
		class="padding_5 margin_t_5 comp" errorIcon="false" style="width: 90%; height: 220px;font-size:14px;">${ctp:toHTMLWithoutSpace(empty commentDraft.richContent ? commentDraft.content : commentDraft.richContent)}</textarea>

	<div>
		<div id="attachmentTR${commentId}" style="display: none;"  class="attachment_files">
			<div id="content_deal_attach" isGrid="true" class="comp"
				comp="type:'fileupload',applicationCategory:'1',attachmentTrId:'${commentId}',canFavourite:false,canDeleteOriginalAtts:true"
				attsdata='${handleAttachJSON }'></div>
		</div>
		<div id="attachment2TR${commentId}" style="display: none;border-top:1px solid #d7d7d7;margin-top:3px;" class="attachment_files">
			<div id="content_deal_assdoc" isGrid="true" class="comp"
				comp="type:'assdoc',applicationCategory:'1',attachmentTrId:'${commentId}',modids:'1,3',canFavourite:false,canDeleteOriginalAtts:true"
				attsdata='${handleAttachJSON }'></div>
		</div>
	</div>

	<%-- 老的@后填充的人员input
	  <input type="hidden" id="dealMsgPush" name="dealMsgPush" />
	 --%>


</c:if>

	<div class="default_handle" style="display:${summaryVO.summary.templeteId ne null ?  'block':'none'}">
		<c:if test="${ctp:containInCollection(basicActionList, 'Opinion')}">
			<div class="clearfix margin_t_10">
			<div class="common_checkbox_box clearfix left margin_t_5"><label
				class="margin_r_10 hand" for="isHidden" id="isHiddenLable"> <input id="isHidden"
				class="radio_com" name="isHidden" type="checkbox">${ctp:i18n('collaboration.common.default.commentHidden')}<!-- 意见隐藏 -->
			</label></div>
			<div id="showToIdSpan" class="common_txtbox common_txtbox_dis clearfix">
			<label class="margin_r_10 left title">${ctp:i18n('collaboration.opinion.doNotInclude')}:</label><!-- 不包括 -->
			<div class="common_txtbox_wrap"><input type="text"
				id="showToIdInput" name="showToIdInput" class="comp"
				comp='type:"selectPeople",showBtn:false,panels:"Department,Team,Post,Outworker,RelatePeople,JoinOrganization",minSize:0,selectType:"Member",showFlowTypeRadio: false'
				value="${ctp:i18n('collaboration.common.default.clickOpenPeople')}"><!-- 点击选择公开人 -->
			</div>
			</div>
			</div>
		</c:if>
		<c:if test="${ctp:containInCollection(basicActionList, 'Track')}">
			<div id='trackDiv_detail'
				class="common_radio_box common_checkbox_box clearfix margin_t_10">
			<label class="margin_r_10 hand" for="isTrack" id="isTrackLable">
				<input id="isTrack" class="radio_com" name="isTrack"  onclick="trackBoxFunc()" value="1" type="checkbox">${ctp:i18n('permission.operation.Track')}<!-- 跟踪 -->
			</label>
			<label class="margin_r_10 disabled_color hand" for="trackRange_all" id="label_all">
				<input id="trackRange_all" class="radio_com" name="trackRange" onclick="trackAllFunc()" value="1" type="radio" disabled="disabled">${ctp:i18n('collaboration.listDone.all')}<!-- 全部 -->
			</label>
			<label class="margin_r_10 disabled_color hand"
				for="trackRange_members" id="label_members"> <input onclick="trackPart()"
				id="trackRange_members" class="radio_com" name="trackRange" value="0"
				type="radio" disabled="disabled">${ctp:i18n('collaboration.listDone.designee')}<!-- 指定人 -->
			</label> <input type="hidden" id="zdgzry" name="zdgzry" value="${trackOnlyIds}"></input><input id="trackRange_members_textbox" readonly onclick="javascript:toggleTrackRange_members()" type="text" class="hidden" value="${trackNames}" style="width:112px;"/>
			</div>
		</c:if> <%-- 归档--%> <c:if test="${canArchive  && superNodestatus==0 }">
			<div class="clearfix margin_t_10 nodePerm" baseAction="Archive">
			<div class="common_checkbox_box clearfix"><label
				class="margin_r_10 hand" for="pigeonhole" id="pigeonholeLable"> <input
				id="pigeonhole" class="radio_com" name="pigeonhole" value="0"
				type="checkbox">${ctp:i18n('permission.operation.Archive')}<!-- 处理后归档 -->
			<input id="pigeonholeValue" name="pigeonholeValue" type="hidden">
			</label></div>
			</div>
		</c:if>
	</div>
	<div class="margin_t_10 font_size12 hand showHide" id="_showOrCloseBtn" onclick="showHideFunc()">
	    <c:set value="${summaryVO.summary.templeteId ne null}" var="__isTemplate" />
		<span class="ico16 ${__isTemplate ?  'arrow_2_t' : 'arrow_2_b'} margin_b_5"></span>
		<c:set value="${ctp:i18n('collaboration.summary.label.open.js') }" var="openLabel" />
		<c:set value="${ctp:i18n('collaboration.summary.label.close.js') }" var="closeLabel" />
		<span class="color_blue">${__isTemplate ?  closeLabel : openLabel}</span>
	</div>

</div>
<!-- <div class="clearfix right" id="_dealDiv"> -->
<div class="clearfix right margin_r_20 <c:if test='${nodeattitude==3}'>padding_t_10</c:if>" id="_dealDiv">
<div align="right" id="deal_btns_div"><%--存为草稿 --%> <c:if
	test="${(isIssus ne 'true' and isAudit ne 'true' and isVouch ne 'true') && (superNodestatus==0 || superNodestatus==1)}">
	<div class="left margin_t_20"><input id="_dealSubmit" onclick="submitClickFunc()" type="button"
		class="common_button common_button_emphasize margin_r_5 hand" value="${ctp:i18n('permission.operation.ContinueSubmit')}"/>
	</div>
</c:if>

<c:if test="${(isAudit eq 'true') && (superNodestatus==0 || superNodestatus==1) }">
	<div class="left margin_t_20"><input id="_auditPass" style="width: auto;max-width: none;min-width: 63px;" onclick="dealDoAuditPass()" value="${ctp:i18n('collaboration.common.default.auditBy')}" type="button"
		class="common_button common_button_emphasize margin_r_5 hand"/><!-- 审核通过 -->
	<c:if test="${superNodestatus==0}">
	<input id="_auditNotPass"  style="width: auto;max-width: none;min-width: 63px;" onclick="dealDoAuditNotPass()" value="${ctp:i18n('collaboration.common.default.anAuditNotPassed')}" type="button"
		class="common_button common_button_seeyon margin_r_5 hand" style="width:70px;"/><!-- 审核不通过 -->
	</c:if>
	</div>
</c:if> <c:if test="${ (isVouch eq 'true') && (superNodestatus==0 || superNodestatus==1) }">
	<div class="left margin_t_20"><input id="_vouchPass" style="width: auto;max-width: none;min-width: 63px;" onclick="dealDoVochPass()" value="${ctp:i18n('collaboration.common.default.approvedBy')}" type="button"
		class="common_button common_button_emphasize margin_r_5 hand"/><!-- 核定通过 -->
	<c:if test="${superNodestatus==0}">
	<input id="_vouchNotPass" style="width: auto;max-width: none;min-width: 63px;" onclick="dealDoVochNotPass()" value="${ctp:i18n('collaboration.common.default.approvedNotBy')}" type="button"
		class="common_button common_button_seeyon margin_r_5 hand" style="width:70px;"/><!-- 核定不通过 -->
	</c:if>
	</div>
</c:if> <c:if test="${ (isIssus eq 'true') && (superNodestatus==0 || superNodestatus==1) }">
	<div class="left margin_t_20"><input id="_dealPass1"  style="width: auto;max-width: none;min-width: 63px;" onclick="dealPass1Func()"  value="${ctp:i18n('collaboration.common.default.adoptedAndPublished')}" type="button"
		class="common_button common_button_emphasize margin_r_5 hand" style="width:70px;"/><!-- 通过并发布 -->
	<c:if test="${superNodestatus==0}">
	<input id="_dealNotPass"  style="width: auto;max-width: none;min-width: 63px;" onclick="stepStopFunc()" value="${ctp:i18n('collaboration.common.default.notPass')}" type="button"
		class="common_button common_button_seeyon margin_r_5 hand" /><!-- 不通过 -->
	</c:if>
	</div>
</c:if>

 <c:if
	test="${(isAudit ne 'true' and isVouch ne 'true' and ctp:containInCollection(basicActionList, 'Opinion') and ctp:containInCollection(basicActionList, 'Comment')) && (superNodestatus==0 || superNodestatus==1)}">
	<div class="left margin_t_20"><input id="_dealSaveDraft" style="width: auto;max-width: none;min-width: 63px;" onclick="dealDoSaveDraft()" value="${ctp:i18n('collaboration.newcoll.saveDraft')}" type="button"
		class="common_button common_button_seeyon margin_r_5 hand"/></div>
</c:if> <c:if test="${(ctp:containInCollection(basicActionList, 'Comment')) && (superNodestatus==0 || superNodestatus==2)}">
	<div class="left margin_t_20">
		<input id="_dealSaveWait"  style="width: auto;max-width: none;min-width: 63px;" onclick="passValue2Parent()" value="${ctp:i18n('permission.operation.Comment')}"
				type="button" class="common_button common_button_seeyon hand"/>
	</div>
	<!-- 暂存待办 -->
</c:if></div>
</div>
</div>
<div id="comment_deal" class="display_none">
	<input type="hidden" id="id" value="${commentDraft.id}">
	<input type="hidden" id="draftCommentId" value="${commentDraft.id}">
	<input type="hidden" id="pid" value="0">
	<input type="hidden" id="clevel" value="1">
	<input type="hidden" id="path" value="pc">
	<input type="hidden" id="moduleType" value="1">
	<input type="hidden" id="moduleId" value="${summaryVO.summary.id}">
	<input type="hidden" id="extAtt1">
	<input type="hidden" id="ctype" value="0">
	<input type="hidden" id="content">
	<input type="hidden" id="hidden">
	<input type="hidden" id="showToId">
	<input type="hidden" id="affairId" value="${summaryVO.affairId}">
	<input type="hidden" id="relateInfo">
	<%-- 这里写死为true，表示发送消息 --%>
	<input type="hidden" id="pushMessage" value="true"/>
	<%-- 6.0@功能改造， 不使用消息推送了，后面不改就删了吧 add by xuqw
	<input type="hidden" id="pushMessage" value="false">
	<input type="hidden" id="pushMessageToMembers">
	 --%>
	<%-- @all的时候保存at人员的信息 --%>
     <input type="hidden" id="atAllMembers" name="atAllMembers"/>
	<input type="hidden" id="praiseInput" value="0"></input>
	<input type="hidden" id="richContent" value="">
</div>

<script type="text/javascript">
  var nodePerm_baseActionList = <c:out value="${nodePerm_baseActionList}" default="null" escapeXml="false"/>;
  var nodePerm_commonActionList = <c:out value="${nodePerm_commonActionList}" default="null" escapeXml="false"/>;
  var nodePerm_advanceActionList = <c:out value="${nodePerm_advanceActionList}" default="null" escapeXml="false"/>;
  var subState = "${summaryVO.affair.subState}";
  var state = '${summaryVO.affair.state}';
  var inInSpecialSB = '${inInSpecialSB}';
  var affairId = "${summaryVO.affairId}";
  var templeteId = "${summaryVO.summary.templeteId}";
  var processId = "${summaryVO.summary.processId}";
  var summaryId= '${summaryVO.summary.id}';
  var bodyType = '${summaryVO.summary.bodyType}';

  var wfItemId = '${contentContext.wfItemId}';
  var wfProcessId = '${contentContext.wfProcessId}';
  var wfActivityId = '${contentContext.wfActivityId}';
  var currUserId = '${CurrentUser.id}';
  var wfCaseId = '${contentContext.wfCaseId}';
  var moduleTypeName = '${contentContext.moduleTypeName}';
  var flowPermAccountId = '${summaryVO.flowPermAccountId}';
  //var affairId = '${summaryVO.affairId}';
  var nodePolicy = '${ctp:escapeJavascript(nodePolicy)}';
  var currLoginAccount= '${CurrentUser.loginAccount}';
  //var processId = '${summaryVO.summary.processId}';
  var collEnumKey = "${collEnumKey}";
  var forwardEventSubject = "${ctp:escapeJavascript(forwardEventSubject)}";
  var commonActionNodeCount = '${commonActionNodeCount}';
  var startCfg = "${contentCfg.useWorkflow and  nodePerm_advanceActionList ne '[]'}";
  var canModifyWorkFlow = '${canModifyWorkFlow }';
  var startMemberId = '${summaryVO.summary.startMemberId}';
  var stateMemberName = '${ctp:escapeJavascript(summaryVO.startMemberName)}';
  var affairMemberId = '${summaryVO.affair.memberId}';
  var isNewfolw = '${summaryVO.isNewflow}';
  var workItemId = '${summaryVO.workitemId}';
  var trackMember="${trackIds}";
  var commentId = '${commentId }';
  var isTemplete = '${isTemplete}'=='true'? true : false;
  var displayIds = '${displayIds }';
  var displayNames = '${displayNames }';
  var nodeDesc = '${nodeDesc}';
  var drafContent = '${ctp:escapeJavascript(commentDraft.content)}'

  $.content.getContentDealDomains = function(domains) {
    if (!domains)
      domains = [];

    //修改a标签的target属性
    var contentCkeditor = CKEDITOR.instances['content_deal_comment'];
    if(contentCkeditor){
        var levels = ["document", "$"], index = 0, tempObj = contentCkeditor, contentDoc;
        while(tempObj = tempObj[levels[index]]){
            index++;
            if(index == levels.length){
                contentDoc = tempObj;
                break;
            }
        }
        if(contentDoc){
            var aTags = contentDoc.getElementsByTagName("a");
            if(aTags){
                for(var i = 0; i < aTags.length; i++){
                    aTags[i].setAttribute("target", "_blank");
                }
            }
        }
    }

	    var commentContent = getContentDealComment();
	    var commentText = getTextDealComment();
	    if($.trim(commentText) != "" && commentText.length > 2000) {
	        $.alert("${ctp:i18n('collaboration.common.deafult.dealCommentMaxSize')}");
	        mainbody_callBack_failed();
	        return false;
	    }
	    $("#comment_deal #content").val(commentText);
	    $("#comment_deal #richContent").val(commentContent);
	    <c:if test="${contentCfg.useWorkflow}">
	    $("#comment_deal #extAtt1").val($("input[name='attitude']:checked").val());
	    </c:if>
	    $("#comment_deal #hidden").val($("#isHidden").attr('checked')=="checked");
	    $("#comment_deal #showToId").val($("#showToIdInput").val());
	    if($("#content_deal_comment").length>0){
		    $("#content_deal_attach").html("");
		    saveAttachmentPart("content_deal_attach");
		    $("#comment_deal #relateInfo").val($.toJSON($("#content_deal_attach").formobj()));
	    }
   		domains.push("comment_deal");
    return domains;
  };
  if(navigator.userAgent.toLowerCase().indexOf("macintosh")!=-1&&navigator.userAgent.toLowerCase().indexOf("safari")!=-1){
  	$(".radio_com").css("margin-top",0);
  }
  //常用语国际化太长，按产品经理要求截取
  var _phrase = $("#cphrase").attr("title");
  if(_phrase && _phrase.length>3){
	  $("#cphrase").html(_phrase.substring(0,7)+"...");
  }
</script>
