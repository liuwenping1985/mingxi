<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />" />
<script type="text/javascript">
	resetCtpLocation();
	
	function openCollaboration(url) {
		openCtpWindow({'url':url});
	}
</script>
</head>
<body scroll="no" class="with-header">
	<c:set var="hasNewColl" value="${v3x:hasNewCollaboration()}" />
	<div class="main_div_row2">
		<div class="right_div_row2 border_all">
			<div class="top_div_row2">
				<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="main-bg">
					<tr>
						<td height="77" colspan="10" valign="top">
							<table width="100%" height="60" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td width="45" class="page2-header-img"><div class="identificationConfig"></div></td>
									<td>
										<div>
											<span class="relatepepleTitleCss">${member.name}</span>
											<c:choose>
												<c:when test="${(!empty OnlineUser) && OnlineUser.state == 'online'}">
													(<fmt:message key="relate.online.${OnlineUser.onlineSubState}" />)
												</c:when>
												<c:otherwise>
													(<fmt:message key="relate.offline" />)
												</c:otherwise>
											</c:choose>
										</div><br />
										<div>
											<c:if test="${not empty param.from}">
												<b>&nbsp;<fmt:message key="relate.yousend.label"><fmt:param value="${member.name}" /></fmt:message></b>
											</c:if>
											<c:if test="${empty param.from}">
												<b>&nbsp;<fmt:message key="relate.youreceive.label"><fmt:param value="${member.name}" /></fmt:message></b>
											</c:if>
										</div>
									</td>
									<td align="right" valign="bottom">
										<table width="500" height="52" border="0" cellpadding="0" cellspacing="0">
											<tr>
												<td width="31%" align="right">
													&nbsp;<fmt:message key="relate.memberinfo.partment" />
												</td>
                                                <c:set value="${v3x:showDepartmentFullPath(member.orgDepartmentId)}" var="deptName" />
												<td width="28%" align="left" title="${deptName}">
													&nbsp;${v3x:toHTML(deptName)}
												</td>
												<td width="15%" align="right">
													&nbsp;<fmt:message key="relate.memberinfo.handphone1" />
												</td>
												<td width="28%" align="left" title="${member.telNumber}">
													&nbsp;${v3x:getLimitLengthString(member.telNumber,15,"...")}
												</td>
											</tr>
											<tr>
												<td align="right">
													&nbsp;<fmt:message key="relate.memberinfo.post1" />
												</td>
												<td title="${post}" align="left">
													&nbsp;${v3x:getLimitLengthString(post,15,"...")}
												</td>
												<td align="right">
													&nbsp;<fmt:message key="relate.memberinfo.tel" />
												</td>
												<td align="left" title="${member.officeNum}">
													&nbsp;${v3x:getLimitLengthString(member.officeNum,15,"...")}
												</td>
											</tr>
											<tr>
												<td align="right">
													&nbsp;<fmt:message key="relate.memberinfo.level" />
												</td>
												<td title="${level}" align="left">
													&nbsp;${v3x:getLimitLengthString(level,15,"...")}
												</td>
												<td align="right">
													&nbsp;<fmt:message key="relate.memberinfo.email" />
												</td>
												<td align="left" title="${member.emailAddress}">
													&nbsp;${v3x:getLimitLengthString(member.emailAddress,15,"...")}
												</td>
											</tr>
										</table>
									</td>
									<td width="70" align="center">
										<a href="${pageContext.request.contextPath }/relateMember.do?method=relateMemberInfo&memberId=${memberId}&relatedId=${relatedId}&departmentId=${param.departmentId}">
											<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />
										</a>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<div class="center_div_row2" id="scrollListDiv">
				<form action="">
					<v3x:table htmlId="pending" data="senderList" var="col" className="sort ellipsis">
						<v3x:column width="60%" type="String" className="cursor-hand1 sort" label="common.subject.label" hasAttachments="${col.hasAttsFlag}" importantLevel="${col.importantLevel}" bodyType="${col.bodyType}" flowState="${col.finish ? 3 : 0}">
							<a class="title-more" href="javascript:openCollaboration('${col.subjectUrl}')" title="${v3x:toHTML(col.subject)}">${v3x:toHTML(v3x:getLimitLengthString(col.subject, 800, '...'))}</a>
							<c:if test="${col.bodyType=='41'}">
								<span class="ico16 doc_16"></span>
							</c:if>
							<c:if test="${col.bodyType=='42'}">
								<span class="ico16 xls_16"></span>
							</c:if>
							<c:if test="${col.bodyType=='43'}">
								<span class="ico16 wps_16"></span>
							</c:if>
							<c:if test="${col.bodyType=='44'}">
								<span class="ico16 xls2_16"></span>
							</c:if>
							<c:if test="${col.bodyType=='20'}">
								<span class="ico16 form_text_16"></span>
							</c:if>
							<c:if test="${col.meetingVideoConf}">
								<span class="ico16 meeting_video_16"></span>
							</c:if>
						</v3x:column>
						<v3x:column width="15%" type="Date" align="center" label="common.date.sendtime.label">
							<fmt:formatDate value="${col.createDate}" pattern="${datetimePattern}" />
						</v3x:column>
						<v3x:column width="15%" type="String" label="relate.type" className="cursor-hand1 sort" align="center">
							<a href="${col.categoryUrl}">${col.category}</a>
						</v3x:column>
						<c:if test="${hasNewColl}">
							<v3x:column align="left" type="String" width="10%" className="cursor-hand1 sort" label="common.toolbar.transmit.label">
								<c:if test="${col.app==1}">
									<a href="javascript:forwardItem('${col.objectId}','${col.entityId}')"><fmt:message key="common.toolbar.transmit.label" bundle="${v3xCommonI18N}" /></a>
								</c:if>&nbsp;
                			</v3x:column>
						</c:if>
					</v3x:table>
				</form>
			</div>
		</div>
	</div>
	<script type="text/javascript">
	<!--
		var oHeight = parseInt(document.body.clientHeight) - 130;
		var oWidth = parseInt(document.body.clientWidth);
		initFFScroll('scrollListDiv', oHeight, oWidth);
	//-->
	</script>
</body>
</html>