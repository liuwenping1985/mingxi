 <%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="systemswitch.title.lable"/></title>
<html:link renderURL='/edocOpenController.do' var="edocOpenController" />

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<script type="text/javascript">
var menuKey = "1508";
//是否是单位公文管理员
//getA8Top().showLocation(menuKey,"<fmt:message key='mt.mtMeeting.Conference.review.label'/>");
if(getA8Top()!=null && typeof(getA8Top().showLocation)!="undefined") {
	getA8Top().showLocation("2106","<fmt:message key='mt.mtMeeting.Permissions.label' />", "<fmt:message key='mt.mtMeeting.right.set'/>");
}
function confirmthisform(){
	var form = document.all("submitform");
	form.action = "${edocOpenController}?method=saveEdocOpenSet";
	form.submit();
}
function defaultform(){
	var form = document.all("submitform");
	form.action = "${edocOpenController}?method=defaultEdocOpenSet";
	form.submit();
}
var mainURL = "<html:link renderURL='/main.do'/>";
function cancelthisform(){
	getA8Top().contentFrame.mainFrame.location.href = mainURL + "?method=showSystemNavigation";
}
<c:if test="${operateResult}">
alert(v3x.getMessage('edocLang.operateOk'));
</c:if>
//xiangfan 添加 修复GOV-2323 2012-04-27
function init(){
	parent.document.getElementById("sx").rows = "100%";
	parent.document.getElementById("detailFrame").style.display = "none";
	parent.document.getElementById("listFrame").noResize = true;
}
function leave(){
	parent.document.getElementById("sx").rows = "98%,2%";
	parent.document.getElementById("detailFrame").style.display = "block";
	parent.document.getElementById("listFrame").noResize = false;
}
</script>
<body onload="init()" onunload="leave()">
<form name="submitform" id="submitform" method="post">
<input type="hidden" name="oldMeetingReview" value="${meetingReview}">
<input type="hidden" name="oldMeetingLeadership" value="${meetingLeadership}">
<table width="100%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td align="center" valign="top">
		<div class="scrollList">
			<table width="60%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="middle">
						<fieldset><legend><fmt:message key="mt.mtMeeting.right.set"/></legend>
						<table width="100%" cellpadding="4" cellspacing="6" border=0>
							<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_APP) { %>
							<tr>
								<td width="80px"><fmt:message key="mt.mtMeeting.review.label"/>：</td>
								<td><textarea id="meetingReviewName" rows="5" class="new-column cursor-hand" name="meetingReviewName" readonly style="width:100%" onclick ="openSelectDepartWin(event);">${v3x:showOrgEntitiesOfTypeAndId(meetingReview,pageContext)}</textarea></td>
							</tr>
							<% } %>
							<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEADER) { %>
							<tr>
								<td width="80px"><fmt:message key="mt.mtMeeting.access.leadership.label"/>：</td>
								<td><textarea id="meetingLeadershipName" rows="5" class="new-column cursor-hand" name="meetingLeadershipName" readonly style="width:100%" onclick ="openSelectDepartWin(event);">${v3x:showOrgEntitiesOfTypeAndId(meetingLeadership,pageContext)}</textarea></td>
							</tr>
							<% } %>
						</table>
						</fieldset>	
					</td>
				</tr>
			</table>	
		</div>
	</td>
  </tr>  
  <tr>
	    <td height="30" class="bg-advance-bottom"  align="center">
	  	<input name="Input3" type="button" class="button-default_emphasize" value="<fmt:message key="common.button.ok.label" bundle='${v3xCommonI18N}' />" onclick="saveEdocacc()">&nbsp;
	    <input name="Input2" type="button"  class="button-default-2" value="<fmt:message key="systemswitch.cancel.lable" bundle="${v3xMainI18N}"/>" onclick="parent.location.reload(true);">&nbsp;   
	  </td>
  </tr>
</table>
<v3x:selectPeople id="edocSendAcc" panels="Department,Post,Level" selectType="Account,Department,Member,Post,Level,Team" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setEdocCreateFields(elements)" viewPage=""  showAllAccount="false" minSize="0"/>

<input type="hidden" name="meetingReview" id="meetingReview" value="${meetingReview}">
<input type="hidden" name="meetingLeadership" id="meetingLeadership" value="${meetingLeadership}">

</form>
<div class="hidden">
<iframe name="tempIframe" id="tempIframe"></iframe>
</div>
<script language="javascript">
var recUnitObj;
var selPerElements =new Properties();
var exclude_sendTo = new Array();
var exclude_copyTo = new Array();
var exclude_reportTo = new Array();
var exclude_sendTo2 = new Array();
var exclude_copyTo2 = new Array();
var exclude_reportTo2 = new Array();

function openSelectDepartWin(e)
{
  //recUnitObj=window.event.srcElement;//xiangfan 注释，修改为下面的方式，兼容FireFox，GOV-2473
  e = window.event || e;
  recUnitObj = e.srcElement || e.target;
  
  var inputIdObj;
  var inputName=recUnitObj.name.substr(0,recUnitObj.name.length-4);
  elements_edocSendAcc=selPerElements.get(inputName,"");
  
  selectPeopleFun_edocSendAcc();
}

function setEdocCreateFields(elements)
{  
  recUnitObj.value=getNamesString(elements);
  var inputIdObj;
  var inputName=recUnitObj.name.substr(0,recUnitObj.name.length-4);
  selPerElements.put(inputName,elements);
  inputIdObj=document.getElementById(inputName);
  
  if(inputIdObj!=null){inputIdObj.value=getIdsString(elements);}  
}

function saveEdocacc()
{
	var theForm=document.getElementById("submitform");//xiangfan 修改为getElementById，兼容FireFox，GOV-2473
	theForm.action = "${mtAdminController}?method=saveEdocSendSet";
	theForm.target="tempIframe";
	theForm.submit();
}

onlyLoginAccount_edocSendAcc=true;
hiddenPostOfDepartment_edocSendAcc=true;

selPerElements.put("meetingReview",parseElements("${v3x:parseElementsOfTypeAndId(meetingReview)}"));
selPerElements.put("meetingLeadership",parseElements("${v3x:parseElementsOfTypeAndId(meetingLeadership)}"));

</script>

<c:if test="">
<script type="text/javascript">
<!--
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='mt.mtMeeting.Conference.review.label' />", [1,5], null, _("meetingLang.detail_info_603_1"));
	previewFrame('Down');
//-->
</script>
</c:if>
</body>
</html>
 