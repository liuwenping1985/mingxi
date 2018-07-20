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
</script>
</head>
<body scroll="no" style="overflow: no">
<form action="${urlResource}?method=addResource" id="addResourceForm" name="addResourceForm" method="post" onsubmit="return remark();">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
<input type="hidden" name="id">

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
	<!-- <tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="common.toolbar.new.label" bundle="${v3xCommonI18N}" /></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;
					  <font color="red">*</font><fmt:message key='system.signet.title.must' bundle="${v3xSystemMarI18N}"/>
					</td>
				</tr>
			</table>
		</td>
	</tr> -->
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
					<!--  去掉类型  2008-3-19 xut
						<tr>
	  	                  <TD class="bg-gray" nowrap><font color="red">*</font><fmt:message key="common.resource.body.type.label"/>:&nbsp;&nbsp;</TD>
	                      <TD class="new-column" nowrap>
				            <select name="type"  class="condition"	style="height: 23; width: 80">
					          <option value="office"><fmt:message key="mt.mtMeeting.room"  bundle="${v3xMeetingI18N}"/></option>
					          <option value="meetingres"><fmt:message key='mt.resource' bundle="${v3xMeetingI18N}" /></option>
					          <option value="acc"><fmt:message key="common.resource.type.acc" /></option>
					          <option value="equipment"><fmt:message key="common.resource.type.equipment" /></option>
					          <option value="car"><fmt:message key="common.resource.type.car" /></option>
					          <option value="data"><fmt:message key="common.resource.type.data" /></option>
					          
				            </select>
	                      </TD>
	                      <td></td>
						</tr>
					-->				
					<tr>
  	                 <TD class="bg-gray" nowrap valign="top"><fmt:message key="common.resource.body.description.label"/>:&nbsp;&nbsp;</TD>
                     <TD class="new-column" nowrap>
                       <textarea class="input-100per" name="description" validate="maxLength" inputName="<fmt:message key="common.resource.body.description.label"/>" maxSize="300" id="description" rows="6" cols=""></textarea>                     
                     </TD>
                     <td></td>
					</tr>
				</table>
			</div>		
		</td>
	</tr>
	<%-- <tr>
		<td height="42" align="center" class="bg-advance-bottom border-top" style="position:absolute;bottom:0;width:100%;line-height:42px;background:#F3F3F3;">
			<input type="submit" name="submitBtn" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
			<input type="button" onclick="cancelForm('addResourceForm')" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2" >
		</td>
	</tr> --%>
</table>
<div align="center" class="bg-advance-bottom border-top" style="height:42px;width:100%;position:absolute;left:0;bottom:-1;line-height:42px;background:#F3F3F3;">
            <input type="submit" name="submitBtn" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize margin_t_10">&nbsp;
            <input type="button" onclick="cancelForm('addResourceForm')" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2 margin_t_10" >
</div>
</tr>        
</form>
</body>
</html>
