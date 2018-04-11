<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="planSummary.js.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html class="h100b w100b">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
    <style type="text/css">
    .person_box{
        width:90px;
        float:left;
    }
    .person_box_ico{
        cursor: default;
        float:left;
        margin-top: 2px;
    }
    .person_box_name{
        width:60px;
        margin-left:5px;
        white-space:nowrap;
        text-overflow:ellipsis;
        font-size:12px;
        display:block;
        float:left;
        overflow:hidden;
    }
    </style>
    <script type="text/javascript">
        $(document).ready(function() {
            $(window).resize(function(){
                $("#tabs").tab().resetSize();
            });
        });
    </script>
</head>
<body class="h100b w100b over_hidden" id="layout_body1">
	<div id="processBtn" style="display: block;">
		<table border="0"  cellspacing="0" cellpadding="0" class="sign-area">
			<c:if test="${canProcess}">
				<tr>
					<td>
						<a href="javascript:void(0)" class="common_button common_button_gray" onclick="javascript:showProcPanel('tab1_div')">${ctp:i18n('plan.summary.tab.process')}</a>
					</td>
				</tr>
			</c:if>
			<tr><td><a href="javascript:void(0)" class="common_button common_button_gray" onclick="javascript:showProcPanel('tab2_div')">${ctp:i18n('plan.summary.tab.property')}</a></td></tr>
		</table>
	</div>
	<div id="processPanel" style="display: none;">
		<div id="tabs" class="comp" comp="type:'tab',parentId:'layout_body1'">
			<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li ><a id="btn0" href="javascript:void(0)" onclick="hideProcPanel()" class="border_b" style="min-width:10px"><span class="ico16 advanced_16" style="position:relative;margin-top:5px;margin-bottom:5px;zoom:1" ></span></a></li>
				<c:if test="${canProcess}">
					<li class="current" >
						<a id="btnProcess" class="border_b" href="javascript:void(0)" tgt="tab1_div">
							<span>${ctp:i18n('plan.summary.tab.process')}</span>
						</a>
					</li>
				</c:if>
				<li <c:if test="${!canProcess}">class="current"</c:if>>
					<a id="btnProperty" class="border_b last_tab" href="javascript:void(0)" tgt="tab2_div">
						<span>${ctp:i18n('plan.summary.tab.property')}</span>
					</a>
				</li>
			</ul>
			</div>
			<div id='tabs_body' class="font_size12" style="margin:0px 6px">
				<c:if test="${canProcess}">
					<div id="tab1_div" class="hidden over_auto w100b" style="float:left;">
						<form id="replyform" name="replyform" action="" method="post">
							<input type="hidden" id="moduleId" name="moduleId" value="${param.planId }" /> 
							<input type="hidden" id="moduleType" name="moduleType" value='5' /> 
							<input type="hidden" id="relateInfo" name="relateInfo" value="" />
							<input type="hidden" id="content" name="content" value="" />
							<input type="hidden" id="hidden" name="hidden" value="" />
							<input type="hidden" id="pid" name="pid" value="0"/>
							<input type="hidden" id="clevel" name="clevel" value="1"/>
							<input type="hidden" id="path" name="path" value="${param.path }"/>
							<input type="hidden" id="ctype" name="ctype" value="0"/>
							<input type="hidden" id="showToId" name="showToId" value="Member|${createUser }" />
						</form>
						<div id="replyCommentDiv" class="margin_t_10">
							
							<table id="formDomain" width="90%" border="0" cellspacing="0" cellpadding="0"
								class="margin_lr_10">
								<TR>
									<TD width=40% align="left">${ctp:i18n('plan.summary.tab.planreply')}:</TD>
									<TD colspan="2" align="right">
										<a id="cphrase"  href="javascript:void(0)" onclick="showphrase('${CurrentUser.id}')">
											<span class="ico16 common_language_16"></span>
											${ctp:i18n('plan.summary.tab.normalmessage')}
										</a>
									</TD>
								</TR>
								<TR>
									<TD colspan="3">
										<textarea id="replyContent" name="replyContent" class="padding_5" style="resize: none;font-size:12px;width: 95%" rows="11"></textarea>
									</TD>
								</TR>
								<TR  style="padding-bottom: 10px">
									<td  colspan="2">
										<div style="color: green" class="margin_t_5">${ctp:i18n('plan.summary.tab.nomorethan1200')}</div>
									</td>
									<TD align="right">
										<label class="margin_t_5"> 
											<input name="isHidden" id="isHidden" type="checkbox" value=""><span class="margin_l_5">${ctp:i18n('plan.summary.tab.opinionhide')}</span> 
										</label>
									</TD>
	
								</TR>
								<tr>
									<td colspan="3" style="padding-bottom: 10px">
										<div class="scrollList margin_tb_5">
											<a href="javascript:void(0)" onclick="showAllAttachement();insertAttachment()" class=""><em class="ico16 affix_16"></em>${ctp:i18n('plan.summary.tab.uploadatt')}</a>(<span id="attachmentNumberDiv">0</span>)
										</div>
										<div id="attachmentTR" style="display: none;">
											<div class="comp" comp="type:'fileupload',
																			applicationCategory:'1',canDeleteOriginalAtts:false,originalAttsNeedClone:false,canFavourite:false"
						 													attsdata=''></div>
										</div>
									</td>
								</tr>
							</table>
							<div class="border_t padding_tb_5 align_right margin_r_10">
								<a id="submitit" class="common_button common_button_gray" href="javascript:void(0)" onclick="submit_commont()">${ctp:i18n('common.button.ok.label')}</a>
							</div>
						</div>
					</div>
				</c:if>
				<div id="tab2_div" class="w100b over_auto <c:if test="${canProcess}">hidden</c:if>" style="word-break: break-all;float:left;">
					<table border="0" cellpadding="0" cellspacing="0"
						style="margin: 10px; line-height: 30px;">
						<tr>
							<td width="30%" align="right">${ctp:i18n('plan.summary.tab.plantime')} :&nbsp;&nbsp;</td>
							<td width="67%">${startTime_} ${ctp:i18n('plan.summary.tab.to')} ${endTime}</td>
							<td width="2%"></td>
						</tr>
						<tr>
							<td width="30%" align="right">${ctp:i18n('plan.summary.tab.plantype')} :&nbsp;&nbsp;</td>
							<td width="67%">${planType }</td>
							<td width="2%"></td>
						</tr>
						<tr>
							<td width="30%" style="line-height: 20px;" nowrap="nowrap"
								align="right" valign="top">${ctp:i18n('plan.toolbar.button.to')} :&nbsp;&nbsp;</td>
							<td width="67%" style="overflow: hidden; line-height: 20px;" valign="top">
                                <c:forEach var="mainTo" items="${allRelUsers.mainTo}" varStatus="status1">
                                    <div class="person_box">
                                         <c:if test="${mainTo.process == 0}">
                                            <c:set value="unviewed_16" var="icoValue" />
                                            <c:set value="未看" var="icoTitle" />
                                        </c:if>
                                        <c:if test="${mainTo.process == 1}">
                                            <c:set value="participate_16" var="icoValue" />
                                            <c:set value="已回复" var="icoTitle" />
                                        </c:if>
                                        <c:if test="${mainTo.process == 2}">
                                            <c:set value="viewed_16" var="icoValue" />
                                            <c:set value="查看" var="icoTitle" />
                                        </c:if>                                       
                                        <span class="ico16 ${icoValue} person_box_ico" title="${icoTitle }"></span><span class="person_box_name" title="${mainTo.refUserName }">${mainTo.refUserName }</span>
                                    </div>
                                </c:forEach>
                            </td>
							<td width="2%"></td>
						</tr>
						<tr>
							<td width="30%" style="line-height: 20px;" nowrap="nowrap"
								align="right" valign="top">${ctp:i18n('plan.toolbar.button.cc')} :&nbsp;&nbsp;</td>
							<td width="67%" style="overflow: hidden; line-height: 20px;" valign="top">
                               <c:forEach var="cc" items="${allRelUsers.ccList}" varStatus="status2">
                                    <div class="person_box">
                                         <c:if test="${cc.process == 0}">
                                            <c:set value="unviewed_16" var="icoValue" />
                                            <c:set value="未看" var="icoTitle" />
                                        </c:if>
                                        <c:if test="${cc.process == 1}">
                                            <c:set value="participate_16" var="icoValue" />
                                            <c:set value="已回复" var="icoTitle" />
                                        </c:if>
                                        <c:if test="${cc.process == 2}">
                                            <c:set value="viewed_16" var="icoValue" />
                                            <c:set value="查看" var="icoTitle" />
                                        </c:if>                                       
                                        <span class="ico16 ${icoValue} person_box_ico" title="${icoTitle }"></span><span class="person_box_name" title="${cc.refUserName }">${cc.refUserName }</span>
                                    </div>
                                </c:forEach>
                            </td>
							<td width="2%"></td>
						</tr>
						<tr>
							<td width="30%" style="line-height: 20px;" nowrap="nowrap"
								align="right" valign="top">${ctp:i18n('plan.toolbar.button.apprize')} :&nbsp;&nbsp;</td>
							<td width="67%" style="overflow: hidden; line-height: 20px;" valign="top">
                                <c:forEach var="tell" items="${allRelUsers.tellList}" varStatus="status3">
                                    <div class="person_box">
                                         <c:if test="${tell.process == 0}">
                                            <c:set value="unviewed_16" var="icoValue" />
                                            <c:set value="未看" var="icoTitle" />
                                        </c:if>
                                        <c:if test="${tell.process == 1}">
                                            <c:set value="participate_16" var="icoValue" />
                                            <c:set value="已回复" var="icoTitle" />
                                        </c:if>
                                        <c:if test="${tell.process == 2}">
                                            <c:set value="viewed_16" var="icoValue" />
                                            <c:set value="查看" var="icoTitle" />
                                        </c:if>                                       
                                        <span class="ico16 ${icoValue} person_box_ico" title="${icoTitle }"></span><span class="person_box_name" title="${tell.refUserName }">${tell.refUserName }</span>
                                    </div>
                                </c:forEach>
                            </td>
							<td width="2%"></td>
						</tr>
						<tr>
							<td width="30%" nowrap="nowrap" align="right">${ctp:i18n('plan.toolbar.button.relateproject')} :&nbsp;&nbsp;</td>
							<td width="67%">${ctp:toHTML(relProject) }</td>
							<td width="2%"></td>
						</tr>
						<tr>
							<td width="30%" nowrap="nowrap" align="right">${ctp:i18n('plan.toolbar.button.relatedep')} :&nbsp;&nbsp;</td>
							<td width="67%">${relDepartment }</td>
							<td width="2%"></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
</html>