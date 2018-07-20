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
</script>
</head>
<body>
<form action="${urlResource}?method=updateResource" id="updateResourceForm" name="updateResourceForm" method="post" onsubmit="return (checkForm(this) && remark())">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg" style="background-color: #f6f6f6;">
<input type="hidden" name="id" value="${resource.id }">
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
	<!-- 
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<c:if test="${oper != 'detail' }">
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="common.toolbar.update.label" bundle="${v3xCommonI18N}"/></td>
					</c:if>
					<c:if test="${oper == 'detail' }">
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="common.resource.detail"/></td>					
					</c:if>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;
					  <font color="red">*</font><fmt:message key='system.signet.title.must' bundle="${v3xSystemMarI18N}"/>
					</td>
				</tr>
			</table>
		</td>
	</tr>	
	 -->
	<tr>
		<td class="categorySet-head" style="padding: 0px 0px 0px 0px">
			<div class="categorySet-body">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
  	                  <TD class="bg-gray" width="25%" nowrap><font color="red">*</font><fmt:message key="common.resource.body.name.label"/>:&nbsp;&nbsp;</TD>
                      <TD class="new-column" width="75%" colspan="3">
                        <input inputName="<fmt:message key='common.resource.body.name.label'/>" validate="notNull" type="text" style = "width: 442px" input-100per" maxSize="50" maxLength="50" name="name" id="name" value='${resource.name }' <c:if test="${oper == 'detail' }">readonly</c:if> >                      
                      </TD>
					</tr>
					<!--  去掉类型
						<tr>
	  	                  <TD class="bg-gray , bbs-tb-padding-topAndBottom" width="25%" nowrap><font color="red">*</font><fmt:message key="common.resource.body.type.label"/>:&nbsp;&nbsp;</TD>
	                      <TD class="new-column , bbs-tb-padding-topAndBottom" colspan="3" nowrap>
				            <select name="type"  class="condition"	style="height: 23; width: 80" <c:if test="${oper == 'detail' }">disabled</c:if> >
					          <option value="office" <c:if test="${resource.type=='office' }">selected</c:if>><fmt:message key="mt.mtMeeting.room"  bundle="${v3xMeetingI18N}"/></option>
					          <option value="meetingres" <c:if test="${resource.type=='meetingres' }">selected</c:if>><fmt:message key='mt.resource' bundle="${v3xMeetingI18N}" /></option>
					          <option value="acc" <c:if test="${resource.type=='acc' }">selected</c:if>><fmt:message key="common.resource.type.acc" /></option>
					          <option value="equipment" <c:if test="${resource.type=='equipment' }">selected</c:if>><fmt:message key="common.resource.type.equipment" /></option>
					          <option value="car" <c:if test="${resource.type=='car' }">selected</c:if>><fmt:message key="common.resource.type.car" /></option>
					          <option value="data" <c:if test="${resource.type=='data' }">selected</c:if>><fmt:message key="common.resource.type.data" /></option>
					          
				            </select>
	                      </TD>
						</tr>
					-->			
					<tr>
  	                 <TD class="bg-gray" width="25%"  nowrap valign="top"><fmt:message key="common.resource.body.description.label"/>:&nbsp;&nbsp;</TD>
                     <TD class="new-column" colspan="3" nowrap>
                       <textarea name="description" id="description" inputName="<fmt:message key="common.resource.body.description.label"/>"  rows="6" cols="70" <c:if test="${oper == 'detail' }">readonly</c:if>>${resource.description }</textarea>                     
                     </TD>
					</tr>
				</table>
			</div>	
		</td>
	</tr>
</table>
<c:if test="${oper != 'detail' }">
	<div align="center" class="bg-advance-bottom border-top" style="height:42px;width:100%;position:absolute;left:0;bottom:0;line-height:42px;background:#F3F3F3;">
		<input type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize margin_t_10">&nbsp;
		<input type="button" onclick="cancelForm('updateResourceForm')" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2 margin_t_10">
	</div>
</c:if>
</form>
</body>
</html>
