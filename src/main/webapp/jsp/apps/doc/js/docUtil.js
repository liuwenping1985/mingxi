<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

function appEnumData() {
    this.global = '0'; // 全局
    this.collaboration = '1'; // 协同应用
    this.form = '2'; // 表单
    this.doc = '3'; // 知识管理
    this.edoc = '4'; // 公文
    this.plan = '5'; // 计划
    this.meeting = '6'; // 会议
    this.bulletin = '7'; // 公告
    this.news = '8'; // 新闻
    this.bbs = '9'; // 讨论
    this.inquiry = '10'; // 调查
    this.mail = '12'; // 邮件
    this.organization = '13'; // 组织模型
    this.info = '32'; // 信息报送
    this.infoStat = '33'; // 信息报送统计
}

/**
 *  根据(总分和评分次数）或（平均分）返回文档的对应的星级class属性值
 *  @param score 当只有一个参数时候，score为平均分，当有两个参数时，为文档总分数
 *  @param scoreCount 评分次数，当不给此参数时score为平均分
 *  @returns 返回文档的对应的星级class属性值
 */
function fnGetStarLevelClass(score,scoreCount) {
	var avg = fnGetAvgScore(score, scoreCount);
    var level = 0.0;
    var intPart = parseInt(avg);
    var floatPart = avg - intPart;
    if(floatPart < 0.25) {
        level += intPart;
    } else if(floatPart < 0.75) {
        level += intPart + 0.5;
    } else {
        level += intPart + 1;
    }
    return 'stars' + level.toString().replace('.','_');
}
/**
 *  获取平均分
 *  @param score 当只有一个参数时候，score为平均分，当有两个参数时，为文档总分数
 *  @param scoreCount 评分次数，当不给此参数时score为平均分
 *  @returns 文档平均分
 */
function fnGetAvgScore(score,scoreCount) {
    var avgScore;
    if(scoreCount==null) {
        avgScore = score;
    } else {
        if (scoreCount===0) 
            avgScore = 0;
        else 
            avgScore = score/scoreCount;
    }
    var avg = parseFloat(avgScore);
    if(avg == null || isNaN(avg)) {
        return 0;
    }
    // 如果平均分范围无效
    if(avg > 5 || avg < 0) {
        return 0;
    }

    return avg.toFixed(1).toString();
}

/**
 *  计算给定时间到当前时间的时间间隔
 *  @param strDate 日期时间格式字符串 格式如：(2012/09/19 or 2012-09-19)[ (18:25:35 or 18:25)]
 *  @returns 返回距离当前时间间隔,对于无法解析的格式原样返回
 */
function fnEvalTimeInterval(strDate) {
    var strDateFormat = strDate.replace(/\-/g, '/');
    var myDate = new Date(strDateFormat);
    
    var timeInterval = new Date().getTime() - myDate.getTime();
    var seconds = timeInterval / 1000;
    if (seconds < 0) {
        return strDate;
    }  else {
        var strInterval = '';
        if (seconds < 60) {
            strInterval = Math.floor(seconds) + "${ctp:i18n('doc.createtime.seconds')}";
        }  else {
            var minus = seconds/60;
            if(minus < 60) {
                strInterval = Math.floor(minus) + "${ctp:i18n('doc.createtime.minutes')}";
            } else {
                var hours = minus/60;
                if (hours < 24) {
                    strInterval = Math.floor(hours) + "${ctp:i18n('doc.createtime.hours')}";
                } else {
                    var days = hours/24;
                    if (days < 30) {
                        strInterval = Math.floor(days) + "${ctp:i18n('doc.createtime.days')}";
                    } else {
                        var months = days/30;
                        if (months < 12) {
                            strInterval = Math.floor(months) + "${ctp:i18n('doc.createtime.months')}";
                        } else {
                            var years = months / 12;
                            strInterval = Math.floor(years) + "${ctp:i18n('doc.createtime.years')}";
                        }
                    }
                }
            }
        }
        return strInterval + "${ctp:i18n('doc.createtime.forward')}";
    }
}

/**
 * 知识查看
 * docId 文档id
 * entranceType 入口类型，跟权限判定有关，具体值参考EntranceTypeEnum.java
 * 如果没有响应入口，请联系 muyx
 */
