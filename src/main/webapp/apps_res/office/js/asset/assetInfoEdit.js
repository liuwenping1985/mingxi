$(function() {
    pTemp.assetInfoDiv = $("#assetInfoDiv");
    pTemp.btnDiv = $("#btnDiv");
    pTemp.ok = $("#btnok");
    pTemp.cancel = $("#btncancel");
    pTemp.ajaxM = new assetInfoManager();
    pTemp.assetHouse = new assetHouseManager();
    pTemp.isModfiy = false;
    fnPageInIt();
    fnSetCss();
    fnInitHouse();
});

function fnPageInIt() {
    pTemp.ok.click(fnOK);
    pTemp.cancel.click(fnCancel);
}

function fnPageReload(p) {
    var mode = p.mode, row = p.row;
    var selectedTreeId = p.selectedTreeId;
    pTemp.mode = mode;
    if (mode == 'add' || mode == 'modify') {
    	//修改或者新建-初始化设备分类、设备库
    	fnInitAssetTypeWithOut();
    	fnInitHouse();
        pTemp.btnDiv.show();
        pTemp.assetInfoDiv.enable();
    } else {
        pTemp.btnDiv.hide();
        pTemp.assetInfoDiv.disable();
    }
    if(mode == 'modify'){
    	pTemp.isModfiy = true;
    }
    if (mode === 'add') {
    	pTemp.isModfiy = false;
        pTemp.assetInfoDiv.clearform();
        $("input:hidden").each(function() {
            $(this).val("");
        });
        $("#state").val('0');
        //设备库默认选中第一个
        if(document.getElementById('assetHouseId').firstChild){
    		document.getElementById('assetHouseId').firstChild.setAttribute('selected','selected');
    	}
        //设备分类默认选中第一个
        if(document.getElementById('assetType').firstChild){
    		document.getElementById('assetType').firstChild.setAttribute('selected','selected');
    	}
        //登记时，要默认左侧树选中的分类
        if(selectedTreeId!='2621'){
        	$("#assetType").find("option").eq(selectedTreeId).attr("selected","selected")
        }
        //OA-60818
        $("#currentCount").val("1");
    } else {
    	if(mode != 'modify'){	//单击查看
    		fnInitAssetType();
    	}
        pTemp.assetInfoDiv.fillform(row);
        if (row) {
            $("#scope").comp({
                value : row.scope,
                text : row.scopeName,
                minSize : 0
            });
        }
        
    }
}

function fnSetCss() {
    pTemp.btnDiv.hide();
    pTemp.assetInfoDiv.disable();
}

function fnSave(assetInfo) {
    pTemp.ajaxM.save(assetInfo, {
        success : function(returnVal) {
            $.infor($.i18n('office.auto.savesuccess.js'));
            parent.pTemp.tab.load();
            parent.pTemp.tab.reSize('d');
            endProcePub();
        },
        error : function(rval) {
            endProcePub();
        }
    });
}

function fnOK() {
	var hasAssetHouse = document.getElementById("assetHouseId").options;
	if(hasAssetHouse.length == 0){
		$.alert($.i18n('office.assetinfo.nohouse.js'));
		return;
	}
	var hasAssetType = document.getElementById("assetType").options;
	if(hasAssetType.length==0){
		$.alert($.i18n('office.assetinfo.notype.js'));
		return;
	}
	//登记时，校验设备库是否能用
	var curAssetHouse = pTemp.assetHouse.findById($("#assetHouseId").val());
	if(curAssetHouse.state == 1){
		$.alert($.i18n('office.asset.assetInfoEdit.dqsbkybsc.js'));
		return;
	}
	var hasAssetHouse = false;
	var managerStr = curAssetHouse.manager.split(",");
	for(var i=0;i<managerStr.length;i++){
		if(managerStr[i] == $.ctx.CurrentUser.id){
			hasAssetHouse = true;
		}
	}
	if(!hasAssetHouse){
		$.alert($.i18n('office.assetinfo.lostauth.js'));
		return;
	}
	var currentData = new Date();
	var buyDate = $("#buyDate").val().split("-");
	var y = currentData.getFullYear();//年
	var m = currentData.getMonth()+1;//月
	var d = currentData.getDate();//日
	if(buyDate[0]>y){
		$.alert($.i18n('office.assetinfo.buydate.cannot.later.now.js'));
		return;
	}else if(buyDate[0]==y&&buyDate[1]>m){
		$.alert($.i18n('office.assetinfo.buydate.cannot.later.now.js'));
		return;
	}else if(buyDate[0]==y&&buyDate[1]==m&&buyDate[2]>d){
		$.alert($.i18n('office.assetinfo.buydate.cannot.later.now.js'));
		return;
	}
    pTemp.assetInfoDiv.resetValidate();
    openProcePub();
    var isAgree = pTemp.assetInfoDiv.validate();
    if (!isAgree) {
        endProcePub();
        return;
    }
    var assetInfo = pTemp.assetInfoDiv.formobj();
    pTemp.ajaxM.isUniqName(assetInfo, {
        success : function(returnVal) {
            if (returnVal != null) {
                $.alert($.i18n('office.assetinfo.numsame.js'));
                endProcePub();
                return;
            }
            fnSave(assetInfo);
        }
    });
}

function fnCancel() {
	if(pTemp.isModfiy){
		var confirm = $.confirm({
		    'msg': $.i18n('office.book.bookInfoEdit.qrfqdqcz.js'),
		    ok_fn: function () {
		    	parent.pTemp.tab.reSize("d");
		    	},
			cancel_fn:function(){return;}
		});
	}else{
		parent.pTemp.tab.reSize("d");
	}
}


/**
 * 设备编辑页面初始化下拉设备库
 */
function fnInitHouse(){
	var assetHouse = pTemp.ajaxM.getAssetHouse();
	document.getElementById("assetHouseId").innerHTML="";				//因为是静态生成，所以每次调这个方法都应该先清空，否则数据要重复
	for(var i = 0 ; i < assetHouse.length ; i ++) {
		var name = assetHouse[i].name;
		$("#assetHouseId").append("<option value='"+assetHouse[i].id+"' title='"+name+"'>"+name.getLimitLength(49,'...')+"</option>");
	}
}

/**
 * 设备编辑页面初始化下拉设备分类,排除已停用的分类
 */
function fnInitAssetTypeWithOut(){
	var assetType = pTemp.ajaxM.getAssetType();
	document.getElementById("assetType").innerHTML="";				//因为是静态生成，所以每次调这个方法都应该先清空，否则数据要重复
	for(var i = 0 ; i < assetType.length ; i ++) {
		if(assetType[i].state!="0"){
			$("#assetType").append("<option value='"+assetType[i].enumvalue+"'>"+assetType[i].showvalue+"</option>");
		}
	}
}

/**
 * 单击查看时，初始化设备分类，不能排除已停用
 */
function fnInitAssetType(){
	var assetType = pTemp.ajaxM.getAssetType();
	document.getElementById("assetType").innerHTML="";				//因为是静态生成，所以每次调这个方法都应该先清空，否则数据要重复
	for(var i = 0 ; i < assetType.length ; i ++) {
		$("#assetType").append("<option value='"+assetType[i].enumvalue+"'>"+assetType[i].showvalue+"</option>");
	}
}