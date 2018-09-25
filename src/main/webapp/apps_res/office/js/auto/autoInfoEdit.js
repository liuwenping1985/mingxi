
$(function() {
	pTemp.autoInfoDiv = $("#autoInfoDiv");
	pTemp.btnDiv = $("#btnDiv");
    pTemp.ok = $("#btnok");
    pTemp.cancel = $("#btncancel");
    pTemp.imgUpload = $("#imgUpload");
    //图片恢复默认
    pTemp.imgCancel = $("#imgCancel");
    pTemp.ajaxM = new autoInfoManager();
    autoDriverMan = new autoDriverManager();
    pTemp.isModfiy = false;
	fnPageInIt();
	fnSetCss();
	fninitCats(); 										//动态生成车辆分类
	initImage();  										//初始车辆图片
}); 

/*
 * 确定、取消事件绑定
 */
function fnPageInIt(){
	//确定、取消按钮绑定事件
	pTemp.ok.click(fnOkLock);
    pTemp.cancel.click(fnCancel);
    pTemp.imgUpload.click(imageUpload)
    pTemp.imgCancel.click(initImage);
}

/**
 * 动态生成车辆分类
 */
function fninitCats(){
	var autoCats = pTemp.ajaxM.findCategoryByCurUser();
	document.getElementById("categoryId").innerHTML="";				//因为是静态生成，所以每次调这个方法都应该先清空，否则数据要重复
	$("#categoryId").append("<option></option>");					//车辆分类默认为空
	if(autoCats != null){
	for(var i = 0 ; i < autoCats.length ; i ++) {
		var text = autoCats[i].name.escapeHTML();
		$("#categoryId").append("<option value='"+autoCats[i].id+"' title='"+text+"'>"+text.getLimitLength(69,"...")+"</option>");
	}
 }
}
/**
 * 页面样式控制
 */
function fnSetCss() {
    pTemp.btnDiv.hide();
    pTemp.autoInfoDiv.disable();
}

/**
 * 刷新载入
 * 
 * @param areaId，刷新页面部分的id
 */
function fnPageReload(p) {
	pTemp.mode = p.mode;
    var mode = p.mode, row = p.row;
    if (mode == 'add' || mode == 'modify') {
        pTemp.btnDiv.show();
        pTemp.autoInfoDiv.enable();
    } else {
        pTemp.btnDiv.hide();
        pTemp.autoInfoDiv.disable();
    }
    
    if (mode === 'add') {
    	pTemp.isModfiy = false;
    	var newAuto =  pTemp.ajaxM.preNew();
    	initImage();											//默认图片
        pTemp.autoInfoDiv.clearform(); 							//清楚表单域内容
        
        //某些浏览器下，枚举没有默认选择，需要设置一下
        $("#state").val("0");									//车辆状态默认为正常
        //车辆类型默认选中第一个
        if(document.getElementById('autoType').firstChild){
    		document.getElementById('autoType').firstChild.setAttribute('selected','selected');
    	}
        $("input:hidden").each(function(){
            $(this).val("");
        });
        $("#autoManager").val(newAuto.autoManager);
        $("#autoManagertxt").val(newAuto.autoManagertxt);
        $("#id").val("-1");
        $("#autoTypeNameDiv").hide();
        $("#autoType").show();
    }else if(mode === 'updates'){              					//如果是批量修改
    	fnOpenUpdates();
    }else{
        pTemp.autoInfoDiv.fillform(row);
        $("#categoryId").val(row.categoryId);					//车辆分类回填
        //车辆类型  
        //单击查看只显示Name
        $("#autoType").hide();
        $("#autoTypeNameDiv").show();
        $("#autoTypeNameDiv").disable();
        //修改，隐藏Name，显示autoType
        if(mode == 'modify'){
        	pTemp.isModfiy = true;
        	$("#autoType").show();
            $("#autoTypeNameDiv").hide();
        	$("#autoTypeNameDiv").enable();
        }
        showImage(); 											//回填图片
    }
}

/**
 * 打开批量修改弹出框
 */
