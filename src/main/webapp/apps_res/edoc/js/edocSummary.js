var senderEditAttCallbackParam = {};
var showPDFflag =true;
var isAgree = false;
function senderEditAtt(){
  var processId = summary_processId;
  var currentUser = currentUserId;
  //修改附件加锁
  var re = EdocLock.lockWorkflow(summaryId, currentUser,EdocLock.UPDATE_ATT);
  if(re[0] == "false"){
    parent.parent.$.alert(re[1]);
    return;
  }
	var attList = getAttachment(summaryId,summaryId);
	senderEditAttCallbackParam.processId = processId;
	senderEditAttCallbackParam.currentUser = currentUser;
	var result = editAttachments(attList,summaryId,summaryId,'4', senderEditAttCallback);
}

/**
 * 修改附件回调函数
 */
function senderEditAttCallback(result){
    
    var processId = senderEditAttCallbackParam.processId;
    var currentUser = senderEditAttCallbackParam.currentUser;
  //提交
    if(result){
        saveAttachment();
        $('#attchmentForm').ajaxSubmit({
                url : genericURL + "?method=updateAttachment&edocSummaryId="+summaryId+"&affairId="+affair_id,
                type : 'POST',
                success : function(data) {
                    updateAttachmentMemory(result,summaryId,summaryId,'');
                    //附件提交完成后，需要清理缓存日志
                    try{
                        attActionLog.logs = null;
                    }
                    catch(e){}
                    //showAttachment(summaryId, 2, 'attachment2TrContent', 'attachment2NumberDivContent','attachmentHtml2Span');
                    //showAttachment(summaryId, 0, 'attachmentTrContent', 'attachmentNumberDivContent','attachmentHtml1Span');
                    //document.getElementById("attachmentTrContent").style.display='';
                    //contentIframe.location.reload();//xiangfan 添加 修复GOV-4873,附件修改成功后刷新子页面
                    location.reload();
                }
        })
    }
    EdocLock.releaseWorkflowByAction(processId, currentUser,EdocLock.UPDATE_ATT);
}

function initCaseProcessXML(){
	if(isLoadProcessXML == false){
		try {
			var requestCaller = new XMLHttpRequestCaller(null, "ajaxColManager", "getXML", false, "POST");
			requestCaller.addParameter(1, "String", caseId);
			requestCaller.addParameter(2, "String", processId);
			var processXMLs = requestCaller.serviceRequest();
			
			if(processXMLs){
				caseProcessXML = processXMLs[0];
				caseLogXML = processXMLs[1];
				caseWorkItemLogXML = processXMLs[2];
				document.getElementById("process_xml").value = caseProcessXML;
				document.getElementById("process_desc_by").value = "xml";
			}
		}
		catch (ex1) {
		}
		isLoadProcessXML = true;
	}
}
function init_edocSUmmary() {
	//设置跟踪人信息
	customTrackSet();
	//判断当前节点是否存在
    if (noConfigItem == "true") { //如果没有找当对应节点权限，则提示:当前处理节点已被删掉，改为知会节点，请联系管理员解决!
        //alert('${ctp:i18n("collaboration.summary.noFindNode")}');
        if(_fawentishi){
        	alert(noFindNodeFawen);
        }else{
        	alert(noFindNodeShouwen);
        }
    }
	parent.edocType=edocType;
	var oSupervise = document.getElementById('buttonsupervis');
	if(oSupervise!=null){
		oSupervise.onclick=null;
		oSupervise.onclick=function(){
			document.getElementById('superviseIframe').src = edoc+"?method=superviseDiagram&summaryId="+summaryId+"&openModal="+openModal;
		}
	}
	var buttonworkflow = document.getElementById('buttonworkflow');
	if(buttonworkflow!=null){
		buttonworkflow.onclick=null;
		buttonworkflow.onclick=function(){
			var divPhrase = document.getElementById('divPhrase');
			if(divPhrase!=null && divPhrase.style.display!='none'){
				divPhraseDisplay  = 'block';
				divPhrase.style.display='none';
			}else{
				divPhraseDisplay  = 'none';
			}
		}
	}
	var buttonsign = document.getElementById('buttonedocform');
	if(buttonsign!=null){
		buttonsign.onclick=null;
		buttonsign.onclick=function(){
			var divPhrase = document.getElementById('divPhrase');
			if(divPhrase!=null && divPhraseDisplay=='block'){
				divPhrase.style.display='block';
			}else{
				divPhrase.style.display='none';
			}
		}
	}

	var buttoncontent = document.getElementById('buttoncontent');
	if(buttoncontent!=null){
		buttoncontent.onclick=null;
		buttoncontent.onclick=function(){
			if(typeof(trans2Html)=='undefined' || trans2Html == 'false')
				LazyloadOffice('0');
		}
	}
	var buttoncontent = document.getElementById('buttoncontent1');
	if(buttoncontent!=null){
		buttoncontent.onclick=null;
		buttoncontent.onclick=function(){
			if(typeof(trans2Html)=='undefined' || trans2Html == 'false')
				LazyloadOffice('1');
		}
	}
	var buttoncontent = document.getElementById('buttoncontent2');
	if(buttoncontent!=null){
		buttoncontent.onclick=null;
		buttoncontent.onclick=function(){
			if(typeof(trans2Html)=='undefined' || trans2Html == 'false')
				LazyloadOffice('2');
		}
	}
	if(onlySeeContent=='true'){ //借阅只借阅正文的时候，切换到正文也签
		showPrecessAreaTd('content');	
	}else{
		showPrecessAreaTd('edocform');	
	}


	//显示正文附件区域，由于布局的关系 ，导致在firefox下面或者两次调用这个方法，导致显示不正常。故将其移动到页面初始化方法中
	if(onlySeeContent && onlySeeContent=="false"){
		showAttachment(summaryId, 2, 'attachment2TrContent', 'attachment2NumberDivContent','attachmentHtml2Span');
	}
	showAttachment(summaryId, 0, 'attachmentTrContent', 'attachmentNumberDivContent','attachmentHtml1Span');

	//changyi add 显示附件(开始没有附件时就不显示)
	if(theToShowAttachments){
		var attachmentNumber = 0;
		for(var i = 0; i < theToShowAttachments.size(); i++) {
			var att  = theToShowAttachments.get(i);
			if(att.subReference == summaryId && (att.type==0 || att.type==2)){
				attachmentNumber++;
			}
		}
		if(attachmentNumber > 0){
			document.getElementById("attachment2Tr").style.display="";
		}
	}
	

	
	//是否在已发中显示修改附件的按钮
	if(canEditAtt == 'true') showModifyAttachmentLabel();

	//初始化附件区，当附件太多的时候设置样式高度为2行，有滚动条
	var attDiv =document.getElementById("attDiv");
	var att2Div= document.getElementById("att2Div");
	if(attDiv) exportAttachment(attDiv);
	if(att2Div) exportAttachment(att2Div);

	//这个地方不要随便动啊。防止OFfice正文加载两次，同时正确显示HTML正文
	 if( bodyType=="HTML"){
		/* $('#scrollContentTd div').html($('#ctn').html());*/
		document.getElementById('htmlContentIframe').src = detailURL+"?method=edocContent&summaryId="+summaryId+"&onlySeeContent="+onlySeeContent;
	} 
	//窗体加载时显示意见输入框
	readLoading();
	
	windowResizeTop();
	initMoreOperation();
	
	if(PDFId!=''&&canPDFSign&&onlySeeContent=='false'){
		showPrecessAreaTd('pdf');
	}
	
}

function initMoreOperation(){
	 $("#caozuo_more").click(function(){
		$("#caozuo_moreDiv").css("display","block");
		$("#caozuo_moreDiv").css("top",$("#hhhhhhh")[0].offsetTop);
		$("#createMeetingFlag").mouseout(function(){
			$("#caozuo_moreDiv").hide();
		});
	 });
}

function customTrackSet(){
	if(!_personalTemplateFlag && _affairSubState != '13' && customSetTrackFlag){
		$("#isTrack").click();
		$("#trackRange_all").attr("checked",true).attr("disabled",false);
		$("#trackRange_part").attr("disabled",false);
	}
	if(trackStatus == "2"){
		$("#isTrack").attr("checked",true);
		$("#trackRange_all").attr("checked",false);
		$("#trackRange_part").attr("checked",true);
	}
	if("" != mids){
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocManager", "getTrackName",false);
		requestCaller.addParameter(1, "String", mids);
		var strName=requestCaller.serviceRequest();
        $("#zdgzryName").val(strName);
        $("#zdgzryName").attr("title",strName);
    	var partText = document.getElementById("zdgzryName");
    	if(partText){
    		partText.style.width="82px";
    	    partText.style.display="";
    	}
	}
}
//是否在已发中显示修改附件的按钮
function showModifyAttachmentLabel(){
	var attachmentTr=document.getElementById("attachmentTrContent");
	if(attachmentTr)attachmentTr.style.display="";
/*	var normalText=document.getElementById("normalText");
	if(normalText)normalText.style.display="none";*/
	var uploadAttachmentTR=document.getElementById("uploadAttachmentTR");
	if(uploadAttachmentTR)uploadAttachmentTR.style.display="";
	//xiangfan 添加 修复GOV-5102 公文后台开启了允许拟文人修改已发公文的附件，发起人打开已发公文中没有插入附件的公文，没有显示 '修改附件'按钮 的错误  Start
	var attachment2TrObj = document.getElementById("attachment2Tr");
	if(attachment2TrObj)attachment2TrObj.style.display="";
	//xiangfan 添加 修复GOV-5102 公文后台开启了允许拟文人修改已发公文的附件，发起人打开已发公文中没有插入附件的公文，没有显示 '修改附件'按钮 的错误  End
}
function unLoad(processId, summaryId,userId){
	try{

		if(isCheckContentEdit && ocxContentIsModify()==true)
		{//正文为修改状态，是否进行保存
			event.returnValue="您修改了正文内容没有保存，确定离开当前页面吗？";
		}
    	unlockEdocEditForm(summaryId,userId);
    	unlockHtmlContent(summaryId);
    	//文单解锁
    	contentIframe.edocContentUnLoad();
    	EdocLock.releaseWorkflow(summaryId, userId);
    	EdocLock.releaseWorkflow(processId, userId);
    }catch(e){
    }
}
var isUpdateedContent = false;
function updateContent(summaryId){
	//永中office不支持wps正文修改
	if(bodyType == "Pdf"){
		alert("Pdf格式正文不允许修改");
		return;
	}
	var isYozoWps = checkYozo();
	if(isYozoWps){
		return;
	}
	modifyBody(summaryId,hasSign);
	summaryChange();
	isUpdateedContent = true;
}

