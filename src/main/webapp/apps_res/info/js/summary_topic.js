//遍历页面中span中属性xd:binding，放到js的hashtable中，便于以后读取
var opinionSpans = null;
var infoUpdateForm = false;
//全局变量，公文单是否修改标志
var isUpdateInfoForm = false;
//记录是否进行了正文修改
var contentUpdate = false;
//正文是否允许修改
var canUpdateContent = true;
//正文修改，主要用于区别套红 签章操作与修改正文
var changeWord = false ;

$(document).ready(function () {
    $(window).load(function() {
        if (opinionJson!="") {
//            var inner =document.getElementById("attachment2TR"+commentId).innerHTML;
//            document.getElementById("attaDocList").innerHTML=inner;
//            inner =document.getElementById("attachmentTR"+commentId).innerHTML;
//            document.getElementById("attaFileList").innerHTML=inner;
        	//countAttDocOrFile();
        }
    });
});


/** 修改报送单事件 */
function UpdateInfoForm(summaryId) {	
	
	parent.showPrecessAreaTd('edocform');
	
	// 判断是否有其他用户在修改文单
	if(checkAndLockInfoEditForm(summaryId)) return;
	
	//已经是文号修改状态
	if(infoUpdateForm){return;}

	var xml = document.getElementById("xml");
	var xsl = document.getElementById("xslt");
	
	initSeeyonForm(xml.value,xsl.value);

    //重新生成公文单后，重新显示意见，手写内容
    initSpans();
    dispOpinions(opinions,sendOpinionStr);
    initHandWrite();
    substituteLogo(logoURL);
    setObjEvent();
    		
    try{
    	if(firstCanEditElementId!="") {
    		var firstEditObj=document.getElementById(firstCanEditElementId);
    		if(firstEditObj!=null) {    			  	
    			firstEditObj.focus();
    		}
    	}
    }catch(e) {}
    
    isUpdateInfoForm = true;
    
    return;
}


//在多人执行时，判断是否有人修改正文。
function checkAndLockInfoEditForm(summaryId) {
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocSummaryManager", "editObjectState",false);
	requestCaller.addParameter(1, "String", summaryId);  
	var ds = requestCaller.serviceRequest();

	if(ds.get("curEditState")=="true") {  
	  	canUpdateWendan=false;  
		alert(_("edocLang.edoc_cannotedit"));
		return true;
	}
	//新建文档，不需要更新
	if(ds.get("lastUpdateTime")==null) {
		return false;
	}  
	return false;
}

//解锁，让别人可以修改文单
function unlockEdocEditForm(summaryId) {
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocSummaryManager", "deleteUpdateObj",false,"GET",false);
	requestCaller.addParameter(1, "String", summaryId);  
	if((arguments.length>1)) {
		requestCaller.addParameter(2, "String", arguments[1]);	
	}  
	requestCaller.serviceRequest();	
}


//处理时保存修改的报送单
function saveInfoForm() {
	if(document.sendForm.elements["my:subject"].value.trim()=="") {
		alert(_("edocLang.edoc_inputSubject"));
    	try { 
    		document.sendForm.elements["my:subject"].focus();
    	}catch(e){}
    	return false;
	}
	if(isUpdateInfoForm==false) { 
		return true;
	}
	document.sendForm.action = collaborationCanstant.updateInfoFormURL;
	if(validFieldData()==false) {
		return false;
	}
	// 确保发文单位被提交
	if(document.getElementById('my:report_unit')) {
		document.getElementById('my:report_unit').setAttribute('canSubmit','true');
	}
	
	var retData=ajaxFormSubmit(document.sendForm);
	var ret;
	if(retData.indexOf("result=true")>=0) {
		ret = true;
	} else {
		ret = false;
	}
	return ret;
}


function hiddeBorder(opn) {		
	var ops = opn.split(",");
	var spanObj;
	if(opinionSpans==null) {
		initSpans();
	}
	for(i=0;i<ops.length;i++) {
		spanObj=opinionSpans.get("my:"+ops[i]);
		if(spanObj!=null) {			
			spanObj.style.border="0px";			
		}
	}
	//20090917guoss修改，其它意见不在ops中，将其它意见的文本框也同时去掉
	if(opinionSpans.get("my:otherOpinion") !=null) {
		opinionSpans.get("my:otherOpinion").style.border="0px";
	}
}

