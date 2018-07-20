<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.v3x.common.web.BaseController" %>
<script type="text/javascript">
var refWindow =${windowObj};
<%
Object jsScript = request.getAttribute("jsScript");
if(jsScript!=null && !"".equals(jsScript.toString()))
{
	out.println(jsScript);
}
%>
//ipad 计划是新窗口打开的，提交完后就关闭
if(navigator.userAgent.indexOf('iPad') == -1){
	refWindow.location.href=refWindow.location.href;
}else{
	getA8Top().window.close();
}
</script>