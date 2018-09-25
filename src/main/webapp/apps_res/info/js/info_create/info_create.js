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



$(document).ready(function () {
	if(formDisableWarning) {
        $.alert('该信息使用的报送单已被停用或删除，将被替换为默认报送单。');
    }
	newInfo_layout = $("#newInfo_layout").layout();
	/** 加载事件 */
   	initClickEvent();
	/** 编辑信息报送回填流程 */
	setSummaryWfXMLInfo();
	/** 设置Toolbar按钮 */
	initToolbar();
	/** 设置单子值 */
	initSummaryData();
	/** 报送单编辑 */
   	infoEditFormDisplay();
   	/** 单子内意见显示 */
   	if(typeof(opinions)!="undefined" && typeof(sendOpinionStr)!="undefined") {
   		dispOpinions(opinions, sendOpinionStr);
   	}
    /** 调整界面：高度 */
   	initStyle();
    /** 初始化附言 */
   	initComments();
   	/**模板设置相关参数*/
   	initParamsFromTemplate();
   	
   	/**没有安装Office，或浏览器不支持Office插件**/
   	if(!hasOffice(contentType)){
   		$.content.switchContentTypeNoComfirm("toolbar", 10);
		contentType = 10;
		bodyType = 'Html';
   	}else{
   		
   		var localOfficeType = getDefaultContentType();//获取用户本地安装的Word类型
   		var localBodyType = getBodyType(localOfficeType);
   		var changeBodyTypeFlag = false;
   		
        if($("#action").val()=="create" || $("#action").val()=="forward"){
        	changeBodyTypeFlag = true;//创建时后台默认为Office Word文档，需要更具用户本地情况进行加载
   		}else {//修改和模版创建时判断是否和原来一致
   			/*if(contentType != localBodyType){
   			    changeBodyTypeFlag = true;
   			}*/
		}
        
        if(changeBodyTypeFlag){
        	//按照用户本地Word安装情况进行正文类型切换(后台写死为Office Word)
       		localOfficeType = parseInt(localOfficeType);
       		$.content.switchContentTypeNoComfirm("toolbar", localOfficeType);
       		contentType = localOfficeType;
    		bodyType = localBodyType;
        }
   		
   		if($("#action").val()=="forward"){//期刊转信息
   			loadMagazineFile();//加载期刊对应的Word文档
   			
   		   //期刊转信息，切换左边菜单显示
   			window.parent.initInfoLeftLocation("listCreateInfo");
	   		window.parent.initInfoBoxDisplay();
   		}
   	}
   	
   	//提示HTML正文无法套红
   	if(contentType == 10){
   		$.alert($.i18n('infosend.alert.htmlCannotTaohong_1'));//当前正文类型为标准正文，标准正文在创建期刊时不能自动套红到期刊中!
   	}
});

/**
 * 通过期刊转信息上报时加载期刊Office文档
 * @return
 */
function loadMagazineFile(){

	if($("#action").val()=="forward"){
		if(window.officeEditorFrame != undefined && officeEditorFrame != null){
			if(officeEditorFrame.page_OcxState == "complete"){//Office文件加载完成
				if(officeEditorFrame.doLoadFile){
					officeEditorFrame.doLoadFile(null,magazineFilePath,null,null);
				}
			}else{
				setTimeout(loadMagazineFile, "500");
			}
		}else{

		}
	}
}

function initParamsFromTemplate(){
	if(fromCallTemplate =='1'){
		$("#canTrack").removeAttr("checked");
		$("#radioall").removeAttr("checked");
		$("#radiopart").removeAttr("checked");
		if(orgnialTemplateFlag =='true'){
			tb.disabled("conotentType");
		}
	}
}

