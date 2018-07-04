<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../header.jsp"%>
<script type="text/javascript">
	var hasIssueArea = false;

	function selectFamilyAdmin(){
		selectPeopleFun_wf();
	}

	function setPeopleFields(elements){
		if(!elements){
			return;
		}
		document.fm.blogFamilyAdmin.value=getIdsString(elements);
		document.fm.blogFamilyAdminName.value=getNamesString(elements);	
		hasIssueArea = true;
	}
	
	function submitForm(){
		var theForm = document.getElementsByName("fm")[0];
		if (!theForm) {
        	return;
    	}
	
		theForm.action = "${detailURL}?method=createFavorites";
	
		if (checkForm(theForm)) {
			var name = document.getElementById("nameFamily").value;
			var ds = validFamilyName(name, 0, "${currentUserId}");
			if(ds == "false"){			
				alert(v3x.getMessage("BlogLang.blog_family_samename"));
				document.fm.nameFamily.focus();
				return false;
			}else
        		theForm.submit();
   	 	}
	}
	
	// 在文本框中禁止 回车 键
  document.onkeydown   =   function()   
  {   
      var   e   =   window.event.srcElement;   
      var   k   =   window.event.keyCode;   
      if(k==13   &&   e.tagName=="INPUT"   &&   e.type=="text")   
      {   
          window.event.keyCode         =   0;   
          window.event.returnValue=   false;
      }   
  } 
</script>
</head>
<body scroll="no" style="overflow: no">
<form name="fm" method="post" action="" onsubmit="return checkForm(this)">

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td class="categorySet-head">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="common.toolbar.new.label" bundle="${v3xCommonI18N}" /></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<div class="" id="categorySetBody">
				<table width="500" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td class="bg-gray , blog-tb-padding-topAndBottom" width="25%" nowrap>
						<font color=red>*</font><fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />:
						</td>					
						<td class="new-column , blog-tb-padding-topAndBottom" width="75%" colspan="3">
							<fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
					        <input name="nameFamily" type="text" id="nameFamily" class="input-100per" deaultValue="${defName}"
				               inputName="<fmt:message key='common.name.label' bundle='${v3xCommonI18N}' />" validate="isDeaultValue,notNull,maxLength"  maxSize="16"
				                value="${defName}"
				                ${v3x:outConditionExpression(readOnly, 'readonly', '')}
				               onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)">
					    </td>
					</tr>
					<tr>
						<td valign="top" class="bg-gray , blog-tb-padding-topAndBottom" nowrap>
							<fmt:message key="common.description.label"  bundle="${v3xCommonI18N}" />:
						</td>
						<td class="new-column , blog-tb-padding-topAndBottom" colspan="3">
							<textarea id="remark" name="remark" class="input-100per"
							rows="5" maxSize="100" validate="maxLength" inputName="<fmt:message key="common.description.label"  bundle="${v3xCommonI18N}" />"></textarea>
						</td>
					</tr>
				</table>
			</div>		
		</td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="button" onclick="submitForm()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
			<input type="button" onclick="window.history.back();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
</body>
</html>
<script>
  bindOnresize('categorySetBody',30,100);
</script>