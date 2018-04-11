<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=extendedResourceManager"></script>
<script type="text/javascript">
var gridObj;
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
 * 初始化接口分类树
 */
function initTree() {
    var $resourceTree = $("#resourceTree");
    $resourceTree.tree({
        idKey: "id",
        pIdKey: "parentId",
        nameKey: "name",
        managerName: "extendedResourceManager",
        managerMethod: "getResourceTree",
        onClick: nodeClk,
        nodeHandler: function (n) {
            n.open = true;
            if(n.data.type == "1"){
				n.open = false;
			}
        }
    });
    $resourceTree.empty();
    $resourceTree.treeObj().reAsyncChildNodes(null, "refresh");
}
function nodeClk(e, treeId, node) {
	$("#productId").val(node.data.productId);
	$("#versionNo").val(node.data.versionNo);
	$("#productName").val(node.data.name);
	$("#nodeType").val(node.data.type);
	var o = {};
	o.productId = node.data.productId;
	o.versionNo = node.data.versionNo;
    var $resource = $("#resource");
    $resource.ajaxgridLoad(o);
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
	if($("#productName").val() == ""){
		$.alert("${ctp:i18n('cip.extendedresource.msg.tip1')}");
		return;
	}
	if($("#nodeType").val() == "-1"){
		$.alert("${ctp:i18n('cip.extendedresource.msg.tip2')}");
		return;
	}
	$("#registerForm").clearform();
	$("#masterId").val("");
	$("#productIdDet").val($("#productId").val());
	$("#productVersionId").val($("#versionNo").val());
	$("#fileName1").val("");
	$("#fileId1").val("");
	$("#tab1").attr("title","");
	$("#tab1").html("");
	var erm = new extendedResourceManager();
	var no = erm.getResourceCode($("#productId").val(), $("#versionNo").val());
	$("#productFlag").val($("#productName").val());
	$("#resourceCodeDet").val($("#productName").val() + no);
	$("#resourceNameDet").val("");
	$("#resourceFileNameDet").val("");
	$("#resourceListDet").val("");
	$("#resourceDeployDet").val("");
	$("#resourceDependentDet").val("");
	$("#resourceMemoDet").val("");
    
	$("#registerForm").enable();
	$("#d1 a").attr("class","common_button common_button_gray");
	$("#a1").attr("onclick","insertAttachment()");
	$("#a2").attr("onclick","downFile()");
	$("#productFlag").disable();
	$("#resourceCodeDet").disable();
	$("#registerForm").show();
	$("#button").show();
    gridObj.grid.resizeGridUpDown('middle');
}
function updateDetail(){
	var hasChecked = $("input:checked", $("#resource"));
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
    var erm = new extendedResourceManager();
    var data = erm.findCipResourcePackageVoById(id);
    $("#masterId").val(data.id);
	$("#productIdDet").val(data.productId);
	$("#productVersionId").val(data.productVersionId);
	var erm = new extendedResourceManager();
	var no = erm.getResourceCode(data.productId, data.productVersionId);
	$("#productFlag").val(data.productFlag);
	$("#resourceCodeDet").val(data.resourceCode);
	$("#resourceNameDet").val(data.resourceName);
	$("#resourceFileNameDet").val(data.resourceFileName);
	$("#resourceListDet").val(data.resourceList);
	$("#resourceDeployDet").val(data.resourceDeploy);
	$("#resourceDependentDet").val(data.resourceDependent);
	$("#resourceMemoDet").val(data.resourceMemo);
	$("#tab1").attr("title",data.resourceFileName);
	if(data.resourceFileName.length > 25){
		$("#tab1").html(""+data.resourceFileName.substring(0,25) + "...");
	}else{
		$("#tab1").html(""+data.resourceFileName);
	}
	$("#fileName1").val(data.resourceFileName);
	$("#fileId1").val(data.resourceFileId);
    
	$("#registerForm").enable();
	$("#d1 a").attr("class","common_button common_button_gray");
	$("#a1").attr("onclick","insertAttachment()");
	$("#a2").attr("onclick","downFile()");
	$("#productFlag").disable();
	$("#resourceCodeDet").disable();
	$("#registerForm").show();
	$("#button").show();
    gridObj.grid.resizeGridUpDown('middle');
}
function deleteDetail(){
	var hasChecked = $("input:checked", $("#resource"));
    if (hasChecked.length == 0) {
        $.alert("${ctp:i18n('cip.extendedresource.msg.tip5')}");
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
    var erm = new extendedResourceManager();
    var data = erm.findCipResourcePackageVoById(pid);
    $.confirm({
        'msg': "${ctp:i18n('common.isdelete.label')}",
        ok_fn: function() {
        	var res = erm.deleteExtendedResourceByIds(id);
        	if(res == "success"){
				var o = {};
				o.productId = data.productId;
				o.versionNo = data.productVersionId;
			    var $resource = $("#resource");
			    $resource.ajaxgridLoad(o);
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
			}else if(choose == "resourceCode"){
				o.condition = "resource_code";
				o.value = res.value;
			}else if(choose == "resourceName"){
				o.condition = "resource_name";
				o.value = res.value;
			}else if(choose == "resourceFileName"){
				o.condition = "filename";
				o.value = res.value;
			}
			o.productId = $("#productId").val();
			o.versionNo = $("#versionNo").val();
		    var $resource = $("#resource");
		    $resource.ajaxgridLoad(o);
        },
        conditions: [{
            id: 'product',
            name: 'product',
            type: 'input',
            text: '${ctp:i18n('cip.base.interface.register.product')}',
            value: 'product'
        },{
        	id: 'resourceCode',
            name: 'resourceCode',
            type: 'input',
            text: '${ctp:i18n('cip.extendedresource.lab.resourceno')}',
            value: 'resourceCode'
        },{
        	id: 'resourceName',
            name: 'resourceName',
            type: 'input',
            text: '${ctp:i18n('cip.extendedresource.lab.resourcename')}',
            value: 'resourceName'
        },{
        	id: 'resourceFileName',
            name: 'resourceFileName',
            type: 'input',
            text: '${ctp:i18n('cip.extendedresource.lab.resourcebag')}',
            value: 'resourceFileName'
        }]
    });
}
/**
 * 初始化列表组件
 */
function initGrid() {
    var $resource = $("#resource");
    gridObj = $resource.ajaxgrid({
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
            display : "${ctp:i18n('cip.extendedresource.lab.resourceno')}",
            name : 'resourceCode',
            width : '25%'
        }, {
            display : "${ctp:i18n('cip.extendedresource.lab.resourcename')}",
            name : 'resourceName',
            width : '15%'
        }, {
            display : "${ctp:i18n('cip.extendedresource.lab.resourcebag')}",
            name : 'resourceFileName',
            width : '25%'
        }],
        click : clk,
        dblclick : griddbclick,
        render : rend,
        managerName : "extendedResourceManager",
        managerMethod : "listCipResourcePackageVo",
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
    o.productId = "first";
    $resource.ajaxgridLoad(o);
}
/**
 * 列表单击事件，查看异常信息
 */
function clk(data, r, c) {
	$("#registerForm").clearform();
	$("#masterId").val(data.id);
	$("#productIdDet").val(data.productId);
	$("#productVersionId").val(data.productVersionId);
	var erm = new extendedResourceManager();
	var no = erm.getResourceCode(data.productId, data.productVersionId);
	$("#productFlag").val(data.productFlag);
	$("#resourceCodeDet").val(data.resourceCode);
	$("#resourceNameDet").val(data.resourceName);
	$("#resourceFileNameDet").val(data.resourceFileName);
	$("#resourceListDet").val(data.resourceList);
	$("#resourceDeployDet").val(data.resourceDeploy);
	$("#resourceDependentDet").val(data.resourceDependent);
	$("#resourceMemoDet").val(data.resourceMemo);
	$("#tab1").attr("title",data.resourceFileName);
	if(data.resourceFileName.length > 25){
		$("#tab1").html(""+data.resourceFileName.substring(0,25) + "...");
	}else{
		$("#tab1").html(""+data.resourceFileName);
	}
	$("#fileName1").val(data.resourceFileName);
	$("#fileId1").val(data.resourceFileId);
    
	$("#addForm").disable();
	$("#d1 a").attr("class","common_button common_button_disable");
	$("#d1 a").removeAttr("onclick");
	$("#button").hide();
	$("#registerForm").show();
    gridObj.grid.resizeGridUpDown('middle');
}
function griddbclick(data, r, c) {
	$("#registerForm").clearform();
	$("#masterId").val(data.id);
	$("#productIdDet").val(data.productId);
	$("#productVersionId").val(data.productVersionId);
	var erm = new extendedResourceManager();
	var no = erm.getResourceCode(data.productId, data.productVersionId);
	$("#productFlag").val(data.productFlag);
	$("#resourceCodeDet").val(data.resourceCode);
	$("#resourceNameDet").val(data.resourceName);
	$("#resourceFileNameDet").val(data.resourceFileName);
	$("#resourceListDet").val(data.resourceList);
	$("#resourceDeployDet").val(data.resourceDeploy);
	$("#resourceDependentDet").val(data.resourceDependent);
	$("#resourceMemoDet").val(data.resourceMemo);
	$("#tab1").attr("title",data.resourceFileName);
	if(data.resourceFileName.length > 25){
		$("#tab1").html(""+data.resourceFileName.substring(0,25) + "...");
	}else{
		$("#tab1").html(""+data.resourceFileName);
	}
	$("#fileName1").val(data.resourceFileName);
	$("#fileId1").val(data.resourceFileId);
    
	$("#registerForm").enable();
	$("#d1 a").attr("class","common_button common_button_gray");
	$("#a1").attr("onclick","insertAttachment()");
	$("#a2").attr("onclick","downFile()");
	$("#productFlag").disable();
	$("#resourceCodeDet").disable();
	$("#registerForm").show();
	$("#button").show();
    gridObj.grid.resizeGridUpDown('middle');
}
function rend(txt, data, r, c) {
	return txt;
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
	if($("#fileName1").val() == ""){
		$.alert("${ctp:i18n('cip.extendedresource.msg.tip3')}");
        return;
    }
    var formsubmit = {"masterId":$("#masterId").val(),"productId":$("#productIdDet").val(),
    		"productVersionId":$("#productVersionId").val(),"resourceFileId":$("#fileId1").val(),
    		"resourceCode":$("#resourceCodeDet").val(),"resourceName":$("#resourceNameDet").val(),
    		"resourceList":$("#resourceListDet").val(),"resourceDeploy":$("#resourceDeployDet").val(),
    		"resourceDependent":$("#resourceDependentDet").val(),"resourceMemo":$("#resourceMemoDet").val()};
	var erm = new extendedResourceManager();
    if($("#masterId").val() != ""){
    	erm.updateExtendedResource(formsubmit, {
            success: function(rel) {
    			if(rel == "success"){
    				var o = {};
    				o.productId = $("#productIdDet").val();
    				o.versionNo = $("#productVersionId").val();
    			    var $resource = $("#resource");
    			    $resource.ajaxgridLoad(o);
        			$("#registerForm").hide();
        			$("#button").hide();
        		    gridObj.grid.resizeGridUpDown('down');
    			}else if(rel == "error"){
    				$.alert("${ctp:i18n('cip.extendedresource.msg.tip4')}");
    			}              
            },
            error:function(returnVal){
              var sVal=$.parseJSON(returnVal.responseText);
              $.alert(sVal.message);
          }
        });
    }else{
    	erm.saveExtendedResource(formsubmit, {
            success: function(rel) {
            	if(rel == "success"){
    				var o = {};
    				o.productId = $("#productIdDet").val();
    				o.versionNo = $("#productVersionId").val();
    			    var $resource = $("#resource");
    			    $resource.ajaxgridLoad(o);
        			$("#registerForm").hide();
        			$("#button").hide();
        		    gridObj.grid.resizeGridUpDown('down');
    			}else if(rel == "error"){
    				$.alert("${ctp:i18n('cip.extendedresource.msg.tip4')}");
    			}                
            },
            error:function(returnVal){
              var sVal=$.parseJSON(returnVal.responseText);
              $.alert(sVal.message);
          }
        });
    }
}
function fillUpCallBk(filemsg){
	if(filemsg.instance!=null && filemsg.instance.length>0){
		var fileId = filemsg.instance[0].fileUrl;
		var fileName = filemsg.instance[0].filename;
		if(fileName.length > 25){
			$.alert("${ctp:i18n('cip.scheme.param.config.namelen')}");
			return
		}else{
			$("#tab1").attr("title",fileName);
			if(fileName.length > 25){
				$("#tab1").html(""+fileName.substring(0,25) + "...");
			}else{
				$("#tab1").html(""+fileName);
			}
			$("#fileName1").val(fileName);
			$("#fileId1").val(fileId);
			//var erm = new extendedResourceManager();
			//erm.copyFile(fileId,fileId);
		}
	}
}
function downFile(){
	var drpDownloadForm = document.createElement("form");
    drpDownloadForm.id = "drpDownloadForm";
    drpDownloadForm.method = "post";
    drpDownloadForm.action = "${path}/cip/thirdpartyinterface/downLoad.do?method=downLoadFile";
    var hideInput = document.createElement("input");
    hideInput.type = "hidden";
    hideInput.name = "fileName"
    hideInput.value = $("#fileName1").val();
    if($("#fileName1").val() == ""){
    	$.alert("${ctp:i18n('cip.extendedresource.msg.tip3')}");
    	return;
    }
    drpDownloadForm.appendChild(hideInput);
    var hideInput1 = document.createElement("input");
    hideInput1.type = "hidden";
    hideInput1.name = "fileId"
    hideInput1.value = $("#fileId1").val();
    drpDownloadForm.appendChild(hideInput1);
    document.body.appendChild(drpDownloadForm);
    drpDownloadForm.submit();
    document.body.removeChild(drpDownloadForm);
}
</script>

</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<input type="hidden" id="productId">
		<input type="hidden" id="versionNo">
		<input type="hidden" id="productName">
		<input type="hidden" id="nodeType">
		<input type="hidden" id="">
		<div class="layout_north" layout="height:40,sprit:false,border:false">
			<div id="toolbars"></div>
		</div>
		<div class="layout_west" layout="width:200,minWidth:50,maxWidth:300">
			<div id="resourceTree"></div>
		</div>
		<div class="layout_center over_hidden" layout="border:true">
			<div id="center">
				<table class="flexme3" id="resource"></table>
				<div id="grid_detail"
					style="overflow-y: hidden; position: relative;">
					<div class="stadic_layout">
						<div class="stadic_layout_body stadic_body_top_bottom"
							style="margin: auto;">
							<div id="registerForm" class="form_area"
								style="overflow-y: hidden;">
								<%@include file="resourceDetail.jsp"%>
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