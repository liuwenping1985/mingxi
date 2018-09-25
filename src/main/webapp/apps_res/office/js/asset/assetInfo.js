$(function() {
	pTemp.ajaxM = new assetInfoManager();
    pTemp.TBar = officeTBar().addAll([ "reg", "edit","imp2exp","del" ]).init("toolbar");
    pTemp.SBar = officeSBar("fnInitSearchBar").addAll(["assetNum","assetType","assetName","assetBrand","buyDate"]).init();
    pTemp.tab = officeTab().addAll([ "id", "assetNum","assetTypeName","assetName","assetBrand","assetModel","buyDate","currentCount","assetHouseName","state"]).init("assetInfo", {
        	argFunc : "fnassetInfoItems",
	        parentId : $('.layout_center').eq(0).attr('id'),
	        slideToggleBtn : true,
	        resizable : true,
	        "managerName" : "assetInfoManager",
	        "managerMethod" : "find"
    });
    pTemp.condition= "";
    pTemp.selectedTreeId = "";
    pTemp.editIframe = $("#editIframe");
    pTemp.cPage = pTemp.editIframe[0].contentWindow;
    pTemp.tab.load();
    fnInitAssetTree();
});

function fnReg(){
    fnShowDetail('add');
}


function fnPageInIt() {
}

function fnPageReload() {
	pTemp.tab.load();
}

function fnSetCss() {
}

function fnTabClk() {
    fnShowDetail('view');
}

function fnTabDBClk() {
    fnShowDetail('modify');
}

function fnNew() {
    fnShowDetail('add');
}

function fnEdit() {
    fnShowDetail('modify');
}

/**
 * 【导入】
 */
function fnImp(){
	var importDialog = $.dialog({
		id: 'imp',
	    url: _path+"/office/assetSet.do?method=importAssetInfo",
	    width: 420,
	    height: 180,
	    title: $.i18n('office.assetinfo.fileupload.js'),
	    targetWindow : getCtpTop(),
	    closeParam:{'show':true,handler:function(){
	    	pTemp.tab.load();
	    }} 
	}); 
	
} 

function fnImpCall(file){
	var fileUrl = file.get(0).fileUrl;
	$("#expOrImp").jsonSubmit({
		action:_path+"/office/assetSet.do?method=importAutoInfo&fileUrl="+fileUrl,
		callback:function(rval){
			
		}
	});
	
}
/**
 * 【导出】
 */
function fnExp(){
	//查询条件
	var condition = pTemp.condition ;
	var value = pTemp.value ;
	//选择的数据
	var selectIds = pTemp.tab.selectRowIds();
	
	var selectType = pTemp.selectedTreeId;
	$("#expOrImp").jsonSubmit({
		action:_path+"/office/assetSet.do?method=exportAssetInfo&con="+condition+"&val="+value+"&ids="+selectIds+"&type="+selectType,
		callback:function(rval){}
	});
}

/**
 * 【下载模板】
 */
function fnDow(){
	$("#expOrImp").jsonSubmit({
		action:_path+"/office/assetSet.do?method=exportAssetInfo&dow=dowloadTemplete",
		callback:function(rval){}
	});
}


function fnShowDetail(mode) {
    var rows = pTemp.tab.selectRows();
    if (mode === 'modify') {
        if (rows.length == 0) {
            $.alert($.i18n('office.assetinfo.modfiy.js'));
            return;
        } else if (rows.length > 1) {
            $.alert($.i18n('office.auto.onlyone.edit.js'));
            return;
        }
    }
    pTemp.tab.reSize('m');
    if(!pTemp.cPage || !pTemp.cPage.fnPageReload){//快速点击报错
    	return;
    }
    pTemp.cPage.fnPageReload({
        "mode" : mode,
        "row" : rows[0],
        "selectedTreeId":pTemp.selectedTreeId
    });
}

function fnDel() {
    var rowIds = pTemp.tab.selectRowIds();
    if (rowIds.length == 0) {
        $.alert($.i18n('office.assetinfo.delete.js'));
        return;
    }
    var canDel = pTemp.ajaxM.findAssetInfoByUse(rowIds);
    if(canDel  == false){
    	fnRealDel(rowIds);
    }else{
        $.infor({
        		'type': 2,
        	    'msg': $.i18n('office.assetinfo.cannot.delete.js'),
        	    'imgType':2
        });
    }
}

function fnRealDel(rowIds){
	 $.confirm({
        'msg' : $.i18n('office.auto.really.delete.js'),
        ok_fn : function() {
            pTemp.ajaxM.deleteByIds(rowIds, {
                success : function() {
                    $.infor($.i18n('office.auto.delsuccess.js'));
                    pTemp.tab.load();
                    fnNew();
                    fnShowDetail('view');
                    pTemp.tab.reSize('d');
                }
            });
        }
    });
}

