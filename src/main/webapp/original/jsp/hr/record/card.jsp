<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@include file="../header.jsp"%>
<script type="text/javascript">
	function checkin(){
		var checkInBtn = document.getElementById("checkInBtn");
		checkInBtn.disabled = true;
       	cardForm.action=hrRecordURL+"?method=addRecord";
       	cardForm.submit();
	}
	
	function checkout(){
		var checkOutBtn = document.getElementById("checkOutBtn");
		checkOutBtn.disabled = true;
		cardForm.action=hrRecordURL+"?method=updateRecord";
		cardForm.submit();
  	}
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body scroll="no" style="overflow: no; text-align:center">
<form name="cardForm" method="post" style="margin: 0px">

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
    <tr align="center">
        <td height="8" class="detail-top">
            <script type="text/javascript">
            getDetailPageBreak();
        </script>
        </td>
    </tr>
    <tr>
        <td class="categorySet-4" height="8"></td>
    </tr>
    <tr>
        <td>
           
            <div id="docLibBody">
                    
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
                        <td height="10" colspan="2">&nbsp;</td>
                    </tr>
                    <tr align="center">
                        <td width="50%">
                            <fieldset style="width:35%" align="center"><legend><strong><fmt:message key="hr.record.checkin.label" bundle="${v3xHRI18N}" /></strong></legend>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                                    <tr>
                                        <td class="bg-gray" width="25%" nowrap="nowrap"><label for="basic"><fmt:message key="hr.record.limitaryTime.label" bundle="${v3xHRI18N}" />:</label></td>
                                        <td class="bg-gray" width="75%" nowrap="nowrap">${begin }<label for="basic"></font></label></td>
                                    </tr>
                                    <tr>
                                        <td class="bg-gray" width="25%" nowrap="nowrap"><label for="basic"><fmt:message key="hr.record.cardTime.label" bundle="${v3xHRI18N}" />:</label></td>
                                        <c:choose>
                                            <c:when test="${record.begin_work_time == null }">
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
                                        <td class="bg-gray" width="75%" nowrap="nowrap">${end }<label for="basic"></label></td>
                                    </tr>
                                    <tr>
                                        <td class="bg-gray" width="25%" nowrap="nowrap"><label for="basic"><fmt:message key="hr.record.cardTime.label" bundle="${v3xHRI18N}" />:</label></td>
                                        <c:choose>
                                            <c:when test="${record.end_work_time == null }">
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
                                        <td class="bg-gray" width="100%" >
                                            <textarea id="outRemark" name="remark" class="input-100per" rows="4" cols="" style="overflow-y: auto">${record.remark}</textarea>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </td>
                    </tr>
                </table>

            </div>
           
        </td>
    </tr>
    <tr>
        <td class="bg-advance-bottom" align="center">
                
            <c:choose>
                <c:when test="${record.id == null}">
                    <input type="button" id="checkInBtn"  onclick="checkin()" class="button-default_emphasize" value='<fmt:message key="hr.record.checkin.label" bundle="${v3xHRI18N}" />'>&nbsp;
                     <input type="button" id="checkOutBtn" onclick="checkout()" class="button-default-2" value='<fmt:message key="hr.record.checkout.label" bundle="${v3xHRI18N}" />'>
                </c:when>
                <c:otherwise>
                    <input type="button" disabled class="button-default-2" value='<fmt:message key="hr.record.checkin.label" bundle="${v3xHRI18N}" />'></button>&nbsp;&nbsp;
                    <c:set value="${(record.end_work_time != null) ?'disabled':'' }" var="canOut"/>
                    <c:set value="${(record.end_work_time != null) ?'button-default-2':'button-default_emphasize' }" var="canClass"/>
                    <input id="checkOutBtn" type="button" ${canOut } onclick="checkout()" class="${canClass }" value='<fmt:message key="hr.record.checkout.label" bundle="${v3xHRI18N}" />'></button>
                </c:otherwise>
            </c:choose>
        
        </td>
    </tr>
</table>

	
<script type="text/javascript">
    bindOnresize('docLibBody', 0, 80)
</script>
</form>
</body>
</html>