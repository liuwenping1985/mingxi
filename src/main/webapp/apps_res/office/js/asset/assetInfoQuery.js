var isHide = false;
// js开始处理
$(function() {
    //table
	 pTemp.tab = officeTab().addAll([ "assetNum","assetType","assetName","assetBrand","assetModel","assetDesc","sum","assetHouse","applyUser","applyDept","handleTime","handleUser","state"]).init("assetUseInfo", {
	        argFunc : "fnInitTable",
	        parentId : $('.stadic_layout_body').eq(0).attr('id'),
	        slideToggleBtn : false,// 上下伸缩按钮是否显示
	        resizable : false,// 明细页面的分隔条
	        "managerName" : "assetUseManager",
	        "managerMethod" : "assetInfoQuery"
	 });
	pTemp.layout = $("#layout").layout();
 	pTemp.ajaxAssetInfo = new assetInfoManager();
	pTemp.ajaxAssetHouse = new assetHouseManager();
	fnShowHighLevel();
	//高级查询点击事件
	$("#highQuery").click(fnShowHighLevel);
	fnInitHouse();
	fnInitAssetType();
	//状态切换
	$("#stateTD").click(fnStateChange);
	//导出Excel
	$("#exportUseInfo").click(fnExp);
	//打印
	$("#assetPrint").click(fnPrint);
    pTemp.tab.load();
    fnInitLayoutHeight();
});

/**
 * 导出Excel
 */
function fnExp(){
	var condition = pTemp.contidion;
	$("#exportForm").jsonSubmit({
		paramObj:condition,
		action:_path+"/office/assetUse.do?method=exportAssetUseInfo",
		callback:function(rval){}
	});
}

/**
 * 打印
 */
function fnPrint(){
	var printSubject = "";
	var colBody = fnAssetInfoQue();
	var colBodyFrag = new PrintFragment(printSubject, colBody);
	var cssList = new ArrayList();
	var pl = new ArrayList();
	pl.add(colBodyFrag);
	printList(pl, cssList)
}

/**
 * 获取打印数据
 */
function fnAssetInfoQue(){
    var mxtgrid = $("#assetUseInfo");
    var str = "";
    if(mxtgrid.length > 0 ){
        var tableHeader = jQuery(".hDivBox thead");               
        var tableBody = jQuery(".bDiv tbody");
        var headerHtml =tableHeader.html();
        var bodyHtml = tableBody.html();
        if(headerHtml == null || headerHtml == 'null'){
            headerHtml ="";
        }
        if(bodyHtml == null || bodyHtml=='null'){
            bodyHtml="";
        }
        bodyHtml = bodyHtml.replace(/text_overflow/g,'word_break_all');
        str+="<table class='only_table edit_table font_size12' border='0' cellspacing='0' cellpadding='0'>"
        str+="<thead>";
        str+=headerHtml;
        str+="</thead>";
        str+="<tbody>";
        str+=bodyHtml;
        str+="</tbody>";
        str+="</table>";
    }
    return str;
}
/**
 * 查询
 */
function fnQuery(){
	fnValiDate();
	var obj = $("#assetInfoDiv").formobj();
	//查询条件，给导出Excel时使用
	pTemp.contidion = obj;
	pTemp.tab.load(obj);
}

/**
 *  校验时间的合法性
 */
function fnValiDate(){
	var startDate = $("#startDate").val();
	var endDate = $("#endDate").val();
	if (startDate != null && startDate.trim() != '' && endDate != null && endDate.trim() != '') {
		if (fnParseDatePub(endDate).getTime() < fnParseDatePub(startDate).getTime()) {
			$.alert($.i18n('office.asset.assetInfoQuery.bljssjbnzykssj.js'));
			return;
		}
	}
}
/**
 * 重置
 */
function fnCancel(){
	$("#assetHouseId").val('');
	$("#assetType").val('');
	$("#assetInfoDiv").clearform();
	$("#allAssetInfo").attr("checked","checked");
	$("#applyUser").val('');
	$("#applyDept").val('');
	fnStateChange();
}
/**
 * 设备编辑页面初始化下拉设备库
 */
function fnInitHouse(){
	var assetHouse = pTemp.ajaxAssetHouse.findOfSelf();
	document.getElementById("assetHouseId").innerHTML="";				//因为是静态生成，所以每次调这个方法都应该先清空，否则数据要重复
	$("#assetHouseId").append("<option value=''>--"+$.i18n('office.asset.query.select.js')+"--</option>");
	for(var i = 0 ; i < assetHouse.length ; i ++) {
		var name = assetHouse[i].name;
		$("#assetHouseId").append("<option value='"+assetHouse[i].id+"' title='"+name+"'>"+name.getLimitLength(43,'...')+"</option>");
	}
}

/**
 * 单击查看时，初始化设备分类，不能排除已停用
 */
function fnInitAssetType(){
	var assetType = pTemp.ajaxAssetInfo.findAssetTypeByQuery(-1);
	document.getElementById("assetType").innerHTML="";				//因为是静态生成，所以每次调这个方法都应该先清空，否则数据要重复
	$("#assetType").append("<option value=''>--"+$.i18n('office.asset.query.select.js')+"--</option>");
	for(var i = 0 ; i < assetType.length ; i ++) {
		$("#assetType").append("<option value='"+assetType[i].value+"'>"+assetType[i].text+"</option>");
	}
}

