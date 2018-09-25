$(function() {
	// toolBar初始化
	pTemp.TBar = officeTBar().addAll([ "dolend" ]).init("toolbar");
	// 初始化查询框
	pTemp.SBar = officeSBar("fnInitSearchBar").addAll(
			[ "applyUser", "applyDept", "applyBookHouse", "applyBookType"]).init();
	// 初始化列表
	pTemp.tab = officeTab().addAll(
			[ "id","applyUser", "applyDept", "bookName",
					"bookCategory","bookHouseName", "applyDate", "applyCount","applyState" ]).init(
			"bookLend", {
				argFunc : "fnBookApplyItems",
				parentId : $('.layout_center').eq(0).attr('id'),
				slideToggleBtn : false,
				resizable : false,
				"managerName" : "bookApplyManager",
				"managerMethod" : "findLendings"
			});

	pTemp.ajaxM = new bookApplyManager();
	pTemp.tab.load();
});
var treeTempValue = 0;
/**
 * 直接借出
 */
function fnDoLend(){
  var rows = pTemp.tab.selectRows();
  if(rows!=null&&rows!=""){
    var quickLendDialog = $.dialog({
      id : 'doQuickLend',
      url : _path+'/office/bookUse.do?method=bookDoQuickLend',
      title : $.i18n('office.tbar.dolend.js'),
      width :480,
      height : 230,
      buttons: [{
        id : "lend",
        isEmphasize:true,
        text : $.i18n('office.asset.apply.lend.js'),
          handler : function() {
            var rv = quickLendDialog.getReturnValue();
            if(rv==false){
              return false;
            }else {
              var data= {
                  lendDate :rv.lendDate,
                  lendFlag : "lend",
                  ids : rows,
                  flag : "lend",
              };
              fnQuickLend(data);
              quickLendDialog.close();
            }
          }
      }, {
        id : "noLend",
        text : $.i18n('office.asset.apply.notLend.js'),
          handler : function() {
          var rv = quickLendDialog.getReturnValue();
          var data= {
              lendDate :rv.lendDate,
              lendFlag : "lend",
              ids : rows,
              flag : "noLend",
          };
          fnQuickLend(data);
          quickLendDialog.close();}
      }]
    });
  }else{
    var doLendDialog = $.dialog({
      id : 'doLend',
      url : _path+'/office/bookUse.do?method=doLend',
      width :900,
      height : 500,
      title : $.i18n('office.tbar.dolend.js'),
      targetWindow : getCtpTop(),
      buttons: [{
        id : "sure",
        isEmphasize:true,
        text : $.i18n('calendar.sure'),
        handler : function() {
          var ret = doLendDialog.getReturnValue();
          var rows = ret.rows;  // 选择的图书资料
          var to = ret.toPerson;// 借阅对象
          if(rows == "null"){
            $.alert($.i18n("office.bookapply.dolend.selectbook.js"));
          }
          if(rows != "false" && rows != "null"){
            var lendSumNull = false;
            for(var i=0;i<rows.length;i++){
              if(rows[i].lendSum == "" || rows[i].lendSum == 0){
                lendSumNull = true;
              }
            }
            if(lendSumNull){
              $.alert($.i18n("office.bookapply.dolend.notnull.js"));
            }else{ // 提交数据
              var rval = pTemp.ajaxM.saveDoLend(to.split("|")[1],rows);
              if(rval.result != null){
                $.alert(rval.result);
                return;
              }else{
                $.infor($.i18n("office.bookapply.dolend.success.js"))
                doLendDialog.close();
              }
            }
          }
        }
      }, {
        id : "cancel",
        text : $.i18n('calendar.cancel'),
        handler : function() {doLendDialog.close();}
      }]
    });
  }
}

function fnReg() {
}

function fnPageInIt() {
}

function fnPageReload() {
	pTemp.tab.load();
}

function fnSetCss() {
}

function fnTabClk() {
	fnShowDetail();
}

