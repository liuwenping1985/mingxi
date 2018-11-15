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
        	<c:if test="${param.type eq 'showAll'}">
	    	  selectColumn();
        	</c:if>
        	<c:if test="${param.type ne 'showAll'}">
        	removeColumn();
        	</c:if>
	     },
        nodeHandler : function(n) {
          <c:if test = "${issearch}">
            n.open = true;
           </c:if>
           if(n.data.canSelecte != "true"){
               n.isParent = true;
           }
        }
    });
});
function moveColumn(type){
    var treeObj=$("#formColumnTree").treeObj();
    var nodes2 = treeObj.getSelectedNodes()[0];
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

function selectColumn(){
    var treeObj=$("#formColumnTree").treeObj();
    var currentNode = treeObj.getSelectedNodes()[0];
    if(!currentNode){
        return;
    }
    parent.addTemplate(currentNode);
}

function addNode(node){
    var treeObj=$("#formColumnTree").treeObj();
    
    if(node.isParent){
    	addSubNode(null,node.children);
    }else{
    	if(!isExist(node) && node.data.canSelecte=="true"){
	    	treeObj.addNodes(null,node);
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
    treeObj.removeNode(treeObj.getSelectedNodes()[0]);
}

function getAllValue(){
    var value = "";
    var name = "";
    var obj = $("#formColumnTree").treeObj().getNodes();
    <c:set var="msg" value="${ctp:i18n('formsection.config.choose.template.length')}" /> 
    if(obj.length>15){
      $.alert('${msg}'+obj.length + " !");
      return "length";
    }
    for(var i=0;i<obj.length;i++){
        value=value+obj[i].data.value+",";
        name=name+obj[i].data.name+",";
    }
    if(value===""){
        return "must";
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