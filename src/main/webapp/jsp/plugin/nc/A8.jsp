<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html:link renderURL='/genericController.do?ViewPage=plugin/nc/ssologin' var="genericController" />
<fmt:setBundle basename="com.seeyon.apps.nc.i18n.NCResources"/>
<c:if test="${param.isvalid}">
<script language="JavaScript">
  alert("<fmt:message key='nc.space.valid'/>");
  </script>
</c:if>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="JavaScript">
	function pkcorpC(pkcorp){
		document.me.pkcorp.value = pkcorp;
      <c:if test="${(param.width=='')||(param.height=='')||(param.width=='null')||(param.height=='null')}">
      var swidth = window.screen.width;
      var sheight = window.screen.height;
      var agent =  navigator.userAgent;
      var i= agent.indexOf("MSIE ");
         if(i > -1){
             agent = agent.substring(i+5);
             i = agent.indexOf(";");
             agent = agent.substring(0,i);
             agent = parseInt(agent);
             if(agent >= 8){
               if(window.screen.deviceXDPI){
                   swidth = swidth*window.screen.deviceXDPI/96;
               }
               if(window.screen.deviceYDPI){
                   sheight = sheight*window.screen.deviceYDPI/96;
                 }
                          }
                 }
         document.me.width.value=swidth;
         document.me.height.value=sheight;
      </c:if>
		document.me.submit();
		}
</script>
</head>

<body scroll=no>
<c:if test="${param.isvalid==null}">
<form name="me" method="post" action="${genericController}">
<input type="hidden" name="width" value="<%=request.getParameter("width")%>">
<input type="hidden" name="height" value="<%=request.getParameter("height")%>">
<input type="hidden" name="pkcorp" value="">
<input type="hidden" name="language" value="<%=request.getParameter("L")%>">
<input type="hidden" name="providerId" value="<%=request.getParameter("providerId")%>">
<input type="hidden" name="accountCode" value="<%=request.getParameter("A")%>">
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
			    erp=java.net.URLDecoder.decode(erp,"UTF-8");
	            //erp=new String(erp.getBytes("ISO-8859-1"),"UTF-8");
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
</c:if>
</body>
</html>