// js开始处理
$(function() {
	// toolBar初始化
	pTemp.sTBar = officeTBar({isPager:true}).addAll([ "reg", "edit", "del","imp2exp","updates" ]).init("toolbar");
	//搜索框初始化
    pTemp.SBar = officeSBar("fnInitSearchBar").addAll(["autoNum","categoryId","autoBrand","autoModel","buyDate","state"]).init();
	// 列表table初始化
	pTemp.tab = officeTab().addAll(
			[ "id", "autoNum", "autoTypeName", "category", "autoBrand",
					"autoModel", "autoPernum", "buyDate", "state" ])
			.init("autoList", {
				argFunc : "initAutoTable",
				parentId : $('.layout_center').eq(0).attr('id'),
				slideToggleBtn : true,// 上下伸缩按钮是否显示
				resizable : true,// 明细页面的分隔条
				"managerName" : "autoInfoManager",
				"managerMethod" : "find"
			});
	
	//manager
    pTemp.ajaxM = new autoInfoManager();
    pTemp.editIframe = $("#autoInfoFrame");//子页面的iframe对象
    pTemp.cPage = pTemp.editIframe[0].contentWindow;//子页面对象
    fnPageReload();
    //两个全局变量，有来存放查询时的条件-值
    pTemp.condition =  null;
    pTemp.value = null;
});

function fnPageReload(){
	pTemp.tab.load();
	if(pTemp.cPage.fninitCats){
		pTemp.cPage.fninitCats();
	}
}

/**
 * 双击修改
 */
function fnTabDBClk() {
	fnShowDetail('modify');
}

/**
 * 单击查看
 */
function fnTabClk() {
	fnShowDetail('view');
}

/**
 * 新建车辆
 */
function fnReg() {
	fnShowDetail('add');
}

/**
 * 修改车辆 
 */
function fnEdit(){
	fnShowDetail('modify');
}

/**
 * 批量修改车辆
 * @returns
 */
function fnUpdates(){
	fnShowDetail('updates');
}

/**
 * 刷新新增，修改页面的数据
 * @param mode
 */
function fnShowDetail(mode) {
    var rows = pTemp.tab.selectRows();
    if (mode === 'modify' || mode === 'updates') {
        if(rows.length == 0){
            $.alert($.i18n('office.autoinfo.select.one.js'));
            return;
        }else if(mode === 'modify' && rows.length > 1){
            $.alert($.i18n('office.auto.onlyone.edit.js'));
            return;
        }
    }
    
    if (mode != 'updates'){
    	pTemp.tab.reSize('m');
    }
    if(!pTemp.cPage || !pTemp.cPage.fnPageReload){//快速点击报错问题
    	return;
    }
    // 子页面载入
    pTemp.cPage.fnPageReload({
        "mode" : mode,
        "row" : rows[0]
    });
}

/**
 * 查询
 */
function fnSBarQuery(o){
	pTemp.condition = o.condition;
	pTemp.value = o.value;
	$("#autoList").ajaxgridLoad(o);
}

/**
 * 导入数据
 * @returns
 */
function fnImp(){
	var importDialog = $.dialog({
		id: 'imp',
	    url: _path+"/office/autoSet.do?method=importAutoInfo",
	    width: 400,
	    height: 240,
	    title: $.i18n('office.assetinfo.fileupload.js'),
	    targetWindow : getCtpTop(),
	    closeParam:{'show':true,handler:function(){
	    	pTemp.tab.load();
	    }} 
	});

}

/**
 * 导出模板
 */
function fnDow(){
	$("#exportAuto").jsonSubmit({
		action:_path+"/office/autoSet.do?method=exportAutoInfo&model=downloadTemplate",
		callback:function(rval){
		}
	});
}

/**
 * 车辆信息列表导出EXCEL
 */
function fnExp(){
	var selectIds = pTemp.tab.selectRowIds(); //导出时、选择的数据
	//查询条件
	var condition = pTemp.condition;
	var value = pTemp.value;
	if(condition == "autoNum_like" || condition =="autoModel_like" || condition== "autoBrand_like"){
		condition = condition.split("_")[0];
	}
	$("#exportAuto").jsonSubmit({
		action:_path+"/office/autoSet.do?method=exportAutoInfo&ids="+selectIds+"&con="+condition+"&val="+value,
		callback:function(rval){}
	});
}

/**
 * 删除车辆
 */
