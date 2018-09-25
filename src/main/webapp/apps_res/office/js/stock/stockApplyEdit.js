// js开始处理
$(function() {
	pTemp.ajaxM = new stockUseManager();
	pTemp.useTab =  $("#stockUseTab");
	pTemp.stockApplyInfo = $("#stockApplyInfo");
	pTemp.editTab = $("#stockApplyEditTab");
	pTemp.layout = $('#layout').layout();
	//初始化数据
	if (pTemp.jval != '') {
		pTemp.row = $.parseJSON(pTemp.jval);
		pTemp.workFlow = pTemp.row.workFlow;
	}
	//table
	pTemp.tab = officeTab().addAll(["stockNum","stockName","stockTypeName","stockModel","stockPrice","stockCount","applyAmount"]);
	var gstate = parseInt(pTemp.row.state);
	var operate = getURLParamPub("operate");
	if((gstate == 5|| gstate == 6 || gstate == 10 || gstate == 20 ) && !(operate == 'add'||operate == 'modify')){
		pTemp.tab.addAll(["grantAmount","grantStateName"]);
	}

	pTemp.tab.addAll(["stockHouseName","stockHouseManagerName","totalPrice"]);
	
	if((operate == 'add'||operate == 'modify')){
		pTemp.tab.addAll(["operat"]);
	}
	
	pTemp.tab.init("stockApplyEditTab", {
		 argFunc : "fnInfo2OtherTabItem",
		 parentId : $('.layout_center').eq(0).attr('id'),
		 slideToggleBtn : false,// 上下伸缩按钮是否显示
		 resizable : false,//明细页面的分隔条
		 usepager: false,
		 render:fnOperatRender,
		 datas:[]
	});
	$('#stockApplyEditTab').width("");
	pTemp.selectStockHref = $("#selectStockHref");
	pTemp.applyTotalDiv = $("#applyTotalDiv");
	pTemp.applyDescTR = pTemp.useTab.find("#applyDescTR");
	pTemp.auditContentTR = pTemp.useTab.find("#auditContentTR");
	pTemp.grantOpinionTR = pTemp.useTab.find("#grantOpinionTR");
	fnPageInIt();
});

/**
 * 页面初始化
 */
function fnPageInIt() {
	//不可编辑
	pTemp.stockApplyInfo.disable();
	pTemp.useTab.disable();
	pTemp.auditContentTR.hide();
	pTemp.grantOpinionTR.hide();
	
	if (pTemp.jval != '') {
		// 加载打开页面数据
		fnPageReload(pTemp.row);
	}
}

/**
 * 页面刷新
 */
function fnPageReload(p) {
	pTemp.row = p;
	pTemp.stockApplyInfo.fillform(p);
	pTemp.useTab.fillform(p);
	//选人组件回填
  $("#userDiv").comp({value : "Member|"+p.applyUser,text : p.applyUserName});
  $("#depDiv").comp({value : "Department|"+p.applyDept,text : p.applyDeptName});
  //表格回填
  pTemp.tab.reLoad({rows:p.rows});
	pTemp.applyTotalDiv.text(p.applyTotal == null ? '' : p.applyTotal);
  //表格编辑数据回填
	if(getURLParamPub("operate") == 'add'|| getURLParamPub("operate") == 'modify'|| 
			(getURLParamPub("operate") == 'grant' && parseInt(p.state) ==5)){
  	var ids=[],applyAmounts = [];
  	for (var i = 0; i < p.rows.length; i++) {
  		if(p.rows[i].grantState != null && parseInt(p.rows[i].grantState) != 0){
  			applyAmounts[i] = p.rows[i].grantAmount;
  		}else{
  			applyAmounts[i] = p.rows[i].applyAmount;
  		}
  		ids[i] = "applyAmount"+ p.rows[i].id;
		}
  	fnFillDataToTab(ids,applyAmounts);
  }
	
	//审核意见显示
	if(p.state >= 1 && p.state != 25){
  	pTemp.auditContentTR.show();
  }
	
  //发放意见显示
  if(p.state >= 5 && p.state != 25 && p.state !=15){
  	pTemp.grantOpinionTR.show();
  }
  
  if(pTemp.row.admin && getURLParamPub("operate") == 'grant' && parseInt(p.state) ==5 ){
  	pTemp.grantOpinionTR.enable();
  }
  
  //描述
  if((getURLParamPub("operate") == 'add'|| getURLParamPub("operate") == 'modify')){
  	pTemp.applyDescTR.enable();//申请描述
  	pTemp.selectStockHref.enable();//选择用品
  	pTemp.selectStockHref.click(fnSelectStock);
  }else{
  	pTemp.selectStockHref.disable();//选择用品
  	pTemp.selectStockHref.unbind("click");
  }
}


