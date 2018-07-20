<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html:link renderURL='/genericController.do?ViewPage=plugin/nc/ssologin' var="genericController" />
<fmt:setBundle basename="com.seeyon.apps.nc.i18n.NCResources"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="JavaScript">
	function pkcorpC(pkcorp){
		document.me.pkcorp.value = pkcorp;
		document.me.width.value = <%=request.getParameter("width")%>;
		document.me.height.value =<%=request.getParameter("height")%>;
		document.me.submit();
	}
</script>
</head>

<body scroll=no>
<form name="me" method="post" action="${genericController}">
<input type="hidden" name="width">
<input type="hidden" name="height">
<input type="hidden" name="accountCode" value="<%=request.getParameter("A")%>">
<input type="hidden" name="pkcorp" value="">
<input type="hidden" name="language" value="<%=request.getParameter("L")%>">
	
<table width="200" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td height="200">&nbsp;</td>
	</tr>
	<tr>
		<td><fmt:message key='nc.user.select'/></td>
	</tr>
	<tr>
		<td><table width="100%" border="0" cellspacing="0" cellpadding="0">
			<%
			String erp= request.getParameter("extendParam");
			String user0="";
			String pkCorp="";
			if(erp!=null)
			{
				try {
				String[] userCorpk = erp.split("::");
				if(userCorpk[0]!=null)
				{
				user0=userCorpk[0];
				}
				if(userCorpk.length==2)
				{
				if(userCorpk[1]!=null)
				{
				pkCorp=userCorpk[1];
				}
				}
				//user0=new String(user0.getBytes("ISO-8859-1"),"UTF-8");
				}catch (Throwable e) {
					
				}
			}
			%>
		<%
			String user = request.getParameter("U");
			if(user != null){
				String[] users = user.split(";;");
				if(users != null){
					for(int i = 0; i < users.length; i++){
						String[] us = users[i].split("::");
						//us[0]=new String(us[0].getBytes("ISO-8859-1"),"UTF-8");
						 if(us[0].equals(user0))
						 {
							 us[1]=pkCorp;
						 }else{
								if (!us[1].equalsIgnoreCase("0001"))
								{
								
										us[1] = "0001";
								}
						 }
                                              if(users.length==1){
                                            	  
							%>
								<tr>
							<td><input checked id="u<%=us[0]%>" type="radio" name="userCode" value="<%=us[0]%>" onclick="pkcorpC('<%=us[1]%>')"><label for="u<%=us[0]%>"><%=us[0]%></label></td>
						</tr>
							<script language="JavaScript">pkcorpC("<%=us[1]%>")</script>
						<% }
						
						%>
						<tr>
							<td><input id="u<%=us[0]%>" type="radio" name="userCode" value="<%=us[0]%>" onclick="pkcorpC('<%=us[1]%>')"><label for="u<%=us[0]%>"><%=us[0]%></label></td>
						</tr>
						<%
					}
				}
			}
			%>
		</table></td>
	</tr>
</table>
</form>
</body>
</html>