var proce;
var currentPage = "newColl";
var isCheckContentNull = true;
var tb;
var isSubmitOperation; // 直接离开窗口做出提示的标记位
var newColl_layout;// 动态布局layout对象
var calenderOnclickFun;
var _TimeFn;
var nullColor = "#FCDD8B";
var notNullColor = "#FFFFFF";
var opinionTextarea ="";
var nibanSpanObj;
//fb 始终是最新流程 密级，升密用到
var flowSecretLevel_wf;
var newFlag;
function parseIds4Panles(){
	var panlesValue = "";
    var ids = $("#supervisorIds").val().split(',');
    if(ids[0] != ""){
        for(var i = 0;i < ids.length;i++){
            if(i == ids.length -1){
            		panlesValue = panlesValue + 'Member|' + ids[i] ;
            }else {
            		panlesValue = panlesValue + 'Member|' + ids[i] +",";
            }
        }
    }
    return panlesValue;
 }
$(document).ready(function(){
	try{
		if (!isformTemplate){
			$("#centerBar").css("overflow","hidden");
		}
	}catch(e){}

	// 从首页待办栏目 人员卡片中打开的新建协同页面
	if($.trim(getCtpTop().newCollDialog) != ""){
		try{
		  hideLocation();
		}catch(e){}
	}

    newColl_layout=$("#newColl_layout").layout();
    try{
      // 文档中心过来的时候需要打开快捷面板
      if(paramfrom != 'a8genius'){
    	  getCtpTop().showLeftNavigation();
      }
    }catch(e){}
    if(wfXmlInfo && wfXmlInfo.trim()!=''){
        $("#workflow_definition #process_xml")[0].value= wfXmlInfo;
    }
    new inputChange($("#subject"), $.i18n('common.default.subject.value2'));
	if($("#process_info").val() == ""){
	    $("#process_info").val($.i18n('collaboration.default.workflowInfo.value'));
	}
	var toolbarArr = [];
	if(newGovdocView=='1'){
		toolbarArr = [{
	        id: "refresh2",
	        name: $.i18n('collaboration.newcoll.callTemplate'),
	        className: "ico16 call_template_16",
	        click:function(){
	        	handleTemplate();
	        }
	    },{
	        id: "contentType_govdoc",
	        name: $.i18n('collaboration.newcoll.conotentType'),
	        className: "ico16 text_type_16",
	        subMenu: getContentTypeChooser_temp("toolbar",bodyType_govdoc,contentBack,"1")
	    },{
			id: "scan_barcode",
			name: $.i18n('collaboration.govdoc.scanbarcode'),
			className: "ico16 call_template_16",
			click: function(){
				if(openBarCodePort()){
					alert($.i18n('collaboration.govdoc.scanningGun.success'));
				}else{
					alert($.i18n('collaboration.govdoc.scanningGun.fail'));
				}
			}
		} ];
	}else{
		toolbarArr = [{
	        id: "saveDraft",
	        name: $.i18n('collaboration.newcoll.save'),
	        className: "ico16 save_traft_16",
	        click:saveDraft
	    }, {
	        id: "refresh2",
	        name: $.i18n('collaboration.newcoll.callTemplate'),
	        className: "ico16 call_template_16",
	        click:function(){
	        	handleTemplate();
	        }
	    }, {
	        id: "insert",
	        name: $.i18n('collaboration.newcoll.insert'),
	        className: "ico16 affix_16",
	        subMenu: [{
	            id: "localfile",
	            name: $.i18n('collaboration.newcoll.localfile'),
	            click: function () {
	                insertAttachmentPoi('Att');
	            }
	        }, {
	            id: "relative",
	            name: $.i18n('collaboration.newcoll.relative'),
	            click: function () {
	                quoteDocument('Doc1');
	            }
	        }]
	    }, {
	        id: "refresh1",
	        name: $.i18n('collaboration.newcoll.saveAsTemplate'),
	        className: "ico16 save_template_16",
	        click:function(){
	        	saveAsTemplete();
	        }
	    },
//	    {
//	        id: "print",
//	        name: $.i18n('collaboration.newcoll.print'),
//	        className: "ico16 print_16",
//	        click: function(){
//	        	newDoPrint("newCol");
//	        }
//	    },
	    {
	        id: "contentType_govdoc",
	        name: $.i18n('collaboration.newcoll.conotentType'),
	        className: "ico16 text_type_16",
	        subMenu: getContentTypeChooser_temp("toolbar",bodyType_govdoc,contentBack,"1")
	    }, {
	        id: "content_govdoc",
	        name: $.i18n('collaboration.summary.text'),
	        className: "ico16 text_type_16",
	        click: function(){
	        	dealPopupContentWin(true,true);
	        }
	    },{
			id: "scan_barcode",
			name: $.i18n('collaboration.govdoc.scanbarcode'),
			className: "ico16 call_template_16",
			click: function(){
				if(openBarCodePort()){
					alert($.i18n('collaboration.govdoc.scanningGun.success'));
				}else{
					alert($.i18n('collaboration.govdoc.scanningGun.fail'));
				}
			}
		}];
	}
	tb = $("#toolbar").toolbar({
		isPager : false,
        borderLeft:false,
        borderRight:false,
        borderTop:false,
        toolbar: toolbarArr
    });
	disableSendButtions();
	if(!isOfficeSupport){
        disable4Office();
    }
    if(sub_app == "1"||sub_app == "3"){
		//发文没有二维码扫描
		tb.hideBtn("scan_barcode");
	}
	if(ishideconotentType){
    	tb.hideBtn("conotentType");
    }
	$("#cphrase").click(function(){
        showphrase($(this).attr("curUser"));
      });
	// 更多按钮操作
    var moreShow_st = 0;// 更多状态
    $("#show_more").click(function () {
        if (moreShow_st==0) {
            $(this).html(_collapse+'<span class="ico16 arrow_2_t"></span>');
            $(".newinfo_more").show();
            moreShow_st=1;
        }else {
            $(this).html(_expansion+'<span class="ico16 arrow_2_b"></span>');
            $(".newinfo_more").hide();
            moreShow_st=0;
        }
        autoSet_LayoutNorth_Height();
    });
    // 附言按钮操作
    var adtional_ico_hide = true;
    $("#adtional").click(function () {
    	if (adtional_ico_hide) {
            newColl_layout.setEast(170);
            $("#fuyan_area").show();
        } else {
            newColl_layout.setEast(35);
            $("#fuyan_area").hide();
        }
        $(".editadt_title,.editadt_box").toggleClass("hidden");
        $(".adtional_text").toggleClass("display_block margin_t_5");
        $("#adtional_ico").toggleClass("arrow_2_l arrow_2_r");
        $("#adtional_ico").parent("td").toggleClass("align_center");
        adtional_ico_hide ? adtional_ico_hide = false : adtional_ico_hide = true;

        autoSet_TextArea_Height();
    });
    // 附言默认值
    checkContentOut();
  // 督办人员输入框添加点击事件
    $("#supervisorNames").bind('click',function(){
     var paramsValue =  parseIds4Panles();
   	 $.selectPeople({
	        type:'selectPeople'
	        ,panels:'Department,Team'
	        ,selectType:'Member'
	        ,minSize:0
	        ,text:$.i18n('common.default.selectPeople.value')
	        ,returnValueNeedType: false
	        ,showFlowTypeRadio: false
	        ,onlyLoginAccount:true
	        ,maxSize:10
	        ,params:{
	           value: paramsValue
	        }
	        ,targetWindow:getCtpTop()
	        ,callback : function(res){
	            // 加入一个逻辑 当存在不能删除的督办人员时候 进行检查
               var unCancel = $("#unCancelledVisor").val();
               if("" != unCancel){// 存在模板督办人员的时候
                   var unCancelArray = unCancel.split(",");
                   var flagGoon = true;
                   var cs = res.value.split(",");
                   for(var m = 0 ; m < unCancelArray.length;  m ++){
                       flagGoon =  in_array(unCancelArray[m],cs);
                       if(flagGoon == false){
                           // 模板自带督办人员不允许删除!
                           $.alert($.i18n('collaboration.newCollaboration.templatePersonnelNoDel'));
                           return;
                       }
                   }
               }
// if(res.value != "" && res.value.length > 0){
// var zgrArr = res.value.split(",");
// var zddr ="";
// if(zgrArr.length > 0){
// for(var co = 0 ; co<zgrArr.length ; co ++){
// zddr += "Member|" + zgrArr[co]+",";
// }
// if(zddr.length > 0){
// htdbry = zddr.substring(0,zddr.length - 1);
// }
// }
// }else{
// htdbry = "";
// }
               $("#supervisorNames").val(res.text);
               $("#supervisorIds").val(res.value);
	        }
	    });
   });

    $("#supervisors").attr('readonly','readonly');
    // 指定人单选按钮添加点击时间
     $("#radiopart").bind('click',function(){
    	 $.selectPeople({
    	        type:'selectPeople'
    	        ,panels:'Department,Team,Post,Outworker,RelatePeople'
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
     	               // 定义获取指定人名称
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
							 trackName(res);

						}
     	            } else {

     	            }
    	        }
    	    });
    });
    $("#radioall").bind('click',function(){
    	//清空指定跟踪人员
    	$("#zdgzry").val("");
		$("#zdgzryName").val("");
		zdgzid = "";
    	var partText = document.getElementById("zdgzryName");
    	partText.style.display="none";
	 });
    // lilong
    $("#process_info").tokenInput();// 快速选人组件
    // 编辑流程
    $("#workflowInfo").bind('click',function(){
        tidyDatas("process_info");
    });

   // 给是否跟踪添加点击事件
     $("#canTrack").bind('click',function(){
         trackOrnot();
     });

     function sendIdClick(){
    	 if(returnTipe()){
        	 //提交之前判断流程密级
        	 var mProcessXml = $("#process_xml").val();
        	 var mSecretLevel = $("#secretLevel").val();
        	 var supervisorIds = $("#supervisorIds").val();
        	 var zdgzry = $("#zdgzry").val();
        	 var pro = $('#process_info').tokenInput("get");
        	 if (pro != null && pro != "" && pro != "undefined") {
    			pro = getTrueValues(pro);
        	 }
        	 if((mProcessXml == "" && (pro ==null || pro == ""))&&isTemFlag!='true'){
        		 $.alert($.i18n('collaboration.forward.workFlowNotNull'));
        		 return;
        	 }
        	 if($.ctx.plugins.contains('secret')){
        		 $.ajax({url : _ctxPath + "/secret/secretController.do?method=checkWorkflowSecretLevel",
        	    		type: "post",
        	    		dataType: "json",
        	 			data: {
        	 				processXml: mProcessXml,
        	 				secretLevel: mSecretLevel,
        	 				supervisorIds: supervisorIds,
        	 				zdgzry: zdgzry,
        	 				pro: pro,
        	 				processId: workflowId
        	 			}
        	    		 ,success : function(data){
        	 	  			if(data && data.res=="false"){
        	 	  				$.alert(data.msg);
        	 	  				if(data.cause == "workflow"){
        	 	  					$("#process_info").tokenInput("clear");
        	 	  					$("#process_info").val("");
        	 						$("#process_xml").val("");
        	 						tempSelectPeopleElements = null;
        	 	  				}
        	 	  				if(data.cause == "supervisor"){
        	 	  					$("#supervisorIds").val("");
        	 						$("#supervisorNames").val("");
        	 	  				}
        	 	  				if(data.cause == "zdgzry"){
        	 	  					$("#zdgzry").val("");
        	 						$("#zdgzryName").val("");
        	 						zdgzid = "";
        	 	  				}
        	 	  			}else{
        	 	  				sendGovdoc(true);
        					}
        	 	  		}
        	 	  	});
        	 }else{
        		 sendGovdoc(true);
        	 }
    	 }
      }

   // 发送协同
     $("#sendId").bind('click',function(){
    	 commonSend(sendIdClick);
     });

     function sendGovdoc(con){
    	// 判断模板中人员是否符合密级
		if (!templateSecretLevelEnable) {
			$.alert($.i18n('secret.flowcheck.cannot'));
			return;
		}
		var sendDevelop = $.ctp.trigger('beforSendColl');
		if (sendDevelop) {
			// xuker
		// 如果是快速发文，则验证送往单位后，再发送
		// start
		if (isQuickSend == "true") {
			beforeSendCollForEdocQuickSend();
		} else {
			sendCollaboration(con);
		}
		//xuker 如果是快速发文，则验证送往单位后，再发送 end
		} else {
			// TODO 是否给出提示
		}
     }

     $("#canTrack").attr("checked","checked");
     trackOrnot();

     document.getElementById("radioall").checked=true;
     // 流程期限和提醒时间的校验
     var deadLineSelect = $("#deadLineselect");
     $("#deadLineselect option[value='0']").remove();// 删除第一项 “无”

     deadLineSelect.prepend("<option value='-1'>"+$.i18n('collaboration.deadline.custom')+"</option>");  // 增加
																											// “自定义”到第一个位置
     deadLineSelect.prepend("<option value='0'>"+$.i18n('collaboration.deadline.no')+"</option>");  // 增加“无”到第一个位置
	 var mycal = $("#deadLineDateTime");
     var deadLineObj=$("#deadLine");
     if(deadLineObj.val()){
         deadLineSelect.val(deadLineObj.val());// 从待发或者模板中打开回写流程期限
          if(!isSysTem){// 不是系统模板
            $("#canAutostopflow")[0].disabled = false;// 把 流程期限到时自动终止 设置为可选
         }
     }else{
        deadLineSelect.val(0);// 从待发或者模板中打开回写流程期限
     }
     var isResetRemaind=false;// 是否重置提前提醒时间
     // 流程期限
     if (deadLineSelect&&deadLineSelect.length==1) {
        var deadLineTime = deadLineSelect[0].value;
        if(deadLineTime&&deadLineTime!="-1"&&deadLineTime!="0"){
            // 日期计算
            var dateValueStr = getDateTimeValue(deadLineTime);
            if (mycal) {
                mycal.val(dateValueStr);
            }
            $("#deadLineCalender").css("display","block");
            $("#deadLineDateTime").attr("disabled",true);
            // 把日期控件按钮的点击事件去掉
            calenderOnclickFun=$("#deadLineCalender .calendar_icon")[0].onclick;
            $("#deadLineCalender .calendar_icon")[0].onclick=null;
        }else if(deadLineTime!="0"){
        	var deadLineStr=$("#deadLineDateTimeHidden").val();
            if(deadLineStr){
                mycal.val(deadLineStr);
                $("#deadLineCalender").css("display","block");
            }else{// 保存的时候设置了自定义，但是清空了时间内容
                deadLineSelect.val(0);
                $("#deadLineCalender").css("display","none");
                isResetRemaind=true;
            }
        }
     }

     $("#deadLineselect").bind("change",function(){
 		valiDeadAndLcqx(this);
     });
     $("#advanceRemind").bind("change",function(){
 		valiDeadAndLcqx(this);
     });
     // 不是新建的协应该加入 页面上 本应该存在的数据
     initFromData();
   // 初始化附件关联文档
     autoSet_LayoutNorth_Height();
     $(".affix_del_16").click(function(){
         autoSet_LayoutNorth_Height();
     });
   // 是否做出提示 当调用模板的时候 不存在部门主管
     warnforSupervise();
     var newDialog= getCtpTop().newCollDialog;
     if(newDialog == null){// 页面离开是调用
          $.confirmClose();
     }
     trimNbsp();
     if(tracktypeeq2){// 重复发起的时候
 		document.getElementById("radiopart").checked= true;
 		$("#zdgzry").val(fgzids);
 	}
 	if(tracktypeeq0){
 	 	$("#canTrack").click();
 	 	document.getElementById("radioall").checked= false;
 	 	$("#radioall,#radiopart").disable();
 	}
 	try{
	 	if($("#canTrackWorkFlowTd")[0].outerText.trim() =='由撤销/回退人决定'){
	 		$("#canTrackWorkFlow").val(0);
	 	}else if($("#canTrackWorkFlowTd")[0].outerText.trim() =='追溯'){
	 		$("#canTrackWorkFlow").val(1);
	 	}else if($("#canTrackWorkFlowTd")[0].outerText.trim() =='不追溯'){
	 		$("#canTrackWorkFlow").val(2);
	 	}
 	}catch(e){
 		$("#canTrackWorkFlow").val(0);
 	}

 	// 表单正文需要判断一下是否有签章字段
 	if(bodyType == '20'){
 		// document.zwIframe.checkInstallHw(disable4Hw);
 	}
 	// 如果是PDF的不让修改正文
 	if (bodyType == '45') {
 	        $("#canEdit")[0].disabled = true;
 	        $("#canEdit")[0].checked = false;
 	}
	// 转发到表单撤销到待发编辑，这个时候表单是只读的，并且屏蔽存为模板按钮
 	var contentViewState = $("#contentViewState").val();
 	if(contentViewState == '2'){ // 只读状态
 		  tb.disabled("refresh1");// 存为模板
 		  // 当前协同是转发后的表单,不能修改正文
 		  $("#canEdit").disabled = true;

 	}
 	// 新建协同等选择关联项目时，增加查询功能
 	var projectProperties=new Object();
 	projectProperties["id"]="selectProjectId";
 	projectProperties["name"]="projectIdSelect";
 	projectProperties["class"]="input-100per";
 	//协同模板标记
 	projectProperties["isTemFlag"]=isTemFlag;
 	if(_isProjectDisabled){
 		projectProperties["disabled"] = "disabled";
 	}
 	initProjectSelect(projectProperties,'selectRelatepro',projectId);

	setProcessId();
	if(isResetRemaind){
		var remind = $("#advanceRemind");
		if(remind[0]){
			remind[0].selectedIndex = 0;// 将提前提醒设置为 无
        }
	}
	if( paramfrom != 'waitSend' && !customSetTrackFlag){
		$("#canTrack").click();
		$("#radioall")[0].checked = false;
		$("#radiopart")[0].checked = false;
		$("#radioall,#radiopart").disable();
	}
	var _contentType = $("#contentType").val();
	 if(!$.browser.msie && isOffice_Fun(_contentType)){
		 $("#sendId").unbind("click").css("color","gray");
	 }
	// if(_formTitleText){
		// $("#subject").val('${_formTitleText}');
	// }
	// OA-71692.新建协同 正文显示有问题 见图（暂时先这里处理 以后样式肯定要重新调下）
	if(bIsClearContentPadding){
		//$(".layout_center").css("height","auto");
	}

	if(noselfflow&&templateFlag=="false"&&!vobjTemplateId&&(isQuickSend=='false'||isQuickSend==false)){
		$("#process_info_select_people").css("display","none");
		disableTokenInput("process_info");
		//$("#process_info").attr("defaultValue","<不允许自建流程，请调用模板>");
		//$("#process_info").attr("value","<不允许自建流程，请调用模板>");
		handleTemplate();
	}
	if((isGovdocTemplate == 'true' && contentT != "-1") || "true" == forwardFawen || "true" == isFenban){
		tb.disabled("contentType_govdoc");
	}
});
function disableTokenInput(inputId) {
    var inputStr = "#"+inputId
    $(inputStr).tokenInput("toggleDisabled");
}
// 正文组件打获取正文切换Toolbar定义实现
var _mt_toolbar_id = "", _lastMainbodyType, _mainbodyOcxObj, _clickMainbodyType;
function getContentTypeChooser(toolbarId, defaultType, callBack){
	if (!toolbarId)
		toolbarId = "toolbar";
	_mt_toolbar_id = toolbarId;
	var r = [];
	for ( var i = 0; i < mtCfg.length; i++) {
		var mt = mtCfg[i].mainbodyType;
		mtCfg[i].value = mt;
		mtCfg[i].id = "_mt_" + mt;
		if (defaultType != undefined && defaultType != "") {
			if (mt == defaultType) {
				mtCfg[i].disabled = true;
				_lastMainbodyType = mt;
			}
		} else if (i == 0) {
			mtCfg[i].disabled = true;
			_lastMainbodyType = mt;
		}
		mtCfg[i].click = function() {
			var cmt = $(this).attr("value");
			_clickMainbodyType = cmt;
			if (callBack) {
				switchContentTypeFun(cmt, function() {
					if (_lastMainbodyType)
						$("#" + _mt_toolbar_id).toolbarEnable(
								"_mt_" + _lastMainbodyType);
					$("#" + _mt_toolbar_id).toolbarDisable("_mt_" + cmt);
					_lastMainbodyType = cmt;

					callBack(cmt);
					isSwitchZW = true;
				});
			}
		};
		try {
			if ($.ctx.isOfficeEnabled(mt))
				r.push(mtCfg[i]);
		} catch (e) {
		}
	}
	return r;

}


