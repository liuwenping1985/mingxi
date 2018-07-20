<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>
<title>选择Erp单位</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=deptMapperManager"></script>
<script type="text/javascript" language="javascript">
$().ready(function() {
	var manager = new deptMapperManager();
	$("#unitTree").tree({
	    idKey: "id",
	    pIdKey: "fathercorp",
	    nameKey: "name",
	    onClick : clk,
	    managerName: "deptMapperManager",
	    managerMethod: "showERPUnitTree",
	    asyncParam : {
	        accountId : $("#accountId").val()
	      },
	    nodeHandler: function(n) {
	    	if(n.data.id=='root'){
	    		n.open = true;
	    	}else{
	    		n.open = false;
	    	}
	    }
	  });
	$("#unitTree").treeObj().reAsyncChildNodes(null, "refresh");
	manager.showERPUnitTree({"accountId":$("#accountId").val()});
	function clk(e, treeId, node) {
		$("#unitId").val(node.data.id);
		$("#erpUnit").val(node.data.unitname);
	}
});
</script>
<script type="text/javascript">
	function OK() {		
		var o = new Object();
		o.unitId=$("#unitId").val();
		o.erpUnit=$("#erpUnit").val();
		return o;
	}
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
            <input type="hidden" id="accountId" name="accountId" value="${ctp:toHTML(accountId)}">
            <input type="hidden" id="unitId" name="unitId" value="">
            <input type="hidden" id="erpUnit" name="erpUnit" value="">
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow-x:hidden;margin-left: 20px;'>            
            <table<div id="unitTree"></div></table>
        </div>
    </div>
</body>
</html>