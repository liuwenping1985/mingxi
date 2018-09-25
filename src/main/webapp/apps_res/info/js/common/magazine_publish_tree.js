
var isLoadTree = false;

function initPublishDestTree() {
	//单位树初始化
	$("#UnitSectionTree").tree({
		idKey : "id",
		pIdKey : "parentId",
		nameKey : "sectionName",
		pidTypeKey:"parentTypeId",
		onDblClick : _selectNode,
		onClick : _clkNode,
		nodeHandler: function(n) {
			if(n.data.icon){
				n.isParent = true;
	        }
	        if(n.data.parentId){
	        	n.open = false;
	        }else{
	        	n.open = true;
	        }
		}
	});
    //单位已选项
    $("#UnitSelectedTree").tree({
    	idKey : "id",
    	pIdKey : "parentId",
    	nameKey : "sectionName",
    	title : "title",
    	pidTypeKey:"parentTypeId",
    	onDblClick : _removeNode,
    	showTitle : true,
    	nodeHandler: function(n) {
    		n.open = false;
    	}
    });
    
    //组织树初始化
    $("#OrgSectionTree").tree({
    	idKey : "id",
    	pIdKey : "parentId",
    	title : "title",
    	nameKey : "sectionName",
    	pidTypeKey:"parentTypeId",
    	onDblClick : _selectNode,
    	onClick : _clkNode,
    	nodeHandler: function(n) {
	        if(n.data.icon){
	          n.isParent = true;
	        }
	        if(n.data.parentId){
	        	n.open = false;
	        }else{
	        	n.open = true;
	        }
    	}
    });
    //组织树已选项
    $("#OrgSelectedTree").tree({
    	idKey : "id",
    	pIdKey : "parentId",
    	nameKey : "sectionName",
    	title : "title",
    	pidTypeKey:"parentTypeId",
    	onDblClick : _removeNode,
    	showTitle : true,
    	nodeHandler: function(n) {
    		n.open = false;
    	}
    });
    
    //栏目初始化
    showOrgTreeData();
    showUnitTreeData();
    initPublishTreeClick();
}

//显示组织公告/新闻版块
function showOrgTreeData(){
	var params = new Object();
	params['sectionType']="Org";
	params['openFromType']=openFromType;
	new infoMagazineManager().pubBulTypeList(params,{
		success : function(data) {
			var setting = $("#OrgSectionTree").treeObj().setting;
			setting.callback.beforeExpand = _beforeExpand;
			$.fn.zTree.init($("#OrgSectionTree"), setting, data);
			var nodes = $("#OrgSectionTree").treeObj().getNodes();
			initOrgTreeSelected(data);
		}
	});
}

//显示单位公告/新闻版块
function showUnitTreeData(){
	var params = new Object();
	params['sectionType']="Unit";
	params['openFromType']=openFromType;
	new infoMagazineManager().pubBulTypeList(params,{
		success : function(data){
			var setting = $("#UnitSectionTree").treeObj().setting;
			setting.callback.beforeExpand = _beforeExpand;
			$.fn.zTree.init($("#UnitSectionTree"), setting, data);
			initUnitTreeSelected(data);
			isLoadTree = true;
		}
	});
}

//组织/单位公告/新闻版块点击事件
function _clkNode(event, treeId, treeNode){
	if(treeNode.data.async == false){
		var params = new Object();
		new infoMagazineManager().pubBulTypeList({
			success : function(data){
				$("#UnitSectionTree").treeObj().removeChildNodes(treeNode);
			    $("#UnitSectionTree").treeObj().addNodes(treeNode, data);
			}
		});
	}
}

function _beforeExpand(treeId,treeNode){
	if(treeNode.data.async == false){
		var params = new Object();
		new infoMagazineManager().pubBulTypeList({
		    success : function(data){
		        $("#UnitSectionTree").treeObj().removeChildNodes(treeNode);
		        $("#UnitSectionTree").treeObj().addNodes(treeNode, data);
		    }
		});
	}
}

