<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.v3x.webmail.*" %>
<%
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setDateHeader("Expires", 0);
String contextPath = request.getContextPath();
if(contextPath.endsWith("/")){contextPath = contextPath.substring(0, contextPath.length() - 1);}
%>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="JavaScript" type="text/JavaScript">

</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
<div id="count" style="position:absolute; left:274px; top:19px; width:292px; height:31px; z-index:2">
    <table >
	<tr>
            <td width="" height="21"><font size="2">共</font></td>    
            <td width="" align="center" valign="top" height="21"> <font size="3"><B> 
                <div id="count2" ></div></B> </font>
            </td>            
            <td width="" align="left" height="21"><font size="2">封邮件，新邮件</font></td>            
            <td width="" align="center" valign="top" height="21"> <font size="3"><B> 
                <div id="count3" ></div></B> </font>
            </td>            
            <td width="" align="left" height="21"><font size="2">封</font></td>
        </tr>
    </table> 
</div>
<img src="<%=contextPath %>/common/images/webmail/inbox_eye.jpg" > 
<div id="Layer1" style="position:absolute; width:660px; height:78px; z-index:1; left: 210px; top: 53px"><font color="#999999">
  <ul>
　<li><font size="2">双击列表中的信息条目可以修改信息详细内容。</font></li>
    <li><font size="2">单击表列标题可以进行快速排序。</font></li>
    <li><font size="2">单击列表中的信息条目可以查看信息详细内容。</font></li>
	<li><font size="2">勾选列表中的信息条目，再继续点击“回复”、“转发”、<br>
	“删除”或“移动”按钮，可以对该记录进行回复、转发、删除或移动操作。</font></li>
  </ul>
  </font></div>
</body>
</html>
