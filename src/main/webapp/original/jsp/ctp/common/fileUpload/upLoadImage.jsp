<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.net.InetAddress"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title><fmt:message key="fileupload.page.title" /></title>

<c:if test="${e ne null}">
	<script type="text/javascript">
	alert("${v3x:showException(e, pageContext)}");
	//parent.again();
	</script>
</c:if>

<fmt:message key='fileupload.exception.UnallowedExtension' var="unallowedExtensionVar">
	<fmt:param value="${param.extensions}" />
</fmt:message>

<script type="text/javascript">

<!--
//Attachment(id, reference, subReference, category, type, filename, mimeType, createDate, size, fileUrl, description){

//判断是否安装了精灵
var isA8geniusAdded = false;
var dv = window.dialogArguments.extendField;
<c:if test="${isA8geniusAdded}">
    isA8geniusAdded = true;
</c:if>
<c:if test="${atts != null}">
	try {
	    getA8Top().endProc();
	}
	catch(e) {
	}
	<c:forEach items="${atts}" var="f">
		<fmt:formatDate value="${f.createdate}" pattern="yyyy-MM-dd HH:mm:ss" var="createDate" />
		parent.addAttachment('${f.type}', '<v3x:out value="${f.filename}" escapeJavaScript="true" />', '${f.mimeType}', '${createDate}', '${f.size}', '${f.fileUrl}', false ,null,'${f.extension}','${f.icon}');
	</c:forEach>
</c:if>

function checks(){
	if(number == 0 || files.isEmpty()){
		return false;
	}
	
	show();
	
	for(var i = 1; i <= index; i++){
		var o = document.getElementById("file" + i);
		if(!o){
			continue;
		}

		if(!o.value){
			document.getElementById("fileInputDiv" + i).removeNode(true);
		}
	}
	
	return true;
}

function checkExtensions(obj){
    var filepath = obj.value;
    if (!filepath) {
    	//alert(_("MainLang.upload_alert_selectfile"));
        return false;
    }
    
	var extensionstr = document.getElementById("extensions").value;
	if(!extensionstr){
		return true;
	}
	

   	var lastSeparator = filepath.lastIndexOf(".");
    if (lastSeparator == -1) {
        return true;
    }
    else{
    	if(extensionstr){
    		var extension = filepath.substring(lastSeparator + 1).toLowerCase();
    		var extensions = extensionstr.split(",");
    		
    		for(var i=0; i<extensions.length; i++) {
    			if(extensions[i] == extension){
    				return true;
    			}
    		}
    	}
    }
    
    alert("${unallowedExtensionVar}");
    
    return false;
}

function show(){
	document.getElementById("b1").disabled = true;

	document.getElementById("upload1").style.display = "none";
	document.getElementById("uploadprocee").style.display = "";
	if(isA8geniusAdded){
	    document.getElementById("selectFile").style.display = "none";	  
	    document.getElementById("fileProcee").style.display = "";  
	}
}

function addAttachment(type, filename, mimeType, createDate, size, fileUrl, canDelete, needClone,extension,icon){
	var _parent = window.opener;
	if(_parent == null){
		_parent = window.dialogArguments;
	}
	var subReference = getUUID();
	if(dv){
	    var src = "/seeyon/fileUpload.do?method=showRTE&fileId="+fileUrl+"&createDate="+createDate+"&type=image";	
	    dv.label = src ;
	    dv.value = subReference  ;	 	  
	}
	
	_parent.addAttachment(type, filename, mimeType, createDate, size, fileUrl,  false , needClone,'',extension,icon);	
	_parent.fileUploadAttachments.get(fileUrl).extSubReference = subReference;
	
	if(!isA8geniusAdded){
	    window.close();
	}			
}

function listenerKeyPress(){
	if(event.keyCode == 27){
		window.close();
	}
}

function again(){
	document.getElementById("b1").disabled = false;

	document.getElementById("upload1").style.display = "";
	document.getElementById("uploadprocee").style.display = "none";
	if(isA8geniusAdded){
	    document.getElementById("selectFile").style.display = "none";	  
	    document.getElementById("fileProcee").style.display = "";  
	}
	
	number = 0;
	files.clear();
	
	document.getElementById("fileNameDiv").innerHTML = "";
	document.getElementById("fileInputDiv").innerHTML = "";
	
	addInput(index);
}

var quantity = <c:out value="${param.quantity}" default="1" />;
var index = 1;
var number = 0;
var files = new Properties();
var geniusNum = 0;