/** 加载单子数据 */
function initSummaryData() {
	/** 设置流程默认值 */
	setDefaultValueWhenIsNull();
	/** 设置跟踪默认值 */
	initTrack();
	//二个下拉列表 流程期限 提前提醒
	selectWriteBack('deadline', deadl);
	selectWriteBack('advanceRemind', advanceR);
	//如果有自定跟踪人反写指定跟踪人
	zdggrWriteBack();
	//设置 转发 改变流程  修改正文  修改附件 归档 流程期限到时自动终止 选择与否
	//setCheckbox();
	//当为流程模板的时候设置一下显示
	//setDetaiwhenisworkflowtemplate();
	//设置一下xml信息
	setwfXMLInfo();
}
/** 保存待发 */
function saveDraft() {
	/** 不弹出离开当前页面提示 */
	isFormSubmit = false;
	/** 设置按钮不可用 */
	disableSendButtions();
	/** 验证信息报送数据 */
	if(!validateSubject()) {
		releaseApplicationButtons();
		return;
	}
	if(!validateAll()) {
		releaseApplicationButtons();
		return;
	}
	/** office设置contentDataId值 */
	setSummaryParam();
	/** 组件保存正文，push正文，流程 */
	$.content.getContentDomains(function(domains) {
        if (domains) {
        	$("#bodyType").val($("#contentType").val());
        	$("#assDocDomain").html("");
            $("#attFileDomain").html("");
            domains.push('assDocDomain');
            domains.push('attFileDomain');
            domains.push('colMainData');
            domains.push('govFormData');
            domains.push('comment_deal');
            saveAttachmentPart("assDocDomain");
            saveAttachmentPart("attFileDomain");
            var jsonSubmitCallBack = function() {
	            setTimeout(function() {
	            	$("#sendForm").attr("action", _path + "/info/infocreate.do?method=saveDraft&listType="+listType);
	            	$("#sendForm").jsonSubmit({
	                    domains : domains,
	                    debug : false,
	                    callback: function(data){
		            		try{
			                    saveWaitSendSuccessTip($.i18n('collaboration.newColl.savePendingOk'));
			                    releaseApplicationButtons();
			                } catch (e) {
			                	releaseApplicationButtons();
			                }
			           	}
	                });
				},300);
            }
            jsonSubmitCallBack();
       }
    }, 'saveAs',null,mainbody_callBack_failed);
}

//存草稿后 ,将summayId的值反写到页面
function endSaveDraft(summaryId,contentId){
	document.getElementById('id').value = summaryId;
	//必须回写moduleId(一个是正文组件,一个是评论组件)
	var obj;
	obj = document.getElementsByName('moduleId');
	for(var i = 0 ; i< obj.length; i ++){
		obj[i].value=summaryId;
	}
	var contentDiv = getMainBodyDataDiv$();
  	$("#id",contentDiv).val(contentId);
	//保存一次草稿后就应该将是否新建业务的数据控制为0
	$("#colMainData #action").val("modify");
	tb.enabled("saveDraft");//保存待发
}

function checkTemplateCanUse(templateId){
	   var govMan = new govTemplateManager();
	   var strFlag = govMan.checkTemplateCanUse(templateId);
	   if(strFlag.flag =='cannot'){
	      return false;
	   }else{
	      return true;
	   }
}


/** 发送 */
function sendInfo(isValidate) {
	/** 不弹出离开当前页面提示 */
	isFormSubmit = false;
	if(isValidate!=false) {
		/** 设置按钮不可用 */
		disableSendButtions();
		/**验证模板是否能用**/
		var tempId = $.trim($("#colMainData #tId").val());
	    if(tempId !=""){//ajax校验 如果包含模板
	          if(!(checkTemplateCanUse(tempId))){
	              $.alert($.i18n('template.cannot.use'));
	              releaseApplicationButtons()
	              return;
	          }
	    }
		/** 验证信息报送数据 */
	    if(!validateSubject()) {
			return;
		}
		if(!validateAll()) {
			releaseApplicationButtons();
			return;
		}
	}
	/** 设置报送信息参数 */
	setSummaryParam();
	/**  */
	isSubmitOperation =  true;
	/** 组件保存正文，push正文，流程 */
	$.content.getContentDomains(function(domains) {
        if (domains) {
        	$("#bodyType").val($("#contentType").val());
        	$("#assDocDomain").html("");
            $("#attFileDomain").html("");
            domains.push('assDocDomain');
            domains.push('attFileDomain');
            domains.push('colMainData');
            domains.push('govFormData');
            domains.push('comment_deal');
            saveAttachmentPart("assDocDomain");
            saveAttachmentPart("attFileDomain");
            var jsonSubmitCallBack = function(){
	            setTimeout(function() {
	            	$("#sendForm").attr("action", _path + "/info/infocreate.do?method=sendInfo");
	            	$("#sendForm").jsonSubmit({
	                    domains : domains,
	                    debug : false,
	                    callback: function(data) {
	                    	parent.leftClickEvent("listInfoReported");
			              	//location.href = "infoList.do?method=listInfoSend&listType=listInfoReported";
			         	}
	             	});
	         	},300);
            }
            jsonSubmitCallBack();
        }
    }, 'send',null,mainbody_callBack_failed);
}

