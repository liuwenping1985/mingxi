<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.v3x.common.constants.Constants" %>
<%@ include file="../webmailheader.jsp" %>
<script type="text/javascript">
	getA8Top().showLocation(405);
</script>
<html>
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  	<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
	<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
	<meta HTTP-EQUIV="Expires" CONTENT="0">
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
    <title><fmt:message key='label.mail' />-<fmt:message key='label.mail.trash' /></title>
  	<script type="text/javascript">
  		function displayDetail(mailNumber,type)
		{
  			if(!v3x.getBrowserFlag('pageBreak')){
				type = 2;
	  		}
			if(type==1){
			url = "${webmailURL}?method=show&folderType=3&showType=0";
			parent.detailFrame.location.href = url + "&mailNumber=" + mailNumber;
			}else if(type==2){
				v3x.openWindow({
				        url: "${webmailURL}?method=show&folderType=3&showType=0"+ "&mailNumber=" + mailNumber,
				        dialogType:'open',
				        workSpace: 'yes'
				});
			}
		}
  		function removeit(folderType)
		{
			if(isSelected() == 0){
  				alert("<fmt:message key='label.alert.error.move'/>");
  				return false;
  			}
  			if(confirm("<fmt:message key='label.alert.error.comfirmmove'/>")){
				var form = document.getElementById("listForm");
				form.target="_parent";
				var url = "${webmailURL}?method=move";
				url += "&toFolder="+folderType+"&fromFolder=3";
				form.action = url;
				form.submit();
  			}
		}
		function delMailPhy()
		{
			if(isSelected() == 0){
  				alert("<fmt:message key='label.alert.error.delete'/>");
  				return false;
  			}
  			if(confirm("<fmt:message key='label.alert.error.confirmphydelete'/>")){
				var form = document.getElementById("listForm");
				form.target="_parent";
				var url = "${webmailURL}?method=delete";
				url += "&folder=3";
				form.action = url;
				form.submit();
  			}
		}
		function delMailAll()
		{
			var ids = document.getElementsByName("id");
			if(ids.length == 0)return;
			if(confirm("<fmt:message key='label.alert.error.empty'/>")){
				var url = "${webmailURL}?method=empty";
				parent.location.href = url;
			}
		}
		function isSelected()
		{
			var ids = document.getElementsByName("id");
			var selectCount = 0;
			for(var i = 0; i < ids.length; i++){
				if(ids[i].checked){
					selectCount++;
				}
			}
			return selectCount;
		}
		function download()
		{
			var count = isSelected();
			if(count == 0){
				alert("<fmt:message key='label.alert.error.download'/>");
				return false;
			}
			var form = document.getElementById("listForm");
			form.target="downloadFrame";
			//var url = "${webmailURL}?method=download";
			var url = "<c:url value='/webmail.do?method=download' />";
			url += "&folderType=3";
			form.action = url
			form.submit();
		}
		function archive()
		{
			if(isSelected() == 0){
  				alert("<fmt:message key='label.alert.error.archive'/>");
  				return false;
  			}
  			var items = document.getElementsByName("id");
  			var ids = "";
			if(items.length > 0){
				for(var i = 0; i < items.length; i++){
					if(items[i].checked){
						var mailLongId = document.getElementById("mailLongId_" + items[i].value).value;
						if(ids.length > 0){
							ids += "," + mailLongId;
						}else{
							ids += mailLongId;
						}
					}
				}
			}
			var flag = pigeonhole(<%=ApplicationCategoryEnum.mail.getKey()%>, ids);
			document.location.reload();
		}
  	</script>

  </head>
  <body scroll="no" class="listPadding">
  <div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2"> 