function checkYozo(){
	var isYozoWps = false;
	if(bodyType && (bodyType == "WpsExcel" || bodyType == "WpsWord")){
		isYozoWps = true;
	}
    var isYoZoOffice = parent.isYoZoOffice();
    if(isYozoWps && isYoZoOffice){
 	   alert(_("edocLang.edoc_alertModifyWpsYozoOffice"));
 	   return true;
    }
    return false;
}

function htmlSign(){
	
    //是edge浏览器
    if(navigator.userAgent.toLowerCase().indexOf("edge")!=-1){
        alert("当前浏览器不支持office签章！");
        return;
    }
	// 判断是否有其他用户在修改文单
	if(checkAndLockEdocEditForm(summaryId)){
		 return;	
	}
	  
	var isReportToSupAccount = document.getElementById("isReportToSupAccount");
	if(isReportToSupAccount && isReportToSupAccount.value == "true"){
		alert("文单含有意见汇报元素，不能进行文单签批操作!");
		return;
	}
	
	var advanceOfficeOcx=advanceOffice;
	if(advanceOfficeOcx == "false"){
		alert(permissionAdvanceOfficeHtmlSignAuthorLabel);
		return;
	}
	showPrecessAreaTd("edocform");
	var affairId=affair_id+"";//转成字符串格式
	contentIframe.handWrite(theform.summary_id.value,theform.disPosition.value,true,affairId);
}
function edocSubmit() {
	disabledPrecessButtonEdoc();//置灰按钮
	var flag;
	var childrenPageAttitude = contentIframe.document.getElementsByName("attitude");
	      for(var i=0;i<childrenPageAttitude.length;i++){
	         if(childrenPageAttitude[i].checked==true){
	        	 flag = childrenPageAttitude[i].value;
	         }
	      }
	      if(flag == 3 || flag == "3"){//如果选择不同意则弹出
	      			var disAgreeOpinionPolicy = document.getElementById("disAgreeOpinionPolicy");
	      			var contentOP = contentIframe.document.getElementById("contentOP");
	      			//意见不同意，校验意见内容
	      			if(disAgreeOpinionPolicy && disAgreeOpinionPolicy.value == 1 && contentOP && contentOP.value.trim() == ''){
	      			        enablePrecessButtonEdoc();
	      			        alert(v3x.getMessage("edocLang.edoc_opinion_mustbe_gived"));
	      			        return;
	      			}
              if (isdealStepBackShow == 'true' || isdealStepStopShow == 'true' || isdealCancelShow == 'true'){ //节点权限没有回退、撤销、终止,系统不会弹出确认框，直接可以提交成功
              var url="edocController.do?method=disagreeDeal" ;
              if (isdealStepBackShow == 'false'){
            	  url+= "&stepBack=hidden" ;
              }
              if (isdealStepStopShow == 'false'){
            	  url+= "&stepStop=hidden" ;
              }
              if (isdealCancelShow  == 'false'){
            	  url+= "&repeal=hidden" ;
              }
              if (affairState =='3' && affairSubState == '16'){
            	  url+= "&disableTB=1" ;
                }
              getA8Top().win123 = getA8Top().$.dialog({
    			  title:edoc_select_operation,
    			  transParams:{'parentWin':window},
    			  url: url,
    			  height:150,
    			  width:300,
    			  closeParam:{
    				  show:true,
    				  autoClose:false,
    				  handler:function(){
    				  enablePrecessButtonEdoc();
    				  getA8Top().win123.close();
    			  	}
    			  }
    		     });
	    	  }else{
	    		  edocSubmitFunc();
	    	  }
	      }else{
			  //同意
			  isAgree = true;
	    	  edocSubmitFunc();
	      }
}
function edocSubmitCallback(rv){
	if (rv == "continue" ){
		commonDialogClose('win123');
      edocSubmitFunc();
  } else if (rv == "stepBack"){
	  commonDialogClose('win123');
	  stepBack(document.theform);
  } else if (rv == "stepStop"){
	  commonDialogClose('win123');
	  stepStop(document.theform);
  } else if (rv == "repeal"){
	  commonDialogClose('win123');
	  repealItem('pending',summaryId,affair_id);
  }
}

var sendCount=0;
function edocSubmitFunc(){
	disabledPrecessButtonEdoc();
	if(isAgree){
		addPDF("agree");
	}else{
		addPDF("unagree");
	} 
	if(document.getElementById("trackRange_part") &&  document.getElementById("trackRange_part").checked){
		if(document.getElementById("trackMembers").value == ""){
			alert(_trackTitle);
			enablePrecessButtonEdoc();
			return;
		}
	}
	if(!isAffairValid(affair_id)){
		doEndSign_pending(affair_id);
		enablePrecessButtonEdoc();
		return;
	}
	var pipeonhole=document.getElementById("pipeonhole");
    if(pipeonhole && pipeonhole.checked){//假设选择了处理后归档，则判断是否选择了文件路径 && 归档文件夹是否存在
    	var selectObj = document.getElementById("archiveId");
        if(selectObj){
            var archiveId=selectObj.value;
            if(archiveId == ''){
                alert(_("edocLang.edoc_alertPleaseSelectPigeonholePath"));
                enablePrecessButtonEdoc();
                return false;
            }
        }
    }
	var processId= document.getElementById("processId").value;
	var caseProcessXML = parent.parent.document.getElementById("process_xml").value;
	var top2 = window.parent.parent;
	var edocJsonStr=edocSubmitJsonStrValues();
	if(!executeWorkflowBeforeEvent("BeforeFinishWorkitem",summaryId,affair_id,processId,processId,activityId,edocJsonStr,"sendEdoc")){
		enablePrecessButtonEdoc();
        return;
    }
	sendCount++;
	if(sendCount>1){
		alert("请不要重复点击！");
		sendCount = 0;
		return;
	}
	top2.preSendOrHandleWorkflow(top2,workitemId,templeteProcessId,processId,activityId, currentUserId,caseId,currentUserAccount,edocJsonStr,
		      "sendEdoc",caseProcessXML,window,"-1",edocSubmitForm);
}
 //工作流回掉，固定函数名
 function releaseApplicationButtons(){
	enablePrecessButtonEdoc();
 }

