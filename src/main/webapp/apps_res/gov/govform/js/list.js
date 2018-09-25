
/****** 页面加载 *****/
$(document).ready(function () {
	loadStyle();
	loadToolbar();
	loadData();
	loadCondition();
	loadSummaryDesc();
});

/****** 列表操作：新建 *****/
function createRow() {
	$('#summary').attr("src", _ctxPath+"/govform/govform.do?method=createForm&formId=&appType="+appType+"&editFlag=true");
	grid.grid.resizeGridUpDown('middle');
}

/****** 列表操作：修改 *****/
function modifyRow() {
	var rows = grid.grid.getSelectRows();
    if(rows.length === 0){
        $.alert($.i18n('govform.info.alert.selectInfoform'));//请选择一条信息报送单！
        return;
    }
    if(rows.length > 1) {
    	$.alert($.i18n('govform.info.alert.selectOneInfoform'));//只能选择一条信息报送单！
    	return;
    }
    var formId = rows[0].id;
	$('#summary').attr("src", _ctxPath+"/govform/govform.do?method=modifyForm&appType="+appType+"&formId="+formId+"&editFlag=true");
	grid.grid.resizeGridUpDown('middle');
}

/****** 列表操作：授权 *****/
function authRow() {
	var rows = grid.grid.getSelectRows();
    if(rows.length === 0){
    	$.alert($.i18n('govform.info.alert.selectInfoform'));//请选择一条信息报送单！
        return;
    }
    var isAuthMyDomain = true;
    var formIds = "";
    var authUnitIds = "";
    var authUnitNames = "";
    var index = 0;
    var systemIndex = 0;
    var systemObj = new Array();
    var otherIndex = 0;
    var otherObj = new Array();
    for(var count = 0 ; count < rows.length; count ++) {
    	if(rows[count].isSystem==true) {
    		systemObj[systemIndex++] = rows[count];
    		continue;
    	}
    	if(rows[count].domainId!=currentUserDomainId) {
    		otherObj[otherIndex++] = rows[count];
    		continue;
    	}
        if(count == rows.length -1) {
        	formIds += rows[count].id;
        }else{
        	formIds += rows[count].id +",";
        }
    }
    if(systemObj.length > 0) {
    	$.alert($.i18n('govform.info.alert.authToOtherUnit'));//系统预置报送单不允许授权给其它单位！
    	for(var i=0; i<systemObj.length; i++) {
    		$("input[type='checkbox'][value='"+systemObj[i].id+"']").attr("checked", false);
    	}
    	return;
    }
    if(otherObj.length > 0) {
    	for(var i=0; i<otherObj.length; i++) {
    		$("input[type='checkbox'][value='"+otherObj[i].id+"']").attr("checked", false);
    	}
    	rows = grid.grid.getSelectRows();
    	if(rows.length === 0) {
            $.alert($.i18n('govform.info.alert.editOtherUtilInfoform'));//不能改变外单位报送单的授权，请重新选择报送单！
            return;
        }
    	isAuthMyDomain = confirm($.i18n('govform.info.alert.authOtherUnit'));//不能改变外单位报送单的授权，是否对本单位制作的报送单继续授权？
    	if(isAuthMyDomain) {
    		formIds = "";
    		for(var count = 0 ; count < rows.length; count ++) {
    	        if(count == rows.length -1) {
    	        	formIds += rows[count].id;
    	        }else{
    	        	formIds += rows[count].id +",";
    	        }
    	    }
    	}
    }
    if(rows.length == 1) {
		authUnitIds = rows[0].authUnitIds;
	}
    if(isAuthMyDomain) {
	    $.selectPeople({
	    	text : $.i18n('common.default.selectPeople.value'),
			value : authUnitIds,
			type : 'selectPeople',
			panels : "Account",
			selectType :  "Account",
			onlyLoginAccount : false,
			isNeedCheckLevelScope:false,
			hiddenPostOfDepartment:true,
			minSize: 0,
			params: {
				value: authUnitIds
			},
			callback : function(ret) {
				var manager = new govformAjaxManager();
			    var obj = new Object();
			    obj.formIds = formIds;
			    obj.authUnitIds = ret.value;
			    var flag = manager.ajaxAuthForm(obj);
			    if(flag == "success") {
			    	window.location.reload();
			    }
			}
	    });
	}
}

/****** 列表操作：置为默认 *****/
function setDefaultRow() {
	var rows = grid.grid.getSelectRows();
    if(rows.length === 0){
    	$.alert($.i18n('govform.info.alert.selectInfoform'));//请选择一条信息报送单！
        return;
    }
    if(rows.length > 1) {
    	$.alert($.i18n('govform.info.alert.selectOneInfoform'));//只能选择一条信息报送单！
    	return;
    }
    if(rows[0].status=="0") {
    	$.alert($.i18n('govform.info.alert.pleaseStart'));//请先将报送单启用！
    	return;
    }
    var formId = rows[0].id;
    var manager = new govformAjaxManager();
    var obj = new Object();
    obj.formId = formId;
    obj.appType = appType;
    obj.type = rows[0].type;
    var flag = manager.ajaxSetDefaultForm(obj);
    if(flag == "success") {
    	window.location.reload();
    }
}

