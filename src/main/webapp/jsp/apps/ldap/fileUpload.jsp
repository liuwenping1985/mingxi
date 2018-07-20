<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="header.jsp"%>
<title><fmt:message key="fileupload.page.title" bundle="${v3xMainI18N}"/></title>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
<script type="text/javascript">
<c:if test="${parseTime != null}">
try {
  window.returnValue=${parseTime};
  window.close();
} catch(e) {
  alert(e);
}
</c:if>
function submitform() {
  //文件名后缀
  var fileURL = document.getElementById('file1').value;
  var filePostfix = fileURL.substring(fileURL.lastIndexOf('.') + 1);
  if (!checkFile(filePostfix.toLowerCase())) {
    alert("<fmt:message key='ldap.alert.selectldif' bundle='${ldaplocale}'/>");
    return;
  }
  var form = document.all("uploadForm");
  if (document.getElementById('file1').value != "" && document.getElementById('file1').value.length != 0) {
    alert('<fmt:message key="ldap.alert.wait" bundle="${ldaplocale}"/>');
    show();
    document.getElementById("b1").disabled = true;
    document.getElementById("submintCancel").disabled = true;
    form.submit();
  } else {
    alert("<fmt:message key='ldap.alert.select' bundle='${ldaplocale}'/>");
  }
}

function endProcess() {
  try {
    window.onbeforeunload = null;
    document.getElementById("b1").disabled = false;
    document.getElementById("submintCancel").disabled = false;
    document.getElementById("upload1").style.display = "";
    document.getElementById("title1").style.display = "";
    document.getElementById("uploadprocee").style.display = "none";
  } catch(e) {
    alert(e);
  }
}
function checkFile(s) {
  var regu = /ldif|ldf/;
  var re = new RegExp(regu);
  if (re.test(s)) {
    return true;
  } else {
    return false;
  }
}
function show() {
  document.getElementById("upload1").style.display = "none";
  document.getElementById("title1").style.display = "none";
  document.getElementById("uploadprocee").style.display = "";
}
</script>
</head>
<body bgColor="#f6f6f6" scroll="no">
<form enctype="multipart/form-data" method="POST" name="uploadForm" target="fileUploadFrame" action="/seeyon/ldap/ldap.do?method=uploadProcess">
   <table class="popupTitleRight" width="100%" height="100%"  align="center" border="0" cellspacing="0" cellpadding="0">
      <tr>
         <td height="20" class="PopupTitle">
            <fmt:message key="import.choose.file" />
         </td>
      </tr>
      <tr>
         <td id="upload1" class="bg-advance-middel" style="vertical-align: middle">
            <div>
               <fmt:message key="fileupload.selectfile.label" bundle="${v3xMainI18N}">
                  <fmt:param value="${v3x:outConditionExpression(!empty param.maxSize, param.maxSize, maxSize)}" />
               </fmt:message>
            </div>
            <INPUT type="file" name="file1" id="file1" style="width: 100%"></td>
      </tr>
      <tr>
         <td  id="title1" height="10"  align="left" style="padding-left: 15px">
            <label for="deleteAll">
               <input type="checkbox" id="deleteAll"  name="bindingOption" value="${deleteAll }">
               <fmt:message key="ldap.alert.bindingempty" bundle="${ldaplocale}"/>
            </label>
            <label for="coverAll">
               <input type="checkbox" id="coverAll" name="bindingOption" value="${coverAll }">
               <fmt:message key="ldap.alert.invalidbinding" bundle="${ldaplocale}"/>
            </label>
         </td>
      </tr>
      <tr>
         <td id="uploadprocee"  align="center" class="bg-advance-middel" style="display: none;">
            <table width="240" height="45" border="0" cellspacing="0" cellpadding="0" bgcolor='#F6F6F6'>
               <tr>
                  <td align='center'  valign='bottom'>
                     <fmt:message key="fileupload.uploading.label" bundle="${v3xMainI18N}"/>
                     ...
                  </td>
               </tr>
               <tr>
                  <td align='center' height='30'>
                     <div class='process'>&nbsp;</div>
                  </td>
               </tr>
            </table>
         </td>
      </tr>
      <tr>
         <td  id="title1" height="20" class="bg-imges2" align="right" style="padding-left: 15px">
            <label title="<fmt:message key='ldap.alert.supportfile' bundle='${ldaplocale}'/>">
            (<fmt:message key="ldap.alert.supportfile" bundle='${ldaplocale}'/>)
         </label>
      </td>
   </tr>
   <tr>
      <td height="42" align="right" class="bg-advance-bottom">
         <input type="button" id="b1" name="b1" onclick="submitform()"value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" class="button-default-2">&nbsp;
         <input id="submintCancel" type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" class="button-default-2">
      </td>
   </tr>
</table>
</form>
<iframe name="fileUploadFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>