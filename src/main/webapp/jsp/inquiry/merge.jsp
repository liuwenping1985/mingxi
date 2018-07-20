<!DOCTYPE HTML>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<html style="height: 100%">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='inquiry.unite.item.label'/></title>
<script>
    function meger(){
          var obj  = transParams.parentWin;
		  obj.document.mainForm.newItem.value=mergeForm.mergename.value;
		  if(mergeForm.mergename.value=="" || mergeForm.mergename.value.length==0){
		  		alert(v3x.getMessage("InquiryLang.inquiry_add_merge_item_alert"));
                return;
		  }
		  transParams.parentWin.mergeinquiryCollBack();
    }
    function cancelMeger(){
    	  var obj  = transParams.parentWin;
		  obj.document.mainForm.newItem.value="*&*cancelMeger*&*";
		  transParams.parentWin.mergeinquiryCollBack();
    }
</script>
</head>
<body scroll="no" class="main-bg" style="height: 100%">
<form name="mergeForm" action="" method="post"  onsubmit="return false" style="height: 100%">
     <table width="100%" border="0" height="100%" cellspacing="0" cellpadding="0" >
  <tr>
    <td align="center" style="padding: 5px;">
    	<fieldset style="height: 80px;padding: 10px;">
    		<legend>
    			<font size="2" style="font-weight: bold;"><fmt:message key='inquiry.unite.item.label'/></font>
    		</legend>
    		<br/>
			<font size="2"><fmt:message key='inquiry.question.uniteItem.label'/>:</font>
			<input type="text" maxlength="40" size="40" name="mergename" />
    	</fieldset>
    </td>
  </tr>
  <tr>
    <td class="bg-advance-bottom" align="right">
    	<input type="button" name="b1" class="button-default_emphasize" value="<fmt:message key='common.button.ok.label'  bundle='${v3xCommonI18N}' />" onclick="meger()">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="b1" value="<fmt:message key='common.button.cancel.label'  bundle='${v3xCommonI18N}' />" onclick="cancelMeger()" class="button-default-2"/>
    </td>
  </tr>
</table>
</form>
</body>
</html>