<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="../apps/doc/pigeonholeHeader.jsp"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script language="javascript">
<!--
	<c:if test="${param.where != 'space' && param.custom != 'true'}">
		if('${v3x:escapeJavascript(group)}' == 'true' || '${v3x:escapeJavascript(group)}' == 'group'){
			//TODO wanguangdong 2012-10-30
			<%-- getA8Top().showLocation(null, v3x.getMessage("InquiryLang.group_inquiry_manage"), "${inquirytype.typeName}");--%>
		}else{
			//TODO wanguangdong 2012-10-30
			<%--getA8Top().showLocation(null, v3x.getMessage("InquiryLang.account_inquiry_manage"), "${inquirytype.typeName}");--%>
			onlyLoginAccount_per = true;
			hiddenOtherMemberOfTeam_per = true;
		}
	</c:if>
if('${param.custom}'=='true'){
    var theHtml=toHtml("${v3x:toHTML(inquirytype.typeName)}",'<fmt:message key="inquiry.manage"/>');
    showCtpLocation("",{html:theHtml});
}
//不受职务级别限制
isNeedCheckLevelScope_per = false;
var hiddenPostOfDepartment_per=true;
function setPeopleFields(elements)
{
	if(!elements){
		return;
	}
	document.getElementById("authscope").value=getIdsString(elements,true);
	var idsValue=getIdsString(elements,true);
		 document.mainForm.target = "grantIframe";
         document.mainForm.action= "${basicURL}?method=authorities&surveytypeid=${param.surveytypeid}";
         mainForm.submit();
     if(idsValue!=''){
           alert(v3x.getMessage("InquiryLang.inquiry_boardAuth_success"));
     }

}
window.onload = function(){
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
}


function inquiryDetail(id){
    var acturl = "${basicURL}?method=showInquiryFrame&surveytypeid=${param.surveytypeid}&bid=" + id +"&manager_ID=manager_ID&group=${v3x:escapeJavascript(group)}&spaceId=${v3x:escapeJavascript(param.spaceId)}";
	openWin(acturl);
}

function delOk(optionID){	
   	mainForm.action="${basicURL}?method=sbasic_remove&surveytypeid=${param.surveytypeid}&op="+optionID+"&typeName=${typeName}&group=${v3x:escapeJavascript(group)}&custom=${v3x:escapeJavascript(custom)}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${v3x:escapeJavascript(param.spaceId)}";
	var len = document.mainForm.id.length;
    var checked = false;
    if(isNaN(len)){
        if(!document.mainForm.id.checked){
		   alert(v3x.getMessage("InquiryLang.inquiry_alertDeleteItem"));
		}else{
			if(confirm(v3x.getMessage("InquiryLang.inquiry_delete_alert"))){
				mainForm.method = 'post';
				if(getA8Top() && getA8Top().startProc) getA8Top().startProc();
				mainForm.submit();
			}
		}
	 }else{
        for (i = 0; i <len; i++) {
            if (document.mainForm.id[i].checked == true) {
                checked = true;
                break;
            }
        }
        if (!checked) {
            alert(v3x.getMessage("InquiryLang.inquiry_alertDeleteItem"));
            return false;
        }else {
			if(confirm(v3x.getMessage("InquiryLang.inquiry_delete_alert"))) {
		    	mainForm.method = 'post';
		    	if(getA8Top() && getA8Top().startProc) getA8Top().startProc();
				mainForm.submit();
			}
		}
	}
}
function promulgation(){
   	var len = document.mainForm.id.length;
        var checked = false;
     if(isNaN(len)){
        if(!document.mainForm.id.checked){
		  alert(v3x.getMessage("InquiryLang.inquiry_choose_the_send_alert"));
          return false;
		}
	 }else{
        for (i = 0; i <len; i++)
        {
            if (document.mainForm.id[i].checked == true)
            {
                checked = true;
                break;
            }
        }
        if (!checked)
        {
            alert(v3x.getMessage("InquiryLang.inquiry_choose_the_send_alert"));
            return false;
        }
     }
	mainForm.action="${basicURL}?method=creator_public&surveytypeid=${param.surveytypeid}&group=${v3x:escapeJavascript(group)}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${v3x:escapeJavascript(param.spaceId)}";
	mainForm.submit();
	
}