function initSpans() {	
	var i,key;	
	var spanObjs=document.getElementsByTagName("span");
	opinionSpans=new Properties();
	for(i=0;i<spanObjs.length;i++)
	{		
		key=spanObjs[i].getAttribute("xd:binding");
		if(key!=null)
		{		
			//记录处理意见录入框的初始化大小，确定手写签批对话框大小;
			spanObjs[i].initWidth=spanObjs[i].style.width;
			spanObjs[i].initHeight=spanObjs[i].style.height;
			opinionSpans.put(key,spanObjs[i]);			
		}
	}	
}
function messagePushFun(){
	var dialog = $.dialog({
		 targetWindow:getCtpTop(),
	     id: 'messagePushDialog',
	     url: _ctxPath + "/info/infoDetail.do?method=messagePush&moduleId="+summaryId+"&mIdStr="+document.getElementById("pushMessageToMembers").value,
	     width: 320,
	     height: 340,
	     title: $.i18n('infosend.label.msgPush'),//消息推送
	     buttons: [{
	         text: $.i18n('collaboration.pushMessageToMembers.confirm'), //确定
	         btnType : 1,//按钮样式
	         handler: function () {
               var rv = dialog.getReturnValue();
       			if (!rv) {
       				return;
       			}
       			$('#comment_deal #pushMessageToMembers').val(rv[1]);
       			if(rv[2]>0){
       				$('#comment_deal #pushMessage').val(true);
       			}else{
       				$('#comment_deal #pushMessage').val(false);
       			}
       			dialog.close();
	     	}
	     }, {
	         text: $.i18n('collaboration.pushMessageToMembers.cancel'), //取消
	         handler: function () {
	             dialog.close();
	         }
	     }]
	 });
}
function insertAtta() {
//	quoteDocument('Doc2');
	quoteDocument(commentId);
	//insertAttachmentPoi(commentId);
	//countAttDocOrFile();
	$(".affix_del_16").click(function(){
	    //clearAttDocOrFile();
    });
}
function insertAttaFile() {
	//insertAttachmentPoi('attFile');
	insertAttachmentPoi(commentId);
	//countAttDocOrFile();
	$(".affix_del_16").click(function(){
	   // clearAttDocOrFile();
    });
}

function showPhraseDiv(){
	showPhrase(curUser);
}

//二次重构初始化显示附件和关联文档的间隔
function clearAttDocOrFile() {
    //判断附件是否存在，如果有则动态添加显示区域
    if($("#attaFileList").find($("#attachmentArea"+commentId+" div")).length>0){
        
    } else {
        //alert("无附件2！");
        $("#attaFileList").html("");
    }
    //判断关联文档是否存在，并动态添加显示区域
    if($("#attaDocList").find($("#attachment2Area"+commentId+" div")).length>0){
       
    }else{
        //alert("无关联文档");
        $("#attaDocList").html("");
    }
}