/**
 * 打开选择用品
 */
function fnSelectStock() {
	var rows = pTemp.tab.datas().rows;
	var wParam = {houseId:-1};
	if (rows.length > 0) {
		wParam = {houseId:rows[0].houseId,stockHouseName:rows[0].stockHouseName}
	}
	openSelectStockWinPub(wParam);
}

/**
 * 选择用品确定回调函数
 */
function fnSelectStockOK(p){
	if(p.okParam.error){
		$.alert(p.okParam.msg);
		return;
	}
	
	var rows = p.okParam.rows;
	if(rows.length == 0){
		$.alert($.i18n('office.stock.select.please.js'));
		return;
	}
	
	var stockIds = [];
	//缓存已填数据
	var ids = [],filldata = [],totalPriceData = [];
	var amountInputs = pTemp.editTab.find("input[id^=applyAmount]");
	var totalPriceDivs = pTemp.editTab.find("div[id^=totalPrice]");
	for ( var i = 0; i < amountInputs.length; i++) {
		ids[i] = $(amountInputs[i]).attr("id");
		if (amountInputs[i].value) {
			filldata[i] = amountInputs[i].value;
			totalPriceData[i] = $(totalPriceDivs[i]).text();
		} else {
			filldata[i] = '';
		}
	}
	
	var tabRows = pTemp.tab.datas().rows;
	for ( var i = 0; i < tabRows.length; i++) {
		stockIds.push(tabRows[i].id);
	}
	
	for ( var i = 0; i < rows.length; i++) {
		if (!stockIds.contains(rows[i].id)) {
			rows[i].stockHouseName = revertHtmlEnc(rows[i].stockHouseName);
			tabRows.push(rows[i]);
		}
	}
	
	pTemp.tab.reLoad({"rows":tabRows});
	
	fnFillDataToTab(ids,filldata,totalPriceData);
	
	p.dialog.close();
	//样式处理OA-76762
  if (v3x.isMSIE9||v3x.isMSIE8||v3x.isMSIE7) {
     $("input[id^=applyAmount]").css('padding','1px');
  }
	
}

