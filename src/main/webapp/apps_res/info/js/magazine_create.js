var newInfo_layout;//动态布局layout对象
var isAudit = false;//默认不需要审核
var _currentTempleteId = "";//当前选中的
var isSubmitOperation = false; //直接离开窗口做出提示的标记位

/**
 * 窗口离开后提示
 * @returns {String}
 */
function beforeCloseCheck(){
	  if(!isSubmitOperation){
	      if(navigator.userAgent.toLowerCase().indexOf("edge")!=-1){
	            return " "; //如果是edge浏览（若直接关闭窗口,您做的修改将不再保留）
	        }else{
	            return "";  //非EDGE浏览器（若直接关闭窗口,您做的修改将不再保留）
	        }
	  }
}

function InfoTemplate(folder, subject, categoryName){
	this.folder = folder;
	this.subject = subject;
	this.categoryName = categoryName;
}
var defaultSelected;
$(document).ready(function () {
	defaultSelected = $("#templates").find("option:selected");
	newInfo_layout = $("#newInfo_layout").layout();
	tb = $("#toolbar").toolbar({
		isPager:false,
        borderLeft:false,
        borderRight:false,
        borderTop:false,
        toolbar: [{
            id: "saveDraft",
            name: $.i18n("infosend.magazine.create.saveMomentum"),
            className: "ico16 save_traft_16",
            click:saveDraft
        }]
    });

	$("#magazineConf").bind("click",magazineConfView);
	//$("#publishRange").bind("click",magazineRange);
	$("#publishRange").bind("click",function() {
		openMagazinePublishDialog($("#publishRange"));
	});
	$("#sendId").bind("click",trySend);

	$("#radio_notAudit").click(auditSwitch);
	$("#radio_Audit").click(auditSwitch);
	
	if(auditStatus=='1') {
		$("#radio_Audit").trigger("click");
	} else {
		$("#radio_notAudit").trigger("click");
	}
	
	if(hasOffice(getDefaultContentType(), false, "您使用的是非IE浏览器，请使用IE浏览器，给您带来的不便非常抱歉！")) {
	    initOfficeCallBackEvent();
	}else{
		isSubmitOperation = true;
		parent.leftClickEvent("listMagazineManager");
	}
	
	if(useLocalTemplateFile){//使用本地模版进行期刊修改
		onOpenFileEvent();
	}
	
	_currentTempleteId = $("#templateId").val();//设置默认选中的版式ID
	OfficeObjExt.showExt = showOfficeObjExt;
});

/**
 * 显示office正文
 */
function showOfficeObjExt(){
	var officeEditorFrame = $("#officeEditorFrame", document)[0];
	var weboffice = $(officeEditorFrame.contentWindow.document).find("#WebOffice");
	weboffice[0].style.visibility = 'visible';
	//点击期刊内容打开office正文后需要重新更新office控件缓存
	clearOfficeFlag();
	setOfficeFlag(true,weboffice[0]);
	var iframe = document.getElementById("officeFrameDiv");
    var h;
    if(OfficeObjExt.firstHeight == null){
      h = iframe.style.height;
      OfficeObjExt.firstHeight = h;
    }else{
      h= OfficeObjExt.firstHeight; 
    }
    var height=h;
    if(h.indexOf("%")>0){
      height = h.substring(0,h.length-1);
      height = parseInt(height);
      height = height -2;
      iframe.style.height = height+"%";
    }else if(h.indexOf("px")>0){
      height = h.substring(0,h.length-2);
      height = parseInt(height);
      height = height -2;
      iframe.style.height = height+"px";
    }else{
      h= $(iframe).height();
      OfficeObjExt.firstHeight = h+"px"; 
      iframe.style.height = (h-2)+"px";
    }
    window.setTimeout(function(){
      iframe.style.height = h;
    }, 2);
}




/* 打开office本地文件回调事件 */
function onOpenFileEvent(){
	//从本地文件打开，要把配置的期刊内容清空
	fileUploadAttachments.clear();
	$("#templateId").val("");
	$("#magazineConfInfos").val("");
	$("#default_select").attr("selected","selected");
	$("#magazineConf").unbind("click");
	$("#magazineConf").val("");
	$("#magazineConfInfos").val("");
	$("#magazineConf").disable();
	$("#templates").disable();
	$("#useLocalFile").val(1);//使用本地文件
	useLocalTemplateFile = true;
}

