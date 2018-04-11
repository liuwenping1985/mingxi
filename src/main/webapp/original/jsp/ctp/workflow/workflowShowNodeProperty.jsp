<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
<title>${ctp:i18n('workflow.nodeProperty.title')}</title>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
<style type="text/css">
.my_label{
    line-height: 22px;
}
.my_th{
    line-height: 22px;
}
.toomore{
    width:230px;
    overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}
</style>
</head>
<body>
<fieldset class="margin_10"><%-- 属性设置 --%>
    <legend>${ctp:i18n("workflow.nodeProperty.setting")}</legend>
    <div class="form_area relative margin_l_10">
        <table border="0" cellspacing="0" cellpadding="0" width="100%" class="my_th">
            <tr>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label" for="text">${ctp:i18n("workflow.nodeProperty.setting.nodeName")}:</label></th>
                <td width="140"  class="padding_l_5" nowrap="nowrap">${ctp:toHTML(nodeName)}</td>
                <td align="right"  nowrap="nowrap"><c:if test="${'WFDynamicForm' eq partyType}"><a class="color_blue" href="#" title="${dyTitle}">[${ctp:i18n("workflow.label.fromDynamicForm")}<%-- 来自动态表 --%>]</a></c:if></td>
            </tr>
            <c:if test="${param.partyType eq 'Post'}"><tr><%-- 匹配范围 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("node.matchScope")}:</label></th>
                <td width="140" class="padding_l_5" colspan="2">
                    <%-- param是el的内置对象，本身是一个map，key就是参数名 
                    显示匹配范围嘛，一段很简单的逻辑，if else if而已--%>
                    <c:choose>
                        <c:when test="${matchScope eq '5'}"><%-- 发起者上级单位 --%>
                            ${ctp:i18n("workflow.designer.node.matchScope.5")}
                        </c:when>
                        <c:when test="${matchScope eq '4'}"><%-- 表单控件决定 --%>
                            ${ctp:i18n("workflow.designer.node.matchScope.4.1")}
                        </c:when>
                        <c:when test="${matchScope eq '3'}"><%-- 发起者部门-包含子部门 --%>
                        	<c:choose>
                        		<c:when test="${vjoin=='1' }">
                        			${ctp:i18n("workflow.designer.node.matchScope.3.vj")}
                        		</c:when>
                        		<c:otherwise>
                        		${ctp:i18n("workflow.designer.node.matchScope.3")}
                            	<c:if test="${pup=='1' || pup=='null' || pup=='-1' || pup==''  || pup=='undefined'}">(${ctp:i18n("workflow.designer.node.role.autoup.label")})</c:if>
                        		</c:otherwise>
                        	</c:choose>
                        </c:when>
                        <c:when test="${matchScope eq '6'}"><%-- 发起者部门-不包含子部门 --%>
                            ${ctp:i18n("workflow.designer.node.matchScope.6")}
                            <c:if test="${pup=='1' || pup=='null' || pup=='-1' || pup==''  || pup=='undefined'}">(${ctp:i18n("workflow.designer.node.role.autoup.label")})</c:if>
                        </c:when>
                        <c:when test="${matchScope eq '2'}"><%-- 集团标准岗 --%>
                            <c:if test="${v3xSuffix eq '.GOV' }">${ctp:i18n("workflow.designer.node.matchScope.2.GOV")}</c:if>
                            <c:if test="${v3xSuffix ne '.GOV' }">${ctp:i18n("workflow.designer.node.matchScope.2")}</c:if>
                        </c:when>
                        <c:when test="${matchScope eq '1'}"><%-- 单位岗 --%>
                        	<c:choose>
                        		<c:when test="${vjoin=='1' }">
                        			${ctp:i18n("workflow.designer.node.matchScope.1.A.vj")}
                        		</c:when>
                        		<c:otherwise>
                        			<c:if test="${matchScopeSuffix eq '.A' }">${ctp:i18n("workflow.designer.node.matchScope.1.A")}</c:if>
                            		<c:if test="${matchScopeSuffix ne '.A' }">${ctp:i18n("workflow.designer.node.matchScope.1")}</c:if>
                        		</c:otherwise>
                        	</c:choose>
                        </c:when>
                    </c:choose>
                </td>
            </tr></c:if>
            <%--角色匹配范围 --%>
            <c:if test="${(partyType=='Node' || partyType=='Role') && isSNRole==false
                        && partyId!='BlankNode' 
                        && partyId!='Sender' 
                        && partyId!='SenderDeptMember'
                        && partyId!='NodeUserDeptMember'
                        && fn:indexOf(partyId, 'SenderVjoin') eq -1
                        && fn:indexOf(partyId, 'NodeUserVjoin') eq -1
                        && fn:indexOf(partyId, 'SenderSVjoin') eq -1
                        && fn:indexOf(partyId, 'NodeUserSVjoin') eq -1
                        && partyId!='SenderSuperDeptDeptMember'
                        && partyId!='NodeUserSuperDeptDeptMember' 
                        && partyId!='SenderReciprocalRoleReporter'
                        && partyId!='NodeUserReciprocalRoleReporter'}">
                <c:if test="${ rup==null || rup=='1' || rup=='-1' || 'null'==rup || 'undefined'==rup || ''==rup}">
                <tr>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.designer.node.matchType")}:</label></th>
                <td width="140" class="padding_l_5" colspan="2">
                        <c:choose>
                        <c:when test="${isAccountRole=='true' || isAccountRole==true}">
                            ${ctp:i18n("workflow.designer.node.accountrole.autoup.label")}
                        </c:when>
                        <c:otherwise>
                          ${ctp:i18n("workflow.designer.node.role.autoup.label")}
                        </c:otherwise>

                    </c:choose>
                </td>
                </tr>
                </c:if> 
            </c:if>
            <%--部门主管/分管角色匹配范围 --%>
            <c:if test="${isShowRoleScope && fn:indexOf(partyId, 'SenderVjoin') eq -1 && fn:indexOf(partyId, 'NodeUserVjoin') eq -1 && fn:indexOf(partyId, 'SenderSVjoin') eq -1 && fn:indexOf(partyId, 'NodeUserSVjoin') eq -1}">
                <c:if test="${rScopeDesc ne null && rScopeDesc ne ''}">   
                <tr>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n('workflow.designer.node.matchScope')}<%-- 匹配范围 --%>:</label></th>
                <td width="140" class="padding_l_5" colspan="2">
                     ${ctp:toHTML(rScopeDesc)}
                </td>
                </tr>  
                </c:if>
            </c:if>
            <c:if test="${partyType!='user'&& isTemplete}">
            <c:if test="${ fn:indexOf(partyId, 'SenderVjoin') ne -1 || fn:indexOf(partyId, 'NodeUserVjoin') ne -1 || fn:indexOf(partyId, 'SenderSVjoin') ne -1 || fn:indexOf(partyId, 'NodeUserSVjoin') ne -1}">
	            <c:if test="${ rup==null || rup=='1' || rup=='-1' || 'null'==rup || 'undefined'==rup || ''==rup}">
	            <tr>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.designer.node.matchType")}:</label></th>
                <td width="140" class="padding_l_5" colspan="2">
                        <c:choose>
                        <c:when test="${isAccountRole=='true' || isAccountRole==true}">
                            ${ctp:i18n("workflow.designer.node.accountrole.autoup.label")}
                        </c:when>
                        <c:otherwise>
                          ${ctp:i18n("workflow.designer.node.role.autoup.label")}
                        </c:otherwise>

                    </c:choose>
                </td>
                </tr>
                </c:if>
            </c:if>
            <tr>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.designer.node.nouser.action.label")}:</label></th>
                <td width="140" class="padding_l_5" colspan="2">
                <c:if test="${na=='0' || na=='-1' || na=='null' || na=='' || na=='undefined'}">${ctp:i18n('workflow.designer.node.nouser.action.label0')}</c:if>
                <c:if test="${na=='2' }">
                    ${ctp:i18n('workflow.designer.node.nouser.action.label2')}
                    <c:if test="${na_i=='1' && appName =='form'}">
                     &nbsp;${ctp:i18n('workflow.node.ignoreBlank')}<!--忽略表单必填项-->
                    </c:if>
                    <c:if test="${na_b=='1' }">
                    &nbsp;${ctp:i18n('workflow.node.asBlankNode')}<!--视为空节点-->
                    </c:if>
                </c:if>
                </td>
            </tr>
            </c:if>
            <c:if test="${'start' ne nodeId}">
            <tr><%-- 执行模式，四种：单人、多人、全体、竞争，很简单的键值对逻辑 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("node.process.mode")}:</label></th>
                <td width="140" class="padding_l_5">
                    <c:choose>
                        <c:when test="${processMode eq 'all'}">${ctp:i18n("node.all.mode")}</c:when>
                        <c:when test="${processMode eq 'competition' || processMode eq '[competition]'}">${ctp:i18n("node.competition.mode")}</c:when>
                        <c:when test="${processMode eq 'multiple'}">${ctp:i18n("node.multiple.mode")}</c:when>
                        <c:when test="${processMode eq 'single'}">${ctp:i18n("node.single.mode")}</c:when>
                    </c:choose>
                </td>
                <td></td>
            </tr>
            </c:if>
            <tr><%-- 节点状态，简单输出 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("node.state")}:</label></th>
                <td width="140" class="padding_l_5">
                    <c:choose>
                        <c:when test="${state eq '1' }">${ctp:i18n("node.state.1.common")}</c:when>
                        <c:when test="${state eq '2' }">${ctp:i18n("node.state.2.already")}</c:when>
                        <c:when test="${state eq '3' }">${ctp:i18n("node.state.3.complete")}</c:when>
                        <c:when test="${state eq '4' }">${ctp:i18n("node.state.4.cancel")}</c:when>
                        <c:when test="${state eq '5' }">${ctp:i18n("node.state.6.stop")}</c:when>
                        <c:when test="${state eq '6' }">${ctp:i18n("node.state.6.stop")}</c:when>
                        <c:when test="${state eq '7' }">${ctp:i18n("node.state.7.zcdb")}</c:when>
                        <c:when test="${state eq '41' }">${ctp:i18n("node.state.41.pending")}</c:when>
                        <c:when test="${state eq '61' }">${ctp:i18n("node.state.61.pending")}</c:when>
                    </c:choose>
                </td>
                <td></td>
            </tr>
            <tr><%-- 节点权限，简单输入 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.nodeProperty.setting.policy")}:</label></th>
                <td width="140" id="nodePolicyLabel" class="padding_l_5">${ctp:toHTML(nodePolicy)}</td>
                <td height="20" width="90" align="right">
                <c:if test="${disable2==true}">
                <a class="color_blue" href="javascript:void(0)" onClick="policyExplain();return false;">[${ctp:i18n("workflow.nodeProperty.setting.policy.explain")}]</a>
                </c:if>
                </td>
            </tr>
         </table>
    </div>
