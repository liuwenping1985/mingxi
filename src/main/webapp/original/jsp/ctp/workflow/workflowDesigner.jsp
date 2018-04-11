<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js.jsp" %>
<html class="h100b over_hidden">
<head>
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-store"> 
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${dialogTitle}</title>
<style type="text/css">
.workflowOperatePanel20{
    height:30px;
    /* width: 280px;
    position: absolute; */
    font-size: 12px;
    top: 0px;
    right: 0px;
}
.workflowOperatePanel50{
    height:46px;
    width: 280px;
    position: relative;
    font-size: 12px;
}
#workflowOperatePanel ul{
    list-style: none;
}
#workflowOperatePanel li{
    list-style-type: none;
    float: right;
    width: 70px;
    margin-top: 5px;
    padding: 5px 5px 5px 5px;
    text-align: right;
}
</style>
</head>
<c:choose>
<c:when test="${isEdoc=='true' }">
<c:set var="bodyOnUnloadFn" value="finish()"/>
</c:when>
<c:otherwise>
<c:set var="bodyOnUnloadFn" value="onUnloadEvent()"/>
</c:otherwise>
</c:choose>
<body onkeydown="listenerKeyESC();" onunload="${bodyOnUnloadFn}" marginheight="0" marginwidth="0" class="over_hidden h100b" style="background: white;">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
    <td height="36px;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="80%">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <c:if test="${scene == '0' || scene == '1' }">
<!-- 流程图操作帮助信息部分：开始 -->
<tr><td  class="padding_10" colspan="3" style="font-size: 12px;font-weight: normal;">${editHelp }</td></tr>
<!-- 流程图操作帮助信息部分：结束 -->
</c:if>
<c:if test="${scene == '6'}">
<tr><td colspan="3" style="font-size: 12px;font-weight: normal;" class="padding_5">
${ctp:i18n('workflow.special.stepback.label1')}
</td></tr>
<tr><td colspan="3" style="font-size: 12px;font-weight: normal;" class="padding_5">
<font color='red'>${ctp:i18n('workflow.special.stepback.label2')}</font>
</td></tr>
</c:if>
                    </table>
                </td>
                    <c:choose>
                        <c:when test="${scene == '6'}">
                  <td width="20%" align="right" nowrap="nowrap" height="46px">
                        <div id="workflowOperatePanel" class="workflowOperatePanel50">
                        </c:when>
                        <c:otherwise>
                  <td width="20%" align="right" nowrap="nowrap" height="30px">
                        <div id="workflowOperatePanel" class="workflowOperatePanel20">
                        </c:otherwise>
                    </c:choose>
                      <table cellspacing="0" cellpadding="0" border="0">
                        <tr>
