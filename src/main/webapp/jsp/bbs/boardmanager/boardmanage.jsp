<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<title></title>
<%@ include file="../header.jsp"%>
<%@ include file="../../apps/doc/pigeonholeHeader.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
<script type="text/javascript">
<!--
	if("${v3x:escapeJavascript(param.dept)}"=='dept'){
	    var theHtml=toHtml("${v3x:toHTML(board.name)}",'<fmt:message key="bbs.departmentBbsSection.label"/><fmt:message key="bbs.manager.label"/>');
        showCtpLocation("",{html:theHtml});
	}
	if("${v3x:escapeJavascript(param.custom)}"=='true'){
	  var theHtml=toHtml("${spaceName}",'<fmt:message key="bbs.latest.post.label"/><fmt:message key="bbs.manager.label"/>');
	  showCtpLocation("",{html:theHtml});
	}

	
	<c:if test="${param.group==null || param.group==''}">
		var onlyLoginAccount_authIssue = true;
		var onlyLoginAccount_authReply = true;
		//不选择个人组外单位人员
		hiddenOtherMemberOfTeam_authIssue = true;
		hiddenOtherMemberOfTeam_authReply = true;
	</c:if>
	<c:if test="${param.spaceType =='18'}">
	  var onlyLoginAccount_authIssue = false;
	  var onlyLoginAccount_authReply = false;
    </c:if>
	
	//授权   改为直接弹出选人界面   type 1代表授权发帖   2代表授权禁止回复
	function authIssueOrReply(type){
		if(type=='1'){
			selectPeopleFun_authIssue();
		}else{
			selectPeopleFun_authReply();
		}
	}
	
	//不受职务级别限制
	isNeedCheckLevelScope_authIssue = false;
	isNeedCheckLevelScope_authReply = false;
	var hiddenPostOfDepartment_authIssue=true;
	var hiddenPostOfDepartment_authReply=true;
	
	function setPeopleFields(elements,type){
		if(elements == null){
			return;
		}
		
		if(type=='1'){
			document.fm2.authIssueIds.value=getIdsString(elements, true);
			document.fm2.authType.value="1";
		}else{
			document.fm2.authReplyIds.value=getIdsString(elements, true);
			document.fm2.authType.value="2";
		}
	    var idsValue=getIdsString(elements, true);
		document.fm2.target = "hiddenIframe";
        document.fm2.action= "${detailURL}?method=authBoard&boardId=${board.id}";
        fm2.submit();
        if(idsValue!=''){
          alert(v3x.getMessage("BBSLang.bbs_boardmanage_boardAuth_success"));
        }
	}
	
	function articleDetail(articleId){
		var acturl = "${detailURL}?method=showPost&articleId="+articleId+"&resourceMethod=listArticleMain&group=${v3x:escapeJavascript(param.group)}";
		openWin(acturl);
	}
	
	//对部门空间进行处理
	function isDept(dept)
	{
		if(dept==="false")
		{
			alert(v3x.getMessage("BBSLang.bbs_board_no_pers"));
			//TODO yangwulin 2012-11-28 getA8Top().contentFrame.topFrame.back();
			getA8Top().back();
		}
	}
	var myPigeonholeItem = {};
	function myPigeonhole(appName, spaceType, appType){
		myPigeonholeItem.appName = appName;
		myPigeonholeItem.spaceType = spaceType;
		myPigeonholeItem.appType = appType;
		var theForm = document.getElementsByName("listForm")[0];
	    if (!theForm) {
	        return false;
	    }
		
		var ids=getSelectIds();
		var result = "";
		if(ids==''){
			alert(v3x.getMessage("bulletin.please_select_record"));
			return;
		}
		var atts = getSelectAtts();
		myPigeonholeItem.ids = ids;
		pigeonhole(appName,ids, atts,"","","myPigeonholeBbsCollBack");
		
	}
	
	function myPigeonholeBbsCollBack (result) {
		if(result=='failure'){
			alert(v3x.getMessage("bulletin.pigeonhole_failure"));
			return;
		}else if(result=='cancel'){
			return;
		}else{
			var theForm = document.getElementsByName("listForm")[0];
			var _archiveIds = result.split(",");
			for (var i=0; i<_archiveIds.length; i++){
		    	var archiveId = _archiveIds[i];
		    	var element = document.createElement("input");
		    	element.type = "hidden";
		    	element.name = "archiveId";
		    	element.value = archiveId;
			    theForm.appendChild(element);
	    	}
			theForm.action = detailURL+"?method=pigeonhole"+'&id='+myPigeonholeItem.ids + "&spaceType=" + myPigeonholeItem.spaceType + "&type=" + myPigeonholeItem.appType;
			theForm.method = "post";
		    theForm.target = "hiddenIframe";
			theForm.submit();
		}
	}