function fnTabDBClk() {
	fnShowDetail();
}
function fnBookApplyItems() {
	return {
		"id" : {
			display : 'id',
			name : 'id',
			width : '3%',
			sortable : false,
			align : 'center',
			type : 'checkbox',
			isToggleHideShow : true
		},
		"applyUser" : {
			display : $.i18n('office.stock.use.user.js'),
			name : 'applyUser',
			width : '8%',
			sortable : true,
			align : 'left',
			isToggleHideShow : false
		},
		"applyDept" : {
			display : $.i18n('office.stock.use.dep.js'),
			name : 'applyDept',
			width : '8%',
			sortable : true,
			align : 'left',
			isToggleHideShow : true
		},
		"bookName" : {
			display : $.i18n('office.asset.apply.assetName.js'),
			name : 'bookName',
			width : '15%',
			sortable : true,
			align : 'left',
			isToggleHideShow : true
		},
		"bookCategory" : {
            display : $.i18n('office.bookinfo.category.js'),
            name : 'bookCategory',
            width : '10%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        },
		"bookHouseName" : {
			display : $.i18n('office.bookhouse.js'),
			name : 'bookHouseName',
			width : '20%',
			sortable : true,
			align : 'left',
			isToggleHideShow : true
		},
		"applyDate" : {
			display : $.i18n('office.bookapply.applydate.js'),
			name : 'applyDate',
			width : '15%',
			sortable : true,
			align : 'left',
			isToggleHideShow : true
		},
		"applyCount" : {
			display : $.i18n('office.bookapply.applysum.js'),
			name : 'applyCount',
			width : '8%',
			sortable : true,
			align : 'right',
			isToggleHideShow : true
		},
		"applyState" : {
			display : $.i18n('office.asset.query.state.js'),
			name : 'applyState',
			width : '8%',
			sortable : true,
			align : 'left',
			isToggleHideShow : true,
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.office.constants.BookInfoApplyState'"
		}
	}
}

function fnShowDetail() {
    var rows = pTemp.tab.selectRows();
    var url = "/office/bookUse.do?method=bookLendDetail&bookApplyId="+rows[0].id+"&v="+rows[0].v,title = $.i18n('office.book.bookLib.tszljy.js');
	fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:800,height:600});
}


/**
 * 查询
 */
function fnSBarQuery(obj) {
	// 查询的时候，记录下查询条件，供导出用
	pTemp.condition = obj.condition;
	pTemp.value = obj.value;
	pTemp.tab.load(obj);
}

function fnBookHouseItems(){
	var jval =$.parseJSON(pTemp.jval);
	var rows =  jval.sb1;
	var options =[];
	if(rows.length>0){
		return rows;
	}else{
		options[0] = {text:"",value:""};
		return options;
	}
}
function fnBookTypeItems(){
	var jval =$.parseJSON(pTemp.jval);
	var rows =  jval.sb2;
	var options =[];
	if(rows.length>0){
		return rows;
	}else{
		options[0] = {text:"",value:""};
		return options;
	}
}

/**
 * 搜索框初始化
 * 
 * @returns
 */
function fnInitSearchBar() {
	return {
		"applyUser":{
		      id : 'applyUser',
		      name : 'applyUser',
		      type : 'input',
		      text : $.i18n('office.stock.use.user.js'),
		      value : 'applyUser'
		    },
		"applyDept" : {
			id : 'applyDept',
			name : 'applyDept',
			type : 'selectPeople',
			text : $.i18n('office.stock.use.dep.js'),
			value : 'applyDept',
			comp : "type:'selectPeople',mode:'open',panels:'Department',selectType:'Department',maxSize:'1'"
		},
		"applyBookHouse" : {
			id : 'applyBookHouse',
			name : 'applyBookHouse',
			type : 'select',
			text : $.i18n('office.bookhouse.js'),
			value : 'applyBookHouse',
			items:fnBookHouseItems()
		},
		"applyBookType" : {
			id : 'applyBookType',
			name : 'applyBookType',
			type : 'select',
			text : $.i18n('office.bookapply.belong.type.js'),
			value : 'applyBookType',
			items:fnBookTypeItems()
		}
	}
}

function fnQuickLend(data){
  pTemp.ajaxM.batchBookLend(data, {
    success : function(rv) {
      if (rv.successNum == rv.totalNum) {
        if(data.flag=="noLend"){
          $.infor($.i18n('office.handle.success.js'));
        }else{
          $.infor($.i18n("office.bookapply.dolend.success.js"));
        }
      } else {
        if (rv.numFailList.length > 0) {
          var str = "";
          for (var i = 0; i < rv.numFailList.length; i++) {
            str = str + "《"+rv.numFailList[i]+"》";
          }
          $.alert($.i18n('office.book.bookBorrow.yxtskcbzbyxzjjc.js') + "<br>" + str);
        }else if (rv.dateFailList.length > 0) {
          var str = "";
          for (var i = 0; i < rv.dateFailList.length; i++) {
            str = str + "《"+rv.dateFailList[i]+"》";
          }
          $.alert($.i18n('office.book.bookBorrow.yxtszljcsjcgjyqx.js') + "<br>" + str);
        }else if (rv.failList.length > 0) {
          var str = "";
          for (var i = 0; i < rv.failList.length; i++) {
            str = str + "《"+rv.failList[i]+"》";
          }
          $.alert($.i18n('office.manager.BookApplyManagerImpl.clsb2.js') + "<br>" + str);// 借出
        }
      }
      pTemp.tab.load();
    },
    error : function(rv) {
      $.error("error");
    }
  });
  
}