</fieldset>
<fieldset class="margin_10"><%-- 节点时间 --%>
    <legend>${ctp:i18n("workflow.nodeProperty.time")}</legend>
    <div class="form_area relative margin_l_10">
        <table border="0" cellspacing="0" cellpadding="0" width="100%">
            <tr><%-- 收到时间，年月日时分秒，19位标准时间，简单输出 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.nodeProperty.time.receivetime")}:</label></th>
                <td width="140" class="padding_l_5">
                    <c:if test="${empty receiveTime}">
                        ${ctp:i18n("common.default") }
                    </c:if>
                    ${receiveTime}
                </td>
                <td width="90"></td>
            </tr>
            <tr><%-- 处理时间，如果没有的话，显示为无，直接显示就行了 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.nodeProperty.time.dealtime")}:</label></th>
                <td width="140" class="padding_l_5">
                    <c:if test="${empty completeTime}">
                        ${ctp:i18n("common.default") }
                    </c:if>
                    ${completeTime}
                </td>
                <td width="90"></td>
            </tr>
            <tr><%-- 处理期限，如果没有的话，显示为无。这个逻辑貌似有点复杂，居然还使用了自定义标签 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.nodeProperty.time.deadline")}:</label></th>
                <td width="140" class="padding_l_5">
                    ${deadLine }
                </td>
                <td width="90"></td>
            </tr>
            <c:if test="${dealTime ne '0'}"><tr><%-- 处理期限到，只有处理期限存在的情况才显示该选项。几个if else if而已。 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.nodeProperty.time.deadline.arrived")}:</label></th>
                <td width="140" class="padding_l_5">
                    <c:choose>
                        <c:when test="${dealTermType eq '0' }">${ctp:i18n("workflow.nodeProperty.time.deadline.arrived.do0")}</c:when>
                        <c:when test="${dealTermType eq '1' }">${ctp:i18n("workflow.nodeProperty.time.deadline.arrived.do1")}${dealTermUserName }</c:when>
                        <c:when test="${dealTermType eq '2' }">${ctp:i18n("workflow.nodeProperty.time.deadline.arrived.do2")}</c:when>
                        <c:otherwise>${ctp:i18n("workflow.nodeProperty.time.deadline.arrived.do0")}</c:otherwise>
                    </c:choose>
                </td>
                <td width="90"></td>
            </tr></c:if>
            <tr><%-- 提前提醒时间，这个逻辑也有点复杂，居然也使用了自定义标签。这他奶奶的用得着自定义标签吗？ --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.nodeProperty.time.advanceremindtime")}:</label></th>
                <td width="140" class="padding_l_5">
                    ${remindTimeString }
                </td>
                <td width="90"></td>
            </tr>
            <tr> <%-- 是否超期 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.nodeProperty.time.isovertoptime")}:</label></th>
                <td width="140" class="padding_l_5">${isOvertopTime }</td>
                <td width="90" style="display: none"><a class="color_blue" href="javascript:void(0)" onClick="policyExplain();return false;">[${ctp:i18n("workflow.nodeProperty.setting.policy.explain")}]</a></td>
            </tr>
            <tr style="display:${(cycleRemindTime==null || cycleRemindTime=='' || cycleRemindTime=='null' || cycleRemindTime=='undefined' || cycleRemindTime=='0' || cycleRemindTime=='-1') ? 'none' : ''}">
            	<th style="line-height: 24px;" nowrap="nowrap" width="80"></th>
            	<td width="150" class="padding_l_5" colspan="2">${ctp:i18n('node.policy.cycle.remind.set.pre')}${cycleRemindTimeString }${ctp:i18n('node.policy.cycle.remind.set.end')}</td>
            </tr>
         </table>
    </div>