function switchContentTypeFun(mainbodyType, successCallback) {
	var fnx;
	if($.browser.mozilla){
		fnx = document.getElementById("zwIframe").contentWindow;
	}else{
		fnx = document.zwIframe;
	}

    var contentDiv = fnx.getMainBodyDataDiv$();
	var contentSwitchBeforeId = $("#id",contentDiv).val();
	$("#contentSwitchId").val(contentSwitchBeforeId);
	var confirm = "";
	confirm = $.confirm({
		'msg' : $.i18n('content.switchtype.message'),
		ok_fn : function() {
			if(mainbodyType == 10 || mainbodyType == 20){
				if(clearOfficeFlag)clearOfficeFlag();
			}
			var contentDiv = fnx.getMainBodyDataDiv$();
			if ($("#contentType", contentDiv).val() == mainbodyType) {
				return;
			}
			var _src = "/seeyon/content/content.do?isFullPage=true&_isModalDialog=true&isNew=true";
				_src += "&moduleId=-1&moduleType=1&rightId=&contentType="+mainbodyType;
				fnx.location.href = _src;

			if (successCallback)
				successCallback();
		}
	});
};


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

// ------ready----//

function setProcessId(){
	if(ordinalTemplateIsSys == 'no'){
		$("#workflow_definition > #processId").val("");
	}
}

// 跟踪
function trackOrnot(){
    var obj = document.getElementById("canTrack");
    var all = document.getElementById("radioall");
    var part = document.getElementById("radiopart");
    var partText = document.getElementById("zdgzryName");
    var zdgzry = document.getElementById("zdgzry");
    $("label[for='radioall']").toggleClass("disabled_color");
    $("label[for='radiopart']").toggleClass("disabled_color");
    if(obj.checked){
        all.checked = true;
        all.disabled = false;
        part.disabled = false;
    }else{
        all.disabled = true;
        part.disabled = true;
        all.checked=false;
        part.checked=false;
        partText.value ='';
        zdgzry.value = "";
    };
}
function  isOffice_Fun(bodyType){
	if($.trim(bodyType) == ""){
		return false;
	}else if(parseInt(bodyType) >= 41 && parseInt(bodyType) <=45){
		return true;
	}else{
		return false;
	}
}

function resetFileId4Clone(){
	var fnx;
	if($.browser.mozilla){
		fnx = document.getElementById("zwIframe").contentWindow;
	}else{
		fnx = document.zwIframe;
	}
	if(istranstocol || _callTemplateId!=''){
		 if(isOffice_Fun(fnx.$("#contentType").val())){
			 fnx.originalFileId = fnx.$("#contentDataId").val();
			 fnx.originalCreateDate = fnx.createDate;

			 fnx.fileId = $.trim(uuidlong) == '' ? getUUID() : uuidlong ;
			 fnx.createDate = "";
			 fnx.$("#contentDataId").val(fnx.fileId);
		 }
	}
}
// 验证流程期限是小于当前系统时间
function sendCheckDeadlineDatetime(){
  var calDateTime = $("#deadLineDateTime");
  var nowDatetime=new Date();
  if(calDateTime[0]){
    if(calDateTime.val()!="" && (nowDatetime.getTime()+server2LocalTime) > new Date(calDateTime.val().replace(/-/g,"/")).getTime()){
    	$.alert($.i18n('collaboration.newcoll.processTimeEarlier'));
        return true;
     }
  }
  // 保存的时候，如果流程期限是空的，则把提前提醒设置为 无
  var mycal=$("#deadLineDateTime");
  var remind = $("#advanceRemind");
  if(mycal[0]&&remind[0]){
      if(mycal[0].value==""){
          remind[0].selectedIndex = 0;
      }
  }
  return false;
}
// 发送协同事件
var sendCount = 0;
var isSwitchZW = false;

function commonSend(curMethod){
	/*var exchange = new govdocExchangeManager();
	if(sub_app == 2){
		var fnx;
		if($.browser.mozilla){
			fnx = document.getElementById("zwIframe").contentWindow;
		}else{
			fnx = document.zwIframe;
		}
		var curContentDataId = fnx.contentDataId.value;
		var curfirm = false;
		try{
			var mark = $("#zwIframe").contents().find("*[mappingfield='doc_mark']").val();
			if(mark!="" && mark!=null && mark.trim()!=""){
				mark = mark +"%"+curSummaryID;
				var test = exchange.validateDocMark(curContentDataId,mark);
				if(test == "haveMark"){
					var confirm = $.confirm({
				        'msg': "该文号收文中已存在，是否继续!",
				        ok_fn: function () {curMethod();},
				        cancel_fn:function(){confirm.close();}
				    });
				}else{
					curMethod();
				}
			}else{
				curMethod();
			}
	    }catch(e){}
	}else if(sub_app == 3){
		var markSel = $("#zwIframe").contents().find("*[mappingfield='doc_mark']")[0];
		if(typeof(markSel) !='undefined'){
			try{
				var markOne = markSel.options[markSel.selectedIndex].value;
				var mark="";
				$("#zwIframe").contents().find("*[mappingfield='doc_mark']").each(function(){
					if($(this).val()!="" && $(this).val().split("|") && $(this).val().split("|").length>0) {
						mark += $(this).val().split("|")[1] + ",";
					} else {
						mark+=$(this).val()+",";
					}
				});
				if(mark){
					mark=mark.substr(0,mark.length-1);
					var sId=curSummaryID;
					if(!sId){
						sId=123;
						mark="3&$"+mark;
					}
					var test = exchange.validateDocMark(sId,mark);
					if(test == "haveMark"){
						var confirm = $.alert({
					        'msg': "该文号已存在,请重新选择文号!"
					    });
						return;
					}
				}
			}catch(e){}
		}
		curMethod();
	}else{
		curMethod();
	}*/
	if(curMethod) {
		curMethod();
	}
}

function sendCollaboration(con){
	if(con && con == true){
		sendCollaboration1();
	}else{
		commonSend(sendCollaboration1);
	}
}

function returnTipe(){
	var hasSubject = false;
	var arr = window.frames["zwIframe"].document.getElementsByTagName("input");
	var arr2 = window.frames["zwIframe"].document.getElementsByTagName("select");
	var subjectArr = window.frames["zwIframe"].document.getElementsByTagName("textarea");
	for(var i = 0; i < arr.length;i ++){
		if($(arr[i]).attr("mappingField") == "subject"){
			hasSubject = true;
			$("#subject").val($(arr[i]).val());
		}
		if($(arr[i]).attr("mappingField") == "doc_mark"){
			$("#doc_mark").val($(arr[i]).val());
		}
		if($(arr[i]).attr("mappingField") == "serial_no"){
			$("#serial_no").val($(arr2[i]).val());
		}
	}
	for(var i =0;i<subjectArr.length;i++){
		if($(subjectArr[i]).attr("mappingField") == "subject"){
			hasSubject = true;
			$("#subject").val($(subjectArr[i]).val());
		}
	}
	if(!hasSubject){
		$("#subject").val("");
	}
	for(var i = 0; i < arr2.length;i ++){
		if($(arr2[i]).attr("mappingField") == "doc_mark"){
			$("#doc_mark").val($(arr2[i]).find("option:selected").html());
		}
		if($(arr2[i]).attr("mappingField") == "serial_no"){
			$("#serial_no").val($(arr2[i]).find("option:selected").html());
		}
	}
	/*if(checkExistsSerialNo($("#serial_no").val())){
		$.alert($.i18n('govdoc.serialNo.used'));
		return false;
	}*/
	
	if(checkGovdocMarkUsed($("#doc_mark").val(), "doc_mark")) {
		return false;
	}
	
	if(checkGovdocMarkUsed($("#serial_no").val(), "serial_no")) {
		return false;
	}
	
	/*var markSel = $("#zwIframe").contents().find("*[mappingfield='doc_mark']")[0];"
	if(typeof(markSel) !='undefined'){
		try{
			var mark = markSel.options[markSel.selectedIndex].id;
			if(sub_app == 1 && !mark.endsWith("|2") && !mark.endsWith("|4") && curSummaryID=="" && typeof(resourceCode)!='undefined' && resourceCode == "F20_fawenNewQuickSend"){
				var exchange = new govdocExchangeManager();
				var test = exchange.validateDocMark(123,$("#doc_mark").val());
				if(test && test =="haveMark"){
					alert("公文文号重复,请重新选择!");
					return false;
				}
			}
		}catch(e){
			return true;
		}
	}*/
	return true;
}


function sendCollaboration1(){
	if(sub_app == "1"){
		if(!$.ctx.hasResource("F20_newSend")){
			alert("没有发文权限");
			return;
		}
	}else if(sub_app == "2"){
		if(!$.ctx.hasResource("F20_newDengji")){
			alert("没有收文权限");
			return;
		}
	} else if(sub_app == "3"){
		if(!$.ctx.hasResource("F20_newSign")){
			alert("没有签报拟文权限");
			return;
		}
	}
	if(document.getElementById("govdocBodyType").value == "Ofd"){
		var exchange = new govdocExchangeManager();
		var test = exchange.validateOfdContent(officeParams.fileId);
		if(test == "no"){
			alert("OFD正文不能为空，请打开OFD正文。");
			return;
		}
	}
	//if(returnTipe()){
		sendCount++;
		if(sendCount>1){
			alert("请不要重复点击！");
			sendCount = 0;
			return;
		}

		disableSendButtions();
		var fnx;
		if($.browser.mozilla){
			fnx = document.getElementById("zwIframe").contentWindow;
		}else{
			fnx = document.zwIframe;
		}
	    var project_Id=$("#selectProjectId").val();
		$("#projectId").val(project_Id);
	    isCheckContentNull = true;
		// 检查流程期限是不是比当前日期早
		if (sendCheckDeadlineDatetime()) {
			sendCount = 0;
			releaseApplicationButtons();
			return;
		}
	    // 判断当前窗口是否是window窗口,人员卡片也需要关闭窗口
	    if (getCtpTop().isCtpTop == undefined || getCtpTop().isCtpTop == "undefined" || from == "peopleCard") {
	        $("#isOpenWindow").val("true");
	    }

		if($("#colPigeonhole").val() == "1"){
			$("#archiveId")[0].value="";
			$("#prevArchiveId")[0].value="";
		}

	    isFormSubmit = false;
		if(!notSpecialCharX(document.getElementById("subject"))){
	        releaseApplicationButtons();
	        sendCount = 0;
	 		return false;
		}
		/*if(!notSpecialCharD(document.getElementById("doc_mark"))){//必填项 不是这么判断的
	        releaseApplicationButtons();
	        sendCount = 0;
	 		return false;
		}*/
		var moduleId = $("#colMainData #id").val();
		if($("#curTemId").val() != ""){
			fnx.setSaveContentParam(moduleId,$("#subject").val(),$("#curTemId").val());
		}else{
			fnx.setSaveContentParam(moduleId,$("#subject").val());
		}

		if("true" == $("#resend").val() || (isSwitchZW && $("#newBusiness").val() == '1' )){
			var _cbody = fnx.getMainBodyDataDiv$();
			$("#id",_cbody).val("");
		}

	    // lilong 快速选人组件整理发送流程前的数据
	    tidyDatas("process_info");
		if(validateAll()){
			releaseApplicationButtons();
			sendCount = 0;
			return;
		}
		// 自动触发的新流程 不校验 指定回退不校验
		if(isneedsendcheck){
		    var tempId = $.trim($("#colMainData #tId").val());
		    if(tempId !=""){// ajax校验 如果包含模板
		          if(!(checkTemplateCanUse(tempId))){
		              $.alert($.i18n('template.cannot.use'));
		              releaseApplicationButtons();
		              sendCount = 0;
		              return;
		          }
		    }
		}

		//判断是否是带有正文套红的模版
		var bodyType = document.getElementById("govdocBodyType").value;
		//快速发文 是否选中了套红模板 套过红
		var hasQuickSendTaohong = false;
		if(isQuickSend&&document.getElementById("fileUrl")!=null){
			var str = document.getElementById("fileUrl").value;
			if(str!=""){
				hasQuickSendTaohong = true;
			}
		}
		if(("" != taohongTemplete && taohongTemplete != '-1' && (bodyType == 'OfficeWord' || bodyType == 'WpsWord'))||hasQuickSendTaohong){
			checkOpenState();
			if(getBookmarksCount()>0){
				//if(!confirm($.i18n("collaboration.taohongAlter"))){
				if(confirm($.i18n('govdoc.alert.taoHongAlreadyExists'))){
					/**
					 * 加入浏览器判断，兼容Firefox
					 */
					if(navigator.userAgent.indexOf("MSIE")>0) {
						refreshOfficeLable($(this.window.document.zwIframe.document),1);
					} else {
						refreshOfficeLable($($(this.window.document).find('#zwIframe').prop('contentWindow').document),1);
					}
				}
			}
		}
		var moduleId = $("#colMainData #id").val();
		$("#comment_deal #moduleId").val(moduleId);
		$("#comment_deal #ctype").val(-1);
		if(opinionTextarea!=""){
			$("#content_deal_comment").val(zwIframe.$("#"+opinionTextarea).val());
		}
		if(nibanSpanObj){
			try{nibanSpanObj.val($("#content_deal_comment").val());}catch(e){}
			
		}
		isSubmitOperation = true;
	    fnx.$.content.getContentDomains_newColl(function(domains){
	        if (domains) {
	        	//G6V5.7-保存公文正文--start  验证通过 保存正文
	        	if(!saveGovdocBody()){
	        		return ;
	        	}
	        	//G6V5.7-保存公文正文--end

	            $("#assDocDomain").html("");
	            $("#attFileDomain").html("");

	            saveAttachmentPart("assDocDomain");
	            saveAttachmentPart("attFileDomain");

	            domains.push('assDocDomain');
	            domains.push('attFileDomain');
	            domains.push('colMainData');
	            domains.push('comment_deal');
	            var subData = {
	                domains : domains,
	                debug : false,
	                callback: closeNewDialog
	            }
	            if(_bizConfig){
	            	subData.callback = function(){};
	            }
	            var jsonSubmitCallBack = function(){
	            	setTimeout(function(){
	            		//提交前重置公文文号参数
	  	            	resetMarkParamBeforeSubmit();
	  	            
	  	            	$("#sendForm").jsonSubmit(subData);
	                }, 300);
	            }
	            formDevelopAdance4ThirdParty(fnx.$("#contentType").val(),fnx.$("#contentDataId").val(),"start",fnx.$("#rightId").val(),null,jsonSubmitCallBack,fnx);

	          }
	    }, 'send',null,mainbody_callBack_failed);
	//}
}

