<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="headerbyopen.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value='/apps_res/meeting/js/meeting.js${v3x:resSuffix()}' />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
function init() {
	var status = "${bean.meetingRoomApp.status}";
	if(status != "0") {
		setReadOnly();
		
		$(".bg-advance-bottom").remove();
	}
}

function doSubmit(){
	if(checkForm(document.myForm)){
		if(confirm('<fmt:message key='mr.alert.confirmPerm'/>？')){
			document.myForm.submit();
		}
	}
}

function closeWindow(){
    window.close();
    var parentWindow = window.dialogArguments;
   	if(parentWindow == undefined) {
    	parentWindow = parent.window.dialogArguments;
   	}
    if(parentWindow == undefined) {
    	parentWindow = parent.parent.window.dialogArguments;
   	}
    if(parentWindow) {
    	if(parentWindow.closeAndFresh && typeof(parentWindow.closeAndFresh)=='function') {
        	parentWindow.window.closeAndFresh();
      	} else if(parentWindow.callback != null && parentWindow.callback){
        	parentWindow.callback();
    	}
	}
}
	
//isValid 人员是否是有效的，换句话说就是是否已经离职，离职不允许弹出人员卡片
function displayPeopleCard(memberId, isValid){
	if(!isValid || isValid == "false"){
    	return ;
  	}
	showV3XMemberCardWithOutButton(memberId, window);
}


function _submitCallback(errorMsg) {
	if(errorMsg != "") {
		alert(errorMsg);
	}
	refreshSection();
	if(window.dialogArguments && window.dialogArguments.callback) {
		window.dialogArguments.callback();
	} else if(window.dialogArguments && window.dialogArguments.dialogDealColl) {
		window.dialogArguments.dialogDealColl.close();
		window.dialogArguments.location.reload();
	} else if(window.dialogArguments) {
		window.dialogArguments.getA8Top().reFlesh();
		parent.window.close();
	} else {
		if(parent.window.listFrame) {
			parent.window.listFrame.location.reload();
		} else {
			parent.window.close();
		}
	}
}

//刷新待办首页或者待办更多
function refreshSection(){
	try{
		var _win = getA8Top().opener.getCtpTop().$("#main")[0].contentWindow;
		if (_win != undefined) {
  		if (_win.sectionHandler != undefined) {
  			_win.sectionHandler.reload("pendingSection",true);
          }
		}
		
        var _win = window.top.opener.$("#main")[0].contentWindow;
		if(_win){
			_win.closeAndFresh();
		}
		
	} catch(e){}
}

</script>
</head>
<body onload="init()" bgcolor="#f6f6f6" style="overflow: hidden;">

<form name="myForm" action="${mrUrl }?method=execPerm" method="post" target="hiddenIframe">
<input type="hidden" name="periodicityId" value="${periodicityId }" />
<input type="hidden" name="affairId" value="${affairId }" />
<input type="hidden" name="id" value="${bean.meetingRoomApp.id }" />
<input type="hidden" name="openWin" value="1" />

<div id="bottom_area" style="position:absolute; top:10px;bottom:50px;width:100%; overflow:auto;padding-top:10px;">

<table width="700" border="0" cellspacing="0" cellpadding="0" align="center">

<tr>
	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.meetingroomname'/>:</td>
	<td width="200" nowrap="nowrap" class="new-column" style="table-layout:fixed;word-break:break-all">
		<c:out value="${v3x:escapeJavascript(bean.meetingRoom.name) }"></c:out>
	</td>
	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.meetName'/>:</td>
	<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
	<c:if test="${bean.meetingName != null}">
		<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.meetName'/>" class="input-300px" value="${bean.meetingName}" readonly />
	</c:if>
	<c:if test="${bean.meetingName == null}">
		<fmt:message key='mr.label.no'/>
	</c:if>
	</td>
</tr>

