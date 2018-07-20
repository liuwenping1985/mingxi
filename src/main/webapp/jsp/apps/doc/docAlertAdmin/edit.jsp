<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="doc.menu.admin.properties"/></title>
<script type="text/javascript">
	function editAlertType(alertIds) {
		var msgchk = document.getElementById("check_box_message");
		var message = msgchk.checked;
		
		mainForm.action = jsURL + "?method=docAlertEdit&alertIds=" + alertIds 
			+ "&message=" + message + "&isFolder=${isFolder}&docResId=${docResId}";
		mainForm.submit();
	}
	
function selectDelete(ele){
	var chk = document.getElementById("check_box_message");
	if(ele.checked){
		chk.checked = true;
		chk.disabled = true;
	}else{
		chk.disabled = false;
	}
}

function forumAble(){

   var commentEnable = "${comment}";
  
   var chforum = document.getElementById("check_box_forum");

    if(commentEnable!=null&&commentEnable=="false") {
       chforum.checked = false;
	   chforum.disabled = true;
	 }

}

function closeAndRef () { 
	transParams.parentWin.modifyCollBack();
}


	
</script>
</head>
<body scroll="no" onload = "forumAble()" style="overflow: hidden;">
<form name="mainForm" id="mainForm" action="" method="post"  target="empty">
<table border="0" cellspacing="0" cellpadding="0" align="center" width="100%" height="100%" class="popupTitleRight">
<tr height="20"> 
 <td  class="PopupTitle" nowrap="nowrap" width="100%"><fmt:message key="doc.jsp.alert.admin.edit.lable"/> </td>
</tr>
<tr height="85" >
  <td  >
    <table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
       <tr>
         <td align="center" width="100%">
           <fieldset style="width:90%" align="center">
				<legend>
					<strong>
						<fmt:message key='doc.jsp.alert.admin.edit.rep'></fmt:message>
					</strong>
				</legend>
			        <table  width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			     <c:if test="${isFolder == 'true'}">		
				   <tr>
					<td class="padding-L padding-T">
							<label for="check_box_add">
								<input type="checkbox" name="check_box_add" id="check_box_add" 
								value="true"   <c:if test="${vo.add == true}"> checked </c:if> >
								<fmt:message key="doc.jsp.alert.add" />					
							</label>
					</td>
					<td class="padding-L padding-T">
							<label for="check_box_edit">
								<input type="checkbox" name="check_box_edit" id="check_box_edit" 
								value="true" <c:if test="${vo.edit == true}"> checked </c:if> >
								<fmt:message key="doc.jsp.alert.edit" />					
							</label>
					</td>
				 </tr>
					
				<tr>
					<td class="padding-L padding-T">
							<label for="check_box_delete">
								<input type="checkbox" name="check_box_delete" id="check_box_delete" 
								value="true" onclick="" <c:if test="${vo.delete == true}"> checked </c:if> >
								<fmt:message key="doc.jsp.alert.delete" /><fmt:message key="doc.jsp.alert.delete.message" />					
							</label>
					</td>
					<td class="padding-L padding-T">
							<label for="check_box_forum">
								<input type="checkbox" name="check_box_forum" id="check_box_forum" 
								value="true" <c:if test="${vo.forum == true}"> checked </c:if>  >
								<fmt:message key="doc.jsp.alert.forum" />					
							</label>
					</td>
					
				</tr>
				</c:if>
					
				<c:if test="${isFolder == 'false'}">		
				<tr>
					<td class="padding-L padding-T">
							<label for="check_box_edit">
								<input type="checkbox" name="check_box_edit" id="check_box_edit" 
								value="true"  <c:if test="${vo.edit == true}"> checked </c:if>  >
								<fmt:message key="doc.jsp.alert.edit" />					
							</label>
					</td>
					<td class="padding-L padding-T">
							<label for="check_box_delete">
								<input type="checkbox" name="check_box_delete" id="check_box_delete" 
								value="true" onclick="" <c:if test="${vo.delete == true}"> checked </c:if>  >
								<fmt:message key="doc.jsp.alert.delete" /><fmt:message key="doc.jsp.alert.delete.message" />					
							</label>
					</td>
					</tr>
				<tr>
					<td class="padding-L padding-T">
						<label for="check_box_forum">
									<input type="checkbox" name="check_box_forum" id="check_box_forum" 
									value="true"  <c:if test="${vo.forum == true}"> checked </c:if>	 >
									<fmt:message key="doc.jsp.alert.forum" />					
						</label>
					</td>
					<td class="padding-L padding-T"></td>
				</tr>
			  </c:if>		 			
			</table>	
		 </fieldset>		
         </td>       
       </tr>
    </table>
  </td>
