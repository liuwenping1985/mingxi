<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>
<title></title>
<script type="text/javascript" src="${path}/ajax.do?managerName=cipSynSchemeManager"></script>
<script type="text/javascript" language="javascript">
$().ready(function() {
	var manager = new cipSynSchemeManager();
	$("#unitTree").tree({
	    idKey: "id",
	    pIdKey: "parentId",
	    nameKey: "name",
	    onClick : clk,
	    managerName: "cipSynSchemeManager",
	    managerMethod: "showERPUnitTree",
	    asyncParam : {
	    	schemeId : $("#schemeId").val(),
	    	entityId : $("#entityId").val(),
	    	schemeInitId : $("#schemeInitId").val()
	      },
	    nodeHandler: function(n) {
	    	if(n.data.type=='group'){
	    		n.open = true;
	    	}else{
	    		n.open = false;
	    	}
	    }
	  });
	$("#unitTree").treeObj().reAsyncChildNodes(null, "refresh");
	manager.showERPUnitTree({"schemeId":$("#schemeId").val(),"entityId":$("#entityId").val(),"schemeInitId":$("#schemeInitId").val()});
	function clk(e, treeId, node) {
		$("#thirdOrgid").val(node.data.id);
		$("#thirdOrgname").val(node.data.name);
		$("#thirdType").val(node.data.type);
	}
});
</script>
<script type="text/javascript">
	function OK() {		
		var o = new Object();
		o.thirdOrgid=$("#thirdOrgid").val();
		o.thirdOrgname=$("#thirdOrgname").val();
		o.thirdType = $("#thirdType").val();
		return o;
	}
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
            <input type="hidden" id="schemeId" name="schemeId" value="${ctp:toHTML(schemeId)}">
            <input type="hidden" id="schemeInitId" name="schemeInitId" value="${ctp:toHTML(schemeInitId)}">
            <input type="hidden" id="entityId" name="entityId" value="${ctp:toHTML(entityId)}">
            <input type="hidden" id="thirdOrgid" name="thirdOrgid" value="">
            <input type="hidden" id="thirdOrgname" name="thirdOrgname" value="">
            <input type="hidden" id="thirdType" name="thirdType" value="">
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow-x:hidden;margin-left: 20px;'>            
            <table<div id="unitTree"></div></table>
        </div>
    </div>
</body>
</html>