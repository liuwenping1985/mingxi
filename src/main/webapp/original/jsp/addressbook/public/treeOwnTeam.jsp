<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<script type="text/javascript">
var addressbookType = '${addressbookType}';
$().ready(function() {
	$("#accountTree").tree({
	    idKey : "id",
	    pIdKey : "parentId",
	    nameKey : "name",
	    onClick: clk,
        nodeHandler : function(n) {
            n.open = true;
          }
	});
});

function clk(e, treeId, node) {
	var showType = $("#showType",parent.document).val();
	$("#searchContent",parent.document).val("");
	var tid=node.data.id;
	if(node.data.parentId!='0' && node.data.parentId!=0 ){
		if(parent.listFrame.document && parent.listFrame.document.readyState === "complete") {
			$("#listFrame",parent.document).attr("src","/seeyon/addressbook.do?method=listOwnTeamMembers&showType="+showType+"&tId="+tid);
			$("#frameUrl",parent.document).val("/seeyon/addressbook.do?method=listOwnTeamMembers&showType="+showType+"&tId="+tid);
		}
		$("#tId").val(tid);
	}else{
		$("#tId").val("-1");
	}
 } 

</script>
<body onclick="parent.hideMenu();">
<%-- <c:set var="isOuter" value="${!v3x:currentUser().internal}" />
<c:set var="myDeptId" value="${v3x:currentUser().departmentId}" /> --%>
<div id="accountContent"  style="width:90%; position: absolute; left:10px; top:10px;">
	<ul id="accountTree" class="ztree" style="margin-top:0; width:90%;"></ul>
</div>
<input type="hidden" name="tId" id="tId" value="-1"/>
</body>