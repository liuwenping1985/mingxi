<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title></title>
<c:set var="isGroup" value="${v3x:currentUser().groupAdmin}" />
<script type="text/javascript">
	//是否选择管理员判断，修改页面肯定有管理员，而且不能取消人员 ，现在由false改true,解决点击修改后，不做人员变动会谈提示。
	var hasIssueArea = true;
	
	function selectBoardAdmin(){
		selectPeopleFun_wf();
	}

	function setPeopleFields(elements){
		if(!elements){
			return;
		}
		document.fm.bbsBoardAdmin.value=getIdsString(elements, false);
		document.fm.bbsBoardAdminName.value=getNamesString(elements);
		hasIssueArea = true;
	}
	
	function submitForm(){
		var theForm = document.getElementsByName("fm")[0];
		if (!theForm) {
        	return;
    	}
    	if(document.getElementById("bbsBoardAdminName").value=='' || document.getElementById("bbsBoardAdminName").value=='<fmt:message key="common.default.selectPeople.value" bundle="${v3xCommonI18N}"/>') {
    		alert(v3x.getMessage("BBSLang.bbs_bbsmanage_createboard_choice"));
    		return;
    	}
		theForm.action = "${detailURL}?method=modifyBoard&spaceType=${param.spaceType}&spaceId=${param.spaceId}";
		if (checkForm(theForm) && checkSelectWF()) {
		  var nameList = new Array();
	    	//初始化讨论类型名称列表
	      <c:forEach var="tname" items="${nameList}">
	            nameList.push("${v3x:escapeJavascript(tname)}");
	      </c:forEach>
	         var boardName = document.fm.name.value.trim();
	         for(var i=0;i<nameList.length;i++){
	            if(boardName==nameList[i].trim()&&boardName!='${bbsBoard.name}'){
	             alert(v3x.getMessage("BBSLang.bbs_bbsmanage_createboard_sameness"));
	             document.fm.name.value = document.fm.name.value.trim();
	             document.fm.name.focus();
	             return false;
	           }
	         }
	       theForm.submit();
   	 	}
	}
	
	function checkSelectWF() {
	    if (!hasIssueArea) {
	        alert(v3x.getMessage("BBSLang.bbs_bbsmanage_createboard_choice"));
	        selectPeopleFun_wf();
	        return false;
	    }
	    return true;
	}
	
  <c:if test="${!isGroup&&spaceType!=18&&spaceType!=17}">
   var onlyLoginAccount_wf = true;
  </c:if>
