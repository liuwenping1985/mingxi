<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" " http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.meeting.manager.MtMeetingManagerImpl"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.meetingroom.resources.i18n.MeetingRoomResources" var="mtRoom" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--

//当自己申请的会议审核人选为自己时，为了不在待审核列表中点击一行后出现的 会议申请详细页面中直接进行审批
//需要特别定义一个变量
notApprove = 2;

window.onload = function(){
}

try {
  if(getA8Top() != null){
	getA8Top().endProc('');
  }
	parent.treeFrame.changeHandler("${param.listType}");
} catch(e) {}

//当前位置
if(getA8Top()!=null && typeof(getA8Top().showLocation)!="undefined") {
<c:choose>
	<c:when test="${param.listType=='listMyAppMeetingWaitVarificate'}">//待审核
		getA8Top().showLocation(2101, "<fmt:message key='mt.mtMeeting.application.label'/>", "<fmt:message key='mt.list.column.type.10'/>");
	</c:when>
	<c:when test="${param.listType=='listMyAppMeetingVarificated'}">//审核通过
		getA8Top().showLocation(2101, "<fmt:message key='mt.mtMeeting.application.label'/>", "<fmt:message key='mt.list.column.type.20'/>");
	</c:when>
	<c:when test="${param.listType=='listMyAppMeetingNotVarificate'}">//审核不通过
		getA8Top().showLocation(2101, "<fmt:message key='mt.mtMeeting.application.label'/>", "<fmt:message key='mt.list.column.type.30'/>");
	</c:when>
	<c:when test="${param.listType=='listMyAppMeeting'}">//我审请的会议
		getA8Top().showLocation(2101, "<fmt:message key='mt.mtMeeting.application.label'/>", "<fmt:message key='mr.tab.yesApp' bundle='${mtRoom}'/>");
	</c:when>
	<c:when test="${param.listType=='listMyAppMeetingDraft'}">//我审请的会议
		getA8Top().showLocation(2101, "<fmt:message key='mt.mtMeeting.application.label'/>", "<fmt:message key='admin.label.drafts' />");
	</c:when>
</c:choose>
}
	
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	
	//发布
	<c:if test="${listType=='listMyAppMeetingVarificated' || listType=='listMyAppMeeting'}">
	myBar.add(
		new WebFXMenuButton(
			"convoked", 
			"<fmt:message key='mt.list.toolbar.publish.label'/>",  
			"javascript:publishAppMeeting();", 
			[1,4], 
			"", 
			null
			)
	);
	</c:if>
	
	//编辑
	<c:if test="${listType!='listMyAppMeetingVarificated' && listType!='listMyAppMeetingVarificating' && listType!='listMyAppMeetingWaitVarificate' && listType!='listMyAppMeeting'}">
	myBar.add(
		new WebFXMenuButton(
			"convoked", 
			"<fmt:message key='common.toolbar.edit.label' bundle='${v3xCommonI18N}'/>",  
			"javascript:editAppMeeting();", 
			[1,2], 
			"", 
			null
			)
	);
	</c:if>
		
	//撤销 已通过的可以进行撤销
	/* puyc 修改 2012-2-9*/
	<c:if test="${listType!='listMyAppMeetingDraft' && listType!='listMyAppMeetingNotVarificate'}">
	myBar.add(
		new WebFXMenuButton(
			"convoked", 
			"<fmt:message key='common.toolbar.cancel.label' bundle='${v3xCommonI18N}'/>",  
			"javascript:actionAppMeeting('cancelAppMeeting');", 
			[3,8], 
			"", 
			null
			)
	);
	</c:if>
	
	//删除
	<c:if test="${listType=='listMyAppMeetingDraft' || listType=='listMyAppMeetingNotVarificate'}">
	myBar.add(
		new WebFXMenuButton(
			"convoked", 
			"<fmt:message key='mt.list.toolbar.delete.label'/>",  
			"javascript:actionAppMeeting('deleteAppMeeting');", 
			[1,3], 
			"", 
			null
			)
	);
	</c:if>

baseUrl='mtAppMeetingController.do?method=';	
var ht = new Hashtable();
var createUserIdTable = new Hashtable();
var userInternalID = "${sessionScope['com.seeyon.current_user'].id}";
	
function selectDateTime(whoClick){
	    var date = whenstart('${pageContext.request.contextPath}', whoClick, 575,140);
	    var newDate = new Date();
	    var strDate = newDate.getYear()+"-"+(newDate.getMonth()+1)+"-"+newDate.getDate();
	    strDate = formatDate(strDate);
	    if(whoClick.id=='fromDate'){
	      if(document.getElementById('toDate').value!="" && 
	        date>document.getElementById('toDate').value){
	        alert(v3x.getMessage("meetingLang.checkdate_startdoesnotlateend"));
	      }
	      else if(null!=date){
	         whoClick.value = date;
	      }
	    }
	    if(whoClick.id=='toDate'){
	      if(document.getElementById('fromDate').value!="" && 
	        date<document.getElementById('fromDate').value){
	        alert(v3x.getMessage("meetingLang.checkdate_enddoeslatestart"));
	      }
	      else if(null!=date&&date!=""){
	         whoClick.value = date;
	      }
	    }   
    }

