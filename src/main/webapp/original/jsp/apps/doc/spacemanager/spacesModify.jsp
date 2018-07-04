<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="spaceHeader.jsp" %>
<%@include file="../../../common/INC/noCache.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<style type="text/css">
.categorySet-body{
	height: 98%;
}
</style>
</head>
<script type="text/javascript">
<!--

	function setspaceIds(){
	   var _parent = window.opener;
	   var spaceIds="";
	   if(_parent == null){
			_parent = window.dialogArguments;
		}
		var theIds= _parent.parent.main.document.getElementsByName("id");
		for(var i=0;i<theIds.length;i++){
			if(theIds[i].checked){
				spaceIds += theIds[i].value + ",";
			}			
		}
		document.getElementById("spaceIds").value = spaceIds ;	
	}
	
	
	
	function modifyDocSpace(docSpaceId){
		var _docSize=document.getElementById("docSize");
		var _mailSize=document.getElementById("mailSize");
		var _blogSize=document.getElementById("blogSize");
		
		if (_docSize && _docSize != null) {
            if(validateInteger(_docSize.value)){
                alert(v3x.getMessage("DocLang.doc_space_total_size_not_integer"));
                return ;
            }
        }
        
        if (_mailSize && _mailSize != null) {
            if(validateInteger(_mailSize.value)){
                alert(v3x.getMessage("DocLang.doc_space_total_size_not_integer"));
                return ;
            }
        }
        
        if (_blogSize && _blogSize != null) {
            if(validateInteger(_blogSize.value)){
                alert(v3x.getMessage("DocLang.doc_space_total_size_not_integer"));
                return ;
            }
        }

		if(!checkForm(theForm)){
			return false;		
		}else {
				// 文档
				if(_docSize){
    				var docsize = document.getElementById("docSize").value;
    				if(docsize > 10 * 1024){
    					alert(v3x.getMessage('DocLang.doc_space_doc_more_than_max'));
    					return;
    				}
				}
				
				// 邮件
				if(_mailSize){
					var docsize = document.getElementById("mailSize").value;
					if(docsize > 10 * 1024){
						alert(v3x.getMessage('DocLang.doc_space_mail_more_than_max'));
						return;
					}
				}
				
				// 博客
				if(_blogSize){
					var docsize = _blogSize.value;
					if(docsize < 10){
						alert(v3x.getMessage('DocLang.doc_space_blog_less_than_min'));
						return;
					}else if(docsize > 1 * 1024){
						alert(v3x.getMessage('DocLang.doc_space_blog_more_than_max'));
						return;
					}
				}
		}
		
		theForm.action=spaceURL + "?method=SpacesModify&spaceId="+docSpaceId;
		theForm.target="spaceIframe";
	
		document.getElementById("btn1").disabled = true;
		document.getElementById("btn2").disabled = true;
		
		theForm.submit();	   
	}
	
	function validateInteger(obj){
		var pattern=/^\+?[0-9][0-9]*$/;
		if(pattern.test(obj)){
			return false;
		}else{
			return true;
		}
	}
//-->
</script>
<body scroll="no" onload="setspaceIds()">
<form action="" id="theForm" name="theForm" method="post"> 
<input type="hidden" value="${spaceIds}" name="spaceIds" id="spaceIds" />   
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td  height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="150" nowrap="nowrap"><fmt:message key="doc.space.set.label"/></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;<font color="red">*</font><fmt:message key='common.notnull.label' bundle="${v3xCommonI18N}" />
						
					 </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	<td class="categorySet-head">
	<table height="100%" width="100%" cellpadding="0" cellspacing="0">
<tr>
<td valign="top">
<table width="60%" border="0" cellspacing="0" cellpadding="0" align="center">
<c:if test="${v3x:hasPlugin('doc')}">
<tr>
	<td align="center" valign="top">

