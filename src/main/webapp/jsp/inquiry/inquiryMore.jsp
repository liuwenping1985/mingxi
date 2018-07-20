<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>	
<title>Insert title here</title>
<script language="javascript">
<!--
	if('${param.spaceType}'=='4'){
	  var theHtml=toHtml("${v3x:toHTML(typeName)}",'<fmt:message key="inquiry.new.inquiry.label"/>');
	  showCtpLocation("",{html:theHtml});
	}
	
    var firstName = "${firstName}";
    var secondName = "${secondName}";
    if (firstName != '' && secondName != ''){
         var theHtml=toHtml("${v3x:toHTML(firstName)}",'${v3x:toHTML(secondName)}');
         showCtpLocation("",{html:theHtml}); 
    }

	function inquiryDetail(id){
		 var acturl = "${basicURL}?method=showInquiryFrame&spaceId=${param.spaceId}&bid=" + id + "&surveytypeid=${typeId}&group=${param.group}";
		 openWin(acturl) ;
	}
	function inquiryModule(typeId){
	 document.location.href = "${basicURL}?method=more_recent_or_check&typeId=" + typeId;
	}
	function inquiryCheck(id){
		 document.location.href = "${basicURL}?method=survey_check&bid="+id+"group=${group}&spaceId=${param.spaceId}";
	}
	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
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

