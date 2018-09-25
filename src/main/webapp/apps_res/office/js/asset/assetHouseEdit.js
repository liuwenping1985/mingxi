$(function() {
    pTemp.assetHouseDiv = $("#assetHouseDiv");
    pTemp.btnDiv = $("#btnDiv");
    pTemp.ok = $("#btnok");
    pTemp.cancel = $("#btncancel");
    pTemp.ajaxM = new assetHouseManager();
    pTemp.selectManager = $("#managertxt");
    pTemp.isModfiy = false;
    fnPageInIt();
    fnSetCss();
});

function fnPageInIt() {
    pTemp.ok.click(fnOK);
    pTemp.cancel.click(fnCancel);
    pTemp.selectManager.click(fnSelect);
}

function fnPageReload(p) {
    var mode = p.mode, row = p.row;
    pTemp.mode = mode;
    if (mode == 'add' || mode == 'modify') {
        pTemp.btnDiv.show();
        pTemp.assetHouseDiv.enable();
    } else {
        pTemp.btnDiv.hide();
        pTemp.assetHouseDiv.disable();
    }
    if(mode == 'modify'){
    	pTemp.isModfiy = true;
    }
    if (mode === 'add') {
    	pTemp.isModfiy = false;
        pTemp.assetHouseDiv.clearform();
        $("input:hidden").each(function() {
            $(this).val("");
        });
        $("#scope")[0].value = "";
        var preVo = pTemp.ajaxM.preNew();
        $("#manager").val(preVo.manager);
	    $("#managertxt").val(preVo.managertxt);
    } else {
        pTemp.assetHouseDiv.fillform(row);
        if (row) {
            $("#scope").comp({
                value : row.scope,
                text : row.scopeName,
                minSize : 0
            });
        }
    }
    pTemp.assetHouseDiv.resetValidate();
}

function fnSetCss() {
    pTemp.btnDiv.hide();
    pTemp.assetHouseDiv.disable();
}

function fnSave(assetHouse) {
    pTemp.ajaxM.save(assetHouse, {
    	success : function(returnVal) {
            $.infor($.i18n('office.stock.house.save.success.js'));
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
    pTemp.assetHouseDiv.resetValidate();
    openProcePub();
    var isAgree = pTemp.assetHouseDiv.validate();
    if (!isAgree) {
        endProcePub();
        return;
    }
    var assetHouse = pTemp.assetHouseDiv.formobj();
    //管理员ID
    var manasgers = $("#manager").val();
    //设备ID
    var assetInfoId = $("#id").val();
    var rval = pTemp.ajaxM.checkHouseManager(manasgers,assetInfoId);
    if(rval!=null && rval=="notAdmin"){
    	$.alert($.i18n('office.assethouse.noadmin.js'));
    	return;
    }else if(rval!=null){
    	$.alert($.i18n('office.assethouse.manager.cannotuse.js'));
    	return;
    }
    pTemp.ajaxM.isUniqName(assetHouse,{
    	success :function(rval){
    		if(rval!=null){
    			$.alert($.i18n('office.assethouse.name.same.js'));
    			endProcePub();
    			return;
    		}else{
    		    fnSave(assetHouse);
    		}
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
 * 选择管理员
 */
function fnSelect(){
	var managerId = $("#manager").val();
	var selectManager = $.dialog({
		id: "selectManager",
		title:$.i18n('office.stock.house.select.manager.js'),
		url :_path+"/office/assetSet.do?method=assetSelectManager",
		width : 300,
		height : 300,
		targetWindow : getCtpTop(),
		transParams :managerId,  //传给子页面
		buttons : [
		    {id : "sure",text : $.i18n('calendar.sure'),isEmphasize:true,
		      handler : function() {
		    	  var rval = selectManager.getReturnValue(); //选择的管理员
		    	  var ids = "";
		    	  var txt = "";
		    	  for(var i=0;i<rval.length;i++){
		    		  if(i==rval.length-1){
		    			  ids = ids + rval[i].id;
		    			  txt = txt + rval[i].name;
		    		  }else{
		    			  ids = ids + rval[i].id + ",";
		    			  txt = txt + rval[i].name + "、";
		    		  }
		    	  }		
		    	  $("#manager").val(ids);					//回填
		    	  $("#managertxt").val(txt); 
		    	  selectManager.close();
		      	}
		      },
		      {id : "cancel",text : $.i18n('calendar.cancel'),
		        handler : function() {selectManager.close();}
		      }]
	});
}
