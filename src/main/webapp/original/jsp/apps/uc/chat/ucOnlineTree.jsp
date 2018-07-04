<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html>
<head>
<%@ include file="header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/zTree/js/jquery.ztree.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/zTree/css/zTreeStyle/zTreeStyle.css${v3x:resSuffix()}" />">
<style type="text/css">
	ul.ztree {margin-top:10px; border:1px solid #617775; background:#fff; width:150px; height:360px; overflow-y:auto; overflow-x:auto;}
</style>
<script type="text/javascript">
function initTreeWidth(){
	try{
		var west_region = parent.document.getElementById('layout_west');
		if(west_region){
			var bodyWidth = parseInt(west_region.clientWidth);
			var treeWidth = bodyWidth;
			if(!v3x.isMSIE){bodyWidth = bodyWidth-10;}
			if(!v3x.isMSIE){treeWidth = treeWidth-10;}
			var bodyHeight = parseInt(west_region.clientHeight)-58;
			var scrollListDiv = document.getElementById('scrollListDiv');
			
			if(scrollListDiv){
				scrollListDiv.style.width = bodyWidth + "px";
				scrollListDiv.style.height = bodyHeight + "px";
			}
			
			$('#select_input_div').width(bodyWidth - 7);
			var _w = $('#select_input_div').width();
			$('#currentAccountId').width(_w - 18);
			$('#accountContent').width(_w - 10);
		}
	}catch(e){}
}

var setting = {
	view: {
		dblClickExpand: false,
		selectedMulti: false
	},
	data: {
		simpleData: {
			enable: true
		}
	},
	callback: {
		onClick: onClick
	}
};

<c:if test="${isShowAccountSwitch && currentUser.internal}">
var zNodes = [
	${v3x:selectTree(accountList, 'id', 'superior', 'name', pageContext)}
];
</c:if>

function onClick(e, treeId, treeNode) {
	var zTree = $.fn.zTree.getZTreeObj("accountTree"), nodes = zTree.getSelectedNodes(), v = "";
	for (var i = 0; i < nodes.length; i ++) {
		v += nodes[i].id + ",";
	}
	if(v.length > 0) v = v.substring(0, v.length - 1);
	ucChangeComboTree(v);
}

function showMenu() {
	var accountObj = $("#currentAccountId");
	var accountOffset = $("#currentAccountId").offset();
	$("#accountContent").css({left:accountOffset.left - 1 + "px", top:accountOffset.top + accountObj.outerHeight() + "px"}).slideDown("fast");

	var treeObj = $.fn.zTree.getZTreeObj("accountTree");
	var node = treeObj.getNodeByParam("id", "${currentAccountId}", null);
	if(node){
		treeObj.selectNode(node);
	}
	
	$("body").bind("mousedown", onBodyDown);
}

function hideMenu() {
	$("#accountContent").fadeOut("fast");
	$("body").unbind("mousedown", onBodyDown);
}

function onBodyDown(event) {
	if (!(event.target.id == "accountContent" || $(event.target).parents("#accountContent").length > 0)) {
		hideMenu();
	}
}
/**
 * 显示所选部门在线人员
 */
function ucShowSelDep(id){
	var url = v3x.baseURL + '/uc/chat.do?method=showOnlineUserList&condition=ByDepartment&departmentId=' + id;
	var a = parent.onlineUserListIframe.document;
	a = a.getElementById("showOfflineList");
	if(a && a.checked){
		url += "&showoffline=checked";
	}
	parent.onlineUserListIframe.location.href = url;
}

/**
 * 切换单位,更换部门树结构、在线人员列表
 */
function ucChangeComboTree(value){
	var url = v3x.baseURL + '/uc/chat.do?method=showOnlineUserTree&currentAccountId=' + value;
	var a = parent.onlineUserListIframe.document;
	a = a.getElementById("showOfflineList");
	if(a && a.checked){
		url += "&showoffline=checked";
	}
	parent.onlineUserTreeIframe.location.href = url;
	ucShowAccountUser(value);
}

/**
 * 显示根单位在线人员
 */
function ucShowAccountUser(id){
	var url = v3x.baseURL + '/uc/chat.do?method=showOnlineUserList&condition=SelectAccount&currentAccountId=' + id;
	var a = parent.onlineUserListIframe.document;
	a = a.getElementById("showOfflineList");
	if(a && a.checked){
		url += "&showoffline=checked";
	}
	parent.onlineUserListIframe.location.href = url;
}

$(document).ready(function(){
	<c:if test="${isShowAccountSwitch && currentUser.internal}">
	$.fn.zTree.init($("#accountTree"), setting, zNodes);
	</c:if>

	if(document.all){
        window.attachEvent("onresize", initTreeWidth);
    }else{
    	window.addEventListener("resize", initTreeWidth, false);
	}
	initTreeWidth();
});
</script>
</head>
<body>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="25">
			<form name="userForm" action="${messageURL}" method="get" onsubmit="return false;">
				<table width="100%" height="25" border="0" cellspacing="0" cellpadding="0" class="message-title-color">
					<tr>
					  	<td valign="top">
					  		<c:if test="${isShowAccountSwitch && currentUser.internal}">
								<div id="select_input_div" class="select_input_div" onclick="showMenu(); return false;">
										<input name="currentAccountId" id="currentAccountId" type="text" class="select_input" style="padding-left: 5px;" readonly="readonly" value="${v3x:getAccount(currentAccountId).name}" />
								</div>
					  		</c:if>
						</td>
					</tr>
				</table>
			</form>
		</td>
	</tr>
	<tr>
		<td>
			<div id="scrollListDiv" class="scrollList" style="background: #ffffff;padding: 5px;">
				<c:choose>
					<c:when test="${isRoot}">
						<script type="text/javascript">
							var root = new WebFXTree("${account.id}", "${account.name}", "");
							root.setBehavior('classic');
							root.icon = "<c:url value='/common/images/templete.gif'/>";
							root.openIcon = "<c:url value='/common/images/templete.gif'/>";	
							
							var icon1 = "/seeyon/common/js/xtree/images/file1.gif";
							var icon2 = "/seeyon/common/js/xtree/images/file2.gif";
							
							<c:forEach items="${childAccountList}" var="ca">
								var aa${fn:replace(ca.id,'-','_')}= new WebFXTreeItem("${ca.id}","${v3x:escapeJavascript(ca.name)}","javascript:changeComboTree('${ca.id}')");
								aa${fn:replace(ca.id,'-','_')}.icon= icon1;
								aa${fn:replace(ca.id,'-','_')}.openIcon= icon1;
							</c:forEach>
							
							<c:forEach items="${childAccountList}" var="ca">
								<c:choose>
									<c:when test="${ca.superior == account.id}">
										root.add(aa${fn:replace(ca.id,'-','_')});
									</c:when>
									<c:otherwise>
										aa${fn:replace(ca.superior,'-','_')}.add(aa${fn:replace(ca.id,'-','_')});
									</c:otherwise>
								</c:choose>
							</c:forEach>
							
							document.write(root);
							document.close();
						</script>
					</c:when>
					<c:otherwise>
						<c:set var="isOuter" value="${!currentUser.internal}" />
						<c:set var="myDeptId" value="${currentUser.departmentId}" />
						<script type="text/javascript">
							var root = new WebFXTree("${account.id}", "${account.name}", "javascript:ucShowAccountUser('${account.id}')");
							root.setBehavior('classic');
							root.icon = "<c:url value='/common/images/templete.gif'/>";
							root.openIcon = "<c:url value='/common/images/templete.gif'/>";	
							
							var icon1 = "/seeyon/common/js/xtree/images/file1.gif";
							var icon2 = "/seeyon/common/js/xtree/images/file2.gif";
							
							<c:forEach items="${deptList}" var="t">
							<c:set value="${v3x:toString(t.v3xOrgDepartment.id)}" var="dId"/>
								<c:choose>
									<c:when test="${isOuter && !v3x:containInCollection(external, t.v3xOrgDepartment)}">
										<c:set var="onlick" value="javascript:void(null)" />
									</c:when>
									<c:otherwise>
										<c:set var="onlick" value="javascript:ucShowSelDep('${t.v3xOrgDepartment.id}')" />
									</c:otherwise>
								</c:choose>
								
								var aa${fn:replace(t.v3xOrgDepartment.id,'-','_')}= new WebFXTreeItem("${t.v3xOrgDepartment.id}","${v3x:escapeJavascript(t.v3xOrgDepartment.name)}(${deptOnlineNumMap[dId]}/${deptNumMap[dId]})","${onlick}");
								
								if('${t.v3xOrgDepartment.isInternal}' == 'false'){
									aa${fn:replace(t.v3xOrgDepartment.id,'-','_')}.icon= icon2;
									aa${fn:replace(t.v3xOrgDepartment.id,'-','_')}.openIcon= icon2;
								}else{
									aa${fn:replace(t.v3xOrgDepartment.id,'-','_')}.icon= icon1;
									aa${fn:replace(t.v3xOrgDepartment.id,'-','_')}.openIcon= icon1;
								}
							</c:forEach>
							
							<c:forEach items="${deptList}" var="t">
								<c:choose>
									<c:when test="${t.parentId==null}">
										root.add(aa${fn:replace(t.v3xOrgDepartment.id,'-','_')});
									</c:when>
									<c:otherwise>
										aa${fn:replace(t.parentId,'-','_')}.add(aa${fn:replace(t.v3xOrgDepartment.id,'-','_')});
									</c:otherwise>
								</c:choose>
							</c:forEach>
							
							document.write(root);
							document.close();
							
							<%--登录进来默认选中所在的部门--%>
							if(${isSameAccount} && ${myDeptId} != ${account.id} && ${!isOuter}){
								var pNodes = [];
								function findPNodes(obj){
									if(obj && obj.parentNode){
										pNodes[pNodes.length] = obj.parentNode;
										findPNodes(obj.parentNode);
									}
								}
								findPNodes(aa${fn:replace(myDeptId,'-','_')});
								for(var i = pNodes.length; i > 0; i--){
									pNodes[i- 1].expand();
								}
								try{
								aa${fn:replace(myDeptId,'-','_')}.select();
								}catch(e){}
							}	
						</script>
					</c:otherwise>
				</c:choose>
			</div>
		</td>
	</tr>
</table>
<div id="accountContent" style="display:none; position: absolute;">
	<ul id="accountTree" class="ztree" style="margin-top:0; width:100%;"></ul>
</div>
</body>
</html>