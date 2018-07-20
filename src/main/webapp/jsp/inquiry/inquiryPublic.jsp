<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">		
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<html>
<head>
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title>Insert title here</title>
<script language="javascript">
<!--

	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
	//TODO getA8
	<c:if test="${param.group == 'group'}">
		//TODO wanguangdong 2012-10-30
		<%--getA8Top().showLocation(7022, "${v3x:escapeJavascript(inquirytype.typeName)}");--%>
	</c:if>
	<c:if test="${param.group == 'account'}">
		if("${v3x:getSysFlagByName('sys_isGroupVer')}" == "true"){
			//TODO wanguangdong 2012-10-30
			<%--getA8Top().showLocation(7021, "${v3x:escapeJavascript(inquirytype.typeName)}");--%>
		}else{
			//TODO wanguangdong 2012-10-30 
			<%-- getA8Top().showLocation(712, "${v3x:escapeJavascript(inquirytype.typeName)}");--%>
		}
	</c:if>
	
    function showGrant(){
       v3x.openWindow({
			url : "${basicURL}?method=authorities_index&surveytypeid=${v3x:escapeJavascript(param.surveytypeid)}",
			width : "500",
			height : "350",
			resizable : "true",
			scrollbars : "true"
		});
    }
   
    function inquiryDetail(id,typeId){
	    //document.location.href = acturl;
	    //弹出调查页面
		//openWin(acturl);
		var state = stateMap.get(id);
		if(state == '8'){
		 	var acturl2 = "${basicURL}?method=showInquiryFrame&bid=" + id + "&surveytypeid=" + typeId+"&manager_ID=manager_ID&group=${v3x:escapeJavascript(param.group)}&spaceId=${v3x:escapeJavascript(param.spaceId)}";
			openWin(acturl2);
			return ;
		}else{
			var acturl = "${basicURL}?method=showInquiryFrame&surveytypeid=${v3x:escapeJavascript(param.surveytypeid)}&bid=" + id +"&group=${v3x:escapeJavascript(group)}&listShow=listShow&from=waitForAudit&spaceId=${v3x:escapeJavascript(param.spaceId)}";
			window.parent.detailFrame.location=acturl;
		}
    }
    function delOk(optionID){
	    mainForm.action="${basicURL}?method=sbasic_remove&surveytypeid=${v3x:escapeJavascript(param.surveytypeid)}&op="+optionID+"&typeName=${typeName}&group=${v3x:escapeJavascript(group)}&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${v3x:escapeJavascript(param.spaceId)}";
	    var len = document.mainForm.id.length;
        var checked = false;
        if(isNaN(len)){
             if(!document.mainForm.id.checked){
		           alert(v3x.getMessage("InquiryLang.inquiry_alertDeleteItem"));
		      }else{
		      			 var id= document.mainForm.id.value;
		     		     var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "validateInquiryExist", false);
						  requestCaller.addParameter(1, "Long", id);
						  var ds = requestCaller.serviceRequest();
		      
				      if(ds ==-1){
			      			alert(_("InquiryLang.inquiry_has_send_can_not_delete"));
				    	 	return false;
			     	  }else if(ds==8){
			    		    alert("调查已经发布！");
				    	 	return false;
			    	 }
		      		//var censorIDs = document.mainForm.censorIDs.value;
		      		//if(censorIDs!=null && censorIDs==-1){
			    	// 	alert(_("InquiryLang.inquiry_has_send_can_not_delete"));
			    	// 	return false;
			    	//}
		    		if(confirm(v3x.getMessage("InquiryLang.inquiry_delete_alert"))){
		    		    mainForm.method = 'post';
		    		    if(getA8Top() && getA8Top().startProc) getA8Top().startProc();
			    	    mainForm.submit();
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
	                   	if(ds ==-1){
			      			alert(_("InquiryLang.inquiry_has_send_can_not_delete"));
				    	 	return false;
			     	  }else if(ds==8){
			    		    alert("调查已经发布！");
				    	 	return false;
			    	 }
                   		//if(document.mainForm.id[i].getAttribute("state")==-1){
	                    // 	alert(_("InquiryLang.inquiry_has_send_can_not_delete"));
	                     // 	return false;
	                   //	}
                       checked = true;
                       break;
                   }
             }
             if (!checked)
             {
                   alert(v3x.getMessage("InquiryLang.inquiry_alertDeleteItem"));
                   return false;
             }else{
	                   if(confirm(v3x.getMessage("InquiryLang.inquiry_delete_alert"))){
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
         var  s = 1 ; 
         var  t = 0 ;
         var  name = [];

         if(isNaN(len)){
               if(!document.mainForm.id.checked){
		           alert(v3x.getMessage("InquiryLang.inquiry_choose_the_send_alert"));
                   return false;
		       }else{
	      		  var id= document.mainForm.id.value;
	     		  var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "validateInquiryExist", false);
				  requestCaller.addParameter(1, "Long", id);
				  var ds = requestCaller.serviceRequest();
	    			var curState = stateMap.get(id);
			    	 if(ds==1){
			    	 	alert(_("InquiryLang.inuiry_no_through"));
			    	 	if(curState != '1')
			    	 		getA8Top().reFlesh();
			    	 	return false;
			    	 }
			    	 if(ds==3){//草稿状态
			    	 	if('${inquirytype.censorDesc}' == '0'){//取到是否审核 0 审核 ，1不审核
				    	 	//alert(_("InquiryLang.inuiry_is_draft"));
				    	 	alert("调查未审核，不能直接发布！");
				    	 	if(curState != '3')
			    	 			getA8Top().reFlesh();
				    	 	return false;
			    	 	}
			    	 }
			    	 if(ds==4){
			    	 	alert(_("InquiryLang.inuiry_no_auditing"));
			    	 	if(curState != '4')
			    	 			getA8Top().reFlesh();
			    	 	return false;
			    	 }
			    	 if(ds==5){
			    	 	alert(_("InquiryLang.inuiry_is_stop"));
			    	 	if(curState != '5')
			    	 			getA8Top().reFlesh();
			    	 	return false;
			    	 }
			    	 if(ds==-1){
			    	 	alert(_("InquiryLang.inquiry_has_send"));
			    	 	if(curState != '-1')
			    	 			getA8Top().reFlesh();
			    	 	return false;
			    	 }
			    	 if(ds==8){
			    		    alert("调查已经发布！");
			    		    if(curState != '8')
			    	 			getA8Top().reFlesh();
				    	 	return false;
			    	 }
		       }
	     }else{
              for (i = 0; i <len; i++){
                   	if (document.mainForm.id[i].checked == true){
                   		var id = document.mainForm.id[i].value;
                  		var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "validateInquiryExist", false);
						requestCaller.addParameter(1, "Long", id);
						var ds = requestCaller.serviceRequest();
						var curState = stateMap.get(id);
	                   	if(ds==8){
			    		    alert("调查已经发布！");
			    		    if(curState != '8')
			    	 			getA8Top().reFlesh();
				    	 	return false;
				    	 }else if(ds==1){
	                     	alert(_("InquiryLang.inuiry_no_through"));
	                     	if(curState != '1')
			    	 			getA8Top().reFlesh();
	                      	return false;
	                   	}else if(ds==4){
	                   	  //alert(v3x.getMessage("InquiryLang.inuiry_send"));
	                   	 alert("调查未审核，不能直接发布！");
	                      	if(curState != '4')
			    	 			getA8Top().reFlesh();
	                      	return false;
	                   	}else if(ds==5){
	                      	alert(_("InquiryLang.inuiry_is_stop"));
	                      	if(curState != '5')
			    	 			getA8Top().reFlesh();
	                      	return false;
	                    }else if(ds==-1){
	                      	alert(_("InquiryLang.inquiry_has_send"));
	                      	if(curState != '-1')
			    	 			getA8Top().reFlesh();
	                      	return false;
	                    }else if(ds==3){
	                      	//alert(_("InquiryLang.inuiry_is_draft"));
	                      	//return false;
	                      	if('${inquirytype.censorDesc}' == '0'){			    	 	
					    	 	alert("调查未审核，不能直接发布！");
					    	 	return false;
			    	 		}			    	 	
	                    } 
	                    //else{
	                    //  	checked = true;
	                   	//}
	                    t++;
               		}
                 
                  
              }
              if (t<1) {
                    alert(v3x.getMessage("InquiryLang.inquiry_choose_the_send_alert"));
                    return false;
              }
         }
	     mainForm.action="${basicURL}?method=creator_public&surveytypeid=${v3x:escapeJavascript(param.surveytypeid)}&group=${v3x:escapeJavascript(group)}&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${v3x:escapeJavascript(param.spaceId)}";
	     if(getA8Top() && getA8Top().startProc) getA8Top().startProc();
	     mainForm.submit();
   }

    function unpublic(){
	      document.location.href ="${basicURL}?method=basic_NO_send&surveytypeid=${v3x:escapeJavascript(param.surveytypeid)}&group=${v3x:escapeJavascript(group)}&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${v3x:escapeJavascript(param.spaceId)}";
	     // mainForm.submit();
    }
   
   
   
    function setPeopleFieldsSecond(elements)
    {
	      if(!elements){
		      return;
	      }
        	document.getElementById("peopleValueSecond").value=getNamesString(elements);
	        document.getElementById("peopleIdSecond").value=getIdsString(elements,false);
	}
    
    
    function newInquiry(){
        openCtpWindow({'url':'${basicURL}?method=promulgation&surveytypeid=${v3x:escapeJavascript(param.surveytypeid)}&group=${v3x:escapeJavascript(group)}&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${v3x:escapeJavascript(param.spaceId)}'});
               //parent.parent.pulisIframe.location ="${basicURL}?method=promulgation&surveytypeid=${v3x:escapeJavascript(param.surveytypeid)}&group=${v3x:escapeJavascript(group)}&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${v3x:escapeJavascript(param.spaceId)}";
              //document.location.href ="${basicURL}?method=promulgation&surveytypeid=${v3x:escapeJavascript(param.surveytypeid)}&group=${v3x:escapeJavascript(group)}";
    }
    
    
    function updateInquiry(bid){
              document.location.href ="${basicURL}?method=get_template&bid="+bid+"&delete=delete&surveytypeid=${v3x:escapeJavascript(param.surveytypeid)}&update=update&typeName=${typeName}&group=${v3x:escapeJavascript(group)}&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${v3x:escapeJavascript(param.spaceId)}"; 
    }
    
    var stateMap = new Properties();
    
    //点击修改按钮响应事件
    function updateInquiryBasic(){
    	
    	var id = getSelectId();
		if(id == ''){
			alert(v3x.getMessage("InquiryLang.inquiry_choose_item_from_list"));
			return;
		}else if(validateCheckbox("id")>1){
			alert(v3x.getMessage("InquiryLang.inquiry_please_choose_one_data"));
			return;
		}
		
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "validateInquiryExist", false);
		requestCaller.addParameter(1, "Long", id);
		var ds = requestCaller.serviceRequest();
		
		if(ds==1||ds==3||ds==4 ){//1.审核未通过 3. 保存待发 4. 未审核
		    openCtpWindow({"url":"${basicURL}?method=get_template&bid="+id+"&delete=delete&surveytypeid=${v3x:escapeJavascript(param.surveytypeid)}&update=update&typeName=${typeName}&group=${v3x:escapeJavascript(group)}&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${v3x:escapeJavascript(param.spaceId)}"});
		}else{
			alert(v3x.getMessage("InquiryLang.inquiry_can_not_be_edit"));
			//window.location.reload(true);
			return ;
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
--></script>
<style type="">
.my_border_lr{
  border-left: 1px solid #b6b6b6;
  border-right: 1px solid #b6b6b6;
  width:99.6%;
}
</style>
<v3x:selectPeople id="second" panels="Department,Team,Post,Level" selectType="Member" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFieldsSecond(elements)" maxSize="1" />
</head>
<body class="listPadding">
 <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top"  height="100%">
			<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
					<td height="25" class="webfx-menu-bar">
				        <script>
								<c:if test="${ issuer=='inquiry_issuer' || manager=='inquiry_manager'}">
								    var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
								         myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", "newInquiry()", [1,1],"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>" ,null));
						                 myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "updateInquiryBasic();", [1,2], "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", null));
						                 myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "delOk('nopublic')", [1,3], "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", null));
						                 myBar.add(new WebFXMenuButton("send", "<fmt:message key='common.toolbar.oper.publish.label' bundle='${v3xCommonI18N}'/>", "promulgation()", [5,7], "<fmt:message key='common.toolbar.oper.publish.label' bundle='${v3xCommonI18N}' />", null));
