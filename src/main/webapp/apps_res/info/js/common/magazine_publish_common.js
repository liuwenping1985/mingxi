
/**弹出发布范围**/
var magazineRangeDialog;
function openMagazinePublishDialog(publishRangeInput) {
	var openFromType = $("#openFromType").val();
	magazineRangeDialog = $.dialog({
        url: _ctxPath+"/info/magazine.do?method=openMagazinePublishDialog&openFromType="+openFromType,
        width: "700",
        height: "500",
       	title: $.i18n('infosend.magazine.label.magazinePublish'),//期刊发布
        id:'magazineRangeDialog',
        transParams: window,
        targetWindow : getCtpTop(),
        closeParam:{
            show:true,
            autoClose:false,
            handler:function() {
            	magazineRangeDialog.close();
            }
        },
        buttons: [{
            id : "okButton",
            text: $.i18n("common.button.ok.label"),
            btnType : 1,//按钮样式
            handler: function () {
        		var values = magazineRangeDialog.getReturnValue();
        		if(values == undefined) {
        			return;
        		}
        		magazineRangeDialog.close();
        		if(openFromType != "4" && openFromType != "0") {//期刊发布需要安装office控件
        			if(!hasOffice("40")) {
        				return;
        			}
        		}
        		if(openFromType == "2") {//直接发布
        			magazinePublishSubmit();
        		} else if(openFromType == "3") {//首页待办直接发布
        			magazinePublishSubmit_portal(publishRangeInput);
            	} else if(openFromType == "4") {//信息统计直接发布
            		infoStatPublishSubmit();
            	} else {
        			if(publishRangeInput) {
        				//给当前控件赋值
                		var rangeNames = "";
                		if($("#publishToViewRangeNames").val() != "") {
                			rangeNames += $("#publishToViewRangeNames").val();
                		}
                		if($("#publishToViewRangeNames").val()!="" && $("#publishToPublicRangeNames").val()!="") {
                			rangeNames += "、";
                		}
                		if($("#publishToPublicRangeNames").val() != "") {
                			rangeNames += $("#publishToPublicRangeNames").val();
                		}
                		publishRangeInput.val(rangeNames);
                		publishRangeInput.attr("title", rangeNames);
        			}
        		}
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


//发布期刊批量套红相关参数
var tempMagazinePublishRanges = "";
var tempMagazinePublishUserName = "";//期刊发布人
var tempMagazinePublishAccount = "";//发布单位
var tempMagazinePublishDept = "";//发布部门
var tempMagazinePublishTime = "";//发布时间
var idsArray = [];
var idsIndex = 0;
var _affterSaveRangeFun = null;
var $magazinePublishIframe = null;

/**
 * 保存发布范围
 */
function saveNextMagazineRange(){

	if(idsArray.length < 1){
		return;
	}
	if(idsIndex == idsArray.length){
		if(_affterSaveRangeFun){
			_affterSaveRangeFun();
		}

		//移除Iframe
		$magazinePublishIframe.remove();

	   	tempMagazinePublishRanges = "";
	   	tempMagazinePublishUserName = "";
	   	idsArray = [];
	   	idsIndex = 0;
	   	_affterSaveRangeFun = null;
	   	$magazinePublishIframe = null;
	}else{
		var tempId = idsArray[idsIndex];
		var url =  _ctxPath + "/info/magazine.do?method=publicMagazineToSaveRange&id=" + tempId;
		if($magazinePublishIframe == null){
			var rand = new Date();
			$magazinePublishIframe = $('<iframe id="magazinePublishIframe'+(rand.getTime())+'" name="magazinePublishIframe'+(rand.getTime())+'" src="" width="0" height="0" style="width:0px;height:0px;overflow:hidden; position: absolute;"></iframe>');
			$("#magazinePublishForm").append($magazinePublishIframe);
		}
		idsIndex +=1;
		$magazinePublishIframe.attr("src", url);
	}
}

function magazinePublishSubmit() {
	tempMagazinePublishRanges = _getPublishRangeNames();
	tempMagazinePublishUserName = $("#publish_user").val();
	tempMagazinePublishAccount = $("#_publish_account").val();
	tempMagazinePublishDept = $("#_publish_dept").val();
	tempMagazinePublishTime = $("#_publish_time").val();

	_affterSaveRangeFun = __doMagazinePublishSubmit;
	//发布前先修改word里面的发布范围

	//发布前先修改word里面的发布范围
	var id_checkbox = grid.grid.getSelectRows();
	if (id_checkbox.length === 0) {
	      return;
	  }else{
	    	for(i=0;i<id_checkbox.length;i++){
	    		var tempId = id_checkbox[i].id;
	    		idsArray.push(tempId);
	    	}
	  }
	saveNextMagazineRange();//发布期刊
}

function __doMagazinePublishSubmit(){
	//期刊发布
	var url =_ctxPath + "/info/magazine.do?method=publishMagazine";
	var domains =[];
   	domains.push("publishMagazineDiv");
   	$("#magazinePublishRange").jsonSubmit({
	    domains : domains,
	    debug : false,
	    action:url,
	    callback: function(data) {
	    	if(data!="") {
	    		$.alert(data);
	    	}
	    	$("#listPending").ajaxgridLoad();
    		cleanPublishData();
	    	//window.location.reload();
        }
    });
}

function cleanPublishData() {
	$("#publishToViewRangeIds").val("");
	$("#publishToViewRangeNames").val("");
	$("#publishToViewRangeNamesOfAll").val("");
	$("#publishToPublicRangeIds").val("");
	$("#publishToPublicRangeNames").val("");
	$("#publishBullentinOrgRangeIds").val("");
	$("#publishBullentinOrgRangeNames").val("");
	$("#publishBullentinUnitRangeIds").val("");
    $("#publishBullentinUnitRangeNames").val("");
}
/**
 * 获取发布范围名称
 * @returns {String}
 */
function _getPublishRangeNames(){
	var ranges = "";
	var range1 = $("#publishToViewRangeNames").val();
	var range2 = $("#publishToPublicRangeNames").val();
	var range3 = $("#publishBullentinOrgRangeNames").val();
	var range4 = $("#publishBullentinUnitRangeNames").val();
	if(range1){
		ranges += range1;
	}
	if(range2){
		if(ranges){
			ranges += "、" + range2;
		}else{
			ranges += range2;
		}
	}
	if(range3){
		if(ranges){
			ranges += "、" + range3;
		}else{
			ranges += range3;
		}
	}
	if(range4){
		if(ranges){
			ranges += "、" + range4;
		}else{
			ranges += range4;
		}
	}
	return ranges;
}

function infoStatPublishSubmit() {
	var url =_ctxPath + "/info/magazine.do?method=publishMagazine";
	var domains =[];
   	domains.push("publishMagazineDiv");
   	dealInfoStatData(domains);
   	$("#magazinePublishRange").jsonSubmit({
	    domains : domains,
	    debug : false,
	    action:url,
	    callback: function(data) {
	    	alert("统计结果发布成功!");
        }
    });
}

function initPublishInfo() {
	//发布到期刊查看
	if(isPublishToView) {
 		$("#bullentinPublishRangeNames0").attr("disabled", true);
 		$("#bullentinPublishRangeNames1").attr("disabled", true);
 		$("#viewCheck").trigger("click");
 		$("#viewPeopleName").val(publishToViewRangeNamesOfAll);
 		$("#viewPeopleId").val(publishToViewRangeIds);
	}
	//发布到公共信息
	if(isPublishToPublic) {
 		$("#publicInfo").attr("checked", true);
 		$("#publicInfo").trigger("click");
 		$("#publicInfo").attr("checked", true);
 		if(publishBullentinOrgRangeIds != "") {
 			$("#bullentinPublishRangeIds0").val(publishBullentinOrgRangeIds);
 			$("#bullentinPublishRangeNames0").val(publishBullentinOrgRangeNames);
 		}
 		if(publishBullentinUnitRangeIds != "") {
 			$("#bullentinPublishRangeIds1").val(publishBullentinUnitRangeIds);
 			$("#bullentinPublishRangeNames1").val(publishBullentinUnitRangeNames);
 		}
	} else {
		$("#publicInfo").attr("checked", false);
 		$("#publicInfo").trigger("click");
 		$("#publicInfo").attr("checked", false);
	}
	if(openFromType == "0") {
		$("#viewPeopleDiv").hide();
		$("#viewPeopleName").val("");
		$("#viewPeopleId").val("");
		$("#viewPublishDiv").hide();
	}
}

function initClick() {
 	//期刊查看：选人框
	$("#viewCheck").click(function() {
		if(openFromType == '0') {
			if($(this).attr("checked")=="checked" && !isLoad && bindPublishRange!=null && bindPublishRange!="") {
	        	var publishRange = bindPublishRange.split(",");
	        	for(var i=0;i<publishRange.length;i++) {
	        		var rangeIds = publishRange[i].split("|");
	        		if(rangeIds.length > 1) {
	        			if(rangeIds[0]=="0" && scoreId!=rangeIds[1]) {
		        			alert($.i18n('infosend.score.alert.repeatBindRange', rangeIds[2], rangeIds[3]));
	        				//alert("其它评分已绑定，不能重复选择！");
		        			$(this).attr("checked", false);
		        			return ;
		        		}
	        		}
	        	}
	        }
		}
 		var checkedPeople=$("#viewPeopleName")[0];
 		if(checkedPeople.disabled==true){
 			checkedPeople.disabled="";
 		}else{
 			checkedPeople.disabled=true;
 		}
 	});
	//期刊查看选项框点击
 	$("#viewPeopleName").click(function() {
 		openPersonDialog($("#viewPeopleId").val(), $("#viewPeopleName"), $("#viewPeopleId"));
 	});
	//公共信息选项框点击
	$("#publicInfo").click(function() {
		var typeValue = $("#tabs_head").find("li.current").find("a").attr("value");
		if($(this).attr("checked")=="checked") {
			//置灰-组织/单位页签
			$("#tabs_head").find("li a").each(function() {
				$(this).attr("disabled", false);
			});
			//隐藏-组织/单位树
			$("#tabs_body").find("span.publish_tree").hide();
			$("#AreaSpan"+typeValue).show();

			//可用-公告范围
			$("#viewPublishDiv").find("div.common_txtbox_wrap").hide();
			$("#bullentinPublishRangeDiv"+typeValue).show();
			$("#viewPublishDiv").find("div.common_txtbox_wrap").find("input").each(function() {
				$(this).attr("disabled", false);
			});
			$(this).attr("checked", true);
		} else {
			//隐藏-组织/单位树
			$("#tabs_body").find("span.publish_tree").hide();
			//置灰-组织/单位页签
			$("#tabs_head").find("li a").each(function() {
				$(this).attr("disabled", true);
			});
			//可用-公告范围
			$("#viewPublishDiv").find("div.common_txtbox_wrap").find("input").each(function() {
				$(this).attr("disabled", true);
			});
			$("#tabs").find("li").each(function() {
				$(this).unbind("click");
			});
			//$("#UnitSectionTree").attr("disabled", "disabled");
		}
	});
	//组织公告发布范围：选人框
 	$("#bullentinPublishRangeNames0").click(function(){
 		openPersonDialog($("#bullentinPublishRangeIds0").val(), $("#bullentinPublishRangeNames0"), $("#bullentinPublishRangeIds0"), false, "Account,Department");
 	});
 	//单位公告发布范围：选人框
 	$("#bullentinPublishRangeNames1").click(function() {
 		openPersonDialog($("#bullentinPublishRangeIds1").val(), $("#bullentinPublishRangeNames1"), $("#bullentinPublishRangeIds1"), true, "Department");
 	});
}

function openPersonDialog(selectMembers, memberNameObj, memberIdObj, showLogin, panelList) {
	if(!showLogin) {
		showLogin = false;
		panelList = "Account,Department";
	}
	$.selectPeople({
		onlyLoginAccount:showLogin,
        type:'selectPeople',
        panels:panelList,
        minSize : 0,
        selectType:'Account,Department',
        text:$.i18n('common.default.selectPeople.value'),
        hiddenPostOfDepartment:true,
        hiddenRoleOfDepartment:true,
        showFlowTypeRadio:false,
        returnValueNeedType: true,
        params:{
           value: selectMembers
        },
        targetWindow:window.top,
        callback : function(res){
            if(res && res.obj) {
            	var selPeopleId = "";
            	var selPeopleName = "";
            	if(res.obj.length>0) {
            		selPeopleId = res.value;
                	selPeopleName = res.text;
            	}
            	if(memberNameObj)
            		memberNameObj.val(selPeopleName);
            	if(memberIdObj)
            		memberIdObj.val(selPeopleId);
            	selectMembers = selPeopleId;
            }
        }
	});
}

function checkVila(id,name){
    /**遍历后台其它单位是否已绑定了发布范围**/
	if(bindPublishRange != null){
		var publishRange=bindPublishRange.split(",");
		for(var i=0;i<publishRange.length;i++){
			if(id==publishRange[i]){
				alert(name+"已经被其它评分标准选择，不能再次绑定！");
				return true;
			}
		}
	}
	return false;
}

function changeCurrentClass(typeValue) {
	$("#tabs_head").find("li").each(function() {
		$(this).removeClass("current");
		if(typeValue == $(this).find("a").attr("value")) {
			$(this).addClass("current");
		}
	});
}

function triggerCurrentClick(typeValue) {
	$("#tabs_head").find("li.current").find("a[value='"+typeValue+"']").trigger("click");
}

function checkPublishType() {
	typeValue = $("#tabs_head").find("li.current").find("a").attr("value");
	$("#viewPublishDiv").find("div.common_txtbox_wrap").hide();
	$("#bullentinPublishRangeDiv"+typeValue).show();
	$("#tabs_body").find("span.publish_tree").hide();
	$("#AreaSpan"+typeValue).show();
	if(typeValue == "0") {
		$("#bullentinPublishTypeLabel").html($.i18n('infosend.magazine.label.orgPublishRange'));//组织公告发布范围：
	} else {
		$("#bullentinPublishTypeLabel").html($.i18n('infosend.magazine.label.unitPublishRange'));//单位公告发布范围：
	}
}

//点击确认
function OK() {
	 publishToViewRangeIds = "";
	 publishToViewRangeNames = "";
	 publishToViewRangeNamesOfAll = "";
	 publishToPublicRangeIds = "";
	 publishToPublicRangeNames = "";
	 publishBullentinOrgRangeIds = "";
	 publishBullentinUnitRangeIds = "";
	 publishBullentinOrgRangeNames = "";
	 publishBullentinUnitRangeNames = "";

	 if($("#viewCheck").attr("checked") == 'checked') {
		 if(openFromType != "0") {
			 if($("#viewPeopleId").val() == "") {
				alert($.i18n('infosend.magazine.alert.selectPeople'));//请选择可查看人员
				return;
			 }
		 }
		 if($("#viewPeopleId").val() != "") {
			 publishToViewRangeIds = $("#viewPeopleId").val();
			 for(var i=0; i<$("#viewPeopleName").val().split("、").length; i++) {
				 publishToViewRangeNamesOfAll += $("#viewPeopleName").val().split("、")[i] + "、";
			 }
			 if(publishToViewRangeNamesOfAll != "") {
				 publishToViewRangeNamesOfAll = publishToViewRangeNamesOfAll.substring(0, publishToViewRangeNamesOfAll.length-1);
			 }
			 publishToViewRangeNames = "[查看页面]";
		 } else {
			 publishToViewRangeIds = "0";
			 publishToViewRangeNames = "[查看页面]";
			 publishToViewRangeNamesOfAll = "[查看页面]";
		 }
	 }
	 if($("#publicInfo").attr("checked") == 'checked') {
		 var orgNodes = $("#OrgSelectedTree").treeObj().getNodes();
		 var unitNodes = $("#UnitSelectedTree").treeObj().getNodes();
		 if(orgNodes=="" && unitNodes==""){
			alert($.i18n('infosend.magazine.alert.selectPublishforum'));//请选择发布版块!
			return;
		 }
		 var hasOrgBullentin = false;
		 var hasUnitBullentin = false;
		 var type;
		 var typeName;
		 //循环取组织公告/新闻版块
		 var maxLenth = 40;
		 var len = 0;
		 for(var i=0; i<orgNodes.length; i++) {
			 var node = orgNodes[i];
			 if(!node) {
				 continue;
			 }
			 var parentObject = node.data;
			 if(parentObject.parentTypeId == 1) {//公告
				 type = 1;
				 typeName = "[组织公告]";
				 hasOrgBullentin = true;
			 } else if(parentObject.parentTypeId == 2) {//新闻
				 type = 2;
				 typeName = "[组织新闻]";
			 }
			 publishToPublicRangeIds += type + "|" + parentObject.id + ",";
			 publishToPublicRangeNames += typeName + "" + node.sectionName + "、";
			 len++;
		 }
		 for(var i=0; i<unitNodes.length; i++) {
			 var node = unitNodes[i];
			 var parentObject = node.data;
			 if(parentObject.parentTypeId == 1) {//公告
				 type = 3;
				 typeName = "[单位公告]";
				 hasUnitBullentin = true;
			 } else if(parentObject.parentTypeId == 2) {//新闻
				 type = 4;
				 typeName = "[单位新闻]";
			 }
			 publishToPublicRangeIds += type + "|" + parentObject.id + ",";
			 publishToPublicRangeNames += typeName + "" + node.sectionName + "、";
			 len++;
		 }
		 if(len > maxLenth) {
			 $.alert('期刊发布范围最多只能选择'+maxLenth+'个.');
			 return;
		 }
		 if(orgNodes!="" && $("#bullentinPublishRangeIds0").val()=="" && hasOrgBullentin && openFromType!="0") {
			alert($.i18n('infosend.magazine.alert.selectOrgPublishRange'));//请选择组织公告发布范围!
			return;
		 }
		 if(unitNodes!="" && $("#bullentinPublishRangeIds1").val()=="" && hasUnitBullentin && openFromType!="0") {
			alert($.i18n('infosend.magazine.alert.selectUnitPublishRange'));//请选择单位公告发布范围!
			return;
		 }
		 if(publishToPublicRangeIds != "") {
			 publishToPublicRangeIds = publishToPublicRangeIds.substring(0, publishToPublicRangeIds.length-1);
		 }
		 if(publishToPublicRangeNames != "") {
			 publishToPublicRangeNames = publishToPublicRangeNames.substring(0, publishToPublicRangeNames.length-1);
		 }
		 publishBullentinOrgRangeIds = $("#bullentinPublishRangeIds0").val();
		 publishBullentinOrgRangeNames = $("#bullentinPublishRangeNames0").val();
		 publishBullentinUnitRangeIds = $("#bullentinPublishRangeIds1").val();
		 publishBullentinUnitRangeNames = $("#bullentinPublishRangeNames1").val();
		 if(!hasOrgBullentin) {
			 $("#bullentinPublishRangeIds0").val("");
			 $("#bullentinPublishRangeNames0").val("");
		 }
		 if(!hasUnitBullentin) {
			 $("#bullentinPublishRangeIds1").val("");
			 $("#bullentinPublishRangeNames1").val("");
		 }
	 }

	 var isFrom = (openFromType==2 || openFromType==3 || openFromType==4);
	 var isNullRanges = ($("#viewCheck").attr("checked") != 'checked' && $("#publicInfo").attr("checked") != 'checked');
	 if(isNullRanges==true && (openFromType==2 || openFromType==3 || openFromType==4)) {
		 $.alert($.i18n('infosend.magazine.alert.selectPublishRange'));
		 return;
	 }
	 
	 parentWindow.$("#publishToViewRangeIds").val(publishToViewRangeIds);
	 parentWindow.$("#publishToViewRangeNames").val(publishToViewRangeNames);
	 parentWindow.$("#publishToViewRangeNamesOfAll").val(publishToViewRangeNamesOfAll);
	 parentWindow.$("#publishToPublicRangeIds").val(publishToPublicRangeIds);
	 parentWindow.$("#publishToPublicRangeNames").val(publishToPublicRangeNames);
	 parentWindow.$("#publishBullentinOrgRangeIds").val(publishBullentinOrgRangeIds);
	 parentWindow.$("#publishBullentinOrgRangeNames").val(publishBullentinOrgRangeNames);
	 parentWindow.$("#publishBullentinUnitRangeIds").val(publishBullentinUnitRangeIds);
	 parentWindow.$("#publishBullentinUnitRangeNames").val(publishBullentinUnitRangeNames);
	 
	 
	 return "";
}


/**********************  首页待办处理 **********************/
var infoDialog_portal;
function openInfoDialog_portal(url,title) {
  	var width = 1200;
  	var height = 460;
  	infoDialog_portal = $.dialog({
        url: _ctxPath + url,
        width: width,
        height: height,
        title: title,
        id:'infoDialog_portal',
        transParams: callbackOfPendingSection,
        closeParam: {
          'show':true,
          autoClose:false,
          handler:function() {
        	  infoDialog_portal.close();
          }
        },
        buttons: [{
            id:"cancelButton",
            text: $.i18n("common.button.cancel.label"),
            handler: function () {
            	infoDialog_portal.close();
            }
        }],
        targetWindow:getCtpTop()
    });
}

function initInfoPublish_portal(openFromType) {
	$("#openFromType").val(openFromType);
}

function magazinePublishSubmit_portal(affairId) {
	$("#publishAffairIds").val(affairId);
	//保存发布范围有问题
    tempMagazinePublishRanges = _getPublishRangeNames();
    tempMagazinePublishUserName = $("#publish_user").val();
    tempMagazinePublishAccount = $("_publish_account").val();
	tempMagazinePublishDept = $("_publish_dept").val();
	tempMagazinePublishTime = $("_publish_time").val();

    _affterSaveRangeFun = __doMagazinePublishSubmit_portal;
	//发布前先修改word里面的发布范围
    if (affairId) {
		var magazineManager = new magazineListManager();
		magazineManager.getMagazineIdByAffairId(affairId, {
			success : function(retMagazineId) {
				if(retMagazineId){
					idsArray.push(retMagazineId);
					saveNextMagazineRange();//发布
				}
			}
		});
	}
}

function __doMagazinePublishSubmit_portal(){
	var url =_ctxPath + "/info/magazine.do?method=publishMagazine";
	var domains =[];
   	domains.push("publishMagazineDiv");
   	$("#magazinePublishForm").jsonSubmit({
	    domains : domains,
	    debug : false,
	    action:url,
	    callback: function(data) {
	    	if(data!="") {
	    		alert(data);
	    	}
    		cleanPublishData();
	    	if(typeof(parent.sectionHandler)!='undefined') {
	    		parent.sectionHandler.reload("pendingSection", true);
	    	} else {
	    		if(window.dialogArguments && window.dialogArguments.closeAndFresh) {
	    			window.dialogArguments.closeAndFresh();
	    		}
	    	}
        }
    });
}

