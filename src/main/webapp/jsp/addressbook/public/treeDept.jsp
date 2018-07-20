<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" src="<c:url value='/apps_res/addressbook/js/public.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/zTree/js/jquery.ztree.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/zTree/css/zTreeStyle/zTreeStyle.css${v3x:resSuffix()}" />">
<style type="text/css">
	ul.ztree {margin-top:10px; border:1px solid #617775; background:#fff; height:360px; overflow-y:auto; overflow-x:auto;}
</style>
</head>
<script type="text/javascript">
	var accountID = "${account.id}";

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
	var zNodes = [
		${v3x:selectTree(accountsList, 'id', 'superior', 'name', pageContext)}
	];
	</c:if>

	function onClick(e, treeId, treeNode) {
		var zTree = $.fn.zTree.getZTreeObj("accountTree"), nodes = zTree.getSelectedNodes(), v = "";
		for (var i = 0; i < nodes.length; i ++) {
			v += nodes[i].id + ",";
		}
		if(v.length > 0) v = v.substring(0, v.length - 1);
		changeType(v);
	}

	function showMenu() {
		var accountObj = $("#currentAccountId");
		var accountOffset = $("#currentAccountId").offset();
		$("#accountContent").css({left:accountOffset.left + "px", top:accountOffset.top + accountObj.outerHeight() + "px"}).slideDown("fast");

		var treeObj = $.fn.zTree.getZTreeObj("accountTree");
		var node = treeObj.getNodeByParam("id", accountID, null);
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
<body scroll="no">
<c:set var="isOuter" value="${!v3x:currentUser().internal}" />
<c:set var="myDeptId" value="${v3x:currentUser().departmentId}" />
<div class="main_div_center">
  <div class="right_div_center">
    <div class="scrollList border_r" style="width:99%">
		<%-- 单位下拉列表 --%>
		<c:if test="${isGroupVer}">
			<td>
				<div id="select_input_div" class="select_input_div" style="width: 98%" onclick="showMenu(); return false;">
                	<input name="currentAccountId" id="currentAccountId" type="text" class="select_input" readonly="readonly" value="${account.name}" />
				</div>
			</td>
		</c:if>
		<c:choose>
			<c:when test="${isRoot}">
				<script type="text/javascript">
					var root = new WebFXTree("${account.id}", "${account.name}", "");
					root.setBehavior('classic');
					root.icon = "<c:url value='/apps_res/addressbook/images/templete.gif'/>";
					root.openIcon = "<c:url value='/apps_res/addressbook/images/templete.gif'/>";	
					
					var icon1 ="${pageContext.request.contextPath}/common/js/xtree/images/file1.gif";
					
					var aa${fn:replace(account.id,'-','_')}= new WebFXTreeItem("${account.id}","${v3x:escapeJavascript(account.name)}","javascript:changeType('${account.id}')");
				    aa${fn:replace(account.id,'-','_')}.icon= icon1;
				    aa${fn:replace(account.id,'-','_')}.openIcon= icon1;
				    
					<c:forEach items="${childAccountList}" var="ca">
						var aa${fn:replace(ca.id,'-','_')}= new WebFXTreeItem("${ca.id}","${v3x:escapeJavascript(ca.name)}","javascript:changeType('${ca.id}')");
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
				<script type="text/javascript">
					var root = new WebFXTree("${account.id}", "${account.name}", "javascript:showAccount('${account.id}')");
					root.setBehavior('classic');
					root.icon = "<c:url value='/apps_res/addressbook/images/templete.gif'/>";
					root.openIcon = "<c:url value='/apps_res/addressbook/images/templete.gif'/>";	
				    
					var icon1 ="${pageContext.request.contextPath}/common/js/xtree/images/file1.gif";
					var icon2 ="${pageContext.request.contextPath}/common/js/xtree/images/file2.gif";
					<c:forEach items="${inlist}" var="t">
						<c:choose>
							<c:when test="${isOuter && !v3x:containInCollection(external,t.v3xOrgDepartment) }">
								<c:set var="onlick" value="javascript:void(null)" />
							</c:when>
							<c:otherwise>
								<c:set var="onlick" value="javascript:showDepartment('${t.v3xOrgDepartment.id}')" />
							</c:otherwise>
						</c:choose>
						var aa${fn:replace(t.v3xOrgDepartment.id,'-','_')}= new WebFXTreeItem("${t.v3xOrgDepartment.id}","${v3x:escapeJavascript(t.v3xOrgDepartment.name)}","${onlick}");
						aa${fn:replace(t.v3xOrgDepartment.id,'-','_')}.icon= icon1;
					    aa${fn:replace(t.v3xOrgDepartment.id,'-','_')}.openIcon= icon1;
					</c:forEach>
					
					<c:forEach items="${inlist}" var="t">
						<c:choose>
							<c:when test="${t.parentId==null}">
								root.add(aa${fn:replace(t.v3xOrgDepartment.id,'-','_')});
							</c:when>
							<c:otherwise>
								aa${fn:replace(t.parentId,'-','_')}.add(aa${fn:replace(t.v3xOrgDepartment.id,'-','_')});
							</c:otherwise>
						</c:choose>
					</c:forEach>
					
					<c:forEach items="${externallist}" var="t">
    					<c:choose>
    						<c:when test="${isOuter && !v3x:containInCollection(external,t.v3xOrgDepartment) }">
    							<c:set var="onlick" value="javascript:void(null)" />
    						</c:when>
    						<c:otherwise>
    							<c:set var="onlick" value="javascript:showDepartment('${t.v3xOrgDepartment.id}')" />
    						</c:otherwise>
    					</c:choose>
    					var aa${fn:replace(t.v3xOrgDepartment.id,'-','_')}= new WebFXTreeItem("${t.v3xOrgDepartment.id}","${v3x:escapeJavascript(t.v3xOrgDepartment.name)}","${onlick}");
    					aa${fn:replace(t.v3xOrgDepartment.id,'-','_')}.icon= icon2;
    					aa${fn:replace(t.v3xOrgDepartment.id,'-','_')}.openIcon= icon2;
				    </c:forEach>
				
    				<c:forEach items="${externallist}" var="t">
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
					root.select();
				</script>
			</c:otherwise>
		</c:choose>
    </div>
  </div>
</div>
<div id="accountContent" style="display:none; width:90%; position: absolute;">
	<ul id="accountTree" class="ztree" style="margin-top:0; width:90%;"></ul>
</div>
</body>
</html>