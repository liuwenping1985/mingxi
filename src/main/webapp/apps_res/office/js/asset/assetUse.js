function openSelectAssetWinPub(userId){
	var _url = "/office/assetUse.do?method=selectAsset&userId=" + userId+"&operate="+getURLParamPub("operate");
	var dialog = $.dialog({
		id : "_office_selectAsset_dialog",
		url : _path + _url,
		targetWindow : getCtpTop(),
		width:1030,
		height:500,
		title:$.i18n('office.asset.assetUse.xzbgsb.js'),
		buttons:[{
			text:$.i18n('office.auto.ok.js'),
			isEmphasize:true,
			handler : function() {
				if (typeof (fnSelectAssetOK) !== 'undefined') {
					fnSelectAssetOK({
						dialog : dialog,
						okParam : dialog.getReturnValue()
					});
				}
			}
		},{
			text:$.i18n('office.asset.assetUse.qx.js'),
			handler : function() {
				if (typeof (fnSelectAssetCancel) !== 'undefined') {
					fnSelectAssetCancel({
						dialog : dialog,
						okParam : dialog.getReturnValue()
					});
				}
			}
		}]
	});
}

/**
 * 搜索条参数
 */
function fnSBArg4UsePub(){
	return {
    "applyUser":{
      id : 'applyUser',
      name : 'applyUser',
      type : 'input',
      text : $.i18n('office.asset.assetUse.syr.js'),
      value : 'applyUser'
    },
    "assetType":{
      id : 'assetType',
      name : 'assetType',
      type : 'input',
      text : $.i18n('office.asset.selectAsset.sbfl.js'),
      value : 'assetType'
    },
    "createDate":{
      id : 'createDate',
      name : 'createDate',
      type : 'datemulti',
      text : $.i18n('office.asset.assetUse.fqsj.js'),
      value : 'createDate',
      ifFormat:'%Y-%m-%d',
      dateTime : false
    },
    "workFlowState":{
      id : 'state',
      name : 'state',
      type : 'select',
      text : $.i18n('office.asset.assetUse.lczs.js'),
      value : 'state_int',
      items : [ {
          text : $.i18n('office.book.bookAudit.dsp.js'),
          value : 0
      }, {
          text : $.i18n('office.asset.assetUse.ysp.js'),
          value : 1
      }, {
          text : $.i18n('office.book.bookAudit.qb.js'),
          value : 2
      } ]
    },
    "applyState":{
      id : 'state',
      name : 'state',
      type : 'select',
      text : $.i18n('office.asset.assetUse.zs.js'),
      value : 'state_int',
      items : [{
          text : $.i18n('office.book.bookAudit.dsp.js'),
          value : 1
		      },{
		        text : $.i18n('office.asset.assetUse.djc.js'),
		        value : 5
		      },{
		        text : $.i18n('office.asset.assetUse.dgh.js'),
		        value : 10
		      },{
		        text : $.i18n('office.asset.assetUse.cqjc.js'),
		        value : 15
		      },{
			      text : $.i18n('office.asset.assetUse.ygh.js'),
			      value : 20
		      },{
				    text : $.i18n('office.asset.assetUse.spbtg.js'),
				    value : 25
      		},{
				    text : $.i18n('office.asset.assetUse.jcbtg.js'),
				    value : 30
      		},{
				    text : $.i18n('office.asset.assetUse.ycx.js'),
				    value : 35
      		},{
				    text : $.i18n('office.book.bookAudit.qb.js'),
				    value : -1
      		}]
    },
    "state":{
      id : 'state',
      name : 'state',
      type : 'select',
      text : $.i18n('office.asset.assetUse.zs.js'),
      value : 'state_int',
      items : [ {
        text : $.i18n('office.asset.assetUse.djc.js'),
        value : 5
      },{
        text : $.i18n('office.asset.assetUse.dgh.js'),
        value : 10
      },{
        text : $.i18n('office.asset.assetUse.cqjc.js'),
        value : 15
      },{
	      text : $.i18n('office.asset.assetUse.ygh.js'),
	      value : 20
      },{
		    text : $.i18n('office.book.bookAudit.qb.js'),
		    value : -1
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
          type : 'checkbox',
          hide : pTemp.hideCheckbox ? true : false,
          isToggleHideShow : false
      },
      "assetNum" : {
        display : $.i18n('office.asset.apply.assetNum.js'),
        name : 'assetNum',
        width : '8%',
        sortable : true,
        align : 'left',
        isToggleHideShow : false
      },
      "assetTypeName" : {
        display : $.i18n('office.asset.apply.assetTypeName.js'),
        name : 'assetTypeName',
        width : '8%',
        sortable : true,
        align : 'left'
      },
      "assetName" : {
        display : $.i18n('office.asset.apply.assetName.js'),
        name : 'assetName',
        width : '10%',
        sortable : true,
        align : 'left'
      },
      "useTime" : {
        display : $.i18n('office.asset.apply.useStartTime.js'),
        name : 'useTime',
        width : '230',
        sortable : false,
        align : 'left'
      },
      "applyDesc" : {
        display : $.i18n('office.asset.apply.applyDesc.js'),
        name : 'applyDesc',
        width : "20%",
        sortable : true,
        align : 'left'
      },
      "createDate" : {
        display : $.i18n('office.autoapply.start.date.js'),
        name : 'createDate',
        width : '100',
        cutsize: 21,
        sortable : true,
        align : 'center'
      },
      "state" : {
        display : $.i18n('office.asset.query.state.js'),
        name : 'stateName',
        width : '100',
        sortable : true,
        align : 'left'
      },
      "startMemberIdName" : {
        display : $.i18n('office.assetapply.startmember.js'),
        name : 'startMemberIdName',
        width : '8%',
        sortable : true,
        align : 'left'
      },
      "applyUser" : {
          display : $.i18n('office.asset.apply.applyUser.js'),
          name : 'applyUserName',
          width : '10%',
          sortable : true,
          align : 'left'
      },
      "applyDept" : {
          display : $.i18n('office.asset.apply.applyDept.js'),
          name : 'applyDeptName',
          width : '20%',
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
	   "assetBrand" : {
	     display : $.i18n('office.asset.apply.assetBrand.js'),
	     name : 'assetBrand',
	     width : '60',
	     sortable : true,
	     align : 'left'
	   },
	   "assetModel" : {
	     display : $.i18n('office.asset.apply.assetModel.js'),
	     name : 'assetModel',
	     width : 80,
	     sortable : true,
	     align : 'left'
	   },
	   "assetDesc" : {
	     display : $.i18n('office.asset.apply.assetMemo.js'),
	     name : 'assetDesc',
	     width : 210,
	     sortable : true,
	     align : 'left'
	   },
	   "applyAmount" : {
	     display : $.i18n('office.asset.query.sum.js'),
	     name : 'applyAmount',
	     width : 50,
	     sortorder:'desc',
	     sortType :'number',
	     sortable : true,
	     align : 'right'
	   },
	   "hasAmount" : {
	     display : $.i18n('office.asset.query.sum.js'),
	     name : 'hasAmount',
	     width : 50,
	     sortorder:'desc',
	     sortType :'number',
	     sortable : true,
	     align : 'right'
	   },
     "handleTime" : {
       display : $.i18n('office.assetapply.lendedtime.js'),
       name : 'handleTime',
       width : 140,
       cutsize :21,
       sortable : true,
       align : 'center'
     }
  }
}

/**
 * 设备库名称获取
 */
function fnAssetHouseItemPub() {
	if (pTemp.jval != '') {
		var houseItems = $.parseJSON(pTemp.jval);
		if(houseItems.length>0){
			return houseItems;
		}
	}
	return [{text:'',value:'-1'}];
}

/**
 * 用车时间列Render
 */
function fnUseTimeRenderPub(text, row, rowIndex, colIndex, col){
	var _text = (text == null) ? "" : text;
  if (col.name === 'useTime') {
		if (row.useStartTime != null && row.useEndTime != null) {
			_text = row.useStartTime + $.i18n('office.asset.apply.to.js') + row.useEndTime;
  	}
		
		if (row.isOften) {
			//_text = $.i18n('office.asset.assetUse.cq.js');
			_text = row.useStartTime +" "+ $.i18n('office.asset.apply.to.js') + " ----";
		}
  }  
  return "<span class='grid_black'>"+_text+"</span>";
}