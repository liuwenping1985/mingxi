<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="com.seeyon.apps.xc.manager.XCSynManagerImp" %>
<%@page import="com.seeyon.apps.xc.manager.XCSynManager" %>
<%@page import="com.seeyon.ctp.common.authenticate.domain.User" %>
<%@page import="com.seeyon.ctp.common.AppContext" %>
<!DOCTYPE html>
<html>
    <head>
<% XCSynManagerImp manager=new XCSynManagerImp();
String appKey=manager.getXCParameterSet().getUserId();
String token=manager.getToken();

%>
    </head>
    <body>
       <form action="https://www.corporatetravel.ctrip.com/corpservice/authorize/login" method="post" id="SSOLoginForm">
            <input type="hidden" value="<%=appKey%>" name="AppKey" />
            <input type="hidden" value="<%=token%>" name="Ticket" />
            <input type="hidden" name="EmployeeID" value="<%=AppContext.getCurrentUser().getLoginName()%>" />
			<input type="hidden" name="Backurl" value="http://ct.ctrip.com/my/zh-cn"/>
        </form>
        <script type="text/javascript">
            document.getElementById("SSOLoginForm").submit();
        </script>
    </body>
</html>
