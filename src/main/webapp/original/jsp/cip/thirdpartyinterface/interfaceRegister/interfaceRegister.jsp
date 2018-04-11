<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=interfaceRegisterManager"></script>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=localAgentManager"></script>
<script type="text/javascript"
	src="${path}/thirdpartyinterface/js/jquery-form.js"></script>
<script type="text/javascript">
var treeObj;
var inputId;
var nodeChildrenIds = "-1";
$(document).ready(function() {
	initTree();
    initToolbar();
    initSearchObj();
    initGrid();	
	$("#registerForm").hide();
	//$("#addForm").disable();
	$("#button").hide();
});
/**
 *获取位置,返回位置对象，如：{left:23,top:32}
 */
function getElementPos(el) {
    var ua = navigator.userAgent.toLowerCase();
    if (el.parentNode === null || el.style.display == 'none') {
        return false;
    }
    var parent = null;
    var pos = [];
    var box;
    if (el.getBoundingClientRect) {//IE，google
        box = el.getBoundingClientRect();
        var scrollTop = document.documentElement.scrollTop;
        var scrollLeft = document.documentElement.scrollLeft;
        if(navigator.appName.toLowerCase()=="netscape"){//google
        	scrollTop = Math.max(scrollTop, document.body.scrollTop);
        	scrollLeft = Math.max(scrollLeft, document.body.scrollLeft);
        }
        return { left : box.left + scrollLeft, top : box.top + scrollTop };
    } else if (document.getBoxObjectFor) {// gecko
        box = document.getBoxObjectFor(el);
        var borderLeft = (el.style.borderLeftWidth) ? parseInt(el.style.borderLeftWidth) : 0;
        var borderTop = (el.style.borderTopWidth) ? parseInt(el.style.borderTopWidth) : 0;
        pos = [ box.x - borderLeft, box.y - borderTop ];
    } else {// safari & opera
        pos = [ el.offsetLeft, el.offsetTop ];
        parent = el.offsetParent;
        if (parent != el) {
            while (parent) {
                pos[0] += parent.offsetLeft;
                pos[1] += parent.offsetTop;
                parent = parent.offsetParent;
            }
        }
        if (ua.indexOf('opera') != -1 || (ua.indexOf('safari') != -1 && el.style.position == 'absolute')) {
            pos[0] -= document.body.offsetLeft;
            pos[1] -= document.body.offsetTop;
        }
    }
    if (el.parentNode) {
        parent = el.parentNode;
    } else {
        parent = null;
    }
    while (parent && parent.tagName != 'BODY' && parent.tagName != 'HTML') { // account for any scrolled ancestors
        pos[0] -= parent.scrollLeft;
        pos[1] -= parent.scrollTop;
        if (parent.parentNode) {
            parent = parent.parentNode;
        } else {
            parent = null;
        }
    }
    return {
        left : pos[0],
        top : pos[1]
    };
}
function showResource(){
	var product_flag = $("#product_flag").val();
	var dialog = $.dialog({
           url:"${path}/cip/thirdpartyinterface/interface.do?method=resourceList&product_flag="+encodeURI(product_flag),
           width: 900,
           height: 450,
           title: "${ctp:i18n('cip.interface.lab.resourcelist')}",
           buttons: [{
               text: "${ctp:i18n('common.button.ok.label')}", 
               isEmphasize: true,
               handler: function () {
                  var rv = dialog.getReturnValue();
                  if(rv == ""){
           		   	$.alert("${ctp:i18n('cip.extendedresource.msg.tip5')}");
           		   	return;
           	   	  }
                  var erm = new extendedResourceManager();
              	  var codes = erm.findResourceCodesByIds(rv);
                  var newHtml = "<span id=\"resourceSpan\" title=\""+codes+"\" "+
                  	"style=\"max-width: 370px;\">"+codes+"</span><em class=\"ico16 "+
                  	"affix_del_16\" onclick=\"clearSpan();\"></em>";
                  $("#resourceLi").html(newHtml);
                  $("#resourcePackageIds").val(rv);
           	   	  dialog.close();
               }
           }, {
               text: "${ctp:i18n('common.button.cancel.label')}",
               handler: function () {
            	   dialog.close();
               }
           }]
   });
}
function befFillUp(id){
	inputId = id;
}
function fillUpCallBk(filemsg){
	if(filemsg.instance!=null && filemsg.instance.length>0){
		var fileId = filemsg.instance[0].fileUrl;
		var fileName = filemsg.instance[0].filename;
		if(fileName.length > 25){
			$.alert("${ctp:i18n('cip.scheme.param.config.namelen')}");
			return
		}else{
			$("#tab" + inputId).attr("title",fileName);
			if(fileName.length > 7){
				$("#tab" + inputId).html(""+fileName.substring(0,7) + "...");
			}else{
				$("#tab" + inputId).html(""+fileName);
			}
			$("#fileName" + inputId).val(fileName);
			$("#fileId" + inputId).val(fileId);
			//var irm = new interfaceRegisterManager();
			//irm.copyFile(fileId,fileId);
		}
	}
}
/**
 * 初始化接口分类树
 */
