<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<html class="h100b over_hidden">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
<script type="text/javascript" src="${path}/ajax.do?managerName=phraseManager"></script>
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
.common_toolbar_box { background:#F0F6F8;}
.toolbar_l a { border:solid 1px #F0F6F8;}
.seperate {
	width:1px;
	display:inline-block;
	background:#c0c5c6;
	height:12px;
	vertical-align:middle;
}
</style>
</head>
<body>

<div id="dealAreaThisRihgt" class="deal_area padding_lr_10 padding_b_10 clearfix form_area">
<div id="hidden_side" class="clearfix padding_t_15 padding_b_10">
<span style="font-size: 15px;">
<em class="ico16 arrow_2_r margin_r_5 "></em>返回协同正文
</span>
<c:if
	test="${summaryVO.summary.templeteId!=null and summaryVO.summary.templeteId!='' }">
	<%--添加调用模版时候的处理说明
	<a class="right" onclick="colShowNodeExplain()"><span
		class="ico16 handling_of_16"></span></a> --%>
	<div id="nodeExplainDiv"
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
</c:if></div>
<div class="clearfix font_size12">
<div id="toolb" class="margin_t_10 left" style="width: 250px;"></div>
<c:if
	test="${contentCfg.useWorkflow and nodePerm_commonActionList ne '[]'}">
	<c:set var="commonActionNodeCount" value="0" />
	<c:forEach items="${commonActionList}" var="operation">
		<c:set var="commonActionNodeCount" value="${commonActionNodeCount+1}" />
		<c:if test="${(canModifyWorkFlow || (!canModifyWorkFlow && summaryVO.summary.startMemberId == summaryVO.affair.memberId)) && superNodestatus==0}">
			<c:if test="${'AddNode' eq operation}">
				<input type="hidden" id="tool_${commonActionNodeCount}"
					value="_commonAddNode" />
				<%--加签 --%>
			</c:if>
			<c:if test="${'JointSign' eq operation}">
				<input type="hidden" id="tool_${commonActionNodeCount}"
					value="_commonAssign" />
				<%--当前会签 --%>
			</c:if>
			<c:if test="${'RemoveNode' eq operation}">
				<input type="hidden" value="_commonDeleteNode"
					id="tool_${commonActionNodeCount}" />
				<%--减签 --%>
			</c:if>
			<c:if test="${'Infom' eq operation}">
				<input type="hidden" value="_commonAddInform"
					id="tool_${commonActionNodeCount}" />
				<%--知会 --%>
			</c:if>
		</c:if>
		<c:if test="${ ('Return' eq operation) && superNodestatus==0}">
			<input type="hidden" value="_commonStepBack"
				id="tool_${commonActionNodeCount}" />
			<%--回退 --%>
		</c:if>
		<c:if
			test="${('Edit' eq operation && summaryVO.summary.bodyType ne '20' && summaryVO.summary.bodyType ne '45') && superNodestatus==0}">
			<input type="hidden" value="_commonEditContent"
				id="tool_${commonActionNodeCount}" />
			<%--修改正文 --%>
		</c:if>
		<c:if test="${('allowUpdateAttachment' eq operation)  && superNodestatus==0 }">
			<input type="hidden" value="_commonUpdateAtt"
				id="tool_${commonActionNodeCount}" />
			<%--修改附件 --%>
		</c:if>
		<c:if test="${('Terminate' eq operation) && superNodestatus==0}">
			<input type="hidden" value="_commonStepStop"
				id="tool_${commonActionNodeCount}" />
			<%--终止 --%>
		</c:if>
		<c:if test="${ ('Cancel' eq operation  && !summaryVO.isNewflow) && superNodestatus==0 }">
			<input type="hidden" value="_commonCancel"
				id="tool_${commonActionNodeCount}" />
			<%--撤销--%>
		</c:if>
		<c:if test="${ ('Forward' eq operation)  && superNodestatus==0}">
			<input type="hidden" value="_commonForward"
				id="tool_${commonActionNodeCount}" />
			<%--转发--%>
		</c:if>
		<%-- <c:if test="${ ('Sign' eq operation && summaryVO.summary.bodyType ne '45')  && superNodestatus==0}">
			<input type="hidden" value="_commonSign"
				id="tool_${commonActionNodeCount}" />
			签章
		</c:if> --%>
		<c:if test="${ ('Transform' eq operation)  && superNodestatus==0 }">
			<input type="hidden" value="_commonTransform"
				id="tool_${commonActionNodeCount}" />
			<%--转事件 --%>
		</c:if>
		<c:if test="${('SuperviseSet' eq operation)  && superNodestatus==0}">
			<input type="hidden" value="_commonSuperviseSet"
				id="tool_${commonActionNodeCount}" />
			<%--督办设置--%>
		</c:if>
		<c:if test="${ ('SpecifiesReturn' eq operation )  && superNodestatus==0}">
			<input type="hidden" value="_dealSpecifiesReturn"
				id="tool_${commonActionNodeCount}" />
			<%--指定回退--%>
		</c:if>
	</c:forEach>
</c:if> <c:if test="${(nodePerm_advanceActionList ne '[]')  && superNodestatus==0 }">
	<a id="moreLabel" class="right margin_t_15">${ctp:i18n('common.more.label')}</a>
</c:if></div>
<div class="hr_heng margin_t_10">&nbsp;</div>

<!--处理意见区域-->
<div class="opinions padding_t_10">
<div class="common_radio_box clearfix">
<div class="left"><c:if test="${nodeattitude!=3}">
	<c:if test="${nodeattitude==1}">
		<label class="margin_r_10 hand" for="afterRead"> <input
			id="afterRead" class="radio_com" name="attitude"
			value="collaboration.dealAttitude.haveRead" type="radio"
			<c:if test="${commentDraft.extAtt1 eq null || commentDraft.extAtt1 eq 'collaboration.dealAttitude.haveRead'}">checked="checked"</c:if>>${ctp:i18n('collaboration.dealAttitude.haveRead')}<!-- 已阅 -->
		</label>
	</c:if>
	<label class="margin_r_10 hand" for="agree"> <input id="agree"
		class="radio_com" name="attitude"
		value="collaboration.dealAttitude.agree" type="radio"
		<c:if test="${nodeattitude == 2 || commentDraft.extAtt1 eq 'collaboration.dealAttitude.agree'}">checked="checked"</c:if>>${ctp:i18n('collaboration.dealAttitude.agree')}<!-- 同意 -->
	</label>
	<c:if test="${superNodestatus==0 || superNodestatus==3}">
	<label class="margin_r_10 hand" for="notagree"> <input
		id="notagree" class="radio_com" name="attitude"
		value="collaboration.dealAttitude.disagree" type="radio"
		<c:if test="${commentDraft.extAtt1 eq 'collaboration.dealAttitude.disagree'}">checked="checked"</c:if>>${ctp:i18n('collaboration.dealAttitude.disagree')}<!-- 不同意 -->
	</label>
	</c:if>
</c:if></div>
<c:if test="${ctp:containInCollection(basicActionList, 'CommonPhrase')}">
	<div class="right"><a id="cphrase" curUser="${CurrentUser.id}">${ctp:i18n('collaboration.common.commonLanguage')}<!-- 常用语 --></a></div>
</c:if>
    <div class="right">
	<span id="praiseToObj" 
	title="<c:if test='${commentDraft.praiseToSummary}'>${ctp:i18n('collaboration.summary.label.praisecancel')}</c:if><c:if test='${!(commentDraft.praiseToSummary)}'>${ctp:i18n('collaboration.summary.label.praise')}</c:if>" class="ico16 ${commentDraft.praiseToSummary ? 'like_16' : 'no_like_16' }" style="width:16px;" onclick='praiseToSummary()'></span>
	&nbsp;&nbsp;<em class="seperate"></em>&nbsp;&nbsp;
	</div>
</div>

<c:if test="${ctp:containInCollection(basicActionList, 'Opinion')}">
	<textarea id="content_deal_comment" name="content_deal_comment"
		class="padding_5 margin_t_5" errorIcon="false" style="width: 95%; height: 150px;font-size:14px;">${commentDraft.content}</textarea>
</c:if>
<div class="clearfix margin_t_10" id="attachmentAndDoc">
    <c:if test="${(ctp:containInCollection(basicActionList, 'UploadRelDoc') or  ctp:containInCollection(basicActionList, 'UploadAttachment'))  && superNodestatus==0 }">
    	<span class="left"> 
            <c:if
    		test="${ctp:containInCollection(basicActionList, 'UploadAttachment') }">
    		<!-- 附件 -->
    		<div class="nodePerm" baseAction="UploadAttachment"
    			style="display: inline;"><a id="uploadAttachmentID" title="${ctp:i18n('collaboration.summary.label.att')}"
    			class="margin_r_5"><span class="ico16 affix_16"></span></a>(<span
    			id="attachmentNumberDiv${commentId}">0</span>)</div>
    	   </c:if> 
           <c:if test="${ctp:containInCollection(basicActionList, 'UploadRelDoc')}">
    		  <!-- 关联 -->
    		  <div class="nodePerm" baseAction="UploadRelDoc"
    			style="display: inline;"><a id="uploadRelDocID" title="${ctp:i18n('collaboration.summary.label.ass')}"
    			class="margin_l_10 margin_r_5"><span
    			class="ico16 associated_document_16"></span></a>(<span
    			id="attachment2NumberDiv${commentId}">0</span>)</div>
    	   </c:if> 
        </span>
    </c:if> 
    <span class="right"><%-- 消息推送 --%>
        <a id="pushMessageButton">
            <em class="ico16 system_messages_16"></em>
            <span id="pushMessageButtonSpan" class="menu_span">${ctp:i18n('collaboration.sender.postscript.pushMessage')}</span>
        </a>
    </span>
    <input type="hidden" id="dealMsgPush" name="dealMsgPush" />
</div>
<div class="newinfo_area margin_t_5">
<div id="attachmentTR${commentId}" style="display: none;">
<div id="content_deal_attach" isGrid="true" class="comp"
	comp="type:'fileupload',applicationCategory:'1',attachmentTrId:'${commentId}',canFavourite:false,canDeleteOriginalAtts:true"
	attsdata='${handleAttachJSON }'></div>
</div>
<div id="attachment2TR${commentId}" style="display: none;">
<div id="content_deal_assdoc" isGrid="true" class="comp"
	comp="type:'assdoc',applicationCategory:'1',attachmentTrId:'${commentId}',modids:'1,3',canFavourite:false,canDeleteOriginalAtts:true"
	attsdata='${handleAttachJSON }'></div>
</div>
</div>
<div class="hr_heng margin_t_10">&nbsp;</div>
<c:if test="${ctp:containInCollection(basicActionList, 'Opinion')}">
	<div class="clearfix margin_t_10">
	<div class="common_checkbox_box clearfix left margin_t_5"><label
		class="margin_r_10 hand" for="isHidden" id="isHiddenLable"> <input id="isHidden"
		class="radio_com" name="isHidden" type="checkbox">${ctp:i18n('collaboration.common.default.commentHidden')}<!-- 意见隐藏 -->
	</label></div>
	<div id="showToIdSpan" class="common_txtbox common_txtbox_dis clearfix">
	<label class="margin_r_10 left title">${ctp:i18n('collaboration.common.default.doesNotInclude')}:</label><!-- 不包括 -->
	<div class="common_txtbox_wrap"><input type="text"
		id="showToIdInput" name="showToIdInput" class="comp"
		comp='type:"selectPeople",showBtn:false,panels:"Department,Team,Post,Outworker,RelatePeople",minSize:0,selectType:"Member",showFlowTypeRadio: false'
		value="${ctp:i18n('collaboration.common.default.clickOpenPeople')}"><!-- 点击选择公开人 -->
	</div>
	</div>
	</div>
</c:if> <c:if test="${ctp:containInCollection(basicActionList, 'Track')}">
	<div id='trackDiv_detail'
		class="common_radio_box common_checkbox_box clearfix margin_t_10">
	<label class="margin_r_10 hand" for="isTrack" id="isTrackLable"> <input
		id="isTrack" class="radio_com" name="isTrack" value="0"
		type="checkbox">${ctp:i18n('collaboration.forward.page.label4')}<!-- 跟踪 -->
	</label> <label class="margin_r_10 disabled_color hand" for="trackRange_all"
		id="label_all"> <input id="trackRange_all" class="radio_com"
		name="trackRange" value="1" type="radio" disabled="disabled">${ctp:i18n('collaboration.listDone.all')}<!-- 全部 -->
	</label> <label class="margin_r_10 disabled_color hand"
		for="trackRange_members" id="label_members"> <input
		id="trackRange_members" class="radio_com" name="trackRange" value="0"
		type="radio" disabled="disabled">${ctp:i18n('collaboration.listDone.designee')}<!-- 指定人 -->
	</label> <input type="hidden" id="zdgzry" name="zdgzry" value="${zdgzry}"></input><input id="trackRange_members_textbox" readonly onclick="javascript:toggleTrackRange_members()" type="text" class="hidden" value="${trackNames}" />
	</div>
</c:if> <%-- 归档--%> <c:if test="${canArchive  && superNodestatus==0 }">
	<div class="clearfix margin_t_10 nodePerm" baseAction="Archive">
	<div class="common_checkbox_box clearfix"><label
		class="margin_r_10 hand" for="pigeonhole" id="pigeonholeLable"> <input
		id="pigeonhole" class="radio_com" name="pigeonhole" value="0"
		type="checkbox">${ctp:i18n('collaboration.common.default.archiveAfterProcessing')}<!-- 处理后归档 -->
	<input id="pigeonholeValue" name="pigeonholeValue" type="hidden">
	</label></div>
	</div>
</c:if></div>
<div class="clearfix right" id="_dealDiv">
<div align="right"><%--存为草稿 --%> <c:if
	test="${(isIssus ne 'true' and isAudit ne 'true' and isVouch ne 'true') && (superNodestatus==0 || superNodestatus==1)}">
	<div class="left margin_t_20"><a id="_dealSubmit"
		class="common_button common_button_emphasize margin_r_5">${ctp:i18n('common.button.submit.label')}</a>
	</div>
</c:if> <c:if test="${(isAudit eq 'true') && (superNodestatus==0 || superNodestatus==1) }">
	<div class="left margin_t_20"><a id="_auditPass"
		class="common_button common_button_gray margin_r_5">${ctp:i18n('collaboration.common.default.auditBy')}</a><!-- 审核通过 -->
	<c:if test="${superNodestatus==0}">
	<a id="_auditNotPass"
		class="common_button common_button_gray margin_r_5">${ctp:i18n('collaboration.common.default.anAuditNotPassed')}</a><!-- 审核不通过 -->
	</c:if>
	</div>
</c:if> <c:if test="${ (isVouch eq 'true') && (superNodestatus==0 || superNodestatus==1) }">
	<div class="left margin_t_20"><a id="_vouchPass"
		class="common_button common_button_gray margin_r_5">${ctp:i18n('collaboration.common.default.approvedBy')}</a><!-- 核定通过 -->
	<c:if test="${superNodestatus==0}">
	<a id="_vouchNotPass"
		class="common_button common_button_gray margin_r_5">${ctp:i18n('collaboration.common.default.approvedNotBy')}</a><!-- 核定不通过 -->
	</c:if>
	</div>
</c:if> <c:if test="${ (isIssus eq 'true') && (superNodestatus==0 || superNodestatus==1) }">
	<div class="left margin_t_20"><a id="_dealPass1"
		class="common_button common_button_emphasize margin_r_5">${ctp:i18n('collaboration.common.default.adoptedAndPublished')}</a><!-- 通过并发布 -->
	<c:if test="${superNodestatus==0}">
	<a id="_dealNotPass"
		class="common_button common_button_emphasize margin_r_5">${ctp:i18n('collaboration.common.default.notPass')}</a><!-- 不通过 -->
	</c:if>
	</div>
</c:if> <c:if
	test="${(isAudit ne 'true' and isVouch ne 'true' and ctp:containInCollection(basicActionList, 'Opinion') and ctp:containInCollection(basicActionList, 'Comment')) && (superNodestatus==0 || superNodestatus==1)}">
	<div class="left margin_t_20"><a id="_dealSaveDraft"
		class="common_button common_button_gray margin_r_5">${ctp:i18n('collaboration.newcoll.saveDraft')}</a></div>
</c:if> <c:if test="${(ctp:containInCollection(basicActionList, 'Comment')) && (superNodestatus==0 || superNodestatus==2)}">
	<div class="left margin_t_20"><a id="_dealSaveWait"
		class="common_button common_button_gray">${ctp:i18n("collaboration.dealAttitude.temporaryAbeyance")}</a></div>
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
	<input type="hidden" id="pushMessage" value="false"> 
	<input type="hidden" id="pushMessageToMembers">
	<input type="hidden" id="praiseInput" value="0"></input>
</div>
</body>
</html>
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
  var affairMemberId = '${summaryVO.affair.memberId}';
  var isNewfolw = '${summaryVO.isNewflow}';
  var workItemId = '${summaryVO.workitemId}';
  var trackMember="${trackIds}";
  var commentId = '${commentId }';
  var isTemplete = '${isTemplete}'=='true'? true : false;
  var displayIds = '${displayIds }';
  var displayNames = '${displayNames }';
  
  $.content.getContentDealDomains = function(domains) {
    if (!domains)
      domains = [];
    var commentVal = $("#content_deal_comment").val();
    if($.trim(commentVal) != "" && commentVal.length > 2000) {
        $.alert("${ctp:i18n('collaboration.common.deafult.dealCommentMaxSize')}");
        enableOperation();
        setButtonCanUseReady();
        return false;
    }
    $("#comment_deal #content").val(commentVal);
    <c:if test="${contentCfg.useWorkflow}">
    $("#comment_deal #extAtt1").val($("input[name='attitude']:checked").val());
    </c:if>
    $("#comment_deal #hidden").val($("#isHidden").attr('checked')=="checked");
    $("#comment_deal #showToId").val($("#showToIdInput").val());
    $("#content_deal_attach").html("");
    saveAttachmentPart("content_deal_attach");
    $("#comment_deal #relateInfo").val($.toJSON($("#content_deal_attach").formobj()));
    domains.push("comment_deal");
    return domains;
  };
</script>
