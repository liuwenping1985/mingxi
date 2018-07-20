<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../common/common.jsp"%>

<script type="text/javascript"
	src="${path}/ajax.do?managerName=licensePermissionManager,accountManager"></script>
<script type="text/javascript">
$().ready(function() {
	
    var dManager = new licensePermissionManager();
    //var rolelist = dManager.getDepRoles()["deproles"];
    var perinfo = dManager.getPermissionInfo("");
    	//alert($.toJSON(postdetil));
    $("#perForm").fillform(perinfo);

    var toolbar = $("#toolbar").toolbar({
        toolbar: [
        {
            id: "selectservertype",
            type: "select",
            value:"1",
            text:"${ctp:i18n('licensePermission.server.ctrl.no')}",
            onchange:changeservertype,
            items: [{
                text: "${ctp:i18n('licensePermission.server.ctrl.yes')}",
                value: '2'
            }]

           
        },{
            id: "selectm1type",
            type: "select",
            value:"1",
            text:"${ctp:i18n('licensePermission.m1.ctrl.no')}",
            onchange:changem1type,
            items: [ {
                text: "${ctp:i18n('licensePermission.m1.ctrl.yes')}",
                value: '2'
            }]

           
        },{
            id: "distribute",
            name: "${ctp:i18n('org.dept.all.units.allocation.number')}",
            className: "ico16 redistribution_16",
            click: function() {
            	if($("#selectservertype").val()=="2"){
            		$(".servertd").each(function() {
            		      $(this).enable();
            		    });
            		
            	}else{
            		$(".servertd").each(function() {
          		      $(this).disable();
          		    });
            	}
            	if($("#selectm1type").val()=="2"){
            		$(".m1td").each(function() {
          		      $(this).enable();
          		    });
            	}else{
            		$(".m1td").each(function() {
            		      $(this).disable();
            		    });
            	}
            	var permissionDisInfo = dManager.getPermissionDisInfo();
                $("#unit").fillform(permissionDisInfo);
            	showAccount();
            	getlevelnum();
                
            }

        }]
    });
    var licservertype = dManager.getServerPermissionType();
    var licM1type = dManager.getM1PermissionType();
   
    toolbar.hideBtn("distribute");
    if(licservertype=="1"){
    	$("#selectservertype").val("1");
    	
    }else{
    	$("#selectservertype").val("2");
    	toolbar.showBtn("distribute");
    }
    if(licM1type=="1"){
    	$("#selectm1type").val("1");
    	
    }else{
    	$("#selectm1type").val("2");
    	toolbar.showBtn("distribute");
    }
    function changeservertype(){
    	dManager.setServerPermissionType($("#selectservertype").val());
    	if($("#selectservertype").val()=="1"){
    		$.infor("${ctp:i18n('licensePermission.server.ctrl.no')}");
    	}else{
    		$.infor("${ctp:i18n('licensePermission.server.ctrl.yes')}");
    	}
    	isshowdistributeBtn();
    }
	function changem1type(){
		dManager.setM1PermissionType($("#selectm1type").val());
		if($("#selectm1type").val()=="1"){
    		$.infor("${ctp:i18n('licensePermission.m1.ctrl.no')}");
    	}else{
    		$.infor("${ctp:i18n('licensePermission.m1.ctrl.yes')}");
    	}
		isshowdistributeBtn();
    }
	function isshowdistributeBtn(){
		if($("#selectm1type").val()=="2"||$("#selectservertype").val()=="2"){
    		toolbar.showBtn("distribute");
    	}else{
    		toolbar.hideBtn("distribute");
    	}
	}
	
	$("#unitTree").tree({
	    idKey: "id",
	    pIdKey: "parentId",
	    nameKey: "name",
	    onClick: clk,
	    enableAsync : true,
	    managerName : "accountManager",
	    managerMethod : "showAccountTree",
	    nodeHandler: function(n) {
	      if(n.data.parentId == '-1') {
	        n.open = true;
	      } else {
	        n.open = false;
	      }
	      
	    }
	  });
	$("#unitTree").treeObj().reAsyncChildNodes(null,"refresh",false);
    function clk(e, treeId, node) {
    	if($("#selectm1type").val()=="1"&&$("#selectservertype").val()=="1"){
    		var perinfo = dManager.getPermissionInfo("");
    	}else{
    		var perinfo = dManager.getPermissionInfo(node.id);
    	}
    	
    	$("#perForm").fillform(perinfo);
    }
    $("#submintCancel").click(function() {
    	location.reload();

    });
    $("#submintButton").click(function() {
        var rootnodes = $("#deptTree").treeObj().getNodes();
        $("#orgAccountId").val(rootnodes[0].id);
		var oldid = $("#id").val();
        dManager.createDept($("#addForm").formobj(), {
            success: function(depBean) {
                $("#id").val(depBean);
                var nodes = $("#deptTree").treeObj().getSelectedNodes();
                var data = $("#addForm").formobj();
                //alert($("#enabled").length);
                if(oldid==''){
                if (nodes.length > 0) {
                    $("#deptTree").treeObj().addNodes(nodes[0], data);
                } else {
                    $("#deptTree").treeObj().addNodes(rootnodes[0], data);
                }
                }
                
            	if($("#conti").attr("checked")=="checked"){
            		addform();
                }else{   
                	
                	$("#depform").hide();
                    $("#welcome").show();
                    $("#button").hide();
                }
                
            }
        });

    });
    function showAccount() {
    	
          var dialog = $.dialog({
        	  
        	   id:'html',
        	   width:'600',
        	   
               htmlId: 'licdistributeform',
               title: "分配单位许可数",
               buttons: [{
                   id: 'ok',
                   text: "${ctp:i18n('guestbook.leaveword.ok')}",
                   handler: function () {
                	   $("#unit").validate();
                	   dManager.savePermissionDisInfo($("#unit").formobj(), {
                           success: function(depBean) {
                        	   dialog.close();
                           }
                       });
                   }
               }, {
                   id: 'cancel',
                   
                   text: "${ctp:i18n('systemswitch.cancel.lable')}",
                   handler: function () {
                      
                       dialog.close();
                   }
               }]
           });
       }
    
    

});