function fnDocOpenDialogOnlyId(docResId, entranceType){
	if(docResourceNotExist(docResId))
		return;  

	var flag = docOpenType(docResId);
    var first = flag.charAt(0);
    if(first!='l' && first != 'c' ){
        // 归档类型
        var loc = flag.indexOf(',');
        var key = flag.substring(0, loc);
        var srcid = flag.substring(loc + 1, flag.length-2);
        var sourceType = flag.substring(flag.length-1);
        if(sourceType==3)
        	openPigeonholeDetail(key, srcid, docResId,"favorite");
        else
        	openPigeonholeDetail(key, srcid, docResId,"docLib");
    }else if(first != 'c' && flag.indexOf(',') == -1){
        // 源文件不存在的链接类型
        $.alert(v3x.getMessage('DocLang.doc_source_doc_no_exist'));
        return;
    }else {
	    var sUrl="${path}/doc.do?method=knowledgeBrowse&docResId="+docResId+"&entranceType="+entranceType;
	    var dialog = $.dialog({
	        id : 'docOpenDialogOnlyId',
	        url : sUrl,
	        targetWindow :getCtpTop(),
	        title : "${ctp:i18n('doc.jsp.knowledge.docopendialogonlyid.title')}"
	    });
	    dialog.maxfn();
    }
	
}

// 得到打开类型
function docOpenType(id) {
    try {
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
             "getTheOpenType", false);
        requestCaller.addParameter(1, "Long", id);
        var flag = requestCaller.serviceRequest();
        return flag;
    } catch (ex1) {
        $.alert("Exception : " + ex1.message);
    }
}

// 系统类型的打开
function openPigeonholeDetail(appEnumKey, sourceId, docId,openFrom) {

    var jsColURL = "/seeyon/collaboration/collaboration.do";
    var jsMeetingURL = "/seeyon/mtMeeting.do";
    var jsPlanURL = "/seeyon/plan.do";
    var jsMailURL = "/seeyon/webmail.do";
    var jsNewsURL = "/seeyon/newsData.do";
    var jsBulURL = "/seeyon/bulData.do";
    var jsEdocURL = "/seeyon/edocController.do";
    var jsInquiryURL = "/seeyon/inquirybasic.do";
    var infoURL="/seeyon/infoDetailController.do";
    var infoStatURL="/seeyon/infoStatController.do";
    
    var dialogType = "modal";
    var data = new appEnumData();
    // 判断是不是以模态对话框打开
    //var isModel = getA8Top().window.dialogArguments;
    // 归档源是否存在的判断
    var existFlag = pigeonholeSourceExist(appEnumKey, sourceId);
    if(existFlag == 'false') {
    	$.alert(v3x.getMessage('DocLang.doc_source_doc_no_exist'));
        return;
     }
    // 访问次数
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
         "accessOneTime", false);
    requestCaller.addParameter(1, "Long", docId);
    requestCaller.serviceRequest();
    
    _url = "";
    if(appEnumKey == data.collaboration || appEnumKey == data.edoc) {
        var ret = "200";
        if(openFrom=="lenPotent") {
            var requestCaller = new XMLHttpRequestCaller(this, "docAclManager", "getEdocBorrowPotent", false);
            requestCaller.addParameter(1, "long", docId);               
            ret = requestCaller.serviceRequest();
        } else {
                var requestCaller = new XMLHttpRequestCaller(this, "docAclManager", "getEdocSharePotent", false);
                requestCaller.addParameter(1, "long", docId);               
                ret = requestCaller.serviceRequest();
        }
        
        if(appEnumKey == data.collaboration) {
//            _url = jsColURL + "?method=detail&from=Done&affairId=" + sourceId + "&type=doc&docId=" + docId + "&lenPotent=" + ret + "&openFrom=" + openFrom;
        	_url = getCollDetailUrl(sourceId,null,null,openFrom,null, ret);
        }
        else {
            if(openFrom!=null){
                _url = jsEdocURL + "?method=edocDetailInDoc&openFrom="+openFrom+"&summaryId=" + sourceId+"&lenPotent="+ret+"&docId="+docId+"&isLibOwner="+isLibOwner;
            }
            else {
                _url = jsEdocURL + "?method=edocDetailInDoc&openFrom="+openFrom+"&summaryId=" + sourceId+"&lenPotent="+ret+"&docId="+docId; 
            }
        }
    }
    else if(appEnumKey == data.meeting){
        _url = jsMeetingURL + "?method=mydetail&id=" + sourceId+"&fromdoc=1";
    }else if(appEnumKey == data.plan){
        _url = jsPlanURL + "?method=initDetailHome&editType=doc&id=" + sourceId;
    }else if(appEnumKey == data.mail){
        _url = jsMailURL + "?method=showMail&id=" + sourceId;
    }else if(appEnumKey == data.inquiry){
        _url = jsInquiryURL + "?method=showInquiryFrame&bid=" + sourceId+"&fromPigeonhole=true";
    }else if(appEnumKey == data.news){
        _url = jsNewsURL + "?method=userView&id=" + sourceId+"&fromPigeonhole=true";
    }else if(appEnumKey == data.bulletin){
        _url = jsBulURL + "?method=userView&id=" + sourceId+"&fromPigeonhole=true";
    }else if(appEnumKey == data.info){
        _url = infoURL + "?method=detail&summaryId=" + sourceId + "&affairId=&from=Done";
    }else if(appEnumKey == data.infoStat){
        _url = infoStatURL + "?method=showStatResult&id=" + sourceId;
    }
    fnSelectOpenMode('docOpenFromHomePage',_url,"${ctp:i18n('doc.title.knowledge.browse')}",false,top);
}