<%--                         <td width="30px"  nowrap="nowrap" align="left" class="padding_5" >
                        <a id="showResetWorkflowDiagram"  href="#" onclick="showResetWorkflowDiagram();">${ctp:i18n('workflow.designer.menupanel.reset.title')}</a>
                        </td> --%>
                        <td align="left" class="padding_5">
                        <img id="showWorkflowBigger" onclick="showWorkflowBiggerFunction();" style="cursor:pointer;display:none;" title="${ctp:i18n('workflow.designer.menupanel.bigger.title')}" src="<c:url value='/common/images/workflow_big.png' />" >
                        </td>
                        <td align="left" class="padding_5">
                        <img id="showWorkflowSmaller" onclick="showWorkflowSmallerFunction();"  style="cursor:pointer;display:none;" title="${ctp:i18n('workflow.designer.menupanel.smaller.title')}" src="<c:url value='/common/images/workflow_small.png' />" >
                        </td>
                        <td class="padding_5">
                          <img style="cursor:pointer;display:block;" id="dragModeDiagramWorkflowDiagram" onclick="showDragModeWorkflowDiagram();"  title="${ctp:i18n('workflow.designer.menupanel.dragmode.title')}" src="<c:url value='/common/images/mode_drag.png' />" >
                        </td>
                        <td class="padding_5">
                            <img style="cursor:pointer;display:block;" id="scrollModeWorkflowDiagram" onclick="showScrollModeWorkflowDiagram();" title="${ctp:i18n('workflow.designer.menupanel.scrollmode.title')}" src="<c:url value='/common/images/mode_scroll_checked.png' />" >
                        </td>
                        <td class="padding_5" align="left"><img style="cursor:pointer;display:block" id="twoSeeMode" modeType="1"  onclick="toggleTwoSeeMode();" style="cursor:pointer;"  title="${ctp:i18n('workflow.designer.menupanel.size.window.title')}" src="<c:url value='/common/images/size_window.png' />" ></td>
                        <c:if test="${isShowAdvancedSetting == 'true' && scene == '0'}">
                        	<td class="padding_5" align="left">[<a href="#" onclick="openEventAdvancedSetting();">${ctp:i18n('workflow.advance.event.name')}</a>]</td>
                        </c:if>
                        <td class="padding_5">
                          <img style="cursor:pointer;display:none;height:26px;" id="exportWorkflowDiagramBtn" onclick="exportWorkflowDiagramFunc();"  title="${ctp:i18n('workflow.designer.menupanel.export.title')}" src="<c:url value='/common/workflow/images/335_ExportImage.png' />" >
                        </td>
                        <td width="5px"  nowrap="nowrap" class="padding_5" >
                        </td>
                        </tr>
                      </table>
                    </div>
                </td>
            </tr>
        </table>
    </td>
</tr>

<!-- flash流程图部分：开始 -->
<tr>
    <td colspan="3" valign="top">
      <div id="flashContainer" style="width:100%; height:100%">
        <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="860" height="600" id="monitor" align="middle">
            <param name="allowScriptAccess" value="always" />
            <param name="movie" value="<c:url value='/common/workflow/monitor.swf${ctp:resSuffix()}' />" />
            <param name="menu" value="false" />
            <param name="quality" value="low" />
            <param name="bgcolor" value="#ffffff" />
            <param name="wmode" value="transparent" />
            <param name="allowScriptAccess" value="always" />
            <!-- 非IE浏览器:开始 -->
            <script type="text/javascript">
                if(isNewBrowser()){
                  //IE11需要走这里
                  document.write("<embed src=\"<c:url value='/common/workflow/monitor.swf${ctp:resSuffix()}' />\" quality=\"low\" bgcolor=\"#ffffff\" width=\"860\" height=\"600\" name=\"monitor\" wmode=\"transparent\" align=\"middle\" allowScriptAccess=\"always\" type=\"application/x-shockwave-flash\" />");
                }
            </script>
            <!-- 非IE浏览器:结束 -->
        </object>
      </div>
    </td>
</tr>
<!-- flash流程图部分：结束 -->
<c:if test="${(scene != '2' && scene != '3' ) || isModalDialog=='true'}">
<!-- 流程规则部分：开始 -->
<c:if test="${scene == '0'}">
<tr height="18">
    <td width="80%" align="left" height="18" colspan="2" nowrap="nowrap">
    <div id="ruleApanMsg" style="font-size: 12px;font-weight: normal;display: none;width: 100%"><a href="javascript:showRuleAndResetFlash();" class="color_blue">${ctp:i18n('workflow.designer.useinstructions.title')}</a>:</div>
    <div id='ruleApan' style="font-size: 12px;font-weight: normal;"><a href="javascript:showRuleAndResetFlash();" class="color_blue">${ctp:i18n('workflow.designer.useinstructions.title')}</a></div>
    </td>
    <td width="20%" align="right" height="18" >
    <div id="ruleApanCloseImage" style="display: none" onclick="showRuleAndResetFlash()"><span class="ico16 revoked_process_16"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
    </td>
</tr>
<tr id="ruleTR" style="display:none;">
    <td colspan="3" height="64" class="bg-advance-middel">
        <div>
        <textarea rows="5" id="ruleContent" style="width: 99%" class="input-100per" inputName="${ctp:i18n('workflow.designer.useinstructions.title')}"></textarea>
        </div>
    </td>
