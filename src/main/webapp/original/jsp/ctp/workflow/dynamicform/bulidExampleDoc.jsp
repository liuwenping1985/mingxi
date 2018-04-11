<%--
  Created by IntelliJ IDEA.
  User: lib
  Date: 2015-12-2
  Time: 13:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html class="over_hidden h100b">
<head>
    <%@ include file="/WEB-INF/jsp/common/common.jsp"%>
    <c:set var="isNewForm" value="${formBean.newForm }"/>
    <title>制作示例</title>
    <script type="text/javascript">
    	function setSrc(){
    		var obj = document.getElementById("exampleIMG");
    		if(_locale == "en"){
    			obj.src = _ctxPath + "/apps_res/form/dynamicFormExample/flowdynamicformdocen.jpg";
    		}else{
    			obj.src = _ctxPath + "/apps_res/form/dynamicFormExample/flowdynamicformdoc.jpg";
    		}
    	}
    		
    	
    </script>
    
</head>
<body class="h100b page_color" style="overflow-y:auto;" onload="setSrc()">
        <div style="h100b">
        	<img auto id="exampleIMG">
		</div>
</body>
</html>
