<%--
 $Author:  $
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<script type="text/javascript">
$(document).ready(function(){
    $("#formColumnTree").tree({
        idKey : "value",
        pIdKey : "parentValue",
        nameKey : "name",
        onDblClick : function() {
        	<c:if test = "${param.canedit ne 'false' }">
        	<c:if test="${param.type eq 'showAll'}">
	    	  selectColumn();
        	</c:if>
        	<c:if test="${param.type ne 'showAll'}">
        	removeColumn();
        	</c:if>
        	</c:if>
	     },
        nodeHandler : function(n) {
            n.open = true;
        }
    });
    <c:if test ="${param.needRefresh eq 'true'}">
    selectColumn(true);
    </c:if>
});
function moveColumn(type){
    var treeObj=$("#formColumnTree").treeObj();
    var nodes2 = treeObj.getSelectedNodes()[0];
    if(!nodes2){
      return;
    }
    if(type=="next"){
        nodes2 = nodes2.getNextNode();
    }
    if(nodes2 && nodes2 != null){
        var nodes = nodes2.getPreNode();
        if(nodes && nodes != null){
            treeObj.moveNode(nodes, nodes2, "prev");
        } 
    }
}

function selectColumn(obj){
    var treeObj=$("#formColumnTree").treeObj();
    var currentNode = treeObj.getSelectedNodes()[0];
    if (obj){
      currentNode = treeObj.getNodesByParam("value","7")[0];
    }
    if(!currentNode){
        return;
    }
    if(currentNode.data.canSelecte == true){
	    var parentNode = currentNode.getParentNode();
	    <c:if test = "${param.MountType eq 'column' }">
	    parent.selectColumnsIFrame.addNode(parentNode,currentNode,true);
      </c:if>
	    <c:if test = "${param.MountType ne 'column' }">
	    parent.addNode(parentNode,currentNode,true);
      </c:if>
    }
}

function addNode(parentNode,node,needChiled){
    var treeObj=$("#formColumnTree").treeObj();
    if(!isExist(parentNode)){
        addNode(parentNode.getParentNode(),parentNode,false);
    }
    if(parentNode.data.value == 0){
        parentNode = treeObj.getNodes()[0]; 
        if(!isExist(node)){
            treeObj.addNodes(parentNode,node);
        }
        if(node.isParent){
        	var temp = treeObj.getNodesByParam("value",node.data.value)[0];
        	if (needChiled){
        	addSubNode(temp,node.children);
        	}
        }
    }else{
        if(!isExist(node)){
            parentNode = treeObj.getNodesByParam("value",parentNode.data.value)[0];
            treeObj.addNodes(parentNode,node);
        }
    }
}

function addSubNode(parentNode,subNodes){
	if(!subNodes){
		return;
	}
	var treeObj=$("#formColumnTree").treeObj();
	for(var i=0;i<subNodes.length;i++){
		if(!isExist(subNodes[i])){
			treeObj.addNodes(parentNode,subNodes[i]);
		}
	}
}

function isExist(node){
    var treeObj=$("#formColumnTree").treeObj();
    var obj = treeObj.getNodesByParam("value",node.data.value);
    if(obj.length==0){
        return false;
    }
    return true;
}

function removeColumn(){
    var treeObj=$("#formColumnTree").treeObj();
    var selectNode = treeObj.getSelectedNodes()[0];
    if(selectNode){
	    if(selectNode.value != 0){
		    treeObj.removeNode(treeObj.getSelectedNodes()[0]);
	    }
    }
}

function getAllItenValue(parentNode){
    if(parentNode==null){
        parentNode = $("#formColumnTree").treeObj().getNodes()[0];
    }
    
    var obj = parentNode.children;
    var value = "";
    if(!obj){
      return value;
    }
    for(var i=0;i<obj.length;i++){
        if(obj[i].isParent){
            value=value+obj[i].data.parentValue+"|"+obj[i].data.value+",";
            value = value + getAllItenValue(obj[i])+",";
        }else{
        	value=value+obj[i].data.parentValue+"|"+obj[i].data.value+",";
        }
    }
    return value.substring(0,value.length-1);
}

function getAllValue(){
    var value = "";
    var name = "";
    var obj = $("#formColumnTree").treeObj().getNodes();
    for(var i=0;i<obj.length;i++){
        value=value+obj[i].data.value+",";
        name=name+obj[i].data.name+",";
    }
    if(value===""){
        return null;
    }
    var o = new Object();
    o.value = value.substring(0,value.length-1);
    o.name = name.substring(0,name.length-1);
    return o;
}
</script>
</head>
<body>
    <div id="formColumnTree"></div>
</body>
</html>