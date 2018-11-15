<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.Date,com.seeyon.ctp.util.Datetimes"%>
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
$(function(){
	setTimeout(function(){
    		  doShowEditor();
    	  },1000)
})
function doShowEditor(){
	if(!isLoadOffice()){
		window.setTimeout("doShowEditor()", 500);
	}else if(loadOfficeSuccess()){
		fullSize();
	}
}
function editOnlineFunction(){
	var issuccess = saveOffice('true');
	if(issuccess){
		var size ='';
		if(getFileSize()){
			size = getFileSize();
		}
		parent.updateAttachmentInfo('${param.id}',officeParams.fileId,officeParams.createDate,size);
	}
	return issuccess;
}
</script>
<script type="text/javascript" src="${ctp_contextPath}/common/office/license.js?v="+new Date().getTime()></script>
</head>
<body onload="">
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
		exactFileType  = getOfficeExtension(exactFileType,"${param.content}")
	}
	return exactFileType;
}
function getFileTypeByFilename(){
    var fileType = "";
	if(filename!=""){
		var index1=filename.lastIndexOf(".");
		var index2=filename.length;
		var suffix=filename.substring(index1+1,index2);//后缀名
		if(suffix!=null){
			if("docx" == suffix || "DOCX" == suffix){
				fileType = "docx";
			}else if("xlsx" == suffix || "XLSX" == suffix){
				fileType = "xlsx";
			}else if("pptx" == suffix || "PPTX" == suffix){
				fileType = "pptx";
			}else{
				fileType = suffix;
			}
		}
	}
	return fileType ;
}
</script>
</body>
</html>