var auditerDialog;
window.onbeforeunload = function(){
	if(auditerDialog){
		auditerDialog.close();
	}
}
function doSelectAuditer(){
	auditerDialog = $.dialog({
    	id:"pigeonholeIpad",
    	title:$.i18n('infosend.magazine.label.selectAuditor'),//请选择审核人
    	url: _ctxPath+"/info/magazine.do?method=magazineAuditerView&magazineId=" + $('#id').val(),
    	//width: 148,
    	width: '500',
        height: '300',
        //type:'panel',
        checkMax: false,
        targetId: 'auditer',
        transParams : {
			win : window
		},
		targetWindow : getCtpTop(),
		closeParam : {
			show : true,
			autoClose : false,
			handler : function() {
				auditerDialog.close();
			}
		},
        buttons:[{
			id:'btn1',
			btnType : 1,//按钮样式
            text: $.i18n("infosend.magazine.create.determine"),
            handler: function(){
            	var ret = auditerDialog.getReturnValue();
            	if(!ret)
            		return;
            	var auditerIds = ret.auditerIds;
            	var auditerNames = ret.auditerNames;
            	if(auditerIds !== ""){
            		$("#audit_label").html($.i18n('infosend.magazine.label.selectedAuditor'));//已选择审核人
            	}else {
            		$("#audit_label").html($.i18n('infosend.magazine.label.selectAuditor'));//请选择审核人
            	}
            	$("#auditerIds").val(auditerIds);
            	$("#auditer").val(auditerNames);
            	$("#auditer").attr("title", auditerNames);
        		auditerDialog.close();
        	}
        }, {
			id:'btn2',
            text: $.i18n("infosend.magazine.create.cancel"),
            handler: function(){
        		auditerDialog.close();
            }
        }]
//        panelParam:{
//			'show':false,
//			'margins':false
//		}
    });
}

function initOfficeCallBackEvent() {
	if(typeof(officeEditorFrame)!='undefined' && officeEditorFrame != null && officeEditorFrame.openFileCallBack && officeEditorFrame.doLoadFile){
		if(action != "" && action != "modify"){
			try {
				officeEditorFrame.doLoadFile(null, systemTemplate, null, null);
				officeEditorFrame.openFileCallBack(onOpenFileEvent);
			} catch(e){
				setTimeout(initOfficeCallBackEvent, "500");
			}
		}else if(action == "modify"){//OA-58376 修改时设置打开本地文件回调函数
			if(infoStateIsDraft) {
				try {
					var templateUrl = $("#templates").find("option:selected").attr("fileUrl");
					if(templateUrl != null && templateUrl != "undefined"){
						var templateId = $("#templates").find("option:selected").attr("id");
						$("#templateId").val(templateId);
						doMagazineTaohong(templateUrl);
					}
				} catch(e) {
					setTimeout(initOfficeCallBackEvent, "500");
				}
			} else {
				officeEditorFrame.openFileCallBack(onOpenFileEvent);
			}		
		}
		
		if("true" == _isOldMagazine){//老期刊数据修改，进行自动套红
			var templateUrl = $("#templates").find("option:selected").attr("fileUrl");
			doMagazineTaohong(templateUrl);
		}
		
	}else {
		setTimeout(initOfficeCallBackEvent, "500");
	}
}

/**
 * 绑定发布范围套红
 */
function addPublishRangeToOffice(){
	//如果选择不审核，期刊发布范围有值，则将期刊发布范围套入
	if(window.officeEditorFrame && officeEditorFrame.setLable){
		if($("#radio_notAudit").is(":checked")){
				officeEditorFrame.setLable("publish_range", $("#publishRange").val());//发布范围套红
				officeEditorFrame.setLable("publish_user", $("#publish_user").val());//期刊发布人套红
				officeEditorFrame.setLable("publish_account", $("#_publish_account").val());//发布单位套红
				officeEditorFrame.setLable("publish_dept", $("#_publish_dept").val());//发布部门套红
				officeEditorFrame.setLable("publish_time", $("#_publish_time").val());//发布时间套红
		}
		//officeEditorFrame.setLable("magazine_no", $("#magazine_no").val());//期号套红
	}
}