function actionAppMeeting(actionMethod) {   
		var ids = document.getElementsByName('id');
		var id = '';
		var id2 = '';
		var mIds = [];
		var len = 0;
		var flag = false;
		var confirmMsg = v3x.getMessage("meetingLang.sure_to_delete");
	
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			
			if(idCheckBox.checked){

				//已发布为通知不能撤销
				if(idCheckBox.approveState==60) {
					alert(v3x.getMessage("meetingLang.meeting_list_toolbar_publish_notCancel_alert"));
					return;
				}

				
				//只有创建者可以删除会议
				if(userInternalID!=createUserIdTable.items(idCheckBox.value)){
					alert(v3x.getMessage("meetingLang.you_not_creater"));
					return;
				}
				mIds[len] = idCheckBox.value;
				len++;
				id=id+idCheckBox.value+'&';
				id2 += idCheckBox.value+",";

				//if(idCheckBox.approveState!=10 && idCheckBox.approveState!=20 && idCheckBox.approveState!=30 && idCheckBox.approveState!=50) {
				if(actionMethod=="cancelAppMeeting") {
					if(idCheckBox.approveState==30) {//撤销条件
						flag = false;//xiangfan 审核未通过的会议可以撤销
						//confirmMsg = v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert4");
					}
					if(idCheckBox.approveState==0 || idCheckBox.approveState==40) {//撤销条件
						flag = true;
						confirmMsg = v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert");
					}

					
				} 
				
			}
		}
		if(id==''){
			alert(v3x.getMessage("meetingLang.choose_item_from_list"));
			return;
		}
		if(actionMethod=='cancelAppMeeting') {
			if(len > 1) {
				alert(v3x.getMessage("meetingLang.not_choose_more_app_item_from_list"));
				return;
			}
			if(flag) {
				confirmMsg = v3x.getMessage("meetingLang.meeting_list_toolbar_not_cancel_alert");
				alert(confirmMsg);
				return;
			}
			
			//mark by xuqiangwei Chrome37修改，这里应该被废弃了
			var returnValue = v3x.openWindow({
		        url: "${controller}?method=showAppMeetingCancelAppendex",
		        dialogType : "modal",
		        width: "400",
		        height: "265"
	    	});
    	if(returnValue!=null) {
	    	var myform = document.createElement("form");
	    	myform.action =  "${controller}";
	    	myform.method =  "post";
	    	myform.innerHTML = "";
	    	for(var k=0; k<mIds.length; k++) {
	    		myform.innerHTML += "<input name='id' type='hidden' value='"+mIds[k]+"' />";		
	    	}	    	
	    	myform.innerHTML += "<input name='method' type='hidden' value='"+actionMethod+"' />";
	    	myform.innerHTML += "<input name='listType' type='hidden' value='${listType}' />";
	    	myform.innerHTML += "<textarea name='content' type='hidden' value='"+returnValue+"'>"+returnValue+"</textarea>";	
	    	document.appendChild(myform);
	    	myform.submit();
    	}
		} else {
			if(confirm(confirmMsg)) {
				 window.location.href = '${controller}?&id='+id2+'&method='+actionMethod+'&listType=${listType}';
			}
		}
}

function publishAppMeeting(actionMethod) {
	var ids = document.getElementsByName('id');
	var id = '';
	var len = 0;
	var flag = false;
	var alertMessage = "";
	var mtAppId;
	for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				//只有创建者可以删除会议
				if(userInternalID!=createUserIdTable.items(idCheckBox.value)){
					alert(v3x.getMessage("meetingLang.you_not_creater"));
					return;
				}
				len++;
				id=id+idCheckBox.value+'&';

				if(idCheckBox.approveState==60) {
					alertMessage = v3x.getMessage("meetingLang.meeting_list_toolbar_publish_notRepeat_alert");
					flag = true;
					break; 
				}
				
				if(idCheckBox.approveState!=20) {
					 alertMessage = v3x.getMessage("meetingLang.meeting_list_toolbar_publish_passing_alert");
					 flag = true;
					 break; 
				}
				
				mtAppId = idCheckBox.value;
			}
		}
		if(id==''){
			alert(v3x.getMessage("meetingLang.choose_item_from_list"));
			return;
		}
		if(len > 1) {
				alert(v3x.getMessage("meetingLang.meeting_list_toolbar_only_choose_one_toPublish"));
				return;
		}	
		if(flag){
				alert(alertMessage);
		}else{
			var menuId = '${param.menuId}';
			//parent.listFrame.location.href = '${controller}?&id='+id+"&method=publishMeeting&menuId="+menuId+"&listType=listMyAppMeeting&mtAppId="+mtAppId;

			parent.parent.location.href =	  "mtMeeting.do?method=listHome&menuId="+menuId+"&listMethod=create&listType=listNoticeMeeting&from=listNoticeCreate&sendType=publishAppToMt" +
				"&mtAppId="+id;

		}
}

