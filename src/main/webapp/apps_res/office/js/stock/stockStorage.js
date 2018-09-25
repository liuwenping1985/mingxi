$(function() {
    pTemp.stockInfoDiv = $("#stockStorageDiv");
    pTemp.btnDiv = $("#btnDiv");
    pTemp.ok = $("#btnok");
    pTemp.cancel = $("#btncancel");
    pTemp.ajaxM = new stockInfoManager();
    pTemp.selectManager = $("#managertxt");
    fnPageInIt();
    fnSetCss();
});

function fnPageInIt() {
    pTemp.ok.click(fnOK);
    pTemp.cancel.click(fnCancel);
}

function fnPageReload(p) {
    var mode = p.mode, row = p.row;
    pTemp.mode = mode;
    if (mode == 'add' || mode == 'modify') {
        pTemp.btnDiv.show();
        pTemp.stockInfoDiv.enable();
    } else {
        pTemp.btnDiv.hide();
        pTemp.stockInfoDiv.disable();
    }

    if (mode === 'add') {
        pTemp.stockInfoDiv.clearform();
        $("input:hidden").each(function() {
            $(this).val("");
        });
    } else {
        pTemp.stockInfoDiv.fillform(row);
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
}

function fnSave(stockStorage) {
    pTemp.ajaxM.saveStorage(stockStorage, {
        success : function(returnVal) {
        	var infor = $.infor({
        		'type': 0,
        	    'msg': '入库成功！',
        	    ok_fn:storageSuccess
        	});
            endProcePub();
        },
        error : function(rval) {
            endProcePub();
            storageSuccess();
        }
    });
}
function storageSuccess(){
	fnReloadPagePub({page:"stockReg"});
	//关闭所有弹出框
	fnAutoCloseWindow();
}

function fnOK() {
	var storageDate = $("#buyDate").val();
	var _storageDate = storageDate.split("-");
	var d1 = new Date(_storageDate[0],_storageDate[1]-1,_storageDate[2]);
	var d2 = new Date();  
	if(d1>d2){
		alert($.i18n('office.stockstorage.date.check.js'));
		return;
	}
    pTemp.stockInfoDiv.resetValidate();
    openProcePub();
    var isAgree = pTemp.stockInfoDiv.validate();
    if (!isAgree) {
        endProcePub();
        return;
    }
    var stockStorage = pTemp.stockInfoDiv.formobj();
    fnSave(stockStorage);
}

function fnCancel() {
	//关闭所有弹出框
	fnAutoCloseWindow();
}


/**
 * 动态生成用品库
 */
function fninitStockHouses(){
	var stockHouses = pTemp.ajaxM.getAll();
	document.getElementById("stockHouseId").innerHTML="";			//因为是静态生成，所以每次调这个方法都应该先清空，否则数据要重复
	$("#stockHouseId").append("<option></option>");					//用品库默认为空
	if(stockHouses!=null){
		for(var i = 0 ; i < stockHouses.length ; i ++) {
			$("#stockHouseId").append("<option id='"+stockHouses[i]+"' value='"+stockHouses[i].id+"'>"+stockHouses[i].name+"</option>");
		}
	}
}

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
		    			  txt = txt + rval[i].name + ",";
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
