<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
    String ctxPath =request.getContextPath(),  ctxServer = request.getScheme()+"://" + request.getServerName() + ":"
                    + request.getServerPort() + ctxPath;
    Locale locale = AppContext.getLocale();
%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" href="${path}/common/all-min.css">
<c:if test="${CurrentUser.skin != null}">
<link rel="stylesheet" href="${path}/skin/${CurrentUser.skin}/skin.css">
</c:if>
<c:if test="${CurrentUser.skin == null}">
<link rel="stylesheet" href="${path}/skin/default/skin.css">
</c:if>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
  var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
</script>
<script type="text/javascript" src="${path}/i18n_<%=locale%>.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/misc/Moo-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/misc/jsonGateway-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.fillform-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.code-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/common-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/v3x-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.dialog-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.comp-debug.js"></script>

<script type="text/javascript">
function openPlan(planId,sectionId){
  var toSrc = _ctxPath + "/plan/plan.do?method=initPlanDetailFrame&planId="+planId;
  var planViewdialog=$.dialog({
       id: 'showPlan',
       url: toSrc,
       width: $(getA8Top().document).width() - 100,
       height: $(getA8Top().document).height() - 100,
       title: "${ctp:i18n('plan.dialog.showPlanTitle')}",
       targetWindow:getCtpTop(),
       buttons: [{
           text: "${ctp:i18n('plan.dialog.close')}",
           handler: function () {
               var rv = planViewdialog.getReturnValue();
               planViewdialog.close();
           }
       }]
    });
}
</script>
</head>
<c:set var="width" value="240"></c:set>
<body class="h100b cardmini">
    <div id="replayPersonsdetail" class="font_size12 adapt_w font_size12 form_area people_msg"  style="height:200px;overflow-y:auto;">
        <table width="${width}" cellpadding="0" cellspacing="0" style="color:#d2d2d2">
            <tr height="20" align="center" ><td colspan="2"><font color="black">${ctp:i18n('plan.desc.replydetail.totalmember')}:${countAll } ${ctp:i18n('plan.desc.replydetail.people')}</font></td></tr>
            <tr height="20" align="center" >
                <td width="120" class="border_tb border_r"><font color="black">${ctp:i18n('plan.desc.replydetail.replyed')}：${fn:length(repliedList) } ${ctp:i18n('plan.desc.replydetail.people')}</font></td>
                <td width="120" class="border_tb"><font color="black">${ctp:i18n('plan.desc.replydetail.unreplyed')}：${fn:length(noreplyList) } ${ctp:i18n('plan.desc.replydetail.people')}</font></td>
            </tr>
            
            <tr height="138" >
                <td valign="top" class="border_r" width="${width/2}">
                    <c:if test="${empty repliedList}">
                        <li class="margin_t_5" style="text-align:left;width: 90px; overflow: hidden; display: inline-block; white-space: nowrap; text-overflow: ellipsis;">&nbsp;</li>
                    </c:if>
                    <c:forEach var="user1" items="${repliedList}" varStatus="status1">
                        <c:choose>
                            <c:when test="${status1.count>6 }">
                                <c:if test="${status1.last}">
                                    <li class="right margin_b_5 margin_r_5"><a href="javascript:openPlan('${param.planId }','${param.entityId }')"><font color="black">……${ctp:i18n('plan.desc.replydetail.detail')}</font></a></li>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <li class="margin_t_5 margin_l_10" style="text-align:left;width: 90px; overflow: hidden; display: inline-block; white-space: nowrap; text-overflow: ellipsis;">
                                    <c:if test="${user1.process == 0}">
                                        <span class='ico16 unviewed_16 margin_r_5' title="未看" style="cursor: default;"></span><font color="black">${user1.refUserName }</font>
                                    </c:if>
                                    <c:if test="${user1.process == 1}">
                                        <span class='ico16 participate_16 margin_r_5' title="已回复" style="cursor: default;"></span><font color="black">${user1.refUserName }</font>
                                    </c:if>
                                    <c:if test="${user1.process == 2}">
                                        <span class='ico16 viewed_16 margin_r_5' title="查看" style="cursor: default;"></span><font color="black">${user1.refUserName }</font>
                                    </c:if>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </td>
                <td valign="top" width="${width/2}" style="">
                    <c:if test="${empty noreplyList}">
                        <li class="margin_t_5" style="text-align:left;width: 90px; overflow: hidden; display: inline-block; white-space: nowrap; text-overflow: ellipsis;">&nbsp;</li>
                    </c:if>
                    <c:forEach  var="user2" items="${noreplyList}" varStatus="status2">
                        <c:choose>
                          <c:when test="${status2.count>6 }">
                            <c:if test="${status2.last}">
                               <li class="right margin_b_5 margin_r_5"><a href="javascript:openPlan('${param.planId }','${param.entityId }')"><font color="black">……${ctp:i18n('plan.desc.replydetail.detail')}</font></a></li>
                            </c:if>
                          </c:when>
                          <c:otherwise>
                            <li class="margin_t_5 margin_l_10" style="text-align:left;width: 90px; overflow: hidden; display: inline-block; white-space: nowrap; text-overflow: ellipsis;">            
                                <c:if test="${user2.process == 0}">
                                    <span class='ico16 unviewed_16 margin_r_5' title="未看" style="cursor: default;"></span><font color="black">${user2.refUserName }</font>
                                </c:if>
                                <c:if test="${user2.process == 1}">
                                    <span class='ico16 participate_16 margin_r_5' title="已回复" style="cursor: default;"></span><font color="black">${user2.refUserName }</font>
                                </c:if>
                                <c:if test="${user2.process == 2}">
                                    <span class='ico16 viewed_16 margin_r_5' title="查看" style="cursor: default;"></span><font color="black">${user2.refUserName }</font>
                                </c:if>
                            </li>
                          </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </td>
            </tr>
        </table>
    </div>
</body>
</html>