// js开始处理
$(function() {
    //toolbar
	if (pTemp.isCarsAdmin == 'true') {
		pTemp.TBar = officeTBar().addAll(["reg","modify","del"]).init("toolbar");
	} else {
	    pTemp.TBar = officeTBar().addAll(["reg","modify"]).init("toolbar");
	}
    //searchBar
    pTemp.SBar = officeSBar().addAll(["autoNumber","memberId","repairTime","routineMaintenanceFlag"]).init();
    
    pTemp.tab = officeTab().addAll([ "id", "autoInfoNumber","routineStr","repairTime","retrievalTime","repairFee","repairProject","memberName" ]).init("autoRepair", {
        argFunc : "fnAutoIllegalTabItems",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false,// 上下伸缩按钮是否显示
        resizable : false,// 明细页面的分隔条
        "managerName" : "autoRepairManager",
        "managerMethod" : "find"
    });
    pTemp.tab.load();
    pTemp.ajaxM = new autoRepairManager();
});

/**
 * 单击Tab查看
 */
function fnTabClk() {
	var rows = pTemp.tab.selectRows();
	var option = {
		url:"/office/autoMgr.do?method=autoRepairEdit&id=" + rows[0].id,
		showButton:true,
		title:$.i18n('office.auto.repair.view.js')
	}
	fnCheckData(rows, option);
}


/**
 * 双击Tab
 */
function fnTabDBClk() {
	var rows = pTemp.tab.selectRows();
	var option = {
		url:"/office/autoMgr.do?method=autoRepairEdit&id=" + rows[0].id,
		showButton:false,
		title:$.i18n('office.auto.repair.modify.js')
	}
	fnCheckData(rows, option);
}

/**
 * tBar新增
 */
function fnReg() {
	var option = {
		url:"/office/autoMgr.do?method=autoRepairEdit",
		showButton:false,
		title:$.i18n('office.auto.repair.reg.js')
	}
	fnOpenAutoIllegalEdit(option);
}

/**
 * 保存
 */
function fnSave(autoIllegal,dialogObj) {
	pTemp.ajaxM.save(autoIllegal, {
	    success : function(returnVal) {
	    	pTemp.tab.load();
	    	$.infor($.i18n('office.auto.savesuccess.js'));
	    	if (dialogObj) {
	    		dialogObj.close();
	    	}
	    	endProcePub();
	    },
	    error : function (){
	        $.infor($.i18n('office.auto.savefail.js'));
	        endProcePub();
	    }
	});
}

/**
 * 修改
 */
function fnUpdate(autoIllegal,dialogObj){
	pTemp.ajaxM.update(autoIllegal, {
	    success : function(returnVal) {
	    	pTemp.tab.load();
	    	$.infor($.i18n('office.auto.savesuccess.js'));
	    	if (dialogObj) {
	    		dialogObj.close();
	    	}
	    	endProcePub();
	    },
	    error : function (){
	        $.infor($.i18n('office.auto.savefail.js'));
	        endProcePub();
	    }
	});
}
/**
 * tBar修改
 */
function fnModify() {
	var rows = pTemp.tab.selectRows();
	if (rows.length == 0) {
		 $.alert($.i18n('office.auto.select.edit.js'));
		 return;
	} else if (rows.length > 1) {
         $.alert($.i18n('office.auto.onlyone.edit.js'));
         return;
	}
	var rows = pTemp.tab.selectRows();
	var option = {
		url:"/office/autoMgr.do?method=autoRepairEdit&id=" + rows[0].id,
		showButton:false,
		title:$.i18n('office.auto.repair.modify.js')
	}
	fnCheckData(rows, option);
}

/**
 * tBar删除
 */
function fnDel() {
	var rowIds = pTemp.tab.selectRowIds();
	if (rowIds.length == 0) {
		 $.alert($.i18n('office.auto.selectone.delete.js'));
		 return;
	}
	var autoNumberMap = new Properties();
	var autoNumbers = '';
	var rows = pTemp.tab.selectRows();
	for (var i = 0 ; i < rows.length ; i ++) {
		autoNumberMap.put(rows[i].autoInfoId,rows[i].autoInfoNumber);
	}
	var autoNumberValues = autoNumberMap.values();
	for (var i = 0 ; i < autoNumberValues.size();  i ++) {
		autoNumbers = autoNumbers + autoNumberValues.get(i) + ",";
	}
	$.confirm({
	    'msg' : $.i18n('office.auto.delRepair.js', autoNumbers.substr(0,autoNumbers.length -1)),
	    ok_fn : function() {
	    	pTemp.ajaxM.deleteByIds(rowIds, {
	            success : function(returnVal) {
	              pTemp.tab.load();
	              $.infor($.i18n('office.auto.delsuccess.js'));
	            }
	    	});
	    }
	});
}

