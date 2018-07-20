<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<c:set var="isGroup" value="${v3x:currentUser().groupAdmin}" />
<script type="text/javascript">
	var hasIssueArea = false;

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
		theForm.action = "${detailURL}?method=createBoard&spaceType=${param.spaceType}&spaceId=${param.spaceId}";
		if (checkForm(theForm) && checkSelectWF()) {
		   var nameList = new Array();
		    //初始化讨论类型名称列表
		   <c:forEach var="tname" items="${nameList}">
		         nameList.push("${v3x:escapeJavascript(tname)}");
		   </c:forEach>
		      var boardName = document.fm.name.value.trim();
		      for(var i=0;i<nameList.length;i++){
		         if(boardName==nameList[i].trim()){
		          alert(v3x.getMessage("BBSLang.bbs_bbsmanage_createboard_sameness"));
		          document.fm.name.value = document.fm.name.value.trim();
		          document.fm.name.focus();
		          return false;
		        }
		      }

            document.getElementById("b1").disabled = true;
            document.getElementById("b2").disabled = true;
            
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
<script type="text/javascript">
<!--
var includeElements_wf = "${v3x:parseElementsOfTypeAndId(entity)}";
//-->
</script>
<v3x:selectPeople id="wf" panels="Department,Post,Level,Team" selectType="Member" jsFunction="setPeopleFields(elements)" maxSize="50" />
</head>
<body scroll="no" style="overflow: no; text-align:center">
<form name="fm" method="post" action="" onsubmit="return checkForm(this)">

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
    <tr>
        <td  valign="top">
           
            <div id="cenner" style="overflow: auto;">

            <table border="0" cellpadding="0" cellspacing="0" height="100%" align="center">
                <tr>
                    <td class="bg-gray , bbs-tb-padding-topAndBottom" width="25%" nowrap>
                        <font color="red">*</font>&nbsp;<fmt:message key="bul.type.typeName" bundle="${bulI18N}" />:
                    </td>       
                    <td class="new-column , bbs-tb-padding-topAndBottom" width="75%" colspan="3">
                        <fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
                        <input name="name" type="text" id="name" class="input-100per" deaultValue="${defName}"
                           inputName="<fmt:message key='common.name.label' bundle='${v3xCommonI18N}' />" validate="isDeaultValue,notNull,maxLength" maxSize="15"
                            value="${defName}"
                            ${v3x:outConditionExpression(readOnly, 'readonly', '')}
                           onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)">
                    </td>
                </tr>

                <tr>
                    <td class="bg-gray , bbs-tb-padding-topAndBottom" nowrap>
                        <font color="red">*</font>&nbsp;<fmt:message key="bbs.admin.label"/>:
                    </td>
                    <td class="new-column , bbs-tb-padding-topAndBottom" colspan="3" nowrap>
                        <fmt:message key="common.default.selectPeople.value" var="defaultSP" bundle="${v3xCommonI18N}"/>
                        
                        <input type="hidden" value="" name="bbsBoardAdmin"> 
                        <input type="text" name='bbsBoardAdminName' 
                            value="${defaultSP}" 
                            readonly class="cursor-hand input-100per" onclick="selectBoardAdmin()" 
                            deaultValue="${defaultSP}">
                    </td>
                </tr>
                <tr>
                    <td class="bg-gray , bbs-tb-padding-topAndBottom" width="25%" nowrap>
                    <fmt:message key="bbs.sort" />:
                    </td>
                    <td class="new-column , bbs-tb-padding-topAndBottom" nowrap>
                            <select  name="orderFlag"  class="condition" style="height: 23; width: 80">
                        <option  value="0" ><fmt:message key="bbs.sort.asc" /></option>
                        <option  value="1" ><fmt:message key="bbs.sort.desc"/></option>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class="bg-gray , bbs-tb-padding-topAndBottom" nowrap>
                        <fmt:message key="bbs.allow.anonymous.label" />:
                    </td>
                    <td class="new-column , bbs-tb-padding-topAndBottom" nowrap>
                        <label for="anonymous_true">
                            <input type="radio" name="anonymousFlag" value="0" id="anonymous_true"  checked/><fmt:message key="common.yes" bundle="${v3xCommonI18N}" />
                        </label>
                        <label for="anonymous_false">
                            <input type="radio" name="anonymousFlag" value="1" id="anonymous_false"  ><fmt:message key="common.no" bundle="${v3xCommonI18N}" />
                        </label>
                    </td>
                </tr>
                
                <tr>
                    <td class="bg-gray , bbs-tb-padding-topAndBottom" nowrap>
                        <fmt:message key="bbs.allow.anonymous.reply.label" />:
                    </td>
                    <td class="new-column , bbs-tb-padding-topAndBottom" nowrap>
                        <label for="a">
                            <input type="radio" name="anonymousReplyFlag" value="0" id="a"  checked/><fmt:message key="common.yes" bundle="${v3xCommonI18N}" />
                        </label>
                        <label for="b">
                            <input type="radio" name="anonymousReplyFlag" value="1" id="b" ><fmt:message key="common.no" bundle="${v3xCommonI18N}" />
                        </label>
                    </td>
                </tr>
                
                <tr>
                    <td class="bg-gray , bbs-tb-padding-topAndBottom" nowrap>
                        <fmt:message key="bbs.topnumber.label" />:
                    </td>
                    <td class="new-column , bbs-tb-padding-topAndBottom" nowrap>
                        <select name="topNumber" class="condition" style="height: 23; width: 80">
                            <option value="0"><fmt:message key="bbs.createboard.common.name.zero" /></option>
                            <option value="1"><fmt:message key="bbs.createboard.common.name.one"/></option>
                            <option value="2"><fmt:message key="bbs.createboard.common.name.two" /></option>
                            <option value="3" selected><fmt:message key="bbs.createboard.common.name.three" /></option>
                            <option value="4"><fmt:message key="bbs.createboard.common.name.four" /></option>
                            <option value="5"><fmt:message key="bbs.createboard.common.name.five"  /></option>
                        </select>
                    </td>
                </tr>
                
                <tr>
                    <td valign="top" class="bg-gray , bbs-tb-padding-topAndBottom" nowrap>
                        <fmt:message key="common.description.label"  bundle="${v3xCommonI18N}" />:
                    </td>
                    <td class="new-column , bbs-tb-padding-topAndBottom " colspan="3">
                        <textarea id="description" name="description" class="input-100per" rows="5" inputName="<fmt:message key='common.description.label'  bundle="${v3xCommonI18N}" />" validate="maxLength" maxSize="120"></textarea>
                    </td>
                </tr>
            </table>

            </div>
           
           
        </td>
    </tr>
    <tr>
        <td class="bg-advance-bottom" align="center">
                
            <input type="button" id="b1" onclick="submitForm()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
            <input type="button" id="b2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2" onclick="parent.parent.document.location.reload();">

        </td>
    </tr>
</table>


<script type="text/javascript">
bindOnresize('cenner', 0, 50);
</script>
</form>
</body>
</html>