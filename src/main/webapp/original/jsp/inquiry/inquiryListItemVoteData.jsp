<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file="../apps/doc/pigeonholeHeader.jsp"%>
<%@ include file="header.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<link rel="STYLESHEET" type="text/css"
	href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
	<link rel="stylesheet" type="text/css"
		href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
		<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title> 
	
<script language="javascript">
	window.onload = function() {
		showCondition(
				"${param.condition}",
				"<v3x:out value='${param.textfield}' escapeJavaScript='true' />",
				"<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
	function showListByCheckbox(){
		var checkbox = document.getElementById("isShowNoEmpty");
		var showListForm = document.getElementById("showListForm");
		var url = showListForm.getAttribute("action");
		if(checkbox.checked){
			url = url + "&isShowNoEmpty=1";
		}
		self.location = url;
	}
</script>
<style type="text/css">
	.scrollList{
		height: 340px;
	}
</style>
</head>

<body scroll="no">
	<table height="100%" width="100%" border="0" cellspacing="0"
		cellpadding="0">
		<tr>
			<td colspan="2" valign="top">
				<table height="100%" width="100%" border="0" cellspacing="0"
					cellpadding="0">
					<tr>
						<td height="22" class="webfx-menu-bar-gray" title="${v3x:toHTML(title)}"><fmt:message key="inquiry.current.option" />:${v3x:toHTML(v3x:getLimitLengthString(title,40,'...'))}</td>
						<c:if	test="${contentExt2=='1'}">
							<form  id="showListForm" action="${basicURL}?method=survey_listItemVoteData&itemId=${param.itemId}&cryptonym=${cryptonym}&isShowVoters=${isShowVoters}"></form>
							<td class="webfx-menu-bar-gray" style="width: 135px">
								<label for="isShowNoEmpty" class="hand" <c:if test="${isShowVoters}">onclick="showListByCheckbox()"</c:if> ><input type="checkbox" id="isShowNoEmpty" <c:if test="${isShowNoEmpty =='1'}">checked</c:if>  <c:if test="${!isShowVoters}">disabled</c:if>/><span>${ctp:i18n('inquiry.voteresult.seecontent')}</span></label>
							</td>
						</c:if>
					</tr>
					<tr>
						<td colspan="2">
							<div class="scrollList">
								<form action="" name="mainForm" id="mainForm" method="post">
                                    <fmt:message key="inquiry.question.input.value" var="_inputValue"/>
									<v3x:table data="${memberSet}" var="con" htmlId="aa"
										isChangeTRColor="true" showHeader="true" showPager="true" dragable="false"
										pageSize="20" leastSize="0" subHeight="60">
										<c:if test="${isShowVoters}">
											<v3x:column type="String" label="inquiry.listvote.username" width="20%"
														className="sort cursor-hand"
														alt="${con.userName}"
														onClick="">${con.userName}
											</v3x:column>
											<v3x:column type="String" width="20%" label="inquiry.listvote.deptname"
														alt="${con.deptName}"
														className="sort cursor-hand">${con.deptName}
											</v3x:column>
											<c:if test="${qType!=4&&qType!=5&&contentExt2=='1'}">
												<v3x:column type="String" width="60%" label="${_inputValue}"
															alt="${con.voteContent}"
															className="sort cursor-hand">${con.voteContent}
												</v3x:column>
											</c:if>
										</c:if>
										<c:if test="${!isShowVoters}">
											<v3x:column type="String" width="100%" label="${_inputValue}"
														alt="${con.voteContent}"
														className="sort cursor-hand">${con.voteContent}
											</v3x:column>
										</c:if>
									</v3x:table>
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