function setSummaryWfXMLInfo() {
	if(wfXmlInfo && wfXmlInfo.trim()!=''){
        $("#workflow_definition #process_xml")[0].value= wfXmlInfo;
    }
}

function setDefaultValueWhenIsNull() {
	new inputChange($("#subject"), $.i18n('common.default.subject.value'));
	if($("#process_info").val() == ""){
	    $("#process_info").val($.i18n('collaboration.default.workflowInfo.value'));
	}
}

function initToolbar() {
	tb = $("#toolbar").toolbar({
        borderLeft:false,
        borderRight:false,
        borderTop:false,
        isPager:false,
        toolbar: [{
            id: "saveDraft",
            name: $.i18n('collaboration.newcoll.save'), //保存待发
            className: "ico16 save_traft_16",
            click:saveDraft
        }, {
            id: "saveAsTemplate",
            name: $.i18n('collaboration.newcoll.saveAsTemplate'), //另存为个人模板
            className: "ico16 save_template_16",
            click:function(){
	        	if(!validateAll()) {
	        		releaseApplicationButtons();
	        		return;
	        	}
            	saveAsTemplete();
            }
        }, {
            id: "showTemplate",
            name: $.i18n('collaboration.newcoll.callTemplate'), //调用模板
            className: "ico16 call_template_16",
            click:function(){
            	handleTemplate();
            }
        }, {
            id: "insert",
            name: $.i18n('collaboration.newcoll.insert'),//插入
            className: "ico16 affix_16",
            subMenu: [{
                id: "localfile",
                name: $.i18n('collaboration.newcoll.localfile'),//本地文件
                click: function () {
                    insertAttachmentPoi('Att');
                }
            }, {
                id: "relative",
                name: $.i18n('collaboration.newcoll.relative'),//关联文档
                click: function () {
                    quoteDocument('Doc1');
                }
            }]
        },{
            id: "conotentType",
            name: $.i18n('collaboration.newcoll.conotentType'),//正文类型
            className: "ico16 text_type_16",
            subMenu: $.content.getMainbodyChooser("toolbar", contentType, _onSelectContentType)
        }, {
            id: "conotentToolbar",
            name: $.i18n('collaboration.colPrint.mainBody'),//正文
            className: "ico16 text_type_16",
            click:function() {
            	updateInfoContent(false,true);
            }
        }]
    });
// 当用系统模板正文类型隐藏
	if(isSystemTemplete){
    	tb.hideBtn("conotentType");
    }
// 当转信息时，正文类型要显示，但是要不可用
	if($("#action").val() == "forward"){
		tb.disabled("conotentType");
	}
}

/**
 * 插入附件回调函数
 */
function insertAtt_AttCallback(){
    autoSet_LayoutNorth_Height();
    $(".affix_del_16").click(function(){
        autoSet_LayoutNorth_Height();
    });
}

/**
 * 插入关联文档回调函数
 */
function quoteDoc_Doc1Callback(){
    autoSet_LayoutNorth_Height();
    $(".affix_del_16").click(function(){
        autoSet_LayoutNorth_Height();
    });
}

/**
 * 切换正文组件执行函数
 */
function _onSelectContentType() {
	/*$.content.switchContentType(_clickMainbodyType, function() {
		if (_lastMainbodyType){
			$("#toolbar").toolbarEnable("_mt_" + _lastMainbodyType);
		}
		$("#toolbar").toolbarDisable("_mt_" + _clickMainbodyType);
		_lastMainbodyType = _clickMainbodyType;
		if('10' == _clickMainbodyType){
			$.alert($.i18n('infosend.alert.htmlCannotTaohong'));//标准正文在创建期刊时不能自动套红到期刊中!
		}
	});*/
	if('10' == _clickMainbodyType){
		$.alert($.i18n('infosend.alert.htmlCannotTaohong'));//标准正文在创建期刊时不能自动套红到期刊中!
	}
}