// 归档源存在的判断
function pigeonholeSourceExist(appEnumKey, sourceId){
    try {
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
             "hasPigeonholeSource", false);
        requestCaller.addParameter(1, "Integer", appEnumKey);
        requestCaller.addParameter(2, "Long", sourceId);
        var flag = requestCaller.serviceRequest();
        return flag;
    } catch (ex1) {
        return 'false';
    }
}

/**
 * 文档下载
 */
function docDownLoad(fileId,isUploadFile,sourceId,docName,createDate,vForDocFileDownload){
	ajaxRecordOptionLog(fileId,"downLoadFile");
	if(docResourceNotExist(fileId))
		return ;
   if(isUploadFile == 'true'){
		empty.location.href="/seeyon/fileDownload.do?method=download&viewMode=download&fileId="+sourceId+"&createDate=" + createDate +"&filename=" + encodeURIComponent(docName)+"&v="+vForDocFileDownload;
	}else{
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "docDownloadCompress", true);
	       requestCaller.addParameter(1, "long", fileId);
	       
	       this.invoke = function(ds) {
	           empty.location.href = _ctxPath+"/doc.do?method=docDownloadNew&id="+fileId;
	           downloading = false;
	       }
	       requestCaller.serviceRequest();	
}
}
//下载弹出框
function downloadDoc(docId, docName, docMimeType, sourceId, createDate,vForDocDownload) {
    // menuDownload(docId, docName, true);
    var isUploadFile = 'false';
    if(docMimeType != 22 && docMimeType != 23 && docMimeType != 24 && docMimeType != 25 && docMimeType != 26) {
        isUploadFile = 'true';
    }
    ajaxRecordOptionLog(docId,"downLoadFile");
    if(isUploadFile == 'true'){
    	empty.location.href="${path}/fileDownload.do?method=download&viewMode=download&fileId="+sourceId+"&createDate="+createDate+"&filename=" + encodeURIComponent(docName)+"&v="+vForDocDownload;
    }else{
        var proce = $.progressBar();
        // 压缩
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "docDownloadCompress", true);
        requestCaller.addParameter(1, "long", docId);
        var flag = 'false';
        this.invoke = function(ds) {
            flag = 'true';
            proce.close();
            empty.location.href = "${path}/doc.do?method=docDownloadNew&id="+docId;
        }
        requestCaller.serviceRequest();
    }
}
var _dialog = null;
//公开到广场
function openToSquare(docId,isFolder,isOld) {
    // 3个人借阅，2，个人共享
    var shareType = (isFolder == 'false' ||typeof(isFolder) =='undefined')? 3:2;
    
	var requestCaller = new XMLHttpRequestCaller(this, "knowledgePageManager", "openDocToSquare", false);
    requestCaller.addParameter(1, "Long", docId);
    requestCaller.addParameter(2, "String",  shareType);
    var hasOP = requestCaller.serviceRequest();

    if(hasOP === 'true') {
    	var win = new MxtMsgBox({
    	    type: 0,
    	    imgType :0,
            width : 380,
    	    height : 80,
    		title:"${ctp:i18n('doc.jsp.knowledge.opentosquare.title')}",
    	    msg: "${ctp:i18n('doc.open.to.square.success')}",
    	    ok_fn:function(){
    	        var myKnowledgeLib = $('#myKnowledgeLib');
    	        if(myKnowledgeLib){
    	            myKnowledgeLib.click();
    	        }
    	    }
    	});
    }else{
    	var win = $.confirm({
    		title:"${ctp:i18n('doc.jsp.knowledge.opentosquare.title')}",
    	    msg: "${ctp:i18n('doc.open.to.square.cancel')}",
            width : 380,
            height : 80,
    	    ok_fn: function () { 
    			var requestCaller = new XMLHttpRequestCaller(this, "knowledgePageManager", "updateCancelPublic", false);
    			requestCaller.addParameter(1, "Long", docId);
    			var hasOP = requestCaller.serviceRequest();
    			if(hasOP == "true") {
    				$.messageBox({
                		type : 0,
                		imgType : 0,
                		width : 380,
                	    height : 80,
                		title : "${ctp:i18n('doc.jsp.knowledge.opentosquare.title')}",
                		msg : "${ctp:i18n('system.manager.ok')}",
                		ok_fn : function() {
                			//刷新页面
                			var myKnowledgeLib = $('#myKnowledgeLib');
                            if(myKnowledgeLib){
                               myKnowledgeLib.click();
                            }
                		}
                	});
    			}			
    		}
    	});

    }
//    // 3个人借阅，2，个人共享
//    var shareType = typeof(isFolder)==="undefined" ? 3:2;
//    var isOld= typeof(isOld)==="undefined" ? false : true;
//    var param={
//        id : 'RefuseBorrowDialog',
//        url : _ctxPath+"/doc/knowledgeController.do?method=openToSquare",
//        width : 400,
//        height : 120,
//        title : "${ctp:i18n('doc.jsp.knowledge.opentosquare.title')}",
//        targetWindow :getCtpTop(),
//        buttons : [ {
//            id : 'submitBtnId',
//            text : "${ctp:i18n('metadata.manager.ok')}",
//            handler : function() {
//                var data = $.parseJSON(_dialog.getReturnValue());
//                var isOnlyList= data.isOnlyList===null?false:true;
//                var param={"docId":docId,"userId":$.ctx.CurrentUser.loginAccount,"userType":"Account","ownerId":$.ctx.CurrentUser.id,"shareType":shareType,"isOnlyList":isOnlyList};
//                ajaxKnowledgePageManager.updateDocToSquare(param,{
//                    success:function(oReturn){
//                        if(oReturn){
//                            $.infor("${ctp:i18n('doc.jsp.knowledge.public.success')}");
//                        }else{
//                        	$.alert("${ctp:i18n('doc.jsp.knowledge.public.failed')}");
//                        }
//                    }
//                });
//                _dialog.close();
//            }
//        }, {
//            text : "${ctp:i18n('systemswitch.cancel.lable')}",
//            handler : function() {
//                _dialog.close();
//            }
//        } ]
//    } 
//    if(isOld){
//        _dialog= new MxtWindow(param);
//    }else{
//        _dialog = $.dialog(param);
//    }   
}
var currentUserId = $.ctx.CurrentUser.id;
/**
 * 根据当前登陆用户权限打开当前文档
 * @param docResourceId 文档id
 * @param createUserId 文档创建人
 */
