<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='inquiry.web.dialogue.label'/></title>
<script>
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;
//function initPage(){
//     document.forms[0].elements[0].value="sdfsdfsdfds";
//}

function closeWindow_Yes(){
var obj  = transParams.parentWin; 
if(document.all.title.value.trim()!=""){
  if(!obj.checkProjectNameIsExist(document.all.title.value.trim())){
     alert(v3x.getMessage("InquiryLang.inquiry_tautonymy_alert"));
     document.all.title.value="";
     document.all.title.focus();
  }else{ 
  
      obj.document.all.title.value=document.all.title.value;
      obj.addOption(obj.document.all.projectBox,document.all.title.value,"");
      document.all.title.value="";
      document.all.title.focus();
  }
}else{
   alert(v3x.getMessage("InquiryLang.inquiry_question_null_alert"));
  document.all.title.focus();
}
}
function closeWindow_NO(){
    var obj  = transParams.parentWin;
    if(document.all.title.value.trim()!=""){
        if(!obj.checkProjectNameIsExist(document.all.title.value.trim())){
         alert(v3x.getMessage("InquiryLang.inquiry_tautonymy_alert"));
         document.all.title.value="";
         document.all.title.focus();
        }else{
          obj.document.all.title.value=document.all.title.value;
          obj.addOption(obj.document.all.projectBox,document.all.title.value,"");
          document.all.title.value="";
          document.all.title.focus();
          obj.document.getElementById("addProjectBox").style.display="";
          getA8Top().showProjectInfoWin.close();
        }
    }else{
        alert(v3x.getMessage("InquiryLang.inquiry_question_null_alert"));
        document.all.title.focus();
    }
}
function OK(){
	var obj  = window.parent;
	var title = document.getElementById("title").value;
	if(title != ""){
		if(!obj.checkProjectNameIsExist(title.trim())){
     		alert(v3x.getMessage("InquiryLang.inquiry_tautonymy_alert"));
     		document.getElementById("title").value="";
     		document.getElementById("title").focus();
     		return false;
  		}else{ 
	  		obj.document.getElementById("title").value=title;
	  		obj.addOption(obj.document.getElementById("projectBox"),title,"");
	  		document.getElementById("title").value="";
	  		document.getElementById("title").focus();
	  		return true;
  		}
	}else{
     	alert(v3x.getMessage("InquiryLang.inquiry_question_null_alert"));
  		document.getElementById("title").focus();
  		return false;
	}
}
function enterButton(){
	var evt = v3x.getEvent();
     if(evt.keyCode == 13){
         closeWindow_Yes();
         return false;
      }
}

window.onload = function(){
	var title = document.getElementById("title");
	title.focus();
}
// -->
</script>
</head>
<body scroll="no">
<form action="" method="post" onsubmit="return false">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	    <td height="20" class="PopupTitle" colspan="2">
		 <fmt:message key='inquiry.add.question.label'/>
	    </td>	
	</tr>
	 <tr>
	    <td width="20%" class="bg-advance-middel" valign="middle" nowrap="nowrap"><fmt:message key='inquiry.question.name.label'/>:</td>
	    <td width="80%" class="bg-advance-middel">
		 <input maxlength="85"  size="50" type="text" id="title" name="title" onkeypress="enterButton()" />
		</td>
	  </tr>
	<tr>
	  <td  class="bg-advance-bottom" align="right" colspan="2" height="42">
	    <input type="button" value="<fmt:message key='inquiry.ok.continue.label'/>" onclick="closeWindow_Yes();"/>
	    <input name="button" type="button" value="<fmt:message key='inquiry.ok.exit.label'/>" onclick="closeWindow_NO();"/>
	    <input name="button2" type="button" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" onclick="getA8Top().showProjectInfoWin.close();"/>
	  </td>
	</tr>
</table>
</form>
</body>
</html>