function initTree() {
    var $interfaceTree = $("#interfaceTree");
    $interfaceTree.tree({
        idKey: "id",
        pIdKey: "parentId",
        nameKey: "name",
        managerName: "interfaceRegisterManager",
        managerMethod: "getInterfaceTree",
        onClick: nodeClk,
        nodeHandler: function (n) {
            n.open = true;
            if(n.data.type == "1" || n.data.type == "2"){
				n.open = false;
			}
        }
    });
    $interfaceTree.empty();
    $interfaceTree.treeObj().reAsyncChildNodes(null, "refresh");
}
function cancelSub(){
	$("#registerForm").hide();
	$("#button").hide();
    gridObj.grid.resizeGridUpDown('down');
}
function checkSub(){
	if(!($("#registerForm").validate())){		
        return;
    }
	var trList = $("#mobody").children("tr")
	var map = [];
    for (var i=0;i<trList.length;i++) {
      var tdArr = trList.eq(i).find("td");
      var no = tdArr.eq(0).find("input").val();
      var des = tdArr.eq(1).find("input").val();
      var id = tdArr.eq(2).find("input").eq(1).val();
      var name = tdArr.eq(2).find("input").eq(0).val();
      var json = {"no":no,"des":des,"id":id,"name":name};
      map.push(json);
    }
	var irm = new interfaceRegisterManager();
    if($("#masterId").val() != ""){
        var formsubmit = {"masterId":$("#masterId").val(),"product_flag":$("#product_flag").val(),"typeName":$("#typeName").val(),
    			"Category_id":$("#Category_id").val(),"Interface_name":$("#Interface_name").val(),
    			"Interface_des":$("#Interface_des").val(),"System_constraint":$("#System_constraint").val(),
    			"business_constraint":$("#business_constraint").val(),"Call_des":$("#Call_des").val(),
    			"Scene_des":$("#Scene_des").val(),"resourcePackage":$("#resourcePackageIds").val(),"productId":$("#productId").val(), "Scene_map":map};
    	irm.updateInterfaceRegister(formsubmit, {
            success: function(rel) {
    			if(rel == "success"){
    			    var o = {};
            		var manager = new localAgentManager();
            	    var ids = manager.getConditionStr($("#masterId").val());
            		o.treeValue = ids;
    				var $interface = $("#interface");
    			    $interface.ajaxgridLoad(o);
        			$("#registerForm").hide();
        			$("#button").hide();
        		    gridObj.grid.resizeGridUpDown('down');
    			}else if(rel == "error"){
    				$.alert("${ctp:i18n('cip.base.interface.register.tip23')}");
    			}              
            },
            error:function(returnVal){
              var sVal=$.parseJSON(returnVal.responseText);
              $.alert(sVal.message);
          }
        });
    }else{
    	var formsubmit = {"product_flag":$("#product_flag").val(),"typeName":$("#typeName").val(),
    			"Category_id":$("#Category_id").val(),"Interface_name":$("#Interface_name").val(),
    			"Interface_des":$("#Interface_des").val(),"System_constraint":$("#System_constraint").val(),
    			"business_constraint":$("#business_constraint").val(),"Call_des":$("#Call_des").val(),
    			"Scene_des":$("#Scene_des").val(),"resourcePackage":$("#resourcePackageIds").val(),"productId":$("#productId").val(), "Scene_map":map};
    	irm.saveInterfaceRegister(formsubmit, {
            success: function(rel) {
            	if(rel == "success"){
            	    var o = {};
            		o.treeValue = nodeChildrenIds;
            		var $interface = $("#interface");
            	    $interface.ajaxgridLoad(o);
        			$("#registerForm").hide();
        			$("#button").hide();
        		    gridObj.grid.resizeGridUpDown('down');
    			}else if(rel == "error"){
    				$.alert("${ctp:i18n('cip.base.interface.register.tip23')}");
    			}                
            },
            error:function(returnVal){
              var sVal=$.parseJSON(returnVal.responseText);
              $.alert(sVal.message);
          }
        });
    }
}
function getHtml(newNum, scene){
	var name = "";
	if(scene.name.length > 7){
		name = scene.name.substring(0,7) + "...";
	}else{
		name = scene.name;
	}
	html = "<td><div class=\"common_txtbox_wrap\"><input type=\"text\" id=\"sceneNo"+newNum 
		+"\" class=\"validate word_break_all\" validate=\"type:'string',maxLength:50,"+
		"name:'${ctp:i18n('cip.base.interface.detail.no')}',notNull:false,regExp:'^[0-9]+$',"+
		"maxLength:10\" value=\""+scene.no+"\"></div></td><td><div class=\"common_txtbox_wrap"+
		" \"><input type=\"text\" id=\"sceneDe"+newNum +"\" class=\"validate word_break_all\" "+
		"validate=\"type:'string',name:'${ctp:i18n('cip.base.interface.detail.scedes')}',"+
		"maxLength:85\" value=\""+scene.des+"\"></div></td><td><div class=\"common_txtbox_wrap\">"+
		"<span id =\"tab"+newNum+"\" title=\""+scene.name+"\">"+name+"</span><div style=\"float:right;\" id =\"d"+newNum+"\">"+
		"<div class=\"comp\" comp=\"type:'fileupload',applicationCategory:'1',quantity:1,"+
		"maxSize:2097152,firstSave:true,canDeleteOriginalAtts:false,originalAttsNeedClone:"+
		"false,callMethod:'fillUpCallBk'\"></div><a id=\"a"+newNum+"\" href=\"javascript:void(0)\" onclick=\""+
		"befFillUp("+newNum+");insertAttachment()\" class=\"common_button common_button_gray margin_r_3"+
		"\">${ctp:i18n('cip.base.interface.register.upfile')}</a><a id=\"a2"+newNum+"\" href=\"javascript:void(0)"+
		"\" onclick=\"downFile("+newNum+");\" class=\"common_button common_button_gray\">"+
		"${ctp:i18n('cip.base.interface.register.downfile')}</a><input type=\"hidden\" "+
		"id=\"fileName"+newNum+"\" value=\""+scene.name+"\"><input type=\"hidden\" "+
		"id=\"fileId"+newNum+"\" value=\""+scene.id+"\"></div></div></td>";
	return html;
}
function getAllChildrenNodes(treeNode, result){
    if (treeNode.isParent) {
        var childrenNodes = treeNode.children;
        for (var i = 0; i < childrenNodes.length; i++) {
        	if(result != ""){
                result += ',' + childrenNodes[i].id;
        	}else{
        		result += childrenNodes[i].id;
        	}
            result = getAllChildrenNodes(childrenNodes[i], result);
        }
    }
    return result;
}
function nodeClk(e, treeId, node) {
	if(node.data.type == "1"){
		$("#product_id").val(node.data.productId);
	}else if(node.data.type == "2"){
		var firstNode = node.getParentNode();
		var isFirst = 0;
		while(isFirst == 0){
    		if(firstNode.data.type == "1"){
    			$("#product_id").val(firstNode.data.productId);
    	    	isFirst = 1;
    		}else{
    			firstNode = firstNode.getParentNode();
    		}
    	}
	}
	nodeChildrenIds = "";
	if(node.data.type == "-1"){
		nodeChildrenIds = "-1";
	}else if(node.data.type == "1"){
		nodeChildrenIds = getAllChildrenNodes(node, "");
	}else if(node.data.type == "2"){
		nodeChildrenIds = getAllChildrenNodes(node, "");
		if(nodeChildrenIds != ""){
			nodeChildrenIds += ',' + node.id;
    	}else{
    		nodeChildrenIds += node.id;
    	}
	}
    var o = {};
	o.treeValue = nodeChildrenIds;
	var $interface = $("#interface");
    $interface.ajaxgridLoad(o);
	if(node.children == null){
		$("#node_children").val("0");
	}else{
		$("#node_children").val("1");
	}
    $("#node_id").val(node.id);
    var type = "";
    if(node.id == "1"){
    	type = "-1";
    }else if(node.getParentNode().id == "1"){
    	$("#product_name").val(node.name);
    	type = "1";
    }
    var name = node.name;
    var isRoot = 0;
    var arr = new Array();
    if(node.id != "1"){
    	var i = 0;
    	while(isRoot == 0){
    		var pnd = node;
    		node = node.getParentNode();
    		if(node.id == "1"){
    	    	$("#product_name").val(pnd.name);
    			isRoot = 1;
    		}else{
    			type = "2";
    			arr[i] = node.name;
    		}
    		i++;
    	}
    }
    var allName = "";
    if(arr.length != 0){
    	for(var j = arr.length - 1; j >= 0; j--){
    		allName = allName + arr[j] + "-";
    	}
    }
    var irm = new interfaceRegisterManager();
	var res = irm.findInterfaceById($("#node_id").val());
	if(res == "success"){
		type = "3";
	}
    $("#node_type").val(type);
    $("#node_name").val(allName + name);
}
function showInterfaceType(target){
	var nodeId = $("#node_id").val();
	var nodeName = $("#node_name").val();
	if(nodeId == ""){
		$.alert("${ctp:i18n('cip.base.interface.register.tip1')}");
		return;
	}else if(nodeId == "1"){
		$.alert("${ctp:i18n('cip.base.interface.register.tip2')}");
		return;
	}
	var p = $(target).attr("tgt");
	//toSonDilago(p);
	var o = $("#objectId").val();
	var dialog = $.dialog({
           url:"${path}/cip/thirdpartyinterface/interface.do?method=addType&id="+encodeURI(nodeId)+"&name="+encodeURI(nodeName),
           width: 450,
           height: 150,
           title: "${ctp:i18n('cip.base.interface.register.inttype')}",
           buttons: [{
               text: "${ctp:i18n('common.button.ok.label')}", 
               isEmphasize: true,
               handler: function () {
                  var rv = dialog.getReturnValue();
                  if(rv.name != ""){
                      var reg=/^[\u4e00-\u9fa50-9a-zA-Z_]+$/; 
                      if(!reg.test(rv.name)){
                    	  $.alert("${ctp:i18n('cip.base.interface.register.tip14')}");
                    	  return;
                      }
                      if(rv.name.length > 25){
                    	  $.alert("${ctp:i18n('cip.base.interface.register.tip21')}");
                    	  return;
                      }
                	  var irm = new interfaceRegisterManager();
     				  var res = irm.addInterfaceType(rv.id, rv.name);
     				  if(res == "error"){
      					 $.alert("${ctp:i18n('cip.base.interface.register.tip4')}");
     				  }else{
     					 $.infor("${ctp:i18n('cip.base.interface.register.tip3')}");
                    	 dialog.close();
                    	 var $interfaceTree = $("#interfaceTree");
                    	 var treeObj = $interfaceTree.treeObj();
                    	 var nodes = treeObj.getSelectedNodes();
                    	 var pnode = nodes[0];
                    	 var newNode = {"id":res,"pid":pnode.data.id,"name":rv.name,"type":"2"}
                    	 treeObj.addNodes(pnode, newNode);
                    	 //$("#node_type").val("");
     				  }
                  }else{
                	  $.alert("${ctp:i18n('cip.base.interface.register.tip5')}");
                  }
               }
           }, {
               text: "${ctp:i18n('common.button.cancel.label')}",
               handler: function () {
            	   dialog.close();
               }
           }]
   });
}
function editInterfaceType(target){
	var nodeId = $("#node_id").val();
	var nodeName = $("#node_name").val();
	if(nodeId == ""){
		$.alert("${ctp:i18n('cip.base.interface.register.tip1')}");
		return;
	}else if(nodeId == "1"){
		$.alert("${ctp:i18n('cip.base.interface.register.tip2')}");
		return;
	}
	var p = $(target).attr("tgt");
	//toSonDilago(p);
	var o = $("#objectId").val();
	var dialog = $.dialog({
           url:"${path}/cip/thirdpartyinterface/interface.do?method=editType&id="+encodeURI(nodeId)+"&name="+encodeURI(nodeName),
           width: 450,
           height: 150,
           title: "${ctp:i18n('cip.base.interface.register.inttype')}",
           buttons: [{
               text: "${ctp:i18n('common.button.ok.label')}", 
               isEmphasize: true,
               handler: function () {
                  var rv = dialog.getReturnValue();
                  if(rv.name != ""){
                	  var reg=/^[\u4e00-\u9fa50-9a-zA-Z_]+$/; 
                      if(!reg.test(rv.name)){
                    	  $.alert("${ctp:i18n('cip.base.interface.register.tip14')}");
                    	  return;
                      }
                      if(rv.name.length > 25){
                    	  $.alert("${ctp:i18n('cip.base.interface.register.tip21')}");
                    	  return;
                      }
                	  var irm = new interfaceRegisterManager();
     				  var res = irm.editInterfaceType(rv.id, rv.name);
     				  if(res == "success"){
     					 $.infor("${ctp:i18n('cip.base.interface.register.tip7')}");
                    	 dialog.close();
                    	 var $interfaceTree = $("#interfaceTree");
                 		 var treeObj = $interfaceTree.treeObj();
                 		 var nodes = treeObj.getSelectedNodes();
                 		 var node = nodes[0];
                 		 //var pnode = node.getParentNode();
                 		 //var newNode = {"id":node.data.id,"pid":node.data.pid,"name":rv.name,"type":node.data.type};
						 //treeObj.removeNode(node);
                 		 //treeObj.addNodes(pnode, newNode);
                 		 node.data.name = rv.name;
                 		 node.name = rv.name;
                 		 var names = $("#node_name").val().split("-");
                 	     var titleName = "";
                 	     for(var i = 0; i < names.length - 1; i++){
                	    	if("" == titleName){
                	    		titleName = names[i];
                	    	}else{
                	    		titleName = titleName + "-" + names[i];
                	    	}
                	     }
                 	     titleName = titleName + "-" + rv.name;
                 		 $("#node_name").val(titleName);
                 		 treeObj.updateNode(node);
                 		 var o = {};
                 		 o.treeValue = nodeChildrenIds;
                 		 var $interface = $("#interface");
                 	     $interface.ajaxgridLoad(o);
                    	 //$("#node_type").val("");
     				  }else{
     					 $.alert("${ctp:i18n('cip.base.interface.register.tip4')}");
     				  }
                  }else{
                	  $.alert("${ctp:i18n('cip.base.interface.register.tip5')}");
                  }
               }
           }, {
               text: "${ctp:i18n('common.button.cancel.label')}",
               handler: function () {
            	   dialog.close();
               }
           }]
   });
}
/**
 * 初始化工具栏组件
 */
