<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.seeyon.v3x.util.Strings" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<title></title>
<style type="text/css">
  html,body{
    padding: 0;
    margin: 0;
    border: 0;
    width: 100%;
    height: 100%;
    overflow: hidden;
  }
</style>
</head>
<body>
<form name="detailMainFrameForm" id="detailMainFrameForm" action="mtMeeting.do?method=mydetailChrome37" method="post" target="detailMainFrame">
<%
//读取传递过来的其它参数
String name="";
Enumeration paramKeys= request.getParameterNames();
while(paramKeys.hasMoreElements())
{
  name=paramKeys.nextElement().toString();
  if("method".equalsIgnoreCase(name)){//回执意见可能是中文
      continue;
  }
  String[] values = request.getParameterValues(name);
  if(values != null){
      for(String value : values){
          if("feedback".equalsIgnoreCase(name)){
              %>
              <input name="<%=name%>" type="hidden" value="<%=Strings.toXmlStr(value)%>"/>
              <%
          }else{
              %>
              <input name="<%=name%>" type="hidden" value="<%=value%>"/>
              <%
          }
      }
  }
}
%>
</form>
<iframe height="100%" width="100%" frameborder="no" src="" name="detailMainFrame" id="detailMainFrame" scrolling="no"></iframe>
</body>
</html>
<script type="text/javascript">
   <%-- 放到最后执行 --%>
   var myform = document.getElementsByName("detailMainFrameForm")[0];
   myform.submit();
</script>