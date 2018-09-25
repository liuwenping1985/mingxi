var showPDFflag = true;
String.prototype.replaceAll = function(s1,s2) { 
    return this.replace(new RegExp(s1,"gm"),s2); 
}
function _hideButton(){
	$("#attachmentListFlag,#attachmentListFlag1").hide();//附件
	$("span[id^='favoriteSpan'],span[id^='cancelFavorite']").hide();//收藏
	$("#attributeSetting,#attributeSettingFlag").hide();//属性状态
	$("#showDetailLog,#showDetailLogFlag").hide();//明细日志
	$("#caozuo_more").hide();
	$("span[class='add_new']",document.componentDiv.document).hide();
	$("#processMaxFlag").hide();
	$("#msgSearch").hide();
}

function getCurPerm(){
	var curPerm = new Object();
	curPerm.appName = "collaboration";
	curPerm.defaultPolicyId = "collaboration";
	curPerm.defaultPolicyName = $.i18n('collaboration.newColl.collaboration');
	if(typeof(jsonPerm) != 'undefined'){
		curPerm.appName = jsonPerm.appName;
		curPerm.subAppName = jsonPerm.subAppName;
		curPerm.defaultPolicyId = jsonPerm.defaultPolicyId;
		curPerm.defaultPolicyName = jsonPerm.defaultPolicyName;
	}
	return curPerm;
}

