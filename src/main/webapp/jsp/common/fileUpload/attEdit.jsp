<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<%@ include file="../INC/noCache.jsp"%>
<html:link renderURL="/edocController.do" var="edocGeneralURL" /> 
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<title><fmt:message key="fileUpdate.page.title" /></title>
<style>
	.common_button_emphasize{
		border-bottom:#42b3e5 1px solid;
		border-left:#42b3e5 1px solid;
		background:#42b3e5;
		color:#fff;
		border-top:#42b3e5 1px solid;
		border-right:#42b3e5 1px solid;
	}
</style>
<script type="text/javascript">
<!--
var edocGeneralURL ="${edocGeneralURL}";
var pw = new Object();
function loadInit(){
	try{
		var ocxObj=new ActiveXObject("HandWrite.HandWriteCtrl");
		pw.installDoc= ocxObj.WebApplication(".doc");
		pw.installXls=ocxObj.WebApplication(".xls");
		pw.installWps=ocxObj.WebApplication(".wps");
		pw.installEt=ocxObj.WebApplication(".et");		
	}catch(e)
	{
		pw.installDoc=false;
		pw.installXls=false;
		pw.installWps=false;
		pw.installEt=false;
	}
	if(pw.installDoc){
		attFileType.put("application/msword","OfficeWord");
		attFileType.put("application/vnd.openxmlformats-officedocument.wordprocessingml.document","OfficeWord");
		attFileType.put(".doc","OfficeWord");
		attFileType.put(".docx","OfficeWord");
		attFileType.put("application/kswps","OfficeWord");
		attFileType.put(".wps","OfficeWord");
	}
	if(pw.installXls){
		attFileType.put("application/vnd.ms-excel","OfficeExcel");
		attFileType.put("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet","OfficeExcel");
		attFileType.put(".xls","OfficeExcel");
		attFileType.put(".xlsx","OfficeExcel");
		attFileType.put("application/kset","OfficeExcel");
		attFileType.put(".et","OfficeExcel");
	}
	if(pw.installWps){
		attFileType.put("application/kswps","OfficeWord");
		attFileType.put(".wps","OfficeWord");
		attFileType.put("application/msword","OfficeWord");
		attFileType.put("application/vnd.openxmlformats-officedocument.wordprocessingml.document","OfficeWord");
		attFileType.put(".doc","OfficeWord");
		attFileType.put(".docx","OfficeWord");
	}
	if(pw.installEt){
		attFileType.put("application/kset","OfficeExcel");
		attFileType.put(".et","OfficeExcel");
		attFileType.put("application/vnd.ms-excel","OfficeExcel");
		attFileType.put("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet","OfficeExcel");
		attFileType.put(".xls","OfficeExcel");
		attFileType.put(".xlsx","OfficeExcel");
	}
}
function canEditOnline(att){
	if(att.type !=0){
		return false;
	}
	var mimetype =  getMimeType(att.mimeType,att.filename);
	if(mimetype){
		return true;
	}
	return false;
}
function getMimeType(mimeType,name){
	var filename = name.toLocaleLowerCase();
	var point = filename.lastIndexOf(".");
	if(point != -1){
		filename = filename.substring(point);
	}
	if(attFileType){
		if(attFileType.get(mimeType)){
			return attFileType.get(mimeType);
		}
		if(attFileType.get(filename)){
			return attFileType.get(filename);
		}
	}
	return null;
}
var logList = new ArrayList();
function loadAttachment(){
	loadInit();
	var par = window.dialogArguments;
	var attList = par.attActionLog.editAtt;
	var	attBody = document.getElementById("attBody");
	for(var i=0;i<attList.size();i++ ){
		var attachment = attList.get(i);
		if(attachment.type == 0 || attachment.type == 2){
			addAtt2Body(attachment,attBody,i);
		}
	}
}

