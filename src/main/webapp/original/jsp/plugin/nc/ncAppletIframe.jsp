<%@ page isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@page import="com.seeyon.apps.nc.multi.NCMultiManager"%>
<%@page import="com.seeyon.apps.nc.multi.NCMultiManager.Provider"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${path}/common/js/V3X.js${ctp:resSuffix()}"></script>
<%
   String id=request.getParameter("fromNC");
   String url="";
   Provider provider=NCMultiManager.getInstance().getProvider(id);
   if(provider!=null){
	     url=provider.getUrl();
		 pageContext.setAttribute("url", url);
   }
 
%>
<script type="text/javascript">
<!--
var providers = new Properties();
//-->
</script>
</head>
<body>
<c:if test="${!empty url}">
<script type="text/javascript" charset="UTF-8" src="${url}/A8LoginNC.jsp"></script>
<script type="text/javascript">
<!--
try{
document.writeln(NCAppletHTMLString);
}catch(e){
  alert("${ctp:i18n('nc.multi.server.error')}"+"${url}");
}
//-->
</script>
</c:if>
<script type="text/javascript">
<!--
 function openNCPending(ncMark,id, userCode, unitCode){
	    var temp=providers.get(ncMark);
	    if(unitCode==null||unitCode==''||unitCode=='null')
         {
             unitCode='0001';
         }
	    if(temp!=null){
	    	var isExist=temp.contains(userCode+"_"+unitCode);
	    	if(isExist){
	    		document.applets["NCApplet"+"_"+ncMark].executeBussiness(id);
	    		return;
	    	}else{
                 try {document.applets['NCApplet' + '_' + ncMark].removeMe(); } catch (e) {}
      }
    }
    loadNC(ncMark, id, userCode, unitCode);
  }

  function loadNC(ncMark, id, userCode, unitCode) {
    try {
      getA8Top().startProc('Login ERP as ' + userCode + '...');
      window.setTimeout("loginNC('" + ncMark + "', '" + id + "', '" + userCode
          + "', '" + unitCode + "')", 500);
    } catch (e) {
      alert(e.message);
    }
  }
  function loginNC(ncMark, id, userCode, unitCode) {
    try {
      if (id == 'AlertM') {
        window
            .open(
                unitCode,
                "",
                "screen.width, screen.height, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
      } else {

        var requestCaller = new XMLHttpRequestCaller(this, "ajaxNCSSOService",
            "login", false);

        requestCaller.addParameter(1, "String", ncMark);
        requestCaller.addParameter(2, "String", unitCode);
        requestCaller.addParameter(3, "String", userCode);
        var coatKey = requestCaller.serviceRequest();

        if (coatKey == null || coatKey == '') {
          alert("${ctp:i18n('nc.multi.login.erro')}");
        } else {
          var key = coatKey.split("=")[1];
          document.applets['NCApplet' + '_' + ncMark].login(key);
          var users = new ArrayList();
          users.add(userCode + "_" + unitCode);
          providers.put(ncMark, users);
          document.applets['NCApplet' + '_' + ncMark].executeBussiness(id);
        }
      }
    } catch (e) {
      try {
        getA8Top().endProc();
      } catch (e) {
      }
      alert("${ctp:i18n('nc.multi.applet.load.error')}");
    }
    try {
      getA8Top().endProc();
    } catch (e) {
    }

  }

  function relPage(ncMark) {
    try {
      var cookieInf = document.applets['NCApplet' + '_' + ncMark]
          .getCookieInfo();

      if (cookieInf != null) {
        return encodeURIComponent(cookieInf);
      }
    } catch (e) {
    }
    //loginNC_UserCode = "";
  }

  function destroy(ncMark) {
    try {
      document.applets['NCApplet' + '_' + ncMark].removeMe();
    } catch (e) {
    }

    try {
    	alert("NCApplet destroy");
      document.applets['NCApplet' + '_' + ncMark].destroy();
    } catch (e) {
    }
  }
//-->
</script>
</body>
</html>