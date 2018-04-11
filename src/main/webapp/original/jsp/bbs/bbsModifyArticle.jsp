<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="bbsHeader.jsp"%>
<html class="h100b over_hidden">
  <head>
        <title>${ctp:i18n('bbs.reply.modify.label')}</title>
    	<link rel="stylesheet" type="text/css" href="${path}/skin/default/bbs.css${v3x:resSuffix()}" />
		<script src="${path}/apps_res/bbs/js/bbs-createArticle.js${v3x:resSuffix()}"></script>
		<script type="text/javascript">
		var modifyAnonymousFlag = ${article.anonymousFlag};
		var modifyAnonymousReplyFlag = ${article.anonymousReplyFlag};
		isNeedCheckLevelScope_wf = false;
        var hiddenPostOfDepartment_wf = true;
		<c:if test="${spaceType != '3' && spaceType != '18'}">
			var onlyLoginAccount_wf = true;
		</c:if>
		function setPeopleFields2(elements){
			if(!elements){
				return;
			}
			var option = new Option(getNamesString(elements), getIdsString(elements));
			
			var ops = document.getElementById("issueArea").options;
			if(ops.length == 3){
				ops.remove(2);
			}
			ops.add(option);
			option.selected = true;
		}
		
		var hasIssueArea = true;
		
		function selectIssueArea(){
			selectPeopleFun_wf();
		}
		
		function setPeopleFields(elements){
			if(!elements){
				return;
			}
			$("#issueArea").val(getIdsString(elements));
			$("#issueAreaName").val(getNamesString(elements));
			hasIssueArea = true;
		}
		<c:if test="${DEPARTMENTAffiliateroomFlag eq true}">
			hasIssueArea = true;
		</c:if>
		
		var _isCustom = ${spaceType == '18'||spaceType == '17'||spaceType == '4'};
		</script>
  </head>
  <body class="h100b over_hidden">
			<form id="articlePostForm" action="">
  			<input type="hidden" name="original_top"  id = "original_top"value="">
  			<input type="hidden" name="original_left" id = "original_left" value="">
			<input type="hidden" name="boardId" id="boardId" value="${boardId}" >
			<input type="hidden" name="boardType" id="boardType" value="${boardType}">
			<input type="hidden" name="boardInfo" id="boardInfo" value="${ctp:toHTML(boardMapJson)} ">
			<input type="hidden" id="articleId" name="articleId" value="${article.id}">
			<input type="hidden" id="articleState" name="articleState" value="${article.state}">
			<input type="hidden" id="issueArea" value="${issueArea}" name="issueArea"><%-- 选人信息 --%>
  			<%--选人 --%>
  			<c:set value="${v3x:showOrgEntitiesOfTypeAndId(issueArea, pageContext)}" var="issueAreastr" />
  			<c:set value="${v3x:parseElementsOfTypeAndId(issueArea)}" var="issueAreaValue" />
		   	<script type="text/javascript">
		        <!--
		        var includeElements_wf = "${v3x:parseElementsOfTypeAndId(entity)}";
		        //-->
	        </script>
			<c:choose>
				<c:when test="${empty group}">
					<v3x:selectPeople id="wf" originalElements="${issueAreaValue}" panels="Department,Team,Post,Level,Outworker" selectType="Member,Department,Account,Post,Level,Team" departmentId="${v3x:currentUser().departmentId}" jsFunction="setPeopleFields(elements)"/>
				</c:when>
				<c:otherwise>
					<v3x:selectPeople id="wf" showAllAccount="true" originalElements="${issueAreaValue}" panels="Account,Department,Team,Post,Level" selectType="Member,Department,Account,Post,Level,Team" departmentId="${v3x:currentUser().departmentId}" jsFunction="setPeopleFields(elements)"/>
				</c:otherwise>
			</c:choose>
			<c:choose>
				<c:when test="${DEPARTMENTAffiliateroomFlag eq true}">
					<input type="hidden" name="bbstype_Name" id="bbstype_Name" value="1" ><!-- 单位板块预览取值和部门区分 -->
				</c:when>
				<c:otherwise>
					<input type="hidden" name="bbstype_Name" id="bbstype_Name" value="" ><!-- 单位板块预览取值和部门区分 -->
				</c:otherwise>
			</c:choose>
			<c:set value="${article.state != 3 ? 'disabled' : ''}" var="disabledFlag" />
			<div class="dialog_body">
				<div class="dialog_header">
                    <span class="index_logo" style="padding-left:96px;">
                        <img src="${path}/skin/default/images/cultural/bbs/logo_create.png" width="31" style="margin-top:15px;">
                        <span class="index_logo_name">${ctp:i18n('new.bbs.button')} +</span>
                    </span>
                </div>
				<div class="dialog_content" style="background:#f7f7f7;">
					<div class="dialog_content_top over_hidden">
						<input type="text" class="input_left font16" id="articleTitle" value="${v3x:toHTML(article.articleName)}" maxLength="85" maxSize="85" ${disabledFlag}/><%-- 标题 --%>
						<select class="news_select margin_r_10 font12"  id = "boardTypeSelect" onchange="createBoardSelect(true);" ${disabledFlag}>
							<c:choose>
                              <c:when test="${spaceType==18}"><option id="boardType_18" value="group" selected>${ctp:i18n('bbs.board.public.custom.group')}</option></c:when>
                              <c:when test="${spaceType==17}"><option id="boardType_17" value="account" selected>${ctp:i18n('bbs.board.public.custom')}</option></c:when>
                              <c:when test="${spaceType==4}"><option id="boardType_4" value="custom" selected>${ctp:i18n('bbs.board.custom')}</option></c:when>
                              <c:when test="${spaceType==12}"><option id="boardType_12" value="project" selected>${ctp:i18n('bbs.title.label')}</option></c:when>
                              <c:otherwise>
    							<c:if test="${fn:length(boardMap['group'])>0 && board.affiliateroomFlag != '1'}">
    							<option value="group" id="boardType_3">${ctp:i18n('Groupdiscussion.label')}</option>
    							</c:if>
    							<c:if test="${fn:length(boardMap['account'])>0 && board.affiliateroomFlag != '1'}">
    							<option value="account" id="boardType_2">${ctp:i18n('Unitdiscussion.label')}</option>
    							</c:if>
    							<c:if test="${fn:length(boardMap['dept'])>0 && board.affiliateroomFlag == '1'}">
    							<option value="dept" id="boardType_1">${ctp:i18n('bbs.departmentBbsSection.label')}</option>
    							</c:if>
                              </c:otherwise>
                             </c:choose>
						</select>
						<select class="active_select font12" id = "boardSelect" onchange="changeCheckBox();" ${disabledFlag}>
							<option value="${board.id}">${board.name}</option>
						</select>
					</div>
					<div class="dialog_content_bottom margin_t_10 margin_b_10">
                        <c:choose>
                            <c:when test="${spaceType == '12'}">
                              <input id="issueAreaName" type="text" readonly="readonly" disabled class="issue_area margin_r_10" value="${issueAreastr }">
                            </c:when>
                            <c:otherwise>
						      <input id="issueAreaName" type="text" readonly="readonly" class="issue_area margin_r_10" onclick="selectIssueArea()" value="${issueAreastr }">
                            </c:otherwise>
                        </c:choose>
    					<span style="margin-right:20px;" class="font12">
                            <label for="radio1">
    						<input id="radio1" type="radio" ${disabledFlag} name="typeRadio" class="radio" checked="checked" value="0" ${article.resourceFlag==0 ? 'checked' : ''}> ${ctp:i18n('bbs.showArticle.Noth') }<span style="margin-right: 5px;"></span>
                            </label>
                            <label for="radio2">
    						<input id="radio2" type="radio" ${disabledFlag} name="typeRadio" class="radio" value="1" ${article.resourceFlag==1 ? 'checked' : ''}> ${ctp:i18n('bbs.yuan.label') }<span style="margin-right: 5px;"></span>
                            </label>
                            <label for="radio3">
    						<input id="radio3" type="radio" ${disabledFlag} name="typeRadio" class="radio" value="2" ${article.resourceFlag==2 ? 'checked' : ''}> ${ctp:i18n('bbs.zhuan.label') }<span style="margin-right: 5px;"></span>
                            </label>
    					</span>
    					<span class="font16">
                            <label for="isGetNewReply">
    						<input type="checkbox" class="checkbox" id = "isGetNewReply" value="${ctp:i18n('bbs.receive.message.label') }" ${article.messageNotifyFlag == true ? 'checked' : ''}><span class="margin_l_5 font12" style="margin-right: 5px;">${ctp:i18n('bbs.receive.message.label') }</span>
                            </label>
                            <label for="isSendSecret">
    						<input type="checkbox" class="checkbox" id = "isSendSecret" ${disabledFlag} value="${ctp:i18n('anonymous.post') }" style="display: ${ board.anonymousFlag == 0 ? '' : 'none'}" ${article.anonymousFlag == true ? 'checked' : ''}><span class="margin_l_5 font12" style="margin-right: 5px;display: ${ board.anonymousFlag == 0 ? '' : 'none'}">${ctp:i18n('anonymous.post') }</span>
                            </label>
                            <label for="isReplySecret">
    						<input type="checkbox" class="checkbox" id = "isReplySecret" ${disabledFlag} value="${ctp:i18n('anonymous.reply') }" style="display: ${ board.anonymousReplyFlag == 0 ? '' : 'none'}" ${article.anonymousReplyFlag == true ? 'checked' : ''}><span class="margin_l_5 font12" style="margin-right: 5px;display: ${ board.anonymousReplyFlag == 0 ? '' : 'none'}">${ctp:i18n('anonymous.reply') }</span>
                            </label>
    					</span>
	                </div>
                    <div id="attachmentDiv" class="textarea_edit_reply">
                        <div class="attch_flag left">
                            <span class="pointer">
                                <em class="icon16 file_attachment_16 margin_b_5"></em>
                                <span class="insert_file" onclick="javascript:insertAttachmentPoi('atts1')">${ctp:i18n('common.attachment.label')}</span>
                                <span id="attachmentTRatts1" style="float: left;display:none;">&nbsp;&nbsp;(<span id="attachmentNumberDivatts1"></span>)&nbsp;&nbsp;</span>
                            </span>
                        </div>
                        <div id="atts2" class="comp" comp="type:'fileupload',applicationCategory:'9',attachmentTrId:'atts1',canDeleteOriginalAtts:true,originalAttsNeedClone:false,callMethod:'attchmentCallBack',takeOver:false" attsdata='${attListJSON}'></div>
                        <div id="attachmentAreaatts1" class="attachment_area left"></div>
                    </div>
				</div>
				<%--正文编辑器 --%>
				<div class="text_editor">
					<iframe id="replyArticle" name="replyArticle" frameborder="0" width="100%" height="100%" style="height:100%;" src="${detailURL}?method=createArticleEditor&articleId=${article.id }" ></iframe>
				</div>
				<div class="bottom_button" style="margin-top:-5px; position: relative; z-index:2;">
					<a class="right create_button margin_tr_10" onclick="${article.state != '3' ? 'modifyArticle' : 'publishArticle'}('false'); ">${ctp:i18n('bbs.create.issue.js')}</a>
					<a class="left create_button margin_tr_10" onclick="previewBbs();">${ctp:i18n('bbs.create.preView.js') }</a>
					<c:if test="${article.state == 3 && spaceType != '12'}">
					<a class="left create_button margin_tr_10 save" onclick="publishArticle('true');">${ctp:i18n('button.save') }</a>
					</c:if>
				</div>
			</div>
  		</form>
  		<form name="preForm" action='${path}/bbs.do?method=bbsPreview' method="post"  target="_blank" >
  			<input id="preTitle" name="preTitle" type="hidden">
  			<input id="preContent" name="preContent" type="hidden">
  			<input id="preScope" name="preScope" type="hidden">
  			<input id="preBoardId" name="preBoardId" type="hidden">
            <input id="preAttachment" name="preAttachment" type="hidden">
  		</form>
	</body>
	<footer>
		<script type="text/javascript">
			var ajax_bbsArticleManager = new bbsArticleManager();
		</script>
	</footer>
</html>
