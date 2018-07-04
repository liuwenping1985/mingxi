<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="over_hidden">
    <head>
	<script type="text/javascript">
	window.onload=function(){
		 <c:if test="${!empty error}">
		  alert("${error}"); 
		  window.close();
		  return;
		  </c:if>
	   document.getElementById("SSOLoginForm").submit();
    }
		
        </script>
    </head>
    <body>

       <form action="https://ct.ctrip.com/corpservice/authorize/login" method="post" id="SSOLoginForm">
            <input type="hidden" value="${appKey}" id="appkey" name="AppKey" />
            <input type="hidden" value="${token}" id="ticket" name="Ticket" />
            <input type="hidden" name="EmployeeID" id="user" value="${currentUser}" />
            <c:if test="${param.xc_click==1}">
            <input type="hidden" name="Backurl" value="http://ct.ctrip.com/my/zh-cn"/>
            </c:if>
        </form>
    </body>
</html>
