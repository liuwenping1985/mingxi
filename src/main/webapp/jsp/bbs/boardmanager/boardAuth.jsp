<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title></title>
<script type="text/javascript">
	var onlyLoginAccount_bbsinqu = true;
	
	function ok(){
		var theForm = document.getElementsByName("fm")[0];
			if (!theForm) {
		        return;
		    }
			theForm.action = "${detailURL}?method=authBoard";
		 	theForm.submit();	
	}

	var hasIssueArea = false;
	
	function selectBoardUser(){
		selectPeopleFun_wf();
	}

	function setPeopleFields(elements){
		if(elements == null){
			return;
		}
		document.fm.authInfo.value=getIdsString(elements, false);
		document.fm.authInfoName.value=getNamesString(elements);
		document.fm.authInfoName.title=getNamesString(elements);	
	}
	
	function checkSelectWF() {
    if (!hasIssueArea) {
        alert(v3x.getMessage("BBSLang.bbs_boardmanage_boardAuth_accredit"));
        selectPeopleFun_wf();
        return false;
    }
    return true;
	}
	
	function doSubmit(){
		var theForm = document.getElementsByName("fm")[0];
		if (!theForm) {
	        return;
	    }
		theForm.action = "${detailURL}?method=authBoard";
	    theForm.submit();
	}
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<form name="fm" method="post" action="">
<input name="boardId" type="hidden" value="${param.boardId}"/> 
<input name="authType" type="hidden" value="${param.authType}"/>
<c:set value="${v3x:joinDirectWithSpecialSeparator(members, ',')}" var="authId"/>
<c:set value="${v3x:showOrgEntitiesOfIds(authId, 'Member', pageContext)}" var="authName"/>

<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td height="20" class="PopupTitle">
			<c:if test="${param.authType == 1}">
				<fmt:message key="bbs.auth.issue.label"/>
			</c:if>
			<c:if test="${param.authType == 2}">
				<fmt:message key="bbs.auth.reply.label"/>
			</c:if>
		</td>
	</tr>
	<fmt:message key='common.default.selectPeople.value' bundle='${v3xCommonI18N}' var="dSP"/>
	<tr >
		<td class="bg-advance-middel"><fmt:message key="bbs.scope.label"/>
			<input type="hidden" name="authInfo" value="${authId}"> 
			<input type="text" readonly="true"  class="input-100per cursor-hand" value="<c:out value='${authName}' default='${dSP}' />" name="authInfoName" onclick="selectPeopleFun_bbsinqu()" >
		 	<v3x:selectPeople id="bbsinqu" panels="Department,Team,Outworker" selectType="Member" departmentId="${v3x:currentUser().departmentId}" showMe="false" jsFunction="setPeopleFields(elements)" minSize="0" originalElements="${v3x:parseElementsOfIds(authId, 'Member')}"/>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom" colspan="2">
			<input type="button" onclick="ok()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
			<input type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
</body>
</html>
