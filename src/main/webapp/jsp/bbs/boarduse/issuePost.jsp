<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>	
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum"%>
<%@page import="com.seeyon.v3x.common.constants.Constants"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<title>
<fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" /><fmt:message key='application.9.label' bundle="${v3xCommonI18N}" />
</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/skin/default/skin.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/common/all-min.css">
<script type="text/javascript">
<%-- 保存可以发帖板块的是否允许匿名发帖情况，用于切换板块时同步匿名发帖复选框的出现 --%>
var boardAnonymousMap = new Properties();
<%-- 保存可以发帖板块的是否允许匿名回复情况，用于切换板块时同步匿名回复复选框的出现 --%>
var boardAnonymousReplyMap = new Properties();
<%-- 不进行职务级别的筛选(工作范围限制) --%>
isNeedCheckLevelScope_wf = false;
<%-- 隐藏部门下的岗位 --%>
var hiddenPostOfDepartment_wf = true;

<c:if test="${group!='group'}">
	var onlyLoginAccount_wf = true;
	//不选择个人组外单位人员
	hiddenOtherMemberOfTeam_wf = true;
</c:if>
<c:if test="${custom =='true' || publicCustom == 'true'}">
	var onlyLoginAccount_wf = false;
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
    if(${DEPARTMENTAffiliateroomFlag == true}){
    	if(document.getElementById('boardId').value==""){
			window.alert(v3x.getMessage("BBSLang.bbs_board_noAuth_post"));
			window.location.href="${detailURL}?method=listLatestFiveArticleAndAllBoard&group=${group}&custom=${custom}&spaceId=${spaceId}";
			return false;
    	}
    }else{
		if(document.getElementById('boardIdBlock').value=="")
		{
			window.alert(v3x.getMessage("BBSLang.bbs_board_noAuth_post"));
			window.location.href="${detailURL}?method=listLatestFiveArticleAndAllBoard&group=${group}&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${param.spaceId}";
			return false;
		}
    }
	theForm.action = "${detailURL}?method=createArticle&group=${group}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${param.spaceId}";
	if (checkForm(theForm) && checkSelectWF()) {
		var ds = validateArticleName();
		if(ds == "true" && !window.confirm(v3x.getMessage("BBSLang.bbs_bbsmanage_alert_same"))){
			return;
		}
		if (!saveOffice()) {
			return;
		}
      	saveAttachment();
		if(getA8Top() && getA8Top().startProc) getA8Top().startProc();
	    isFormSumit = true;
	    //关闭提示对话框
	    window.onbeforeunload = function(){
	      try {
	          removeCtpWindow(null,2);
	      } catch (e) {
	      }
	  }
	  var hrefSendder = document.getElementById("sendder");
	  if(!hrefSendder.disabled){
	   	hrefSendder.disabled = true;
	   	theForm.submit();
	  }
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
<c:if test="${DEPARTMENTAffiliateroomFlag eq true || publicCustom}">
	<c:set var="issueAreaName" value="${v3x:showOrgEntitiesOfTypeAndId(DEPARTMENTissueArea, pageContext)}" />
	hasIssueArea = true;
</c:if>

<%-- 切换板块的时候动态显示是否可匿名发起、匿名回复复选框 --%>
function changeBoard(obj){
	var anDiv = document.getElementById("anonymousDiv");
	if(boardAnonymousMap.get(obj.value)=='0'){
		anDiv.style.display = "";
	}else{
		anDiv.style.display = "none";
	}
	
	var anReplyDiv = document.getElementById("anonymousReplyDiv");
	if(boardAnonymousReplyMap.get(obj.value)=='0'){
		anReplyDiv.style.display = "";
	}else{
		anReplyDiv.style.display = "none";
	}
}
var includeElements_wf="";
var elements_wf="";
function openAjax(typeId){
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxBbsBoardManager", "getBbsMessage", false);
	requestCaller.addParameter(1, "String", typeId);
	var ds = requestCaller.serviceRequest();
	var aMessage = ds.split(';');
	document.getElementById('issueArea').value=aMessage[1];
	document.getElementById('issueAreaName').value=aMessage[3];
	document.getElementById('boardId').value=aMessage[0];
	if("${board.affiliateroomFlag}" == "1"  && aMessage[0] != undefined && aMessage[1] != undefined){
		includeElements_wf =aMessage[1].indexOf(aMessage[0])!=-1 ? aMessage[1] : "nil" ;
		elements_wf="";
	}else{
		includeElements_wf="";
		elements_wf="";
	}
    
}
</script>
</head>
<body scroll="no">
	<form name="issuePostForm" id="issuePostForm" method="post"
		style="margin: 0px">
		<input type="hidden" name="image" id="image" value="${image}"> 
		<input type="hidden" name="issuerImage" id="issuerImage" value="${issuerImage}"> 
		<input type="hidden" name="DEPARTMENTAffiliateroomFlag" value="${DEPARTMENTAffiliateroomFlag}"> 
		<input type="hidden" name="bbsTypeName" value="${issueAreaName}">
        <input type="hidden" id="spaceName" name="spaceName" value="${spaceName}">
		<c:set value="${v3x:getOrgEntity('Department', userDepartmentId).name}" var="publishScopeValue" />
		<input type="hidden" id="publishDepartmentName" name="publishDepartmentName" value="<c:out value="${publishScopeValue}"/>" escapeXml="true" />
		<c:set value="${v3x:getOrgEntity('Post', userPostId).name}" var="publishScopeValues" />
		<input type="hidden" id="publishPostName" name="publishPostName" value="<c:out value="${publishScopeValues}"/>" escapeXml="true" />
	    <input type="hidden" id="rFlag" name="rFlag" value="0" />
		<input type="hidden" id="yuan" name="yuan" value=" [<fmt:message key="bbs.yuan.label"/>]" escapeXml="true" />
		<input type="hidden" id="zhuan" name="zhuan" value=" [<fmt:message key="bbs.zhuan.label" />]" escapeXml="true" />
		
		<!--  
		<input type="hidden" id="boardName" name="boardName"	value="${boardName2}" escapeXml="true"/>
		-->
		<c:set value="${v3x:parseElementsOfTypeAndId(DEPARTMENTissueArea)}" var="org"/>
	
		<c:choose>
			<c:when test="${empty group}">
				<v3x:selectPeople id="wf"
					originalElements="${org}"
					panels="Department,Team,Post,Level,Outworker"
					selectType="Member,Department,Account,Post,Level,Team"
					departmentId="${v3x:currentUser().departmentId}"
					jsFunction="setPeopleFields(elements)" />
			</c:when>
			<c:otherwise>
				<v3x:selectPeople id="wf" showAllAccount="true"
		      		originalElements="${org}"
					panels="Account,Department,Team,Post,Level"
					selectType="Member,Department,Account,Post,Level,Team"
					departmentId=""
					jsFunction="setPeopleFields(elements)" />
			</c:otherwise>
		</c:choose>
		<c:if test="${spaceType == '18'||spaceType == '17'||board.affiliateroomFlag == '4'}">
		      <script type="text/javascript">
                    <!--
                     includeElements_wf = "${v3x:parseElementsOfTypeAndId(entity)}";
                    //-->
                </script>
		      <v3x:selectPeople id="wf" showAllAccount="true"
		            originalElements="${org}"
                    panels="Account,Department,Team,Post,Level,Outworker"
                    selectType="Member,Department,Account,Post,Level,Team"
                    departmentId="${v3x:currentUser().departmentId}"
                    jsFunction="setPeopleFields(elements)" />
		</c:if>
		<c:if test="${board.affiliateroomFlag == '1'}">
		  <script type="text/javascript">
                    <!--
                     includeElements_wf = "${v3x:parseElementsOfTypeAndId(ChildDeptissueArea)}";
                    //-->
                </script>
		</c:if>
		<c:choose>
            <c:when test="${custom}">
                <input type="hidden" name="bbstype_Name" id="bbstype_Name" value="4">
                <!-- 自定义团队板块预览取值-->
            </c:when>
			<c:when test="${DEPARTMENTAffiliateroomFlag}">
				<input type="hidden" name="bbstype_Name" id="bbstype_Name" value="1">
				<!-- 单位板块预览取值和部门区分 -->
			</c:when>
			<c:otherwise>
				<input type="hidden" name="bbstype_Name" id="bbstype_Name" value="">
				<!-- 单位板块预览取值和部门区分 -->
			</c:otherwise>
		</c:choose>
		<script type="text/javascript">
		if('18'=='${v3x:escapeJavascript(param.spaceType)}'||'17'=='${v3x:escapeJavascript(param.spaceType)}'||'4'=='${v3x:escapeJavascript(param.spaceType)}')
			showAllOuterDepartment_wf = false;
		else
			showAllOuterDepartment_wf = true;
		</script>
		
		<div class="h100b">
					<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page-list-border">
						<tr>
							<td colspan="6" height="22" valign="top">
							<script type="text/javascript">
					    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
					    	var insert = new WebFXMenu;
							insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
							insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' />", "insertCorrelationFile()"));//关联文档的入口
							if(v3x.getBrowserFlag("hideMenu") == true){
					    		myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, [1,6], "", insert));
					    	}
					    	<c:set value="javascript:history.back()" var="backEvent" />
					        <c:if test="${param.from == 'top'}">
					            <%--TODO yangwulin 2012-11-28 javascript:getA8Top().contentFrame.topFrame.back() --%>
					            <c:set value="javascript:getA8Top().back()" var="backEvent" />
					        </c:if>
					          myBar.add(new WebFXMenuButton("preview", "<fmt:message key='common.toolbar.preview.label' bundle='${v3xCommonI18N}'/>", "viewPage('${genericController}?ViewPage=bbs/data_Detail')", [7,3],"<fmt:message key='common.toolbar.preview.label' bundle='${v3xCommonI18N}'/>", null));
					    	//v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
					    	document.write(myBar);
					    	document.close();
				    		</script>
				    		<div class="hr_heng"></div>
							</td>
						</tr>
                        
						<tr class="bg-summary" height="45">
						<td rowspan="${DEPARTMENTAffiliateroomFlag ? '2' : '3'}" width="1%" nowrap="nowrap" ><a href="#" onclick="javaScript:issuePost();" id='sendder'  class="margin_lr_10 display_inline-block align_center new_btn"><fmt:message key="oper.publish"/></a></td>
							<td width="1%" height="29" class="bg-gray" noWrap="noWrap"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />:</td>
							<td width="27%"><fmt:message key="common.default.subject.value" var="defSubject" bundle="${v3xCommonI18N}" /> 
							<input name="articleName" type="text" id="articleName" class="input-250px" deaultValue="${defSubject}"
								inputName="<fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />"
								validate="isDeaultValue,isWord,notNull,maxLength" maxLength="85" maxSize="85"
								value="<c:out value="${defSubject}" escapeXml="true" default='${defSubject}' />"
								${v3x:outConditionExpression(readOnly, 'readonly', '')}
			            		onfocus="checkDefSubject(this, true)"
								onblur="checkDefSubject(this, false)">
							</td>
							<td width="10%" class="bg-gray"><fmt:message key="bbs.board.label" />:</td>
							<td width="27%">
							<c:set value="${v3x:currentUser().loginAccount}" var="loginAccountId" />
								<c:choose>
									<c:when test="${DEPARTMENTAffiliateroomFlag}">
										<c:choose>
											<c:when test="${!custom && deptSpaceModels!=null && deptSpaceModelsLength>1}">
												<input type="hidden" name="boardId" id="boardId" value="${board.id}">
												<select id="superior" name="superior" onchange="openAjax(this.value)"  class="input-250px">
                                                        <c:forEach items="${deptSpaceModels}" var="dept">
                                                            <option title="${v3x:toHTML(dept.spacename)}" value="${dept.entityId}" ${dept.entityId == board.id ? 'selected' : ''}>
                                                              ${v3x:getLimitLengthString(v3x:toHTML(v3x:showOrgEntitiesOfIds(dept.entityId, 'Department', pageContext)),50, '...')}
                                                            </option>
                                                        </c:forEach>
                                               </select>
											</c:when>
											<c:when test="${custom}">
												<input type="text" class="input-250px" id="boardName" name="boardName" value="${spaceName}" disabled>
												<input type="hidden" name="boardId" id="boardId" value="${board.id}">
												<input type="hidden" name="custom" id="custom" value="${custom}">
											</c:when>
											<c:otherwise>
												<input type="hidden" name="boardId" id="boardId" value="${board.id}">
												<input type="text" class="input-100per" id="boardName" name="boardName" value="${board.name}" disabled>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<select name="boardId" id="boardIdBlock" class="input-250px" onchange="changeBoard(this)">
											<c:forEach var="theBoard" items="${canIssueBoardList}">
												<option value="${theBoard.id}" ${param.boardId==theBoard.id? 'selected' : ''}>${v3x:toHTML(theBoard.name)}</option>
											<script type="text/javascript">
												boardAnonymousMap.put('${theBoard.id}','${theBoard.anonymousFlag}');
												boardAnonymousReplyMap.put('${theBoard.id}','${theBoard.anonymousReplyFlag}');
											</script>
											</c:forEach>
										</select>
									</c:otherwise>
								</c:choose>
							</td>
							<td width="28%" style="padding-left: 10px;">
							<label for="e">
								<input type="radio" name="resourceFlag" checked value="0" id="e"> 
								<fmt:message key="bbs.none.label" />
							</label> 
							<label for="b"> 
								<input type="radio" name="resourceFlag" value="1" id="b">
								<fmt:message key="bbs.yuan.label" />
							</label>
							<label for="c"> 
								<input type="radio" name="resourceFlag" value="2" id="c">
								<fmt:message key="bbs.zhuan.label" />
							</label>
							</td>
						</tr>
						<tr class="bg-summary">
							<td width="1%" height="24" class="bg-gray" noWrap="noWrap"><fmt:message key="bbs.boardmanager.column.issuearea.label" />:</td>
							<fmt:message key="common.default.issueScope.value" var="defScope" bundle="${v3xCommonI18N}" />
							<td nowrap="nowrap"><input type="hidden" id="issueArea"
								value="${DEPARTMENTissueArea}" name="issueArea"> <c:choose>
									<c:when test="${custom}">
										<input type="text" readonly="true" id="issueAreaName" name="issueAreaName" deaultValue="${defScope}" class="cursor-hand input-250px"
											value="<c:out value="${issueAreaName}" escapeXml="true" default="${defScope}" />"
											onclick="selectIssueArea()">
									</c:when>
									<c:otherwise>
										<input type="text" readonly="true" id="issueAreaName" class="cursor-hand input-250px"  deaultValue="${defScope}" value="<c:out value="${issueAreaName}" escapeXml="true" default="${defScope}" />"
											name="issueAreaName" onclick="selectIssueArea()">
									</c:otherwise>
								</c:choose></td>
							<td nowrap="nowrap" class="bg-gray"><fmt:message key="bbs.issue.poster.label" />:</td>
							<td nowrap="nowrap">
							<input type="text" name="issueUser" class="input-250px bbs-readonly" value="${v3x:currentUser().name}" readonly>
							</td>
							<td nowrap="nowrap" style="padding-left: 5px;">
							 <c:if test="${!DEPARTMENTAffiliateroomFlag}">
                                    <label for="d" id="anonymousDiv" style="display: ${ board.anonymousFlag == 0 ? '' : 'none'}">
                                        <input type="checkbox" name="anonymous" id="d"> <fmt:message key="anonymous.post" />&nbsp;&nbsp; </label>
                                    <label for="f" id="anonymousReplyDiv" style="display: ${ board.anonymousReplyFlag == 0 ? '' : 'none'}">
                                        <input type="checkbox" name="anonymousReply" id="f"> <fmt:message key="anonymous.reply" />&nbsp;&nbsp; </label>
                            </c:if> 
                            <%--
							<c:if test="${!DEPARTMENTAffiliateroomFlag && board.affiliateroomFlag != '1'}">
									<label for="d" id="anonymousDiv" style="display: ${ board.anonymousFlag == 0 ? '' : 'none'}">
										<input type="checkbox" name="anonymous" id="d"> <fmt:message key="anonymous.post" />&nbsp;&nbsp; </label>
									<label for="f" id="anonymousReplyDiv" style="display: ${ board.anonymousReplyFlag == 0 ? '' : 'none'}">
										<input type="checkbox" name="anonymousReply" id="f"> <fmt:message key="anonymous.reply" />&nbsp;&nbsp; </label>
							</c:if> 
							<c:if test="${board.affiliateroomFlag == '1'}">
							   <label for="d" id="anonymousDiv" style="display: ${ board.anonymousFlag == 0 ? '' : 'none'}">
                                        <input type="checkbox" name="anonymous" id="d"> <fmt:message key="anonymous.post" />&nbsp;&nbsp; </label>
                                    <label for="f" id="anonymousReplyDiv" style="display: ${ board.anonymousReplyFlag == 0 ? '' : 'none'}">
                                        <input type="checkbox" name="anonymousReply" id="f"> <fmt:message key="anonymous.reply" />&nbsp;&nbsp; </label>
							</c:if>
							 --%>
							<label for="a"> <input type="checkbox" name="messageNotifyFlag" id="a"> <fmt:message key="bbs.receive.message.label" /> </label>
							</td>
						</tr>
            
                        <tr class="bg-summary" style="${DEPARTMENTAffiliateroomFlag ? 'display:none;' : ''}">
                            <td width="1%" height="24" class="bg-gray" noWrap="nowrap"></td>
                            <td nowrap="nowrap" colspan="4">
                            <%--<label for="shareDajia">
                                <input type="checkbox" name="shareDajia" id="shareDajia" />
                                <span><fmt:message key="news.share.dajia" /></span>
                            </label> --%>
                            </td>
                        </tr>
                        
						<!-- 在此处添加关联文档 -->
				        <tr id="attachment2TR" class="bg-summary" style="display:none;">
                            <td colspan="2" valign="top"></td>
                            <td colspan="4" valign="top">
				            <div style="float: left"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</div>
				            <div>
				            <div class="div-float">(<span id="attachment2NumberDiv"></span>)</div>
				           <div></div><div id="attachment2Area" style="overflow: auto;"></div></div>
				         </tr>
				        <tr id="attachmentTR" class="bg-summary" style="display: none;">
                            <td colspan="2" valign="top"></td>
                            <td colspan="4" height="18" valign="top">
                            <div style="float: left"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />:</div>
                            <div><div class="div-float"> (<span id="attachmentNumberDiv"></span>) </div> 
                            <v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" />
                            </div>
                        </tr>
						<tr>
							<td colspan="6" height="6" class="bg-b"></td>
						</tr>
						<tr valign="top">
							<td id="ie6_ckeditor" colspan="6"><c:choose>
									<c:when
										test="${v3x:getBrowserFlagByUser('HtmlEditer', v3x:currentUser())==true}">
										<v3x:editor htmlId="content" type="HTML" barType="Bbs" category="<%=ApplicationCategoryEnum.bbs.getKey()%>" />
									</c:when>
									<c:otherwise>
										<textarea id="content" name="content" style="height: 100%; width: 100%"></textarea>
										<input type='hidden' name='bodyType' id='bodyType' value='HTML'>
										<input type="hidden" name="bodyCreateDate" id="bodyCreateDate" value="">
										<input id="contentNameId" type="hidden" name="contentName" value="">
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</table>
			</div>
	</form>
