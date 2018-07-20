<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.meeting.manager.MtMeetingManagerImpl"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">
<!--
window.onload = function(){
}
	try {
		getA8Top().endProc('');
	} catch(e) {
	}
	//显示当前位置
	getA8Top().showLocation(2101);

	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	if(v3x.getBrowserFlag('hideMenu')){
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", 
			"parent.location.href='${mtMeetingURL}?method=create&formOper=new';", 
			[1,1], 
			"", 
			null
			)
	);
	<%-- 只有暂存待发和已发起未召开的的会议允许修改，只有已召开或已总结的会议允许归档 --%>
	<c:if test="${param.stateStr=='0' || param.stateStr=='10' || param.stateStr==''}">
		myBar.add(
			new WebFXMenuButton(
				"edtBtn", 
				"<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", 
				"editMtTemplate('${param.stateStr}');", 
				[1,2], 
				"", 
				null
				)
		);
	</c:if>
	}
	<c:if test="${param.stateStr=='' || param.stateStr=='10'}">
		myBar.add(
			new WebFXMenuButton(
				"cancelBtn", 
				"<fmt:message key='common.toolbar.cancelmt.label' bundle='${v3xCommonI18N}' />", 
				"deleteMtRecord('${mtMeetingURL}?method=delete&stateStr=${param.stateStr}', 'cancel');", 
				[4,1], 
				"", 
				null
				)
		);
	</c:if>
	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", 
			"deleteMtRecord('${mtMeetingURL}?method=delete&stateStr=${param.stateStr}', 'delete');", 
			[1,3], 
			"", 
			null
			)
	);
	
	function summaryMeeting(){
		var id=getSelectId();
		if(id==''){
			alert(v3x.getMessage("meetingLang.choose_item_from_list"));
			return;
		}else if(validateCheckbox("id")>1){
			alert(v3x.getMessage("meetingLang.please_choose_one_date"));
			return;
		}
		parent.location.href='${mtSummaryTemplateURL}?method='+'edit'+'&id='+id;
	}
	
	<c:if test="${param.stateStr=='20'}">
	if(v3x.getBrowserFlag('hideMenu')){
		myBar.add(
			new WebFXMenuButton(
				"pigeonholeBtn", 
				"<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />", 
				"mtPigeonhole('<%=com.seeyon.v3x.common.constants.ApplicationCategoryEnum.meeting.key()%>');", 
				[1,9], 
				"", 
				null
				)
		);
	}
	</c:if>
	
//	myBar.add(
//		new WebFXMenuButton(
//		"",
//		"<fmt:message key='common.toolbar.refresh.label' bundle='${v3xCommonI18N}' />", 
//		"javascript:refreshIt()", 
//		[1,10], 
//		"", 
//		null
//		)
//	);
	myBar.add(
		new WebFXMenuButton(
			"sentButNotConvoked", 
			"<fmt:message key='mt.mtMeeting.state.10' />", 
			"javascript:showCertainStateMeetings('10');", 
			[4,2],
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"toSend", 
			"<fmt:message key='mt.mtMeeting.state.tosend'/>",  
			"javascript:showCertainStateMeetings('0');", 
			[7,8], 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"convoked", 
			"<fmt:message key='mt.mtMeeting.state.convoked'/>",  
			"javascript:showCertainStateMeetings('20');", 
			[4,3], 
			"", 
			null
			)
	);
		
	baseUrl='${mtMeetingURL}?method=';
	
	var ht = new Hashtable();
	var createUserIdTable = new Hashtable();
	var userInternalID = "${sessionScope['com.seeyon.current_user'].id}";
	function editMeeting(id){
		if(userInternalID==createUserIdTable.items(id)){
			<%-- 已经开始的会议不允许修改，其他均允许修改 --%>
			if(!validateCanEdit(id)) {
				alert(v3x.getMessage("meetingLang.meeting_begin_cannot_edit"));
				if('${param.stateStr}' == '10' || '${param.stateStr}' == '')
					parent.getA8Top().reFlesh();
				return;
			}
			parent.location.href=baseUrl+'edit'+'&id='+id+'&flag=editMeeting';
		}else{
			alert(v3x.getMessage("meetingLang.you_not_creater"));
			return;
		}
	}
	
	function meetingToCol(){
		var id=getSelectId();
		if(id==''){
			alert(v3x.getMessage("meetingLang.choose_item_from_list"));
			return;
		}else if(validateCheckbox("id")>1){
			alert(v3x.getMessage("meetingLang.please_choose_one_date"));
			return;
		}
		parent.parent.location.href='${mtMeetingURL}?method='+'meetingToCol'+'&id='+id;
	}
	
	function summaryToCol(){
		var id=getSelectId();
		if(id==''){
			alert(v3x.getMessage("meetingLang.choose_item_from_list"));
			return;
		}else if(validateCheckbox("id")>1){
			alert(v3x.getMessage("meetingLang.please_choose_one_date"));
			return;
		}
		if(ht.items(id)==40){
			parent.parent.location.href='${mtMeetingURL}?method='+'summaryToCol'+'&id='+id;
		}else{
			alert(v3x.getMessage("meetingLang.meeting_no_summary"));
			return;
		}
	}
	//文章页面弹出窗口
	function openWin(url){
			var rv = v3x.openWindow({
	        url: url,
	        dialogType: "open"
	    });
	}	
	
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
	function setSearchPeopleFields(elements, namesId, valueId) {
		document.getElementById(valueId).value = getIdsString(elements, false);
		document.getElementById(namesId).value = getNamesString(elements);
		document.getElementById(namesId).title = getNamesString(elements);
	}
    //-->
