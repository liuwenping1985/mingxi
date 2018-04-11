<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
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
	<c:forEach var="detail" items="${details}">
		var defId='${detail.metadataDefId}';
		theArrayList.add(defId);
	</c:forEach>
	
	function metadataMody() {
		var _mainForm=document.getElementById("mainForm");
		_mainForm.action="${managerURL}?method=setMetadataModyPageIfram";
		_mainForm.submit();
	}

	function display(){
	//	if(doument.getElementById("start_status").checked){

      document.getElementById("seartch").style.display="";
		
	}
	function hiddenPlay(){
		document.getElementById("seartch").style.display="none";
		
	}
    function showDiv(){
	var  test="${docType.status}";
	var flag = "${param.flag}";	
	if(test == 2&&flag!='view') document.getElementById("seartch").style.display="";
	}
	

//-->
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docManager.js${v3x:resSuffix()}" />"></script>
<body>
<form action="" name="mainForm" id="mainForm" method="post">
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
					<c:choose> 
					<c:when test="${isModify != true }">
					<td class="categorySet-title" width="110" nowrap="nowrap"><fmt:message key='metadataDef.operation.add' /></td>
					</c:when>
					<c:when test="${param.flag == 'view' }">
					<td class="categorySet-title" width="110" nowrap="nowrap"><fmt:message key='metadataDef.operation.view' /></td>
					</c:when>
					<c:otherwise>
					<td class="categorySet-title" width="110" nowrap="nowrap"><fmt:message key='metadataDef.operation.modify' /></td>
					</c:otherwise>
					</c:choose>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;<font color="red">*</font><fmt:message key='common.notnull.label' bundle="${v3xCommonI18N}" /></td>
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
		<tr><td class="bg-gray" width="20%" nowrap><font color="red">*</font><fmt:message key='common.name.label' bundle="${v3xCommonI18N}" />:</td>
			<c:choose>
				<c:when test="${docType.isSystem == true}">
				<td class="new-column" width="80%"><input type="text" name="theName" id="theName" class="input-100per" value="${v3x:_(pageContext, docType.name)}" disabled></td></tr>
				</c:when>
			<c:otherwise>
			<td class="new-column" width="80%">
			<fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
			<input type="text" name="theName" id="theName"  class="input-100per" deaultValue="${defName}" 
			inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}" />" validate="isDeaultValue,notNull,isWord" maxSize="80" 
			 value="<c:out value="${v3x:_(pageContext, docType.name)}" escapeXml="true" default='${defName}' />"
			 ${v3x:outConditionExpression(readOnly, 'readonly', '')}
			onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)" /></td></tr></c:otherwise>
			</c:choose>
			
			<tr><td class="bg-gray" width="20%" nowrap valign="top"><fmt:message key='common.description.label' bundle="${v3xCommonI18N}" />:</td>
			<td class="new-column" width="80%">
			<textarea rows="5" cols="32" id="description" name="description" class="input-100per"
			inputName="<fmt:message key='common.description.label' bundle="${v3xCommonI18N}" />" validate="maxLength" maxSize="80"	>${docType.description}</textarea></td></tr>

			<c:if test = "${docType.status !=0&&param.flag=='edit'}">

			<tr><td class="bg-gray" width="20%" nowrap valign="top"><fmt:message key="doc.type.current.status" />:</td>
			<td class="new-column" width="80%"> 

		    	  <c:choose>
					<c:when test="${docType.status==1}">
					<label for= "start_status">
					 <input type="radio" name="status" value="1" checked  onclick = "hiddenPlay()" />  <fmt:message key="doc.type.status.1" />&nbsp;
					</label>
					<label for= "end_status">
					 <input type="radio" name="status" value="2" onclick = "display()"/><fmt:message key="doc.type.status.2" />	
					</label>
					</c:when>
					<c:otherwise>
                    <label for= "start_status">
					<input type="radio" name="status" value="1" onclick = "hiddenPlay()" /><fmt:message key="doc.type.status.1" />&nbsp;
					</label>
					<label for= "end_status">
			 		 <input type="radio" name="status" value="2" checked  onclick = "display()" /><fmt:message key="doc.type.status.2" />	
					 </label>
					</c:otherwise>
				</c:choose>
               <div id="seartch" style="display:none;"> 
			   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  <label for="seartchEnable">
					<input type="checkbox" name="seartchEnable" id="seartchEnable"   <c:if test="${docType.seartchStatus==1}"> checked </c:if>
					value="true"/>
					
					<fmt:message key="doc.type.seartch.close" />			
			      </label>
				</div>
							
			
			</td></tr>    
			</c:if>
						
						
			<tr><td class="bg-gray" width="20%" nowrap valign="top"></td>
			<td class="new-column" width="80%">
			<!-- 
			<font color="red">(
			<fmt:message key='common.charactor.limit.label' bundle="${v3xCommonI18N}">
				<fmt:param value="120" />
			</fmt:message>)</font></td>
			 -->
			</tr>
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
		<table width="600" border="0" cellpadding="0" cellspacing="0" align="center" height="100%"
		style="word-break:break-all;word-wrap:break-word">
		<tr><td></td><td>
				<div id="prop_buttons" style="display:none">
				<table height="25" width="100%" cellpadding="0" cellspacing="0" align="center">
					<tr><td class="padding5"><input id="add" type="button" value="<fmt:message key='common.button.add.label' bundle='${v3xCommonI18N}'/>" onclick="addNewMeta();"  class="button-default_emphasize"/>&nbsp;&nbsp;&nbsp;&nbsp;
					<input id="del" type="button" value="<fmt:message key='common.button.delete.label' bundle='${v3xCommonI18N}'/>" onclick="deleteChoiceMeta();" class="button-default_emphasize"/>&nbsp;&nbsp;&nbsp;&nbsp;
					<input id="up" type="button" value="<fmt:message key='common.button.moveup.label' bundle='${v3xCommonI18N}'/>" onclick="choiceMetaIndex('up')" class="button-default_emphasize" />&nbsp;&nbsp;&nbsp;&nbsp;
					<input id="down" type="button" value="<fmt:message key='common.button.movedown.label' bundle='${v3xCommonI18N}'/>" onclick="choiceMetaIndex('down')" class="button-default_emphasize" /><td/></tr>
				</table>
				</div>
		</td></tr>
        <tr><td>&nbsp;</td></tr>
			<tr><td class="bg-gray" width="20%" nowrap valign="top"><font color="red">*</font><fmt:message key="doc.menu.admin.properties" />:</td><td class="new-column" width="80%">
				<div ><fieldset class="docScrollList">
	<c:choose>
		<c:when test="${docType.isSystem == true || param.flag == 'view'||docType.status!=0}">
		  <v3x:table data="${MetadataMenu}" var="metadata" htmlId="metadataHtmlId" isChangeTRColor="false" showPager="false" showHeader="true" dragable="false">
			<v3x:column width="35" align="center" label="<input type='checkbox' onclick='selectAll(this, \"sId\")'/>">
				<input type='checkbox' name='sId' id="sId" value="${metadata.metadataDef.id}"/>
			</v3x:column>
			<v3x:column label="common.name.label" value="${metadata.name}"></v3x:column>
			<v3x:column label="common.type.label" width="20%" type="string">
				<fmt:message key="${metadata.key}"/>
			</v3x:column>
			<v3x:column label="metadataDef.readonly" width="15%" align="center">
			<c:choose>
				<c:when test="${metadata.readOnly == true }">
					<input type='checkbox' name="isEditable${metadata.metadataDef.id}" id="isEditable${metadata.metadataDef.id}" value='1' checked disabled/>
				</c:when>
				<c:when test="${metadata.readOnly == false}">
					<input type='checkbox' name="isEditable${metadata.metadataDef.id}" id="isEditable${metadata.metadataDef.id}" value='1' disabled/>
				</c:when>
			</c:choose>
				
			</v3x:column>
				<v3x:column label="doc.property.nullable.label" width="15%" align="center">	
					<input type='checkbox' name="nullable${metadata.metadataDef.id}" 
					id="nullable${metadata.metadataDef.id}" value='1' disabled 
					${v3x:outConditionExpression(metadata.detail.nullable=='true', 'checked', '')}
					/>

			</v3x:column>
		</v3x:table>
		</c:when>
		<c:otherwise>
			<v3x:table data="${MetadataMenu}" var="metadata" htmlId="metadataHtmlId" isChangeTRColor="true" showPager="false" showHeader="true" pageSize="20" dragable="false">
			<v3x:column width="35" align="center" label="<input type='checkbox' onclick='selectAll(this, \"sId\")'/>">
				<input type='checkbox' name='sId' id="sId" value="${metadata.metadataDef.id}" />
			</v3x:column>
			<v3x:column label="common.name.label" value="${metadata.name}"></v3x:column>
			<v3x:column label="common.type.label" width="20%" type="string">
				<fmt:message key="${metadata.key}"/>
			</v3x:column>
			<v3x:column label="metadataDef.readonly" width="15%" align="center">
			<c:choose>
				<c:when test="${metadata.readOnly == true }">
					<input type='checkbox' name="isEditable${metadata.metadataDef.id}" id="isEditable${metadata.metadataDef.id}" value='1' checked/>
				</c:when>
				<c:when test="${metadata.readOnly == false}">
					<input type='checkbox' name="isEditable${metadata.metadataDef.id}" id="isEditable${metadata.metadataDef.id}" value='1'/>
				</c:when>
			</c:choose>
				
			</v3x:column>
			<v3x:column label="doc.property.nullable.label" width="15%" align="center">		
					<input type='checkbox' name="nullable${metadata.metadataDef.id}" 
						id="nullable${metadata.metadataDef.id}" value='1'
						${v3x:outConditionExpression(metadata.detail.nullable=='true', 'checked', '')}
						/>
			</v3x:column>
		</v3x:table>
		</c:otherwise>
		</c:choose>
