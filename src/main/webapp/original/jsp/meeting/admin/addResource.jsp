<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<html>
<head>
<link rel="stylesheet" type="text/css" href="<c:url value='/apps_res/systemmanager/css/css.css${v3x:resSuffix()}' />">
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
    if(_name.trim().length < 1){
		alert(v3x.getMessage("meetingLang.meeting_cantbe_null"));
		return false;
	}
    var _description = descriptionObj.value;
    var name_inputName = nameObj.getAttribute("inputName");
    var description_inputName = descriptionObj.getAttribute("inputName");
	var value=document.addResourceForm.description.value.length;
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
	document.all.submitBtn.disabled = true;
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
<body scroll="no" style="overflow: no">

<form action="meetingResource.do?method=execAdd" id="addResourceForm" name="addResourceForm" method="post" onsubmit="return remark();" target="hiddenIframe">
<input type="hidden" name="id">

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
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
	<td id="categorySetId" class="categorySet-head" style="padding: 0px 0px 0px 0px;border:0px 0px 0px 0px;overflow-y:hidden;">
		<div id="categorySetBody" class="categorySet-body border-top border-right border-bottom">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
 	           		<TD class="bg-gray" width="30%" nowrap><font color="red">*</font><fmt:message key="common.resource.body.name.label"/>:&nbsp;&nbsp;</TD>
                    <TD class="new-column" width="40%">
                       	<input inputName="<fmt:message key='common.resource.body.name.label'/>" validate="notNull" type="text" class="input-100per" name="name" id="name" maxSize="50" maxLength="50">                      
                    </TD>
                    <td width="30%"></td>
				</tr>		
				<tr>
 	               	<TD class="bg-gray" nowrap valign="top"><fmt:message key="common.resource.body.description.label"/>:&nbsp;&nbsp;</TD>
                    <TD class="new-column" >
                      	<textarea class="input-100per" name="description" validate="maxLength" inputName="<fmt:message key="common.resource.body.description.label"/>" maxSize="30" id="description" rows="6" cols=""></textarea>                     
                    </TD>
                   	<td></td>
				</tr>
			</table>
		</div>		
	</td>
</tr>
</table>

<div align="center" class="bg-advance-bottom border-top" style="height:42px;width:100%;position:absolute;left:0;bottom:0px;line-height:42px;background:#F3F3F3;">
	<input type="submit" name="submitBtn" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize margin_t_5">&nbsp;
	<input type="button" onclick="document.location='<c:url value="/common/detail.jsp" />';" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2 margin_t_5" >
</div>

</form>

<iframe id="hiddenIframe" name="hiddenIframe" style="display:none;with:0px;height:0px;"></iframe>

</body>
</html>
