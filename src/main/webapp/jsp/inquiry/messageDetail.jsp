<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${sbcompose.inquirySurveybasic.surveyName}</title>
<link rel="stylesheet" type="text/css"
	href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/skin/default/skin.css${v3x:resSuffix()}" />">
<style>
<!--
#discussul{
 list-style: none; 
 margin:0 0 0 18px; 
 font-weight:bold;
}
#discussul li{
margin:5px 0 5px 20px;
font-weight:normal;
color:#000000;
}
// -->
</style>
<script type="text/javascript">
parent.document.title = "${sbcompose.inquirySurveybasic.surveyName}";
var acount = new ArrayList();
function clickCount(chl,name,maxCount,id){
   var names= name +"items";
   var count =validateCheckbox(names);
   if(maxCount!=0 && count>maxCount){
     chl.checked =  false;
     alert(v3x.getMessage("InquiryLang.inquiry_out_most_alert"));
     return false;
   }
}

function voteSubmit(count){
     if(count ==0){
        return false;
     }
     for(var c =0;c<count;c++){
           var votecount = 0;
           var items = document.getElementsByName(c+'items');
           for(var icount = 0;icount<items.length;icount++){
                 if(items[icount].checked==true){
                   votecount++;
                 }
           }
           if(votecount<1){
             alert(v3x.getMessage("InquiryLang.inquiry_enter_something_alert")+(c+1)+v3x.getMessage("InquiryLang.inquiry_enter_question_something_alert"));
             return false;
           }
           try{
                var otherItems  = document.getElementById("other"+c+"items");
                if(otherItems.checked==true){
                      var othercontent = document.getElementsByName(c+"content");
                      if(othercontent[0].value ==""){
                           alert(v3x.getMessage("InquiryLang.inquiry_enter_something_alert")+(c+1)+v3x.getMessage("InquiryLang.inquiry_enter_question_other_alert"));
                            return false;
                       }      
                }
            }catch(e){}
     }
     var parentObj = top.window.dialogArguments;
     if(parentObj){
		top.window.close();
		mainForm.submit();
  	 }else{
    	mainForm.submit();
    	window.location.reload();
  	 }
}

function showResult(){
	var parentObj = top.window.dialogArguments;
    if(parentObj){
		location.replace("${basicURL}?method=survey_result&tid=${tid}&bid=${param.bid}&fromPigeonhole=${param.fromPigeonhole}");
	}
}


function enabledOtherItems(otherItemSort){
	var otherItem = eval(document.all.otherItemSort+"content");
	alert(otherItem);
	otherItem.disabled=false;
}

</script>
<script>showAttachment('<c:out value="${param.bid}" />', 0, '', '');</script>
</head>
<body scroll='auto'>
<form name="mainForm" action="${basicURL}?method=user_vote&tid=${sbcompose.inquirySurveybasic.inquirySurveytype.id}"
	method="post">
