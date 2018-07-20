<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
<script type="text/javascript" src="<c:url value='/apps_res/addressbook/js/public.js${v3x:resSuffix()}'/>"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/zTree/js/jquery.ztree.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/zTree/css/zTreeStyle/zTreeStyle.css${v3x:resSuffix()}" />">
<style type="text/css">
	ul.ztree {margin-top:10px; border:1px solid #617775; background:#fff; height:360px; overflow-y:auto; overflow-x:auto;}
</style>
<script type="text/javascript">
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

	<c:if test="${isGroupVer}">
	var zNodes =[
		${v3x:selectTree(accountsList, 'id', 'superior', 'name', pageContext)}
	];
	</c:if>

	function onClick(e, treeId, treeNode) {
		var zTree = $.fn.zTree.getZTreeObj("accountTree"), nodes = zTree.getSelectedNodes(), v = "";
		for (var i = 0; i < nodes.length; i ++) {
			v += nodes[i].id + ",";
		}
		if(v.length > 0) v = v.substring(0, v.length - 1);
		changeTypeSysTeam(v);
	}

	function showMenu() {
		var accountObj = $("#currentAccountId");
		var accountOffset = $("#currentAccountId").offset();
		$("#accountContent").css({left:accountOffset.left + "px", top:accountOffset.top + accountObj.outerHeight() + "px"}).slideDown("fast");

		var treeObj = $.fn.zTree.getZTreeObj("accountTree");
		var node = treeObj.getNodeByParam("id", "${account.id}", null);
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

	function setSelectWidth(){
		var _w = $('#select_input_div').width();
		$("#currentAccountId").width(_w - 18);
	}

	$(document).ready(function(){
		<c:if test="${isGroupVer}">
		$.fn.zTree.init($("#accountTree"), setting, zNodes);
		</c:if>

		setSelectWidth();
	});
</script>
</head>
<body scroll="no">
<div class="main_div_center">
  <div class="right_div_center">
    <div class="center_div_center">
        <div class="scrollList border_r" style="width:99%">
	<c:if test="${isGroupVer}">
		<td>
			<div id="select_input_div" class="select_input_div" onclick="showMenu(); return false;">
               	<input name="currentAccountId" id="currentAccountId" type="text" class="select_input" readonly="readonly" value="${account.name}" />
			</div>
		</td>
		<br />
	</c:if>
	<script type="text/javascript">
		var root = new WebFXTree("${account.id}", "${account.name}", "javascript:void(null)");
		root.setBehavior('classic');
		root.icon = "<c:url value='/apps_res/addressbook/images/templete.gif'/>";
		root.openIcon = "<c:url value='/apps_res/addressbook/images/templete.gif'/>";	
			
		<c:forEach items="${teamlist }" var="t">
			var aa${fn:replace(t.v3xOrgTeam.id,'-','_')}= new WebFXTreeItem("${t.v3xOrgTeam.id}","${v3x:escapeJavascript(t.v3xOrgTeam.name)}","javascript:showSysTeam('${t.v3xOrgTeam.id}', '${account.id}')");
			root.add(aa${fn:replace(t.v3xOrgTeam.id,'-','_')});
		</c:forEach>
		
		document.write(root);
		root.select();
	</script>
    </div>
</div>
</div>
</div>
<div id="accountContent" style="display:none; position:absolute; width:90%;">
	<ul id="accountTree" class="ztree" style="margin-top:0; width:90%;"></ul>
</div>
</body>
</html>
