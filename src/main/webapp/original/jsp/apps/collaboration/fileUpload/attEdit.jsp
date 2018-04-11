<%--
 $Author:  miaoyf$
 $Rev:  $
 $Date:: 2012-11-15#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<title>${ctp:i18n('fileUpdate.page.title')}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
$(function(){
	var toolbar = $("#toolbar").toolbar({
	    toolbar: [{
	        id: "insertAttachment",
	        name: "${ctp:i18n('common.toolbar.insertAttachment.label')}",
	        className: "ico16 affix_16",
	        click:function(){
	        	addEditAttachment();
	        }
	    },{
	        id: "quoteMyDocument",
	        name: "${ctp:i18n('common.toolbar.insert.mydocument.label')}",
	        className: "ico16 associated_document_16",
	        click:function(){
	        	quoteMyDocument("position1");
	        }
	    },{
	        id: "delAttachment",
	        name: "${ctp:i18n('common.toolbar.delete.label')}",
	        className: "ico16 del_16",
	        click:function(){
	        	delAttachment();
	        }
	    }]
	});
});
var pw = new Object();
var isEdocAtt="${param.isEdocAtt}";
window.transParams = window.transParams || window.parent.transParams || {};//弹出框参数传递
window.dialogArguments = window.transParams.parentWin || window.dialogArguments;

