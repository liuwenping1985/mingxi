 	<style>
 	.v_align{
 		vertical-align: -1px;
 	}
 	.left{float:left;}
 	</style>
 	<ul>
	<c:forEach var="projectAffair" varStatus="status" items="${rightAffairList}">
		<c:choose> 
			<c:when test="${status.count%2==0}">
				<li name="liColumn" class="even" style="display:inline;display:block;height:25px;line-height:24px;padding-left:7px;vertical-align: bottom;padding:0 0 0 0;">
			</c:when>
			<c:otherwise>
				<li name="liColumn" style="display:inline;display:block;height:25px;line-height:24px;padding-left:7px;vertical-align: bottom;padding:0 0 0 0;">
			</c:otherwise>
		</c:choose>
			<!--标题-->
			<c:if test="${projectAffair.subject ne null}">
				<span name="subject" class="channel_title left" style="display:inline-block;height:25px;overflow:hidden;color: #111111">
						<%--流程结束--%>
						<c:if test="${projectAffair.processOver eq 3 }">
							<span class="ico16 margin_l_5 v_align flow3_16 left" style="margin-right: 0px;"></span>
						</c:if>
						<c:if test="${projectAffair.processStop eq true}">
							<span class="ico16 margin_l_5 v_align flow1_16 left" style="margin-right: 0px;"></span>
						</c:if>
						<%--重要程度  --%>
						<c:if test="${projectAffair.importantLevel eq 2 or projectAffair.importantLevel eq 3 or projectAffair.importantLevel eq 4 or projectAffair.importantLevel eq 5}">
							<span class="ico16 margin_l_5 v_align important${projectAffair.importantLevel }_16 left" style="margin-right: 0px;"></span>
						</c:if>
						<%-- 标题 --%>
						<a name="subjectTitle" class="color_black left hand" title="${ctp:toHTML(projectAffair.subject)}"
							ondblclick="javascript:return;" onclick='javascript:checkAndOpen("${projectAffair.id}","${projectAffair.link}","${ctp:toHTML(ctp:escapeJavascript(projectAffair.subject))}", "", "1","",this)'> ${ctp:toHTML(projectAffair.subject)} </a>
		                <%--附件  --%>
		                <c:if test="${projectAffair.hasAttachments eq true }">
		                	<span class='ico16 margin_l_5 v_align affix_16 left'></span>
		                </c:if>
		                <%-- 视频图标 --%>
		                <c:if test="${projectAffair.meetingNature eq '2' }">
                        	<span class='ico16 margin_l_5 v_align bodyType_videoConf_16 left'></span>
                        </c:if>
		                 <%--正文类型  --%>
		                <c:if test="${projectAffair.bodyType ne '' and projectAffair.bodyType ne null and projectAffair.bodyType ne '10' and projectAffair.bodyType ne '30' and projectAffair.bodyType ne 'HTML'}">
                         	<c:set value="${projectAffair.bodyType }" var="bodyType"/>
                            <c:if test="${projectAffair.bodyType eq 'OfficeWord'}">
                                <c:set value="41" var="bodyType"/>
                            </c:if>
                            <c:if test="${projectAffair.bodyType eq 'OfficeExcel'}">
                                <c:set value="42" var="bodyType"/>
                            </c:if>
                            <c:if test="${projectAffair.bodyType eq 'WpsWord'}">
                                <c:set value="43" var="bodyType"/>
                            </c:if>
                            <c:if test="${projectAffair.bodyType eq 'WpsExcel'}">
                                <c:set value="44" var="bodyType"/>
                            </c:if>
                            <c:if test="${projectAffair.bodyType eq 'Pdf'}">
                                <c:set value="45" var="bodyType"/>
                            </c:if>
                            <c:set value="office${bodyType}_16" var="bodyTypeClass"/>
                            <%-- 视频图标 5.0以前老数据 --%>
                            <c:if test="${projectAffair.bodyType eq 'videoConf' }">
                            	<c:set value="meeting_video_16" var="bodyTypeClass"/>
                            </c:if>
		                  	<span class='ico16 margin_l_5 v_align ${bodyTypeClass } left'></span>
		                </c:if>
						
		                <%-- 图标区（节点期限图标） --%>
		                <c:if test="${projectAffair.showClockIcon eq true }">
		                	<c:if test="${projectAffair.overTime eq false }">
			                	<span title="${projectAffair.deadLine}" class="ico16 margin_l_5 v_align extended_blue_16 left"></span> <%-- 节点期限 --%>
		                	</c:if>
		                	<c:if test="${projectAffair.overTime eq true }">
			                	<span title="${projectAffair.deadLine}" class="ico16 margin_l_5 v_align extended_red_16 left"></span> <%-- 节点期限 --%>
		                	</c:if>
		                </c:if>
					</span>
			</c:if>
			<c:if test="${projectAffair.createDate ne null}">
				<span name="createDate" class="left flagClass text_overflow" title="${projectAffair.createDate}" style="padding-left:5px;color: #111111">
					${projectAffair.createDate}
				</span>
			</c:if>
			<c:if test="${projectAffair.senderId ne null}">
				<span name="senderId" class="left flagClass text_overflow" title="${ctp:showMemberNameOnly(projectAffair.senderId)}" style="padding-left:5px;color: #111111">
					<a onclick="displayMemberInfo(this)" value="${projectAffair.senderId}">${ctp:showMemberNameOnly(projectAffair.senderId)}</a>
				</span>
			</c:if>
			<c:if test="${projectAffair.state ne null}">
				<span name="state" class="left flagClass text_overflow" title="${projectAffair.stateStr}" style="padding-left:5px;color: #111111">
					<a onclick="displayCollaboration(${projectAffair.state})">${projectAffair.stateStr}</a>
				</span>
			</c:if>
			<c:if test="${projectAffair.canForward eq true}">
				<span name="canForward" class="left flagClass text_overflow" title="[${ctp:i18n("project.collaboration.show.forward")}]" style="padding-left:5px;color: #111111">
					<a onclick="transmitColById(this)" value="${projectAffair.colSummaryId}_${projectAffair.id}">[${ctp:i18n("project.collaboration.show.forward")}]</a>
				</span>
			</c:if>
		</li>
	</c:forEach>
	</ul>
