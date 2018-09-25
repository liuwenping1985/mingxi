// js开始处理
$(function() {
	pTemp.ajaxM = new autoUseManager();
	pTemp.useTab =  $("#autoUseTab");
	pTemp.editDiv = pTemp.useTab.find("tr[nodePostion*=send]");
	
	pTemp.applyDriverNameInput = $("#applyDriverName");
	pTemp.applyDriverSpan = $("#applyDriverSpan");
	pTemp.applyDriverDiv = $("#applyDriverDiv");
	fnPageInIt();
	fnSetCss();
});

/**
 * 页面初始化
 */
function fnPageInIt() {
	var isSelfDriving = false;
	if (pTemp.jval != '') {
		pTemp.row = $.parseJSON(pTemp.jval);
		pTemp.workFlow = pTemp.row.workFlow;
		//没有勾选自驾
		if (pTemp.row.selfDriving == null || !pTemp.row.selfDriving) {
			pTemp.applyDriverSpan.show();
		} else {
			pTemp.applyDriverSpan.hide();
			isSelfDriving = true;
		}
		
		fnSelfDrivingPub();
		// 加载打开页面数据
		fnPageReload(pTemp.row);
	}
	pTemp.useTab.disable();
	//当前页面为编辑页面
	if(getURLParamPub("isEdit")=='true'){
		pTemp.editDiv.enable();
	}
	
	if(isSelfDriving){
		//勾选自驾，驾驶员置灰色
		pTemp.applyDriverDiv.disable();
		pTemp.applyDriverNameInput.val("");
	}
	
	pTemp.useTab.find("tr[nodePostion=autoOut]").hide();
	//自驾置灰
	$("#applySelf2Msg").disable();
	$("#applyDriverPhoneDiv").disable();
}

/**
 * 页面刷新
 */
function fnPageReload(p) {
	pTemp.useTab.fillform(p);
	// 选人组件回填
	p.applyUser = "Member|"+p.applyUser;
  $("#userDiv").comp({value : p.applyUser,text : p.applyUserName});
  $("#depDiv").comp({value : p.applyDept,text : p.applyDeptName});
  $("#passengerDiv").comp({value : p.passenger,text : p.passengerName});
}

function fnOK(operate) {
	pTemp.editDiv.resetValidate();
	var isAgree = pTemp.editDiv.validate();
	if (!isAgree){
		return;
	}
	
	if(pTemp.row.selfDriving != null && !pTemp.row.selfDriving && pTemp.applyDriverNameInput.val().trim()=='') {
		$.alert($.i18n('office.auto.select.driver.js'));
		return;
	}
	
	var startTime = $("#applyOuttime").val();
	var endTime = $("#applyBacktime").val();
	
	if (startTime >= endTime) {
	  $.alert($.i18n('office.auto.sdate.compare.edate.js'));
	  endProcePub();
	  return;
	}
	
	openProcePub();
	var autoUse = pTemp.editDiv.formobj();
	autoUse.type = "autoSend";
	autoUse.applyId = pTemp.row.id;
	
	pTemp.ajaxM.autoUseManage(autoUse,{
		success : function(rval) {
			endProcePub();
			var msgType = fnSendOutCarMsgPub(rval,pTemp.useTab.formobj());
			var type = msgType.type , msg = msgType.msg;
			
			if (type == 'ok') {
				if(operate=='sendOut'){
					fnAutoDOut();
				}else{
					fnMsgBoxPub(msg, type,function(msbox){
						fnReloadPagePub({page:"autoSend"});
						fnAutoCloseWindow();						
					});
				}
			} else if(type == 'error'){
				fnMsgBoxPub(msg, type,function(msbox){
					fnReloadPagePub({page:"autoSend"});
					fnAutoCloseWindow();
				});
			}else{
				fnMsgBoxPub(msg, type,function(msbox){
					if(msgType.isReload){
						fnReloadPagePub({page:"autoSend"});
						fnAutoCloseWindow();						
					}
				});
			}
		},
    error : function(rval) {
    	endProcePub();
    	var msg = $.i18n('office.auto.apply.send.fail.js'),type = 'error';
    	fnMsgBoxPub(msg,type,function(){
    		fnReloadPagePub({page:"autoSend"});
				fnAutoCloseWindow();
			});
    }
	});
}

