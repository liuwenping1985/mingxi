<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum"%>
<%@ page import="com.seeyon.v3x.common.constants.Constants"%>
<html>
<head>

<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/skin/default/skin.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docFavorite.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/ui/seeyon.ui.tooltip-debug.js${v3x:resSuffix()}" />"></script>
<title></title>
<script type="text/javascript">
	<c:if test="${alertInfo != null && alertInfo != '' && from != 'message'}">
		alert("${alertInfo}");
		try {
			var parObj = window.parent;
			if(getA8Top() && getA8Top().OpenWindows){
				getA8Top().OpenWindows.close();
				getA8Top().OpenWindows = null;
			}else if(parObj) {
				var fromObj = v3x.getParentWindow(parObj);
				if(fromObj) {
					try {
						fromObj.location.reload();
					} catch(e) {}
					parObj.close();
				} else {
					parObj.location.reload();
				}
			}
		} catch(e) {}
	</c:if>
	<c:if test="${from == 'message'}">
	   alert("${alertInfo}");
	   try {
           window.parent.close();
       } catch(e) {}
	</c:if>
	//下一页响应事件
	function nextPage(page){
		var nowPage = page;
		var articleId = document.getElementById("articleId").value;
		var newPageSize = getPageSize();
		var newTotalPages = getTotalPages("${size}", newPageSize);
		if(nowPage>newTotalPages) {
			nowPage = newTotalPages;
		}
		if("${param.isCollCube}" == "1"){
			parent.window.location.replace("${detailURL}?method=showPost&articleId="+articleId+"&group=true&pageSizePara="+newPageSize+"&nowPagePara="+nowPage+"&fromPigeonhole="+"${param.fromPigeonhole}"+"&isCollCube="+"${param.isCollCube}");		
		}else{
			getA8Top().location.replace("${detailURL}?method=showPost&articleId="+articleId+"&group=true&pageSizePara="+newPageSize+"&nowPagePara="+nowPage+"&fromPigeonhole="+"${param.fromPigeonhole}");
		}
	}
	
	//上一页响应事件
	function prevPage(page){
		var nowPage =page;
		var articleId = document.getElementById("articleId").value;		
		var newPageSize = getPageSize();
		var newTotalPages = getTotalPages("${size}", newPageSize);
		if(nowPage>newTotalPages) {
			nowPage = newTotalPages;
		}	
		if("${param.isCollCube}" == "1"){
			parent.window.location.replace("${detailURL}?method=showPost&articleId="+articleId+"&group=true&pageSizePara="+newPageSize+"&nowPagePara="+nowPage+"&fromPigeonhole="+"${param.fromPigeonhole}"+"&isCollCube="+"${param.isCollCube}");
		}else{
			getA8Top().location.replace("${detailURL}?method=showPost&articleId="+articleId+"&group=true&pageSizePara="+newPageSize+"&nowPagePara="+nowPage+"&fromPigeonhole="+"${param.fromPigeonhole}");
		}
	}
	
	//首页响应事件
	function firstPage(){
		var pageSize = getPageSize();
		var articleId = document.getElementById("articleId").value;
		if("${param.isCollCube}" == "1"){
			parent.window.location.replace("${detailURL}?method=showPost&articleId="+articleId+"&group=true&pageSizePara="+pageSize+"&nowPagePara=1"+"&fromPigeonhole="+"${param.fromPigeonhole}"+"&isCollCube="+"${param.isCollCube}");
		}else{
			getA8Top().location.replace("${detailURL}?method=showPost&articleId="+articleId+"&group=true&pageSizePara="+pageSize+"&nowPagePara=1"+"&fromPigeonhole="+"${param.fromPigeonhole}");
		}
	}
	
	//末页响应事件
	function endPage(){
		var articleId = document.getElementById("articleId").value;
		var pageSize = getPageSize();
		var lasePageNum = getTotalPages("${size}", pageSize);
		if("${param.isCollCube}" == "1"){
			parent.window.location.replace("${detailURL}?method=showPost&articleId="+articleId+"&group=true&pageSizePara="+pageSize+"&nowPagePara="+lasePageNum+"&fromPigeonhole="+"${param.fromPigeonhole}"+"&isCollCube="+"${param.isCollCube}");
		}else{
			getA8Top().location.replace("${detailURL}?method=showPost&articleId="+articleId+"&group=true&pageSizePara="+pageSize+"&nowPagePara="+lasePageNum+"&fromPigeonhole="+"${param.fromPigeonhole}");
		}
	}
		
	//go响应事件
	function goPage(){
		var articleId = document.getElementById("articleId").value;
		var nowPageStr = document.getElementById("nowPage").value.trim();
		var nowPage = 1;
		var pageSize = getPageSize();
		var totalPages = getTotalPages("${size}", pageSize);
		if(isInt(nowPageStr)) {
			nowPage = parseInt(nowPageStr);
			if(nowPage>totalPages){
				nowPage = totalPages;
			}
			if(nowPage<=0) {
				nowPage = 1;
			}
		} 
		if("${param.isCollCube}" == "1"){
			parent.window.location.replace("${detailURL}?method=showPost&articleId="+articleId+"&group=true&pageSizePara="+pageSize+"&nowPagePara="+nowPage+"&fromPigeonhole="+"${param.fromPigeonhole}"+"&isCollCube="+"${param.isCollCube}");
		}else{
			getA8Top().location.replace("${detailURL}?method=showPost&articleId="+articleId+"&group=true&pageSizePara="+pageSize+"&nowPagePara="+nowPage+"&fromPigeonhole="+"${param.fromPigeonhole}");
			
		}
	}
	
	//回车响应go事件
	function changePage(){				
        if(event.keyCode==13){
            goPage();            
        }
    }
	
	function getTop() {
		document.getElementById("page_content").scrollTop = 0;
	}

	function getBottom() {
		document.getElementById("page_content").scrollTop = document.getElementById("page_content").scrollHeight;
	}
	//ie11 支持，之前用reload方法，ie11不支持
	function refreshItByBBs(){
		var _ppp = window.parent.location;
		window.parent.location.href = _ppp;
	}
	
	window.onbeforeunload = function(){
	    try {
			parent.window.opener.sectionHandler.reload("projectBbsSection",true);  
	        removeCtpWindow("${article.id}",2);
	    } catch (e) {
	    }
	}
