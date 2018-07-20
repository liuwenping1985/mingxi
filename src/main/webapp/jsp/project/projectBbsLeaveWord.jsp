<%-- 此页面废弃，留作纪念 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<table border=0 cellSpacing=0 cellPadding=0 width="100%">
	<tbody>
		<tr>
			<td class="sectionTitleLine sectionTitleLineBackground">
				<div class=sectionSingleTitleLine>
					<div class=sectionTitleLeft></div>
					<div class=sectionTitleMiddel>
					<div class=sectionTitlediv>
						<SPAN class=sectionTitle>
							<fmt:message key="project.info.myProjectBbs" />\<fmt:message key="project.info.myLeaveWord" />
						</SPAN>
					</div>
					</div>
					<div style="FLOAT: right" class=sectionTitleRight></div>
				</div>
			</td>
		</tr>
		<tr>
			<td class="sectionBody sectionBodyBorder messageReplyDiv">
			<div class="replyDivHidden" id="replyDiv" style="width: 350px;">
				<DIV class="header">
					<DIV class="title"><fmt:message key="project.leavemessage.range" /></DIV>
					<DIV class="close" onclick="hiddenLeaveWordDlg()"></DIV>
				</DIV>
				<DIV class="content"><TEXTAREA style="resize: none;" id="contentReplyArea" class="contentArea"></TEXTAREA></DIV>
				<DIV class="footer">
					<DIV class="sentMessage"><LABEL for="sendMessage"><INPUT id="sendMessage" CHECKED type="checkbox"><fmt:message key="project.leavemessage.sendmessage" /></LABEL></DIV>
					<DIV class="sentButton"><span class='fastBtn'>(Ctrl+Enter)</span><INPUT id="sendActionButton" class="sendAction" onclick="sendMessage('${projectCompose.projectSummary.id}','undefined','undefined')" value="<fmt:message key="project.leavemessage.send" />" type="button"></DIV>
				</DIV>
			</div>
			<table width="100%" height="200" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td height="30" colspan="6" class="txt_1">&nbsp; <fmt:message key="project.info.myProjectBbs" /></td>
				</tr>
				<tr>
					<td valign="top" class="padding5">
						<v3x:table className="dotted2"  dragable="false" htmlId="meetings" leastSize="3" data="bbsList" var="bbs" pageSize="5" showHeader="false" showPager="false" size="2">
							<v3x:column width="2%" align="right">
								<img src="<c:url value="/common/images/icon.gif"/>" width="10" height="10" />
							</v3x:column>
							<v3x:column align="left" width="45%" alt="${bbs.articleName}" hasAttachments="${bbs.attachmentFlag}">
								<a class="title-more" href="javascript:openWin('${bbsURL}?method=showPost&resourceMethod=listLatestFiveArticleAndAllBoard&articleId=${bbs.id}')">${v3x:toHTML(v3x:getLimitLengthString(bbs.articleName,17,"..."))}</a>
							</v3x:column>
							<v3x:column width="18%" type="String" label="common.issuer.label" alt="${bbs:showName(bbs, pageContext)}">
								<nobr>${bbs:showName(bbs, pageContext)}</nobr>
							</v3x:column>
							<v3x:column align="left" width="18%">
								<fmt:formatDate value='${bbs.issueTime}' pattern='MM/dd HH:mm' />
							</v3x:column>
						</v3x:table>
					</td>
				</tr>
				<tr>
					<td>
						<div class="more">
							<c:if test="${relat!=true}">
								[&nbsp;<a href="${bbsURL}?method=issuePost&showSpaceLacation=true&boardId=${projectCompose.projectSummary.id}"><fmt:message key="common.toolbar.new.label" bundle="${v3xCommonI18N}" /><fmt:message key="application.9.label" bundle="${v3xCommonI18N}" /></a>&nbsp;]
							</c:if>
							[&nbsp;<a href="${bbsURL}?method=moreProjectBbs&projectId=${projectCompose.projectSummary.id}&phaseId=${phaseId}"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>&nbsp;]
						</div>
					</td>
				</tr>
				<tr>
					<td height="25" colspan="6" class="txt_1">&nbsp; <fmt:message key="project.info.myLeaveWord" /></td>
				</tr>
				<tr> 
					<td valign="top" class="padding5">
						<v3x:table className="dotted2 ellipsis" dragable="false" htmlId="meetings" leastSize="3" data="leaveList" var="leaveWord" pageSize="5" showHeader="false" showPager="false" size="1">
							<v3x:column align="left" width="15%" alt="${v3x:showMemberName(leaveWord.creatorId)}">
		 						${v3x:getLimitLengthString(v3x:showMemberName(leaveWord.creatorId),10,"...")}
		 					</v3x:column>
							<v3x:column align="left" width="23%">
								<fmt:formatDate value='${leaveWord.createTime}' pattern='MM/dd HH:mm' />
		 					</v3x:column>
							<v3x:column align="left" width="64%" alt="${leaveWord.content}">
								<a class="title-more" href="javascript:showLeaveWordDlg('${leaveWord.id}')">${v3x:toHTML(leaveWord.content)}</a>
							</v3x:column>
						</v3x:table>
					</td>
				</tr>
				<tr>
					<td>
						<div class="more">
							[&nbsp;<a href='javascript:showLeaveWordDlgFromMore("${projectCompose.projectSummary.id}","${projectCompose.projectSummary.id}","${v3x:toHTMLWithoutSpaceEscapeQuote(projectCompose.projectSummary.projectName)}")'><fmt:message key="project.info.sendLeaveWord" /></a>&nbsp;]
							[&nbsp;<a href="<html:link renderURL='/guestbook.do' />?method=moreLeaveWordNew&project=true&hasAuthForNew=${hasAuthForNew }&departmentId=${projectCompose.projectSummary.id}&phaseId=${phaseId}&managerFlag=${managerFlag}"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>&nbsp;]
						</div>
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</tbody>
</table>