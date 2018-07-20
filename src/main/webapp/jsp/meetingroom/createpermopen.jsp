<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<%@ include file="headerbyopen.jsp" %>
		<script type="text/javascript" charset="UTF-8" src="<c:url value='/apps_res/meeting/js/meeting.js${v3x:resSuffix()}' />"></script>
        <script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript">
		function init(){
			var readOnly = "${readOnly}";
			var isAllowed = "${bean.isAllowed}";
			if(readOnly == "true"){
				setReadOnly();
			}
			if(isAllowed != "${MRConstants.Status_App_Wait}"){
				setReadOnly();
			}
		}
		function doSubmit(){
			if(checkForm(document.myForm)){
				if(confirm('<fmt:message key='mr.alert.confirmPerm'/>？')){
					document.myForm.submit();
				}
			}
		}

		function closeWin(){
		    window.close();
		    var parentWindow = window.dialogArguments;
            if(parentWindow == undefined) {
                parentWindow = parent.window.dialogArguments;
            }
            if(parentWindow == undefined) {
                parentWindow = parent.parent.window.dialogArguments;
            }
            if(parentWindow){
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
		</script>
	</head>
	<body onload="init()" bgcolor="#f6f6f6" style="overflow: auto;">
<form name="myForm" action="${mrUrl }?method=execPerm" method="post" target="hiddenIframe">
<input type="hidden" name="periodicityInfoId" value="${param.periodicityInfoId }" />
<input type="hidden" value="${affairId }" name="affairId" />
<input type="hidden" name="id" value="${bean.appId }" /><input type="hidden" name="openWin" value="1" />
<table class="popupTitleRight" border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td height="20" class="PopupTitle">
			<c:if test="${isPeriodicity == 'true'}"><fmt:message key='mt.periodic' bundle='${v3xMeetingI18N}'/></c:if>
			<fmt:message key='mr.tab.perm'/>
		</td>
	</tr>
	<tr class="bg-advance-middel">
		<td class="categorySet-head"><div style="padding-bottom: 10px;padding-top: 10px;background-color: rgb(255, 255, 255);overflow: auto">
		<table width="700" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.meetingroomname'/>:</td>
			<td width="200" nowrap="nowrap" class="new-column" style="table-layout:fixed;word-break:break-all">
				<c:out value="${bean.meetingRoomApp.meetingRoom.name }"></c:out>
			</td>
			<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.meetName'/>:</td>
			<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
			<c:if test="${bean.meetingRoomApp.meeting!=null}">
			<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.meetName'/>" class="input-300px" value="${bean.meetingRoomApp.meeting.title}" readonly />
			</c:if>
			<c:if test="${bean.meetingRoomApp.meeting==null}">
			<fmt:message key='mr.label.no'/>
			</c:if>
			</td>
		</tr>
		<tr>
			<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.appPerson'/>:</td>
			<c:set var="isProxy" value="${proxy?'proxy-true':'' }"/>
			<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
				<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.appPerson'/>" class="input-300px" value="${v3x:showMemberNameOnly(bean.meetingRoomApp.perId)}" readonly />
			</td>
			<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.appDept'/>:</td>
			<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
				<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.appDept'/>" class="input-300px" value="${departmentName }" readonly />
			</td>
		</tr>
		<c:if test="${isPeriodicity == 'false'}">
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
		</c:if>

		<c:if test="${isPeriodicity == 'true'}">
		<tr>
		<td colspan="5" width="100%" nowrap="nowrap" class="bg-gray">

		<div <c:if test="${appSize>4}">style='border:0px;padding:3px; height:140px; LINE-HEIGHT: 20px; OVERFLOW: scroll;overflow-x:visible;'</c:if>>
		<table width="101%">
			<c:forEach items="${appList}" var="app">
			<tr>
				<td width="15%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.startDatetime'/>:</td>
				<td width="40%" nowrap="nowrap" class="new-column">
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
		</c:if>


		<tr>
			<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.seatCount'/>:</td>
			<c:set var="isProxy" value="${proxy?'proxy-true':'' }"/>
			<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
				<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.seatCount'/>" class="input-300px" value="${bean.meetingRoomApp.meetingRoom.seatCount}" readonly />
			</td>
			<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.eqdescription'/>:</td>
			<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
				<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.eqdescription'/>" class="input-300px" value="${bean.meetingRoomApp.meetingRoom.eqdescription}" readonly />
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
			<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.place'/>:</td>
			<c:set var="isProxy" value="${proxy?'proxy-true':'' }"/>
			<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
				<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.place'/>" class="input-300px" value="${bean.meetingRoomApp.meetingRoom.place}" readonly />
			</td>
			<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.meetingRoomUse'/>:</td>
			<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
				<input type="text" name="asset_name" inputName="<fmt:message key='mr.label.meetingRoomUse'/>" class="input-300px" value="${v3x:toHTML(bean.meetingRoomApp.description)}" readonly />
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
							 		<img id="imageId" src="/seeyon/fileUpload.do?method=showRTE&fileId=${imageObj==null?null:imageObj.fileUrl }&createDate=${imageDate}&type=image" width="180px;" height="156px;" />
							 	</c:when>
							 	<c:otherwise>
							 		<img id="imageId" src="<c:url value='/apps_res/meetingroom/images/no_picture.png'/>" width="180px;" height="156px;" />
							 	</c:otherwise>
							 </c:choose>
						</div>
					</span>
					<input type="hidden" id="image" name="image" value="${imageObj==null?null:imageObj.fileUrl }"/>
			</td>
		</tr>
		<tr>
		<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key="mr.label.reviewPerson"/>:</td>
			<td width="35%" nowrap="nowrap" class="new-column ${isProxy }">
                <c:set var="isValid" value="${v3x:getMember(bean.meetingRoomApp.meetingRoom.perId).isValid}"/>
				<a href="#" onclick="displayPeopleCard('${bean.meetingRoomApp.meetingRoom.perId }','${isValid}')"  style="color:#000;">${v3x:showOrgEntitiesOfIds(peradmin, 'Member', '')}</a>
                <c:if test="${not empty proxyName}">
                <font color="red"> (<fmt:message key="mr.agent.label1"><fmt:param>${proxyName}</fmt:param></fmt:message>)</font>
                </c:if>
			</td>
		</tr>
				<tr>
					<td width="12%" nowrap="nowrap" class="bg-gray">&nbsp;</td>
					<td width="35%" colspan="3" nowrap="nowrap" class="new-column">
						<label for="permStatus1">
						<input type="radio" id="permStatus1" name="permStatus" value="${MRConstants.Status_App_Yes }"
						<c:if test="${bean.isAllowed == MRConstants.Status_App_Yes }">checked</c:if>
						<c:if test="${bean.isAllowed == MRConstants.Status_App_Wait && readOnly != 'true' }">checked</c:if>
						/>
						<c:if test="${isPeriodicity == 'true'}"><fmt:message key='mr.label.all'/></c:if><fmt:message key='mr.label.allowed'/>&nbsp;&nbsp;</label>
						<label for="permStatus2">
						<input type="radio" id="permStatus2" name="permStatus" value="${MRConstants.Status_App_No}"
						<c:if test="${bean.isAllowed == MRConstants.Status_App_No }">checked</c:if> />
						<c:if test="${isPeriodicity == 'true'}"><fmt:message key='mr.label.all'/></c:if><fmt:message key='mr.label.notallowed'/>
						</label>
					</td>
				</tr>
				<tr>
					<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.note'/>:</td>
					<td width="82%" colspan="3" nowrap="nowrap" class="new-column">
						<textarea name="description" inputName="<fmt:message key='mr.label.note'/>" validate="maxLength" maxSize="50" style="width:716px;height: 80px;">${bean.description }</textarea>
					</td>
				</tr>
		</table>
		</div>
		</td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="button" onclick="doSubmit()" class="button-default-2 button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" />&nbsp;
			<input type="button" class="button-default-2" onclick="closeWin();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" />
		</td>
	</tr>
</table>
</form>
<iframe name="hiddenIframe" style="display:none"></iframe>
	</body>
</html>