</script>
<v3x:attachmentDefine attachments="${attachments}" />
<style>
.article p{
    font-size: 16px;
    line-height: 1.5;
}
.article font{
    line-height: 150%;
}
.reply p{
	font-size: 14px;
	line-height: 1.5;
}
.reply font{
	line-height: 150%;
}
.reply1 p{
    line-height: 150%;
    word-break:break-all;
}
.reply1 font{
    line-height: 150%;
}
ol{
	margin: auto;
}
.page2-list-border {
    BORDER-BOTTOM: #cdcdcd 1px solid; BORDER-LEFT: #cdcdcd 1px solid; BORDER-TOP: #cdcdcd 1px solid; BORDER-RIGHT: #cdcdcd 1px solid
}

div{
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}
</style>
</head>
<body style="overflow:hidden;">
<form name="postForm" id="postForm" method="post" style="margin: 0px;">
<input type="hidden" id="articleId" name="articleId" value="${article.id}">
<input type="hidden" name="replyUserId" value="${v3x:currentUser().id}">
<input type="hidden" name="resourceMethod" value="${resourceMethod}">
<input type="hidden" name="boardId" id="boardId" value="${board.id}">
<input type="hidden" name="messageNotifyFlag" value="${article.messageNotifyFlag}">
<input name="group" type="hidden" value="${group}">
<c:set value="${v3x:currentUser().id}" var="memberId" />
<table id="content" border="0" cellpadding="0" cellspacing="0" width="100%" height="45" align="center" style="height:45px;">
	<tr>
		<td width="100%" height="45" valign="top">
			 <table width="100%"  border="0" cellpadding="0" cellspacing="0" class="page_head_bg">
		     <tr class="page_topmenu" height="45">
		        <td class="page_title"><fmt:message key="bbs.label" /></td>
		        <c:if test="${article.state !=100}">
		        <td  align="right">
					<c:if test="${param.fromPigeonhole!=true && docCollectFlag eq 'true'}">
		        		 <span id="cancelFavorite${article.id}" class="font-size-12 cursor-hand ${!isCollect?'hidden':''}" onclick="javaScript:cancelFavorite_old('9','${article.id}','false','3','',false,20)">
                                <fmt:message key='bbs.cancel.favorite' />
                         </span>
                         <span id="favoriteSpan${article.id}" class="font-size-12 cursor-hand ${isCollect?'hidden':''}" onclick="javaScript:favorite_old('9','${article.id}','false','3')">
                                <fmt:message key='bbs.favorite' />
                         </span>
		        		<span class="margin_lr_5">|</span>
			       </c:if>
			        <c:if test="${canReply}">
						<a class="cursor-hand page_topmenu" href="javascript:getBottom();replyFromReferenceOrDirectly('1','${param.fromPigeonhole}','${isCollCube}','${param.fromIsearch}');"><fmt:message key="bbs.reply.post.label" /></a>
						<span class="margin_lr_5">|</span>
					</c:if>
					<a class="cursor-hand page_topmenu" onClick="refreshItByBBs()"><fmt:message key="common.toolbar.refresh.label" bundle="${v3xCommonI18N}" /></a>
					<c:if test="${isCollCube ne '1' and param.fromPigeonhole ne 'true' and param.fromIsearch ne 'true'}">
						<span class="margin_lr_5">|</span>
						<a class="cursor-hand page_topmenu" onclick="javascript:top.close()" ><fmt:message key="common.button.close.label" bundle="${v3xCommonI18N}" /></a>
					</c:if>
		        </td>
		       	</c:if>
		        <td  width="10"></td>
			</tr>
			</table>
		</td>
	</tr>
