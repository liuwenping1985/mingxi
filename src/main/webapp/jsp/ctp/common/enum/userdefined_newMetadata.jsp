<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ include file="header.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><fmt:message key="metadata.enum.name"/></title>
<script type="text/javascript">	
	function cancel(){
		parent.listFrame.location.reload();
	}
	
	function checkIsNameDuple(){
		//新建时校验重复
			var labelObj = document.all.metadataName;
			var existMetadataNames = parent.listFrame.existMetadataNamesArray;
			if(labelObj && existMetadataNames){
				for(var i = 0; i<existMetadataNames.length; i++){
					if(labelObj.value == existMetadataNames[i]){
						alert(_("sysMgrLang.checkForm_nameMustNotDuple"));
						labelObj.focus();
						return false;
					}
				}
			}
	}
	
	

function userInputOk()
{
  if(checkForm(document.editForm)==false || checkIsNameRep(document.editForm) == false){return;}
  document.editForm.submit();
}
</script>
</head>
<body style="margin: 0px; padding: 0px;scroll:no">
<script type="text/javascript">
<!--
getDetailPageBreak();
//-->
</script>
<c:set value="${param.disabled=='true'? 'disabled':''}" var="setIsEnable"/>
<form name="editForm" method="post" action="${metadataMgrURL}?method=addUserDefinedMeta" onSubmit="return (checkForm(this) && checkIsNameRep(this))">
	<input type="hidden" name="method" value="updateMetadataItem">
	<input type="hidden" name="metadataId" value="${metadataItem.id}">
	<input type="hidden" name="categoryId" value="${metadata.id}">
	<input type="hidden" name="isSystem" value="${isSystem}">
	<input type="hidden" name="parentId" value="${parentId}">
	<input type="hidden" name="selectName" value="${selectName }">
	<input type="hidden" name="from" value="">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"  height="98%">	
	<tr>
	   <td width="100%" height="100%" class="categorySet-head">   
			<table width="80%" border="0" cellspacing="0" cellpadding="3" align="center">
				<tr>
				  	<td class="bg-gray" width="25%" nowrap="nowrap" height="24"><font color="red">*</font><label for="leader"><fmt:message key="metadata.enumname.label"/></label></td>
					<td class="new-column" width="55%" nowrap="nowrap">
						<input type="text" name="metadataName" id="metadataName" class="input-100per"  maxSize="85" maxlength="85"  value="" inputName="<fmt:message key='metadata.enumname.label'/>" validate="notNull,maxLength,isWord"  character="\\/|><*?'&%$" />				  	</td>
					<td>
						&nbsp;
					</td>
				</tr>				
				<tr>
					<td class="bg-gray" width="25%" nowrap="nowrap" height="24"><font color="red">*</font><label for="memo"><fmt:message key="metadata.manager.sort"/></label></td>
					<td class="new-column" width="55%">
						<input class="input-100per" type="text" 
						
						 maxSize="8" maxlength="8"  name="sort" ${setIsEnable} value="${sortNUM}" inputName="<fmt:message key='metadata.manager.sort'/>" validate="notNull,isNumber,isInteger" />					</td>
					<td>
						&nbsp;
					</td>			
				</tr>
				<tr>
					<td width="25%" height="40%" valign="top" nowrap="nowrap" class="bg-gray"><label for="memo"><fmt:message key="metadata.enum.description.label"/></label></td>
					<td class="new-column" width="55%">
						<textarea class="100" name="description" id="description" maxSize="50" maxlength="50" validate="maxLength"  inputName="<fmt:message key="metadata.enum.description.label"/>" rows="6" cols="" style="width: 100%"  ${setIsEnable}>${metadataItem.description}</textarea>					</td>
					<td>
						&nbsp;
					</td>				
				</tr>
			</table>		
	    </td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="button" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" class="button-default-2" onclick="userInputOk();">&nbsp;&nbsp;
			<input type="button" onClick="cancel()" ${setIsEnable} value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" class="button-default-2">
			</td>
		</tr>	  
	</table>
</form>
<script type="text/javascript">
 document.getElementById("metadataName").focus() ;
</script>

</body>