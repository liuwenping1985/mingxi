<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="inquiry.open" /></title>
</head>
<body scroll='no'>
    <script type="text/javascript">
        //开启调查保存结果
        function saveOpen() {
            document.getElementById("Submit").disabled = true;
            document.getElementById("Submit").className = "button-default_emphasize button-default-disable";
            
            var close_date = document.getElementById("close_date");
            clearDefaultValueWhenSubmit(close_date);
            var closeDate = document.getElementById("close_date").value;
            var nowDate = new Date();
            var nowTime = nowDate.format("yyyy-MM-dd HH:mm").toString();

            if (closeDate == "" && closeDate == null) {
                document.getElementById("close_date").innerHTML = "3000-01-01 00:00:00";
            } else if (closeDate != "" && nowTime >= closeDate) {
                alert("<fmt:message key='inquiry.open.confirm.time' />");
                document.getElementById("Submit").disabled = false;
                document.getElementById("Submit").className = "button-default_emphasize";
                return false;
            } 
            var theForm = document.forms[0];
            theForm.action="${basicURL}?method=basicOpen&bid=${bid}&id=${id}";
            theForm.submit();
        }
        
        function openIquiryCollBack (returnValue) {
        	transParams.parentWin.openInquiryCollBack(returnValue);
        }
    </script>

    <form name="formorder" method="post" target="targetIframe">
        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center"
            class="popupTitleRight">
            <tr align="center" style="padding-right: 20px;padding-top: 30px;">
                <td class="bg-gray" ><fmt:formatDate value='${tem.inquirySurveybasic.closeDate}'
                        pattern='yyyy-MM-dd HH:mm' var="closetime" /> <fmt:message key="inquiry.select.closeDate.label"
                        var="dfclosetime" /> <fmt:message key="inquiry.close.time.label" />:</td>
                <td>
                    <c:if test="${tem.inquirySurveybasic.closeDate > '3000-01-01 00:00:00'}">
                        <fmt:message key="inquiry.select.closeDate.label" var="closetime" />
                    </c:if>
                    <input class="cursor-hand" style="width: 95%;float: left" type="text" id="close_date" name="close_date" value="<c:out value='${closetime}' default='${dfclosetime}'/>"
                        deaultValue="${dfclosetime}"
                        inputName="<fmt:message key='inquiry.close.time.label' />"
                        onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'datetime');" readonly />
                </td>
            </tr>
            <tr align="center" style="padding: 10px;margin-top: 10px;">
                <td colspan="2" class="bg-gray">
                    <fmt:message key="inquiry.open.confirm" />
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td colspan="2" align="center" class="bg-advance-bottom">
                    <input id="Submit" name="Submit" type="button" onClick="saveOpen();" class="button-default_emphasize"
                    value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" />&nbsp; 
                    <input type="button" name="b2" onclick="getA8Top().openInquiryWin.close();"
                    value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />"
                    class="button-default-2" />
                </td>
            </tr>
        </table>
        </center>
        </td>
        </tr>
        </table>
    </form>
    <iframe id="targetIframe" name="targetIframe" width="0" height="0" style="display: none;"></iframe>
</body>
</html>
