<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
<c:if test="${editFlag == true}">
<fmt:message key="doc.jsp.alert.title.edit" />
</c:if>
<c:if test="${editFlag == false}">
<fmt:message key="doc.jsp.alert.title.add" />
</c:if>
</title>
<script type="text/javascript">
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

   var commentEnable = "${commentEnable}";
   var chforum = document.getElementById("check_box_forum");

    if(commentEnable!=null&&commentEnable=="false") {
       chforum.checked = false;
	   chforum.disabled = true;
	 }

}

function OK(){
	docalert('${docResId}', '${isFolder}');
}
</script>

</head>
<body scroll="no" style="overflow:hidden" onkeydown="listenerKeyESC()" onload = "forumAble()">
<c:set var="hasForum" value="${not docOpenFlag ? 'style=\"display: none;\"':''}"/>
<form name="mainForm" id="mainForm" action="" method="post"  target="alertIframe">
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td  height="20" class="PopupTitle" colspan="2" nowrap="nowrap"><fmt:message key="doc.jsp.alert.object" />:&nbsp;&nbsp;${v3x:getLimitLengthString(v3x:_(pageContext, name), 25,'...')}</td>
		</tr>
		
		<tr height="100"><td colspan="2" align="center">		
			<fieldset style="width:85%" align="center"><legend><strong>
				<c:if test="${editFlag == true}">
				<fmt:message key="doc.jsp.alert.title.edit" />
				</c:if>
				<c:if test="${editFlag == false}">
				<fmt:message key="doc.jsp.alert.title.add" />
				</c:if>
			</strong></legend>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">	
		
		<c:if test="${isFolder == 'true'}">		
		<tr>
						<td height="40">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="check_box_add">
					<input type="checkbox" name="check_box_add" id="check_box_add" 
					value="true"   <c:if test="${vo.add == true}"> checked </c:if>
					<c:if test="${editFlag == false}"> checked </c:if> >
					<fmt:message key="doc.jsp.alert.add" />					
				</label>
			</td>
						<td height="40">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="check_box_edit">
					<input type="checkbox" name="check_box_edit" id="check_box_edit" 
					value="true" <c:if test="${vo.edit == true}"> checked </c:if>
					 <c:if test="${editFlag == false}"> checked </c:if> >
					<fmt:message key="doc.jsp.alert.edit" />					
				</label>
			</td>
		</tr>
		
		<tr>			<td height="40">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="check_box_delete">
					<input type="checkbox" name="check_box_delete" id="check_box_delete" 
					value="true" onclick="" <c:if test="${vo.delete == true}"> checked </c:if>
					 <c:if test="${editFlag == false}"> checked </c:if> >
					<fmt:message key="doc.jsp.alert.delete" />						
				</label>
			</td>
						<td height="40" ${hasForum}>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="check_box_forum">
					<input type="checkbox" name="check_box_forum" id="check_box_forum" 
					value="true" <c:if test="${vo.forum == true}"> checked </c:if>
					 <c:if test="${editFlag == false}"> checked </c:if> >
					<fmt:message key="doc.jsp.alert.forum" />					
				</label>
			</td></tr>
		</c:if>
		
				<c:if test="${isFolder == 'false'}">		
		<tr>
						<td height="40">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="check_box_edit">
					<input type="checkbox" name="check_box_edit" id="check_box_edit" 
					value="true"  <c:if test="${vo.edit == true}"> checked </c:if>
					 <c:if test="${editFlag == false}"> checked </c:if> >
					<fmt:message key="doc.jsp.alert.edit" />					
				</label>
			</td>
						<td height="40">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="check_box_delete">
					<input type="checkbox" name="check_box_delete" id="check_box_delete" 
					value="true" onclick="" <c:if test="${vo.delete == true}"> checked </c:if>
					 <c:if test="${editFlag == false}"> checked </c:if> >
					<fmt:message key="doc.jsp.alert.delete" />					
				</label>
			</td>
		</tr>
		
		<tr>			<td height="40" ${hasForum}>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="check_box_forum">
					<input type="checkbox" name="check_box_forum" id="check_box_forum" 
					value="true"  <c:if test="${vo.forum == true}"> checked </c:if>
					 <c:if test="${editFlag == false}"> checked </c:if> >
					<fmt:message key="doc.jsp.alert.forum" />					
				</label>
			</td>
						<td height="40">&nbsp;
			</td></tr>
		</c:if>

		</table>
			</fieldset>
		</td></tr>
		
		
		<tr >
			<td colspan="2" height="40" valign="top">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="check_box_message">
					<input type="checkbox" name="check_box_message" id="check_box_message" 
					value="true" <c:if test="${vo.sendMessage == true}"> checked </c:if>
					
					 <c:if test="${editFlag == false}"> checked </c:if> >
					<fmt:message key="doc.jsp.alert.message.send" />					
				</label>
	<!--			<c:if test="${isFolder == 'false'}">
				<label for="check_box_subFolder" class="hidden">
									<input type="checkbox" name="check_box_subFolder" id="check_box_subFolder" 
					value="true"  >
					<fmt:message key="doc.jsp.alert.subFolde" />					
				</label>
				</c:if>
				<c:if test="${isFolder == 'true'}">
				<label for="check_box_subFolder">
									<input type="checkbox" name="check_box_subFolder" id="check_box_subFolder" 
					value="true" <c:if test="${vo.setSubFolder == true}"> checked </c:if>
		         	  <c:if test="${editFlag == false}"> checked </c:if> >
					<fmt:message key="doc.jsp.alert.subFolde" />					
				</label>
				</c:if>				    -->

			</td>
		</tr>
		
		<c:if test="${v3x:getBrowserFlagByRequest('HideButtons', pageContext.request)}">		
		<tr height="42">
			<td align="right" class="bg-advance-bottom" colspan="2">
				<input type="button" name="b1" onclick="docalert('${docResId}', '${isFolder}')" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
				<input type="button" name="b2" onclick="window.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
		</c:if>
	</table>

</form>

<iframe name="alertIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"/>

</body>
</html>