function initTrack() {
    $("#canTrack").attr("checked","checked");
    trackOrnot();
    document.getElementById("radioall").checked=true;
    if(tracktypeeq2) {//重复发起的时候
		document.getElementById("radiopart").checked= true;
		$("#zdgzry").val(fgzids);
	}
	if(tracktypeeq0) {
	 	$("#canTrack").click();
	 	document.getElementById("radioall").checked= false;
	 	$("#radioall,#radiopart").disable();
	}
}

//跟踪
function trackOrnot(){
  var obj = document.getElementById("canTrack");
  var all = document.getElementById("radioall");
  var part = document.getElementById("radiopart");
  var partText = document.getElementById("zdgzryName");
  $("label[for='radioall']").toggleClass("disabled_color");
  $("label[for='radiopart']").toggleClass("disabled_color");
  if(obj.checked){
      all.checked = true;
      all.disabled = false;
      part.disabled = false;
	  partText.type="hidden";
  }else{
      all.disabled = true;
      part.disabled = true;
      all.checked=false;
      part.checked=false;
	  partText.type="hidden";
  };
}

function zdggrWriteBack(){
	if(vobjtrackids){
		//设置为自定跟踪人
		$("#canTrack").attr('checked','checked');
		trackOrnot();
		$("#radiopart").attr('checked','checked');
		$('#zdgzry').val(vobjtrackids);
		$("label[for='radioall']").toggleClass("disabled_color");
	    $("label[for='radiopart']").toggleClass("disabled_color");
	    $('#zdgzryName').attr("type","hidden");
	}
}

function initStyle() {
	autoSet_LayoutNorth_Height();
	$(".affix_del_16").click(function(){
		autoSet_LayoutNorth_Height();
	});
}

function initComments() {
	trimNbsp();
}

function initClickEvent() {
	//选择流程
	$("#infoPropertyTable #process_info").live('click', function() {
	 		createProcessXml("info",window.top,window,$.ctx.CurrentUser.id,$.ctx.CurrentUser.name,
  	     	$.ctx.CurrentUser.loginAccountName,"shenhe",$.ctx.CurrentUser.loginAccount,'审核',
  	     	"Department,Post,Team",
  	     	"Member,Account,Department,Team,Post");
	});
	//给是否跟踪添加点击事件
	$("#canTrack").bind('click',function(){
	    trackOrnot();
	});
	//指定人单选按钮添加点击时间
	$("#radiopart").bind('click',function(){
		 	$.selectPeople({
		        type:'selectPeople'
		        ,panels:'Department,Post,Team'
		        ,selectType:'Member'
		        ,text:$.i18n('common.default.selectPeople.value')
		        ,hiddenPostOfDepartment:true
		        ,hiddenRoleOfDepartment:true
		        ,showFlowTypeRadio:false
		        ,returnValueNeedType: false
		        ,params:{
		           value:zdgzid
		        }
		        ,targetWindow:getCtpTop()
		        ,callback : function(res){
		        	if(res && res.obj && res.obj.length>0){
		                $("#zdgzry").val(res.value);
						if(res.value.length > 0){
							var zgrArr = res.value.split(",");
							var zddr ="";
							if(zgrArr.length > 0){
								for(var co = 0 ; co<zgrArr.length ; co ++){
									zddr += "Member|" + zgrArr[co]+",";
								}
								if(zddr.length > 0){
									zdgzid = zddr.substring(0,zddr.length - 1);
								}
							}
							//叶方取消信息报送增加显示指定耿总人: trackName(res);
						}
		            } else {

		            }
		        }
		    });
	});
	$("#radioall").bind('click',function(){ 
    	var partText = document.getElementById("zdgzryName");
    	partText.type="hidden";
	 });
	//附言按钮操作
	var adtional_ico_hide = true;
	$("#adtional_ico").click(function () {
		if (adtional_ico_hide) {
			newInfo_layout.setEast(170);
		} else {
			newInfo_layout.setEast(35);
		}
	    $(".editadt_title,.editadt_box").toggleClass("hidden");
	    $(".adtional_text").toggleClass("display_block margin_t_5");
	    $(this).toggleClass("arrow_2_l arrow_2_r");
	    $(this).parent("td").toggleClass("align_center");
	    adtional_ico_hide ? adtional_ico_hide = false : adtional_ico_hide = true;
	    autoSet_TextArea_Height();
	});

	//流程期限和提醒时间的校验
    $("#deadline").bind("change",function(){
		valiDeadAndLcqx(this);
    });
    $("#advanceRemind").bind("change",function(){
		valiDeadAndLcqx(this);
    });

	//发送协同
	$("#sendId").bind('click',function() {
		if(fromSendBack && optionType=='4') {//指定回退
			chooseStepBackWay();
		} else {
			sendInfo();
		}
	});

	$("#formId").change(function() {
		doChangeForm($(this));
	});
}