function unpublic(){
	mainForm.action="${basicURL}?method=basic_NO_send&surveytypeid=${param.surveytypeid}"+"&typeName=${typeName}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${v3x:escapeJavascript(param.spaceId)}";
	mainForm.submit();
}
function setPeopleFieldsSecond(elements)
{
	if(!elements){
		return;
	}
	document.getElementById("textfield").value=getNamesString(elements);
	document.getElementById("textfield1").value=getIdsString(elements,false);

}
var myPigeonholeItem = {};
function myPigeonhole(){
	    var IDstring =document.getElementsByName('id');
	    var thisValue = "";
	    var atts = getSelectAtts();
	    for(var i = 0 ;i<IDstring.length;i++){
	       if(IDstring[i].checked){
	           thisValue  += IDstring[i].value +",";
	       }
	    }
	    if(thisValue =="" ){
	         alert(v3x.getMessage("InquiryLang.inquiry_select_pigeonhole"));
	         return false;
	    } else {
	    	var requestCaller = new XMLHttpRequestCaller(this, "inquiryManager", "filterWhenPigeonhole", false);
				requestCaller.addParameter(1, "String", thisValue);
			var result = requestCaller.serviceRequest();
			if(result[0] == "") {
				alert(v3x.getMessage("InquiryLang.inquiry_pigeonhole_all_running"));
				for(var i = 0 ;i<IDstring.length;i++){
			       if(IDstring[i].checked){
			    	   IDstring[i].checked = false;
			       }
			    }
				return false;
			}
			if(result[1] == "true") {
				alert(v3x.getMessage("InquiryLang.inquiry_pigeonhole_some_running"));
				thisValue = result[0];
			}
		}    
	    var nowValue = thisValue; 
	    myPigeonholeItem.nowValue = nowValue;
	    pigeonhole(10, nowValue,atts,"","","inquiryPigeonCollBack");
	    
}

function inquiryPigeonCollBack (backValue) {
	if(backValue == 'failure' ){
        alert(v3x.getMessage("InquiryLang.inquiry_pigeonhole_fail"));
        return false;
  }else if(backValue != 'cancel'){
     var _archiveIds = backValue.split(",");
     for (var i=0; i<_archiveIds.length; i++){
          var archiveId = _archiveIds[i];
          var element = document.createElement("INPUT");
          element.type="hidden";
          element.name="archiveId";
          element.value=archiveId;
          mainForm.appendChild(element);
     }
     mainForm.target  = 'grantIframe';
     mainForm.action="${basicURL}?method=pigeonhole&ids="+myPigeonholeItem.nowValue+"&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${v3x:escapeJavascript(param.spaceId)}";
     mainForm.submit();
  }
}

function getSelectAtts(){
		var ids=document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=id+idCheckBox.attFlag+',';
			}
		}
		return id;
	}