//function openFileWithPermission(docResourceId,createUserId,entranceType) {
//	if(docResourceNotExist(docResourceId))
//		return ;
//    var hasOP = new docHierarchyManager().hasOpenPermission(docResourceId, currentUserId);
//    if(hasOP) {
//        fnDocOpenDialogOnlyId(docResourceId, entranceType);
//    } else {
//        $.confirm({
//            'type': 1,
//            'msg': "${ctp:i18n('doc.jsp.knowledge.borrow.whether.apply')}",
//            ok_fn: function () { 
//
//    		fnAddDocBorrowApply(docResourceId,currentUserId,createUserId);
////            	if( hasPotentUsers(docResourceId) ){
////            	} else {
////            		$.alert("${ctp:i18n('sorry!该文档的所有者已经不存在了')}");
////            	}
//            }
//        });
//    }
//}
/**
 * 是否存在有文档权限的用户
 * @param docResourceId
 * @returns
 */
function hasPotentUsers(docResourceId) {
	var strInclude = new knowledgePageManager().getPotentModelUsers(docResourceId,false);
	if(strInclude != null) {
//		if(strInclude.indexOf(",")!=-1){
//			$("#spc1").comp({includeElements:[strInclude]});
//		}else{
//			var elements=[strInclude.substring(0,strInclude.lastIndexOf("|"))];
//			$("#spc1").comp({includeElements:elements,value:elements,
//								text:strInclude.substring(strInclude.lastIndexOf("|")+1)});
//		}
		return true;
	}
	return false;
}
	
