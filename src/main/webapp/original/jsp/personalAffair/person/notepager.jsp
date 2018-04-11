<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/v3xmain/css/notepager.css${v3x:resSuffix()}" />">
<script type="text/javascript">
<!--
var v3x= new V3X();
v3x.init("${pageContext.request.contextPath}", "<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");
var autoSaveTime=60000;
var autoSaveTimer;
var notepageId ="${notepage.id}";
var currentUserId ="${v3x:currentUser().id}";
var saveAs ='<fmt:message key='notepager.save.filename'/>.txt';
showCtpLocation("F12_notepager");
//-->
</script>
<script type="text/javascript" charset="utf-8" src="<c:url value='/apps_res/v3xmain/js/notepager.js${v3x:resSuffix()}' />"></script>
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" >
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="page-list-border-LRD">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		       			<td width="45" class="page2-header-img"><div class="notepager"></div></td>
						<td id="notepagerTitle1" class="page2-header-bg">&nbsp;<fmt:message key="notepager.title" /></td>
						<td class="page2-header-line padding-right" align="right" id="back">&nbsp;</td>
			        </tr>
			 </table>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<div class="scrollList">
				<table border="0" align="center" width="600" cellspacing="0" cellpadding="4" class="notepager-table">
				    <tr>
					  <td id="notepagerTitle2" class="notepager-title" width="100%">
					  <fmt:message key='notepager.title'/>
					  </td>
					</tr>
					<tr>
						<td align="center" class="textarea-bg">
						<textarea cols="114" rows=""  id="message" name="message" onchange="stateSave()" onfocus="focusSave()"
						  onblur="blurSave()" maxSize="500" inputName="<fmt:message key='notepager.content.label'/>">${v3x:toHTMLescapeRN(notepage.content)}</textarea>
						</td>
					</tr>
					<tr>
					    <td class="bottom" height="40">
					      <div id="descriptonDiv"><font color="red">*</font>
							<fmt:message key="notepager.descripton.label"> 
								<fmt:param><c:out value="500"></c:out> </fmt:param> 
							</fmt:message>
						  </div>
					      <div id="exportDiv"><c:if test="${v3x:getBrowserFlagByRequest('HideBrowsers', pageContext.request)}"><input type="button" class="button-default-4" onclick="saveas()" value="<fmt:message key="notepager.button.saveas"/>"></c:if></div>
					    </td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>
<iframe name="expwin" src="" style="display:none;"></iframe>
</body>
</html>