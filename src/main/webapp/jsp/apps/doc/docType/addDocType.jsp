<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<%@ include file="../../../common/INC/noCache.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<script type="text/javascript">
<!--
	
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

	var theArrayList = new ArrayList();		//定义一个存储ID得集合
	var lastList = new ArrayList();			//排序后的ID集合
	<c:forEach var="definition" items="${finalDef}">
		var defId='${definition.id}';
		theArrayList.add(defId);
	</c:forEach>
	
	function metadataMody(){
		var _mainForm=document.getElementById("mainForm");
		_mainForm.action="${managerURL}?method=setMetadataModyPageIfram";
		_mainForm.submit();
	}
//-->
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docManager.js${v3x:resSuffix()}" />"></script>
<body>
<form action="" name="mainForm" id="mainForm" method="post">
<input type="hidden" name="parentType" value="1">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="96%" align="center">	
	<tr align="center">
		<td height="8" class="detail-top">
    		<script type="text/javascript">
    			getDetailPageBreak(); 
    		</script>
		</td>
	</tr>
	<tr>		
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="110" nowrap="nowrap"><fmt:message key='metadataDef.operation.add'/></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;<font color="red">*</font><fmt:message key='common.notnull.label' bundle="${v3xCommonI18N}"/></td>
				</tr>
			</table>
		</td>
	</tr>

	<tr>
	<td align="center">
    <div id="docLibBody">
		<table width="70%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr align="center">
		<td valign="middle">
<!-- Del By Lif Start -->		

<!-- Del End -->		
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr align="center">
		<td valign="middle">
		<table width="600" border="0"  cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td class="bg-gray" width="20%" nowrap><font color="red">*</font><fmt:message key='common.name.label' bundle="${v3xCommonI18N}" />:</td>
				<td class="new-column" width="80%">
				<input type="text" name="theName" id="theName" class="input-100per" value=""
				 inputName="<fmt:message key='common.name.label' bundle="${v3xCommonI18N}" />" validate="notNull,isWord" maxSize="80"></td>
			</tr>						
			<tr>
				<td class="bg-gray" width="20%" nowrap valign="top">
					<fmt:message key='common.description.label' bundle="${v3xCommonI18N}" />:
				</td>
				<td class="new-column" width="80%">
					<textarea rows="5" cols="32" id="description" name="description" class="input-100per"
					 inputName="<fmt:message key='common.description.label' bundle="${v3xCommonI18N}" />" validate="maxLength" maxSize="80"></textarea>
				</td>
			</tr>
						<tr><td class="bg-gray" width="20%" nowrap valign="top"></td>
			<td class="new-column" width="80%">
			<!-- 
			<font color="red">(
			<fmt:message key='common.charactor.limit.label' bundle="${v3xCommonI18N}">
				<fmt:param value="120" />
			</fmt:message>)</font>
			 -->
			</td></tr>
		</table>
<!-- Del By Lif Start -->		
	</td></tr>
	<tr><td>
<!-- Del End -->	
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr><td>&nbsp;</td></tr>
		</table>
			</td></tr>
	<tr><td>
<!-- Del By Lif Start -->		

<!-- Del End -->	
		<table width="700" border="0" cellpadding="0" cellspacing="0" align="center" height="100%"
		style="word-break:break-all;word-wrap:break-word">
		<tr height="35"><td class="bg-gray" width="25%" valign="top"></td><td class="new-column" width="75%"><input type="button" value="<fmt:message key='common.button.add.label' bundle='${v3xCommonI18N}'/>" onclick="addNewMeta();"  class="button-default_emphasize"/>&nbsp;&nbsp;
					<input type="button" value="<fmt:message key='common.button.delete.label' bundle='${v3xCommonI18N}'/>" onclick="deleteChoiceMeta();" class="button-default_emphasize"/>&nbsp;&nbsp;
					<input type="button" value="<fmt:message key='common.button.moveup.label' bundle='${v3xCommonI18N}'/>" onclick="choiceMetaIndex('up')" class="button-default_emphasize" />&nbsp;&nbsp;
					<input type="button" value="<fmt:message key='common.button.movedown.label' bundle='${v3xCommonI18N}'/>" onclick="choiceMetaIndex('down')" class="button-default_emphasize" /></td></tr>
			<tr><td class="bg-gray" width="25%" valign="top"><font color="red">*</font><fmt:message key="doc.menu.admin.properties" />:</td>
			<td class="new-column" width="75%">
				<div ><fieldset class="docScrollList">
					  <v3x:table data="${MetadataMenu}" var="metadata" htmlId="metadataHtmlId" isChangeTRColor="true" showPager="false" showHeader="true" pageSize="20" dragable="false">
			<v3x:column width="35" align="center" label="<input type='checkbox' onclick='selectAll(this, \"sId\")'/>">
				<input type='checkbox' name='sId' id="sId" value="${metadata.metadataDef.id}" />
			</v3x:column>
			<v3x:column label="common.name.label" value="${metadata.metadataDef.name}"></v3x:column>
			<v3x:column label="common.type.label" width="20%" type="string">
				<fmt:message key="${metadata.key}"/>
			</v3x:column>
			<v3x:column label="metadataDef.readonly" width="15%" align="center">
			<c:choose>				
				<c:when test="${metadata.readOnly == true}">
					<input type='checkbox' name="isEditable${metadata.metadataDef.id}" id="isEditable${metadata.metadataDef.id}" value='1' checked="checked"/>
				</c:when>
				<c:when test="${metadata.readOnly == false}">
					<input type='checkbox' name="isEditable${metadata.metadataDef.id}" id="isEditable${metadata.metadataDef.id }" value='1' />
				</c:when>
			</c:choose>
				
			</v3x:column> 
			<v3x:column label="doc.property.nullable.label" width="15%" align="center">		
					<input type='checkbox' name="nullable${metadata.metadataDef.id}" id="nullable${metadata.metadataDef.id}" value='1'/>
			</v3x:column>
	</v3x:table>
<!-- Del By Lif Start -->		

<!-- Del End -->	

				</fieldset>
				</div>
			</td></tr>
		</table>
<!-- Del By Lif Start -->		
	</td></tr></table>
<!-- Del End -->	
		</td>
	</tr>


</table>		
	</div></td>
	</tr>

	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			
			<input type="button" name="b1" id="b1" onclick="addDocType();" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
			<input type="button" name="b2" id="b2" onclick="window.location.href='<c:url value='/common/detail.jsp'/>';" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>

	</table>
<div id="tempMetadata"></div>
<input type="hidden" id="addString" name="addString">
<iframe id="empty" name="empty" marginheight="0" marginwidth="0" width="0" height="0"></iframe>
</form>
</body>
</html>
<script>
  bindOnresize('docLibBody',20,80);
</script>