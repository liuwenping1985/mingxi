
function openPersonCard(_startMemberId) {
	if (openFrom != 'glwd' && openFrom != 'docLib'){
	    openType = getCtpTop();
	  } else {
	    openType = window;
	  }
	$.PeopleCard({
        targetWindow : openType,
        memberId : _startMemberId
    });
}

var dialogDealColl;
function showSummayDialogByURL(url,title) {
  	var width = $(getA8Top().document).width() - 60;
  	var height = $(getA8Top().document).height() - 50;
  	dialogDealColl = $.dialog({
        url: url,
        width: width,
        height: height,
        title: title,
        id:'dialogDealColl',
        transParams:[$('#summary'),$('.slideDownBtn'),$('#listPending')],
        closeParam: {
          'show':true,
          autoClose:false,
          handler:function(){
            if(!dialogDealColl.isWorkflowChange){
              dialogDealColl.close();
            }else{
                var confirm = $.confirm({
                'msg': $.i18n('collaboration.common.isWorkflowChange'),
                ok_fn: function () {
                  dialogDealColl.close();
                  dialogDealColl = null;
                },
                cancel_fn:function(){
                    return;
                }
              });
            }
            var affairId = getMultyWindowId("affairId",url);
            var regex = /^[-]?\d+$/;
            if(regex.test(affairId)){
            	infoDelLock(affairId);
            }
          }

        },
        targetWindow:getCtpTop()
    });
}

function closeInfoDealPage(listType){
	  var fromDialog = true;
	  var dialogTemp= null;
	  try{
	    dialogTemp=window.parentDialogObj['dialogDealColl'];
	  }catch(e){
	    fromDialog = false;
	  }
	  try{
		  if(window.parent) {
			  if(window.parent.$('.slideDownBtn')) {
				  window.parent.$('.slideDownBtn').trigger('click');
			  }
			  if(window.parent.$('#'+listType)) {
				  window.parent.$('#'+listType).ajaxgridLoad();
			  }
		      if(window.parent.$('#listStatistic')) {
		    	  try{window.parent.$('#listStatistic').ajaxgridLoad();}catch(e){}
		      }
		  }
	  }catch(e){// 弹出对话框模式
	      try{
	          if(window.dialogArguments){
	              window.dialogArguments[0].attr('src','');
	              window.dialogArguments[1].trigger('click');
	            //  var obj=new Object();
	             // obj.listType=listType;
	              window.dialogArguments[2].ajaxgridLoad();
	          }
	      }catch(e){}
	  }

	  // 首页更多
	  try{
		//刷新待办栏目更多
		var _win = window.top.opener.$("#main")[0].contentWindow;
		if(_win){
	  		 var url = _win.location.href;
	  		 if ( url.indexOf("morePending") != -1) {
                _win.location =  _win.location;
             }
	  	}
	  	
	    if(window.dialogArguments){
	        if(typeof(window.dialogArguments.callbackOfPendingSection) == 'function'){
	          var iframeSectionId=window.dialogArguments.iframeSectionId;
	            var selectChartId=window.dialogArguments.selectChartId;
	            var dataNameTemp=window.dialogArguments.dataNameTemp;
	            window.dialogArguments.callbackOfPendingSection(iframeSectionId,selectChartId,dataNameTemp);
	            return;
	        }
	        if(typeof(window.dialogArguments.callbackOfEvent) == 'function'){
	          window.dialogArguments.callbackOfEvent();
	          // 协同V5.0 OA-45058 时间线上点击待办协同进行处理，点击提交按钮后，协同页面一直不消失
	          if(dialogTemp!=null&&typeof(dialogTemp)!='undefined'){
	              dialogTemp.close();
	          }
	          return;
	        }
	        if(typeof(window.dialogArguments.callback) == 'function'){
	          window.dialogArguments.callback();
	          // 协同V5.0 OA-45058 时间线上点击待办协同进行处理，点击提交按钮后，协同页面一直不消失
	          if(dialogTemp!=null&&typeof(dialogTemp)!='undefined'){
	              dialogTemp.close();
	          }
	          return;
	        }

	    }
	  }catch(e){
	  }
	  try{
	      if(dialogTemp!=null && typeof(dialogTemp)!='undefined'){
	          if (getCtpTop().main.sectionHandler != undefined){
	              getCtpTop().main.sectionHandler.reload("pendingSection",true);
	          }
	          dialogTemp.close();
	      }
	  }catch(e){}
	  // 不是dialog方式打开的都用window.close
	  if(!fromDialog){
	    // 刷新首页待办栏目
	      try{

	    	//关闭窗口后，刷新工作桌面的待办列表
    		if(window.top.opener && window.top.opener.closed != true && window.top.opener.getCtpTop().refreshDeskTopPendingList){
    			window.top.opener.getCtpTop().refreshDeskTopPendingList();
    		}

	          if(getA8Top().dialogArguments){
	        	  getA8Top().dialogArguments.main.sectionHandler.reload("pendingSection",true);
	          }else{
	            if(getA8Top().opener.main.sectionHandler != null) {
	            	getA8Top().opener.main.sectionHandler.reload("pendingSection",true);
	            } else {
	            	if(typeof(getCtpTop().opener.main.closeAndFresh) == 'function') {
	            		getCtpTop().opener.main.location.reload();
		            }
	            }

	          }
	        //刷新我的提醒栏目
	        try{
  				var _win = window.top.opener.$("#main")[0].contentWindow;
  		    	if (_win != undefined) {
  		    		_win.sectionHandler.reload("collaborationRemindSection",true);
  		    	}
  		    }catch(e){
  		    }
	      }catch(e){
	      }
	      window.close();
	  }
}