$("#assetHouseId").live('change',function(){
	var houseId = -1;
	var houseIdStr = $(this).val();
	if (houseIdStr != '') {
		houseId = houseIdStr;
	}
	var assetType = pTemp.ajaxAssetInfo.findAssetTypeByQuery(houseId);
	document.getElementById("assetType").innerHTML="";				//因为是静态生成，所以每次调这个方法都应该先清空，否则数据要重复
	$("#assetType").append("<option value=''>--"+$.i18n('office.asset.query.select.js')+"--</option>");
	for(var i = 0 ; i < assetType.length ; i ++) {
		$("#assetType").append("<option value='"+assetType[i].value+"'>"+assetType[i].text+"</option>");
	}
	
})

/**
 * 计算生成layoutNorth的初始化高度
 */
function fnInitLayoutHeight(){
	$("#layout").layout().setNorth($("#assetInfoQuery").height()+95);
	pTemp.tab.reSize();
}

/**
 * 点击高级
 */
function fnShowHighLevel(){
	if(isHide){
		$("#useInfoTR").show();
		$("#processTimeTR").show();
		isHide = false;
	}else{
		$("#useInfoTR").hide();
		$("#processTimeTR").hide();
		isHide = true;
	}
	//展示高级查询之后，再重新设置north区域高度
	fnInitLayoutHeight();
//	//如果选中空闲，要置灰高级查询
//	fnStateChange();
}

/**
 * 状态没选中空闲，则取消高级查询的置灰
 */
function fnStateChange(){
	var freeAssetInfo = $("#freeAssetInfo")[0];
	if(freeAssetInfo.checked){
		$("#applyUser_txt").val("");
		$("#applyDept_txt").val("");
		$("#applyUser").val("");
		$("#applyDept").val("");
		$("#startDate").val("");
		$("#endDate").val("");
		$("#applyUserDIV").disable();
		$("#applyDeptDIV").disable();
		$("#startDate").disable();
		$("#endDate").disable();
		//选择空闲之后，要将高级查询按钮以及条件框都隐藏
		isHide = false;      //这个状态不能少，否则刚进来就点击空闲的话，会将隐藏的展示出来。 因为初始化的时候，将isHide=true了。
		fnShowHighLevel();
		$("#highQueryTD").hide();
	}else{
		$("#applyUserDIV").enable();
		$("#applyDeptDIV").enable();
		$("#startDate").enable();
		$("#endDate").enable();
		isHide = true;
		$("#highQueryTD").show();
	}
}

/**
 * 初始化table
 */
function fnInitTable(){
	return {
		"assetNum" : {
			display : $.i18n('office.assetinfo.num.js'),
			name : 'assetNum',
			width : '10%',
			sortable : false,
			align : 'left'
		},
		"assetType" : {
			display : $.i18n('office.assetinfo.type.js'),
			name : 'assetType',
			width : '7%',
			sortable : true,
			align : 'left'
		},
		"assetName" : {
			display : $.i18n('office.assetinfo.name.js'),
			name : 'assetName',
			width : '6%',
			sortable : true,
			align : 'left'
		},
		"assetBrand" : {
			display :$.i18n('office.assetinfo.brand.js'),
			name : 'assetBrand',
			width : '6%',
			sortable : true,
			align : 'left'
		},
		"assetModel" : {
			display : $.i18n('office.assetinfo.model.js'),
			name : 'assetModel',
			width : '6%',
			sortable : true,
			align : 'left'
		},
		"assetDesc" : {
			display : $.i18n('office.assetinfo.desc.js'),
			name : 'assetDesc',
			width : '10%',
			sortable : true,
			align : 'left'
		},
		"sum" : {
			display : $.i18n('office.asset.query.sum.js'),
			name : 'sum',
			width : '5%',
			sortable : true,
			align : 'left'
		},
		"assetHouse" : {
			display : $.i18n('office.assetinfo.assethouse.js'),
			name : 'assetHouse',
			width : '7%',
			sortable : true,
			align : 'left'
		},
		"applyUser" : {
			display : $.i18n('office.asset.query.user.js'),
			name : 'applyUser',
			width : '7%',
			sortable : true,
			align : 'left'
		},
		"applyDept" : {
			display : $.i18n('office.asset.query.usedep.js'),
			name : 'applyDept',
			width : '8%',
			sortable : true,
			align : 'left'
		},
		"handleTime" : {
		display : $.i18n('office.asset.query.handtime.js'),
		name : 'handleTime',
		width : '10%',
		sortable : true,
		align : 'left'
		},
		"handleUser" : {
		display : $.i18n('office.asset.query.handuser.js'),
		name : 'handleUser',
		width : '8%',
		sortable : true,
		align : 'left'
		},
		"state" : {
			display : $.i18n('office.asset.query.state.js'),
			name : 'state',
			width : '8%',
			sortable : true,
			align : 'left',
			isToggleHideShow : false,
			codecfg:"codeType:'java',codeId:'com.seeyon.apps.office.constants.AssetUsedState'"
		}
	};
}