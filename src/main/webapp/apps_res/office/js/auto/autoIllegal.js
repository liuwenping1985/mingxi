// js开始处理
$(function() {
    //toolbar
	if (pTemp.isCarsAdmin == 'true') {
		pTemp.TBar = officeTBar().addAll(["reg","modify","del"]).init("toolbar");
	} else {
		pTemp.TBar = officeTBar().addAll(["reg","modify"]).init("toolbar");
	}
    //searchBar
    pTemp.SBar = officeSBar().addAll(["autoNumber","driver","illegalDate","illegalFlagStr","dealStateStr"]).init();
    
    pTemp.tab = officeTab().addAll([ "id", "autoInfoNumber","illegalDate","illegalAction","mark","illegalFlagStr","driverMemberName","dealStateStr" ]).init("autoIllegal", {
        argFunc : "fnAutoIllegalTabItems",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false,// 上下伸缩按钮是否显示
        resizable : false,// 明细页面的分隔条
        "managerName" : "autoIllegalManager",
        "managerMethod" : "find"
    });
    pTemp.tab.load();
    pTemp.ajaxM = new autoIllegalManager();
});

/**
 * 单击Tab查看
 */
function fnTabClk() {
	var rows = pTemp.tab.selectRows();
	var option = {
		url:"/office/autoMgr.do?method=autoIllegalEdit&id=" + rows[0].id,
		showButton:true,
		title:$.i18n('office.auto.illegal.view.js')
	}
	fnCheckData(rows,option);
}


/**
 * 双击Tab
 */
function fnTabDBClk() {
	var rows = pTemp.tab.selectRows();
	var option = {
		url:"/office/autoMgr.do?method=autoIllegalEdit&id=" + rows[0].id,
		showButton:false,
		title:$.i18n('office.auto.illegal.mod.js')
	}
	fnCheckData(rows, option);
}

/**
 * tBar新增
 */
function fnReg() {
	var option = {
		url:"/office/autoMgr.do?method=autoIllegalEdit",
		showButton:false,
		title:$.i18n('office.auto.illegal.reg.js')
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
		url:"/office/autoMgr.do?method=autoIllegalEdit&id=" + rows[0].id,
		showButton:false,
		title:$.i18n('office.auto.illegal.mod.js')
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
	    'msg' : $.i18n('office.auto.delIllegal.js', autoNumbers.substr(0,autoNumbers.length -1)),
	    ok_fn : function() {
	    	pTemp.ajaxM.deleteByIds(rowIds, {
	            success : function() {
		            pTemp.tab.load();
		            $.infor($.i18n('office.auto.delsuccess.js'));
	            }
	        });
	    }
	});
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
        "autoInfoNumber" : {
            display : $.i18n('office.auto.num.js'),
            name : 'autoInfoNumber',
            width : '10%',
            sortable : true,
            align : 'left'
        },
        "illegalDate" : {
            display : $.i18n('office.auto.illegal.illegalDate.js'),
            name : 'illegalDate',
            width : '20%',
            sortable : true,
            align : 'left'
        },
        "illegalAction" : {
            display : $.i18n('office.auto.illegal.illegalAction.js'),
            name : 'illegalAction',
            width : '20%',
            sortable : true,
            align : 'left'
        },
        "mark" : {
            display : $.i18n('office.auto.illegal.mark.js'),
            name : 'mark',
            width : '5%',
            sortable : true,
            align : 'left'
        },
        "illegalFlagStr" : {
            display : $.i18n('office.auto.illegal.illegalFlag.js'),
            name : 'illegalFlagStr',
            width : '10%',
            sortable : true,
            align : 'left'
        },
        "driverMemberName" : {
            display : $.i18n('office.auto.driver.js'),
            name : 'driverMemberName',
            width : '15%',
            sortable : true,
            align : 'left'
        },
        "dealStateStr" : {
            display : $.i18n('office.auto.illegal.dealState.js'),
            name : 'dealStateStr',
            width : '14%',
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
			width : 720,
			height : 350,
			title : opt.title,
			transParams : opt.showButton
	};
	windowParam.buttons = [ {
		text : $.i18n('office.auto.ok.js'),
		hide : opt.showButton,
		handler : function() {
			var jsonVal = pTemp._illegalEditDialog.getReturnValue();
			if (jsonVal && jsonVal != null){
				if (jsonVal.id && typeof(jsonVal) != 'undefined') {
					fnUpdate(jsonVal,pTemp._illegalEditDialog);
				} else {
					fnSave(jsonVal,pTemp._illegalEditDialog);
				}
			}
		}
	}, {
		text : $.i18n('office.auto.cancel.js'),
		hide : opt.showButton,
		handler : function() {
			if (pTemp._illegalEditDialog) {
				pTemp._illegalEditDialog.close();
			}
		}
	} ];
	pTemp._illegalEditDialog = $.dialog(windowParam);
}


function fnSBarQuery(sjson) {
	var object = new Object();
	if (sjson.condition == 'illegalDate') {
		if (sjson.value.length > 1){
			var startDate = sjson.value[0];
			var endDate = sjson.value[1];
			if (startDate != '') {
				object.illegalDate_ge = startDate;
			}
			if (endDate != '') {
				object.illegalDate_le = endDate;
			}
		}
	} else if (sjson.condition == 'driver') {
		object.driver = sjson.value;
	} else if (sjson.condition == 'illegalFlagStr') {
		object.illegalFlagStr = sjson.value;
	} else if (sjson.condition == 'autoNumber') {
		object.autoNumber = sjson.value;
	} else {
		object.dealStateStr = sjson.value;
	}
	pTemp.tab.load(object);
}

function fnCheckData (rows,option) {
	pTemp.ajaxM.findById(rows[0].id, {
	    success : function(returnVal) {
	      if (returnVal == null) {
	        $.alert($.i18n('office.auto.data.del.js'));
	        pTemp.tab.load();
	        return;
	      }else{
	          fnOpenAutoIllegalEdit(option);
	      }
	    }
	});
}