//板块切换响应事件
	//function changeType(obj){
	
	//	var typeId = obj.value;
	//	document.location.href = "${basicURL}?method=survey_index&surveytypeid="+typeId+"&mid=mid&group=${v3x:escapeJavascript(group)}";
		
	//}
	
	function changeType(typeId){
		document.location.href = "${basicURL}?method=survey_index&surveytypeid="+typeId+"&mid=mid&group=${v3x:escapeJavascript(group)}&hasCheckAuth=${v3x:escapeJavascript(hasCheckAuth)}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${v3x:escapeJavascript(param.spaceId)}";
	}

	  //取消发布调查
    function cancelInquiry(){
	    mainForm.action="${basicURL}?method=cancel&surveytypeid=${param.surveytypeid}&group=${v3x:escapeJavascript(group)}&custom=${v3x:escapeJavascript(custom)}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${v3x:escapeJavascript(param.spaceId)}";
	    var len = document.mainForm.id.length;
        var checked = false;
        if(isNaN(len)){
             if(!document.mainForm.id.checked){
            	 alert(v3x.getMessage("InquiryLang.inquiry_choose_item_from_list"));
		      }else{
		      			 var id= document.mainForm.id.value;
		     		     var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "validateInquiryExist", false);
						  requestCaller.addParameter(1, "Long", id);
						  var ds = requestCaller.serviceRequest();
		      
				      if(ds == 5){
				    	  alert(v3x.getMessage("InquiryLang.inquiry_has_finsihed"));
				    	 	return false;
			     	  }else if(ds == 8 || ds ==-1){
			     		 if(confirm(v3x.getMessage("InquiryLang.inquiry_cancel_alert"))){
				    		    mainForm.method = 'post';
					    	    mainForm.submit();
			     		 }
			    	 }else{
			    		 alert(v3x.getMessage("InquiryLang.inquiry_is_not_send"));
			    		 return false;
				     }
		    		
		      }
	    }else{
             for (i = 0; i <len; i++)
             {
                   if (document.mainForm.id[i].checked == true)
                   {
                   
                   		var id = document.mainForm.id[i].value;
                  		var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "validateInquiryExist", false);
						requestCaller.addParameter(1, "Long", id);
						var ds = requestCaller.serviceRequest();

					      if(ds == 5){
					    	  alert(v3x.getMessage("InquiryLang.inquiry_has_finsihed"));
					    	 	return false;
				     	  }else if(ds == 1 || ds == 2 || ds == 3 || ds == 4){
				     		 alert(v3x.getMessage("InquiryLang.inquiry_is_not_send"));
				    		 return false;
					     }
                   		
                       checked = true;
                       continue;
                   }
             }
             if (!checked)
             {
            	 alert(v3x.getMessage("InquiryLang.inquiry_choose_item_from_list"));
                 return false;
             }else{
            	 if(confirm(v3x.getMessage("InquiryLang.inquiry_cancel_alert"))){
		    		    mainForm.method = 'post';
			    	    mainForm.submit();
	     		 }
             }
        }
    }
	  
    function dateChecks () {
        var condition = document.getElementById('condition').value;
        if (condition == 'createDate') {
            return dateCheck();
        } else {
            doSearch();
        }
    }
//-->    
</script>

<c:set value="${v3x:parseElements(auList, 'id', 'entityType')}" var="auList"/>
<script type="text/javascript">
<!--
var includeElements_per = "${v3x:parseElementsOfTypeAndId(entity)}";
//-->
</script>
<v3x:selectPeople id="per" panels="Department,Post,Level,Team" minSize="0"
	selectType="Member,Account,Department,Level,Team,Post"
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
	originalElements="${auList}" jsFunction="setPeopleFields(elements)" />
	
<script type="text/javascript">
    var authlist="${authlist.authlist}";
    //alert(authlist);
    //elements_per = parseElements(authlist);
    
</script>
<script type="text/javascript">
 <!--
 var includeElements_second = "${v3x:parseElementsOfTypeAndId(entity)}";
 //-->
 </script>
<v3x:selectPeople id="second" panels="Department,Team,Post,Level"
	selectType="Member"
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
	jsFunction="setPeopleFieldsSecond(elements)" maxSize="1" />
	
</head>

<body scroll="no">

