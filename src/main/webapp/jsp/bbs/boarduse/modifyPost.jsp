<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum"%>
<%@page import="com.seeyon.v3x.common.constants.Constants"%>
<!DOCTYPE html>
<html style="height: 100%">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title><fmt:message key='bbs.reply.modify.label'/></title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/skin/default/skin.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/common/all-min.css">
<script type="text/javascript">
var boardNamelessMap = new Properties();
<%-- 不进行职务级别的筛选(工作范围限制) --%>
isNeedCheckLevelScope_wf = false;
<c:if test="${group!='group'}">
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
	document.issuePostForm.issueArea.value=getIdsString(elements);
	document.issuePostForm.issueAreaName.value=getNamesString(elements);	
	hasIssueArea = true;
}
	
function issuePost(){
	var theForm = document.getElementsByName("issuePostForm")[0];
	if (!theForm) {
        return;
    }
	theForm.action = "${detailURL}?method=modifyArticle&pageSizePara=${v3x:escapeJavascript(param.pageSizePara)}&nowPagePara=${v3x:escapeJavascript(param.nowPagePara)}&isCollCube=${param.isCollCube}";
	if (checkForm(theForm) && checkSelectWF()) {
		var ds = validateArticleName();
		if(ds == "true" && !window.confirm(v3x.getMessage("BBSLang.bbs_bbsmanage_alert_same"))){
			return;
		}
		if (!saveOffice()) {
			return;
		}
      
      	saveAttachment();
	    disableButton("save");
	    disableButton("insert");
	    isFormSumit = true;
		theForm.submit();
	}
}


function checkSelectWF() {
    if (!hasIssueArea) {
        alert(v3x.getMessage("BBSLang.bbs_boarduse_issuePost_issuearea"));
        selectPeopleFun_wf();
        return false;
    }
    return true;
}

<%-- ajax 验证标题名称是否重复(实际没做限制了) --%>
function validateArticleName(){
	return "false";
}
<c:if test="${DEPARTMENTAffiliateroomFlag eq true}">
	hasIssueArea = true;
