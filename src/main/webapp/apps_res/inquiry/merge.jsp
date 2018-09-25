<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../WEB-INF/jsp/inquiry/inquiryHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='inquiry.unite.item.label'/></title>
<script>
    function meger(){
          var obj  = self.dialogArguments;
		  obj.document.mainForm.newItem.value=mergeForm.mergename.value;
		  if(mergeForm.mergename.value=="" || mergeForm.mergename.value.length==0){
		  		alert(v3x.getMessage("InquiryLang.inquiry_add_merge_item_alert"));
                return;
		  }
		  window.close();
    }
    function cancelMeger(){
          var obj  = self.dialogArguments;
		  obj.document.mainForm.newItem.value="*&*cancelMeger*&*";
          window.close();
    }
</script>
</head>
<body scroll="no">
<form name="mergeForm" action="" method="post"  onsubmit="return false">
     <table width="100%" border="0" height="100%" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center">
    	<fieldset>
    		<legend>
    			<font size="2"><fmt:message key='inquiry.unite.item.label'/></font>
    		</legend>
			<font size="2"><fmt:message key='inquiry.question.uniteItem.label'/>:</font>
			<input type="text" size="40" name="mergename" />
    	</fieldset>
    </td>
  </tr>
  <tr>
    <td class="bg-advance-bottom" align="right">
    	<input type="button" name="b1" value="<fmt:message key='common.button.ok.label'  bundle='${v3xCommonI18N}' />" onclick="meger()">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="b1" value="<fmt:message key='common.button.cancel.label'  bundle='${v3xCommonI18N}' />" onclick="cancelMeger()">
    </td>
  </tr>
</table>
</form>
</body>
</html>