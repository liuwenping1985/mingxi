<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.ctp.common.constants.Constants" %>	
<%@ include file="../webmailheader.jsp" %>
<html>
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  	<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
	<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
	<meta HTTP-EQUIV="Expires" CONTENT="0">
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
    <title><fmt:message key='label.mail' />-<fmt:message key='label.mail.set' /></title>
  	<script type="text/javascript">

  		function doCreate(flag)
  		{
  			if(v3x.getBrowserFlag('pageBreak')){
  				parent.detailFrame.document.location.href = "${webmailURL}?method=set&flag="+flag;
  			}else{
  			    v3x.openWindow({
  				     url: "${webmailURL}?method=set&flag="+flag,
  				     dialogType:'open',
  				     workSpace: 'yes'
  				});
  	  		}
  		}
  		function doDel()
  		{
     		if(isSelected() == 0){
  				alert(v3x.getMessage('MailLang.mail_least_delete'));
  				return false;
  			}		 		
  			if(isSelected()>0)
  			{
  				if(confirm("<fmt:message key='label.alert.set.delete'/>"))
  				{
  					document.listForm.action="${webmailURL}?method=delMailSet";
  					document.listForm.target="_parent";
  					document.listForm.submit();
  					try{
  					  getA8Top().startProc('');
  					}catch(e){}
  				}
  			}
  		}

  		
  		function setDefault()
  		{
  			if(isSelected()==1)
  			{
				document.listForm.action="${webmailURL}?method=setDefaultMailBox";
				document.listForm.target="_parent";
				document.listForm.submit();
				try{
				  getA8Top().startProc('');
				}catch(e){}
  			}else if(isSelected()>1){
  				alert(v3x.getMessage("MailLang.mail_alertSelOneEdocForm_Only"));
  				return false;
  			}else if(isSelected() == 0){
  				var msg = "<fmt:message key='label.alert.set.select'/>";	
  				alert(msg);
  				return false;
  			}
  		}
  		function isSelected(){
  			var msg = "<fmt:message key='label.alert.set.select'/>";
  			var items = document.getElementsByName("id");
  			var selectCount = 0;
  			for(var i = 0; i < items.length; i++){
  				if(items[i].checked){
					selectCount++;
  				}
  			}
  			return selectCount;
  		}
  		
function editOneLine(flag){
	var chkid = document.getElementsByName('id');
	var count = 0;
	var id = "";
	for(var i = 0; i < chkid.length; i++){
		if(chkid[i].checked){
			count++;
			id = chkid[i].value;
		}
	}
	
	if(count == 0){
		alert(v3x.getMessage('MailLang.mail_least_select_singleton'));
		return false;
	}else if(count > 1){
		alert(v3x.getMessage('MailLang.mail_alertSelOneEdocForm_Only'));
		return false;
	}

	if(v3x.getBrowserFlag('pageBreak')){
		parent.detailFrame.document.location.href='${webmailURL}?method=set&email='+id+'&flag='+flag;	
	}else{
	    v3x.openWindow({
		     url: '${webmailURL}?method=set&email='+id+'&flag='+flag,
		     dialogType:'open',
		     workSpace: 'yes'
		});
 	}

}

	
  		function editMailSet(id, flag)
  		{
  			if(v3x.getBrowserFlag('pageBreak')){
  				parent.detailFrame.document.location.href = "${webmailURL}?method=set&email=" + id +"&flag=" + flag;
  			}else{
  				v3x.openWindow({
  				     url: "${webmailURL}?method=set&email=" + id +"&flag=" + flag,
  				     dialogType:'open',
  				     workSpace: 'yes'
  				});
  	  		}
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
    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
    	myBar.add(new WebFXMenuButton("create", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", "doCreate('new')", [1,1], "", null));
    	myBar.add(new WebFXMenuButton("edit",   "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "editOneLine('edit');", [1,2], "", null));
   		myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>", "doDel()", [1,3], "", null));
    	myBar.add(new WebFXMenuButton("setDefault", "<fmt:message key='button.setdefault' />", "setDefault()", [17,9], "", null));
    	document.write(myBar);
    	document.close(); 
    </script>
		</td>
	</tr>
	</table>
    
    </div>
    <div class="center_div_row2"  id="scrollListDiv">
    <form name="listForm" id="listForm" method="post" style="margin: 0px">
    <v3x:table htmlId="listTable" data="list" var="bean" showHeader="true" showPager="false" pageSize="${pageSize}" size="${size}" isChangeTRColor="true" className="sort ellipsis">
		<v3x:column width="3%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
			<input type='checkbox' name='id' id="id" value='<c:out value="${bean.email}"/>' />
		</v3x:column>
		<v3x:column width="8%" type="String" onDblClick="editMailSet('${bean.email}', 'edit')" onClick="editMailSet('${bean.email}', 'view')" className="cursor-hand sort" align="center"  label="label.alert.defaultbox">
			<c:choose>
				<c:when test="${bean.defaultBox}"><fmt:message key='common.true' bundle='${v3xCommonI18N}'/></c:when>
				<c:otherwise>&nbsp;</c:otherwise>
			</c:choose>
		</v3x:column>
		<v3x:column width="12%" type="String" value="${bean.email}" maxLength="20" onDblClick="editMailSet('${bean.email}', 'edit')" onClick="editMailSet('${bean.email}', 'view')" label="label.alert.email" className="cursor-hand sort" alt="${bean.email}">
		</v3x:column>
		<v3x:column width="20%" type="String" value="${bean.pop3Host}" maxLength="20" onDblClick="editMailSet('${bean.email}', 'edit')" onClick="editMailSet('${bean.email}', 'view')" label="label.alert.pop" className="cursor-hand sort" alt="${bean.pop3Host}">
		</v3x:column>
		<v3x:column width="20%" type="String" value="${bean.smtpHost}" maxLength="20" onDblClick="editMailSet('${bean.email}', 'edit')" onClick="editMailSet('${bean.email}', 'view')" label="label.alert.smtp" className="cursor-hand sort" alt="${bean.smtpHost}">
		</v3x:column>
		<v3x:column width="12%" type="String" maxLength="16" onDblClick="editMailSet('${bean.email}', 'edit')" onClick="editMailSet('${bean.email}', 'view')" label="label.alert.username" className="cursor-hand sort" alt="${bean.userName}" value="${bean.userName}">
		</v3x:column>
		<v3x:column width="25%" type="String" onDblClick="editMailSet('${bean.email}', 'edit')" onClick="editMailSet('${bean.email}', 'view')" label="label.alert.backup" className="cursor-hand sort" alt="">
			<c:choose>
				<c:when test="${bean.backup}"><fmt:message key='label.alert.isbackup' /></c:when>
				<c:otherwise><fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/></c:otherwise>
			</c:choose>
		</v3x:column>
	</v3x:table>
	</form>
	</div>
	</div>
</div>
<script type="text/javascript">
initIpadScroll("scrollListDiv",550,870);
showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.email.option' bundle='${v3xMainI18N}' />", [1,4], null, _("MailLang.detail_info_406"));	
showCtpLocation('F17_mailset');
</script>
  </body>
</html>