//保存待发
var useWorkflow = false;
function saveDraft() {
	isFormSubmit = false;
	//if(!validataForm()){//表单校验
	//	return ;
	//}
	var subject = $("#subject").val();
	if(subject == ""){
		$.alert($.i18n('infosend.magazine.create.nameNotBeEmpty'));
		return false;
	}else if(subject.length > 85){
		$.alert($.i18n('infosend.magazine.create.lessThan85Characters'));
		return false;
	}
	
	$.content.getContentDomains(function(domains) {
		domains.push('magazineMainData');
		domains.push('publishMagazineDiv');
		var jsonSubmitCallBack = function() {
            setTimeout(function() {
            	$("#sendForm").attr("action", _ctxPath + "/info/magazine.do?method=saveDraft");
            	$("#sendForm").jsonSubmit({
                    domains : domains,
                    debug : false,
                    callback: function(data){
                    	parent.leftClickEvent("listMagazineManager");
                    	//location.href = "infoList.do?method=listInfoDraft&listType=listInfoDraft";
		           	}
                });
			},300);
        }
		jsonSubmitCallBack();
	},'saveAs',null,mainbody_callBack_failed);//修改成 saveAs 避免弹出无流程id相关提示dialog

}

function trySend() {
	isFormSubmit = false;
	/*
	 * OA-58670 修改
	 * if(!validataForm()){//表单校验
		return ;
	}*/
	
	//验证期号
	if(!validataIssue()){
		return;
	}
	
	var tempO = new Object();
	tempO.magazine_no = $("#magazine_no").val();
	tempO.id = $("#id").val();
	
	//检查审核人
	if($("#radio_Audit").attr("checked")=='checked') {
		if($("#auditerIds").val()=='') {
			$.alert('期刊审核人不能为空!');
			return;
		}
	}
	
	var templateId = $("#templateId").val();
	var magazineConfInfos = $("#magazineConfInfos").val();
	
	if(templateId == "" && !useLocalTemplateFile){
		$.alert($.i18n('infosend.magazine.create.publishedLayout'));
		return false;
	}
	
	//是否选择消息
	if(magazineConfInfos == "" && !useLocalTemplateFile){
		$.alert($.i18n('infosend.magazine.create.journalContent'));
		return false;
	}
	
	//如果选择了信息内容
	if(magazineConfInfos!='') {
		try {
			var infomanager = new infoManager();
			var subjects = infomanager.checkSummaryState(magazineConfInfos);
			if(subjects != "") {
				$.alert("信息"+subjects+"已撤销，请重新选择期刊内容！");
				return false;
			}
		} catch(e) {}
	}
	
		// 判断审批人是否有权限
	if ($("#radio_Audit").attr("checked") == 'checked') {
		var noRightAuditors = magazineManager.checkAuditUserRight($("#auditerIds").val());
		var tempAuditor = $("#auditerIds").val();
		var tempNoRightNames = "";
		
		//查看返回的不合法的帐号数量
		var tempCount = 0;
		if(noRightAuditors){
			for(var key in noRightAuditors){
				tempCount++;
			}
		}
		
		if(tempCount > 0){
		    for(var key in noRightAuditors){
		    	if(tempNoRightNames == ""){
		    		tempNoRightNames += noRightAuditors[key];
		    	}else{
		    		tempNoRightNames += "、" + noRightAuditors[key];
		    	}
		    	tempAuditor = tempAuditor.replace("," + key + ",", ",").replace(key + ",", "").replace("," + key, "").replace(key, "");
		    }
		    
		    $.alert({
	            msg: $.i18n('infosend.magazine.alert.hasNoauditRight', tempNoRightNames),// 无审核权限，将无法收到待审期刊！
	            ok_fn: function (){
	            	if(tempAuditor){
	            		$("#auditerIds").val(tempAuditor);
	            		_doSubmit(tempO);
	    		    }
	            },
	            close_fn: function(){
	            	if(tempAuditor){
	            		$("#auditerIds").val(tempAuditor);
	            		_doSubmit(tempO);
	    		    }
	            }
	        });
		}else{
			_doSubmit(tempO);
		}
	}else{
		_doSubmit(tempO);
	}
}