function initToolbar() {
    $("#toolbars").toolbar({
        toolbar : [ {
        	id:"createType",
            name:"${ctp:i18n('cip.base.interface.register.newtype')}",
            className: "ico16",
            click: function (){
                createType();
            }
        },{
            id : "modifyType",
            name : "${ctp:i18n('cip.base.interface.register.changetype')}",
            className : "ico16 editor_16",
            click : function() {
                updateType();
            }
        },{
        	id:"deleteType",
            name:"${ctp:i18n('cip.base.interface.register.deltype')}",
            className: "ico16 del_16",
            click: function (){
                deleteType();
            }
        },{
            id : "create",
            name : "${ctp:i18n('cip.base.interface.register.new')}",
            className : "ico16",
            click : function() {
                createDetail();
            }
        },{
            id : "modify",
            name : "${ctp:i18n('cip.base.interface.detail.change')}",
            className : "ico16 editor_16",
            click : function() {
                updateDetail();
            }
        },{
        	id:"delete",
            name:"${ctp:i18n('cip.base.interface.register.del')}",
            className: "ico16 del_16",
            click: function (){
                deleteDetail();
            }
        }]
    });
}
function createDetail(){
	if($("#node_type").val() != "2"){
		$.alert("${ctp:i18n('cip.base.interface.register.tip8')}");
		return;
	}
	$("#registerForm").clearform();
	$("#masterId").val("");
    $("#product_flag").val($("#product_name").val());
    $("#typeName").val($("#node_name").val());
    $("#Category_id").val($("#node_id").val());
    $("#productId").val($("#product_id").val());
    $("#Interface_name").val("");
    $("#Interface_des").val("");
    $("#System_constraint").val("");
    $("#business_constraint").val("");
    $("#Call_des").val("");
	$("#resourceLi").html("");
	$("#resourcePackageIds").val("");
	$("#dResource a").attr("onclick","showResource()");
    var trId = $("#appTable tr:last").attr("id");
    for(var i = 1; i <= trId; i++){
    	if(i == 1){
    		$("#sceneNo" + i).val("");
    		$("#sceneDe" + i).val("");
    		$("#tab" + i).html("");
			$("#fileName" + i).val("");
			$("#fileId" + i).val("");
    	}else{
        	$("#" + i).remove();
    	}
    }
    $("#registerForm").enable();
	$("#interForm input").removeAttr("disabled");
	$("#interForm textarea").removeAttr("disabled");
	$("#d1 a").attr("class","common_button common_button_gray");
	$("#d1 a").attr("onclick","befFillUp(1);insertAttachment()");
	$("#d1 a").last().attr("onclick","downFile(1)");
	$("#img").show();
	$("#product_flag").disable();
	$("#typeName").disable();
	$("#registerForm").show();
	$("#button").show();
	var pos = getElementPos(document.getElementById("1"));
    var img = $("#img");
	var offset = img.offset();
	offset.top = pos.top;
	offset.left = pos.left - 16;
	img.offset(offset);
    gridObj.grid.resizeGridUpDown('middle');
}
function updateDetail(){
	var hasChecked = $("input:checked", $("#interface"));
    if (hasChecked.length == 0) {
        $.alert("${ctp:i18n('cip.base.interface.register.tip9')}");
        return;
    }
    if (hasChecked.length > 1) {
        $.alert("${ctp:i18n('cip.base.interface.register.tip10')}");
        return;
    }
	$("#registerForm").clearform();
    var id = "";
    for (var i = 0; i < hasChecked.length; i++) {
        id = hasChecked[i].value;
    }
    var irm = new interfaceRegisterManager();
    var data = irm.rMInterfaceById(id);
    $("#masterId").val(data.iD);
    $("#product_flag").val(data.product_flag);
    $("#typeName").val(data.vALUE0);
    $("#Category_id").val(data.category_id);
    $("#Interface_name").val(data.interface_name);
    $("#Interface_des").val(data.interface_des);
    $("#System_constraint").val(data.system_constraint);
    $("#business_constraint").val(data.business_constraint);
    $("#Call_des").val(data.call_des);
    var erm = new extendedResourceManager();
	var codes = erm.findResourceCodesByIds(data.resourcePackage);
	var newHtml = "";
	if(codes != "" && codes != null){
    	var newHtml = "<span id=\"resourceSpan\" title=\""+codes+"\" "+
    		"style=\"max-width: 370px;\">"+codes+"</span><em class=\"ico16 "+
    		"affix_del_16\" onclick=\"clearSpan();\"></em>";
	}
	$("#dResource a").attr("onclick","showResource()");
    $("#resourceLi").html(newHtml);
    $("#resourcePackageIds").val(data.resourcePackage);
    $("#productId").val(data.product_id);
    var trId = $("#appTable tr:last").attr("id");
    for(var i = 1; i <= trId; i++){
    	if(i == 1){
    		$("#sceneNo" + i).val("");
    		$("#sceneDe" + i).val("");
    		$("#tab" + i).html("");
			$("#fileName" + i).val("");
			$("#fileId" + i).val("");
    	}else{
        	$("#" + i).remove();
    	}
    }
    for(var i = 1; i <= data.scene_des.length; i++){
    	var newNum = i; 
    	var scene = data.scene_des[i - 1];
    	if(i == 1){
    		$("#sceneNo" + i).val(scene.no);
    		$("#sceneDe" + i).val(scene.des);
    		$("#tab" + i).attr("title",scene.name);
    		if(scene.name.length > 7){
				$("#tab" + i).html(""+scene.name.substring(0,7) + "...");
			}else{
				$("#tab" + i).html(""+scene.name);
			}
			$("#fileName" + i).val(scene.name);
			$("#fileId" + i).val(scene.id);
    	}else{
        	html = getHtml(newNum, scene);
        	$("#appTable").append("<tr class='autorow' id='"+newNum+"'>"+html+"</tr>");
    	}
    }
	$("#registerForm").enable();
	$("#interForm input").removeAttr("disabled");
	$("#interForm textarea").removeAttr("disabled");
	for(var i = 1; i <= data.scene_des.length; i++){
		$("#d"+i+" a").attr("class","common_button common_button_gray");
		$("#d"+i+" a").attr("onclick","befFillUp("+i+");insertAttachment()");
		$("#d"+i+" a").last().attr("onclick","downFile("+i+")");
	}
	$("#img").show();
	$("#product_flag").disable();
	$("#typeName").disable();
	$("#registerForm").show();
	$("#button").show();
	var pos = getElementPos(document.getElementById(data.scene_des.length));
    var img = $("#img");
	var offset = img.offset();
	offset.top = pos.top;
	offset.left = pos.left - 16;
	img.offset(offset);
    gridObj.grid.resizeGridUpDown('middle');
}
function deleteDetail(){
	var hasChecked = $("input:checked", $("#interface"));
    if (hasChecked.length == 0) {
        $.alert("${ctp:i18n('cip.base.interface.register.tip30')}");
        return;
    }
    var id = "";
    var pid = "";
    for (var i = 0; i < hasChecked.length; i++) {
    	if(id == ""){
            id = hasChecked[i].value;
            pid = hasChecked[i].value;
    	}else{
    		id += "," + hasChecked[i].value;
    	}
    }
	var o = {};
	var manager = new localAgentManager();
    var ids = manager.getConditionStr(pid);
	o.treeValue = ids;
    var irm = new interfaceRegisterManager();
	$.confirm({
        'msg': "${ctp:i18n('common.isdelete.label')}",
        ok_fn: function() {
        	var res = irm.delInterfaceById(id);
        	if(res == "success"){
				var $interface = $("#interface");
			    $interface.ajaxgridLoad(o);
    			$("#registerForm").hide();
    			$("#button").hide();
    		    gridObj.grid.resizeGridUpDown('down');
        	}else{
        		$.alert(res + "${ctp:i18n('cip.extendedresource.msg.tip7')}");
        	}
        }
    });
}
function createType(){
	if($("#node_type").val() == "3"){
		$.alert("${ctp:i18n('cip.base.interface.register.tip8')}");
		return;
	}
	showInterfaceType();
}
function updateType(){
	if($("#node_type").val() == ""){
		$.alert("${ctp:i18n('cip.base.interface.register.tip24')}");
		return;
	}else if ($("#node_type").val() == "-1"){
		$.alert("${ctp:i18n('cip.base.interface.register.tip25')}");
		return;
	}else if ($("#node_type").val() == "1"){
		$.alert("${ctp:i18n('cip.base.interface.register.tip26')}");
		return;
	}
	editInterfaceType();
}
function deleteType(){
	if($("#node_type").val() == ""){
		$.alert("${ctp:i18n('cip.base.interface.register.tip27')}");
		return;
	}else if ($("#node_type").val() == "-1"){
		$.alert("${ctp:i18n('cip.base.interface.register.tip28')}");
		return;
	}else if ($("#node_type").val() == "1"){
		$.alert("${ctp:i18n('cip.base.interface.register.tip29')}");
		return;
	}
	if($("#node_children").val() == "1"){
		$.alert("${ctp:i18n('cip.base.interface.register.tip11')}");
		return;
	}
	var irm = new interfaceRegisterManager();
	$.confirm({
        'msg': "${ctp:i18n('common.isdelete.label')}",
        ok_fn: function() {
        	var res = irm.delInterfaceType($("#node_id").val());
        	if(res == "success"){
        		var $interfaceTree = $("#interfaceTree");
        		var treeObj = $interfaceTree.treeObj();
        		var nodes = treeObj.getSelectedNodes();
        		var node = nodes[0];
        		treeObj.removeNode(node);
        		$("#node_type").val("");
        		location.reload();
        	}else{
        		$.alert("${ctp:i18n('cip.base.interface.register.tip22')}");
        	}
        }
    });
}
/**
 * 初始化搜索框
 */
