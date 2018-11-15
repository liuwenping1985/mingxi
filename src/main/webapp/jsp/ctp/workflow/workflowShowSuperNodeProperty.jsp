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
</style>
</head>
<body>
<fieldset class="margin_10"><%-- 属性设置 --%>
    <legend>${ctp:i18n("workflow.nodeProperty.setting")}</legend>
    <div class="form_area relative margin_l_10">
        <table border="0" cellspacing="0" cellpadding="0" width="100%" class="my_th">
            <tr>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label" for="text">${ctp:i18n("workflow.nodeProperty.setting.nodeName")}:</label></th>
                <td width="140" colspan="2" class="padding_l_5" style="word-break:break-all">${ctp:toHTML(nodeName)}</td>
            </tr>
            <c:if test="${'start' ne nodeId}">
            <tr><%-- 执行模式，四种：单人、多人、全体、竞争，很简单的键值对逻辑 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("node.process.mode")}:</label></th>
                <td width="140" class="padding_l_5">
                    <c:choose>
                        <c:when test="${processMode eq '0'}">${ctp:i18n('workflow.commonpage.processmode.nozusai')}</c:when>
                        <c:when test="${processMode eq '1'}">${ctp:i18n('workflow.commonpage.processmode.zusai')}</c:when>
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
<fieldset class="margin_10"><%-- 流转设置 --%>
    <legend>${ctp:i18n('workflow.superTolerantModel.label') }</legend>
    <div class="form_area relative margin_l_10">
        <table border="0" cellspacing="0" cellpadding="0" width="100%">
            <tr><%-- 收到时间，年月日时分秒，19位标准时间，简单输出 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.nodeProperty.time.receivetime")}:</label></th>
                <td width="200" class="padding_l_5">
                    <c:if test="${empty receiveTime}">
                        ${ctp:i18n("common.default") }
                    </c:if>
                    ${receiveTime}
                </td>
                <td width="90"></td>
            </tr>
            <tr><%-- 处理时间，如果没有的话，显示为无，直接显示就行了 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.nodeProperty.time.dealtime")}:</label></th>
                <td width="200" class="padding_l_5">
                    <c:if test="${empty completeTime}">
                        ${ctp:i18n("common.default") }
                    </c:if>
                    ${completeTime}
                </td>
                <td width="90"></td>
            </tr>
            <c:if test="${isShowActionConfigUrl eq true }">
                <tr>
                    <td width="28%" height="28" align="right">${ctp:i18n('workflow.supernode.action.config.label') }:</td>
                    <td width="50%" height="28" colspan="2" align="left">
                    <a class="color_blue margin_l_5" href="#" onclick="showSuperNodeActionConfigPage();" style="text-decoration:none">
                    ${ctp:i18n('workflow.supernode.action.config.show') }
                    </a> 
                    </td>
                    <td align="left" width="22%" nowrap="nowrap"></td>
                </tr>
             </c:if>
            <tr><%-- 容错模式 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.tolerantModel.label")}:</label></th>
                <td width="140" class="padding_l_5">
                    <c:choose>
                        <c:when test="${tolerantModel eq '1' }">${ctp:i18n("workflow.tolerantModel.ignore")}</c:when>
                        <c:when test="${tolerantModel eq '0' }">${ctp:i18n("workflow.tolerantModel.waitPerson")}</c:when>
                    </c:choose>
                </td>
                <td width="90"></td>
            </tr>
            <tr><%-- 人工干预人员 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.superPerson.label")}:</label></th>
                <td width="140" class="padding_l_5">
                    ${dealTermUserName }
                </td>
                <td width="90"></td>
            </tr>
         </table>
    </div>