//-->
</script>
</head>
<body class="padding5" scroll='no' onload="isDept('${isSpaceManager}')">

<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
    <c:set value="${v3x:parseElements(board.issuerList, 'id', 'entityType')}" var="authIssueId"/>
	<c:set value="${v3x:parseElements(board.canNotReplyList, 'id', 'entityType')}" var="authReplyId"/>
	<script type="text/javascript">
     <!--
     var ctxResources = <c:out value="${CurrentUser.resourceJsonStr}" default="null" escapeXml="false"/>;
     var includeElements_authIssue = "${v3x:parseElementsOfTypeAndId(entity)}";
     var includeElements_authReply = "${v3x:parseElementsOfTypeAndId(entity)}";
     //-->
     </script>
	<v3x:selectPeople id="authIssue" panels="${param.group eq 'group' ?  'Account,' : ''}Department,Post,Level,Team${param.group eq 'group' ?  '' : ',Outworker'}" selectType="Member,Account,Department,Level,Team,Post" departmentId="${v3x:currentUser().departmentId}" showMe="false" jsFunction="setPeopleFields(elements,1)" minSize="0" originalElements="${authIssueId}"/>
	<v3x:selectPeople id="authReply" panels="Department,Post,Level,Team,Outworker" selectType="Member,Account,Department,Level,Team,Post" departmentId="${v3x:currentUser().departmentId}" showMe="false" jsFunction="setPeopleFields(elements,2)" minSize="0" originalElements="${authReplyId}"/>
	<script type="text/javascript">
	<!--
	showAllOuterDepartment_authIssue=true;
	showAllOuterDepartment_authReply=true;
	
	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
	var top1 = new WebFXMenu;
	top1.add(new WebFXMenuItem("", "<fmt:message key='bbs.set.label' /><fmt:message key='bbs.top.label' />", "setArticle('1', '${board.id}', '${v3x:escapeJavascript(param.dept)}', '${v3x:escapeJavascript(param.group)}')"));
	top1.add(new WebFXMenuItem("", "<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/><fmt:message key='bbs.top.label' />", "setArticle('2', '${board.id}', '${v3x:escapeJavascript(param.dept)}', '${v3x:escapeJavascript(param.group)}')"));
	
	var elite = new WebFXMenu;
	elite.add(new WebFXMenuItem("", "<fmt:message key='bbs.set.label' /><fmt:message key='bbs.elite.label' />", "setArticle('3', '${board.id}', '${v3x:escapeJavascript(param.dept)}', '${v3x:escapeJavascript(param.group)}')"));
	elite.add(new WebFXMenuItem("","<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/><fmt:message key='bbs.elite.label' />", "setArticle('4', '${board.id}', '${v3x:escapeJavascript(param.dept)}', '${v3x:escapeJavascript(param.group)}')"));
	
	myBar.add(new WebFXMenuButton("top1", "<fmt:message key='common.toolbar.oper.top.label' bundle='${v3xCommonI18N}'/>", null, [5,8], "", top1));
	myBar.add(new WebFXMenuButton("elite", "<fmt:message key='common.toolbar.elite.label' bundle='${v3xCommonI18N}'/>", null, [7,1], "", elite));
	myBar.add(new WebFXMenuButton("Delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "delArticle('${board.id}', '${v3x:escapeJavascript(param.dept)}', '${v3x:escapeJavascript(param.group)}')", [1,3], "", null));
	<c:if test="${v3x:hasPlugin('doc')}">
		myBar.add(
			new WebFXMenuButton(
				"newBtn", 
				"<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />", 
				"myPigeonhole('<%=com.seeyon.v3x.common.constants.ApplicationCategoryEnum.bbs.key()%>', '${v3x:escapeJavascript(param.spaceType)}', '${board.id}');", 
				[1,9], 
				"", 
				null
				)
		);
	</c:if>
	
	var boardManage = new WebFXMenu;	
	<c:if test="${param.dept==null || param.dept==''}">
    	boardManage.add(new WebFXMenuItem("", "<fmt:message key='bbs.auth.issue.label'/>", "authIssueOrReply(1)"));
    	boardManage.add(new WebFXMenuItem("", "<fmt:message key='bbs.auth.reply.label'/>", "authIssueOrReply(2)"));
	</c:if>
	boardManage.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.statistics.label' bundle='${v3xCommonI18N}' />", "viewStatistics('${newsURL}?method=publishInfoStc&mode=bbs&group=${v3x:escapeJavascript(param.group)}&deptId=${v3x:escapeJavascript(param.dept)}&typeId=${board.id}');"));
	myBar.add(new WebFXMenuButton("boardManage", "<fmt:message key='common.toolbar.boardmanage.label' bundle='${v3xCommonI18N}' />", null, [12,9], "", boardManage));
	
	<c:choose>		
		<c:when test="${param.dept eq 'dept'}">
			<c:if test="${fn:length(deptSpaceModels)>1}">
		    	var oDepartment = new WebFXMenu;
				<c:forEach items="${deptSpaceModels}" var="deptSpace" varStatus="index">
				    <c:if test="${deptSpace.entityId != board.id}">
					oDepartment.add(new WebFXMenuItem("deptSpace${index}", "${v3x:toHTML(v3x:getLimitLengthString(deptSpace.spacename, 15,'...'))}", "changeDepartment('${deptSpace.entityId}');", "", "${v3x:toHTML(deptSpace.spacename)}"));
				    </c:if>
			    </c:forEach>
				myBar.add(new WebFXMenuButton("chanegDepartment", "<fmt:message key='common.toolbar.board.switch.label' bundle='${v3xCommonI18N}'/>", "", [9,6],"", oDepartment));
		    </c:if>
	    </c:when>
	    <c:otherwise>
	    	<c:if test="${fn:length(v3xBbsBoardManageList)>0}">
		    	var sendToSubItems = new WebFXMenu;
		    	var sendToType1 ="";
				<c:forEach items="${v3xBbsBoardManageList}" var="bbsBoard" varStatus="index">
					sendToSubItems.add(new WebFXMenuItem("bti${index}", "${v3x:escapeJavascript(v3x:getLimitLengthString(bbsBoard.name, 15,'...'))}", "changeType('${bbsBoard.id}', '${v3x:escapeJavascript(param.group)}', '${v3x:escapeJavascript(param.dept)}');", "", "${v3x:escapeJavascript(bbsBoard.name)}"));
					sendToType1=sendToType1+"${bbsBoard.id}"+",";
				</c:forEach>
				myBar.add(new WebFXMenuButton("sendto", "<fmt:message key='common.toolbar.board.switch.label' bundle='${v3xCommonI18N}'/>", "", [9,6],"", sendToSubItems));
				myBar.add(new WebFXMenuButton("moveBtn", "<fmt:message key='bbs.menu.move.label'/>","moveTo(sendToType1);",[2,1], "", null));
		    </c:if>
	    </c:otherwise>
	</c:choose>
	//-->
</script>
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="22" valign="top" class="webfx-menu-bar">
			    <script type="text/javascript">
			    	//v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
			    	document.write(myBar);
			    </script>
			</td>
			<td class="webfx-menu-bar page2-list-header" height="22">
				<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
				<input type="hidden" value="<c:out value='${param.method}' />" name="method">
				<input type="hidden" value="${board.id}" name="boardId">
				<input type="hidden" name="dept" value="${v3x:toHTML(param.dept)}" />
				<input type="hidden" name="group" value="${v3x:toHTML(param.group)}" />
				<input type="hidden" name="custom" value="${custom}">
				<input type="hidden" id="spaceId" name="spaceId" value="${param.spaceId}"/>
				<input type="hidden" id="spaceType" name="spaceType" value="${v3x:toHTML(param.spaceType)}"/>
					<div class="div-float-right">
					<div class="div-float">
					<select name="condition"  id="condition" onChange="showNextCondition(this)" class="condition">
						<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
						<option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
						<option value="issueUser"><fmt:message key="bbs.issue.poster.label"/></option>
						<option value="issueTime"><fmt:message key="bbs.date.create"/></option>
					</select></div>
					<div id="subjectDiv" class="div-float hidden"><input type="text" maxlength="50" onkeydown="javascript:searchWithKey()" name="textfield" class="textfield"></div>
					<div id="issueUserDiv" class="div-float hidden"><input type="text"  maxlength="50" onkeydown="javascript:searchWithKey()" name="textfield" class="textfield"></div>
					<div id="issueTimeDiv" class="div-float hidden"><input type="text" name="textfield" class="input-date" id="startdate"
						onclick="whenstart('${pageContext.request.contextPath}',this,640,265);"
						readonly> - <input type="text" name="textfield1" id="enddate"
						class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,720,265);" readonly></div>
					<div onclick="javascript:doMySearch()" class="div-float condition-search-button"></div>
					</div>
				</form>
			</td>
		</tr>
	</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
      <form name="listForm" method="post" action="" onsubmit="">
			<v3x:table data="${list}" var="con" htmlId="pending" isChangeTRColor="true" showHeader="true" >
				<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>" >
					<input type='checkbox' name='id' value="${con.id}" />
					<input type="hidden" name="topSequence" value="${con.topSequence}"/>
				</v3x:column>
				
				<v3x:column width="35%" label="common.subject.label" hasAttachments="${con.attachmentFlag}" type="String"
				 alt="${con.articleName}" onClick="javascript:articleDetail('${con.id}')" className="sort cursor-hand">
					<c:set value="50" var="nameLength" />
					<c:if test="${con.topSequence==1}">
						<font color="red">[<fmt:message key="bbs.top.label" />]</font>
						<c:set value="${nameLength - 4}" var="nameLength" />
					</c:if>
					<input type="hidden" id="topName_${con.id}" value="${con.articleName}"/>
					${v3x:toHTML(v3x:getLimitLengthString(con.articleName, nameLength, "..."))}
					<c:if test="${con.eliteFlag}">
						<font color="red">[<fmt:message key="bbs.elite.label" />]</font>
					</c:if>
				</v3x:column>
				
				<c:set value="${v3x:currentUser().id}" var="currentUserId" />
				<c:choose>
					<c:when test="${con.anonymousFlag && currentUserId!=con.issueUser}">
						<fmt:message key="anonymous.label" var="createrUser"/>
					</c:when>
					<c:otherwise>
						<c:set value="${v3x:showMemberName(con.issueUser)}" var="mName"/>
						<c:set value="${v3x:getLimitLengthString(mName,16,'...')}" var="createrUser"/>
					</c:otherwise>
				</c:choose>
			
				<v3x:column width="15%" type="String" label="bbs.issue.poster.label" value="${createrUser}"/>
				<v3x:column width="15%" type="Date" align="left" label="bbs.date.create" >
					<fmt:formatDate value="${con.issueTime}" pattern="${dataPattern}" />
				</v3x:column>
				<v3x:column width="15%" type="Number" label="bbs.clicknumber.label" value="${con.clickNumber}" align="center" />
				
				<v3x:column width="15%" type="Number" label="bbs.replynumber.label" value="${con.replyNumber}" align="center" />
			</v3x:table>
		</form>
    </div>
  </div>
</div>

<input type="hidden" id="_custom" name="_custom" value="${custom}">
<script type="text/javascript">
<!--
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
//-->
</script>
<form name="fm2" method="post" action="" onsubmit="">
	<input type="hidden" name="topNum" value="${board.topNumber}">
	<input type="hidden" name="authIssueIds" value="${authIssueId}">
	<input type="hidden" name="authReplyIds" value="${authReplyId}">
	<input type="hidden" name="authType" value="">
</form>
<iframe src="javascript:void(0)" name="hiddenIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>