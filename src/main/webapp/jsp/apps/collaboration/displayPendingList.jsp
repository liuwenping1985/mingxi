 	<style>
 	.v_align{
 		vertical-align: -1px;
 	}
 	.left{float:left;}
 	.channel_content li .ico16{
 		margin-top:7px;
 	}
 	</style>
 	<script>
	function showMemberCard(obj,_memberID){
        $(obj).PeopleCard({memberId:_memberID});
	}

 	</script>
 	<ul>
	<c:forEach var="row" varStatus="status" items="${rowList1==null ? leftList:rowList1}">
		<li class="${row.receiveTime eq '' ? '':'sectionSubjectIcon_2' } ${status.index%2==1 ne '' ? 'even':''} clear over_hidden" style="display:block;padding-left:7px;vertical-align: bottom;padding:0 0 0 0;">
			<c:forEach items="${columnHeaderList}" var="colHeader">
				<%-- 公文文号(公文字段)--%>
				<c:if test="${colHeader eq 'edocMark'}">
					<span class="left flagClass text_overflow" title="${row.edocMark}" style="padding-left:5px;width:118px;color: #111111">
						${ctp:toHTML(row.edocMark)}&nbsp;
					</span>
				</c:if>
				<%-- 发文单位 (公文字段)--%>
				<c:if test="${colHeader eq 'sendUnit'}">
					<span class="left flagClass text_overflow" title="${row.sendUnit}" style="padding-left:5px;width:105px;color: #111111">
						${row.sendUnit}&nbsp;
					</span>
				</c:if>

				<%-- 会议地点(会议字段) --%>
				<c:if test="${colHeader eq 'placeOfMeeting'}">
					<span class="left flagClass text_overflow" title="${row.placeOfMeeting}" style="padding-left:5px;width:80px;color: #111111">
						${row.placeOfMeeting}&nbsp;
					</span>
				</c:if>
				<%-- 主持人(会议字段) --%>
				<c:if test="${colHeader eq 'theConferenceHost'}">
					<span class="left flagClass hand  text_overflow" id="${row.id}theConferenceHostId" title="${row.theConferenceHost}" style="padding-left:5px;width:54px;color: #111111">
                        <script type="text/javascript">
                   			$("#${row.id}theConferenceHostId").click(function(){
                             	 	$.PeopleCard({memberId:"${row.theConferenceHostId}"});
                            });
                   		</script>
						${row.theConferenceHost}&nbsp;
					</span>
				</c:if>
				<%--已处理人数/总人数(会议、调查字段) --%>
				<c:if test="${colHeader eq 'processingProgress'}">
					<span class="left flagClass text_overflow" style="padding-left:5px;width:42px;">
						<c:if test="${row.applicationCategoryKey eq 6 }">
							<div class="replyCard" id="replyCard${row.objectId }" objectId="${row.objectId }" style="display:inline-block;color: #111111">
								${row.processedNumber}/${row.totalNumber }
							</div>
						</c:if >
						<c:if test="${row.applicationCategoryKey ne 6 }">
							${row.processingProgress}&nbsp;
						</c:if>
					</span>
				</c:if>
				<%-- 节点名称 --%>
				<c:if test="${colHeader eq 'policy'}">
                 	<span class="left flagClass text_overflow pendingNodeName" title="${row.policyName}" style="padding-left:8px;width:45px;color: #111111">
                 		${row.policyName}&nbsp;
                 	</span>
				</c:if>
				<%-- 分类 --%>
				<c:if test="${colHeader eq 'category'}">
					<span class="left flagClass text_overflow" title="${ctp:i18n(row.categoryLabel)}" style="padding-left:5px;width:35px;">
						<c:choose>
							<c:when test="${row.hasResPerm eq true}">
								<a href="javascript:openLink('${row.categoryLink}')">${row.categoryLabel}</a>
							</c:when>
							<c:otherwise>
								${ctp:i18n(row.categoryLabel)}
							</c:otherwise>
						</c:choose>
					</span>
				</c:if>
				<%-- 发起人 --%>
				<c:if test="${colHeader eq 'sendUser'}">
					<span class="left flagClass text_overflow senderflag" style="padding-left:5px;">
						<span class='left hasIconSpan hand text_overflow' style='padding:0px;margin:0;'>
	                       <span class="senderTitle" id="${row.id}senderId" title="${ctp:toHTML(row.createMemberName)}" style="margin:0;">
	                    		<script type="text/javascript">
	                     			$("#${row.id}senderId").click(function(){
	                               	 	$.PeopleCard({memberId:"${row.createMemberId}"});
	                                });
	                    		</script>
	                       	${ctp:toHTML(row.createMemberName)}
                    	 	</span>
	                     </span>
                     	<%-- 加签/会签 图标 --%>
						<c:if test="${row.fromName ne null}">
							<span title="${row.fromName}" class="ico16 v_align signature_16 left" style="margin-left:0;margin-right:0;"></span>
						</c:if>
						<%-- 回退 图标 --%>
						<c:if test="${row.backFromName ne null}">
							<span title="${row.backFromName}" class="ico16 v_align specify_fallback_16 left" style="margin-left:0;margin-right:0;"></span>
						</c:if>
                        <c:if test="${row.meetingImpart ne null}">
                            <span title="${row.meetingImpart}" class="ico16 v_align meeting_inform_16 left" style="margin-left:0;margin-right:0;"></span>
                        </c:if>
                     </span>
				</c:if>
				<%-- 接收时间/召开时间段 --%>
				<c:if test="${colHeader eq 'receiveTime'}">
					<span class="color_gray2 left flagClass text_overflow" title="${row.completeTime}" style="padding-left:5px;width:78px;">
						${row.receiveTime}&nbsp;
					</span>
                </c:if>
                <%-- 处理期限--%>
				<c:if test="${colHeader eq 'deadLine'}">
						<span class="${row.dealTimeout ? 'color_red':'color_gray2' } left flagClass text_overflow" title="${row.dealLineName}" style="padding-left:5px;width:78px;">
							${row.dealLineName}
						</span>

                </c:if>

				<%-- 标题 --%>
				<c:if test="${colHeader eq 'subject'}">
					<span class="channel_title left" style="width:100px; display:inline-block;overflow:hidden;color: #111111">
						<%-- 图标区 --%>
						<%--重要程度  --%>
						<c:if test="${row.importantLevel eq 2 or row.importantLevel eq 3 or row.importantLevel eq 4 or row.importantLevel eq 5}">
							<span class="ico16 margin_l_5 v_align important${row.importantLevel }_16 left" style="margin-right: 0px;"></span>
						</c:if>
						<%-- 标题 --%>
                        <%-- ctp:escapeJavascript :转义\   ;   ctp:toHTML 转义<         %-->
                        <%-- 两个组合转义 ，不要随便去掉一个   ，先进行JS类\转义再TOHTML，否则类似"已经被转成&qoute;了，就不能继续\转义了，JS会报错--%>
                        <%-- 测试字符 1：    '><script>alert(1)</script>='><script>alert(1)</script> --%>
                        <%-- 测试字符 2：远（卡尔蔡司）_OA&nbsp;手动启动jvm.dll加载失败:\users\adjdf\jre\bin\server\jvm.dll--%>
                        <%-- 测试字符3： ”“”“""""""ds"    --%>
						<a id="row${row.id}" class="color_black left hand ${row.subState eq 11 ? 'font_bold':''}" title="${ctp:toHTML(row.subject)}"
							<c:if test="${row.id ne null && row.id ne ''}">
							ondblclick="javascript:return;" onclick='javascript:checkAndOpen("${row.id}","${row.link}","${ctp:toHTML(ctp:escapeJavascript(row.subject))}", "${row.openType }", "${row.applicationCategoryKey }","${row.applicationSubCategoryKey }",this)'
							</c:if>
						> ${ctp:toHTML(row.subject)}&nbsp;</a>
		                <%--附件  --%>
		                <c:if test="${row.hasAttachments eq true }">
		                	<span class='ico16 margin_l_5 v_align affix_16 left'></span>
		                </c:if>
		                <%-- 视频图标 --%>
		                <c:if test="${row.meetingNature eq '2' }">
                        	<span class='ico16 margin_l_5 v_align bodyType_videoConf_16 left'></span>
                        </c:if>
                        <c:if test="${row.applicationCategoryKey != '404'and row.applicationCategoryKey != '401' and row.applicationCategoryKey != '402' and row.applicationCategoryKey != '403' }">
                        	 <%--正文类型  --%>
			                <c:if test="${row.bodyType ne '' and row.bodyType ne null and row.bodyType ne '10' and row.bodyType ne '30' and row.bodyType ne 'HTML'}">
	                         	<c:set value="${row.bodyType }" var="bodyType"/>
	                            <c:if test="${row.bodyType eq 'OfficeWord'}">
	                                <c:set value="41" var="bodyType"/>
	                            </c:if>
	                            <c:if test="${row.bodyType eq 'OfficeExcel'}">
	                                <c:set value="42" var="bodyType"/>
	                            </c:if>
	                            <c:if test="${row.bodyType eq 'WpsWord'}">
	                                <c:set value="43" var="bodyType"/>
	                            </c:if>
	                            <c:if test="${row.bodyType eq 'WpsExcel'}">
	                                <c:set value="44" var="bodyType"/>
	                            </c:if>
	                            <c:if test="${row.bodyType eq 'Pdf'}">
	                                <c:set value="45" var="bodyType"/>
	                            </c:if>
	                            <c:set value="office${bodyType}_16" var="bodyTypeClass"/>
	                            <%-- 视频图标 5.0以前老数据 --%>
	                            <c:if test="${row.bodyType eq 'videoConf' }">
	                            	<c:set value="meeting_video_16" var="bodyTypeClass"/>
	                            </c:if>
	                            <c:if test="${row.bodyType eq 'gd' }">
	                            	<c:set value="scholarDocumentExchange_16" var="bodyTypeClass"/>
	                            </c:if>
			                  	<span class='ico16 margin_l_5 v_align ${bodyTypeClass } left'></span>
			                </c:if>
                        </c:if>
		                

		                <%-- 图标区（节点期限图标） --%>
		                <c:if test="${row.showClockIcon eq true }">
		                	<c:if test="${row.dealTimeout eq false }">
			                	<span title="${row.deadLine}" class="ico16 margin_l_5 v_align extended_blue_16 left"></span> <%-- 节点期限 --%>
		                	</c:if>
		                	<c:if test="${row.dealTimeout eq true }">
			                	<span title="${row.deadLine}" class="ico16 margin_l_5 v_align extended_red_16 left"></span> <%-- 节点期限 --%>
		                	</c:if>
		                </c:if>
					</span>
				</c:if>
			</c:forEach>
		</li>
	</c:forEach>
	</ul>
