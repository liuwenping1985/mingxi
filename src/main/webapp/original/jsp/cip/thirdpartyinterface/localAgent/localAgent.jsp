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
<script type="text/javascript">
var gridObj;
var nodeChildrenIds = "-1";
$(document).ready(function() {
	initTree();
    initToolbar();
    initSearchObj();
    initGrid();
    $("#registerForm").hide();
	$("#button").hide();
});
/**
 * 初始化接口分类树
 */
function initTree() {
    var $agentTree = $("#agentTree");
    $agentTree.tree({
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
    $agentTree.empty();
    $agentTree.treeObj().reAsyncChildNodes(null, "refresh");
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
	$("#nodeType").val(node.data.type);
	if(node.data.type == "1"){
		$("#productCode").val(node.data.productCode);
	}else if(node.data.type == "2"){
		var firstNode = node.getParentNode();
		var isFirst = 0;
		while(isFirst == 0){
    		if(firstNode.data.type == "1"){
    			$("#productCode").val(firstNode.data.productCode);
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
		$("#interfaceType").val(node.name);
		nodeChildrenIds = getAllChildrenNodes(node, "");
		if(nodeChildrenIds != ""){
			nodeChildrenIds += ',' + node.id;
    	}else{
    		nodeChildrenIds += node.id;
    	}
	}
    var o = {};
	o.treeValue = nodeChildrenIds;
	var $agent = $("#agent");
    $agent.ajaxgridLoad(o);
    var isFirst = 0;
	var pnd = node;
    if(node.id != "1" && node.parentId != "1"){
    	while(isFirst == 0){
    		pnd = pnd.getParentNode();
    		if(pnd.parentId == "1"){
    	    	$("#productName").val(pnd.name);
    	    	isFirst = 1;
    		}
    	}
    }
}
/**
 * 初始化工具栏组件
 */
function initToolbar() {
    $("#toolbars").toolbar({
        toolbar : [ {
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
	if($("#nodeType").val() != "2"){
		$.alert("${ctp:i18n('cip.localAgent.msg.tip1')}");
		return;
	}
	$("#registerForm").clearform();
	$("#selectType").val($("#productCode").val());
	$("#productFlag").val($("#productName").val());
	$("#typeName").val($("#interfaceType").val());
	$("#nodeChildrenIds").val(nodeChildrenIds);
	initSelect();
	$("#interfaceDetName").val("");
	$("#agentSimDes").val("");
	$("#agentDescription").val("");
	$("#agentIntroduce").val("");
	$("#masterId").val("");
	$("#interfaceId").val("");
    
	$("#registerForm").enable();
	$("#d1 a").attr("onclick","detailInterface()");
	$("#registerForm").show();
	$("#button").show();
	$("#productFlag").disable();
	$("#typeName").disable();
	$("#appTable").disable();
	$("#agentInterface").disable();
    gridObj.grid.resizeGridUpDown('middle');
}
function updateDetail(){
	var hasChecked = $("input:checked", $("#agent"));
    if (hasChecked.length == 0) {
        $.alert("${ctp:i18n('cip.extendedresource.msg.tip5')}");
        return;
    }
    if (hasChecked.length > 1) {
        $.alert("${ctp:i18n('cip.extendedresource.msg.tip6')}");
        return;
    }
	$("#registerForm").clearform();
    var id = "";
    for (var i = 0; i < hasChecked.length; i++) {
        id = hasChecked[i].value;
    }
	var manager = new localAgentManager();
    var data = manager.getAgentVoById(id);
	$("#productFlag").val(data.productFlag);
	$("#typeName").val(data.typeName);
	$("#interfaceDetName").val(data.cipInterfaceName);
	$("#productCode").val(data.procuctCode);
	initSelect(data.adapterId);
	$("#agentSimDes").val(data.agentSimpleDes);
	$("#agentDescription").val(data.agentDescription);
	$("#agentIntroduce").val(data.agentIntroduce);
	$("#masterId").val(data.id);
	$("#interfaceId").val(data.cipInterfaceId);
	var ids = manager.getConditionStr(data.cipInterfaceId);
	$("#nodeChildrenIds").val(ids);
    
	$("#registerForm").enable();
	$("#d1 a").attr("onclick","detailInterface()");
	$("#registerForm").show();
	$("#button").show();
	$("#productFlag").disable();
	$("#typeName").disable();
	$("#appTable").disable();
	$("#agentInterface").disable();
    gridObj.grid.resizeGridUpDown('middle');
	
}
function deleteDetail(){
	var hasChecked = $("input:checked", $("#agent"));
    if (hasChecked.length == 0) {
        $.alert("${ctp:i18n('cip.extendedresource.msg.tip5')}");
        return;
    }
    var id = "";
    for (var i = 0; i < hasChecked.length; i++) {
    	if(id == ""){
            id = hasChecked[i].value;
    	}else{
    		id += "," + hasChecked[i].value;
    	}
    }
    var manager = new localAgentManager();
    $.confirm({
        'msg': "${ctp:i18n('common.isdelete.label')}",
        ok_fn: function() {
        	var res = manager.deleteAgentByIds(id);
        	if(res == "success"){
			    var o = {};
				o.treeValue = nodeChildrenIds;
				var $agent = $("#agent");
			    $agent.ajaxgridLoad(o);
    			$("#registerForm").hide();
    			$("#button").hide();
    		    gridObj.grid.resizeGridUpDown('down');
        	}else{
        		$.alert(res + "${ctp:i18n('cip.extendedresource.msg.tip7')}");
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
			}else if(choose == "agentFace"){
				o.condition = "agent_face";
				o.value = res.value;
			}else if(choose == "interfaceName"){
				o.condition = "interface_name";
				o.value = res.value;
			}else if(choose == "agentDes"){
				o.condition = "agent_simple_des";
				o.value = res.value;
			}
			o.productId = $("#productId").val();
			o.versionNo = $("#versionNo").val();
		    var $agent = $("#agent");
		    $agent.ajaxgridLoad(o);
        },
        conditions: [{
            id: 'product',
            name: 'product',
            type: 'input',
            text: '${ctp:i18n('cip.base.interface.register.product')}',
            value: 'product'
        },{
        	id: 'agentFace',
            name: 'agentFace',
            type: 'input',
            text: '${ctp:i18n('cip.localAgent.lab.adapterselect')}',
            value: 'agentFace'
        },{
        	id: 'interfaceName',
            name: 'interfaceName',
            type: 'input',
            text: '${ctp:i18n('cip.localAgent.lab.interfacename')}',
            value: 'interfaceName'
        },{
        	id: 'agentDes',
            name: 'agentDes',
            type: 'input',
            text: '${ctp:i18n('cip.localAgent.lab.agentdes')}',
            value: 'agentDes'
        }]
    });
}
/**
 * 初始化列表组件
 */
function initGrid() {
    var $agent = $("#agent");
    gridObj = $agent.ajaxgrid({
        colModel : [ {
            display : 'id',
            name : 'id',
            width : '10%',
            sortable : false,
            align : 'center',
            type : 'checkbox',
            isToggleHideShow : false
        }, {
            display : "${ctp:i18n('cip.base.interface.register.product')}",
            name : 'productFlag',
            width : '25%'
        }, {
            display : "${ctp:i18n('cip.localAgent.lab.adapterselect')}",
            name : 'adapterName',
            width : '25%'
        }, {
            display : "${ctp:i18n('cip.localAgent.lab.interfacename')}",
            name : 'cipInterfaceName',
            width : '15%'
        }, {
            display : "${ctp:i18n('cip.localAgent.lab.agentdes')}",
            name : 'agentSimpleDes',
            width : '25%'
        }],
        click : clk,
        dblclick : griddbclick,
        render : rend,
        managerName : "localAgentManager",
        managerMethod : "listCipAgentVo",
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
    $agent.ajaxgridLoad(o);
}
/**
 * 列表单击事件，查看异常信息
 */
function clk(data, r, c) {
	$("#registerForm").clearform();
	$("#masterId").val(data.id);
	$("#interfaceId").val(data.cipInterfaceId);
	$("#productFlag").val(data.productFlag);
	$("#typeName").val(data.typeName);
	$("#interfaceDetName").val(data.cipInterfaceName);
	$("#productCode").val(data.procuctCode);
	initSelect(data.adapterId);
	$("#agentSimDes").val(data.agentSimpleDes);
	$("#agentDescription").val(data.agentDescription);
	$("#agentIntroduce").val(data.agentIntroduce);
    
	$("#addForm").disable();
	$("#d1 a").removeAttr("onclick");
	$("#button").hide();
	$("#registerForm").show();
    gridObj.grid.resizeGridUpDown('middle');
}
function griddbclick(data, r, c){
	$("#registerForm").clearform();
	$("#productFlag").val(data.productFlag);
	$("#typeName").val(data.typeName);
	$("#interfaceDetName").val(data.cipInterfaceName);
	$("#productCode").val(data.procuctCode);
	initSelect(data.adapterId);
	$("#agentSimDes").val(data.agentSimpleDes);
	$("#agentDescription").val(data.agentDescription);
	$("#agentIntroduce").val(data.agentIntroduce);
	$("#masterId").val(data.id);
	$("#interfaceId").val(data.cipInterfaceId);
    var manager = new localAgentManager();
	var ids = manager.getConditionStr(data.cipInterfaceId);
	$("#nodeChildrenIds").val(ids);
    
	$("#registerForm").enable();
	$("#d1 a").attr("onclick","detailInterface()");
	$("#registerForm").show();
	$("#button").show();
	$("#productFlag").disable();
	$("#typeName").disable();
	$("#appTable").disable();
	$("#agentInterface").disable();
    gridObj.grid.resizeGridUpDown('middle');
}
function rend(txt, data, r, c) {
	return txt;
}
function initSelect(val){
    var select = document.getElementById("adaptorSelect");
    $("#adaptorSelect").empty();
    var code = $("#productCode").val();
    var manager = new localAgentManager();
    var selectList = manager.getSelectMap(code);
    if(selectList == null){
    	var num = $("#appTable tr:last").attr("id");
		for(var i = 1; i <= num; i++){
			$("#"+i).remove();
		}
		$("#agentInterface").val("");
    	$.alert("${ctp:i18n('cip.localAgent.msg.tip4')}");
    	return;
    }
    for(var i = 0; i < selectList.length; i++){
    	var item = createOption(selectList[i].id, selectList[i].name);
        select.add(item);
        if(selectList[i].id==val){
        	item.selected=true;
        }	
    }
	getAdaptor();
}
function createOption(value, text) {
	var option = document.createElement("option");
	option.value = value;
	option.text = text;
	return option;
}
function showInterface(){
    var ids = $("#nodeChildrenIds").val();
	var dialog = $.dialog({
           url:"${path}/cip/thirdpartyinterface/agent.do?method=interfaceList&ids="+ids,
           width: 900,
           height: 450,
           title: "${ctp:i18n('cip.localAgent.lab.interfacelist')}",
           buttons: [{
               text: "${ctp:i18n('common.button.ok.label')}", 
               isEmphasize: true,
               handler: function () {
                  	var rv = dialog.getReturnValue();
                  	if(rv == ""){
           		   		$.alert("${ctp:i18n('cip.extendedresource.msg.tip5')}");
           		   		return;
           	   	  	}
                  	if(rv == "more"){
             		   	$.alert("${ctp:i18n('cip.extendedresource.msg.tip6')}");
             		   	return;
             	   	}
                  	var idName = rv.split(",");
                  	$("#interfaceDetName").val(idName[1]);
                  	$("#interfaceId").val(idName[0]);
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
function detailInterface(){
	var id = $("#interfaceId").val();
	if(id == ""){
		$.alert("${ctp:i18n('cip.localAgent.msg.tip6')}");
		return;
	}
	var dialog = $.dialog({
           url:"${path}/cip/thirdpartyinterface/agent.do?method=interfaceDetail&id="+id,
           width: 900,
           height: 450,
           title: "${ctp:i18n('cip.localAgent.lab.interfacedetail')}",
           buttons: [{
               text: "${ctp:i18n('common.button.ok.label')}", 
               isEmphasize: true,
               handler: function () {
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
function getAdaptor(){
	var manager = new localAgentManager();
	var data = manager.getAdaptorDetail($("#adaptorSelect").val());
	$("#agentInterface").val(data.interfaceType);
	if(data.paramList == null){
		var num = $("#appTable tr:last").attr("id");
		for(var i = 1; i <= num; i++){
			$("#"+i).remove();
		}
		return;
	}
	if(data.paramList.length > 0){
		var num = $("#appTable tr:last").attr("id");
		for(var i = 1; i <= num; i++){
			$("#"+i).remove();
		}
		for(var i = 0; i < data.paramList.length; i++){
			if(data.paramList[i].paramName == null){
				data.paramList[i].paramName = "";
			}
			if(data.paramList[i].paramValue == null){
				data.paramList[i].paramValue = "";
			}
			if(data.paramList[i].dataType == null){
				data.paramList[i].dataType = "";
			}
			if(data.paramList[i].apiDoc == null){
				data.paramList[i].apiDoc = "";
			}
			if(data.paramList[i].memo == null){
				data.paramList[i].memo = "";
			}
			var no = i + 1;
			var html = getTd(1, no)+getTd(2,data.paramList[i].paramName)+
				getTd(3,data.paramList[i].paramValue)+getTd(4,data.paramList[i].dataType)+
				getTd(5,data.paramList[i].apiDoc)+getTd(6,"")+
				getTd(7,data.paramList[i].memo);
			$("#appTable").append("<tr class='autorow' id='"+no+"'>"+html+"</tr>");
		}
	}
}
function getTd(index, value){
	var td = "<td><div class=\"common_txtbox_wrap\"><input type=\"text\" id=\"param"+index+"\" "+
		"class=\"validate word_break_all\" validate=\"type:'string',name:'param"+index+"'\" "+
		"value=\""+value+"\"></div></td>";
	return td;
}
function checkSub(){
	if(!($("#registerForm").validate())){		
        return;
    }
	if($("#interfaceId").val() == ""){
		$.alert("${ctp:i18n('cip.localAgent.msg.tip3')}");
        return;
    }
	if($("#adaptorSelect").val() == null){
		$.alert("${ctp:i18n('cip.localAgent.msg.tip5')}");
        return;
    }
	var adaptorSelectValue = "";
	if($("#adaptorSelect").val() != null){
		adaptorSelectValue = $("#adaptorSelect").val();
	}
    var formsubmit = {"masterId":$("#masterId").val(),"cipInterfaceId":$("#interfaceId").val(),
    		"adapterId":adaptorSelectValue,"agentDescription":$("#agentDescription").val(),
    		"agentIntroduce":$("#agentIntroduce").val(),"agentSimpleDes":$("#agentSimDes").val(),
    		"typeName":$("#typeName").val()};
	var manager = new localAgentManager();
    if($("#masterId").val() != ""){
    	manager.updateCipAgent(formsubmit, {
            success: function(rel) {
    			if(rel == "success"){
    			    var o = {};
    				o.treeValue = nodeChildrenIds;
    				var $agent = $("#agent");
    			    $agent.ajaxgridLoad(o);
        			$("#registerForm").hide();
        			$("#button").hide();
        		    gridObj.grid.resizeGridUpDown('down');
    			}else if(rel == "error"){
    				$.alert("${ctp:i18n('cip.localAgent.msg.tip2')}");
    			}              
            },
            error:function(returnVal){
              var sVal=$.parseJSON(returnVal.responseText);
              $.alert(sVal.message);
          }
        });
    }else{
    	manager.saveCipAgent(formsubmit, {
            success: function(rel) {
            	if(rel == "success"){
    			    var o = {};
    				o.treeValue = nodeChildrenIds;
    				var $agent = $("#agent");
    			    $agent.ajaxgridLoad(o);
        			$("#registerForm").hide();
        			$("#button").hide();
        		    gridObj.grid.resizeGridUpDown('down');
    			}else if(rel == "error"){
    				$.alert("${ctp:i18n('cip.localAgent.msg.tip2')}");
    			}                
            },
            error:function(returnVal){
              var sVal=$.parseJSON(returnVal.responseText);
              $.alert(sVal.message);
          }
        });
    }
}
function cancelSub(){
	$("#registerForm").hide();
	$("#button").hide();
    gridObj.grid.resizeGridUpDown('down');
}
</script>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<input type="hidden" id="productCode" />
		<input type="hidden" id="productName" />
		<input type="hidden" id="interfaceType" />
		<input type="hidden" id="nodeType" />
		<div class="layout_north" layout="height:40,sprit:false,border:false">
			<div id="toolbars"></div>
		</div>
		<div class="layout_west" layout="width:200,minWidth:50,maxWidth:300">
			<div id="agentTree"></div>
		</div>
		<div class="layout_center over_hidden" layout="border:true">
			<div id="center">
				<table class="flexme3" id="agent"></table>
				<div id="grid_detail"
					style="overflow-y: hidden; position: relative;">
					<div class="stadic_layout">
						<div class="stadic_layout_body stadic_body_top_bottom"
							style="margin: auto;">
							<div id="registerForm" class="form_area"
								style="overflow-y: hidden;">
								<%@include file="agentDetail.jsp"%>
							</div>
						</div>
						<div class="stadic_layout_footer stadic_footer_height">
							<div id="button" align="center"
								class="page_color button_container">
								<div
									class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">
									<a id="btnok" href="javascript:void(0)" onclick="checkSub();"
										class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
									<a id="btncancel" href="javascript:void(0)" onclick="cancelSub();"
										class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>