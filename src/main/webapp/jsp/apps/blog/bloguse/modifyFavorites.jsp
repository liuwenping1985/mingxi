<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="org.apache.commons.lang.StringUtils"%>

<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>

<title></title>
<script type="text/javascript">
	function selectFamilyAdmin(){
		selectPeopleFun_wf();
	}

	function setPeopleFields(elements){
		if(!elements){
			return;
		}
		document.fm.blogFamilyAdmin.value=getIdsString(elements);
		document.fm.blogFamilyAdminName.value=getNamesString(elements);	
	}
	
	function submitForm(){
	
		var theForm = document.getElementsByName("fm")[0];
		if (!theForm) {
        	return;
    	}
    	
		theForm.action = "${detailURL}?method=modifyFavorites";
	
		if (checkForm(theForm)) {
			var name = document.getElementById("nameFamily").value;
			var ds = validFamilyName(name, "${blogFamily.id}", "${sessionScope['com.seeyon.current_user'].id}")
			if(ds == "false"){				
				alert(v3x.getMessage("BlogLang.blog_family_samename"));
				document.fm.nameFamily.focus();
				return false;
			}else
        		theForm.submit();
   	 	}
	}
	
</script>

</head>
<body scroll="no" style="overflow: no">
<form name="fm" method="post" action="" onsubmit="return checkForm(this)">
<input name="id" type="hidden" value=${blogFamily.id}>
<input name="type" type="hidden" value=${blogFamily.type}>
<input name="articleNumber" type="hidden" value=${blogFamily.articleNumber}>
<input name="employeeId" type="hidden" value=${blogFamily.employeeId}>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<c:if test="${param.viewFlag == 'false'}">
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="blog.family.label.edit" /></td>
					</c:if>
					<c:if test="${param.viewFlag != 'false'}">
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="blog.family.label" /></td>
					</c:if>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<div id="categorySet-body">
				<table width="500" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td class="bg-gray , blog-tb-padding-topAndBottom" width="25%" nowrap>
							<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />:
						</td>					
						<td class="new-column , blog-tb-padding-topAndBottom" width="75%">
							<fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
					        <input name="nameFamily" type="text" id="nameFamily" class="input-100per" deaultValue="${defName}"
				               inputName="<fmt:message key='common.name.label' bundle='${v3xCommonI18N}' />" validate="isDeaultValue,notNull" maxSize="16"
				                value="<c:out value="${blogFamily.nameFamily}" escapeXml="true" default='${defName}' />" 
				                ${v3x:outConditionExpression(param.viewFlag =='true', 'disabled', '')}
				                >
					    </td>
					</tr>
					
					<tr>
						<td class="bg-gray , blog-tb-padding-topAndBottom" nowrap valign="top">
							<fmt:message key="common.description.label"  bundle="${v3xCommonI18N}" />:
						</td>
						<td class="new-column , blog-tb-padding-topAndBottom">
							<textarea id="remark" name="remark" class="input-100per"
							rows="5" maxSize="100" validate="maxLength" inputName="<fmt:message key="common.description.label"  bundle="${v3xCommonI18N}" />"
							${v3x:outConditionExpression(param.viewFlag =='true', 'readonly', '')}
							><c:out value="${blogFamily.remark}" escapeXml="true"/></textarea>
						</td>
					</tr>					
			

				</table>
			</div>		
		</td>
	</tr>
		<c:if test="${param.viewFlag == 'false'}">
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="button" onclick="submitForm()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
			<input type="button" onclick="history.go(-1)" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
		</c:if>
</table>
</form>
</body>
<script>
  bindOnresize('categorySetBody',30,100);
</script>