function loadInit(){
	if($.browser.msie){
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
		
	}else{
		pw.installDoc=true;
		pw.installXls=true;
		pw.installWps=true;
		pw.installEt=true;
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
//页面初始化
function loadAttachment(){
	loadInit();
	var par = window.dialogArguments;
	var attList = par.attActionLog.editAtt;
	var	attBody = document.getElementById("attBody");
	//附件排序
	try{
		if(attList.size()>=2){
			attList.toArray().sort(function(a,b){
				var t1=new Date(a.createDate.replace(/-/g,'/')).getTime(); 
				var t2=new Date(b.createDate.replace(/-/g,'/')).getTime(); 
				return t2-t1;
			});
		}
	}catch(e){
	}
	//始化普通附件
	for(var i=0;i<attList.size();i++ ){
		var attachment = attList.get(i);
		if(attachment.type == 0 ){
			addAtt2Body(attachment,attBody,i);
		}
	}
	//初始化关联文档
	for(var i=0;i<attList.size();i++ ){
		var attachment = attList.get(i);
		if(attachment.type == 2){
			addAtt2Body(attachment,attBody,i);
		}
	}
	calcelHand();
}
//附件列表数据拼装
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
	var innerHTMLStr="";
	if(isEdocAtt&&isEdocAtt=="true"){//公文
		innerHTMLStr = "<label title='"+escapeStringToHTML(attachment.filename)+"'  ><input name='id' onclick='isCheckAll()' type='checkbox' id='"+attachment.id+"' reference='"+attachment.reference+"' subReference='"+attachment.subReference+"' category='"+attachment.category+"' "
							+"attType='"+attachment.type+"' filename='"+escapeStringToHTML(attachment.filename)+"' mimeType='"+attachment.mimeType+"' createDate='"+attachment.createDate+"' "
							+"size='"+attachment.size+"' fileUrl='"+attachment.fileUrl+"' description='"+ escapeStringToHTML(attachment.description) +"' needClone='"+attachment.needClone+"'"
							+" extension='"+attachment.extension+"' v='"+attachment.v+"' icon='"+attachment.icon+"' extReference='${param.reference}' extSubReference='${param.subReference}'" 
							+"/></label>";
	}else{
		innerHTMLStr = "<label title='"+escapeStringToHTML(attachment.filename)+"'  ><input name='id' onclick='isCheckAll()' type='checkbox' id='"+attachment.id+"' reference='"+attachment.reference+"' subReference='"+attachment.subReference+"' category='"+attachment.category+"' "
							+"typeAttach='"+attachment.type+"' filename='"+escapeStringToHTML(attachment.filename)+"' mimeType='"+attachment.mimeType+"' createDate='"+attachment.createDate+"' "
							+"size='"+attachment.size+"' fileUrl='"+attachment.fileUrl+"' description='"+ escapeStringToHTML(attachment.description) +"' needClone='"+attachment.needClone+"'"
							+" extension='"+attachment.extension+"' icon='"+attachment.icon+"' v='"+attachment.v+"' extReference='${param.reference}' extSubReference='${param.subReference}'"
							+"/></label>";
	}
	checkBox.innerHTML=	innerHTMLStr;
	var name = document.createElement('td');
	name.setAttribute("type","String");
	name.setAttribute("id",attachment.id+"nameTd");
	var onlineEdit = canEditOnline(attachment);
	
	//修改附件的列表中不应该显示收藏和查看
	attachment.canFavourite=false;
	attachment.isCanTransform=false;
	
	if(isEdocAtt&&isEdocAtt=="true"){//公文
		name.innerHTML =attachment.toString(false,false,onlineEdit,380);
	}else{
		name.innerHTML = att2String(attachment,onlineEdit,380);//协同
	}
	
	//name.style.width="60%";
	var updateDate = document.createElement('td');
	updateDate.setAttribute("type","Date");
	//updateDate.style.width="40%";
    //只显示到分钟，不显示秒
    var createDate = attachment.createDate;
    if(createDate && createDate.length > 16){
        createDate = createDate.substr(0,16);
    }
    updateDate.innerHTML = createDate;

	tr.appendChild(checkBox);
	tr.appendChild(name);
	tr.appendChild(updateDate);

	attBody.appendChild(tr);
}
//附件列表展现
function att2String(attachment,onlineEdit,width){
	var str = "";
	str += "<div id='attachmentDiv_" + attachment.fileUrl2 + "' class='attachment_block'>";
	var attShowName="";
	//改为表单组不截断，其他都截断
	 if(attachment.type != 1 && attachment.category !=2 ){
		var len = 25;
		if(width){
			len = parseInt(width/8);
		}
		if(!attachment.isShowImg){
		    attShowName += attachment.filename.getLimitLength(len).escapeHTML();
		}
	}else{
	    if(!attachment.isShowImg){
			attShowName += attachment.filename;
	    }
	}
	
	if(attachment.size && attachment.type == 0){
	    if(!attachment.isShowImg){
			attShowName += "(" + (parseInt(attachment.size/1024) + 1) + "KB)";
	    }
	} 
	// 名称及超链end
	//文件类型图标
	var iconSpan='';
	if(attachment.type != 1 && !attachment.isShowImg){
	    iconSpan += '&nbsp;<span class="ico16 '+attachment.icon.substring(0,attachment.icon.indexOf('.'))+'_16 margin_r_5"></span>';
	}
	str +=iconSpan;
	//增加编辑正文链接
	if(onlineEdit && attachment.category != 2){
		str += "<a onclick=\"editOfficeOnline(\'"+attachment.id+"\')\" title=\"" + escapeStringToHTML(attachment.filename) + "\" target='downloadFileFrame' style='font-size:12px;color:#000000;' class='like-a'>";
	}
	//附件标题
	str +=attShowName;
	//在线编辑office文档
	if((attachment.canEditOnline() && attachment.id != undefined) && attachment.category == 2){
        	 str += "<iframe id='officeEditorIframe' name='officeEditorIframe' frameborder=\"0\" height=\"0\" width=\"0\" scrolling=\"no\" marginheight=\"0\" marginwidth=\"0\"></iframe>";
        	 str += "<span id=\"editOnline_"+attachment.id+"\" > <a class=\"hand\" title = \"" + $.i18n("common.toolbar.edit.label") + "\" onclick=\"editOfficeOnline4Form(\'"+attachment.id+"\',\'"+attachment.fileUrl+"\',\'"+attachment.filename+"\',\'"+attachment.mimeType+"\',\'"+attachment.category+"\',\'"+attachment.createDate+"')\"><span class=\"ico16 editor_16\"></span></a></span>";
	}
	str += "&nbsp;</div>";
	return str;
}

//上传附件
function addEditAttachment(){
	insertAttachment();
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
//刷新附件列表
function sychorAtt(){
	//隐藏附件区域
	$("#attachmentArea").hide();
	$("#attachment2Areaposition1").hide();
	var attList = fileUploadAttachments.values();
	var	attBody = document.getElementById("attBody");
	var ff = attBody.childNodes.length%2;
	var createDate = "";
	var des = "";
	for(var i=0;i< attList.size();i++ ){
		var att = attList.get(i);
		if(isDuple(att)){
			$.alert($.i18n("collaboration.attEdit.has_same_att","&lt;"+att.filename+"&gt;"));
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
}

/**
 * 插入关联文档回调
 */
function quoteDoc_attEditCallback(){
    sychorAtt();
}

//删除附件
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
		$.alert("${ctp:i18n('collaboration.attEdit.system_lang_delete')}");
		return false;
	}
	var log = new ActionLog(2,(new Date()).format("yyyy-MM-dd HH:mm"),des);
	logList.add(log);
}
function checkBoxToAtt(att){
	var result;
	if(isEdocAtt&&isEdocAtt=="true"){
		result = new Attachment(att.id,att.getAttribute("reference"), att.getAttribute("subReference"),
				 att.getAttribute("category"), att.getAttribute("attType"), att.getAttribute("filename"),
				 att.getAttribute("mimeType"), att.getAttribute("createDate"), 
				 att.getAttribute("size"), att.getAttribute("fileUrl"), 
				 att.getAttribute("description"), att.getAttribute("needClone"),
				 att.getAttribute("extension"),att.getAttribute("icon"),false,false,att.getAttribute("v"));
	}else{
		result = new Attachment(att.id,att.getAttribute("reference"), att.getAttribute("subReference"),
							 att.getAttribute("category"), att.getAttribute("typeAttach"), att.getAttribute("filename"),
							 att.getAttribute("mimeType"), att.getAttribute("createDate"), 
							 att.getAttribute("size"), att.getAttribute("fileUrl"), 
							 att.getAttribute("description"), att.getAttribute("needClone"),
							 att.getAttribute("extension"),att.getAttribute("icon"));
		result.v=att.getAttribute("v");
	}
	result.onlineView = false;
	result.extReference = att.getAttribute("extReference");
	result.extSubReference = att.getAttribute("extSubReference");
	return result;
}
//协同dialog提交
function OK(){
	try{
		//设置修改附件的标志
		$('#attModifyFlag',window.dialogArguments.document).val('true');
	}catch(e){}
	var atts = document.getElementsByName("id");
	var attList = new ArrayList();
	for(var i = 0 ; i < atts.length ;i++){
		var att = checkBoxToAtt(atts[i]);
		attList.add(att);
	}
	return [attList,logList];
}

//公文模态对话框提交
function submitAttachment(){
	try{
		//设置修改附件的标志
		$('#attModifyFlag',window.dialogArguments.document).val('true');
	}catch(e){}
	var atts = document.getElementsByName("id");
	var attList = new ArrayList();
	for(var i = 0 ; i < atts.length ;i++){
		var att = checkBoxToAtt(atts[i]);
		attList.add(att);
	}
	_returnValue([attList,logList]);
	_closeWin(false);
}

/**
 *内部方法，向上层页面返回参数
 */
function _returnValue(value){
    if(transParams.popCallbackFn){//该页面被两个地方调用
        transParams.popCallbackFn(value);
    }else{
        window.returnValue = value;
    }
}

/**
 *内部方法，关闭当前窗口
 */
function _closeWin(setFlag){
    if(setFlag){
        try{
            $('#attModifyFlag',window.dialogArguments.document).val('false');
        }catch(e){
        }
    }
    if(transParams.popWinName){//该页面被两个地方调用
        transParams.parentWin[transParams.popWinName].close();
    }else{
        window.close();
    }
}
function checkYozo(name){
	var ebodyType="";
	var filename = name.toLocaleLowerCase();
	var point = filename.lastIndexOf(".");
	if(point != -1){
		ebodyType = filename.substring(point);
	}
	var isYozoWps = false;
	if(ebodyType && (ebodyType == ".wps" || ebodyType == ".et")){
		isYozoWps = true;
	}
    var isYoZoOffice = parent.isYoZoOffice();
    if(isYozoWps && isYoZoOffice){
 	   alert("对不起，您本地的永中office软件不支持对当前正文格式的此操作！");
 	   return true;
    }
    return false;
}
//编辑 Office的附件
function editOfficeOnline(id){
	var att = document.getElementById(id);
	var filename = att.getAttribute("filename");
	var category = att.getAttribute("category");
	var fileUrl = att.getAttribute("fileUrl");
	var createDate = att.getAttribute("createDate");
	var bodyType = getMimeType(att.getAttribute("mimeType"),filename);
	//永中office不支持wps正文修改
	var isYozoWps = checkYozo(filename);
	if(isYozoWps){
		return;
	}
	var url = _ctxServer+"/genericController.do?ViewPage=ctp/common/fileUpload/officeEdit&id="+id+"&filename="+encodeURIComponent(filename)+"&content="+fileUrl+"&bodyType="+bodyType+"&createDate="+createDate+"&category="+category+"&_isModalDialog=true";
	
	var subjectObj=document.getElementById("subject");
	if(subjectObj !== null){
		var point = filename.lastIndexOf(".");
		if(point != -1){
			subjectObj.value=filename.substring(0,point);
		}else{
			subjectObj.value=filename;
		}
	}
	officeEditorIframe.location.href=url;
	
	
}
function refreshAtt(att){
	var attTd = document.getElementById(att.id+"nameTd");
	var attachment = checkBoxToAtt(att);
	if(attTd && attachment){
		attTd.innerHTML = attachment.toString(false,false,true,380);
	}
}

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
}
function showAbout(){
    
    var _url=getA8Top().v3x.baseURL + "/genericController.do?ViewPage=apps/collaboration/fileUpload/attEditDes";
    var dialog = $.dialog({
        id : "showAbout",
        url : _url,
        title : $.i18n("collaboration.fileUpdate.page.about"),
        width : 300,
        height : 260,
        buttons : [
            {
                id : "okButton",
                text : $.i18n("common.button.close.label"),
                handler : function() {
                    dialog.close();
                }
            }
        ]
    });
}
function selectAll(allButton, targetName){
  var objcts = document.getElementsByName(targetName);
  
  if(objcts != null){
      for(var i = 0; i < objcts.length; i++){
          if(objcts[i].disabled == true){
              continue;
          }
          objcts[i].checked = allButton.checked;
      }
  }
}
function isCheckAll(){
	var checkedCount=0;
	var allCount=$("input[name='id']").size();
	$("input[name='id']").each(function(){
		if(this.checked==true){
			checkedCount++;
		}
	});
	if(allCount==checkedCount){
		$("#checkAll")[0].checked=true;
	}else{
		$("#checkAll")[0].checked=false;
	}
}
//去掉不能编辑的附件的图标手型
function calcelHand(){
	$("#attBody div.attachment_block").each(function(index) {
	    if($(this).find("a").length==0){
	    	$(this).find("span").css("cursor","auto");
	    }
	});
}
</script>
<style>
	.stadic_head_height{
		height:60px;
	}
	.stadic_body_top_bottom{
 		top: 60px;
		bottom: 35px;
	}
	.stadic_footer_height{
		height:35px;
	}
	.common_toolbar_box {
		background: none;
	}
</style>
</head>
<body  onload="loadAttachment()" scroll="no" class="h100b over_hidden">
<input type="hidden" name="subject" id="subject" value="">
<div style="display:none">
	<div class="comp" comp="type:'assdoc',attachmentTrId:'position1',applicationCategory:'1',referenceId:'${vobj.summary.id}', modids:'1,3',callMethod:'quoteDoc_attEditCallback'" attsdata='${attachmentsJSON}'></div>
	<div class="comp" comp="type:'fileupload',applicationCategory:'1',callMethod:'sychorAtt',takeOver:false" attsdata='${attachmentsJSON}'></div>
</div>
<div class="stadic_layout">
		<div class="stadic_layout_head stadic_head_height page_color line_height180 font_size12">
			<div class="clearfix">
				<div class="right" style="margin-right:15px;"><a onclick="showAbout()">${ctp:i18n('fileUpdate.page.about')}</a>&nbsp;&nbsp;</div>
			</div>
			<div class="hr_heng"></div>
			<div id="toolbar" style="padding:0px 15px;"></div>
		</div>
		<div class="stadic_layout_body stadic_body_top_bottom" style="padding:0px 20px;height:335px;width:510px;background:#fafafa;">
			<TABLE class="only_table edit_table" border=0 cellSpacing=0 cellPadding=0 width="100%">
				<THEAD>
					<TR>
						<TH width="5%" align="center" style="height:33px;text-align:center;background: rgb(128,171,211);"><input id="checkAll" onclick="selectAll(this,'id')" name="importlevelcheck" type="checkbox"/></TH>
						<TH style="color:#fff;background: rgb(128,171,211);">
							${ctp:i18n("collaboration.eventsource.category.name")}  <!-- 名称 -->
		                </TH>
		                <TH style="color:#fff;background: rgb(128,171,211);"> 
		                	${ctp:i18n("collaboration.fileUpdate.attEdit.updateTime")}<!-- 修改时间 -->
		                </TH>
					</TR>
				</THEAD>
				<TBODY id="attBody">
				</TBODY>
		    </TABLE>
		</div>
		<%-- 公文使用模态对话框 有提交按钮 --%>
		<c:if test="${param.isEdocAtt eq true }">
			<div class="stadic_layout_footer stadic_footer_height page_color align_right">
				<a id="btnok" class="common_button common_button_gray margin_t_5 common_button_emphasize" style='' onclick="submitAttachment()">${ctp:i18n('common.button.ok.label')}</a>&nbsp;<!-- 确定 -->
	            <a id="btncancel" class="common_button common_button_gray margin_t_5 margin_r_5" onclick="_closeWin(true)">${ctp:i18n('common.button.cancel.label')}</a><!-- 取消 -->
	        </div>
		</c:if>
	</div>
<iframe id="officeEditorIframe" name="officeEditorIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>