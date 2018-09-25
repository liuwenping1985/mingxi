$(function() {
    pTemp.stockHouseDiv = $("#stockHouseDiv");
    pTemp.btnDiv = $("#btnDiv");
    pTemp.ok = $("#btnok");
    pTemp.cancel = $("#btncancel");
    pTemp.ajaxM = new stockHouseManager();
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
        pTemp.stockHouseDiv.enable();
    } else {
        pTemp.btnDiv.hide();
        pTemp.stockHouseDiv.disable();
    }
    if(mode == 'modify'){
    	pTemp.isModfiy = true;
    }
    if (mode === 'add') {
    	pTemp.isModfiy = false;
        pTemp.stockHouseDiv.clearform();
        $("input:hidden").each(function() {
            $(this).val("");
        });
        $("#scope")[0].value = "";
        var preVo = pTemp.ajaxM.preNew();
        $("#manager").val(preVo.manager);
	    $("#managertxt").val(preVo.managertxt);
    } else {
        pTemp.stockHouseDiv.fillform(row);
        if (row) {
            $("#scope").comp({
                value : row.scope,
                text : row.scopeName,
                minSize : 0
            });
        }
    }
    pTemp.stockHouseDiv.resetValidate();
}

function fnSetCss() {
  if(pTemp.isFirst){
    pTemp.btnDiv.hide();
    pTemp.stockHouseDiv.disable();
  }
}

function fnSave(stockHouse) {
    pTemp.ajaxM.save(stockHouse, {
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
    pTemp.stockHouseDiv.resetValidate();
    openProcePub();
    var isAgree = pTemp.stockHouseDiv.validate();
    if (!isAgree) {
        endProcePub();
        return;
    }
    var stockHouse = pTemp.stockHouseDiv.formobj();
    pTemp.ajaxM.isUniqName(stockHouse,{
    	success :function(rval){
    		if(rval!=null){
    			$.alert($.i18n('office.stock.house.name.same.js'));
    			endProcePub();
    			return;
    		}else{
    		    fnSave(stockHouse);
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
		url :_path+"/office/stockSet.do?method=stockSelectManager",
		width : 300,
		height : 300,
		targetWindow : getCtpTop(),
		transParams :managerId,  //传给子页面
		buttons : [
		    {id : "sure",text : $.i18n('calendar.sure'),
		    	isEmphasize:true,
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