function validateStepBackData() {
	/** 不弹出离开当前页面提示 */
	isFormSubmit = false;
	/** 设置按钮不可用 */
	disableSendButtions();
	/** 验证信息报送数据 */
	if(!notSpecialCharX($("input[id='my:subject']"))) {
		releaseApplicationButtons();
        return false;
    }
	if(!validateAll()) {
		releaseApplicationButtons();
		return false;
	}
	return true;
}

var chooseStepBackDialog;
function chooseStepBackWay() {
	if(!validateStepBackData()) {
		return false;
	}
	chooseStepBackDialog = $.dialog({
        url:  _ctxPath + "/info/info.do?method=openChooseStepBackWayDialog",
        width: 300,
        height: 200,
        title: $.i18n('infosend.listInfo.pleaseSelect'), //组请选择
        id:'chooseStepBackDialog',
        transParams:window,
        targetWindow:getCtpTop(),
        closeParam:{
            show:true,
            autoClose:false,
            handler:function(){
            	chooseStepBackDialog.close();
            }
        },
        buttons: [{
            id : "okButton",
            text: $.i18n("common.button.ok.label"),
            btnType : 1,//按钮样式
            handler: function () {
            	var choose = chooseStepBackDialog.getReturnValue();
            	if(choose) {
            		chooseStepBackDialog.close();
            		$("#stepBackWay").val(choose);
            		sendInfo(false);
            	}
           }
        }, {
            id:"cancelButton",
            text: $.i18n("common.button.cancel.label"),
            handler: function () {
            	chooseStepBackDialog.close();
            }
        }]
    });
}

function valiDeadAndLcqx(obj){
	var dl = $("#deadline");
	var remind = $("#advanceRemind");
	//流程期限
	if(obj.id=='deadline'){
		if(parseInt(remind[0].value) >= parseInt(dl[0].value) && parseInt(remind[0].value) != 0){
            //未设置流程期限或流程期限小于,等于提前提醒时间
		    $.alert($.i18n('collaboration.newColl.alert.lcqx'));
			remind[0].selectedIndex = 0;
			dl[0].selectedIndex = 0;
		}
	}
	//提醒
	if(obj.id=='advanceRemind'){
		if(parseInt(remind[0].value) >= parseInt(dl[0].value)){
            //未设置流程期限或流程期限小于,等于提前提醒时间
		    $.alert($.i18n('collaboration.newColl.alert.lcqx'));
			remind[0].selectedIndex = 0;
		}
	}
}

function selectWriteBack(selectId,selValue){
	if(selValue){
		var obj = $("#"+selectId)[0];
		for(var count = 0 ; count < obj.length; count ++){
			if(obj[count].value == selValue){
				obj.selectedIndex = count;
				break;
			}
		}
	}
}