/**
 * 申请借阅
 * @param docResourceId 文档id
 * @param borrowUserId 借阅人
 * @param createUserId 文档创建人
 */
//function fnAddDocBorrowApply(docResourceId,borrowUserId,createUserId) {
//    var dialog = $.dialog({
//        id: 'html',
//        url: _ctxPath+"/doc/knowledgeController.do?method=applyBorrow&docId="+docResourceId,
//        title: "${ctp:i18n('doc.jsp.knowledge.borrow.apply')}",
//        width : 352,
//        height : 120,
//        overflow : 'hidden',
//        buttons: [ 
//           {
//                text: "${ctp:i18n('common.button.ok.label')}", 
//                handler: function () {
//        	   		var data = $.parseJSON(dialog.getReturnValue());
//        	   		if(data==false)
//        	   			return ;
//                    var docBorrow = new Object();
//                    docBorrow.borrowUserId = borrowUserId;
//                    docBorrow.docResourceId = docResourceId;
//                    docBorrow.createUserId = data.spc1;
//                    docBorrow.loginAccount = $.ctx.CurrentUser.loginAccount;
//                    docBorrow.description = data.borrowMsg;
//                    new knowledgePageManager().applyDocBorrow(docBorrow, {
//                       success : function(data) {
//                           //$.alert('发送借阅' + s);
//                           if(data === null) {
//                               $.alert("${ctp:i18n('doc.jsp.knowledge.borrow.apply.failed')}");
//                           } else {
//                               $.infor("${ctp:i18n('doc.jsp.knowledge.borrow.apply.success')}");
//                           }
//                       }
//                    });
//                    dialog.close();
//                } 
//             } , {
//                text: "${ctp:i18n('common.button.cancel.label')}",
//                handler: function () {
//                    dialog.close();
//                }
//           }]
//     });
//}
//从操作按钮进入编辑文档
function fnEditDocFromToolbar(id, filename) {
	//if(isOffice2007(filename) && !confirmToOffice2003()) 
		//return false;
	
	if(checkLock(id, false) == false) {
		return;
	}
	var isUploadFile = false;
	if(isUploadFileMimeType !== '0') {
		isUploadFile = true;
    }
	if(isUploadFileMimeType!='0' && isUploadFileMimeType!='101' && isUploadFileMimeType!='102' && isUploadFileMimeType!='120' && isUploadFileMimeType!='121'){
		dialog = $.dialog({
			id : "uploadFileDialog" ,
			url : jsURL + "?method=editDoc&docResId=" + id + "&docLibType=" + docLibType+"&isUploadFileMimeType=true&isUploadFile=true&openFrom=toolbar",
			width: 400,
		    height: 420,
		    isDrag: true ,
		    targetWindow: window.parent.top,
		    title: "${ctp:i18n('doc.knowledge.edit')}",
		    buttons: [{
            	id : 'ok',
                text: "${ctp:i18n('calendar.sure')}",
                handler: function () {
                	var returnValue = dialog.getReturnValue();
                	if(returnValue) {
                		top.fnRefresh();
                	} 
                }
            }, {
            	id : 'cancel',
                text: "${ctp:i18n('common.button.cancel.label')}",
                handler: function () {
                    dialog.close();
                }
            }]
			});
	}else{
	    var topWindow = getA8Top().document.documentElement;
		dialog = $.dialog({
			id : "docOpenDialogOnlyId" ,
			url : jsURL + "?method=editDoc&docResId=" + id + "&docLibType=" + docLibType+ "&isUploadFile=" + isUploadFile +"&openFrom=toolbar",
			width: topWindow.clientWidth-20,
		    height: topWindow.clientHeight-50,
		    top:10,
		    isDrag: true ,
		    targetWindow: getA8Top(),
		    title: "${ctp:i18n('doc.knowledge.edit')}"
		});
	}
	getA8Top()._dialog = dialog;
}