function formDevelopAdance4ThirdParty(bodyType,affairId,attitude,opinionContent,currentDialogWindowObj,succesCallBack,fnx$) {
  try{
    function failedCallBack(){
      releaseApplicationButtons();
      fnx$.deleteContentById();
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
/**
 * 表单协同开发高级事件
 *
 * @return
 */
function formAdvanceDevelop(){
    if($("#contentType").val() == '20'){
    	var params = new Object();
    	params["contentDataId" ] =  $("#contentDataId").val();
    	params["operationId" ] =  $("#rightId").val();

	    var formBindEventListener = new collaborationFormBindEventListener();
		var result = formBindEventListener.startFormDevelopmentOfAdvCheck(params);
		if(result != ""){
		$.messageBox({
		    'type' : 0,
		    'title':$.i18n('system.prompt.js'),
		    'msg' : result,
		    ok_fn : function() {
		    }
		  });
		releaseApplicationButtons();
		return false;
		}

    }
	return true;
}
function releaseApplicationButtons(){
	if(typeof(tb) =='undefined'){
		_TimeFn = setTimeout(function(){
			releaseApplicationButtons();
		},500);
		return;
	}else{
		clearTimeout(_TimeFn);
	}
	$("#sendId")[0].disabled = false;

	if(!ishideconotentType){
		tb.enabled("conotentType");// 正文类型
	}
	tb.enabled("insert");// 插入附件
	//xuker add 快速发文 置灰部分按钮 start
	if(isQuickSend=='true'){

	}else{
		tb.enabled("saveDraft");// 保存待发
		tb.enabled("refresh2");// 调用模板
		tb.enabled("refresh1");// 存为模板
		tb.enabled("print");// 保存待发
	}
	sendCount = 0;
	//xuker add 快速发文 置灰部分按钮 end
}

/**
 * 验证不通过返回true
 */
function validateAll(){
	// 如果选择了指定跟踪人员但是又没有选择具体人员的话
	var members=document.getElementById("zdgzry");
	if(members){
		var trackRangePart=document.getElementById("radiopart");
		if(trackRangePart!=null&&trackRangePart.checked&&members.value==""){
            // 指定跟踪人不能为空，请选择指定跟踪人！
			$.alert($.i18n('collaboration.newColl.alert.zdgzrNotNull'));
			return true;
		}
	}
	if(!notSpecialCharX(document.getElementById("subject"))){
        return true;
    }
	// 判断流程是否为空
	var process_lc = document.getElementById("process_info");
	var defaultPro = $("#process_info").attr("defaultValue");
	if (defaultPro==$.trim(process_lc.value)) {
	    $("#process_info").attr("value","");
    }
	if(process_lc && process_lc.value==""){
		if(noselfflow){
			alert("请选择模版!");
			return true;
		}
	    $.messageBox({
	        'type' : 0,
	        'title':$.i18n('system.prompt.js'),
	        'msg' : $.i18n('collaboration.forward.workFlowNotNull'), // 流程不能为空
	        'imgType':2,
	        ok_fn : function() {
                clickProcessInfoButton();// lilong 0327
	    		// $("#process_info").click();
	        }
	      });

		return true;
	}
	// 督办设置验证
	if(!checkSupervisor()){
		return true;
	}
	checkContent();
	// 附言不能超过500子
	if($("#content_coll").val().replace(/\r\n$/ig, "").replace(/\n$/ig, "").replace(/\r$/ig, "").length > 500){
		 var x =$.i18n('collaboration.fuyan.toolong');
		 var x2 = $('#content_coll').val().length;
		 x.replace("{0}",x2);
		 $.alert(x.replace("{0}",x2));  // 发起人附言不能超过500
		return true;
	}
	return false;
}
function returnSubjectTipe(){
	var hasSubject = false;
	var arr = window.frames["zwIframe"].document.getElementsByTagName("span");
	for(var i = 0; i < arr.length;i ++){
		if($(arr[i]).attr("mappingField") == "subject"){
			hasSubject = true;
			$("#subject").val($(arr[i]).text());
		}
		
	}
	return hasSubject;
}
function notSpecialCharX(element){
	var value = element.value;
	var inputName = element.getAttribute("inputName");
	if($.trim(value) ==""  || $("#subject").val() === $("#subject").attr("defaultValue")){
		if(returnSubjectTipe()){
			return true;
		}
		var textInput = $(getDocumentobjByMappingfieldForDengji("subject"));
		textInput.change(function(){
			if($.trim(textInput.val())==""){
				textInput.css("background-color",nullColor);
			}else{
				textInput.css("background-color",notNullColor);
			}
		});
		textInput.trigger("change");
		$.messageBox({
	        'type' : 0,
            'imgType':2,
            'title':$.i18n('system.prompt.js'), // 系统提示
	        'msg' : $.i18n('collaboration.common.titleNotNull'),// 标题不能为空
	        ok_fn : function() {
	    		//element.focus();
	        }
	      });
		return false;
	} else if (value.length > 340) {
	    $.alert("标题字段长度最大为340");  // 标题最大长度为85!
	    return false;
	}
	return true;
}
function notSpecialCharD(element){
	if(element){
		var value = element.value;
		var inputName = element.getAttribute("inputName");
		if($.trim(value) ==""  || $("#doc_mark").val() === "请选择公文文号"){
			$.messageBox({
		        'type' : 0,
	            'imgType':2,
	            'title':$.i18n('system.prompt.js'), // 系统提示
		        'msg' : "文号不能为空!",// 标题不能为空
		        ok_fn : function() {
		    		//element.focus();
		        }
		      });
			return false;
		}
	}
	return true;
}
/**
 * 发起时，验证督办设置
 */
function checkSupervisor(){
	// 设置了督办人员，就必须设置督办时间
	var supervisorId = $("#supervisorIds").val();
	var unCancelledVisor = $("#unCancelledVisor").val();

	var superviseTitle = $("#title")[0].value;
	var rule = /^[^\|\\"'<>]*$/;
	if(!(rule.test(superviseTitle))) {
        // 督办主题包含特殊字符(\|\"<>')请重新录入!
		$.alert(superviseTip);
		return false;
	}

	if(supervisorId){
		var supervisorIdsT = supervisorId.split(",");
		var supervisorIds = new Array();
		for (var i = 0 ; i < supervisorIdsT.length ; i ++) {
			if (supervisorIdsT[i] != null && supervisorIdsT[i].trim() != "")
				supervisorIds.push(supervisorIdsT[i]);
		}

		if(supervisorIds.length > 10){
            // 最多只允许10个人督办,请重新选择督办人!
		    $.alert($.i18n('collaboration.newColl.alert.select10Supervision'));
			return false;
		}

		if(!$("#awakeDate").val()){
            // 请选择督办期限
		    $.alert($.i18n('collaboration.newColl.alert.selectSupervisionPeriod'));
			return false;
		}
		var sVisorsFromTemplate = $("#sVisorsFromTemplate").val();
		if(unCancelledVisor != null && unCancelledVisor != ""){
			var uArray = unCancelledVisor.split(",");
			for(var i=0;i<uArray.length;i++){
				var have = supervisorId.search(uArray[i]);
				if(have == -1){
				    // 模板自带督办人员不允许删除!
                    $.alert($.i18n('collaboration.newCollaboration.templatePersonnelNoDel'));
					return false;
				}
			}
		}
	}else{
		if(unCancelledVisor){
		    // 模板自带督办人员不允许删除!
            $.alert($.i18n('collaboration.newCollaboration.templatePersonnelNoDel'));
			return false;
		}
	}

	var title = $("#title").val();
	if(title && title.length>85){
        // 督办主题长度不能超过200字
	    $.alert($.i18n('collaboration.newColl.alert.supervisionLong85'));
		return false;

	}

	// 设置了督办主题或者督办时间，但没有设置督办人，给出提示
	if(($("#awakeDate").val() || $("#title").val()) && !supervisorId){
        // 请选择督办人员!
	    $.alert($.i18n('collaboration.newColl.alert.selectSupervision'));
		return false;
	}
	//判断系统日期和督办日期，若督办日期小于系统日期，则给出提示
	if($("#awakeDate").val() != '' && (ajaxCalcuteWorkDatetime(0) >= $("#awakeDate").val())){
		var r=confirm($.i18n('collaboration.newColl.thisTimeGrSupTime2'));
		return r;
	}else{
		return true;
	}
}

function mainbody_callBack_failed(e){
	 // alert("error:"+e);
	  releaseApplicationButtons();
	  return;
}
/**
 * 获取指定分钟数后的日期 sc 单位分钟
 */
function getDateTimeValue(sc) {
    // 参数表示在当前日期下要增加的天数
    var now = new Date();
    if(sc){
        switch(sc){
	        case '5':
	        case '10':
	        case '15':
	        case '30':
            case '60':
            case '120':
            case '180':
            case '240':
            case '300':
            case '360':
            case '420':
            case '480':
            case '720':
            case '1440':
            case '2880':
            case '4320':
            case '5760':
            case '7200':
            case '8640':
            case '10080':
            case '20160':
            case '21600':
            case '30240':
            case '43200':
            case '86400':
            case '129600':
            	return ajaxCalcuteWorkDatetime(sc);
                break;
            default:
            	return new Date(now).format("yyyy-MM-dd HH:mm");
        }
    }

    // 2014-03-20 01:10 返回值格式

}
function ajaxCalcuteWorkDatetime(minutes) {
	var colMan = new colManager();
	var ajaxBean = new Object();
	ajaxBean["minutes"] = minutes;
	var workDatetime = colMan.calculateWorkDatetime(ajaxBean);

	return new Date(parseInt(workDatetime)).format("yyyy-MM-dd HH:mm");

}
function ajaxCalcuteNatureDatetime(datetime,minutes) {
	var colMan = new colManager();
	var ajaxBean = new Object();
	ajaxBean["datetime"] = datetime;
	ajaxBean["minutes"] = minutes;
	var workDatetime = colMan.calculateWorkDatetime(ajaxBean);
	return workDatetime;
}
function valiDeadAndLcqx(obj){
	var dl = $("#deadLineselect");
	var remind = $("#advanceRemind");
    var mycal=$("#deadLineDateTime");
	// 流程期限
	if(obj.id=='deadLineselect'){
		$("#deadLine").val(dl.val());// 设置流程期限时间段的值
        var deadLineTime=dl[0].value;
        // 日期计算
        var dateValueStr=getDateTimeValue(deadLineTime);
        if(mycal){
            mycal.val(dateValueStr);
        }
		if(getDateTimeValue(remind[0].value) >= getDateTimeValue(dl[0].value) && parseInt(remind[0].value) != 0){
            // 未设置流程期限或流程期限小于,等于提前提醒时间
		    $.alert($.i18n('collaboration.newColl.alert.lcqx'));
			remind[0].selectedIndex = 0;
			dl[0].selectedIndex = 0;
		}
        if(dl[0].selectedIndex==1){// 选中“自定义”
            $("#deadLineCalender").css("display","block");
            $("#deadLineDateTime").attr("disabled",false);
            $("#deadLineDateTime").attr("readonly",true);
            if(typeof(calenderOnclickFun)!="undefined"){
                $("#deadLineCalender .calendar_icon")[0].onclick=calenderOnclickFun;
            }
        }else if(dl[0].selectedIndex==0){// 选中 “无”
            $("#deadLineCalender").css("display","none");
            $("#deadLineDateTime").attr("value","");
            dl.removeAttr("style");
        }else{
            $("#deadLineCalender").css("display","block");
            // 把日期控件按钮的点击事件去掉
            if($("#deadLineCalender .calendar_icon")[0].onclick!=null){
                calenderOnclickFun=$("#deadLineCalender .calendar_icon")[0].onclick;
            }
            $("#deadLineCalender .calendar_icon")[0].onclick=null;
            $("#deadLineDateTime").attr("disabled",true);
        }
		setAutoEnd();
		// 没有设置流程期限或者是调用的模板的时候，流程自动终止应该置灰
        if((dl.val()!="-1"&&dl.val()<=0) || (isTemFlag =='true' && isSysTem)){
            $("#canAutostopflow")[0].checked = false;
            $("#canAutostopflow")[0].disabled = true;
        }else{
            $("#canAutostopflow")[0].disabled = false;
        }
	}
	// 提醒
	if(obj.id=='advanceRemind'){
        var deadlineDateTimeR="";
        if(dl[0].value=="-1"){// 自定义的时候直接取控件上的日期值
            if(mycal){
                deadlineDateTimeR=mycal.val();
                if(deadlineDateTimeR == ""){
                    // 未设置流程期限或流程期限小于,等于提前提醒时间
                    $.alert($.i18n('collaboration.newColl.alert.lcqx'));
                    remind[0].selectedIndex = 0;
                }
                if(parseInt(remind[0].value) != 0){
                	var remaindDatetime=ajaxCalcuteNatureDatetime(deadlineDateTimeR,remind[0].value);
                	var nowDatetime=new Date();
                	if(remaindDatetime<nowDatetime.getTime()+server2LocalTime){
                		$.alert($.i18n('collaboration.newColl.alert.lcqx'));
                		remind[0].selectedIndex = 0;
                	}
                }
            }
        }else{
            if(parseInt(remind[0].value) >= parseInt(dl[0].value) && parseInt(remind[0].value) != 0){
            	// 未设置流程期限或流程期限小于,等于提前提醒时间
            	$.alert($.i18n('collaboration.newColl.alert.lcqx'));
            	remind[0].selectedIndex = 0;
            }
        }
	}
}

function setAutoEnd(){
	if(parseInt($("#deadLine").val()) == 0 || isSysTem){// 系统模板的话也不能设置
		$("#canAutostopflow").removeAttr("checked");
		$("#canAutostopflow")[0].disabled = true;
	}else{
		$("#canAutostopflow").removeAttr("disabled");
	}
}

// 初始化加载表单数据
function initFromData(){
	// 三个下拉列表 重要程度 流程期限 提前提醒
	selectWriteBack('importantLevel',importantL);
	selectWriteBack('deadLine',deadl);
	selectWriteBack('advanceRemind',advanceR);
	// 如果有自定跟踪人反写指定跟踪人
	zdggrWriteBack();
	// 督办相关信息数据回填
	superviseWriteBack();
	// 设置 转发 改变流程 修改正文 修改附件 归档 流程期限到时自动终止 选择与否
	setCheckbox();
	// 重复发起的时候不能修改协同标题
	setCanEditSubject();
	// 重复发起设置summaryI为空
	setResetInfo();
	// 当为流程模板的时候设置一下显示
	setDetaiwhenisworkflowtemplate();
	// 设置更多里面的细节按钮
	setDetailwhenTemplate();
	// 设置基准时长显示
	setStandardDuration();
	// 设置一下xml信息
	setwfXMLInfo();
	 if(_callTemplateId && _callTemplateId != '' ){
		 setPageMenu();
	 }
};

function selectWriteBack(selectId,selValue){
	if(selValue){
		var obj = $("#"+selectId)[0];
		if(obj) {
			for(var count = 0 ; count < obj.length; count ++){
				if(obj[count].value == selValue){
					obj.selectedIndex = count;
					break;
				}
			}
		}
	}
}

function zdggrWriteBack(){
	if(vobjtrackids){
		// 设置为自定跟踪人
		$("#canTrack").attr('checked','checked');
		trackOrnot();
		$("#radiopart").attr('checked','checked');
		$('#zdgzry').val(vobjtrackids);
		$("label[for='radioall']").toggleClass("disabled_color");
	    $("label[for='radiopart']").toggleClass("disabled_color");
	}
	if(''!=fgzids){
		var colTrack = new trackManager();
    	var params = new Object();
        params["userId"] = fgzids;
        var strName=colTrack.getTrackName(params);
        $("#zdgzryName").val(strName);
        $("#zdgzryName").attr("title",strName);
        var partText = document.getElementById("zdgzryName");
        partText.style.display="";

	}
}

function superviseWriteBack(){
	// 督办人员名称
	if(vobjcolsupnames){
		$('#supervisors').val(vobjcolsupnames);
	}
	// 督办人员IDS
	if(vobjcolSupors){
		$("#supervisorIds").val(vobjcolSupors);
	}
	// 督办日期
	if(vobjcolsupDate){
		$("#awakeDate").val(vobjcolsupDate);
	}
}

function setCheckbox(){
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

function setCanEditSubject(){
	if(vobjreadonly){
		$("#subject").attr("readOnly","true");
	}
}

function setResetInfo(){
	  if($("#colMainData #resend").val() =='true'){
  	    var contentDiv = $("#mainbodyDataDiv_"+$("#_currentDiv").val());
          $("#id",contentDiv).val(-1);
          $("#workflow_definition #processId").val("");
          $("#workflow_definition #caseId").val("");
          $("#colMainData #caseId").val("");
	  }
}

function setDetaiwhenisworkflowtemplate(){
	if(isneedsetDetailwhenwftem){// 自由协同建立的模板不受这个方法控制
		$("#canForward")[0].disabled= false;
		$("#canModify")[0].disabled= true;
		$("#canEdit")[0].disabled= false;
		$("#canArchive")[0].disabled= false;
		$("#canEditAttachment")[0].disabled= false;
		$("#canAutostopflow")[0].disabled= true;
	}
}

function setDetailwhenTemplate(){
	var deadLine = $("#deadLine")[1];// 流程期限
	var colPigeonhole = $("#colPigeonhole")[0];// 归档信息
	var advanceRemind = $("#advanceRemind")[1];// 提前提醒
	var canForward = $("#canForward")[0];
	var canModify = $("#canModify")[0];
	var canEdit = $("#canEdit")[0];
	var canEditAttachment = $("#canEditAttachment")[0];
	var canArchive = $("#canArchive")[0];
	var canAutostopflow = $("#canAutostopflow")[0];
	if(vobjparentColTem){// 本身或者父是系统协同模板
		canForward.disabled = true;
		canModify.disabled = true;
		canEdit.disabled = true;
		canEditAttachment.disabled = true;
		canArchive.disabled = true;
		canAutostopflow.disabled = true;
	// }else if('${vobj.parentTextTemplete}' =='true'){//本身或者父是系统格式模
	}
	if(vobjparenttexttype){
		canForward.disabled = false;
		canModify.disabled = false;
		canEdit.disabled = false;
		canEditAttachment.disabled = false;
		canArchive.disabled = false;
		canAutostopflow.disabled = true;
	}
	if(vobjparentwftem){// 本身或者父是系统流程模板
		canForward.disabled = false;
		canModify.disabled = true;
		canEdit.disabled = false;
		canEditAttachment.disabled = false;
		canArchive.disabled = false;
		//OA-75234
		//canAutostopflow.disabled = false;
	}
}

function setStandardDuration(){
		var sc = vobjstanddur;
		var standdc = document.getElementById("standdc");
		if(sc){
			switch(sc){
			 	case '0':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.no'); // 无
			 		break;
			 	case '60':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.one.hour'); // 1小时
			 		break;
			 	case '120':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.two.hour'); // 2小时
			 		break;
			 	case '180':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.three.hour'); // 3小时
			 		break;
			 	case '240':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.four.hour'); // 4小时
			 		break;
			 	case '300':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.five.hour'); // 5小时
			 		break;
			 	case '360':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.six.hour'); // 6小时
			 		break;
			 	case '420':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.seven.hour'); // 7小时
			 		break;
			 	case '1440':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.one.day'); // 1天
			 		break;
			 	case '2880':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.two.day'); // 2天
			 		break;
			 	case '4320':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.three.day'); // 3天
			 		break;
			 	case '5760':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.four.day'); // 4天
			 		break;
			 	case '7200':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.five.day'); // 5天
			 		break;
			 	case '8640':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.six.day'); // 6天
			 		break;
			 	case '10080':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.one.week'); // 1周
			 		break;
			 	case '20160':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.two.week'); // 2周
			 		break;
			 	case '21600':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.half.month'); // 半个月
			 		break;
			 	case '30240':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.three.week'); // 3周
			 		break;
			 	case '43200':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.one.month'); // 1个月
			 		break;
			 	case '86400':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.two.month'); // 2个月
			 		break;
			 	case '129600':
			 		standdc.innerHTML=$.i18n('collaboration.deadline.three.month'); // 3个月
			 		break;
			}
		}
}

function setwfXMLInfo(){
	// Javascript中可以用$.ctx.CurrentUser.xxx(目前javascript中只开放id，name、loginAccount和loginAccountName)
	if(frompeoplecardflag){// 人员卡片调用过来的时候设置流程信息
		var obj =[];
		var personArrays= new Array();
		var aPeople= new Object();
		aPeople.id= peoplecardinfoID;
		aPeople.name= peoplecardinfoname;
		aPeople.type= "Member" ;
		aPeople.excludeChildDepartment= false;
		aPeople.accountId= peoplecardinfoaccountid;
		// aPeople.accountShortname='${accountObj.shortName}' ;
		// personArrays.push(aPeople);
		obj[0] = personArrays;
		obj[1]= 1;
		obj[2] = false;// 该参数没用了已经
		aPeople.accountShortname='';// 不显示
		if(issameaccountflag){
			obj[2] = true;// 该参数没用了已经
			aPeople.accountShortname=accountobjsn;
		}
         personArrays.push(aPeople);
		var res = {
				'obj':obj
				}
		createProcessXmlCallBack(window,res,'collaboration',window,
				$.ctx.CurrentUser.id,$.ctx.CurrentUser.name,$.ctx.CurrentUser.loginAccountName,
				"collaboration",$.ctx.CurrentUser.loginAccount,"协同");
	}
}

// /设置layout_north高度
function autoSet_LayoutNorth_Height() {
    newColl_layout.setNorth($("#north_area_h").height() + 10);
    autoSet_TextArea_Height();
}

// 设置附言textarea高度
function autoSet_TextArea_Height(){
		var textarea=$("#content_coll").hide();
	    var h=textarea.parents("table").height()-55;
	    textarea.height(h).show();
}

function warnforSupervise(){
	if(warnforsupervise){
        // 模板设置了部门主管为督办人员，但该部门没有指定主管！
		$.alert($.i18n('collaboration.newColl.alert.warnforSupervise'));
	}
}

function trimNbsp(){
	try{var trimObj = $("div[id=fuyan]").find("textarea")[0];
    trimObj.innerHTML = $.trim(trimObj.innerHTML);}catch(e){}
}

/*
 * 判断在数组中是否含有给定的一个变量值 参数： needle：需要查询的值 haystack：被查询的数组
 * 在haystack中查询needle是否存在，如果找到返回true，否则返回false。 此函数只能对字符和数字有效
 */
 function in_array(needle,haystack){
		for(var i in haystack){
			if(haystack[i] == needle){
				return true;
			}
		}
		return false;
 }

 function setSummaryId(){
		var cfrom = paramfrom;
		if(cfrom && 'resend' == cfrom){
			// 设置重复发起的标记
			var isResend = document.createElement('input');
			isResend.type ='hidden';
			isResend.id="resend";
			isResend.name="resend";
			isResend.value="1";
			document.getElementById('colMainData').appendChild(isResend);
		}
}

 var isOfficeSupport = true;
 function officeNotSupportCallback(){
 	isOfficeSupport = false;
 }
 function disable4Office(){
 	$("#sendId")[0].disabled = true;// 发送
 	tb.disabled("saveDraft");// 保存待发
 	tb.disabled("refresh1");// 存为模板
 }
 function disable4Hw(){
	$("#sendId")[0].disabled = true;// 发送
 }
 function endProgressBar(){
	  // if(typeof(proce)!='undefined'){
	   // proce.close();
	 // }
		 hideMask();
}

 function disableSendButtions(){
	  $("#sendId")[0].disabled = true;
	  tb.disabled("saveDraft");// 保存待发
	  tb.disabled("refresh2");// 调用模板
	  tb.disabled("insert");// 保存待发
	  tb.disabled("conotentType");// 正文类型
	  tb.disabled("refresh1");// 存为模板
	  tb.disabled("print");// 保存待发
}

function __weixinClose(){
	try{
		//关闭微信当前窗口
		WeixinJSBridge.invoke('closeWindow',{},function(res){
		});
	 }catch(e){
	 }
}

function closeNewDialog(){
     // 判断当前页面是否是主窗口页面
     try{
         if (getCtpTop().isCtpTop) {
             var  _win = getCtpTop().$("#main")[0].contentWindow;
             var url = _win.location.href;
             try{
                 _win.location = _ctxPath +"/collaboration/collaboration.do?method=listSent";
             }catch(e){
                 _win.location =  _win.location;
             }
         } else {

        	 __weixinClose();
        	 var _win;
        	 //5.7新公文dom结构有变动，应该为detailIframe
        	 if(undefined != getCtpTop().opener.getCtpTop().$("#main")[0].contentWindow.detailIframe){
        		 _win = getCtpTop().opener.getCtpTop().$("#main")[0].contentWindow.detailIframe;
        	 }else{
        		 _win = getCtpTop().opener.getCtpTop().$("#main")[0].contentWindow;
        	 }
             if (_win != undefined) {
                 // 判断当前是否是首页栏目
                 if (_win.sectionHandler != undefined) {
                     getCtpTop().opener.getCtpTop().removeAllWindow();
                     // 首页栏目（当点击了统计图条件后处理）
                     if (_win.params != undefined && _win.params.selectChartId != "") {
                         _win._collCloseAndFresh(_win.params.iframeSectionId,_win.params.selectChartId,_win.params.dataNameTemp);
                     } else {
                         // 进入首页待办栏目直接处理
                         _win.sectionHandler.reload("pendingSection",true);
                         _win.sectionHandler.reload("sentSection",true);
                         _win.sectionHandler.reload("waitSendSection",true);
                     }
                 } else {
                     // 刷新列表
                     var url = _win.location.href;

                   // 项目栏目协同刷新
                  	try{
                  		getCtpTop().opener.getA8Top().$("#main")[0].contentWindow.$("#body")[0].contentWindow.sectionHandler.reload("projectCollaboration",true);
                 	 }catch(e){}


                     if ((url.indexOf("collaboration") != -1 || url.indexOf("govDoc") != -1) && (url.indexOf("listSent") != -1 || url.indexOf("listWaitSend") != -1 || url.indexOf("moreWaitSend") != -1 )) {
                         _win.location =  _win.location;
                     } else {
                         // 业务生成器、生成的列表嵌入到了iframe下。也要刷新待发列表
                         try{
                             var _win2 = _win.$.find('iframe');
                             if (_win2 != undefined && _win2[0] != undefined) {
                                 var url = _win2[0].src;
                                 if (url.indexOf("collaboration") != -1 && url.indexOf("listWaitSend") != -1) {
                                     _win.location =  _win.location;
                                 }
                             }
                         }catch(e){}
                     }

                 }
             }
             removeCtpWindow(affairId,2);
         }
     }catch(e){
     }
     window.close();
}

 /**
	 * 提交前把disabled的属性去掉，数据才能正常提交到后台
	 */
 function enableAdvanceOper(){
 	var canForward = document.getElementById("canForward");
 	var canModify = document.getElementById("canModify");
 	var canEdit = document.getElementById("canEdit");
 	var canEditAttachment = document.getElementById("canEditAttachment");
 	var canArchive = document.getElementById("canArchive");
 	canForward.disabled = false;
 	canModify.disabled = false;
 	canEdit.disabled = false;
 	canEditAttachment.disabled = false;
 	canArchive.disabled = false;
 }

 function addAction4Send(){
	 $("#sendId").unbind('click').bind('click',function(){
		 var sendDevelop = $.ctp.trigger('beforSendColl');
		 if(sendDevelop){
			 sendCollaboration();
		 }else{
			 // TODO 是否给出提示
		 }
	 });
 }

 function saveDraft(){
		//判断模板中人员是否符合密级
		 if(!templateSecretLevelEnable){
			 $.alert($.i18n('secret.flowcheck.cannot'));
			 return;
		 }
	 	var arr = window.frames["zwIframe"].document.getElementsByTagName("input");
		for(var i = 0; i < arr.length;i ++){
			if($(arr[i]).attr("mappingField") == "subject"){
				$("#subject").val($(arr[i]).val());
			}
		}
		var arr1 = window.frames["zwIframe"].document.getElementsByTagName("textarea");
		for(var i = 0; i < arr1.length;i ++){
			if($(arr1[i]).attr("mappingField") == "subject"){
				$("#subject").val($(arr1[i]).val());
			}
		}
	 	disableSendButtions();
	 	var fnx;
		if($.browser.mozilla){
			fnx = document.getElementById("zwIframe").contentWindow;
		}else{
			fnx = document.zwIframe;
		}
        isCheckContentNull = true;
	    var sendDevelop = $.ctp.trigger('beforeSaveDraftColl');
	    if(!sendDevelop){
	    	releaseApplicationButtons();
	    	addAction4Send();
	    	return;
	    }
	 	resetFileId4Clone();
	 	if(_checkTrack()){
	 		releaseApplicationButtons();
	 		addAction4Send();
	 		return;
	 	}
		if(istranstocol){
		       fileId = $("#contentDataId").val();
		}
		$("#saveAsFlag").val('saveAsDraft');
		if(!notSpecialCharX(document.getElementById("subject"))){
			releaseApplicationButtons();
			addAction4Send();
	        return false;
	    }
		checkContent();
		// 附言不能超过500子
		if($("#content_coll").val().length > 500){
			 var x =$.i18n('collaboration.fuyan.toolong');
			 var x2 = $("#content_coll").val().length;
			 x.replace("{0}",x2);
			 $.alert(x.replace("{0}",x2));  // 发起人附言不能超过500
			 releaseApplicationButtons();
			 addAction4Send();
			return;
		}
		var moduleId = $("#colMainData #id").val();
		if($("#curTemId").val() != ""){
			fnx.setSaveContentParam(moduleId,$("#subject").val(),$("#curTemId").val());
		}else{
			fnx.setSaveContentParam(moduleId,$("#subject").val());
		}
		// 提交时，督办填写验证
		if(!checkSupervisor()){
			releaseApplicationButtons();
			addAction4Send();
			return;
		}
		var tempId = $.trim($("#colMainData #tId").val());
	    if(tempId !=""  && savedrafttemVal){// ajax校验 如果包含模板
	        if(!(checkTemplateCanUse(tempId))){
	            $.alert($.i18n('template.cannot.use'));
	            releaseApplicationButtons();
	            addAction4Send();
	            return;
	        }
	    }
		// 设置comment表的ctype 字段为-1
		var moduleId = $("#colMainData #id").val();
		$("#comment_deal #moduleId").val(moduleId);
		$("#comment_deal #ctype").val(-1);
		// 快速选人
		tidyDatas("process_info");
		// 保存待发的时候如果是系统模板 置空 processID
		var proId ="";
		var flagS= false;
		if(issystemtemflag){
			flagS = true;
			proId = $("#workflow_definition #processId").val();
			$("#workflow_definition #processId").val("");
		}
		// proce = $.progressBar();
		showMask();

	//G6V5.7-保存公文正文--start
	  if(!saveGovdocBody(true)){
		  return ;
	  }
  //G6V5.7-保存公文正文--end

		if(isSwitchZW && $("#newBusiness").val() == '1' ){
			var _cbody = fnx.getMainBodyDataDiv$();
			$("#id",_cbody).val("");
		}
	    fnx.$.content.getContentDomains_newColl(function(domains){
	        if (domains) {

	            $("#assDocDomain").html("");
	            $("#attFileDomain").html("");

	            saveAttachmentPart("assDocDomain");
	            saveAttachmentPart("attFileDomain");

	            domains.push('assDocDomain');
	            domains.push('attFileDomain');
	            domains.push('colMainData');
	            domains.push('comment_deal');

	            //提交前重置公文文号参数
	            resetMarkParamBeforeSubmit();
	            
	            $("#sendForm").jsonSubmit({
	              action:_ctxPath+"/collaboration/collaboration.do?method=saveDraft&distributeAffairId=" + distributeAffairId+"&isFenban="+isFenban,
	              domains : domains,
	              validate:false,
	              debug : false,
	              callback:function(data){
	                // proce.close();
	                hideMask();
	                if(flagS){
		                $("#workflow_definition #processId").val(proId);
		               //addAction4Send();
	                }
	              }
	            });
	        }
	        //G6V57 BDGW-2500分办时保存待发，关闭当前界面后，待办栏目数据没有及时刷新
	        if(isFenban == "true"){
	        	var _win;
	        	if(undefined != window.top.opener.$("#main")[0]){
		        	if(undefined != window.top.opener.$("#main")[0].contentWindow.detailIframe){
		        		_win = window.top.opener.$("#main")[0].contentWindow.detailIframe;
		        	}else{
		        		_win = window.top.opener.$("#main")[0].contentWindow;
		        	}
		        	if(_win.sectionHandler != undefined) {
		                //刷新首页待办
		                _win.sectionHandler.reload("pendingSection",true);
		            }
	        	}
	        }
	    },'saveAs',null,mainbody_callBack_failed_whenSaveAs);
}

 function _checkTrack(){
	 	// 如果选择了指定跟踪人员但是又没有选择具体人员的话
		var members=document.getElementById("zdgzry");
		if(members){
			var trackRangePart=document.getElementById("radiopart");
			if(trackRangePart!=null&&trackRangePart.checked&&members.value==""){
	            // 指定跟踪人不能为空，请选择指定跟踪人！
				$.alert($.i18n('collaboration.newColl.alert.zdgzrNotNull'));
				return true;
			}else{
				return false;
			}
		}
 }

 function mainbody_callBack_failed_whenSaveAs(){
		// proce.close();
	 	releaseApplicationButtons();
		addAction4Send();
		hideMask();
}
 /**
	 * ctp_conetnt_all的Id
	 *
	 * @param contentId
	 * @return
	 */
 function setContentIdForDel(contentId){
	 document.getElementById("contentIdUseDelete").value=contentId;
 }


// 存草稿后 ,将summayId的值反写到页面
 function endSaveDraft(summaryId,contentId,affairId,templateId,isFenban){
	 var fnx;
	if($.browser.mozilla){
		fnx = document.getElementById("zwIframe").contentWindow;
	}else{
		fnx = document.zwIframe;
	}
    var url = window.location.href.split("/seeyon")[1];
    url = "/seeyon" +url;
    try{
        addAnotherKey(url,affairId,2,"method=newColl",window);
    }catch(e){}
 	document.getElementById('id').value = summaryId;
 	// 必须回写moduleId(一个是正文组件,一个是评论组件)
 	var obj;
 	obj = document.getElementsByName('moduleId');
 	for(var i = 0 ; i< obj.length; i ++){
 		obj[i].value=summaryId;
 	}
 	var contentDiv = fnx.getMainBodyDataDiv$();
   	$("#id",contentDiv).val(contentId);
 	// 保存一次草稿后就应该将是否新建业务的数据控制为0
 	$("#colMainData #newBusiness").val("0");
 	tb.enabled("saveDraft");// 保存待发
 	disableSendButtions();
    try{
        saveWaitSendSuccessTip4WaitSend($.i18n('collaboration.newColl.savePendingOk'),summaryId,affairId,isFenban);
    } catch (e){}
 }


// 检查督办时间设置
 function checkAwakeDate(){
 	var now = new Date();// 当前系统时间
 	var awakeDateStr=document.getElementById("awakeDate").value;
 	if(awakeDateStr!= ""){
 		var days = awakeDateStr.substring(0,awakeDateStr.indexOf(" "));
 		var hours = awakeDateStr.substring(awakeDateStr.indexOf(" "));
 		var temp = days.split("-");
 		var temp2 = hours.split(":");
 		var d1 = new Date(parseInt(temp[0],10),parseInt(temp[1],10)-1,parseInt(temp[2],10),parseInt(temp2[0],10),parseInt(temp2[1],10));
 		if(d1.getTime()<now.getTime()){
 		    var confirm = "";
 	        confirm = $.confirm({
 	            'msg': $.i18n('collaboration.newColl.thisTimeGrSupTime2'),// 督办时间比当前时间早，是否继续？
 	            ok_fn: function () {
 	            	return true;
 	            },
 	            cancel_fn:function(){
 	                document.getElementById("awakeDate").value = "";
 	                return false;
 	            }
 	        });
 		}
 	}
 }

// 流程期限时间比当前时间早，是否继续
 function checkDeadLineDateTime(){
 	var now = new Date();// 当前系统时间
 	var awakeDateStr=document.getElementById("deadLineDateTime").value;
 	if(awakeDateStr!= ""){
 		var days = awakeDateStr.substring(0,awakeDateStr.indexOf(" "));
 		var hours = awakeDateStr.substring(awakeDateStr.indexOf(" "));
 		var temp = days.split("-");
 		var temp2 = hours.split(":");
 		var d1 = new Date(parseInt(temp[0],10),parseInt(temp[1],10)-1,parseInt(temp[2],10),parseInt(temp2[0],10),parseInt(temp2[1],10));
        var remind = $("#advanceRemind");
        var remaindDatetime=ajaxCalcuteNatureDatetime(awakeDateStr,remind[0].value);
 		if(d1.getTime()<now.getTime()+server2LocalTime){
          $.alert($.i18n('collaboration.newcoll.processTimeEarlier'));
 		}else if(remaindDatetime<now.getTime()+server2LocalTime){
            $.alert($.i18n('collaboration.newColl.alert.lcqx'));
            remind[0].selectedIndex = 0;
        }
 	}
 }

function handleTemplate(){
     var moduleType;
	if(_govDocFormType == "5"){
		moduleType = "401";
	}else if(_govDocFormType == "7"){
		moduleType ="402";
	}else if(_govDocFormType == "8"){
		moduleType = "404";
	}
	callTemplate(moduleType,"",getTemplateId,isFenban);
}

function getTemplateId(templateId){
	var  oldUrl=curlocationPath +"/collaboration/collaboration.do?method=newColl&rescode=F01_newColl&_resourceCode=F01_newColl";
	if(templateId && templateId != ''){
		isSubmitOperation = true;
		//$("#zwIframe").attr("src","/seeyon/content/content.do?method=invokingForm&formId="+rv+"&viewState=1&isFullPage=true&distributeContentDataId=" + $("#distributeContentDataId").val() + "&distributeContentTemplateId=" + $("#distributeContentTemplateId").val());
		var url = curlocationPath +"/collaboration/collaboration.do?method=newColl&templateId="+templateId+"&from=templateNewColl";
		url += "&contentDataId=" + $("#distributeContentDataId").val() + "&contentTemplateId=" + $("#distributeContentTemplateId").val();
		url += "&oldSummaryId=" + oldSummaryId;
		url += "&distributeAffairId=" + distributeAffairId;
		url += "&app=4&sub_app=" + $("#sub_app").val();
		url += "&forwardText=" + forwardText + "&forwardAffairId=" + forwardAffairId;
		url += "&isFenbanFlag="+isFenban;
		url += "&curSummaryID="+curSummaryID;
		window.location = url;
	}
	 try{
        addAnotherKey(oldUrl,oldUrl,2,"method=newColl",window);
    }catch(e){}
}
function setPageMenu(){
	var  oldUrl=curlocationPath +"/collaboration/collaboration.do?method=newColl&rescode=F01_newColl";
	try{
        addAnotherKey(oldUrl,oldUrl,2,"method=newColl",window);
    }catch(e){}
}
// 超期提醒与提前提醒时间设置的比较
function compareTime() {
	var newCollForm = document.getElementsByName("sendForm")[0];
	var advanceRemindTime = document.getElementById("advanceRemind").value;
	var deadLineTime = document.getElementById("deadLineselect").value;
	if (deadLineTime == 0) {
		var allow_auto_stop_flow = document.getElementById('canAutostopflow');
		if (allow_auto_stop_flow) {
			allow_auto_stop_flow.disabled = true;
		}
	}
	var advanceRemindNumber = new Number(advanceRemindTime);
	var deadLineNumber = new Number(deadLineTime);
	if (deadLineNumber <= advanceRemindNumber
			&& !(advanceRemindNumber == 0 && deadLineNumber == 0)) {
		var mycal = $("#deadLineDateTime");
		// 发送的时候需要重新验证流程期限
		if (mycal) {
			if (mycal.val() != "" && advanceRemindNumber != 0
					&& getDateTimeValue(advanceRemindNumber) >= mycal.val()) {
				// 未设置流程期限或流程期限小于,等于提前提醒时间
				$.alert($.i18n('collaboration.newColl.alert.lcqx'));
				return false;
			}else{
				return true;
			}
		} else {
			// 未设置流程期限或流程期限小于,等于提前提醒时间
			$.alert($.i18n('collaboration.newColl.alert.lcqx'));
			newCollForm.advanceRemind.selectedIndex = 0;
			// newCollForm.deadline.selectedIndex = 0;
			return false;
		}
	} else {
		return true;
	}
}

function checkSpecialChar(element){
	var value = element.value;
	var inputName = element.getAttribute("inputName");
	// 修改[]之间的内容，其它部分不许修改
	if(/^[^\|\\"'<>]*$/.test(value)){
		return true;
	}else{
		writeErrorInfo(element,inputName + $.i18n('collaboration.newColl.tszf')); // 不能包含特殊字符（|\"'\<>），请重新输入！
		return false;
	}
}

function writeErrorInfo(element, message){
	$.alert(message);
	try{
		element.focus();
		element.select();
   }catch(e){}
}


function saveAsTemplete() {
	if($.ctx.plugins.contains('secret') && !templateSecretLevelEnable){
		$.alert($.i18n('secret.flowcheck.cannot'));
		return;
	}
	// 判断流程是否为空
	var process_lc = document.getElementById("process_info");
	var defaultPro = $("#process_info").attr("defaultValue");
	if (defaultPro==$.trim(process_lc.value)) {
	    $("#process_info").attr("value","");
    }
	if(process_lc && process_lc.value==""){
	    $.messageBox({
	        'type' : 0,
	        'title':$.i18n('system.prompt.js'),
	        'msg' : $.i18n('collaboration.forward.workFlowNotNull'), // 流程不能为空
	        'imgType':2,
	        ok_fn : function() {
	        	if(noselfflow == null || noselfflow == ""){
	        		clickProcessInfoButton();// lilong 0327
	        		// $("#process_info").click();
	        	}
	        }
	      });
		return;
	}
	var arr = window.frames["zwIframe"].document.getElementsByTagName("textarea");
	for(var i = 0; i < arr.length;i ++){
		if($(arr[i]).attr("mappingField") == "subject"){
			$("#subject").val($(arr[i]).val());
		}
	}
	if($("#subject").val() == null || $("#subject").val() == ""){
		arr = window.frames["zwIframe"].document.getElementsByTagName("input");
		for(var i = 0; i < arr.length;i ++){
			if($(arr[i]).attr("mappingField") == "subject"){
				$("#subject").val($(arr[i]).val());
			}
		}
	}
	var fnx;
	if($.browser.mozilla){
		fnx = document.getElementById("zwIframe").contentWindow;
	}else{
		fnx = document.zwIframe;
	}
	isCheckContentNull=false;// 不验证pdf是否为空
    isCleckContent = false;
	tidyDatas("process_info");// OA-55329
	resetFileId4Clone();
	var tIdCheck = $("#colMainData #tId").val();
	if(tIdCheck){
		if(!(checkTemplateCanUse(tIdCheck))){
              $.alert($.i18n('template.cannot.use'));
              return;
        }
	}
	$("#saveAsFlag").val('saveAsPersonal');
	var theForm = document.getElementsByName("sendForm")[0];
	var titleValue = theForm.subject.value;
    var defaultSubject = $.i18n('common.default.subject.value2');
	if( null == titleValue || ""==titleValue || defaultSubject == titleValue){
		var textInput = $(getDocumentobjByMappingfieldForDengji("subject"));
		textInput.css("background-color",nullColor);
	    $.alert($.i18n('collaboration.common.titleNotNull'));  // 标题不能为空
		return;
	} else if (titleValue.length > 85) {
	    $.alert($.i18n('collaboration.newColl.titleMaxSize'));  // 标题最大长度为85!
        return false;
    }
	if($("#content_coll").val().length > 500){
		 var x =$.i18n('collaboration.fuyan.toolong');
		 var x2 = $('#content_coll').val().length;
		 x.replace("{0}",x2);
		 $.alert(x.replace("{0}",x2));  // 发起人附言不能超过500
		return true;
	}
	var subject =  document.getElementById("subject").value;
	var defaultValue = $("#subject").attr("defaultValue");
	if(defaultSubject == defaultValue){
		defaultValue ="";
	}
	var tembodyType =document.getElementById("tembodyType").value;
	var formtitle = document.getElementById("formtitle").value;
	var hasWorkflow= false;
	if($("#process_info").val() && !("" == $("#process_info").val()
             || $.i18n('collaboration.default.workflowInfo.value') == $("#process_info").val())){
		hasWorkflow = true;
	}
	var _cbody = fnx.getMainBodyDataDiv$();
	var _ctype = $("#contentType",_cbody).val();
	//G6V57 BDGW-2638【单组织】存为模板，模板名称应该为标题名，不应该为文单名！多组织正常
	//经确认，公文此处不显示原模板名称，而是显示标题名称
	/*if(useforsavetemsubjectflag){
		subject = useforsavetemsubject;
	}*/
	var _temType = 'hasnotTemplate';
	if(saveastemtype){
		_temType = saveastemtype;
	}
	var dialog = $.dialog({
		 targetWindow:getCtpTop(),
	     id: 'saveAsTemplate',
	     url: curlocationPath +"/collaboration/collaboration.do?method=saveAsTemplate&hasWorkflow="+hasWorkflow+"&subject="+escapeStringToHTML(encodeURIComponent(subject))+"&tembodyType="+tembodyType+"&formtitle="+escapeStringToHTML(encodeURIComponent(formtitle))+"&defaultValue="+defaultValue+"&ctype="+_ctype+"&temType="+_temType + "&app=" + app,
	     width: 350,
	     height: 220,
	     title: $.i18n('collaboration.newcoll.saveAsTemplate'),  // 另存为个人模板
	     buttons: [{
	         text: $.i18n('collaboration.pushMessageToMembers.confirm'), // 确定
	         handler: function () {
                var rv = dialog.getReturnValue();
                // activeOcx(); //TODO office等加office控件
        		if (!rv) {
        	        return;
        	    }
        		var over = rv[0];
        	    var overId = rv[1];
        	    var type = rv[2];
        	    var subject = rv[3];
                if(over == 5){
                  var confirm = "";
                  confirm = $.confirm({
                      'msg': $.i18n('collaboration.saveAsTemplate.isHaveTemplate',escapeStringToHTML(subject)),  // 模板
																													// '+subject+'已经存在，是否将原模板覆盖?
                      ok_fn: function () {
                          confirm.close();
                          doSaveTemplate(1,subject,overId,type,dialog);
                      },
                      cancel_fn:function(){
                        confirm.close();
                      }
                   });
                }else{
                   doSaveTemplate(over,subject,overId,type,dialog);
                }
            }
	     }, {
	         text: $.i18n('collaboration.pushMessageToMembers.cancel'), // 取消
	         handler: function () {
	             dialog.close();
	         }
	     }]
	 });
}

function doSaveTemplate(over,subject,overId,type,dialog){

	var fnx;
	if($.browser.mozilla){
		fnx = document.getElementById("zwIframe").contentWindow;
	}else{
		fnx = document.zwIframe;
	}
	checkPDFIsNull=true;// 模板pdf正文允许为空
    // 校验超期提醒，提前提醒时间
    if(!compareTime() || !checkSupervisor()){
        return;
    }
    if(over == 2){
        return ;
    }
    var theForm = document.getElementsByName("sendForm")[0];

    theForm.saveAsTempleteSubject.value = subject;
    theForm.target = "personalTempleteIframe"; // 自定义名字:出现于框架结构，将会在该名称的框架内打开链接

    var moduleId = getUUID();
    if( null != overId && !("" == overId)){
       // moduleId = overId;// 覆盖
        $("#moduleId",$("#comment_deal")).val(moduleId);// 覆盖附言区域的moduleID
        var oldId = fnx.getContentIdByModuleIdAndType(1,moduleId);
        setContentIdForDel(oldId);
    }
    var contentDiv = fnx.getMainBodyDataDiv$();
    // 协同V5.0 OA-34229
	  // 新建事项调用一个系统流程模板后，存为模板后，点击保存待发；
	  // 然后进入待发事项编辑该协同存为模板，再次保存待发；依次重复上诉操作，就会报JS错误
    // 保存上次的ID 以免产生新的正文 出现多正文的情况
    var oldZWId = $("#id",contentDiv).val();
    $("#id",contentDiv).val(-1);
    var oldZWModuleId = $("#moduleId",contentDiv).val();
    $("#moduleId",contentDiv).val(moduleId);
    var oldZWModuleTemplateID =  $("#moduleTemplateId",contentDiv).val();
    $("#moduleTemplateId",contentDiv).val(-1);// 存为个人模板
												// 正文的moduleTemplateId要存成-1
    var oldcommentId = $("#comment_deal #id").val();
    $("#comment_deal #id").val("");
    $("#comment_deal #moduleId").val("");
    // var curTid = document.getElementById('tId').value;
    // document.getElementById('tId').value= -1;
    document.getElementById('useForSaveTemplate').value='yes';
    var template_dom = document.createElement("input");
    template_dom.id="personTid";
    template_dom.name="personTid";
    template_dom.type="hidden";
    template_dom.value = moduleId;
    if($("#colMainData #personTid").size() > 0){// 多次存为个人模板的时候，要先判断是否已经存在该数据域
												// 不然会按分组提交
        $("#colMainData #personTid").val(moduleId);
    }else{
        $("#colMainData").append(template_dom);
    }
    var type_dom= document.createElement("input");
    type_dom.id="type";
    type_dom.name="type";
    type_dom.type="hidden";
    type_dom.value=type;
    if($("#colMainData #type").size() > 0){// 多次存为个人模板的时候，要先判断是否已经存在该数据域
											// 不然会按分组提交
        $("#colMainData #type").val(type);
    }else{
        $("#colMainData").append(type_dom);
    }
    var overId_dom= document.createElement("input");
    overId_dom.id="overId";
    overId_dom.name="overId";
    overId_dom.type="hidden";
    overId_dom.value=overId;
    if($("#colMainData #overId").size() > 0){
        $("#colMainData #overId").val(overId);
    }else{
        $("#colMainData").append(overId_dom);
    }
    var pobj = $("#workflow_definition #processId")[0];
    var alreayPid =pobj.value;// 现在遵循的原理 即使存个人模板全生成新的流程 （insert
								// wf_process_templete）
    pobj.value='-1';
    theForm.method = "POST";
    $("#projectId").val($("#selectProjectId").val());

	if(!saveGovdocBody()){
		return ;
	}
    if(type != 'workflow'){
    	fnx.$.content.getContentDomains_newColl(function(domains){
            if (domains) {

                $("#assDocDomain").html("");
                $("#attFileDomain").html("");

          	  saveAttachmentPart("assDocDomain");
                saveAttachmentPart("attFileDomain");

                domains.push('assDocDomain');
                domains.push('attFileDomain');
                domains.push('colMainData');
                domains.push('comment_deal');
                theForm.action = curlocationPath + "/collTemplate/collTemplate.do?method=saveTemplate";
				 $("#tembodyType").val(convertContentType_StringToValue(document.getElementById("govdocBodyType").value));
				 $("#bodyType").val(convertContentType_StringToValue(document.getElementById("govdocBodyType").value));
                $("#sendForm").jsonSubmit({
                  domains : domains,
                  validate:false,
                  callback:function(){// 加入回调函数，可以让页面不跳转，实现异步
                      $.infor($.i18n('collaboration.newColl.susscessSaveTemplate'));  // 成功保存个人模板
                      theForm.action= curlocationPath +"/collaboration/collaboration.do?method=send&distributeAffairId="+distributeAffairId;
                  }
                });
              }
        },'saveAs');
    }else{
        var domains = [];
        var contentDiv = fnx.getMainBodyDataDiv$();
        $.content.getWorkflowDomains($("#moduleType", contentDiv).val(), domains);
            if (domains) {

          	  $("#assDocDomain").html("");
                $("#attFileDomain").html("");
				$("#tembodyType").val(convertContentType_StringToValue(document.getElementById("govdocBodyType").value));
				$("#bodyType").val(convertContentType_StringToValue(document.getElementById("govdocBodyType").value));
                domains.push('colMainData');
                domains.push('comment_deal');
                theForm.action = curlocationPath + "/collTemplate/collTemplate.do?method=saveTemplate";
                $("#sendForm").jsonSubmit({
                  domains : domains,
                  debug : false,
                  validate:false,
                  callback:function(){
                      $.infor($.i18n('collaboration.newColl.susscessSaveTemplate'));  // 成功保存个人模板
                      theForm.action= curlocationPath +"/collaboration/collaboration.do?method=send&distributeAffairId="+distributeAffairId;
                  }
                });
             }
    }
    // document.getElementById('tId').value = curTid;
    document.getElementById('useForSaveTemplate').value='no';
    pobj.value = alreayPid;
    $("#comment_deal #id").val(oldcommentId);
    $("#id",contentDiv).val(oldZWId);// 回填上次的正文ID 和 业务ID
    $("#moduleId",contentDiv).val(oldZWModuleId);
    $("#moduleTemplateId",contentDiv).val(oldZWModuleTemplateID);// 存为个人模板
																	// 正文的moduleTemplateId要存成-1
    checkPDFIsNull=false;// 保存成功之后设置回来模板标记
    try{uuidlong = "";}catch(e){}
    dialog.close();
}

function doPigeonholeWindow(flag, appName, from,obj) {
	doPigeonhole(flag, appName, from);
}

// 预归档
function doPigeonhole(flag, appName, from) {
    if (flag == "no") {
        // TODO 清空信息
    } else if (flag == "new") {
        var result;
        if (from == "templete") {
            result = pigeonhole(appName, null, false, false, "", "doPigeonholeCallback");
        } else {
			//公文预归档
            result = pigeonhole(appName, null, "", "", "govdocsent", "doPigeonholeCallback");
        }
    }
}

/**
 * doPigeonhole归档回调
 */
function doPigeonholeCallback(result) {
    var theForm = document.getElementsByName("sendForm")[0];
    if (result == "cancel") {
        var oldPigeonholeId = theForm.archiveId.value;
        var selectObj = theForm.colPigeonhole;
        if (oldPigeonholeId != "" && selectObj.options.length >= 3) {
            selectObj.options[2].selected = true;
        } else {
            var oldOption = document.getElementById("defaultOption");
            oldOption.selected = true;
        }
        return;
    }
    var pigeonholeData = result.split(",");
    pigeonholeId = pigeonholeData[0];
    pigeonholeName = pigeonholeData[1];
    if (pigeonholeId == "" || pigeonholeId == "failure") {
        theForm.archiveName.value = "";
        $.alert(pipeinfo1);
    } else {
        var oldPigeonholeId = theForm.archiveId.value;
        theForm.archiveId.value = pigeonholeId;
        if (document.getElementById("prevArchiveId")) {
            document.getElementById("prevArchiveId").value = pigeonholeId;
        }
        var selectObj = document.getElementById("colPigeonhole");
        var option = document.createElement("OPTION");
        option.id = pigeonholeId;
        option.text = pigeonholeName;
        option.value = pigeonholeId;
        option.selected = true;
        if (oldPigeonholeId == "" && selectObj.options.length <= 2) {
            selectObj.options.add(option, selectObj.options.length);
        } else {
            selectObj.options[selectObj.options.length - 1] = option;
        }
    }
}


// 预归档
function doPigeonholeIpad(flag, appName,from,obj) {

    if (flag == "no") {
        // TODO 清空信息
    }else if (flag == "new") {
        var result;
    	// newIdes=null;
    	var atts = undefined;
    	var type = "";
    	var validAcl = undefined;
    	if(from == "templete"){
        	result = pigeonhole(appName, null, false, false);
    	}else{

    		result = v3x.openDialog({
    	    	id:"pigeonholeIpad",
    	    	title:pipeinfo2,
    	    	url : pigeonholeURL + "?method=listRoots&isrightworkspace=pigeonhole&appName=" + appName + "&atts=" + atts + "&validAcl=" + validAcl+"&pigeonholeType="+type,
    	    	width: 350,
    	        height: 400,
    	        // isDrag:false,
    	        // targetWindow:getA8Top(),
    	        // fromWindow:window,
    	        type:'panel',
    	        relativeElement:obj,
    	        buttons:[{
    				id:'btn1',
    	            text: pipeinfo3,
    	            handler: function(){
    	        		var returnValues = result.getReturnValue();
	    	        	var theForm = document.getElementsByName("sendForm")[0];
	    	            var pigeonholeData = returnValues.split(",");
	    	            pigeonholeId = pigeonholeData[0];
	    	            pigeonholeName = pigeonholeData[1];
	    	            if(pigeonholeId == "" || pigeonholeId == "failure"){
	    	            	theForm.archiveName.value = "";
	    	            	$.alert(pipeinfo4);
	    	            }
	    	            else{
	    	            	var oldPigeonholeId = theForm.archiveId.value;
	    	            	theForm.archiveId.value = pigeonholeId;
	    	            	if(document.getElementById("prevArchiveId")){
	    	            		document.getElementById("prevArchiveId").value = pigeonholeId;
	    	            	}
	    	            	var selectObj = document.getElementById("colPigeonhole");
	    	            	var option = document.createElement("OPTION");
	    	            	option.id = pigeonholeId;
	    	            	option.text = pigeonholeName;
	    	            	option.value = pigeonholeId;
	    	            	option.selected = true;
	    	            	if(oldPigeonholeId == "" && selectObj.options.length<=2){
	    	            		selectObj.options.add(option, selectObj.options.length);
	    	            	}
	    	            	else{
	    	            		selectObj.options[selectObj.options.length-1] = option;
	    	            	}
	    	            }
		        		result.close();
	            }

    	        }, {
    				id:'btn2',
    	            text: pipeinfo5,
    	            handler: function(){
    	        		result.close();
    	            }
    	        }]
    	    });
    	}
    }
}

function pigeonholeEvent(obj){
	var theForm = document.getElementsByName("sendForm")[0];
	switch(obj.selectedIndex){
		case 0 :
			var oldArchiveId = theForm.archiveId.value;
			if(oldArchiveId != ""){
				theForm.archiveId.value = "";
			}
			theForm.archiveId.value = "";
			break;
		case 1 :
			doPigeonholeWindow('new', '1', 'newGov',obj);
			break;
		default :
			theForm.archiveId.value = document.getElementById("prevArchiveId").value;
			return;
	}
}



// 附件上传后回调方法
function testCallBack(field){
    // 处理文件逻辑的action
    location.href="/t1/fileController.do?field="+field;
}

function saveWaitSendSuccessTip4WaitSend(content,summaryId,affairId,isFenban){
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
    document.getElementById("zwIframe").src="";//将正文内容置空，解决了页面刷新两遍
    setTimeout(function(){
        panel.close();
        try {
            var url = _ctxPath+"/collaboration/collaboration.do?method=newColl&summaryId="+summaryId+"&isFenban="+isFenban+"&affairId="+affairId+"&app=4&sub_app="+sub_app+"&from=waitSend"+"&formTitleText="+encodeURIComponent(encodeURIComponent($("#subject").val()));
            if(window.location.href.indexOf("from=bizconfig") != -1 || window.location.href.indexOf("reqFrom=bizconfig") != -1){
            	url += "&reqFrom=bizconfig";
            	if($("#bzmenuId").val() != ""){
            		url += "&menuId="+$("#bzmenuId").val();
            	}
            }
            if (getCtpTop().isCtpTop) {
                isFormSubmit = false;
                getCtpTop().$("#main")[0].contentWindow.location = url;
            } else {
                window.location = url;
            }
        }catch(e) {}
    },2000);
  }
function saveWaitSendSuccessTip(content,summaryId,templateId,isFenban){
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
    document.getElementById("zwIframe").src="";//将正文内容置空，解决了页面刷新两遍
    setTimeout(function(){
        panel.close();
        try {
            var url = _ctxPath+"/collaboration/collaboration.do?method=newColl&summaryId="+summaryId+"&isFenban="+isFenban+"&templateId="+templateId+"&app=4&sub_app="+sub_app+"&from=waitSend"+"&formTitleText="+encodeURIComponent(encodeURIComponent($("#subject").val()));
            if(window.location.href.indexOf("from=bizconfig") != -1 || window.location.href.indexOf("reqFrom=bizconfig") != -1){
            	url += "&reqFrom=bizconfig";
            	if($("#bzmenuId").val() != ""){
            		url += "&menuId="+$("#bzmenuId").val();
            	}
            }
            if (getCtpTop().isCtpTop) {
                isFormSubmit = false;
                getCtpTop().$("#main")[0].contentWindow.location = url;
            } else {
                window.location = url;
            }
        }catch(e) {}
    },2000);
  }
function checkContent(){
	    var content = $("#content_coll").val();
	    var defaultValue = $.i18n("collaboration.newcoll.fywbzyl");
	    if (content == defaultValue) {
	        $("#content_coll").val("");
	        $("#content_coll").css("color","");
	    }
}
function checkContentOut(){
	    var content = $("#content_coll").val();
	    var defaultValue = $.i18n("collaboration.newcoll.fywbzyl");
	    if (content == "") {
	        $("#content_coll").val(defaultValue);
	        $("#content_coll").css("color","#a3a3a3");
	    }
}
function onclickTrack(){
	$("#radiopart").click();
}
// 截取跟踪指定人长度
function trackName(res){
	var userName="";
	var nameSprit="";
	if(res.obj.length>0){
  	for(var co = 0 ; co<res.obj.length ; co ++){
	   userName+=res.obj[co].name+",";
	}
  	userName=userName.substring(0,userName.length-1);
  	// 只显示前三个名字
// nameSprit=userName.split(",");
// if(nameSprit.length>3){
// nameSprit=userName.split(",", 3);
// nameSprit+="...";
// }
  	$("#zdgzryName").attr("title",userName);
	var partText = document.getElementById("zdgzryName");
	 partText.style.display="";
	 // $("#zdgzryName").val(nameSprit);
	 $("#zdgzryName").val(userName);
 }
}

function _contentSetText(){
	if(istranstocol && !transOfficeId){
		// if(false){
		var _formC = $("#formTextId").text();
		var fnx;
		if($.browser.mozilla){
			fnx = document.getElementById("zwIframe").contentWindow;
		}else{
			fnx = document.zwIframe;
		}
		if(_formC){
			// try{fnx.$("#mainbodyHtmlDiv_0")[0].innerHTML=_formC}catch(e){};
			try{fnx.setContent(_formC);}catch(e){}
		}
	}
	if($("#contentSwitchId").val() != ""){
		if($.browser.mozilla){
			fnx = document.getElementById("zwIframe").contentWindow;
		}else{
			fnx = document.zwIframe;
		}
		var contentDiv = fnx.getMainBodyDataDiv$();
		$("#id",contentDiv).val($("#contentSwitchId").val());
	}
	if(_isResendFlag){
		var fnx;
		if($.browser.mozilla){
			fnx = document.getElementById("zwIframe").contentWindow;
		}else{
			fnx = document.zwIframe;
		}
		var contentDiv = fnx.getMainBodyDataDiv$();
		$("#id",contentDiv).val("");
	}
	releaseApplicationButtons();
}


function contentBack(bodyType) {
    // 如果是PDF正文，不能修改正文
    var canEdit = "";
    if (getCtpTop().isCtpTop) {
        canEdit = $("#canEdit")[0];
    } else {
        canEdit = parent.$("#canEdit")[0];
    }
    if (bodyType == 45) {
        canEdit.disabled = true;
        canEdit.checked = false;
    } else {
        canEdit.disabled = false;
        canEdit.checked = true;
    }
	getTaoHongList(CurrentUserId,bodyType);
}


/**
 * 待发表单打开不保存，移除Session中当前表单数据缓存对象
 */
function removeSessionMasterData(dataId){
    if (dataId) {
        var tempFormManager = new formManager();
        tempFormManager.removeSessionMasterData({"masterDataId":dataId});
    }
    WebClose();
}

//新建页面解决chrome下隐藏后显示控件未的问题
function newColOfficeObjExtshowExt(){
	var iframe = $("#zwIframe", document)[0];
	OfficeObjExt.showIfame({ //处理 zwIframe iframe中的Office 对象的显示
		firstAttr:"firstHeight",
		iframe:iframe,
		callback:function(){
			var arr = [];
			var _tpWin = getCtpTop();
			//显示的时候如果有遮罩就不显示office插件
			var hasMask = (_tpWin.$('.mask').size()>0 && _tpWin.$('.mask').css('display') != 'none')
			|| (_tpWin.$('.shield').size()>0 && _tpWin.$('.shield').css('display') != 'none');
			if(_tpWin.isOffice && _tpWin.officeObj && _tpWin.officeObj.length>0  && !hasMask){ //处理所有签章对象的显示
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
											arr =[];
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
					if(arr.length ==1){
						arr.length=0;
						arr =[];
					}
				}
			},20);
		}
	}); //default :firstHeight

}


function errorHandle(e){
	disableSendButtions();
}

//chooserNo--正文选择器序号，避免菜单id冲突
function getContentTypeChooser_temp(toolbarId, defaultType, callBack, chooserNo){
	var isChose = false;
	defaultType=convertContentType_StringToValue(defaultType);
	if(chooserNo){
	  chooserNo = "_mt_" + chooserNo +"_"	;
	}else{
		chooserNo = "_mt_" ;
	}
	if (!toolbarId)
		toolbarId = "toolbar";
	_mt_toolbar_id = toolbarId;
	var r = [];
	for ( var i = 0; i < mtCfg_govdoc.length; i++) {
		var mtCtg_temp=mtCfg_govdoc[i];
		var mt = mtCtg_temp.mainbodyType;
		mtCtg_temp.value = mt;
		mtCtg_temp.id =  chooserNo + mt;
		mtCtg_temp.click = function() {
			var cmt = $(this).attr("value");
			_clickMainbodyType = cmt;
			if (callBack) {
				changeBodyType(cmt, function() {
					if (_lastMainbodyType)
						$("#" + _mt_toolbar_id).toolbarEnable(
								 chooserNo + _lastMainbodyType);
					$("#" + _mt_toolbar_id).toolbarDisable( chooserNo + cmt);
					_lastMainbodyType = cmt;
					callBack(cmt);
					//isSwitchZW = true;
				});
			}
		};
		try {
			if ($.ctx.isOfficeEnabled(mt)){
				if (defaultType != undefined && defaultType != "") {  //如果有默认类型， 则默认类型置灰，否则置灰第一个
					if (mt == defaultType) {
							mtCtg_temp.disabled = true;
							_lastMainbodyType = mt;
						}
					} else {
						if((mt == "41" || mt =="43") && !isChose){//避免用户即装了wps 也装了office 造成重复选择
							var bodyTypeObj = document.getElementById("govdocBodyType");
							bodyTypeObj.value = convertContentType_valueToString(mt);
							mtCtg_temp.disabled = true;
							showEditor(bodyTypeObj.value, false);//根据是wps和word不同，更换类型
							isChose = true;
							_lastMainbodyType = mt;
							getTaoHongList(CurrentUserId,mt);
						}
					}

				r.push(mtCtg_temp);
			}
		} catch (e) {
		}
	}
	var hasPlugin = false;
	var htmlIndex = -1;
	for(var i = 0; i < r.length; i++){
		var cmt = r[i].value;
		if(cmt == "41" || cmt =="43"){
			hasPlugin = true;
		}
		if(cmt == "10"){
			htmlIndex = i;
		}
	}
	if("" == isNewGovdoc && !hasPlugin && -1 != htmlIndex){ //新建的时候没有office控件时候，默认类型改为HTML
		var cmt = r[htmlIndex].value;
		_clickMainbodyType = cmt;
		if (callBack) {
			changeBodyTypeForLoad(cmt, function() {
				if (_lastMainbodyType)
					$("#" + _mt_toolbar_id).toolbarEnable(
							 chooserNo + _lastMainbodyType);
				$("#" + _mt_toolbar_id).toolbarDisable( chooserNo + cmt);
				_lastMainbodyType = cmt;
				callBack(cmt);
			});
		}
		r[htmlIndex].disabled= true;
	}
	return r;

}
function changeBodyTypeForLoad(bodyType, changeBodyTypeCallBack){
	if(bodyType==10){
		bodyType="HTML";
	}else if(bodyType==41){
		bodyType="OfficeWord";
	}else if(bodyType==42){
		bodyType="OfficeExcel";
	}else if(bodyType==43){
		bodyType="WpsWord";
	}else if(bodyType==44){
		bodyType="WpsExcel";
	}else if(bodyType==45){
		bodyType="Pdf";
	}
    var bodyTypeObj = document.getElementById("govdocBodyType");
    if (bodyTypeObj && bodyTypeObj.value == bodyType) {
        return true;
    }else{
		bodyTypeObj.value = bodyType
	}

    //if (myBar) {
        if (bodyType == "HTML") {
        	if(clearOfficeFlag)clearOfficeFlag();
            //myBar.enabled("preview");
        } else {
            //myBar.disabled("preview");
        }
    //}

    //【公文】清空office的id.先保存Office,然后切换到HTML，content这个Div中会保存OFFICE 正文的ID
    //var appName=document.getElementById("appName");
    if(bodyType=='HTML'){
        var contentObj=document.getElementById("content");
        if(contentObj)
        {
            contentObj.value="";
        }
    }


        var changePdf = document.getElementById("changePdf");
        if(changePdf){
            if(bodyType == "OfficeWord" || bodyType == "WpsWord"){
                changePdf.style.display = "";
            }else{
                changePdf.style.display = "none";
            }
        }
        var share_weixin1 = document.getElementById("share_weixin_1");
        var share_weixin2 = document.getElementById("share_weixin_2");
        if(share_weixin1 && share_weixin2){
            if(bodyType == "HTML"){
                share_weixin1.style.display = "";
                share_weixin2.style.display = "";
            }else{
                share_weixin1.style.display = "none";
                share_weixin2.style.display = "none";
            }
        }
        showEditor(bodyType, true);
       // if(appName && appName.value=='4'){
            if(bodyType == "OfficeWord" || bodyType == "WpsWord"){
                //BDGW-1450 快速发文正文类型切换后，正文套红变灰
                // 拷过来的代码有问题，resetTaohongList resetTaohongList()两个都未定义
                //if(typeof(resetTaohongList)!='undefined'){
                //    resetTaohongList();
                    var taohongselectObj = document.getElementById("fileUrl");
                    if(taohongselectObj){
                        taohongselectObj.disabled = false;
                    }
                //}
            }else{
                var taohongselectObj = document.getElementById("fileUrl");
                if(taohongselectObj){
                    taohongselectObj.disabled = true;
                }
            }
        //}

        if(typeof(changeBodyTypeCallBack)!='undefined'){
        	changeBodyTypeCallBack();
        }
        return true;
}
//G6V5.7- 保存公文正文
function saveGovdocBody(isSavaDraft){
	//G6V5.7- 保存公文正文 --start
	var govdocBodyType = document.getElementById("govdocBodyType");
	var bodyType = document.getElementById("govdocBodyType").value;
	//保存公文正文
	if(bodyType == "HTML"){
		var rsStr = getHtmlContent();
		if(!rsStr){
			rsStr = "";
		}
		$("#govdocContent").val(rsStr);
		$("#govdocContentType").val(convertContentType_StringToValue(govdocBodyType.value));
	}else{
	   if(!saveOcx(null,isSavaDraft))
	   {//失败
		 releaseApplicationButtons();
		 return false;
	   }else{
		//成功，则传递参数
		  $("#govdocContent").val(fileId);
		  $("#govdocContentType").val(convertContentType_StringToValue(govdocBodyType.value));
	   }
	}

   //G6V5.7- 保存公文正文 --end
   return true;

}

$(function(){
	try{
		if(sub_app == "1" ){
			var obj = document.getElementById("edocCategoryList");
			var selIndex = obj.selectedIndex;
			var selOption = obj.options[selIndex];
			var edocCategoryId = selOption.value;
			for(var i = 0;i<allFormList.length;i++){
				if(allFormList[i].categoryId != edocCategoryId){
					continue;
				}
				var att = "";
				if(defaultFormId == allFormList[i].id){
					att="selected='selected'";
				}
				$("#formList").append("<option value='"+allFormList[i].id+"' " + att + ">"+allFormList[i].name+"</option>");
			}
			if(defaultFormId == null || defaultFormId == ""){
				var formList = document.getElementById("formList");
				var formListSelIndex = formList.selectedIndex;
				var formListSelOption = formList.options[formListSelIndex];
				defaultFormId = formListSelOption.value;
			}
		}else if(sub_app == "2"||sub_app=="3"){
			$("#edocCategoryList").css("display","none");
			$("#formList").css("float","left");
			$("#formList").css("width","100%");
			for(var i = 0;i<allFormList.length;i++){
				var att = "";
				if(defaultFormId == allFormList[i].id){
					att="selected='selected'";
				}
				$("#formList").append("<option value='"+allFormList[i].id+"' " + att + ">"+allFormList[i].name+"</option>");
			}
			if(defaultFormId == null || defaultFormId == ""){
				var formList = document.getElementById("formList");
				var formListSelIndex = formList.selectedIndex;
				var formListSelOption = formList.options[formListSelIndex];
				defaultFormId = formListSelOption.value;
			}
		}
		$("#formId").val(defaultFormId);
		var url = "/seeyon/content/content.do?method=invokingForm&formId="+defaultFormId+"&viewState=1&isFullPage=true&isNew=true";
		url += "&moduleId=" + zwModuleId + "&moduleType=4&distributeContentDataId=" + distributeContentDataId;
		url += "&distributeContentTemplateId=" + distributeContentTemplateId+"&summaryId="+$("#id").val();
		url += "&currentaffairId="+$("#currentaffairId").val() + "&oldSummaryId=" + oldSummaryId + "&forwardAffairId=" + forwardAffairId;
		$("#zwIframe").attr("src",url);
		//xuker 快速发文 如果从快速发文进来，则初始化快速发文界面 start
		if(app==4&&(isQuickSend=="true"||isQuickSend==true)){
			if(sub_app==1){//快速发文
				initFawenQuickSendUI();
			}else if(sub_app==2){//快速收文
				initShouwenQuickSendUI();
			}
		}
		//xuker 快速发文 如果从快速发文进来，则初始化快速发文界面 end
	}catch(e){
		alert(e);
	}
	////绑定密级事件
	$("#zwIframe").load(function(){
		bindFormSecretLevelChanged();
		
		initNewGovdocOpinion();
		
		//580督查督办： 1.获取关联字段是否关联督办，是则隐藏关联表单控件；2.添加判断是否是来自督办催办或变更，如果是则初始化督办事项关联
		//催办 变更关联字段都是field0006
		var field="field0006";
		if(typeof(supRalationField)!='undefined' && supRalationField!=''){
			field=supRalationField;
		}
		var fnx = document.getElementById("zwIframe").contentWindow;
		var relationField=$("span[name='"+field+"']",fnx.document).eq(1);
		if(relationField.length>0){
			var relation = $.parseJSON(relationField.attr("relation"));
			if(relation!=null && supervisionFormId!='' &&supervisionFormId!='0' && relation.toRelationObj==supervisionFormId){//当关联ID与督办表单一致时则屏蔽选择关联表单按钮
				relationField.css("visibility","hidden");
				if(supType!=''&&typeof(fnx.initRelation)!='undefined'){
					fnx.initRelation(field,relationJson);
				}
			}
		}
		
	});
	
});

function initNewGovdocOpinion(){
	//如果没有意见输入框， 或者不可编辑
	var canEditOpinion=false;
	$("#hasnibanComment").val("0");
	if(typeof(zwIframe.$)!='undefined'){
		zwIframe.$("textarea").each(function(){
			if($(this).attr("mappingField")=='nibanyijian'){
				$("#hasnibanComment").val("1");//写入空意见
				if($(this).parent().attr("class")=='edit_class'){
					$("#hasnibanComment").val("2");//写入全部意见
					if(allowCommentInForm!='1'&&newGovdocView==1){//不允许在文单中修改意见，才显示
						nibanSpanObj = $(this);
						canEditOpinion=true;
						if($(this).val()!=""){
							$("#content_deal_comment").val($(this).val());
						}
						$(this).attr("readOnly","readOnly");
						$(this).attr("unselectable","on");
					}else{//
						var processHTML = "";
						processHTML+="<a onclick='javascript:ShowphraseC("+$("#cphrase").attr("curUser")+",\""+$(this).attr("id")+"\")' id='cUseP' style='margin-bottom:5px;float:right;font-size:12px;'>";
						processHTML+="<span class='dealicons commonPhrase'></span>";
						processHTML+="常用语</a>";
						$(this).before(processHTML);
						opinionTextarea = $(this).attr("id");
					}
					return false;
				}
			}
		});
		if(canEditOpinion){
			$("#commonuse").show();
			$("#content_deal_comment").show();
		}else{
			$("#commonuse").hide();
			$("#content_deal_comment").hide();
		}

	}
}
function addNewPhrase(docum){
	var processHTML = "";
	processHTML+="<a onclick='javascript:ShowphraseC("+$("#cphrase").attr("curUser")+",\""+$(docum).attr("id")+"\")' id='cUseP' style='float:right;font-size:12px;'>";
	processHTML+="<span class='dealicons commonPhrase'></span>";
	processHTML+="常用语</a>";
	$(docum).before(processHTML);
	opinionTextarea = $(this).attr("id");
}
function changeFormList(obj){
	$("#formList").empty();
	var selIndex = obj.selectedIndex;
	var selOption = obj.options[selIndex];
	var edocCategoryId = selOption.value;
	for(var i = 0;i<allFormList.length;i++){
		if(allFormList[i].categoryId != edocCategoryId){
			continue;
		}
		if(allFormList[i].defaultFormByCategory=='1'){
			$("#formList").append("<option value='"+allFormList[i].id+"' selected='selected'>"+allFormList[i].name+"</option>");
		}else{
			$("#formList").append("<option value='"+allFormList[i].id+"'>"+allFormList[i].name+"</option>");
		}

	}
	var formList = document.getElementById("formList");
	reloadFormContent(formList);

	//更换了文单后重新绑定密级事件
	$("#zwIframe").load(function(){
		bindFormSecretLevelChanged();
	});
}
function myElement(key,value,type,hiddenValue){
	this.key = key;
	this.value = value;
	this.type = type;
	this.hiddenValue = hiddenValue;
}
function reloadFormContent(obj){
	try{
		var oldObjs = frames['zwIframe'].document.getElementsByTagName("*");
		var oldElements = new Array();
		var j = 0;
		for(var i = 0;i<oldObjs.length;i++){
			var mappingField = oldObjs[i].getAttribute("mappingField");
			var objValue = oldObjs[i].value;
			if(mappingField && mappingField == "doc_mark"&&oldObjs[i].selectedIndex){
				objValue = oldObjs[i].options[oldObjs[i].selectedIndex].text;
			}
			if(mappingField && mappingField == "serial_no"&&oldObjs[i].selectedIndex){
				objValue = oldObjs[i].options[oldObjs[i].selectedIndex].text;
			}
			var eId = oldObjs[i].getAttribute("id");
			if(mappingField && oldObjs[i].nodeName.toLowerCase() != "span" && objValue && eId && eId.indexOf("field") >= 0){

				var hiddenObj = null;
				var hiddenValue = null;
				if(oldObjs[i].id.indexOf("txt") != -1){
					var hiddenObj = oldObjs[i].nextSibling || oldObjs[i].nextElementSibling;
					hiddenValue = hiddenObj.value;
				}
				if(mappingField == "doc_mark"&&oldObjs[i].selectedIndex){
					hiddenValue = oldObjs[i].options[oldObjs[i].selectedIndex].value;
				}
				if(mappingField == "serial_no"&&oldObjs[i].selectedIndex){
					hiddenValue = oldObjs[i].options[oldObjs[i].selectedIndex].value;
				}
				var type = oldObjs[i].tagName;
				var value = objValue;
				var o = new myElement(mappingField,value,type,hiddenValue);
				if(hiddenValue != null && hiddenValue!=""){
					oldElements[j++] = mappingField + ":" + hiddenValue;
				}else{
					oldElements[j++] = mappingField + ":" + value;
				}
			}
		}
		var selIndex = obj.selectedIndex;
		var selOption = obj.options[selIndex];
		var formId = selOption.value;
		$("#formId").val(formId);
		
		reloadGovdocForm();
		
		var url = "/seeyon/content/content.do?method=invokingForm&isNew=true&formId="+formId+"&viewState=1&isFullPage=true&moduleType=4";
		url += "&distributeContentDataId=" + distributeContentDataId
		url += "&distributeContentTemplateId=" + distributeContentTemplateId + "&summaryId="+$("#id").val();
		url += "&oldSummaryId=" + oldSummaryId + "&forwardAffairId=" + forwardAffairId + "&oldElements=" + oldElements.join("@");
		$("#zwIframe").attr("src",url);
	}catch(e){
		alert(e);
	}
}

/**
 * 检查内部文号是否已经存在，如果存在则要给出提示
 */
function checkExistsSerialNo(serialNo){
	if("" == serialNo || null ==serialNo){
		return;
	}
	if(serialNo == "请选择内部文号"){
		return;
	}
	var colMan = new colManager();
	return colMan.existsSerialNo(serialNo,curSummaryID);
}

/**
 * 初始化快速发文页面 xuker add
 */
function initFawenQuickSendUI(){
	//保存待发 saveDraft_a
	$("#saveDraft_a").hide();
	$("#saveDraft_a").next().hide();//中间那条线

	//调用模板 refresh2_a
	$("#refresh2_a").hide();
	$("#refresh2_a").next().hide();//中间那条线

	//存为模板 refresh1_a
	$("#refresh1_a").hide();
	$("#refresh1_a").next().hide();//中间那条线

	//流程期限
	//提前提醒
	$("#sendId").closest("tr").find("th").hide();
	$("#sendId").closest("tr").find("td").not($("#sendId").closest("td")).hide();

	//跟踪
	$("#canTrack").closest("th").hide();
	$("#zdgzry").closest("td").hide();


	//更多
	$("#show_more").closest("td").hide();

	$("#colPigeonhole").closest("td").css("padding-right", "30px").prev("th").css("padding-left", "25px");
	//todo xukertodo
	//alert("快速发文初始化页面！");
	if(newGovdocView==1){
		$("#liuchengqx").closest("tr").hide();
		$("#tiqiantix").closest("tr").hide();
	}
}
/**
 * 初始化快速发文页面 xuker add
 */
function initShouwenQuickSendUI(){
	//todo xukertodo
	//alert("快速收文初始化页面！");
}

/**
 * 快速发文弹出送往单位 xuker add
 */
var quickSendUnitObj= null;
function beforeSendCollForEdocQuickSend(){
	var exchange = new govdocExchangeManager();
	var quickSendUnit=""; //送往单位的信息
	var isInputAcc = false;
	if(!setMainUnitAndCopyUnit()){
		isInputAcc = true;
	}
	var sendUnitVal = $("#fenfa_input_value").val();
	var sendUnitTxt = $("#fenfa_input").val();
	if(isInputAcc){
		if(!confirm("手写单位不能交换，是否继续?")){
			return;
		}
	}
	if(sendUnitVal.trim()==""&&!isInputAcc){
		$.messageBox({
	        'type' : 0,
            'imgType':2,
            'title':$.i18n('system.prompt.js'), // 系统提示
	        'msg' : '分送单位不能为空',// 标题不能为空
	        ok_fn : function() {
	    		//element.focus();
	        }
	      });
		return ;
	}else{
		var val = sendUnitVal;
		var txt = sendUnitTxt;
		var valArr = val.split(",");
		valArr = valArr.myUnique();

		val = valArr.join(",");
		quickSendUnit = val;
		$("#quickSendUnit").val(val);
		var orgIds = "";
		var orgId = val.split(",");
		for(var i =0;i<orgId.length;i++){
			if(orgId[i].split("|")[1]){
				orgIds += orgId[i].split("|")[1]+",";
			}
		}
		orgIds = orgIds.substring(0,orgIds.length-1);
		//判断是否包含外部单位
		var outAccount = exchange.validateExistAccountOrDepartment(orgIds);
		if(outAccount!=''){
			if(!confirm('外部单位不能交换，是否继续？')){
				return;
			}
		}
		var returnVal = exchange.validateExistAccount(val);
		if(returnVal && returnVal !=""){
			alert($.i18n("govdoc.not.signWorkflow")+":\n  "+returnVal);
		}
		sendCollaboration();
	}


	//var par = new Object();
	//if(quickSendUnitObj!=null){
	//	var val = quickSendUnitObj.value+","+sendUnitVal;
	//	var txt = quickSendUnitObj.text+","+sendUnitTxt;
	//	var valArr = val.split(",");
	//	var txtArr = txt.split(",");
	//	valArr = valArr.myUnique();
	//	txtArr = txtArr.myUnique();
	//	val = valArr.join(",");
	//	txt = txtArr.join(",");
	//	par.value = val;
	//	par.text = txt;
	//}else{
	//	par.value = sendUnitVal;
	//	par.text = sendUnitTxt;
	//}
	//$.selectPeople({
	//	panels: 'Account,Department,OrgTeam',
	//	selectType: 'Account,Department,OrgTeam',
	//	hiddenPostOfDepartment:true,//隐藏岗位
	//	showAllOuterDepartment:true,//显示所有外部单位
	//	isCanSelectGroupAccount:false,//是否可选集团单位
	//	params : par,
	//	minSize:1,
	//	callback : function(ret) {
	//		quickSendUnit = ret.value
	//		var txt = ret.text;
	//		quickSendUnitObj = ret;
	//		if(quickSendUnit!=""){
	//			$("#quickSendUnit").val(quickSendUnit);
	//			var orgs = quickSendUnit.split(",");
	//			var names = txt.split("、");
	//			var orgIds = new Array();
	//			var orgNames = new Array();
	//			for(var i=0;i<orgs.length;i++){
	//				orgIds.push(orgs[i].split("|")[1]);
	//				orgNames.push(names[i]);
	//			}
	//			//判断是否包含外部单位
	//			var outAccount = exchange.validateExistAccountOrDepartment(orgIds.join(",")+"|"+orgNames.join(","));
	//			if(orgNames.join(",")==outAccount){
	//				$.alert("发行单位不能为空,外部单位不能交换");
	//				return;
	//			}
	//			var returnVal = exchange.validateExistAccount(quickSendUnit);
	//			if(returnVal && returnVal !="" ||outAccount!=""){
	//				alert("以下单位未设置收文交换流程或存在外部单位，流程处于待交换状态，请在发行状态中查看:\n"+outAccount + "  "+returnVal+"\n如果发送到的部门没有配置收文签收流程，" +
	//						"则会默认发送到该部门所属单位");
	//			}
	//			sendCollaboration();
	//		}else{
	//			alert('请选择送往单位！');
	//			return ;
	//		}
	//	}
	//});


	//var dialog = $.dialog({
	//	targetWindow:getCtpTop(),
	//	id: 'edocQuickSendUnit',
	//	url: curlocationPath +"/collaboration/collaboration.do?method=edocQuickSendUnit",
	//	width: 350,
	//	height: 220,
	//	title: $.i18n('collaboration.newcoll.sendUnit'),
	//	transParams:{
	//		"sendUnitVal":sendUnitVal,
	//		"sendUnitTxt":sendUnitTxt
	//	},
	//	targetWindow:getCtpTop(),
	//	buttons: [{
	//		text: $.i18n('collaboration.pushMessageToMembers.confirm'), // 确定
	//		handler: function () {
	//			quickSendUnit = dialog.getReturnValue();
	//			if(quickSendUnit!=""){
	//				$("#quickSendUnit").val(quickSendUnit);
	//				sendCollaboration();
	//				dialog.close();
	//			}
	//		}
	//	}, {
	//		text: $.i18n('collaboration.pushMessageToMembers.cancel'), // 取消
	//		handler: function () {
	//			dialog.close();
	//		}
	//	}]
	//});
	return quickSendUnit;
}

Array.prototype.myUnique = function()
{
	var n = [this[0]]; //结果数组
	for(var i = 1; i < this.length; i++) //从第二项开始遍历
	{
		//如果当前数组的第i项在当前数组中第一次出现的位置不是i，
		//那么表示第i项是重复的，忽略掉。否则存入结果数组
		if (this.indexOf(this[i]) == i) n.push(this[i]);
	}
	return n;
}
/**
 * 从表单中读取快速发文设置 发行至的送往单位 包括主送单位和抄送单位 xuker add
 */
function setMainUnitAndCopyUnit(){
	//从表单中获取主送单位和抄送单位
//	var mainUnitObj = $("[mappingField=send_to]",window.frames["zwIframe"].document);
//	var copyUnitObj = $("[mappingField=copy_to]",window.frames["zwIframe"].document);
//	var mainUnitObjTxt = "";
//	var copyUnitObjTxt = "";
//	var mainUnitTxt = "";//主送单位名称字符串
//	var mainUnitVal = "";//主送单位账号字符串
//	var copyUnitTxt = "";//抄送单位名称字符串
//	var copyUnitVal = "";//抄送单位账号字符串
//	if(mainUnitObj.length>0){
//		mainUnitTxt = $(mainUnitObj,window.frames["zwIframe"].document).html();
//		var mainUnitInputId = $(mainUnitObj).attr("id").replace("_txt","");
//		mainUnitVal = $("#"+mainUnitInputId,window.frames["zwIframe"].document).val();
//		if(mainUnitVal!=""&&mainUnitTxt==""){ //firfox下没有取到页面上的主送单位字符串，这样取一下
//			mainUnitTxt = $(mainUnitObj,window.frames["zwIframe"].document).attr("title");
//		}
//		mainUnitObjTxt = mainUnitTxt;
//		if(mainUnitVal!=''){
//			var valArr = mainUnitVal.split(",");
//			var reg = /[a-zA-Z]+\|(-?[0-9]{6,})/;
//			var lastVal = "";
//			for(var i =0;i<valArr.length;i++){
//				var r = valArr[i].match(reg);
//				if(r!=null){
//					lastVal+=valArr[i]+",";
//				}
//			}
//			if(lastVal!=""){
//				lastVal = lastVal.substring(0,lastVal.length-1);
//			}
//			mainUnitVal = lastVal;
//		}
//	}
//	if(copyUnitObj.length>0){
//		copyUnitTxt = $(copyUnitObj,window.frames["zwIframe"].document).html();
//		var copyUnitInputId = $(copyUnitObj).attr("id").replace("_txt","");
//		copyUnitVal = $("#"+copyUnitInputId,window.frames["zwIframe"].document).val();
//		if(copyUnitVal!=""&&copyUnitTxt==""){ //firfox下没有取到页面上的主送单位字符串，这样取一下
//			copyUnitTxt = $(copyUnitObj,window.frames["zwIframe"].document).attr("title");
//		}
//		copyUnitObjTxt = copyUnitTxt;
//		if(copyUnitVal!=''){
//			var valArr = copyUnitVal.split(",");
//			var reg = /[a-zA-Z]+\|(-?[0-9]{6,})/;
//			var lastVal = "";
//			for(var i =0;i<valArr.length;i++){
//				var r = valArr[i].match(reg);
//				if(r!=null){
//					lastVal+=valArr[i]+",";
//				}
//			}
//			if(lastVal!=""){
//				lastVal = lastVal.substring(0,lastVal.length-1);
//			}
//			copyUnitVal = lastVal;
//		}
//	}
//	//设置值
//	var oldinputVal = "";
//	var oldinputTxt = "";
//	var unitValArr = new Array();
//	var unitTxtArr = new Array();
//	
//	
//	var unitVal = "";
//	var unitTxt = "";
//	if(mainUnitVal != "") {
//		unitVal += mainUnitVal;
//		unitTxt += mainUnitTxt;
//	}
//	if(copyUnitTxt!="") {
//		if(unitVal != "") {
//			unitVal += ",";
//			unitTxt += "、";
//		}
//		unitVal += copyUnitVal;
//		unitTxt += copyUnitTxt;
//	}
//	if(unitVal!=""){
//		var tempUnit = unitVal.split(",");
//		var tempUnitTxt = unitTxt.split("、");
//		for(var i=0;i<tempUnit.length;i++){
//			if(tempUnit[i]!=""&&$.inArray(tempUnit[i],unitValArr)==-1){
//				unitValArr.push(tempUnit[i]);
//				unitTxtArr.push(tempUnitTxt[i]);
//			}
//		}
//	}
//	for(var i=0;i<unitValArr.length;i++){
//		if(i==unitValArr.length-1){
//			oldinputVal+=unitValArr[i];
//			oldinputTxt+=unitTxtArr[i];
//		}else{
//			oldinputVal+=unitValArr[i]+",";
//			oldinputTxt+=unitTxtArr[i]+"、";
//		}
//	}
//	$("#fenfa_input_value").val(oldinputVal);
//	$("#fenfa_input").val(oldinputTxt);
//	if(unitTxtArr.join("、")!=unitTxt){
//		return false;
//	}
//	if((mainUnitObjTxt!=""&&mainUnitVal=="") 
//			|| (copyUnitObjTxt!=""&&copyUnitVal=="")) {
//		return false;
//	}
	var orgIds = new Array();
	var orgTempIds = new Array();
	var orgNames = new Array();
	zwIframe.$("span[id^='field'][id$='_span']").each(function(){
		var fieldVal = $(this).attr("fieldVal");
		fieldVal = $.parseJSON(fieldVal);
		var mappingField = "";
		if($(this).children()[0]){
			mappingField = $($(this).children()[0]).attr("mappingField");
		}
		if(mappingField=="send_to"||mappingField=="copy_to"||mappingField=="report_to"){
			var value = $(this).find("input").attr("value");
			if(value!=''){
				orgTempIds=orgTempIds.concat(value.split(","));
			}
		}
	});
	if(orgTempIds.length>0){
		var reg = /([a-zA-Z]+\|)?(-?[0-9]{6,})/;
		for(var i =0;i<orgTempIds.length;i++){
			var r = orgTempIds[i].match(reg);
			if(r!=null&&typeof(r[1])!='undefined'){
				orgIds.push(orgTempIds[i]);
			}
		}
	}
	var fenfaVal = "";
	for(var i=0;i<orgIds.length;i++){
		if(i==orgIds.length-1){
			fenfaVal +=orgIds[i];
		}else{
			fenfaVal +=orgIds[i]+",";
		}
	}
	$("#fenfa_input_value").val(fenfaVal);
	if(orgIds.length!=orgTempIds.length){
		return false;
	}
	return true;
}

var tempTemplatefileUrl = "";
//快速发文--套红--start
function sendQuick_taohong(templateType) {
	if (document.getElementById("fileUrl").value == "") {
		return;
	}

	var bodyType = document.getElementById("govdocBodyType").value;
	var orgAccountId = loginAccount;

	if (templateType == "edoc") {

		if (bodyType == "HTML") {
			alert($.i18n("govdoc.htmlnofuntion.text"));
			document.getElementById("fileUrl").value = "";
			return;
		}

		if (bodyType == "OfficeExcel")// excel不能进行正文套红。
		{
			alert($.i18n("govdoc.excelnofuntion.text"));
			document.getElementById("fileUrl").value = "";
			return;
		}

		if (bodyType == "WpsExcel")// excel不能进行正文套红。
		{
			alert($.i18n("govdoc.wpsetnofuntion.text"));
			document.getElementById("fileUrl").value = "";
			return;
		}

		if (bodyType == "Pdf") {
			alert($.i18n("govdoc.pdfnofuntion.text"));
			document.getElementById("fileUrl").value = "";
			return;
		}

		if (bodyType == "gd") {
			alert($.i18n("govdoc.gdnofuntion.text"));
			document.getElementById("fileUrl").value = "";
			return;
		}

		// 判断文号是否为空
		//if (checkEdocWordNoIsNull() == false) {
		//	document.getElementById("fileUrl").value = "";
		//	return;
		//}
	}
	// Ajax判断是否存在套红模板
	if (!hasEdocDocTemplate(orgAccountId, templateType, bodyType)) {
		$.alert($.i18n('govdoc.docTemplate.record.notFound'));
		document.getElementById("fileUrl").value = "";
		return;
	}
	if (bodyType.toLowerCase() == "officeword"
			|| bodyType.toLowerCase() == "wpsword" || templateType == "script") {

		if (templateType == "edoc") {
			// 判断是否有印章，有印章的时候不允许套红。
			if (getSignatureCount() > 0) {
				alert($.i18n("govdoc.notaohong.signature"));
				document.getElementById("fileUrl").value = "";
				return;
			}
            //
			//if(!saveGovdocBody2()){
			//	return ;
			//}
			// 正文套紅將會自動清稿，你確定要這麼做嗎?
			if(getBookmarksCount() == 0){
				if (confirm($.i18n("govdoc.alertAutoRevisions"))) {
					tempTemplatefileUrl = document.getElementById("fileUrl").value;
					// 清除正文痕迹并且保存
					if (!removeTrailAndSave()) {
						document.getElementById("fileUrl").value = "";
						return;
					}
				} else {
					document.getElementById("fileUrl").value = tempTemplatefileUrl;
					return;
				}
			}else{
				tempTemplatefileUrl = document.getElementById("fileUrl").value;
				// 清除正文痕迹并且保存
				if (!removeTrailAndSave()) {
					document.getElementById("fileUrl").value = "";
					return;
				}
			}
		}
		if(getBookmarksCount() > 0){
			var random = $.messageBox({
			    'type': 100,
			    'msg':'正文已套红，是否需要更改套红模板，点击是选择新套红模板，点击否则只更新正文书签内容。',
			    buttons: [{
			    id:'btn1',
			        text: "是",
			        handler: function () {
						taohongFuncks(templateType);
					}
			    }, {
			    id:'btn2',
			        text: "否",
			        handler: function () {
			        	var sendData = null;
		            	if(navigator.userAgent.indexOf("MSIE")>0) {
		            		sendData = $(window.frames["zwIframe"].document);
		            	} else {
		            		sendData = $(window.frames["zwIframe"].document);
		            	}
		            	refreshGovdocTaohong(sendData);
		            	contentUpdate = true;
			        }
			    }, {
			    id:'btn3',
			        text: "取消",
			        handler: function () { random.close(); }
			    }]
			});
		}else{
			taohongFuncks(templateType);
		}
	}
}


function taohongFuncks(templateType){
	var receivedObj;
	var str = document.getElementById("fileUrl").value;
	receivedObj = str;

	var taohongTemplateContentType = "";
	var ts = receivedObj.split("&");
	taohongTemplateContentType = ts[1];
	receivedObj = ts[0];
	var taohongSendUnitType = ts[2];

	var sendUnitTypeInput = document.createElement("input");
	sendUnitTypeInput.id = "taohongSendUnitType";
	sendUnitTypeInput.name = "taohongSendUnitType";
	sendUnitTypeInput.type = "hidden";
	sendUnitTypeInput.value = taohongSendUnitType;

	// GOV-3253 【公文管理】-【发文管理】-【待办】，处理待办公文时进行'文单套红'出现脚本错误
	// IE7不支持这句，而且在文单套红时也把选择单位或部门的去掉了，所以这里不用了
	// contentIframe.document.getElementsByName("sendForm")[0].appendChild(sendUnitTypeInput);

	if (taohongTemplateContentType == "officeword") {
		taohongTemplateContentType = "OfficeWord";
	} else if (taohongTemplateContentType == "wpsword") {
		taohongTemplateContentType = "WpsWord";
	}

	// 记录字段值为TRUE，JS用来记录套红操作
	if (receivedObj == null) {
		document.getElementById("fileUrl").value = "";
		return;
	} else {
		var redContent = document.getElementById("redContent");
		if (redContent && templateType == "edoc") {
			redContent.value = "true";
		}
	}
	contentOfficeId.put("0", fileId);
	setOfficeOcxRecordID(contentOfficeId.get("0", null));
	officetaohong($(window.frames["zwIframe"].document), receivedObj, templateType, extendArray,1);
	contentUpdate = true;
	hasTaohong = true;
	taohongFileUrl = document.getElementById("fileUrl").value;
}
//快速发文--套红--end

//ajax判断是否存在套红模板
function hasEdocDocTemplate(orgAccountId,templateType,bodyType){
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocDocTemplateController", "hasEdocDocTemplate",false);
	requestCaller.addParameter(1, "Long", orgAccountId);
	requestCaller.addParameter(2, "String", templateType);
	requestCaller.addParameter(3, "String", bodyType);
	var ds = requestCaller.serviceRequest();
	//"0":没有，“1”：有
	if(ds=="1"){return true;}
	else {return false;}
}
//根据类型 更改套红模板
function getTaoHongList(userId , bodyType){
	var taoHongType = "officeword";
	if(bodyType==43){
		taoHongType = "wpsword";
	}
	var objs = edocDocTemplateManager.findGrantedListForTaoHong(userId,0,taoHongType);
	var ops = $("#fileUrl").find("option");
	$(ops).not(":first").remove();
	for(var i=0;i<objs.length;i++){
		var fileUrl = objs[i].fileUrl;
		var textType = objs[i].textType;
		var name = objs[i].name;
		var status = objs[i].status;
		if(status==1){
			var opStr = '<option value="'+fileUrl+'&'+textType+'">'+name+'</option>';
			$(opStr).appendTo($("#fileUrl"));
		}
	}
}
//G6V5.7- 保存公文正文
function saveGovdocBody2(){
	var fnx;
	fnx =document.getElementById("zwIframe").contentWindow;
	var bodyType = document.getElementById("govdocBodyType").value;
	//保存公文正文
	if(bodyType == "HTML"){
		var rsStr = fnx.getHtmlContent();
	}else{
		var bodyType = document.getElementById("govdocBodyType");
		bodyType.value="OfficeWord";
		return saveOffice();
	}

	//G6V5.7- 保存公文正文 --end
	return true;

}

//套红的时候，如果是联合发文，会用两个单位的套红模板将正文分别套红，形成两套正文。
//套红的时候，如果是联合发文，检查公文的第一套正文或者第二套正文是否已经被创建，没有创建就创建，已经创建就返回当前正文ID
//创建的方式：createContentBody会在后台向edocbody表中添加记录，并且返回新的正文ID（newOfficeID）,
//        并且将newOfficeID赋值给控件的fileID.,这样保存的时候就会创建新的正文，并且向file表中添加新的记录。
function checkExistBody(){
	var isUniteSend=false;//document.getElementById("isUniteSend").value;
	var summaryId=curSummaryID;//document.getElementById("summary_id").value;
	var contentNum=currContentNum;////document.getElementById("currContentNum").value;
	var bodyType = document.getElementById("govdocBodyType").value;
	if(contentUpdate==false || isUniteSend!="true"){return ;}
	if(contentOfficeId.get(contentNum,null)==null)
	{
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocManager", "createContentBody",false);
		requestCaller.addParameter(1, "String", summaryId);
		requestCaller.addParameter(2, "int", contentNum);
		requestCaller.addParameter(3, "String", contentOfficeId.get("0",null));
		requestCaller.addParameter(4, "String", bodyType);
		var ds = requestCaller.serviceRequest();
		fileId=ds;
		contentOfficeId.put(contentNum,ds);
	}
	else
	{
		fileId=contentOfficeId.get(contentNum,null);
	}
	return fileId;
}

//copy from deal_govdoc.js start 2016-04-19
function saveContent(){
	var bodyType = document.getElementById("govdocBodyType").value;
	document.getElementById("bodyType").value = bodyType;
	return saveGovdocContent();
}

//处理时保存公文正文
function saveGovdocContent()
{
	var ajaxStr = "" ;//记录的是修改的类型的记录
	var affair_IdValue = document.getElementById("affair_id") ;
	var summary_IdValue = document.getElementById("summary_id");
	var ajaxUserId = document.getElementById("ajaxUserId");
	var redFormObj = document.getElementById("redForm");
	if(redFormObj)  {
		var redFormValue = redFormObj.value ;
		if(redFormValue == "true" && affair_IdValue && summary_IdValue){
			ajaxStr = ajaxStr + ",taohongwendan" ;
		}
	}


	//Word转Pdf以后，如果PDF加盖了专业签章，保存PDF
	try{
		if ($("#contentIframe")[0].contentWindow.checkContentModify()) {
			$("#contentIframe")[0].contentWindow.savePdf();
		}
	}catch(e){
	}


	if(contentUpdate==false){
		submitToRecord();
		return true;
	}
	var bodyType = document.getElementById("govdocBodyType").value;
	if(bodyType=="HTML")
	{
		//保存专业签章
		if(typeof(htmlContentIframe) != "undefined" && htmlContentIframe.isInstallIsignatureHtml()){
			htmlContentIframe.saveISignatureHtml(3);
		}
		try {
			var ds;
			var url = window.location.search;
			var ajaxColManager = new colManager();
			var params = new Object();
			params.content = getHtmlContent();
			var summaryId2 = GetQueryString(url,"summaryId");
			if(!summaryId2){
				summaryId2 = summaryId;
			}
			params.summaryId = summaryId2;
			params.contentType = "10";
			ajaxColManager.saveGovdocContent(params, {
				success: function(rs){
					ds = rs;
				}
			});
			//var rtVal = tBS.testAjaxBean2(ajaxTestBean);
			ajaxStr = ajaxStr + ",contentUpdate" ;
			submitToRecord();
			return (ds=="true");
		}
		catch (ex1) {
			alert("Exception : " + (ex1.number & 0xFFFF)+ex1.description);
			return false;
		}
	}else if(bodyType=="Pdf"){
		savePdf();
		if(contentUpdate) {
			if(changeWord){
				ajaxStr = ajaxStr + ",contentUpdate" ;
			}
		}
		submitToRecord();
	}else
	{
		/**
		 * 记录正文被修改的记录
		 */
		if(contentUpdate) {
			if(changeWord){
				ajaxStr = ajaxStr + ",contentUpdate" ;
			}
		}
		/**
		 * 记录正文套红
		 */
		if(hasTaohong) {
			if(typeof redContent!="undefined"){
				var redContentValue = redContent;
				if(redContentValue && redContentValue.value == "true")
					ajaxStr = ajaxStr + ",taohong" ;
			}
		}
		/**
		 * 签章
		 */
		if(changeSignature) {
			ajaxStr = ajaxStr + ",qianzhang" ;
		}


		if(saveOffice()==false)
		{
			return false;
		}
	}
	/**
	 * 修改正文并且导入了新文件，需要记录应用日志
	 */
	try{
		if(isLoadNewFileEdoc) {
			ajaxStr = ajaxStr + ",isLoadNewFile" ;
		}
	}catch(e){
	}
	submitToRecord();
	// AJax记录操作日志
	function submitToRecord(){
		if(ajaxStr != ""  && affair_IdValue && summary_IdValue && ajaxUserId) {
			recordChangeWord(affair_IdValue.value ,summary_IdValue.value ,ajaxStr, ajaxUserId.value)
			ajaxStr = "" ;
		}
	}
	return true;
}
/**
 * AJax记录流程日志
 */
function recordChangeWord(affair_IdValue ,summary_IdValue ,ajaxStr,userId) {
	if(null == affair_IdValue || "" == affair_IdValue){
		var url = window.location.search;
		affair_IdValue = GetQueryString(url,"affairId");
	}
	if(null == summary_IdValue || "" == summary_IdValue){
		var url = window.location.search;
		var summaryId2 = GetQueryString(url,"summaryId");
		if(!summaryId2){
			summaryId2 = summaryId;
		}
		summary_IdValue = summaryId2;
	}
	if(affair_IdValue == "" && summary_IdValue == "" && ajaxStr == "")
		return ;
	try{
		if(affair_IdValue && summary_IdValue) {
			var colManagerAjax = new colManager();
			var params = new Object();
			params["affairId"] =  affair_IdValue;
			params["summaryId"] =  summary_IdValue;
			params["changeType"] =  ajaxStr;
			params["userId"] =  userId;
			colManagerAjax.recoidChangeWord(params);
		}
	}catch(e){
	}
}
//copy from deal_govdoc.js start 2016-04-19

//二维码扫描,初始化表单数据
function initData(reader){
	if(reader){
		//标题
		var subject = getDocumentobjByMappingfieldForDengji("subject");
		if(subject){
			subject.value = reader.GetDocTitle();
		}
		//公文文号
		var docMark = getDocumentobjByMappingfieldForDengji("doc_mark");
		if(docMark){
			try {
				//在收文中，公文文号是文本框，直接赋值就可以
				docMark.value = reader.GetSerialNumber();
				//以下是写下拉框的方式
				//var docMarkValue = reader.GetSerialNumber();
				//docMark.options.add(new Option(docMarkValue, docMarkValue));
				//docMark.value = docMarkValue;
				//var docMarkName = docMark.name;
				//var docMarkId = docMarkName.replace("_txt", "");
				//var obj = $(window.frames["zwIframe"].document).find("[id=" + docMarkId + "]")[0];
				//obj.value = docMarkValue;
			}catch(e){

			}
		}
		//主送单位
		var sendTo = getDocumentobjByMappingfieldForDengji("send_to");
		if(sendTo) {
			try {
				var idstr = reader.GetReceCompany();
				var ids = idstr.split("|");
				var sendtofieldid = sendTo.name.replace("_txt","");
				var obj = $(window.frames["zwIframe"].document).find("[id="+sendtofieldid+"]")[0];
				if(ids.length>1){
					sendTo.value = ids[0];
					obj.value = getDepartmentInfo(ids[1]);
				}
			}catch(e){

			}
		}
		//发文单位
		var send_unit = getDocumentobjByMappingfieldForDengji("send_unit");
		if(send_unit) {
			try {
				var idstr = reader.GetDispCompany();
				var ids = idstr.split("|");
				var sendunitfieldid = send_unit.name.replace("_txt","");
				var obj = $(window.frames["zwIframe"].document).find("[id="+sendunitfieldid+"]")[0];
				if(ids.length>1){
					send_unit.value = ids[0];
					obj.value = getDepartmentInfo(ids[1]);
				}
			}catch(e){

			}
		}
		//拟稿日期
		var edocDate = getDocumentobjByMappingfieldForDengji("createdate");
		if(edocDate){
			try {
				edocDate.value = reader.GetDocTime();
			}catch(e) {

			}
		}
		//文件密级
		var urgentLevel = getDocumentobjByMappingfieldForDengji("secret_level");
		var scanUrgentLevel = reader.GetSecuLevel();
		//var scanUrgentLevel = "机密";
		if(urgentLevel && scanUrgentLevel){
			try {
				var urgentleveloptions = urgentLevel.options;
				if (urgentleveloptions) {
					for (var i = 0; i < urgentleveloptions.length; i++) {
						if (urgentleveloptions[i].text == scanUrgentLevel) {
							urgentleveloptions[i].selected = true;
							var field_name = urgentLevel.name + "_txt";
							var obj = $(window.frames["zwIframe"].document).find("[id=" + field_name + "]")[0];
							obj.value = scanUrgentLevel;
						}
					}
				}
			}catch (e){

			}
		}
		//紧急程度
		var secretLevel = getDocumentobjByMappingfieldForDengji("urgent_level");
		var scanSecretLevel = reader.GetUrgenLevel();
		//var scanSecretLevel = "加急";
		if(secretLevel && scanSecretLevel){
			try {
				var secretLeveloptions = secretLevel.options;
				for(var i=0;i<secretLeveloptions.length;i++){
					if(secretLeveloptions[i].text == scanSecretLevel){
						secretLeveloptions[i].selected = true;
						var field_name = secretLevel.name + "_txt";
						var obj = $(window.frames["zwIframe"].document).find("[id="+field_name+"]")[0];
						obj.value = scanSecretLevel;
					}
				}
			}catch (e){

			}
		}
		//公文种类
		var doctype = getDocumentobjByMappingfieldForDengji("doc_type");
		var doctypevalue = reader.GetDocName();
		//var doctypevalue = "批复";
		if(doctype && doctypevalue){
			try {
				var doctypeoptions = doctype.options;
				for(var i=0;i<doctypeoptions.length;i++){
					if(doctypeoptions[i].text == doctypevalue){
						doctypeoptions[i].selected = true;
						var field_name = doctype.name + "_txt";
						var obj = $(window.frames["zwIframe"].document).find("[id="+field_name+"]")[0];
						obj.value = doctypevalue;
					}
				}
			}catch (e){

			}
		}
	}
}
//通过表单中的mappingfield得到相关的dom对象
function getDocumentobjByMappingfieldForDengji(name){
	var obj = $(window.frames["zwIframe"].document).find("[mappingField="+name+"]")[0];
	return obj;
}

var templateSecretLevelEnable = true;
function changeSecretLevel(object,processId){
	var selectValue = object.value;
	//调用模板设置流程密级进行判断是否合适
	/*if(isGovdocSystemTemplate=='true'){
		$.ajax({url : _ctxPath + "/secret/secretController.do?method=checkTemplateSecretLevel&processId=" + processId+"&secretLevel="+selectValue,
			success : function(data){
	  			if(data == "false"){
	  				document.getElementById("secretLevel").value = flowSecretLevel_wf;
	  				$.alert($.i18n('secret.flowcheck.cannot'));
	  				templateSecretLevelEnable = false;
	  				return false;
	  			}else{
	  				templateSecretLevelEnable = true;
	  				flowSecretLevel_wf = selectValue;
	  				synFormSecretLevel(object);
	  			}
	  		}
	  	});
	}*//*else{
		var workflowInfoObj = document.getElementById("process_info");
		var f = false;
	    if(isQuickSend == 'false' && workflowInfoObj.value != "<点击新建流程>" && workflowInfoObj.value != "" && selectValue != ""&&newFlag){
			if((!flowSecretLevel_wf || selectValue > flowSecretLevel_wf) ){
				if(window.confirm($.i18n('secret.changeSecretLevel.confirm'))){
					//清空流程
					$("#process_info").tokenInput("clear");
					$("#process_xml").val("");
					tempSelectPeopleElements = null;
					workflowInfoObj.value = "<点击新建流程>";
					wfXmlInfo = "";
					jsonPerm = "";
				    hasWorkflow = false;
				    isFromTemplate = false;
				    f = true;
				}else{
		        	document.getElementById("secretLevel").value = flowSecretLevel_wf;
		        }
	         }else{
	        	 f = true;
	        }
	    }else{
	    	f = true;
	    }
	    if(f){
	    	flowSecretLevel_wf = selectValue;
	    	synFormSecretLevel(object);
	    }

	}*/
}

//分保---密级同步
function synFormSecretLevel(object){
	//与表单中的数据实时同步（要求表单中密级为只读）
	var arr = window.frames["zwIframe"].document.getElementsByTagName("select");
	if(arr && arr.length > 0){
		var selectText = "";
		for(var i=0; i<object.options.length; i++){
			var opt = object.options[i];
			if(opt.selected ==true || opt.selected=="selected"){
				selectText = opt.text;
				break;
			}
		}
		for(var i = 0; i < arr.length;i ++){
			if($(arr[i]).attr("mappingField") == "secret_level"){
				var txtID = $(arr[i]).attr("id");
				for(var j=0; i<arr[i].options.length; j++){
			        if(arr[i].options[j] && arr[i].options[j].text == selectText){
			        	arr[i].options[j].selected = true;
			        	window.frames["zwIframe"].document.getElementById(txtID+"_txt").value=arr[i].options[j].text;
			            break;
			        }
			    }
			}
		}
	}
}

function bindFormSecretLevelChanged() {
	var formSecretLevelSelect;
	var arr = window.frames["zwIframe"].document.getElementsByTagName("select");
	if (arr && arr.length > 0) {
		for (var i = 0; i < arr.length; i++) {
			if ($(arr[i]).attr("mappingField") == "secret_level") {
				formSecretLevelSelect = arr[i];
				break;
			}
		}
		if (!formSecretLevelSelect) {
			return;
		}
		formSecretLevelSelect.onchange = function() {
			if(isQuickSend=='false'){
			// 因为覆盖了onchange，重新调用原有逻辑
			window.frames["zwIframe"].calc(this);
			// 因为文单密级的value与密级的value不同，所以此处只能用text判断
			var selectText = "";
			for (var i = 0; i < this.options.length; i++) {
				var opt = this.options[i];
				if (opt.selected == true || opt.selected == "selected") {
					selectText = opt.text;
					break;
				}
			}
			var attDocs = $("#attachment2AreaDoc1").find("div");
			var subject="";
			var selectValue = selectText;
			var flag = false;
			switch (selectValue) {
			case '普通':
				selectValue = 1;
				break;
			case '秘密':
				selectValue = 2;
				break;
			case '机密':
				selectValue = 3;
				break;
			case '绝密':
				selectValue = 4;
				break;
			case '機密':
				selectValue = 3;
				break;
			case '絕密':
				selectValue = 4;
				break;
			}
			if(attDocs.length>0){
				for(var i=0;i<attDocs.length;i++){
			    var id = attDocs[i].getAttribute("id").split("_")[1];
				var affMan = new colManager();
				var affair = affMan.getAffairById(id);
				if(affair==null||affair==""||affair=="undefined"){
					var docM = new docHierarchyManager();
					affair = docM.getDocResourceById(id);
				}
				if(affair==null||affair==""||affair=="undefined"||!affair.secretLevel){
					continue;
				}
				var sl = affair.secretLevel;

				if(sl!=null&&sl>selectValue){
					if(affair.app!=null&&affair.app!=""&&affair.app!="undefined"){
						if(affair.app==4){
							subject += "《"+affair.subject+"》 ";
							flag = true;
						}
					}/*else if(affair.sourceId){
						if(affMan.getAffairById(affair.sourceId)!=null&&affMan.getAffairById(affair.sourceId)!=""&&affMan.getAffairById(affair.sourceId)!="undefined"){
							subject += "《"+affair.frName+"》 ";
							flag = true;
						}
					}*/else{
						subject += "《"+affair.frName+"》 ";
						flag = true;
					}

				}else{
					continue;
				}
			}
			}
			var oldSecretLevelSelect = document.getElementById("secretLevel");
			var isModify = false;
			var sl = 0;
			var min = 5;
			var pro = $('#process_info').tokenInput("get");
			if (pro == null || pro == "" || pro == "undefined") {
				pro = $('#process_info').val();
				if (pro != null && pro != "" && pro != 'undefined'
						&& pro != '<点击新建流程>') {
					var members = pro.split("、");
					for (var i = 0; i < members.length; i++) {
						var sls = members[i].split("（")[1];
						if(typeof(sls) == "undefined"){
							continue;
						}
						sl = sls.split("）")[0];
						switch (sl) {
						case '普通':
							sl = 1;
							break;
						case '秘密':
							sl = 2;
							break;
						case '机密':
							sl = 3;
							break;
						case '绝密':
							sl = 4;
							break;
						case '機密':
							sl = 3;
							break;
						case '絕密':
							sl = 4;
							break;
						}
						if (sl <= min) {
							min = sl;
						}
					}
				}
			} else {
				/*if (pro != null && pro != "" && pro != "undefined") {
					pro = getTrueValues(pro);
					var memberM = new memberManager();

					var notSuitName = "";
					var memberAll = pro.split(",");
					for (var i = 0; i < memberAll.length; i++) {
						var memberId = memberAll[i].split("|")[1];
						if (memberId == null || memberId == ""
								|| memberId == "undefined") {
							continue;
						}
						var orgMember = memberM.getOrgMemberById(memberId);
						if (orgMember != null && orgMember.secretLevel < min) {
							min = orgMember.secretLevel;
						}

					}
				}*/
			}
				if(oldSecretLevelSelect!=null && oldSecretLevelSelect.options!=null){
					if (oldSecretLevelSelect.value < selectValue ) {
						newFlag = true;
					}
					for (var i = 0; i < oldSecretLevelSelect.options.length; i++) {
						var opt = oldSecretLevelSelect.options[i];
						if (opt.text == selectText) {
							opt.selected = true;
		                    if(flag){
		                    	$.alert("关联文档中,"+subject+"密级高于当前公文密级！会导致公文流程中的人员不能查看该文档！");
		                    }
							isModify = true;
							if (min < selectValue ) {
								newFlag = true;
							}
							$("#secretLevel").trigger("change");
							break;
						}
					}
					//若是用户自定义文单密级，和密级无法一一对应，则将密级设置为空
					if (!isModify) {
						oldSecretLevelSelect.options[0].selected = true;
					}
				}
			}else{
				//快速发文同步密级
				var selectText = "";
				for(var i=0; i<this.options.length; i++){
					var opt = this.options[i];
					if(opt.selected ==true || opt.selected=="selected"){
						selectText = opt.text;
						break;
					}
				}
				var oldSecretLevelSelect = document.getElementById("secretLevel");
				if(oldSecretLevelSelect!=null && oldSecretLevelSelect.options!=null){
					for(var i = 0; i < oldSecretLevelSelect.options.length; i++){
						var opt = oldSecretLevelSelect.options[i];
						if(opt.text == selectText){
							opt.selected = true;
							break;
						}
					}
				}
				$("#secretLevel").trigger("change");
			}
		};
	}
}
//检查流程中人员密级
function checkWorkFlow() {
	var pro = $('#process_info').tokenInput("get");
	if (pro == null || pro == "" || pro == "undefined") {
		return;
	}
	pro = getTrueValues(pro);
	var memberM = new memberManager();
	var flag = false;
	var secretlevel = $('#secretLevel option:selected').val();
	if (secretlevel != null && secretlevel != "") {
		var notSuitName = "";
		var memberAll = pro.split(",");
		for (var i = 0; i < memberAll.length; i++) {
			var memberId = memberAll[i].split("|")[1];
			if (memberId == null || memberId == "" || memberId == "undefined") {
				continue;
			}
			var orgMember = memberM.getOrgMemberById(memberId);
			if (orgMember.secretLevel < secretlevel) {
				flag = true;
				notSuitName += orgMember.name + " ";
			}
		}
		if (flag) {
			alert("流程中有低于当前密级的人员：" + notSuitName);
		}
	}
	return flag;
}
//显示常用语
function showphrase(str) {
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
                  textboxID : "content_deal_comment",
                  data : phrasecontent,
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
/**
 * 获取单位部门组织外部单位信息
 * @param idstr
 * @returns {String}
 */
function getDepartmentInfo(idstr){
	var realvalue = "";
	var val = idstr.split(",");
	for(var i=0;i<val.length;i++){
		if(val[i] != undefined && val[i] != "") {
			var orgMan = new orgManager();
			var exchangeManager = new govdocExchangeManager();
			var orgDepartment = null;
			var orgTeam = null;
			var orgExchange = null;
			var orgaccount = orgMan.getAccountById(val[i]);
			if(orgaccount!=null){
				realvalue += "Account|"+val[i];
				if(val.length > 1 && i != val.length-1){
					realvalue += ",";
				}
				continue;
			}else{
				orgDepartment =orgMan.getDepartmentById(val[i]);
			}
		    if(orgDepartment!=null){
				realvalue += "Department|"+val[i];
				if(val.length > 1 && i != val.length-1){
					realvalue += ",";
				}
				continue;
			}else{
				orgTeam = orgMan.getTeamById(val[i]);
			}
			if(orgTeam!=null){
				realvalue += "OrgTeam|"+val[i];
				if(val.length > 1 && i != val.length-1){
					realvalue += ",";
				}
				continue;
			}else{
				orgExchange = exchangeManager.getExchangeAccount(val[i]);
			}
			if(orgExchange!=null){
				realvalue += "ExchangeAccount|"+val[i];
				if(val.length > 1 && i != val.length-1){
					realvalue += ",";
				}
				continue;
			}
		}
	}
	return realvalue;
}