function initSearchObj() {
    var topSearchSize = 7;
    if ($.browser.msie && $.browser.version == '6.0') {
        topSearchSize = 5;
    }
    var searchObj = $.searchCondition({
        top: topSearchSize,
        right: 10,
        searchHandler: function () {
            var choose = $('#' + searchObj.p.id).find("option:selected").val();
            wholeObj = searchObj;
            var res = searchObj.g.getReturnValue();
			var o = {};
			if(choose == "product"){
				o.condition = "product_flag";
				o.value = res.value;
			}else if(choose == "interfaceName"){
				o.condition = "interface_name";
				o.value = res.value;
			}else if(choose == "type"){
				o.condition = "value0";
				o.value = res.value;
			}else if(choose == "describ"){
				o.condition = "interface_des";
				o.value = res.value;
			}
			o.treeValue = nodeChildrenIds;
			var $interface = $("#interface");
			$interface.ajaxgridLoad(o);
        },
        conditions: [{
            id: 'product',
            name: 'product',
            type: 'input',
            text: '${ctp:i18n('cip.base.interface.register.product')}',
            value: 'product'
        },{
        	id: 'interfaceName',
            name: 'interfaceName',
            type: 'input',
            text: '${ctp:i18n('cip.base.interface.register.name')}',
            value: 'interfaceName'
        },{
        	id: 'type',
            name: 'type',
            type: 'input',
            text: '${ctp:i18n('cip.base.interface.register.inttype')}',
            value: 'type'
        },{
        	id: 'describ',
            name: 'describ',
            type: 'input',
            text: '${ctp:i18n('cip.base.interface.register.des')}',
            value: 'describ'
        }]
    });
}
/**
 * 初始化列表组件
 */
