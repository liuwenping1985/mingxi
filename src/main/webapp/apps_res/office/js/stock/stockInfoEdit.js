$(function() {
    pTemp.stockInfoDiv = $("#stockInfoDiv");
    pTemp.btnDiv = $("#btnDiv");
    pTemp.ok = $("#btnok");
    pTemp.cancel = $("#btncancel");
    pTemp.ajaxM = new stockInfoManager();
    pTemp.selectManager = $("#managertxt");
    pTemp.isModfiy= false;
    fnPageInIt();
    fnSetCss();
    fninitStockHouses();
});

function fnPageInIt() {
    pTemp.ok.click(fnOK);
    pTemp.cancel.click(fnCancel);
    pTemp.selectManager.click(fnSelect);
}

function fnPageReload(p) {
    var mode = p.mode, row = p.row;
    var treeTempValue = p.treeTempValue;
    pTemp.mode = mode;
    if (mode == 'add' || mode == 'modify') {
        pTemp.btnDiv.show();
        pTemp.stockInfoDiv.enable();

    	$("#stockCountDiv").disable();
    	$("#stockCount").disable();
    	$("#createDateDiv").disable();
    	$("#createDateTxt").disable();
    	$("#stockPriceDiv").disable();
    	$("#stockPrice").disable();

    } else {
        pTemp.btnDiv.hide();
        pTemp.stockInfoDiv.disable();
    }
    if(mode == 'modify'){
    	pTemp.isModfiy= true;
    }
    if (mode === 'add') {
    	fninitStockHouses();
    	pTemp.isModfiy= false;
        pTemp.stockInfoDiv.clearform();
        //在创建时允许加数量
        $("#stockCountDiv").enable();
	    $("#stockCount").enable();
	    $("#stockPriceDiv").enable();
	    $("#stockPrice").enable();
        $("input:hidden").each(function() {
            $(this).val("");
        });

        var hasVal = true;
        $("#stockType option").each(function (){
            if($(this).val()==treeTempValue){
            	document.getElementById('stockType').value = treeTempValue;
            	hasVal = false;
            }
        });
        if(hasVal&&document.getElementById('stockType').firstElementChild){
        	var firstEleVal = document.getElementById('stockType').firstElementChild.value;
        	document.getElementById('stockType').value = firstEleVal;
        }
    	document.getElementById('state').value = 0;
    	if(document.getElementById('stockHouseId').firstChild){
    		document.getElementById('stockHouseId').firstChild.setAttribute('selected','selected');
    	}
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
  if(pTemp.isFirst){
    pTemp.btnDiv.hide();
    pTemp.stockInfoDiv.disable();
  }
}

function fnSave(stockInfo) {
    pTemp.ajaxM.save(stockInfo, {
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
    pTemp.stockInfoDiv.resetValidate();
    openProcePub();
    var isAgree = pTemp.stockInfoDiv.validate();
    if (!isAgree) {
        endProcePub();
        return;
    }
    
    var hasStockType = document.getElementById("stockType").options;
	if(hasStockType.length==0){
		$.alert($.i18n('office.stock.not.use.stock.type.js'));
        endProcePub();
		return;
	}
    
    var stockInfo = pTemp.stockInfoDiv.formobj();
    pTemp.ajaxM.isUniqName(stockInfo, {
        success : function(returnVal) {
            if (returnVal == true) {
                $.alert($.i18n('office.stock.has.same.by.no.js'));
                endProcePub();
                return;
            }
            fnSave(stockInfo);
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
 * 动态生成用品库
 */
function fninitStockHouses(){
	var stockHouses = pTemp.ajaxM.getAll();
	document.getElementById("stockHouseId").innerHTML="";			//因为是静态生成，所以每次调这个方法都应该先清空，否则数据要重复
	if(stockHouses!=null){
		for(var i = 0 ; i < stockHouses.length ; i ++) {
			var text = stockHouses[i].text;
			$("#stockHouseId").append("<option id='"+stockHouses[i].value+"' value='"+stockHouses[i].value+"' title='"+text+"'>"+text.getLimitLength(49,'...')+"</option>");
		}
	}else{
		$("#stockHouseId").append("<option></option>");					//用品库默认为空
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
