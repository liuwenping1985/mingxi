var layout = null;
var proce = null;

/** 页面加载 */
$(document).ready(function () {
	try{
		//正文加载
		proce = $.progressBar();
	  
		/** 初始化样式相关 */
		initStyle();
		/** 绑定页面控件事件 */
		initBindClickEvent();
		 
		if(hasOffice(getDefaultContentType())) {
			/** 初始化office期刊内部事件 */
			initOfficeCallBackEvent();/** 审批内容框聚焦 **/
			setDealCommentFocus();
		}
		var openFrom = document.getElementById("openFrom");
		if(openFrom && openFrom.value == 'Pending'){
			summaryChange();
		}
		getCtpTop().OfficeObjExt.showExt = showOfficeObjExt;
	}catch(e){
		getCtpTop().OfficeObjExt.showExt = showOfficeObjExt;
	}
});

/**
 * 提供对Dialog弹出窗中含office插件的隐藏问题
 */
getCtpTop().OfficeObjExt.showDialogOffice =function(_tpWin,isChrome){
	var isDialog = false;	  
	if(_tpWin.isOffice && _tpWin.officeObj && _tpWin.officeObj.length>0){
	  for(var i = 0; i<_tpWin.officeObj.length;i++){
		  
		var _temp = _tpWin.officeObj[i]; 
		if(_temp.getAttribute("isDialog") ==false){
			continue;
		}
		isDialog = true;
		if(_temp && _temp.style){
		  _temp.style.visibility = 'visible';
		}
	  }
	}
	
	if(isChrome && isDialog){
	  window.setTimeout(getCtpTop().OfficeObjExt.showExt,1);
	}
}; 
/**
 * 显示office控件的扩展函数
 */
