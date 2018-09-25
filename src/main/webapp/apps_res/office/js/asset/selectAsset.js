// js开始处理
$(function() {
  //searchBar
  pTemp.SBar = officeSBar("fnSBArgItem").addAll(["assetHouse","assetName","assetBrand","assetModel","assetDesc"]).init();
  //table
  pTemp.tab = officeTab().addAll(["id","assetNum","assetTypeName","assetName","assetBrand","assetModel","assetDesc","currentCount","assetHouseNameTab","assetHouseManagerName"]).init("assetTab", {
    argFunc : "fnTabItem",
    "managerName" : "assetUseManager",
    "managerMethod" : "findSelectTabList"
  });
  //tree
  pTemp.tree = fnBuildAssetTree();
  pTemp.tree.reAsyncChildNodes(null, "refresh");
  if(window.parentDialogObj && window.parentDialogObj["_office_selectAsset_dialog"]){
  	 pTemp.transParam = window.parentDialogObj["_office_selectAsset_dialog"].getTransParams();
  }
  pTemp.layout = $('#layout').layout();
  pTemp.ajaxM = new assetUseManager();
  pTemp.userId = pTemp.isCarsAdmin;//直接借出选择人员
  pTemp.tab.load({userId:pTemp.userId,operate:getURLParamPub("operate")});
  
});

/**
 * 构造设备分类树
 */
function fnBuildAssetTree() {
  $("#assetTree").tree({
      managerName : "assetUseManager",
      managerMethod : "findSelectTree",
      idKey : "id",
      pIdKey : "pid",
      nameKey : "name",
      onClick : fnTreeClk,
      asyncParam : {
          pageId : 'docCenter'
      },
      nodeHandler : function(node) {
          if (node.data.pid == '-1') {
              node.isParent = true;
              node.open = true;
          }else{
          	node.isParent = false;
          }
      },
      render : function(name, data) {
          return name;
      }
  });
  return $("#assetTree").treeObj();
}

function fnTreeClk(e, treeId, node) {
	var nodeData = node.data;
	nodeData.userId = pTemp.userId;
	nodeData.operate = getURLParamPub("operate");
	pTemp.tab.load(nodeData);
}

function fnSBarQuery(cnd){
	if(cnd.condition == ''){//选中根节点
		var allNodes = pTemp.tree.getNodes();
    var nodes = pTemp.tree.transformToArray(allNodes); 
		if (nodes.length > 1) {
			pTemp.tree.selectNode(nodes[0]);
			pTemp.tree.expandNode(nodes[0],true,false);
    }
	}
	
	var selectNodes = pTemp.tree.getSelectedNodes();
	var snode = {};
	if (selectNodes.length > 0) {
		snode = selectNodes[0].data;
	}
	
	cnd.isQuery ="true";
	cnd.id = snode.id;
	cnd.pid = snode.pid;
	cnd.userId = pTemp.userId;
	cnd.operate = getURLParamPub("operate");
	pTemp.tab.load(cnd);
}

function OK(){
	var rows =  pTemp.tab.selectRows();
	return {'rows':rows};
}

function fnSBArgItem(){
	return{
	"assetHouse":{
	      id : 'assetHouse',
	      name : 'assetHouse',
	      type : 'select',
	      text : $.i18n('office.assethouse.name.js'),
	      value : 'assetHouseId_long',
	      items : fnAssetHouseItem()
	},
    "assetName":{
      id : 'assetName',
      name : 'assetName',
      type : 'input',
      text : $.i18n('office.auto.bookStcInfo.mc.js'),
      value : 'assetName_like'
    },
    "assetBrand":{
      id : 'assetBrand',
      name : 'assetBrand',
      type : 'input',
      text : $.i18n('office.asset.selectAsset.pp.js'),
      value : 'assetBrand_like'
    },
    "assetModel":{
      id : 'assetModel',
      name : 'assetModel',
      type : 'input',
      text : $.i18n('office.asset.selectAsset.xh.js'),
      value : 'assetModel_like'
    },
    "assetDesc":{
      id : 'assetDesc',
      name : 'assetDesc',
      type : 'input',
      text : $.i18n('office.asset.selectAsset.sbms.js'),
      value : 'assetDesc_like'
    }
	}
}

function fnAssetHouseItem(){
	if (pTemp.jval != '') {
		var houseItems = $.parseJSON(pTemp.jval);
		if(houseItems.length>0){
			return houseItems;
		}
	}
	return [{text:'',value:'-1'}];
}

/**
 * 申请编辑，选择设备tab的列参数
 */
function fnTabItem(){
	var tabItem = {
			"id" : {
        display : 'id',
        name : 'id',
        width : 20,
        sortable : false,
        align : 'center',
        type : 'radio'
    },
    "assetNum" : {
	       display : $.i18n('office.asset.selectAsset.sbbh.js'),
	       name : 'assetNum',
	       width : '60',
	       sortable : true,
	       align : 'left'
	   },
	   "assetTypeName" : {
	       display : $.i18n('office.asset.selectAsset.sbfl.js'),
	       name : 'assetTypeName',
	       width : '60',
	       sortable : true,
	       align : 'left'
	   },
	   "assetName" : {
	     display : $.i18n('office.auto.bookStcInfo.mc.js'),
	     name : 'assetName',
	     width : '80',
	     sortable : true,
	     align : 'left'
	   },
	   "assetBrand" : {
	     display : $.i18n('office.asset.selectAsset.pp.js'),
	     name : 'assetBrand',
	     width : '70',
	     sortable : true,
	     align : 'left'
	   },
	   "assetModel" : {
	     display : $.i18n('office.asset.selectAsset.xh.js'),
	     name : 'assetModel',
	     width : 80,
	     sortable : true,
	     align : 'left'
	   },
	   "assetDesc" : {
	     display : $.i18n('office.asset.selectAsset.sbms.js'),
	     name : 'assetDesc',
	     width : 90,
	     sortable : true,
	     align : 'left'
	   },
	   "currentCount" : {
	     display : $.i18n('office.asset.selectAsset.dqkc.js'),
	     name : 'currentCount',
	     width : 50,
	     sortorder:'desc',
	     sortType :'number',
	     sortable : true,
	     align : 'right'
	   },
	   "assetHouseNameTab" : {
	     display : $.i18n('office.asset.selectAsset.sbk.js'),
	     name : 'assetHouseNameTab',
	     width : 100,
	     sortable : true,
	     align : 'left'
	   },
	   "assetHouseManagerName" : {
	     display : $.i18n('office.asset.selectAsset.gly.js'),
	     name : 'assetHouseManagerName',
	     width : 120,
	     sortable : true,
	     align : 'left'
	   }
	 }
	 return tabItem;
}