function fnOpenUpdates(){
	var updatesDialog = $.dialog({
		id: 'updates',
	    url: _path+"/office/autoSet.do?method=autoInfoUpdates",
	    width: 400,
	    height: 300,
	    title: $.i18n('office.tbar.updates.js'),
	    targetWindow : getCtpTop(),
	    buttons: [{
	    	id : "sure",
	    	isEmphasize:true,
	    	text : $.i18n('calendar.sure'),
	        handler : function() {
	        	pTemp.rval = updatesDialog.getReturnValue();
	        	if(pTemp.rval.isAgree == "yes"){   //批量修改的校验
		        	fnOK();
		        	updatesDialog.close();
	        	}
	        }
	    }, {
	    	id : "cancel",
	    	text : $.i18n('calendar.cancel'),
	        handler : function() {updatesDialog.close();}
	    }]
	});
}

/**
 * 设置车辆管理员、驾驶员回调函数
 * @returns
 */
function fnSelectPeople(p) {
	var returnObj = p.okParam;
	if (returnObj) {
		if (p.type === "manager") {
			var managerIds = "";
			var managerNames = "";
			for ( var i = 0, j = returnObj.length; i < j; i++) {
				if (i < j - 1) {
					managerIds = managerIds + returnObj[i].id + ","; 		// 组装管理员ID和名字字符串
					managerNames = managerNames + returnObj[i].name+ "、";
				} else if (i == j - 1) {
					managerIds = managerIds + returnObj[i].id;
					managerNames = managerNames + returnObj[i].name;
				}
			}
			$("#autoManager").val(managerIds);
			$("#autoManagertxt").val(managerNames);
		} else if (p.type === "driver") {
			if(returnObj.length==1){ 										//驾驶员不是必选，要判断为空
				var driverId = returnObj[0].id;	
				var driverName = returnObj[0].memberName;
				$("#autoDriver").val(driverId);
				$("#autoDrivertxt").val(driverName);
			}
		}
		p.dialog.close();
	}
}

/**
 * 选择人员
 */
function fnSelect(type){
	var ids = $("#autoDriver").val();
	if(type === 'manager'){
		ids = $("#autoManager").val();
	}
	fnSelectPeoplePub({type:type,value:ids});
}

/**
 * 保存信息
 */
var btOkLock = 3;
function fnOkLock(){
  if(btOkLock==0){
    $("#btnok").removeAttr("disabled"); 
    btOkLock = 3;
  }else{
    $("#btnok").attr("disabled", true);
    btOkLock--;
    if(btOkLock == 2) {
      fnOK();
    }
    setTimeout(function() { 
      fnOkLock();
    },50);
  } 
}

function fnOK(){
	var currentData = new Date();
	var buyDate = $("#buyDate").val().split("-");
	var y = currentData.getFullYear();//年
	var m = currentData.getMonth()+1;//月
	var d = currentData.getDate();//日
	if(buyDate[0]>y){
		$.alert($.i18n('office.auto.buydate.can.not.late.today.js'));
		return;
	}else if(buyDate[0]==y&&buyDate[1]>m){
		$.alert($.i18n('office.auto.buydate.can.not.late.today.js'));
		return;
	}else if(buyDate[0]==y&&buyDate[1]==m&&buyDate[2]>d){
		$.alert($.i18n('office.auto.buydate.can.not.late.today.js'));
		return;
	}
	var driverId = $("#autoDriver").val();//  驾驶员ID
	//保存时，检查驾驶员是否可用
	if(driverId!=null && driverId!=""){
		var driver = autoDriverMan.findById(driverId);
		if(driver != null && driver.state != 0){
			$.alert($.i18n('office.auto.driver.notexit.js'));
			$("#autoDriver").val("");
			$("#autoDrivertxt").val("");
			return;
		}	
	}
	var isValidate = $("#autoInfoDiv").validate();
	if(isValidate){
		var autoNum = $("#autoNum").val();
		var autoId = $("#id").val();
		if(pTemp.mode === 'updates'){
			var ids = parent.pTemp.tab.selectRowIds();
			var idStr = "";
			for(var i=0;i<ids.length;i++){
				if(i<ids.length-1){
					idStr = idStr+ids[i]+",";
				}else{
					idStr = idStr+ids[i];
				}
			}
			var am= pTemp.rval.managerVal;
			var ad = pTemp.rval.driverVal;
			var afConsump = pTemp.rval.aveFuelConsump;
			var aflCost = pTemp.rval.aveFuelCost;
			var aMemo = pTemp.rval.autoMemo;
			if(!(am=="" && ad=="" && afConsump=="" && aflCost=="" && aMemo=="")){
				//批量修改保存
				pTemp.ajaxM.saveUpdates({autoManager:am,
						autoDriver:ad,
						aveFuelConsump:afConsump,
						aveFuelCost:aflCost,
						autoMemo:aMemo,
						ids:idStr},{
							success : function(returnVal){
								if(returnVal==null){
									$.alert($.i18n('office.auto.savefail.js'));
									return;
								}else{
									$.infor($.i18n('office.auto.savesuccess.js'));
									parent.pTemp.tab.reSize('d');
									parent.pTemp.tab.load();
								}
							}
						});
			}
			return;
		}else{
			pTemp.ajaxM.isUniqName(autoNum,autoId,{
		        success : function(returnVal) {
		            if (returnVal != null) {
		                $.alert(returnVal);
		                return;
		            }else{
		        		$("#autoInfoDiv").jsonSubmit({
		    			domains : [ "autoInfoDiv" ],
		    			action:_path+"/office/autoSet.do?method=saveAutoInfo",
		    			callback:function(){
		    				$.infor($.i18n('office.auto.savesuccess.js'));
				        	parent.pTemp.tab.reSize('d');
				        	parent.pTemp.tab.load();  //刷新
		    			}
		    		});
		            }
		        }
		    });
		}
	}
}