//转发协同弹出框
function forwardDocToCol(docId, docLibId,docType,sourceId) {
	if(docType == 1 || docType==2){//是协同
		//检查源协同是否存在
		var existFlag = pigSourceExistById(docId,docType);
	    if(existFlag == 'false') {		
		    alert(v3x.getMessage('DocLang.doc_source_doc_no_exist'));
		    return;
	    }
	    
	    try {
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "getSummaryIdByAffairId", false);
			requestCaller.addParameter(1, "long", sourceId);
			var summaryId = requestCaller.serviceRequest();
			//判断是否允许转发协同或邮件
	    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxColManager", "checkForwardPermission", false);
	    	requestCaller.addParameter(1, "String", summaryId + '_' + sourceId);
	    	var ds = requestCaller.serviceRequest();
	    	if(ds.length !== 0){
	    		alert($.i18n('doc.alert.sendToColl.failure'));
	    		return;
	    	}
			// 记录转发日志
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "logForward", false);
			requestCaller.addParameter(1, "String", "false");
			requestCaller.addParameter(2, "Long", docId);
			requestCaller.serviceRequest();
			getA8Top().toCollWin = getA8Top().$.dialog({
	            title:" ",
	            transParams:{'parentWin':window},
	            url: "${path}/collaboration/collaboration.do?method=showForward&showType=model&data=" + summaryId+"_"+sourceId,
	            width: 360,
	            height: 430,
	            isDrag:false
	        });
	    }catch (ex1) {
			alert("Exception : " + ex1.message);
		}
	}else if(docType == 10){//是邮件
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "logForward", false);
		requestCaller.addParameter(1, "String", "false");
		requestCaller.addParameter(2, "Long", docId);
			
		requestCaller.serviceRequest();
		var surl = "${path}/webmail.do?method=convertToCol&id=" + sourceId;
		toA8Main(surl);
	}else{
	    var colUrl = "${path}/doc.do?method=sendToColl";
	    sendToCollOrEmail(colUrl, docId, docLibId);
	}
}
//实现一个空方法转发协同的回调
function callbackForwardColV3x () {
//	document.location.reload(true);
}

//转发邮件弹出框
function forwardDocToEmail(docId, docLibId,docType,sourceId) {
	 if(docType == 1){
		var existFlag = pigSourceExistById(docId,docType);
	    if(existFlag == 'false') {		
		    alert(v3x.getMessage('DocLang.doc_source_doc_no_exist'));
		    return;
	    }
		try {
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "getSummaryIdByAffairId", false);
			requestCaller.addParameter(1, "long", sourceId);
			var summaryId = requestCaller.serviceRequest();
			//判断是否允许转发协同或邮件
		    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxColManager", "checkForwardPermission", false);
		    	requestCaller.addParameter(1, "String", summaryId + '_' + sourceId);
		    	var ds = requestCaller.serviceRequest();
		    	if(ds && ds.length != 0){
		    		alert($.i18n('doc.alert.sendToColl.failure'));
		    		return;
		    	}
	    }catch(e){
	    }
	}
	
	if(hasDefaultMailBox()){
	    if(docType == 1 || docType == 2){//协同
		    try {    
			    // 记录转发日志
				var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "logForward", false);
				requestCaller.addParameter(1, "String", "true");
				requestCaller.addParameter(2, "Long", docId);
				requestCaller.serviceRequest();
	
				var surl = "${path}/collaboration/collaboration.do?method=forwordMail&id=" + summaryId;
				toA8Main(surl);
			}catch (ex1) {
				alert("Exception : " + ex1.message);
			}
		}else if(docType == 10){//邮件
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "logForward", false);
			requestCaller.addParameter(1, "String", "true");
			requestCaller.addParameter(2, "Long", docId);
			requestCaller.serviceRequest();
			var surl = "${path}/webmail.do?method=autoToMail&id=" + sourceId;
			toA8Main(surl);
		}else{
			var emailUrl = "${path}/doc.do?method=sendToWebMail";
			sendToCollOrEmail(emailUrl, docId, docLibId);
		}
	}
}