</table>
<div id="page_content" class="page_content" style="overflow: auto;">
<table border="0" cellpadding="0" cellspacing="0" width="100%" style="background:#fff;border:1px solid #dadada;">
	<tr>
		<td valign="top" class="padding5" height="70" id="articleContent">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" class="page2-list-border">
			    <tr>
				   <td colspan="2" valign="top">
					   <table border="0" cellpadding="0" cellspacing="0" width="100%" class="bbs-view-title-bar" >
					   <tr>
					   	<td  nowrap="nowrap">
						   	<b class="padding5" title="${v3x:toHTML(article.articleName)}">${v3x:toHTML(v3x:getLimitLengthString(article.articleName,50,"..."))}
					       		<c:choose>
									<c:when test="${article.resourceFlag==1}">
										[<fmt:message key="bbs.yuan.label" />]
									</c:when>
									<c:when test="${article.resourceFlag==2}">
										[<fmt:message key="bbs.zhuan.label" />]
									</c:when>
								</c:choose>
					        </b>
					   	</td>
					   </tr>
					   </table>
			       </td>
				</tr>
				<tr>
					<td  class="tbCellTemp bbs-bg" width="150px" nowrap>
						<table>
							<tr>
								<td width="50">
				                			<c:choose>
				                				<c:when test="${article.anonymousFlag && memberId!=article.issueUserId}">
				                					<img id="image1" src="${pageContext.request.contextPath}/apps_res/v3xmain/images/personal/pic.gif" class="radius" width="48" height="48" />
				                				</c:when>
				                				<c:otherwise>
				                					<c:choose>
														<c:when test="${image == '0'}">
															<img id="image1" src="${pageContext.request.contextPath}/fileUpload.do?method=showRTE&${issuerImage}&type=image" class="radius" width="48" height="48" />
														</c:when>
														<c:when test="${image == '1'}">
															<img id="image1" src="${pageContext.request.contextPath}/apps_res/v3xmain/images/personal/${issuerImage}" class="radius" width="48" height="48" />
														</c:when>
														<c:otherwise>
															<img id="image1" src="${pageContext.request.contextPath}/apps_res/v3xmain/images/personal/pic.gif" class="radius" width="48" height="48" />
														</c:otherwise>
													</c:choose>
				                				</c:otherwise>
											</c:choose>
		                		</td>
		                	</tr>
		                	<tr>
		                		<td width="56" align="center">
		                			<div class="bbs-member-name" style="white-space: nowrap; margin-top: 3px;">
		                			<c:choose>													
										<c:when test="${article.anonymousFlag && memberId!=article.issueUserId}">
											<fmt:message key="anonymous.label"/>
										</c:when>
										<c:otherwise>${v3x:showMemberName(article.issueUserId)}</c:otherwise>												
									</c:choose>
									</div>
								</td>
							</tr>
						</table>
						<c:choose>
							<c:when test="${article.anonymousFlag && memberId!=article.issueUserId}">
								<div><fmt:message key="department.label" />&nbsp;:&nbsp;*****</div>
								<div><fmt:message key="station.label" />&nbsp;:&nbsp;*****</div>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${custom}">
										<div><fmt:message key="department.label" />&nbsp;:&nbsp;${v3x:getOrgEntity('Department',depId).name}</div>
										<div><fmt:message key="station.label" />&nbsp;:&nbsp;${v3x:getOrgEntity('Post',article.post).name}</div>
									</c:when>
									<c:otherwise>
										<div><fmt:message key="department.label" />&nbsp;:&nbsp;${v3x:getOrgEntity('Department',article.department).name}</div>
										<div><fmt:message key="station.label" />&nbsp;:&nbsp;${v3x:getOrgEntity('Post',article.post).name}</div>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
						<div><fmt:message key="bbs.board.label" />&nbsp;:&nbsp;${v3x:toHTML(board.name)}</div>
						<c:set value="${v3x:showOrgEntitiesOfTypeAndId(issueArea, pageContext)}" var="issueAreastr" />
						<div title="${issueAreastr}">
							<fmt:message key="common.issueScope.label" bundle="${v3xCommonI18N}" />&nbsp;:&nbsp;${v3x:getLimitLengthString(issueAreastr, 48, '...')}
						</div>
					</td>
					<td valign="top">
						<table  border="0" height="100%" width="100%" cellspacing="0" cellpadding="0" style="background:#fff;">
							<tr>
								<td class="tbCell4 bbs-tb-padding" height="24" >
									<div class="div-float">
									<fmt:message key="bbs.issue.at.label" /><fmt:formatDate value="${article.issueTime}" pattern="${dataPattern}"/>
									</div>
									<div class="div-float-right padding5">
									<fmt:message key="bbs.clicknumber.label"/>：${article.clickNumber } &nbsp;&nbsp; <fmt:message key="bbs.replynumber.label"/>：${size }
			     			   		</div>
								</td>
							</tr>
							<tr>
								<td colspan="2"  width="100%" valign="top">
									<table  height="100%" width="100%" cellspacing="0" cellpadding="0">
										<tr>
										<td class="wordbreak , bbs-tb-padding2" valign="top" width="100%"> 
															<div class="article">${article.content}</div>
										</td>
					
										</tr>
										<tr>
                                            <td>
                                                <div class="padding30" style="display: none; " id="attsDiv2${article.id}">
                                                    <div class="atts-label"><fmt:message key="common.mydocument.label"  bundle="${v3xCommonI18N}" /> :&nbsp;&nbsp;</div>
                                                    <script type="text/javascript">
                                                        showAttachment('${article.id}', 2, 'attsDiv2${article.id}');
                                                    </script>
                                                </div>
                                            </td>
                                        </tr>
										<tr>
											<td>
												<div class="padding30" style="display: none; " id="attsDiv${article.id}">
													<div class="atts-label"><fmt:message key="common.attachment.label"  bundle="${v3xCommonI18N}" /> :&nbsp;&nbsp;</div>
													<script type="text/javascript">
														showAttachment('${article.id}', 0, 'attsDiv${article.id}');
													</script>
												</div>
											</td>
										</tr>
										
										<c:if test="${article.modifyTime!=null}">
											<tr>
												<td valign="top">
													<div class="div-float padding30">
														<font color="#1039B2">
														<c:choose>													  	  
															<c:when test="${article.anonymousFlag && memberId!=article.issueUserId }">
																<fmt:message key="anonymous.label"/>
															</c:when>
															<c:otherwise>${v3x:showMemberName(article.issueUserId)}</c:otherwise>
														</c:choose>
														<fmt:message key="bbs.at.label"/>&nbsp;
														<fmt:formatDate value="${article.modifyTime}" type="both" dateStyle="medium"/>&nbsp;
														<fmt:message key="bbs.finallyeditarticle.label" /></font>
													</div>
												</td>
											</tr>
										</c:if>
									</table>
								</td>
							</tr>
							<tr align="right">
								<td height="20" class="bbs-view-border-top">
									<c:if test="${article.state !=100}">
									<c:if test="${canModify}"><a style="margin-right: 15px;" href="javascript:editArticle('${detailURL}?method=modifyPost&articleId=${article.id}&boardId=${board.id}&flag=modify&group=${param.group}', '${size}','${isCollCube}');" >[<fmt:message key="bbs.edit.label"/>]</a></c:if>
									<c:if test="${canReply}"><a style="margin-right: 15px;" href="javascript:getBottom();replyFromReferenceOrDirectly('2','${param.fromPigeonhole}','${isCollCube}');" >[<fmt:message key="bbs.reference.label"/>]</a></c:if>
									<c:if test="${canDeleteArticleFlag}"><a style="margin-right: 15px;" href="javascript:deleteArticle('${article.id}','${resourceMethod}','${board.id}','${group}')" >[<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />]</a></c:if>
									</c:if>
									<a style="margin-right: 15px;" onclick="getTop()"><img border="0" src="<c:url value='/apps_res/bbs/images/top.GIF'/>" alt="<fmt:message key='return.top.label'/>" ></a>
									<a style="margin-right: 30px;" onclick="getBottom()"><img border="0" src="<c:url value='/apps_res/bbs/images/bottom.GIF'/>" alt="<fmt:message key='return.buttom.label'/>"></a>
								</td>
							</tr>
					   </table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="padding5">		
			<c:set value='${nowPage == 1 ? 1 : ((nowPage-1)*pageSize+1) }' var='i' />
			<c:forEach items="${replyModelList}" var="replyPost">
				<table  border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top: 10px;"  class="page2-list-border">
					<tr  height="100%">
						<td  class="tbCellTemp bbs-bg"  width="150px" nowrap>
							<c:set value="${v3x:getOrgEntity('Member',replyPost.replyUserId)}" var="replyMember" />
							<table>
							<tr>
								<td width="50">
											<c:choose>
												<c:when test="${replyPost.anonymousFlag && memberId!=replyPost.replyUserId}">
													<img src="${pageContext.request.contextPath}/apps_res/v3xmain/images/personal/pic.gif" class="radius" width="50" height="50" />
												</c:when>
												<c:otherwise>
				                					<c:choose>
														<c:when test="${replyPost.imageType == '0'}">
															<img src="${pageContext.request.contextPath}/fileUpload.do?method=showRTE&${replyPost.self_image_name}&type=image" class="radius" width="50" height="50" />
														</c:when>
														<c:when test="${replyPost.imageType == '1'}">
															<img src="${pageContext.request.contextPath}/apps_res/v3xmain/images/personal/${replyPost.self_image_name}" class="radius" width="50" height="50" />
														</c:when>
														<c:otherwise>
															<img src="${pageContext.request.contextPath}/apps_res/v3xmain/images/personal/pic.gif" class="radius" width="50" height="50" />
														</c:otherwise>
													</c:choose>
				                				</c:otherwise>
				                			</c:choose>
			                	</td>	
			                </tr>
			                <tr>
								<td width="56" align="center">
									<div class="bbs-member-name"  style="white-space: nowrap; margin-top: 3px;">
			                			<c:choose>										  	
											<c:when test="${replyPost.anonymousFlag && memberId!=replyPost.replyUserId}"><fmt:message key="anonymous.label"/></c:when>
											<c:otherwise>${v3x:showMemberName(replyPost.replyUserId)}</c:otherwise>
										</c:choose>	
                					</div>	
                				</td>
                			</tr>
                			</table>					
							<c:choose>
								<c:when test="${replyPost.anonymousFlag && memberId!=replyPost.replyUserId}">	
									<fmt:message key="department.label" />&nbsp;:&nbsp;*****<br>
									<fmt:message key="station.label" />&nbsp;:&nbsp;*****<br>
								</c:when>												
								<c:otherwise>
									<fmt:message key="department.label" />&nbsp;:&nbsp;${v3x:getOrgEntity('Department',replyMember.orgDepartmentId).name}<br>
									<fmt:message key="station.label" />&nbsp;:&nbsp;${v3x:getOrgEntity('Post',replyMember.orgPostId).name}<br>
								</c:otherwise>
							</c:choose>
						</td>
						<td valign="top">
							<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="tbCell4  bbs-tb-padding" width="55%"  height="24"><b title="${v3x:toHTML(replyPost.replyName)}">${v3x:toHTML(v3x:getLimitLengthString(replyPost.replyName,60,"..."))}</b></td>												
										<td class="tbCell4  bbs-tb-padding" style="color:#6a6a69" width="40%"  height="24"  align="right"><fmt:message key="bbs.reply.at.label" />
											<fmt:formatDate value="${replyPost.replyTime}" pattern="${dataPattern}"/>
										</td>
										<td  class="tbCell4" width="5%"  height="10" >
											<div class="bbs-div-padding-right">${i}<fmt:message key="bbs.floor.label" /></div>
										</td>
									</tr>
									<tr>
										<td style="padding-left: 16px;padding-top:0px;padding-bottom:0px;" valign="top" colspan="3" height="100%">
											<div style="width:100%;overflow-x:auto;overflow-y:hidden;">
												<table width='100%' border='0' cellspacing='0' cellpadding='0'>
													<c:if test="${(replyPost.useReplyFlag == 3  && replyPost.refPostContent != null) || replyPost.useReplyFlag == 2}">
														<tr>
															<td style="padding-left: 10px;padding-right: 26px;padding-top:3px" >
																<table width='100%' border='0' class='border-top border-left border-right border-bottom' cellspacing='0' cellpadding='0'>
																	<tr>
																		<td width='100%' height='24' bgcolor='#f2f9ff' class='bbs-tb-padding border-bottom'>
																			<b><fmt:message key="bbs.reference.label"/>:</b>
																		</td>
																	</tr>
																	<tr>
																		<td valign="top" width='100%' id="reply" bgcolor='#f2f9ff' class='wordbreak , bbs-tb-padding'>
																		<c:if test="${replyPost.useReplyFlag == 3}">
																			<c:choose>
																				<c:when test="${replyPost.refPostIssueUserName !=null}">
																					${replyPost.refPostIssueUserName}
																				</c:when>
																				<c:otherwise>
																					<fmt:message key="anonymous.label"/>
																				</c:otherwise>
																			</c:choose>
																			&nbsp;<fmt:message key="bbs.at.label"/>&nbsp;
																			<fmt:formatDate value="${replyPost.refPostIssueTime}" pattern="${dataPattern}" />
																			&nbsp;<fmt:message key="bbs.issue.label"/>
																			<br><br>
																			<div class="reply1">${replyPost.refPostContent}&nbsp;</div>
																		</c:if>
																		<c:if test="${replyPost.useReplyFlag == 2}">
																			<c:choose>
																				<c:when test="${article.anonymousFlag }">
																					<fmt:message key="anonymous.label"/>
																				</c:when>
																				<c:otherwise>${v3x:showMemberName(article.issueUserId)}</c:otherwise>
																			</c:choose>
																			&nbsp;<fmt:message key="bbs.at.label"/>&nbsp;
																			<fmt:formatDate value="${article.issueTime}" pattern="${dataPattern}"/>
																			&nbsp;<fmt:message key="bbs.issue.label"/>
																			<br><br>
																			<div class="reply1">${article.content}&nbsp;</div>
																		</c:if>
																		</td>
																	</tr>
																</table>
															</td>
														</tr>
													</c:if>
													<tr>
														<td class="wordbreak , bbs-tb-padding2" valign="top" width="100%"> 
															<div class="reply">${replyPost.content}</div>
														</td>
													</tr>
													<tr>
														<td class="wordbreak , bbs-tb-padding2" valign="top" width="100%"> 
															<div class="div-float" style="display: none" id="attsTR${replyPost.id}">
															<div class="atts-label"><fmt:message key="common.attachment.label"   bundle="${v3xCommonI18N}"/> :&nbsp;&nbsp;</div>
																<div id="attsDiv${replyPost.id}"></div>
															</div>
														</td>
													</tr>
													<tr>
                                                        <td class="wordbreak , bbs-tb-padding2" valign="top" width="100%"> 
                                                            <div class="div-float" style="display: none" id="attsTR2${replyPost.id}">
                                                            <div class="atts-label"><fmt:message key="common.mydocument.label"   bundle="${v3xCommonI18N}"/> :&nbsp;&nbsp;</div>
                                                                <div id="attsDiv2${replyPost.id}"></div>
                                                            </div>
                                                        </td>
                                                    </tr>
													
													<c:if test="${replyPost.modifyTime!=null}">
													<tr>
														<td class="wordbreak , bbs-tb-padding2" valign="top" width="100%">
															<div class="div-float">												
																<font color="#1039B2">
																	<c:choose>
																	<c:when test="${replyPost.anonymousFlag && memberId!=replyPost.replyUserId}">
																		<fmt:message key="anonymous.label"/>
																	</c:when>
																	<c:otherwise>${v3x:showMemberName(replyPost.replyUserId)}</c:otherwise>															
																	</c:choose> 
																	<fmt:message key="bbs.at.label"/>&nbsp;
																	<fmt:formatDate value="${replyPost.modifyTime}" type="both" dateStyle="medium"/>&nbsp;
																	<fmt:message key="bbs.finnalyeditreply.label" />														
																</font>
															</div>
														</td>
													</tr>
													</c:if>	
												</table>
											</div>
										</td>
									</tr>
										<tr align="right" height="20">
											<td colspan="3"  class="bbs-view-border-top">
												<c:if test="${article.state !=100}">
												<c:if test="${replyPost.canBeEditedFlag == 1 && canReply}">
													<a href="javascript:getBottom();editReply('${replyPost.id}', '${article.id}', '${size}','${param.fromPigeonhole}');" >
													<fmt:message key="bbs.edit.label"/></a>&nbsp;&nbsp;&nbsp;&nbsp;
												</c:if>	
												<c:if test="${canReply}">
													<a href="javascript:getBottom();replyReplyFromReferenceOrDirectly('${replyPost.id}', '3', '${param.fromPigeonhole}', '${isCollCube}','${param.fromIsearch}');">
													<fmt:message key="bbs.reference.label"/></a>&nbsp;&nbsp;&nbsp;&nbsp;
												</c:if>
												<c:if test="${replyPost.canBeDeleteFlag == 1 && canReply}">
													<a href="javascript:deleteReplyPost('${replyPost.id}','${article.id}','${group}','${size}','${param.fromPigeonhole}');" >
													<fmt:message key="delete.label"/></a>&nbsp;&nbsp;&nbsp;&nbsp;
												</c:if>
												</c:if>
												<a onclick="getTop()"><img border="0" src="<c:url value='/apps_res/bbs/images/top.GIF'/>" alt="<fmt:message key='return.top.label'/>" ></a>&nbsp;&nbsp;&nbsp;&nbsp;
												<a onclick="getBottom()"><img border="0" src="<c:url value='/apps_res/bbs/images/bottom.GIF'/>" alt="<fmt:message key='return.buttom.label'/>"></a>&nbsp;&nbsp;&nbsp;&nbsp;
											</td>
										</tr>
									</table>
								</td>
							</tr>
				</table>
			<c:set value="${i+1}" var='i' />
			</c:forEach>
		</td>
	</tr>
	<tr>
		<td align="right" class="padding5" valign="top">
        <DIV class="common_over_page align_right">
                                每页显示
         <INPUT class=common_over_page_txtbox id='pageSize' value="${pageSize}">
         <SPAN class=margin_r_20>条/共${size}条</SPAN>
          <A title=首页 class=common_over_page_btn href="javascript:firstPage();"><EM class=pageFirst></EM></A>
          <A title=上一页 class=common_over_page_btn href="javascript:prevPage('${(nowPage-1)>=1?(nowPage-1):1}')"><EM class=pagePrev></EM></A>
          <A title=下一页 class=common_over_page_btn href="javascript:nextPage('${(nowPage+1)<=pages?(nowPage+1):pages}');"><EM class=pageNext></EM></A>
          <A title=尾页 class=common_over_page_btn href="javascript:endPage();"><EM class=pageLast></EM></A>
          <SPAN class=margin_l_10>第</SPAN>
          <INPUT class=common_over_page_txtbox  id='nowPage'  value="${nowPage>=1?nowPage:1}">页/${pages}页
          <A id=grid_go class=common_over_page_btn href="javascript:goPage();">go</A>&nbsp;&nbsp;&nbsp;&nbsp;
         </DIV>
        </td>
	</tr>
	<tr id="canReply" >
		<td class="padding5 bbs-tb-padding-topAndBottom" valign="top">
		<c:if test="${article.state !=100}">
			<c:if test="${canReply}">
				<iframe id="replyArticle" name="replyArticle" frameborder="0" width="100%" style="height:430px;" src="${detailURL}?method=replyArticle&useReplyFlag=1&articleId=${article.id}&fromPigeonhole=${param.fromPigeonhole}&fromIsearch=${param.fromIsearch}&isCollCube=${isCollCube}"></iframe>
			</c:if>
		</c:if>
		</td>
	</tr>