function addAtt2Body(attachment,attBody,i){
	attachment.onlineView = false;
	var tr = document.createElement('tr');
	if(i%2==0){
		tr.className="sort erow";
	}else{
		tr.className="sort";
	}
	var checkBox = document.createElement('td');
	checkBox.align="center";
	if(!attachment.reference){
		attachment.reference = '${param.reference}';
		attachment.subReference = '${param.subReference}';
	}
	if(!attachment.id){
		attachment.id = getUUID();
	}
	//去掉 修改时间 后面的秒
	var createDate=attachment.createDate;
	if(createDate.indexOf(":")!=createDate.lastIndexOf(":")){
		attachment.createDate=createDate.substring(0,createDate.lastIndexOf(":"));
	}
	
	checkBox.innerHTML = "<label title='"+escapeStringToHTML(attachment.filename)+"'  ><input name='id' type='checkbox' id='"+attachment.id+"' reference='"+attachment.reference+"' subReference='"+attachment.subReference+"' category='"+attachment.category+"' "
						+"attType='"+attachment.type+"' filename='"+escapeStringToHTML(attachment.filename)+"' mimeType='"+attachment.mimeType+"' createDate='"+attachment.createDate+"' "
						+"size='"+attachment.size+"' fileUrl='"+attachment.fileUrl+"' description='"+ escapeStringToHTML(attachment.description) +"' needClone='"+attachment.needClone+"'"
						+" extension='"+attachment.extension+"' v='"+attachment.v+"' icon='"+attachment.icon+"' extReference='${param.reference}' extSubReference='${param.subReference}'" 
						+"/></label>";
	var name = document.createElement('td');
	name.setAttribute("type","String");
	name.setAttribute("id",attachment.id+"nameTd");
	var onlineEdit = canEditOnline(attachment);
	name.innerHTML = attachment.toString(false,false,onlineEdit,380);
	//name.style.width="60%";
	var updateDate = document.createElement('td');
	updateDate.setAttribute("type","Date");
	//updateDate.style.width="40%";
	updateDate.innerHTML = attachment.createDate;

	tr.appendChild(checkBox);
	tr.appendChild(name);
	tr.appendChild(updateDate);

	attBody.appendChild(tr);
}
//上传附件
function addEditAttachment(){
	insertAttachment();
	sychorAtt();
}
//判断是否重复
function isDuple(att){
	var delIds = document.getElementsByName("id");
	for(var i = 0 ; i < delIds.length ;i++){
		if(att.type ==0 || att.type == 3){
			if(delIds[i].getAttribute("filename") == att.filename){
				return true;
			}
		}else if(att.type==2 || att.type==4){
			if(delIds[i].getAttribute("description") == att.description){
				return true;
			}
		}
	}
	return false;
}
function sychorAtt(){
	var attList = fileUploadAttachments.values();
	var	attBody = document.getElementById("attBody");
	var ff = attBody.childNodes.length%2;
	var createDate = "";
	var des = "";
	for(var i=0;i< attList.size();i++ ){
		var att = attList.get(i);
		if(isDuple(att)){
			alert(_("MainLang.has_same_att",att.filename));
			continue;
		}
		if(ff == 1){
			var tt = i+1;
			addAtt2Body(att,attBody,tt);
		}else{
			addAtt2Body(att,attBody,i);
		}
		if(i != 0){
			des +=",";
		}
		des += att.filename;
		createDate = att.createDate;
	}
	if(des){
		var log = new ActionLog(0,createDate,des);
		logList.add(log);
	}
	fileUploadAttachments.clear();
}
//关联文档
function quoteMyDocument(appType) {
	quoteDocument(appType);
	sychorAtt();
}
function quoteDocument(appType) {
	var quoteURL = "";
	if(appType == '1' || appType ==1 || !appType){
		quoteURL = colGeneralURL;
	}else{
		//信息报送
		if(appType == '32' || appType==32) {
			quoteURL = "infoController.do";
		} else {
			if(appType == '4') {//公文
				appType = '';
			}
			quoteURL = edocGeneralURL;
		}
	}
    var atts = v3x.openWindow({
        url: v3x.baseURL + '/ctp/common/associateddoc/assdocFrame.do?isBind=1,3',
        height: 600,
        width: 800
    });
	if(atts){
	    deleteAllAttachment(2);
	    for (var i = 0; i < atts.length; i++) {
	        var att = atts[i]
	        addAttachment(att.type, att.filename, att.mimeType, att.createDate, att.size, att.fileUrl, true, false, att.description, null, att.mimeType + ".gif", att.reference, att.category, false)
	    }
	}
}
function delAttachment(){
	var delIds = document.getElementsByName("id");
	var	attBody = document.getElementById("attBody");
	var des = "";
	var delElement = new ArrayList();
	for(var i = 0 ; i < delIds.length ;i++){
		if(delIds[i] && delIds[i].checked == true){
			var p = delIds[i].parentElement || delIds[i].parentNode;
			//checkbox添加一层label 多获取一层
			p = p.parentElement.parentElement || p.parentNode.parentNode ;
			delElement.add(p);
			if(des){
				des+=",";
			}
			des +=delIds[i].getAttribute("filename");
		}
	}
	if(!delElement.isEmpty()){
		for(var i = 0 ; i < delElement.size();i++)
				attBody.removeChild(delElement.get(i));
	}else{
		alert(_("MainLang.system_lang_delete"))
		return false;
	}
	var log = new ActionLog(2,(new Date()).format("yyyy-MM-dd HH:mm"),des);
	logList.add(log);
}
function checkBoxToAtt(att){
	var result = new Attachment(att.id,att.getAttribute("reference"), att.getAttribute("subReference"),
						 att.getAttribute("category"), att.getAttribute("attType"), att.getAttribute("filename"),
						 att.getAttribute("mimeType"), att.getAttribute("createDate"), 
						 att.getAttribute("size"), att.getAttribute("fileUrl"), 
						 att.getAttribute("description"), att.getAttribute("needClone"),
						 att.getAttribute("extension"),att.getAttribute("icon"),false,false,att.getAttribute("v"));
	result.onlineView = false;
	result.extReference = att.getAttribute("extReference");
	result.extSubReference = att.getAttribute("extSubReference");
	return result;
}
function submitAttachment(){
	var atts = document.getElementsByName("id");
	var attList = new ArrayList();
	for(var i = 0 ; i < atts.length ;i++){
		var att = checkBoxToAtt(atts[i]);
		attList.add(att);
	}
	//var par = window.dialogArguments;
	//以下方法不可取。报 不能执行已经释放的javascript错误
	//par.updateAttachmentInClinet(attList,logList,'${param.category}','${param.reference}','${param.subReference}','${param.type}')
	window.returnValue = [attList,logList];
	window.close();
}
function editOfficeOnline(id){
	var att = document.getElementById(id);
	var filename = att.getAttribute("filename");
	/*if(filename.indexOf(".docx")!=-1 || filename.indexOf(".DOCX")!=-1
		|| filename.indexOf(".xlsx")!=-1 || filename.indexOf(".XLSX")!=-1
		|| filename.indexOf(".pptx")!=-1 || filename.indexOf(".PPTX")!=-1){
		if(!confirmToOffice2003())return;
	}*/
	var category = att.getAttribute("category");
	var fileUrl = att.getAttribute("fileUrl");
	var createDate = att.getAttribute("createDate");
	var bodyType = getMimeType(att.getAttribute("mimeType"),filename);
	var url = "genericController.do?ViewPage=ctp/common/fileUpload/officeEdit&id="+id+"&filename="+encodeURIComponent(filename)
	+"&content="+fileUrl+"&bodyType="+bodyType+"&createDate="+createDate+"&category="+category+"&_isModalDialog=true";
	officeEditorIframe.location.href=url;
}
function refreshAtt(att){
	var attTd = document.getElementById(att.id+"nameTd");
	var attachment = checkBoxToAtt(att);
	if(attTd && attachment){
		attTd.innerHTML = attachment.toString(false,false,true,380);
	}
}
/*
function renameToOffice2003(filename){
    var retname = "";
	if(filename!=""){
		var suffix = filename.split(".");
		if(suffix!=null && suffix.length==2){
			if("docx" == suffix[1] || "DOCX" == suffix[1]){
				retname = suffix[0]+".doc";
			}else if("xlsx" == suffix[1] || "XLSX" == suffix[1]){
				retname = suffix[0]+".xls";
			}else if("pptx" == suffix[1] || "PPTX" == suffix[1]){
				retname = suffix[0]+".ppt";
			}else{
				retname=filename;
			}
		}else{
			retname = filename;
		}
	}else{
		retname = filename;
	}
	return retname ;
}*/
function updateAttachmentInfo(id,fileUrl,createDate,fileSize){
	var att = document.getElementById(id);
	att.setAttribute("fileUrl",fileUrl);
	att.setAttribute("createDate",createDate);
	if(fileSize){
		att.setAttribute("size",fileSize);
	}
	att.setAttribute("filename",att.getAttribute("filename"));
	refreshAtt(att);
	var log = new ActionLog(1,createDate,att.getAttribute("filename"));
	logList.add(log);
	/**
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxEditAttachmentManager", "checkOfficeInfo", false);
	requestCaller.addParameter(1, "Long", fileUrl);
	requestCaller.addParameter(2, "date", createDate);
	var rs = requestCaller.serviceRequest();
	if(rs){
		if(rs[0] =="0"){
			att.setAttribute("fileUrl",fileUrl);
			att.setAttribute("size",rs[1]);
			att.setAttribute("createDate",createDate);
			//refreshAtt(att);
			var log = new ActionLog(1,createDate,att.getAttribute("filename"));
			logList.add(log);
		}else{
			alert(_("MainLang.att_size_maxSize"));
		}
	}
	**/
}
function showAbout(){
	var rv = v3x.openWindow({
	    url: "genericController.do?ViewPage=common/fileUpload/attEditDes",
		width: "300",
	    height: "260",
        dialogType: "modal",
        resizable: true
	});	
}
//-->
</script>
<style type="text/css">.erow{background: #f7f7f7;padding:5px 0px;}</style>
</head>
<div style="display:none">
<v3x:fileUpload  applicationCategory="${empty param.category?1:param.category }" />
</div>
<body onload="loadAttachment()" scroll="yes" style="overflow: auto" onkeydown="listenerKeyESC()">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="PopupTitle" align="left" height="20px">
			<div class="div-float"><fmt:message key="fileUpdate.page.title" /></div>
			<div class="div-float-right"><span onclick="javascript:showAbout()" class="like-a"><fmt:message key="fileUpdate.page.about" /></span>&nbsp;&nbsp;</div>
		</td>
	</tr>
	<tr valign="top">
		<td align="center">
		<div class="border-top">
		<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="20" class="webfx-menu-bar">
				<script type = "text/javascript" >
			    var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			    myBar.add(new WebFXMenuButton("pigeonhole", "<fmt:message key="common.toolbar.insertAttachment.label" bundle="${v3xCommonI18N }"/>", "javascript:addEditAttachment()", [1,6], "", null));
			    myBar.add(new WebFXMenuButton("pigeonhole", "<fmt:message key="common.toolbar.insert.mydocument.label" bundle="${v3xCommonI18N}"/>", "javascript:quoteMyDocument('${param.category}');", [1,6], "", null));
			    myBar.add(new WebFXMenuButton("pigeonhole", "<fmt:message key="common.toolbar.delete.label" bundle="${v3xCommonI18N}"/>", "javascript:delAttachment();", [1,3], "", null));
				document.write(myBar);
				document.close();
				</script>	
				</td>
			</tr>
			<tr height="100%">
				<td class="bg-advance-middel" height="100%">
					<div class="scrollList border-tree" style="background: #ffffff">
					<table class="sort ellipsis" width="100%"  border="0" cellspacing="0" cellpadding="0" >
					<thead>
					<tr class="sort">
						<td width="50" align="center"><input type='checkbox' id='allCheckbox' onclick='selectAll(this, "id")'/></td>
						<td width="350" type="String"><label for="canArchive"><fmt:message key="common.name.label" bundle="${v3xCommonI18N }"/></label></td>
						<td type="String"><label for="canArchive"><fmt:message key="common.date.lastupdate.label" bundle="${v3xCommonI18N }"/></label></td>
					</tr>
					</thead>
					<tbody id="attBody">
						
					</tbody>
					</table>
					</div>
				</td>
			</tr>
		</table>
		</div>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="button" onclick="submitAttachment()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2 common_button_emphasize">&nbsp;
			<input type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>
<iframe name="officeEditorIframe" frameborder="0" height="0" width="0" scrolling="yes" marginheight="0" marginwidth="0"></iframe>
</body>
</html>