//				                         myBar.add(
//											new WebFXMenuButton(
//											"",
//											"<fmt:message key='common.toolbar.refresh.label' bundle='${v3xCommonI18N}' />", 
//											"javascript:refreshIt()", 
//											[1,10], 
//											"", 
//											null
//											)
//										);
									//TODO wanguangdong 2012-10-26 v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
						            document.write(myBar);
								</c:if>
					    </script>
				    </td>
					<td class="webfx-menu-bar page2-list-header">
						<form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
						
							<input type="hidden" value="<c:out value='${param.method}' />" name="method">
							<input type="hidden" value="${v3x:toHTML(param.surveytypeid)}" name="surveytypeid">
							<input type="hidden" value="${v3x:toHTML(group)}" name="group">
							<input type="hidden" value="${custom}" name="custom">
							<input type="hidden" value="${v3x:toHTML(param.spaceType)}" name="spaceType">
							<input type="hidden" value="${v3x:toHTML(param.spaceId)}" name="spaceId">
							<div class="div-float-right">
							
								<div class="div-float">
									<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
										<option value=""><fmt:message key="inquiry.option.selectCondition.text" /></option>
										<option value="subject"><fmt:message key="inquiry.subject.label" /></option>
										<option value="createDate"><fmt:message key="inquiry.date.create" /></option>
									</select>
								</div>
								
								<div id="subjectDiv" class="div-float hidden">
									<input type="text" name="textfield" class="textfield" onkeydown="javascript:searchWithKey()">
								</div>
								
								<div id="createDateDiv" class="div-float hidden">
								
									<input type="text" id="startdate" name="textfield" id="fromDate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly onkeydown="javascript:searchWithKey()">
								  		-
								  	<input type="text" id="enddate" name="textfield1" id="toDate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly onkeydown="javascript:searchWithKey()">
									
								</div>
								
								<div onclick="javascript:return dateChecks()" class="div-float condition-search-button"></div>
							
							</div>
							<input type="hidden" name="page_b" value="page_b">
						</form>
					</td>
				</tr>
				<tr>
					<td colspan="2">
					
					<div class="scrollList my_border_lr" style="overflow-x:hidden;">
					<form action="" name="mainForm" id=""mainForm"" method="post">
			         <v3x:table data="${blist}" var="con" htmlId="inqueryId" isChangeTRColor="true" showHeader="true" showPager="true" pageSize="20" leastSize="0" subHeight="30">
						   <v3x:column width="5%" align="center"
							label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
						 	<input type='checkbox' name='id' state='${con.inquirySurveybasic.censor}' value="${con.inquirySurveybasic.id}" />
						 	<script>
						 		stateMap.put('${con.inquirySurveybasic.id}','${con.inquirySurveybasic.censor}');
						 	</script>
						   </v3x:column>
						<c:set var="onclick" value="inquiryDetail('${con.inquirySurveybasic.id}','${con.surveyTypeCompose.id}')" />	
						<v3x:column width="40%" type="String" label="common.subject.label" value="${con.inquirySurveybasic.surveyName}"
							 onClick="${onclick}" onDblClick="updateInquiryBasic()" className="cursor-hand sort" hasAttachments="${con.inquirySurveybasic.attachmentsFlag}" symbol="..." maxLength="200" alt="${con.inquirySurveybasic.surveyName}"></v3x:column>		   
					    <c:if test="${nopublic!='nopublic'}">
						   <v3x:column width="10%" label="common.issuer.label" value="${v3x:showOrgEntitiesOfIds(con.sender.id, 'Member', pageContext)}" onClick="${onclick}" onDblClick="updateInquiryBasic()" className="cursor-hand sort"></v3x:column>
					    </c:if>
					    <v3x:column width="15%" type="String" label="inquiry.scope.label" onClick="${onclick}" onDblClick="updateInquiryBasic()" className="cursor-hand sort" alt="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}"  symbol="..." maxLength="16" value="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}">
					    </v3x:column>
			        	<v3x:column width="15%" type="Date" label="inquiry.date.create" onClick="${onclick}" onDblClick="updateInquiryBasic()" className="cursor-hand sort" align="left"><fmt:formatDate value="${con.inquirySurveybasic.sendDate}" pattern="${ datetimePattern }"/></v3x:column>
				       <c:choose>
				           <c:when test="${con.inquirySurveybasic.closeDate eq null}">
				            <v3x:column   width="15%"  type="String" label="inquiry.close.time.label" onClick="${onclick}" onDblClick="updateInquiryBasic()" className="cursor-hand sort" align="left"><fmt:message key="inquiry.no.limit" /></v3x:column>		      
				           </c:when>
						   <c:otherwise>
						    <v3x:column type="Date" width="15%"  label="inquiry.close.time.label" onClick="${onclick}" onDblClick="updateInquiryBasic()" className="cursor-hand sort" align="left"><fmt:formatDate value="${con.inquirySurveybasic.closeDate}" pattern="${ datetimePattern }"/></v3x:column>		      
						   </c:otherwise>	         
				         </c:choose> 	
				         <c:if test="${nopublic=='nopublic'}">
					   		<v3x:column   width="10%" type="String" label="inquiry.state.label">
								<c:if test="${con.inquirySurveybasic.censor==1}"><fmt:message key="inquiry.state.forbid.label"/>&nbsp;
									<!--  菜单中已加入修改按钮 
										<input type="button" value="<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />" onclick="updateInquiry('${con.inquirySurveybasic.id}')">
									-->
									<input type="hidden" id="censorIDs" name="censorIDs" value="1" />
								</c:if>
								<c:if test="${con.inquirySurveybasic.censor==2}"><fmt:message key="inquiry.state.pass.label"/>
									<input type="hidden" id="censorIDs" name="censorIDs" value="2" />
								</c:if>
								<c:if test="${con.inquirySurveybasic.censor==3}"><fmt:message key="inquiry.state.draught.label"/>&nbsp;
									<!--  菜单中已加入修改按钮 
										<input type="button" value="<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />" onclick="updateInquiry('${con.inquirySurveybasic.id}')">
									-->
									<input type="hidden" id="censorIDs" name="censorIDs" value="3" />
								</c:if>
								<c:if test="${con.inquirySurveybasic.censor==4}"><fmt:message key="inquiry.state.NotCheck.label"/>
					   	 			<input type="hidden" id="censorIDs" name="censorIDs" value="4" />
								</c:if>
								<c:if test="${con.inquirySurveybasic.censor==5}"><fmt:message key="inquiry.state.stop.label"/>
									<input type="hidden" id="censorIDs" name="censorIDs" value="5" />
								</c:if>
								<c:if test="${con.inquirySurveybasic.censor==-1}"><fmt:message key="inquiry.state.passnotbegin"/>
									<input type="hidden" id="censorIDs" name="censorIDs" value="-1" />
								</c:if>
								<c:if test="${con.inquirySurveybasic.censor==8}">
									<fmt:message key="inquiry.deal.state.label.8"/>
								</c:if>
						    </v3x:column>
					    </c:if>
					</v3x:table>
					</form>
					</div>
				</td>
				</tr>
					<tr id="attachmentTR" class="bg-summary" style="display:none;">
						<td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message
							key="common.attachment.label" bundle="${v3xCommonI18N}" />:&nbsp;
						</td>
						<td colspan="8" valign="top">
						<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
						<v3x:fileUpload attachments="${attachments}" originalAttsNeedClone="true" /></td>
					</tr>
				<input type="hidden" name="loadFile" value="${attachments}">
			</table>
		</td>
	</tr>
</table>
 <div style="display: none;">
	<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
	<v3x:fileUpload attachments="${attachments}" originalAttsNeedClone="true" />
 </div>
<script type="text/javascript">
<!--
showDetailPageBaseInfo("detailFrame", "<fmt:message key='application.10.label' bundle="${v3xCommonI18N}" />", [2,1],pageQueryMap.get('count'),_("InquiryLang.detail_info_8005"));
//-->
</script>
</body>
</html>