<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
<c:if test="${checkerbutton == 'inquiry_checker' || hasCheckAuth==true}">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
		
			<div class="div-float">
			<div class="tab-separator"></div>
			<div class="tab-tag-left-sel"></div>
			<div class="tab-tag-middel-sel"><fmt:message key="inquiry.manage.inquiry.label"></fmt:message></div>
			<div class="tab-tag-right-sel"></div>
	
			<div class="tab-separator"></div>
			
			<div class="tab-tag-left"></div>
			<div class="tab-tag-middel"><a href="${basicURL}?method=checkerListFrame&group=${v3x:toHTML(group)}&typeId=${inquirytype.id}&spaceType=${v3x:toHTML(param.spaceType)}&spaceId=${v3x:toHTML(param.spaceId)}" class="non-a">
			<fmt:message key="inquiry.auditor.manage.label"></fmt:message></a>
			</div>
			<div class="tab-tag-right"></div>
			<div class="tab-separator"></div>
			</div>
			
		</td>
	</tr>
</c:if>	
	<tr>
		<td colspan="2" valign="top">
			<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="22" class="">
						<script>
							//first
							var ctxResources = <c:out value="${CurrentUser.resourceJsonStr}" default="null" escapeXml="false"/>;
							if( '${checkerbutton}' == 'inquiry_checker' || '${v3x:escapeJavascript(hasCheckAuth)}'=='true'){
								var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","gray");
							}else{
								var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
							}
							<c:if test="${v3x:hasPlugin('doc')}">
							if(v3x.getBrowserFlag('hideMenu')){
								myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />", "myPigeonhole()",[1,9], "<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />", null));
							}
							</c:if>
							myBar.add(new WebFXMenuButton("cancel", "<fmt:message key='common.toolbar.cancelIssue.label' bundle='${v3xCommonI18N}'/>", "cancelInquiry()", [5,9], "<fmt:message key='common.toolbar.cancelIssue.label' bundle='${v3xCommonI18N}' />", null));
							
							var boardManage = new WebFXMenu;	
							if(!('${v3x:escapeJavascript(custom)}' == 'true')) {
								boardManage.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.auth.label' bundle='${v3xCommonI18N}'/>", "selectPeopleFun_per();"));
							}
							boardManage.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.statistics.label' bundle='${v3xCommonI18N}' />", "viewStatistics('${newsURL}?method=publishInfoStc&mode=inquiry&typeId=${param.surveytypeid}');"));
							myBar.add(new WebFXMenuButton("boardManage", "<fmt:message key='common.toolbar.boardmanage.label' bundle='${v3xCommonI18N}' />", null, [12,9], "", boardManage));
							myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "delOk('manage')", [1,3], "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", null));
							
							<c:if test="${fn:length(manageTypeList) > 1}">
								var sendToSubItems = new WebFXMenu;
								var moveToType ="";
								<c:forEach items="${manageTypeList}" var="type" varStatus="index" >
									<c:if test="${type.inquirySurveytype.id != param.surveytypeid}">
										sendToSubItems.add(new WebFXMenuItem("bti${index}", "${v3x:toHTML(v3x:getLimitLengthString(type.inquirySurveytype.typeName, 15,'...'))}", "changeType('${type.inquirySurveytype.id}');", "", "${v3x:toHTML(type.inquirySurveytype.typeName)}"));
										moveToType=moveToType+"${type.inquirySurveytype.id}"+",";
									</c:if>
								</c:forEach>
								myBar.add(new WebFXMenuButton("sendto", "<fmt:message key='common.toolbar.board.switch.label' bundle='${v3xCommonI18N}'/>", "", [9,6],"", sendToSubItems));
								myBar.add(new WebFXMenuButton("moveBtn", "<fmt:message key='bulletin.menu.move.label' bundle='${bulI18N}'/>","moveTo(moveToType);",[2,1], "", null));
							</c:if>
							<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
							document.write(myBar);
						</script>
					</td>
					
					<c:choose>
						<c:when test="${  checkerbutton == 'inquiry_checker' || hasCheckAuth==true}">
							<td class="webfx-menu-bar-gray">
						</c:when>
						<c:otherwise>
							<td class="webfx-menu-bar">
						</c:otherwise>
					</c:choose>
					
						<form action="${basicURL}" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
							<input type="hidden" value="<c:out value='${param.method}' />" name="method">
							<input type="hidden" value="${inquirytype.id}" name="surveytypeid">
							<input type="hidden" value="${v3x:toHTML(group)}" name="group">
							<input type="hidden" value="mid" name="mid">
							<input type="hidden" value="${v3x:toHTML(custom)}" name="custom">
							<input type="hidden" value="${v3x:toHTML(param.spaceType)}" name="spaceType">
			 				<input type="hidden" value="${v3x:toHTML(param.spaceId)}" name="spaceId">
							<div class="div-float-right">
								<div class="div-float">
								<select id="condition" name="condition" onChange="showNextCondition(this)" class="condition">
									<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
									<option value="sender"><fmt:message key="inquiry.creater.label" /></option>
									<option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
									<option value="createDate"><fmt:message key="inquiry.date.create"/></option>
								</select></div>
								<div id="senderDiv" class="div-float hidden"><input type="text" id="textfield" name="textfield" onkeydown="javascript:searchWithKey()"></div>
								<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield" onkeydown="javascript:searchWithKey()"></div>
								
								<div id="createDateDiv" class="div-float hidden">
									<input type="text" id="startdate" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly onkeydown="javascript:searchWithKey()"> - 
									<input type="text" id="enddate" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly onkeydown="javascript:searchWithKey()">
								</div>
								<div onclick="javascript:return dateChecks()" class="div-float condition-search-button button-font-color"></div>
							</div>
						</form>
					</td>
				</tr>
				<tr>
					<td colspan="2">
					
					<div class="scrollList">
					<form action="" name="mainForm" id=""mainForm"" method="post">
					
					<c:choose>
					<c:when test="${checkerbutton == 'inquiry_checker' || hasCheckAuth==true}">
			         <v3x:table
						data="${blist}" var="con" htmlId="aa" isChangeTRColor="true"
						showHeader="true" showPager="true" pageSize="20" leastSize="0" subHeight="60">
						
						<v3x:column width="5%" align="center"
							label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
							<input type='checkbox' name='id' value="${con.inquirySurveybasic.id}" attFlag="${con.inquirySurveybasic.attachmentsFlag}" />
						</v3x:column>
						
						<c:set var="onclick" value="inquiryDetail('${con.inquirySurveybasic.id}')" />	
						<v3x:column type="String" label="common.subject.label" width="30%"
							 className="sort cursor-hand" symbol="..." hasAttachments="${con.inquirySurveybasic.attachmentsFlag}" maxLength="26" 
							 alt="${con.inquirySurveybasic.surveyName}" onClick="javascript:${onclick}">
							 ${v3x:toHTML(con.inquirySurveybasic.surveyName)}
							 </v3x:column>	   
						<v3x:column type="String" width="10%" label="inquiry.creater.label" symbol="..." maxLength="12" value="${v3x:showOrgEntitiesOfIds(con.inquirySurveybasic.createrId, 'Member', pageContext)}" alt="${v3x:showOrgEntitiesOfIds(con.inquirySurveybasic.issuerId, 'Member', pageContext)}" className="sort cursor-hand"></v3x:column>
					     <%--<v3x:column  type="Number" width="9%" label="inquiry.people.count.label"  value="${con.inquirySurveybasic.totals}" className="sort" align="left">
					     </v3x:column>--%>
					     <v3x:column  type="Number" width="10%" label="inquiry.click.count.label"  value="${con.inquirySurveybasic.clickCount}" className="sort cursor-hand" align="left">
					     </v3x:column>  	   
					     <v3x:column  type="Number" width="10%" label="inquiry.vote.count.label" value="${con.inquirySurveybasic.voteCount}" className="sort cursor-hand" align="left">
					     </v3x:column>
						<v3x:column  type="String" width="10%" label="inquiry.scope.label"  className="sort cursor-hand" alt="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}"  symbol="..." maxLength="16" value="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}">
					    </v3x:column>
					   <v3x:column type="Date" width="15%" label="inquiry.date.create"  className="sort cursor-hand" align="left"><fmt:formatDate value="${con.inquirySurveybasic.sendDate}" pattern="${ datetimePattern }"/></v3x:column>
					   <v3x:column type="String" width="10%" label="inquiry.deal.state.label"  className="sort cursor-hand" align="left">
					   	<c:choose>
					   		<c:when test="${con.inquirySurveybasic.censor==5}">
					   			<fmt:message key="inquiry.deal.state.label.5"/>
					   		</c:when>
					   		<c:otherwise>
					   			<fmt:message key="inquiry.deal.state.label.8"/>
					   		</c:otherwise>
					   	</c:choose>
					   </v3x:column>
					</v3x:table>
					</c:when>
					<c:otherwise>
			         <v3x:table
						data="${blist}" var="con" htmlId="aa" isChangeTRColor="true"
						showHeader="true" showPager="true" pageSize="20" leastSize="0" subHeight="40">
						
						<v3x:column width="5%" align="center"
							label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
							<input type='checkbox' name='id' value="${con.inquirySurveybasic.id}" attFlag="${con.inquirySurveybasic.attachmentsFlag}" />
						</v3x:column>
						
						<c:set var="onclick" value="inquiryDetail('${con.inquirySurveybasic.id}')" />	
						<v3x:column type="String" label="common.subject.label" width="30%"
							 className="sort cursor-hand" symbol="..." hasAttachments="${con.inquirySurveybasic.attachmentsFlag}" maxLength="26" 
							 alt="${con.inquirySurveybasic.surveyName}" onClick="javascript:${onclick}">
							 ${v3x:toHTML(con.inquirySurveybasic.surveyName)}
							 </v3x:column>	   
						<v3x:column type="String" width="10%" label="inquiry.creater.label" symbol="..." maxLength="12" value="${v3x:showOrgEntitiesOfIds(con.inquirySurveybasic.createrId, 'Member', pageContext)}" alt="${v3x:showOrgEntitiesOfIds(con.inquirySurveybasic.issuerId, 'Member', pageContext)}" className="sort cursor-hand"></v3x:column>
					     <%--<v3x:column  type="Number" width="9%" label="inquiry.people.count.label"  value="${con.inquirySurveybasic.totals}" className="sort" align="left">
					     </v3x:column>--%>
					     <v3x:column  type="Number" width="10%" label="inquiry.click.count.label"  value="${con.inquirySurveybasic.clickCount}" className="sort cursor-hand" align="left">
					     </v3x:column>  	   
					     <v3x:column  type="Number" width="10%" label="inquiry.vote.count.label" value="${con.inquirySurveybasic.voteCount}" className="sort cursor-hand" align="left">
					     </v3x:column>
						<v3x:column  type="String" width="10%" label="inquiry.scope.label"  className="sort cursor-hand" alt="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}"  symbol="..." maxLength="16" value="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}">
					    </v3x:column>
					   <v3x:column type="Date" width="15%" label="inquiry.date.create"  className="sort cursor-hand" align="left"><fmt:formatDate value="${con.inquirySurveybasic.sendDate}" pattern="${ datetimePattern }"/></v3x:column>
					   <v3x:column type="String" width="10%" label="inquiry.deal.state.label"  className="sort cursor-hand" align="left">
					   	<c:choose>
					   		<c:when test="${con.inquirySurveybasic.censor==5}">
					   			<fmt:message key="inquiry.deal.state.label.5"/>
					   		</c:when>
					   		<c:otherwise>
					   			<fmt:message key="inquiry.deal.state.label.8"/>
					   		</c:otherwise>
					   	</c:choose>
					   </v3x:column>
					</v3x:table>
					</c:otherwise>
					</c:choose>
					

			        
					<input type="hidden" name="authscope" id="authscope">
					</form>
					</div>	
				</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<iframe src="javascript:void(0)" name="grantIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe> 
</body>
</html>