function setwfXMLInfo(){
	//Javascript中可以用$.ctx.CurrentUser.xxx(目前javascript中只开放id，name、loginAccount和loginAccountName)
	if(frompeoplecardflag){//人员卡片调用过来的时候设置流程信息
		var obj =[];
		var personArrays= new Array();
		var aPeople= new Object();
		aPeople.id= peoplecardinfoID;
		aPeople.name= peoplecardinfoname;
		aPeople.type= "Member" ;
		aPeople.excludeChildDepartment= false;
		aPeople.accountId= peoplecardinfoaccountid;
		//aPeople.accountShortname='${accountObj.shortName}' ;
		//personArrays.push(aPeople);
		obj[0] = personArrays;
		obj[1]= 1;
		obj[2] = false;//该参数没用了已经
		aPeople.accountShortname='';//不显示
		if(issameaccountflag){
			obj[2] = true;//该参数没用了已经
			aPeople.accountShortname=accountobjsn;
		}
         personArrays.push(aPeople);
		var res = {
				'obj':obj
		}
		createProcessXmlCallBack(window,res,'info',window,
				$.ctx.CurrentUser.id,$.ctx.CurrentUser.name,$.ctx.CurrentUser.loginAccountName,
				"shenhe",$.ctx.CurrentUser.loginAccount,"审核",
				"Department,Post,Team",
	     		"Member,Account,Department,Team,Post");
	}
}

function setCheckbox() {
	if(sumcanforward){
		$("#canForward").removeAttr("checked");
	}
	if(sumcanmodify){
		$("#canModify").removeAttr("checked");
	}
	if(sumcanEdit){
		$("#canEdit").removeAttr("checked");
	}
	if(sumcanEditAtt){
		$("#canEditAttachment").removeAttr("checked");
	}
	if(sumcanArchive){
		$("#canArchive").removeAttr("checked");
	}
	if(sumcanautostop){
		$("#canAutostopflow").attr("checked","checked");
	}
}

function setDetaiwhenisworkflowtemplate(){
	if(isneedsetDetailwhenwftem){//自由协同建立的模板不受这个方法控制
		$("#canForward")[0].disabled= false;
		$("#canForward")[0].checked = false;
		$("#canModify")[0].disabled= true;
		//$("#canModify")[0].checked = true;
		$("#canEdit")[0].disabled= false;
		$("#canEdit")[0].checked = false;
		$("#canEditAttachment")[0].disabled= false;
		$("#canEditAttachment")[0].checked = false;
		$("#canArchive")[0].disabled= false;
		$("#canArchive")[0].checked = false;
		$("#canAutostopflow")[0].disabled= true;
		$("#canAutostopflow")[0].checked = false;
	}
}


function disableSendButtions(){
	  $("#sendId")[0].disabled = true;
	  tb.disabled("saveDraft");//保存待发
	  tb.disabled("showTemplate");//调用模板
	  tb.disabled("insert");//保存待发
	  tb.disabled("conotentType");//正文类型
	  tb.disabled("conotentToolbar");//正文
	  tb.disabled("saveAsTemplate");//存为模板
	  //tb.disabled("print");//打印
	  //$("#sendId").unbind("click");
}

function releaseApplicationButtons(isSubmit){
	$("#sendId")[0].disabled = false;
	tb.enabled("saveDraft");//保存待发
	tb.enabled("showTemplate");//调用模板
	tb.enabled("insert");//保存待发
	tb.enabled("conotentType");//正文类型
	tb.enabled("conotentToolbar");//正文
	tb.enabled("saveAsTemplate");//存为模板
	//tb.enabled("print");//打印
	if(isSubmit) {
		$("#sendId").bind("click",function(){
	   		sendInfo();
		});
	}
}

function closeNewDialog(){
    try{
        var dialogTemp = getCtpTop().newCollDialog;
        if(dialogTemp!=null&&typeof(dialogTemp)!='undefined'){
             getCtpTop().newCollDialog = null;
             dialogTemp.close();
        }
    } catch(e) {}
}

function trimNbsp(){
	try{var trimObj = $("div[id=fuyan]").find("textarea")[0];
    trimObj.innerHTML = $.trim(trimObj.innerHTML);}catch(e){}
}
function setSummaryParam2() {
	if(isOffice($("#contentType").val())) {
		 originalFileId = $("#contentDataId").val();
		 originalCreateDate = createDate;

		 fileId = $.trim(uuidlong) == '' ? getUUID() : uuidlong ;
		 createDate = "";
		 $("#contentDataId").val(fileId);
	}
	$("#bodyType").val(getBodyType($("#contentType").val()));
	//var moduleId = $("#colMainData #id").val();
	var moduleId = $("#colMainData #id").val();
	setSaveContentParam(moduleId, $("input[id='my:subject']").val());

	$("#colMainData #state").val(0);
	$("#colMainData #id").val($("#colMainData #personTid").val());
	$("#colMainData #moduleId").val($("#colMainData #personTid").val());
	//$("#comment_deal #moduleId").val(moduleId);
	//$("#comment_deal #ctype").val(-1);
}

