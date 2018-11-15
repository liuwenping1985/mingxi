<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ include file="header.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><fmt:message key="metadata.enum.name"/></title>
<script type="text/javascript">	
	function cancel(){
		window.returnValue=null;
		window.close();
	}
	
	function checkIsNameDuple(){
		//新建时校验重复
			var labelObj = document.all.metadataName;
			var orgLabel = document.all.orgMetadataName;
			var existMetadataNames = parent.listFrame.existMetadataNamesArray;
			if(labelObj && existMetadataNames){
				for(var i = 0; i<existMetadataNames.length; i++){
					if(labelObj.value == existMetadataNames[i] && labelObj.value!=orgLabel.value){
						alert(_("sysMgrLang.checkForm_nameMustNotDuple"));
						labelObj.focus();
						return false;
					}
				}
			}
		return true;
	}
	
	

function userInputOk()
{
  if(checkForm(document.editForm)==false || checkIsNameRep(document.editForm) == false){return;}
  document.editForm.submit();
}
</script>
</head>
<body style="scroll:no">
<script type="text/javascript">
<!--
getDetailPageBreak();
//-->
</script>
<form name="editForm" method="post" action="${metadataMgrURL}" onSubmit="return (checkForm(this) && checkIsNameRep(this))">
	<input type="hidden" name="method" value="updateUserDefinedMetadata">
	<input type="hidden" name="metadataId" value="${metadata.id}">
	<input type="hidden" name="isSystem" value="true">
	<input type="hidden" name="from" value="update">
	<input type="hidden" name="orgMetadataName" value="<c:out value="${metadata.label}"/>">
	<input type="hidden" name="parentId" value="${param.parentId}">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"  height="98%">	
	<tr>
	   <td width="100%" height="100%" class="categorySet-head">   
			<table width="80%" border="0" cellspacing="0" cellpadding="3" align="center">
				<tr>
				  	<td class="bg-gray" width="25%" nowrap="nowrap" height="24"><font color="red">*</font><label for="leader"><fmt:message key="metadata.enumname.label"/></label></td>
					<td class="new-column" width="75%" nowrap="nowrap">
						<input type="text" <c:if test="${param.disabled=='true'}">disabled</c:if> name="metadataName" class="input-100per"  maxSize="85" maxlength="85"  value="<c:out value="${metadata.label}"/>" inputName="<fmt:message key='metadata.enumname.label'/>" validate="notNull,maxLength,isWord"  character="\\/|><*?'&%$" />				  	</td>
				</tr>				
				<tr>
					<td class="bg-gray" width="25%" nowrap="nowrap" height="24"><font color="red">*</font><label for="memo"><fmt:message key="metadata.manager.sort"/></label></td>
					<td class="new-column" width="75%">
						<input class="input-100per" <c:if test="${param.disabled=='true'}">disabled</c:if> type="text" name="sort"   maxSize="8" maxlength="8"   value="${metadata.sort}" inputName="<fmt:message key='metadata.manager.sort'/>" validate="notNull,isNumber,maxLength,isInteger" />					</td>
				</tr>
				<tr>
					<td width="25%" height="24" valign="top" nowrap="nowrap" class="bg-gray"><label for="memo"><fmt:message key="metadata.enum.description.label"/></label></td>
					<td class="new-column" width="75%">
						<textarea class="100" <c:if test="${param.disabled=='true'}">disabled</c:if>  maxSize="50" maxlength="50" validate="maxLength"    inputName="<fmt:message key="metadata.enum.description.label"/>" name="description" id="description" rows="6" cols="" style="width: 100%" >${metadata.description}</textarea>					</td>
				</tr>
			</table>		
	    </td>
	</tr>
		<c:if test="${param.disabled!='true'}">
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="button" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" class="button-default-2" onclick="userInputOk();">&nbsp;&nbsp;
			<input type="button"  onclick="window.location.href='<c:url value="/common/detail.jsp" />'" ${setIsEnable} value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" class="button-default-2">
			</td>
		</tr>	 
		</c:if> 
	</table>
</form>
</body>