function docResourceNotExist(fileId){
    var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "docResourceExist", false);
    requestCaller.addParameter(1, "Long", fileId);
    var existflag = requestCaller.serviceRequest();
    if(existflag == 'false') {
        alert("${ctp:i18n('doc.jsp.knowledge.sourceDoc.deleted')}");
        return true;
    }      
    return false;
}

function sendToCollOrEmail(location, rowid, docLibId) {
	var surl = location + "&docResId=" + rowid + "&docLibId=" + docLibId;
	toA8Main(surl);
}

function toA8Main(surl){
//	if(getA8Top().opener){
//		getA8Top().opener.focus();
//		getA8Top().opener.getA8Top().document.getElementById("main").src = surl;
//	}else{
//		getA8Top().document.getElementById("main").src = surl;
//	}
//	getA8Top().showLeftNavigation();
	getA8Top().showLeftNavigation();
	getA8Top().document.getElementById("main").src = surl;
}
function isPig(frType) {
	return frType >= 0 && frType <=10;
}
/**
* 	获取打开正文内容的url
*
*	affairId,summaryId,processId 三个参数如果有affairId优先传affairId，如果 取不到affairId传 summaryId或者processId
* 	openFrom  		从哪里打开的,用来控制协同处理界面右侧处理区域是否显示  从如下字符串中取值：
*					formStatistical 表单查询统计
*					docLib	文档中心
*					supervise 督办
*					listDone 已办列表
*					listPending 待办列表
*                  F8Reprot F8穿透统计
*					subFlow 子流程查看主流程，或者主流程查看子流程
*	operationId		表单使用的字段，没有可以传 null
*  docAcl          文档中心权限串
*/
function getCollDetailUrl(affairId,summaryId,processId,openFrom,operationId,docAcl){
	var url = _ctxPath + "/collaboration/collaboration.do?method=summary";
	if(affairId!=null&&typeof(affairId)!='undefined'){
		url+="&affairId="+affairId;
	}
	if(summaryId!=null&&typeof(summaryId)!='undefined'){
		url+="&summaryId="+summaryId;
	}
	if(processId!=null&&typeof(processId)!='undefined'){
		url+="&processId="+processId;
	}
	if(openFrom!=null&&typeof(openFrom)!='undefined'){
		url+="&openFrom="+openFrom;
	}
	if(operationId!=null&&typeof(operationId)!='undefined'){
		url+="&operationId="+operationId;
	}
	if(docAcl!=null&&typeof(docAcl)!='undefined'){
       url+="&lenPotent="+docAcl;
   }
	return url;
}
/**
 * 睡眠函数
 * @param millisecondi
 * @returns
 */
function pause(millisecondi)
{
    var now = new Date();
    var exitTime = now.getTime() + millisecondi;

   while(true)
    {
        now = new Date();
        if(now.getTime() > exitTime) return;
    }
}

function fnCloseRecommendDialog() {
	var _dialog = top.frames['main']._dialog;
	top.frames['main']._dialog = null;
	//刷新知识查看
    if(top.docOpenDialogOnlyId_main_iframe && top.docOpenDialogOnlyId_main_iframe.fnReloadKnowledgeBrowse){
        top.docOpenDialogOnlyId_main_iframe.fnReloadKnowledgeBrowse();
    }
	_dialog.close();
}