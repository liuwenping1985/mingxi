<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@include file="header.jsp"%>
<script type="text/javascript">
function init() {
  try {
      //人员列表刷新
    getA8Top().endProc();
    //parent.listFrame.location.href = "${organizationURL}?method=listMember&reload=" + 1;
    window.parent.location.reload();
  } catch(e) {
    alert(e);
  }
}
</script>
</head>
<body onload="init()">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" >
        <tr>
            <td align="center">
                <div style="padding:20px" id="checkRTXMsg" align="center">
                    <fieldset style="width:70%;height:20%">
                        <legend>
                            <fmt:message key='org.synchron.result' bundle='${ldaplocale}'/>
                        </legend>
                        <fmt:message key='ldap.alert.bindingtime' bundle='${ldaplocale}'>
                            <fmt:param value='${showTime}'></fmt:param>
                        </fmt:message>
                    </fieldset>
                </div>
            <td>
            <td></td>
        </tr>
    </table>
</body>
</html>