</table>	
</div>
</form>
<iframe name="hiddenFrame" width="0" height="0" frameborder="0"></iframe>
<iframe name="newHiddenFrame" width="0" height="0" frameborder="0"></iframe>
<script type="text/javascript">
<!--
function showAttachments(type){
	if(theToShowAttachments.isEmpty()){
		return;
	}
	var subReference2Atts = new Properties();
	for(var i = 0; i < theToShowAttachments.size(); i++) {
		var att  = theToShowAttachments.get(i);
		if(att.type == type){
			var docs = subReference2Atts.get(att.subReference);
			if(docs == null){
				docs = new ArrayList();
				subReference2Atts.put(att.subReference,docs);
			}
			docs.add(att);
		}
	}
	var opnionIds = subReference2Atts.keys();
	for(var i = 0; i < opnionIds.size(); i++){
		var opnionId = opnionIds.get(i);
		var atts = subReference2Atts.get(opnionId);
		var str = new StringBuffer();
		for(var j = 0; j < atts.size(); j++){
			str.append(atts.get(j).toString(true, false));
		}
		var attachmentTr = document.getElementById("attsTR" + opnionId);
		var attachmentdiv = document.getElementById("attsDiv" + opnionId);

		if(attachmentTr && attachmentdiv){
			attachmentTr.style.display = '';
			attachmentdiv.innerHTML = str;
		}
	}

}

showAttachments(0);

function resizeBody(){
	try {
		<%-- 控制页面滚动条 --%>
		setHeightAuto("page_content", 20, 70);
		
		<%-- 翻页后，定位到该页的第一处回复 --%>
		var nowPage = parseInt("${nowPage}");
		if(nowPage > 1) {
			document.getElementById("page_content").scrollTop = document.getElementById("articleContent").clientHeight;
		}
	} catch (e) {}
}

resizeBody();

if (document.all) {
	window.attachEvent("onresize", resizeBody);
} else {
	window.addEventListener("resize", resizeBody, false);
}
//-->
</script>
</body>
</html>