</tr>
</c:if>
<!-- 流程规则部分：结束 -->
<c:if test="${isModalDialog=='false' && appName!='office'}">
<!-- 流程按钮操作部分：开始 -->
<tr height="42" id="workflowButtonTR">
    <td width="20%">&nbsp;</td>
    <td align="right">
    <!-- 设计态:编辑模版流程 -->
    <c:if test="${scene == '0'}">
    <input id="confirmButton" name="confirmButton" type="button" onclick="saveWFContent()" value="${ctp:i18n('workflow.designer.page.button.ok')}" class="button-style">
    <input id= cancelButton" id="cancelButton" type="button" onclick="window.close()" value="${ctp:i18n('workflow.designer.page.button.cancel')}" class="button-style button-space">
    </c:if>
    <!-- 设计态:自由流程 -->
    <c:if test="${scene == '1'}">
    <input id="confirmButton" name="confirmButton" type="button" onclick="saveWFContent()" value="${ctp:i18n('workflow.designer.page.button.ok')}" class="button-style">
    <input id= cancelButton" id="cancelButton" type="button" onclick="window.close()" value="${ctp:i18n('workflow.designer.page.button.cancel')}" class="button-style button-space">
    </c:if>
    <!-- 设计态:查看模版流程 
    <c:if test="${scene == '2' && isModalDialog=='true'}">
    <input type="button" onclick="window.close()" value="${ctp:i18n('workflow.designer.page.button.close')}" class="button-style button-space">
    </c:if>
    <c:if test="${scene == '3' && isModalDialog=='true'}">
    <input type="button" onclick="window.close()" value="${ctp:i18n('workflow.designer.page.button.close')}" class="button-style button-space">
    </c:if>
            运行态:查看 -->
    <!-- 运行态:督办 -->
    <c:if test="${scene == '4'}">
    <input id="modifyButton" type="button" onclick="modify()" value="${ctp:i18n('workflow.designer.page.button.modify')}" style="display:none" class="button-style">
    <a id="submitButton" onclick="saveSuperviousContent()" class="common_button common_button_emphasize">${ctp:i18n('workflow.designer.page.button.ok')}</a>
    <a onclick="finish()" class="common_button common_button_gray">${ctp:i18n('workflow.designer.page.button.close')}</a>
    </c:if>
    <!-- 运行态:管控 -->
    <c:if test="${scene == '5'}">
    <input id="modifyButton" type="button" onclick="modify()" value="${ctp:i18n('workflow.designer.page.button.modify')}" class="button-style button-space">
    <input id="submitButton" type="button" onclick="saveWFContent()" value="${ctp:i18n('workflow.designer.page.button.ok')}" style="display:none" class="button-style">
    <input id="repealButton" type="button" onclick="repealWorkflow('${param.appEnumStr }', '${param.newflowType}')" value="${ctp:i18n('workflow.designer.page.button.repeal')}" class="button-style button-space">
    <input id="stopButton" type="button" onclick="stopWorkflow('${param.appEnumStr }', '${param.newflowType}')" value="${ctp:i18n('workflow.designer.page.button.stop')}" class="button-style button-space">
    <input id="closeButton" type="button" onclick="window.close()" value="${ctp:i18n('workflow.designer.page.button.close')}" class="button-style button-space">
    </c:if>
    </td>
    <td width="20%">&nbsp;</td>