/**
 * 直接出车
 */
function fnAutoDOut() {
	var autoUse = {type:"autoDOut",applyId:pTemp.row.id};	
	pTemp.ajaxM.autoUseManage(autoUse, {
		success : function(rval) {			
			var msgType = fnSendOutCarMsgPub(rval,pTemp.useTab.formobj());
			var type = msgType.type , msg = msgType.msg;
			endProcePub();
			
			if (type == 'ok') {
				fnMsgBoxPub(msg, type, function() {
					fnReloadPagePub({page : "autoSend"});
					fnAutoCloseWindow();
				});
			} else if(type == 'error'){
				fnMsgBoxPub(msg, type,function(msbox){
					fnReloadPagePub({page:"autoSend"});
					fnAutoCloseWindow();
				});
			}else{
				fnMsgBoxPub(msg, type);
			}
		}
	});
}

/**
 * 不派车
 */
function fnCancel() {
	var confirm = $.confirm({
    'msg': $.i18n('office.auto.apply.notsend.js'),
    ok_fn: function () {
    	var autoUse = {type:"autoNoneSend",applyId:pTemp.row.id,dispatchOpinion:$("#dispatchOpinion").val()};
    	openProcePub();
    	pTemp.ajaxM.autoUseManage(autoUse,{
    		success : function(rval) {
    			var msg = $.i18n('office.handle.success.js'),type = 'ok';
    			endProcePub();
    			fnReloadPagePub({page : "autoSend"});
    			
    			if(rval.state == "handled"){
    				type = "alert";
    				msg = $.i18n('office.auto.apply.processbyother.js');
    			}
    			
    			if(navigator.userAgent.toLowerCase().indexOf("nt 10.0")!=-1&&navigator.userAgent.toLowerCase().indexOf("trident")!=-1){
		          alert(msg);
		          fnAutoCloseWindow();
    			}else{
    				fnMsgBoxPub(msg, type,function(msbox){
    					fnAutoCloseWindow();
    				});
    			}
    			
    		}
    	});
    }
	});
}

/**
 * 选择驾驶员
 */
function fnSelectPeople(opt){
	fnSelectPeople4Send2OutPub(opt);
}

/**
 * 页面样式控制
 */
function fnSetCss() {
		// var showOpt ={eastWidth:300,sprit:true,maxWidth:500,spiretBarShow:true,border:true};
		var hideOpt ={eastWidth:-2,sprit:false,maxWidth:0,spiretBarShow:false,border:false};
		var opt = hideOpt;
    var layout = new MxtLayout({
        'id' : 'layout',
        'eastArea' : {
            'id' : 'east',
            'width' : opt.eastWidth+2,
            'sprit' : opt.sprit,
            'minWidth' : opt.eastWidth+2,
            'maxWidth' : opt.maxWidth,
            'border' : opt.border,
            spiretBar : {
                show : opt.spiretBarShow,
                handlerL : function() {
                    layout.setEast(opt.eastWidth);
                    $("#deal_area").show();
                    $("#deal_area_show").hide();
                },
                handlerR : function() {
                    layout.setEast(30);
                    $("#deal_area").hide();
                    $("#deal_area_show").show();
                }
            }
        },
        'centerArea' : {
            'id' : 'center',
            'border' : opt.border,
            'minHeight' : 20
        }
    });
    
    var operate = getURLParamPub("operate");
    if(operate == "view"){
    	$("#applyDriverSpan").remove();
    	$("#applyAutoSpan").remove();
    }
}