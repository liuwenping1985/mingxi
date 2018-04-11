<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ include file="inquiryHeader.jsp" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>${ctp:i18n('inquiry.info.title')}--${inquiryInfo.inquiryName}</title><%--i18 调查详请 --%>
    <link rel="stylesheet" type="text/css" href="${path}/skin/default/inquiry.css${v3x:resSuffix()}" />
    <link rel="stylesheet" type="text/css" href="${path}/apps_res/inquiry/css/result.css${v3x:resSuffix()}"/>
    <link rel="stylesheet" type="text/css" href="${path}/apps_res/inquiry/css/question.css${v3x:resSuffix()}"/>
    <link rel="stylesheet" type="text/css" href="${path}/apps_res/inquiry/css/mine.css${v3x:resSuffix()}" />
    <link rel="stylesheet" href="${path}/common/image/css/touchTouch.css${v3x:resSuffix()}">
    <script type="text/javascript" src="${path}/common/image/jquery.touchTouch-debug.js${v3x:resSuffix()}"></script>
    <script src="${path}/apps_res/inquiry/js/common.js${v3x:resSuffix()}"></script>
    <script src="${path}/apps_res/inquiry/js/question.js${v3x:resSuffix()}"></script>
    <script type="text/javascript">
        var _path = '${path}';
        var ajax_inquiryManager = new inquiryManager();
        //返回首页（集团和单位空间下的处于发布状态下的调查）
        function toIndex(){
            if(('${inquiryInfo.inquirySpaceType}' =='2' || '${inquiryInfo.inquirySpaceType}' =='3') && ('${inquiryInfo.surveyState}'=='5' || '${inquiryInfo.surveyState}'=='8')){
                var url = '${path}/inquiryData.do?method=inquiryIndex';
                window.location.href = url;
            }
        }
    </script>
    <v3x:attachmentDefine attachments="${attachments}" />
</head>
<body onunload="unlock('${inquiryInfo.inquiryId}',false);">
<input type="hidden" name="inquiryId" id="inquiryId" value="${inquiryInfo.inquiryId}">
<input type="hidden" name="inquiryBoardId" id="inquiryBoardId" value="${inquiryInfo.inquiryBoardId}">
<input type="hidden" name="infoMode" id="infoMode" value="${infoMode}">
<input type="hidden" name="memberId" id="memberId" value="${memberId}">
<input type="hidden" name="packageStr" id="packageStr" value="${packageStr}">
<input type="hidden" name="questionStr" id="questionStr" value="${questionStr}">
<input type="hidden" name="metaData" id="metaData" value="${metaData}">
<input type="hidden" name="isAuth" id="isAuth" value="${isAuth}">
<input type="hidden" name="isManager" id="isManager" value="${isManager}">
<input type="hidden" name="isSender" id="isSender" value="${isSender}">
<input type="hidden" name="isInScope" id="isInScope" value="${isInScope}">
<input type="hidden" name="surveyState" id="surveyState" value="${inquiryInfo.surveyState}">
<input type="hidden" name="inquiryAttListJSON" id="inquiryAttListJSON" value="${inquiryAttListJSON}">