//
function _selectNode() {
	var treeNodes;
	var selectedNodes;
	var selectedTreeObj;
	var typeValue = $("#tabs_head").find("li.current").find("a").attr("value");
	if(typeValue == "1") {//单位公告/新闻版块
		treeNodes = $("#UnitSectionTree").treeObj().getSelectedNodes();
		selectedTreeObj = $("#UnitSelectedTree").treeObj();
		selectedNodes = selectedTreeObj.getNodes();
	}else{//组织公告/新闻版块
		treeNodes = $("#OrgSectionTree").treeObj().getSelectedNodes();
		selectedTreeObj = $("#OrgSelectedTree").treeObj();
		selectedNodes = selectedTreeObj.getNodes();
	}
	if(treeNodes) {
		for (var i=0; i<treeNodes.length; i++) {
			if(!treeNodes[i]) {
				continue;
			}
			var newNode = treeNodes[i];
	        var newNodeData = newNode.data;
	        /**根节点不可以选择**/
	        if(newNodeData.parentId==0){
	        	alert("选择具体的板块！");
	        	return ;
	        }
	       /**循环遍历已选值*/
	        for (var i=0; i<selectedNodes.length; i++) {
	        	 var selectedNode = selectedNodes[i];
	        	 if(!selectedNode) {
	        		 continue;
	        	 }
	        	 var selectedNodeData = selectedNode.data;
	        	 if(newNodeData.id==selectedNodeData.id 
	        			 && newNodeData.parentId==selectedNodeData.parentId 
	        			 && newNodeData.parentTypeId==selectedNodeData.parentTypeId) {
	        		 alert("不能选择重复项！");
	        		 return ;
	        	 }
	        }
	        /**遍历后台其它单位是否已绑定了发布范围**/
	        if(openFromType=="0" && bindPublishRange!=null && bindPublishRange!="") {
	        	var myCheckFlag = false;
	        	if(oldPublishToPublicRangeIds != "") {
					var myPublicPublishRange = oldPublishToPublicRangeIds.split(",");
					if(myPublicPublishRange && myPublicPublishRange.length > 0) {
						for(var k=0; k<myPublicPublishRange.length; k++) {
							var myRangeIds = myPublicPublishRange[k].split("|");
							if(newNodeData.id==myRangeIds[1]) {
		    					myCheckFlag = (myRangeIds[0]=="1" && newNodeData.parentTypeId=="1")
		    					|| (myRangeIds[0]=="2" && newNodeData.parentTypeId=="2")
		    					|| (myRangeIds[0]=="3" && newNodeData.parentTypeId=="1")
		    					|| (myRangeIds[0]=="4" && newNodeData.parentTypeId=="2");
		    					if(myCheckFlag) {
		    						break;
		    					}
							}
						}
					}
				}
	        	
	        	if(!myCheckFlag) {
		        	var publishRange = bindPublishRange.split(",");
		        	for(var k=0;k<publishRange.length;k++) {
		        		var rangeIds = publishRange[k].split("|");
		        		if(rangeIds.length > 1) {
		        			if(newNodeData.id==rangeIds[1]) {
		        				var checkFlag = (rangeIds[0]=="1" && newNodeData.parentTypeId=="1")
		        					|| (rangeIds[0]=="2" && newNodeData.parentTypeId=="2")
		        					|| (rangeIds[0]=="3" && newNodeData.parentTypeId=="1")
		        					|| (rangeIds[0]=="4" && newNodeData.parentTypeId=="2");
		        				if(checkFlag) {
		        					alert($.i18n('infosend.score.alert.repeatBindRange', rangeIds[2], rangeIds[3]));
	        						//alert("其它评分已绑定，不能重复选择！");
		        					return;
		        				}
		        			}
		        		}
		        	}
	        	}
	        }
	        selectedTreeObj.addNodes(null, newNode);
        	selectedNodes = selectedTreeObj.getNodes();
        	for(var i=selectedNodes.length-1; i>=0; i--) {
        		var selectedNode = selectedNodes[i];
	        	 if(!selectedNode) {
	        		 continue;
	        	 }
	        	 if(i == selectedNodes.length-1) {
	        		 var selectedNodeData = selectedNode.data;
	        		 if(newNodeData.id==selectedNodeData.id) {
	        			 selectedNodeData.parentId = newNodeData.parentId;
		        		 selectedNodeData.parentTypeId = newNodeData.parentTypeId;
		        		 break;
		        	 }
	        	 }
        	}
		}//treeNodes form
	}//treeNodes !=null
}

function _removeNode(){
	var treeObj=null;
	var typeValue = $("#tabs_head").find("li.current").find("a").attr("value");
	if(typeValue == "1"){
		treeObj = $("#UnitSelectedTree").treeObj();
	}else{
		treeObj = $("#OrgSelectedTree").treeObj();
	}
	var nodes = treeObj.getSelectedNodes();
	if(nodes) {
		var moveNode;
	    for (var i=0; i < nodes.length; i++) {
	    	moveNode = nodes[i];
	    	moveNode.data = nodes[i].data;
	    	treeObj.removeNode(nodes[i]);
	    }
	    if(!moveNode) {
	    	return;
	    }
	    var moveNodeData = moveNode.data.data;
	    var oldNodes = treeObj.getNodes();
	    var newNodes = [];	    
	    var len = 0;
	    for(var i=0; i<oldNodes.length; i++) {
	    	var oldNodeData = oldNodes[i].data;
	    	if(moveNodeData.id==oldNodeData.id && moveNodeData.parentTypeId==oldNodeData.parentTypeId) {
	    	} else {
	    		newNodes[len] = oldNodes[i];
	    		newNodes[len].data = oldNodes[i].data;
	    		newNodes[len].data.id = oldNodes[i].data.id;
	    		newNodes[len].data.parentId = oldNodes[i].data.parentId;
	    		newNodes[len].data.parentTypeId = oldNodes[i].data.parentTypeId;
	    		treeObj.getNodes()[len] = newNodes[len];
	    		len++;
	    	}
	    }
	    treeObj.getNodes().length = len;
	}
}