</head>
<body scroll="no" class="with-header page_color">
	<div class="main_div_row2">
	  <div class="right_div_row2">
	    <div class="top_div_row2" style="height:55px;">
			<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" style='background:#eee;'>
				<tr class="page2-header-line">
					<td width="100%" height="25" valign="top" class="page-list-border-LRD">
						 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
					     	<tr class="page2-header-line">
					        <td width="45" class="page2-header-img"><div class="inquiryIndex"></div></td>
							<td class="page2-header-bg" width="500" style="padding: 3px 10px 3px 10px;"><fmt:message key='inquiry.new.inquiry.label' /></td>
							<td class="page2-header-line padding-right" align="right"></td>
							</tr>	
						</table>
					</td>
				</tr>
				 <tr>
                 <td colspan="2">
                 <div class="hr_heng"></div>
                 </td>
                 </tr>
				<tr>
					 <td valign="top">
						<table width="100%" height="100%"  cellpadding="0" cellspacing="0" border="0" class="page2-list-border">
							<tr>
								<td height="22" class="webfx-menu-bar page2-list-header ${(custom) ? 'padding5' : ''}">
									 <c:choose>
									 	<c:when test="${custom =='custom'}">
									 		<c:if test="${spaceManagerFlag}">
									  			<script type="text/javascript">
													var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
													if(v3x.getBrowserFlag("hideMenu") == true){
														myBar.add(new WebFXMenuButton("create", "<fmt:message key='inquiry.publish.button' />", "javascript:inquiryPublish('${typeId}')", [5,7], "", null));
													}    	
													myBar.add(new WebFXMenuButton("manage", "<fmt:message key='inquiry.manage' />", "javascript:inquiryManage('${typeId}')", [12,9], "", null));
													document.write(myBar);
													document.close();
												</script>
									  		</c:if>
									 	</c:when>
								    	<c:when test="${moreList}">
								    		<b>${v3x:toHTML(typeName)}</b>
								    	</c:when>
								    	<c:otherwise>
								    		<b>
									    		<c:choose>
									    			<c:when test="${publicCustom}">
	                                            		${v3x:toHTML(spaceName)}
	                                        		</c:when>
									    			<c:when test="${group=='group' }">
									    				<c:set value="${v3x:getSysFlagByName('sys_isGovVer') ? '.rep' : ''}" var="govLabel" />
									    				<fmt:message key='inquiry.zuixin.label1${govLabel}' />
									    			</c:when>
										    		<c:otherwise>
										    			<fmt:message key='inquiry.zuixin.label' />
										    		</c:otherwise>
									    		</c:choose>
								    		</b>
								    	</c:otherwise>
						  		  </c:choose>
				                 
								</td>
								<td class="webfx-menu-bar">
									<form action="${basicURL}" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
                                      <c:choose>  
                                        <c:when test="${custom =='custom' and spaceManagerFlag}">
                                            <input type="hidden" value="more_recent_or_check" name="method">
                                        </c:when>
                                        <c:otherwise> 
                                          <input type="hidden" value="oneTypeInquirySearch" name="method">
                                        </c:otherwise> 
                                      </c:choose>  
										<input type="hidden" value="${group}" name="group">
										<input type="hidden" value="${param.homeFlag}" name="homeFlag">
										<input type="hidden" value="${inqueryId}" name="inqueryId">
										<input type="hidden" value="${inqueryId}" name="typeId">
										<input type="hidden" value="${custom}" name="custom">
										<input type="hidden" value="${param.spaceType}" name="spaceType">
										<input type="hidden" value="${param.spaceId}" name="spaceId">
										<div class="div-float-right">
											<div class="div-float">
											<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
												<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
												<option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
												<option value="creater"><fmt:message key="inquiry.creater.label"/></option>
												<option value="createDate"><fmt:message key="inquiry.date.create"/></option>
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
								</td>
							</tr>	
						</table>
					</td>
				</tr>
			</table>			
				
	    </div>
	    <div class="center_div_row2" id="scrollListDiv" style="top:60px">
			<form action="" name="mainForm" id="mainForm" method="get">
				<v3x:table data="${alist}" var="con" htmlId="sdsd" >
					<c:choose>
						<c:when test="${checkerbutton=='inquiry_checker'}">
							<c:set var="onclick"
								value="inquiryCheck('${con.inquirySurveybasic.id}')" />
						</c:when>
						<c:otherwise>
							<c:set var="onclick"
								value="inquiryDetail('${con.inquirySurveybasic.id}','${con.inquirySurveybasic.inquirySurveytype.id}')" />
						</c:otherwise>
					</c:choose>
					
					<c:set var="titleMaxLength" value="64" />
					<c:if test="${empty param.typeId }">
						<c:set var="titleMaxLength" value="54" />
					</c:if>
					
					<v3x:column width="45%" type="String" label="common.subject.label"
						className="sort" symbol="..."
						maxLength="40" alt="${con.inquirySurveybasic.surveyName}">
						<a href="javascript:${onclick}" class="title-more-visited" title="${v3x:toHTML(con.inquirySurveybasic.surveyName)}">
							${v3x:toHTML(con.inquirySurveybasic.surveyName)}
						</a>
					</v3x:column>
					
				<c:if test="${empty param.typeId }">
					<c:set value="${basicURL}?method=more_recent_or_check&typeId=${con.inquirySurveybasic.inquirySurveytype.id}&from=${param.from}&group=${group}" var="linkColumn"></c:set>
					<v3x:column width="10%" type="String" label="inquiry.category.label" value="${con.inquirySurveybasic.inquirySurveytype.typeName}"
						  className="sort"  maxLength="20" href="${linkColumn}"
						alt="${con.inquirySurveybasic.inquirySurveytype.typeName}"
						symbol="...">
					</v3x:column>
				</c:if>
				
					<v3x:column width="10%" type="String" label="inquiry.creater.label" value="${v3x:showOrgEntitiesOfIds(con.inquirySurveybasic.createrId, 'Member', pageContext)}"  className="sort" maxLength="16" symbol="..."></v3x:column>
					
					<v3x:column width="15%"  type="String" label="inquiry.scope.label"  className="sort" 
						alt="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}" symbol="..."
						maxLength="22" value="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}">
					</v3x:column>
					
					<v3x:column  width="15%" type="Date"  label="inquiry.date.create" className="sort"  align="left">
						<fmt:formatDate value="${con.inquirySurveybasic.sendDate}"
							pattern="${ datetimePattern }" />
					</v3x:column>
					
					 <c:choose>
				           <c:when test="${con.inquirySurveybasic.closeDate eq null}">
				            <v3x:column width="15%"  type="String"  label="inquiry.close.time.label"  className="sort"  align="left"><fmt:message key="inquiry.no.limit" /></v3x:column>		      
				           </c:when>
						   <c:otherwise>
						    <v3x:column width="15%" type="Date" label="inquiry.close.time.label"  className="sort" align="left"><fmt:formatDate value="${con.inquirySurveybasic.closeDate}" pattern="${ datetimePattern }"/></v3x:column>		      
						   </c:otherwise>
					 </c:choose>
				</v3x:table>
			</form>
	      
	    </div>
	  </div>
	</div>
<script language="javascript">
	if('${param.openFrom}'=='index'){
		resetCtpLocation();
	}
</script>	
</body>
</html>