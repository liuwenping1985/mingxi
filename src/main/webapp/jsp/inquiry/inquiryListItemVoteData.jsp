<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file="../apps/doc/pigeonholeHeader.jsp"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
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
</script>
</head>

<body scroll="no">
	<table height="100%" width="100%" border="0" cellspacing="0"
		cellpadding="0">
		<tr>
			<td colspan="2" valign="top">
				<table height="100%" width="100%" border="0" cellspacing="0"
					cellpadding="0">
					<tr>
						<td height="22" class="webfx-menu-bar-gray"><fmt:message key="inquiry.current.option" />：${title}</td>
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
							action="${basicURL}?method=survey_listItemVoteData&itemId=${param.itemId}"
							name="searchForm" id="searchForm" method="get"
							onsubmit="return false" style="margin: 0px">
							<input type="hidden" value="<c:out value='${param.method}' />"
								name="method"> <input type="hidden" value="${param.itemId}"
									name="itemId">
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
									<v3x:table data="${memberSet}" var="con" htmlId="aa"
										isChangeTRColor="true" showHeader="true" showPager="true"
										pageSize="20" leastSize="0" subHeight="60">
										<v3x:column type="String" label="inquiry.listvote.username" width="30%"
											className="sort cursor-hand" symbol="..." maxLength="26"
											alt="${con.userName}"
											value="${con.userName}" onClick="">
										</v3x:column>
										<v3x:column type="String" width="68%" label="inquiry.listvote.deptname"
											symbol="..." maxLength="12" value="${con.deptName}" alt="${con.deptName}"
											className="sort cursor-hand">
										</v3x:column>
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