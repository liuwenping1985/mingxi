<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html> 
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum"%>
<%@page import="com.seeyon.v3x.common.constants.Constants"%>
<html style="height:100%;">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title>
<c:if test="${param.method ne 'modifyPost'}">
  <fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" /><fmt:message key='application.9.label' bundle="${v3xCommonI18N}" /></title>
</c:if>
<c:if test="${param.method eq 'modifyPost'}">
  <fmt:message key='bbs.reply.modify.label'/>
</c:if>
</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/skin/default/skin.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/common/all-min.css">
<script type="text/javascript">
<!--
<%-- 不进行职务级别的筛选(工作范围限制) --%>
isNeedCheckLevelScope_wf = false;
<%-- 隐藏部门下的岗位 --%>
var hiddenPostOfDepartment_wf = true;
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

var hasIssueArea = false;

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
	
	theForm.action = "${detailURL}?method=createArticle&group=${group}&SectionRoomFlag=${SectionRoomFlag}";
	if('${param.flag}'=='modify') {
		theForm.action = "${detailURL}?method=modifyArticle&group=${group}&articleId=${article.id}&SectionRoomFlag=&{SectionRoomFlag}";
	}
	
	if (checkForm(theForm) && checkSelectWF()) {
		var ds = validateArticleName();
		if(ds == "true" && !window.confirm(v3x.getMessage("BBSLang.bbs_bbsmanage_alert_same"))){
			return;
		}

		if (!saveOffice()) {
			return;
		}      
      	saveAttachment();
	    document.getElementById("sendId").disabled = true;
	    isFormSumit = true;
		theForm.submit();
	}
}