/**
 * trySend 分离出来的代码
 */
function _doSubmit(tempO){
	if(magazineManager.hasRepeatMagazineIssue(tempO)){
		var confirm = $.confirm({
		    'msg': $.i18n("infosend.magazine.create.alreadyExists"),
		    ok_fn:function (){send();},
			cancel_fn:function(){return false}
		});
	}else {
		send();
	}
}

function send(){
	isSubmitOperation = true;
	addPublishRangeToOffice();//保存发布范围
	
	$.content.getContentDomains(function(domains) {
		domains.push('magazineMainData');
		domains.push('publishMagazineDiv');
		var jsonSubmitCallBack = function() {
            setTimeout(function() {
            	$("#sendForm").attr("action", _ctxPath + "/info/magazine.do?method=send");
            	$("#sendForm").jsonSubmit({
                    domains : domains,
                    debug : false,
                    callback: function(data){
                    	parent.leftClickEvent("listMagazineManager");
                    	//location.href = "infoList.do?method=listInfoDraft&listType=listInfoDraft";
		           	}
                });
			},300);
        }
		jsonSubmitCallBack();
	},'saveAs',null,mainbody_callBack_failed);//修改成 saveAs 避免弹出无流程id相关提示dialog
}


function validataForm(){
	var subject = $("#subject").val();

	var templateId = $("#templateId").val();
	var magazineConfInfos = $("#magazineConfInfos").val();
	if(subject == ""){
		$.alert($.i18n('infosend.magazine.create.nameNotBeEmpty'));
		return false;
	}else if(subject.length > 85){
		$.alert($.i18n('infosend.magazine.create.lessThan85Characters'));
		return false;
	}else if(!validataIssue()){
		return false;
	}else if(magazineConfInfos == "" && !useLocalTemplateFile){
		$.alert($.i18n('infosend.magazine.create.journalContent'));
		return false;
	}else if(templateId == "" && !useLocalTemplateFile){
		$.alert($.i18n('infosend.magazine.create.publishedLayout'));
		return false;
	}
	if($("#radio_Audit").attr("checked")=='checked') {
		if($("#auditerIds").val()=='') {
			$.alert('期刊审核人不能为空!');
			return false;
		}
	}
	return true;
}

function validataIssue(){
	var magazineNo = $("#magazine_no").val();
	var patrn=/^[\d]+$/;
	if(magazineNo == "" || !patrn.exec(magazineNo) || magazineNo.length > 4){
		$.alert($.i18n('infosend.magazine.create.fourOfTheNumbers'));
		return false;
	}
	return true;
}

function mainbody_callBack_failed(){

}

function auditSwitch(){
	$("#radio_notAudit").removeAttr("checked");
	$("#radio_Audit").removeAttr("checked");
	if($(this).attr("id") == "radio_notAudit"){
		if(auditerDialog){//顺带吧dialog关闭了
			auditerDialog.close();
		}
		$("#auditer").hide();
		$("#radio_notAudit").attr("checked","checked");
		//$("#publishRange").bind("click",magazineRange);
		/*$("#publishRange").bind("click",function() {
			openMagazinePublishDialog($("#publishRange"));
		});*/
		$("#publishRange").enable();
		isAudit = false;
	}else {
		$("#auditer").show();
		//$("#publishRange").unbind("click");
		$("#publishRange").disable();
		$("#radio_Audit").attr("checked","checked");
		isAudit = true;
	}
}

