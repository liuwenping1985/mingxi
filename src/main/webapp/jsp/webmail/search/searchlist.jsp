<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.v3x.common.constants.Constants" %>
<%@ include file="../webmailheader.jsp" %>
<script type="text/javascript">
		function displayDetail(mailNumber)
		{
			var _url = "<c:url value='/webmail.do?method=show&folderType=${folderType}&showType=0' />";
			var rv = v3x.openWindow({
				url: _url + "&mailNumber=" + mailNumber,
				workSpace: 'yes',
				dialogType:v3x.getBrowserFlag('openWindow')?'modal':'open',
	            resizable: false
			});

			//parent.detailFrame.location.href = url + "&mailNumber=" + mailNumber;
		}
		function delMail()
  		{
  			if(isSelected() == 0){
  				alert("<fmt:message key='label.alert.error.delete'/>");
  				return false;
  			}
  			if(confirm("<fmt:message key='label.alert.error.comfirmdel'/>")){
				var form = document.getElementById("listForm");
				form.target="_parent";
				var url = "${webmailURL}?method=move";
				url += "&fromFolder=2&toFolder=${folderType}";
				form.action = url;
				form.submit();
  			}
		}
	function remove(folderType)
		{
			if(isSelected() == 0){
  				alert("<fmt:message key='label.alert.error.move'/>");
  				return false;
  			}
  			if(confirm("<fmt:message key='label.alert.error.comfirmmove'/>")){
				var form = document.getElementById("listForm");
				form.target="_parent";
				var url = "${webmailURL}?method=move";
				url += "&toFolder="+folderType+"&fromFolder=${folderType}";
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
				url += "&folder=${folderType}";
				form.action = url;
				form.submit();
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
			var url = "<c:url value='/webmail.do?method=download' />";
			url += "&folderType=${folderType}";
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
				for(var i = 0; i < items.length - 1; i++){
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
<html>
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  	<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
	<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
	<meta HTTP-EQUIV="Expires" CONTENT="0">
    <title><fmt:message key='label.mail' />-<fmt:message key='label.mail.search' /></title>
  </head>
<body scroll="no" >
<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0" class="main-bg">
	<tr height="10">
		<td valign="top" style="padding: 0px 5px">
			<div class="portal-layout-cell gov_nobackground  gov_border" style="padding: 5px">		  	
				<span class="searchSectionTitle"><fmt:message key="label.search.title"/>:</span>
			</div>  
		</td>
	 </tr>
	<tr>
		<td style="padding: 0 5px;">
		    <div class="scrollList" id="scrollListDiv">
		    <form name="listForm" id="listForm" method="post" style="margin: 0px">
		    <v3x:table htmlId="listTable" data="list" var="bean" showHeader="true" showPager="true" isChangeTRColor="false">
						<input type='hidden' name="mailLongId_<c:out value='${bean.mailNumber}' />" value="${bean.mailLongId}"/>
				<v3x:column width="3%" align="center" label="<font color='red'><b>!</b></font>">
					<c:choose>
						<c:when test="${bean.priority==2||bean.priority==1}"><font color='red'>!!</font></c:when>
						<c:when test="${bean.priority==4||bean.priority==5}">&nbsp;</c:when>
						<c:otherwise><font color='red'>!</font></c:otherwise>
					</c:choose>
				</v3x:column>
				<v3x:column width="4%" align="center" label="<span class='attachment_true'></span>">
					<c:choose>
						<c:when test="${bean.hasAffix}"><span class='attachment_true'></span></c:when>
						<c:otherwise>&nbsp;</c:otherwise>
					</c:choose>
				</v3x:column>
				<v3x:column width="40%" type="String" onDblClick="displayDetail('${bean.mailNumber}');" onClick="displayDetail('${bean.mailNumber}');"
					label="label.head.subject" className="cursor-hand sort" alt="${bean.subject}">
					<c:out value="${bean.subject}" />
				</v3x:column>
				<v3x:column width="25%" type="String" onDblClick="displayDetail('${bean.mailNumber}');" onClick="displayDetail('${bean.mailNumber}');"
					label="label.head.from" className="cursor-hand sort" alt="${bean.from}">
					<c:out value="${bean.from}" />
				</v3x:column>
				<v3x:column width="16%" type="String" onDblClick="displayDetail('${bean.mailNumber}');" onClick="displayDetail('${bean.mailNumber}');"
					label="label.head.date" className="cursor-hand sort">
					<fmt:formatDate value="${bean.sendDate}" pattern="${datePattern}"/>
				</v3x:column>
				<v3x:column width="8%" type="String" onDblClick="displayDetail('${bean.mailNumber}');" onClick="displayDetail('${bean.mailNumber}');"
					label="label.head.size" className="cursor-hand sort" alt="${v3x:formatFileSize(bean.size, true)}">
					<c:out value="${v3x:formatFileSize(bean.size, true)}" />
				</v3x:column>
			</v3x:table>
			</form>
			</div>					
		</td>
	</tr>
</table>
  <iframe name="downloadFrame" id="downloadFrame" style="display:none"></iframe>
  <script>
  initIpadScroll("scrollListDiv",550,870);
  showCtpLocation('F18_mailsearch');
  </script>
  </body>
</html>