function edocSubmitForm() {
    var obj = getProcessAndUserId();
    try {
        // 文单必填项设置--------------start
        if ((canWordNoChange && canWordNoChange != "false")
                || (canUpdateForm && canUpdateForm != "false")) {
            // 增加对公文文号长度校验，最大长度不能超过66，主要考虑归档时，doc_metadata表长度200
            if (!contentIframe.checkEdocMark()){
            	enablePrecessButtonEdoc();
            	return;
            }
            // 验证文号定义是否存在
            if (!contentIframe.checkMarkDefinition(contentIframe.sendForm)){
            	enablePrecessButtonEdoc();    	
            	return false;
            }
        }

        if (canUpdateForm && canUpdateForm != "false") {
            var value;
            var msg = "";
            var inputObj;
            var aField;
            var strTmp;
            for (var i = 0; i < contentIframe.fieldInputListArray.length; i++) {

                aField = contentIframe.fieldInputListArray[i];
                inputObj = contentIframe.document
                        .getElementById(aField.fieldName);
                if (inputObj == null || inputObj.disabled == true) {
                    continue;
                }
                if (aField.access == "edit" && aField.required == 'true'
                        && inputObj.value.length == 0) {
                    
                    alert(_("edocLang.edoc_alter_required_not_null"));
                    contentIframe.document.getElementById(aField.fieldName).focus();
                    enablePrecessButtonEdoc();
                    return false;
                }
            }
        }
        // -----------------end
        var copies = contentIframe.document.getElementById("my:copies");
        if (!checkCopies(copies)) {
        	enablePrecessButtonEdoc();
            throw new Error(edocErrortypePrint + edocReleaseLock);
            return;
        }

        if (!checkEdocMark()) {
        	enablePrecessButtonEdoc();
            throw new Error(edocErrorDocnum + edocReleaseLock);
            return;
        }
        // 插入修改督办的日志信息
        var valiSupervise = document.getElementById('valiSupervise').value;
        if (valiSupervise != "") {
            saveSuperviseLog();
        }
        // 插入修改督办的日志信息
        if (!checkNodeHasExchangeType()) {// 交换类型检测
        	enablePrecessButtonEdoc();
            return;
        }
        // 提交时检查锁
        EdocLock.checkWorkflowLock(obj.processId, obj.currentUser,
                EdocLock.SUBMIT);
        // lijl添加,状态是是3或者4并且是退回过的情况下弹出窗口-----------------------Start
        var subForm = document.theform;
        var optionType = document.getElementById("optionType").value;
        var optionId = document.getElementById("optionId").value;
        var affairState = document.getElementById("affairState").value;
        var summary_id = document.getElementById("summary_id").value;
        var affState = document.getElementById("affState").value; // xiangfan
                                                                    // 将‘affState’
                                                                    // 修改为‘affairState’
                                                                    // GOV-4767
        var isFlowBack = document.getElementById("isFlowBack").value;
        // 节点类型(shenpi、huitui...)
        var policy = document.getElementById("policy").value;
        var signFlag = true;
        // 封发节点签章判断，同时要有签章权限
        if (permKey == "fengfa" && hasSign) {
            var bodyType = document.getElementById("bodyType").value;
            if (bodyType == "OfficeWord" && bodyType == 'OfficeWord') {
                signFlag = checkIsHaveHtmlSign(firstBodyContent); // 这方法明明要传递id->传的是office正文的content
            }
        }
        // optionType=3退回时办理人选择意见覆盖方式,其他情况保留最后意见
        // optionType=4退回时办理人选择意见覆盖方式,其他情况保留所有意见
        // affairState==5 Affair的state取消：该情况取消。OA-49715
        // 意见绑定在同一个框中，当第3个处理节点回退了，第1个节点取回后提交，提示意见保留方式了，应该不提示
        // affairState==6 Affair的state回退
        // affState=16 Affair的subState被指定回退
        // affState=4 公文回退的状态
        // if(!isOutOpinions && (optionType=='3' || optionType=='4') &&
        // (affairState=='6' || affState=='16')) {//这次改动是流程状态变动
		if ((optionType == '3' || optionType == '4') && isFlowBack != "") {

            // OA-21323 后台设置意见保留方式又被退回人选择。被退回人在提交时选择"保留最后一次意见"，但是处理后，他所有的意见都保留了
            // 加了affairId参数
            var url = genericURL + "?method=optionSetup&optionId=" + optionId
                    + "&optionType=" + optionType + "&summary_id=" + summaryId
                    + "&policy=" + encodeURIComponent(policy) + "&affairId="
                    + affair_id + "&ndate=" + new Date();

            window.seletcOpinionTypeWin = getA8Top().$.dialog({
                title:'意见保留设置',
                transParams:{'parentWin':window},
                url: url,
                targetWindow:getA8Top(),
                width:"400",
                height:"350",
                closeParam: {
                    'show':true,
                    autoClose:false,
                    handler:function() {
                        window.seletcOpinionTypeWin.close();
                        enablePrecessButtonEdoc();
                    }
                  }
            });
            
        } else {
            // yangzd 在多人执行时，删除当前编辑人的编辑信息
            /*
             * var requestCaller = new XMLHttpRequestCaller(this,
             * "ajaxEdocSummaryManager", "deleteUpdateObj",false);
             * requestCaller.addParameter(1, "String", summaryId);
             * requestCaller.serviceRequest();
             */
            // OA-33739 客户bug：代理人处理公文后被代理人仍能处理
            if (deleteUpdateObjAndIsAffairEnd() == "true") {
                alert(affairHaveBeenProcessing);
                parent.doEndSign_pending(affair_id);
                enablePrecessButtonEdoc();
                return;
            }

            // dIdentifier(); //给督办人ID加标识 0|1|2
            // 修改 当前处理节点有 交换类型权限时，和封发一样要提示 请指定部门收发员
            var wfLastInput=document.getElementById("workflow_last_input").value;
        	if(finished != "true" && hasExchangeType == true) {
                if (contentIframe.checkEdocWordNo() == false) {
                	enablePrecessButtonEdoc();
                    throw new Error(edocReleaseLock); // "需要释放锁"
                    return;
                }

                checkExchangeRole({"callbackFn":_exeCheckExchangeRoleCallback});
                return;//不在继续了其余交给checkExchangeRole内部实现
                
                if (signFlag == "false") {
                    // if(!confirm("<fmt:message
                    // key='edoc.docTemplate.signAlert' />?")) {
                    // throw new Error("<fmt:message
                    // key='edoc.release.lock'/>"); //"需要释放锁"
                    //  return;
                    //}
                }
            }else{
                _exeCheckExchangeRoleCallback(true);
            }
        }

    } catch (e) {
        //如果出现了异常情况
        //比如1 印发分数个数错误，2 意见必填时，没有填写
        EdocLock.releaseWorkflowByAction(obj.processId, obj.currentUser,
                EdocLock.SUBMIT);//14    
    }
}

/**
 * 被回退者选择意见覆盖方式
 */
function seletcOpinionTypeCallback(retObj) {
    var obj = getProcessAndUserId();
    try {
        if (retObj) {

            var subForm = document.theform;

            var requestCaller = new XMLHttpRequestCaller(this,
                    "ajaxEdocSummaryManager", "deleteUpdateObj", false);
            requestCaller.addParameter(1, "String", summaryId);
            requestCaller.serviceRequest();
            // dIdentifier(); //给督办人ID加标识 0|1|2
            if (permKey == "fengfa" || hasExchangeType) {
                if (contentIframe.checkEdocWordNo() == false) {
                	enablePrecessButtonEdoc();
                    throw new Error(edocReleaseLock); // "需要释放锁"
                }
                
                checkExchangeRole({"callbackFn":_exeCheckExchangeRoleCallback});
            }else{
                _exeCheckExchangeRoleCallback(true);
            }
        }
    } catch (e) {
        // 如果出现了异常情况
        // 比如1 印发分数个数错误，2 意见必填时，没有填写
        EdocLock.releaseWorkflowByAction(obj.processId, obj.currentUser,
                EdocLock.SUBMIT);//14    
        enablePrecessButtonEdoc();
    }
}

/**
 * 执行交换角色验证
 */
function _exeCheckExchangeRoleCallback(value){
    
    if(value){
        
        var obj = getProcessAndUserId();
        try {
            var subForm = document.theform;

            if (getBrowserFlagByRequest) {
                if (!checkIsNeedTHAndGZ()) {
                	enablePrecessButtonEdoc();
                    return false;
                }
            }
            doSign(subForm, formAction);
        } catch (e) {
            // 如果出现了异常情况
            // 比如1 印发分数个数错误，2 意见必填时，没有填写
            EdocLock.releaseWorkflowByAction(obj.processId, obj.currentUser,
                    EdocLock.SUBMIT);//14     
            enablePrecessButtonEdoc();
        }
        
    }else{//验证失败
        
        var obj = getProcessAndUserId();
        
        // 如果出现了异常情况
        // 比如1 印发分数个数错误，2 意见必填时，没有填写
        EdocLock.releaseWorkflowByAction(obj.processId, obj.currentUser,
                EdocLock.SUBMIT);// 14
        
        enablePrecessButtonEdoc();
    }
}


//最后一个节点，判断是否有套红、盖章，提示用户
function checkIsNeedTHAndGZ(){
	
	var wfLastInput=document.getElementById("workflow_last_input").value;
	
	if(edocType!="1" && finished!="true" && (wfLastInput=='true' || hasExchangeType==true)) {
			
	    var bodyType = document.getElementById("bodyType").value;
	    var isNotTH=false;
	    var isNotGZ_tupian=false;//图片章
	    var isNotGZ_zhuanye=false; //专业章
	    var isNotGZ_html=false;//html章
	    var isNotGZ=false;
	   
	    try {//Chrome浏览器不支持Office控件，直接不验证了
	        if(bodyType == "OfficeWord" && getBookmarksCount()==0){ //套红
	            isNotTH=true;
	          }
	
	          if(fileId!=null && fileId!="" && checkIsHaveHtmlSign(fileId)=="false"){ //图片章
	            isNotGZ_tupian=true;
	          }else if(bodyType=="HTML" && !htmlContentIframe.isDoSignature && !htmlContentIframe.hasHtmlSign()){
	            isNotGZ_html=true;
	          }
	          try{
	              if(typeof(officeEditorFrame)!='undefined' && officeEditorFrame){
	                  var ocxObj;
	                ocxObj=officeEditorFrame.document.getElementById("WebOffice");
	                if(typeof(ocxObj)!='undefined' && ocxObj!=null && !officeEditorFrame.HasSpecialSignature(ocxObj)){//专业签章
	                	isNotGZ_zhuanye=true;
	                 	if(officeEditorFrame.getSignatureCount() > 0) {
	                 		isNotGZ_zhuanye=false;
	                 	}
	                }
	              }
	          }catch(e){
	          }
	          
	          if((isNotGZ_tupian && isNotGZ_zhuanye)||isNotGZ_html){
	              isNotGZ=true;
	          }
	          var isNotTH_alert="";
	          var isNotGZ_alert="";
	          if(isNotTH){
	            isNotTH_alert=_("edocLang.edoc_finish_taohong");
	          }
	          if(isNotGZ){
	            isNotGZ_alert=_("edocLang.edoc_finish_Signet");
	          }
	          
	          if(isNotTH || isNotGZ){
	            if(window.confirm(_("edocLang.edoc_finish_taohongAndSignet_1")+isNotTH_alert+((isNotTH_alert!="" && isNotGZ_alert!="")?_("edocLang.edoc_finish_And"):"")+isNotGZ_alert+_("edocLang.edoc_finish_taohongAndSignet_2"))==false){
	               return false;
	            }
	          }
	    } catch (e) {
	    }
	  }
  
   return true;
}
function deleteUpdateObjAndIsAffairEnd(){
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocSummaryManager", "deleteUpdateObjAndIsAffairEnd",false);
	requestCaller.addParameter(1, "String", summaryId); 
	requestCaller.addParameter(2, "String", affair_id);
	var ds = requestCaller.serviceRequest();
	return ds;
}

