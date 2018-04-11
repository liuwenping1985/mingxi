<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script   language="JavaScript">   
  window.onload = function(){
	  setSize();
  }  
  function   setSize(){   
     var   myHeight=300;        
     var   myWidth=700;   
     window.resizeTo(myWidth,myHeight);   
     window.moveTo((window.screen.availWidth-myWidth)/2,     (window.screen.availHeight-myHeight)/2);    
  }
  function  submit1(){
    window.open("${hrRecordURL}?method=card&remark="+document.all.textarea1.value,"","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,left=0,top=0,width=530,height=410");
    window.close(); 
  }
  function  cancel(){   
    window.close();  
  }
</script>  
</head>
<body>
<form method="post" name="form1" >
<div align="center">
<textarea id="textarea1" name="textarea1" cols="60" rows="4">${remark}</textarea>
</div>
<div align="center">
<button class="btn" onclick="submit1()"><fmt:message key="hr.record.submit.label" bundle="${v3xHRI18N}" /></button>
&nbsp;&nbsp;
<button class="btn" onclick="cancel()"><fmt:message key="hr.record.cancel.label" bundle="${v3xHRI18N}" /></button>
</div>
</form>
</body>
</html>