function initGrid() {
    var $interface = $("#interface");
    gridObj = $interface.ajaxgrid({
        colModel : [ {
            display : 'ID',
            name : 'iD',
            width : '10%',
            sortable : false,
            align : 'center',
            type : 'checkbox',
            isToggleHideShow : false
        }, {
            display : "${ctp:i18n('cip.base.interface.register.product')}",
            name : 'product_flag',
            width : '25%'
        }, {
            display : "${ctp:i18n('cip.base.interface.register.name')}",
            name : 'interface_name',
            width : '25%'
        }, {
            display : "${ctp:i18n('cip.base.interface.register.inttype')}",
            name : 'vALUE0',
            width : '15%'
        }, {
            display : "${ctp:i18n('cip.base.interface.register.des')}",
            name : 'interface_des',
            width : '25%'
        }],
        click : clk,
        dblclick : griddbclick,
        render : rend,
        managerName : "interfaceRegisterManager",
        managerMethod : "listCipInterfaceRegisterVo",
        parentId : $('.layout_center').eq(0).attr('id'),
        height : 360,
        isHaveIframe : true,
        slideToggleBtn : true,
        vChange : true,
        vChangeParam : {
            overflow : "hidden",
            autoResize : true
        }
    });
    var o = {};
    o.treeValue = "first";
    $interface.ajaxgridLoad(o);
}
/**
 * 列表单击事件，查看异常信息
 */