</script>
</head>
<body onload="javascript:setMenuState('${param.stateStr}');">
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
		<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
		<input type="hidden" value="<c:out value='${param.method}' />" name="method">
		<input type="hidden" value="${param.stateStr}" name="stateStr" />
		<div class="div-float-right condition-search-div">
		<div class="div-float">
			<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
				<option value=""><fmt:message
					key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
				<option value="title"><fmt:message key="mt.mtMeeting.title" /></option>
				<c:if test="${param.stateStr eq '20'}">
					<option value="state"><fmt:message key="mt.mtMeeting.state" /></option>
				</c:if>
				<c:if test="${param.stateStr ne '0'}">
					<option value="createUser"><fmt:message
						key='mt.mtMeeting.createUser' /></option>
				</c:if>
				<option value="createDate"><fmt:message key="mt.searchdate" /></option>
			</select>
			</div>

			<div id="titleDiv" class="div-float hidden">
				<input type="text" name="textfield" class="textfield">
			</div>
		<c:if test="${param.stateStr eq '20'}">
			<div id="stateDiv" class="div-float hidden">
			<select name="textfield" id="textfield" class="textfield">
				<option value="20"><fmt:message key="mt.mtMeeting.state.20" /></option>
				<option value="30"><fmt:message key="mt.mtMeeting.state.30" /></option>
				<option value="40"><fmt:message key="mt.mtMeeting.state.40" /></option>
			</select>
			</div>
		</c:if> 
		<c:if test="${param.stateStr ne '0'}">
			<div id="createUserDiv" class="div-float hidden">
			<v3x:selectPeople id="createUser" panels="Department,Team" selectType="Member"
				departmentId="${currentUser.departmentId}"
				jsFunction="setSearchPeopleFields(elements, 'createUserName', 'createUserId')" minSize="0" maxSize="1" />
			<input type="text" name="textfield" id="createUserName" class="textfield" readonly="true" onclick="selectPeopleFun_createUser('textfield', 'textfield1')" />
			<input type="hidden" name="textfield1" id="createUserId" />
			</div>
		</c:if>

		<div id="createDateDiv" class="div-float hidden">
		<input type="text" name="textfield" id="fromDate" class="input-date cursor-hand" onclick="selectDateTime(this);" readonly> 
			- 
		<input type="text" name="textfield1" id="toDate" class="input-date cursor-hand" onclick="selectDateTime(this);" readonly>
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
		<input type='checkbox' name='id' attFlag="${bean.hasAttachments}"
			value="<c:out value="${bean.id}"/>" ${disabled} />
		<script type="text/javascript">
			ht.add('${bean.id}','${bean.state}');
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

	<c:set value="editMeeting('${bean.id}');" var="dbClick" />
	<c:set value="displayMyDetail('${bean.id}','${proxy}','${proxyId}');"
		var="click" />

	<v3x:column width="35%" type="String" onDblClick="${dbClick}"
		onClick="${click}" label="mt.mtMeeting.title"
		className="cursor-hand sort" bodyType="${bean.dataFormat}"
		hasAttachments="${bean.hasAttachments}"
		alt="${createAccountName}${bean.title}" maxLength="45" symbol="...">
		<c:choose>
			<c:when test="${bean.proxy}">
				<div class="link-blue">
				${createAccountName}${v3x:toHTML(bean.title)}
				<c:if test="${proxyId ne null }">
				  (<fmt:message key="mt.agent" />${v3x:showMemberName(bean.proxyId)})
				</c:if>
				</div>
			</c:when>
			<c:otherwise>
				${createAccountName}${v3x:toHTML(bean.title)}
			</c:otherwise>
		</c:choose>
	</v3x:column>

	<v3x:column width="8%" type="String" onDblClick="${dbClick}"
		onClick="${click}" label="mt.mtMeeting.createUser"
		className="cursor-hand sort">
		${v3x:showMemberName(bean.createUser)}
	</v3x:column>

	<v3x:column width="10%" type="String" onDblClick="${dbClick}"
		onClick="${click}" label="mt.mtMeeting.remindFlag"
		className="cursor-hand sort">
		<c:choose>
			<c:when test="${!bean.remindFlag}">
				<fmt:message key="mt.mtMeeting.noremind" />
			</c:when>
			<c:when test="${bean.remindFlag&&bean.beforeTime!=-1}">
				<fmt:message key="mt.mtMeeting.beforeTime" />
				<v3x:metadataItemLabel metadata="${remindTimeMetaData}"
					value="${bean.beforeTime}" />
			</c:when>
			<c:when test="${!bean.remindFlag||bean.beforeTime==-1}">
				<fmt:message key="mt.mtMeeting.remind.ontime" />
			</c:when>
		</c:choose>
	</v3x:column>

	<v3x:column width="13%" type="String" onDblClick="${dbClick}"
		onClick="${click}" label="mt.mtMeeting.beginDate"
		className="cursor-hand sort">
		<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />
	</v3x:column>

	<v3x:column width="13%" type="String" onDblClick="${dbClick}"
		onClick="${click}" label="common.date.endtime.label"
		className="cursor-hand sort">
		<fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />
	</v3x:column>

	<v3x:column width="6%" type="String" onDblClick="${dbClick}"
		onClick="${click}" label="common.state.label"
		className="cursor-hand sort">
		<fmt:message key="mt.mtMeeting.state.${bean.state}" />
	</v3x:column>
</v3x:table>
</form>
</div>
</div>
</div>

<%-- <%@ include file="../../doc/pigeonholeHeader.jsp"%> --%>
<jsp:include page="../include/deal_exception.jsp" />
<script type="text/javascript">
<!--
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='mt.mtMeeting' /><fmt:message key='mt.list' />", [1,5], pageQueryMap.get('count'), _("meetingLang.detail_info_603_1"));	
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	initIpadScroll("scrollListDiv",550,870);
//-->
</script>

</body>
</html>