<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@include file="header.jsp"%>
<%@ taglib uri="http://www.seeyon.com/ctp" prefix="ctp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><fmt:message key="relate.type.relatemember" /></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/decorations/layout/D2-M_5-5_T/css/styles.css${v3x:resSuffix()}" />">
<script language=javascript src="<c:url value='/apps_res/plan/js/output_mul_day.js${v3x:resSuffix()}'/>"></script>
<style type="text/css">
.portal-layout-TwoColumns #column1 {
	width: 49.5%;
	float: right;
	margin-left: 0px;
	position: relative;
	_position: static;
	right: 2px;
	right: 0px\9;
}
.meeting_video_16 {
	background-position: -240px -16px;
}
.sectionTitle {
	margin-left: 5px;
}
.mxt-grid-header {
	padding-bottom: 0px;
}
td.sort {
	border-right: none;
}
#pending {
	border: none;
}
</style>
<script type="text/javascript">
	resetCtpLocation();

	var today = new Date();
	var myYear = today.getFullYear();
	var myMonthTop = today.getMonth() + 1;
	var myDayOfMonth = today.getDate();
	var relateMemberId = "${member.id}";
	var dialogCalEventAdd;
	function openTheWindow(url) {
		dialogCalEventAdd = new MxtWindow({
			id : 'dialogCalEventAdd',
			title : _("relateLang.calendar_event_add"),
			url : url,
			width : 600,
			height : 550,
			type : 'window',
			targetwindow : window.parent.top,
			isDrag : false,
			buttons : [ {
				id : "sure",
				text : _("relateLang.calendar_sure"),
				emphasize:true,
				handler : function() {
					dialogCalEventAdd.getReturnValue();
				}
			}, {
				id : "cancel",
				text : _("relateLang.calendar_cancel"),
				handler : function() {
					dialogCalEventAdd.close();
				}
			} ]
		});
	}
	
	function reloadPage() {
		if (dialogCalEventAdd) {
			dialogCalEventAdd.close();
		}
		document.location.reload();
	}
	
	function openDetails(url) {
		var args = new Array();
		args['url'] = url;
		args['width'] = 1400;
		args['height'] = 800;
		v3x.openWindow(args);
	}
	
	function sendMessageForCards(name, id) {
		getA8Top().sendUCMessage(name, id);
	}
	
	var allDate = new Properties();//日历事件
	var isChangeMonth = 0;//记录是否点击上月、下月
	<c:forEach items="${dateSet}" var="d">
		var e = new ArrayList();
		<c:forEach items="${d.value}" var="e">
			e.add("${v3x:escapeJavascript(e)}");
		</c:forEach>
		allDate.put("${d.key}", e);
	</c:forEach>
	
    function newCollaboration(){
        openCtpWindow({'url':'${pageContext.request.contextPath}/collaboration/collaboration.do?method=newColl&memberId=${member.id}&from=relatePeople'});
    }
    
    function openCollaboration(url){
        openCtpWindow({'url':url});
    }
</script>
<style> 
 .project-layout-TwoColumns 
 { 
 float: left; 
 border: 0px solid blue; 
 width: 100%; 
 } 
 .project-layout-TwoColumns #banner 
 { 
 width: 100%; 
 float: left; 
 display: inline; 
 border: 0px solid red; 
 } 
 .project-layout-TwoColumns #column0 
 { 
 width: 49.9%; 
 _width: 49.6%; 
 float: left; 
 } 
 .project-layout-TwoColumns #column1 
 { 
 width: 49.5%; 
 float: right; 
 margin-left: 4px; 
 position:relative; 
 _position:static; 
 right:2px; 
 right:0px\9; 
 } 
 .sectionSingleTitleLine{
 	background: none;
 	background-color: #daeaf1;
 }
 .sectionBody{
 	background:none;
 }
 </style> 
