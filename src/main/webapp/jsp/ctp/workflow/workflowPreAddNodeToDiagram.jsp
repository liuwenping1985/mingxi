<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
    <title>${ctp:i18n("workflow.insertPeople.title")}</title>
    <%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
</head>
<body class="h100b">
    <div class="form_area padding_5">
        <table border="0" cellSpacing="0" cellPadding="0" width="100%">
          <tbody><tr>
            <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("workflow.insertPeople.selectPolicy")}:</label></th>
            <td width="100%"><div class="common_selectbox_wrap">
                <select id="policySelect" name="policy">
                    <c:forEach items='${policyList}' var="nodePolicy">
                        <option value="${nodePolicy.value}" ${defaultPolicyId==nodePolicy.name || defaultPolicyId==nodePolicy.value?"selected":""}>
                        <%--<c:if test="${nodePolicy.type == 0}">
                            ${ctp:i18n(nodePolicy.label)}
                        </c:if>
                        <c:if test="${nodePolicy.type == 1}">${nodePolicy.name}</c:if>--%>
                        ${nodePolicy.name}
                        </option>
                    </c:forEach>
                </select>
            </div></td>
            <td nowrap="nowrap" rowspan="3" valign="top"><a href="javascript:void(0)" onclick="policyExplain()" class="display_inline-block margin_t_10">&nbsp;[${ctp:i18n("node.policy.explain")}]</a></td>
          </tr><c:if test="${param.isForm eq true}">
          <tr height="32" id="premissionTr">
                <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("workflow.insertPeople.form.operation")}:</label></th>
                <td colspan="2"><div class="common_radio_box clearfix">
                    <c:if test="${isFormReadonly ne true}">
                        <label for="formOperationPolicy1">
                            <input class="radio_com" type="radio" id="formOperationPolicy1" name="formOperationPolicy" value="0">${ctp:i18n("workflow.insertPeople.form.sameToCurrentNode")}
                        </label>
                    </c:if>
                    <label for="formOperationPolicy2">
                        <input class="radio_com" id="formOperationPolicy2" type="radio" name="formOperationPolicy" value="1" checked>${ctp:i18n("common.readonly")}
                    </label>
                </div></td>
            </tr>
          </c:if><tr>
            <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("workflow.insertPeople.selectPeople")}:</label></th>
            <td><div class="common_txtbox_wrap">
                <input id="collSelectPeopleInput" name="collSelectPeopleInput" readonly value="<${ctp:i18n('workflow.insertPeople.urgerAlt')}>" class="validate" validate="type:'string',notNull:true,isDeaultValue:true,deaultValue:'<${ctp:i18n('workflow.insertPeople.urgerAlt')}>',errorMsg:'${ctp:i18n('workflow.insertPeople.selectPeople')}'">
            </div></td>
          </tr>
          <tr>
            <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("workflow.insertPeople.processMode.label")}:</label></th>
            <td nowrap="nowrap">
                <div class="common_radio_box clearfix">
                    <label class="margin_r_10 hand" for="processMode_serial">
                        <input id="processMode_serial" class="radio_com" name="process_mode" value="1" type="radio">${ctp:i18n("workflow.insertPeople.serial")}
                    </label>
                    <label class="margin_r_10 hand" for="processMode_parallel">
                        <input id="processMode_parallel" checked="checked" class="radio_com" name="process_mode" value="2" type="radio">${ctp:i18n("workflow.insertPeople.parallel")}
                    </label>
                    <label class="margin_r_10 hand" for="processMode_nextparallel">
                        <input id="processMode_nextparallel" class="radio_com" name="process_mode" value="5" type="radio">${ctp:i18n("workflow.insertPeople.nextparallel")}
                    </label>  
                </div>
            </td>
          </tr>
          <tr id="nodeProcessMode" class="hidden">            
                <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("node.process.mode")}:</label></th>
                <td><div class="common_radio_box clearfix">
                    <label for="all_mode">
                        <input type="radio" name="node_process_mode" id="all_mode" value="all" class="radio_com" checked="checked">
                        ${ctp:i18n("node.all.mode")}
                    </label>
                    <label for="competition_mode">
                        <input type="radio" name="node_process_mode" id="competition_mode" class="radio_com" value="competition">
                        ${ctp:i18n("node.competition.mode")}
                    </label>
                </div></td>
            </tr>
            
          <tr>
            <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('workflow.designer.node.cycle.label')}:</label></th>
            <td><div class="common_selectbox_wrap"><%--
                <select id="dealTerm" name="dealTerm">
                    <c:forEach items='${nodeDeadlineTimeList}' var="obj">
                        <option value="${obj.value}">${obj.name}</option>
                    </c:forEach>
                </select>--%>
                <select id="dealTerm" name="dealTerm" ${disable0}
                            class="codecfg" codecfg="codeId:'collaboration_deadline',defaultValue:'0'">
		    	</select>
            </div></td>
          </tr>
            
          <tr id="dealTermCustomArea" style="display:none;">
            <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("workflow.designer.node.time")}:</label></th>
            <td><div class="common_txtbox_wrap">
                <input value="" id="customDealTerm" name="customDealTerm" readonly="readonly" ${disable0} type="text"  class="comp input-100per margin_l_5" comp="type:'calendar',isOutShow:true,ifFormat:'%Y-%m-%d %H:%M',showsTime:true,dateString:'${defaultDealTerm}'"/>
            </div></td>
          </tr>
          
          <tr>
            <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('workflow.designer.node.advanceremindtime')}:</label></th>
            <td><div class="common_selectbox_wrap"><%--
                <select id="remindTime" name="remindTime">
                    <c:forEach items='${nodeRemindTimeList}' var="obj">
                        <option value="${obj.value}">${obj.name}</option>
                    </c:forEach>
                </select>--%>
                <select name="remindTime" id="remindTime" 
                	class="codecfg" codecfg="codeId:'common_remind_time',defaultValue:'0'">
		    	</select>
            </div></td>
          </tr>
          </tbody>
        </table>
    </div>
<div id="policyExplainHTML" class="hidden">
    <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
        <tr>
            <td colspan="2">
                <div style="height: 28px;">
                    <textarea name="content" rows="9" cols="46" validate="maxLength"
                            inputName="${ctp:i18n('common.opinion.label')}" maxSize="2000" readonly></textarea>
                </div>  
            </td>
        </tr>   
    </table>
</div>
<script type="text/javascript" src="<%=request.getContextPath() %>/common/workflow/workflowDesigner_ajax.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowPreAddNodeToDiagram_js.jsp"%>
	if(window.parent.document.getElementById("app") && window.parent.document.getElementById("app").value == "4"){
		$("#premissionTr").hide();
	}
</script>
</body>
</html>