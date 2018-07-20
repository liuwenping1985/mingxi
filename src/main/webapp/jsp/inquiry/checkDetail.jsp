<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="inquiry.auditor.manage.label"></fmt:message></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/skin/default/skin.css${v3x:resSuffix()}" />">
<script type="text/javascript">
//进入时默认选择审核状态
window.onload = function(){
	var checkRadioArr = document.all.checkMindRadio;
	
	if( "${sbcompose.inquirySurveybasic.censor}" == "1" ){
		checkRadioArr[2].checked = true;
	}else if("${sbcompose.inquirySurveybasic.censor}" == "2"){
		checkRadioArr[1].checked = true;
	}else{
		checkRadioArr[0].checked = true;
	}
}

function submitCheck(){
	var checkRadioArr = document.all.checkMindRadio;
	var flag = "";
	for( var i = 0 ; i < checkRadioArr.length ; i++ ){
		if(checkRadioArr[i].checked){
			flag = checkRadioArr[i].value;
			break;
		}
	}
	if(document.all.checkMind.value.length>150){
  		alert(v3x.getMessage("InquiryLang.inquiry_checkmind_too_long"));
  		document.all.checkMind.focus();
  		return false;
    }
    
	var dialogArguments = top.window.dialogArguments;
	if(dialogArguments){
		mainForm.action="${basicURL}?method=checker_handle&typeid=${param.tid}&handle=" + flag + "&bid=${param.bid}&group=${group}&close=close";
		document.mainForm.target="checkDetailHidden";
		mainForm.submit();
	}else{
		mainForm.action="${basicURL}?method=checker_handle&typeid=${param.tid}&handle=" + flag + "&bid=${param.bid}&group=${group}";
		mainForm.submit();
	}
}

function passOrNo(flag){
	var dialogArguments = top.window.dialogArguments;
	
	if(document.all.checkMind.value.length>150){
  		alert(v3x.getMessage("InquiryLang.inquiry_checkmind_too_long"));
  		document.all.checkMind.focus();
  		return false;
    }
	if(dialogArguments){
		mainForm.action="${basicURL}?method=checker_handle&typeid=${param.tid}&handle=" + flag + "&bid=${param.bid}&group=${group}&close=close";
		document.mainForm.target="checkDetailHidden";
		mainForm.submit();
	}else{
		mainForm.action="${basicURL}?method=checker_handle&typeid=${param.tid}&handle=" + flag + "&bid=${param.bid}&group=${group}";
		mainForm.submit();
	}
}

function cancelAudit(){
			var parentObj = top.window.dialogArguments;
			if (parentObj){
				window.close();
			}else{
				window.location.href = "<c:url value='/common/detail.jsp'/>";
			}
}
	function lock(id)
	{
		var action="inquiry.lockaction.audit";
		//进行加锁
		try {
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "lock", false);
			requestCaller.addParameter(1, "Long", id);
			requestCaller.addParameter(2, "String",action);
			var ds= requestCaller.serviceRequest();
		}
		catch (ex1) {
			alert("Exception : " + ex1);
		}
	}
	
	function unlock(id)
	{
		//进行解锁
		var depObj = document.getElementById("department");
		try {
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "unlock", false);
			requestCaller.addParameter(1, "Long", id);
			<%-- 如果用户直接点击退出或关闭IE，此时解锁无法进行，可能形成死锁 --%>
			requestCaller.needCheckLogin = false;
			var ds = requestCaller.serviceRequest();
		}
		catch (ex1) {
			alert("Exception : " + ex1);
		}
	}