function predoZcdb(obj){
	disabledPrecessButtonEdoc();
	//插入修改督办的日志信息
	var valiSupervise=document.getElementById('valiSupervise').value;
	if(valiSupervise!=""){
		saveSuperviseLog();
	}
	addPDF(1);
	//插入修改督办的日志信息
	if(deleteUpdateObjAndIsAffairEnd() == "true"){
		enablePrecessButtonEdoc();
		alert(affairHaveBeenProcessing);
		parent.doEndSign_pending(affair_id);
		return;
	}	
	doZcdb(obj);
}
function disabledMemberList(){
	var memberListDiv =document.getElementById("memberList");
	memberListDiv.disabled=true;
	document.getElementById("exchangeDeptType").disabled=false;
}
function enabledMemberList(){
	var memberListDiv =document.getElementById("memberList");
	memberListDiv.disabled=false;
	document.getElementById("exchangeDeptType").disabled=true;
}
function addIdentifier(){
	var orgMemberId = document.getElementById("orgSupervisorId").value;
	var memberId = document.getElementById("supervisorId").value;
	var orgArray = orgMemberId.split(",");
	var memberArray = memberId.split(",");
	var returnId = "";
	for(var i=0;i<memberArray.length;i++){
		if(orgMemberId.value == ""){
			memberArray[i] +="|0";
			returnId += memberArray[i];
			returnId +=",";
			continue;
		}

		var bool = orgMemberId.search(memberArray[i]);
		
		if(bool != "-1" || bool != -1){
			memberArray[i] += "|0";
		}else{
			memberArray[i] += "|1";
		}
		returnId += memberArray[i];
		returnId +=",";
	}

	if(orgMemberId != ''){
		for(var i=0;i<orgArray.length;i++){
			var bool = returnId.search(orgArray[i]);
			if(bool == '-1' || bool == -1){
				orgArray[i] += "|2";
				returnId += orgArray[i];
				returnId += ",";
			}
		}
	}
	document.getElementById("supervisorId").value = returnId;
}


var checkExchangeRoleCallbackParam = {};
function checkExchangeRole(params) {
    
    params = params || params;
    var callbackFn = params.callbackFn || function(){};
    var selectDeptflag = false;
    
    var typeAndIds = "";
    var msgKey = "edocLang.alert_set_departExchangeRole";
    var obj = document.getElementById("edocExchangeType_depart");
    if (obj == null) {
        callbackFn(true);
        return true;
    }
    var selectObj = document.getElementsByName("memberList")[0];
    var selectdExchangeUserId = (selectObj.options[selectObj.selectedIndex]).value;
    var selectdExchangeUserName = (selectObj.options[selectObj.selectedIndex]).innerHTML;

    if (obj.checked) {
        // xiangfan 添加 修复GOV-4911 Start
        var list = null;
        var sendUserDeptId = "";
        
        var selectDeptObj = document.getElementsByName("exchangeDeptType")[0];
        var selectDeptIndex = selectDeptObj.selectedIndex;
        var selectDeptType = (selectDeptObj.options[selectDeptIndex]).value;
        
        if(selectDeptType == "Creater"){
            list = createrExchangeDepts;
            msgKey = "edocLang.alert_set_departExchangeRole";
        }else {
            list = deptSenderList;
            msgKey = "edocLang.alert_set_dispatcherExcahgeRole";
        }
        
        if (list != null && list != "undifined" && list != "") {
            var _url = genericControllerURL
                    + "edoc/selectDeptSender&memberList="
                    + encodeURIComponent(list);
            var listArr = list.split("|");
            if (listArr.length > 1) {
                
                checkExchangeRoleCallbackParam.msgKey = msgKey;
                checkExchangeRoleCallbackParam.selectdExchangeUserName = selectdExchangeUserName;
                checkExchangeRoleCallbackParam.callbackFn = callbackFn;
                selectDeptflag = true;
                
                window.checkExchangeRoleWin = getA8Top().$.dialog({
                    title : '选择交换部门',
                    transParams : {
                        'parentWin' : window,
                        'popWinName' : 'checkExchangeRoleWin',
                        'popCallbackFn' : checkExchangeRoleCallback
                    },
                    url : _url,
                    targetWindow : getA8Top(),
                    width : "342",
                    height : "185"
                });

            } else if (listArr.length == 1) {
                    sendUserDeptId = listArr[0].split(',')[0];
                    document.getElementById("returnDeptId").value = sendUserDeptId;
                }
            }
        
        // xiangfan 添加 修复GOV-4911 End
        if(!selectDeptflag){
            typeAndIds = "Department|" + sendUserDeptId;
            selectdExchangeUserId = "";
        }
    } else {
        typeAndIds = "Account|" + sendUserAccountId;
        msgKey = "edocLang.alert_set_accountExchangeRole";
    }
    
    if(!selectDeptflag){
        _exeCheckExchangeRole(typeAndIds, selectdExchangeUserId, msgKey, selectdExchangeUserName, callbackFn);
    }
}

/**
 * 执行交换角色验证
 * @param typeAndIds
 * @param selectdExchangeUserId
 * @param msgKey
 * @param callbackFn
 */
function _exeCheckExchangeRole(typeAndIds, selectdExchangeUserId, msgKey, selectdExchangeUserName, callbackFn){
    var requestCaller = new XMLHttpRequestCaller(this,
            "ajaxEdocExchangeManager", "checkExchangeRole", false);
    requestCaller.addParameter(1, "String", typeAndIds);
    requestCaller.addParameter(2, "String", selectdExchangeUserId);
    var ds = requestCaller.serviceRequest();
    if (ds == "check ok") {
        callbackFn(true);
    } else if (ds == "changed")// xiangfan 添加逻辑判断
    {
        alert(edocCancelExchangePrivileges1 + selectdExchangeUserName
                + edocCancelExchangePrivileges2);
        callbackFn(false);
    } else {
        alert(_(msgKey, ds));
        callbackFn(false);
    }
}

/**
 * 分发部门选择回调函数
 * 
 * @returns
 */
function checkExchangeRoleCallback(sendUserDepartmentId) {
    
    var msgKey = checkExchangeRoleCallbackParam.msgKey;
    var selectdExchangeUserName = checkExchangeRoleCallbackParam.selectdExchangeUserName;
    var callbackFn = checkExchangeRoleCallbackParam.callbackFn;
    
    if (sendUserDepartmentId == "cancel"
            || typeof (sendUserDepartmentId) == 'undefined') {

        // 取消或者直接点击关闭
        callbackFn(false);
    }else{
        document.getElementById("returnDeptId").value = sendUserDepartmentId;
        var typeAndIds = "Department|" + sendUserDepartmentId;
        var selectdExchangeUserId = "";
        _exeCheckExchangeRole(typeAndIds, selectdExchangeUserId, msgKey, selectdExchangeUserName, callbackFn);
    }
}

function brighter(id){
    timerBrighter = window.setInterval("menuItemIn('" + id + "')", 50);
    window.clearInterval(timerDarker);
}

function menuItemIn(id){
	if(document.getElementById(id).filters.alpha.opacity < 100){
		document.getElementById(id).filters.alpha.opacity += 10;
    }else{
		window.clearInterval(timerBrighter);
    }
}
function darker(id){
	timerDarker = window.setInterval("menuItemOut('" + id + "')", 50);
	window.clearInterval(timerBrighter);
}

function menuItemOut(id){
    if(document.getElementById(id).filters.alpha.opacity > 0){
		document.getElementById(id).filters.alpha.opacity -= 10;
    }else{
		window.clearInterval(timerDarker);
		
		if(document.getElementById(id).filters.alpha.opacity <= 0) {
			document.getElementById(id).style.display = "none";
		}
    }
}

/**
 * 打开公文督办列表
 * @param summaryId
 */
function openSuperviseWindow(summaryId){
    var mId = document.getElementById("supervisorId");
    var sDate = document.getElementById("awakeDate");
    var sNames = document.getElementById("supervisors");
    var title = document.getElementById("superviseTitle");
    var count = document.getElementById("count");

    var unCancelledVisor = document.getElementById("unCancelledVisor");
    var sfTemp = document.getElementById("sVisorsFromTemplate");
    var urlStr ="edocSupervise.do?method=superviseWindow";
    if(mId.value != null && mId.value != ""){
        urlStr += "&supervisorId=" + mId.value + "&supervisors=" + encodeURIComponent(sNames.value) 
        + "&superviseTitle=" + encodeURIComponent(title.value) + "&awakeDate=" + sDate.value  + "&sVisorsFromTemplate="+sfTemp.value +"&unCancelledVisor="+unCancelledVisor.value + "&count="+count.value;
    }

    window.openSuperviseWindowWin = getA8Top().$.dialog({
        title:'公文督办',
        transParams:{'parentWin':window},
        url: urlStr,
        targetWindow:getA8Top(),
        width:"400",
        height:"300"
    });
}

/**
 * 督办回调函数
 */
