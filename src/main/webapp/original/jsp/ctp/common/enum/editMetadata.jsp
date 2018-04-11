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
		if(document.all.id.value == ""){
			var labelObj = document.all.label;
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
		return true;
	}
	
	

function userInputOk()
{
  if(checkForm(document.editForm)==false){return;}
	document.editForm.submit();
}

getDetailPageBreak();
</script>
</head>
<body style="margin: 0px; padding: 0px;scroll:no">
<c:set value="${param.disabled=='true'? 'disabled':''}" var="setIsEnable"/>
<form name="editForm" method="post" action="${metadataMgrURL}" onSubmit="return (checkForm(this) && checkIsNameDuple())">
	<input type="hidden" name="method" value="updateMetadata">
	<input type="hidden" name="metadataId" value="${metadata.id}">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"  class="categorySet-bg" height="98%">	
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="metadata.enum.name"/></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	   <td width="100%" height="100%" class="categorySet-head">
	    <div class="categorySet-body" style="scroll:no">	   

			<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
				  	<td class="bg-gray" width="25%" nowrap="nowrap" height="24"><font color="red">*</font><label for="leader"><fmt:message key="metadata.enumname.label"/></label></td>
					<td class="new-column" width="75%" nowrap="nowrap">
						<input type="text" disabled name="metadataName" class="input-100per"  value="${v3x:messageFromResource(EnumI18N, metadata.label)}" inputName="<fmt:message key='metadata.manager.displayname'/>" validate="notNull,isWord"   character="\\/|><*?'&%$" />				  	</td>
				</tr>				
				<tr>
					<td class="bg-gray" width="25%" nowrap="nowrap" height="24"><font color="red">*</font><label for="memo"><fmt:message key="metadata.manager.sort"/></label></td>
					<td class="new-column" width="75%">
						<input class="input-100per" type="text" name="sort" ${setIsEnable} value="${metadata.sort}" inputName="<fmt:message key='metadata.manager.sort'/>" validate="notNull,isNumber,isInteger" />					</td>
				</tr>
				<tr>
					<td width="25%" height="24" valign="top" nowrap="nowrap" class="bg-gray"><label for="memo"><fmt:message key="metadata.enum.description.label"/></label></td>
					<td class="new-column" width="75%">
						<textarea class="100" name="description" id="description" rows="6" cols="" style="width: 100%"  ${setIsEnable}>${metadata.description}</textarea>					</td>
				</tr>
			</table>		
		</div>
	    </td>
	</tr>
	<c:if test="${param.disabled!='true'}">
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="button" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" class="button-default-2" onclick="userInputOk();">&nbsp;&nbsp;
			<input type="button" onclick="window.location.href='<c:url value="/common/detail.jsp" />'" ${setIsEnable} value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" class="button-default-2">
			</td>
		</tr>	  
		</c:if>
	</table>
</form>
</body>