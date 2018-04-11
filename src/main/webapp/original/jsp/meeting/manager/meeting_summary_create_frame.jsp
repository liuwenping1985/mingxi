<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>
<%@ include file="meeting_summary_create_js.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>${meetingBean.title}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/meeting/js/meetingPeople.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript">

//////////////////////////当前位置
//showCtpLocation("F09_meetingDone", {surffix : "${titleLabel}"});

///////////////////////按钮
var myBar = new WebFXMenuBar("${path}");

//保存
<c:if test="${bean.state==0 || bean.state==1 || bean.state==7}">
	myBar.add(new WebFXMenuButton("save", "${saveBtn}", "toSend('save');", [1,4], "", null));
</c:if>

//插入
var insert = new WebFXMenu;
insert.add(new WebFXMenuItem("", "${insertAttsBtn}", "insertAttachment()"));
insert.add(new WebFXMenuItem("", "${insertDocBtn}", "quoteDocument()"));
myBar.add(new WebFXMenuButton("insert", "${insertBtn}", null, [1,6], "", insert));
//正文类型
myBar.add(${v3x:bodyTypeSelector("v3x")});
//正文类型下拉选择
if(bodyTypeSelector) {
	bodyTypeSelector.disabled("menu_bodytype_${bean.dataFormat}");
}


//调整正文的高度
$(function(){
  	$("html").addClass("h100b over_hidden");
  	try{//设置正文区域TD高度
    	$("#scrollListMeetingDiv").height(window.document.body.clientHeight-$("#scrollListMeetingDiv")[0].offsetTop);
  	}catch(e){}
});

</script>
<style>
.bg-summary, td {
	height: 26px;
}
input,select {
	vertical-align: middle;
	height: 22px;
}
</style>
</head>
<body class="h100b over_hidden" >

<div class="newDiv h100b" id="summaryHeight" style="overflow:auto;">
	
<form id="dataForm" name="dataForm" action="${meetingSummaryURL}" method="post" class="h100b" target="hiddenIframe">
<input type="hidden" id="isOpenWindow" name="isOpenWindow" value="" />		
<input type="hidden" id="type" value="2" />
<input type="hidden" id="mtRoomName" name="mtRoomName" value="${meetingRoomName}" />
<input type="hidden" id="mtTypeName" name="mtTypeName" value="${meetingTypeName}" />
<input type="hidden" id="meetingId" name="meetingId" value="${meetingBean.id}" />
<input type="hidden" name="fromMethod" value="${fromMethod != null?fromMethod:param.method }"/>
<input type="hidden" id="method" name="method" value="saveSummary" />
<input type="hidden" id="formOper" name="formOper" value="save" />
<%--xiangfan 添加   --%>
<input type="hidden" id="listType" name="listType" value="${param.listType}" />
<input type="hidden" name="id" value="${bean.id}" />
<input type="hidden" id="isHasAtt" name="isHasAtt" value="" />
<input type="hidden" name="dataFormat" id="dataFormat" value="${bean.dataFormat}" />
<input type="hidden" id="emceeId" name="emceeId" value="${meetingBean.emceeId}"/>
<input type="hidden" id="recorderId" name="recorderId" value="${meetingBean.recorderId}"/>

<!-- 会议纪要表单元素 -->
<table border="0" cellspacing="0" cellpadding="0" style="width: 100%; height: 100%">
<tr>
	<td height="22" class="webfx-menu-bar border-left border-right border-top">
		<script type="text/javascript">
			document.write(myBar);
		</script>
	</td>
</tr>

<tr>
<td  height="10">
<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" id="contentTable">

<tr class="bg-summary">
	<!-- 发送 -->
	<td rowspan="3" width="1%" nowrap="nowrap" class="border-left">
		<a href="javascript:void(0)" id='send' onClick="toSend('send')" class="margin_lr_10 display_inline-block align_center new_btn">${sendBtn }</a>
	</td>

	<!-- 会议名称 -->
	<th nowrap="nowrap" width="1%" align="right">
		<div class="padding_r_5">${subjectLabel }${colonLabel }</div>
	</th>
	<td colspan="3">
		<div class="common_txtbox_wrap">
		<input type="text" class="input-100per" id="title" name="title" value="${ctp:toHTML(meetingBean.title)}" readonly="readonly" />
		</div>
	</td>
	
	<!-- 开始时间-->
	<th nowrap="nowrap" width="7%" align="right">
		<div class="padding_r_5">${beginDateLabel }${colonLabel }</div>
	</th>
	<td width="17%">
		<div class="common_txtbox_wrap">
		<input type="text" class="input-100per" name="beginDate" id="beginDate" readonly="readonly"  value="<fmt:formatDate pattern="${datetimePattern}" value="${meetingBean.beginDate}" />"/>
		</div>
	</td>
	
	<!-- 结束时间-->
	<th nowrap="nowrap" align="right">
		<div class="padding_r_5">${endDateLabel }${colonLabel }</div>
	</th>
	<td width="17%">
		<div class="common_txtbox_wrap">
		<input type="text" class="input-100per" name="endDate" id="endDate" readonly="readonly"  value="<fmt:formatDate pattern="${datetimePattern}" value="${meetingBean.endDate}" />" />
		</div>
	</td>
	
	<td width="10" valign="middle" nowrap="nowrap" align="right" class="border-right"></td>
