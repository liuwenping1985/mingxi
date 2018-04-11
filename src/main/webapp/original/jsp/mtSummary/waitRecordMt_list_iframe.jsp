<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.meeting.manager.MtMeetingManagerImpl"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../meeting/include/taglib.jsp" %>
<%@ include file="../meeting/include/header.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
	try {
		//getA8Top().endProc('');
	} catch(e) {
	}
	//显示当前位置
	showCtpLocation("F09_meetingSummary",{surffix:"待记录的纪要"});

	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	myBar.add( new WebFXMenuButton("newBtn", "<fmt:message key='mtSummary.create.lable'  bundle='${v3xMeetingSummaryI18N}' />", "create();", [1,1], "", null));
	myBar.add( new WebFXMenuButton("delBtn", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "remove_summary();", [1,3], "", null));



	<%--删除--%>
	function remove_summary(){
		var ids = '';
		var checkBoxList = parent.listFrame.document.getElementsByName('id');
		for(var i = 0; i < checkBoxList.length; i++){
			var idCheckBox = checkBoxList[i];
			if(idCheckBox.checked){
					if(ids == ''){
						ids = idCheckBox.value;
					}else{				
						ids += ','+idCheckBox.value;
					}
			}
		}

		if(ids != "" && ids.length != 0){
			if(!confirm(v3x.getMessage("meetingLang.summary_list_toolbar_only_delete_confirm"))){
				return false;
			}
			var form1 = document.getElementById("mainForm");
			form1.action = "${mtSummaryURL}?method=deleteWaitRecord&ids="+ids;
			form1.submit();
		}else{
			alert(v3x.getMessage("meetingLang.summary_list_toolbar_only_choose_one_deleteMt"));
			return false;
		}
	}
	
	/**
	 * 新建会议纪要
	 */
	function create(){
		var meetingId = '';
		var checkBoxList = parent.listFrame.document.getElementsByName('id');
		for(var i = 0; i < checkBoxList.length; i++){
			if(checkBoxList[i].checked){
				if(meetingId == ''){
					meetingId = checkBoxList[i].value;
				}else{				
					meetingId += ','+checkBoxList[i].value;
				}
			}
		}
		if(meetingId != ""){
			if(meetingId.split(",").length == 1){
				//parent.sx.rows="100%,*";
				location.href = "${mtSummaryURL}?method=create&meetingId=" + meetingId + "&from=${from}&listType=${listType}";
			}else{
				alert(v3x.getMessage("meetingLang.summary_list_toolbar_only_choose_one_toCreate"));
				return false;				
			}
		}else{
			alert(v3x.getMessage("meetingLang.summary_list_toolbar_select_create_item"));
			return false;
		}
	}

	function displayMyDetail(id,proxy,proxyId, openType){
		//if(!openType || openType==0){
			//parent.detailFrame.location.href = '${mtMeetingURL}?method=mydetail&id='+id+'&proxy='+proxy+"&proxyId="+proxyId;
		//}else{
			 var rv = v3x.openWindow({
			     url: '${mtMeetingURL}?method=mydetail&id='+id+'&proxy='+proxy+"&proxyId="+proxyId,
			     workSpace: 'yes',
			     dialogType: v3x.getBrowserFlag('pageBreak') == true ? 'modal' : '1'
			});
		//}
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
								<script type="text/javascript">document.write(myBar);</script>
							</td>
							<td class="webfx-menu-bar">
								<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
									<input type="hidden" value="<c:out value='${param.method}' />" name="method" /> 
									<input type="hidden" value="${param.stateStr}" name="stateStr" />
									<div class="div-float-right condition-search-div">
										<div class="div-float">
											<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
												<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
												<option value="title"><fmt:message key="mt.list.column.mt_name" /></option>
												<option value="createUser"><fmt:message key='mt.mtMeeting.createUser' /></option>
												<option value="createDate"><fmt:message key="mt.searchdate" /></option>
												<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
													<option value="mtTypeName"><fmt:message key="mt.mtMeeting.meetingType" /></option>
												<% } %>
												<%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")){ %>
													<option value="meetingNature"><fmt:message key="mt.mtMeeting.meetingNature" /></option>
												<%} %>
											</select>
										</div>
										<div id="titleDiv" class="div-float hidden">
											<input type="text" name="textfield" class="textfield" />
										</div>
										<div id="createUserDiv" class="div-float hidden">
											<v3x:selectPeople id="createUser" panels="Department,Team" selectType="Member"
												departmentId="${currentUser.departmentId}"
												jsFunction="setSearchPeopleFields(elements, 'createUserName', 'createUserId')" minSize="0" maxSize="1" />
											<input type="text" name="textfield" id="createUserName" class="textfield" readonly="true" onclick="selectPeopleFun_createUser('textfield', 'textfield1')" />
											<input type="hidden" name="textfield1" id="createUserId" />
										</div>
										<div id="createDateDiv" class="div-float hidden">
											<input type="text" name="textfield" id="fromDate" class="input-date cursor-hand" onclick="selectDateTime(this);" readonly /> 
											- 
											<input type="text" name="textfield1" id="toDate" class="input-date cursor-hand" onclick="selectDateTime(this);" readonly />
										</div>
										<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
										<div id="mtTypeNameDiv" class="div-float hidden">
											<select name="textfield" id="textfield" class="textfield">
						                    <c:forEach var="meetingType" items="${typeList}"> 
							                  <option value="${meetingType.name}">${meetingType.name}</option>
						                    </c:forEach>
					                      </select>
										</div>
										<% } %>
										<%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")){ %>
											<div id="meetingNatureDiv" class="div-float hidden">
											    <select name="textfield" id="textfield" class="textfield">
													  <option value="1"><fmt:message key="mt.mtMeeting.label.ordinary" /></option>
											          <option value="2"><fmt:message key="mt.mtMeeting.label.video" /></option>
												</select>
											</div>
										<%}%>
										<div onclick="javascript:doSearch()" class="condition-search-button div-float"></div>
									</div>
								</form>
							</td>
						</tr>
					</table>
				</div>
				<div class="center_div_row2" id="scrollListDiv">
					<form name="mainForm" id="mainForm" method="post">
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
								<c:when test="${v3x:currentUser().id!=bean.recorderId}"> 
									<c:if test="${bean.recorderId==-1}">
										<c:if test="${v3x:currentUser().id!=bean.emceeId }">
											<c:set value="disabled" var="disabled" />
										</c:if>
									</c:if>
								</c:when>
								<c:otherwise>
									<c:set value="" var="disabled" />
								</c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${bean.accountId!=v3x:currentUser().accountId}">
									<c:set value="(${v3x:showOrgEntitiesOfIds(bean.accountId,'Account',pageContext)})" var="createAccountName" />
								</c:when>
								<c:otherwise>
									<c:set value="" var="createAccountName" />
								</c:otherwise>
							</c:choose>
							<c:set value="displayMyDetail('${bean.id}','${proxy}','${proxyId}', 1);" var="click" />

							<!-- 选择框  -->
							<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
								<input type='checkbox' name='id' attFlag="${bean.hasAttachments}" value="<c:out value="${bean.id}"/>" ${disabled} />
							</v3x:column>
							<!-- 会议名称  -->
							<v3x:column width="35%" type="String"  onClick="${click}" label="mt.list.column.mt_name" className="cursor-hand sort" bodyType="${bean.dataFormat}" hasAttachments="${bean.hasAttachments}" alt="${createAccountName}${bean.title}" maxLength="45" symbol="...">
								${createAccountName}${v3x:toHTML(bean.title)}
									<c:if test="${bean.meetingType eq  '2' }">
						                   <span class="bodyType_videoConf inline-block"></span>
						        	</c:if>
							</v3x:column>
							<!-- 创建人  -->
							<v3x:column width="12%" type="String"  onClick="${click}" label="mt.mtMeeting.createUser" className="cursor-hand sort">
								${v3x:showMemberName(bean.createUser)}
							</v3x:column>
							<!-- 会议类型  -->
							<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
							<v3x:column width="10%" type="String"  onClick="${click}" label="mt.list.column.mt_type" className="cursor-hand sort" value="${bean.mtType==null?'':bean.mtType.name}">
							</v3x:column>
							<% } %>
							<%------------- 会议方式 -----------------%>
							<%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")){ %>
								<v3x:column width="8%" type="String"  onClick="${click}" label="mt.mtMeeting.meetingNature" className="cursor-hand sort" value="${bean.meetingType=='2'?'视频会议':'普通会议'}">
								</v3x:column>
							<%} %>
							<!-- 开始时间  -->
							<v3x:column width="13%" type="String"  onClick="${click}" label="mt.mtMeeting.beginDate" className="cursor-hand sort">
								<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />
							</v3x:column>
							<!-- 结束时间  -->
							<v3x:column width="13%" type="String"  onClick="${click}" label="common.date.endtime.label" className="cursor-hand sort">
								<fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />
							</v3x:column>
							<!-- 会议室  -->
							<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETINGROOM_APP) { %>
								<v3x:column width="12%" type="String" onClick="${click}" label="mt.mtMeeting.place" className="cursor-hand sort" value="${bean.roomName}">
								</v3x:column>
							<%} %>
						</v3x:table>
					</form>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			//showDetailPageBaseInfo("detailFrame", "<fmt:message key='mt.mtMeeting' /><fmt:message key='mt.list' />", [1,2], pageQueryMap.get('count'), _("meetingLang.detail_info_603_1"));	
			showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
			initIpadScroll("scrollListDiv",550,870);
		</script>
	</body>
</html>