function selectTemplate(){
	var templateUrl = $("#templates").find("option:selected").attr("fileUrl");
	if(templateUrl == null || templateUrl == "undefined"){
		$("#templateId").val("");//选择默认的，将templateId的值清空
		return ;
	}
	if(_currentTempleteId && _currentTempleteId == $("#templates").find("option:selected").attr("id")){//选择了相同的期刊版式
		$("#templateId").val(_currentTempleteId);
		return;
	}
	
	_currentTempleteId = $("#templates").find("option:selected").attr("id");
	
	/*
	 * OA-58670 修改
	 * if(!validataIssue()){//期号必填
		$("#templates").find("option:selected").removeAttr("selected");
		defaultSelected.attr("selected",true);
		return ;
	}*/
	var keys = fileUploadAttachments.keys();

	//if(keys.size() > 0){
	//if(templateUrl != null && templateUrl != "undefined"){
		//if(keys.size() > 0){//OA-60229修改，没选择消息时，同样切换模版
			var templateId = $("#templates").find("option:selected").attr("id");
			$("#templateId").val(templateId);
			//setOfficeOcxRecordID("-4703500879712992980");//关联officeID,在做套红时，以便吧office的正文内容设置到套红的正文上
			//officetaohong(null,templateUrl,"edoc",null);
			doMagazineTaohong(templateUrl);
		//}
	//}
	//}else {
		//$("#templates").find("option:selected").removeAttr("selected");
		//defaultSelected.attr("selected",true);
		//$.alert("请配置期刊内容！");
	//}
	//var lists = new Properties();
	//for(var p in jsonData){
	//	for(var i=0; i<jsonData[p].length; i++){
	//		maps.put
	//		jsonData[p][i].infoFolder;
	//		jsonData[p][i].infoSubject;
	//	}
	//}
	//$.parseJSON(jsonData);
	//return ;
}

var magazineConfDialog
function magazineConfView(){
	/*
	 *OA-58670 修改，取消提示
	 * if(!validataIssue()){
		return false;
	}*/
	
	var data = new Date();
	magazineConfDialog = $.dialog({
        url: _ctxPath+"/info/magazine.do?method=contentIframe&type=create&data="+data,
        width: "800",
        height: "400",
       	title: $.i18n("infosend.magazine.create.configuration"),
        id:'magazineConfDialog',
        transParams:[window],
        targetWindow:getCtpTop(),
        closeParam:{
            show:true,
            autoClose:false,
            handler:function(){
				magazineConfDialog.close();
            }
        },
        buttons: [{
            id : "okButton",
            btnType : 1,//按钮样式
            text: $.i18n("common.button.ok.label"),
            handler: function () {
        		var atts = magazineConfDialog.getReturnValue();
        		if(atts){
        			//deleteAllAttachment(2,"Doc1");
        			deleteMagzineConfAttachment();
        			for(var i=0;i<atts.length;i++){
        				var att=atts[i];
        				//addAttachmentPoi(att.type,att.filename,att.mimeType,att.createDate,att.size,att.fileUrl,true,false,att.description,null,att.mimeType+".gif","Doc1",att.reference,att.category,null,null,"");
        				addMagzineConfForInfo(att.type,att.filename,att.mimeType,att.createDate,att.size,att.fileUrl,true,false,att.description,null,att.mimeType+".gif","Doc1",att.reference,att.category,null,null,"");
        			}
        		}

        		var keys = fileUploadAttachments.keys();
        		var magazineConfInfos = "";
        		var magazineConfInfoNames = "";
        		for(var i = 0; i < keys.size(); i++) {
        			var att = fileUploadAttachments.get(keys.get(i));
        			magazineConfInfos += att.fileUrl+",";
        			magazineConfInfoNames += att.filename+"、";
        		}
        		if(magazineConfInfoNames.length > 0){
	        		magazineConfInfoNames = magazineConfInfoNames.substring(0, magazineConfInfoNames.length-1);
        		}
        		$("#magazineConf").val(magazineConfInfoNames);
        		$("#magazineConfInfos").val(magazineConfInfos);

        		magazineConfDialog.close();//关闭后尝试套红

        		var templateUrl = $("#templates").find("option:selected").attr("fileUrl");
        		if(templateUrl != null && templateUrl != "undefined"){
        			var templateId = $("#templates").find("option:selected").attr("id");
        			$("#templateId").val(templateId);
        			doMagazineTaohong(templateUrl);
        		}
           }
        }, {
            id:"cancelButton",
            text: $.i18n("common.button.cancel.label"),
            handler: function () {
        		magazineConfDialog.close();
            }
        }]
    });
}