</fieldset>
<fieldset class="margin_10"><%-- 运行情况 --%>
    <legend>${ctp:i18n("workflow.label.actionResult")} <%-- 动作执行情况 --%></legend>
    <div class="form_area relative margin_l_10">
        <table border="0" cellspacing="0" cellpadding="0" width="100%">
            <tr><%-- 收到时间，年月日时分秒，19位标准时间，简单输出 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.label.callTime")}<%-- 调用时间 --%>:</label></th>
                <td width="140" class="padding_l_5">
                    ${invokeTime}
                </td>
                <td width="90"></td>
            </tr>
            <tr><%-- 处理时间，如果没有的话，显示为无，直接显示就行了 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.label.returnTime")}<%-- 返回时间 --%>:</label></th>
                <td width="140" class="padding_l_5">
                    ${returnTime }
                </td>
                <td width="90"></td>
            </tr>
            <tr><%-- 容错模式 --%>
                <th style="line-height: 24px;" nowrap="nowrap" width="80"><label class="my_label"  for="text">${ctp:i18n("workflow.label.returnMessage")}<%-- 返回消息 --%>:</label></th>
                <td width="140" class="padding_l_5">
                    ${control.returnMsg }
                </td>
                <td width="90"></td>
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
<script type="text/javascript">
	var desArr = new Array();
	//暂时将所有节点权限的描述设成一个值
	//var description = "";
	//$("#content").val(description);
	//document.getElementById("checkPolicyDiv").innerHTML = document.getElementById("checkPolicyHTML").innerHTML;
	var paramObjs= window.parentDialogObj['workflow_dialog_showNodeProperty_Id'].getTransParams();
	var dealDesc= paramObjs.desc;
	function policyExplain(){
	    try{
	        var dialog = $.dialog({
	        url : '<c:url value="${nodePolicyExplainUrl}"/>',
	        transParams : window,
	        width : 295,
	        height : 275,
	        title : '${ctp:i18n("node.policy.explain")}',
	        buttons : [
	            {
	                text : '${ctp:i18n("common.button.close.label") }',
	                handler : function(){
	                    dialog.transParams = null;
	                    dialog.close();
	            }}
	        ],
	        targetWindow: getCtpTop()
	        });
	    }catch(e){//兼容公文老代码
	        var dialog = $.dialog({
	        url : '<c:url value="${nodePolicyExplainUrl }"/>',
	        transParams : window,
	        width : 295,
	        height : 275,
	        title : '${ctp:i18n("node.policy.explain")}',
	        buttons : [
	            {
	                text : '${ctp:i18n("common.button.close.label") }',
	                handler : function(){
	                    dialog.transParams = null;
	                    dialog.close();
	            }}
	        ],
	        targetWindow: window.parent
	        });
	    }
	}
	function dealExplain(desc){
	    var dialog = $.dialog({
	        url : '<c:url value="/workflow/designer.do?method=showDealExplain"/>&desc='+unescape(dealDesc),
	        width : 295,
	        height : 220,
	        title : '${ctp:i18n("workflow.designer.node.deal.explain")}',
	        buttons : [
	            {
	                text : '${ctp:i18n("common.button.close.label") }',
	                handler : function(){
	                    dialog.close();
	            }}
	        ],
	        targetWindow: getCtpTop()
	    });
	}
	
	function escapeSpecialChar(str){
      if(!str){
          return str;
      }
      str= str.replace(/\&/g, "&amp;").replace(/\</g, "&lt;").replace(/\>/g, "&gt;").replace(/\"/g, "&quot;");
      str= str.replace(/\'/g,"&#039;").replace(/"/g,"&#034;");
      return str;
    }

	function showSuperNodeActionConfigPage(){
	  var myUrl= _ctxPath + escapeSpecialChar("${actionConfigUrl}");
	  <c:if test="${isOutsideUrl eq true}">
	  myUrl= escapeSpecialChar("${actionConfigUrl}");
	  </c:if>
	  var dialog = $.dialog({
	    id:"workflow_dialog_suprnode_action_id",
	    url: myUrl,
	    title : "${actionConfigTitle}",
	    width : '${actionConfigUrlWidth}',
	    height: '${actionConfigUrlHeight}',
	    targetWindow:getCtpTop(),
	    buttons : [ {
	        text : $.i18n("common.button.close.label"),
	        handler : function() {
	            dialog.close();
	        }
	    }]
	});
	}
</script>
</body>
</html>