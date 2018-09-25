$(function() {
    pTemp.stockInfoDiv = $("#stockInfoDiv");
    pTemp.btnDiv = $("#btnDiv");
    pTemp.ok = $("#btnok");
    pTemp.cancel = $("#btncancel");
    pTemp.ajaxM = new stockInfoManager();
    pTemp.selectManager = $("#managertxt");
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
    	document.getElementById('stockCountDiv').disabled = true;
    	document.getElementById('stockCount').disabled = true;
    	document.getElementById('createDateDiv').disabled = true;  
    	document.getElementById('createDate').disabled = true;
    	document.getElementById('stockPriceDiv').disabled = true;
    	document.getElementById('stockPrice').disabled = true;
    } else {
        pTemp.btnDiv.hide();
        pTemp.stockInfoDiv.disable();
    }
    if (mode === 'add') {
        pTemp.stockInfoDiv.clearform();
        $("input:hidden").each(function() {
            $(this).val("");
        });
        if(treeTempValue==2611){
        	document.getElementById('stockType').value = 0;
        }else{
        	document.getElementById('stockType').value = treeTempValue;
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
    pTemp.btnDiv.hide();
    pTemp.stockInfoDiv.disable();
}

function fnSave(stockInfo) {
    pTemp.ajaxM.save(stockInfo, {
        success : function(returnVal) {
            if (pTemp.mode === 'modify') {
                $.infor($.i18n('office.book.bookInfoApply.gxcg.js'));
            } else {
                $.infor($.i18n('office.book.bookInfoEdit.bccg.js'));
            }
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
    var stockInfo = pTemp.stockInfoDiv.formobj();
    pTemp.ajaxM.isUniqName(stockInfo, {
        success : function(returnVal) {
            if (returnVal == true) {
                $.alert($.i18n('office.book.bookInfoApply.czxtypbhqxg.js'));
                endProcePub();
                return;
            }
            fnSave(stockInfo);
        }
    });
}

function fnCancel() {
    parent.pTemp.tab.reSize("d");
}


/**
 * 动态生成用品库
 */
function fninitStockHouses(){
	var stockHouses = pTemp.ajaxM.getAll();
	document.getElementById("stockHouseId").innerHTML="";			//因为是静态生成，所以每次调这个方法都应该先清空，否则数据要重复
	if(stockHouses!=null){
		for(var i = 0 ; i < stockHouses.length ; i ++) {
			$("#stockHouseId").append("<option id='"+stockHouses[i].value+"' value='"+stockHouses[i].value+"'>"+stockHouses[i].text+"</option>");
		}
	}else{
		$("#stockHouseId").append("<option></option>");					//用品库默认为空
	}
	
}

function fnSelect(){
	var managerId = $("#manager").val();
	var selectManager = $.dialog({
		id: "selectManager",
		title:$.i18n('office.book.bookInfoApply.xzgly.js'),
		url :_path+"/office/stockSet.do?method=stockSelectManager",
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
