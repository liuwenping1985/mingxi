<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="planSummary.js.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
function OK(){ 
if(!checkStatusFrom()) {
    return false;
}
 submit_status('tab3');
 return "changeStatus";
}
</script>
<body>
<div id='tabs_body' class="common_tabs_body font_size12">
       <div id="tab1_div">
            <form id="statusform" action="/plan/plan.do?method=changeStatus" onsubmit="return false" method="post" style='margin: 0px'>
                <INPUT type='hidden' value="${planId}" name="planId" id="planId">
                <INPUT type='hidden' value="portal" name="from_source" id="from_source">
                <table width="90%" border="0"  cellspacing="0" cellpadding="0" class="sign-area" style="position:relative;left:10px;">
                    <tr height="30">
                        <td width="20%">&nbsp;</td>
                        <td width="60%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">${ctp:i18n('plan.grid.label.finishratio')}：</td>
                        <td>
                             <input type="text" style="width:80px;text-align:center" id="rate" name="rate" value="${finishRatio}" onkeyup="initByRateInput();" autocomplete="off" onpaste="return false"><strong>%</strong> 
                    </td>
                    </tr>
                    <tr height="10"><td>&nbsp;</td><td>&nbsp;</td></tr>
                <tr>
                    <td nowrap="nowrap">${ctp:i18n('plan.grid.label.status')}：</td>
                    <td>
                            <select name="planStatus" id="planStatus" style="width: 99px" onchange="initByPlanStatus();">
                                <option value='1' <c:if test="${planStatus=='1' }">selected</c:if>>${ctp:i18n('plan.execution.state.1')}</option>
                                <option value='2' <c:if test="${planStatus=='2' }">selected</c:if>>${ctp:i18n('plan.execution.state.2')}</option>
                                <option value='3' <c:if test="${planStatus=='3' }">selected</c:if>>${ctp:i18n('plan.execution.state.3')}</option>
                                <option value='4' <c:if test="${planStatus=='4' }">selected</c:if>>${ctp:i18n('plan.execution.state.4')}</option>
                                <option value='5' <c:if test="${planStatus=='5' }">selected</c:if>>${ctp:i18n('plan.execution.state.5')}</option>
                            </select>
                      </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>