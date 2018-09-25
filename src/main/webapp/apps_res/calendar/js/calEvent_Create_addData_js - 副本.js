	var dialogCalEventAdd; //新增dialog
	var dialogCalEventUpdate; //修改dialog
	var app_Id;
	//这个是为了关闭窗口，如果用户需要刷新页面，则需要将reloadDate传进入
	function viewDialogClose(id, reloadDate,isList) {
	   if(id=="hasError"){
	        dialogCalEventAdd.enabledBtn("sure");
	   }else{
	       if (id == -1) { //新增窗口
	       		if(app_Id =='19'||app_Id=='20'||app_Id=='21'||app_Id=='4'){
	       			//公文转发事件,reloadDate目前只有公文是等于false,先这样改着
		       		var random = parent.parent.$.messageBox({
						    'type': 100,
						    'msg': "<span class='msgbox_img_0 margin_r_5 left'></span>"+parent.parent.$.i18n('calendar.transmit.ok.label'),
						    close_fn:function(){
						    	dialogCalEventAdd.enabledBtn("sure");
						    },
						    buttons: [{
						    id:'btn1',
						        text: "确定",
						        handler: function () { 
						        	dialogCalEventAdd.close();
									//GOV-1183 不刷新页面
						        	//refreshPage(reloadDate,isList);
						        }
						    }]
						});
				}else{
					dialogCalEventAdd.close();
				}
           } else if (id == "entrust") { //委托窗口
               dialogCalEventEntrust.close();
           } else if (id == "delete") { //删除窗口
               dialogCalEventDelete.close();
           } else { //修改窗口、即查看窗口
               dialogCalEventUpdate.close();
               if (typeof (searchobj) != 'undefined'&&typeof(curButtonClick)=='undefined') {
                    search(searchobj.g.getReturnValue());
               }
           }
           if(app_Id!='19'&&app_Id!='20'&&app_Id!='21'&&app_Id!='4'){
           		//公文刷新特殊处理
	          refreshPage(reloadDate,isList)
           }
	   }
	}
	/**
	*判断页面是否刷新
	*/
	function refreshPage(reloadDate,isList){
       if (reloadDate == 'true'&&(isList==null||isList=="")) {
    	   //OA-85304: IE11，新建事件，保存后列表没显示出来，页面卡死
    	   setTimeout(function(){
    		   window.location = window.location;
    	   }, 100);
//    	   if($.browser.msie&&parseInt($.browser.version,10)>=11){ //ie11下刷新会卡死，不需要参数'true'
//    		   window.location.reload(); 
//    	   }else{
//    		   window.location.reload(true);
//    	   }
       }else if(reloadDate == 'true'){
           search(null);//这个地方是为了解决IE11新建事件，刷新列表时卡死的问题
       }
	}
	//這裡的方法主要的為了協同、计划、关联项目转事件用到的js。
	//beginDate 开始时间
	//formId 协同ID 或者计划ID
	//appID 应用模块ID 也就是说 协同 == 1 计划 == 5
	//endDate 结束时间 （计划转事件用的参数）
	//subject 标题（计划转事件用的参数）
	//signifyType 重要程度 （计划转事件用的参数）这里说明一下，计划转过来的重要程度有可能不止事件本身的几种。如果不满足，则默认为重要紧急
	//receiveMemberId接收人ID
	// dateType 日期类型 1.日期 2 时间
	//isListObj是否是从列表中的新建中进，列表进来的话，新建的话，刷新页面的时候IE11容易卡死
	function AddCalEvent(beginDate,formId,appID,endDate,subject,signifyType,receiveMemberId,dateType,isListObj,urlPath) {
		var url = "";
		var isList="";
		var rootPath;
		var isEdoc = false;
		app_Id=appID;
		try {
  		if(_ctxPath) {
  		  rootPath = _ctxPath;
  		} else {
  		  isEdoc = true;
  		  rootPath = urlPath;
  		}
		} catch (e) {
		  isEdoc = true;
		  rootPath = urlPath;
		}
		if (typeof (beginDate) == 'undefined'||beginDate==null) {
			url = rootPath + '/calendar/calEvent.do?method=createCalEvent';
		} else {
			url = rootPath
					+ '/calendar/calEvent.do?method=createCalEvent&beginDate='
					+ beginDate;
		}
		if (typeof (formId) != 'undefined'&&formId!=null) {
			url = url + "&fromId=" + formId;
		}
		
		if (typeof (appID) != 'undefined'&&appID!=null) {
            url = url + "&appID=" + appID;
        }
		if (typeof (endDate) != 'undefined'&&endDate!=null) {
			url = url + "&endDate=" + endDate;
		}
		
		if (typeof (subject) != 'undefined'&&subject!=null) {
            url = url + "&subject=" + encodeURIComponent(subject);
        }
		if (typeof (signifyType) != 'undefined'&&signifyType!=null) {
			url = url + "&signifyType=" + signifyType;
		}
		if (typeof (receiveMemberId) != 'undefined'&&receiveMemberId!=null) {
			url = url + "&receiveMemberId=" + receiveMemberId;
		}
		if (typeof (dateType) != 'undefined'&&dateType!=null) {
		  url = url + "&dateType=" + dateType;
		}
		if (typeof (isListObj) != 'undefined'&&isListObj!=null) {
	          isList = isListObj.isList;
	        }
		var jqObj = $;
		var ctpTopObj;
		if(isEdoc == true) {
		  jqObj = V5_Edoc().$;
		  ctpTopObj = V5_Edoc().getCtpTop();
		} else {
		  jqObj = $;
		  ctpTopObj = getCtpTop();
		}
		dialogCalEventAdd = jqObj.dialog( {
		    id  : "dialogCalEventAdd",
			url : url,
			width : 600,
			height : 465,
			checkMax : true,
			targetWindow : ctpTopObj,
			transParams : {
				diaClose : viewDialogClose,
				isview : "true",
				isList :isList
			},
			title : jqObj.i18n('calendar.event.view.add'),
			buttons : [ {
				id : "sure",
				isEmphasize:true,
				text : jqObj.i18n('calendar.sure'),
				handler : function() {
					var isFalse = dialogCalEventAdd.getReturnValue();
					if(isFalse){
					  dialogCalEventAdd.disabledBtn("sure");					  
					}
				}
			}, {
				id : "cancel",
				text : jqObj.i18n('calendar.cancel'),
				handler : function() {
					dialogCalEventAdd.close();
				}
			} ]
		});
	}
	//本方法和上面方法功能一样，区别在与增加了一个recordid的参数，但由于该方法在其他多处被引用，且不便于增加参数，因此新建一个同名方法，参数为对象
	function AddCalEventObj(obj) {
		var beginDate = obj.startTime;
		var formId = obj.planId;
		var appID = obj.appId;
		var endDate = obj.endTime;
		var subject = obj.eventDesc;
		var signifyType = obj.importantLevel;
		var receiveMemberId = obj.receiveMemberId;
		var dateType = obj.dateType;
		var recordId = obj.recordId;
		var isList = obj.isList;
		var url = "";
		if (typeof (beginDate) == 'undefined') {
			url = _ctxPath + '/calendar/calEvent.do?method=createCalEvent';
		} else {
			url = _ctxPath
					+ '/calendar/calEvent.do?method=createCalEvent&beginDate='
					+ beginDate;
		}
		if (typeof (formId) != 'undefined') {
			url = url + "&fromId=" + formId;
		}
		
		if (typeof (appID) != 'undefined') {
            url = url + "&appID=" + appID;
        }
		if (typeof (endDate) != 'undefined') {
			url = url + "&endDate=" + endDate;
		}
		
		if (typeof (subject) != 'undefined') {
            url = url + "&subject=" + encodeURIComponent(subject);
        }
		if (typeof (signifyType) != 'undefined') {
			url = url + "&signifyType=" + signifyType;
		}
		if (typeof (receiveMemberId) != 'undefined') {
			url = url + "&receiveMemberId=" + receiveMemberId;
		}
		if (typeof (dateType) != 'undefined') {
		  url = url + "&dateType=" + dateType;
		}
		if (typeof (recordId) != 'undefined') {
			url = url + "&recordid=" + recordId;
		}
		dialogCalEventAdd = $.dialog( {
		    id  : "dialogCalEventAdd",
			url : url,
			width : 600,
			height : 465,
			checkMax : true,
			targetWindow : getCtpTop(),
			transParams : {
				diaClose : viewDialogClose,
				isview : "true",
				isList : isList
			},
			title : $.i18n('calendar.event.view.add'),
			buttons : [ {
				id : "sure",isEmphasize:true,
				text : $.i18n('calendar.sure'),
				handler : function() {
					var isFalse = dialogCalEventAdd.getReturnValue();
					if(isFalse){
					  dialogCalEventAdd.disabledBtn("sure");
					}
				}
			}, {
				id : "cancel",
				text : $.i18n('calendar.cancel'),
				handler : function() {
					dialogCalEventAdd.close();
				}
			} ]
		});
	}