<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<script src="<c:url value="/apps_res/addressbook/js/common.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var addressbookType = '${addressbookType}';
var isRoot = '${isRoot}';
var accountId = '${accountId}'; 
$().ready(function() {
	$("#accountTree").tree({
	    idKey : "id",
	    pIdKey : "parentId",
	    nameKey : "name",
	    onClick: clk,
	    nodeHandler : function(n) {
	        if (n.data.parentId =='0' || n.data.parentId==0 || n.data.parentId ==undefined || n.data.parentId =='undefined') {
	        	n.open = true;
	        }
	      }
	});
});

function clk(e, treeId, node) {
	if(isRoot=='true' || isRoot==true){
		var showType = $("#showType",parent.document).val();
		$("#searchContent",parent.document).val("");
		if(parent.listFrame.document && parent.listFrame.document.readyState === "complete") {
			$("#treeFrame",parent.document).attr("src","/seeyon/addressbook.do?method=treeDept&addressbookType=1&accountId="+node.data.id);
			$("#listFrame",parent.document).attr("src","/seeyon/addressbook.do?method=listAllMembers&addressbookType=1&showType="+showType+"&accountId="+node.data.id);
			$("#frameUrl",parent.document).val("/seeyon/addressbook.do?method=listAllMembers&addressbookType=1&showType="+showType+"&accountId="+node.data.id);
			$("#currentAccountId",parent.document).html(getSubValue(node.data.name,34));
			$("#showAccountOrDept",parent.document).val("account");
			if(!($("#checkBox_h",parent.document).hasClass("icon16"))){
				$("#checkBox_h",parent.document).addClass("icon16 containChildren_icon16 checkBox_h_current");
			}
			$("#checkBox_h",parent.document).css("background-color","#EFEDED");
		}
	}else{
		//选择单位
		var showType = $("#showType",parent.document).val();
		$("#searchContent",parent.document).val("");
		if(node.data.parentId=='0' || node.data.parentId==0 ){
			if(parent.listFrame.document && parent.listFrame.document.readyState === "complete") {
				$("#listFrame",parent.document).attr("src","/seeyon/addressbook.do?method=listAllMembers&addressbookType=1&showType="+showType+"&accountId="+accountId);
				$("#frameUrl",parent.document).val("/seeyon/addressbook.do?method=listAllMembers&addressbookType=1&showType="+showType+"&accountId="+accountId);
				$("#showAccountOrDept",parent.document).val("account");
				if(!($("#checkBox_h",parent.document).hasClass("icon16"))){
					$("#checkBox_h",parent.document).addClass("icon16 containChildren_icon16 checkBox_h_current");
				}
				$("#checkBox_h",parent.document).css("background-color","#EFEDED");
			}
		}else{
		//选择部门
			if(parent.listFrame.document && parent.listFrame.document.readyState === "complete") {
				var deptId=node.data.id;
				$("#showAccountOrDept",parent.document).val("dept");
				var isDepartment=0;
				if($("#checkBox_h",parent.document).hasClass("icon16")){
					isDepartment=1;
				}
				$("#checkBox_h",parent.document).css("background-color","white");
				$("#listFrame",parent.document).attr("src","/seeyon/addressbook.do?method=listDeptMembers&addressbookType=1&showType="+showType+"&pId="+deptId+"&accountId="+accountId+"&click=dept"+"&deptId="+deptId+"&isDepartment="+isDepartment);
				$("#frameUrl",parent.document).val("/seeyon/addressbook.do?method=listDeptMembers&addressbookType=1&showType="+showType+"&pId="+deptId+"&accountId="+accountId+"&click=dept"+"&deptId="+deptId+"&isDepartment="+isDepartment);
			} 
		
		}
	}

 } 
/* var accountID = "${account.id}"; */

</script>
<body onclick="parent.hideMenu();">
<%-- <c:set var="isOuter" value="${!v3x:currentUser().internal}" />
<c:set var="myDeptId" value="${v3x:currentUser().departmentId}" /> --%>
<div id="accountContent"  style="width:90%; position: absolute; left:10px; top:10px;">
	<ul id="accountTree" class="ztree" style="margin-top:0; width:90%;"></ul>
</div>
</body>

