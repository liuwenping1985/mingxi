<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>
<%@ page import="java.util.*" %>
<html>
<head>
<title>messageManager</title>
<script type="text/javascript">
showCtpLocation("F13_sysMsgManager");
//getA8Top().hiddenNavigationFrameset();
function checkAutoForm(form){
  if(form.oncount.checked){    
    form.count.validate = 'notNull,isInteger';
  }else{
    form.count.validate = '';
    form.count.value=' ';
  }
  if(form.onday.checked){
    form.day.validate = 'notNull,isInteger';
  }else{
    form.day.validate = '';
    form.day.value=' ';
  }
  if(checkForm(form)){
    alert(v3x.getMessage("MainLang.messagemanager_auto_setup_ok"));
    return true;
  }else{
    return false;
  }
}

function checkHandForm(form){
  if(checkForm(form)){
    if(form.startTime.value>=form.endTime.value){
      alert(v3x.getMessage("MainLang.messagemanager_starttime_lessthan_endTime"));
      return false;
    }else{
      return true;
    }
  }else{
    return false;
  }
}
</script>
</head>
<body scroll="no" style="overflow: no">
<div>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="border_b">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="messageManagerHome"></div></td>
						<td class="page2-header-bg">&nbsp;<fmt:message key="manager.manager" /></td>
						<td>&nbsp;</td>
			      </tr>
			 </table>
		</td>
	</tr>
	<%--
	<tr>
		<td height="80">
		<table class="sort manage-stat-1" width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
		    <thead>
			<tr align="center"> 
				<td width="25%" class="sorttd"><fmt:message key="messageManager.count.type" /></td>
				<td width="25%" class="sorttd"><fmt:message key="messageManager.count.month" /></td>
				<td width="25%" class="sorttd"><fmt:message key="messageManager.count.season" /></td>
				<td width="25%" class="sorttd"><fmt:message key="messageManager.count.year" /></td>
			</tr>	
			</thead>	
			<tbody>		
			<% 
			Map<String,Vector> countMap = (Map)request.getAttribute("countMap");
			Vector<Integer> systemVec = countMap.get("system");
			Vector<Integer> personVec = countMap.get("person");
			%>
			<tr align="center">						
				<td class="sort"><fmt:message key="messageManager.count.person" /></td>
				<td class="sort"><%=personVec.get(0)%></td>
				<td class="sort"><%=personVec.get(1)%></td>
				<td class="sort"><%=personVec.get(2)%></td>
			</tr>
			<tr align="center">
				<td class="sort"><fmt:message key="messageManager.count.system" /></td>
				<td class="sort"><%=systemVec.get(0)%></td>
				<td class="sort"><%=systemVec.get(1)%></td>
				<td class="sort"><%=systemVec.get(2)%></td>
			</tr>
			</tbody>
		</table>
		</td>
	</tr>
	 --%>
	<tr>
		<td height="80">
		<form name="autoForm" action="${urlMessageManager}?method=autoRemove" method="post" onsubmit="return (checkAutoForm(this))" >
		<div style="padding:20px">	
			<fieldset><legend><fmt:message key="messageManager.auto.set" /></legend>	
				<table height="30%" width="100%" border="0">
					 <tr>
					    <td width="10%"></td>
			            <td width="20%" align="right"><fmt:message key="messageManager.auto.maxcount" />:&nbsp;</td>
						<td width="10%" align="left">
						<c:choose>  
						<c:when test="${messageDelset.messageCount == -1 }">
						  <input name="count" type="text" validate="notNull,isInteger" inputName="<fmt:message key="messageManager.auto.maxcount" />" id="count" max="200" min="1" maxlength="3" style='width: 100px' value="">			
						</c:when>
						<c:otherwise>
						  <input name="count" type="text" validate="notNull,isInteger" inputName="<fmt:message key="messageManager.auto.maxcount" />" id="count" max="200" min="1" maxlength="3" style='width: 100px' value="${messageDelset.messageCount}">			
						</c:otherwise>
						</c:choose>
						</td>
					    <td class="hidden"><label for="oncount"><span class="commentContent-hidden"><fmt:message key="messageManager.auto.effect" /></span>&nbsp;<input name="oncount" type="checkbox" id="oncount" <c:if test='${messageDelset.status == 2 || messageDelset.status == 3}'>checked</c:if>></label></td>
					     <td width="10%"></td>
					     <td width="10%"></td>
					     <td width="10%"></td>
			         </tr>
			         <tr>
				         <td width="10%"></td>
				         <td width="20%" align="right"><fmt:message key="messageManager.auto.maxday" />:</td>
				         <td width="10%" align="left">
				         <c:choose>
				         <c:when test="${messageDelset.messageDay == -1 }">
				           <input name="day" type="text" validate="notNull,isInteger" inputName="<fmt:message key="messageManager.auto.maxday" />" id="day" max="90" min="1" maxlength="2" style='width: 100px' value="">
				         </c:when>
				         <c:otherwise>
				           <input name="day" type="text" validate="notNull,isInteger" inputName="<fmt:message key="messageManager.auto.maxday" />" id="day" max="90" min="1" maxlength="2" style='width: 100px' value="${messageDelset.messageDay}">
						 </c:otherwise>
						 </c:choose>
						 </td>
						 <td class="hidden"><label for="onday"><span class="commentContent-hidden"><fmt:message key="messageManager.auto.effect" /></span>&nbsp;<input name="onday" type="checkbox" id="onday" <c:if test='${messageDelset.status == 1 || messageDelset.status == 3}'>checked</c:if>></label></td>
						 <td width="10%">
						 	<input type="submit" class="button-default-4" value="<fmt:message key="messageManager.auto.save" />">
						 </td>
						 <td width="10%"></td>
					     <td width="10%"></td>
				         </tr>
				        
			         </tr>
			     </table>			  
			</fieldset>
		</div>
		</form>
		</td>
	</tr>
	<tr>
		<td height="60%">
		<form name="handForm" action="${urlMessageManager}?method=handRemove" method="post" onsubmit="return (checkHandForm(this))" >
		<div style="padding:20px">	
			<fieldset style="" ><legend><fmt:message key="messageManager.hand.set" /></legend>
				<table width="100%" border="0">
					  <tr height="20%">
			            <td width="30%" nowrap="nowrap" align="right"><fmt:message key="messageManager.hand.starttime" />:  &nbsp;&nbsp;
			            	<input type="text" readonly="true" class="input-50per" name="startTime" onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'datetime');" inputName="<fmt:message key='messageManager.hand.starttime' />" validate="notNull" value="<fmt:formatDate value="${bean.beginDate}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>" />
						</td>
						
			            <td width="30%" nowrap="nowrap" align="right"><fmt:message key="messageManager.hand.endtime" />: &nbsp;&nbsp;
							<input type="text" readonly="true" class="input-50per" name="endTime" onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'datetime');" inputName="<fmt:message key='messageManager.hand.endtime' />" validate="notNull" value="<fmt:formatDate value="${bean.endDate}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>" />
						</td>
						
						<td>
							<input name="Submit2" type="submit" class="button-default-2" value="<fmt:message key='meesageManager.hand.del' />">
						</td>
			          </tr>
			          <tr>
       			 		<td colspan="7">
       			 			<div align="center">
       			 				<span class="commentContent-hidden"><fmt:message key="messageManager.hand.warning" /></span>
       			 			</div>
       			 		</td>
        			  </tr>
			    </table>
			</fieldset>
		</div>
		</form>
		</td>
	</tr>
	<tr>
		<td height="100%">&nbsp;</td>
	</tr>
</table>
</div>
</body>
</html>