function clk(data, r, c) {
	$("#registerForm").clearform();
    $("#grid_detail").resetValidate();
    $("#masterId").val(data.iD);
    $("#product_flag").val(data.product_flag);
    $("#typeName").val(data.vALUE0);
    $("#Category_id").val(data.category_id);
    $("#Interface_name").val(data.interface_name);
    $("#Interface_des").val(data.interface_des);
    $("#System_constraint").val(data.system_constraint);
    $("#business_constraint").val(data.business_constraint);
    $("#Call_des").val(data.call_des);
    var erm = new extendedResourceManager();
	var codes = erm.findResourceCodesByIds(data.resourcePackage);
	var newHtml = "";
	if(codes != "" && codes != null){
    	var newHtml = "<span id=\"resourceSpan\" title=\""+codes+"\" "+
    		"style=\"max-width: 370px;\">"+codes+"</span><em class=\"ico16 "+
    		"affix_del_16\"></em>";
	}
	$("#dResource a").removeAttr("onclick");
    $("#resourceLi").html(newHtml);
    $("#resourcePackageIds").val(data.resourcePackage);
    var trId = $("#appTable tr:last").attr("id");
    for(var i = 1; i <= trId; i++){
    	if(i == 1){
    		$("#sceneNo" + i).val("");
    		$("#sceneDe" + i).val("");
    		$("#tab" + i).html("");
			$("#fileName" + i).val("");
			$("#fileId" + i).val("");
    	}else{
        	$("#" + i).remove();
    	}
    }
    for(var i = 1; i <= data.sceneVos.length; i++){
    	var newNum = i; 
    	var scene = data.sceneVos[i - 1];
    	if(i == 1){
    		$("#sceneNo" + i).val(scene.no);
    		$("#sceneDe" + i).val(scene.des);
    		$("#tab" + i).attr("title",scene.name);
    		if(scene.name.length > 7){
				$("#tab" + i).html(""+scene.name.substring(0,7) + "...");
			}else{
				$("#tab" + i).html(""+scene.name);
			}
			$("#fileName" + i).val(scene.name);
			$("#fileId" + i).val(scene.id);
    	}else{
        	html = getHtml(newNum, scene);
        	$("#appTable").append("<tr class='autorow' id='"+newNum+"'>"+html+"</tr>");
    	}
    }
	$("#registerForm").enable();
	$("#registerForm").show();
	$("#addForm").disable();
	for(var i = 1; i <= data.sceneVos.length; i++){
		$("#d"+i+" a").attr("class","common_button common_button_disable");
		$("#d"+i+" a").removeAttr("onclick");
	}
	$("#img").hide();
	$("#button").hide();
	var pos = getElementPos(document.getElementById(data.sceneVos.length));
    var img = $("#img");
	var offset = img.offset();
	offset.top = pos.top;
	offset.left = pos.left - 16;
	img.offset(offset);
    gridObj.grid.resizeGridUpDown('middle');
}
function griddbclick(data, r, c) {
	$("#registerForm").clearform();
    $("#grid_detail").resetValidate();
    $("#masterId").val(data.iD);
    $("#product_flag").val(data.product_flag);
    $("#typeName").val(data.vALUE0);
    $("#Category_id").val(data.category_id);
    $("#Interface_name").val(data.interface_name);
    $("#Interface_des").val(data.interface_des);
    $("#System_constraint").val(data.system_constraint);
    $("#business_constraint").val(data.business_constraint);
    $("#Call_des").val(data.call_des);
    var erm = new extendedResourceManager();
	var codes = erm.findResourceCodesByIds(data.resourcePackage);
	var newHtml = "";
	if(codes != "" && codes != null){
    	var newHtml = "<span id=\"resourceSpan\" title=\""+codes+"\" "+
    		"style=\"max-width: 370px;\">"+codes+"</span><em class=\"ico16 "+
    		"affix_del_16\" onclick=\"clearSpan();\"></em>";
	}
	$("#dResource a").attr("onclick","showResource()");
    $("#resourceLi").html(newHtml);
    $("#resourcePackageIds").val(data.resourcePackage);
    var trId = $("#appTable tr:last").attr("id");
    for(var i = 1; i <= trId; i++){
    	if(i == 1){
    		$("#sceneNo" + i).val("");
    		$("#sceneDe" + i).val("");
    		$("#tab" + i).html("");
			$("#fileName" + i).val("");
			$("#fileId" + i).val("");
    	}else{
        	$("#" + i).remove();
    	}
    }
    for(var i = 1; i <= data.sceneVos.length; i++){
    	var newNum = i; 
    	var scene = data.sceneVos[i - 1];
    	if(i == 1){
    		$("#sceneNo" + i).val(scene.no);
    		$("#sceneDe" + i).val(scene.des);
    		$("#tab" + i).attr("title",scene.name);
    		if(scene.name.length > 7){
				$("#tab" + i).html(""+scene.name.substring(0,7) + "...");
			}else{
				$("#tab" + i).html(""+scene.name);
			}
			$("#fileName" + i).val(scene.name);
			$("#fileId" + i).val(scene.id);
    	}else{
        	html = getHtml(newNum, scene);
        	$("#appTable").append("<tr class='autorow' id='"+newNum+"'>"+html+"</tr>");
    	}
    }
	$("#registerForm").enable();
	$("#interForm input").removeAttr("disabled");
	$("#interForm textarea").removeAttr("disabled");
	for(var i = 1; i <= data.sceneVos.length; i++){
		$("#d"+i+" a").attr("class","common_button common_button_gray");
		$("#d"+i+" a").attr("onclick","befFillUp("+i+");insertAttachment()");
		$("#d"+i+" a").last().attr("onclick","downFile("+i+")");
	}
	$("#img").show();
	$("#product_flag").disable();
	$("#typeName").disable();
	$("#registerForm").show();
	$("#button").show();
	var pos = getElementPos(document.getElementById(data.sceneVos.length));
    var img = $("#img");
	var offset = img.offset();
	offset.top = pos.top;
	offset.left = pos.left - 16;
	img.offset(offset);
    gridObj.grid.resizeGridUpDown('middle');
}
function rend(txt, data, r, c) {
	return txt;
}
function createTrfn(){
	var last = $("#appTable tr:last").attr("id");
	if(last == null){
		last = 0;
	}
	var current = parseInt(last);
	var newNum = current+1;
	var scene = {
    	no:'',
		des:'',
		id:'',
		name:''
	};
	var html = getHtml(newNum, scene);
	$("#appTable").append("<tr class='autorow' id='"+newNum+"'>"+html+"</tr>");
}
function delTrfn(){
	var trId = $("#appTable tr:last").attr("id");
	var prevTr = $("#"+trId).prev("tr");
	if(prevTr==null||trId==1){
		return;
	}
	$("#"+trId).remove();
}
function downFile(id){
	var drpDownloadForm = document.createElement("form");
    drpDownloadForm.id = "drpDownloadForm";
    drpDownloadForm.method = "post";
    drpDownloadForm.action = "${path}/cip/thirdpartyinterface/downLoad.do?method=downLoadFile";
    var hideInput = document.createElement("input");
    hideInput.type = "hidden";
    hideInput.name = "fileName"
    hideInput.value = $("#fileName" + id).val();
    if($("#fileName" + id).val() == "" || $("#fileName" + id).val() == null){
    	$.alert("${ctp:i18n('cip.base.interface.register.tip19')}");
    	return;
    }
    drpDownloadForm.appendChild(hideInput);
    var hideInput1 = document.createElement("input");
    hideInput1.type = "hidden";
    hideInput1.name = "fileId"
    hideInput1.value = $("#fileId" + id).val();
    drpDownloadForm.appendChild(hideInput1);
    document.body.appendChild(drpDownloadForm);
    drpDownloadForm.submit();
    document.body.removeChild(drpDownloadForm);
}
function clearSpan(){
    $("#resourcePackageIds").val("");
	$("#resourceLi").html("");
}
</script>

