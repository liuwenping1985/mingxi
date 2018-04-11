<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%@include file="../edocHeader.jsp" %>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}" />"></script>
		<link href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
	</head>
	<body onresize="resizeBody(150,'treeframeset','min','left')">
		<div class="scrollList padding5tree">
			<script type="text/javascript">
				var root = new WebFXTree("root", "<fmt:message key = 'menu.edoc.keyword.label' />", "javascript:showList(0);");
				root.setBehavior('classic');
				root.icon = "<c:url value='/common/images/left/icon/5101.gif'/>";
				root.openIcon = "<c:url value='/common/images/left/icon/5101.gif'/>";

				<c:forEach items="${keywordList}" var="keyword">
					<c:choose>
						<%-- 后台排序上一定要先一级再二级 --%>
						<c:when test="${keyword.parentId == null || keyword.parentId == 0}">
							var node${fn:replace(keyword.id,'-','_')} = new WebFXTreeItem("${keyword.id}","${v3x:toHTML(keyword.name)}","javascript:showList('${keyword.id}');");
							node${fn:replace(keyword.id,'-','_')}.icon = "<c:url value='/common/images/left/icon/1201.gif'/>";
							node${fn:replace(keyword.id,'-','_')}.openIcon = "<c:url value='/common/images/left/icon/1201.gif'/>";
							
							root.add(node${fn:replace(keyword.id,'-','_')});
						</c:when>
						<c:when test="${keyword.levelNum == 2}">
							try{
								var node${fn:replace(keyword.id,'-','_')} = new WebFXTreeItem("${keyword.id}","${v3x:toHTML(keyword.name)}","javascript:showList('${keyword.id}');");
								node${fn:replace(keyword.id,'-','_')}.icon = "<c:url value='/common/images/left/icon/5104.gif'/>";
								node${fn:replace(keyword.id,'-','_')}.openIcon = "<c:url value='/common/images/left/icon/5104.gif'/>";
								
								if(typeof(node${fn:replace(keyword.parentId,'-','_')}) != "undefined") {
									node${fn:replace(keyword.parentId,'-','_')}.add(node${fn:replace(keyword.id,'-','_')});
								}
							}catch(e){}
						</c:when>
						<c:otherwise>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			
				document.write(root);
				webFXTreeHandler.select(root);

				<%--改变显示模式--%>
				function showList(nodeId){
			           parent.listFrame.location.href = "${edocKeyWordUrl}?method=list&currentNodeId="+nodeId;
				}

				// 定位到指定单位
				function selectKeyword(keywordId) {
					try {
						var currentNode = eval(("node"+keywordId).replace('-', '_'));
						var array = new Array();
						var p = currentNode.parentNode;
						while (p) {
							array.push(p);
							p = p.parentNode;
						}
						array.reverse();
						for (var i=0; i<array.length; i++) {
							array[i].expand();
						}
						currentNode.select();
					} catch (e) {
						root.select();
					}
				}
			</script>
		</div>
		<iframe src="javascript:void(0)" name="hiddenIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
	</body>
</html>