function deleteMagzineConfAttachment(){
	var keys = fileUploadAttachments.keys();
	for(var i = 0; i < keys.size(); i++) {
		var att = fileUploadAttachments.get(keys.get(i));
			fileUploadAttachments.remove(keys.get(i));
			i -= 1;
	}
}

/* 期刊套红 */
function doMagazineTaohong(templateUrl){
	/*
	 * OA-58670 修改
	 * if(!validataIssue()){
		return false;
	}*/
	var keys = fileUploadAttachments.keys();
	var s = "";
	//if(keys.size() > 0){//OA-60229修改，没选择消息时，同样切换模版 
		for(var i = 0; i < keys.size(); i++) {
			s += keys.get(i) + ",";
		}
		var jsonData = {};
		if(s){
			jsonData = magazineManager.getInfoMaps(s); 
		}
		if(typeof(officeEditorFrame)!='undefined' && officeEditorFrame != null && officeEditorFrame.openFileCallBack && officeEditorFrame.doLoadFile){
			officeEditorFrame.doLoadFile(document.getElementsByName("sendForm")[0],templateUrl,null,jsonData);
		} else {
			setTimeout(doMagazineTaohong, "500");
		}
	//}
}

function addMagzineConfForInfo(type, filename, mimeType, createDate, size, fileUrl, canDelete, needClone,
		description, extension, icon, poi, reference, category, onlineView, width, embedInput,hasSaved,
		isCanTransform,v,canFavourite, isShowImg,id){
	  canDelete = canDelete == null ? true : canDelete;
	  needClone = needClone == null ? false : needClone;
	  description = description ==null ? "" : description;
	  if(attachDelete != null) canDelete = attachDelete;
	  if(fileUrl == null){
		  fileUrl=filename;
	  }
	  var attachment = new Attachment(id,reference, poi, category, type, filename, mimeType, createDate, size, fileUrl, description, needClone,extension,icon, false,isCanTransform,v);
	  attachment.showArea=poi;
	  attachment.embedInput=embedInput;
	  attachment.hasSaved =hasSaved;
	  if(canFavourite != null) attachment.canFavourite=canFavourite;
	  if(isShowImg != null) attachment.isShowImg=isShowImg;
	  if(fileUploadAttachment != null){
	    if(fileUploadAttachment.containsKey(fileUrl)){
	      return;
	    }
	    fileUploadAttachment.put(fileUrl, attachment);
	  }else{
	    if(fileUploadAttachments.containsKey(fileUrl)){
	    	fileUrl+=poi;
	    }
	    fileUploadAttachments.put(fileUrl, attachment);
	  }

}

/**弹出发布范围**/
var magazineRangeDialog
function magazineRange(){
	var data = new Date();
	magazineRangeDialog = $.dialog({
        url: _ctxPath+"/info/magazine.do?method=publishRange",
        width: "700",
        height: "500",
       	title: $.i18n("infosend.magazine.create.release"),
        id:'magazineRangeDialog',
        transParams:{"win":window},
        targetWindow:getCtpTop(),
        closeParam:{
            show:true,
            autoClose:false,
            handler:function(){
            	magazineRangeDialog.close();
            }
        },
        buttons: [{
            id : "okButton",
            btnType : 1,//按钮样式
            text: $.i18n("common.button.ok.label"),
            handler: function () {
        		var values = magazineRangeDialog.getReturnValue();
        		if(values==undefined){
        			return;
        		}
        		$("#publishRange").val(values.checkPublistTypes);
        		$("#viewPeopleId").val(values.viewPeopleId);
        		$("#publicViewPeopleId").val(values.publicViewPeopleId);
        		$("#orgSelectedTree").val(values.orgSelectedTree);
        		$("#UnitSelectedTree").val(values.UnitSelectedTree);
        		$("#viewPeople").val(values.viewPeople);
        		$("#publicViewPeople").val(values.publicViewPeople);
        		magazineRangeDialog.close();
           }
        }, {
            id:"cancelButton",
            text: $.i18n("common.button.cancel.label"),
            handler: function () {
            	magazineRangeDialog.close();
            }
        }]
    });
}

