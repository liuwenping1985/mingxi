<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="inquiryHeader.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/report/chart/chart_common.jsp"%>
<html>
<head>
    <meta charset="UTF-8">
    <title>${ctp:i18n('inquiry.result.inquiryresult')}</title><%--i18 调查首页 --%>
    <link rel="stylesheet" type="text/css" href="${path}/skin/default/inquiry.css${v3x:resSuffix()}" />
    <link rel="stylesheet" type="text/css" href="${path}/apps_res/inquiry/css/result.css${v3x:resSuffix()}"/>
    <script src="${path}/apps_res/inquiry/js/common.js${v3x:resSuffix()}"></script>
    <script src="${path}/apps_res/inquiry/js/result.js${v3x:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/apps_res/collaboration/js/CollaborationApi.js${v3x:resSuffix()}"></script>
    <script type="text/javascript">
        var _path = '${path}';
        var ajax_inquiryManager = new inquiryManager();
        var secretFlag = ${inquiry.inquirySurveybasic.cryptonym == 0 && isSenderOrAdmin};
        <%--var seeResultInfo = ${(inquiry.inquirySurveybasic.cryptonym == 1 && inquiry.inquirySurveybasic.showVoters&&isSenderOrAdmin)||(inquiry.inquirySurveybasic.cryptonym == 0)}--%>
    </script>
</head>
<body>
<input type="hidden" name="inquiryId" id="inquiryId" value="${inquiryInfo.inquiryId}">
<input type="hidden" name="inquiryName" id="inquiryName" value="${ctp:toHTML(inquiryInfo.inquiryName)}">
<input type="hidden" name="infoMode" id="infoMode" value="${infoMode}">

<input type="hidden" name="inquiryVoteNum" id="inquiryVoteNum" value="${inquiry.inquirySurveybasic.voteCount}">
<input type="hidden" name="inquiryTotalNum" id="inquiryTotalNum" value="${inquiry.inquirySurveybasic.totals}">