function quoteDocument() {
    getA8Top().addassDialog = getA8Top().v3x.openDialog({
        title:v3x.getMessage("V3XLang.assdoc_title"),
        transParams:{'parentWin':window},
        url: v3x.baseURL + '/ctp/common/associateddoc/assdocFrame.do?isBind=1,3',
        targetWindow:getA8Top(),
        width:"800",
        height:"500"
    });
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

<c:if test="${PROGECTAffiliateroomFlag eq true}">
	<c:set var="issueAreaName" value="${v3x:showOrgEntitiesOfTypeAndId(PROGECTissueArea,pageContext)}" />
	hasIssueArea = true;
</c:if>

<c:if test="${not param.from eq 'projectSection'}">
	var theHtml=toHtml("${v3x:toHTML(board.name)}",'<fmt:message key="bbs.issue.post.label"/>');
	showCtpLocation("",{html:theHtml});
</c:if>

//-->
</script>
</head>
<body scroll="no" style="height:100%;">
<form name="issuePostForm" id="issuePostForm" method="post" style="margin: 0px; height:100%;">
<input type="hidden" id="PROGECTAffiliateroomFlag" name="PROGECTAffiliateroomFlag" value="${PROGECTAffiliateroomFlag}" >
<input type="hidden" id="deptName" name="deptName" value="${v3x:getOrgEntity('Department', v3x:currentUser().departmentId).name}" >
<input type="hidden" id="postName" name="postName" value="${v3x:getOrgEntity('Post', v3x:currentUser().postId).name}" >
<input type="hidden" id="bbsTypeName" name="bbsTypeName" value="${v3x:toHTML(board.name)}" >
<input type="hidden" id="rFlag" name="rFlag" value="0" />
<input type="hidden" id="yuan" name="yuan" value=" [<fmt:message key="bbs.yuan.label"/>]" escapeXml="true" />
<input type="hidden" id="zhuan" name="zhuan" value=" [<fmt:message key="bbs.zhuan.label" />]" escapeXml="true" />
<input type="hidden" name="image" id="image" value="${image}"> 
<input type="hidden" name="issuerImage" id="issuerImage" value="${issuerImage}"> 
<input type="hidden" name="managerFlag" id="managerFlag" value="${param.managerFlag}"> 
<input type="hidden" name="projectState" id="projectState" value="${projectState}"> 
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td height="100%">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page-list-border">
				<tr>
					<td colspan="6" height="22" valign="top" >
						<script type="text/javascript">
					    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
					    	var insert = new WebFXMenu;
							insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
                            insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' />", "quoteDocument()"));
					    	if(v3x.getBrowserFlag("hideMenu") == true){
					    		myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, [1,6], "", insert));
					    	}
					    	myBar.add(new WebFXMenuButton("preview", "<fmt:message key='common.toolbar.preview.label' bundle='${v3xCommonI18N}'/>", "viewPage('${genericController}?ViewPage=bbs/data_DetailForProject')", [7,3],"<fmt:message key='common.toolbar.preview.label' bundle='${v3xCommonI18N}'/>", null));
					    	<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
					    	document.write(myBar);
					    	document.close();
					    						    	
				    	</script>
			    	</td>
				</tr>
				<c:set value="${param.flag=='modify' ? 'disabled' : ''}" var="disabled" />
				<tr class="bg-summary">
					<td rowspan="2" width="1%" nowrap="nowrap"><a href="#" onclick="javaScript:issuePost();" id='sendId'  class="margin_lr_10 display_inline-block align_center new_btn"><fmt:message key="oper.publish"/></a></td>
					<td width="8%" class="bg-gray" ><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />:</td>
					<td width="27%">
					<fmt:message key="common.default.subject.value" var="defSubject" bundle="${v3xCommonI18N}" />
					<input
						name="articleName" type="text" id="articleName" class="input-100per" deaultValue="${defSubject}"
						inputName="<fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />"
						validate="isDeaultValue,notNull,maxLength" maxLength="80"
						 value="<c:out value="${article.articleName}" escapeXml="true" default='${defSubject}' />"
						${v3x:outConditionExpression(readOnly, 'readonly', '')}  ${disabled}
			            onfocus="checkDefSubject(this, true)" onblur="checkDefSubject(this, false)">
					</td>
					<td width="10%" class="bg-gray"><fmt:message key="bbs.board.label"/>:</td>
					<td width="25%">
						<select name="boardId"  class="input-100per" onchange="changeBoard(this)" ${PROGECTAffiliateroomFlag ? 'disabled' : ''}>
							<option value="${board.id}">${v3x:toHTML(board.name)}</option>
							<input type="hidden" name="boardId" value="${board.id}">
						</select>
					</td>
					<td width="25%" class="padding_l_5">
						<label for="e">
							<input type="radio" name="resourceFlag"  ${disabled} value="0" id="e" ${article.resourceFlag==0 ? 'checked' : ''}> <font color="#387d0b"><fmt:message key="bbs.none.label"/></font>
						</label>
						<label for="b">
							<input type="radio" name="resourceFlag"  ${disabled} value="1" id="b" ${article.resourceFlag==1 ? 'checked' : ''}> <font color="#387d0b"><fmt:message key="bbs.yuan.label" /></font>
						</label>
						<label for="c">
							<input type="radio" name="resourceFlag"  ${disabled} value="2" id="c" ${article.resourceFlag==2 ? 'checked' : ''}> <font color="#387d0b"><fmt:message key="bbs.zhuan.label" /></font>
						</label>
					</td>
				</tr>
				<tr class="bg-summary">
					<td class="bg-gray"><fmt:message key="bbs.scope.label" />:</td>
					<fmt:message key="common.default.issueScope.value" var="defScope" bundle="${v3xCommonI18N}" />
					<td nowrap="nowrap" >
					
					<input type="hidden" value="${PROGECTissueArea}" name="issueArea">
						<input type="text" readonly="true" class="cursor-hand input-100per" ${PROGECTAffiliateroomFlag? 'disabled' : ''}
						value="<c:out value="${issueAreaName}" escapeXml="true" default="${defScope}"/>"
						 name="issueAreaName"  id="issueAreaName"
						 onclick="selectIssueArea()"
						 title="<c:out value="${issueAreaName}" escapeXml="true" default="${defScope}"/>"
						 >
						<v3x:selectPeople id="wf" panels="Department,Team,Outworker" selectType="Account,Department,Team,Member" departmentId="${v3x:currentUser().departmentId}" jsFunction="setPeopleFields(elements)" />
					</td>
					
					<script type="text/javascript">
						showAllOuterDepartment_wf = true;
					</script>
					
					<td nowrap="nowrap" class="bg-gray"><fmt:message key="common.issuer.label"  bundle="${v3xCommonI18N}" />: </td>
					<td nowrap="nowrap"><input type="text" name="issueUser"  class="input-100per bbs-readonly"
						value="${v3x:currentUser().name}" readonly> 
					</td>
					<td class="padding_l_5">
						<label for="a">
							<input type="checkbox" name="messageNotifyFlag" id="a" ${article.messageNotifyFlag == true ? 'checked' : ''}><fmt:message key="bbs.receive.message.label"/>
						</label>
					</td>
				</tr>
                <tr id="attachment2TR" class="bg-summary" style="display:none;">
                    <td colspan="2" valign="top"></td>
                    <td colspan="4" valign="top" height="18">
                    <div style="float: left"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</div>
                    <div>
                    <div class="div-float">(<span id="attachment2NumberDiv"></span>)</div>
                    <div></div><div id="attachment2Area" style="overflow: auto;"></div></div>
                    </td>
                </tr>
			  	<tr id="attachmentTR" class="bg-summary" style="display:none;">
                    <td colspan="2" valign="top"></td>
                    <td colspan="4" height="18" valign="top">
                        <div style="float: left"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />:</div>
                        <div><div class="div-float"> (<span id="attachmentNumberDiv"></span>) </div> 
                        <v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" />
                        </div>
                    </td>
			  	</tr>
				<tr>
					<td colspan="6" height="6" class="bg-b"></td>
				</tr>
				<tr valign="top">
					<td colspan="6" id="ie6_ckeditor"><v3x:editor htmlId="content" content="${article.content}" type="HTML" barType="Bbs" category="<%=ApplicationCategoryEnum.bbs.getKey()%>" /></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>