<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22">
    <script type="text/javascript">
	    var folderNode = new WebFXMenu("${pageContext.request.contextPath}");
	    folderNode.add(new WebFXMenuItem("folder_1", "<fmt:message key='label.mail.inbox' />", "removeit(1)"));
		folderNode.add(new WebFXMenuItem("folder_0", "<fmt:message key='label.mail.sent' />", "removeit(0)"));
		folderNode.add(new WebFXMenuItem("folder_2", "<fmt:message key='label.mail.draft' />", "removeit(2)"));
    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
    	myBar.add(new WebFXMenuButton("deletePhy", "<fmt:message key='button.delete' />", "delMailPhy()", [11,10], "", null));
    	myBar.add(new WebFXMenuButton("deleteAll", "<fmt:message key='button.empty' />", "delMailAll()", [12,3], "", null));
    	myBar.add(new WebFXMenuButton("domove", "<fmt:message key='button.move' />", null, [12,1], "", folderNode));
    	if(v3x.getBrowserFlag('hideMenu')){
    		myBar.add(new WebFXMenuButton("down", "<fmt:message key='button.download' />", "download()", [6,4], "", null));
    	}
    	//myBar.add(new WebFXMenuButton("archive", "<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />", "archive()", "<c:url value='/common/images/toolbar/insert.gif'/>", "", null));
    	document.write(myBar);
    	document.close();
    </script>
		</td>
	</tr>
	</table>
    
    </div>
    <div class="center_div_row2"  id="scrollListDiv">
    <form name="listForm" id="listForm" method="post" style="margin: 0px">
    <v3x:table htmlId="listTable" data="list" var="bean" pageSize="${pageSize }" size="${size}" showHeader="true" showPager="true" isChangeTRColor="true">
		<v3x:column width="4%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
		<input type='checkbox' name='id' value="<c:out value="${bean.mailNumber}"/>" />
		</v3x:column>
		<v3x:column width="3%" widthFixed="true" align="center" label="<font color='red'><b>!</b></font>">
			<c:choose>
				<c:when test="${bean.priority==2||bean.priority==1}"><font color='red'>!!</font></c:when>
				<c:when test="${bean.priority==4||bean.priority==5}">&nbsp;</c:when>
				<c:otherwise><font color='red'>!</font></c:otherwise>
			</c:choose>
		</v3x:column>
		<v3x:column width="3%" widthFixed="true" align="center" label="<span class='attachment_true'></span>">
			<c:choose>
				<c:when test="${bean.hasAffix}"><span class='attachment_true'></span></c:when>
				<c:otherwise>&nbsp;</c:otherwise>
			</c:choose>
		</v3x:column>
		<v3x:column width="40%" type="String" onDblClick="displayDetail('${bean.mailNumber}',2);" onClick="displayDetail('${bean.mailNumber}',1);"
			label="label.head.subject" className="cursor-hand sort" alt="${bean.subject}">
			${v3x:toHTML(v3x:getLimitLengthString(bean.subject, 60, '...'))}
		</v3x:column>
		<v3x:column width="25%" type="String" onDblClick="displayDetail('${bean.mailNumber}',2);" onClick="displayDetail('${bean.mailNumber}',1);"
			label="label.head.from" className="cursor-hand sort" alt="${bean.from}">
			<c:out value="${bean.from}" />
		</v3x:column>
		<v3x:column width="15%" type="String" onDblClick="displayDetail('${bean.mailNumber}',2);" onClick="displayDetail('${bean.mailNumber}',1);"
			label="label.head.date" className="cursor-hand sort">
			<fmt:formatDate value="${bean.sendDate}" pattern="${datePattern}"/>
		</v3x:column>
		<v3x:column width="10%" type="String" onDblClick="displayDetail('${bean.mailNumber}',2);" onClick="displayDetail('${bean.mailNumber}',1);"
			label="label.head.size" className="cursor-hand sort" alt="${v3x:formatFileSize(bean.size, true)}">
			<c:out value="${v3x:formatFileSize(bean.size, true)}" />
		</v3x:column>
	</v3x:table>
	</form>
	</div>
	</div>
	</div>
  <iframe name="fetchIframe" id="fetchIframe" style="display:none"></iframe>
  <iframe name="downloadFrame" id="downloadFrame" style="display:none"></iframe>
  <script type="text/javascript">
  initIpadScroll("scrollListDiv",550,870);
  showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.email.garbage' bundle='${v3xMainI18N}' />", [1,4], pageQueryMap.get('count'), _("MailLang.detail_info_405"));	
  showCtpLocation('F16_mailtrash');
  </script>
  </body>
</html>
