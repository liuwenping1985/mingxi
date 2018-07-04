<!--
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
-->
<%@include file="caaccountHeader.jsp"%>
<!--
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Expires" CONTENT="0">
<title><fmt:message key="import.local.excel" /></title>
<script type="text/javascript">
	var accountflag=0;
	function listenerKeyPress(){
		if(event.keyCode == 27){
			//window.close();
		}
	}
		
	//function isExcel(filePostfix
	function submitform(){
		//文件名后缀
		var fileURL = document.getElementById('file1').value;
		var filePostfix = fileURL.substring(fileURL.lastIndexOf('.')+1);
		if(filePostfix.toLowerCase()!='xls'){//tanglh
			alert(v3x.getMessage("organizationLang.file_error_choose_excel"));
			return;
		}
		var form = document.all("uploadFormOrgImp");
		document.getElementById("impURL").value = document.getElementById('file1').value;
		if(document.getElementById('file1').value!="" && document.getElementById('file1').value.length!=0){
			var rep = document.all("repeat");
			var repvalue;
			if(rep[0].checked){
				repvalue = rep[0].value;
			}else{
				repvalue = rep[1].value;
			}
			form.target='fileUpload';
			//form.action="${organizationURL}?method=matchField";
			//getA8Top().startProc('');
			form.action="${caacountURL}?method=doImport&repeat="+repvalue;
			window.onbeforeunload=null;
			document.getElementById("b1").disabled = true;
	        document.getElementById("submintCancel").disabled = true;
	        showProcDiv();
			form.submit();
		}else{
			alert(v3x.getMessage("organizationLang.choose_import_file"));
		}
	}
    function showProcDiv(){
        var width = 240;
        var height = 100;
        
        var left = (document.body.scrollWidth - width) / 2;
        var top = (document.body.scrollHeight - height) / 2;
        var title = v3x.getMessage("V3XLang.common_process_label");    
        var str = "";
            str += '<div id="procDIV" style="position:absolute;left:'+left+'px;top:'+top+'px;width:'+width+'px;height:'+height+'px;z-index:50;border:solid 2px #DBDBDB;">';
            str += "<table width=\"100%\" height=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" bgcolor='#F6F6F6'>";
            str += "  <tr>";
            str += "    <td align='center' id='procText' height='40' valign='bottom'>&nbsp;</td>";
            str += "  </tr>";
            str += "  <tr>";
            str += "    <td align='center'><span class='process'>&nbsp;</span></td>";
            str += "  </tr>";
            str += "</table>";
            str += "</div>";
            
        document.getElementById("procDiv1").innerHTML = str;
        var procTextE = document.getElementById("procText");
        if(procTextE){
            procTextE.innerText = title;
        }
        document.close();
    }

    function hideProcDiv(){
        document.getElementById("procDiv1").innerHTML = "";
    }
       	
	function matchfiled(){	//tanglh
			var kkk = v3x.openWindow({
				url		: '${organizationURL}?method=popMatchPage',
				width	: 600,
				height	: 530,
				resizable	: "yes"
			});
	}
	function getselectvalue(a){
						
	}
	function initLanguage(){
		var language = "${v3x:getLanguage(pageContext.request)}";
		try{
		var sel = document.all.language;
		if(language == 'zh-cn'){
			sel.options[0].selected = true;
		}else if(language == 'en'){
			sel.options[1].selected = true;
		}
		}catch(e){
		}
	}
 	function checksheet(a)	{
 		var id = a.id;
 		if(id.indexOf("single") != -1){
 			var kk = document.getElementById("sheetnum");
 			kk.style.display="none";
 		}else  if(id.indexOf("multi") != -1){
 			var kk = document.getElementById("sheetnum");
 			kk.style.display="";
 		}
 	}
 	function seleaccount(){
 		var tname = document.all("tablename");
 		var op = tname.options;
 		for(var i=0;i<op.length;i++){
 			if(op[i].selected == true){
 				if(op[i].value != ""){
	 				if(op[i].value == "account"){
	 					accountflag=0;
	 				}else{
	 					accountflag=1;
	 				}
 				}else{
 					accountflag=0;
 				}
 			}
 		}
 	}

</script>
</head>
<body scroll="no" onkeydown="listenerKeyPress()" >
<iframe name="fileUpload" width="0" height="0" id="fileUpload"></iframe>
<form enctype="multipart/form-data" name="uploadFormOrgImp" method="post"	>
  <table width="100%" height="100%" align="center"  border="0" cellpadding="0" cellspacing="0"><tr><td>
	<table class="popupTitleRight" width="100%" height="100%"  align="center" border="0" cellspacing="0" cellpadding="0">
		<input type="hidden" id="importType" name="importType" value="${importType}">
		<input type="hidden" id="selectvalue" name="selectvalue">
		<input type="hidden" id="radiovalue" name="radiovalue">
		<input type="hidden" id="impURL" name="impURL">
		<input type="hidden" id="languagevalue" name="languagevalue">
		<tr>
			<td height="20" class="PopupTitle">
				<fmt:message key="ca.importAccount.label"/>
			</td>
		</tr>
		<tr>
			<td id="upload1" class="bg-advance-middel" height="30"> 
			<div><fmt:message key="import.choose.file" /></div>
			<INPUT type="file" name="file1" id="file1" style="width: 100%"></td>
		</tr>
		<tr>
			<td  align="left" style="padding-left: 15px">
				<fmt:message key="import.option"/>:&nbsp;
				<label for="overleap">
					<input type="radio" name="repeat" value="1" checked="checked" id="overleap">
					<fmt:message key="import.repeatitem.overleap"/>
				</label>
				<label for="overcast">
					<input type="radio" name="repeat" value="0" id="overcast">
					<fmt:message key="import.repeatitem.overcast"/>&nbsp;&nbsp;
				</label>
			</td>
		</tr>
								
		<tr>
			<td height="30" align="right" class="bg-advance-bottom">
				<input type="button" id="b1" name="b1" onclick="submitform()"value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
				<input id="submintCancel" type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
	</table>
	
	</table></form>
	<!--</iframe>-->
	<div id="procDiv1"></div>
</body>
</html>