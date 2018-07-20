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

	<c:if test="${param.where != 'space' && param.custom != 'true'}">
		<c:choose>
			<c:when test="${group=='group'}">
			    getA8Top().showLocation(null, v3x.getMessage("InquiryLang.group_inquiry_manage"), "${v3x:escapeJavascript(theType.typeName)}");
			</c:when>
			<c:otherwise>
				getA8Top().showLocation(null, v3x.getMessage("InquiryLang.account_inquiry_manage"), "${v3x:escapeJavascript(theType.typeName)}");
			</c:otherwise>
		</c:choose>
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
		var acturl = "${basicURL}?method=showInquiryFrame&surveytypeid=${param.surveytypeid}&bid=" + id+"&spaceId=${param.spaceId}";
//	   document.location.href = acturl;
		openWin(acturl) ;
    }

    function delOk(optionID){
	    mainForm.action="${basicURL}?method=sbasic_remove&surveytypeid=${param.surveytypeid}&op="+optionID+"&typeName=${typeName}&spaceType=${param.spaceType}&spaceId=${param.spaceId}";
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
	     mainForm.action="${basicURL}?method=creator_public&surveytypeid=${param.surveytypeid}&spaceType=${param.spaceType}&spaceId=${param.spaceId}";
         mainForm.submit();
   }


    function unpublic(){
	      document.location.href ="${basicURL}?method=basic_NO_send&surveytypeid=${param.surveytypeid}&spaceType=${param.spaceType}&spaceId=${param.spaceId}";
	     // mainForm.submit();
    }
   
   
   
   function setPeopleFieldsSecond(elements)
	{
		if(!elements){
			return;
		}
		document.getElementById("textfield").value=getNamesString(elements);
		document.getElementById("textfield1").value=getIdsString(elements,false);
	
	}
    
    
    function newInquiry(){
              document.location.href ="${basicURL}?method=promulgation&surveytypeid=${param.surveytypeid}&spaceType=${param.spaceType}&spaceId=${param.spaceId}";  
    }
    
    
    function updateInquiry(bid){
              document.location.href ="${basicURL}?method=get_template&bid="+bid+"&delete=delete&surveytypeid=${param.surveytypeid}&update=update&typeName=${typeName}&spaceType=${param.spaceType}&spaceId=${param.spaceId}"; 
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

<v3x:selectPeople id="second" panels="Department,Team,Post,Level"
	selectType="Member"
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
	jsFunction="setPeopleFieldsSecond(elements)" maxSize="1" />
</head>
<body  style="padding:5px;">
 <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			    <div class="div-float">
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel"><a href="${basicURL}?method=survey_index&surveytypeid=${param.surveytypeid}&spaceType=${param.spaceType}&spaceId=${param.spaceId}" class="non-a"><fmt:message key="inquiry.look.over.label"></fmt:message></a></div>
				<div class="tab-tag-right-sel"></div>
				<c:if test="${issuer=='inquiry_issuer'||manager=='inquiry_manager'}">
				<div class="tab-separator"></div>
                <!--
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel"><a href="${basicURL}?method=promulgation&surveytypeid=${param.surveytypeid}" class="non-a">新建</a></div>
				<div class="tab-tag-right"></div>
				-->
				<div class="tab-separator"></div>
				
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel"><a href="${basicURL}?method=basic_NO_send&surveytypeid=${param.surveytypeid}&group=${group}&spaceType=${param.spaceType}&spaceId=${param.spaceId}" class="non-a"><fmt:message key="inquiry.create.label"></fmt:message></a></div>
				<div class="tab-tag-right"></div>
				
				</c:if>
			<!--查询 start -->
			<form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
			 	<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			 	<input type="hidden" value="${param.surveytypeid}" name="surveytypeid">
			 	<input type="hidden" value="${group}" name="group">
			 	<input type="hidden" value="${param.spaceType}" name="spaceType">
			 	<input type="hidden" value="${param.spaceId}" name="spaceId">
				<div class="div-float-right">
							<div class="div-float">
							<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
								<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
								<option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
								<option value="creater"><fmt:message key="inquiry.creater.label"/></option>
								<option value="createDate"><fmt:message key="common.issueDate.label" bundle="${v3xCommonI18N}"/></option>
							</select></div>
							<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield" onkeydown="javascript:searchWithKey()"></div>
							<div id="createrDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield" onkeydown="javascript:searchWithKey()"></div>
							<div id="createDateDiv" class="div-float hidden">
								<input type="text" id="startdate" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly onkeydown="javascript:searchWithKey()"> - 
								<input type="text" id="enddate" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly onkeydown="javascript:searchWithKey()">
							</div>
					<div onclick="javascript:return dateChecks()" class="div-float condition-search-button button-font-color"></div>
				</div>
		</form>
		<!--查询 end -->
		</div>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="tab-body-border">
<table height="100%" width="100%" border="0" cellspacing="0"
	cellpadding="0">
	<tr>
		<td colspan="2">
		
		<div class="scrollList">
		<form action="" name="mainForm" id=""mainForm"" method="post">
         <v3x:table
			data="${blist}" var="con" htmlId="" isChangeTRColor="true"
			showHeader="true" showPager="true" pageSize="20" leastSize="0">
		    <c:if test="${public=='public'|| nopublic=='nopublic'}">
			   <v3x:column width="5%" align="center"
				label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
			 	<input type='checkbox' name='id' value="${con.inquirySurveybasic.id}" />
			   </v3x:column>
			</c:if>
			<c:set var="onclick" value="inquiryDetail('${con.inquirySurveybasic.id}')" />				
			<v3x:column  type="String" label="common.subject.label" value="${con.inquirySurveybasic.surveyName}"
				 className="cursor-hand sort" symbol="..." maxLength="26" alt="${con.inquirySurveybasic.surveyName}" width="22%" onClick="javascript:${onclick}">
				${con.inquirySurveybasic.surveyName}
			</v3x:column>	   
		    <c:if test="${nopublic!='nopublic'&&public!='public'}">
			   <v3x:column  type="String" label="common.issuer.label" symbol="..." maxLength="12" value="${v3x:showOrgEntitiesOfIds(con.inquirySurveybasic.issuerId, 'Member', pageContext)}" alt="${v3x:showOrgEntitiesOfIds(con.inquirySurveybasic.createrId, 'Member', pageContext)}" onClick="${onclick}" className="cursor-hand sort"></v3x:column>
		    </c:if>
		    <v3x:column width="15%" type="String" label="common.issueScope.label" onClick="${onclick}" className="cursor-hand sort" alt="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}"  symbol="..." maxLength="16" value="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}">
		    </v3x:column>
        	<v3x:column type="Date" label="common.issueDate.label" onClick="${onclick}" className="cursor-hand sort" align="left"><fmt:formatDate value="${con.inquirySurveybasic.sendDate}" pattern="${ datetimePattern }"/></v3x:column>
	         <c:choose>
	           <c:when test="${con.inquirySurveybasic.closeDate eq null}">
	            <v3x:column  type="String"  label="inquiry.close.time.label" onClick="${onclick}" className="cursor-hand sort" width="17%" align="left"><fmt:message key="inquiry.no.limit" /></v3x:column>		      
	           </c:when>
			   <c:otherwise>
			    <v3x:column type="Date" label="inquiry.close.time.label" onClick="${onclick}" className="cursor-hand sort" width="17%" align="left"><fmt:formatDate value="${con.inquirySurveybasic.closeDate}" pattern="${ datetimePattern }"/></v3x:column>		      
			   </c:otherwise>	         
	         </c:choose>
	       	</v3x:table>
		</form>
		</div>
	</td>
	</tr>
</table>
		</td>
	</tr>
</table>
</body>
</html>
