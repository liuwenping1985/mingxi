<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title></title>
<script type="text/javascript">
	//getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(24); 
</script>
</head>
<body scroll="no" style="padding: 5px">
<form action="" name="articleForm" id="articleForm" method="post" style="margin: 0px">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td style="padding-top:3px;">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td style="padding-top:3px;">
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td valign="bottom" height="26" class="tab-tag">
						<div class="div-float">
						<div class="tab-tag-left-sel"></div>
						<div class="tab-tag-middel-sel"><fmt:message key="bbs.label" /></div>
						<div class="tab-tag-right-sel"></div>
						</div>
						</td>
					</tr>
					<tr>
						<td class="tab-body-border">
						<div class="scrollList">
						<form name="fm" method="post" action="" onsubmit="">
						<v3x:table htmlId="pending" data="boardModelList" var="col2" showPager="false" isChangeTRColor="false" showHeader="true">
							<v3x:column width="6%" align="center">
								<img height="40px" src="<c:url value="/apps_res/bbs/images/${col2.hasNewPostFlag ? 'light' : 'dark'}.gif"/>"
										title="<fmt:message key="bbs.${col2.hasNewPostFlag ? 'has' : 'no'}.new.post.label"/>">
							</v3x:column>
							<v3x:column width="20%" type="String" label="bbs.board.label" alt="${col2.boardName}">
								<strong><a href="${detailURL}?method=listBoardArticle&id=${col2.id}&group=group"
									class='titleDefaultCss'>${v3x:getLimitLengthString(col2.boardName,25,"...")}</a></strong>
							</v3x:column>
							<v3x:column width="21%" type="String"
								label="common.description.label"
								value="${col2.boardDescription }" maxLength="40">
							</v3x:column>
							<v3x:column width="10%" type="Number" align="center"
								label="bbs.subject.number.label" value="${col2.articleNumber}">
							</v3x:column>
							<v3x:column width="8%" type="Number" align="center"
								label="bbs.total.post.number.label"
								value="${col2.sumPostNumber}">
							</v3x:column>
							<v3x:column width="8%" type="Number" align="center"
								label="bbs.elite.number.label">
								<a href="${detailURL}?method=listBoardElite&id=${col2.id}"
									class="hyper_link2"
									title="<fmt:message key='bbs.elite.post.label'/>">
								${col2.elitePostNumber} </a>
							</v3x:column>
							<c:set value="${v3x:showOrgEntitiesOfIds(v3x:joinDirectWithSpecialSeparator(col2.board.admins, ','), 'Member', pageContext)}" var="admins" />
							<v3x:column width="27%" label="bbs.admin.label" alt="${admins}" value="${admins}" maxLength="20" symbol="..." />
						</v3x:table></form>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr><td height="18"><br></td></tr>
		</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
