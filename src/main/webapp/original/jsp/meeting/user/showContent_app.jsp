<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.meetingroom.resources.i18n.MeetingRoomResources" var="v3xMtRoom"/>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>">
	<link href="<c:url value="/apps_res/form/css/SeeyonForm.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css"/> 
	<script type="text/javascript">
		//会议总结转发协同
		function summaryToCol(){
			var parentObj = getA8Top().window.dialogArguments;
			
			//判断会议总结是否存在   做防护
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxMtSummaryTemplateManager", "isMeetingSummaryExist", false);
			requestCaller.addParameter(1, "Long", '${bean.id}');
			var ds = requestCaller.serviceRequest();
			if(ds=='false'){
				alert(v3x.getMessage("meetingLang.meeting_has_delete"));
				return;
			}
			
			if(parentObj){
				var a8Top = parentObj.getA8Top().window.dialogArguments;
				if(a8Top){
					a8Top.parent.parent.location.href='${mtMeetingURL}?method=summaryToCol&id=${bean.id}';
				}else{
					parentObj.getA8Top().parent.parent.location.href='${mtMeetingURL}?method=summaryToCol&id=${bean.id}';
				}
				parentObj.close();
				window.close();
			}else{
				parent.parent.parent.parent.location.href='${mtMeetingURL}?method=summaryToCol&id=${bean.id}';
			}
		}
	</script>
	<v3x:attachmentDefine attachments="${attachments}" />
</head>
<body class="body-bgcolor" style="overflow: scroll;">
	<v3x:showContent content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" htmlId="col-contentText" />
	
	<%-- 关键点3 ： 分隔线 --%>
	<div class="body-line-sp"></div>
	
	<c:if test="${param.from!='temp'}">
	<table align="center" border="0" cellspacing="0" cellpadding="0" class="body-detail">
		<tr valign="top">
			<td class="body-detail-border" width="100%">
				<div class="body-detail-su" style="padding-left: 15px;">
					<!-- 
					<fmt:message key="mt.mtReply.feedback1">
						<fmt:param value="${replySize}" />
					</fmt:message>
					 -->
					<!-- 审核意见(${replySize}) -->
					审核人意见(${replySize})
					
				</div>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="padding-left: 15px; padding-right: 15px;">
					<c:forEach var="mtReply" items="${replyList}">
						<c:if test="${mtReply.agreeFlag!='0'}">
							<tr><td width="100%" >
								<div class="div-clear" style="width: 100%;">
									<div class="optionWriterName">
										<div class="div-float font-12px" style="padding-left: 20px; padding-bottom: 2px; color: #335186;">
											<span class="cursor-hand" onclick="showV3XMemberCardWithOutButton('${mtReply.userId}')"><b><c:out value="${mtReply.userName}"/></b></span>
											<c:if test="${mtReply.ext1=='1'}">
												<font color="red">
													(<fmt:message key="mt.agent.label1">
													<fmt:param>${mtReply.ext2}</fmt:param>
													</fmt:message>)
												</font>
											</c:if>&nbsp;
											<b>
											<c:if test="${mtReply.agreeFlag == 1}">
												<fmt:message key="mr.label.allowed" bundle="${v3xMtRoom}"/>
											</c:if>
											<c:if test="${mtReply.agreeFlag == 2}">
												<fmt:message key="mr.label.notallowed" bundle="${v3xMtRoom}"/>
											</c:if>
											</b>
											&nbsp;&nbsp;
											<fmt:formatDate value="${mtReply.approveDate}" pattern="${datePattern}"  />
										</div>
										<div class="div-float-right" style="padding-right: 20px;">
											&nbsp;
										</div>
									</div>
									<div class="optionContents" style="padding: 2px 20px 2px 20px;">
										${v3x:toHTML(mtReply.suggestion)}&nbsp;
									</div>
									<div class="div-float attsContent" style="display: none" id="attsDiv${mtReply.id}">
										<div class="atts-label"></div>
										<div class="div-float"><script type="text/javascript">showAttachment('${mtReply.id}', 0, 'attsDiv${mtReply.id}');</script></div>
									</div>
								</div>
							</td></tr>	
						</c:if>
					</c:forEach>
				</table>
			</td>
	  	</tr>
	</table>
	</c:if>
	
	<%-- 关键点5 ： 分隔线 --%>
	<div class="body-line-sp"></div>
	
	
</body>
</html>