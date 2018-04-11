<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<script type="text/javascript">
var addressbookType = '${addressbookType}';
var accountId = '${accountId}'; 
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
		if(node.data.parentId!='0' && node.data.parentId!=0 ){
			if(parent.listFrame.document && parent.listFrame.document.readyState === "complete") {
				var tid=node.data.id;
				$("#listFrame",parent.document).attr("src","/seeyon/addressbook.do?method=listSysTeamMembers&addressbookType=3&showType="+showType+"&accountId="+accountId+"&tId="+tid);
				$("#frameUrl",parent.document).val("/seeyon/addressbook.do?method=listSysTeamMembers&addressbookType=3&showType="+showType+"&accountId="+accountId+"&tId="+tid);
			} 
		}
 } 

</script>
<body onclick="parent.hideMenu();">
<div id="accountContent"  style="width:90%; position: absolute; left:10px; top:10px;">
	<ul id="accountTree" class="ztree" style="margin-top:0; width:90%;"></ul>
</div>
</body>