function revertHtmlEnc(s){
  if (!s){
      return s;
  }  
  var str = s.replace(/&amp;/gi, '&');
  str = str.replace(/&lt;/gi, '<');
  str = str.replace(/&gt;/gi, '>');
  str = str.replace(/&quot;/gi, '\"');
  str = str.replace(/&nbsp;/gi, ' ');
  str = str.replace(/&#039;/gi, '\'');
  str = str.replace(/<br( )?(\/)?>/gi, '\n');
  return str;
}

/**
 * 向tab表回填输入数据
 */
function fnFillDataToTab(ids,applyAmounts,totalPrices){
	var amountInputs = pTemp.editTab.find("input[id^=applyAmount]");
	var totalPriceDivs = pTemp.editTab.find("div[id^=totalPrice]");
	// 回填已填数据
	for ( var i = 0; i < amountInputs.length; i++) {
		var id = $(amountInputs[i]).attr("id");
		var index = ids.indexOf(id);
		if(index!=-1){			
			if(applyAmounts[index] != null){
				amountInputs[i].value = applyAmounts[index];
			}
			
			if (totalPrices && totalPrices[index]) {
				$(totalPriceDivs[i]).text(totalPrices[index]);
			}
		}
	}
	//回填总价
	fnApplyPriceCount(null);
}

/**
 * 选择用品确定取消回调函数
 */
function fnSelectStockCancel(p){
	p.dialog.close();
}

/**
 * 申请，发放，不发放均调用此方法
 * @param operate:apply/grant/notGrant
 */
function fnOK(operate) {
	//校验每行为空，大于库存
	var reg =/^[0-9]{1,9}$/;
	var amountInputs = pTemp.editTab.find("input[id^=applyAmount]");
	var rows = pTemp.tab.datas().rows;
	var infoIds = [];
	var infoAmounts = [];
	
	pTemp.useTab.resetValidate();	
	var isAgree = pTemp.useTab.validate();
	if (!isAgree){
		return {isAgree:false};
	}
	
	if(operate != "notGrant"){
		if(amountInputs.length == 0){
			$.alert($.i18n('office.stock.select.please.js'));
			return;
		}
		
		var zeroCount = 0;
		for ( var i = 0; i < amountInputs.length; i++) {
			var amount = amountInputs[i].value;
			var row = rows[i];
			if(!reg.test(amount)){
				if(parseInt(pTemp.row.state) == 5){//发放环节
					$.alert($.i18n('office.stock.grant.num.not.null.js'));
				}else{
					$.alert($.i18n('office.stock.apply.num.not.null.js'));
				}
				return;
			}
			
			if($.isNumeric(amount) && $.isNumeric(row.stockCount)){//在申请状态
				if(parseInt(amount) == 0){
					zeroCount++;
				}
			}
			
			if(zeroCount >0 && parseInt(pTemp.row.state) != 5){
					$.alert($.i18n('office.stock.apply.num.not0.js'));
					return;
			}
			
			infoIds[i] = row.id;
			infoAmounts[i] = amount;
		}
		
		//发放环节，点击发放时，提示
		if(zeroCount == amountInputs.length && parseInt(pTemp.row.state) == 5){
			var confirm = $.confirm({
		    'msg': $.i18n('office.stock.grant.num.not0.js'),
		    ok_fn: function () {
		    	fnSubmit(operate);
		    },
		    cancel_fn:function(){
		    	endProcePub();
		    }
			});
		}else{
			fnSubmit(operate);
		}
	}else{
		fnSubmit(operate);
	}
}


function fnSubmit(operate){
	//校验每行为空，大于库存
	var reg =/^[0-9]{1,9}$/;
	var amountInputs = pTemp.editTab.find("input[id^=applyAmount]");
	var rows = pTemp.tab.datas().rows;
	var infoIds = [],infoNames= [];
	var infoAmounts = [];
	
	pTemp.useTab.resetValidate();	
	
	var isAgree = pTemp.useTab.validate();
	if (!isAgree){
		return {isAgree:false};
	}
	
	if(operate != "notGrant"){
		if(amountInputs.length == 0){
			$.alert($.i18n('office.stock.select.please.js'));
			return;
		}
		
		for ( var i = 0; i < amountInputs.length; i++) {
			var amount = amountInputs[i].value;
			var row = rows[i];
			if(!reg.test(amount)){
				if(parseInt(pTemp.row.state) == 5){//发放环节
					$.alert($.i18n('office.stock.grant.num.not.null.js'));
				}else{
					$.alert($.i18n('office.stock.apply.num.not.null.js'));
				}
				return;
			}
			
			if($.isNumeric(amount) && $.isNumeric(row.stockCount) && parseInt(pTemp.row.state) != 5){//在申请状态
				if(parseInt(amount) == 0){
					$.alert($.i18n('office.stock.apply.num.not0.js'));
					return;
				}
			}
			
			infoNames[i] = row.stockName;
			infoAmounts[i] = amount;
		}
	}
	
	for (var i = 0; i < amountInputs.length; i++) {
		var row = rows[i];
		infoIds[i] = row.id;
	}
	
	openProcePub();
	var stockUse = pTemp.useTab.formobj();
	var applyDept = $("#stockDiv").formobj().applyDept;
	if(applyDept){
		stockUse.applyDept = applyDept.split("|")[1];
	}
	if(operate == 'apply'){
		stockUse.operate = "checkApply";
	}else if(operate == 'grant' || operate == 'notGrant'){
		stockUse.operate = operate;
	}
	//recordId,infoId，数量，总价
	stockUse.infoIds = infoIds;
	stockUse.infoAmounts = infoAmounts;
	stockUse.applyTotal = pTemp.applyTotalDiv.text();
	if(getURLParamPub("operate")=='modify'){
		stockUse.isModify = 'true';
	}
	//缓存
	pTemp.stockUse = stockUse;
	//校验库存是否
	if(operate == 'apply' || stockUse.isModify == 'true'){
		pTemp.ajaxM.getStockCountByIds({"ids":infoIds},{
			success : function(rval) {
				rval = $.parseJSON(rval);
				var hasApplyNumBigCount = false,stockNames=" ";
				if(rval.length > 0){
					for(var i=0;i<rval.length;i++){
						if(infoAmounts[i] > parseInt(rval[i])){
							if(hasApplyNumBigCount){
								stockNames += ",";
							}
							stockNames += infoNames[i];
							hasApplyNumBigCount = true;
						}
					}
				}
				
				if(hasApplyNumBigCount){
					$.confirm({
			      'msg' : $.i18n("office.stock.apply.num.is.big.js",stockNames+" "),
			      cancel_fn:function(){
			      	endProcePub();
			      },
			      ok_fn : function() {
			      	fnSaveApply(operate,stockUse);
			      }
			    });
				}else{
					fnSaveApply(operate,stockUse);
				}
			}});
	}else{
		fnSaveApply(operate,stockUse);
	}
}

function fnSaveApply(operate,stockUse){
	var isCloseWin = false ;
	pTemp.ajaxM.saveApply(stockUse,{
		success : function(rval) {
			var msg =$.i18n('office.handle.success.js'),type = 'ok';
			if (rval.state == "applyEmpty") {
				type = "alert";
				msg = $.i18n('office.stock.select.please.js');
			}else if (rval.state == "stockInfoModify") {
				if(operate == 'apply'){
					msg = $.i18n('office.stock.state.no.apply.js') +rval.stockNames;
					type = "alert";
				}else{//发放
					msg = $.i18n('office.stock.state.no.grant.js') +rval.stockNames;
					type = "alert";
				}
			}else if(rval.state == "stockInfoModify4NoAcl"){
				msg = $.i18n('office.stock.apply.user.noAcl.js',rval.stockNames);
				type = "alert";
			} else if (rval.state == "notEnough") {
				type = "alert";
				msg = $.i18n('office.stock.not.enough.js')+rval.stockNames;
			} else if (rval.state == "adminNoAcl4House") {
				type = "alert";
				msg = $.i18n('office.stock.not.acl.manage.js');
				isCloseWin = true;
			}else if(rval.state == "NoAcl4House"){
				msg = $.i18n('office.stock.not.acl.dbselect.js');
				if(pTemp.row.admin){
					msg = $.i18n('office.stock.not.acl.for.apply.by.modify.js');
					type = "alert";
					endProcePub();
					fnMsgBoxPub(msg, type);
					return;
				}
				
				var confirm = $.confirm({
			    'msg': msg,
			    ok_fn: function () {
			    	endProcePub();
			    	if(!pTemp.row.admin){
			    		pTemp.tab.reLoad({rows:[]});
			    	}
			    },
			    cancel_fn:function(){
			    	endProcePub();
			    }
				});
				return;
			}else if(rval.state == "handled"){
				isCloseWin = true ;
				type = "alert";
				msg = $.i18n('office.stock.apply.handled.js');
			}
			
			if (type == 'ok') {
				if(operate == 'apply'){
					//申请，提交到工作流
					workFlowPreSubmit();
				}else{
					fnMsgBoxPub(msg, type,function(){
						fnReloadPagePub({page:"stockGrant"});
						fnAutoCloseWindow();
					});
				}
			}else if(type == 'error'){
				endProcePub();
				fnMsgBoxPub(msg, type,function(){
					if(operate == 'apply'){
						fnReloadPagePub({page:"stockApply"});
					}else{
						fnReloadPagePub({page:"stockGrant"});
					}
					fnAutoCloseWindow();
				});
			}else{
				endProcePub();
				fnMsgBoxPub(msg, type,function(){
					if(isCloseWin){
						if(operate == 'apply'){
							fnReloadPagePub({page:"stockApply"});
						}else{
							fnReloadPagePub({page:"stockGrant"});
						}
						fnAutoCloseWindow();
					}
				});
			}
		},
    error : function(rval) {
    	endProcePub();
    	var msg = $.i18n('office.asset.assetApplyEdit.sqsb.js'),type = 'error';
    	fnMsgBoxPub(msg,type,function(){
    		fnReloadPagePub({page:"stockApply"});
				fnAutoCloseWindow();
			});
    }
	});
}

function fnNotGrant(operate){
	var confirm = $.confirm({
    'msg': $.i18n('office.stock.sure.not.grant.js'),
    ok_fn: function () {
    	fnOK(operate);
    }
	});
}

/**
 * 删除选择的办公用品
 */
function fnDelRow(rowId){
	var ids = [],filldata = [],totalPriceData = [];//缓存已填数据
	var amountInputs = pTemp.editTab.find("input[id^=applyAmount]");
	var totalPriceDivs = pTemp.editTab.find("span[id^=totalPrice]");
	
	for ( var i = 0; i < amountInputs.length; i++) {
		if (amountInputs[i].value) {
			filldata[i] = amountInputs[i].value;
			totalPriceData[i] = $(totalPriceDivs[i]).text();
		} else {
			filldata[i] = '';
		}
		ids[i] = $(amountInputs[i]).attr("id");
	}
	
	pTemp.tab.removeRow(rowId);
	
	fnFillDataToTab(ids,filldata,totalPriceData);
}

/**
 * 工作流预提交
 */
function workFlowPreSubmit() {
  preSendOrHandleWorkflow(window,"-1",pTemp.row.workFlow.workflowId,"-1","start", $.ctx.CurrentUser.id,"-1",$.ctx.CurrentUser.loginAccount,null,"office",null,window,"-1",fnWorkFlowCallSubmit);
}

/**
 * 工作流预提交回调提交
 */
function fnWorkFlowCallSubmit(){
	pTemp.stockUse.operate = "applySubmit";
	//工作流数据获取
	pTemp.stockUse.workFlow = $("#workFlowDiv").formobj();
	//pTemp.stockUse.workFlowJSON = pTemp.workFlowJSON;
	pTemp.ajaxM.saveApply(pTemp.stockUse,{
		success : function(rval) {
			var msg ='',type = 'ok';
			if (rval.state == "applyEmpty") {
				type = "alert";
				msg = $.i18n('office.stock.not.null.4select.js');
			}
			endProcePub();
			if (type == 'ok') {
				fnReloadPagePub({page:"stockApply"});
				fnAutoCloseWindow();
			}else{
				fnMsgBoxPub(msg, type);
			}
		},
    error : function(rval) {
    	endProcePub();
    	var msg = $.i18n('office.asset.assetApplyEdit.sqsb.js'),type = 'error';
    	fnMsgBoxPub(msg,type,function(){
    		fnReloadPagePub({page:"stockApply"});
				fnAutoCloseWindow();
			});
    }
	});
}

/**
 * 取消按钮
 */
function fnCancel() {
	if(getURLParamPub("operate")=="add"){
		var confirm = $.confirm({
		    'msg': $.i18n('office.sure.giveup.operate.js'),
		    ok_fn: function () {
		    	endProcePub();
		    	fnAutoCloseWindow();
		    }
			});
	}else{
		endProcePub();
    	fnAutoCloseWindow();
	}

}

/**
 *申请数量输入框校验函数 
 */
function fnApplyAmountCheck(_this){
	_this.value = _this.value.replace(/\D/g, '');
}

/**
 *输入框失去焦点计算 
 */
function fnApplyPriceCount(_this) {
	var rows = pTemp.tab.datas().rows;
	var amountInputs = pTemp.editTab.find("input[id^=applyAmount]");
	var totalPriceDivs = pTemp.editTab.find("span[id^=totalPrice]");
	var total = 0;
	var isBigCount = false;
	for ( var i = 0; i < amountInputs.length && i< rows.length; i++) {
		var amount = amountInputs[i].value;
		if ($.isNumeric(amount) && $.isNumeric(rows[i].stockPrice)) {
			var totalPrice = parseFloat(rows[i].stockPrice) * parseInt(amount);
			total += totalPrice;
			//设定总价
			
			$(totalPriceDivs[i]).text(parseFloat(totalPrice).toFixed(2));
			$(totalPriceDivs[i]).attr("title", parseFloat(totalPrice).toFixed(2));
		}
		//大于库存，提示
		if($.isNumeric(amount) && $.isNumeric(rows[i].stockCount)){
			if(parseInt(amount)>parseInt(rows[i].stockCount)){
				isBigCount = true;
				pTemp.applyAmountInputId = $(amountInputs[i]).attr("id");
			}
		}
	}
	pTemp.applyTotalDiv.text(parseFloat(total).toFixed(2));
}

/**
 * 申请编辑，选择用品tab的列参数
 */
function fnInfo2OtherTabItem(){
	var tabItem = {
			"id" : {
        display : 'id',
        name : 'id',
        width : 40,
        sortable : false,
        align : 'center',
        type : 'checkbox'
    },
    "stockNum" : {
	       display : $.i18n('office.stock.num.js'),
	       name : 'stockNum',
	       width : '55',
	       sortable : true,
	       align : 'left',
	       isToggleHideShow : false
	   },
	   "stockName" : {
	       display : $.i18n('office.stock.name.js'),
	       name : 'stockName',
	       width : '105',
	       sortable : true,
	       align : 'left'
	   },
	   "stockModel" : {
	     display : $.i18n('office.manager.StockInfoManagerImpl.ypgg.js'),
	     name : 'stockModel',
	     width : '55',
	     sortable : true,
	     align : 'left'
	   },
	   "stockTypeName" : {
	     display : $.i18n('office.stock.type.js'),
	     name : 'stockTypeName',
	     width : 100,
	     sortable : true,
	     align : 'left'
	   },
	   "stockPrice" : {
	     display : $.i18n('office.stock.price.js'),
	     name : 'stockPrice',
	     width : 45,
	     sortable : true,
	     sortorder:'desc',
	     sortType :'number',
	     align : 'right'
	   },
	   "stockCount" : {
	     display : $.i18n('office.stock.count.js'),
	     name : 'stockCount',
	     width : 40,
	     sortorder:'desc',
	     sortType :'number',
	     sortable : true,
	     align : 'right'
	   },
	   "applyAmount" : {
	     display : $.i18n('office.asset.apply.applyAmount.js'),
	     name : 'applyAmount',
	     width : 60,
	     sortable : true,
	     sortType :'number',
	     sortorder:'desc',
	     align : 'right'
	   },
	   "grantAmount" : {
	     display : $.i18n('office.stock.grantnum.js'),
	     name : 'grantAmount',
	     width : 60,
	     sortable : true,
	     sortType :'number',
	     sortorder:'desc',
	     align : 'right'
	   },
	   "stockHouseName" : {
	     display : $.i18n('office.stock.house.js'),
	     name : 'stockHouseName',
	     width : 100,
	     sortable : true,
	     align : 'left'
	   },
	   "stockHouseNameTab" : {
	     display : $.i18n('office.stock.house.js'),
	     name : 'stockHouseNameTab',
	     width : 100,
	     sortable : true,
	     align : 'left'
	   },
	   "stockHouseManagerName" : {
	     display : $.i18n('office.auto.admin.js'),
	     name : 'stockHouseManagerName',
	     width : 70,
	     sortable : true,
	     align : 'left'
	   },
	   "grantStateName" : {
       display : $.i18n('office.asset.query.state.js'),
       name : 'grantStateName',
       width : '70',
       sortable : true,
       align : 'left'
	   },
	   "totalPrice" : {
	     display : $.i18n('office.stock.price.total.js'),
	     name : 'totalPrice',
	     width : 65,
	     sortType :'number',
	     sortorder:'desc',
	     sortable : true,
	     align : 'right'
	   },
	   "operat" : {
	     display : '',
	     name : 'operat',
	     width : 26,
	     sortable : true,
	     align : 'center'
	   }
	 }
	 return tabItem;
}

/**
 * 操作的render
 */
function fnOperatRender(text, row, rowIndex, colIndex, col){
	var _text = (text == null) ? "" : text;
	
  if (col.name === 'operat') {
			return "<a href='javascript:void(0);' class='margin_r_5' onclick='fnDelRow("+row.id+");'><span class='ico16 affix_del_16' title='"+$.i18n('office.tbar.delete.js')+"'></span> </a>";
  }
  
  if((getURLParamPub("operate")=='add'|| getURLParamPub("operate")=='modify') && col.name === 'applyAmount'){
		return "<input id='applyAmount"+row.id+"' maxlength='9' style='width:55px' class='align_right font_size12 grid_black' onblur='fnApplyPriceCount(this);' onkeyup='fnApplyAmountCheck(this);'>";
	}
  
  if(getURLParamPub("operate")=='add'|| getURLParamPub("operate")=='modify' ||  
  		(getURLParamPub("operate")=='grant' && parseInt(pTemp.row.state) == 5 && pTemp.row.admin)){
  	
  	//申请数量
    if(col.name === 'grantAmount'){
    	var disableTxt = "";
    	if(row.grantState != null && parseInt(row.grantState) != 0){
    		 disableTxt = "readonly='readonly' disabled='disabled'";
    	}
    	return "<input id='applyAmount"+row.id+"' "+disableTxt+" maxlength='9' style='width:55px' class='align_right font_size12 grid_black' onblur='fnApplyPriceCount(this);' onkeyup='fnApplyAmountCheck(this);'>";
    }
    //总价
    if(col.name === 'totalPrice'){
    	return "<span class='grid_black' id='totalPrice"+row.id+"' title='"+_text+"'>"+_text+"</span>";
    }
  }
  return "<span class='grid_black'>"+_text+"</span>";
}

$(document).ready(function(){
	$("#stockApplyEditTab").height(110);
});