<input type="hidden" name="packageStr" id="packageStr" value="${ctp:toHTML(packageStr)}">
<input type="hidden" name="questionStr" id="questionStr" value="${ctp:toHTML(questionStr)}">
<input type="hidden" name="metaData" id="metaData" value="${ctp:toHTML(metaData)}">
<!-- 导出Excel表格所用 -->
<iframe name="saveAsExcelFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0" style="display: none"></iframe>
<div class="container">
    <div class="container_top">
        <div class="container_top_area">
            <span class="index_logo" style="padding-left: 10px;">
                <img src="${path}/skin/default/images/cultural/inquiry/inquiry_logo.png" width="40" height="40">
                <span class="index_logo_name">${ctp:i18n('inquiry.inquiry')}</span><%--i18 调查 --%>
            </span>
        </div>
    </div>
    <div class="content_container">
        <div class="container_auto auto_1280">
            <div class="container_result_header">
                <div class="container_top">
							<span class="container_top_left">
								<span class="user_photo">
									<img class="radius" src="${senderInfo.senderImgUrl}"
                                         onclick="showMemberCard('${senderInfo.senderId}')"/>
								</span>
								<span class="user_name"
                                      title="${senderInfo.senderName}">${ctp:toHTML(v3x:getLimitLengthString(senderInfo.senderName,10,"..."))}</span>
							</span>
							<span class="container_top_right">
								<ul class="result_ul">
                                    <li class="result_li">
                                        <span class="margin_r_40"
                                              title="${inquiryInfo.startDeptName}">${ctp:i18n('inquiry.meta.startdept')}： ${ctp:toHTML(v3x:getLimitLengthString(inquiryInfo.startDeptName,10,"..."))}</span><%--发起部门--%>
                                        <span class="margin_r_40"
                                              title="${inquiryInfo.inquiryBoardName}">${ctp:i18n('inquiry.meta.inquirytype')}： ${ctp:toHTML(inquiryInfo.inquiryBoardName)}</span><%--调查版块--%>
                                         <c:if test="${not empty inquiryInfo.inquiryAuthId && inquiryInfo.inquiryAuthId != '0' }">
                                             <span class="margin_r_40">${ctp:i18n('inquiry.auditor')}：${v3x:showMemberNameOnly(inquiryInfo.inquiryAuthId)}</span><%--审核员--%>
                                         </c:if>
                                        <span class="margin_r_40">${ctp:i18n('inquiry.meta.timelimit')}：${v3x:getLimitLengthString(inquiryInfo.inquirySendDate,16,"")} — <c:if test="${empty inquiryInfo.inquiryEndDate}">${ctp:i18n('inquiry.meta.timelimitnone')}</c:if><c:if test="${not empty inquiryInfo.inquiryEndDate}">${v3x:getLimitLengthString(inquiryInfo.inquiryEndDate,16,"")}</c:if></span><%--调查期限--%>
                                    </li>
                                    <li class="result_li">
                                        <span title="${inquiryInfo.inquiryScopeName}">${ctp:i18n('inquiry.meta.scope')}： ${ctp:toHTML(v3x:getLimitLengthString(inquiryInfo.inquiryScopeName,121,"..."))}</span><%--审核员--%>
                                    </li>
                                    <li class="result_li">
										<span>
											${ctp:i18n('inquiry.meta.votetype')}：<%--投票方式：--%>
                                            <c:if test="${inquiry.inquirySurveybasic.cryptonym == 0 }">
                                                <input id="inquiryVoteType1" type="radio" name="inquiryVoteType" class="radio" disabled checked>
                                            </c:if>
                                            <c:if test="${inquiry.inquirySurveybasic.cryptonym == 1 }">
                                                <input id="inquiryVoteType1" type="radio" name="inquiryVoteType" class="radio" disabled >
                                            </c:if>
											${ctp:i18n('inquiry.meta.votetype1')}<%--实名--%>
                                            <c:if test="${inquiry.inquirySurveybasic.cryptonym == 1 }">
											<input id="inquiryVoteType2" type="radio" name="inquiryVoteType" class="radio margin_l_30" disabled checked>
                                            </c:if>
                                            <c:if test="${inquiry.inquirySurveybasic.cryptonym == 0 }">
											<input id="inquiryVoteType2" type="radio" name="inquiryVoteType" class="radio margin_l_30" disabled>
                                            </c:if>
											${ctp:i18n('inquiry.meta.votetype2')}<%--匿名--%>
										</span>
										<span>
                                            <c:if test="${inquiry.inquirySurveybasic.cryptonym == 1 && inquiry.inquirySurveybasic.showVoters}">
											<input id="inquiryVoteBackDoor" type="checkbox" class="margin_l_10 checkbox" disabled checked>
                                                ${ctp:i18n('inquiry.meta.backdoor')}<%--发起人/版块管理员可查看已投票和未投票人--%>
                                            </c:if>
                                            <c:if test="${inquiry.inquirySurveybasic.cryptonym == 1 && !inquiry.inquirySurveybasic.showVoters}">
											<input id="inquiryVoteBackDoor" type="checkbox" class="margin_l_10 checkbox" disabled>
                                                ${ctp:i18n('inquiry.meta.backdoor')}<%--发起人/版块管理员可查看已投票和未投票人--%>
                                            </c:if>
                                            <%--<c:if test="${inquiry.inquirySurveybasic.cryptonym == 0}">--%>
                                                <%--<input id="inquiryVoteBackDoor" type="checkbox" class="hidden margin_l_10 checkbox" disabled checked>--%>
                                            <%--</c:if>--%>
										</span>

                                    </li>
                                    <li class="result_li last_li">
										<span class="margin_r_20">
                                            <c:if test="${inquiry.inquirySurveybasic.allowViewResultAhead}">
											<input id="inquiryResultBeforeJoin" type="checkbox" class="checkbox" disabled checked>
											</c:if>
                                            <c:if test="${!inquiry.inquirySurveybasic.allowViewResultAhead}">
                                                <input id="inquiryResultBeforeJoin" type="checkbox" class="checkbox" disabled>
                                            </c:if>
                                            ${ctp:i18n('inquiry.allowviewresultahead.label')}
										</span>
										<span class="margin_r_20">
                                            <c:if test="${inquiry.inquirySurveybasic.allowViewResult}">
											<input id="inquiryResultAfterEnd" type="checkbox" class="checkbox" disabled checked>
                                            </c:if>
                                            <c:if test="${!inquiry.inquirySurveybasic.allowViewResult}">
                                                <input id="inquiryResultAfterEnd" type="checkbox" class="checkbox" disabled>
                                            </c:if>
											${ctp:i18n('inquiry.allowviewresult.label')}
										</span>
                                    </li>
                                </ul>
							</span>
                    <img src="" width="130" height="130" class="code_right" style="display: none">
                </div>

            </div>
            <div class="container_result_body">
                <div class="container_bottom">
                    <div class="bottom_header">
                        <div class="bottom_info_header">
                            <span class="result_title">${ctp:i18n('inquiry.result.inquiryresult')}&nbsp;—&nbsp;</span>${ctp:toHTML(inquiryInfo.inquiryName)}<%--调查结果--%>
                        </div>
                        <ul class="result_info_ul">
                            <li class="result_info_li overview_li">${ctp:i18n('inquiry.result.tabjoindetail')}</li><%--参与分析--%>
                            <li class="result_info_li analysis_li current">${ctp:i18n('inquiry.result.tabanalysis')}</li><%--结果分析--%>
                            <c:if test="${isSenderOrAdmin}">
                            <li class="result_info_li answer_li">${ctp:i18n('inquiry.memberexcel')}</li><%--sp1 数据收集--%>
                            </c:if>
                            <%--<img src="${path}/skin/default/images/cultural/inquiry/result_corner.jpg" width="15" height="7" class="result_corner">--%>
                        </ul>
                    </div>
                </div>
                <div class="overview result_body_info hidden">
                    <div class="overview_chart">
                        <p class="chart_title"></p><%--收集情况 ${ctp:i18n('inquiry.result.charttitle')}--%>
                        <ul class="overview_chart_msg">
                            <li class="chart_li hand" onclick="$('.result_depart_li:eq(0)').click();">
                                <span class="chart_li_title">${ctp:i18n('inquiry.result.chartlititle1')}</span><%--已参加人数--%>
                                <span class="chart_li_num join_num">${inquiry.inquirySurveybasic.voteCount}</span>
                            </li>
                            <li class="chart_li hand" onclick="$('.result_depart_li:eq(1)').click();">
                                <span class="chart_li_title">${ctp:i18n('inquiry.result.chartlititle2')}</span><%--未参加人数--%>
                                <span class="chart_li_num no_join_num">${fn:length(voteMemberList) - inquiry.inquirySurveybasic.voteCount}</span>
                            </li>
                            <li class="chart_li">
                                <span class="chart_li_title">${ctp:i18n('inquiry.result.chartlititle3')}</span><%--完成率--%>
                                <span class="chart_li_num overPer">${inquiry.inquirySurveybasic.voteCount / fn:length(voteMemberList) * 100}</span>
                            </li>
                        </ul>
                        <input type="hidden" id="overviewChartData" name="overviewChartData" value="${overviewChartData}">
                    </div>
                    <%--实名，或匿名打勾可看，详情只有实名可看--%>
                    <c:if test="${isSenderOrAdmin&&((inquiry.inquirySurveybasic.cryptonym == 0)||(inquiry.inquirySurveybasic.cryptonym == 1&&inquiry.inquirySurveybasic.showVoters))}">
                        <ul class="result_depart" style="display: block;">
                            <li class="result_depart_li current">${ctp:i18n('inquiry.result.joined')}</li><%--已参加--%>
                            <li class="result_line"></li>
                            <li class="result_depart_li">${ctp:i18n('inquiry.result.nojoined')}</li><%--未参加--%>
                        </ul>
                        <div class="result_infos">
                            <input type="hidden" value="0" id="voteType">
                            <c:if test="${inquiry.inquirySurveybasic.censor==8}">
                                <a href="javascript:;" class="result_button" onclick="reminders()">${ctp:i18n('inquiry.result.membervotetable.button')}</a><%--催办--%>
                            </c:if>
                            <div class="result_search">
                                <select id="voteMemberOption" class="search_title">
                                    <option value="1">${ctp:i18n('inquiry.result.membervotetable.th1')}</option><%--姓名--%>
                                    <option value="2">${ctp:i18n('inquiry.result.membervotetable.th2')}</option><%--部门--%>
                                    <option value="3">${ctp:i18n('inquiry.result.membervotetable.th3')}</option><%--岗位--%>
                                </select>
                                <input id="voteMemberInput" type="text" class="search_input"/>
                                <span class="search_icon hand" onclick="searchVoteMember();">
                                    <%--投票人员查询--%>
                                    <em class="icon16 result_search_16"></em>
                                </span>
                            </div>
                        </div>
                        <div class="radius_15">
                            <table id="voteMemberTable" cellpadding="0" cellspacing="0" width="100%" class="table people_table">
                                <thead class="table_head">
                                <tr>
                                    <td width="4%" class="check_input">
                                        <input type="checkbox" class="check_all" onclick="selectVoteMember();">
                                    </td>
                                    <td width="15%">${ctp:i18n('inquiry.result.membervotetable.th1')}</td><%--姓名--%>
                                    <td width="20%">${ctp:i18n('inquiry.result.membervotetable.th2')}</td><%--部门--%>
                                    <td width="20%">${ctp:i18n('inquiry.result.membervotetable.th3')}</td><%--岗位--%>
                                    <td width="25%">${ctp:i18n('inquiry.result.membervotetable.th4')}</td><%--投票时间--%>
                                    <td width="10%">${ctp:i18n('inquiry.result.membervotetable.th5')}</td><%--问卷--%>
                                </tr>
                                </thead>
                                <tbody class="table_body">
                                <c:forEach var="member" items="${voteMemberList}" varStatus="x">
                                    <c:if test="${x.index<20}">
                                        <tr id="voteMember_${member.v3xOrgMember.id}">
                                            <td width="4%" class="check_input">
                                                <c:if test="${member.hadVoted}">
                                                    <input type="checkbox" class="check_list voted" disabled>
                                                </c:if>
                                                <c:if test="${!member.hadVoted}">
                                                    <input type="checkbox" class="check_list notVote" name="voteMemberTable" value="${member.v3xOrgMember.id}">
                                                </c:if>
                                            </td>
                                            <td title="${ctp:toHTML(v3x:showMemberNameOnly(member.v3xOrgMember.id))}">${ctp:toHTML(v3x:getLimitLengthString(v3x:showMemberNameOnly(member.v3xOrgMember.id),10,'...'))}</td>
                                            <td title="${ctp:toHTML(member.deptStr)}">${ctp:toHTML(v3x:getLimitLengthString(member.deptStr,12,'...'))}</td>
                                            <td title="${ctp:toHTML(member.postStr)}">${ctp:toHTML(v3x:getLimitLengthString(member.postStr,18,'...'))}</td>
                                            <td><fmt:formatDate value="${member.voteDate}" type="both" pattern="yyyy-MM-dd HH:mm"/></td>
                                            <td censor = "${inquiry.inquirySurveybasic.censor}" boo = "${inquiry.inquirySurveybasic.censor != 10}" aa="${member.hadVoted&&(inquiry.inquirySurveybasic.cryptonym == 0&&isSenderOrAdmin)&&inquiry.inquirySurveybasic.censor != 10}">
                                                <c:if test="${member.hadVoted&&(inquiry.inquirySurveybasic.cryptonym == 0&&isSenderOrAdmin)&&inquiry.inquirySurveybasic.censor != 10}">
                                                    <em class="icon16 result_table_16 relative_icon hand" onclick="openInquiryInfo('${member.v3xOrgMember.id}')"></em>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:if test="${x.index>=20}">
                                        <tr id="voteMember_${member.v3xOrgMember.id}" style="display: none;">
                                            <td width="4%" class="check_input">
                                                <c:if test="${member.hadVoted}">
                                                    <input type="checkbox" class="check_list voted" disabled>
                                                </c:if>
                                                <c:if test="${!member.hadVoted}">
                                                    <input type="checkbox" class="check_list notVote" name="voteMemberTable" value="${member.v3xOrgMember.id}">
                                                </c:if>
                                            </td>
                                            <td title="${ctp:toHTML(v3x:showMemberNameOnly(member.v3xOrgMember.id))}">${ctp:toHTML(v3x:getLimitLengthString(v3x:showMemberNameOnly(member.v3xOrgMember.id),10,'...'))}</td>
                                            <td title="${ctp:toHTML(member.deptStr)}">${ctp:toHTML(v3x:getLimitLengthString(member.deptStr,12,'...'))}</td>
                                            <td title="${ctp:toHTML(member.postStr)}">${ctp:toHTML(v3x:getLimitLengthString(member.postStr,18,'...'))}</td>
                                            <td><fmt:formatDate value="${member.voteDate}" type="both" pattern="yyyy-MM-dd HH:mm"/></td>
                                            <td censor = "${inquiry.inquirySurveybasic.censor}" boo = "${inquiry.inquirySurveybasic.censor != 10}" aa="${member.hadVoted&&(inquiry.inquirySurveybasic.cryptonym == 0&&isSenderOrAdmin)&&inquiry.inquirySurveybasic.censor != 10}">
                                                <c:if test="${member.hadVoted&&(inquiry.inquirySurveybasic.cryptonym == 0&&isSenderOrAdmin)&&inquiry.inquirySurveybasic.censor != 10}">
                                                    <em class="icon16 result_table_16 relative_icon hand" onclick="openInquiryInfo('${member.v3xOrgMember.id}')"></em>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                </tbody>
                                <tfoot class="table_foot">
                                <c:if test="${fn:length(voteMemberList)>20}">
                                    <tr id="moreRows">
                                        <td colspan="6" align="center" onclick="moreRows();">${ctp:i18n('inquiry.result.more')}</td><%--加载更多--%>
                                    </tr>
                                </c:if>
                                <c:if test="${fn:length(voteMemberList)<=20}">
                                    <tr id="moreRows" style="display: none">
                                        <td colspan="5" align="center" onclick="moreRows();">${ctp:i18n('inquiry.result.more')}</td><%--加载更多--%>
                                    </tr>
                                </c:if>
                                </tfoot>
                            </table>
                            <input id='pageNum' type="hidden" value="1">
                        </div>
                    </c:if>
                </div>
                <div class="result_analysis result_body_info">
                    <div class="ana_top">
                        <div class="ana_top_info">
                            <v3x:selectPeople id="spDept" showAllAccount="true" originalElements="${org}"
                                              panels="Department" selectType="Department" departmentId=""
                                              jsFunction="setPeopleFields(elements,'dept')" />
                            <v3x:selectPeople id="spPost" originalElements="${org}"
                                              panels="Post" selectType="Post" departmentId=""
                                              jsFunction="setPeopleFields(elements,'post')" />
                            <input type="hidden" value="all" id="searchType">
                            <span style="float: left;line-height: 25px;padding-right: 10px;">
                                <input id="voteResultSelectType1" name="voteResultSelectType" type="radio" value="all" checked  onclick="showSelectPeople('all');" style="margin-bottom: 2px;">
                                <label for="voteResultSelectType1" class="margin_l_5">${ctp:i18n('inquiry.result.changeanswer.total')}</label><%--全部--%>
                            </span>
                            <span style="float: left;line-height: 25px;padding-right: 10px;" >
                                <input id="voteResultSelectType2" name="voteResultSelectType" type="radio" value="dept" onclick="showSelectPeople('dept');" style="margin-bottom: 2px;">
                                <label for="voteResultSelectType2" class="margin_l_5">${ctp:i18n('inquiry.result.changeanswer.dept')}</label><%--部门--%>
                            </span>
                            <span style="float: left;line-height: 25px;padding-right: 10px;">
                                <input id="voteResultSelectType3" name="voteResultSelectType" type="radio" value="post"  onclick="showSelectPeople('post');" style="margin-bottom: 2px;">
                                <label for="voteResultSelectType3" class="margin_l_5">${ctp:i18n('inquiry.result.changeanswer.post')}</label><%--岗位--%>
                            </span>
                            <span style="float: left;line-height: 25px;padding-right: 10px;">
                                <input id="voteResultSelectPeople" style="width: 200px" type="text" readonly>
                                <input id="voteResultSelectPeopleScope" type="hidden">
                            </span>
                            <span class="analysis_span hand" style="float: left;line-height: 25px;" onclick="inquiryToCol();">
                                <em class="icon16 send_seeyon_16"></em>${ctp:i18n('inquiry.result.button.tocol')}<%--转发协同--%>
                            </span>
                            <c:if test="${isSenderOrAdmin}">
                            <span class="analysis_span hand" style="float: left;line-height: 25px;" onclick="fileToExcel()">
                                <em class="icon16 export_16"></em>${ctp:i18n('inquiry.result.button.toexcel')}<%--导出--%>
                            </span>
                            </c:if>

                            <%--<span class="analysis_span">--%>
                                <%--<em class="icon16 print_16"></em>--%>
                                <%--打印--%>
                            <%--</span>--%>
                        </div>
                    </div>
                    <%--实名且管理员发起人可看--%>
                    <c:forEach items="${inquiry.subsurveyAndICompose}" var="question" varStatus="quState">
                        <p class="ana_title margin_l_30">${quState.count}. ${ctp:toHTML(question.inquirySubsurvey.title)}</p>
                        <input type="hidden" value="${question.inquirySubsurvey.singleMany}" id="qType_${question.inquirySubsurvey.id}">
                        <c:if test="${question.inquirySubsurvey.singleMany!=2&&question.inquirySubsurvey.singleMany!=3}">
                            <div class="analysis_chart chartObj" id="quChart_${question.inquirySubsurvey.id}"></div>
                            <img class="chartImg" id="quChartImg_${question.inquirySubsurvey.id}" style="width: 705px;height: 245px;text-align: center;display: none"/>
                        </c:if>
                        <div class="radius_15" id="quTableDiv_${question.inquirySubsurvey.id}" style="margin-bottom: 30px;">
                            <table cellpadding="0" cellspacing="0" width="100%" class="table analysis_table">
                                <c:choose>
                                    <c:when test="${question.inquirySubsurvey.singleMany==2||question.inquirySubsurvey.singleMany==3}">
                                        <thead class="table_head">
                                            <tr>
                                                <c:if test="${inquiry.inquirySurveybasic.cryptonym == 0 && isSenderOrAdmin}">
                                                    <td width="30%">${ctp:i18n('inquiry.result.qutalbe.th1')}</td><%--姓名--%>
                                                    <td width="70%">${ctp:i18n('inquiry.result.qutalbe.th2')}</td><%--答案--%>
                                                </c:if>
                                                <c:if test="${!(inquiry.inquirySurveybasic.cryptonym == 0 && isSenderOrAdmin)}">
                                                    <td width="100%">${ctp:i18n('inquiry.result.qutalbe.th2')}</td><%--答案--%>
                                                </c:if>
                                            </tr>
                                        </thead>
                                        <tbody class="table_body">
                                        <c:forEach var="answer" items="${question.inquirySubsurvey.isds}">
                                            <tr>
                                                <c:if test="${inquiry.inquirySurveybasic.cryptonym == 0 && isSenderOrAdmin}">
                                                <td title = "${v3x:showMemberNameOnly(answer.userId)}">${v3x:getLimitLengthString(v3x:showMemberNameOnly(answer.userId),25,"...")}</td>
                                                <td class="relative">
                                                        ${v3x:toHTMLescapeRN(answer.discussContent)}
                                                        <%--<em class="icon16 result_table_16 relative_icon"></em>--%>
                                                </td>
                                                </c:if>
                                                <c:if test="${!(inquiry.inquirySurveybasic.cryptonym == 0 && isSenderOrAdmin)}">
                                                <td class="relative">
                                                        ${v3x:toHTMLescapeRN(answer.discussContent)}
                                                        <%--<em class="icon16 result_table_16 relative_icon"></em>--%>
                                                </td>
                                                </c:if>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                        <tfoot class="table_foot">
                                            <tr>
                                                <td colspan="2">
                                                    <span class="analysis_people">${ctp:i18n('inquiry.result.qutalbe.tfoot1')}：${inquiry.inquirySurveybasic.voteCount}</span><%--答题人数--%>
                                                    <span class="discuss_page">
                                                        <%--<em class="icon16 discuss_left_16"></em>--%>
                                                        <span class="page_circles">
                                                            <a href="javascript:;" class="page_num current moreResult" style="width: auto" onclick="moreResult(this);">${ctp:i18n('inquiry.result.qutalbe.tfoot2')}</a><%--查看更多--%>
                                                            <a href="javascript:;" class="page_num current hideResult" style="width: auto" onclick="hideResult(this);">${ctp:i18n('inquiry.result.qutalbe.tfoot3')}</a><%--收起结果--%>
                                                        </span>
                                                        <%--<em class="icon16 discuss_right_16"></em>--%>
                                                    </span>
                                                </td>
                                            </tr>
                                        </tfoot>
                                    </c:when>
                                    <c:otherwise>
                                        <thead class="table_head">
                                        <tr>
                                            <td width="70%">${ctp:i18n('inquiry.result.qutalbe.th3')}</td><%--答案选项--%>
                                            <td width="15%">${ctp:i18n('inquiry.result.qutalbe.th4')}</td><%--选择人数--%>
                                            <td width="15%">${ctp:i18n('inquiry.result.qutalbe.th5')}</td><%--百 分 比--%>
                                        </tr>
                                        </thead>
                                        <tbody class="table_body">
                                        <c:forEach var="answer" items="${question.items}">
                                            <c:choose>
                                                <c:when test="${(inquiry.inquirySurveybasic.cryptonym=='0'||(inquiry.inquirySurveybasic.cryptonym=='1'&&answer.contentExt2=='1')) &&isSenderOrAdmin}">
                                                    <tr id="itemTr_${answer.id}" class="hand" onclick="openWindowForItem('${answer.id}',${inquiry.inquirySurveybasic.cryptonym})">
                                                </c:when>
                                                <c:otherwise>
                                                    <tr id="itemTr_${answer.id}">
                                                </c:otherwise>
                                            </c:choose>
                                                <td>${ctp:toHTML(answer.content)}</td>
                                                <td class="fakeVoteCount">${answer.voteCount}</td>
                                                <td>
                                                    <c:if test="${inquiry.inquirySurveybasic.voteCount==0}">
                                                    0.00%
                                                    </c:if>
                                                    <c:if test="${inquiry.inquirySurveybasic.voteCount!=0}">
                                                        <fmt:formatNumber value="${answer.voteCount / inquiry.inquirySurveybasic.voteCount * 100}" pattern="0.00"/>%
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                        <tfoot class="table_foot">
                                            <tr>
                                                <td colspan="3">
                                                    <span class="analysis_people">${ctp:i18n('inquiry.result.qutalbe.tfoot1')}：${inquiry.inquirySurveybasic.voteCount}</span><%--答题人数--%>
                                                </td>
                                            </tr>
                                        </tfoot>
                                    </c:otherwise>
                                </c:choose>
                            </table>
                        </div>
                    </c:forEach>
                </div>
                <c:if test="${isSenderOrAdmin}">
                <div class="answer_detail result_body_info hidden">
                    <input id="firstAnswer" type="hidden" value="0"/>
                    <input id="isSecret" type="hidden" value="${inquiry.inquirySurveybasic.cryptonym}"/>
                    <div id="quList" hidden>
                        <c:forEach items="${inquiry.subsurveyAndICompose}" var="question" varStatus="quState">
                            <input type="hidden" value="Q${quState.count}. ${ctp:toHTML(question.inquirySubsurvey.title)}">
                        </c:forEach>
                    </div>
                    <div class="answer_export">
                        <span class="analysis_span hand" style="float: left;line-height: 25px;" onclick="fileToMemberExcel()">
                            <em class="icon16 export_16"></em>${ctp:i18n('inquiry.result.button.toexcel')}<%--导出--%>
                        </span>
                    </div>
                    <div class="answer_table">
                        <table id="answerTable" style="display: none;" width="100%" height="100%" class="table"></table>
                    </div>
                </div>
                </c:if>
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