</tr>
<tr valign="center">
 <td height="20" align="right" >
 <fieldset style="width:90%; border: 0;" align="center">
	<label for="check_box_message">
		<input type="checkbox" name="check_box_message" id="check_box_message" 
		value="true" <c:if test="${vo.sendMessage == true}"> checked </c:if>  >
		<fmt:message key="doc.jsp.alert.message.send" />					
	</label>
	</fieldset>
 </td>
</tr>

<tr valign="center" height="50">
	<td>
    <table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td align="center" valign="top" width="100%">
	
	<fieldset style="width:90%" align="center"><legend><strong><fmt:message key='doc.jsp.alert.admin.prop'/></strong></legend>
		
		<table width="100%" border="0" cellspacing="0" align="center"
		cellpadding="0" id="propTable" style="word-break:break-all;word-wrap:break-word">
			<tr height="25">
				<td align="right" width="30%"><fmt:message key='doc.jsp.open.body.name'/>:&nbsp;&nbsp;</td>
				<td >${v3x:_(pageContext, vo.docResource.frName)}</td></tr>		
			<tr height="25">
				<td align="right"width="30%"><fmt:message key='doc.jsp.properties.common.contenttype'/>:&nbsp;&nbsp;</td>
				<td >${v3x:_(pageContext, vo.type)}</td></tr>			
			<tr height="25">
				<td align="right" width="30%"><fmt:message key='doc.jsp.properties.common.path'/>:&nbsp;&nbsp;</td>
				<td >${vo.path}</td></tr>				
			<tr height="25"><td align="right" width="30%"><fmt:message key='doc.metadata.def.creater'/>:&nbsp;&nbsp;</td>
				<td >${vo.docCreater}</td></tr>
			<tr height="25"><td align="right" width="30%"><fmt:message key='doc.metadata.def.createtime'/>:&nbsp;&nbsp;</td>
				<td ><fmt:formatDate value='${vo.docResource.createTime}' pattern='${datetimePattern}' /></td></tr>	
			<tr height="25">
				<td align="right" width="30%"><fmt:message key='doc.jsp.alert.admin.alerttype'/>:&nbsp;&nbsp;</td>
				<td >${vo.alertType}</td></tr>			
			<tr height="25">
				<td align="right" width="30%"><fmt:message key='doc.jsp.alert.admin.alerttime'/>:&nbsp;&nbsp;</td>
				<td ><fmt:formatDate value='${vo.alertCreateTime}' pattern='${datetimePattern}' /></td></tr>	
			<tr height="25"><td align="right" width="30%"><fmt:message key='doc.metadata.def.desc'/>:&nbsp;&nbsp;</td>
				<td >${vo.docResource.frDesc}</td></tr>
		</table>
		
		</fieldset>
		</td>
		</tr>	     	   
	   </table> 
	 </td>
</tr>

<tr height="42">
		<td align="right" class="bg-advance-bottom">
			<input type="button" name="b1" onclick="editAlertType('${vo.alertIds}')" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
			<input type="button" name="b2" onclick="closeAndRef()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
</tr>

</table>
</form>
<iframe id="empty" name="empty" marginheight="0" marginwidth="0" width="0" height="0"></iframe>
</body>
</html>