function fnSBarQuery(sjson) {
	var object = new Object();
	if (sjson.condition == 'repairTime') {
		if (sjson.value.length > 1){
			var startDate = sjson.value[0];
			var endDate = sjson.value[1];
			if (startDate != '') {
				object.retrievalTime_ge = startDate;
			}
			if (endDate != '') {
				object.retrievalTime_le = endDate;
			}
		}
	} else if (sjson.condition == 'autoNumber') {
		object.autoNumber = sjson.value;
	} else if (sjson.condition == 'memberId') {
		object.memberId = sjson.value;
	} else {
		object.repairType = sjson.value;
	}
	pTemp.tab.load(object);
}
/**
 * 列表
 */
function fnAutoIllegalTabItems () {
    return {
        "id" : {
            display : 'id',
            name : 'id',
            width : '5%',
            sortable : false,
            align : 'center',
            type : 'checkbox'
        },
        "routineStr" : {
            display : $.i18n('office.auto.repairType.js'),
            name : 'routineStr',
            width : '10%',
            sortable : true,
            align : 'left'
        },
        "autoInfoNumber" : {
            display : $.i18n('office.auto.num.js'),
            name : 'autoInfoNumber',
            width : '10%',
            sortable : true,
            align : 'left'
        },
        "repairFee" : {
            display : $.i18n('office.auto.cost.js'),
            name : 'repairFee',
            width : '10%',
            sortable : true,
            align : 'left'
        },
        "repairTime" : {
            display : $.i18n('office.auto.repairtime.js'),
            name : 'repairTime',
            width : '15%',
            sortable : true,
            align : 'left'
        },
        "retrievalTime" : {
            display : $.i18n('office.auto.backtime.js'),
            name : 'retrievalTime',
            width : '15%',
            sortable : true,
            align : 'left'
        },
        "repairProject" : {
            display : $.i18n('office.auto.maintanceProject.js'),
            name : 'repairProject',
            width : '24%',
            sortable : true,
            align : 'left'
        },
        "memberName" : {
            display : $.i18n('office.auto.handled.js'),
            name : 'memberName',
            width : '10%',
            sortable : true,
            align : 'left'
        }
    }
}

/**
 * 弹出新建＼修改＼查看页面
 */
function fnOpenAutoIllegalEdit(opt) {
	var windowParam = {
			id : '_office_Illegal_edit',
			url : _path + opt.url,
			targetWindow : getCtpTop(),
			width : 840,
			height : 450,
			title : opt.title,
			transParams : opt.showButton
	};
	windowParam.buttons = [ {
		text : $.i18n('calendar.sure'),
		hide : opt.showButton,
		handler : function() {
			var jsonVal = pTemp._illegalEditDialog.getReturnValue();
			if (jsonVal && jsonVal != null){
				if (jsonVal.id && typeof(jsonVal.id) != 'undefined') {
					fnUpdate(jsonVal,pTemp._illegalEditDialog);
				} else {
					fnSave(jsonVal,pTemp._illegalEditDialog);
				}
			}
		}
	}, {
		text : $.i18n('calendar.cancel'),
		hide : opt.showButton,
		handler : function() {
			if (pTemp._illegalEditDialog) {
				pTemp._illegalEditDialog.close();
			}
		}
	} ];
	pTemp._illegalEditDialog = $.dialog(windowParam);
}

function fnCheckData (rows,option) {
	pTemp.ajaxM.findById(rows[0].id, {
	    success : function(returnVal) {
	      if (returnVal == null) {
	        $.alert("数据已经被删除！");
	        pTemp.tab.load();
	        return;
	      }else{
	          fnOpenAutoIllegalEdit(option);
	      }
	    }
	});
}