<!-- Del By Lif Start -->		

<!-- Del End -->
		</fieldset>
				</div>
			</td></tr>
		</table>
		</td></tr></table>
<!-- Del By Lif Start -->		

<!-- Del End -->	

		</td>
	</tr>
		
</table>		
	</div></td>
	</tr>

	<tr id="editButton" style="display:none;">
		<td height="42" align="center" class="bg-advance-bottom">
			
			<input id="b1" name="b1" type="button" onclick="updateDocType();" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
			
			<input id="b2"  name="b2" type="button" onclick="window.location.href='<c:url value='/common/detail.jsp'/>';" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>

	</table>
<div id="tempMetadata"></div>
<input type="hidden" id="addString" name="addString">
<input type="hidden" id="oldValue" name="oldValue" value="${v3x:toHTML(docType.name)}">
<script type="text/javascript">
<!--
	var modyTableTr=document.getElementById("metadataHtmlId");
	if(modyTableTr.rows.length > 1){		//若表不光有表头时
		var temp_meta_id=document.getElementsByName("sId");
		var temp_number=1;
		for(var m=0; m<temp_meta_id.length;m++){
			modyTableTr.rows[temp_number].id="tr"+temp_meta_id[m].value;		//为当前存在得行设置ID
			temp_number=temp_number+1;		
		}
	}
	
	var flag = "${param.flag}";
	var isSystem = "${docType.isSystem}";
	var status = "${docType.status}";
	if(flag == "edit"){
		document.getElementById("editButton").style.display="";
		var objDiv = document.getElementById("prop_buttons");
		objDiv.style.display = "block";
		if (isSystem == "true") {
			document.getElementById("description").disabled = true;
			document.getElementById("b1").disabled = true;
			document.getElementById("b2").disabled = true;
			document.getElementById("add").disabled = true;
			document.getElementById("del").disabled = true;
			document.getElementById("up").disabled = true;
			document.getElementById("down").disabled = true;
		}
        
	
	}
	else{
		document.getElementById("theName").disabled = true;
		document.getElementById("description").disabled = true;
		document.getElementById("editButton").style.display="none";
	}

//-->
</script>
<input type="hidden" name="docTypeId" id="docTypeId" value="${docType.id}"/>	
<iframe id="empty" name="empty" marginheight="0" marginwidth="0" width="0" height="0"></iframe>
</form>
</body>
</html>
<script>
  bindOnresize('docLibBody',20,80);
</script>