/**
*	取消
*/
function fnCancel(){
	if(pTemp.isModfiy){
		var confirm = $.confirm({
		    'msg': $.i18n('office.sure.giveup.operate.js'),
		    ok_fn: function () {
		    	pTemp.autoInfoDiv.clearform();
		    	parent.pTemp.tab.reSize("d");
		    	},
			cancel_fn:function(){return;}
		});
	}else{
		parent.pTemp.tab.reSize("d");
	}
}
/**
 * 初始化默认图片
 */
function initImage() {
	//恢复默认的时候，清除url，避免隐藏数据提交
	$("#autoImage").val("-99");
	var imgStr = "<img src='/seeyon/apps_res/office/images/car.jpg' width='292' height='185'/>";
	$("#imageDiv").get(0).innerHTML = imgStr;
}

/**
 * 上传图片
 */
function imageUpload() {
	  dymcCreateFileUpload("dyncid", "13", "gif,jpg,jpeg,png,bmp", "1", false, 'imageCallback', null, true, true, null, true,false,'5120000');
	  insertAttachment();
}

/**
 * 上传图片回调函数
 * @param id
 */
function imageCallback(id) {
	  //隐藏图片下面的垃圾回收站的图标
	  $("#attachmentArea").hide();
	  var fileUrl = id.get(0).fileUrl;
	  var createDate = id.get(0).createDate || id.get(0).createdate;
	  var url1 = '/fileUpload.do?method=showRTE&fileId=' + fileUrl + '&createDate=' + createDate + '&type=image';
	  var path = _ctxServer;
	  var url = " ";
	  url = url + path + url1;
	  var imgStr = "<img src='" + url + "' width='292' height='185'>";
	  $("#imageDiv").get(0).innerHTML = imgStr; //页面显示图片
	  $("#autoImage").val(fileUrl);//记录图片Url，以备修改时比较,不记录图片ID，是因为上传和回填是，生成ID不一致。
	  $("#autoNum").focus();
}

/**
 * 回填图片
 */
function showImage() {
	var atts = pTemp.ajaxM.getAttachment($("#autoImage").val());
	if(typeof(atts.id) != 'undefined' && atts.id != -1){
		var fileUrl = atts.fileUrl;
		var createDate = atts.createdate;
		var url1 = '/fileUpload.do?method=showRTE&fileId=' + fileUrl + '&createDate=' + createDate + '&type=image';
		var path = _ctxServer;
		var url = " ";
		url = url + path + url1;
		var imgStr = "<img src='" + url + "' width='292' height='185'>";
		$("#imageDiv").get(0).innerHTML = imgStr;
		$("#autoImage").val(fileUrl);//如果修改车辆信息时，没有重新上传图片，根据fileUrl，则不删除附件信息。
	}else{
		initImage();
	}
}