//重构初始化显示附件和关联文档的间隔
function countAttDocOrFile() {
    //判断附件是否存在，如果有则动态添加显示区域
    if($("#attachmentTR" + commentId).find($("#attachmentArea"+commentId+" div")).length>0){
        //alert("有附件1！");
    	
    	//附件字体有问题，进行修改
    	var tempAttCotent = $("#attachmentTR" + commentId).html();
    	tempAttCotent = tempAttCotent.replace(/(class[ ]*?=[ ]*?['"]{1})(.*?)(['"]{1})/ig,"$1$2 attach_font_size_fix$3");
        $("#attaFileList").html(tempAttCotent);
    } else {
        //alert("无附件2！");
        $("#attaFileList").html("");
    }
    //判断关联文档是否存在，并动态添加显示区域
    if($("#attachment2TR" + commentId).find($("#attachment2Area"+commentId+" div")).length>0){
        //alert("有关联文档");
    	//附件字体有问题，进行修改
    	var tempAttCotent = $("#attachment2TR" + commentId).html();
    	tempAttCotent = tempAttCotent.replace(/(class[ ]*?=[ ]*?['"]{1})(.*?)(['"]{1})/ig,"$1$2 attach_font_size_fix$3");
        $("#attaDocList").html(tempAttCotent);
    }else{
        //alert("无关联文档");
        $("#attaDocList").html("");
    }
}

//展示常用语
function showPhrase(str) {
    var callerResponder = new CallerResponder();
    //实例化Spring BS对象
    var pManager = new phraseManager();
    /** 异步调用 */
    var phraseBean = [];
    pManager.findCommonPhraseById({
        success : function(phraseBean) {
              var phrasecontent = [];
              var phrasepersonal = [];
              for (var count = 0; count < phraseBean.length; count++) {
                  phrasecontent.push(phraseBean[count].content);
                  if (phraseBean[count].memberId == str && phraseBean[count].type == "0") {
                      phrasepersonal.push(phraseBean[count]);
                  }
              }
              $("#cphrase").comLanguage({
                  textboxID : "contentOP",
                  data : phrasecontent,
                  posLeftRight: "right",
                  newBtnHandler : function(phraseper) {
                      $.dialog({
                          url : _ctxPath + '/phrase/phrase.do?method=gotolistpage',
                          transParams : phrasepersonal,
                          targetWindow:top,
                          title : $.i18n('collaboration.sys.js.cyy')
                      });
                  }
              });
            },
            error : function(request, settings, e) {
                $.alert(e);
            }
      });
}

function showOpinionsInputForm(){
	var insertObj = _disPosition;
	if(opinionSpans==null) { 
		initSpans();
	}
	var inputObj = opinionSpans.get("my:"+insertObj,null);
	//处理态度
	var str3 = "";
	//TODO
	if(parent.canShowAttitude=="true" ){
		str3 = document.getElementById("processAttitude").innerHTML;
		$("#processAttitude").remove();//吧隐藏域的删除了，避免新生成的意见js，无法通过文字选择radio。因为有重复！OA-53636
	}
	/*var processHTML="<div id='notPrint'>";
	if(canShowCommonPhrase=="true"){
		processHTML+='<div oncontextmenu="return false"';
		  processHTML+='style="position:absolute; right:350px; top:120px; width:450px; height:150px; z-index:2; background-color: #ffffff;display:none;overflow:no;border:1px solid #000000;"';
		  processHTML+='id="divPhrase" oncontextmenu="return false">';//onmouseout="hiddenPhrase()"
		  processHTML+='<IFRAME width="100%" id="phraseFrame" onmouseout="hiddenPhrase()" name="phraseFrame" height="100%" frameborder="0" align="middle" scrolling="no"';
		  processHTML+='marginheight="0" marginwidth="0"></IFRAME>';
		  processHTML+='</div>';
	}
	
	processHTML+="<table width='100%' border='0' cellspacing='0' cellpadding='0' >";
	
	var contentTop = 5;
	if(canShowAttitude=="true" || canShowCommonPhrase=="true" || canUploadAttachment=="true" || canUploadRel=="true") {
		processHTML+="<tr><td height='30' class='edoc_deal' style='padding: 0px 5px;'><div class='edoc_deal_div'>";
		contentTop = 0;
	}

	if(canShowAttitude=="true"){
		processHTML+="<div style='margin-top:-2px;display:none;'>";
		processHTML+=str3;
		processHTML+="</div>";
	}
	if(canShowCommonPhrase=="true"){
		var _phraseLabel = $.i18n('infosend.nodePerm.commonLanguage.label');
		processHTML+="<a id='cphrase' onclick='showPhraseDiv()' style='float:left;font-size:12px;display:inline-block;'>";
		processHTML+="<span class='ico16 common_language_16 margin_r_5'></span>";
		processHTML+=_phraseLabel+"</a>";
		
		processHTML+='<div oncontextmenu="return false" style="width:260px; height:60px; z-index:2; background-color: #ffffff;display:none;overflow:no;border:1px solid #000000;"';
		processHTML+='id="divPhrase" onmouseover="showPhrase()" onmouseout="hiddenPhrase()" oncontextmenu="return false">';
		processHTML+='<IFRAME width="100%" id="phraseFrame" name="phraseFrame" height="100%" frameborder="0" align="middle" scrolling="no" marginheight="0" marginwidth="0"></IFRAME>';
		processHTML+='</div>';
		
	}
	if(canUploadAttachment=="true"){
		var _uploadAttchment = $.i18n('infosend.label.uploadAttchment');
		processHTML+="<a  href='javascript:insertAttaFile();'  style='float:left;font-size:12px;display:inline-block;'>";
		processHTML+="<span class='ico16 affix_16 margin_r_5'></span>"+ _uploadAttchment+"</a>";
	}
	if(canUploadRel=="true"){
		var _document = $.i18n('infosend.label.relationDoc');
		processHTML+="<a href='javascript:insertAtta();' style='float:left;font-size:12px;display:inline-block;'>";
		processHTML+="<span class='ico16 associated_document_16 margin_r_5'></span>"+ _document+"</a>";
	}
	
	if(canShowAttitude=="true" || canShowCommonPhrase=="true" || canUploadAttachment=="true" || canUploadRel=="true") {
		processHTML+="</div></td></tr>";
	}
	
	if(canShowOpinion=="true"){
		processHTML+="<tr><td height='30' style='padding: "+contentTop+"px 5px;width:98%;'>";
	    processHTML+="<textarea id='contentOP' name='contentOP' rows='10'  style='width:100%' maxSize='1000' validate='maxLength'> </textarea>";
	    processHTML+="</td></tr>";
	}
	 processHTML+="<tr><td><div id='attaFileList'></div><br/><div id='attaDocList'></div></td></tr>";
	 processHTML+="</table>";
	 processHTML+="</div>";
*/
	
	 processHTML = $("#currentComment").html();
	 $("#currentComment").remove();
	 
	 /********** 意见显示，请不要再动我的了 ***********/
	 var insertObj = _disPosition;
	var inputObj = opinionSpans.get("my:"+insertObj,null);
	if(inputObj == null) {		  
		inputObj=opinionSpans.get("my:otherOpinion",null);
		if(inputObj==null){
			document.getElementById("dealOpinionTitleDiv").style.display = '';
			document.getElementById("processOtherOpinions").innerHTML=processHTML;
			document.getElementById("processOtherOpinions").style.display='';

			//在文档外面才不进行回退意见是否覆盖选择
			isOutOpinions = true;
		}else{
			hiddeBorderAndHeight(insertObj);
			inputObj.insertAdjacentHTML("beforeBegin",processHTML);
			//inputObj.insertAdjacentHTML("beforeBegin","<br>");
		}
	} else {
		hiddeBorderAndHeight(insertObj);
		inputObj.insertAdjacentHTML("beforeBegin", processHTML);
		//inputObj.insertAdjacentHTML("beforeBegin","<br>");
	}
		
	if(canShowOpinion=="true") {
		document.getElementById("contentOP").value=document.getElementById("attitudeOp").value;
	}
	
	//退回人打开信息操作控制
	if(''!='${subState}'){
		if('${subState}' =='15' || '${subState}' =='17'){
			canEdit=false;
			$(".validationStepback").attr('disabled','disabled').attr("href","javascript:;").css("color","#ccc");
		}
	}

	/*if(inputObj==null) {		  
		inputObj=opinionSpans.get("my:shenhe",null);
		if(inputObj==null){
			document.getElementById("processOtherOpinions").innerHTML=processHTML;
			document.getElementById("processOtherOpinions").style.display='';
		}else{
			hiddeBorderAndHeight(insertObj);
			inputObj.insertAdjacentHTML("beforeBegin",processHTML);
		}
	}else{
		hiddeBorderAndHeight(insertObj);
		  
		inputObj.insertAdjacentHTML("beforeBegin",processHTML);
	}

	 if(canShowOpinion=="true"){
		 $("#contentOP").val($("#attitudeOp").val());
	 }*/
	 
}


//贵州六盘水市政府——修改人：杨帆 2011-12-10———隐藏意见框中的文本框 --start
function hiddeBorderAndHeight(opn)
{		
	var ops = opn.split(",");
	var spanObj;
	if(opinionSpans==null){initSpans();}
	for(i=0;i<ops.length;i++)
	{
		spanObj=opinionSpans.get("my:"+ops[i]);
		if(spanObj!=null)
		{			
			spanObj.style.border="0px";	
			spanObj.style.height="0";	
		}
	}
	//20090917guoss修改，其它意见不在ops中，将其它意见的文本框也同时去掉
	if(opinionSpans.get("my:otherOpinion") !=null){
			opinionSpans.get("my:otherOpinion").style.border="0px";
		}
}
//贵州六盘水市政府——修改人：杨帆 2011-12-10———隐藏意见框中的文本框 --end




function replyCommentOK(date){
	parent.location.href = parent.location.href;
}
//重新加载附件显示
function reloadParentAtt(){
	var str1=document.getElementById("attachmentArea").innerHTML;
	var str2=document.getElementById("attachment2Area").innerHTML;
	str1=str1.replace(/deleteAttachment/g,'deleteParentAtt');
	str2=str2.replace(/deleteAttachment/g,'deleteParentAtt');
	document.getElementById("processatt1").innerHTML=str1;
	document.getElementById("processatt2").innerHTML=str2;	
}

function infoContentUnLoad() {
	try{
		unLoadHtmlHandWrite();
	}catch(e){}
}

