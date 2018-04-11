<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<c:set var="path" value="${pageContext.request.contextPath}" />
<script type="text/javascript">
function cancelForm(form){
 	document.getElementById(form).action= "${path}/common/detail.jsp";
	document.getElementById(form).submit();
}

function remark(){
    var patrn = /^[^\|#￥%&+<>"']*$/;
    var nameObj = document.getElementById("name");
    var descriptionObj = document.getElementById("description");
    var _name = nameObj.value;
    var _description = descriptionObj.value;
    var name_inputName = nameObj.getAttribute("inputName");
    var description_inputName = descriptionObj.getAttribute("inputName");
    var value=document.updateResourceForm.description.value.length;
    if(!patrn.test(_name)){
        alert(name_inputName + v3x.getMessage("meetingLang.meeting_noAllowed_character"));
        return false;
    }
    if(!patrn.test(_description)){
        alert(description_inputName + v3x.getMessage("meetingLang.meeting_noAllowed_character"));
        return false;
    }
	if(value>500){
        alert(v3x.getMessage("MainLang.resource_description_maxlength_flow"));
	    return false;
	}  
}

function _submitCallback(msgType, msg) {
	if(msgType == "success") {
		parent.parent.location.reload();
	} else {
		if(msg != "") {
			alert(msg);
			document.all.submitBtn.disabled = false;
		}
	}
}

</script>
</head>
<body>
<form action="meetingResource.do?method=execAdd" id="updateResourceForm" name="updateResourceForm" method="post" onsubmit="return (checkForm(this) && remark())" target="hiddenIframe">
<input type="hidden" name="id" value="${_publicResourceObj.id }">

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg" style="background-color: #f6f6f6;">

<tr align="center">
	<td height="8" class="detail-top">
		<script type="text/javascript">
			getDetailPageBreak(); 
		</script>
	</td>
</tr>	

<tr>
	<td class="categorySet-4" height="8"></td>
</tr>

<tr>
	<td class="categorySet-head" style="padding: 0px 0px 0px 0px">
		<div class="categorySet-body">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
 	                  <TD class="bg-gray" width="25%" nowrap><font color="red">*</font><fmt:message key="common.resource.body.name.label"/>:&nbsp;&nbsp;</TD>
                     <TD class="new-column" width="75%" colspan="3">
                       <input inputName="<fmt:message key='common.resource.body.name.label'/>" validate="notNull" type="text" style = "width: 442px" input-100per" maxSize="50" maxLength="50" name="name" id="name" value='${_publicResourceObj.name }' <c:if test="${oper == 'detail' }">readonly</c:if> >                      
                     </TD>
				</tr>
					
				<tr>
 	                 <TD class="bg-gray" width="25%"  nowrap valign="top"><fmt:message key="common.resource.body.description.label"/>:&nbsp;&nbsp;</TD>
                    <TD class="new-column" colspan="3" nowrap>
                      <textarea name="description" id="description" inputName="<fmt:message key="common.resource.body.description.label"/>"  rows="6" cols="70" <c:if test="${oper == 'detail' }">readonly</c:if>>${_publicResourceObj.description }</textarea>                     
                    </TD>
				</tr>
			</table>
		</div>	
	</td>
</tr>

</table>

<c:if test="${oper != 'detail' }">
	<div align="center" class="bg-advance-bottom border-top" style="height:42px;width:100%;position:absolute;left:0;bottom:22px;line-height:42px;background:#F3F3F3;">
		<input type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize margin_t_10">&nbsp;
		<input type="button" onclick="document.location='<c:url value="/common/detail.jsp" />';" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2 margin_t_10">
	</div>
</c:if>

</form>

<iframe id="hiddenIframe" name="hiddenIframe" style="display:none;with:0px;height:0px;"></iframe>

</body>
</html>