function showOfficeObjExt(){
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

//正文被修改，关闭窗口时弹出提示
function summaryChange(){
	if(!(window.parentDialogObj && window.parentDialogObj['dialogDealColl'])){
		confirmClose();
	}
}

function confirmClose(){
	var mute = arguments.length > 0;
    document.body.onbeforeunload = function(){
      // submit时屏蔽提示
      if(!mute){
        window.event.returnValue = "您修改了正文内容，离开当前页面后将会丢失修改的内容，确认关闭当前页面吗？";
      }
    };
}


/** 页面离开事件 */
window.onbeforeunload = function() {
    removeCtpWindow(affairId,2);
}

/**
 * 如果是期刊审核，设定审核页面加载完成后，意见框聚焦
 */
function setDealCommentFocus(){
	if(openFrom=='Pending'){
		if(window.officeEditorFrame != undefined && officeEditorFrame != null){
			if(officeEditorFrame.page_OcxState == "complete"){//Office文件加载完成
				$('#content_deal_comment').focus();
			}else{
				setTimeout(setDealCommentFocus, "500");
			}
		}else{
			
		}
	}
}

/**
 * 归档回调操作
 */
var pigeonholeCallbackParm = {};
function pigeonholeCallback(result){
    if(result && result != "cancel") {
        result = result.split(",");
        $("#folderId").val(result[0]);
  }
}

/** 绑定页面控件事件 */
function initBindClickEvent() {
	/** 期刊归档 */
	$("#_commonPigeonhole_a").click(function() {
		var result = pigeonhole(32, null, "", true, 0, "pigeonholeCallback");
	});
	/** 常用语 */
	$("#cphrase").bind("click",showPhraseDiv);
}

/** 初始化office期刊内部事件 */
function initOfficeCallBackEvent() {
	if(typeof(officeEditorFrame)!='undefined' && officeEditorFrame != null && officeEditorFrame.openFileCallBack && officeEditorFrame.doLoadFile){
		officeEditorFrame.openFileCallBack(onOpenFileEvent);
	}else {
		setTimeout(initOfficeCallBackEvent, "500");
	}
	if(hasLoadOfficeFrameComplete()){
	    var ocxObj=officeEditorFrame.document.getElementById("WebOffice");
	    if(ocxObj.editType && ocxObj.editType!="0,0" && openFrom=='Pending'){
			var lockWorkflowRe = lockWorkflow(magazineId, _currentUserId, 15);
		    if(lockWorkflowRe[0] == "false"){
		    	ocxObj.editType="0,0";
		      $.alert($.i18n('infosend.magazine.alert.magazineLock', lockWorkflowRe[2]));//用户+lockWorkflowRe[2]+正在对此期刊正文进行操作，暂时不能编辑或提交!
		       return;
		    }
	    }
	}
}
/** 本地文件打开回调 */
function onOpenFileEvent(){
	useLocalFile = "1";//使用了本地文件 标示
}

function confirmAudit(action){
	/*if(action == "passAndNotPublish"){
		var confirm = $.confirm({
		    'msg': $.i18n('infosend.magazine.alert.auditNotPublis'),//通过不发布的期刊将不能再进行任何操作。确定是否继续？
		    ok_fn:function (){doAudit(action);},
			cancel_fn:function(){return false}
		});
	}else {
		doAudit(action);
	}*/
	doAudit(action);
}

var isSubmmiting = false;//标记是否正在提交，防止按钮重复点击提交
function doAudit(action) {
	if(isSubmmiting){
		return;
	}
	isSubmmiting = true;
	 var lockWorkflowRe = checkWorkflowLock(magazineId, _currentUserId,14);
     if(lockWorkflowRe[0] == "false"){
         $.alert(lockWorkflowRe[1]);
         isSubmmiting = false;
         return;
     }
	if($("#comment_deal #folderId").val() != "") {
		var idm = new infoDocManager();
        var aids= [];
        aids.push(affairId);
        var jsonObj = idm.getIsSamePigeonhole(aids, $("#comment_deal #folderId").val());
        if(jsonObj && !confirm(jsonObj)) {
        	isSubmmiting = false;
        	return;
        }
	}
	 var url =_ctxPath+"/info/magazine.do?method=doAudit&action="+action+"&useLocalFile="+useLocalFile;
	 /*var domains =[];
  	 domains.push("dealAreaThisRihgt");
  	 domains.push("comment_deal");
  	 //domains.push("content_workFlow");
  	 domains.push("_currentDiv");
  	 $("#center").jsonSubmit({
         domains : domains,
         action:url,
         debug : false, 
         callback: function(data){
        	 closeCollDealPage("listMagazineAuditPending");
           }
     });*/
	
 	lockWorkflow(magazineId,_currentUserId,15);

  	$.content.getContentDomains(function(domains) {
  		$("#content_deal_attach").html("");
  		saveAttachmentPart("content_deal_attach");
  		$("#comment_deal #content").val($("#content_deal_comment").val());
  		$("#comment_deal #relateInfo").val($.toJSON($("#content_deal_attach").formobj()));
  		domains.push("dealAreaThisRihgt");
  		domains.push("comment_deal");
  		domains.push("content_deal_attach");
		var jsonSubmitCallBack = function() {
            setTimeout(function() {
            	$("#layout").jsonSubmit({
                    domains : domains,
                    debug : false,
                    action:url,
                    callback: function(data) {
                    	closeInfoDealPage("listMagazineAuditPending");
		           	}
                });
			},300);
        }
		jsonSubmitCallBack();
	}, 'saveAs', null, function(){});
}

function showPhraseDiv(){
	showPhrase(curUser);
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


function loadDealAreaShowClick() {
	//右侧 半屏展开
	$( "#deal_area_show").click( function () {
	    $( ".deal_area #hidden_side").trigger( "click" );
	});

	//右侧  收缩	
	$( ".deal_area #hidden_side").click(function() {
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
	
	loadDealClick();
}

/** 初始化样式相关 start *****************************************/
function initPendingStyle() {
	var initWidth=350;
	 if(isDealPageShow == "true") {
		 $(".deal_area").show();
		 $("#deal_area_show").hide();
	 }else{
		 initWidth=38;
		$(".deal_area").hide();
		$("#deal_area_show").show();
	}
	//页面加载 样式初始化
    layout = new MxtLayout({
        'id': 'layout',
        'eastArea': {
            'id': 'east',
            'width': initWidth,
            'sprit': true,
            'minWidth': 350,
            'maxWidth': 500,
            'border': true,
            spiretBar: {
                show: true,
                showItem:"L",
                handlerL: function () {
                   layout.setEast(window.document.body.clientWidth / 2);
                    $(".deal_area").show();
                    $("#deal_area_show").hide();
                },
                handlerR: function () {
                  layout.setEast(348);
                    $(".deal_area").show();
                    $("#deal_area_show").hide();
                }
            }
        },
        'centerArea': {
            'id': 'center',
            'border': true,
            'minHeight': 20
        }
    });
    loadDealAreaShowClick();
}

function initDoneStyle() {
	//页面加载 样式初始化
    layout = new MxtLayout({
        'id': 'layout',
        'centerArea': {
            'id': 'center',
            'border': true,
            'minHeight': 20
        }
    });
    $("#east").hide();
}

 function initStyle() {
	 
	if(openFrom=='Pending') {
		initPendingStyle();
	}  else {
		initDoneStyle();
	}
	
	if ($.browser.msie) {
		 if ($.browser.version < 8) {
		    $( "#iframe_content" ).css("height" , $(".stadic_layout_body" ).height());
		 }
		 if($.browser.version < 8) {
			 setIframeHeight_IE7();
			 $(window).resize(function(){
				 setIframeHeight_IE7();
			 });
		 }
	}
	
	
	
	$("#content_workFlow").css("overflow","auto");
	
	initOfficeStyle();
	
	summaryHeadHeight();

}
 
 function initOfficeStyle() {
	 
	 $("#cc #mainbodyDiv").css("overflow",'visible');
     $("#cc").css({"height":"500px", "margin-bottom":"2px", "width":"100%"});
	 $(".content_text").css("padding-top",'0px').css("padding-left",'5px').css("padding-right",'0px').css("padding-bottom",'0px');
	 $(parent.window.document.getElementById("content_workFlow")).css("visibility","visible");
	 $("#replyContent_sender").hide();
	 $("#currentComment").find("span.li_title").html($.i18n('infosend.label.opinion.handleOpinion', commentCount));//html(处理人意见（共+commentCount+条）);
	 
	 if(window._isViewPage != undefined && _isViewPage == 'true'){//查看页面链接
		 $("#display_content_view,#cc").css("height", "100%");//全屏
		 $("#cc").css("margin-bottom", "0");
		 $("#currentComment").hide();
	 }
	 
	 var totalCount = 15;//最多执行15次，4.5秒
	 
	function setOfficeHeight() {
		if(totalCount > 0){
			
			totalCount--;
			
			setTimeout(function(){ 
				try{
					var docIframe = document.frames["officeTransIframe"].document.frames["htmlFrame"];
					if ($(docIframe).size() > 0) {
						var docIframeHeight = docIframe.document.body.clientHeight;
						$("#cc").css("height",parseInt(docIframeHeight+50)+'px');
						
						//Office转换后的正文，当宽度比外层的iframe宽的时候，设置外层iframe的宽度，避免出现滚动条
			            var docIframeWidth=docIframe.document.body.clientWidth;
			            var tableWidth=$("table",docIframe.document).width();
			 			if(docIframeWidth<tableWidth){
			 				$("#cc").css("width",parseInt(tableWidth+100)+'px');
			 			}
					}
				}catch(e){
					setOfficeHeight(); 
				}
			}, 300);
		}
	}
	setOfficeHeight();
	//正文加载完毕的时候,关闭加载项
	closeProce();
}
 
function closeProce(){
	  if (proce==""){
	      setTimeout(colseProce,300);
	  }else{
	      proce.close();
	  }
}

//将标题部分高度改为动态值
function summaryHeadHeight(){
	//$("#content_workFlow").css("top", $("#summaryHead").height()+10);
	$("#content_workFlow").height($("#center").height()-$("#summaryHead").height()-10);//底部留30空白
}

function closeCollDealPage(listType){
	  var fromDialog = true;
	  var dialogTemp= null;
	  try{
	    dialogTemp=window.parentDialogObj['dialogDealColl'];
	  }catch(e){
	    fromDialog = false;
	  }
	  try{
	      //window.parent.$('.slideDownBtn').trigger('click');
	      window.parent.$('#listPending').ajaxgridLoad();
	      //try{window.parent.$('#listStatistic').ajaxgridLoad();}catch(e){}
	    
	  }catch(e){// 弹出对话框模式
	      try{
	          if(window.dialogArguments){
	              //window.dialogArguments[0].attr('src','');
	              //window.dialogArguments[1].trigger('click');
	              var obj=new Object();
	              obj.listType=listType;
	              window.dialogArguments[2].ajaxgridLoad(obj);
	          }
	        
	      }catch(e){}
	  }
	 
	  // 首页更多
	  try{
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
	          if(getA8Top().dialogArguments){
	          getA8Top().dialogArguments.main.sectionHandler.reload("pendingSection",true);
	          }else{
	            getA8Top().opener.main.sectionHandler.reload("pendingSection",true);
	          }
	      }catch(e){}
	      window.close();
	  }
}
 
function setIframeHeight_IE7(){
    setTimeout(function(){
            $("#content_workFlow").height($("#center").height()-$("#summaryHead").height()-10);
            $("#iframeright").height($("#content_workFlow").height());
            $("#componentDiv").height($("#content_workFlow").height());
    },0);
}

/** 初始化样式相关 end ******************************************/


