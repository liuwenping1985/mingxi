<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
  <head>
    <title>测试</title>
  </head>
  <body>
  <center>
	   <table border="1" style="text-align: center;">
		   <tr>
			   <th>导图名称</th>
			   <th>创建ID</th>
			   <th>创建时间</th>
			   <th>ATTID</th>
			   <th>布局类型</th>
			   <th>布局方式</th>
			   <th>状态</th>
			   <th>删除标记</th>
		   </tr>
	   		<c:forEach items="${jdbc}" var="biz">
		   <tr>
		   		<td>${biz.name}</td>
		   		<td>${biz.creator_id}</td>
		   		<td>${biz.create_time}</td>
		   		<td>${biz.att_id}</td>
		   		<td>${biz.layouttype}</td>
		   		<td>${biz.layout}</td>
		   		<td>${biz.state}</td>
		   		<td>${biz.del_flag}</td>
		   </tr>
	   	</c:forEach>   
	   </table>
	   </center>
  </body>
</html>