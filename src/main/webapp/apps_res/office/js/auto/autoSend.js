// js开始处理
$(function() {
    //toolbar
    pTemp.TBar = officeTBar().addAll(["dSend"]).init("toolbar");
    //searchBar
    pTemp.SBar = officeSBar("fnSBArgFuncPub").addAll(["applyUser","applyDept","applyAutoIdName"]).init();
    
    pTemp.tab = officeTab().addAll(["id","applyUser","applyDept","passengerNum","applyOrigin","useTime","applyDes","applyAutoId","state" ]).init("autoSend", {
        argFunc : "fnTabItem",
        parentId : $('.layout_center').eq(0).attr('id'),
        slideToggleBtn : false,// 上下伸缩按钮是否显示
        resizable : false,// 明细页面的分隔条
        render:fnUseTimeRenderPub,
        "managerName" : "autoUseManager",
        "managerMethod" : "findAutoUseList"
    });
    pTemp.ajaxM = new autoUseManager();
    fnPageReload();
});

/**
 * 刷新页面
 */
function fnPageReload() {
	var param = {type:'autoSend'};
	pTemp.tab.load(param);
}

/**
 * 单击Tab查看
 */
function fnTabClk() {
	var row = pTemp.tab.selectRows()[0];
	var param = {applyId:row.id,states:[5]};
	pTemp.ajaxM.isApplyHasState(param,{success:function(rval){
		if(rval){
			var url = "/office/autoUse.do?method=autoApplyIframe&isEdit=true&applyId="+ row.id+"&state="+row.state+"&v="+row.v
			,title = $.i18n('office.app.auto.use.apply.js');
			fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:800,height:520});
		}else{
			fnPageReload();
			$.alert($.i18n('office.auto.apply.handled.js'));
		}
	}});
}


/**
 * 直接派车
 */
function fnDSend(){
 	var row = pTemp.tab.selectRows()[0];
	var url = "/office/autoUse.do?method=autoDSendIframe&isEdit=true&isDEdit=true&operate=add",title = $.i18n('office.tbar.dsend.js');
	fnAutoOpenWindow({"url":url,"title":title,hasBtn:false,width:800,height:520});
}

/**
 * 查询
 */
function fnSBarQuery(cnd){
	cnd.isQuery = "true";
	cnd.type = 'autoSend';
	pTemp.tab.load(cnd);
}


function fnTabItem(){
  return {
      "id" : {
          display : 'id',
          name : 'id',
          width : "5%",
          sortable : false,
          align : 'center',
          type : 'checkbox',
          hide : true,
          isToggleHideShow : false
      },
      "applyUser" : {
          display : $.i18n('office.autoapply.user.js'),
          name : 'applyUserName',
          width : '8%',
          sortable : true,
          align : 'left',
          isToggleHideShow : false
      },
      "applyDept" : {
          display : $.i18n('office.autoapply.dep.js'),
          name : 'applyDeptName',
          width : '13%',
          sortable : true,
          align : 'left'
      },
      "passengerNum" : {
          display : $.i18n('office.autoapply.num.js'),
          name : 'passengerNum',
          width : 45,
          sortable : true,
          align : 'left'
      },
      "applyOrigin" : {
          display : $.i18n('office.autoapply.origin.js'),
          name : 'applyOrigin',
          width : '10%',
          sortable : true,
          align : 'left'
      },
      "applyDes" : {
          display : $.i18n('office.autoapply.endplace.js'),
          name : 'applyDes',
          width : '10%',
          sortable : true,
          align : 'left'
      },
      "applyAutoId" : {
          display : $.i18n('office.autoapply.auto.js'),
          name : 'applyAutoIdName',
          width : "8%",
          sortable : true,
          align : 'left'
      },
      "state" : {
          display : $.i18n('office.asset.query.state.js'),
          name : 'stateName',
          width : "10%",
          sortable : true,
          align : 'left'
      },
      "useTime" : {
        display : $.i18n('office.autoapply.udate.js'),
        name : 'useTime',
        width : 230,
        sortable : true,
        align : 'left'
      }
  }
}
