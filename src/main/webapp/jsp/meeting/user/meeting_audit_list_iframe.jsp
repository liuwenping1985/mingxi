<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.meeting.manager.MtMeetingManagerImpl"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
window.onload = function(){
}

try {
	getA8Top().endProc('');
	parent.treeFrame.changeHandler("${param.listType}");
} catch(e) {}

//getA8Top().showLocation(2101,"<fmt:message key='mt.mtMeeting.application.label'/>","<fmt:message key='admin.label.appMeeting'/>");

//显示当前位置
<%--puyc修改2012-2-5--%>
//当前位置
if(getA8Top()!=null && typeof(getA8Top().showLocation)!="undefined") {
	if('${liststatus}'==0){
		getA8Top().showLocation(2101,"<fmt:message key='mt.mtMeeting.auditing.label'/>","<fmt:message key='mt.list.column.type.10'/>");
	}else if('${liststatus}'==1){
		getA8Top().showLocation(2101,"<fmt:message key='mt.mtMeeting.auditing.label'/>","<fmt:message key='admin.label.audited'/>");
	}
}
	
var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");

<c:if test="${liststatus!=0}">
	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", 
			"deleteMtPerm();", 
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
<body>

<div class="main_div_row2">
<div class="right_div_row2">
<div class="top_div_row2">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
	<td class="webfx-menu-bar">
		<script type="text/javascript">
			document.write(myBar);	
		</script>
	</td>
	<td class="webfx-menu-bar">
		<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
			<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			<input type="hidden" value="${param.status}" name="status" />
			<div class="div-float-right condition-search-div">
			<div class="div-float">
				<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
					<option value=""><fmt:message
						key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						<option value="title"><fmt:message key="mt.list.column.mt_name" /></option>
						<option value="createUser"><fmt:message key="mt.list.column.app_person" /></option>
						<option value="meetingTypeId"><fmt:message key="mt.list.column.mt_type" /></option>
						<option value="createDate"><fmt:message key="mt.searchdate" /></option>
				</select>
			</div>

			<div id="titleDiv" class="div-float hidden">
				<input type="text" name="textfield" class="textfield">
			</div>
			<div id="createUserDiv" class="div-float hidden">
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

<form name="myform">
	<input type="hidden" value="${param.status}" name="status" />
	
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

		<c:set value="displayMyDetailApp('${bean.mtMeetingApp.id}','${bean.proxy==true?1:0}','${bean.userId}',1);" var="click" />
		<c:set value="proxy-${bean.proxy}" var="proxyClass"></c:set>

		<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
			<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" />
		</v3x:column>
		
		<%-- 会议申请标题 --%>
		<v3x:column width="45%" type="String"  onClick="${click}" label="mt.list.column.mt_name" className="cursor-hand sort ${bean.agreeFlag==0?(proxyClass):''}" bodyType="${bean.mtMeetingApp.dataFormat}"  hasAttachments="${bean.mtMeetingApp.hasAttachments}" alt="${bean.mtMeetingApp.title}" maxLength="45" symbol="...">
			<c:choose>
				<c:when test="${bean.proxy}">
					${createAccountName}${v3x:toHTML(bean.mtMeetingApp.title)}
					<c:choose>
						<c:when test="${proxyId ne null }">
							 <c:choose>
							  	<c:when test="${bean.agreeFlag==0 }">
							  		(<fmt:message key="mt.agent" />${v3x:showMemberName(bean.proxyId)})
							  	</c:when>
							  	<c:otherwise>
							  		${bean.proxyLabel }
							  	</c:otherwise>
						  	</c:choose>
						</c:when>
						<c:otherwise>
							${bean.proxyLabel }
						</c:otherwise>
					</c:choose>

				</c:when>
				<c:otherwise>
					${createAccountName}${v3x:toHTML(bean.mtMeetingApp.title)}
				</c:otherwise>
			</c:choose>
		</v3x:column>
		<%-- 创建人 --%>
		<v3x:column width="10%" type="String"  onClick="${click}" label="mt.list.column.app_person" className="cursor-hand sort">
			${v3x:showMemberName(bean.mtMeetingApp.createUser)}
		</v3x:column>
		<%-- 会议类型 --%>
		<v3x:column width="10%" type="String"  onClick="${click}" label="mt.mtMeeting.meetingType" className="cursor-hand sort">
			<c:forEach var="meetingType" items="${typeList}"> 
				<c:if test="${bean.mtMeetingApp.meetingTypeId!=null && bean.mtMeetingApp.meetingTypeId==meetingType.id}">
				 	${meetingType.name}
				 </c:if>
			</c:forEach>
		</v3x:column>
		<%-- 开始时间 --%>
		<v3x:column width="15%" type="String"  onClick="${click}" label="mt.mtMeeting.beginDate" className="cursor-hand sort">
			<font color="${bean.fontColor }" ><fmt:formatDate pattern="${datePattern}" value="${bean.mtMeetingApp.beginDate}" /></font>
		</v3x:column>
		<%-- 结束时间 --%>
		<v3x:column width="15%" type="String" onClick="${click}" label="common.date.endtime.label" className="cursor-hand sort">
			<font color="${bean.fontColor }" ><fmt:formatDate pattern="${datePattern}" value="${bean.mtMeetingApp.endDate}" /></font>
		</v3x:column>

	</v3x:table>
</form>
</div>
</div>
</div>
<%--
<%@ include file="../../doc/pigeonholeHeader.jsp"%>
 --%>

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