</c:if>
</script>
</head>
<c:set value="${issueArea}" var="issueAreaid"/>
<body scroll="no" style="height: 100%">
<form name="issuePostForm" id="issuePostForm" method="post" style="margin: 0px; height: 100%">
	<input type="hidden" name="boardId" value="${boardId}" >
	<input type="hidden" name="articleId" value="${article.id}">
	<input type="hidden"  name="issueArea" value="${issueArea}">
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
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td valign="top">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page-list-border">
				<tr >
					<td colspan="6" height="22" valign="top">
						<script type="text/javascript">
							var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
							
							var insert = new WebFXMenu;
							insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
							insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' />", "insertCorrelationFile()"));//关联文档的入口
              
							myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, [1,6], "", insert));
					    	
							document.write(myBar);
							document.close();
						</script>
                        <div class="hr_heng"></div>
			    	</td>
				</tr>
				<tr class="bg-summary" height="45">
                    <td rowspan="${DEPARTMENTAffiliateroomFlag ? '2' : '3'}" width="1%" nowrap="nowrap" ><a href="#" onclick="javaScript:issuePost();" id='sendder'  class="margin_lr_10 display_inline-block align_center new_btn"><fmt:message key="oper.publish"/></a></td>
					<td width="1%" height="29" class="bg-gray" noWrap="noWrap"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />:</td>
					<td width="27%">
					<fmt:message key="common.default.subject.value" var="defSubject" bundle="${v3xCommonI18N}" />
					<input
						name="articleName" type="text" id="articleName" class="input-300px cursor-hand"
						inputName="<fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />" maxLength="85" maxSize="85"
						 value="${v3x:toHTML(article.articleName)}" disabled >
					</td>
					<td width="10%" class="bg-gray"><fmt:message key="bbs.board.label"/>:</td>
					<td width="27%">
					<c:choose>
						<c:when test="${DEPARTMENTAffiliateroomFlag}">
							<select name="boardId" disabled  id="boardIdBlock" class="input-300px">
							     <c:if test="${!empty deptSpaceModels}">
							         <c:forEach items="${deptSpaceModels}" var="dept">
	                                    <c:if test="${dept.entityId == board.id}">
	                                        <option value="${board.id}" selected>${dept.spacename}</option>
	                                    </c:if>
	                                </c:forEach>
							     </c:if>
							     <c:if test="${!empty deptSpaceModels}">
							     <option value="${board.id}" selected>${board.name}</option>
							     </c:if>
							</select>
						</c:when>
						<c:otherwise>
							<input type="text" class="input-300px" id="boardName" name="boardName" value="${board.name}" disabled>
						</c:otherwise>
					</c:choose>
					</td>
					<td width="28%" style="padding-left: 10px;">
						<label for="e">
							<input type="radio" name="resourceFlag"  disabled value="0" id="e" ${article.resourceFlag==0 ? 'checked' : ''}>
                            <fmt:message key="bbs.none.label"/>
						</label>
						<label for="b">
							<input type="radio" name="resourceFlag"  disabled value="1" id="b"  ${article.resourceFlag==1 ? 'checked' : ''}>
                            <fmt:message key="bbs.yuan.label" />
						</label>
						<label for="c">
							<input type="radio" name="resourceFlag"  disabled value="2" id="c" ${article.resourceFlag==2? 'checked' : ''}>
                            <fmt:message key="bbs.zhuan.label" />
						</label>
					</td>
				</tr>
				<tr class="bg-summary">
					<td nowrap="nowrap" class="bg-gray" style="height: 30px;"><fmt:message key="bbs.boardmanager.column.issuearea.label"/>:</td>
					<fmt:message key="common.default.issueScope.value" var="defScope" bundle="${v3xCommonI18N}" />
					<c:set value="${v3x:showOrgEntitiesOfTypeAndId(issueArea, pageContext)}" var="issueAreastr" />
					<td nowrap="nowrap" >
						<input type="text" class="cursor-hand input-300px" ${DEPARTMENTAffiliateroomFlag? 'disabled' : ''} value="<c:out value="${issueAreastr}" escapeXml="true" />" name="issueAreaName" onclick="selectIssueArea()">
					</td>
					<td nowrap="nowrap" class="bg-gray"><fmt:message key="bbs.issue.poster.label" />: </td>
					<td nowrap="nowrap"><input type="text" name="issueUser"  class="input-300px bbs-readonly"
						value="${v3x:showMemberName(article.issueUserId)}" readonly disabled> 
					</td>
					<td style="padding-left: 10px;">
					<c:if test="${!DEPARTMENTAffiliateroomFlag}">
						<label for="d" id="anonymousDiv" style="display: ${ board.anonymousFlag == 0 ? '' : 'none'}">
							<input type="checkbox"  disabled name="anonymous" id="d"  ${article.anonymousFlag == true ? 'checked' : ''}>
                            <fmt:message key="anonymous.post"/>&nbsp;&nbsp;
						</label>
							
						<label for="f" id="anonymousDiv" style="display: ${ board.anonymousReplyFlag == 0 ? '' : 'none'}">
							<input type="checkbox"  disabled name="anonymousReply" id="f"  ${article.anonymousReplyFlag == true ? 'checked' : ''}>
                            <fmt:message key="anonymous.reply"/>&nbsp;&nbsp;
						</label>
					</c:if>
					<label for="a">
						<input type="checkbox" name="messageNotifyFlag" id="a"  ${article.messageNotifyFlag == true ? 'checked' : ''}>
                        <fmt:message key="bbs.receive.message.label"/>
					</label>
					</td>
				</tr>
                <tr class="bg-summary" style="${DEPARTMENTAffiliateroomFlag ? 'display:none;' : ''}">
                    <td width="1%" height="24" class="bg-gray" noWrap="nowrap"></td>
                    <td nowrap="nowrap" colspan="4">
                    <%--<label for="shareDajia">
                        <input type="checkbox" name="shareDajia" id="shareDajia" ${v3x:outConditionExpression(article.shareDajia, 'checked', '')}/>
                        <span><fmt:message key="news.share.dajia" /></span>
                    </label> --%>
                    </td>
                </tr>
				<!-- 在此处添加关联文档 -->
                        <tr id="attachment2TR"  style="display:none;">
                          <td class="label bg-gray" colspan="2"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
                          <td class="value" colspan="4">
                            <div class="div-float">(<span id="attachment2NumberDiv"></span>)</div>
                           <div></div><div id="attachment2Area" style="overflow: auto;"></div></td>
                         </tr>
			  	<tr id="attachmentTR" class="bg-summary , bbs-attachment-padding" style="display:none;">
			      	<td nowrap="nowrap" height="18" class="bg-gray" valign="top" colspan="2">
					<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />:</td>
					<td colspan="4" valign="top">
					<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
					<v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" />
			      	</td>
			  	</tr>
				<tr><td colspan="6" height="6" class="bg-b"></td></tr>
				<tr valign="top">
					<td colspan="6" id="editerDiv_td">
                       <div id="editerDiv">      
                        <v3x:editor htmlId="content" content="${article.content}" type="HTML" barType="Bbs" category="<%=ApplicationCategoryEnum.bbs.getKey()%>" />
                       </div>
                     </td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>