</tr>


<tr class="bg-summary">
	<!-- 主持人-->
	<th nowrap="nowrap"  align="right">
		<div class="padding_r_5">${emceeIdLabel }${colonLabel }</div>
	</th>
	<td >
		<div class="common_txtbox_wrap">
		<input type="text" class="input-100per" id="emceeName" name="emceeName" readonly="readonly" value="${ctp:toHTML(v3x:showMemberNameOnly(meetingBean.emceeId))}" title="${ctp:toHTML(v3x:showMemberNameOnly(meetingBean.emceeId))}"/>
		</div>
	</td>
	
	<!-- 发起者 -->
	<th nowrap="nowrap" align="right">
		<div class="padding_r_5">${createUserLabel }${colonLabel }</div>
	</th>
	<td>
		<div class="common_txtbox_wrap">
		<input type="text" class="input-100per" id="createUser" name="createUser" readonly="readonly" value="${ctp:toHTML(v3x:showMemberNameOnly(meetingBean.createUser))}" title="${ctp:toHTML(v3x:showMemberNameOnly(meetingBean.createUser))}"/>
		</div>
	</td>
	
	<!-- 参会人员-->
	<th nowrap="nowrap" align="right">
		<div class="padding_r_5">${joinLabel }${colonLabel }</div>
	</th>
	<td>
		<div class="common_txtbox_wrap">
		<fmt:message key="mt.mtMeeting.conferees" var="_myLabel"/>
		<fmt:message key="label.please.select" var="_myLabelDefault">
			<fmt:param value="${_myLabel}" />
		</fmt:message>
		<input type="hidden" id="conferees" name="conferees" value="${meetingBean.conferees}" />
		<input type="text" class="input-100per cursor-hand" id="confereesNames" name="confereesNames" readonly="true" 
			value="<c:out value="${v3x:showOrgEntities(meetingConfereeList, 'id', 'entityType', pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
			title="<c:out value="${v3x:showOrgEntities(meetingConfereeList, 'id', 'entityType', pageContext)}" escapeXml="true" />"
			deaultValue="${_myLabelDefault}"
			onfocus="checkDefSubject(this, true)"
			onblur="checkDefSubject(this, false)"
			inputName="${_myLabel}" 
			validate="notNull,checkSelectConferees"
			/>
		</div>
	</td>
	
	<!-- 会议分类-->
	<th nowrap="nowrap" align="right">
		<div class="padding_r_5">${categoryLabel }${colonLabel }</div>
	</th>
	<td>
	<div class="common_txtbox_wrap">
		<input type="text"  class="input-100per" name="meetingFormat" id="meetingFormat"  readonly="readonly" value="${meetingBean.meetingTypeName}"/>
	</div>
	</td>

	<td valign="middle" nowrap="nowrap" align="right" class="border-right"></td>
</tr>
	
<tr class="bg-summary">
	<!-- 实际参会人员-->
	<th nowrap="nowrap" align="right" colspan="1">
		<div class="padding_r_5">${joinActualLabel }${colonLabel }</div>
	</th>
	<td colspan="3">
		<div class="common_txtbox_wrap">
			<fmt:message key="mt.mtMeeting.conferees" var="_myLabel"/>
			<fmt:message key="label.please.select" var="_myLabelDefault">
				<fmt:param value="${_myLabel}" />
			</fmt:message>
			<input type="hidden" value="${bean.isAudit }" name="isAudit" />
			<input type="hidden" id="scopes" name="scopes" value="${bean.conferees}"/>
			<input type="text" class="input-100per cursor-hand" id="scopesNames" name="scopesNames" readonly="true" 
				value="<c:out value="${v3x:showOrgEntities(scopeList, 'id', 'entityType', pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
				title="<c:out value="${v3x:showOrgEntities(scopeList, 'id', 'entityType', pageContext)}" escapeXml="true" />"
				deaultValue="${_myLabelDefault}"
				onfocus="checkDefSubject(this, true)"
				onblur="checkDefSubject(this, false)"
				inputName="${_myLabel}" 
				validate="checkSelectConferees"
				onclick="selectMtPeople_scopes('scopesSelect', 'scopes');"
				/>
		</div>
	</td>
	
	<c:choose>
		<c:when test="${hasMeetingRoomApp }">
			<th nowrap="nowrap" align="right">
				<div class="padding_r_5">${placeLabel} ${colonLabel }</div>
			</th>
			<td colspan="3">
				<div class="common_txtbox_wrap">
				<input type="text"  class="input-100per" name="roomName" id="roomName"  readonly="readonly" value="${ctp:toHTML(roomName)}"/>
				</div>
			</td>
		</c:when>
		<c:otherwise>
			<td colspan="4"></td>
		</c:otherwise>
	</c:choose>
	
	<td valign="middle" nowrap="nowrap" align="right" class="border-right"></td>
</tr>

<tr id="attachment2TR" class="bg-summary" style="display:none;">
	<td nowrap="nowrap" height="18" class="bg-gray border-left"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
	<td colspan="9" class="border-right"><div class="div-float" style="margin-top: 4px;">(<span id="attachment2NumberDiv"></span>)</div>
		<div></div><div id="attachment2Area" style="overflow: auto;"></div>
	</td>
</tr>					

<tr id="attachmentTR" style="display:none;" class="bg-summary">
	<td class="bg-gray border-left"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> <fmt:message key="label.colon" /> </td>
	<td class="border-right" colspan="9">
		<div class="div-float" style="margin-top: 4px;">(<span id="attachmentNumberDiv"></span>)</div>
		<v3x:fileUpload originalAttsNeedClone="${originalBodyNeedClone}" attachments="${attachments}" canDeleteOriginalAtts="true" />
	</td>
</tr>

<tr>
	<td colspan="10" height="6" class="bg-b border-left border-right"></td>
</tr>

</table>
</td>
</tr>

<!-- 会议纪要正文 -->
<tr>
	<td id="scrollListMeetingDiv" valign="top" style="height:80%;">
		<v3x:editor content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" originalNeedClone="${originalBodyNeedClone}" htmlId="content" category = "<%=ApplicationCategoryEnum.meeting.getKey()%>" />
	</td>
</tr>

</table>

</form>
</div>

<iframe name="hiddenIframe" width="0" height="0" style="display:none"></iframe>
<script>
// 将标题部分高度改为动态值
    //$("#summaryHeight").height(document.documentElement.clientHeight+10);
    OfficeObjExt.showExt=function(){
    	var _tpWin = getA8Top();
			if((_tpWin.$('.mask').size()>0 && _tpWin.$('.mask').css('display') != 'none') || (_tpWin.$('.shield').size()>0 && _tpWin.$('.shield').css('display') != 'none')){
				return;
			}
		var iframe = document.getElementById("officeFrameDiv");
		var h;
		if(OfficeObjExt.firstHeight == null){
			h = iframe.style.height;
			OfficeObjExt.firstHeight = h;
		}else{
			h= OfficeObjExt.firstHeight; 
		}
		var height=h;
		if(h.indexOf("%")>0){
			height = h.substring(0,h.length-1);
			height = parseInt(height);
			height = height -2;
			iframe.style.height = height+"%";
		}else if(h.indexOf("px")>0){
			height = h.substring(0,h.length-2);
			height = parseInt(height);
			height = height -2;
			iframe.style.height = height+"px";
		}else{
			h= $(iframe).height();
			OfficeObjExt.firstHeight = h+"px"; 
			iframe.style.height = (h-2)+"px";
		}
		window.setTimeout(function(){
			iframe.style.height = h;
		}, 2);
	};
	try{
		getA8Top().OfficeObjExt._tempShowExt =  getA8Top().OfficeObjExt.showExt;
		getA8Top().OfficeObjExt.showExt = OfficeObjExt.showExt ; 
		window.onunload = function(){
			getA8Top().OfficeObjExt.showExt =getA8Top().OfficeObjExt._tempShowExt;
			getA8Top().OfficeObjExt._tempShowExt = null; 
		}
	}catch(e){	
	}
</script>

<iframe name="hiddenIframe" width="0" height="0" style="display:none"></iframe>

</body>
</html> 