function getlevelnum() {
	var serusenum = 0;
	$(".servertd").each(function() {
		serusenum = $(this).val()*1 + serusenum;
	    });
	var musenum = 0;
	$(".m1td").each(function() {
		musenum = $(this).val()*1 + musenum;
	    });
	try{
		if($("#totalservernum").html().indexOf("数")>0){
			$("#levelservernum").html($("#totalservernum").html().replace("并发数","")*1-serusenum);
		}else{
			$("#levelservernum").html($("#totalservernum").html()*1-serusenum);
		}
		if($("#totalm1num").html().indexOf("数")>0){
			$("#levelm1num").html($("#totalm1num").html().replace("注册数","")*1-musenum);
		}else{
			$("#levelm1num").html($("#totalm1num").html()*1-musenum);
		}
	}catch(e){
		$("#levelservernum").html($("#totalservernum").html()*1-serusenum);
		$("#levelm1num").html($("#totalm1num").html()*1-musenum);
	}
	
   
 }
</script>
<style>
/* #toolbar .common_toolbar_box{
	height: 23px;
	padding-top: 7px;
	padding-left: 5px;
} */
select{
line-height:26px;
height:26px;
}
</style>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
	<div class="comp" comp="type:'breadcrumb',code:'T02_licpermission'"></div>
		<div class="layout_north" layout="height:40,sprit:false,border:false">
			<div id="toolbar" class="margin_t_5"></div>
		</div>
		<div class="layout_center over_hidden" layout="border:true">
		<div class="stadic_layout">
					<div class="stadic_layout_head stadic_head_height">
					</div>
					<div class="stadic_layout_body stadic_body_top_bottom">
						<div id="permissionform" class="form_area">
							<%@include file="permissionform.jsp"%>

						</div>
					</div>
					
			</div>

		</div>
		<div class="layout_west"
			layout="border:true,width:200,minWidth:50,maxWidth:300">
			
			<div id="unitTree"></div>
			
			
		</div>
	</div>
	<div id="licdistributeform" class="hidden">
		
            <%@include file="licdistributeform.jsp"%>
           
    </div>
	
</body>
</html>