function addNextInput(obj){
	if(files.values().contains(obj.value)){
		removeInput(index);
		addInput(index)

		alert(_("MainLang.upload_alert_exist"));
		return;
	}

	if(!checkExtensions(obj)){
		removeInput(index);
		addInput(index)
		return;
	}

	if(number >= quantity){
		removeInput(index);
		addInput(index)
		
		alert(_("MainLang.upload_alert_limit", number));
		return;
	}

	number++;
	document.getElementById("fileInputDiv" + index).style.display = 'none';
	var s = obj.value.lastIndexOf("\\");
	if(s < 0){
		s = obj.value.lastIndexOf("/");
	}

	var filename = obj.value.substring(s + 1);
	var nameHTML = "";
	nameHTML += "<div id='fileNameDiv" + index + "' title='" + escapeStringToHTML(filename) + "' style='float: left;height: 18px; line-height: 14px;' noWrap>"
	nameHTML += filename.getLimitLength(16).escapeHTML();
	nameHTML += "<img src='<c:url value='/common/images/attachmentICON/delete.gif' />' onclick='deleteOne(" + index + ")' class='cursor-hand' title='" + v3x.getMessage('V3XLang.attachment_delete') + "' height='11' align='absmiddle'>";		
	nameHTML += "&nbsp;</div>";

	document.getElementById("fileNameDiv").innerHTML += nameHTML;
	files.put(index, obj.value);
	index++;
	addInput(index);
}

function deleteOne(i){
	removeInput(i);
	number--;
	files.remove(i);
}

function removeInput(i){

    var errorNode = false;
	try{
		document.getElementById("fileInputDiv" + i).removeNode(true);
	}
	catch(e){
	    errorNode = true;
	}
		
	try{
		document.getElementById("fileNameDiv" + i).removeNode(true);
	}
	catch(e){
	   errorNode = true;
	}

	if(isA8geniusAdded&&!errorNode){
	    var UFIDA_Upload1 = document.getElementById("UFIDA_Upload1");
	    UFIDA_Upload1.DeleteItemFromList(i-1);
	}

}

function addInput(i){

	var html =  "<div id=\"fileInputDiv" + i + "\" style=\"\">" + 
				"</div>";
	var e = document.createElement(html);
	var fileNameIndexFlag = i;
	if(quantity==1)
		fileNameIndexFlag = 1;
			
	if(isA8geniusAdded){	    
	    var inputHTML1 = "<INPUT type=\"text\" name=\"file1\" id=\"file1\" onkeydown=\"return false\" onkeypress=\"return false\" style=\"width: 73%\">&nbsp;&nbsp;" + "<INPUT type=\"button\" name=\"button1\" id=\"button1\" onclick=\"OpenBrowser()\" value=\"<fmt:message key='file.upload.browse' bundle='${v3xCommonI18N}' />......\" >";	    	
	    e.innerHTML=inputHTML1;
	}else{
	    var inputHTML = "<INPUT type=\"file\" name=\"file" + fileNameIndexFlag + "\" id=\"file" + i + "\" onchange=\"addNextInput(this)\" onkeydown=\"return false\" onkeypress=\"return false\" style=\"width: 100%\">";	    
	    var eInput = document.createElement(inputHTML);	
	    e.appendChild(eInput);	    
	}
	document.getElementById("fileInputDiv").appendChild(e);
}

function OpenBrowser()
{
    for(i=1;i<index;i++){
        deleteOne(i);
    }
    files = new Properties();
    var UFIDA_Upload1 = document.getElementById("UFIDA_Upload1");
	var ret = UFIDA_Upload1.openBrowser();
	document.getElementById("file1").value = ret;  		
	var fStrs = ret.split("\n");
	for(i=0;i<fStrs.length;i++){
	    document.getElementById("fileStr").value = fStrs[i];
	    addNextInput(document.getElementById("fileStr"));
	}
}

