<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="mainResource"/>
<html>
<head>
<script type="text/javascript">
<!--
if("${v3x:escapeJavascript(param.where)}" != "space"){
	if('${v3x:escapeJavascript(group)}'=='group'){
		//TODO wanguangdong 2012-10-30
		<%--getA8Top().showLocation(null, v3x.getMessage("InquiryLang.group_inquiry_audit"));--%>
	}else if('${v3x:escapeJavascript(group)}'==''){
		//TODO wanguangdong 2012-10-30
		<%--getA8Top().showLocation(null, v3x.getMessage("InquiryLang.account_inquiry_audit"));--%>
		onlyLoginAccount_per = true;
	}
}
//-->
</script>
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">	
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
<!--
	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}

    function inquiryCheck(id,tid){
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "hasInquiryExist", false);
		requestCaller.addParameter(1, "Long", id);
		var ds = requestCaller.serviceRequest();
		if(ds=='false'){
			alert("该调查已被管理员或发起者删除!");
			location.reload(true);
			return;
		}
		//auditFlag是从审核列表页面进入的标志
    	var acturl = "${basicURL}?method=survey_check&bid="+id+"&tid="+tid+"&group=${v3x:escapeJavascript(group)}&from=list&auditFlag=0";
	    //弹出调查页面
		//openWin(acturl);
		parent.detailFrame.location.href=acturl;
		//window.parent.detailFrame.location.href = 
	    //document.location.href = "${basicURL}?method=survey_check&bid="+id+"&tid="+tid+"&group=${v3x:escapeJavascript(group)}";
    }
    
    //菜单按钮事件  审核   取消审核
    function auditData(obj){
    
    	var id = getSelectId();
		if(id == ''){
			alert(v3x.getMessage("InquiryLang.inquiry_choose_item_from_list"));
			return;
		}else if(validateCheckbox("id")>1){
			alert(v3x.getMessage("InquiryLang.inquiry_please_choose_one_data"));
			return;
		}
		
		
		if(obj=='audit'){
			//弹出页面进行审核操作
			
			var acturl = "${basicURL}?method=survey_check&bid="+id+"&tid=${typeId}&group=${v3x:escapeJavascript(group)}&from=list";
			var result = openWin(acturl);
			location.reload(true);
			
		}else{
			//进行取消审核操作
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "validateInquiryExist", false);
			requestCaller.addParameter(1, "Long", id);
			var ds = requestCaller.serviceRequest();
			/*
				-1.发布未开始
				1.审核未通过
				2.审核通过但未发布
				3.保存待发
				4.未审核
				5.终止状态
				8.发布状态
				10.归档
			*/
			if(ds==4)//1.审核未通过 3. 保存待发 4. 未审核  8.已发布
			{	
				alert("调查还未审核，不能取消!");
				return;
			}
			if(ds==8)//1.审核未通过 3. 保存待发 4. 未审核  8.已发布
			{	
				alert("调查已经发布，不能取消!");
				return;
			}
			document.location.href = "${basicURL}?method=checkCancel&bid="+id+"&typeId=${typeId}&group=${v3x:escapeJavascript(group)}&spaceType={param.spaceType}&spaceId=${v3x:escapeJavascript(param.spaceId)}";
		}
    
    }
    
    function setPeopleFieldsSecond(elements){
		if(!elements){
			return;
		}
		document.getElementById("textfield").value=getNamesString(elements);
		document.getElementById("textfield1").value=getIdsString(elements,false);
	
	}
//-->
</script>
<c:if test="${hasManageAuth}"><!--这个是管理板块的权限 -->
	<body>
</c:if>
<c:if test="${!hasManageAuth}"><!--这个是管理板块的权限 -->
	<body>
</c:if>