<input type="hidden" name="isDialog" value="dialog">
<table width="100%" border="0" cellspacing="0"
	cellpadding="0" align="center">
	<tr>
		<td class="webfx-menu-bar , bbs-td-center" colspan="2"
			align="left"><font style="font-size:14px"><c:out value="${sbcompose.inquirySurveybasic.surveyName}" /></font></td>
	</tr>

	<tr>
		<td>
	<a name="top" id="top"></a>
		<table width="100%" border="0" cellspacing="0" cellpadding="0"
			align="center">
			<tr>
				<td>
				<table width="100%" height="100%" border="0" cellspacing="0"
					cellpadding="0" class="bbs-table2">
					<tr>
						<td width="30%" class="tbCell2 , bbs-bg , bbs-tb-bottom"
							valign="top">


						<table width="100%" border="0"  align="left" valign="top">
							<tr>
								<td align="left" class="basic-look-over" width="30%" valign="top" colspan="3"><c:out value="${v3x:showOrgEntitiesOfIds(sbcompose.sender.id, 'Member', pageContext)}" /></td>
							</tr>
							<tr>
								<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.send.department.label" />:</td>
						    </tr>
							<tr>
							   <td  width="2%">&nbsp;</td>
							   <td  width="98%"><c:out value="${sbcompose.deparmentName.name}" /> </td>
							</tr>
							<tr height="2px">
							   <td colspan="3" height="2px"><div class="line"><sub></sub></div></td>
							</tr>
							<tr>
								<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.category.label" />:</td>
						    </tr>
						    <tr>
							   <td  width="2%">&nbsp;</td>
							   <td  width="98%"><c:out value="${sbcompose.inquirySurveybasic.inquirySurveytype.typeName}" /></td>
							</tr>
							<tr height="2px">
							   <td colspan="3" height="2px"><div class="line"><sub></sub></div></td>
							</tr>
							<tr>
								<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.date.rane.label" />:</td>
						    </tr>
							<tr>
							  <td  width="2%">&nbsp;</td>
							   <td  colspan="2"><fmt:formatDate
									value="${sbcompose.inquirySurveybasic.sendDate}" 
									pattern="${datetimePattern}" /> &nbsp;&nbsp;<fmt:message key="inquiry.to.label" /> </td>   
							</tr>
							<tr>
							   <td  width="2%">&nbsp;</td>
							   <td  colspan="2">
							   		 <c:choose>
								       <c:when test="${sbcompose.inquirySurveybasic.closeDate eq null}">
								                 <fmt:message key="inquiry.no.limit" />
								       </c:when>
									  <c:otherwise>
										     <fmt:formatDate value="${sbcompose.inquirySurveybasic.closeDate}" 	pattern="${datetimePattern}" />
									 </c:otherwise>	
							       </c:choose>
								</td>   
							</tr>
							<tr height="2px">
							   <td colspan="3" height="2px"><div class="line"><sub></sub></div></td>
							</tr>
							<c:if test="${sbcompose.inquirySurveybasic.censorId !='0'}">
							   <tr>
								   <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.auditor.label" />:</td>
						       </tr>
							   <tr>
									<td  width="2%">&nbsp;</td>
									<td colspan="2"><c:out value="${sbcompose.conser.name}" /></td>
							   </tr>
							   <tr height="2px">
							   <td colspan="3" height="2px"><div class="line"><sub></sub></div></td>
							  </tr>
							</c:if>
							<tr>
							  <tr>
								   <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="common.issueScope.label" bundle="${v3xCommonI18N}" />:</td>
						       </tr>
								 <tr>
									<td  width="2%">&nbsp;</td>
									<td colspan="2"><div  style=" width:180px;overflow:hidden; text-overflow:ellipsis;" title="${v3x:showOrgEntities(sbcompose.entity, "id", "entityType", pageContext)}" ><nobr>${v3x:showOrgEntities(sbcompose.entity, "id", "entityType", pageContext)}</nobr></div></td>
							   </tr>
							
						</table>
						</td>

						<td width="70%" valign='top' class="bbs-tb-bottom">
						<table width="100%" height="100%" border="0" cellspacing="0"
							cellpadding="0" style="word-break:break-all;word-wrap:break-word">
							<tr>
								<td class="tbCell4 , bbs-tb-padding2" valign="top">
								<p>${v3x:toHTML(sbcompose.inquirySurveybasic.surveydesc)}</p>
								<c:forEach
									items="${sbcompose.subsurveyAndICompose}" var="tname">
									<ul id="discussul">
										<c:out value="${tname.inquirySubsurvey.sort+1}" />
										.
										<c:out value="${tname.inquirySubsurvey.title}" /> 
										<input type="hidden" value="${tname.inquirySubsurvey.id}"
											name="subid">
										<c:if test="${tname.inquirySubsurvey.maxSelect>'0'}">
		   &nbsp;&nbsp;(<fmt:message key="inquiry.select.max.label" />:${tname.inquirySubsurvey.maxSelect})
		</c:if>                        
		                               <br> 
		                               <c:if test="${v3x:isNotBlank(tname.inquirySubsurvey.subsurveyDesc)}">
		                               		<li>
		                               			${v3x:toHTML(tname.inquirySubsurvey.subsurveyDesc)}
		                               		</li>
		                               	</c:if> 
										<c:set var="maxSort" value="0" />
										<c:set var="sOm" value="0" />
										<c:set var="sortvalue" value="0" />
										<c:forEach items="${tname.items}" var="sub">
											<c:if test="${tname.inquirySubsurvey.singleMany==0}">
												<li><input type='radio'
												  <c:if  test="${vote!='vote' || sbcompose.inquirySurveybasic.censor!='8'}">
			                                        disabled="disabled" 
			                                    </c:if>
													name='${tname.inquirySubsurvey.sort}items'
													value='${sub.id}'></li>
											</c:if>
											<c:if test="${tname.inquirySubsurvey.singleMany==1}">
												<li><input type='checkbox'  
												 <c:if  test="${vote!='vote' || sbcompose.inquirySurveybasic.censor!='8'}">
			                                      disabled="disabled" 
			                                    </c:if>
													name='${tname.inquirySubsurvey.sort}items'
													value='${sub.id}'
													onClick='clickCount(this,${tname.inquirySubsurvey.sort},${tname.inquirySubsurvey.maxSelect})'>
												</li>
											</c:if>
											<c:out value="${sub.content}" />
											<c:set var="maxSort" value="${sub.sort}" />
											<c:set var="sOm" value="${tname.inquirySubsurvey.singleMany}" />
											<c:set var="sortvalue" value="${tname.inquirySubsurvey.sort}" />


										</c:forEach>
										<c:if test="${tname.inquirySubsurvey.otheritem==0}">
											<li>
												<c:if test="${sOm==0}">
	
													<input type='radio'
													 <c:if test="${vote!='vote' || sbcompose.inquirySurveybasic.censor!='8'}">
				                                     disabled="disabled" 
				                                    </c:if>  name='${sortvalue}items' value='' id="other${sortvalue}items" onclick="enabledOtherItems(${tname.inquirySubsurvey.sort})">
	
												</c:if> 
												
												<c:if test="${sOm==1}">

													<input type='checkbox'
													 <c:if test="${vote!='vote' || sbcompose.inquirySurveybasic.censor!='8'}">
				                                    disabled="disabled" 
				                                    </c:if> name='${sortvalue}items' value='' id="other${sortvalue}items"
														onClick='clickCount(this,${tname.inquirySubsurvey.sort},${tname.inquirySubsurvey.maxSelect},${tname.inquirySubsurvey.id})'>

												</c:if> 
												
												<fmt:message key="inquiry.question.otherItem.label" />&nbsp;&nbsp; 
												
												<input type="text" name="${tname.inquirySubsurvey.sort}content"  <c:if test="${vote!='vote' || sbcompose.inquirySurveybasic.censor!='8'}">
			                                      readonly="readonly" </c:if> id='${tname.inquirySubsurvey.sort}items' value="" disabled>
												<input type="hidden" name="${tname.inquirySubsurvey.sort}sort" value="${maxSort + 1}"></li>
										</c:if>
										<c:if test="${tname.inquirySubsurvey.discuss==0}">
											<li><fmt:message key="inquiry.add.review.label" />:</li>
											<li><textarea cols="100" rows="5"
											  <c:if test="${vote!='vote' || sbcompose.inquirySurveybasic.censor!='8'}">
			                                      readonly="readonly"
			                                    </c:if>
												name="${tname.inquirySubsurvey.sort}disscus"
												style="border:1px solid #d8d8d8"></textarea></li>
										</c:if>
									</ul>&nbsp;
								</c:forEach>
								<div class="div-float attsContent" style="display: none"
									id="attsDiv${param.bid}">
								<div class="atts-label"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> ：</div>
								<v3x:attachmentDefine attachments="${attachments}" /> <script
									type="text/javascript">showAttachment('${param.bid}', 0, 'attsDiv${param.bid}');</script>
								</div>
								
								</td>
								<td class="tbCell4">&nbsp;</td>
							</tr>
							<c:if test="${ sbcompose.sender.id == sessionScope['com.seeyon.current_user'].id }">
								<tr>
									<td class="tbCell4" valign="top"> <fmt:message  key="inquiry.check.mind" />: <textarea rows="5" cols="80" class="input-100per" name="checkMind" id="checkMind" disabled>${sbcompose.inquirySurveybasic.checkMind}</textarea></td>
								</tr>
							</c:if>
						</table>
						</td>
					</tr>
				</table>
				</td>
			</tr>

			<tr>
				<td colspan="2" height="24"><br>
				</td>
			</tr>
			<a name="buttom" id="buttom"></a>
		
			
			
		</table>
   <table width="100%">
      <tr>
      <td class="bg-advance-bottom">
      <div align="right" valign="middle">
     <c:if test="${vote=='vote' || sbcompose.inquirySurveybasic.censor=='8'  || sbcompose.inquirySurveybasic.censor=='5'}">
		<c:if test="${vote=='vote' && sbcompose.inquirySurveybasic.censor=='8'}">
			<input type="hidden" value="${param.bid}" name="bid">
			<input type="button" onclick="voteSubmit('${sbcompose.questionsize}')" value="<fmt:message key='common.button.submit.label' bundle='${v3xCommonI18N}'/>" name="B3">&nbsp;&nbsp;&nbsp;
`</c:if> 
<c:if test="${sbcompose.inquirySurveybasic.censor=='8'||sbcompose.inquirySurveybasic.censor=='5'}">
			<input type="button" value="<fmt:message key='inquiry.view.result.label' /> " name="B1"
				onclick="showResult()">&nbsp;&nbsp;&nbsp;
</c:if> 
<c:if test="${vote=='vote'&& sbcompose.inquirySurveybasic.censor=='8'}">
			<input type="reset" value="<fmt:message key='inquiry.button.reset.lable'/> " name="B2">&nbsp;&nbsp;&nbsp;
		</c:if>
		
		</c:if>
		<input type="button" value="<fmt:message key='common.button.close.label' bundle="${v3xCommonI18N}" /> " name="B2" onclick="window.close()">&nbsp;&nbsp;&nbsp;
		</div>
	 </td>
   </tr>
   </table>

</td>
</tr>
</table>
</form>
<iframe name="closeThis" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<script type="text/javascript">
	var forms = document.getElementById("mainForm");
</script>

</body>
</html>