</head>
<body scroll="no" style="overflow: hidden">
	<c:set value="${v3x:hasNewCollaboration()}" var="hasNewColl" />
	<c:set value="${v3x:hasMenu('F02_eventlist')}" var="hasNewCal" />
	<div class="main_div_center">
		<div class="right_div_center">
			<div id="right_div_portal_sub" class="center_div_center">
				<div class="banner-layout">
					<table width="100%" height="60" border="0" cellpadding="0" cellspacing="0" style="background:#a2d2e6;">
						<tr>
							<td width="45" class="page2-header-img"><div class="identificationConfig"></div></td>
							<td width="380">
								<table width="100%" height="100%" border="0" cellpadding="0" class="ellipsis" cellspacing="0">
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td nowrap="nowrap" valign="bottom" class="border-padding">
											<span class="relatepepleTitleCss">${member.name}</span>
											<c:choose>
												<c:when test="${(!empty OnlineUser) && OnlineUser.state == 'online'}">
													(<fmt:message key="relate.online.${OnlineUser.onlineSubState}" />)
												</c:when>
												<c:otherwise>
													(<fmt:message key="relate.offline" />)
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
								</table>
							</td>
							<td align="right" valign="bottom" style="padding-top: 4px; padding-right: 20px;">
								<table width="100%" height="52" border="0" cellpadding="0" cellspacing="0" class="ellipsis">
									<tr>
										<td width="31%" align="right">&nbsp;<fmt:message key="relate.memberinfo.dep" /></td>
                                        <c:set value="${v3x:showDepartmentFullPath(member.orgDepartmentId)}" var="deptName" />
										<td width="28%" title="${deptName}">&nbsp;${v3x:toHTML(deptName)}</td>
										<td width="15%" align="right">&nbsp;<fmt:message key="relate.memberinfo.handphone1" /></td>
										<td width="28%" title="${telNumber}">&nbsp;${telNumber}</td>
									</tr>
									<tr>
										<td align="right">&nbsp;<fmt:message key="relate.memberinfo.post1" /></td>
										<td title="${post}">&nbsp;${post}</td>
										<td align="right">&nbsp;<fmt:message key="relate.memberinfo.tel" /></td>
										<td title="${member.officeNum}">&nbsp;${member.officeNum}</td>
									</tr>
									<tr>
										<td align="right">&nbsp;
											<%--政务版，【职务级别】显示为【职务】--%>
											<c:choose>
												<c:when test="${v3x:getSysFlagByName('is_gov_only')=='true'}">
													<fmt:message key="relate.memberinfo.level.GOV1" /><fmt:message key="relate.memberinfo.level.GOV2" />
												</c:when>
												<c:otherwise>
													<fmt:message key="relate.memberinfo.level" />
												</c:otherwise>
											</c:choose>
										</td>
										<td title="${level}">&nbsp;${level}</td>
										<td align="right">&nbsp;<fmt:message key="relate.memberinfo.email" /></td>
										<td title="${member.emailAddress}">&nbsp;${member.emailAddress}</td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
				<div class="project-layout-TwoColumns">
					<div id="column0" class="portal-layout-column" style="width: 50%">
						<div class="portal-layout-cell ">
							<div class="portal-layout-cell_head">
								<div class="portal-layout-cell_head_l"></div>
								<div class="portal-layout-cell_head_r"></div>
							</div>
							<table border=0 cellSpacing=0 cellPadding=0 width="100%" class="portal-layout-cell-right main-bg border_all">
								<tbody>
									<tr>
										<td class="sectionTitleLine sectionTitleLineBackground">
											<div class=sectionSingleTitleLine>
												<div class=sectionTitleLeft></div>
												<div class=sectionTitleMiddel>
													<div class=sectionTitlediv>
														<SPAN class=sectionTitle>
															<fmt:message key="relate.youreceive.label">
																<fmt:param value="${member.name}" />
															</fmt:message>
														</SPAN>
													</div>
												</div>
												<div style="FLOAT: right" class=sectionTitleRight></div>
											</div>
										</td>
									</tr>
									<tr>
										<td class="sectionBody sectionBodyBorder">
											<v3x:table htmlId="pending" dragable="false" leastSize="8" data="senderList" var="col" pageSize="8" showHeader="false" showPager="false" size="1" className="sort ellipsis">
												<v3x:column type="String" maxLength="20" className="cursor-hand1 sort" hasAttachments="${col.hasAttsFlag}" importantLevel="${col.importantLevel}" bodyType="${col.bodyType}" flowState="${col.finish ? 3 : 0}">
													<a class="title-more" href="javascript:openCollaboration('${col.subjectUrl}')" title="${v3x:toHTMLescapeRN(col.subject)}">${v3x:toHTMLescapeRN(v3x:getLimitLengthString(col.subject, 36, '...'))}</a>
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
												<v3x:column width="30" type="String" align="left">
													<c:choose>
														<c:when test="${col.app==1 && hasNewColl}">
															<a href="javascript:forwardItem('${col.objectId}','${col.entityId}')"><fmt:message key="common.toolbar.transmit.collaboration.label" bundle="${v3xCommonI18N}" /> </a>
														</c:when>
														<c:otherwise>
															&nbsp;
														</c:otherwise>
													</c:choose>
												</v3x:column>
												<v3x:column width="90" type="Date" align="left">
													<fmt:formatDate value="${col.createDate}" pattern="${datePattern}" />
												</v3x:column>
												<v3x:column width="40" type="String" align="right" className="cursor-hand1 sort padding_r_5">
													<a href="${col.categoryUrl }">${col.category}</a>
												</v3x:column>
											</v3x:table>
										</td>
									</tr>
									<tr>
										<td>
											<div class="align_right" style="padding: 2px 5px 5px 5px;">
												<c:if test="${hasNewColl}">
													[<a href="javascript:newCollaboration();"><fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' /><fmt:message key="application.1.label" bundle="${v3xCommonI18N}" /></a>]
												</c:if>
												<c:if test="${v3x:hasNewMail()}">
													[<a href="<html:link renderURL='/webmail.do?method=create&defaultaddr=${member.emailAddress}'/>"><fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' /><fmt:message key="relate.send.email" /></a>]
												</c:if>
												<c:if test="${v3x:hasPlugin('uc')}">
													[<a href="javascript:sendMessageForCards('${member.name}', '${member.id}')"><fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}' /><fmt:message key="relate.send.onlinemessage" /></a>]
												</c:if>
												[<a href="<html:link renderURL='/relateMember.do?method=morePendingOrSending&memberId=${member.id }&relatedId=${relatedId }&departmentId=${ param.departmentId }'/>"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>]
											</div>
										</td>
									</tr>
								</tbody>
							</table>
							<div class="portal-layout-cell_footer">
								<div class="portal-layout-cell_footer_l"></div>
								<div class="portal-layout-cell_footer_r"></div>
							</div>
						</div>
						
						<div class="portal-layout-cell ">
							<div class="portal-layout-cell_head">
								<div class="portal-layout-cell_head_l"></div>
								<div class="portal-layout-cell_head_r"></div>
							</div>
							<table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right main-bg border_all">
								<tbody>
									<tr>
										<td class="sectionTitleLine sectionTitleLineBackground">
											<div class=sectionSingleTitleLine>
												<div class=sectionTitleLeft></div>
												<div class=sectionTitleMiddel>
													<div class=sectionTitlediv>
														<SPAN class=sectionTitle>
															<fmt:message key="relate.shareDocs">
																<fmt:param value="${member.name}" />
															</fmt:message>
															<c:if test="${ctp:hasResourceCode('F04_blogHome')}">
																<c:if test="${isBlogOpen}">
																	<a href="${blogURL}?method=listAllArticle&userId=${member.id}">
																		<fmt:message key="relate.blog"><fmt:param value="${member.name}" /></fmt:message>
																	</a>
																</c:if>
															</c:if>
														</SPAN>
													</div>
												</div>
												<div style="FLOAT: right" class=sectionTitleRight></div>
											</div>
										</td>
									</tr>
									<tr>
										<td class="sectionBody sectionBodyBorder">
											<table width="100%" height="224" border="0" cellpadding="0" cellspacing="0">
                                                <c:forEach varStatus="status" begin="0" end="7">
                                                <c:set value="${status.index * 2}" var="index1" />
                                                <c:set value="${index1 + 1}" var="index2" />
												<tr class="border-bottom">
													<td width="5%" align="center" class="sort">&nbsp;</td>
													<td width="48%" class="sort">
														<c:if test="${docVO[index1]!=null}">
															<img src="${pageContext.request.contextPath}/apps_res/doc/images/docIcon/${docVO[index1].closeIcon}" />
															<a class="title-more" href="<html:link renderURL='/doc.do?method=docHomepageIndex&isShareAndBorrowRoot=true&docResId=${docVO[index1].docResource.id }'/>" title="${docVO[index1].showName}">${v3x:getLimitLengthString(docVO[index1].showName, 33,'...')}</a>
														</c:if>&nbsp;
													</td>
													<td width="47%" class="sort">
														<c:if test="${docVO[index2]!=null}">
															<img src="${pageContext.request.contextPath}/apps_res/doc/images/docIcon/${docVO[index2].closeIcon}" />
															<a class="title-more" href="<html:link renderURL='/doc.do?method=docHomepageIndex&isShareAndBorrowRoot=true&docResId=${docVO[index2].docResource.id }'/>" title="${docVO[index2].showName}">${v3x:getLimitLengthString(docVO[index2].showName, 33,'...')}</a>
														</c:if>&nbsp;
													</td>
												</tr>
                                                </c:forEach>
												<tr>
													<td height="26" colspan="3" align="right" class="link" style="padding: 2px 5px 5px 5px;">
														[<a href="<html:link renderURL='/doc.do?method=docHomepageShareIndex&ownerId=${member.id}'/>"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>]
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</tbody>
							</table>
							<div class="portal-layout-cell_footer">
								<div class="portal-layout-cell_footer_l"></div>
								<div class="portal-layout-cell_footer_r"></div>
							</div>
						</div>
					</div>
					<div id="column1" class="portal-layout-column">
						<div class="portal-layout-cell ">
							<div class="portal-layout-cell_head">
								<div class="portal-layout-cell_head_l"></div>
								<div class="portal-layout-cell_head_r"></div>
							</div>
							<table border=0 cellSpacing=0 cellPadding=0 width="100%" class="portal-layout-cell-right main-bg border_all">
								<tbody>
									<tr>
										<td class="sectionTitleLine sectionTitleLineBackground">
											<div class=sectionSingleTitleLine>
												<div class=sectionTitleLeft></div>
												<div class=sectionTitleMiddel>
													<div class=sectionTitlediv>
														<SPAN class=sectionTitle>
															<fmt:message key="relate.yousend.label"><fmt:param value="${member.name}" /></fmt:message>
														</SPAN>
													</div>
												</div>
												<div style="FLOAT: right" class=sectionTitleRight></div>
											</div>
										</td>
									</tr>
									<tr>
										<td class="sectionBody sectionBodyBorder">
											<v3x:table htmlId="sending" dragable="false" leastSize="8" data="memberList" var="col" pageSize="8" showHeader="false" showPager="false" size="1" className="sort ellipsis">
												<v3x:column type="String" maxLength="20" className="cursor-hand1 sort" hasAttachments="${col.hasAttsFlag}" importantLevel="${col.importantLevel}" bodyType="${col.bodyType}" flowState="${col.finish ? 3 : 0}">
													<a class="title-more" href="javascript:openCollaboration('${col.subjectUrl}')" title="${v3x:toHTML(col.subject)}">${v3x:toHTML(v3x:getLimitLengthString(col.subject, 36, '...'))}</a>
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
												<v3x:column width="30" type="String" align="left">
													<c:choose>
														<c:when test="${col.app==1 && hasNewColl}">
															<a href="javascript:forwardItem('${col.objectId}','${col.entityId}')"><fmt:message key="common.toolbar.transmit.collaboration.label" bundle="${v3xCommonI18N}" /></a>
														</c:when>
														<c:otherwise>
															&nbsp;
														</c:otherwise>
													</c:choose>
												</v3x:column>
												<v3x:column width="90" type="Date" align="left">
													<fmt:formatDate value="${col.createDate}" pattern="${datePattern}" />
												</v3x:column>
												<v3x:column width="40" type="String" align="right" className="cursor-hand1 sort padding_r_5">
													<a href="${col.categoryUrl }">${col.category}</a>
												</v3x:column>
											</v3x:table>
										</td>
									</tr>
									<tr>
										<td>
											<div class="align_right" style="padding: 2px 5px 5px 5px;">
												[<a href="<html:link renderURL='/relateMember.do?method=morePendingOrSending&memberId=${ member.id }&relatedId=${ relatedId }&departmentId=${ param.departmentId }&from=send'/>"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>]
											</div>
										</td>
									</tr>
								</tbody>
							</table>
							<div class="portal-layout-cell_footer">
								<div class="portal-layout-cell_footer_l"></div>
								<div class="portal-layout-cell_footer_r"></div>
							</div>
						</div>
						
						<div class="portal-layout-cell ">
							<div class="portal-layout-cell_head">
								<div class="portal-layout-cell_head_l"></div>
								<div class="portal-layout-cell_head_r"></div>
							</div>
							<c:if test="${v3x:getSysFlagByName('event_notShow') != true}">
							<table border=0 cellSpacing=0 cellPadding=0 width="100%" class="portal-layout-cell-right main-bg border_all">
								<tbody>
									<tr>
										<td class="sectionTitleLine sectionTitleLineBackground">
											<div class=sectionSingleTitleLine>
												<div class=sectionTitleLeft></div>
												<div class=sectionTitleMiddel>
													<div class=sectionTitlediv>
														<SPAN class=sectionTitle>
															<fmt:message key="relate.calendar"><fmt:param value="${member.name}" /></fmt:message>
														</SPAN>
													</div>
												</div>
												<div style="FLOAT: right" class=sectionTitleRight></div>
											</div>
										</td>
									</tr>
									<tr>
										<td class="sectionBody sectionBodyBorder">
											<table width="100%" height="226" border="0" cellpadding="0" cellspacing="0">
												<tr>
													<td valign="top">
														<table width="100%" border="0" cellpadding="0" cellspacing="0">
															<SCRIPT language=javascript id=Change_js type=text/javascript>
																var lg = 1;
																if (v3x.currentLanguage == 'en') {
																	lg = 0;
																}
																drawCalendar(myYear, myMonthTop - 1, lg, allDate);
																fUpdateCal(myYear, myMonthTop - 1, myDayOfMonth, allDate);
															</SCRIPT>
														</table>
													</td>
												</tr>
												<tr>
													<td height="31" align="right">
														<c:choose>
															<c:when test="${relateType==3 && hasNewCal}">
																<span class="link">
																	[ <a href="javascript:openTheWindow('${calEventURL}?method=createCalEvent&appID=15&receiveMemberId=Member|${member.id}');"><fmt:message key="relate.consign.event" /></a> ]
																</span>
															</c:when>
															<c:when test="${relateType==2 && hasNewCal}">
																<span class="link">
																	[ <a href="javascript:openTheWindow('${calEventURL}?method=createCalEvent&appID=15&receiveMemberId=Member|${member.id}');"><fmt:message key="relate.consign.event" /></a> ]
																</span>
															</c:when>
															<c:when test="${(relateType==1 || relatedType==3) && hasNewCal}">
																<span class="link">
																	[ <a href="javascript:openTheWindow('${calEventURL}?method=createCalEvent&appID=15&receiveMemberId=Member|${member.id}');"><fmt:message key="relate.consign.event" /></a> ]
																</span>
															</c:when>
															<c:otherwise>
															</c:otherwise>
														</c:choose>&nbsp;
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</tbody>
							</table>
							</c:if>
							<div class="portal-layout-cell_footer">
								<div class="portal-layout-cell_footer_l"></div>
								<div class="portal-layout-cell_footer_r"></div>
							</div>
						</div>
					</div>
				</div>
				<form id="mainForm" name="mainForm" method="post" action=""></form>
				<IFRAME height="0%" name="empty" id="empty" width="0%" frameborder="0"></IFRAME>
			</div>
		</div>
	</div>
</body>
</html>