</script>
<script>showAttachment('<c:out value="${param.bid}" />', 0, '', '');</script>
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
</head>
<body scroll='no' onunload="unlock('${sbcompose.inquirySurveybasic.id}');" onload="lock('${sbcompose.inquirySurveybasic.id}');">
<form name="mainForm" action="${basicURL}?method=user_vote&tid=${tid}" method="post" class="${param.from=='list'?'':'popupTitleRight'}">
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	<c:if test="${param.from!='list'}">
	<tr>
		<td class="PopupTitle">
			<fmt:message key="inquiry.auditor.manage.label"/>
		</td>
	</tr>
	</c:if>
	<tr>
		<td valign="top">
			<div class="scrollList" id="scrollList">
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td colspan="3"  valign="top"><a name="top" id="top"></a>
							<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" >
								<tr>
									<td width="25%" class="tbCell6 , bbs-bg" valign="top">
										<table width="100%" border="0"  align="left" valign="top">
											<tr>
												<td width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td><td> <fmt:message key="inquiry.subject.label" />: </td>
											</tr>
											<tr>
											   <td  width="2%">&nbsp;</td>
											   <td  width="98%">${v3x:toHTML(sbcompose.inquirySurveybasic.surveyName)}</td>
											</tr>
											<tr>
												<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.creater.label" />:</td>
										    </tr>
											<tr>
											   <td  width="2%">&nbsp;</td>
											   <td  width="98%"><c:out value="${v3x:showOrgEntitiesOfIds(sbcompose.sender.id, 'Member', pageContext)}" /> </td>
											</tr>
											   <tr height="2px">
											   <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
											  </tr>							
											<tr>
												<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.send.department.label" />:</td>
										    </tr>
											<tr>
											   <td  width="2%">&nbsp;</td>
											   <td  width="98%"><c:out value="${sbcompose.deparmentName.name}" /> </td>
											</tr>
											<tr height="2px">
											   <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
											</tr>
											<tr>
												<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.category.label" />:</td>
										    </tr>
										    <tr>
											   <td  width="2%">&nbsp;</td>
											   <td  width="98%"><c:out value="${sbcompose.inquirySurveybasic.inquirySurveytype.typeName}" /></td>
											</tr>
											<tr height="2px">
											   <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
											</tr>
											<tr>
												<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.date.rane.label" />:</td>
										    </tr>
											<tr>
											  <td  width="2%">&nbsp;</td>
											   <td  colspan="2"><fmt:formatDate value="${sbcompose.inquirySurveybasic.sendDate}"  pattern="${datetimePattern}" /> &nbsp;&nbsp;<fmt:message key="inquiry.to.label" /> </td>   
											</tr>
											<tr>
											   <td  width="2%">&nbsp;</td>
											   <td  colspan="2">
				                                  <c:choose>
												       <c:when test="${ sbcompose.inquirySurveybasic.closeDate eq null }">
												                 <fmt:message key="inquiry.no.limit" />
												       </c:when>
													  <c:otherwise>
														     <fmt:formatDate value="${sbcompose.inquirySurveybasic.closeDate}" 	pattern="${datetimePattern}" />
													 </c:otherwise>	
											       </c:choose>
				                                </td>   
											</tr>
											<tr height="2px">
											   <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
											</tr>
											<c:if test="${sbcompose.inquirySurveybasic.censorId != null}">
											   <tr>
												   <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.auditor.label" />:</td>
										       </tr>
											   <tr>
													<td  width="2%">&nbsp;</td>
													<td colspan="2">${v3x:showOrgEntitiesOfIds(sbcompose.inquirySurveybasic.censorId, 'Member', pageContext)}</td>
											   </tr>
											   <tr height="2px">
											   <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
											  </tr>
											</c:if>
											 <tr>
												 <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="common.issueScope.label" bundle="${v3xCommonI18N}" />:</td>
										     </tr>
											<tr>
												<td  width="2%">&nbsp;</td>
												<td colspan="2"><div  style=" width:180px;overflow:hidden; text-overflow:ellipsis;" title="${v3x:showOrgEntities(sbcompose.entity, "id", "entityType", pageContext)}" ><nobr>${v3x:showOrgEntities(sbcompose.entity, "id", "entityType", pageContext)}</nobr></div></td>
											</tr>
                                             <tr height="2px">
                                               <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
                                              </tr>
                                             <tr>
                                                 <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2">投票方式:</td>
                                            </tr>
                                            <tr>
                                                <td  width="2%">&nbsp;</td>
                                                <td colspan="2">
                                                    <div style="width:280px;">
                                                            <c:choose>
                                                                  <c:when test="${sbcompose.inquirySurveybasic.cryptonym == 0}">
                                                                        <input disabled="disabled" id="cryptonym1" type="radio" name="cryptonym" value="0" checked="checked" />
                                                                        <fmt:message key="inquiry.real.name.label" />
                                                                        <br/>
                                                                        <input id="allowAdminViewResult" name="allowAdminViewResult" disabled="disabled"  type="checkbox" checked="checked"/>
                                                                        <fmt:message key="inquiry.allowviewresult.foradmin.2" />
                                                                    </c:when>
                                                                    <c:when test="${sbcompose.inquirySurveybasic.cryptonym == 1}">
                                                                        <input id="cryptonym2" type="radio" name="cryptonym" disabled="disabled" checked="checked"/>
                                                                        <fmt:message key="inquiry.anonymity.label" />
                                                                        <br/>
                                                                        <input id="allowAdminViewResult" name="allowAdminViewResult" disabled="disabled"  type="checkbox" checked="checked"/>
                                                                        <c:if test="${sbcompose.inquirySurveybasic.showVoters == true}">
                                                                            <fmt:message key="inquiry.allowviewresult.foradmin" />
                                                                        </c:if>
                                                                        <c:if test="${sbcompose.inquirySurveybasic.showVoters == false}">
                                                                            <fmt:message key="inquiry.allowviewresult.foradmin.1" />
                                                                        </c:if>
                                                                    </c:when>
                                                             </c:choose>
                                                    </div>
                                                </td>
                                            </tr>
										</table>
									</td>
									<td width="78%" valign='top' class=" top-padding">
										<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="word-break:break-all;word-wrap:break-word">
											<tr>
												&nbsp;
												<font style="font-size: 16px;">
													${v3x:toHTML(sbcompose.inquirySurveybasic.surveydesc)}
												</font>
												
												<td class="tbCell4 , bbs-tb-padding2" valign="top" style="word-break:break-all;word-wrap:break-word;border: 0px;">
												<c:set var="itemCount" value="0" />
												<c:forEach items="${sbcompose.subsurveyAndICompose}" var="tname">
													<ul id="discussul">
														<c:out value="${tname.inquirySubsurvey.sort+1}" />
														.
														<c:out value="${tname.inquirySubsurvey.title}" /> 
														<input type="hidden" value="${tname.inquirySubsurvey.id}" name="subid">
														<c:if test="${tname.inquirySubsurvey.maxSelect>'0'}">
														   &nbsp;&nbsp;(<fmt:message key="inquiry.select.max.label" />:${tname.inquirySubsurvey.maxSelect})
														</c:if>
						                               <br><c:if test="${v3x:isNotBlank(tname.inquirySubsurvey.subsurveyDesc)}"><li>${v3x:toHTML(tname.inquirySubsurvey.subsurveyDesc)}</li></c:if> 
														<c:set var="maxSort" value="0" />
														<c:set var="sOm" value="0" />
														<c:set var="sortvalue" value="0" />
														<c:forEach items="${tname.items}" var="sub" varStatus="stat">
															<c:if test="${tname.inquirySubsurvey.singleMany==0}">
																<li><label for='${stat.index}id'>	
																<input type='radio' <c:if test="${vote!='vote' || sbcompose.inquirySurveybasic.censor!='8'}"> disabled="disabled"   </c:if>
																	id='${stat.index}id' name='${tname.inquirySubsurvey.sort}items'
																	value='${sub.id}' <c:if test="${tname.inquirySubsurvey.otheritem==0}"> onclick="clearOtherItems(${tname.inquirySubsurvey.sort})" </c:if> ><c:out value="${sub.content}" /></label></li>
															</c:if>
															<c:if test="${tname.inquirySubsurvey.singleMany==1}">
																<li>
																<input type='checkbox'  <c:if test="${vote!='vote' || sbcompose.inquirySurveybasic.censor!='8'}"> disabled="disabled"  </c:if>
																	name='${tname.inquirySubsurvey.sort}items'
																	value='${sub.id}'
																	onClick='clickCount(this,${tname.inquirySubsurvey.sort},${tname.inquirySubsurvey.maxSelect})'><c:out value="${sub.content}" />
																</li>
															</c:if>
															<c:set var="maxSort" value="${sub.sort}" />
															<c:set var="sOm" value="${tname.inquirySubsurvey.singleMany}" />
															<c:set var="sortvalue" value="${tname.inquirySubsurvey.sort}" />
															<c:set var="itemCount" value="${itemCount+1}" />
														</c:forEach>
														
														<c:if test="${tname.inquirySubsurvey.otheritem==0}">
															<li>
																<label for="other${sortvalue}items"><c:if test="${sOm==0}">
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
																		onClick='otherClickCount(this,${tname.inquirySubsurvey.sort},${tname.inquirySubsurvey.maxSelect},${tname.inquirySubsurvey.id})'>
					
																</c:if> 
																	<fmt:message key="inquiry.question.otherItem.label" />&nbsp;&nbsp; 
																</label>
																	<input type="text"
																		name="${tname.inquirySubsurvey.sort}content"  <c:if test="${vote!='vote' || sbcompose.inquirySurveybasic.censor!='8'}">
									                                      readonly="readonly" </c:if> id='${tname.inquirySubsurvey.sort}items' value="" disabled>
									                                      
																	<input type="hidden" name="${tname.inquirySubsurvey.sort}sort" value="${maxSort + 1}"></li>
															</c:if>
														<c:if test="${tname.inquirySubsurvey.discuss==0}">
															<c:set value="${tname.inquirySubsurvey.singleMany!=2 ? 'inquiry.add.review.label' : 'inquiry.pls.anwer'}" var="key" />
													    	<li><fmt:message key="${key}" />:</li>
															<li>
																<textarea cols="100" rows="5"  
																	<c:if test="${vote!='vote' || sbcompose.inquirySurveybasic.censor!='8'}">
							                                      		readonly="readonly"
							                                    	</c:if>
																name="${tname.inquirySubsurvey.sort}disscus"
																style="border:1px solid #d8d8d8" inputName="<fmt:message key='inquiry.add.review.label' />" validate="maxLength" maxSize="150">
																</textarea>
															</li>
														</c:if>
													</ul>&nbsp;
												</c:forEach>
												<div class="div-float attsContent" style="display: none"
                                                        id="attsDiv2${param.bid}">
                                                    <div class="atts-label"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" /> ：</div>
                                                    <v3x:attachmentDefine attachments="${attachments}" /> <script
                                                        type="text/javascript">showAttachment('${param.bid}',2, 'attsDiv2${param.bid}');</script>
                                                    </div>
												<div class="div-float attsContent" style="display: none"
													id="attsDiv${param.bid}">
												<div class="atts-label"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> ：</div>
												<v3x:attachmentDefine attachments="${attachments}" /> <script
													type="text/javascript">showAttachment('${param.bid}', 0, 'attsDiv${param.bid}');</script>
												</div>
												
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>
</form>
<iframe name="checkDetailHidden" width="0" height="0" frameborder="0"></iframe>
<script type="text/javascript">
<c:if test="${param.from != 'list'}">
	bindOnresize('scrollList', 0, 45);
</c:if>
<c:if test="${param.from == 'list'}">
	bindOnresize('scrollList', 0, 0);
</c:if>
</script>
</body>
</html>