function fnDel() {
	var applyManager = new autoApplyManager();
	var ids = pTemp.tab.selectRowIds();
	var isApply = false;
	var autoApply = applyManager.findByAutoId(ids);
	if(autoApply!=null && autoApply.length>0){
		isApply = true;
	}
	if (ids.length >= 1) {
		
		if(isApply){
			if(ids.length>1){
				$.alert($.i18n('office.auto.used.js'));
				return;
			}
			if(ids.length==1){
				$.alert($.i18n('office.auto.car.has.apply.notDel.js'));
				return;
			}
		}
		
		var confirm = $.confirm({
			'msg' : $.i18n('office.auto.really.delete.js'),
			ok_fn : function() {
				pTemp.ajaxM.deleteByIds(ids,{
	                success : function(rval) {
	                    $.infor($.i18n('office.auto.delsuccess.js'));
	                    fnReg();
	    				pTemp.tab.load();
	    				pTemp.tab.reSize('d');
	                }
	            });				
			},
			cancel_fn : function() {
				return;
			}
		});

	} else {
		$.alert($.i18n('office.auto.selectone.delete.js'));
	}
}

/**
 * 车辆列表数据初始化
 */
function initAutoTable() {
	return {
		"id" : {
			display : 'id',
			name : 'id',
			width : '5%',
			sortable : false,
			align : 'center',
			type : 'checkbox',
			isToggleHideShow : true
		},
		"autoNum" : {
			display : $.i18n('office.auto.num.js'),
			name : 'autoNum',
			width : '14%',
			sortable : true,
			align : 'left',
			isToggleHideShow : false
		},
		"autoTypeName" : {
			display : $.i18n('office.auto.type.js'),
			name : 'autoTypeName',
			width : '14%',
			sortable : true,
			align : 'left'
		},
		"category" : {
			display : $.i18n('office.auto.group.js'),
			name : 'category',
			width : '15%',
			sortable : true,
			align : 'left'
		},
		"autoBrand" : {
			display : $.i18n('office.auto.name.js'),
			name : 'autoBrand',
			width : '10%',
			sortable : true,
			align : 'left',
			isToggleHideShow : false
		},
		"autoModel" : {
			display : $.i18n('office.auto.model.js'),
			name : 'autoModel',
			width : '10%',
			sortable : true,
			align : 'left',
			isToggleHideShow : false
		},
		"autoPernum" : {
			display : $.i18n('office.auto.sitsum.js'),
			name : 'autoPernum',
			width : '10%',
			sortable : true,
			sortType : 'number',
			align : 'left',
			isToggleHideShow : false
		},
		"buyDate" : {
			display : $.i18n('office.auto.buyData.js'),
			name : 'buyDate',
			width : '10%',
			sortable : true,
			align : 'left',
			isToggleHideShow : false
		},
		"state" : {
			display : $.i18n('office.auto.state.js'),
			name : 'state',
			width : '10%',
			sortable : true,
			align : 'left',
			isToggleHideShow : false,
			codecfg:"codeType:'java',codeId:'com.seeyon.apps.office.constants.AutoInfoStateEnum'"
		}
	};
}

/**
 * 搜索框初始化
 * @returns
 */
function fnInitSearchBar(){
	return{
		"autoNum" :{
      	  id:'autoNum',
      	  name:'autoNum',
      	  type :'input',
      	  text :$.i18n('office.auto.autoStcInfo.cph.js'),
      	  value :'autoNum_like'
        },
        "categoryId" :{
      	  id :'categoryId',
      	  name :'categoryId',
      	  type :'select',
      	  text :$.i18n('office.auto.car.category.js'),
      	  value :'categoryId_long',
      	  items:fnCategoryItems()
        },
        "autoBrand" :{
      	  id :'autoBrand',
      	  name :'autoBrand',
      	  text :$.i18n('office.asset.apply.assetBrand.js'),
      	  type :'input',
      	  value :'autoBrand_like'
        },
        "autoModel" :{
      	  id :'autoModel',
      	  name :'autoModel',
      	  text :$.i18n('office.auto.model.js'),
      	  type :'input',
      	  value :'autoModel_like'
        },
        "buyDate" :{
      	  id :'buyDate',
      	  name :'buyDate',
      	  text :$.i18n('office.auto.buyData.js'),
      	  ifFormat:'%Y-%m-%d',
      	  type :'datemulti',
      	  value :'buyDate'
        },
        "state" :{
      	  id :'state',
      	  name :'state',
      	  text :$.i18n('office.auto.state.js'),
      	  type :'select',
      	  value :'state_int',
      	  items :[{
      		  text:$.i18n('office.auto.state0.js'),
      		  value:'0'
      	  },{
      		  text:$.i18n('office.auto.state1.js'),
      		  value:'1'
      	  },{
      		  text:$.i18n('office.auto.state2.js'),
      		  value:'2'
      	  },{
      		  text:$.i18n('office.auto.state3.js'),
      		  value:'3'
      	  }
      	  ]
        }
      };
}

function fnCategoryItems(){
	var rows =  $.parseJSON(pTemp.jval);
	var options =[];
	if(rows.length>0){
		for ( var i = 0; i < rows.length; i++) {
			options[i]= {text:rows[i].name.escapeHTML(),value:rows[i].id};
		}
		return options;
	}else{
		options[0] = {text:"",value:""};
		return options;
	}
}


