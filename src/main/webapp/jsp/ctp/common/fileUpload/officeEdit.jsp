<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.Date,com.seeyon.v3x.util.Datetimes"%>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<%
response.setDateHeader("Expires",-1);
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragrma","no-cache");
%>
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-store"> 
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<title></title>
<%
	Date createDate = Datetimes.parseDate((String)request.getParameter("createDate"));
%>
<script type="text/javascript">
<!--
$(function(){
	setTimeout(function(){
    		  doShowEditor();
    	  },1000)
})
function doShowEditor(){
	if(!officeEditorFrame.isLoadOffice()){
		window.setTimeout("doShowEditor()", 500);
	}else if(officeEditorFrame.loadOfficeSuccess()){
		fullSize();
	}
}
function editOnlineFunction(){
	var issuccess = saveOffice('true');
	if(issuccess){
		var size ='';
		if(fileSize){
			size = fileSize;
		}
		parent.updateAttachmentInfo('${param.id}',fileId,createDate,size);
	}
}
//-->
</script>
<script type="text/javascript" src="${ctp_contextPath}/common/office/license.js${ctp:resSuffix()}"></script>
</head>
<body onload="doShowEditor()">
<v3x:editor originalNeedClone="true" htmlId="content" category="${param.category }" content="${param.content}" type="${param.bodyType}" createDate="<%=createDate %>" />
<script type="text/javascript">
var editOnline = true;
isFormSumit = true;
var noSaveFile = true;
function getOfficeExtension(fileType,fileId){
	if(fileType=="doc" || fileType == "xls"){
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxHandWriteManager", "ajaxGetOfficeExtension",false);
		requestCaller.addParameter(1, "String", fileId);  
		var ds = requestCaller.serviceRequest();
		if(ds == 'docx' || ds == 'doc' || ds == 'xls' || ds == 'xlsx'){
			fileType = ds;
		}
	}
	return fileType;
}
var filename = "${param.filename}";
function getExactFileType4Ocx(){
	var exactFileType = getFileTypeByFilename();
	if(exactFileType != 'docx' && exactFileType != 'xlsx' && exactFileType !='pptx'){
		exactFileType  = getOfficeExtension(fileType,"${param.content}")
	}
	return exactFileType;
}
function getFileTypeByFilename(){
    var fileType = "";
	if(filename!=""){
		var suffix = filename.split(".");
		if(suffix!=null && suffix.length==2){
			if("docx" == suffix[1] || "DOCX" == suffix[1]){
				fileType = "docx";
			}else if("xlsx" == suffix[1] || "XLSX" == suffix[1]){
				fileType = "xlsx";
			}else if("pptx" == suffix[1] || "PPTX" == suffix[1]){
				fileType = "pptx";
			}else{
				fileType = suffix[1];
			}
		}
	}
	return fileType ;
}
</script>
</body>
</html>