</fieldset>
<c:if test="${not empty display}">
<fieldset class="margin_10"><%-- 表单绑定，只有display不为空的时候 --%>
    <legend>${ctp:i18n("workflow.nodeProperty.formBind")}</legend>
    <div class="form_area relative margin_l_10">
        <table border="0" cellspacing="0" cellpadding="0" width="100%">
            <tr>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.nodeProperty.formAndOperation")}:</label></th>
                <td width="230" class="padding_l_5">${display}</td>
            </tr>
            <c:forEach items="${mutilDisplayList }" var="mutilDisplay">
                <tr>
                    <th style="line-height: 24px;" nowrap="nowrap" width="80"></th>
                    <td width="230" class="padding_l_5">${mutilDisplay[1] }</td>
                </tr>
            </c:forEach>
         </table>
    </div>
</fieldset>
</c:if>
<c:if test="${isFromTemplete or isTemplete}"><%-- 处理说明按钮 --%><div class="margin_5">
	<table><tr><td width="100%"></td><td nowrap="nowrap">
    <a href="javascript:void(0)"  onclick="dealExplain('${desc}');return false;" class="font_size12 color_blue" style="bottom:0;right:10px;">[${ctp:i18n("workflow.nodeProperty.dealExplain")}]</a>
	</td></tr></table>
</div></c:if>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowShowNodeProperty_js.jsp" %>
</body>
</html>