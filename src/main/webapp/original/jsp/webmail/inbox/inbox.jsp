<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.ctp.common.constants.Constants" %>
<%@ include file="../webmailheader.jsp" %>
<script type="text/javascript">
	getA8Top().showLocation(402);
</script>
<script type="text/javascript" src="<c:url value='/apps_res/collaboration/js/CollaborationApi.js${v3x:resSuffix()}'/>"></script>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  	<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
	<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
	<meta HTTP-EQUIV="Expires" CONTENT="0">
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
    <title></title>
  	<script type="text/javascript">
  		function doFetchMail(email)
  		{
  			parent.document.location.href = "${webmailURL}?method=fetch&email=" + email;
  			if(getA8Top().$ && getA8Top().$.progressBar){
  				getA8Top()._webmailProce = getA8Top().$.progressBar({
  					text: "<fmt:message key='label.alert.fetch'/>"
  				});
  			}else{
  				getA8Top().startProc("<fmt:message key='label.alert.fetch'/>");
  			}
  		}
		//根据邮箱类型筛选邮件
		function siftMail(inboxId){
			//alert(inboxType);
			var url ;
			if(inboxId==1){
				 url = "${webmailURL}?method=list_inbox";
			}else{
				 url = "${webmailURL}?method=siftMail&inboxId=" +inboxId ;
			}
			var form = document.getElementById("listForm");
			//form.target="_parent";
			form.action = url;
			form.submit();
       	}
  		function displayDetail(mailNumber,type)
		{
  			if(!v3x.getBrowserFlag('pageBreak')){
  				type = 2;
  	  		}
			if(type==1){
			url = "${webmailURL}?method=show&folderType=1&showType=0";
			parent.detailFrame.location.href = url + "&mailNumber=" + mailNumber;
			}else if(type==2){
				v3x.openWindow({
				        url: "${webmailURL}?method=show&folderType=1&showType=0"+ "&mailNumber=" + mailNumber,
				        dialogType:'open',
				        workSpace: 'yes'
				});
			}
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
				url += "&fromFolder=1&toFolder=3";
				form.action = url;
				form.submit();
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
				url += "&toFolder="+folderType+"&fromFolder=1";
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
				url += "&folder=1";
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
		function doReply(flag)
		{
			var count = isSelected();
			if(count == 0){
				alert("<fmt:message key='label.alert.error.reply'/>");
				return false;
			}
			if(count > 1){
				alert("<fmt:message key='label.alert.error.replyonly'/>");
				return false;
			}
			var form = document.getElementById("listForm");
			form.target="_parent";
			url = "${webmailURL}?method=reply&folderType=1";
			url += "&flag=" + flag;
			form.action = url;
			form.submit();
		}
		function doResend()
		{
			var count = isSelected();
			if(count == 0){
				alert("<fmt:message key='label.alert.error.fw'/>");
				return false;
			}
			if(count > 1){
				alert("<fmt:message key='label.alert.error.fwonly'/>");
				return false;
			}
			var form = document.getElementById("listForm");
			form.target="_parent";
			url = "${webmailURL}?method=edit&folderType=1&Fw=Fw";
			form.action = url;
			form.submit();
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
			url += "&folderType=1";
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

		function convertToCol(){
		    if(isSelected() == 0){
  				alert("<fmt:message key='label.alert.error.fw'/>");
  				return false;
  			}
  			
  		  var checkedIds = document.getElementsByName('id');
		  var len = checkedIds.length;
		  var str = "";
		  var num = 0;
		  for(var i = 0; i < len; i++) {
		  		var checkedId = checkedIds[i];
				if(checkedId && checkedId.checked){			
					num += 1;
					str += checkedId.value;
					str +=","
				}
			}

			if(num>1){
		  	alert("<fmt:message key='label.alert.error.fwonly'/>");
		  	return;
			}
			if(str.length>0){
				str = str.substring(0,str.length-1);
			}
			var params = {
						    bodyType : '10',
						    manual : 'true',
						    personId : '',
						    from : '',
						    handlerName : 'webmail',
						    sourceId : str,
						    ext : '1'
						}
			collaborationApi.newColl(params);
		}
		function autoToCol(){
		    if(isSelected() == 0){
  				alert("<fmt:message key='label.alert.error.fw'/>");
  				return false;
  			}
				var form = document.getElementById("listForm");
				form.target="_parent";
				var url = "<html:link renderURL='/webmail.do?method=autoToCol&folderType=1' />";
				//url += "?folderType=1";
				form.action = url;
				//alert(url);
				form.submit();
		}
		
  	</script>

  </head>
  <body scroll="no" class="listPadding">
  
 <div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2 webfx-menu-bar">
<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22">
    <script type="text/javascript">
    	var c_Rec = new WebFXMenu("${pageContext.request.contextPath}");
    	<c:forEach var="item" items="${mbcList}">
    		c_Rec.add(new WebFXMenuItem("email_$item.index", "${item.email}", "doFetchMail('${item.email}');"));
		</c:forEach>

		var folderNode = new WebFXMenu("${pageContext.request.contextPath}");
		folderNode.add(new WebFXMenuItem("folder_0", "<fmt:message key='label.mail.sent' />", "removeit(0)"));
		folderNode.add(new WebFXMenuItem("folder_2", "<fmt:message key='label.mail.draft' />", "removeit(2)"));
		folderNode.add(new WebFXMenuItem("folder_3", "<fmt:message key='label.mail.trash' />", "removeit(3)"));
		//收件箱账号
		var inboxNode=new WebFXMenu("${pageContext.request.contextPath}");
		<c:forEach var="inboxId" items="${mbcList}">
		    inboxNode.add(new WebFXMenuItem("email_$inboxId.index", "${inboxId.email}", "siftMail('${inboxId.email}');"));
		</c:forEach>
		inboxNode.add(new WebFXMenuItem("email_$all.index", "<fmt:message key='button.all' />", "siftMail(1)"));

    	//c_Rec.add(new WebFXMenuItem("saveAsText", "@sina.com", "getMailPop_doClick();", "<c:url value='/common/images/toolbar/send.gif'/>"));

		var transmitNode = new WebFXMenu("${pageContext.request.contextPath}");
		<c:if test="${!empty mbcList}">
    	       {
		transmitNode.add(new WebFXMenuItem("transmitNode_0", "<fmt:message key='common.toolbar.transmit.mail.label' bundle='${v3xCommonI18N}'/>", "doResend()"));
    	        }
    	       </c:if>
		<c:if test="${v3x:hasNewCollaboration()}">
			transmitNode.add(new WebFXMenuItem("transmitNode_2", "<fmt:message key='common.toolbar.transmit.col.label' bundle='${v3xCommonI18N}' />", "convertToCol()"));
		</c:if>
				
    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
    	myBar.add(new WebFXMenuButton("receive", "<fmt:message key='button.receive' />", null, [11,7], "", c_Rec));
    	myBar.add(new WebFXMenuButton("reply", "<fmt:message key='button.reply' />", "doReply(0)", [11,8], "", null));
    	myBar.add(new WebFXMenuButton("replyAll", "<fmt:message key='button.replyAll' />", "doReply(1)", [11,9], "", null));
    	if(v3x.getBrowserFlag('hideMenu')){
    		myBar.add(new WebFXMenuButton("redSent", "<fmt:message key='common.toolbar.transmit.label' bundle='${v3xCommonI18N}'/>", null, [1,7], "", transmitNode));
    	}
    	myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>", "delMail()", [1,3], "", null));
    	myBar.add(new WebFXMenuButton("deletePhy", "<fmt:message key='button.delete' />", "delMailPhy()", [11,10], "", null));
    	myBar.add(new WebFXMenuButton("domove", "<fmt:message key='button.move' />", null, [12,1], "", folderNode));
    	if(v3x.getBrowserFlag('hideMenu')){
    		myBar.add(new WebFXMenuButton("down", "<fmt:message key='button.download' />", "download()", [6,4], "", null));
    	}
		myBar.add(new WebFXMenuButton("select", "<fmt:message key='button.InboxFilter' />", null, [21,7], "", inboxNode));
    	//myBar.add(new WebFXMenuButton("archive", "<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />", "archive()", "<c:url value='/common/images/toolbar/insert.gif'/>", "", null));
		//myBar.add(new WebFXMenuButton("atoCol", "<fmt:message key='button.toCol' />", "convertToCol()", "<c:url value='/common/images/toolbar/save.gif'/>", "", null));
		document.write(myBar);
    	document.close();
    	<c:if test="${empty mbcList}">
    	{
		disableButton("receive");
    	}
         </c:if>
    </script>
		</td>
	</tr>
	</table>
    
    </div>
    <div class="center_div_row2"  id="scrollListDiv">
		    <form name="listForm" id="listForm" method="post">
		    <v3x:table htmlId="listTable" data="list" var="bean" pageSize="${pageSize}" size="${size}" showHeader="true" showPager="true" isChangeTRColor="true">
				<v3x:column width="4%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="<c:out value="${bean.mailNumber}"/>" />
				<!--input type='hidden' name="mailLongId_<c:out value='${bean.mailNumber}' />" value="${bean.mailLongId}"/-->
				</v3x:column>
				<v3x:column width="3%" widthFixed="true" align="center" label="<font color='red'><b>!</b></font>">
					<c:choose>
						<c:when test="${bean.priority==2||bean.priority==1}"><font color='red'>!!</font></c:when>
						<c:when test="${bean.priority==4||bean.priority==5}">&nbsp;</c:when>
						<c:otherwise><font color='red'>!</font></c:otherwise>
					</c:choose>
				</v3x:column>
				<v3x:column width="3%" widthFixed="true"  align="center" label="<span class='attachment_true'></span>">
					<c:choose>
						<c:when test="${bean.hasAffix}"><span class='attachment_true'></span></c:when>
						<c:otherwise>&nbsp;</c:otherwise>
					</c:choose>
				</v3x:column>
				<v3x:column width="40%" type="String" onDblClick="displayDetail('${bean.mailNumber}',2);" onClick="displayDetail('${bean.mailNumber}',1);"
					label="label.head.subject" className="cursor-hand sort" alt="${bean.subject}">
					<c:choose>
						<c:when test="${bean.readFlag }">${v3x:toHTML(v3x:getLimitLengthString(bean.subject, 60, '...'))}&nbsp;</c:when>
						<c:otherwise><strong>${v3x:toHTML(v3x:getLimitLengthString(bean.subject, 54, '...'))}&nbsp;</strong></c:otherwise>
					</c:choose>
				</v3x:column>
				<v3x:column width="25%" type="String" onDblClick="displayDetail('${bean.mailNumber}',2);" onClick="displayDetail('${bean.mailNumber}',1);"
					label="label.head.from" className="cursor-hand sort" alt="${bean.from}">
					<c:choose>
						<c:when test="${bean.readFlag }">${v3x:getLimitLengthString(bean.from, 65, '...')}&nbsp;</c:when>
						<c:otherwise><strong>${v3x:getLimitLengthString(bean.from, 65, '...')}&nbsp;</strong></c:otherwise>
					</c:choose>
				</v3x:column>
				<v3x:column width="15%" type="String" onDblClick="displayDetail('${bean.mailNumber}',2);" onClick="displayDetail('${bean.mailNumber}',1);"
					label="label.head.date" className="cursor-hand sort">
					<c:choose>
						<c:when test="${bean.readFlag }"><fmt:formatDate value="${bean.sendDate}" pattern="${datePattern}"/></c:when>
						<c:otherwise><strong><fmt:formatDate value="${bean.sendDate}" pattern="${datePattern}"/></strong></c:otherwise>
					</c:choose>
				</v3x:column>
				<v3x:column width="10%" type="Size" onDblClick="displayDetail('${bean.mailNumber}',2);" onClick="displayDetail('${bean.mailNumber}',1);" 
					label="label.head.size" className="cursor-hand sort" alt="${v3x:formatFileSize(bean.size, true)}">
					<c:choose>
						<c:when test="${bean.readFlag }">${v3x:formatFileSize(bean.size, true)}</c:when>
						<c:otherwise><strong>${v3x:formatFileSize(bean.size, true)}</strong></c:otherwise>
					</c:choose>
				</v3x:column>
			</v3x:table>
			</form>
		<iframe name="downloadFrame" id="downloadFrame" style="display:none"></iframe>
    </div>
  </div>
</div>
<script type="text/javascript">
initIpadScroll("scrollListDiv",550,870);
showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.email.receive' bundle='${v3xMainI18N}' />", [1,4], pageQueryMap.get('count'), _("MailLang.detail_info_402"));	
showCtpLocation('F13_mailinbox');
</script>
  </body>
</html>