function openSuperviseWindowCallback(rv){
    if(rv!=null && rv!="undefined"){
        
        var isDeleteSupervisior = document.getElementById("isDeleteSupervisior");
        var mId = document.getElementById("supervisorId");
        var sDate = document.getElementById("awakeDate");
        var sNames = document.getElementById("supervisors");
        var title = document.getElementById("superviseTitle");
        
        try{
            document.getElementById('valiSupervise').value="1";
        }catch(e){
        }
         var sv = rv.split("|");
         if(sv.length == 4){
             mId.value = sv[0]; //督办人的ID(添加标识的，为的是向后台传送)
             sDate.value = sv[1]; //督办时间
             sNames.value = sv[2]; //督办人的姓名
             title.value = sv[3];
         }else if(sv.length == 5){
             mId.value = sv[0]; //督办人的ID(添加标识的，为的是向后台传送)
             sDate.value = sv[1]; //督办时间
             sNames.value = sv[2]; //督办人的姓名
             title.value = sv[3];
             isDeleteSupervisior.value = sv[4];//取消督办
         }
     }
}

function showDigarm(id,fromSupervis) {
	//和协同保持一致，不在验证权限，因为能看到这个按钮的都是有权限的
	/*//判断是否当前用户是否仍然是公文督办人
	 if(!isStillSupervisor(summaryId)){
		if(!window.dialogArguments)
			parent.location.href = parent.location.href;
		else
			window.close();
		return false;
	} */
	var top2 = window.parent;
	var isOpenFrom=isOpenFrom;
	if(isOpenFrom == 'supervise'||fromSupervis=='fromSupervis'){//督办默认节点权限是 阅读
		var nodeId="shenpi";
		var nodeName=nodePpolicyShenpi;
		
		//收文督办默认节点权限是 阅读
		if("recEdoc"==appNameNode){
			nodeId="yuedu";
			nodeName=nodePolicyYuedu;
		}		top2.editWFCDiagramEdocModalDialog(window.getA8Top(),caseId,processId,window,appNameNode,templateFlag, flowPermAccountId,nodeId,nodeName,editRefreshWorkflow,false,superviseEdocLabel);
	}else{
		top2.editWFCDiagram(window.getA8Top(),caseId,processId,window,appNameNode,templateFlag, flowPermAccountId,"shenhe","审核",editRefreshWorkflow,superviseEdocLabel);
	}
}
function editRefreshWorkflow(callBackObj){
    var wfurl = "workflow/designer.do?method=showDiagram&isTemplate="+templateFlag+"&isDebugger=false&scene="+scene+"&processId="+processId+"&caseId="+caseId+"&currentNodeId="+activityId+"&appName=edoc&showHastenButton=true";
    
    $("#monitorFrame").attr("src",encodeURI(wfurl));
}
function showPrecessAreaTd(type){
	//cx  
	if(type!="pdf"){
		//如果是火狐浏览器
		if(navigator.userAgent.indexOf("Chrome")>0 || navigator.userAgent.indexOf("Firefox")>0){
			if(pdfIframe.HWPostil1&&pdfIframe.HWPostil1.lVersion){
				var newPDFId = saveWebAip(pdfIframe.HWPostil1,summaryId,url2);
				PDFId = newPDFId;
			}
		}
	}
	///
	
	if(type=='content'){
		//非IE浏览器，打开Office正文给出提示
		var bodyType = document.getElementById("bodyType").value;

		if(!v3x.isMSIE&&bodyType=="gd"){
			alert("当前浏览器不支持GD正文，请您使用IE浏览器");
			return;
		}


	}
	var edocformTR = document.getElementById('edocformTR');
	var contentTR = document.getElementById('contentTR');
	var workflowTR = document.getElementById('workflowTR');
	var content1TR = document.getElementById('content1TR');
	var content2TR = document.getElementById('content2TR');
	var pdfTR = document.getElementById('pdfTR');
	
	var edocform_input = document.getElementById('edocform_btn');
	var content_input = document.getElementById('content_btn');
	var workflow_input = document.getElementById('workflow_btn');
	var content1_input = document.getElementById('content1_btn');
	var content2_input = document.getElementById('content2_btn');
	var pdf_input = document.getElementById('pdf_btn');

	var hasBody1_flag = hasBody1;
	var hasBody2_flag = hasBody2;
	function initSet(){
		if(contentTR)contentTR.style.display = 'none';
		if(content1TR)content1TR.style.display = 'none';
		if(content2TR)content2TR.style.display = 'none';

		if(edocform_input)edocform_input.className = 'deal_btn_l';
		if(workflow_input)workflow_input.className = 'deal_btn_m';
		if(pdf_input)pdf_input.className = 'deal_btn_m';
		if(hasBody1_flag == 'true' || hasBody2_flag == 'true'){
			if(content_input)content_input.className = 'deal_btn_m';
		}else{
			if(content_input)content_input.className = 'deal_btn_r';
		}
		if(content1_input)content1_input.className = 'deal_btn_r';
		if(content2_input)content2_input.className = 'deal_btn_r';
		if(onlySeeContent == "false"){
			if(content_input)content_input.className = 'deal_btn_m';
			if(content1_input)content1_input.className = 'deal_btn_m';
			if(content2_input)content2_input.className = 'deal_btn_m';
			if(workflow_input)workflow_input.className = 'deal_btn_r';
		}
		
	}
	var bodyType = document.getElementById("bodyType").value;
	if((type == "content" || type == "content1" || type == "content2") && bodyType != "HTML"){
		//当前点击正文按钮，并且是非HTML正文时，按钮样式不变化
	}
	else{
		initSet();
	}
	
	if(type == 'edocform'){
		if(edocformTR)edocformTR.style.display = '';
		if(workflowTR)workflowTR.style.display = 'none';
		if(edocform_input)edocform_input.className = 'deal_btn_l_sel';
		if(pdfTR)pdfTR.style.display='none';
	}
	else if(type == 'workflow'){
		if(pdfTR)pdfTR.style.display='none';
		if(edocformTR)edocformTR.style.display = 'none';
		var wfUrl= 'workflow/designer.do?method=showDiagram&isTemplate='+templateFlag+'&isDebugger=false&scene='+scene+'&isModalDialog=false&caseId='+caseId+'&showHastenButton='+showHastenButton+'&appName=edoc&currentNodeId='+activityId+"&wendanId="+wendanId;
		if(affairState == '1'){//协同-待发
		  wfUrl+="&currentUserName="+encodeURIComponent(currentUserName)+"&currentUserId="+currentUserId;
		  if(scene=='3'){
		    wfUrl+="&processId="+processId;
		  }else{
		    wfUrl+="&processId="+templeteProcessId;
		  }
		}else{
		  wfUrl+="&processId="+processId;
		}
		$("#monitorFrame").attr('src',wfUrl);
		if(workflowTR){
			workflowTR.style.display = '';
			
			//流程图
			$("#workflowTR table").height($("#workflowTR").height());
		}
		workflow_input.className = 'deal_btn_r_sel';
	}
	else if(type == 'content'){
		if(contentTR && bodyType == "HTML"){
			if(edocformTR)edocformTR.style.display = 'none';
			if(workflowTR)workflowTR.style.display = 'none';
			if(pdfTR)pdfTR.style.display='none';
			contentTR.style.display = '';
			content_input.className = 'deal_btn_m_sel';
			$("#htmlContentDiv").width($("#hhhhhhh").width()-100);
			if(!hasLoadHtmlSign && onlySeeContent != 'true'){
				var canDeleteISigntureHtml = paramFrom == 'sended' || paramFrom == 'Done' || paramFrom == 'listSent' ? "false":"true";
				var isShowMoveMenu = paramFrom=='sended' || paramFrom=='Done' || paramFrom == 'listSent' ? "false":"true";
				var isShowDocLockMenu = paramFrom =='sended' || paramFrom == 'Done' || paramFrom == 'listSent' ? "false":"true";
			    htmlContentIframe.loadSignatures(summaryId,canDeleteISigntureHtml,isShowMoveMenu,isShowDocLockMenu,3);
			    hasLoadHtmlSign = true;
			}
		}
		else{
			LazyloadOffice('0');
		}
	}
	else if(type == 'content1'){
		if(contentTR && bodyType == "HTML"){
			if(edocformTR)edocformTR.style.display = 'none';
			if(workflowTR)workflowTR.style.display = 'none';
			if(pdfTR)pdfTR.style.display='none';
			content1TR.style.display = '';
			content_input.className = 'deal_btn_m_sel';
		}
		else{
			LazyloadOffice('1');
		}
	}
	else if(type == 'content2'){
		if(contentTR && bodyType == "HTML"){
			if(edocformTR)edocformTR.style.display = 'none';
			if(workflowTR)workflowTR.style.display = 'none';
			if(pdfTR)pdfTR.style.display='none';
			content2TR.style.display = '';
			content_input.className = 'deal_btn_m_sel';
		}
		else{
			LazyloadOffice('2');
		}
	}else if(type == "pdf"){
		if(edocformTR)edocformTR.style.display = 'none';
		if(pdfTR)pdfTR.style.display = 'block';
		if(workflowTR)workflowTR.style.display = 'none';
		if(edocform_input)pdf_input.className = 'deal_btn_m_sel';
		if(PDFId!=''){
			if(showPDFflag){
				$("#pdfIframe").attr('src',detailURL+"?method=getContent&summaryId="+summaryId+"&affairId="+affair_id+"&isPDF=1");
				showPDFflag = false;
			}
			var i=0;
			if(_fileType=='pdf'){
				var sh1 = setInterval(function(){
					if(pdfIframe.iWebPDF2015&&pdfIframe.iWebPDF2015.Version){//如果加载到pdf控件，赋值到pdf
						mapPDF(pdfIframe.iWebPDF2015,"contentIframe");
						for(var i=0;i<contentIframe.opinions.length;i++){  
							var a = contentIframe.opinions[i];  // 获取对象
							$("#ceceshi").html(a[1].toString().replaceAll("<br\/>","\n"));   // a[0] 流程名称  a[1] html值
							var str = "";
							$("#ceceshi").find(">*").each(function(index){
								str += $(this).text()+"\n";
							});
							pdfIframe.iWebPDF2015.Documents.ActiveDocument.Fields(a[0].toString()).Value = str; 
						}
						clearInterval(sh1);
					}
					i++;
					if(i>=5){
						clearInterval(sh1);
					}
				},100);
			}else if(_fileType=="aip"){
				var sh1 = setInterval(function(){
					if(pdfIframe.HWPostil1&&pdfIframe.HWPostil1.lVersion){//如果加载到pdf控件，赋值到pdf
						if(pdfIframe.HWPostil1.IsOpened){
							for(var i=0;i<contentIframe.opinions.length;i++){  
								var a = contentIframe.opinions[i];  // 获取对象
								$("#ceceshi").html(a[1].toString().replaceAll("<br\/>","\n").replaceAll("<div","\n<div"));   // a[0] 流程名称  a[1] html值
								var str = "";
								str = $("#ceceshi").text();
								pdfIframe.HWPostil1.SetValue(a[0].toString(),"");
								pdfIframe.HWPostil1.SetValue(a[0].toString(),str); 
							}
							setEdocSummaryData(pdfIframe.HWPostil1,"contentIframe");
							clearInterval(sh1);
						}
					}
					i++;
					if(i>=5){
						clearInterval(sh1);
					}
				},100);
			}
			
		}
	}
	
}
String.prototype.replaceAll = function(s1,s2) { 
    return this.replace(new RegExp(s1,"gm"),s2); 
}
//跟踪相关
function setTrackRadiio(v){
	var obj = document.getElementById("isTrack");
	if(obj!=null){
		var all = document.getElementById("trackRange_all");
		var part = document.getElementById("trackRange_part");
		if(obj.checked){
			 all.disabled = false;
			 part.disabled = false;
			 all.checked = true;
		}else {
			all.disabled = true;
			part.disabled = true;
			all.checked = false;
			part.checked = false;
		}
	}
	//checkMulitSign(v);
}