function selectOne(type, objTD){
	var flag = false;
	if(type && objTD){
		tempNowSelected.clear();
		if(v3x.getBrowserFlag('selectPeopleShowType')){
			var ops = objTD.options;
			var count = 0;
			for(var i = 0; i < ops.length; i++) {
				var option = ops[i];
				if(option.selected){
					var e = getElementFromOption(option);
					if(e){
						tempNowSelected.add(e);
					}
				}
			}
		}else{
			if(arguments[2]){
				var ops = document.getElementById(arguments[2]).childNodes;
				var count = 0;
				for(var i = 0; i < ops.length; i++) {
					var option = ops[i];
					if(option.getAttribute('seleted')){
						var e = getElementFromOption(option);
						if(e){
							tempNowSelected.add(e);
						}
					}
				}
				selectOneMemberDiv(objTD);
				flag = true;
			}
		}
	}
	if(!v3x.getBrowserFlag('selectPeopleShowType')){
		if(arguments[2]){
			//双击组 选择组
			listenermemberDataBodyDiv(document.getElementById(arguments[2]));
		}else{
			listenermemberDataBodyDiv(document.getElementById(temp_Div));
		}
	}
	if(tempNowSelected == null || tempNowSelected.isEmpty()){
		return;
	}

	var _showAccountShortname = false;
	var unallowedSelectEmptyGroup = getParentWindowData("unallowedSelectEmptyGroup") || false;

	var alertMessageBeyondLevelScop = new StringBuffer();
	var alertMessageEmptyMemberNO = new StringBuffer();
	var alertMessageBeyondWorkScop = new StringBuffer();

	var isCanSelectGroupAccount = getParentWindowData("isCanSelectGroupAccount");
	var isConfirmExcludeSubDepartment = getParentWindowData("isConfirmExcludeSubDepartment");
	for(var i = 0; i < tempNowSelected.size(); i++){
		var element = tempNowSelected.get(i);
		var type = element.type;
		if(type == Constants_Outworker){
			type = Constants_Department;
		}

		if(!checkCanSelect(type)){
			continue;
		}

		if(type == Constants_Account && excludeElements.contains(type + element.id)){
            continue;
        }

		if(!checkExternalMemberWorkScope(type, element.id)){
			continue;
		}

		//内部人员: 当前是外部人员面板，检查外部单位能否直接选择，逻辑：只要有一个不可见，就返回；管理员：只判断人员是否为空
		if(isInternal && tempNowPanel.type == Constants_Outworker && unallowedSelectEmptyGroup && type == Constants_Department && checkCanSelectMember()){
		    var _entity = topWindow.getObject(type, element.id);
		    var _ms = _entity.getAllMembers();

		    if(!_ms || _ms.isEmpty()){
            alertMessageEmptyMemberNO.append(element.name);
            continue;
		    }

		    if(!isAdmin){ //普通用户
		        var extMember = topWindow.ExtMemberScopeOfInternal.get(element.id);
		        if(!extMember){
		            alertMessageEmptyMemberNO.append(element.name);
		            continue;
		        }

		        var isSelect = true;
		        for(var i = 0; i < _ms.size(); i++) {
		            if(!extMember.contains(_ms.get(i).id)){
		                isSelect = false;
		                break;
		            }
		        }

		        if(!isSelect){
		            alertMessageBeyondWorkScop.append(element.name);
		            continue;
		        }
		    }
		}

		if((isCanSelectGroupAccount == false || isGroupAccessable == false) && type == Constants_Account && element.id == rootAccount.id){
			continue;
		}
		//检测越级访问，只要部门/组里面有任何一个人不能选择，则该部门/组不能选择
		if(type != Constants_Member && type != Constants_Department && !checkAccessLevelScope(type, element.id)){
			alertMessageBeyondLevelScop.append(element.name);
			continue;
		}

		//判断是否要子部门 //Constants_Node 工作流用的节点type
		if(( type == Constants_Department || type == Constants_Node ) && isConfirmExcludeSubDepartment){
		    var isShowPageConfirm4Select = false;

		    if(type == Constants_Department){//当前选择的部门
    			var _getChildrenFun = Constants_Panels.get(type).getChildrenFun;

    			var entity = topWindow.getObject(type, element.id);
    			if(entity){
    				datas2Show = eval("entity." + _getChildrenFun + "()");
    			}
    			else{
    				datas2Show = topWindow.findChildInList(topWindow.getDataCenter(type), id);
    			}
    			isShowPageConfirm4Select = datas2Show && !datas2Show.isEmpty();
		    }
		    else if(type == Constants_Node){
		        isShowPageConfirm4Select = element.id.endsWith("DeptMember");
		    }
			if(isShowPageConfirm4Select){
				var _index = element.name.indexOf("(" + $.i18n("selectPeople.excludeChildDepartment") + ")");
				if(_index != -1) {
					element.name = element.name.substring(0, _index);
				}

				//【包含】 true 【不包含】 false【取消】 ''
				var temp = showConfirm4Select(element.name);
				if(temp == '') {
				    continue; //表示不选，跳过
				}
				else if(temp == 'false'){//通过JSP页面来提示是否包含子部门
					element.excludeChildDepartment = true;
					element.name += "(" + $.i18n("selectPeople.excludeChildDepartment") + ")";
				}
				else {
					element.excludeChildDepartment = false;
				}
			}
			if(element.excludeChildDepartment == false) {//包含子部门
				if(!checkAccessLevelScopeWithChildDept(element.id)) {
					alertMessageBeyondLevelScop.append(element.name);
					continue;
				}
			} else {//OA-48542
				if(!checkAccessLevelScope(type, element.id)){//不包含子部门
					alertMessageBeyondLevelScop.append(element.name);
					continue;
				}
			}
		} else {
			if(type == Constants_Department && !checkAccessLevelScope(type, element.id)){
				alertMessageBeyondLevelScop.append(element.name);
				continue;
			}
		}



		var key = type + element.id;

		if(key == "NodeNodeUser" || key == "NodeSenderSuperDept" || key == "NodeNodeUserSuperDept"){
		    continue;
		}

		if(selectedPeopleElements.containsKey(key)){	//??????????????????
			continue; //Exist
		}

		//检测集合里面是否是空的，一般检测部门和组
		if(checkEmptyMember(type, element.id)){
			if(unallowedSelectEmptyGroup){ //不允许选择空组
				alertMessageEmptyMemberNO.append(element.name);
				continue;
			}
			else{
				if(!confirm($.i18n("selectPeople.alertEmptyMember", element.name))){
					continue;
				}
			}
		}
		if(type == Constants_Department && element.excludeChildDepartment == true) {//不包含子部门，父部门下没有人
			if(checkEmptyMemberWithoutChildDept(type, element.id)) {
				if(unallowedSelectEmptyGroup){ //不允许选择空部门
					alertMessageEmptyMemberNO.append(element.name);
					continue;
				}
				else{
					if(!confirm($.i18n("selectPeople.alertEmptyMember", element.name))){
						continue;
					}
				}
			}
		}

		var _accountId = element.accountId || currentAccountId;
		var accountShortname = allAccounts.get(_accountId).shortname;

		element.type = type;
		element.typeName = Constants_Component.get(type);
		element.accountId = _accountId;
		element.accountShortname = accountShortname;

		add2List3(element);
		selectedPeopleElements.put(key, element);
	}

	var sp = $.i18n("common_separator_label");
	var alertMessage = "";
	if(!alertMessageBeyondWorkScop.isBlank()){
	    alertMessage += ($.i18n("selectPeople.alertBeyondWorkScope", alertMessageBeyondWorkScop.toString(sp).getLimitLength(50, "..."))) + "\n\n";
	}
	if(!alertMessageBeyondLevelScop.isBlank()){
		alertMessage += ($.i18n("selectPeople.alertBeyondLevelScope", alertMessageBeyondLevelScop.toString(sp).getLimitLength(50, "..."))) + "\n\n";
	}
	if(!alertMessageEmptyMemberNO.isBlank()){
		alertMessage += ($.i18n("selectPeople.alertEmptyMemberNO", alertMessageEmptyMemberNO.toString(sp).getLimitLength(50, "...")));
	}

	if(alertMessage){
		alert(alertMessage);
	}
}