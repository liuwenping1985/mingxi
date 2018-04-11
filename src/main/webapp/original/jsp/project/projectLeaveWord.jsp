<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<div class="portal-layout-cell_head">
<div class="portal-layout-cell_head_l"></div>
<div class="portal-layout-cell_head_r"></div>
</div>
<table border="0" cellSpacing="0" cellPadding="0" width="100%"  class="portal-layout-cell-right">
	<tbody>
		<tr>
			<td class="sectionTitleLine sectionTitleLineBackground">
				<div class=sectionSingleTitleLine>
					<div class=sectionTitleLeft></div>
					<div class=sectionTitleMiddel>
					<div class=sectionTitlediv>
						<SPAN class=sectionTitle>
							<fmt:message key="project.info.myLeaveWord" />
						</SPAN>
					</div>
					</div>
					<div style="FLOAT: right" class=sectionTitleRight></div>
				</div>
			</td>
		</tr>
		<tr>
			<td class="sectionBody sectionBodyBorder messageReplyDiv" height="205" style="position: relative;background-color:rgb(255, 255, 255)">
					<input id="hiddenArguments1" name="hiddenArguments1" type="hidden" value="${projectCompose.projectSummary.phaseId}"/>
                    <input id="hiddenArguments2" name="hiddenArguments2" type="hidden" value="${empty param.phaseId ? 1 : param.phaseId}"/>
					<input id="messageReplyDivHidden${flagStr}" name="messageReplyDivHidden" type="hidden" value="${projectCompose.projectSummary.id}"/>
					<div id="${flagStr}" class="leaveMessageContainer default" style="height: 205px;">
					
						<c:forEach items="${leaveList}" var="leaveWords">
							<c:choose>
								<c:when test="${leaveWords.leaveWord.indexShow == 0}">
									<c:set value="messageDivFirst" var="messageDivClass" />
								</c:when>
								<c:when test="${leaveWords.leaveWord.indexShow == 1 || leaveWords.leaveWord.indexShow == 2 || leaveWords.leaveWord.indexShow == 3 || leaveWords.leaveWord.indexShow == 4}">
									<c:set value="messageDiv" var="messageDivClass" />
								</c:when>
								<c:otherwise>
									<c:set value="messageDivHidden" var="messageDivClass" />
								</c:otherwise>
							</c:choose>
							
							<div class="${messageDivClass}">
								<table cellpadding="0" cellspacing="0" width="100%" style="table-layout:fixed">
									<tr>
									
										<td class="phtoImgTD">
										
											<div class="phtoImg"><img class="radius" src="${leaveWords.leaveWord.urlImage}" width="40" height="40"/></div>
										</td>
										<td>
											<div class="messageContent">
												<span class="peopleName">
													${v3x:showMemberName(leaveWords.leaveWord.creatorId)}
													<c:if test="${leaveWords.leaveWord.replyerId != null && leaveWords.leaveWord.replyerId != leaveWords.leaveWord.creatorId}">
														<span class="replySay"><fmt:message key="guestbook.leaveword.reply" bundle='${v3xMainI18N}' />:</span>
														${v3x:showMemberName(leaveWords.leaveWord.replyerId)}
													</c:if>
												</span>
												<span class="peopleSay"><fmt:message key="guestbook.leaveword.speak" bundle='${v3xMainI18N}' />:</span>
												<span class="peopleMessage clearfix">${leaveWords.leaveWord.content}</span>
											</div>
											<div class="messageTime">
												<c:choose>
													<c:when test="${leaveWords.leaveWord.replyId != null}">
														<span class="reply">
															<a href="javascript:replyMessage('${leaveWords.leaveWord.replyId}', '${leaveWords.leaveWord.departmentId}', '${leaveWords.leaveWord.creatorId}', '${leaveWords.leaveWord.idflag}')">
																<fmt:message key="guestbook.leaveword.reply" bundle='${v3xMainI18N}' />
															</a>
														</span>
													</c:when>
													<c:otherwise>
														<span class="reply">
															<a href="javascript:replyMessage('${leaveWords.leaveWord.id}', '${leaveWords.leaveWord.departmentId}', '${leaveWords.leaveWord.creatorId}', '${leaveWords.leaveWord.idflag}')">
																<fmt:message key="guestbook.leaveword.reply" bundle='${v3xMainI18N}' />
															</a>
														</span>
													</c:otherwise>
												</c:choose>
												<span class="meaageTime"><fmt:formatDate value="${leaveWords.leaveWord.createTime}" pattern="MM-dd HH:mm" /></span>
											</div>
										</td>
									</tr>
								</table>
							</div>
							
							<c:if test="${leaveWords.hasNodes}">
							     <c:forEach items="${leaveWords.subLeaveWord}" var="suble">
							         <c:choose>
                                <c:when test="${suble.indexShow == 0}">
                                    <c:set value="messageDivFirst" var="messageDivClass" />
                                </c:when>
                                <c:when test="${suble.indexShow == 1 || suble.indexShow == 2 || suble.indexShow == 3 || suble.indexShow == 4}">
                                    <c:set value="messageDiv" var="messageDivClass" />
                                </c:when>
                                <c:otherwise>
                                    <c:set value="messageDivHidden" var="messageDivClass" />
                                </c:otherwise>
                            </c:choose>
                            <div class="${messageDivClass}">
                                <table cellpadding="0" cellspacing="0" width="100%" style="table-layout:fixed">
                                    <tr>
                                        <td width="40"></td>
                                        <td class="phtoImgTD" height="40" >
                                        
                                            <div class="phtoImg"><img class="radius" src="${suble.urlImage}" width="40" height="40"/></div>
                                        </td>
                                        <td>
                                            <div class="messageContent">
                                                <span class="peopleName">
                                                    ${v3x:showMemberName(suble.creatorId)}
                                                    <c:if test="${suble.replyerId != null && suble.replyerId != suble.creatorId}">
                                                        <span class="replySay"><fmt:message key="guestbook.leaveword.reply" bundle='${v3xMainI18N}' />:</span>
                                                        ${v3x:showMemberName(suble.replyerId)}
                                                    </c:if>
                                                </span>
                                                <span class="peopleSay"><fmt:message key="guestbook.leaveword.speak" bundle='${v3xMainI18N}' />:</span>
                                                <span class="peopleMessage clearfix">${suble.content}</span>
                                            </div>
                                            <div class="messageTime">
                                                <c:choose>
                                                    <c:when test="${suble.replyId != null}">
                                                        <span class="reply">
                                                          
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="reply">
                                                      
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                                <span class="meaageTime"><fmt:formatDate value="${suble.createTime}" pattern="MM-dd HH:mm" /></span>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
							     </c:forEach>
							</c:if>
						</c:forEach>
						
						
					<div class="replyDivHidden" id="replyDiv${flagStr}"  onkeydown="sendMessageOnKey()" style="float:right;position:fixed;bottom:20px;right:20px;z-index:10;"></div>
				
					</div>
					
				</td>
		</tr>
		<tr>
			<td>
				<div class="align_right">
					[&nbsp;<a href="javascript:showLeaveWordDiv('${flagStr}', '${projectCompose.projectSummary.id}')"><fmt:message key="project.info.sendLeaveWord" /></a>&nbsp;]
					[&nbsp;<a href="<html:link renderURL='/guestbook.do' />?method=moreLeaveWordNew&project=true&hasAuthForNew=${hasAuthForNew }&departmentId=${projectCompose.projectSummary.id}&phaseId=${phaseId}&managerFlag=${managerFlag}"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>&nbsp;]
				</div>
			</td>
		</tr>
	</tbody>
</table>
<div class="portal-layout-cell_footer">
	<div class="portal-layout-cell_footer_l"></div>
	<div class="portal-layout-cell_footer_r"></div>
</div>
<script>
initDiv("${flagStr}")
function sendMessageOnKey(){
	if(event.ctrlKey){
		if(event.keyCode==13){
			sendMessage('${projectCompose.projectSummary.id}','','','${flagStr}')
		}
	}

}
</script>