function setTrackCheckboxChecked(){
	var obj = document.getElementById("pipeonhole");
	if(obj!=null){
		if(obj.checked){
			//obj.checked = false;
			//alert(_("edocLang.edoc_alertSignAfterOption"));
		}
		
	}
	 var partText = document.getElementById("zdgzryName");
	 partText.style.display="none";
	var obj = document.getElementById("isTrack");
	if(obj!=null){
		obj.checked = true;
	}
}
function selectPeopleFunTrackNewCol(){
	var obj = document.getElementById("pipeonhole");
	if(obj!=null){
		if(obj.checked){
			//obj.checked = false;
			//alert(_("edocLang.edoc_alertSignAfterOption"));
		}
	}
	var all = document.getElementById("trackRange_all");
    if(all.checked==true){
    	 var partText = document.getElementById("zdgzryName");
    	 partText.style.display="none";
    }else{
    	 var partText = document.getElementById("zdgzryName");
    	 partText.style.display="";
    }
	//setTrackCheckboxChecked();
	selectPeopleFun_track();
}
function setPeople(elements){
	var tarckName="";
	var memeberIds = "";
	if(elements){
		for(var i= 0 ;i<elements.length ; i++){
			if(memeberIds ==""){
				memeberIds = elements[i].id;
			}else{
				memeberIds +=","+elements[i].id;
			}
			 tarckName+=elements[i].name+",";
		}
		document.getElementById("trackMembers").value = memeberIds;
		trackNameFun(tarckName);
	}
}
//点击确认或者暂存待办前，把文单中意见处理框的值传递到此页面
function beforeSubmitButton(){
	isCheckContentEdit=false;//提交的时候是不检查正文是否修改的
  	//意见态度
   	var childrenPageAttitude = contentIframe.document.getElementsByName("attitude");
  	if(childrenPageAttitude){
      for(var i=0;i<childrenPageAttitude.length;i++){
         if(childrenPageAttitude[i].checked==true){
        	 document.getElementsByName("attitude")[i].checked=true;
         }
      }
  	}
  	//意见处理
  	if(typeof(contentIframe)!="undefined"&&contentIframe.document.getElementById("contentOP")){
    	theform.contentOP.value=contentIframe.document.getElementById("contentOP").value;
  	}
}
//修改人：杨帆 2012-2-15———定义显示意见处理输入栏和常用语等变量 --end
function readLoading(){
	  //判断是否可以直接修改文单
	  if(paramFrom =='Pending' && canUpdateForm=="true" && affairSubState!='15'){
	    contentIframe.UpdateEdocForm(summaryId);
	  }
	  //显示意见框到文单中
	  if(paramFrom=='Pending' && (canShowOpinion=="true"|| canShowAttitude=="true" )){
	    contentIframe.showOpinionsInputForm();
      }
}
function cbfun(){
    try{htmlContentIframe.releaseISignatureHtmlObj();}catch(e){}
    if(typeof(beforeCloseCheck) =='function'){
       return beforeCloseCheck();
    }
}
function unlock(){
    unLoad(summary_processId, summaryId,currentUserId);
}
//选择了加签的人员之后，调用的刷新流程图的方法
function refreshWorkflow(callBackObj){
    var wfurl = "workflow/designer.do?method=showDiagram&isTemplate="+templateFlag+"&isDebugger=false&scene="+scene+"&processId="+processId+"&caseId="+caseId+"&currentNodeId="+activityId+"&appName=edoc&showHastenButton=false";

    var xml = parent.parent.document.getElementById("process_xml").value;
    var json = parent.parent.document.getElementById("readyObjectJSON").value;
    var addNodeJson = parent.parent.document.getElementById("processChangeMessage").value;
    $("#processChangeMessage").attr("value",addNodeJson);
    $("#process_xml").attr("value",xml);
    $("#readyObjectJSON").attr("value",json);
    $("#monitorFrame").attr("src",encodeURI(wfurl));
    
    var edocformTR = document.getElementById('edocformTR');
    var workflowTR = document.getElementById('workflowTR');
	var pdfTR = document.getElementById('pdfTR');
    if(edocformTR)edocformTR.style.display = 'none';
    if(workflowTR)workflowTR.style.display = '';
	if(pdfTR)pdfTR.style.display = 'none';
	var pdf_input = document.getElementById('pdf_btn');
    if(pdf_input)pdf_input.className = 'deal_btn_m';
	
    var edocform_input = document.getElementById('edocform_btn');
    if(edocform_input)edocform_input.className = 'deal_btn_l';
    var workflow_input = document.getElementById('workflow_btn');
    workflow_input.className = 'deal_btn_r_sel';
    if(typeof(callBackObj) != 'undefined'){
        if(callBackObj.messageDataList){
    		document.getElementById("process_message_data").value=(callBackObj.messageDataList);
        } 
	}
	var contentTR = document.getElementById('contentTR');
	var content1TR = document.getElementById('content1TR');
	var content2TR = document.getElementById('content2TR');
	if(contentTR)contentTR.style.display = 'none';
	if(content1TR)content1TR.style.display = 'none';
	if(content2TR)content2TR.style.display = 'none';
	var content_input = document.getElementById('content_btn');
	if(content_input)content_input.className = 'deal_btn_m';
}

//正文被修改，关闭窗口时弹出提示
function summaryChange(){
	if(!(window.parentDialogObj && window.parentDialogObj['dialogDealColl'])){
		confirmClose();
	}
}

function confirmClose(){
	var mute = arguments.length > 0;
	if($.browser.mozilla){
		window.onbeforeunload=function (e){
			if(!mute){
				return edocLang.edoc_update_content_alert_confirm;
			}
		}
	}else{
		document.body.onbeforeunload = function(){
			// submit时屏蔽提示
			if(!mute){
				window.event.returnValue = edocLang.edoc_update_content_alert_confirm;
			}
		};
	}
}

//提交或暂存待办时要取消离开弹出框
function cancelConfirm(){
	document.body.onbeforeunload = null;
	window.onbeforeunload = null;
}

function edocTaohong(templateType){
	//永中office不支持wps正文修改
	if(templateType == 'edoc'){//正文套红
		var isYozoWps = checkYozo();
		if(isYozoWps){
			return;
		}
	}
	taohong(templateType);
	summaryChange();
}