<div class="container">
    <div class="content_container">
        <div class="container_top">
            <div class="container_top_area">
            <span class="index_logo" style="padding-left: 10px;cursor: pointer;" onclick="toIndex();" <c:if test="${(inquiryInfo.inquirySpaceType == 2 ||inquiryInfo.inquirySpaceType == 3)&&(inquiryInfo.surveyState == 5 || inquiryInfo.surveyState ==8)}"> title="${ctp:i18n('inquiry.backtoindex')}" </c:if>><%--i18 返回首页 --%>
                <img src="${path}/skin/default/images/cultural/inquiry/inquiry_logo.png" width="40" height="40">
                <span class="index_logo_name hand">${ctp:i18n('inquiry.inquiry')}</span><%--i18 调查 --%>
            </span>
            </div>
        </div>
        <div class="container_auto auto_1280">
            <div class="msg_check" style="display: none">
                <div class="msg_check_textarea" style="display: none;">
                    <textarea class="check_textarea"
                    style="color:#999;"
                    onfocus="if(this.value == '${ctp:i18n("inquiry.info.authlimit")}') {this.style.color = '#333';this.value = '';}"
                    onblur="if(this.value =='') {this.style.color = '#999';this.value = '${ctp:i18n("inquiry.info.authlimit")}';}">${ctp:i18n('inquiry.info.authlimit')}</textarea><%--审核意见，150字以内--%>
                    <span class="msg_button">
                        <a href="javascript:;" class="buttonNew check_button margin_b_10" onclick="authInquiry(2)">${ctp:i18n('inquiry.info.authbutton1')}</a><%--通过并发布--%>
                        <a href="javascript:;" class="buttonNew pass_button" onclick="authInquiry(0)">${ctp:i18n('inquiry.info.authbutton2')}</a><%--通&nbsp;&nbsp;&nbsp;过--%>
                        <a href="javascript:;" class="buttonNew no_pass_button" onclick="authInquiry(1)">${ctp:i18n('inquiry.info.authbutton3')}</a><%--不&nbsp;&nbsp;通&nbsp;&nbsp;过--%>
                    </span>
                </div>
                <c:if test="${infoMode!='pass'}">
                <div class="msg_check_noPass" style="display: none;">
                    <p><span class="no_pass_left" title="${v3x:showMemberName(inquiryInfo.inquiryAuthId)}">${v3x:getLimitLengthString(v3x:showMemberName(inquiryInfo.inquiryAuthId),9,"...")}${ctp:i18n('inquiry.info.someoneauthmind')}：</span><span class="pass_state no_pass">${ctp:i18n('inquiry.info.auth.nopass')}</span></p><%--的审核意见--%>
                    <div class="no_pass_info">
                        <span class="no_pass_left">${ctp:i18n('inquiry.info.auth.mind')}：</span><%--附言--%>
                        <c:if test="${!(authMind==null||authMind=='')}">
                            <div class="no_msg">${ctp:toHTML(authMind)}</div>
                        </c:if>
                        <c:if test="${authMind==null||authMind==''}">
                            <div class="no_msg">${ctp:i18n('inquiry.info.auth.mindnone')}</div><%--无--%>
                        </c:if>
                    </div>
                </div>
                </c:if>
                <c:if test="${infoMode=='pass'}">
                <div class="msg_check_pass" style="display: none;">
                    <div class="check_textarea">
                        <p><span class="no_pass_left" title="${v3x:showMemberName(inquiryInfo.inquiryAuthId)}">${v3x:getLimitLengthString(v3x:showMemberName(inquiryInfo.inquiryAuthId),9,"...")}${ctp:i18n('inquiry.info.someoneauthmind')}：</span><span class="pass_state ready_pass">${ctp:i18n('inquiry.info.auth.pass')}</span></p><%--的审核意见--%>
                        <div class="no_pass_info">
                            <span class="no_pass_left">${ctp:i18n('inquiry.info.auth.mind')}：</span><%--附言--%>
                            <c:if test="${!(authMind==null||authMind=='')}">
                                <div class="no_msg">${ctp:toHTML(authMind)}</div>
                            </c:if>
                            <c:if test="${authMind==null||authMind==''}">
                                <div class="no_msg">${ctp:i18n('inquiry.info.auth.mindnone')}</div><%--无--%>
                            </c:if>
                        </div>
                    </div>
                    <span class="msg_button">
                        <a href="javascript:;" class="buttonNew check_button margin_b_10" onclick="publishInquiry()">${ctp:i18n('inquiry.info.authbutton4')}</a><%--发布--%>
                    </span>
                </div>
                </c:if>
            </div>
            <div class="container_result_header">
                <div class="container_top">
							<span class="container_top_left">
								<span class="user_photo">
									<img class="radius" src="${senderInfo.senderImgUrl}"
                                         onclick="showMemberCard('${senderInfo.senderId}')"/>
								</span>
								<span class="user_name"
                                      title="${senderInfo.senderName}">${ctp:toHTML(v3x:getLimitLengthString(senderInfo.senderName,11,"..."))}</span>
							</span>
							<span class="container_top_right">
								<ul class="result_ul">
                                    <li class="result_li">
                                        <span class="margin_r_40"
                                              title="${inquiryInfo.startDeptName}">${ctp:i18n('inquiry.meta.startdept')}： ${ctp:toHTML(v3x:getLimitLengthString(inquiryInfo.startDeptName,21,"..."))}</span><%--发起部门--%>
                                        <span class="margin_r_40"
                                              title="${inquiryInfo.inquiryBoardName}">${ctp:i18n('inquiry.meta.inquirytype')}： ${ctp:toHTML(inquiryInfo.inquiryBoardName)}</span><%--调查版块--%>
                                        <c:if test="${not empty inquiryInfo.inquiryAuthId && inquiryInfo.inquiryAuthId != '0' }">
                                            <span class="margin_r_40" title="${v3x:showMemberName(inquiryInfo.inquiryAuthId)}">${ctp:i18n('inquiry.auditor')}：${v3x:getLimitLengthString(v3x:showMemberName(inquiryInfo.inquiryAuthId),15,"...")}</span><%--审核员--%>
                                        </c:if>
                                        <span class="margin_r_40">${ctp:i18n('inquiry.meta.timelimit')}：${v3x:getLimitLengthString(inquiryInfo.inquirySendDate,16,"")} — <c:if test="${empty inquiryInfo.inquiryEndDate}">${ctp:i18n('inquiry.meta.timelimitnone')}</c:if><c:if test="${not empty inquiryInfo.inquiryEndDate}">${v3x:getLimitLengthString(inquiryInfo.inquiryEndDate,16,"")}</c:if></span><%--调查期限--%>
                                    </li>
                                    <li class="result_li">
                                        <span title="${inquiryInfo.inquiryScopeName}">${ctp:i18n('inquiry.meta.scope')}： ${ctp:toHTML(inquiryInfo.inquiryScopeNameLimit)}</span><%--发布范围--%>
                                    </li>

                                    <li class="result_li">
										<span>
											${ctp:i18n('inquiry.meta.votetype')}：<%--投票方式--%>
											<input id="inquiryVoteType1" type="radio" name="inquiryVoteType" class="radio" disabled>
											${ctp:i18n('inquiry.meta.votetype1')}<%--实名--%>
											<input id="inquiryVoteType2" type="radio" name="inquiryVoteType" class="radio margin_l_30" disabled>
											${ctp:i18n('inquiry.meta.votetype2')}<%--匿名--%>
										</span>
										<span>
											<input id="inquiryVoteBackDoor" type="checkbox" class="margin_l_10 checkbox" disabled>
											${ctp:i18n('inquiry.meta.backdoor')}<%--发起人/版块管理员可查看已投票和未投票人--%>
										</span>

                                    </li>
                                    <li class="result_li last_li">
										<span class="margin_r_20 hidden">
											<input type="checkbox" class="checkbox" disabled>
											允许参与人查看评论内容
										</span>
										<span class="margin_r_20">
											<input id="inquiryResultBeforeJoin" type="checkbox" class="checkbox" disabled>
											${ctp:i18n('inquiry.allowviewresultahead.label')}
										</span>
										<span class="margin_r_20">
											<input id="inquiryResultAfterEnd" type="checkbox" class="checkbox" disabled>
											${ctp:i18n('inquiry.allowviewresult.label')}
										</span>
										<span class="margin_r_20 hidden">
											<input type="checkbox" class="checkbox" disabled>
											调查结束后推送调查结果
										</span>
                                    </li>
                                </ul>
							</span>
                    <%--<img src="../css/images/code.jpg" width="130" height="130" class="code_right" style="display: none">--%>
                </div>

            </div>
            <div class="container_result_body">
                <div class="question_info">
                    <div class="question_header">
                        <h3 class="qusetion_title">${ctp:toHTML(inquiryInfo.inquiryName)}</h3>
                        <img src="" class="header_photo" style="display: none">
                        <div class="question_title_msg margin_b_10" readonly style="overflow:hidden;font-size: 16px;color: #333;display: inline-block;word-break: break-all;width: 100%;resize: none;background-color: white;border-color: white;min-height: 26px"></div>
                        <input id="inquiryAfter" type="hidden" value=""/>
                        <ul class="fileUpload_ul margin_b_10">
                            <c:if test="${hasAtts}">
                                <li id="fileArea" class="fileUpload_ul_li" >
                                    <div id="attachmentTRInquiryFile" class="attachmentDiv">
                                        <div class="attch_flag left">
                                        <span class="">
                                            <em class="icon16 file_attachment_16 margin_b_5"></em>
                                            <span class="insert_file" >${ctp:i18n('common.attachment.label')}</span>
                                        </span>
                                            <span id="attachmentTRatts1" >&nbsp;&nbsp;(<span id="attachmentNumberDivInquiryFile"></span>)&nbsp;&nbsp;</span>
                                        </div>
                                        <div id="attFile" isGrid="true" class="comp" comp="type:'fileupload',attachmentTrId:'InquiryFile',canFavourite:false,applicationCategory:'10',canDeleteOriginalAtts:false" attsdata='${inquiryAttListJSON}'></div>
                                        <div id="attachmentAreaInquiryFile" class="attachment_area left"></div>
                                    </div>
                                </li>
                            </c:if>
                            <c:if test="${hasDoc}">
                                <li id="docArea" class="fileUpload_ul_li">
                                    <div id="attachment2TRInquiryFile" class="attachmentDiv">
                                        <div class="attch_flag left">
                                        <span class="">
                                            <em class="ico16 associated_document_16 margin_b_5"></em>
                                            <span class="insert_file" >${ctp:i18n('common.mydocument.label')}</span>
                                        </span>
                                            <span id="attachment2TRInquiryDoc" >&nbsp;&nbsp;(<span id="attachment2NumberDivInquiryDoc"></span>)&nbsp;&nbsp;</span>
                                        </div>
                                        <div id="docFile" isGrid="true" class="comp" comp="type:'assdoc',attachmentTrId:'InquiryDoc',canFavourite:false,applicationCategory:'10',canDeleteOriginalAtts:false" attsdata='${inquiryAttListJSON}'></div>
                                    </div>
                                </li>
                            </c:if>
                        </ul>
                    </div>
                    <div class="question_infos">
                        <div class="question_button" style="display: none">
                            <c:if test="${param.openFrom != 'ucpc'}">
                                <a class="buttonNew reopen_button" href="javascript:;" onclick="reopenInquiry();" style="display: none">${ctp:i18n('inquiry.info.button1')}</a><%--开启调查--%>
                            </c:if>
                            <a class="buttonNew submit_button" href="javascript:;" onclick="voteInquiry();" style="display: none">${ctp:i18n('inquiry.info.button2')}</a><%--提     交--%>
                            <c:if test="${param.openFrom != 'ucpc'}">
                                <a class="buttonNew viewResult_button" href="javascript:;" onclick="viewResult();" style="display: none">${ctp:i18n('inquiry.info.button3')}</a><%--查看结果--%>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="to_top" id="back_to_top">
    <span class="scroll_bg">
        <em class="icon24 to_top_24 margin_t_5"></em>
        <span class="back_top_msg hidden">${ctp:i18n('inquiry.gototop')}</span><%--返回顶部--%>
    </span>
</div>
</body>
</html>