function changeViewCallBack(currentIndex,toindex,cb){
	try{
	if(toindex != 0){
		//$(window.componentDiv)[0].document.zwIframe.isHasISignFlag()
		var fnx_zwIframe;
		if($.browser.mozilla){
    	 	fnx_zwIframe =$(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
    	 }else{
    	 	fnx_zwIframe =$(window.componentDiv)[0].document.zwIframe;
    	 }
		if(fnx_zwIframe.isHasISignFlag() && nowNodeIsSignatureHtml=="true"){
			var confirm = "";
	        confirm = $.confirm({
	            'msg': $.i18n('collaboration.summary.isign.title'),  //模板 '+subject+'已经存在，是否将原模板覆盖?
	            ok_fn: function () {
	                confirm.close();
                  
                  
	        	   fnx_zwIframe.preSubmitData(function(){
	        		   if (layout.getEastWidth() * 1 > 100) {
	                       $("#hidden_side").trigger("click");
	                     };
	                       $("#deal_area_show").hide();
	                       cb();
	        	   }, function(){}, false,false);
	            },
	            cancel_fn:function(){
	              confirm.close();
	            }
	         });
			
		}else{
				fnx_zwIframe.preSubmitData(function(){
					if (layout.getEastWidth() * 1 > 100) {
				    	$("#hidden_side").trigger("click");
				    };
				    $("#deal_area_show").hide();
					cb();
				}, function(){}, false,false);
		}
	}else if(toindex == 0 && openFrom=="listPending"){
		if(typeof(cb) =='function'){
    		cb();
    	}
		$("#hidden_side").trigger("click");
		$("#_opinionArea").trigger("click");
	}}catch(e){}
}

var isSubmitOperation = false;
//将所有操作置为可用状态
 function enableOperation(){
  //提交 
  $("#_dealSubmit").enable();
  //存为草稿
  $('#_dealSaveDraft').enable();
  //暂存待办
  $('#_dealSaveWait').enable();
  //态度
  $("input[name='attitude']").enable();
  //加签
  $("#_dealAddNode_a,#_commonAddNode_a").enable();
  //知会
  $("#_dealAddInform_a,#_commonAddInform_a").enable();
  //当前会签
  $("#_dealAssign_a,#_commonAssign_a").enable();
  //减签
  $("#_dealDeleteNode_a,#_commonDeleteNode_a").enable();
  //回退
  $("#_dealStepBack_a,#_commonStepBack_a").enable();
  //转发
  $("#_dealForward_a,#_commonForward_a").enable();
  //终止
  $("#_dealStepStop_a,#_commonStepStop_a").enable();
  //撤销流程
  $("#_dealCancel_a,#_commonCancel_a").enable();
  //修改附件
  $("#_commonUpdateAtt_a,#_dealUpdateAttachment_a").enable();
  //签章
  $("#_commonSign_a,#_dealSign_a").enable();
  // 指定回退
  $("#_dealSpecifiesReturn_a").enable();
  //修改正文
  $('#_commonEditContent_a,#_dealEditContent_a').enable();
  //督办设置开始
  $("#_commonSuperviseSet_a,#_dealSuperviseSet_a").enable();
  //转事件
     $("#_dealTransform_a,#_commonTransform_a").enable();
  //意见隐藏
  $("#isHidden").enable();
  //跟踪
  $("#isTrack").enable();
  //处理后归档
  $('#pigeonhole').enable();
  //常用语
  $('#cphrase').enable();
  //更多
  $('#moreLabel').enable();
  //消息推送
  $('#pushMessageButton').enable();
  //关联文档
  $('#uploadRelDocID').enable();
  //附件
  $('#uploadAttachmentID').enable();
  //通过并发布
  $('#_dealPass1').enable();
  //不通过
  $('#_dealNotPass').enable();
  //审核通过
  $('#_auditPass').enable();
  //审核不通过
  $('#_auditNotPass').enable();
  //核定通过
  $('#_vouchPass').enable();
  //核定不通过
  $('#_vouchNotPass').enable();
  //分办
  $('#_distribute').enable();
 }
 function disabl4Hw(){
	 //提交 
	 $("#_dealSubmit").disable();
 }
  //将所有操作置为不可用
 function disableOperation(){ 
  //提交 
  try {
	  $("#_dealSubmit").disable();
	  //存为草稿
	  $('#_dealSaveDraft').disable();
	  //暂存待办
	  $('#_dealSaveWait').disable();
	  //态度
	  $("input[name='attitude']").disable();
	  //加签
	  $("#_dealAddNode_a,#_commonAddNode_a").disable();
	  //知会
	  $("#_dealAddInform_a,#_commonAddInform_a").disable();
	  //当前会签
	  $("#_dealAssign_a,#_commonAssign_a").disable();
	  //减签
	  $("#_dealDeleteNode_a,#_commonDeleteNode_a").disable();
	  //回退
	  $("#_dealStepBack_a,#_commonStepBack_a").disable();
	  //转发
	  $("#_dealForward_a,#_commonForward_a").disable();
	  //终止
	  $("#_dealStepStop_a,#_commonStepStop_a").disable();
	  //撤销流程
	  $("#_dealCancel_a,#_commonCancel_a").disable();
	  //修改附件
	  $("#_commonUpdateAtt_a,#_dealUpdateAttachment_a").disable();
	  //签章
	  $("#_commonSign_a,#_dealSign_a").disable();
	  // 指定回退
	  $("#_dealSpecifiesReturn_a").disable();
	  //修改正文
	  $('#_commonEditContent_a,#_dealEditContent_a').disable();
	  //督办设置开始
	  $("#_commonSuperviseSet_a,#_dealSuperviseSet_a").disable();
	  //转事件
	     $("#_dealTransform_a,#_commonTransform_a").disable();
	  //意见隐藏
	  $("#isHidden").disable();
	  //跟踪
	  $("#isTrack").disable();
	  //处理后归档
	  $('#pigeonhole').disable();
	  //常用语
	  $('#cphrase').disable();
	  //更多
	  $('#moreLabel').disable();
	  //消息推送
	  $('#pushMessageButton').disable();
	  //关联文档
	  $('#uploadRelDocID').disable();
	  //附件
	  $('#uploadAttachmentID').disable();
	  //通过并发布
	  $('#_dealPass1').disable();
	  //不通过
	  $('#_dealNotPass').disable();
	  //审核通过
	  $('#_auditPass').disable();
	  //审核不通过
	  $('#_auditNotPass').disable();
	  //核定通过
	  $('#_vouchPass').disable();
	  //核定不通过
	  $('#_vouchNotPass').disable();
	  //分办
	  $('#_distribute').disable();
	 } catch(e) {}
 }

 //工作流回掉，固定函数名
 function releaseApplicationButtons(){
	 mainbody_callBack_failed();
 }

 //ajax判断事项是否可用。
 function isAffairValid(affairId){
   var cm = new colManager();
   var msg = cm.checkAffairValid(affairId);
   if($.trim(msg) !=''){
        $.messageBox({
            'title' : $.i18n('collaboration.system.prompt.js'), //系统提示
            'type': 0,
            'imgType':2,
            'msg': msg,
           ok_fn:function(){
                enableOperation();
                setButtonCanUseReady();
                closeCollDealPage();
           }
         });
        
        return false;
   }
   return true;
 }
 
 /**
  * 示例代码
  * 所保护字段
  * DocForm.SignatureControl.FieldsList="XYBH=协议编号;BMJH=保密级别;JF=甲方签章;HZNR=合作内容;QLZR=权利责任;CPMC=产品名称;DGSL=订购数量;DGRQ=订购日期"      
  */
 function getProjectField4Form(){
	 var projectArr=new Array();
     var projectData= "";
	 var projectValue= "";
     var ff = new Properties();
     var form  = componentDiv.document.zwIframe.getFieldVals4hw();
     projectArr.push(form.displayStr);
     projectArr.push(form.valueStr);
     return projectArr;
 }
 
 /**
  * 1、HTML编辑状态不能盖章
  * 2、对修改正文的地方增加限制：已经加盖了专业签章的地方不能修改正文
  * 3、表单数据域保护
  */
 function openSignature(){
	//永中office不支持wps正文修改
	var isYozoWps = checkYozo(bodyType);
 	if(isYozoWps){
 		return;
 	}
   if(isSpecifiesBack()){
       return;
   }
   //添加正文锁
   var lockWorkflowRe = lockWorkflow(summaryId, _currentUserId, 15);
   if(lockWorkflowRe[0] == "false"){
       $.alert(lockWorkflowRe[1]);
       return;
   }
   //表单正文和HTML标准正文加盖isignaturehtml专业签章
   if(bodyType=="10"||bodyType=="20"){
       try{
           //非IE浏览器不支持专业签章
           if(!$.browser.msie){
               $.alert($.i18n("collaboration.alert.isignature.not.ie"));
               return;
           }
           if (!componentDiv.document.zwIframe.isInstallIsignatureHtml()) {
               $.alert($.i18n("collaboration.client.not.installed.professional.signature"));
               return ;
           }
           var projectArr = new Array();
           if(bodyType=="20"){
               projectArr =getProjectField4Form();
           }
           componentDiv.document.zwIframe.doSignature(projectArr);
           
       }catch(e){
           $.alert($.i18n("collaboration.client.not.installed.professional.signature"));
           return false;
       }
       
   }else{
	   if($.browser.mozilla){
  	   		zwIframeObj =$(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
  	   	 }else{
  	   		zwIframeObj =$(window.componentDiv)[0].document.zwIframe;
  	   	 }
	   //防止点击其他按钮后控件外层div的style="width:0px;height:0px;overflow:hidden; position: absolute;"导致全屏控件被关闭后无法显示
	   $(zwIframeObj)[0].$("#officeFrameDiv").attr("style","display:none;height:100%");
	   $(zwIframeObj)[0].$("#officeTransIframe").remove();
	   $(zwIframeObj)[0].$("#officeFrameDiv").show();
	   $(zwIframeObj)[0].checkOpenState();
	   window.setTimeout(function(){
		   $(zwIframeObj)[0].WebOpenSignature();
		   $(zwIframeObj)[0].officeEditorFrame.document.getElementById("WebOffice").EditType = "1,0";//盖章的时候要设置为可编辑状态，否则专业签章的按钮显示不对
	   },100);
	   zwIframeObj.$("#viewState").val("1");
   }
   summaryChange();   
   //设置正文为编辑状态
   
 }
 function popupContentWin(){
	 if($.browser.mozilla){
	   	var zwIframeObj =$(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
	 }else{
	   	var zwIframeObj =$(window.componentDiv)[0].document.zwIframe;
	 }
	 //将office控件的隐藏方式修改成以下这种。如果是display=none方式隐藏控件在FireFox 下不能加载
	 if($(zwIframeObj)[0].$("#officeFrameDiv").css("display")=="none"){
		 $(zwIframeObj)[0].$("#officeFrameDiv").attr("style","width:0px;height:0px;overflow:hidden; position: absolute;");
	 }
	 if(typeof($(zwIframeObj)[0].isHandWriteRef)=='function' && $(zwIframeObj)[0].isHandWriteRef()==false){
		 return;
	 }
	 $(zwIframeObj)[0].checkOpenState();
	 $(zwIframeObj)[0].fullSize();
 }
 //保存 ISiginature HTML 专业签章
 function saveISignature(){
     try{
         //var bodyTypeStr = $("#bodyType").val();//V57表单正文只有HTML类型。所以不需要判断类型，而且当前取出的类型为非表单正文类型。所以有问题
         var flag = true;
         //if(bodyTypeStr == '10' || bodyTypeStr == '20'){
        	 var fnx_zwIframe;
        	 if($.browser.mozilla){
        	 	fnx_zwIframe =$(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
        	 }else{
        	 	fnx_zwIframe =$(window.componentDiv)[0].document.zwIframe;
        	 }
        	flag = fnx_zwIframe.saveISignatureHtml();
         //}
         return flag;
     }catch(e){
         return false;
     }
     return true;
 }


 function downloadAttrList(fileUrl,uploadTime,fileName,fileType,v){
   var url=_ctxPath + "/fileDownload.do?method=download&v="+v+"&fileId="+fileUrl+"&createDate="+uploadTime+"&filename="+encodeURIat(fileName);
   if($.trim(fileType)!==""){
     url+="."+fileType;
   }
   $("#downloadFileFrame").attr("src",url);
 }
 
//指定回退
 function specifiesReturn() {
	//将相关意见框的意见同步到主页面 zhangdong 20170329 start
 	beforeSubmitButton();
 	//将相关意见框的意见同步到主页面 zhangdong 20170329 end
   // 指定回退状态
     if(isSpecifiesBack()){
       enableOperation();
     setButtonCanUseReady();
       return;
     }
     if (!dealCommentTrue("specifiesReturn")){
       enableOperation();
       setButtonCanUseReady();
         return;
     }
     try{
 	    var cm= new colManager();
 	    if(cm.isNotDistribute(affairId,summaryId)){
 	    	$.alert("该流程已分送，无法回退");
 	        enableOperation();
 	        setButtonCanUseReady();
 	        return;
 	    }
     }catch(e){}
     stepBackToTargetNode(getCtpTop(), getCtpTop(),
         _summaryItemId,_summaryProcessId,
         _summaryCaseId, _summaryActivityId,
         stepBackToTargetNodeCallBack,
         show1, show2,isFromTemplate);
 }
 
 function stepBackToTargetNodeCallBack(workitemId, processId, caseId, activityId, theStepBackNodeId, submitStyle, falshDialog) {
   falshDialog.close();
   var domains = [];
   if($.content.getContentDealDomains(domains)) {
	   var jsonSubmitCallBack = function(){
		   $("#layout").jsonSubmit({
			   action : _ctxPath+ "/collaboration/collaboration.do?method=updateAppointStepBack"
			   +"&workitemId="+workitemId
			   +"&processId="+processId
			   +"&caseId="+caseId
			   +"&activityId="+activityId
			   +"&theStepBackNodeId="+theStepBackNodeId
			   +"&submitStyle="+submitStyle
			   +"&summaryId="+summaryId
			   +"&affairId="+affairId,
			   domains : domains,
			   callback:function(data){
				   //保存公文正文
           		   saveGovdocContent();
				   closeCollDealPage();
			   }
		   });
	   };
		
		// office正文需要更新或者保存
	    var _saveContentCallBack = function(){
	    	var fnx;
			if ($.browser.mozilla) {
				fnx = $(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
			} else {
				fnx = $(window.componentDiv)[0].document.zwIframe;
			}
			fnx.saveOrUpdate({
          		failed:mainbody_callBack_failed,
          		success : jsonSubmitCallBack,
          		checkNull:false,
                needCheckRule:false,
                needCheckRepeatData:false,//是否校验重复行数据          		
          		needSubmit:true,
          		"mainbodyDomains":domains
        	});
	    }
	   //V50_SP2_NC业务集成插件_001_表单开发高级
	   formDevelopAdance4ThirdParty(bodyType,affairId,"stepBack", $("#content_deal_comment").val(),null,_saveContentCallBack);

   };
 }
 

 /**
  * 加表单同步锁
  */
 var hasSubmitButtonFlag = true;
  function formAddLock(){
    var callerResponder = new CallerResponder();
    callerResponder.success = function(jsonObj) {
      if(jsonObj && jsonObj.canSubmit == "0"){
        $.alert(jsonObj.loginName + $.i18n('collaboration.common.flag.editingForm'));  //正在编辑表单
        $("#_dealDiv").hide();
        $("#_dealStepBack,#_commonStepBack").addClass("back_disable_color").disable();//回退
        $("#_dealCancel_a,#_commonCancel_a").addClass("back_disable_color").disable();//撤销
        $("#_dealStepStop,#_commonStepStop").addClass("back_disable_color").disable(); //终止 
        //修改附件
        $("#_commonUpdateAtt,#_dealUpdateAttachment").addClass("back_disable_color").disable();
        $("#_commonUpdateAtt_a,#_dealUpdateAttachment_a").addClass("common_menu_dis").disable();
        $("#_dealSpecifiesReturn").addClass("back_disable_color").disable();//指定回退
        $("#_dealSpecifiesReturn_a").addClass("back_disable_color").disable();
        hasSubmitButtonFlag = false;
      }
    };
    var cm = new colManager();
    cm.formAddLock($("#affairId").val(), callerResponder);
  }
 
  /**
   * 修改完流程，解除流程同步锁
   */
  function colDelLock(affairId){
	if(isHasDealPage == 'true' && hasSubmitButtonFlag){
		if(typeof(colManager) == 'function'){
			var cm = new colManager();
			var param = new Object();
			param.summaryId = summaryId;
			param.bodyType = bodyType;
			param.processId = _summaryProcessId;
			param.fromRecordId = fromRecordId;
			param.formAppId = fromRecordId;
			
			cm.ajaxColDelLock(param);
		}
	}
	WebClose();
  }
 
  /**
   * 向具体位置中增加附件
   */
  function addAttachmentPoiDomain(type, filename, mimeType, createDate, size, fileUrl, canDelete, needClone, description, extension, icon, poi, reference, category, onlineView,isCanTransform,v) {
    canDelete = canDelete == null ? true : canDelete;
    needClone = needClone == null ? false : needClone;
    description = description ==null ? "" : description;
    if(attachDelete != null) canDelete = attachDelete;
    if(fileUrl == null){
      fileUrl=filename;
    }
    var isCanTransformEnable= _isOfficeTrans ? "enable":"";
    var attachment = new Attachment('', '', '', '', type, filename, mimeType, createDate, size, fileUrl, description, needClone,extension,icon,onlineView,isCanTransformEnable,v);
    attachment.showArea=poi;
    attachment.hasSaved=true;
    attachment.canFavourite=false;
    attachment.v=v;//下载


    fileUploadAttachments.put(fileUrl, attachment);
    showAtachmentObject(attachment, canDelete, null);
    //更新关联文档隐藏域
    var file=attachment;
    if(file.type==2  && $("#"+file.embedInput).size()>0){
        var assArray =new Array();
        if($("#"+file.embedInput).attr("value")){
          assArray=$("#"+file.embedInput).attr("value").split(",");
        }
       
        if(!assArray.contains(file.fileUrl)){
          assArray.push(attachment.fileUrl);
        }
        $("#"+file.embedInput).attr("value", assArray);
    }
    showAtachmentTR(type,'',poi);
    if(attachCount)
      showAttachmentNumber(type,attachment);
    if(typeof(currentPage) !="undefined" && currentPage== "newColl"){
      addScrollForDocument();
    }
  }
   
function updateAtt(processId,summaryId){
    var lockWorkflowRe = lockWorkflow(summaryId, _currentUserId, 16);
    if(lockWorkflowRe[0] == "false"){
        $.alert(lockWorkflowRe[1]);
        return;
    }
    // 取得要修改的附件
    var attachmentList = new ArrayList();
    var keys = fileUploadAttachments.keys();
    // 过滤非正文区域的附件
    var keyIds=new ArrayList();
    for(var i = 0; i < keys.size(); i++) {
    	var att = fileUploadAttachments.get(keys.get(i));
    	if(att.showArea=="showAttFile"||att.showArea=="Doc1"){
    		attachmentList.add(att);
    		keyIds.add(keys.get(i));
    	}
    }
    editAttachments(attachmentList,summaryId,summaryId,'1',keyIds);
}
//弹出修改附件页面
function editAttachments(atts, reference, subReference, category, keyIds) {
	if (attActionLog == null) {
		attActionLog = new AttActionLog(reference, subReference, null, atts);
	}
	reference = reference || "";
	subReference = subReference || "";
	var dialog = $.dialog({
		id : "showForwardDialog",
		url : _ctxPath
				+ "/genericController.do?ViewPage=apps/collaboration/fileUpload/attEdit&category="
				+ category + "&reference=" + reference
				+ "&subReference=" + subReference,
		title : $.i18n("collaboration.nodePerm.allowUpdateAttachment"),
		targetWindow : getCtpTop(),
		transParams : {
			attActionLog : attActionLog
		},
		width : 550,
		height : 430,
		buttons : [
			{
				id : "okButton",
				text : $.i18n("common.button.ok.label"),
				handler : function() {
					var retValue = dialog.getReturnValue();
					if (retValue) {
						var attachmentList = new ArrayList();
						var inst = retValue[0].instance;
						for (var i = 0; i < inst.length; i++) {
							var att = copyAttachment(inst[i]);
							att.onlineView = false;
							attachmentList.add(att);
						}
						var logList = new ArrayList();
						inst = retValue[1].instance;
						if (inst.length == 0) {
							dialog.close();// 关闭窗口
							return false;
						}
						for (var i = 0; i < inst.length; i++) {
							var att = copyActionLog(inst[i]);
							logList.add(att);
						}
						var save = saveEditAttachments(logList,
								attachmentList);
						if (!save) {
							dialog.close();// 关闭窗口
							return null;
						}
						var result = attActionLog.editAtt;
						if (result) {
							// 标记协同内容有变化，关闭页面时需进行判断
							summaryChange();
							// 将修改后的附件，与本地更新。
							var toShowAttTemp = new ArrayList();
							for (var i = 0; i < theToShowAttachments
									.size(); i++) {
								var att = theToShowAttachments
										.get(i);
								toShowAttTemp.add(att);
							}
							for (var i = 0; i < toShowAttTemp
									.size(); i++) {
								var att = toShowAttTemp.get(i);
								if (att.showArea != "showAttFile"
										&& att.showArea != "Doc1") {
									theToShowAttachments
											.remove(att);
								}
							}
							theToShowAttachments = new ArrayList();
							updateAttachmentMemory(result,
									summaryId, summaryId, '');
						} else {
							theToShowAttachments = attachmentList;
							dialog.close();// 关闭窗口
							return;// 沒有修改附件直接返回
						}
						try {
							clearAttOrDocShowArea("attachmentNumberDivshowAttFile");
							clearAttOrDocShowArea("attachmentAreashowAttFile");
							clearAttOrDocShowArea("attachment2NumberDivDoc1");
							clearAttOrDocShowArea("attachment2AreaDoc1");
							hideTr("attachmentTRshowAttFile");
							hideTr("attachment2TRDoc1");
						} catch (e) {

						}
						for (var k = 0; k < keyIds.size(); k++) {
							fileUploadAttachments.remove(keyIds
									.get(k));
						}
						for (var i = 0; i < theToShowAttachments
								.size(); i++) {
							var att = theToShowAttachments.get(i);
							var poi;
							if (att.type == 0) {
								poi = 'showAttFile';
							} else if (att.type == 2) {
								poi = 'Doc1';
							}
							addAttachmentPoiDomain(att.type,
									att.filename, att.mimeType,
									att.createDate ? att.createDate
											.toString() : null,
									att.size, att.fileUrl, false,
									false, att.description,
									att.extension, att.icon, poi,
									att.reference, att.category,
									true, att.isCanTransform, att.v);
						}
						$("#attFileDomain").html("");
						$("#assDocDomain").html("");
						saveAttachmentPart("attFileDomain");
						saveAttachmentPart("assDocDomain");
						saveAttachmentActionLog();
						summaryHeadHeight();
					}
					dialog.close();// 关闭窗口
				},
				OKFN : function() {
					dialog.close();
				}
			}, {
				id : "cancelButton",
				text : $.i18n("common.button.cancel.label"),
				handler : function() {
					dialog.close();
				}
			} ]
	});
}
//提交和暂存待办 保存附件 start
function saveAttachments(){
	if(attActionLog){
		$("#attFileDomain").html("");
		$("#assDocDomain").html("");
		saveAttachmentPart("attFileDomain");
		saveAttachmentPart("assDocDomain");
		saveAttachmentActionLog();
		var attachmentInputsObj = document.getElementById("attachmentInputs");
		attachmentInputsObj.innerHTML = attActionLog.toInput();
		$('#attchmentForm').ajaxSubmit({
			url : "/seeyon/edocController.do?method=updateAttachment&edocSummaryId="+summaryId+"&affairId="+affairId+"&govdoc=govdoc",
			type : 'POST',
			success : function(data) {
				var result=attActionLog.editAtt;
				updateAttachmentMemory(result,summaryId,summaryId,'');
				//附件提交完成后，需要清理缓存日志
				try{
					attActionLog.logs = null;
				}
				catch(e){}
			}
		})
	}
}
//提交和暂存待办 保存附件 end
function saveAttachmentActionLog(){
  if(typeof(attActionLog) != 'undefined' && attActionLog){
      var result = "";
      var attLogListObj=$("#attActionLogDomain");
      if(attActionLog.logs != null && typeof(attActionLog.logs) != 'undefined' ){
          for(var i = 0 ; i< attActionLog.logs.size();i++){
        	  var attObj=attActionLog.logs.get(i);
        	  if(!checkIsExist(attLogListObj,attObj)){
        		  result += attActionLog.logs.get(i).toInput();
        	  }
          }
      }
      $("#attActionLogDomain").append($(result));
  }
}

/**
 * 批量下载
 */
function doloadFileFun(userId,$obj){
	if(getA8Top().xmlDoc == null){
		$.alert($.i18n('collaboration.summary.attachment.title'));
		//Bulk download control failed to load, please click on the login page of the 'auxiliary program to install' download and install!
		//批量下載控件加載失敗，請點擊登錄頁面的《輔助程序安裝》下載安裝！
		return;
	}
// getA8Top().contentFrame.topFrame.showDowloadPicture("doc");
	var ipUrl = window.location.href;
	var startUrl = ipUrl.substring(0, ipUrl.indexOf("/seeyon")) + "/seeyon";
	//var ids = $obj;
	var size = 0;
	var pigCount = 0;
	var hasFolder = false;
	//alert($obj.size());
	for (var i = 0; i < $obj.size(); i ++) {
			size += 1;
			var id = $obj[i].value;
			var downloadFrName = $($obj[i]).attr("frName")+'.'+$($obj[i]).attr("frType");
			//alert(downloadFrName);
			if(document.getElementById(id + "_Size")){
			  var downloadFrSize = document.getElementById(id + "_Size").value;
			}
			var vForDocDownload = $($obj[i]).attr("frVStr");
			var url;
			var result;
			
			//var isBorrow = isShareAndBorrowRoot == "true" && (frType == "102" || frType == "103");
			var isBorrow = false;
			downloadFrName = downloadFrName.replace(/ /g, "");
			url = startUrl + "/collaboration/collaboration.do?method=checkFile&docId=" + id + "&isBorrow=" + isBorrow+"&v="+vForDocDownload;
			result = getA8Top().xmlDoc.AddDownloadFile(userId, downloadFrSize, downloadFrName, url);
	}
}

//检查当前的attActionLog是否已经记录了这个附件
function checkIsExist(attLogListObj,attObj){
	var attTitle=attObj.des;
	for(var i=0;i<attLogListObj.size();i++){
		var attLogObj=attLogListObj.get(i);
		var attLogHTML="";
		if(attLogObj&&attLogObj.innerHTML){
			attLogHTML=attLogObj.innerHTML;
		}
		if(attLogHTML==""&&attLogObj&&attLogObj.outerHTML){
			attLogHTML+=attLogObj.outerHTML;
		}
		if(attLogHTML&&attLogHTML.indexOf(attTitle)!=-1){
			return true;
		}
	}
	return false;
}
function clearAttOrDocShowArea(id){
  var showDiv = document.getElementById(id);
  if(showDiv){
    showDiv.innerHTML="";
  }
}
function hideTr(attachmentTrId){
  var attachmentTr = document.getElementById(attachmentTrId);
  if(attachmentTr){
    attachmentTr.style.display = "none";
  }
}

function transmitColById(data){
  var dataStr = "";
  for(var i = 0; i < data.length; i++){
      dataStr += data[i]["summaryId"] + "_" + data[i]["affairId"] + ",";
  }
  
  var commentAttFiles = [];
  var commentAttDocs = [];
  
  var atts = fileUploadAttachments.values();
  for (var i = 0; i < atts.size(); i++) {
      var att = atts.get(i);

      if(att.showArea != commentId){
          continue;
      }
      
      var attjson = att.toJson();
      var attjsonObj = $.parseJSON(attjson);
      
      attjsonObj.needClone = true;
      attjsonObj.extReference = "";
      attjsonObj.extSubReference = "";
      
      if(att.type == "2" || att.type == "4"){ //关联文档
          commentAttDocs[commentAttDocs.length++] = $.toJSON(attjsonObj);
      }
      else{ //文件附件
          commentAttFiles[commentAttFiles.length++] = $.toJSON(attjsonObj);
      }
  }
  
  var dialog = $.dialog({
      id : "showForwardDialog",
      url : _ctxPath+'/collaboration/collaboration.do?method=showForward&data=' + dataStr,
      title : $.i18n('collaboration.transmit.col.label'),
      targetWindow: getCtpTop(),
      height:"415",
      transParams:{
          commentContent : $("#content_deal_comment").val(),
          commentAttFiles : "[" + commentAttFiles.join(",") + "]",
          commentAttDocs : "[" + commentAttDocs.join(",") + "]"
      },
      buttons: [{
          id : "okButton",
          text: $.i18n("common.button.ok.label"),
          handler: function () {
             var rv = dialog.getReturnValue();
             if(rv == -1){
                 
             }
             else{
                 $.alert($.i18n('collaboration.forward.forwardSuccess')); //转发成功!
                 dialog.close();
             }
          },
          OKFN : function(){
              dialog.close();
          }
      }, {
          id:"cancelButton",
          text: $.i18n("common.button.cancel.label"),
          handler: function () {
              dialog.close();
          }
      }]
  });
}
/**
 * 转会议接口，页面之间跳转到新建会议页面
 * @param affairId 
 * @param collaborationFrom
 * @param frameObj     需要跳转到新建会议的框架
 * @param closeWin     是否关闭当前窗口，true：关闭；false：不关闭
 */
function createMeeting(affairId,collaborationFrom,frameObj,closeWin){
    if($.ctx.plugins.contains('meeting')){ 
          var  url = _ctxPath + "/meetingNavigation.do?method=entryManager&entry=meetingArrange&listType=listSendMeeting&listMethod=create&affairId="+affairId+"&collaborationFrom="+collaborationFrom+"&formOper=new&moduleTypeFlag=edoc";
          openCtpWindow({"url":url,"id":(affairId+"createMeeting")});
    } 
}


function doSearch(flag){
  if(typeof(flag)=='undefined' || flag == null){
      flag = 'forward';
  }
  var t = document.getElementById('searchText').value;
  componentDiv.$.content.commentSearchCreate(t, flag);
  return false;
}
function enterKeySearch(e) {
  var c;
  if ("which" in e) {
    c = e.which;
  } else if ("keyCode" in e) {
    c = e.keyCode;
  }
  if (c == 13) {
    doSearch("forward");
  }
}

function advanceViews(flag,obj) {
  var processAdvanceDIVObj = document.getElementById("processAdvanceDIV");
  var isDisplay = flag;
  if(flag == null){
      isDisplay = processAdvanceDIVObj.style.display == "none";
  }
  if(isDisplay){
      //判断当前是否是office插件
      if (bodyType >= 40 && bodyType<=45 && (!_isOfficeTrans || $("#viewOriginalContentA").size() < 0 || $("#viewOriginalContentA").is(":hidden"))) {
          processAdvanceDIVObj.style.top = ($(obj).offset().top-40)+"px";
      } else {
          processAdvanceDIVObj.style.top = ($(obj).offset().top+20)+"px";
      }
      processAdvanceDIVObj.style.display = "";
      if(document.getElementById("processAdvance"))
          document.getElementById("processAdvance").innerHTML = "<font style='color:#5A5A5A;'>&gt;&gt;</font>";
  }else{
      processAdvanceDIVObj.style.display = "none";
      if(document.getElementById("processAdvance"))
          document.getElementById("processAdvance").innerHTML = "<font style='color:#5A5A5A;'>&gt;&gt;</font>";
  }
}

//跟踪
function setTrack(){
   var dialog = $.dialog({
     targetWindow:getCtpTop(),
     id: 'trackDialog',
     url: _ctxPath+'/collaboration/collaboration.do?method=openTrackDetail&objectId='+summaryId+'&affairId='+affairId,
     width: 200,
     height: 100,
     title: $.i18n('collaboration.listDone.traceSettings'),
     buttons: [{
         text: $.i18n('collaboration.pushMessageToMembers.confirm'), //确定
         handler: function () {
              var returnValue = dialog.getReturnValue();
              if(returnValue == 2){
            	  if($(window.frames["trackDialog_main_iframe"].document).find("#zdgzry").val().length==0){
            		  alert("指定人不能为空");
            		  return;
            	  }
              }else{
            	  $('#zdgzry').val(""); 
              }
              dialog.close();
              if(openFrom = "listSent"  && window.parent && window.parent.$('#listSent')[0]){
 									window.parent.$('#listSent').ajaxgridLoad();
 							}
  						if(openFrom = "listDone"  && window.parent && window.parent.$('#listDone')[0]){
 										window.parent.$('#listDone').ajaxgridLoad();
 							}
         }
     }, {
         text: $.i18n('collaboration.pushMessageToMembers.cancel'), //取消
         handler: function () {
             dialog.close();
         }
     }]
 });
}

/**
 * 查看属性设置信息 弹出对话框
 */
function attributeSettingDialog(affairId){
    var dialog = $.dialog({
        url : _ctxPath+'/collaboration/collaboration.do?method=getAttributeSettingInfo&affairId='+affairId+'&isHistoryFlag='+isHistoryFlag+'&isGovdocFlag=true',
        width : 500,
        height : 450,
        targetWindow:openType,
        title : $.i18n('collaboration.common.flag.findAttributeSetting'),  // 查看属性状态设置
        buttons : [{
            text :$.i18n('collaboration.dialog.close'),//关闭
            handler : function() {
              dialog.close();
            }
        }]
    });
}
function showDetailLogFunc(){
  showDetailLogDialog(summaryId,_summaryProcessId);
}
/**
* 明细日志 弹出对话框
*/
function showDetailLogDialog(summaryId,processId){
  var dialog = $.dialog({
      url : _ctxPath+'/detaillog/detaillog.do?method=showDetailLog&summaryId='+summaryId+'&processId='+processId+'&isHistoryFlag='+isHistoryFlag,
      width : 800,
      height : 400,
      title :$.i18n('collaboration.sendGrid.findAllLog'), //查看明细日志
      targetWindow:openType,
      buttons : [{
          text : $.i18n('collaboration.dialog.close'),
          handler : function() {
            dialog.close();
          }
      }]
  });
}
//回退（用于处理协同的业务逻辑处理）
function stepBackCallBack(){
	//将相关意见框的意见同步到主页面 zhangdong 20170329 start
	beforeSubmitButton();
	//将相关意见框的意见同步到主页面 zhangdong 20170329 end
	//流程锁
	var resultLock= lockWorkflow(wfProcessId, currUserId,9);
    if(resultLock[0]=='false'){
       $.alert(resultLock[1]);
       return;
    }
	//js事件接口
	var sendDevelop = $.ctp.trigger('beforeDealstepback');
	if(!sendDevelop){
		 return;
	}
	
  //置灰
  disableOperation();
    //var confirm = "";
    if (!dealCommentTrue("stepBack")){
      enableOperation();
      setButtonCanUseReady();
        return;
    }
    //调用工作流函数判断是否能够回退
    var obj = canStepBack(_contextItemId,_contextProcessId,_contextActivityId,_contextCaseId);
    //不能回退
    if(obj[0] === 'false'){
        $.alert(obj[1]);
        enableOperation();
        setButtonCanUseReady();
        return;
    }
    var lockWorkflowRe = lockWorkflow(_contextProcessId,_currentUserId, 9);
    if(lockWorkflowRe[0] == "false"){
        $.alert(lockWorkflowRe[1]);
        enableOperation();
        setButtonCanUseReady();
        return;
    }
    try{
	    var cm= new colManager();
	    if(cm.isNotDistribute(affairId,summaryId)){
	    	$.alert("该流程已分送，无法回退");
	        enableOperation();
	        setButtonCanUseReady();
	        return;
	    }
    }catch(e){}
    
    if(!isAffairValid(affairId)) return;
    if(!executeWorkflowBeforeEvent("BeforeStepBack",summaryId,affairId,_contextProcessId,_contextProcessId,_contextActivityId,formRecordid,_moduleTypeName)){
		return;
	}
    	var dialog = $.dialog({
    		 targetWindow:getCtpTop(),
    	     id: 'stepbackdialog',
    	     bottomHTML:'<label for="trackWorkflow" class="margin_t_5 hand">'+
 			'<input type="checkbox" id="trackWorkflow" name="trackWorkflow" class="radio_com">'+$.i18n("collaboration.workflow.trace.traceworkflow")+
 			'</label><span class="color_blue hand" style="color:#318ed9;" title="'+$.i18n("collaboration.workflow.trace.summaryDetail")+
 			'">['+$.i18n("collaboration.workflow.trace.title")+']</span>',
    	     url: _ctxPath +"/collaboration/collaboration.do?method=stepBackDialog&affairId="+affairId,
    	     width: 350,
    	     height: 150,
    	     title: "系统提示",
    	     closeParam:{	
    	    	 			show:true,
    	    	 			autoClose:true,
    	    	 			handler:function(){
    	    	 				enableOperation();
    	    	 				setButtonCanUseReady();
    	     				}
    	     },
    	     buttons: [{
    	         text: $.i18n('collaboration.pushMessageToMembers.confirm'), //确定
    	         handler: function () {
                    var rv = dialog.getReturnValue();
                    //alert(rv[0]);return;
            		if (!rv) {
            	        return;
            	    }
            		var trackWorkflowType = rv[0];
            		var fnx;
            		if($.browser.mozilla){
            			fnx  =$(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
            		}else{
            			fnx =$(window.componentDiv)[0].document.zwIframe;
            		}
            		//保存公文正文
            		saveGovdocContent();
            		//保存文单签批
            		if(!componentDiv.zwIframe.saveHwData()){
            			return;
            		}
            		//保存全文签批
            		addPDF();
            		fnx.$.content.getContentDomains(function(domains) {
                        if($.content.getContentDealDomains(domains)) {
                        	//var trackWorkflowType =  getA8Top().document.getElementById("trackWorkflow").value;
                        	//alert(trackWorkflowType);
                        	//return;
                        	dialog.close();
                        	var jsonSubmitCallBack = function(){
        			        	 $("#layout").jsonSubmit({
        		                        action : _ctxPath + '/collaboration/collaboration.do?method=stepBack&affairId='+affairId+'&summaryId='+summaryId+'&trackWorkflowType='+trackWorkflowType+"&isStepBack=1",
        		                        domains : domains,
        		                        validate:false,
        		                        callback:function(data){
        		                          closeCollDealPage();
        		                        }
        		                 });
        			        };
        			        //V50_SP2_NC业务集成插件_001_表单开发高级
        			        formDevelopAdance4ThirdParty(bodyType,affairId,"stepBack", $("#content_deal_comment").val(),null,jsonSubmitCallBack);
                     }
                   },'stepBack');
                }
    	     }, {
    	         text: $.i18n('collaboration.pushMessageToMembers.cancel'), //取消
    	         handler: function () {
    	    	 		enableOperation();
    	    	 		setButtonCanUseReady();
    	    	 		dialog.close();
    	         }
    	     }]
    	 });
    
    
    
}

//弹出 更多操作
function showMessageBox2() {
    var dialog = new MxtDialog({
        width: 100,
        height: 190,
        type: 'panel',
        htmlId: 'img_more',
        targetId: 'img_more_btn',
        targetWindow:getCtpTop(),
        shadow: false,
        panelParam: {
            'show': false,
            'margins': false
        }
    });

    $('#img_more').mouseleave(function () {
        dialog.close();
    });
}


function refreshWorkflow(callBackObj){
  //隐藏附件区域
  $("#content_workFlow").css("top", 88);
  //$(".attachment_block").hide();
  // 加签的情况
  if(callBackObj && (callBackObj.type == 1 
      || callBackObj.type == 2 
      || callBackObj.type == 3 
      || callBackObj.type == 4)){
    summaryChange();
  }
  showWorkFlowView();
  var isTemplate = isFromTemplate;
 
  var wfurl = _ctxPath+"/workflow/designer.do?method=showDiagram&isModalDialog=false&isHistoryFlag="+isHistoryFlag+"&isDebugger=false&isTemplate="+isTemplate+"&scene="+_scene+"&processId="+_contextProcessId+"&caseId="+_contextCaseId+"&currentNodeId="+_contextActivityId+"&appName=collaboration&formMutilOprationIds="+operationId;
  if(openFrom=='supervise' && summaryReadOnly !=='true'){
      wfurl+="&showHastenButton=true";
  }else{
     //加载流程页面 待办、已办、已发、
     if(affairState == '1'){//协同-待发
    	 if(_startMemberId == _currentUserId){
    		 //加个判断条件，否则别的人统计草稿状态的表单，流程图的发起人有问题，工作流在待发的时候根据这个参数来显示flash中的发起人。
    		 wfurl += "&currentUserName="+_currentUserName+"&currentUserId="+_currentUserId;
    	 }
     }else{
         if((affairState == '2'||(affairState == '4' && isCurrentUserSupervisor=='true')) 
             && isFinshed!="true" && openFrom!='glwd'&& openFrom!='subFlow' && openFrom!='edocStatics' && openFrom!='lenPotent' && summaryReadOnly!=='true'){
             wfurl+="&showHastenButton=true";
         }
     }
  }
  $("#iframeright").attr("src",encodeURI(wfurl));
}

function superviseSettingFunc(){
    var col = new colManager(); 
    var retVal = col.checkTemplateCanModifyProcess(templateId);
    var mflag = false;
    /*if("no" == retVal.canModify){
        mflag = true;
    }*/
    if("no" == retVal.canSetSupervise){
      mflag = true;     
    }
    if( isFinish == true || mflag){
        $.alert($.i18n('collaboration.cannotSupervise_flow_end_or_template2'));
        return false;
    }
    if((affairApp && affairApp == 4)&&(summaryGovdocType == 1 || summaryGovdocType== 2 || summaryGovdocType == 3 || summaryGovdocType == 4)){
    	openSuperviseWindow(3,true,summaryId,templeteId,null,_startMemberId);
    }else{
    	openSuperviseWindow(1,true,summaryId,templeteId,null,_startMemberId);
    }
}

//刷新流程图 （用于修改流程时回调）
var isWorkflowChange = false;
function summaryChange(){
  isWorkflowChange = true;
  if(!(window.parentDialogObj && window.parentDialogObj['dialogDealColl'])){
    $.confirmClose();
  }
}
//流程图展现
function showWorkFlowView(){
    $("#content_view_li").removeClass("current");
    $("#query_view_li").removeClass("current");
    $("#signContent_view_li").removeClass("current");
    $("#govdoc_content_view_li").removeClass("current");
    $("#statics_view_li").removeClass("current");
    $("#workflow_view_li").addClass("current");
    $("#queryDiv").hide();
    $("#showGovdocHtmlContent").hide();
//    if(pdfIframe.document.getElementById("HWPostil1")!=null){
//  	  pdfIframe.document.getElementById("HWPostil1").style.display="none";
//    }
    $("#pdfIframe").height(0);
    $("#govdocPdfiframe").hide();
    $("#iframeright").show();
    //alert($("#componentDiv").css("top"));
    $("#componentDiv").css("position","absolute").css("top","-10000px");
    //1.如果是 督办未结办时 显示修改流程按钮
    //2.如果是已办列表中当前用户是督办人，并且流程未结束 显示修改流程按钮
    if((isSupervise||isCurSuperivse) && !isFinish && affairState!="1"){
    	if(isHistoryFlag != 'true'){
    		$("#show_edit_workFlow").show().css("margin-left","40px");
    	}
        var attachment = $("#attachmentAreashowAttFile .attachment_block").length;
        var realDoc = $("#attachment2AreaDoc1 .attachment_block").length;
        if(attachment == 0 && realDoc == 0){
          $('.stadic_body_top_bottom').css('top','138px');
        }else if(attachment != 0 || realDoc != 0){
          $('.stadic_body_top_bottom').css('top',$(".stadic_head_height").height()+5);
        }
    }
    
    if(_isOfficeContent(bodyType)){
    	$("#show_edit_workFlow").css("margin-top","-10px");
    }
    $("#iframeright").css("display","block");
}

function _isOfficeContent(bodyType){
	if(bodyType == '41' || bodyType =="42" || bodyType=='43' || bodyType =='44' || bodyType =='45'){
		return true;
	}
	return false;
}
//公文pdf正文
function showGovdocPdfConent(){
	GovdocPdfFullSize();
}
//判断是否存在修改正文或正文盖章权限 
function checkChangeContentOrSign(editFlag){
	 //判断条件是具有修改正文权限同时是发发文的文单并且还要是待办状态
	 if(($("#_commonEdit_span").length > 0 || $("#_dealEdit").length>0) && summaryGovdocType =="1" && affairState=="3"){
		 editGovdocContentFunc(editFlag);
	 }
	 //判断条件是具有正文盖章权限同时是发发文的文单并且还要是待办状态
	 if(($("#_commonContentSign_span").length > 0 || $("#_dealContentSign").length>0) && summaryGovdocType =="1" && affairState=="3"){
		 //openGovdocSignature(editFlag);
		 //之前自己调用了openGovdocSignature 在此方法中会打开office窗口，和showGovdocContent方法下的dealPopupContentWin冲突，导致控件会刷新两次，所以在此之间把控件的签章状态设为可用即可
		 updateSignatureState();
	 }
}
//公文正文
function showGovdocContent(summaryId){
	$(".attachment_block").show();
	var bodyType = document.getElementById("govdocBodyType").value;
	if("html" == bodyType || "HTML" == bodyType){//如果公文类型是html,就直接切换视图
		showHtmlContent();
	}else{
		//添加判断是否具有修改正文或正文盖章权限，有的话则直接调用功能 zhangdong 20170407 start
		if("Ofd"!=bodyType){
			checkChangeContentOrSign(false);
		}
		//updateOfficeState("4,0"); 和显示痕迹冲突 暂时去掉
		//添加判断是否具有修改正文或正文盖章权限，有的话则直接调用功能 zhangdong 20170407 end
		dealPopupContentWin(false,false);
		
	}
}

function showHtmlContent(){
	$("#workflow_view_li").removeClass("current");
	$("#content_view_li").removeClass("current");
	$("#signContent_view_li").removeClass("current");
	$("#govdoc_content_view_li").addClass("current");
	$("#iframeright").hide();
	$("#componentDiv").hide();
//	if(pdfIframe.document.getElementById("HWPostil1")!=null){
//		  pdfIframe.document.getElementById("HWPostil1").style.display="none";
//	  }
	$("#pdfIframe").height(0);
	$("#show_edit_workFlow").hide();
	var attachment = $("#attachmentAreashowAttFile .attachment_block").length;
	var realDoc = $("#attachment2AreaDoc1 .attachment_block").length;
	if(attachment == 0 && realDoc == 0){
	   $('.stadic_body_top_bottom').css('top','90px');
	}else if(attachment != 0 || realDoc != 0){
	   $('.stadic_body_top_bottom').css('top',$(".stadic_head_height").height()+10);
	}
	$("#showGovdocHtmlContent").show();
	//$("#componentDiv").css("position","static").css("top","auto");
}

//正文展现
function showContentView(){
  $("#workflow_view_li").removeClass("current");
  $("#query_view_li").removeClass("current");
  $("#govdoc_content_view_li").removeClass("current");
  $("#signContent_view_li").removeClass("current");
  $("#statics_view_li").removeClass("current");
  $("#content_view_li").addClass("current");
  $("#showGovdocHtmlContent").hide();
  $("#iframeright").hide();
  $("#queryDiv").hide();
//  if(pdfIframe.document.getElementById("HWPostil1")!=null){
//	 pdfIframe.document.getElementById("HWPostil1").style.display="none";
//  }
  $("#pdfIframe").height(0);
  $("#componentDiv").show();
  $("#display_content_view").show();
  $("#componentDiv").css("position","static").css("top","auto");
  //将'修改流程'按钮隐藏,并且把样式上移
  $("#show_edit_workFlow").hide();
  $(".attachment_block").show();
  var attachment = $("#attachmentAreashowAttFile .attachment_block").length;
  var realDoc = $("#attachment2AreaDoc1 .attachment_block").length;
  if(attachment == 0 && realDoc == 0){
    $('.stadic_body_top_bottom').css('top','90px');
  }else if(attachment != 0 || realDoc != 0){
      $('.stadic_body_top_bottom').css('top',$(".stadic_head_height").height()+10);
  }
}
function showSignContentView(isHandWrite,identification){
	  $("#workflow_view_li").removeClass("current");
	  $("#query_view_li").removeClass("current");
	  $("#govdoc_content_view_li").removeClass("current");
	  $("#statics_view_li").removeClass("current");
	  $("#content_view_li").removeClass("current");
	  $("#signContent_view_li").addClass("current");
	  $("#showGovdocHtmlContent").hide();
	  $("#iframeright").hide();
	  $("#queryDiv").hide();
	  $("#componentDiv").hide();
	  $("#formRelativeDiv").hide();
	  $("#pdfIframe").height("100%");
//	  if(pdfIframe.document.getElementById("HWPostil1")!=null){
//		 pdfIframe.document.getElementById("HWPostil1").style.display="";
//	  }
	  $("#display_content_view").show();
	  $("#componentDiv").css("position","static").css("top","auto");
	  //将'修改流程'按钮隐藏,并且把样式上移
	  $("#show_edit_workFlow").hide();
      $('.attachment_block').show();
	  var attachment = $("#attachmentAreashowAttFile .attachment_block").length;
	  var realDoc = $("#attachment2AreaDoc1 .attachment_block").length;
	  if(attachment == 0 && realDoc == 0){
	    $('.stadic_body_top_bottom').css('top','90px');
	  }else if(attachment != 0 || realDoc != 0){
	      $('.stadic_body_top_bottom').css('top',$(".stadic_head_height").height()+10);
	  }
	  if(PDFId!=''){
		  	var srcs = "/seeyon/govDoc/govDocController.do?method=govdocSignContent&fileType="+_fileType;
		  	if(typeof(isHandWrite)!='undefined'&&null!=isHandWrite){
				srcs+="&isHandWrite="+isHandWrite;
			}
		  	if(typeof(identification)!='undefined'&&null!=identification){
				srcs+="&fromButton="+identification;
			}
			if($("#pdfIframe").attr('src')==''){
				$("#pdfIframe").attr('src',srcs);
			}else{
				if(typeof(isHandWrite)!='undefined'&&null!=isHandWrite){
					pdfIframe.handWrite();
				}
				if(typeof(identification)!='undefined'&&null!=identification){
					pdfIframe.signChange();
				}
			}
			
		}
}
function _dealButtonCss4RelativeView(type){
	if(type == 'query'){
    	$("#query_view_li").addClass("current");
    	$("#statics_view_li").removeClass("current");
    }else if(type == 'report'){
    	$("#statics_view_li").addClass("current");
    	$("#query_view_li").removeClass("current");
    }
}
//相关查询展现
function showFormRelativeView(type,formRelativeids,formId){
    $("#workflow_view_li").removeClass("current");
    $("#content_view_li").removeClass("current");
    $("#signContent_view_li").removeClass("current");
    _dealButtonCss4RelativeView(type);
//    if(pdfIframe.document.getElementById("HWPostil1")!=null){
//  	  pdfIframe.document.getElementById("HWPostil1").style.display="none";
//    }
    $("#pdfIframe").height(0);
    $("#iframeright").hide();
    //$("#componentDiv").hide();
    $("#componentDiv").css("position","absolute").css("top","-10000px");
    $("#display_content_view").hide();
    var fnx_zwIframe;
	if($.browser.mozilla){
	 	fnx_zwIframe =$(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
	 }else{
	 	fnx_zwIframe =$(window.componentDiv)[0].document.zwIframe;
	 }
	fnx_zwIframe.preSubmitData(function(){}, function(){}, false,false);
    //将'修改流程'按钮隐藏,并且把样式上移
    $("#show_edit_workFlow").hide();
    $('.attachment_block').show();
    var attachment = $("#attachmentAreashowAttFile .attachment_block").length;
    var realDoc = $("#attachment2AreaDoc1 .attachment_block").length;
    if(attachment == 0 && realDoc == 0){
      $('.stadic_body_top_bottom').css('top','90px');
    }else if(attachment != 0 || realDoc != 0){
        $('.stadic_body_top_bottom').css('top',$(".stadic_head_height").height()+10);
    }
    src=_ctxPath+"/form/queryResult.do?method=queryStatistics&type="+type+"&formId="+formId+"&formRelativeIds="+formRelativeids+"&formMasterId="+componentDiv.zwIframe.$("#contentDataId").val();
   
    $("#formRelativeDiv").attr("src",src).show();
}
function superviseFunc(){
	if((affairApp && affairApp == 4)&&(summaryGovdocType == 1 || summaryGovdocType== 2||summaryGovdocType== 3 || summaryGovdocType == 4)){
		showSuperviseWindow(summaryId,3,isFinish,templateId);
    }else{
    	showSuperviseWindow(summaryId,1,isFinish,templateId);
    }
}
/*
 * 表单开发高级 : V50_SP2_NC业务集成插件_001_表单开发高级
 * @param bodyType ：正文类型
 * @param affairId :affairId
 * @param attitude :态度
 * @param opinionContent ：意见内容
 * @param currentDialogWindowObj ：当前Dialog对象
*/
function formDevelopAdance4ThirdParty(bodyType,affairId,attitude,opinionContent,currentDialogWindowObj,succesCallBack) {
  try{
	  function failedCallBack(){
	      mainbody_callBack_failed();
	  }
	  if(bodyType != '20' ){
		  succesCallBack();
	  }else {
		  beforeSubmit(affairId, $.trim(attitude), $.trim(opinionContent),currentDialogWindowObj,succesCallBack,failedCallBack);
	  }
   }catch(e){
	   alert("表单开发高级异常!");
   } 
}
function addOneSub(n){
    return parseInt(n)+1;
}
/**
 * @param $delMesPush 意见栏a的人员
 * @param $oldMesPush 原来的消息推送功能放的文本域
 * @param $textArea   意见框
 * @return
 */
function mergeMesPushFun($delMesPush,$oldMesPush,$textArea){
	//alert($delMesPush.val()+"**"+$oldMesPush.val()+"**"+$textArea.val());
	//$delMesPush 转换成数组
	var d1 = $delMesPush.val();
	if(d1 && d1 != '') {
		d1 = $.parseJSON(d1);
	}
	
	var d2 = $oldMesPush.val();
	if(d2 && d2 != ''){
		d2 = $.parseJSON(d2);
	}
	
	var val = $textArea.val();
	 
	var all =[];
	if(d2.length > 0){
		all = d2;
	}
	
	if(d1.length > 0){
		for(var i =0; i < d1.length; i++){
			var v=[];
			if($textArea.val().indexOf(d1[i][2]) > -1){
				v.push(d1[i][0]);
				v.push(d1[i][1]);
				all.push(v);
			}
		}
	}
	$oldMesPush.val($.toJSON(all));
}

//提交回调函数
var subCount = 0;
function submitFunc(){
	disableOperation();
	if($("#praiseToObj").hasClass("like_16")){ 
		$("#praiseInput").val(1);
	}else{
		$("#praiseInput").val(0);
	}
    subCount = addOneSub(subCount);
    if(parseInt(subCount)>=2){
        //不能重复提交，用最原生的alert，$.ALERT不能阻塞，太慢了才弹出
        alert($.i18n("collaboration.summary.notDuplicateSub"));
        subCount = 0;
        enableOperation();
        return;
    }
	try{showMask();}catch(e){}
	
    var fnx;
    if($.browser.mozilla){
		fnx = $(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
	}else{
		fnx = $(window.componentDiv)[0].document.zwIframe;
	}
    var domains =[];
    if(typeof(fnx.content_isComplete) =='undefined' || typeof(fnx.preSubmitData) =='undefined' || !fnx.content_isComplete() ){
    		$.alert($.i18n('collaboration.summary.notComplete'));
    		mainbody_callBack_failed();
            return false;
    }
    if(!isAffairValid(affairId)) {
    	try{hideMask();}catch(e){}
    	subCount = 0;
    	enableOperation();
    	return;  
    }
    
    var sbcallback = function(domains) {
      //保存ISignaturehtml专业签章
      if(!saveISignature(1)){
        enableOperation();
        setButtonCanUseReady();
        subCount = 0;
        try{hideMask();}catch(e){}
        return;
      }
      
      //OFFICE正文中直接点修改按钮，不是“正文修改”菜单进去的，这种情况下会这种contentUpdate变量为true;
      if(fnx.contentUpdate) fnx.$("#viewState").val("1");
      
      if(fnx.$("#viewState").val()=="1" || bodyType=='20'){ 
          var domains =[];
          fnx.saveOrUpdate({
              success:bulnewsAudit,
              failed:mainbody_callBack_failed,
              checkNull:true,
              needSubmit:true,
              "mainbodyDomains":domains
            });
         }else{
      	   bulnewsAudit();
         }
       };
       //公告新闻审核提交
       var bulnewsAudit=function(){
      	 if (nodePolicy == "bulletionaudit" ) {
             bulletinIssue(summaryId,affairId,bodyType,sub,rightId,mainbody_callBack_failed);
             return ;
         }else if (nodePolicy == "newsaudit" ){
      		 newsIssue(summaryId,affairId,bodyType,sub,rightId,mainbody_callBack_failed);
             return ;
      	 }else{
      		 if($("#isDistribureOperate").val() != "1"){
      			 sub();
      		 }
      	 }
       }
       
      var sub = function(subBack){
    	 var _returnValue =$.content.getContentDealDomains(domains);
    	 if(_returnValue == false){
    		 subCount = 0;
    		 try{hideMask();}catch(e){}
    	 }
        if(_returnValue) {
        	
        	//提交前重置公文文号参数
          	resetMarkParamBeforeSubmit();
          	
//          var path = _ctxPath + '/collaboration/collaboration.do?method=finishWorkItem&affairId='+affairId+"&app=" + $("#app").val();
        	//客开 作者:mly 项目名称: 自流程 修改功能:保存续办人员节点的activityid到affair中 start
            var path = _ctxPath + '/collaboration/collaboration.do?method=finishWorkItem&affairId='+affairId+"&app=" + $("#app").val()+"&customDealWithActivitys="+$("#customDealWithActivitys").val();
          //客开 作者:mly 项目名称: 自流程 修改功能:保存续办人员节点的activityid到affair中 end
        	// 归档信息
          var pigeonholeValue = $("#pigeonholeValue").val();
          if(pigeonholeValue && pigeonholeValue != "cancel"){
            var pigeonhole = pigeonholeValue.split(",");
            path += '&pigeonholeValue=' + pigeonhole[0];
            var cm = new colManager();
            var aids= [];
            aids.push(affairId);
            var jsonObj = cm.getIsSamePigeonhole(aids,pigeonhole[0]);
            if(jsonObj){
            	alert(jsonObj);
            	enableOperation();
            	subCount = 0;
            	try{hideMask();}catch(e){}
            	return;
            }
          }
        //cx 
          //path += '&fenfa_input_value=' +document.getElementById("fenfa_input_value").value;
          path +='&isNotEdit='+document.getElementById("isNotEdit").value;
          path +='&duanxintixing='+document.getElementById("duanxintixing").value;
          //LL
          var govdocContent=document.getElementById("newPdfIdFirst").value;
          var isConvertPdf = false;
          if("isConvertPdf" == document.getElementById("isConvertPdf").value){
        	  isConvertPdf = true;
          }
          path +='&govdocContent='+govdocContent+'&isConvertPdf='+isConvertPdf;
          var reSign = document.getElementById("reSign");
          if(reSign&&reSign.value=="1"){
        	  path += '&reSign=1';
          }
          //
          
          //cx  提交全文签批
          addPDF();
          domains.push('colSummaryData');
          domains.push('trackDiv_detail');
          domains.push('superviseDiv');
          domains.push('workflow_definition');
          domains.push('attFileDomain');
          domains.push('assDocDomain');
          domains.push('attActionLogDomain');
          domains.push(fnx.getMainBodyDataDiv());
          var jsonSubmitCallBack = function(){
        	  mergeMesPushFun($("#dealMsgPush"),$('#comment_deal #pushMessageToMembers'),$("#content_deal_comment"));
        	  $("#layout").jsonSubmit({
              action : path,
              domains : domains,
          	  isMask : false,
              callback:function(data){
        		  try{hideMask();}catch(e){}
        		  subCount = 0;
        		  if (subBack) {
        		      subBack();
        		  }
                  closeCollDealPage();
              }
            });
          }

          var attitudeArray=document.getElementsByName("attitude");
          for(var i=0; i<attitudeArray.length;i++){
              if(attitudeArray[i].checked){
                 attitudeArray = attitudeArray[i].value;
                 break;
              } 
          }
          //V50_SP2_NC业务集成插件_001_表单开发高级
          formDevelopAdance4ThirdParty(bodyType,affairId,attitudeArray, $("#content_deal_comment").val(),null,jsonSubmitCallBack);
        
        }
      }
      var wffinish = function(contentObj) {
        var domains =[];
        $.content.getWorkflowDomains($("#moduleType").val(), domains);
        $.content.callback.workflowFinish = function() {
          sbcallback(domains);
        };
        fnx.preSubmitData(function(){
        	if(!executeWorkflowBeforeEvent("BeforeFinishWorkitem",summaryId,affairId,_contextProcessId,_contextProcessId,_contextActivityId,formRecordid,_moduleTypeName)){
                return;
            }
            preSendOrHandleWorkflow(window, _contextItemId,_contextProcessId, _contextProcessId,
                _contextActivityId,_currentUserId,_contextCaseId,_loginAccountId,
                formRecordid, _moduleTypeName, $("#process_xml").val(), false,$("#subApp").val());
        },mainbody_callBack_failed,true);
      };
      if ((componentDiv.zwIframe.opinionType == '3' || componentDiv.zwIframe.opinionType == '4')&&isFlowBack!="") {
          // OA-21323 后台设置意见保留方式又被退回人选择。被退回人在提交时选择"保留最后一次意见"，但是处理后，他所有的意见都保留了
          // 加了affairId参数
    	  var urls =  "/seeyon/govDoc/govDocController.do?method=opinionSetup"
          + "&opinionType=" + componentDiv.zwIframe.opinionType + "&summaryId=" + summaryId
          + "&policy=" + encodeURIComponent(nodePolicy) + "&affairId="
          + affairId + "&ndate=" + new Date();
    	  var dialog = $.dialog({
    		  	url:urls,
    		    title: '意见保留设置',
    		  width:300,
    		  height:300,
    		    overflow:'hidden',
    		    targetWindow:getCtpTop(),
  			    transParams:window,
  			    closeParam:{
  		          'show':true,
  		          autoClose:false,
  		          handler:function(){
  		        	subCount--;
    			  	enableOperation();
    			  	setButtonCanUseReady();
    		        dialog.close();
  		          }
  			    },
    		    buttons: [{
    		        text: "确认",
    		        handler: function () {
    			  		var rv = dialog.getReturnValue();
    			  		document.getElementById("chooseOpinionType").value=rv;
    			 		wffinish();
    		       		dialog.close();
    		    	}
    		    }, {
    		        text: "关闭",
    		        handler: function () {
	    			  	subCount--;
	    			  	enableOperation();
	    			  	setButtonCanUseReady();
	    		        dialog.close();
    		    	}
    		    }]
    	  });
      }else{
    	  wffinish();
      }
    
}
//正文保存失败
function mainbody_callBack_failed(){
  enableOperation();
  setButtonCanUseReady();
  subCount = 0;
  try{hideMask();}catch(e){}
  return;
}
function doZCDB(){
  try{showMask();}catch(e){}
  var fnx;
  if($.browser.mozilla){
		fnx = $(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
	}else{
		fnx = $(window.componentDiv)[0].document.zwIframe;
	}
  if(typeof(fnx.content_isComplete) !='undefined' && typeof(fnx.content_isComplete) =='function'){
  	if(!fnx.content_isComplete()){
  		$.alert($.i18n('collaboration.summary.notComplete'));
  		mainbody_callBack_failed();
          return false;
  	}
  }
  var domains =[];
  if(!isAffairValid(affairId)) {
    try{hideMask();}catch(e){}
    return;  
  }
  //保存全文签批单
  addPDF();
  var sbcallback = function(domains) {
    //保存ISignaturehtml专业签章
    if(!saveISignature(1)){
      enableOperation();
      setButtonCanUseReady();
      try{hideMask();}catch(e){}
      return;
    }
    
    //OFFICE正文中直接点修改按钮，不是“正文修改”菜单进去的，这种情况下会这种contentUpdate变量为true;
    if(fnx.contentUpdate) fnx.$("#viewState").val("1");
    
    if(fnx.$("#viewState").val()=="1" || bodyType=='20'){ 
      var domains =[];
      fnx.saveOrUpdate({
          success:sub,
          failed:mainbody_callBack_failed,
          needSubmit:true,
          "mainbodyDomains":domains,
          checkNull:false,
          needCheckRule:false,
          isDoZcdb:true
        });
     }else{
        sub();
     }
  }

  var sub = function(){
	  //保存公文正文
	  saveGovdocContent();
        if($.content.getContentDealDomains(domains)) {
          domains.push('colSummaryData');
          domains.push('trackDiv_detail');
          domains.push('superviseDiv');
          domains.push('workflow_definition');
          domains.push('attFileDomain');
          domains.push('assDocDomain');
          domains.push('attActionLogDomain');
          
          domains.push(fnx.getMainBodyDataDiv());
          var govdocContent=document.getElementById("newPdfIdFirst").value;
          var isConvertPdf = false;
          if("isConvertPdf" == document.getElementById("isConvertPdf").value){
        	  isConvertPdf = true;
          }
          
          //提交前重置公文文号参数
          resetMarkParamBeforeSubmit();
        	
//          var path = _ctxPath+ '/collaboration/collaboration.do?method=doZCDB&affairId='+affairId+'&processId='+_summaryProcessId+'&govdocContent='+govdocContent+'&isConvertPdf='+isConvertPdf;
        //客开 作者:mly 项目名称:自流程 修改功能:暂存代办保存用户选择的代办信息 start
          var path = _ctxPath+ '/collaboration/collaboration.do?method=doZCDB&affairId='+affairId+'&processId='+_summaryProcessId+'&govdocContent='+govdocContent+'&isConvertPdf='+isConvertPdf + "&customDealWith="+($("#customDealWith").attr("checked") =='checked')+"&permissionRange="+$("#permissionRange option:selected").val() +"&memberRange="+$("#memberRange option:selected").val();
          //客开 作者:mly 项目名称:自流程 修改功能:暂存代办保存用户选择的代办信息 end
          $("#layout").jsonSubmit({
              action : path,
              domains : domains,
          	  isMask : false,
              callback:function(data){
        	  	  try{hideMask();}catch(e){}
        	  		closeCollDealPage();
              }
          });
        };
  }
    
  var wffinish = function(contentObj,domains) {
    var domains =[];
    $.content.getWorkflowDomains($("#moduleType").val(), domains);
    sbcallback(domains);
  };
 
  wffinish();
}
function closeCollDealPage(){
	if(extFrom == "ucpc"){
		window.close();
		return;
	}
	try{showContentView();}catch(ee){}//当前页签是权威签批单时 会导致保存不了
	try{
        //清空签章锁
        var zwIframe = $(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
        zwIframe.releaseISignatureHtmlObj();
        zwIframe.unLoadHtmlHandWrite();
    }catch(e){};

    try{
    	//办公桌面
    	try{
	    	if(typeof(window.top)!='undefined'
	    		&& typeof(window.top.opener)!='undefined'
	    		&& typeof(window.top.opener.getCtpTop)!='undefined'
	    		&& typeof(window.top.opener.getCtpTop().refreshDeskTopPendingList) !='undefined'){
	    			window.top.opener.getCtpTop().refreshDeskTopPendingList();
	    	}
    	}catch(e){
    		
    	}

        //判断当前页面是否是主窗口页面
        if (getCtpTop().isCtpTop  && isTimeLine !="1") {
            window.parent.$('.slideDownBtn').trigger('click');
            window.parent.$('#listPending').ajaxgridLoad();
            window.parent.$('#listStatistic').ajaxgridLoad();
            setTimeout(function(){
                window.parent.$('#summary').attr('src',_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listPending&size="+parent.grid.p.total);
            },300);
        } else {
        	 var _win;
        	if(undefined != window.top.opener.$("#main")[0].contentWindow.detailIframe){
        		_win = window.top.opener.$("#main")[0].contentWindow.detailIframe;
        	}else{
        		_win = window.top.opener.$("#main")[0].contentWindow;
        	}
            if (_win != undefined) {
                //判断当前是否是首页栏目
                if (_win.sectionHandler != undefined) {
                    //首页栏目（当点击了统计图条件后处理）
                    if (_win.params != undefined && _win.params.selectChartId != "") {
                        _win._collCloseAndFresh(_win.params.iframeSectionId,_win.params.selectChartId,_win.params.dataNameTemp);
                    } else {
                        //进入首页待办栏目直接处理
                        _win.sectionHandler.reload("pendingSection",true);
                        //表单栏目配置到首页，首页栏目直接处理表单待办协同后该待办没有自动刷新消失
                        _win.sectionHandler.reload("singleBoardFormBizConfigSection",true);
                    }
                } else {
                    //刷新列表
                    if (_win.loadPendingGrid != undefined) {
                        _win.loadPendingGrid();
                    } else if(_win.closeAndFresh != undefined) {
                        _win.closeAndFresh();
                    }else{
                    	//项目栏目协同刷新
                     	try{
                     		getCtpTop().opener.getA8Top().$("#main")[0].contentWindow.$("#body")[0].contentWindow.sectionHandler.reload("projectCollaboration",true);
                    	 }catch(e){}
                        var url = _win.location.href;
                        if (url.indexOf("collaboration") != -1 && (url.indexOf("listPending") != -1 || url.indexOf("morePending") != -1)) {
                            _win.location =  _win.location;
                        } else {
                            try{
                              //业务生成器、生成的列表嵌入到了iframe下。也刷新待办列表
                                var _win2 = _win.$.find('iframe');
                                if (_win2 != undefined && _win2[0] != undefined) {
                                    var url = _win2[0].src;
                                    if (url.indexOf("collaboration") != -1 && url.indexOf("listPending") != -1) {
                                        _win.location =  _win.location;
                                    }
                                }
                            }catch(e){}
                        }
                    }
                }
            }
            removeCtpWindow(affairId,2);
        }
      //刷新我的提醒栏目
        var _win = window.top.opener.$("#main")[0].contentWindow;
        if (_win != undefined) {
        	try{_win.sectionHandler.reload("collaborationRemindSection",true);}catch(e){}
        }
    }catch(e){
        try {
        	if(window.parentDialogObj["dialogDealColl"].transParams.callbackOfEvent){
        		window.parentDialogObj["dialogDealColl"].transParams.callbackOfEvent();
        	}
        	window.parentDialogObj["dialogDealColl"].close();//时间线
            return;
        } catch(e) {}
    }
    if(getA8Top().openReplateMoreWin){
      getA8Top().openReplateMoreWin.close();
      getA8Top().openReplateMoreWin = null;
    }else{
    	try{
      		//OA-71476【项目协同】更多页面，点击查看查询后的数据，弹出异常提示。--老bug
     	 	window.top.opener.$("#main")[0].parentWindow.relodProjectWin();
      	}catch(e){}
      	var theUrl = $("#fbNewUrl").val();
      	if(theUrl!=undefined && theUrl != ""){
      		if(opener.open==null){
      			distributePage = window.open(theUrl);
      		}else{
      			distributePage = opener.open(theUrl);
      		}
      		$("#fbNewUrl").val("");
      	}
      	window.close();
    }
    
    
}

//查看附件列表
function showOrCloseAttachmentList(){
  //获取正文下的附件
    var attmentList = null;
    var attmentContent =$("#componentDiv").contents().find("#zwIframe").contents().find("#mainbodyDiv a[attachmentid]");
    if (attmentContent.length > 0) {
        attmentList = new Array();
        for (var i=0;i<attmentContent.length;i++) {
            attmentList[i] = $("#componentDiv").contents().find("#zwIframe").contents().find("#mainbodyDiv a[attachmentid]").eq(i).attr('attachmentid');
        }
    }
    
    var fnx;
    if($.browser.mozilla){
		fnx = $(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
	}else{
		fnx = $(window.componentDiv)[0].document.zwIframe;
	}
    var attrs = fnx.getContentAttrs();
    var formAttrId = "";
    if($.trim(attrs) != ""){
        for(var i=0;i<attrs.length;i++){
            var id = attrs[i].fileUrl;
            if(attrs.length == 1){
                formAttrId = id;
            }else if(i < attrs.length -1){
                formAttrId += id + ",";
            }else{
                formAttrId += id;
            }
        }
    }
    var attachmentListObj = document.getElementById("attachmentList");
    if(attachmentListObj.style.display == "none"){
        attachmentListObj.style.display = "block";
        hideOfficeObj();
        var url = _ctxPath+"/collaboration/collaboration.do?method=findAttachmentListBuSummaryId&summaryId="+summaryId+"&memberId="+_affairMemberId+"&canFavorite="+_canFavorite+"&formAttrId=" + formAttrId+"&attmentList="+attmentList+"&openFromList="+openFrom+"&isHistoryFlag="+isHistoryFlag;
        $("#attachmentList").attr("src",url);
    }else{
        attachmentListObj.style.display = "none";
        showOfficeObj();
    }
}



//将标题部分高度改为动态值
function summaryHeadHeight(){
   $("#content_workFlow").css("top",$("#summaryHead").height()+10);
}
function formAuthorityFunc(){
  var moduleIds=new Array();
  var affairIds=new Array();
  moduleIds.push(summaryId);
  affairIds.push($('#affairId').val());
  setRelationAuth(moduleIds,1,function(flag){
  var colM = new colManager();   
  var param = new Object();
  param.affairIds = affairIds;
  param.flag = flag;
  colM.updateAffairIdentifierForRelationAuth(param, {
      success: function(){ }
   });
 });
}

function getParentWindow(win){
  if(win.dialogArguments){
    return win.dialogArguments;
  }else{
    return win.opener || win;
  }
}

function timelyExchangeFun(){
    var colM = new colManager();
    colM.getColAllMemberId(summaryId, {success:
        function(members){
            try{
              var currentWin = getA8Top();
              for(var i = 0; i < 5; i++){
                if(typeof currentWin.isCtpTop != 'undefined' && currentWin.isCtpTop){
                  break;
                }else{
                  currentWin = getParentWindow(currentWin).getA8Top();
                }
              }
              var errorMessage = currentWin.checkCreateCollBoration(members);
              if(errorMessage != ""){
            	  $.alert(errorMessage);
            	  return;
              }
              currentWin.createCollaborationTeam(members,summaryId,escapeStringToJavascript(subject));
            }catch(e){
               $.alert($.i18n('collaboration.alert.uc.error'));
            }
        } 
    });
}
function colseProce(){
  if (proce==""){
      setTimeout(colseProce,300);
  }else{
      proce.close();
      if(formDefaultShow == '1' && $("#signContent_view_li").length == 1 && $("#signContent_view_li").css("display") != "none"&&affairState != "2"){
  		setTimeout(function(){
  			showSignContentView();
      	}, 2000);
  		}
  }
}

function setIframeHeight_IE7(){
    setTimeout(function(){
            $("#content_workFlow").height($("#center").height()-$("#summaryHead").height()-10);
            $("#iframeright").height($("#content_workFlow").height());
            $("#componentDiv").height($("#content_workFlow").height());
    },0);
}

$(function(){
  if (openFrom != 'glwd' && openFrom != 'docLib'){
    openType = getCtpTop();
  } else {
    openType = window;
  }
 
  //正文加载
  proce = $.progressBar();
  
  //从首页portal打开时，在弹出框中添加'标题'显示
  if(window.parentDialogObj && window.parentDialogObj[dialogId]){
     window.parentDialogObj[dialogId].setTitle(escapeStringToJavascript(subject));
   }
  if( trackType =='1' ){
    $( "#isTrack[name=isTrack]").attr( 'checked' ,'checked' );
    $( "#label_all[for=trackRange_all]").removeClass( "disabled_color" );
    $("#label_members[for=trackRange_members]" ).removeClass( "disabled_color");
    $("#trackRange_all" ).removeAttr( 'disabled').attr( "checked" ,"checked" );
    $( "#trackRange_members").removeAttr( 'disabled' );
} else if (trackType == '2'){
    $( "#isTrack[name=isTrack]").attr( 'checked' ,'checked' );
   
    $( "#label_all[for=trackRange_all]").removeClass( "disabled_color" );
    $("#label_members[for=trackRange_members]" ).removeClass( "disabled_color");
    $( "#trackRange_all").removeAttr( 'disabled' );
    $("#trackRange_members" ).removeAttr( 'disabled').attr( "checked" ,"checked" );
    var trackRangeMembersTextbox=$("#trackRange_members_textbox").val();
    if(trackRangeMembersTextbox){
    	$("#trackRange_members_textbox").show().val(trackRangeMembersTextbox).attr("title", trackRangeMembersTextbox);
    }
}

  $.content.callback = {
	  preSubmitForm:function(){
		 var fnx;
	     if($.browser.mozilla){
			fnx = $(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
		 }else{
			fnx = $(window.componentDiv)[0].document.zwIframe;
		 }
	     
	     //这段代码会导致缓存表单不存在时，弹窗点击两次才能关闭，先注释掉
	     fnx.preSubmitData(function(){},function(){},false,false);
	  },		  
      dealSubmit : function () {//提交回调函数
          isSubmitOperation = true ;
          if ($("input[name='attitude']:checked" ).val()== "collaboration.dealAttitude.disagree"){ //当态度为"不同意"时做的一些判断
              var isdealStepBackShow= false;
              var isdealStepStopShow= false;
              var isdealCancelShow= false;

              if ((nodePerm_commonActionList && nodePerm_commonActionList.contains('Return' ))
                      ||(nodePerm_advanceActionList && nodePerm_advanceActionList.contains('Return' ))){
                  isdealStepBackShow = true ;
              }
              if ((nodePerm_commonActionList && nodePerm_commonActionList.contains('Terminate' ))
                      ||(nodePerm_advanceActionList && nodePerm_advanceActionList.contains('Terminate' ))){
                  isdealStepStopShow = true ;
              }
              if ((nodePerm_commonActionList && nodePerm_commonActionList.contains('Cancel' ))
                      ||(nodePerm_advanceActionList && nodePerm_advanceActionList.contains('Cancel' ))){
                  isdealCancelShow = true ;
              }
              if (isdealStepBackShow||isdealStepStopShow||isdealCancelShow){ //节点权限没有回退、撤销、终止,系统不会弹出确认框，直接可以提交成功
              var ur=_ctxPath+"/collaboration/collaboration.do?method=disagreeDeal" ;
              if (!isdealStepBackShow){
                  ur+= "&stepBack=hidden" ;
              }
              if (!isdealStepStopShow){
                  ur+= "&stepStop=hidden" ;
              }
              if (!isdealCancelShow){
                  ur+= "&repeal=hidden" ;
              }
              if (affairState =='3' && affairSubState == '16'){
                ur+= "&disableTB=1" ;
              }
              var dialog = $.dialog({
                  url : ur,
                  title :$.i18n( 'collaboration.system.prompt.js' ), //系统提示
                  width : 300,
                  height: 120,
                  targetWindow:getCtpTop(),
                  buttons : [ {
                    text : $.i18n('collaboration.pushMessageToMembers.confirm' ), //确定
                    handler : function () {
                      var rv = dialog.getReturnValue();
                      if (rv == "continue" ){
                          dialog.close();
                          submitFunc();
                      } else if (rv == "stepBack"){
                          dialog.close();
                          stepBackCallBack();
                      } else if (rv == "stepStop"){
                          dialog.close();
                          $.content.callback.dealStepStop();
                      } else if (rv == "repeal"){
                          dialog.close();
                          $.content.callback.dealCancel();
                      }
                    }
                  }, {
                    text : $.i18n('collaboration.pushMessageToMembers.cancel' ), //取消
                    handler : function () {
                      enableOperation();
                      setButtonCanUseReady();
                        dialog.close();
                    }
                  } ],
                  closeParam:{
                     'show' :true ,
                     handler: function (){
                       enableOperation();
                       setButtonCanUseReady();
                     }
                  }
                });
              } else {
                  submitFunc();
              }
          } else {
              submitFunc();
          }
      },
      dealSaveDraft : function (){  //存为草稿
    	 if($("#praiseToObj").hasClass("like_16")){ 
  			$("#praiseInput").val(1);
	  	 }else{
	  		$("#praiseInput").val(0);
	  	 }
    	  var draftCommentId = getUUID();
    	  $("#comment_deal > #id").val(draftCommentId);
    	  //保存全文签批单
          addPDF();
    	  var url = _ctxPath + '/collaboration/collaboration.do?method=doDraftOpinion&affairId=' +affairId+ '&summaryId='+summaryId;
          var domains = [];
              if ($.content.getContentDealDomains(domains)) {
                  $( "#layout" ).jsonSubmit({
                    action : url,
                      domains : domains,
                      callback: function (data){
                    	  $("#draftCommentId").val(draftCommentId);
                          $.infor($.i18n('collaboration.summary.savesucess' ));
                      }
                  });
              }
      },
      dealSaveWait : function () {//暂存待办回调函数
    	  	if($("#praiseToObj").hasClass("like_16")){ 
    			$("#praiseInput").val(1);
    		}else{
    			$("#praiseInput").val(0);
    		}
    	   mergeMesPushFun($("#dealMsgPush"),$('#comment_deal #pushMessageToMembers'),$("#content_deal_comment"));
           if ($("#pigeonhole" ).length > 0 && $("#pigeonhole" )[0].checked){
             $.messageBox({
               'title' : $.i18n('collaboration.system.prompt.js' ), //系统提示
                  'type' : 0,
                  'imgType' :2,
                  'msg' : '暂存待办情况下，归档无效!' ,
                  ok_fn: function (){
                        doZCDB();
                        isSubmitOperation = true ;
                  },
             	  close_fn : mainbody_callBack_failed
              });
           } else {
               doZCDB();
               isSubmitOperation = true ;
           }
      },
      dealForward : function (){
          transmitColById([{ "summaryId" : summaryId, "affairId" :affairId}]);
      },
      dealStepStop : function (){//终止
          var lockWorkflowRe = lockWorkflow(_summaryProcessId, _currentUserId, 11);
          if (lockWorkflowRe[0] == "false" ){
              $.alert(lockWorkflowRe[1]);
              enableOperation();
              setButtonCanUseReady();
              return ;
          }
         
          if (!isAffairValid(affairId)||!dealCommentTrue("stepStop")){
          	enableOperation();
          	return;
          } 
          
          if(!executeWorkflowBeforeEvent("BeforeStop",summaryId,affairId,_summaryProcessId,_summaryProcessId,_contextActivityId,formRecordid,_moduleTypeName)){
        	  return;
          }
          var confirm = "" ;
          confirm = $.confirm({
              'msg' : $.i18n('collaboration.confirmStepStopItem' ),
              ok_fn: function () {
                 
                 //var fnx =$(window.componentDiv)[0].document.zwIframe;
        	  	 var fnx;
                 if($.browser.mozilla){
	               		fnx =$(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
	              }else{
	               		fnx =$(window.componentDiv)[0].document.zwIframe;
	            }
                 if(fnx.contentUpdate) fnx.$("#viewState").val("1");
                 //保存正文
                 if(fnx.$("#viewState").val()=="1" || bodyType=='20'){ 
                   var domains =[];
                   var isSubmitFlag = false;
                   fnx.saveOrUpdate({
                       needSubmit:true,
                       checkNull:false,
                       needCheckRule:false,
                       needCheckRepeatData:false,//是否校验重复行数据
                       "mainbodyDomains":domains,
                       success:function(){},
                       failed:function(){
                    	   enableOperation();
                    	   setButtonCanUseReady();
                    	   isSubmitFlag = true;
                       }
                     });
                 	}
                 if(isSubmitFlag){
                	 return;
                 }
                 
                 mergeMesPushFun($("#dealMsgPush"),$('#comment_deal #pushMessageToMembers'),$("#content_deal_comment"));
                 
                 fnx.$.content.getContentDomains( function (domains) {
                     if ($.content.getContentDealDomains(domains)) {
                    	 
                    	 var jsonSubmitCallBack = function(){
                        	 $( "#east" ).jsonSubmit({
                                 action : _ctxPath+ '/collaboration/collaboration.do?method=stepStop&affairId=' +affairId,
                                 domains : domains,
                                 validate: false ,
                                 callback: function (data){
                                       closeCollDealPage();
                                 }
                             });
                         }
                    	 //V50_SP2_NC业务集成插件_001_表单开发高级
                    	 formDevelopAdance4ThirdParty(bodyType,affairId, "stepstop", $("#content_deal_comment").val(),confirm,jsonSubmitCallBack);
                         
                    	 
                   }
                 }, 'stepStop' );
               },
              cancel_fn: function (){
                  releaseWorkflowByAction(_summaryProcessId, _currentUserId, 11);
                  enableOperation();
                  setButtonCanUseReady();
                  confirm.close();
              },
              close_fn: function (){
            	  releaseWorkflowByAction(_summaryProcessId, _currentUserId, 11);
                  enableOperation();
                  setButtonCanUseReady();
              }
          });
      },
      dealCancel : function (){//撤销流程
          //校验开始
          var _colManager = new colManager();
          var params = new Object();
          params[ "summaryId" ] = summaryId;
          //校验是否流程结束、是否审核、是否核定，涉及到的子流程调用工作流接口校验
          var canDealCancel = _colManager.checkIsCanRepeal(params);
          if (canDealCancel.msg != null){
              $.alert(canDealCancel.msg);
              enableOperation();
              setButtonCanUseReady();
              return ;
          }
          //调用工作流接口校验是否能够撤销流程
          var repeal = canRepeal('collaboration' ,_summaryProcessId,_contextActivityId);
          //不能撤销流程
          if (repeal[0] === 'false' ){
              $.alert(repeal[1]);
              enableOperation();
              setButtonCanUseReady();
              return ;
          }
          var lockWorkflowRe = lockWorkflow(_summaryProcessId,_currentUserId, 12);
          if (lockWorkflowRe[0] == "false" ){
              $.alert(lockWorkflowRe[1]);
              enableOperation();
              setButtonCanUseReady();
              return ;
          }
          if (!dealCommentTrue("dealCancel")){
              enableOperation();
            setButtonCanUseReady();
              return ;
          }

          if (!isAffairValid(affairId)) return;
         
          if(!executeWorkflowBeforeEvent("BeforeCancel",summaryId,affairId,_summaryProcessId,_summaryProcessId,_contextActivityId,formRecordid,_moduleTypeName)){
        	  return;
          }
          /*repealConfirm = $.confirm({
              'msg' : $.i18n('collaboration.confirmRepal' ),
              ok_fn: function (){
	            
                  var fnx =$(window.componentDiv)[0];
                  fnx.$.content.getContentDomains( function (domains) {
                      if ($.content.getContentDealDomains(domains)) {
                          var repealComment = $.trim($("#content_deal_comment" ).val());
                         
                          var jsonSubmitCallBack = function(){
                        	  $( "#east" ).jsonSubmit({
                                  action : _ctxPath + '/collaboration/collaboration.do?method=repeal&affairId=' +affairId+ '&summaryId='+summaryId+ '&repealComment=' + escapeStringToHTML(repealComment),
                                  domains : domains,
                                  validate: false ,
                                  callback: function (data){
                                    closeCollDealPage();
                                  }
                             });
                          }  
                          //V50_SP2_NC业务集成插件_001_表单开发高级
                          formDevelopAdance4ThirdParty(bodyType,affairId,"repeal", $("#content_deal_comment").val(),repealConfirm,jsonSubmitCallBack);
                          
                          
                      }
                  }, 'repeal' );
            },
            cancel_fn: function (){
                releaseWorkflowByAction(_summaryProcessId, _currentUserId, 12);
                enableOperation();
                setButtonCanUseReady();
                repealConfirm.close();
            },
            close_fn: function (){
              enableOperation();
              setButtonCanUseReady();
            }
         });*/
          var dialog = $.dialog({
     		 targetWindow:getCtpTop(),
     	     id: 'stepbackdialog',
     	    bottomHTML:'<label for="trackWorkflow" class="margin_t_5 hand">'+
			'<input type="checkbox" id="trackWorkflow" name="trackWorkflow" class="radio_com">'+$.i18n("collaboration.workflow.trace.traceworkflow")+
			'</label><span class="color_blue hand" style="color:#318ed9;" title="'+$.i18n("collaboration.workflow.trace.summaryDetail2")+
			'">['+$.i18n("collaboration.workflow.trace.title")+']</span>',
     	     url: _ctxPath +"/collaboration/collaboration.do?method=repealDialog&affairId="+affairId,
     	     width: 350,
     	     height: 150,
     	     title: "系统提示",
     	     closeParam:{	
     	    	 			show:true,
     	    	 			autoClose:true,
     	    	 			handler:function(){
				        	  enableOperation();
				              setButtonCanUseReady();
     	     				}
     	     },
     	     buttons: [{
     	         text: $.i18n('collaboration.pushMessageToMembers.confirm'), //确定
     	         handler: function () {
                     var rv = dialog.getReturnValue();
                     //alert(rv[0]);
                     //return;
             		if (!rv) {
             	        return;
             	    }
             		 var fnx;
	               	 if($.browser.mozilla){
	               		fnx =$(window.componentDiv)[0].document.getElementById("zwIframe").contentWindow;
	               	 }else{
	               		fnx =$(window.componentDiv)[0].document.zwIframe;
	               	 }
             		//var fnx =$(window.componentDiv)[0].document.zwIframe;
                    fnx.$.content.getContentDomains( function (domains) {
                        if ($.content.getContentDealDomains(domains)) {
                            var repealComment = $.trim($("#content_deal_comment" ).val());
                            var _trackWorkflowType = rv[0];
                            var jsonSubmitCallBack = function(){
                            	dialog.close();//关闭dialog
                          	  $( "#east" ).jsonSubmit({
                                    action : _ctxPath + '/collaboration/collaboration.do?method=repeal&affairId=' +affairId+ '&summaryId='+summaryId+ '&repealComment=' + encodeURIComponent(escapeStringToJavascript(repealComment))+"&trackWorkflowType="+_trackWorkflowType,
                                    domains : domains,
                                    validate: false ,
                                    callback: function (data){
                                      closeCollDealPage();
                                    }
                               });
                            }  
                            //V50_SP2_NC业务集成插件_001_表单开发高级
                            formDevelopAdance4ThirdParty(bodyType,affairId,"repeal", $("#content_deal_comment").val(),dialog,jsonSubmitCallBack);
                            
                            
                        }
                    }, 'repeal' );
                 }
     	     }, {
     	         text: $.i18n('collaboration.pushMessageToMembers.cancel'), //取消
     	         handler: function () {
     	    	 		releaseWorkflowByAction(_summaryProcessId, _currentUserId, 12);
     	    	 		enableOperation();
     	    	 			setButtonCanUseReady();
     	    	 			dialog.close();
     	         }
     	     }]
     	 });
          
      },
      auditPass : function (){//审核通过
          $.content.callback.dealSubmit();
      },
      auditNotPass : function (){//审核不通过
          stepBackCallBack();
      },
      vouchPass : function (){//核定通过
          $.content.callback.dealSubmit();
      },
      vouchNotPass : function (){//核定不通过
          stepBackCallBack();
      },
      specifiesReturnFunc : function (){//指定回退
          specifiesReturn();
      }
  };
  /*设置正文编辑区域*/

  if ($.browser.msie) {
      if ($.browser.version < 8) {
          $( "#iframe_content" ).css("height" , $(".stadic_layout_body" ).height());
      }
  }
  //设置iframe高度后,再加载
  $( "#iframe_content").attr( "src" , "content_view.html" );
  //新增附言 绑定点击事件
  $( '#add_new').click( function (){
      $( '.textarea').removeClass( 'display_none' );
  });

  //新增附言取消 绑定点击事件
  $( '#cancel').click( function (){
      $( '.textarea').addClass( 'display_none' );
  });
  //跟踪 绑定点击事件，选中该 checkbox，默认选中‘全部’
  $( '#isTrack').click( function (){
      var trackRange = $( 'input:radio[name="trackRange"]' );
      if($( this ).attr('checked' )){
          trackRange.removeAttr( 'disabled' );
          //将‘全部’置为选中状态
          trackRange.get(0).checked = true ;
          //改变<label>样式
          $( '#label_all' ).removeClass('disabled_color hand' );
          $( '#label_members' ).removeClass('disabled_color hand' );
      } else{
          trackRange.attr( 'disabled' ,'true' );
          //去掉选中状态
          trackRange.removeAttr( 'checked' );
          //改变<label>样式
          $( '#label_all' ).addClass('disabled_color hand' );
          $( '#label_members' ).addClass('disabled_color hand' );
          $("#trackRange_members_textbox").hide();
      }
  });
  $("#trackRange_all").click(function(){
	  if($(this).attr("checked")){
		  $("#trackRange_members_textbox").hide();  
	  }
  });
  var msData=[];
//流程最大化、意见查找、附件列表、收藏、跟踪、新建会议、即时交流、表单授权、属性状态、明细日志、打印、督办/督办设置
  if($( "#attachmentListFlag" ).length>0){
      msData[msData.length]={
              name:$.i18n( 'collaboration.common.flag.attachmentList' ),  // 附件列表
              className: "affix_16" ,
              handle: function (json) {
                  showOrCloseAttachmentList();
              }
          };
  }
  var _favTip = $.i18n('collaboration.summary.favorite');
  var _favClass = "unstore_16";
  if(isCollect){
	  _favTip = $.i18n('collaboration.summary.favorite.cancel');
	  _favClass= "stored_16";
  }
  if($("#favoriteFlag").length > 0){
	  msData[msData.length]={
			  id:"_favId",
              name:_favTip,  // 收藏
              className: _favClass ,
              handle: function (json) {
                  if($("#_favId")[0].innerHTML.indexOf("stored_16") > -1){
                      cancelFavorite(1,affairId,hasAttsFlag,3);
                  }else{
                	  favorite(1,affairId,hasAttsFlag,3);
                  }
              }
          };
  }
  if($( "#gzbuttonFlag" ).length>0){
      msData[msData.length]={
              name: $.i18n( 'collaboration.forward.page.label4' ),  //跟踪
              className: "track_16" ,
              handle: function (json) {
                   setTrack();
              }
          };
  }
  if($( "#showDetailLogFlag" ).length>0){
	    msData[msData.length]={
	          name: $.i18n( 'collaboration.common.flag.showDetailLog' ),  //明细日志
	          className: "view_log_16" ,
	          handle: function (json) {
	            showDetailLogFunc();
	          }
	    };
	  }
if($( "#attributeSettingFlag" ).length>0){
    msData[msData.length]={
            name: $.i18n('collaboration.common.flag.attributeSetting' ),  // 属性状态
            className: "attribute_16" ,
            handle: function (json) {
                attributeSettingDialog($( '#affairId' ).val());
            }
        };
}
  if($.ctx.resources.contains( 'F09_meetingArrange' )){
    if($( "#createMeetingFlag" ).length>0) {
        msData[msData.length]={
              name: $.i18n( 'collaboration.summary.createMeeting' ),  //新建会议
              className: "ico16" ,
              handle: function (json) {
                  createMeeting(affairId,openFrom,getCtpTop().frames['main' ], true);
              }
          };
    } else {
      if($( "#createMeeting" )) {
        $( "#createMeeting" ).click( function() {
          createMeeting(affairId,openFrom,getCtpTop().frames['main' ], true);
        });
      }
    }
  }else{
	  $("#createMeetingFlag,#createMeeting").hide();
  }
  //致信路径过来的不显示即时交流按钮
//   if($( "#timelyExchangeFlag" ).length>0 && hasPluginUC && extFrom != 'ucpc'){
//       msData[msData.length]={
//               name: $.i18n( 'collaboration.summary.timelyExchange' ),  //即时交流
//               className: "communication_16" ,
//               handle: function (json) {
//                   timelyExchangeFun();
//               }
//           };
//   }
  if($( "#formAuthorityFlag" ).length>0){
      msData[msData.length]={
              name: $.i18n('collaboration.toolbar.relationAuthority.label' ),//表单授权
              className: "authorize_16" ,
              handle: function (json) {
                  formAuthorityFunc();
              }
          };
  }
 
  
  if($("#showWorkflowtraceFlag").length>0){
  	msData[msData.length]={
 	        name: $.i18n('collaboration.workflow.label.lczs'),
 	        className: "view_log_16",
 	        handle: function (json) {
 	        	showOrCloseWorkflowTrace();
 	        }
  	};
  }
 
  if($( "#showSuperviseSettingWindowFlag" ).length>0){
    msData[msData.length]={
            name: $.i18n('collaboration.common.flag.showSuperviseSetting' ),  //督办设置
            className: "setting_16" ,
            handle: function (json) {
              superviseSettingFunc();
            }
        };
  }
  if($( "#showSuperviseWindowFlag" ).length>0){
    msData[msData.length]={
            name: $.i18n( 'collaboration.common.flag.showSupervise' ),  //督办
            className: "meeting_look_1" ,
            handle: function (json) {
              superviseFunc();
            }
        };
  }
//   if($( "#_processMaxFlag" ).length>0){
// 	    msData[msData.length]={
// 	            name: $.i18n( 'collaboration.summary.flowMax' ),  //流程最大化
// 	            className: "process_max_16" ,
// 	            handle: function (json) {
// 	    			processFlashMax();
// 	            }
// 	        };
//       }
      
  $( "#caozuo_more").menuSimple({
      direction: "BR" ,
      data: msData
  });
  
  /**增加流程追溯的查看方法**/
  function showOrCloseWorkflowTrace(){
	  var dialog = $.dialog({
			 targetWindow:getCtpTop(),
		     id: 'workflowTrace',
		     url: _ctxPath +"/trace/traceWorkflow.do?method=showWorkflowDetail&affairId="+affairId+"&app=4",
		     width: 800,
		     height: 420,
		     title: $.i18n('collaboration.workflow.label.lczs')
		 });
  }

  //督办设置 绑定点击事件
  $( '#showSuperviseSettingWindow').click(superviseSettingFunc);
 
  //督办绑定点击事件
  $( '#showSuperviseWindow').click(superviseFunc);
 
  //查看明细日志 绑定点击事件
  $( '#showDetailLog').click(showDetailLogFunc);
  //打印 绑定点击事件
  $( '#print').click( function (){
	  if(pdfIframe){
		  if(document.getElementById("pdfIframe").style.height!="0px"){
			  if(pdfIframe.HWPostil1&&pdfIframe.HWPostil1.lVersion){
				  pdfIframe.HWPostil1.PrintDoc(1,1);
				  return;
			  }
		  }
	  }
	  newDoPrint( "summary");
  });
  
  $( '#jointlyIssued').click( function (){
			var dialog = $.dialog({
		        url : "/seeyon/govDoc/govDocExchangeController.do?method=jointlyIssuedDetail&summaryId=" + summaryId + "&affairId="+$( '#affairId' ).val()+"&type=1",
		        width : 700,
		        height : 300,
		        title : '联合发文',
		        targetWindow:getCtpTop(),
		        buttons : [{
		            text : $.i18n('collaboration.button.close.label'),
		            handler : function() {
		              dialog.close();
		            }
		        }]
		    });
	  });
  //表单授权绑定点击事件
  $( '#formAuthority').click(formAuthorityFunc);
  //属性设置 绑定点击事件
  $( '#attributeSetting').click( function (){
      attributeSettingDialog($( '#affairId' ).val());
  });
  //盖章
  //$( "#_commonSign, #_dealSign").click(openSignature);
  //右侧 半屏展开
  $( "#deal_area_show").click( function () {
    $( ".deal_area #hidden_side").trigger( "click" );
  });
//右侧  收缩
  $( ".deal_area #hidden_side").click( function () {
		  if ($( "#east" ).outerWidth() == 350) {
	          layout.setEast(38);
	          $( ".deal_area" ).hide();
	          $( "#deal_area_show" ).show();
	      } else {
	          layout.setEast(348);
	          $( ".deal_area" ).show();
	          $( "#deal_area_show" ).hide();
	      }
  });
  //给跟踪按钮加事件
  $( "#gzbutton").bind( "click" ,function (){
      setTrack();
  });

  $( "#gz").change( function () {
      var a8obj = getCtpTop().document;
      var value = $( this ).val();
      var _gz_ren = $( "#gz_ren" ,a8obj);
      switch (value) {
          case "0" :
              _gz_ren.hide();
              break ;
          case "1" :
              _gz_ren.show();
              break ;
      }
  });
  //指定人弹出选人窗口
  $( "#radio4").bind( 'click' ,function (){
       $.selectPeople({
              type: 'selectPeople'
              ,panels: 'Department,Team,Post,Outworker,RelatePeople'
              ,selectType: 'Member'
              ,text:$.i18n( 'collaboration.default.selectPeople.value' )
              ,params:{
                 value: forTrackShowString
              }
              ,targetWindow:getCtpTop()
              ,callback : function (res){
                  if (res && res.obj && res.obj.length>0){
                      var selPeopleId="" ;
                      for (var i = 0; i < res.obj.length; i ++){
                          if (i == res.obj.length -1){
                              selPeopleId +=res.obj[i].id;
                          } else {
                              selPeopleId+=res.obj[i].id + "," ;
                          }
                      }
                      forTrackShowString = res.value;
                      $( "#zdgzry" ).val(selPeopleId);
                  } else {
                    
                  }
              }
          });
    });
  
  //修改流程绑定点击事件
  $( '#edit_workFlow').click( function (){
	  var curPerm = getCurPerm();
      editWFCDiagram(getCtpTop(),_summaryCaseId,_summaryProcessId,
              '', curPerm.appName ,isFromTemplate,
              flowPermAccountId,curPerm.defaultPolicyId,curPerm.defaultPolicyName,refreshWorkflow,$.i18n( 'supervise.col.label' ));
  });

  //添加人员卡片信息
  $( "#panleStart").click( function (){
      $.PeopleCard({
          targetWindow:openType,
          memberId:_startMemberId
      });
  });

  //新闻审核、公告审核
  $( "#_dealPass1").click( function (){
      var lockWorkflowRe = lockWorkflow(_summaryProcessId, _currentUserId, 14);
      if(lockWorkflowRe[0] == "false" ){
          $.alert(lockWorkflowRe[1]);
          enableOperation();
          setButtonCanUseReady();
          return ;
      }
      var lockWorkflowCon = checkWorkflowLock(summaryId, currUserId);
      if (lockWorkflowCon[0] == "false") {
          $.alert(lockWorkflowCon[1]);
          enableOperation();
          setButtonCanUseReady();
          return;
      }
      if (!dealCommentTrue("dealPass1")){
          return ;
       }
      
      submitFunc();
      
  });

  
 //协同收藏
 $( "#favoriteSpan"+affairId).click( function (){
     favorite(1,affairId,hasAttsFlag,3);
 });
 $( "#cancelFavorite"+affairId).click( function (){
     cancelFavorite(1,affairId,hasAttsFlag,3);
 });
//隐藏空意见 add by libing
 $("#hidNullOpinion").click(function(){
	 $("#hidNullOpinion").hide();
	 $("#showNullOpinion").show();
	 var htmlSource  = $(window.componentDiv)[0].document;
	 //本协同的意见区
	 //$("div[id^='comContent']",htmlSource).each(function(){
		// var idStr = this.id.substring(10,this.id.length);
		// //本身自己的内容为空 && 有震荡回复 &&
		// var canNotView = $("#canNotView"+idStr,htmlSource).size()>0;
		// var emtyContent = $("#emtyContent"+idStr,htmlSource).size()>0;
		// var selfBlank = emtyContent|| canNotView; //已经本身没有或者不可见。
		// if( selfBlank
		//	 && ($("#replyContent_"+idStr,htmlSource)[0].innerHTML =="" ||
		//			 ($("#replyContent_"+idStr,htmlSource)[0].innerHTML !="" && $("#hideReplay"+idStr,htmlSource).size() <1 ))
		// 		&& $("#liAtt"+idStr,htmlSource).size()<1 && $("#liRela"+idStr,htmlSource).size()<1){
		//	 $("#ul"+this.id,htmlSource).addClass("hiddenNullOpinion");
		//	 //$("#ul"+this.id,htmlSource).addClass("hiddenNullOpinion")[0].outerHTML = "";
		//	 $("h3.per_title",htmlSource).css("clear","both");
		// }
	 //});
	//转发的协同的原意见区
	// $("span[id^='comContent']",htmlSource).each(function(){
	//	 var idStr = this.id.substring(10,this.id.length);
	//	 //本身自己的内容为空 && 有震荡回复 &&
	//	 var canNotView = $("#canNotView"+idStr,htmlSource).size()>0;
	//	 var emtyContent = $("#emtyContent"+idStr,htmlSource).size()>0;
	//	 var selfBlank = emtyContent|| canNotView;
	//	 if( selfBlank
	//		 && ($("#replyContent_"+idStr,htmlSource).hasClass("display_none") || //没有孩子 false  && 有孩子 但是有一个不隐藏就不能隐藏
	//					 (!$("#replyContent_"+idStr,htmlSource).hasClass("display_none") && $("#hideReplay"+idStr,htmlSource).size() <= 0))
	//	 		&& $("#liAtt"+idStr,htmlSource).size()<1 && $("#liRela"+idStr,htmlSource).size()<1){
	//		 $("#ul"+this.id,htmlSource).addClass("hiddenNullOpinion");
	//		 $("h3.per_title",htmlSource).css("clear","both");
	//	 }
	// });
	 var edocHtmlSource = $(window.componentDiv)[0].document.zwIframe.document;
	 //公文意见
	 $("span[id^='field'][id$='_span']",edocHtmlSource).each(function(){
		 var fieldVal = $(this).attr("fieldVal");
		 if(fieldVal!=null){
			 fieldVal = $.parseJSON(fieldVal);
		 }
		 if(fieldVal.inputType=="edocflowdealoption"){
			 var nodes = $(this).children();
			 if(nodes.length>1){
				 $($(this).children()[1]).html("");
			 }else{
				 $($(this).children()[0]).html("");
			 }
			 
		 }
	 });
	 showNowHeight();
 });
 $("#showNullOpinion").click(function(){
	 $("#showNullOpinion").hide();
	 $("#hidNullOpinion").show();
	 //return;
	 var htmlSource  = $(window.componentDiv)[0].document;
	 $(".hiddenNullOpinion",htmlSource).each(function(){
		 $(this).removeClass("hiddenNullOpinion");
	 });
	 var edocHtmlSource = $(window.componentDiv)[0].document.zwIframe;
	 edocHtmlSource.dispOpinions(edocHtmlSource.opinions,edocHtmlSource.senderOpinion);
	 edocHtmlSource.initHandWrite();
	 showNowHeight();
 });
function showNowHeight(){
	var nowHeight = componentDiv.zwIframe.$("#mainbodyDiv").height();
	 componentDiv.$("#cc").height(nowHeight);
	 componentDiv.$("#cc").parent().height(nowHeight);
	 componentDiv.$("#zwIframe").height(nowHeight);
}
 //流程最大化
$( "#processMaxFlag").click(processFlashMax);
function processFlashMax(){
    var isTemplate = isFromTemplate;
    //是否显示催办按钮
    var showHastenButton = false ;
    //判断是否显示催办按钮
    if((affairState == '2' ||(affairState == '4' && isCurrentUserSupervisor=='true' ))
            && isFinshed!= "true" && summaryReadOnly!='true' && openFrom!='edocStatics' && openFrom!='lenPotent' ){
        showHastenButton= true ;
     }
    var senderName = null ;
    //senderName待发已发列表才能传递，其他情况下步传递
    if(openFrom == 'listWaitSend' ){
       senderName = _currentUserName;
    }
    if(affairState == '1' &&  affairSubState == '1' && isTemplate == 'true' && templateType != 'text' ){
       showWFTDiagram(getCtpTop(), templateWorkflowId, getCtpTop());
    } else{
       showWFCDiagram(openType,
    		          _contextCaseId,
    		          _contextProcessId,
    		          isTemplate,
    		          showHastenButton,
    		          supervisorsId,
    		          window, 
    		          'collaboration', 
    		          false ,
    		          _contextActivityId,
    		          operationId,'' ,
    		          senderName,isHistoryFlag);
    }
}

//即时交流
$("#timelyExchangeFlag,#timelyExchange").click( function (){
   timelyExchangeFun();
});

//表单加锁单
if(bodyType == '20' && isHasDealPage == 'true'){
	 formAddLock();
	 $(window.componentDiv).load(function(){
    	try{this.checkInstallHw(disabl4Hw);}catch(e){}
     });
}

 if ($.browser.msie){
   if($.browser.version < 9){
     setIframeHeight_IE7();
     $(window).resize(function(){
       setIframeHeight_IE7();
     });
   }
 }
});

window.onbeforeunload = function(){
    if (getCtpTop().isCtpTop == undefined || getCtpTop().isCtpTop == "undefined") {
        removeCtpWindow(affairId,2);
    }
};


//处理和查看页面解决chrome下隐藏后显示控件未的问题
function OfficeObjExtshowExt(){
	var compIframe= $("#componentDiv")[0];
 	var iframe = $("#zwIframe",compIframe.contentWindow.document)[0];
 	document.onmouseover = function(){};
 	OfficeObjExt.showIfame({ //处理 zwIframe iframe中的Office 对象的显示
		firstAttr:"firstHeight",
		iframe:iframe,
		callback:function(){
			var arr = [];
			var _tpWin = getCtpTop();
		 
			if(_tpWin.isOffice && _tpWin.officeObj && _tpWin.officeObj.length>0){ //处理所有签章对象的显示
				for(var i = 0; i<_tpWin.officeObj.length;i++){
					var _temp = _tpWin.officeObj[i];
					if(_temp && _temp.style){
						_temp.style.visibility = 'visible';
						arr.push({ //将多个Office对象安装队列顺序执行，进行效果显示
							obj:_temp, //当前的office对象
							idx:arr.length, //当前office对象在队列中的唯一标示
							run:function(){
								OfficeObjExt.showIfame({ //执行当前office对象的显示
									firstAttr:"firstHeight_"+this.idx, //当前对象 对应的对应到队列中的唯一标示
									iframe:this.obj,//当前的Office 对象
									callback:function(){ //当前office对象在队列中执行完毕的函数
										if(typeof arr[this.idx+1] !=='undefined'){
											arr[this.idx+1].run(); //当前队列执行完毕后，执行下一个队列
										}
										if(typeof arr[this.idx+1] ==='undefined'){ //当队列执行完毕后，清空数组对象
											arr.length =0;
										}
									}
								});
							}
						});
					}
				}
			}
			window.setTimeout(function(){
				if(arr.length>0){ //执行队列中第一个元素 的显示
					arr[0].run();
				} 
			},20); 
		}
	}); //default :firstHeight 
}



if(_isSystemAdmin != "true"){
    getDom();
}
function getDom(){
    if(xmlDoc == null){
        try{
            xmlDoc = new ActiveXObject( "SeeyonFileDownloadLib.SeeyonFileDownload");
            xmlDoc.AddUserParam(currentUserLocale, currentUserloginName , _sid , $.ctx.CurrentUser.id );
        }catch(ex1){
         
        }
    }
    return xmlDoc;
}

function getProcessAndUserId(){
	  var obj = {};
	  var processId = document.getElementById("processId").value;
	  var currentUser = document.getElementById("ajaxUserId").value;
	  var workitemId = document.getElementById("workitemId").value;
	  var caseId = document.getElementById("caseId").value;
	  var summaryIdObj=document.getElementById("summary_id");
	  if(summaryIdObj){
		  obj.summaryId=summaryIdObj.value;
	  }
	  obj.processId = processId;
	  obj.currentUser = currentUser;
	  obj.workitemId = workitemId;
	  obj.caseId=caseId;
	  return obj;
}

$(document).ready(function() {
    $(window).load(function() {
		if(isFromTrace){//撤销的时候屏蔽按钮
			//$("#attachmentListFlag,#attachmentListFlag1").hide();//附件
			//$("span[id^='favoriteSpan'],span[id^='cancelFavorite']").hide();//收藏
			//$("#attributeSetting,#attributeSettingFlag").hide();//属性状态
			//$("#showDetailLog,#showDetailLogFlag").hide();//明细日志
			$("#caozuo_more").hide();
			$("#print").hide();
			if(!(_trackTypeRecord == '6') || _trackTypeRecord == '5'){//不是普通回退都要隐藏回复
				$("span[class='add_new']",document.componentDiv.document).hide();
			}
		}
		if(isCollCube == "1" || isColl360 == "1"){
			_hideButton();
		}
        if(onlySeeContent){
            //$("#govdoc_content_view_li").find("a").trigger("click");
        	/**
        	 *BDGW-2137 当文档中心借阅的权限为“公文正文”，借阅人打开该公文，默认打开正文时显示为空
        	 *延时触发打开正文，避免组件未加载完导致正文空白
        	 */
        	setTimeout(function(){
        		showGovdocContent(summaryId);
        	}, 2000);
        }else{
        }
    });
    
    
  //判断当前节点是否存在
    if (noConfigItem == "true") { //如果没有找当对应节点权限，则提示:当前处理节点已被删掉，改为知会节点，请联系管理员解决!
        $.alert($.i18n("collaboration.summary.noFindNode"));
    }
    var initWidth=350;
    if(isDealPageShow !== "false"){
        $(".deal_area").show();
        $("#deal_area_show").hide();
    }else{
        initWidth=38;
        $(".deal_area").hide();
        $("#deal_area_show").show();
    }
    //页面加载 样式初始化
    
    var layoutJson ={};
    layoutJson.id = 'layout';
    if(hasDealArea == 'true'){
    	 layoutJson.eastArea =  {
             'id': 'east',
             'width': initWidth,
             'sprit': true,
             'minWidth': 350,
             'maxWidth': 500,
             'border': true
         };
    }else{
    	if(newGovdocView==1){
    		layoutJson.eastArea =  {
    	             'id': 'east',
    	             'width': initWidth,
    	             'sprit': true,
    	             'minWidth': 350,
    	             'maxWidth': 350,
    	             'border': true
    	         };
    	}
    }
    layoutJson.centerArea = {
        'id': 'center',
        'border': true,
        'minHeight': 20
    }
    
    layout = new MxtLayout(layoutJson);
    
    
    summaryHeadHeight();
    
    if ($.browser.msie){
        if($.browser.version < 7 || document.documentMode<8){
			var _c = document.getElementById('content_workFlow');
			if(document.documentMode<8)_c.style.height = _c.clientHeight
            $("#componentDiv").height($("#content_workFlow").height());
            $(window).resize(function(){
                $("#componentDiv").height($("#content_workFlow").height());
            })
        }
    }
    
});