//调用工作流加签接口
function edocInsertPeople(workitemId,processId,activityId,performer,caseId){
  //OA-42082 收文待办进行加签，默认的节点权限应该是阅读，不是审批
   var policyName = edocType=='0' || edocType=='2' ? "审批" : "阅读";
   parent.parent.insertNode(workitemId,processId,activityId,performer,caseId,appNameNode,false,policyName,wOrgAccountId,refreshWorkflow);
}
function assignNode(workitemId,processId,activityId,performer,caseId){
	  parent.parent.assignNode(workitemId,processId,activityId,performer,caseId,appNameNode,false,"huiqian",wOrgAccountId,refreshWorkflow);
}
//多级会签调用接口
function multistageSign(summaryId, processId, affairId){
	parent.parent.multistageSign(
			appNameNode,
			summaryId,
			affairId,
			currentUserId,
	        workitemId,
	        processId,
	        currentNodeId,
	        currentUserId,
	        currentUserName,
	        currentUserAccount,
	        flowPermAccountId,
	        null,
	        null,
	        sessionScopeDepartmentId,refreshWorkflow);
}
//调用工作流减签接口
function edocDeletePeople(workitemId,processId,activityId,performer,caseId){
	parent.parent.deleteNode(workitemId,processId,activityId,performer,caseId,refreshWorkflow,summaryId,affair_id,refreshWorkflow);
}
//调用工作流知会接口
function addInform(workitemId,processId,activityId,performer,caseId){
    parent.parent.informNode(workitemId,processId,activityId,performer,caseId,appNameNode,false,"zhihui",wOrgAccountId,refreshWorkflow); 
}
function TransmitToBulletin(){
	//如果是书生交换的收文，不允许转发 START
		if('gd'==bodyType){
			alert(_("edocLang.edoc_forward_bulletin"));
			return;
		}
	//如果是书生交换的收文，不允许转发 END
	  if(ocxContentIsModify()==true)
	  {//正文为修改状态，是否进行保存
	      if(window.confirm(_("edocLang.content_modify_info")))
	      {
	          if(!saveContent()){return;}
	      }
	      
	  }
	  //Ajax判断是否有发布新闻、公告的权限
	  var requestCaller = new XMLHttpRequestCaller(this, "edocManager", "AjaxjudgeHasPermitIssueNewsOrBull", false);
	  requestCaller.addParameter(1, "String", 'bulletionaudit');
	  var rs = requestCaller.serviceRequest();
	  if(rs == "false"){
	      alert(_("edocLang.edoc_alertNoPermitBull"));//您沒有發布權限!
	      return ;
	  }
	  var type = "edoc";
	  edocBulletinIssue(summaryId,bodyType,bulletinIssueBack,type);
	}
	function bulletinIssueBack(rv){
	  if(rv){
	    alert(v3x.getMessage("edocLang.edoc_transferred_announcement"));
	  }
	  
	}
	//调用工作流传阅接口
	function passRead(){
	  parent.parent.passRead(workitemId,processId,activityId,performer,appNameNode,
			  wOrgAccountId,summaryId,affair_id,departmentId,refreshWorkflow);
	}
	function showPushWindowEdoc(summaryId){
		  var edocType ="";
		  var obj = document.getElementById("edocType");
		  var pushMessageMemberIds = document.getElementById("pushMessageMemberIds");
		  if(obj){
		      edocType = obj.value;
		  }
		  var selected  =  document.getElementById("pushMessageMemberIds").value;
		  var url =  "edocController.do?method=showPushWindow"
		                           +"&summaryId="+summaryId
		                           +"&edocType="+edocType
		                           +"&sel="+encodeURIat(selected);
		  var replyedAffairId = document.getElementById("replyedAffairId");
		  
		  if(replyedAffairId!=null && typeof(replyedAffairId)!='undefined'){
		      url+="&replyedAffairId="+replyedAffairId.value;
		  }
		  getA8Top().win123 = getA8Top().$.dialog({
			  title:colChooseMessageRecevier,
			  transParams:{'parentWin':window},
			  url: url,
			  height:350,
			  width:300
		      });
		  
		}
	function showPushWindowCallback(ret){
		if(typeof(ret) != 'undefined' && ret != null){ 
		    //直接取消的时候返回undefined。没有选择点确定的时候返回为空
		    var memberIds = ret[0];
		    var memberNames = ret[1];
		    document.getElementById("pushMessageMemberIds").value = memberIds;
		    var pushMessageMemberNames  = document.getElementById("pushMessageMemberNames");
		    if(pushMessageMemberNames && replyedAffairId != replyedAffairId.value){
		        pushMessageMemberNames.value = memberNames;
		        pushMessageMemberNames.title = memberNames;
		    }
		  }
	}
	function onbeforeunloadEdocDetail() {
	    if(clickFlag) {
	        clickFlag = false;  
	        document.body.onbeforeunload = null;
	        try{
	          //如果从已发中打开，值是取不到的
	          var processId = document.getElementById('processId').value;
	          var currentUserId = document.getElementById('ajaxUserId').value;
	          var rs = EdocLock.releaseWorkflow(processId, currentUserId);
	        }catch(e){
	        }
	        
	    }
	}
	function _hideButton(){
		$("#wfzsbutton,#wflczs1").hide();//流程追溯
		$("#mxrz1,#sxzt1").hide();
		$("#edoc_print").hide();
	}
	function edocShowNodeExplain(){
	      var dialog = parent.parent.$.dialog({
	        url: "edocController.do?method=edocShowNodeExplain&affairId="+affair_id+"&templeteId="+summaryTempleteId+"&processId="+summary_processId,
	        width:300,
	        height:200,
	        title:workflowNodePropertyDealExplain, //节点权限操作说明
	        targetWindow:top,
	        buttons : [ {
	            text : permissionClose,//关闭
	            handler : function() {
	              dialog.close();
	            }
	          } ]
	        });
	}
	function TurnRecEdoc(){
		var _height=410;
		//aJax判断
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocExchangeManager", "checkTurnRec",false);
		requestCaller.addParameter(1, "String", summaryId);
		var ds = requestCaller.serviceRequest();
		if(ds=="true"){//已经被转发过了
			_height=100;
		}
		p_getCtpTop().turnRecDialog = p_$().dialog({
		        url: "exchangeEdoc.do?method=openTurnRec&summaryId="+summaryId,
		        width:500,
		        height:_height,
		        title:permissionOperationTurnRecEdoc, //节点权限操作说明
		        targetWindow:getA8Top(),
		        isClear:false
	        });
	}

	function showTurnRecInfo(){
		p_getCtpTop().turnRecInfoDialog = p_$().dialog({
	        url: "exchangeEdoc.do?method=openTurnRecInfo&summaryId="+summaryId,
	        width:500,
	        height:450,
	        title:edoc_turn_rec_info, //节点权限操作说明
	        targetWindow:getA8Top(),
	        isClear:false,
	        buttons : [ {
	            text : permissionClose,//关闭
	            handler : function() {
	              p_getCtpTop().turnRecInfoDialog.close();
	            }
	          } ]
	        });
	}
	$(document).ready(function() {
		if(isFromSDL =="repealRecord" || isFromSDL =='stepBackRecord'){//撤销的时候屏蔽按钮
			$("#wfzsbutton,#wflczs1").hide();//流程追溯
			$("#mxrz1,#sxzt1").hide();
			$("#edoc_print").hide();
			$("#edoc_attachment").hide();
		}
		if(isCollCube =='1' || isColl360 == '1'){
			//_hideButton();
		}
		if($("#processAdvanceDIV > div").length == 0){
			$("#processAdvance").hide();
		}
		try{
			//20160127 -bug-处理意见填写框中默认的空白字符
		    $("#contentOP").val($("#contentOP").val().replace(/\s+/g,'').replace(/\n/,'').trim());
		}catch(e){}
});
	
	//开始
	if(_sysAdminFlag){
	   	getDom();
	}
	function getDom(){
	    if(xmlDoc == null){
	        try{
	            xmlDoc = new ActiveXObject( "SeeyonFileDownloadLib.SeeyonFileDownload");
	            xmlDoc.AddUserParam(_userLocale, _userLoginName, _sessionId, _curUserId);
	        }catch(ex1){
	          /**
	           * TODO:暂时屏蔽控件加载异常
	           */
	            //alert("批量下载控件加载错误 : " + ex1.message);
	        }
	    }
	    return xmlDoc;
	}
	//结束
	
	
	//js最后加载

	$(document).ready(function(){
		if(v3x.isIpad){
			$('#easyui-layout').css({'width':1024,'height':768});
			$('body').layout().resize();
		}

		//浏览器兼容设置---start
		try{
		    $("#hhhhhhh,#signAreaTable,#contentIframe,#scrollContentTd div").height($("body").height()-document.getElementById("hhhhhhh").getBoundingClientRect().top);
		}catch(e){}
		try{$("#iSignatureHtmlDiv,#inputPosition").css("height","1px");}catch(e){}
		//流程图
		//已经在showPrecessAreaTd方法设置，具体点击流程图的页签时候再调整，避免OA-51198
		//$("#workflowTR table").height($("#workflowTR").height());
		$(window).resize(function(){
		    try{
			    $("#hhhhhhh,#signAreaTable,#contentIframe,#scrollContentTd div").height($("body").height()-document.getElementById("hhhhhhh").getBoundingClientRect().top);
		    }catch(e){}
			$("#iSignatureHtmlDiv,#inputPosition").css("height","1px");
			//流程图
			$("#workflowTR table").height($("#workflowTR").height());
		});
		//浏览器兼容设置---end
        var validationSubState=document.getElementById("affState");
        if(null !=validationSubState && validationSubState != ''){
            var subStateValues = validationSubState.value;
            //退回人打开信息操作控制
            if(specialStepBack=="false" && (subStateValues =='15'  || subStateValues =='17' || subStateValues =='19')){
                canEdit=false;
                $(".validationStepback").attr('disabled','disabled').attr("href","javascript:void(0);").attr("onclick","javascript:;").css("color","#ccc");
            }
            //被指定回退节点以及中间节点,打开信息操作控制
            if(specialStepBack=="false" && (subStateValues =='16' || subStateValues =='17')){
                $(".validationStepback1").attr('disabled','disabled').attr("href","javascript:void(0);").attr("onclick","javascript:;").css("color","#ccc");
            }
            //指定回退的中间节点，屏蔽退回、指定回退,specialStepBack=false验证为当前流程为指定回退流程
            if(specialStepBack=="false" && subStateValues !='16' && subStateValues !='17'){
                $(".validationStepback2").attr('disabled','disabled').attr("href","javascript:void(0);").attr("onclick","javascript:;").css("color","#ccc");
            }
        }
	});
	var edocExchangeFlagObj = hasExchangeType;
	if(edocExchangeFlagObj=="true"){
		//封发节点和【交换类型】节点权限都显示
	if ((permKey == "fengfa")||(edocExchangeFlagObj=="true")) {
	 var companyRadioObj = document.getElementById("edocExchangeType_company");
		  if(companyRadioObj!=null && companyRadioObj.checked){
			  enabledMemberList();
		  }
		}
	}
	
	function windowResizeTop() {
		$("#hhhhhhh,#signAreaTable,#contentIframe,#scrollContentTd div").height($("body").height()-document.getElementById("hhhhhhh").getBoundingClientRect().top);
		$("#iSignatureHtmlDiv,#inputPosition").css("height","1px");
		//流程图
		if($("#workflowTR").css("display")!='none') {
			$("#workflowTR table").height($("#workflowTR").height());
		}
	}

  if(document.getElementById("AddCalEventDIV")) {
	  if(resources.indexOf("F02_eventlistK")>-1){
		document.getElementById("AddCalEventDIV").style.display="block";	
	  }else{
	    document.getElementById("AddCalEventDIV").style.display="none";	
	  }
  }
  