/****** 列表操作：删除 *****/
function deleteRow() {
	var rows = grid.grid.getSelectRows();
    if(rows.length === 0) {
    	$.alert($.i18n('govform.info.alert.selectInfoform'));//请选择一条信息报送单！
        return;
    }
    var formIds = "";
    var systemIndex = 0;
    var systemObj = new Array();
    var otherIndex = 0;
    var otherObj = new Array();
    for(var count = 0 ; count < rows.length; count ++) {
    	if(rows[count].isSystem==true) {
    		systemObj[systemIndex++] = rows[count];
    		continue;
    	}
    	if(rows[count].domainId!=currentUserDomainId) {
    		otherObj[otherIndex++] = rows[count];
    		continue;
    	}
        if(count == rows.length -1){
        	formIds += rows[count].id;
        }else{
        	formIds += rows[count].id +",";
        }
    }
    if(systemObj.length > 0) {
    	$.alert($.i18n('govform.info.alert.delSysInfoform'));//不允许删除系统报送单！
    	for(var i=0; i<systemObj.length; i++) {
    		$("input[type='checkbox'][value='"+systemObj[i].id+"']").attr("checked", false);
    	}
    	return;
    }
    if(otherObj.length > 0) {
    	$.alert($.i18n('govform.info.alert.delOtherUnitInfoform'));//外单位授权的报送单不能删除！
    	for(var i=0; i<otherObj.length; i++) {
    		$("input[type='checkbox'][value='"+otherObj[i].id+"']").attr("checked", false);
    	}
    	return;
    }
    var manager = new govformAjaxManager();
    var obj = new Object();
    obj.formIds = formIds;
    obj.needDelete = "false";
    var flag = manager.ajaxDeleteForm(obj);
    if(flag != "success") {
    	$.alert(flag);
    	return;
    }
    if(confirm($.i18n('govform.info.alert.sureDelInfoform'))) {//确定删除报送单吗？该操作不能恢复
    	manager = new govformAjaxManager();
        obj = new Object();
        obj.formIds = formIds;
        obj.needDelete = "true";
        var flag = manager.ajaxDeleteForm(obj);
        if(flag == "success") {
        	window.location.reload();
        } else {
        	$.alert(flag);
        }
    }
}

/****** 列表操作：启用 *****/
function enableRow() {
	changeRow(1);
}
/****** 列表操作：停用 *****/
function disabledRow() {
	changeRow(0);
}
function changeRow(status) {
	var rows = grid.grid.getSelectRows();
    if(rows.length === 0){
    	$.alert($.i18n('govform.info.alert.selectInfoform'));//请选择一条信息报送单！
        return;
    }
    var systemDisabledFlag = false;
    var formIds = "";
    for(var count = 0 ; count < rows.length; count ++) {
    	if(status == 0) {
    		if(rows[count].isDefault==true) {
    			$("input[type='checkbox'][row='"+count+"']").attr("checked", false);// = false;
    			systemDisabledFlag = true;
    			continue;
    		}
    	}
        formIds += rows[count].id + ",";
    }
    if(formIds != "") {
    	formIds = formIds.substring(0, formIds.length-1);
    }
    if(status == 0) {
    	if(systemDisabledFlag==true) {
			$.alert($.i18n('govform.info.alert.infoformWrongUse'));//报送单使用状态错误,默认报送单不能设置成停用状态！
			return;
		}
    }
    var manager = new govformAjaxManager();
    var obj = new Object();
    obj.formIds = formIds;
    obj.status = status;
    var flag = manager.transAjaxChangeForm(obj);
    if(flag == "success") {
    	window.location.reload();
    }
}

//定义单击事件
function clickRow(data, rowIndex, colIndex) {
    $('#summary').attr("src", _ctxPath+"/govform/govform.do?method=modifyForm&appType="+appType+"&listType="+listType+"&formId="+data.id);
}
//定义单击事件
function dbclickRow(data, rowIndex, colIndex) {
    $('#summary').attr("src", _ctxPath+"/govform/govform.do?method=modifyForm&appType="+appType+"&formId="+data.id+"&editFlag=true");
}
//页面底部说明加载
function loadSummaryDesc() {
	var count = grid.p.total;
	 $('#summary').attr("src", _ctxPath+"/govform/govform.do?method=summaryDesc&listType=listForm&size="+count);
}
//回调函数
function rend(txt, data, r, c) {
	if(c===1){
		txt="<span class='grid_black'>"+txt+"</span>";
	}
	return txt;
}

/****** 页面加载：布局加载 *****/
function loadStyle() {
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