</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="layout_north" layout="height:40,sprit:false,border:false">
			<div id="toolbars"></div>
		</div>
		<div class="layout_west" layout="width:200,minWidth:50,maxWidth:300">
			<div id="interfaceTree"></div>
		</div>
		<div class="layout_center over_hidden" layout="border:true">
			<div id="center">
				<table class="flexme3" id="interface"></table>
				<div id="grid_detail"
					style="overflow-y: hidden; position: relative;">
					<div class="stadic_layout">
						<div class="stadic_layout_body stadic_body_top_bottom"
							style="margin: auto;">
							<div id="registerForm" class="form_area"
								style="overflow-y: hidden;">
								<%@include file="interfaceDetail.jsp"%></div>
						</div>
						<div class="stadic_layout_footer stadic_footer_height">
							<div id="button" align="center"
								class="page_color button_container">
								<div
									class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">
									<a id="btnok" href="javascript:void(0)" onclick="checkSub();"
										class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
									<a id="btncancel" href="javascript:void(0)"
										onclick="cancelSub();"
										class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<form name="listForm" id="listForm" method="post"
			onsubmit="return false">
			<input type="hidden" id="node_id" /> <input type="hidden"
				id="node_name" /> <input type="hidden" id="node_type" /> <input
				type="hidden" id="node_children" /> <input type="hidden"
				id="product_name" /> <input type="hidden" id="product_id" />
	</div>
</body>
</html>