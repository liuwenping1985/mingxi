// js开始处理
$(function() {
    //toolbar
	if (pTemp.isCarsAdmin == 'true') {
		pTemp.TBar = officeTBar().addAll(["reg","modify","del"]).init("toolbar");
	} else {
		pTemp.TBar = officeTBar().addAll(["reg","modify"]).init("toolbar");
	}
    //searchBar
    pTemp.SBar = officeSBar().addAll(["autoNumber","memberId","insuredDate","expDate","policyNum","insureCompany"]).init();
    
    pTemp.tab = officeTab().addAll([ "id", "autoInfoNumber","policyNum","insuredDate","expDate","insuerTypeStr","insureAmount","memberName" ]).init("autoSafety", {
        argFunc : "fnAutoIllegalTabItems",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false,// 上下伸缩按钮是否显示
        resizable : false,// 明细页面的分隔条
        "managerName" : "autoSafetyManager",
        "managerMethod" : "find"
    });
    pTemp.tab.load();
    pTemp.ajaxM = new autoSafetyManager();
});

/**
 * 单击Tab查看
 */
function fnTabClk() {
	var rows = pTemp.tab.selectRows();
	var option = {
		url:"/office/autoMgr.do?method=autoSafetyEdit&id=" + rows[0].id,
		showButton:true,
		title:$.i18n('office.auto.safety.view.js')
	}
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


/**
 * 双击Tab
 */
function fnTabDBClk() {
	var rows = pTemp.tab.selectRows();
	var option = {
		url:"/office/autoMgr.do?method=autoSafetyEdit&id=" + rows[0].id,
		showButton:false,
		title:$.i18n('office.auto.safety.mod.js')
	}
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

/**
 * tBar新增
 */
function fnReg() {
	var option = {
		url:"/office/autoMgr.do?method=autoSafetyEdit",
		showButton:false,
		title:$.i18n('office.auto.safety.reg.js')
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
		url:"/office/autoMgr.do?method=autoSafetyEdit&id=" + rows[0].id,
		showButton:false,
		title:$.i18n('office.auto.safety.mod.js')
	}
  pTemp.ajaxM.findById(rows[0].id, {
     success : function(returnVal) {
      if (returnVal == null) {
        $.alert($.i18n('office.auto.data.del.js'));
        pTemp.tab.load();
        return;
      } else {
        fnOpenAutoIllegalEdit(option);
      }
    }
  });
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
	    'msg' : $.i18n('office.auto.delSafety.js', autoNumbers.substr(0,autoNumbers.length -1)),
	    ok_fn : function() {
	    	pTemp.ajaxM.deleteByIds(rowIds, {
	            success : function() {
	            	$.infor($.i18n('office.auto.delsuccess.js'));
	                pTemp.tab.load();
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
        "policyNum" : {
            display : $.i18n('office.auto.safety.policyNum.js'),
            name : 'policyNum',
            width : '15%',
            sortable : true,
            align : 'left'
        },
        "insuredDate" : {
            display : $.i18n('office.auto.safety.insuredDate.js'),
            name : 'insuredDate',
            width : '15%',
            sortable : true,
            align : 'left'
        },
        "expDate" : {
            display : $.i18n('office.auto.expDate.js'),
            name : 'expDate',
            width : '15%',
            sortable : true,
            align : 'left'
        },
        "insuerTypeStr" : {
            display : $.i18n('office.auto.safety.insuerType.js'),
            name : 'insuerTypeStr',
            width : '15%',
            sortable : true,
            align : 'left'
        },
        "insureAmount" : {
            display : $.i18n('office.auto.safety.insureAmount.js'),
            name : 'insureAmount',
            width : '14%',
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
			id : '_office_Safety_edit',
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
	if (sjson.condition == 'insuredDate') {
		if (sjson.value.length > 1){
			var startDate = sjson.value[0];
			var endDate = sjson.value[1];
			if (startDate != '') {
				object.insuredDate_ge = startDate;
			}
			if (endDate != '') {
				object.insuredDate_le = endDate;
			}
		}
	} else if (sjson.condition == 'expDate') {
		if (sjson.value.length > 1){
			var startDate = sjson.value[0];
			var endDate = sjson.value[1];
			if (startDate != '') {
				object.expDate_ge = startDate;
			}
			if (endDate != '') {
				object.expDate_le = endDate;
			}
		}
	} else if (sjson.condition == 'memberId') {
		object.memberId = sjson.value;
	} else if (sjson.condition == 'policyNum') {
		object.policyNum = sjson.value;
	} else if (sjson.condition == 'autoNumber') {
		object.autoNumber = sjson.value;
	} else {
		object.insureCompany = sjson.value;
	}
	pTemp.tab.load(object);
}