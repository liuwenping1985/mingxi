<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<html>
<head>
</head>

<body scroll="no" style="overflow: no">
<form name="cardForm" method="post">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
         <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
    <tr align="center">
        <td height="8" class="detail-top">
            <script type="text/javascript">
// Edit By Lif Start 修改的分隔线的显示样式        
            getDetailPageBreak(true);
// Edit End         
        </script>
        </td>
    </tr>
    <tr>
        <td class="categorySet-4" height="8"></td>
    </tr>
    </table>
    </div>
    <div class="center_div_row2">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr align="center">
                        <td width="50%">
                            <fieldset style="width:35%" align="center"><legend><strong><fmt:message key="hr.record.checkin.label" bundle="${v3xHRI18N}" /></strong></legend>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                                    <tr>
                                        <td class="bg-gray" width="25%" nowrap="nowrap"><label for="basic"><fmt:message key="hr.record.limitaryTime.label" bundle="${v3xHRI18N}" />:</label></td>
                                        <td class="bg-gray" width="75%" nowrap="nowrap">${record.begin_hour}:${record.begin_minute}<label for="basic"></font></label></td>
                                    </tr>
                                    <tr>
                                        <td class="bg-gray" width="25%" nowrap="nowrap"><label for="basic"><fmt:message key="hr.record.cardTime.label" bundle="${v3xHRI18N}" />:</label></td>
                                        <c:choose>
                                            <c:when test="${record.begin_work_time == null || record.state.id == 3}">
                                                <td class="bg-gray" width="25%" nowrap="nowrap" align="center"><label for="basic"><fmt:message key="hr.record.uncard.label" bundle="${v3xHRI18N}" /></label></td>
                                            </c:when>
                                            <c:otherwise>
                                                <td class="bg-gray" width="25%" nowrap="nowrap" align="center"><label for="basic"><fmt:formatDate value="${record.begin_work_time}" type="both" dateStyle="full" pattern="yyyy/MM/dd H:mm:ss" /></label></td>
                                            </c:otherwise>
                                        </c:choose>
                                    </tr>
                                    <tr>
                                        <td class="bg-gray" width="25%" nowrap="nowrap"><label for="basic"><fmt:message key="hr.record.sign.in.ip.label" bundle="${v3xHRI18N}" />:</label></td>
                                        <c:choose>
                                            <c:when test="${record.signInIP == null || record.signInIP == ''}">
                                                <td class="bg-gray" width="25%" nowrap="nowrap" align="center"><label for="basic"><fmt:message key="hr.record.uncard.label" bundle="${v3xHRI18N}" /></label></td>
                                            </c:when>
                                            <c:otherwise>
                                                <td class="bg-gray" width="25%" nowrap="nowrap" align="center"><label for="basic">${record.signInIP}</label></td>
                                            </c:otherwise>
                                        </c:choose>
                                    </tr>
                                </table>
                            </fieldset>
                            <p></p>
                        </td>
                    </tr>
                    <tr align="center">
                        <td width="50%">
                            <fieldset style="width:35%" align="center"><legend><strong><fmt:message key="hr.record.checkout.label" bundle="${v3xHRI18N}" /></strong></legend>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                                    <tr>
                                        <td class="bg-gray" width="25%" nowrap="nowrap"><label for="basic"><fmt:message key="hr.record.limitaryTime.label" bundle="${v3xHRI18N}" />:</label></td>
                                        <td class="bg-gray" width="75%" nowrap="nowrap">${record.end_hour}:${record.end_minute}<label for="basic"></label></td>
                                    </tr>
                                    <tr>
                                        <td class="bg-gray" width="25%" nowrap="nowrap"><label for="basic"><fmt:message key="hr.record.cardTime.label" bundle="${v3xHRI18N}" />:</label></td>
                                        <c:choose>
                                            <c:when test="${record.end_work_time == null  || record.state.id == 3}">
                                                <td class="bg-gray" width="25%" nowrap="nowrap" align="center"><label for="basic"><fmt:message key="hr.record.uncard.label" bundle="${v3xHRI18N}" /></label></td>
                                            </c:when>
                                            <c:otherwise>
                                                <td class="bg-gray" width="25%" nowrap="nowrap" align="center"><label for="basic"><fmt:formatDate value="${record.end_work_time}" type="both" dateStyle="full" pattern="yyyy/MM/dd H:mm:ss" /></label></td>                                 
                                            </c:otherwise>
                                        </c:choose>
                                    </tr>
                                    <tr>
                                        <td class="bg-gray" width="25%" nowrap="nowrap"><label for="basic"><fmt:message key="hr.record.sign.out.ip.label" bundle="${v3xHRI18N}" />:</label></td>
                                        <c:choose>
                                            <c:when test="${record.signOutIP == null || record.signOutIP == ''}">
                                                <td class="bg-gray" width="25%" nowrap="nowrap" align="center"><label for="basic"><fmt:message key="hr.record.uncard.label" bundle="${v3xHRI18N}" /></label></td>
                                            </c:when>
                                            <c:otherwise>
                                                <td class="bg-gray" width="25%" nowrap="nowrap" align="center"><label for="basic">${record.signOutIP}</label></td>
                                            </c:otherwise>
                                        </c:choose>
                                    </tr>
                                </table>
                            </fieldset>
                            <p></p><p></p>
                        </td>
                    </tr>
                    <tr align="center">
                        <td width="50%">
                            <fieldset style="width:35%" align="center"><legend><strong><fmt:message key="hr.record.remark.label" bundle="${v3xHRI18N}" /></strong></legend>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                                    <tr>
                                        <td class="bg-gray" width="100%" nowrap="nowrap">
                                            <textarea id="outRemark" name="remark" class="input-100per" rows="4" cols="" readonly="readonly">${record.remark}</textarea>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </td>
                    </tr>
                </table>
    </div>
  </div>
</div>

	
		
</form>
</body>
</html>