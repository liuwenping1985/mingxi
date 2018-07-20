<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="planSummary.js.jsp" %>
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
<body class="h100b w100b over_hidden" id="layout_body">
	<div id="processBtn" style="display: block;">
		<table border="0"  cellspacing="0" cellpadding="0" class="sign-area">
			<tr><td><a href="javascript:void(0)" class="common_button common_button_gray" onclick="javascript:showProcPanel('tab1_div')">${ctp:i18n('plan.summary.tab.status')}</a></td></tr>
			<c:if test="${canSummary}"><tr><td><a href="javascript:void(0)" class="common_button common_button_gray" onclick="javascript:showProcPanel('tab2_div')">${ctp:i18n('plan.summary.tab.summary')}</a></td></tr></c:if>
			<tr><td><a href="javascript:void(0)" class="common_button common_button_gray" onclick="javascript:showProcPanel('tab3_div')">${ctp:i18n('plan.summary.tab.property')}</a></td></tr>
		</table>
	</div>
	<div id="processPanel" style="display: none;">
		<div id="tabs" class="comp" comp="type:'tab',parentId:'layout_body'">
		    <div id="tabs_head" class="common_tabs clearfix">
		        <ul class="left">
		        	<li><a id="btn0" class="border_b" href="javascript:void(0)" onclick="hideProcPanel()" style="min-width:10px"><span class="ico16 advanced_16" style="position:relative;margin-top:5px;margin-bottom:5px;zoom:1"></span></a></li>
		            <li class="current"><a id="btnStatus" class="border_b" href="javascript:void(0)" tgt="tab1_div"><span>${ctp:i18n('plan.summary.tab.status')}</span></a></li>
		            <c:if test="${canSummary}">
		            	<li><a id="btnSummary" href="javascript:void(0)" class="border_b" tgt="tab2_div"><span>${ctp:i18n('plan.summary.tab.summary')}</span></a></li>
		            </c:if>
		            <li><a id="btnProperty" href="javascript:void(0)" tgt="tab3_div" class='last_tab border_b'><span>${ctp:i18n('plan.summary.tab.property')}</span></a></li>
		        </ul>
		    </div>
		    <div id='tabs_body' class="common_tabs_body font_size12 border_t">
		        <div id="tab1_div" class="over_auto w100b">
		 			<form id="statusform" action="plan.do?method=changeStatus" onsubmit="return false" method="post" style='margin: 0px'>
		          		<INPUT type='hidden' value="${param.planId }" name="planId" id="planId">
		          		<table width="90%" border="0"  cellspacing="0" cellpadding="0" class="sign-area margin_t_10" style="position:relative;left:10px;">
		          			
		          			<tr>
		              			<td nowrap="nowrap" align="right">${ctp:i18n('plan.grid.label.finishratio')}：</td>
		             			<td align="left">
	                               <input type="text" style="width:80px;text-align:center" id="rate" name="rate" value="${finishRatio}" onkeyup="initByRateInput();" autocomplete="off" onpaste="return false"><strong>%</strong> 
		                		</td>
		          			</tr>
		          			<tr height="10"><td>&nbsp;</td><td>&nbsp;</td></tr>
				          	<tr>
				              	<td nowrap="nowrap" align="right">${ctp:i18n('plan.summary.tab.elsestatus')}：</td>
				              	<td align="left">
					              		<select name="planStatus" id="planStatus" style="width: 99px" onchange="initByPlanStatus();">
											<option value='1' <c:if test="${planStatus=='1' }">selected</c:if>>${ctp:i18n('plan.execution.state.1')}</option>
											<option value='2' <c:if test="${planStatus=='2' }">selected</c:if>>${ctp:i18n('plan.execution.state.2')}</option>
											<option value='3' <c:if test="${planStatus=='3' }">selected</c:if>>${ctp:i18n('plan.execution.state.3')}</option>
											<option value='4' <c:if test="${planStatus=='4' }">selected</c:if>>${ctp:i18n('plan.execution.state.4')}</option>
											<option value='5' <c:if test="${planStatus=='5' }">selected</c:if>>${ctp:i18n('plan.execution.state.5')}</option>
					              		</select>
					              </td>
				          	</tr>
		
				  			  <tr height="10"><td>&nbsp;</td><td>&nbsp;</td></tr>
							  <tr>
							     <td><hr/></td>
							     <td><hr/></td>
							  </tr>
							  <tr>
							  		<td colspan="2" align="right">
							  			<a id="submitit" class="common_button common_button_gray" href="javascript:void(0)" onclick="submit_status('tab1')">${ctp:i18n('common.button.ok.label')}</a>
							  		</td>
							  </tr>
		    			</table>
		    			 
		   			</form>
				</div>
				
				<c:if test="${canSummary}">
				<div id="tab2_div" class="hidden over_auto w100b">
					<form id="summaryform" action="" onsubmit="return false" method="post" style='margin: 0px'>
						<table width="90%" id="formDomain" border="0" cellspacing="0" cellpadding="0" class="margin_t_10 margin_lr_5">
							<input type=hidden value="${param.planId }" name="planId"/>

							<tr>
								<td nowrap="nowrap">${ctp:i18n('plan.summary.tab.plansummary')}：</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td>
									<textarea id="summaryText" name="summaryText" class="padding_5" style="font-size:12px;resize: none;width:100%" rows="11"></textarea>
									<div style="color: green" class="margin_t_5">${ctp:i18n('plan.summary.tab.nomorethan1200')}</div>
								</td>
							</tr>
						
							<tr>
								<td >
								<div class="margin_tb_5">
									<a href="javascript:void(0)" onclick="showAllAttachement();insertAttachment();" class=""><em class="ico16 affix_16"></em>${ctp:i18n('plan.summary.tab.uploadatt')}</a>(<span id="attachmentNumberDiv">0</span>)
								</div>
								<div id="attachmentTR" style="display: none;">
									<div class="comp" comp="type:'fileupload',
																	applicationCategory:'1',canDeleteOriginalAtts:false,originalAttsNeedClone:false,canFavourite:false"
				 													attsdata=''></div>
								</div>
								
								</td>
							</tr>
							<tr>
							
							</tr>
						</table>
						<div class="border_t padding_tb_5 align_right margin_r_10">
								<a id="submitit2" class="common_button common_button_gray" href="javascript:void(0)" onclick="submit_status('tab2')">${ctp:i18n('common.button.ok.label')}</a>
						</div>
					</form>
				</div>
				
				</c:if>
		        <div id="tab3_div" class="hidden over_auto w100b">
					<table border="0" cellpadding="0" cellspacing="0"
						style="margin: 10px; line-height: 30px;">
						<tr>
							<td width="80" align="right">${ctp:i18n('plan.summary.tab.plantime')} :</td>
							<td width="200">${startTime_} ${ctp:i18n('plan.summary.tab.to')} ${endTime}</td>
							<td width="10"></td>
						</tr>
						<tr>
							<td width="80" align="right">${ctp:i18n('plan.summary.tab.plantype')} :</td>
							<td width="200">${planType }</td>
							<td width="10"></td>
						</tr>
						<tr>
							<td width="80" style="line-height: 20px;" nowrap="nowrap"
								align="right" valign="top">${ctp:i18n('plan.toolbar.button.to')} :</td>
							<td width="200" style="overflow: hidden; line-height: 20px;" valign="top">
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
							<td width="10"></td>
						</tr>
						<tr>
							<td width="80" style="line-height: 20px;" nowrap="nowrap"
								align="right" valign="top">${ctp:i18n('plan.toolbar.button.cc')} :</td>
							<td width="200" style="overflow: hidden; line-height: 20px;" valign="top">
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
							<td width="10"></td>
						</tr>
						<tr>
							<td width="80" style="line-height: 20px;" nowrap="nowrap"
								align="right" valign="top">${ctp:i18n('plan.toolbar.button.apprize')} :</td>
							<td width="200" style="overflow: hidden; line-height: 20px;" valign="top">
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
							<td width="10"></td>
						</tr>
						<tr>
							<td width="80" nowrap="nowrap" align="right">${ctp:i18n('plan.toolbar.button.relateproject')} :</td>
							<td width="200">${ctp:toHTML(relProject) }</td>
							<td width="10"></td>
						</tr>
						<tr>
							<td width="80" nowrap="nowrap" align="right">${ctp:i18n('plan.toolbar.button.relatedep')} :</td>
							<td width="200">${relDepartment }</td>
							<td width="10"></td>
						</tr>
					</table>
				</div>
			</div>
		</div>	
	</div>
</body>
</html>