<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<html>
<head>
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script language="javascript">
<!--
	
	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
	
	<c:if test="${group!=null&&group!=''}">
		getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(23); 
	</c:if>
	
	<c:if test="${group==null}">
		getA8Top().showLocation(702,'${inquirytype.typeName}');
	</c:if>
	
    function showGrant(){
       v3x.openWindow({
			url : "${basicURL}?method=authorities_index&surveytypeid=${param.surveytypeid}",
			width : "500",
			height : "350",
			resizable : "true",
			scrollbars : "true"
		});
    }
    
    function inquiryDetail(id){
		var acturl = "${basicURL}?method=showInquiryFrame&surveytypeid=${param.surveytypeid}&bid=" + id +"&group=${group}";
	    //document.location.href = acturl;
	    //弹出调查页面
		openWin(acturl);
    }
    function delOk(optionID){
	    mainForm.action="${basicURL}?method=sbasic_remove&surveytypeid=${param.surveytypeid}&op="+optionID+"&typeName=${typeName}&group=${group}";
	    var len = document.mainForm.id.length;
        var checked = false;
        if(isNaN(len)){
             if(!document.mainForm.id.checked){
		           alert(v3x.getMessage("InquiryLang.inquiry_alertDeleteItem"));
		      }else{
		      		var censorIDs = document.mainForm.censorIDs.value;
		      		if(censorIDs!=null && censorIDs==-1){
			    	 	alert(_("InquiryLang.inquiry_has_send_can_not_delete"));
			    	 	return false;
			    	}
		    		if(confirm(v3x.getMessage("InquiryLang.inquiry_delete_alert"))){
		    		    mainForm.method = 'post';
			    	    mainForm.submit();
				   }
		      }
	    }else{
             for (i = 0; i <len; i++)
             {
                   if (document.mainForm.id[i].checked == true)
                   {
                   		if(document.mainForm.id[i].getAttribute("state")==-1){
	                     	alert(_("InquiryLang.inquiry_has_send_can_not_delete"));
	                      	return false;
	                   	}
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
       		    	 var censorIDs = document.mainForm.censorIDs.value;
			    	 if(censorIDs!=null && censorIDs==1){
			    	 	alert(_("InquiryLang.inuiry_no_through"));
			    	 	return false;
			    	 }
			    	 if(censorIDs!=null && censorIDs==2){
			    	 }
			    	 if(censorIDs!=null && censorIDs==3){
			    	 	alert(_("InquiryLang.inuiry_is_draft"));
			    	 	return false;
			    	 }
			    	 if(censorIDs!=null && censorIDs==4){
			    	 	alert(_("InquiryLang.inuiry_no_auditing"));
			    	 	return false;
			    	 }
			    	 if(censorIDs!=null && censorIDs==5){
			    	 	alert(_("InquiryLang.inuiry_is_stop"));
			    	 	return false;
			    	 }
			    	 if(censorIDs!=null && censorIDs==-1){
			    	 	alert(_("InquiryLang.inquiry_has_send"));
			    	 	return false;
			    	 }
		       }
	     }else{
              for (i = 0; i <len; i++){
                   	if (document.mainForm.id[i].checked == true){
	              		if(document.mainForm.id[i].getAttribute("state")==1){
	                     	alert(_("InquiryLang.inuiry_no_through"));
	                      	return false;
	                   	}else if(document.mainForm.id[i].getAttribute("state")==4){
	                      	alert(v3x.getMessage("InquiryLang.inuiry_send"));
	                      	return false;
	                   	}else if(document.mainForm.id[i].getAttribute("state")==5){
	                      	alert(_("InquiryLang.inuiry_is_stop"));
	                      	return false;
	                    }else if(document.mainForm.id[i].getAttribute("state")==-1){
	                      	alert(_("InquiryLang.inquiry_has_send"));
	                      	return false;
	                    }else if(document.mainForm.id[i].getAttribute("state")==3){
	                      	alert(_("InquiryLang.inuiry_is_draft"));
	                      	return false;
	                    }else{
	                      	checked = true;
	                   	}
               		}
                   s++;
                  
              }
              if (!checked)
              {
                    alert(v3x.getMessage("InquiryLang.inquiry_choose_the_send_alert"));
                    return false;
              }
         }
	     mainForm.action="${basicURL}?method=creator_public&surveytypeid=${param.surveytypeid}&group=${group}";
         mainForm.submit();
   }

    function unpublic(){
	      document.location.href ="${basicURL}?method=basic_NO_send&surveytypeid=${param.surveytypeid}&group=${group}";
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
              document.location.href ="${basicURL}?method=promulgation&surveytypeid=${param.surveytypeid}&group=${group}";
    }
    
    
    function updateInquiry(bid){
              document.location.href ="${basicURL}?method=get_template&bid="+bid+"&delete=delete&surveytypeid=${param.surveytypeid}&update=update&typeName=${typeName}&group=${group}"; 
    }
    
--></script>

<v3x:selectPeople id="second" panels="Department,Team,Post,Level" selectType="Member" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFieldsSecond(elements)" maxSize="1" />
</head>
<body class="tab-body">
 <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			    <div class="div-float">
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel"><a href="${basicURL}?method=survey_index&surveytypeid=${param.surveytypeid}&group=${group}" class="non-a"><fmt:message key="inquiry.look.over.label"></fmt:message></a></div>
				<div class="tab-tag-right"></div>
				<!-- 
				<div class="tab-separator"></div>
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel"><a href="${basicURL}?method=promulgation&surveytypeid=${param.surveytypeid}" class="non-a">新建</a></div>
			    <div class="tab-tag-right"></div>
			     -->
				<div class="tab-separator"></div>
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel"><a href="${basicURL}?method=basic_NO_send&surveytypeid=${param.surveytypeid}&group=${group}" class="non-a"><fmt:message key="inquiry.create.label"></fmt:message></a></div>
				<div class="tab-tag-right-sel"></div>
			</div>
		</td>
		
	</tr>
	<tr>
		<td colspan="2" class="tab-body-bg-copy">
			<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="22" class="webfx-menu-bar-gray">
			        <script>
							<c:if test="${ issuer=='inquiry_issuer' || manager=='inquiry_manager'}">
							    var myBar = new WebFXMenuBar("","gray");
							         myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", "newInquiry()", "<c:url value='/common/images/toolbar/new.gif'/>","<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>" ,null));
					                 myBar.add(new WebFXMenuButton("send", "<fmt:message key='inquiry.publish' />", "promulgation()", "<c:url value='/common/images/toolbar/send.gif'/>", "<fmt:message key='inquiry.publish' />", null));
			                         myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "delOk('nopublic')", "<c:url value='/common/images/toolbar/delete.gif'/>", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", null));
					            document.write(myBar);
							</c:if>
				    </script></td>
					<td class="webfx-menu-bar-gray">
					<form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
					
						<input type="hidden" value="<c:out value='${param.method}' />" name="method">
						<input type="hidden" value="${param.surveytypeid}" name="surveytypeid">
						<input type="hidden" value="${group}" name="group">
						<div class="div-float-right">
						
							<div class="div-float">
								<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
									<option value="subject"><fmt:message key="inquiry.option.selectCondition.text" /></option>
									<option value="subject"><fmt:message key="inquiry.subject.label" /></option>
									<option value="createDate"><fmt:message key="common.issueDate.label"  bundle="${v3xCommonI18N}" /></option>
								</select>
							</div>
							
							<div id="subjectDiv" class="div-float">
								<input type="text" name="textfield" class="textfield">
							</div>
							
							<div id="createDateDiv" class="div-float hidden">
							
								<input type="text" name="textfield" id="fromDate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
							  		-
							  	<input type="text" name="textfield1" id="toDate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
								
							</div>
							
							<div onclick="javascript:doSearch()" class="condition-search-button"></div>
						
						</div>
						<input type="hidden" name="page_b" value="page_b">
					</form>
					</td>
				</tr>
				<tr>
					<td colspan="2">
					
					<div class="scrollList">
					<form action="" name="mainForm" id=""mainForm"" method="post">
			         <v3x:table data="${blist}" var="con" htmlId="" isChangeTRColor="true" showHeader="true" showPager="true" pageSize="20" leastSize="0">
						   <v3x:column width="5%" align="center"
							label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
						 	<input type='checkbox' name='id' state='${con.inquirySurveybasic.censor}' value="${con.inquirySurveybasic.id}" />
						   </v3x:column>
						<c:set var="onclick" value="inquiryDetail('${con.inquirySurveybasic.id}')" />	
						<v3x:column  type="String" label="common.subject.label" value="${con.inquirySurveybasic.surveyName}"
							 onClick="${onclick}" className="cursor-hand sort" symbol="..." maxLength="26" alt="${con.inquirySurveybasic.surveyName}" width="22%"></v3x:column>		   
					    <c:if test="${nopublic!='nopublic'&&public!='public'}">
						   <v3x:column label="common.issuer.label" value="${v3x:showOrgEntitiesOfIds(con.sender.id, 'Member', pageContext)}" onClick="${onclick}" className="cursor-hand sort"></v3x:column>
					    </c:if>
					    <v3x:column  type="String" label="common.issueScope.label" onClick="${onclick}" className="cursor-hand sort" alt="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}"  symbol="..." maxLength="34" value="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}">
					    </v3x:column>
			        	<v3x:column type="Date" label="common.issueDate.label" onClick="${onclick}" className="cursor-hand sort" align="left"><fmt:formatDate value="${con.inquirySurveybasic.sendDate}" pattern="${ datetimePattern }"/></v3x:column>
				       <c:choose>
				           <c:when test="${con.inquirySurveybasic.closeDate eq null }">
				            <v3x:column   type="String" label="inquiry.close.time.label" onClick="${onclick}" className="cursor-hand sort" width="17%" align="left"><fmt:message key="inquiry.no.limit" /></v3x:column>		      
				           </c:when>
						   <c:otherwise>
						    <v3x:column type="Date" label="inquiry.close.time.label" onClick="${onclick}" className="cursor-hand sort" width="17%" align="left"><fmt:formatDate value="${con.inquirySurveybasic.closeDate}" pattern="${ datetimePattern }"/></v3x:column>		      
						   </c:otherwise>	         
				         </c:choose> 	
				         <c:if test="${nopublic=='nopublic'}">
					   		<v3x:column  type="String" label="inquiry.state.label">
								<c:if test='${con.inquirySurveybasic.censor==1}'><fmt:message key="inquiry.state.forbid.label"/>&nbsp;<input type="button" value="<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />" onclick="updateInquiry('${con.inquirySurveybasic.id}')">
									<input type="hidden" id="censorIDs" name="censorIDs" value="1" />
								</c:if>
								<c:if test='${con.inquirySurveybasic.censor==2}'><fmt:message key="inquiry.state.pass.label"/>
									<input type="hidden" id="censorIDs" name="censorIDs" value="2" />
								</c:if>
								<c:if test='${con.inquirySurveybasic.censor==3}'><fmt:message key="inquiry.state.draught.label"/>&nbsp;<input type="button" value="<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />" onclick="updateInquiry('${con.inquirySurveybasic.id}')">
									<input type="hidden" id="censorIDs" name="censorIDs" value="3" />
								</c:if>
								<c:if test='${con.inquirySurveybasic.censor==4}'><fmt:message key="inquiry.state.NotCheck.label"/>
					   	 			<input type="hidden" id="censorIDs" name="censorIDs" value="4" />
								</c:if>
								<c:if test='${con.inquirySurveybasic.censor==5}'><fmt:message key="inquiry.state.stop.label"/>
									<input type="hidden" id="censorIDs" name="censorIDs" value="5" />
								</c:if>
								<c:if test='${con.inquirySurveybasic.censor==-1}'><fmt:message key="inquiry.state.passnotbegin"/>
									<input type="hidden" id="censorIDs" name="censorIDs" value="-1" />
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
 
</body>
</html>