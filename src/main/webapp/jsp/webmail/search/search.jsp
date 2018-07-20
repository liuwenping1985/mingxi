<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.v3x.common.constants.Constants" %>	

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../webmailheader.jsp" %>
<script type="text/javascript">
getA8Top().endProc();
function search()
{
	var bgTR = document.getElementById("bgTR");
	var iframeTR =document.getElementById("iframeTR");
	if(bgTR){bgTR.style.display="none"}
	if(iframeTR){iframeTR.style.display=""}

	var form = document.getElementById("searchForm");
	var subject = form.subject;
	var from = form.from;
	var to = form.to;
	var dateTime = form.dateTime;
	if(subject.value.length == 0 && from.value.length == 0 && to.value.length == 0 && dateTime.value.length == 0)
	{
		alert("<fmt:message key='label.alert.error.search.conditions'/>");
		return false;
	}
	form.action = "${webmailURL}?method=search";
	form.submit();
	getA8Top().startProc("<fmt:message key='label.alert.error.search.alert'/>");
}
//getA8Top().hiddenNavigationFrameset(407);
function submitSearch(){
	if(event.keyCode == 13){
		search();
	}
}
</script>
</head>
<body scroll="no" class="" onkeypress="submitSearch()">
<form name="searchForm" id="searchForm" method="post" target="dataIFrame">
<input type="hidden" name="exec" value='1' />
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="main-bg">
<tr class="page2-header-line">
	<td width="100%" height="41" valign="top" >
		 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	     	<tr class="page2-header-line">
	        <td width="45" class="page2-header-img"><div class="emailSearch"></div></td>
	        <td class="page2-header-bg"><fmt:message key='label.mail.searchMenu'/></td>
	        <td class="page2-header-line page2-header-link" align="right">
	        </td>
			</tr>
		 </table>
	</td>
</tr>
  <tr height="100">
    <td  valign="top" align="center" style="padding: 5px">
		<div class="portal-layout-cell gov_nobackground gov_border">		  	
			<table border="0" cellSpacing="0" cellPadding="0" width="100%">
				<tr>
					<td style="padding: 5px" valign="top">
						<span class="sectionTitle"><fmt:message key='common.search.condition.label' bundle="${v3xCommonI18N}"/></span>:
					</td>
					<td style="padding: 5px"align="center" width="600">
						 <table width="500" border="0" cellpadding="0" cellspacing="0">
						 	<tr>
								<td align="right">
								  <fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />:
								</td>
								<td> 
								  <input name="subject" type="text" id="subject"  validate="notNull" />
								</td>
								<td height="27" align="right"><fmt:message key="label.alert.searchscope" />:</td>
								<td colspan="2"><select name="mailbox" style="width:100px">
										<option value="1"><fmt:message key='label.mail.inbox'/></option>
										<option value="0"><fmt:message key='label.mail.sent'/></option>
										<option value="2"><fmt:message key='label.mail.draft'/></option>
										<option value="3"><fmt:message key='label.mail.trash'/></option>
									</select></td>
							</tr>
		                    <tr>
								<td align="right"><fmt:message key='label.head.from'/>:</td>
								<td> 
								 <input name="from" type="text" id="from" inputName="<fmt:message key='label.head.from'/>"
		                          validate="notNull" escapeXml="true" default='' />
								</td>
								<td align="right"><fmt:message key='label.head.date'/>:</td>
								<td><select name="relation" size="1" style="width:100px">
									<option value="<"  ><fmt:message key='label.head.before'/></option>
									<option value=">"  ><fmt:message key='label.head.after'/></option>
									<option value="="  selected><fmt:message key='label.head.equals'/></option>
								  </select>
								 </td>
								 <td align="right" valign="bottom">
								 <input type="text" readonly="true" style="width:150px" name="dateTime" onclick="whenstart('${pageContext.request.contextPath}', this, event.clientX, event.clientY+100);" validate="" />
								 </td>
							</tr>
							<tr>
								<td align="right"><fmt:message key='label.head.to'/>:</td>
								<td> 
								    <input name="to" type="text" id="to" inputName="<fmt:message key='label.alert.to'/>"
		                             validate="notNull" escapeXml="true" default='' />
								</td>	
								<td height="27" align="center">&nbsp;</td>
								<td  align="right" colspan="2"></td>
							</tr>
						 </table>
					</td>
					<td aline="left" valign="bottom" style="padding-bottom:5px;">
						<input class="deal_btn" onmouseover="javascript:this.className='deal_btn_over'" onmouseout="javascript:this.className='deal_btn'" type="button" onclick="search();" value="<fmt:message key='label.alert.error.search.title'/>" class="button-default-2">
					</td>
				</tr>
			</table>
		</div>  

	  </td>
	</tr>
	<tr id="bgTR">
		<td valign="top" style="padding: 0px 5px">
			<div class="portal-layout-cell gov_nobackground gov_border" style="padding: 5px">		  	
				<span class="searchSectionTitle"><fmt:message key="label.search.title"/>:</span>
			</div>  
		</td>
	 </tr>
	<tr id="iframeTR" style="display:none">
	<td>	
	<IFRAME height="100%" name="dataIFrame" id="dataIFrame" width="100%" frameborder="0"></IFRAME>
	</td>
</tr>	
	
</table>
</form>
<script>
  showCtpLocation('F18_mailsearch');
</script>
</body>
</html>