<v3x:selectPeople id="second" panels="Department,Team,Post,Level" selectType="Member" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFieldsSecond(elements)" maxSize="1" />

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" >

	<tr>
	
		<td colspan="2">
			<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="22" class="webfx-menu-bar-gray" style="height: 34px;">
						<script>
						<!--
							if('${hasManageAuth}'=='true'){//这个是管理板块的权限 
								var myBar = new WebFXMenuBar("","gray");
							}else{
								var myBar = new WebFXMenuBar("","gray");
							}
				
							myBar.add(
								new WebFXMenuButton(
									"newBtn", 
									"<fmt:message key='inquiry.cancel.label' />", 
									"auditData('cancel');",
									"<c:url value='/common/images/toolbar/cancelaudit.gif'/>", 
									"", 
									null
									)
							);
							
							myBar.add(
									new WebFXMenuButton(
									"",
									"<fmt:message key='common.toolbar.refresh.label' bundle='${v3xCommonI18N}' />", 
									"javascript:refreshIt()", 
									"<c:url value='/common/images/toolbar/refresh.gif'/>", 
									"", 
									null
									)
							);
							<%-- <v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/> --%>
							document.write(myBar);
						//-->	
						</script>
					</td>
					
					<c:if test="${hasManageAuth}"><!--这个是管理板块的权限 -->
						<td class="webfx-menu-bar-gray">
					</c:if>
					<c:if test="${!hasManageAuth}"><!--这个是管理板块的权限 -->
						<td class="webfx-menu-bar-gray">
					</c:if>
					
						<form action="${basicURL}" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
							<input type="hidden" value="<c:out value='${param.method}' />" id="method" name="method">
							<input type="hidden" value="${typeId}" id="surveyTypeId" name="surveyTypeId">
							<input type="hidden" value="${v3x:toHTML(group)}" name="group" id="group">
							<input type="hidden" value="mid" name="mid" id="mid">
							<div class="div-float-right">
								<div class="div-float">
								<select name="condition" id="condition"  onChange="showNextCondition(this)" class="condition">
									<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
									<option value="sender"><fmt:message key="inquiry.creater.label" /></option>
									<option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
								</select></div>
								<div id="senderDiv" class="div-float hidden">
									<!--  <input type="text" id="textfield" name="textfield" onclick="selectPeopleFun_second()" readonly><input type="hidden" id="textfield1" name="textfield1">-->
									 <input type="text" id="textfield" name="textfield" onkeydown="javascript:searchWithKey()">
								</div>
								<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield" onkeydown="javascript:searchWithKey()"></div>
								
								<div id="createDateDiv" class="div-float hidden">
									<input type="text" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly onkeydown="javascript:searchWithKey()"> - 
									<input type="text" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly onkeydown="javascript:searchWithKey()">
								</div>
								<div onclick="javascript:doSearch()" class="div-float condition-search-button button-font-color"></div>
							</div>
						</form>
					</td>
				</tr>
			
	
				<tr>
					<td colspan="2">
						<div class="scrollList">
							<form action="" name="mainForm" id="" mainForm"" method="get">
							  <v3x:table data="${blist}" var="con" htmlId="sdsd"
								  isChangeTRColor="true" showHeader="true" className="sort ellipsis" subHeight="30">
								<c:set var="onclick" value="inquiryCheck('${con.inquirySurveybasic.id}','${con.inquirySurveybasic.inquirySurveytype.id}')" />
								
								<v3x:column width="5%" align="center" 
									label="<input type='checkbox'  onclick='selectAll(this, \"id\")'/>">
									<input type='checkbox' <c:if test="${con.inquirySurveybasic.censor==4 }">disabled</c:if> id='id' name='id' value="${con.inquirySurveybasic.id}" />
									
								</v3x:column>
								
								<v3x:column width="40%" type="String" label="inquiry.subject.laber" onClick="${onclick}" className="cursor-hand sort" hasAttachments="${con.inquirySurveybasic.attachmentsFlag}"
									maxLength="52" alt="${con.inquirySurveybasic.surveyName}">
								${v3x:showSubject(con.inquirySurveybasic,v3x:currentUser().id,52,10,con.inquirySurveybasic.censor==2) }	
								</v3x:column>
									
								<v3x:column type="String" width="20%" label="inquiry.block.inquiry.label" value="${con.inquirySurveybasic.inquirySurveytype.typeName}" onClick="${onclick}" className="cursor-hand sort" symbol="..."
									maxLength="25" alt="${con.inquirySurveybasic.inquirySurveytype.typeName}"></v3x:column>
							    
							    <v3x:column type="String" width="10%" label="inquiry.creater.label" value="${v3x:showOrgEntitiesOfIds(con.inquirySurveybasic.createrId, 'Member', pageContext)}" alt="${v3x:showOrgEntitiesOfIds(con.inquirySurveybasic.createrId, 'Member', pageContext)}"
										onClick="${onclick}" className="cursor-hand sort"></v3x:column>
										
								<v3x:column type="String" width="15%" label="inquiry.scope.label" onClick="${onclick}"
									className="cursor-hand sort"
									alt="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}" symbol="..."
									maxLength="16"
									value="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}">
								</v3x:column>
								
								<v3x:column width="10%" type="String" label="common.state.label" onClick="${onclick}" className="cursor-hand sort">
									<c:choose>
										<c:when test="${con.inquirySurveybasic.censor==4||con.inquirySurveybasic.censor==null}">
										<fmt:message key="inquiry.state.NotCheck" />
										</c:when>
										<c:when test="${con.inquirySurveybasic.censor==2}">
										<fmt:message key="inquiry.state.pass" />
										</c:when>
									</c:choose>
								</v3x:column>						
							</v3x:table>
						 </form>
						</div>
					</td>
				</tr>
		</table>
		</td>
		</tr>
		</table>
		<script type="text/javascript">
		<!--
			showDetailPageBaseInfo("detailFrame", "<fmt:message key='application.10.label' bundle="${v3xCommonI18N}" />", [2,1],pageQueryMap.get('count'),_("InquiryLang.detail_info_607"));
		//-->
		</script>
	</body>
</html>