<tr>
	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.appPerson'/>:</td>
	<c:set var="isProxy" value="${proxy?'proxy-true':'' }"/>
	<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
		<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.appPerson'/>" class="input-300px" value="${v3x:toHTML(v3x:showMemberNameOnly(bean.meetingRoomApp.perId))}" readonly />
	</td>
	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.appDept'/>:</td>
	<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
		<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.appDept'/>" class="input-300px" value="${v3x:toHTML(departmentName) }" readonly />
	</td>
</tr>

<c:choose>
<c:when test="${periodicityRoomAppList!=null && fn:length(periodicityRoomAppList)>0 }">
<tr>
	<td colspan="5" width="100%" nowrap="nowrap" class="bg-gray">
		<div <c:if test="${fn.length(periodicityRoomAppList) > 4}">style='border:0px;padding:3px; height:140px; LINE-HEIGHT: 20px; OVERFLOW: scroll;overflow-x:hidden;'</c:if>>
			<table width="101%">
				<c:forEach items="${periodicityRoomAppList}" var="app">
				<input type="hidden" name="roomAppId" value="${app.id }" />
				<tr>
					<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.startDatetime'/>:</td>
					<td width="35%" nowrap="nowrap" class="new-column">
						<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.startDatetime'/>" class="input-300px" disabled value="<fmt:formatDate value="${app.startDatetime}" pattern="yyyy-MM-dd HH:mm"/>" />
					</td>
					<td width="12%" nowrap="nowrap" class="bg-gray">&nbsp;&nbsp;&nbsp;<fmt:message key='mr.label.endDatetime'/>:</td>
					<td width="35%" nowrap="nowrap" class="new-column">
						<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.endDatetime'/>" class="input-300px" disabled value="<fmt:formatDate value="${app.endDatetime}" pattern="yyyy-MM-dd HH:mm"/>" />
					</td>
				</tr>
				</c:forEach>
			</table>
		</div>
	</td>
</tr>
</c:when>
<c:otherwise>
<tr>
	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.startDatetime'/>:</td>
	<td width="35%" nowrap="nowrap" class="new-column">
		<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.startDatetime'/>" class="input-300px" disabled value="<fmt:formatDate value="${bean.meetingRoomApp.startDatetime}" pattern="yyyy-MM-dd HH:mm"/>" />
	</td>
	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.endDatetime'/>:</td>
	<td width="35%" nowrap="nowrap" class="new-column">
		<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.endDatetime'/>" class="input-300px" disabled value="<fmt:formatDate value="${bean.meetingRoomApp.endDatetime}" pattern="yyyy-MM-dd HH:mm"/>" />
	</td>
</tr>
</c:otherwise>
</c:choose>

<tr>
	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.seatCount'/>:</td>
	<c:set var="isProxy" value="${proxy?'proxy-true':'' }"/>
	<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
		<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.seatCount'/>" class="input-300px" value="${bean.meetingRoom.seatCount}" readonly />
	</td>
	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.eqdescription'/>:</td>
	<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
		<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.eqdescription'/>" class="input-300px" value="${v3x:toHTML(bean.meetingRoom.eqdescription)}" readonly />
	</td>
</tr>
		
<tr>
	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.joinCount'/>:</td>
	<c:set var="isProxy" value="${proxy?'proxy-true':'' }"/>
	<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
		<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.joinCount'/>" class="input-300px" value="${count}" readonly />
	</td>
</tr>

<tr>
	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.meetingRoomUse'/>:</td>
	<td width="35%" nowrap="nowrap" class="new-column ${isProxy }" style="height:40px;">
		<textarea rows="2" cols="" name="app_description" style="width:100%;">${v3x:toHTML(bean.meetingRoomApp.description)}</textarea>
	</td>

	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.place'/>:</td>
	<c:set var="isProxy" value="${proxy?'proxy-true':'' }"/>
	<td width="35%" nowrap="nowrap" class="new-column ${isProxy }" style="vertical-align:top; padding-top:3px;">
		<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.place'/>" class="input-300px" value="${v3x:toHTML(bean.meetingRoom.place)}" readonly />
	</td>