function initPublishTreeClick() {
	//添加项
 	$(".add").click(function(){
 		var newItem=$(".newItem").eq(0).clone(true).removeClass("hidden");
 		$(".fieldset_edit").eq(0).before(newItem);
 	});
 	//删除项 
 	$(".remove").click(function(){
 		var removeItem=$(".newItem").length;
 		if(removeItem!=1) $(".newItem").eq(removeItem-1).remove();	  
 	});
}

function initOrgTreeSelected(data) {
	if(publishToPublicRangeIds != "") {
		var OrgSelectedNodes = [];
		var rangeIds = publishToPublicRangeIds.split(",");
		var rangeNames = publishToPublicRangeNames.split("、");
		for(var i=0; i<rangeIds.length; i++) {
			var rangeId = rangeIds[i].split("|");
			var parentTypeId = 1;
			if(rangeId[0] == "2") {
				parentTypeId = 2;
			}
			if(rangeId[0] == "1" || rangeId[0] == "2") {//3组织公告 4组织新闻
				var newNode;
				if(data.length > 0) {
					for(var j=0; j<data.length; j++) {
						if(rangeId[1] == data[j].id && parentTypeId == data[j].parentTypeId) {
							newNode = new Object();
							newNode.data = data[j];
							newNode.data.id = data[j].id;							
							break;
						}
					}
				}
				if(!newNode) {
					continue;
				}
				newNode.id = newNode.data.id;
				if(rangeId[0] == "1") {//公告
					newNode.data.parentTypeId = 1;
					newNode.data.parentId = 10;
				} else {//新闻
					newNode.data.parentTypeId = 2;
					newNode.data.parentId = 11;
				}
				if(rangeNames[i] && rangeNames[i] != "") {
					newNode.sectionName = rangeNames[i].substring(6, rangeNames[i].length);
				}
				OrgSelectedNodes[OrgSelectedNodes.length] = newNode;
			}
		}
		if(OrgSelectedNodes.length > 0) {
			var selectedTreeObj = $("#OrgSelectedTree").treeObj();
			selectedTreeObj.addNodes(null, OrgSelectedNodes);
			reloadSelectedTree(OrgSelectedNodes, selectedTreeObj);
		}
	}
}

function initUnitTreeSelected(data) {
	if(publishToPublicRangeIds != "") {
		var UnitSelectedNodes = [];
		var rangeIds = publishToPublicRangeIds.split(",");
		var rangeNames = publishToPublicRangeNames.split("、");
		for(var i=0; i<rangeIds.length; i++) {
			var rangeId = rangeIds[i].split("|");
			var parentTypeId = 1;
			if(rangeId[0] == "4") {
				parentTypeId = 2;
			}
			if(rangeId[0] == "3" || rangeId[0] == "4") {//3单位公告 4单位新闻
				var newNode;
				if(data.length > 0) {
					for(var j=0; j<data.length; j++) {
						if(rangeId[1] == data[j].id && parentTypeId == data[j].parentTypeId) {
							newNode = new Object();
							newNode.data = data[j];
							newNode.data.id = data[j].id;
							break;
						}
					}
				}
				if(!newNode) {
					continue;
				}
				newNode.id = newNode.data.id;
				if(rangeId[0] == "3") {//公告
					newNode.data.parentTypeId = 1;
					newNode.data.parentId = 10;
				} else {//新闻
					newNode.data.parentTypeId = 2;
					newNode.data.parentId = 11;
				}
				if(rangeNames[i] && rangeNames[i] != "") {
					newNode.sectionName = rangeNames[i].substring(6, rangeNames[i].length);
				}
				UnitSelectedNodes[UnitSelectedNodes.length] = newNode;
			}
		}
		if(UnitSelectedNodes.length > 0) {
			var selectedTreeObj = $("#UnitSelectedTree").treeObj();
			selectedTreeObj.addNodes(null, UnitSelectedNodes);
			reloadSelectedTree(UnitSelectedNodes, selectedTreeObj);
		}
	}
}

function reloadSelectedTree(selectedNodes, selectedTree) {
	var selectNodes = selectedTree.getNodes();
    for(var i=0; i<selectNodes.length; i++) {
    	selectNodes[i] = selectedNodes[i];
    }
}
