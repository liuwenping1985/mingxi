// js开始处理
$(function() {
  //searchBar
  pTemp.SBar = officeSBar("fnSBArgItem").addAll(["stockName","stockHouseId"]).init();
  //table
  pTemp.tab = officeTab().addAll([ "id","stockNum","stockName","stockTypeName","stockModel","stockPrice","stockCount","stockHouseNameTab"]).init("stockTab", {
    argFunc : "fnInfo2OtherTabItemPub",
    "managerName" : "stockUseManager",
    "managerMethod" : "findSelectStockTabList"
  });
  $('#stockTab').width("");
  pTemp.tree = fnBuildStockTree();
  pTemp.tree.reAsyncChildNodes(null, "refresh");
  if(window.parentDialogObj && window.parentDialogObj["_office_selectStock_dialog"]){
  	 pTemp.transParam = window.parentDialogObj["_office_selectStock_dialog"].getTransParams();
  }
  pTemp.layout = $('#layout').layout();
  pTemp.ajaxM = new stockUseManager();
  pTemp.tab.load();
  
});

/**
 * 构造用品分类树
 */
function fnBuildStockTree() {
  $("#stockTree").tree({
      managerName : "stockUseManager",
      managerMethod : "findSelectStockTree",
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
  return $("#stockTree").treeObj();
}

function fnTreeClk(e, treeId, node) {
	var nodeData = node.data;
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
	
	pTemp.tab.load(cnd);
}

function OK(){
	var wParam = pTemp.transParam;
	var rows =  pTemp.tab.selectRows();
	var selectHouseId = -1;
	var isAgree = false, msg = "";
	if(isAgree){
		return {error:true,msg:msg};
	}
	
	return {'rows':rows};
}

function fnSBArgItem(){
	return{
    "stockName":{
      id : 'stockName',
      name : 'stockName',
      type : 'input',
      text : $.i18n('office.stock.name.js'),
      value : 'stockName_like'
    },
    "stockHouseId":{
      id : 'stockHouseId',
      name : 'stockHouseId',
      type : 'select',
      text : $.i18n('office.stock.house.js'),
      value : 'stockHouseId_long',
      items : fnStockHouseItemPub()
    }
	}
}