</body>
</html>
<script type="text/javascript">
    if (v3x.isMSIE6) {
        initIe10AutoScroll("ie6_ckeditor",120)
    };
    var flag = '${param.group}';
    if (flag == 'group' || flag == 'true') {
        showCtpLocation('F05_bbsIndexGroup');
    } else {
        showCtpLocation('F05_bbsIndexAccount');
    }
     if('18'=='${v3x:escapeJavascript(param.spaceType)}'||'17'=='${v3x:escapeJavascript(param.spaceType)}'||'space'=='${param.where}'){
        var theHtml=toHtml("${publicCustom ? spaceName : (param.group=='true'||param.group=='group' ? groupName : accountName)}",'<fmt:message key="application.9.label" bundle="${v3xCommonI18N}" />');
        showCtpLocation("",{html:theHtml});
    }
     if('1'=='${v3x:escapeJavascript(spaceType)}'||'1'=='${v3x:escapeJavascript(param.spaceType)}'){
         var theHtml=toHtml("${v3x:toHTML(boardName2)}",'<fmt:message key="bbs.issue.post.label"/>');
         showCtpLocation("",{html:theHtml});
     }
     if('${v3x:escapeJavascript(param.spaceType)}'=='4' || '${v3x:escapeJavascript(spaceType)}'=='4'){
 	    var theHtml=toHtml("${v3x:toHTML(spaceName)}",'<fmt:message key="bbs.latest.post.label"/>');
 	    showCtpLocation("",{html:theHtml});
 	}
     
     if(v3x.isFirefox || v3x.isChrome){
     	window.onbeforeunload = function(){
     		return "";
     	}
     }else{
     	window.onbeforeunload = function(){
   	   		window.event.returnValue = "";
   		}
     }
</script>