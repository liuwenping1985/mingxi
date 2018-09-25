function openSelectStockWinPub(transArg,url){
	var _url = "/office/stockUse.do?method=selectStock";
	if (url) {
		_url += url;
	}
	var dialog = $.dialog({
		id : "_office_selectStock_dialog",
		url : _path + _url,
		targetWindow : getCtpTop(),
		width:900,
		height:500,
		transParams:transArg,
		title:$.i18n('office.stock.select.please.js'),
		buttons:[{
			text:$.i18n('office.auto.ok.js'),
			isEmphasize:true,
			handler : function() {
				if (typeof (fnSelectStockOK) !== 'undefined') {
					fnSelectStockOK({
						dialog : dialog,
						okParam : dialog.getReturnValue()
					});
				}
			}
		},{
			text:$.i18n('office.auto.cancel.js'),
			handler : function() {
				if (typeof (fnSelectStockCancel) !== 'undefined') {
					fnSelectStockCancel({
						dialog : dialog,
						okParam : dialog.getReturnValue()
					});
				}
			}
		}]
	});
}

/**
 * 在办公用品使用的搜索按钮的参数
 */
function fnSBArg4UsePub(){
	return {
    "applyUser":{
      id : 'applyUser',
      name : 'applyUser',
      type : 'input',
      text : $.i18n('office.stock.use.user.js'),
      value : 'applyUser'
    },
    "applyDept":{
      id : 'applyDept',
      name : 'applyDept',
      type : 'selectPeople',
      text : $.i18n('office.stock.use.dep.js'),
      value : 'applyDept',
      comp : "type:'selectPeople',mode:'open',panels:'Department',selectType:'Department',maxSize:'1'"
    },
    "applyDate" : {
      id : 'applyDate',
      name : 'applyDate',
      type : 'datemulti',
      text : $.i18n('office.stock.use.applydate.js'),
      value : 'applyDate',
      ifFormat:'%Y-%m-%d',
      dateTime : false
    },
    "workFlowState":{
      id : 'state',
      name : 'state',
      type : 'select',
      text : $.i18n('office.workflow.state.js'),
      value : 'state_int',
      items : [ {
          text : $.i18n('office.workflow.state.unaduit.js'),
          value : 0
      }, {
          text : $.i18n('office.workflow.state.aduited.js'),
          value : 1
      }, {
          text : $.i18n('office.asset.query.state.all.js'),
          value : 2
      } ]
    },
    "stockHouseId":{
      id : 'stockHouseId',
      name : 'stockHouseId',
      type : 'select',
      text : $.i18n('office.stock.house.js'),
      value : 'stockHouseId_long',
      items : fnStockHouseItemPub()
    },
    "applyState":{
      id : 'state',
      name : 'state',
      type : 'select',
      text : $.i18n('office.asset.query.state.js'),
      value : 'state_int',
      items : [{
          text : $.i18n('office.workflow.state.unaduit.js'),
          value : 1
		      },{
		        text : $.i18n('office.stock.use.unsend.js'),
		        value : 5
		      },{
		        text : $.i18n('office.constants.StockApplyState.grant.part.js'),
		        value : 6
		      },{
		        text : $.i18n('office.stock.use.sended.js'),
		        value : 10
		      },{
		        text : $.i18n('office.workflow.state.aduit.not.js'),
		        value : 15
		      },{
			      text : $.i18n('office.stock.use.send.not.js'),
			      value : 20
		      },{
				    text : $.i18n('office.workflow.state.revoked.js'),
				    value : 25
      		},{
				    text : $.i18n('office.asset.query.state.all.js'),
				    value : -1
      		}]
    },
    "state":{
      id : 'state',
      name : 'state',
      type : 'select',
      text : $.i18n('office.asset.query.state.js'),
      value : 'state_int',
      items : [ {
          text : $.i18n('office.stock.use.unsend.js'),
          value : 5
      }, {
          text : $.i18n('office.stock.use.sended.js'),
          value : 10
      },{
		    text : $.i18n('office.asset.query.state.all.js'),
		    value : -100
  		}]
    }
    
	}
}

/**
 * 申请，审核，发放，发放记录共用的标题列 tab数据
 */
function fnTabItem4UsePub(){
  return {
      "id" : {
          display : 'id',
          name : 'id',
          width : 40,
          sortable : false,
          align : 'center',
          type : 'checkbox'
      },
      "applyUser" : {
          display : $.i18n('office.stock.use.user.js'),
          name : 'applyUserName',
          width : '10%',
          sortable : true,
          align : 'left'
      },
      "applyDept" : {
          display : $.i18n('office.stock.use.dep.js'),
          name : 'applyDeptName',
          width : '20%',
          sortable : true,
          align : 'left'
      },
      "applyDate" : {
        display : $.i18n('office.stock.use.applydate.js'),
        name : 'applyDate',
        width : '110',
        cutsize :21,
        sortable : true,
        align : 'center'
      },
      "stockHouseName" : {
          display : $.i18n('office.stock.house.js'),
          name : 'stockHouseName',
          width : '16%',
          sortable : true,
          align : 'left'
      },
      "state" : {
          display : $.i18n('office.asset.query.state.js'),
          name : 'stateName',
          width : '100',
          sortable : true,
          align : 'left'
      },
      "workFlowState" : {
        display : $.i18n('office.workflow.state.js'),
        name : 'workFlowState',
        width : '100',
        sortable : true,
        align : 'left'
      },
      "applyDesc" : {
        display : $.i18n('office.stock.use.applydesc.js'),
        name : 'applyDesc',
        width : 270,
        sortable : true,
        align : 'left'
      }
  }
}

/**
 * 申请编辑，选择用品tab的列参数
 */
function fnInfo2OtherTabItemPub(){
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
	       align : 'left'
	   },
	   "stockName" : {
	       display : $.i18n('office.stock.name.js'),
	       name : 'stockName',
	       width : '115',
	       sortable : true,
	       align : 'left'
	   },
	   "stockModel" : {
	     display : $.i18n('office.manager.StockInfoManagerImpl.ypgg.js'),
	     name : 'stockModel',
	     width : '60',
	     sortable : true,
	     align : 'left'
	   },
	   "stockTypeName" : {
	     display : $.i18n('office.stock.type.js'),
	     name : 'stockTypeName',
	     width : 120,
	     sortable : true,
	     align : 'left'
	   },
	   "stockPrice" : {
	     display : $.i18n('office.stock.price.js'),
	     name : 'stockPrice',
	     width : 50,
	     sortable : true,
	     sortorder:'desc',
	     sortType :'number',
	     align : 'right'
	   },
	   "stockCount" : {
	     display : $.i18n('office.stock.count.js'),
	     name : 'stockCount',
	     width : 50,
	     sortorder:'desc',
	     sortType :'number',
	     sortable : true,
	     align : 'right'
	   },
	   "applyAmount" : {
	     display : $.i18n('office.stock.applynum.js'),
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
	     display : $.i18n('office.stock.house.manager.js'),
	     name : 'stockHouseManagerName',
	     width : 90,
	     sortable : true,
	     align : 'left'
	   },
	   "totalPrice" : {
	     display : $.i18n('office.stock.totalprice.js'),
	     name : 'totalPrice',
	     width : 85,
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
 * 用品库名称获取
 */
function fnStockHouseItemPub() {
	if (pTemp.jval != '') {
		var houseItems = $.parseJSON(pTemp.jval);
		if(houseItems.length>0){
			return houseItems;
		}
	}
	return [{text:'',value:'-1'}];
}