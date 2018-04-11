<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<title>选择财务部门</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=deptMapperManager"></script>
<script type="text/javascript" language="javascript">
$().ready(function() {
	var manager = new deptMapperManager();
	if($("#multiUnit").val()=='false'){
		$("#units").hide();
	}
	$("#units").change(function(){	
		var o = $("#departmentTree").treeObj();
		var async = o.setting.async;
		var otherParam = async.otherParam;
		otherParam.units=$("#units").val();
		o.reAsyncChildNodes(null, "refresh");
	});
	$("#departmentTree").tree({
	    idKey: "id",
	    pIdKey: "pid",
	    nameKey: "nameCode",
	    onClick : clk,	    
	    managerName: "deptMapperManager",
	    managerMethod: "showERPDeptTree",
	    asyncParam : {
	        accountId : $("#accountId").val(),
	        units : $("#units").val()
	      },
	    nodeHandler: function(n) {
	      if (n.data.id == $("#units").val() || n.data.id=='root') {
	        n.open = true;
	      } else {
	        n.open = false;
	      }
	    }
	  });	
	$("#departmentTree").treeObj().reAsyncChildNodes(null, "refresh");
	manager.showERPDeptTree({"accountId":$("#accountId").val(),"units":$("#units").val()});
	function clk(e, treeId, node) {
		$("#erpId").val(node.data.id);
		$("#erpName").val(node.data.name);
		$("#erpCode").val(node.data.code);
		$("#erpUnit").val(node.data.unitName);
		}
});
</script>
<script type="text/javascript">
	function OK() {		
		if($("#erpId").val()=="unit"){			
			return false;
		}else{
			var o = new Object();
			o.erpDeptId=$("#erpId").val();
			o.erpDeptName=$("#erpName").val();
			o.erpDeptCode=$("#erpCode").val();
			o.erpDeptUnit=$("#erpUnit").val();
			return o;
		}
		
	}
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
	        <div id="searchDiv">
            <input type="hidden" id="accountId" name="accountId" value="${accountId}">
            <input type="hidden" id="erpId" name="erpId">
            <input type="hidden" id="erpName" name="erpName">
            <input type="hidden" id="erpCode" name="erpCode">
            <input type="hidden" id="erpUnit" name="erpUnit">
            <select id="units" name="units">
                ${main:accountVoucherTree(units,null,accountString,pk_corp,0, pageContext)}
            </select>
	        </div>
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow-x:hidden;width:700px;height:300px;'>            
            <table style="width:701px;height:300px"><div id="departmentTree"></div></table>
            <input type="hidden" id="multiUnit" name="multiUnit" value="${multiUnit}">           
        </div>
    </div>
</body>
</html>