var infoDialog;
function openInfoDialog(url,title) {
  	var width = 900;
  	var height = 460;
  	infoDialog = $.dialog({
        url: url,
        width: width,
        height: height,
        title: title,
        id:'infoDialog',
        transParams: window,
        closeParam: {
          'show':true,
          autoClose:false,
          handler:function() {
        	  var retObj = infoDialog.getReturnValue();
          	  if(retObj && retObj.refreshPage == true){
          		//统计列表刷新，特殊处理
          		if(window.parent && window.parent.submitSearch){
          			window.parent.submitSearch(0);
          		}
          		//location.reload();
          	  }
          	  infoDialog.close();
          }
        },
        buttons: [{
            id:"cancelButton",
            text: $.i18n("common.button.cancel.label"),
            handler: function () {
            	var retObj = infoDialog.getReturnValue();
            	if(retObj && retObj.refreshPage == true){
            		//统计列表刷新，特殊处理
            		if(window.parent && window.parent.submitSearch){
            			window.parent.submitSearch(0);
            		}
            		//location.reload();
            	}
            	infoDialog.close();
            }
        }],
        targetWindow:getCtpTop()
    });
}

function loadListStyle() {
	//初始化布局
    new MxtLayout({
        'id': 'layout',
        'northArea': {
            'id': 'north',
            'height': 30,
            'sprit': false,
            'border': false
        },
        'centerArea': {
            'id': 'center',
            'border': false,
            'minHeight': 20
        }
    });
}

function openInfoScoreAutoMaticRecord(infoId) {
	var title = $.i18n('infosend.listInfo.sendCount');//发布次数
	var url = _ctxPath+"/info/publishscore.do?method=listInfoPublishScoreRecord&listType=listInfoPublishScoreRecord&infoId="+infoId;
	openInfoDialog(url, title);
}

function openInfoScoreManualRecord(infoId) {
	var title = $.i18n('infosend.listInfo.sendCount');//发布次数
	var url = _ctxPath+"/info/publishscore.do?method=listInfoPublishScoreRecord&listType=listInfoPublishScoreManualRecord&infoId="+infoId;
	openInfoDialog(url, title);
}

function openInfoStatScoreAutoMaticRecord(infoIds) {
	var title = $.i18n('infosend.listInfo.sendCount');//发布次数
	var url = _ctxPath+"/info/publishscore.do?method=listInfoStatPublishScoreRecord&listType=listInfoStatPublishScoreRecord&infoIds="+infoIds;
	openInfoDialog(url, title);
}

function openInfoStatScoreManualRecord(infoIds) {
	var title = $.i18n('infosend.listInfo.sendCount');//发布次数
	var url = _ctxPath+"/info/publishscore.do?method=listInfoStatPublishScoreRecord&listType=listInfoStatPublishScoreManualRecord&infoIds="+infoIds;
	openInfoDialog(url, title);
}

/**
 * 修改完流程，解除流程同步锁
 */
function infoDelLock(affairId){
  if(typeof(infoLockManager) == 'function'){
      var infoLock = new infoLockManager();
      infoLock.infoDelLock(affairId);
  }
}

/**
 * 判断是否支持Office控件
 * @param bodyType ： 正文类型
 * @param hasAlert :  是否已经提示true，则继续提示
 * @param msg
 * @returns {Boolean}
 */