</script>
</head>
<body scroll="no" style="overflow: no">
<form name="fm" method="post" action="" onsubmit="return checkForm(this)">
<input name="id" type="hidden" value="${bbsBoard.id}">
<c:set var="readOnly" value="${param.isDetail eq 'readOnly'}" />
<c:set var="dis" value="${v3x:outConditionExpression(readOnly, 'disabled', '')}" />
<c:set value="${v3x:joinDirectWithSpecialSeparator(bbsBoard.admins, ',')}" var="adminId"/>
<c:set value="${v3x:showOrgEntitiesOfIds(adminId, 'Member', pageContext)}" var="adminName"/>

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
    <tr>
        <td>
           
            <div id="connect" class="scrollList">

                <table width="500" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
                        <td class="bg-gray , bbs-tb-padding-topAndBottom" width="25%" nowrap>
                            <font color="red">*</font>&nbsp;<fmt:message key="bul.type.typeName" bundle="${bulI18N}" />:
                        </td>                   
                        <td class="new-column , bbs-tb-padding-topAndBottom" width="75%">
                            <fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
                            <input name="name" type="text" id="name" class="input-100per" deaultValue="${defName}" ${dis}
                               inputName="<fmt:message key='common.name.label' bundle='${v3xCommonI18N}' />" validate="isDeaultValue,notNull,maxLength" maxSize="15"
                               value="<c:out value="${bbsBoard.name}" escapeXml="true" default='${defName}' />"
                               onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)">
                        </td>
                    </tr>
                    <tr>
                        <td class="bg-gray , bbs-tb-padding-topAndBottom" nowrap>
                            <font color="red">*</font>&nbsp;<fmt:message key="bbs.admin.label" />:
                        </td>
                        <td class="new-column , bbs-tb-padding-topAndBottom" nowrap ${dis}>
                        <script type="text/javascript">
                            <!--
                            var includeElements_wf = "${v3x:parseElementsOfTypeAndId(entity)}";
                            //-->
                            </script>
                             <v3x:selectPeople id="wf" panels="Department,Post,Level,Team" selectType="Member"
                                jsFunction="setPeopleFields(elements)" maxSize="50" originalElements="${v3x:parseElementsOfIds(adminId, 'Member')}"/>
                            <fmt:message key="common.default.selectPeople.value" var="defaultSP" bundle="${v3xCommonI18N}"/>
                            <input type="hidden" value="${adminId}" name="bbsBoardAdmin" > 
                            <input type="text" name='bbsBoardAdminName' id='bbsBoardAdminName' value="<c:out value='${adminName}' default='${defaultSP}' escapeXml='true' />"  
                                readonly class="cursor-hand input-100per" onclick="selectBoardAdmin()" deaultValue="${defaultSP}" ${dis} >
                        </td>
                    </tr>
                    <tr>
                        <td class="bg-gray , bbs-tb-padding-topAndBottom" nowrap>
                        <fmt:message key="bbs.sort" />:
                        </td>
                        <td class="new-column , bbs-tb-padding-topAndBottom" nowrap ${dis}>
                                <select  name="orderFlag"  class="condition" style="height: 23; width: 80" ${dis}>
                            <option  value="0" 
                                <c:if test="${bbsBoard.orderFlag==0}">selected</c:if>><fmt:message key="bbs.sort.asc" /></option>
                            <option  value="1" 
                                <c:if test="${bbsBoard.orderFlag==1}">selected</c:if>><fmt:message key="bbs.sort.desc"/></option>
                          </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="bg-gray , bbs-tb-padding-topAndBottom" nowrap>
                            <fmt:message key="bbs.allow.anonymous.label" />:
                        </td>
                        <td class="new-column , bbs-tb-padding-topAndBottom" nowrap ${dis}>
                            <label for="anonymous_true">
                                <input type="radio"  id="anonymous_true" name="anonymousFlag" value="0" 
                                    <c:if test="${bbsBoard.anonymousFlag==0}">checked</c:if> /><fmt:message key="common.yes" bundle="${v3xCommonI18N}" />
                            </label>
                            <label for="anonymous_false">
                                <input type="radio" name="anonymousFlag"  id="anonymous_false" value="1" 
                                    <c:if test="${bbsBoard.anonymousFlag==1}">checked</c:if> /><fmt:message key="common.no" bundle="${v3xCommonI18N}" />
                            </label>
                         </td>
                    </tr>
                    <tr>
                        <td class="bg-gray , bbs-tb-padding-topAndBottom" nowrap>
                            <fmt:message key="bbs.allow.anonymous.reply.label" />:
                        </td>
                        <td class="new-column , bbs-tb-padding-topAndBottom" nowrap ${dis}>
                            <label for="a">
                                <input type="radio"  id="a" name="anonymousReplyFlag" value="0" 
                                    <c:if test="${bbsBoard.anonymousReplyFlag==0}">checked</c:if> /><fmt:message key="common.yes" bundle="${v3xCommonI18N}" />
                            </label>
                            <label for="b">
                                <input type="radio" name="anonymousReplyFlag"  id="b" value="1" 
                                    <c:if test="${bbsBoard.anonymousReplyFlag==1}">checked</c:if> /><fmt:message key="common.no" bundle="${v3xCommonI18N}" />
                            </label>
                         </td>
                    </tr>
                    <tr>
                        <td class="bg-gray , bbs-tb-padding-topAndBottom" nowrap>
                            <fmt:message key="bbs.topnumber.label" />:
                        </td>
                        <td class="new-column , bbs-tb-padding-topAndBottom" nowrap ${dis}>
                            <select name="topNumber" class="condition" style="height: 23; width: 80" ${dis}>
                            <option value="0"
                                <c:if test="${bbsBoard.topNumber==0}">selected</c:if>><fmt:message key="bbs.createboard.common.name.zero"/></option>
                            <option value="1"
                                <c:if test="${bbsBoard.topNumber==1}">selected</c:if>><fmt:message key="bbs.createboard.common.name.one" /></option>
                            <option value="2"
                                <c:if test="${bbsBoard.topNumber==2}">selected</c:if>><fmt:message key="bbs.createboard.common.name.two"/></option>
                            <option value="3"
                                <c:if test="${bbsBoard.topNumber==3}">selected</c:if>><fmt:message key="bbs.createboard.common.name.three"/></option>
                            <option value="4"
                                <c:if test="${bbsBoard.topNumber==4}">selected</c:if>><fmt:message key="bbs.createboard.common.name.four"/></option>
                            <option value="5"
                                <c:if test="${bbsBoard.topNumber==5}">selected</c:if>><fmt:message key="bbs.createboard.common.name.five"/></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="bg-gray , bbs-tb-padding-topAndBottom" nowrap valign="top">
                            <fmt:message key="common.description.label"  bundle="${v3xCommonI18N}" />:
                        </td>
                        <td class="new-column , bbs-tb-padding-topAndBottom">
                            <textarea id="description" name="description"  ${dis} style="width: 400px;" cols="60" rows="5" inputName="<fmt:message key='common.description.label'  bundle="${v3xCommonI18N}" />" validate="maxLength" maxSize="120"><c:out value="${bbsBoard.description}" escapeXml="true"/></textarea>
                        </td>
                    </tr>
                </table>

            </div>
           
           
        </td>
    </tr>
    <c:if test="${!readOnly}">
    <tr>
        <td class="bg-advance-bottom" align="center">
                
			<input type="button" onclick="submitForm()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
			<input type="button" onclick="parent.parent.document.location.reload();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">

        </td>
    </tr>
    </c:if>
</table>


<script type="text/javascript">
	var isread = ${readOnly};
	if(isread){
		document.getElementById('connect').style.height = "240px";
	}
	bindOnresize('connect',0, 50)
</script>
</form>
</body>