/**
 * 初始化设备分类树
 */
function fnInitAssetTree(){
	$("#assetTypeTree").tree({
		idKey: "id",
		pIdKey: "pid",
		nameKey: "name",
		managerName : "assetInfoManager",
	    managerMethod : "getAssetTypeTree",
	    onClick: fnTreeClk,
	    nodeHandler: function(n) {
	    	n.open = true;
	    }
	});
	$("#assetTypeTree").treeObj().reAsyncChildNodes(null, "refresh");
}

/**
 * 树的点击事件
 * @param e
 * @param treeId
 * @param node
 */
function fnTreeClk(e, treeId, node) {
	//记录下当前选择的分类，登记的时候默认该分类
	pTemp.selectedTreeId = node.data.id;
	var nodeData = node.data;
	pTemp.tab.load(nodeData);
	pTemp.tab.reSize('d');
}

/**
 * 查询
 */
function fnSBarQuery(obj){
	//查询的时候，记录下查询条件，供导出用
	pTemp.condition = obj.condition;
	pTemp.value = obj.value;
	pTemp.tab.load(obj);
}


/**
 * 搜索框初始化
 * @returns
 */
function fnInitSearchBar(){
    return {
		  "assetNum" : {
		       id : 'assetNum',
		       name : 'assetNum',
		       type : 'input',
		       text : $.i18n('office.assetinfo.num.js'),
		       value : 'assetNum_like'
		  },
		  "assetType" : {
		      id : 'assetType',
		      name : 'assetType',
		      type : 'select',
		      text : $.i18n('office.assetinfo.type.js'),
		      value : 'assetType',
		      items:fnAssetType()
		 },
		 "assetName" : {
		     id : 'assetName',
		     name : 'assetName',
		     type : 'input',
		     text : $.i18n('office.assetinfo.name.js'),
		     value : 'assetName_like'
		 },
		 "assetBrand" : {
		     id : 'assetBrand',
		     name : 'assetBrand',
		     type : 'input',
		     text : $.i18n('office.assetinfo.brand.js'),
		     value : 'assetBrand_like'
		 },
		 "buyDate" :{
	      	  id :'buyDate',
	      	  name :'buyDate',
	      	  text :$.i18n('office.assetinfo.buydata.js'),
	      	  ifFormat:'%Y-%m-%d',
	      	  type :'datemulti',
	      	  value :'buyDate'
		 }
    }
}

/**
 * 初始化搜索用设备分类
 * @returns {Array}
 */
function fnAssetType(){
	var rows = pTemp.ajaxM.getAssetType();
	var options = [];
	if(rows.length>0){
		var j = 0;
		for ( var i = 0; i < rows.length; i++) {
			if(rows[i].outputSwitch == 1){  //查询的时候，要过滤掉不能查询的枚举
				options[j]= {text:rows[i].showvalue,value:rows[i].enumvalue};
				j = j+1;
			}
		}
	}
	if(!options.length>0){
		options[0] = {text:"",value:""};
		return options;
	}else{
		return options;
	}
}

function fnassetInfoItems(){
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
        "assetNum" : {
            display : $.i18n('office.assetinfo.num.js'),
            name : 'assetNum',
            width : '12%',
            sortable : true,
            align : 'left',
            isToggleHideShow : false
        },
        "assetTypeName" : {
            display : $.i18n('office.assetinfo.type.js'),
            name : 'assetTypeName',
            width : '10%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        },
        "assetName" : {
            display : $.i18n('office.assetinfo.name.js'),
            name : 'assetName',
            width : '12%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        },
        "assetBrand" : {
            display : $.i18n('office.assetinfo.brand.js'),
            name : 'assetBrand',
            width : '10%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        },
        "assetModel" : {
            display : $.i18n('office.assetinfo.model.js'),
            name : 'assetModel',
            width : '10%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        },
        "assetHouseName" : {
            display : $.i18n('office.assetinfo.assethouse.js'),
            name : 'assetHouseName',
            width : '10%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        },
        "buyDate" : {
            display : $.i18n('office.assetinfo.buydata.js'),
            name : 'buyDate',
            width : '10%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        },
        "currentCount" : {
            display : $.i18n('office.assetinfo.currentCount.js'),
            name : 'currentCount',
            width : '10%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true
        },
        "state" : {
            display : $.i18n('office.assetinfo.state.js'),
            name : 'state',
            width : '10%',
            sortable : true,
            align : 'left',
            isToggleHideShow : true,
			codecfg:"codeType:'java',codeId:'com.seeyon.apps.office.constants.AssetInfoStateEnum'"
        }
    }
}
