<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../apps/doc/pigeonholeHeader.jsp"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<link rel="STYLESHEET" type="text/css"
	href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
	<link rel="stylesheet" type="text/css"
		href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<html style="height: 100%">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title> 
	
<script language="javascript">
	window.onload = function() {
		var val = '${param.textfield}';
		showCondition(
				"${param.condition}",
				"<v3x:out value='${param.textfield}' escapeJavaScript='true' />",
				"<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
	
	function openWindowForHadVote(userId,bId){
		getA8Top().openWindowForHadVoteWin = getA8Top().v3x.openDialog({
	        title:" ",
	        transParams:{'parentWin':window},
	        url: "${basicURL}?method=showInquiryFrame&bid="+bId+"&userId="+userId+"&fromReminded=fromReminded&notShowButton=true",
	        width: 1280,
	        height: 580,
	        isDrag:false
	    });
	}
	
	function reminders(bId){
		var len = document.mainForm.id.length;
		var ids="";
		if(isNaN(len)){
			if(!document.mainForm.id.checked){
				alert("<fmt:message key='inquiry.listvote.remind.selected' />");
				return;
			}else{
				ids += document.mainForm.id.value;
			}
		}else{
			for (i = 0; i <len; i++) {
				if (document.mainForm.id[i].checked == true) {
					ids += document.mainForm.id[i].value+",";
				}
			}
		}
		if(ids==""){
			alert("<fmt:message key='inquiry.listvote.remind.selected' />");
			return;
		}
		var requestCaller = new XMLHttpRequestCaller(this, "inquiryManager", "remindVote", false);
		requestCaller.addParameter(1, "String", bId);
		requestCaller.addParameter(2, "String", ids);
		var reminded = requestCaller.serviceRequest();
		if(reminded == 'true'){
			alert("<fmt:message key='inquiry.listvote.remind.success' />");
		}else{
			alert("<fmt:message key='inquiry.listvote.remind.faild' />");
		}
		
	}
</script>
</head>

<body scroll="no" style="height: 100%">
	<table height="100%" width="100%" border="0" cellspacing="0"
		cellpadding="0">
		<tr>
			<td colspan="2" valign="top">
				<table height="100%" width="100%" border="0" cellspacing="0"
					cellpadding="0">
					<tr>
						<td height="22" class="webfx-menu-bar-gray">
						<c:if test="${flag != 'hadVote' }">
                            <input type="button"  class="button-default-2 margin_5" title="<fmt:message key='inquiry.listvote.remind' />" value="<fmt:message key='inquiry.listvote.remind' />" onclick="reminders('${param.bid}')"></input>
						</c:if></td>
						<c:choose>
							<c:when
								test="${checkerbutton == 'inquiry_checker' || hasCheckAuth==true}">
								<td class="webfx-menu-bar-gray">
							</c:when>
							<c:otherwise>
								<td class="webfx-menu-bar">
							</c:otherwise>
						</c:choose>
						<form
							action="${basicURL}?method=survey_listVoteData&bid=${param.bid}&flag=${flag}"
							name="searchForm" id="searchForm" method="get"
							onsubmit="return false" style="margin: 0px">
							<input type="hidden" value="<c:out value='${param.method}' />"
								name="method"> <input type="hidden" value="${flag}"
								name="flag"> <input type="hidden" value="${param.bid}"
									name="bid">
										<div class="div-float-right">
											<div class="div-float">
												<select id="condition" name="condition"
													onChange="showNextCondition(this)" class="condition">
													<option value="">
														<fmt:message key="common.option.selectCondition.text"
															bundle="${v3xCommonI18N}" />
													</option>
													<option value="sender"><fmt:message key="inquiry.listvote.username" /></option>
													<option value="deptName"><fmt:message key="inquiry.listvote.deptname" /></option>
													<c:if test="${flag == 'allVote'}">
                                                        <option value="hadVote"><fmt:message key="inquiry.listvote.whethervoting" /></option>
                                                    </c:if>
                                                    <c:if test="${flag != 'noVote'}">
                                                        <option value="createDate"><fmt:message key="inquiry.listvote.votetime" /></option>
                                                    </c:if>
												</select>
											</div>
											<div id="senderDiv" class="div-float hidden">
												<input type="text" id="textfield" name="textfield"
													onkeydown="javascript:searchWithKey()">
											</div>
											<div id="deptNameDiv" class="div-float hidden">
												<input type="text" name="textfield" class="textfield"
													onkeydown="javascript:searchWithKey()">
											</div>
                                            <c:if test="${flag == 'allVote'}">
    											<div id="hadVoteDiv" class="div-float hidden">
    												<select name="textfield"
    													    class="condition">
    													<option value="true"><fmt:message key="inquiry.listvote.yes" /></option>
    													<option value="false"><fmt:message key="inquiry.listvote.no" /></option>
    												</select>
    											</div>
                                            </c:if>
                                            <c:if test="${flag != 'noVote'}">
    											<div id="createDateDiv" class="div-float hidden">
    												<input type="text" id="startdate" name="textfield"
    													class="input-date"
    													onclick="whenstart('${pageContext.request.contextPath}',this,640,265);"
    													readonly onkeydown="javascript:searchWithKey()"> -
    													<input type="text" id="enddate" name="textfield1"
    													class="input-date"
    													onclick="whenstart('${pageContext.request.contextPath}',this,640,265);"
    													readonly onkeydown="javascript:searchWithKey()">
    											</div>
                                            </c:if>
											<div onclick="doSearch()"
												class="div-float condition-search-button button-font-color"></div>
										</div>
						</form>
						</td>
					</tr>
					<tr>
						<td colspan="2">

							<div class="scrollList">
								<form action="" name="mainForm" id="mainForm" method="post">
									<c:choose>
										<c:when test="${flag == 'hadVote'}">
											<v3x:table data="${memberSet}" var="con" htmlId="aa"
												isChangeTRColor="true" showHeader="true" showPager="true"
												pageSize="20" leastSize="0" subHeight="60">
												<v3x:column type="String" label="inquiry.listvote.username" width="30%"
													className="sort cursor-hand" symbol="..." maxLength="26"
													alt="${con.v3xOrgMember.name}"
													value="${con.v3xOrgMember.name}" onClick="">
												</v3x:column>
												<v3x:column type="String" width="20%" label="inquiry.listvote.deptname"
													symbol="..." maxLength="12" value="${con.deptStr}" alt=""
													className="sort cursor-hand">
												</v3x:column>
												
												<c:if test="${semiAnonymous !='true'}">
													<v3x:column type="Date" width="33%" label="inquiry.listvote.votetime"
														className="sort cursor-hand"
														align="left">
														<fmt:formatDate value="${con.voteDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
													</v3x:column>
													<v3x:column type="String" width="20%" label="inquiry.listvote.question"
														className="sort cursor-hand" alt="" symbol="..."
														maxLength="16" >
													<c:if test="${con.hadVoted=='true'}">
														<a onclick="javascript:openWindowForHadVote('${con.v3xOrgMember.id}','${param.bid }');">
															<img width="16" height="16" align="middle" class="toolbar-button-icon" style="background-position: -32px -96px;" src="/seeyon/common/images/space.gif" border="0">
														</a>
													</c:if>												
													</v3x:column>
												</c:if>
												<c:if test="${semiAnonymous =='true'}">
													<v3x:column type="Date" width="53%" label="inquiry.listvote.votetime"
														className="sort cursor-hand"
														align="left">
														<fmt:formatDate value="${con.voteDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
													</v3x:column>
												</c:if>
											</v3x:table>
										</c:when>
										<c:when test="${flag == 'noVote'}">
											<v3x:table data="${memberSet}" var="con" htmlId="aa"
												isChangeTRColor="true" showHeader="true" showPager="true"
												pageSize="20" leastSize="0" subHeight="60">
												<v3x:column width="5%" align="center"
													label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
													<input type='checkbox' name='id' ${con.hadVoted?'disabled':''}  value="${con.v3xOrgMember.id}" attFlag="" />
												</v3x:column>
												<v3x:column type="String" label="inquiry.listvote.username" width="30%"
													className="sort cursor-hand" symbol="..." maxLength="26"
													alt="${con.v3xOrgMember.name}"
													value="${con.v3xOrgMember.name}" onClick="">
												</v3x:column>
												<v3x:column type="String" width="67%" label="inquiry.listvote.deptname"
													symbol="..." maxLength="12" value="${con.deptStr}" alt=""
													className="sort cursor-hand">
												</v3x:column>
											</v3x:table>
										</c:when>
										<c:otherwise>
											<v3x:table data="${memberSet}" var="con" htmlId="aa"
												isChangeTRColor="true" showHeader="true" showPager="true"
												pageSize="20" leastSize="0" subHeight="60">
												<v3x:column width="5%" align="center"
													label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
													<input type='checkbox' name='id' ${con.hadVoted?'disabled':''} value="${con.v3xOrgMember.id}" attFlag="" />
												</v3x:column>
												<c:set var="onclick" value="inquiryDetail('')" />
												<v3x:column type="String" label="inquiry.listvote.username" width="23%"
													className="sort cursor-hand" symbol="..." maxLength="26"
													alt="${con.v3xOrgMember.name}" onClick=""
													value="${con.v3xOrgMember.name}">
												</v3x:column>
												<v3x:column type="String" width="20%" label="inquiry.listvote.deptname"
													symbol="..." maxLength="12" value="${con.deptStr}" alt=""
													className="sort cursor-hand">
												</v3x:column>
												<v3x:column type="String" width="15%" label="inquiry.listvote.whethervoting"
													className="sort cursor-hand"
													align="left">
													<c:choose>
												   		<c:when test="${con.hadVoted=='true'}">
												   			<fmt:message key="inquiry.listvote.yes"/>
												   		</c:when>
												   		<c:otherwise>
												   			<fmt:message key="inquiry.listvote.no"/>
												   		</c:otherwise>
												   	</c:choose>
												</v3x:column>
												
												<c:if test="${semiAnonymous !='true'}">
													<v3x:column type="String" width="30%" label="inquiry.listvote.votetime"
														className="sort cursor-hand"
														align="left">
														<fmt:formatDate value="${con.voteDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
													</v3x:column>
													<v3x:column type="String" width="10%" label="inquiry.listvote.question"
														className="sort cursor-hand" alt="" symbol="..."
														maxLength="16" >
													<c:if test="${con.hadVoted=='true'}">
														<a onclick="javascript:openWindowForHadVote('${con.v3xOrgMember.id}','${param.bid }');">
															<img width="16" height="16" align="middle" class="toolbar-button-icon" style="background-position: -32px -96px;" src="/seeyon/common/images/space.gif" border="0">
														</a>
													</c:if>
													</v3x:column>
												</c:if>
												<c:if test="${semiAnonymous =='true'}">
													<v3x:column type="String" width="40%" label="inquiry.listvote.votetime"
														className="sort cursor-hand"
														align="left">
														<fmt:formatDate value="${con.voteDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
													</v3x:column>
												</c:if>
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
	<iframe src="javascript:void(0)" name="grantIframe" frameborder="0"
		height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
	</iframe>
</body>
		</html>