<fieldset style="width:95%" align="center"><legend><strong><fmt:message key='doc.space.doc.space'/></strong></legend>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
<tr>
	<td class="bg-gray" width="30%" nowrap>	
	<span style="color:red;">*</span><fmt:message key='doc.space.totalsize.label'/>:</td><td class="new-column" width="70%">	
			<input type="text" name="docSize" id="docSize" style="width:50%;" 
			inputName="<fmt:message key='doc.space.doc.space'/>" validate="notNull, isNumber"
			 value="<c:out value="${docSize}" escapeXml="true" />"
			 ${v3x:outConditionExpression(readOnly, 'readonly', '')}
			 />&nbsp;MB
	</td>
</tr>
<tr>
		<td colspan="2">&nbsp;</td>
	</tr>

	</table>
	</fieldset>
	</td>
	</tr>
</c:if>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<c:if test="${v3x:hasPlugin('webmail')}">
	<tr>
	<td align="center" valign="top">
	<fieldset style="width:95%" align="center"><legend><strong><fmt:message key='doc.space.mail.space'/></strong></legend>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td class="bg-gray" width="30%" nowrap><span style="color:red;">*</span><fmt:message key='doc.space.totalsize.label'/>:</td><td class="new-column" width="70%">
		<input type="text" name="mailSize" id="mailSize"  style="width:50%;" deaultValue="${theSpace}" 
				inputName="<fmt:message key='doc.space.mail.space'/>" validate="notNull, isNumber"
				 value="<c:out value="${mailSize}" escapeXml="true" default='${theSpace}' />"
				 ${v3x:outConditionExpression(readOnly, 'readonly', '')}
				onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)" />&nbsp;MB
		</td>
	</tr>
<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	</table>
	</td>
	</tr>
	</c:if>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<%--判断blog开关 --%>
	<c:if test="${v3x:hasPlugin('blog') && v3x:isEnableSwitch('blog_enable')}">
	<tr>
	<td align="center" valign="top">
	<fieldset style="width:95%" align="center"><legend><strong><fmt:message key='doc.space.blog.space'/></strong></legend>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
<tr>
	<td class="bg-gray" width="30%" nowrap><span style="color:red;">*</span><fmt:message key='doc.space.totalsize.label'/>:</td><td class="new-column" width="70%">
	<input type="text" name="blogSize" id="blogSize"  style="width:50%;" deaultValue="${theSpace}" 
			inputName="<fmt:message key='doc.space.blog.space'/>" validate="notNull, isNumber"
			 value="<c:out value="${blogSize}" escapeXml="true" default='${theSpace}' />"
			 ${v3x:outConditionExpression(readOnly, 'readonly', '')}
			onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)" />&nbsp;MB
	</td>
</tr>
<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	</table>
	</fieldset>
	</td>
	</tr>
</c:if>
</table>
</td>
</tr>

</table>
	</td></tr>
	<tr id="enEdiable">
		<td height="42" align="center" class="bg-advance-bottom">
		<input type="button" id="btn1" class="button-default_emphasize"  onclick="modifyDocSpace('${spaceVo.docStorageSpace.id}')" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" name="mody"    > 
		<input type="button" id="btn2" class="button-default-2" onclick="window.close()" value="<fmt:message key='common.toolbar.back.label' bundle="${v3xCommonI18N}" />" name="reset"> 
		</td>
	</tr>
	</table>
	<input type="hidden" id="docUsedSize" name="docUsedSize" value="${docUsedSize}">
	<input type="hidden" id="mailUsedSize" name="mailUsedSize" value="${mailUsedSize}">
	<input type="hidden" id="blogUsedSize" name="blogUsedSize" value="${blogUsedSize}">
</form>
<script type="text/javascript">
	var _dbClick='${dbClick}';
	if(_dbClick == 'true'){
		document.getElementById("enEdiable").style.display="";
	}
	else{
		document.getElementById("enEdiable").style.display="none";
		if (document.getElementById("docSize")) {
		    document.getElementById("docSize").disabled = true;
		}
		if (document.getElementById("mailSize")) {
		    document.getElementById("mailSize").disabled = true;
		}
		if (document.getElementById("blogSize")) {
			document.getElementById("blogSize").disabled = true;
		}
	}
</script>
<iframe id="spaceIframe" name="spaceIframe" marginheight="0" marginwidth="0" width="0" height="0"></iframe>
</body>
</html>