function hasOffice(bodyType, hasAlert, msg) {
	if(bodyType=='' || bodyType=='10' || bodyType==10) {
		return true;
	}

	var pw = new Object();
	try{
	  if($.browser.msie){
		  	var ocxObj=new ActiveXObject("HandWrite.HandWriteCtrl");
			pw.installDoc= ocxObj.WebApplication(".doc");
			pw.installWps=ocxObj.WebApplication(".wps"); 
	  }else{
		  	pw.installDoc= true;
			pw.installWps=true; 
	  }
		
	}catch(e){
		pw.installDoc=false;
		pw.installWps=false;
	}
	if(pw.installDoc && pw.installWps){
		return true;
	}else if(pw.installWps){
		return true;
	}else if(pw.installDoc){
		return true;
	} else {
		if($("#viewState").length>0) {
			$("#viewState", getMainBodyDataDiv$()).val(0);
		}
		if(!hasAlert) {
			if(msg){
				alert(msg);
			}else{
			    $.i18n("infosend.alert.officeNotAvailable");//Office控件不可用，请使用IE浏览器或重新安装Office控件！
			}
		}
		return false;
	}
}

/**
 * 用于判断切换正文类型，返回值为contentType
 * @return
 */
function getOfficeContentType(){
	var contentType = "41";
	try{
	  if($.browser.msie){
		  	var ocxObj=new ActiveXObject("HandWrite.HandWriteCtrl");
			pw.installDoc= ocxObj.WebApplication(".doc");
			pw.installWps=ocxObj.WebApplication(".wps"); 
	  }else{
		  	pw.installDoc= true;
			pw.installWps=true; 
	  }
	}catch(e){
		pw.installDoc=false;
		pw.installWps=false;
	}
	if(pw.installDoc && pw.installWps){
		contentType = "41";
	}else if(pw.installWps){
		contentType = "43";
	}else if(pw.installDoc){
		contentType = "41";
	}
	return contentType;
}

function getDefaultBodyType() {
	var bodyType = "officeWorld";
	pw = new Object();
	try{
		if($.browser.msie){
		  	var ocxObj=new ActiveXObject("HandWrite.HandWriteCtrl");
			pw.installDoc= ocxObj.WebApplication(".doc");
			pw.installWps=ocxObj.WebApplication(".wps"); 
	  }else{
		  	pw.installDoc= true;
			pw.installWps=true; 
	  }
	}catch(e){
		pw.installDoc=false;
		pw.installWps=false;
	}
	if(pw.installDoc && pw.installWps){
		bodyType = "officeWorld";
	}else if(pw.installWps){
		bodyType = "wpsWorld";
	}else if(pw.installDoc){
		bodyType = "officeWorld";
	}
}

function getDefaultContentType() {
	var pw = new Object();
	try{
		if($.browser.msie){
		  	var ocxObj=new ActiveXObject("HandWrite.HandWriteCtrl");
			pw.installDoc= ocxObj.WebApplication(".doc");
			pw.installWps=ocxObj.WebApplication(".wps"); 
	  }else{
		  	pw.installDoc= true;
			pw.installWps=true; 
	  }
	}catch(e){
		pw.installDoc=false;
		pw.installWps=false;
	}
	if(pw.installDoc && pw.installWps){
		return "41";
	}else if(pw.installWps){
		return "43";
	}else if(pw.installDoc){
		return "41";
	}
	return '41';
}

function getBodyType(contentType) {
	if(contentType == '10') {
		return "HTML";
	} else if(contentType == "41") {
		return "OfficeWord";
	} else if(contentType == "42") {
		return "OfficeExcel";
	} else if(contentType == "43") {
		return "WpsWord";
	} else if(contentType == "44") {
		return "WpsExcel";
	}
}

function getContentType(bodyType) {
	if(bodyType == 'HTML') {
		return '10';
	} else if(bodyType == "OfficeWord") {
		return "41";
	} else if(bodyType == "OfficeExcel") {
		return "42";
	} else if(bodyType == "WpsWord") {
		return "43";
	} else if(contentType == "WpsExcel") {
		return "44";
	}
}


/**
 * 打开老G6期刊发布，信息列表
 * @param magazineId
 * @param title
 */
function openMagazineList(magazineId, title, affairState, win) {
	if(!win){
		win = getCtpTop();
	}

	var dialog = $.dialog({
	      url : _ctxPath+"/info/magazinelist.do?method=magazineInfoList&openFrom=magazineInfoList&magazineId="+magazineId+"&affairState="+affairState,
	      width : 800,
	      height : 400,
	      title :title,//信息详情
	      targetWindow:win,
	      buttons : [{
	          text : $.i18n('collaboration.dialog.close'),
	          handler : function() {
	            dialog.close();
	          }
	      }]
	  });
}