<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>印章管理</title>
<%@include file="header.jsp"%>
<script type="text/javascript"><!--
showCtpLocation("F12_perSignet");

	function doEdit(){
		var theSelect=document.getElementById("doSelect");
		if(theSelect.value==''){
			alert('请选择印章!');
			return ;
		}
		var _select="";
		for(var j=0;j<theSelect.options.length;j++){
			if(theSelect.options[j].selected  == true ){
				 _select =theSelect.options[j].value;
			}
		}
		if( _select != "" ){
			if ( checkForm(document.getElementById("modifySignetForm")) == true ){
				if ( validateSignetpassword() == true ){
					if ( validsignet(_select) == true ){
					
				try{
    			var requestCaller = new XMLHttpRequestCaller(this, "signetManager", "ajaxIsCancelled", false);
    			requestCaller.addParameter(1, "String", _select);
    			var ds = requestCaller.serviceRequest();
    			if(ds == 'false'){
    				alert('授权已被管理员取消');
    				window.location.href = window.location.href;
    				return;
	   			 }else if(ds == 'true'){
	   			 		document.getElementById("modifySignetForm").action="<html:link renderURL='/signet.do' />?method=editPassword&markid="+_select;
						document.getElementById("modifySignetForm").submit();
	   			 }
  			  }catch(e){
   			  }					
					}
				}
			}
		}else{
			alert(v3x.getMessage("sysMgrLang.system_modify_signet"));
		}
	}
	function resetForm(){
		document.getElementById("password").value="";
		document.getElementById("newSignetword").value="";
		document.getElementById("validateSignetword").value="";
	}
</script>
</head>
<body scroll="no">
<form enctype="multipart/form-data" id="modifySignetForm" name="modifySignetForm" method="post" action="<html:link renderURL='/signet.do' />?method=editSignet" onsubmit="return (checkForm(this) && validatepassword())" target="tempIframe">
 <input type="hidden" id="id" name="id" value="${signet.id}">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page-list-border">
		<tr class="page2-header-line">
			<td width="100%" height="41" valign="top" class="page-list-border-LRD">
				 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
			     	<tr class="page2-header-line">
			        	<td width="45" class="page2-header-img"><div class="showMessageSetting"></div></td>
						<td class="page2-header-bg" width="380"><fmt:message key='signet.password.sign' /></td>
						<td class="page2-header-line padding-right" align="right"></td>
						<td>&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>  
	  <tr>
	    <td valign="top" height="100%">
	    <br><br><br><br>
 		<input type="hidden" id="id" name="id" value="${signet.id}">
			<table  width="40%" border="0" cellspacing="0" cellpadding="3" align="center">
				<c:set var="ro" value="${v3x:outConditionExpression(readOnly, 'readonly', '')}" />
				<c:set var="dis" value="${v3x:outConditionExpression(readOnly, 'disabled', '')}" />
				<tr>  
					<td width="20%" nowrap="nowrap" align="right">
					  <label for="name"> <font color="red">*</font><fmt:message key="signet.password.choscesign" />:</label>
					</td>
					<td class="new-column" width="60%">
						<select name="doSelect" id="doSelect" class="input-100per" onchange="resetForm()">
							<option value="">   < <fmt:message key="signet.password.choscesign.title" /> >  </option>
							<c:forEach items="${signetList }" var="acount" >
								<option id="acount.id" value="${acount.id }">${v3x:toHTML(acount.markName)}</option>
							</c:forEach>
						</select>
					</td>
					<td width="20%" >&nbsp;</td>
				</tr>
				<tr>
					<td nowrap="nowrap" align="right">
						<label for="post.code"> <font color="red">*</font><fmt:message key="manager.formerpassword.notnull" />:</label>
					</td>
					<td class="new-column" >
						<input maxSize="16" minLength="6" maxlength="16" class="input-100per" type="password" name="password" id="password" value="${signet.password}"
						${ro}  inputName="<fmt:message key="manager.formerpassword.notnull" />"
						validate="notNull" />
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td  nowrap="nowrap" align="right"><label
						for="post.code"> <font color="red">*</font> <fmt:message key="manager.password.notnull" />:</label></td>
					<td class="new-column" >
						<input id="newSignetword" class="input-100per" type="password" name="newSignetword" id="newSignetword" value=""
						${ro} inputName="<fmt:message key="manager.password.notnull" />" minLength="6" maxSize="16" maxLength="16"
						validate="notNull,minLength,maxLength" />
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td nowrap="nowrap" align="right">
						<label for="post.code"> <font color="red">*</font> <fmt:message key="signet.edit.validateword" />:</label>
					</td>
					<td class="new-column" >
						<input id="validateSignetword" class="input-100per" type="password" name="validateSignetword" id="validateword" value=""
						${ro} inputName="<fmt:message key="signet.edit.validateword" />" minLength="6" maxSize="16" maxLength="16"
						validate="notNull,minLength,maxLength" />
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="2"><font class="description-lable"><fmt:message key="signet.number"/></font></td>
				</tr>
			</table>
			
		</td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="button" onclick="doEdit();" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;&nbsp;&nbsp;&nbsp; 
			<input type="button" onclick="getA8Top().back()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
	</tr>
</table>
</form>	
<iframe name=tempIframe id=tempIframe style="height:0px;width:0px;"></iframe>
</body>
</html>