/*********************************************************************************************/
function setSummaryParam() {
	if(isOffice($("#contentType").val())) {
		 originalFileId = $("#contentDataId").val();
		 originalCreateDate = createDate;

		 fileId = $.trim(uuidlong) == '' ? getUUID() : uuidlong ;
		 createDate = "";
		 $("#contentDataId").val(fileId);
	}
	$("#bodyType").val(getBodyType($("#contentType").val()));
	var moduleId = $("#colMainData #id").val();
	setSaveContentParam(moduleId, $("input[id='my:subject']").val());

	$("#colMainData #state").val(0);
	//$("#comment_deal #moduleId").val(moduleId);
	//$("#comment_deal #ctype").val(-1);
}

function validateSubject() {
	/** 验证信息报送数据 */
	if($("input[id='my:subject']").length < 1) {
		if($("#infoSubject").val() != "") {
			$("#infoSubject").attr("id", "my:subject");
		}
	}
	var reportDate= $("input[id='my:report_date']").val();
	if(reportDate == '' ){
		$.alert($.i18n('infosend.reportDate.isNotNull'));
		return false;
	}
	if(!notSpecialCharX($("input[id='my:subject']"))) {
		releaseApplicationButtons();
        return false;
    }
	return true;
}

/**
 * 验证不通过返回false
 */
function validateAll() {
	//如果选择了指定跟踪人员但是又没有选择具体人员的话
	var members=document.getElementById("zdgzry");
	if(members){
		var trackRangePart=document.getElementById("radiopart");
		if(trackRangePart!=null&&trackRangePart.checked&&members.value==""){
            //指定跟踪人不能为空，请选择指定跟踪人！
			$.alert($.i18n('collaboration.newColl.alert.zdgzrNotNull'));
			return false;
		}
	}
	//判断流程是否为空
	var process_lc = document.getElementById("process_info");
	var defaultPro = $("#process_info").attr("defaultValue");
	if (defaultPro==$.trim(process_lc.value)) {
	    $("#process_info").attr("value","");
    }
	if(process_lc && process_lc.value=="") {
	    $.messageBox({
	        'type' : 0,
	        'title':$.i18n('system.prompt.js'),
	        'msg' : $.i18n('collaboration.forward.workFlowNotNull'), //流程不能为空
	        'imgType':2,
	        ok_fn : function() {
	    		$("#process_info").click();
	        }
	    });
		return false;
	}
	/** 验证报送单必填项 */
     for (var i = 0; i < fieldInputListArray.length; i++) {
    	 var  aField = fieldInputListArray[i];
         var  inputObj = document.getElementById(aField.fieldName);
         if (inputObj == null || inputObj.disabled == true) {
             continue;
         }
         if (aField.required == "true" && aField.access == "edit"
                 && inputObj.value.length == 0) {
        	    $.alert($.i18n('govform.info.alert.fieldNotNull',aField.inputName));
             try {
                 document.getElementById(aField.fieldName).focus();
             } catch (e) {
             }
             return false;
         }
     }
	//附言不能超过500子
	if($("#fuyan").find("textarea").val().length > 500){
		 var x =$.i18n('collaboration.fuyan.toolong');
		 var x2 = $('#fuyan').find('textarea').val().length;
		 x.replace("{0}",x2);
		 $.alert(x.replace("{0}",x2));  //发起人附言不能超过500
		return false;
	}
	return true;
}

