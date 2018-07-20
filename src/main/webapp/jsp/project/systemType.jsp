<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="projectHeader.jsp"%>
<title>
<c:choose>
	<c:when test="${param.id!=null}">
		<fmt:message key='project.toolbar.modifytype.label' var="projectTitle"/>
	</c:when>
	<c:otherwise>
	<fmt:message key='project.toolbar.newtype.label' var="projectTitle"/>
	</c:otherwise>
</c:choose>
${projectTitle}
</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript">
<!--
function NewHTTPCall()
{
   var xmlhttp;
   try{
     xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
     return xmlhttp;
   }
   catch (e)
   {
     return null;
   }
}

function init(aUrl)
{
  var httpCall = NewHTTPCall();
  if (httpCall ==  null){
    alert(v3x.getMessage("ProjectLang.formdisplay_nonsupportXMLHttp"));
    return null;
  }
    httpCall.open('GET', aUrl + "&" + Math.random(), false);  
    httpCall.onreadystatechange = function() {
    if (httpCall.readyState == 4){
    	if (httpCall.status == 200){
    		var projectid = httpCall.responseText;
     		var tohtml = "${v3x:toHTMLWithoutSpaceEscapeQuote(name)}";
     		var rv = "[\"" + projectid + "\", \"" + tohtml +"\"]";
     		parent.window.returnValue = rv;
     		window.close();
  		}
  	}
  };
  httpCall.send(null);
    
}

var nameList = new Array();
var idList = new Array();
  	<c:forEach var="tname" items="${projectList}">  	
       	 nameList.push("${v3x:toHTML(tname.name)}");
       	 idList.push("${tname.id}");
   	</c:forEach>
   	
function isSameName(){
      var issame = true;
      var theNewName = document.getElementById("name");
      var isModify = '${param.id!=null}';
      if(isModify == 'false'){
      
	      for(var j = 0;j<nameList.length;j++ ){
	       if(theNewName.value.trim() == nameList[j].trim()){
	          alert(v3x.getMessage("ProjectLang.project_name_repName"));
	          theNewName.focus();
	          issame = false;
	       }
	      }
      	  if(issame){
      		nameList.push(theNewName.value.trim());
      	  }
      	}else {
 	      for(var j = 0;j<nameList.length;j++ ){
	       if(theNewName.value.trim() == nameList[j].trim()){
	          if(idList[j] != '${param.id}' ){
		          alert(v3x.getMessage("ProjectLang.project_name_repName"));
		          theNewName.focus();
		          issame = false;	          
	          }
	       }
	      }     	  
      	}
      return issame;
	 } 
	 
 function nameLength(){
	var memo=document.getElementById("memo").value.length;
	var name=document.getElementById("name").value.length;
	  if(name>65){          //该字段后台存储长度是255，此处按照l/3截取
	        alert(v3x.getMessage("ProjectLang.project_sort_notexcess"));
		    return false;
	    }else if(memo>85) {
	    	alert(v3x.getMessage("ProjectLang.project_remark_notexcess"));
	   	    return false;
	    } 
	  return true;  
}
 
 function saveType(){
   
   var typeid = document.getElementById("id").value;
   var name = document.getElementById("name").value;
   name = name.replace(/&/g,"amp;38");
   var memo = document.getElementById("memo").value;
   memo = memo.replace(/&/g,"amp;38");
   if(checkForm(projectTypeForm)&&nameLength() &&  isSameName()){
     var deleteurl = v3x.baseURL + encodeURI("/project.do?method=saveProjectType&id=" + typeid+"&name="+name+"&memo="+memo);
     init(deleteurl);
   }else{
   	document.getElementById("b1").disabled=false;
   }
 }
//-->
</script>
</head>
<body scroll='no'>
<form id="projectTypeForm" target="saveCategoryFrame">
<input type="hidden" id="id" name="id" value="${pType.id}">
<table class="popupTitleRight" width="100%" height="250px"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="30px" class="PopupTitle">${projectTitle}</td>
	</tr>
	<tr>
		<td class="bg-advance-middel" height="56px" >			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="m_right" height="28" width="100" nowrap="nowrap"><label for="name"><font color="red">*&nbsp;</font><fmt:message key='project.style.name'/>:</label></td>
					<td class="new-column">
						<input ${dis} type="text" class="input-100per" name="name" id="name" value="${v3x:toHTMLWithoutSpace(pType.name) }" validate="notNull" inputName="<fmt:message key='project.style.name'/>" />
					</td>
				</tr>
				<tr>
					<td class="m_right" height="28" width="100" nowrap="nowrap" valign="top"><label for="memo">&nbsp;&nbsp;&nbsp;<fmt:message key='project.style.describe'/>:</label></td>
					<td class="new-column" >
					<textarea style="resize: none;" ${dis} class="input-100per" name="memo" id="memo" rows="7"  cols="">${pType.memo}</textarea>
					</td>
				</tr>
			</table>		
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td height="30px" align="right" class="bg-advance-bottom">
			<input name='b1' type="button" class="button-default_emphasize" id="b1" onclick="javascript:this.disabled=true;saveType()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
			<input name='b2' type="button" id="b2" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">			
		</td>
	</tr>
</table>
</form>
<iframe src="javascript:void(0)" name="saveCategoryFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
<html>