function SetServerName_OnClick()
{
	var isOldUFIDA_Upload1 = true;
	try{
		var ufa = new ActiveXObject("UFIDA_IE_Addin.Assistance");
		if(ufa.getGeniusVersion() != null){
			isOldUFIDA_Upload1 = false;
		}
    }
	catch(e){
	}
	var serverName = null;
	if(isOldUFIDA_Upload1){
		serverName = '<%=request.getServerName()%>';
	}
	else{
		serverName = '<%=request.getScheme()%>://<%=request.getServerName()%>';
	}
	
    try{
	    var form_action= document.getElementById("form_action");	    
	    var extensions = document.getElementById("extensions").value;
		var applicationCategory = document.getElementById("applicationCategory").value;
		var destDirectory = document.getElementById("destDirectory").value;
		var destFilename = document.getElementById("destFilename").value;
		var typeStr = document.getElementById("type").value;
		var maxSizeStr = document.getElementById("maxSize").value;
	    var fieldname= "id=&method=processUpload&extensions="+extensions
	                   +"&applicationCategory="+applicationCategory
	                   +"&destDirectory="+destDirectory
	                   +"&destFilename="+destFilename
	                   +"&type="+typeStr
	                   +"&maxSize="+maxSizeStr
	                   +"&from=a8genius";
	    var UFIDA_Upload1 = document.getElementById("UFIDA_Upload1");
		UFIDA_Upload1.CallBackUploadCompletedType(1);
		var serverPort = '<%=request.getServerPort()%>';
		UFIDA_Upload1.SetServerName(serverName);
		UFIDA_Upload1.SetFormAction(form_action.value);
		UFIDA_Upload1.SetFileFieldName("icon");
		UFIDA_Upload1.SetFieldName(fieldname);
		UFIDA_Upload1.SetCallbackUploadCompleted(cbmthod);
		UFIDA_Upload1.SetServerPort(serverPort);
		UFIDA_Upload1.SetProcessBarColor(250206135);
		UFIDA_Upload1.SetProcessBarBkColor(parseInt('0xFFFFFF'));
    }catch(e){
        alert(e);
    }
}

function cbmthod(type,str)
{  	
    var i=str.indexOf('{');
    if(i==0){
        geniusNum++;
        var str1 = str.split('}');
        var str2 = str1[0] + '}'; 
        var strJsion = '('+str2+')';
        var f = eval(strJsion);
	    parent.addAttachment(f.type, f.filename, f.mimeType, f.createDate, f.size, f.fileUrl,null,null,f.extension,f.icon);
	    if(geniusNum == number){
	        window.close();
	    }
	    str = str1[1];
    }
    
    if ( type == 1)
	{
		var percent= document.getElementById("file_percent");
		var fileName=str.substr(str.lastIndexOf("\\")+1);  
		percent.innerText = "共"+number+1+"个文件，正在上传第"+geniusNum+1+"个文件 "+getLimitLength(fileName, 50);
	} else if ( type == 2){
	    var percent= document.getElementById("percent");
	    var pcent = str.split('/');
		percent.innerText = "已上传 "+pcent[0]+"KB , 总文件大小 "+pcent[1]+"KB";
	}
	//alert(str);
    return "true";
}

function onUpload(){
  try{
    SetServerName_OnClick();
    show();
	var percent= document.getElementById("result");
    percent.innerText = "";
    var UFIDA_Upload1 = document.getElementById("UFIDA_Upload1");
    UFIDA_Upload1.height = '20';
    UFIDA_Upload1.StartUpload();   
  }catch(e){
    alert(e);
  }
}
//-->
</script>
</head>
<body bgColor="#f6f6f6" scroll="no" onkeydown="listenerKeyPress()">
<form enctype="multipart/form-data" name="uploadForm" method="post"
	action="<html:link renderURL='/fileUpload.do?method=processUpload' />"
	onsubmit="return checks()" target="uploadIframe">
	<input type="hidden" name="type" value="${param.type}">
	<input type="hidden" name="extensions" id="extensions" value="${param.extensions}">
	<input type="hidden" name="applicationCategory" id="applicationCategory" value="${param.applicationCategory}">
	<input type="hidden" name="destDirectory" id="destDirectory" value="${param.destDirectory}">
	<input type="hidden" name="destFilename" id="destFilename" value="${param.destFilename}">
	<input type="hidden" name="maxSize" id="maxSize" value="${param.maxSize}">
	<input type="hidden" name="isEncrypt" id="isEncrypt" value="${param.isEncrypt}">
    <input type="hidden" id="form_action" value="/seeyon/fileUpload.do">
    <input type="hidden" id="fileStr" value="">
    <c:choose>
    <c:when test="${isA8geniusAdded}">
        <%@include file="geniuesUpload.jsp" %>
    </c:when>
    <c:otherwise>
        <%@include file="a8Upload.jsp" %>
    </c:otherwise>
    </c:choose>
</form>

</BODY>
</HTML>
<iframe name="uploadIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>