function editAppMeeting(actionMethod) {
	var ids = document.getElementsByName('id');
	var id = '';
	var len = 0;
	var flag = false;
	var alertMessage = "";
	var mtState;
	for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				mtState = idCheckBox.approveState;


				//已发布为通知不能撤销
				if(idCheckBox.approveState==60) {
					alert(v3x.getMessage("meetingLang.meeting_list_toolbar_publish_notEdit_alert"));
					return;
				}

				
				//只有创建者可以编辑会议
				if(userInternalID!=createUserIdTable.items(idCheckBox.value)){
					alert(v3x.getMessage("meetingLang.you_not_creater"));
					return;
				}
				len++;
				id=id+idCheckBox.value+'&';
				if(idCheckBox.approveState==20 || idCheckBox.approveState==50) {
					 if(idCheckBox.approveState==20) {
					 	alertMessage = v3x.getMessage("meetingLang.meeting_list_toolbar_edit_pass_alert");
					 } else {
					 	alertMessage = v3x.getMessage("meetingLang.meeting_list_toolbar_edit_passing_alert");
					 }
					 flag = true;
				}
			}
		}
		if(id==''){
			alert(v3x.getMessage("meetingLang.choose_item_from_list"));
			return;
		}
		if(len > 1) {
			alert(v3x.getMessage("meetingLang.meeting_list_toolbar_only_choose_one_toEdit"));
			return;
		}

		if(flag){
			alert(alertMessage);
		}else{
				var url = baseUrl+'edit&id='+id+"&listType=${listType}";
				if(mtState == 30)url += "&addApprove=true";
				window.location.href= url;
		}
}
    //-->
</script>
</head>
<body onload="">
<div class="main_div_row2">
<div class="right_div_row2">
<div class="top_div_row2">
<table width="100%" height="100%" border="0" cellspacing="0"
	cellpadding="0">
	<tr>
		<td class="webfx-menu-bar">
		<script
			type="text/javascript">
				document.write(myBar);	
			</script>
		</td>
		<td class="webfx-menu-bar">
		<form action="${controller}" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
		<input type="hidden" value="<c:out value='${param.method}' />" name="method">
		<input type="hidden" value="${param.stateStr}" name="stateStr" />
		<input type="hidden" value="${listType}" name="listType"/>
		<div class="div-float-right condition-search-div">
		<div class="div-float">
			<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
					<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
					<option value="title"><fmt:message key="mt.list.column.mt_name" /></option>
					<option value="meetingTypeId"><fmt:message key="mt.list.column.mt_type" /></option>
					<option value="createDate"><fmt:message key="mt.searchdate" /></option>
					<c:if test="${listType=='listMyAppMeetingDraft'}">
					<option value="approveState"><fmt:message key="mt.mtType.label" /></option>	
					</c:if>
			</select>
			</div>

			<div id="titleDiv" class="div-float hidden">
				<input type="text" name="textfield" class="textfield">
			</div>
		
			<div id="meetingTypeIdDiv" class="div-float hidden">
			<select name="textfield" id="textfield" class="textfield">
				<c:forEach var="meetingType" items="${typeList}"> 
					 <option value="${meetingType.id}">${meetingType.name}</option>
				</c:forEach>
			</select>
			</div>
			<div id="createDateDiv" class="div-float hidden">
			  <input type="text" name="textfield" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
				-
			  <input type="text" name="textfield1" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
			</div>
		<div id="approveStateDiv" class="div-float hidden">
			<select name="textfield" id="textfield" class="textfield">
				<option value="0"><fmt:message key='mt.list.column.type.0'/></option>
				<option value="40"><fmt:message key='mt.list.column.type.40'/></option>
				</select>
		</div>
		<div onclick="javascript:doSearch()" class="condition-search-button div-float"></div>
		</div>
		</form>
		</td>
	</tr>
</table>