</tr>
		
<tr>
	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key="mr.label.room.photo"/>:</td>
	<td width="35%" nowrap="nowrap" class="new-column" style="height: 170px">
	   <span style="width: 180px; height: 156px; text-align: center; ">
			<div id="thePicture1" style="width: 180px; height: 156px; text-align: center;border:1px #CCC solid;" >
				 <fmt:formatDate var="imageDate" pattern="yyyy-MM-dd" value="${imageObj==null?null:imageObj.createdate}" />
				 <c:choose>
				 	<c:when test="${!empty imageObj}">
                                 <html:link renderURL="/fileUpload.do?method=showRTE&fileId=${imageObj==null?null:imageObj.fileUrl }&createDate=${imageDate}&type=image" var="imgURL" />
				 		<img id="imageId" src="${imgURL}" width="180px;" height="156px;" />
				 	</c:when>
				 	<c:otherwise>
				 		<img id="imageId" src="<c:url value='/apps_res/meetingroom/images/no_picture.png'/>" width="180px;" height="156px;" />
				 	</c:otherwise>
				 </c:choose>
			</div>
		</span>
		<input type="hidden" id="image" name="image" value="${imageObj==null?null:imageObj.fileUrl }"/>
	</td>
	<%-- 会议用品 --%>
	<c:if test="${resourcesName!=''}">
	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key="mt.resource"/>:</td>
	<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
		<textarea name="asset_name" inputName="<fmt:message key='mt.resource'/>"style="width:302px;height: 156px; white-space:normal;" readonly >${resourcesName}</textarea>
	</td>
	</c:if>
</tr>
		
<tr>
	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key="mr.label.reviewPerson"/>:</td>
	<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
		<c:set var="isValid" value="${v3x:getMember(bean.meetingRoom.perId).isValid}"/>
		      <a href="#" onclick="displayPeopleCard('${bean.meetingRoom.perId }','${isValid}')" style="color:#000;">${v3x:showOrgEntitiesOfIds(peradmin, 'Member', '')}</a>
    	<c:if test="${not empty proxyName}">
        	<font color="red"> (<fmt:message key="mr.agent.label1"><fmt:param>${proxyName}</fmt:param></fmt:message>)</font>
		</c:if>
	</td>
</tr>
				
<tr>
	<td width="12%" nowrap="nowrap" class="bg-gray">&nbsp;</td>
	<td width="35%" colspan="3" nowrap="nowrap" class="new-column">
		<label for="permStatus1">
		<input type="radio" id="permStatus1" name="permStatus" value="1" ${bean.meetingRoomPerm.isAllowed != 2 ? "checked" : "" } />
		<fmt:message key='mr.label.allowed'/>&nbsp;&nbsp;</label>
		
		<label for="permStatus2">
		<input type="radio" id="permStatus2" name="permStatus" value="2" ${bean.meetingRoomPerm.isAllowed == 2 ? "checked" : "" } />
		<fmt:message key='mr.label.notallowed'/>
		</label>
	</td>
</tr>

<tr>
	<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.note'/>:</td>
	<td width="82%" colspan="3" nowrap="nowrap" class="new-column">
		<textarea name="description" inputName="<fmt:message key='mr.label.note'/>" validate="maxLength" maxSize="50" style="width:716px;height: 80px;">${bean.meetingRoomPerm.description }</textarea>
	</td>
</tr>

</table>
</div>

<div id="bottom_button_area" class="bg-advance-bottom border-top" align="center" style="position:absolute;bottom:0;width:100%;line-height:42px;background:#F3F3F3;">
	<input type="button" onclick="javascript:doSubmit()" class="button-default-2 button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" />&nbsp;
	<input type="button" onclick="javascript:closeWindow();" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" />
</div>

</form>

<iframe name="hiddenIframe" style="display:none"></iframe>

</body>
</html>