//截取跟踪指定人长度
  function trackNameFun(res){
  	var userName="";
  	var nameSprit="";
    userName=res.substring(0,res.length-1);
    //只显示前三个名字
    nameSprit=res.split(",");
    if(nameSprit.length>3){
    	nameSprit=res.split(",", 3);
    	nameSprit+="...";
    }
    $("#zdgzryName").attr("title",userName);
  	var partText = document.getElementById("zdgzryName");
  	partText.style.display="";
  	partText.style.width="82px";
  	 $("#zdgzryName").val(nameSprit);
  }
  
/**
  * 在子页面点击插入附件后回调函数
 */
function _insertAttCallback(){
	var topicIfram = document.getElementById("contentIframe");
	if(topicIfram && topicIfram.contentWindow){
		topicIfram.contentWindow.reloadParentAtt();//调用子页面的回调方法
	}
}
function callBck(data){
	//关闭日期控件窗口
	window.parent.getA8Top().date_win.close();
    if (data != "") {
    	var now = new Date();// 当前系统时间
		var days = data.substring(0, data.indexOf(" "));
		var hours = data.substring(data.indexOf(" "));
		var temp = days.split("-");
		var temp2 = hours.split(":");
		var d1 = new Date(parseInt(temp[0], 10), parseInt(temp[1], 10) - 1,
				parseInt(temp[2], 10), parseInt(temp2[0], 10), parseInt(
						temp2[1], 10));
		if (d1.getTime() < now.getTime()) {
			// GOV-3460 公文管理，设置暂存代办 提醒时间时，设置小于当前时间也能成功
			document.getElementById("nowzcdbTime").value = "";
			alert(_("edocLang.edoc_zcdb_remind_later_than_now"));
			return false;
		}
		doSelectZcdbTime();
	}
   
}
function selectDateTime(request, obj, width, height) {
	var isChrome=v3x.isChrome;
	if(isChrome){//Chrome浏览器单独处理
		whenstart(request, obj, width, height, 'datetime',null,270, 270,{'callBackFun':callBck});
	}else{
		whenstart(request, obj, width, height, 'datetime');
		if (obj.value != "") {
			var now = new Date();// 当前系统时间
			var days = obj.value.substring(0, obj.value.indexOf(" "));
			var hours = obj.value.substring(obj.value.indexOf(" "));
			var temp = days.split("-");
			var temp2 = hours.split(":");
			var d1 = new Date(parseInt(temp[0], 10), parseInt(temp[1], 10) - 1,
					parseInt(temp[2], 10), parseInt(temp2[0], 10), parseInt(
							temp2[1], 10));
			if (d1.getTime() < now.getTime()) {
				// GOV-3460 公文管理，设置暂存代办 提醒时间时，设置小于当前时间也能成功
				document.getElementById("nowzcdbTime").value = "";
				alert(_("edocLang.edoc_zcdb_remind_later_than_now"));
				return false;
			}
			doSelectZcdbTime();
		}
	}
}
function doSelectZcdbTime() {
	//非空判断
	var sDate = document.getElementById("nowzcdbTime");
	if (sDate.value == null || sDate.value == "") {
		alert(_("edocLang.edoc_zcdb_selectRemindTime"));
		return;
	}
	if (document.getElementById("nowzcdbTime") != null) {
		document.getElementById("zcdbTime").value = document
				.getElementById("nowzcdbTime").value;
	}
	isCancelZcdbTime = false;
	cancelConfirm();
	
	var aObj=document.getElementById("zcdbAdviceA");
	
	predoZcdb(aObj);
}

//移除actions里面的项
function removeAction(actions,actStr){
    
    if(actions && actStr){
        var tempActions = actions;
        tempActions = tempActions.replace("[", "").replace("]", "");
        var tempArray = tempActions.split(",");
        if(tempArray.length > 0){
            for(var i = 0; i < tempArray.length; i++){
                var tempItem = tempArray[i];
                var tempItemTrim = tempItem.replace(/^\s+|\s+$/g,'');//取消前后空白
                if(tempItemTrim == actStr){
                    
                    if(i == 0){
                        actions = actions.replace(tempItem + ",", "").replace(tempItem, "");
                    }else {
                        actions = actions.replace("," + tempItem, "");
                    }
                    break;
                }
            }
        }
    }
	return actions;
}

//字符串转换成数组
function transToArr(actions) {
	var arr = new Array();
	if (actions != "[]" && actions != "") {
		//去掉文单更新
		actions=removeAction(actions,"UpdateForm");
		//去掉转发
		if(isRemoveForward=="true"){
			actions=removeAction(actions,"Forward");
		}
		actions = actions.replace("[", "").replace("]", "");
		
		if (actions != "") {
			arr = actions.split(",");
			for(var i = 0; i < arr.length; i++){
			    arr[i] = arr[i].replace(/^\s+|\s+$/g,'');//去除空格
			}
		}
	}
	return arr;
}
//第一个字符转大写
var toUpperCase = function(str) {
	str = str.replace(/^\s+|\s+$/g, "");//去两边的空格
	return str.replace(/\b\w+\b/g, function(word) {
		return word.substring(0, 1).toUpperCase() + word.substring(1);
	});
}
//从字符串中去掉指定的字符串
function subString(advanceAll, action) {
	var strAction = action + ",";//拼字符串，用来从全部中去掉已经显示的
	if (advanceAll.indexOf(strAction) != -1) {
		advanceAll = advanceAll.replace(strAction, "");
	} else {
		advanceAll = advanceAll.replace(action, "");
	}
	return advanceAll;
}
//根据当前客户端分辨率判断默认显示多少个常用处理权限
function getShowCommonSize() {
	var result = 0;
	//1024=4/1280=8/1360=10/1366=10
	var width = document.body.clientWidth;
	if (width < 1280) {
		result = 4;
	} else if (width < 1366) {
		result = 8;
	} else {
		result = 10;
	}
	return result;
}
//弹出暂存待办时间设置框
function showDatetimeDialog() {
	var nowzcdbTimeObj = document.getElementById("nowzcdbTime");
	selectDateTime(pagePath, nowzcdbTimeObj, 400,
			200);
}
//处理界面节点权限布局初始化
$(function(){
	var commonShowSize=getShowCommonSize(); //1366
	//没有暂存待办增加一列
	if(canShowZCDB=="false"){
		commonShowSize+=2;
	}
	//没有交换类型增加两列
	if(canShowJHLX=="false"){
		commonShowSize+=4;
	}
	//没有交跟踪和处理后归档增加两列
	if(canShowGZGD=="false"){
		commonShowSize+=4;
	}
	var commonDivObj=$("#commonActionsDiv");//常用显示区域
	var advancedDivObj=$("#advancedActionsDiv");//高级显示区域
	var commonActions=transToArr(commonActionsStr);//常用
	var advancedActions=transToArr(advancedActionsStr);//高级
	//常用区域只显示常用的按钮，如果显示不下放到高级里面
	if(commonActions.length < commonShowSize){
		commonShowSize=commonActions.length;
	}
	var allActions=commonActions.concat(advancedActions);
	var advanceAll=allActions.toString();
	//常用区域展现
	var table="<table>";
	var tr1="<tr>";
	var tr2="<tr>";
	for(var i=0;i<commonShowSize;i++){
		var action=allActions[i];
		if(action!=""){
			var divObj=$("#div"+toUpperCase(action));
			if(i%2==0){//第一行
				tr1=tr1+"<td>"+divObj[0].innerHTML+"</td>";
				//当只有一个节点权限的时候，为了保持样式一直，第二行需要补充一个空格
				if(commonShowSize==1){
					tr2=tr2+"<td>&nbsp;</td>";
				}
			}
			if(i%2==1){//第二行
				tr2=tr2+"<td>"+divObj[0].innerHTML+"</td>";
			}
			advanceAll=subString(advanceAll,action);
		}
	}
	tr1=tr1+"</tr>";
	tr2=tr2+"</tr>";
	table=table+tr1+tr2+"</table>";
	$(table).appendTo(commonDivObj);
	//高级区域展现处理
	var advanceArr=transToArr(advanceAll);
	if(advanceArr.length==0){
		$("#processAdvance").css("display","none");
	}
	for(var i=0;i<advanceArr.length;i++){
		var advAction=advanceArr[i];
		if(advAction!=""){
			var divObj=$("#div"+toUpperCase(advAction));
			divObj.appendTo(advancedDivObj);//绑定到高级
		}
	}
});