</div>
<div class="center_div_row2" id="scrollListDiv">
<form>
<v3x:table htmlId="listTable" data="list" var="bean" leastSize="0">
	<c:choose>
		<c:when test="${bean.proxy}">
			<c:set value="1" var="proxy" />
			<c:set value="${bean.proxyId}" var="proxyId" />
		</c:when>
		<c:otherwise>
			<c:set value="0" var="proxy" />
			<c:set value="-1" var="proxyId" />
		</c:otherwise>
	</c:choose>

	<c:choose>
		<c:when test="${v3x:currentUser().id!=bean.createUser || bean.proxy}">
			<c:set value="disabled" var="disabled" />
		</c:when>
		<c:otherwise>
			<c:set value="" var="disabled" />
		</c:otherwise>
	</c:choose>

	<v3x:column width="5%" align="center"
		label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
		<input type='checkbox' name='id' attFlag="${bean.hasAttachments}" value="<c:out value="${bean.id}"/>" ${disabled} approveState="${bean.approveState}"/>
		<script type="text/javascript">
			ht.add('${bean.id}','${bean.approveState}');
			createUserIdTable.add('${bean.id}','${bean.createUser}');
		</script>
	</v3x:column>

	<c:choose>
		<c:when test="${bean.accountId!=v3x:currentUser().accountId}">
			<c:set
				value="(${v3x:showOrgEntitiesOfIds(bean.accountId,'Account',pageContext)})"
				var="createAccountName" />
		</c:when>
		<c:otherwise>
			<c:set value="" var="createAccountName" />
		</c:otherwise>
	</c:choose>
<%-- puyc修改2012-2-5 --%>

	<c:choose>
	    <c:when test="${bean.approveState==0 || bean.approveState==10 || bean.approveState==40 || bean.approveState==30}">
			<c:set value="editAppMeeting('${bean.id}');" var="dblclick" />	
		</c:when>
		<c:otherwise>
			<c:set value="displayMyDetailApp('${bean.id}','${proxy}','${proxyId}', 1);" var="click" />
		</c:otherwise>
   </c:choose>
	<c:set value="displayMyDetailApp('${bean.id}','${proxy}','${proxyId}', 1);" var="dblclick" />	
	<c:set value="displayMyDetailApp('${bean.id}','${proxy}','${proxyId}', 1);" var="click" />

	<v3x:column width="40%" type="String" 
		onDblClick="${dblclick}"
		onClick="${click}" label="mt.list.column.mt_name"
		className="cursor-hand sort" bodyType="${bean.dataFormat}"
		hasAttachments="${bean.hasAttachments}"
		alt="${createAccountName}${bean.title}" maxLength="45" symbol="..." value="${bean.title}">
	</v3x:column>

	<v3x:column width="10%" type="String" 
		onDblClick="${dblclick}"
		onClick="${click}" label="mt.mtMeeting.app.createUser"
		className="cursor-hand sort">
		${v3x:showMemberName(bean.createUser)}
	</v3x:column>

	<v3x:column width="10%" type="String" 
		onDblClick="${dblclick}"
		onClick="${click}" label="mt.list.column.mt_type"
		className="cursor-hand sort" value="${bean.mtType==null?'':bean.mtType.name}">
	</v3x:column>

	<v3x:column width="13%" type="String" 
		onDblClick="${dblclick}"
		onClick="${click}" label="mt.mtMeeting.beginDate"
		className="cursor-hand sort">
		<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />
	</v3x:column>

	<v3x:column width="13%" type="String" 
		onDblClick="${dblclick}"
		onClick="${click}" label="common.date.endtime.label"
		className="cursor-hand sort">
		<fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />
	</v3x:column>

	<c:choose>
	<c:when test="${listType=='listMyAppMeetingDraft'}">
		<v3x:column width="9%" type="String" 
			onDblClick="${dblclick}"
			onClick="${click}" label="mt.mtType.label"
			className="cursor-hand sort">
			<fmt:message key="mt.list.column.type.${bean.approveState}" />
		</v3x:column>
	</c:when>
	<c:otherwise>
		<v3x:column width="9%" type="String" 
			onDblClick="${dblclick}"
			onClick="${click}" label="mt.list.column.mt_desc"
			className="cursor-hand sort">
			<fmt:message key="mt.list.column.type.${bean.approveState}" />
		</v3x:column>
	</c:otherwise>
	</c:choose>

</v3x:table>

</form>
</div>
</div>
</div>

<%-- 5.0<%@ include file="../../doc/pigeonholeHeader.jsp"%> --%>
<jsp:include page="../include/deal_exception.jsp" />
<script type="text/javascript">
<!--
//	showDetailPageBaseInfo("detailFrame", "<fmt:message key='mt.mtMeeting' /><fmt:message key='mt.list' />", [1,5], pageQueryMap.get('count'), _("meetingLang.detail_info_603_1"));	
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	initIpadScroll("scrollListDiv",550,870);
//-->
</script>

</body>
</html>