function notSpecialCharX(element) {
	if(element==null) {
		$.messageBox({
	        'type' : 0,
            'imgType':2,
            'title':$.i18n('system.prompt.js'), //系统提示
	        'msg' : $.i18n('collaboration.common.titleNotNull'),//标题不能为空
	        ok_fn : function() {}
	      });
		return false;
	}
	var value = element.val();
	var inputName = element.attr("inputName");
	if($.trim(value) =="" || value===element.attr("defaultValue")) {
		$.messageBox({
	        'type' : 0,
            'imgType':2,
            'title':$.i18n('system.prompt.js'), //系统提示
	        'msg' : $.i18n('collaboration.common.titleNotNull'),//标题不能为空
	        ok_fn : function() {
	    		element.focus();
	        }
	      });
		return false;
	} else if (value.length > 85) {
	    $.alert($.i18n('collaboration.newColl.titleMaxSize'));  //标题最大长度为85!
	    return false;
	} //else if(!(/^[^\|\\"'<>]*$/.test(value))) {
	else if(!(/^[^\|\\"']*$/.test(value))) {//修改这里的特殊字符限制时请同步修改模版那边信息标题限制
		//writeErrorInfo(element, inputName + $.i18n('collaboration.newColl.tszf')); //不能包含特殊字符（|\"'\<>），请重新输入！
		writeErrorInfo(element, inputName + "不能包含特殊字符（|\"'\），请重新输入！");
		return false;
	}
	return true;
}

function formDevelopAdance4ThirdParty(bodyType,affairId,attitude,opinionContent,currentDialogWindowObj,succesCallBack) {
	try{
		function failedCallBack() {
			releaseApplicationButtons(true);
		}
		if(bodyType != '20' ){
			showMask();
			succesCallBack();
		}else {
			beforeSubmit(affairId, $.trim(attitude), $.trim(opinionContent),currentDialogWindowObj,succesCallBack,failedCallBack);
			showMask();
		}
	}catch(e){
		alert("表单开发高级异常!"+e.message);
	}
}

function mainbody_callBack_failed(e){
	// alert("error:"+e);
	  releaseApplicationButtons();
	  return;
}

///设置layout_north高度
function autoSet_LayoutNorth_Height() {
	newInfo_layout.setNorth($("#north_area_h").height());
	autoSet_TextArea_Height();
}

//设置附言textarea高度
function autoSet_TextArea_Height(){
	var textarea = $("#fuyan #content").hide();
	var h=textarea.parents("table").height()-55;
	textarea.height(h).show().focus();
}

function writeErrorInfo(element, message){
	$.alert(message);
	try{
		element.focus();
		element.select();
   }catch(e){}
}

// 保存提示
function saveWaitSendSuccessTip(content){
    var htmlContent="<div id='saveTip' class='align_center over_auto padding_5' style='color:#ffffff;width:130px; z-index:900; background-color:#85c93a;'>"+content+"</div>";
    var _left=($("#toolbar").width()-130)/2;
    var _top=$("#toolbar").offset().top;
    var panel = $.dialog({
        id:'saveTip',
        width: 140,
        height: 24,
        type: 'panel',
        html: htmlContent,
        left:_left,
        top:_top,
        shadow:false,
        panelParam:{
            show:false,
            margins:false
        }
    });
    setTimeout(function(){
        panel.close();
    },2000);
  }
//截取跟踪指定人长度
function trackName(res){
	var userName="";
	var nameSprit="";
	if(res.obj.length>0){
  	for(var co = 0 ; co<res.obj.length ; co ++){
	   userName+=res.obj[co].name+",";
	}
  	userName=userName.substring(0,userName.length-1);
  	//只显示前三个名字
  	nameSprit=userName.split(",");
  	if(nameSprit.length>3){
  		nameSprit=userName.split(",", 3);
  	}
  	$("#zdgzryName").attr("title",userName);
	var partText = document.getElementById("zdgzryName");
	 partText.type="text";
	 $("#zdgzryName").val(nameSprit+"...");
 }
}
function validateFuyan(){
	//附言不能超过500子
	if($("#fuyan").find("textarea").val().length > 500){
		 var x =$.i18n('collaboration.fuyan.toolong');
		 var x2 = $('#fuyan').find('textarea').val().length;
		 x.replace("{0}",x2);
		 $.alert(x.replace("{0}",x2));  //发起人附言不能超过500
		 releaseApplicationButtons();
		 return false;
	}
}