</tr>
<!-- 流程按钮操作部分：结束 -->
</c:if>
</c:if>
<c:if test="${scene == '6'}">
<!-- 指定回退选项部分：开始 -->
<tr id="theStepBackNodeTR" class="display_none" style="height: 100%">
    <td colspan="3" height="35" style="font-size: 12px;font-weight: normal;" valign="top">
        <table align="center" width="95%" border="0" style="table-layout:fixed;">
            <tr>
                <td id="theStepBackNodeInfo" align="left" class="padding_5 text_overflow"  nowrap="nowrap" >${ctp:i18n("workflow.label.afterReturn")} <%-- 被回退节点处理后： --%></td>
            </tr>
            <tr>
                <td>
                    <table width="100%" border="0" style="<%--table-layout:fixed;--%>">
                        <td id="theStepBackNodeInfoAction" align="left"  class="padding_5 text_overflow" width="10%"  nowrap="nowrap">${ctp:i18n("workflow.label.afterReturnAction")}<%-- 被回退节点处理后动作：--%></td>
                        <c:choose>
                            <c:when test="${processState==2 || processState==3 || processState==5 || stepBackCount>0}">
                                <c:if test="${showReGo == 'true' }">
                                    <td  class="padding_5" width="10%" nowrap="nowrap"><label class="margin_r_10 hand" for="rego"><input onclick="onClickToMe(0);"  type="radio" value="0" name="handleStyle" id="rego" disabled="disabled">${ctp:i18n('workflow.special.stepback.label6')}</label></td>
                                </c:if>
                                <c:if test="${showToMe == 'true' }">
                                    <td  class="padding_5" width="10%" nowrap="nowrap" id="tomeTdId" onclick="showStepBackMsg();"><label class="margin_r_10 hand" for="tome" id="tomelabelId"><input  onclick="onClickToMe(1);"  type="radio" value="1" name="handleStyle" id="tome" checked="checked">${ctp:i18n('workflow.special.stepback.label7')}</label></td>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${showReGo == 'true' }">
                                    <td  class="padding_5" width="10%" nowrap="nowrap"><label class="margin_r_10 hand" for="rego"><input onclick="onClickToMe(0);" type="radio" value="0" name="handleStyle" id="rego" checked="checked">${ctp:i18n('workflow.special.stepback.label6')}</label></td>
                                </c:if>
                                <c:if test="${showToMe == 'true' && showReGo == 'true' }">
                                    <td  class="padding_5" width="10%" nowrap="nowrap" id="tomeTdId" onclick="showStepBackMsg();"><label class="margin_r_10 hand" for="tome" id="tomelabelId"><input onclick="onClickToMe(1);" type="radio" value="1" name="handleStyle" id="tome">${ctp:i18n('workflow.special.stepback.label7')}</label></td>
                                </c:if>
                                <c:if test="${showToMe == 'true' && showReGo != 'true' }">
                                    <td  class="padding_5" width="10%" nowrap="nowrap" id="tomeTdId" onclick="showStepBackMsg();"><label class="margin_r_10 hand" for="tome" id="tomelabelId"><input onclick="onClickToMe(1);" type="radio" value="1" name="handleStyle" id="tome" checked="checked">${ctp:i18n('workflow.special.stepback.label7')}</label></td>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                        <td  class="padding_5" id="tomeTipInfo" width="70%" align="left"></td>
                    </table>
                </td>
            </tr>
        </table>
    </td>   
</tr>
<!-- 指定回退选项部分：结束 -->
</c:if>
</table>
<div id="NewflowDIV" style="display: none"></div>
<form id="downLoadForm" target="downLoadIframe" style="display:none" method="post">
    <input name="method" value="exportDiagram">
    <input name="data" value="">
</form>
<iframe id="downLoadIframe" name="downLoadIframe" src="" style="display:none"></iframe>
</body>
<script type="text/javascript">
$(document).ready(function() {
    /* var traceSpanArea = parent.document.getElementById("traceSpanArea");
    if(_traceInput){
    	var _rego = document.getElementById("rego");
    	if(_rego && _rego.checked){  //不存在流程重走的时候或者没有选中的时候设置为灰色的。
    		traceSpanArea
    	}
    } */
    if(navigator.userAgent.toLowerCase().indexOf("macintosh")!=-1&&navigator.userAgent.toLowerCase().indexOf("safari")!=-1){
        getA8Top().$("iframe").css("margin-left","1px")
    }
});
</script>
</html>