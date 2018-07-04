<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="ldap.ou.click" bundle="${ldaplocale}"/></title>
<base  target=_self>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xloadtree.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/xmlextras.js${v3x:resSuffix()}" />"></script>
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/form/css/form.css${v3x:resSuffix()}" />">    
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/hr/css/default.css${v3x:resSuffix()}" />">
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />">
</head>
<script type="text/javascript">
var rValue = null;
function showRdn(element) {
	rValue = element;
}

function OK() {
	return rValue;
}

</script>
<body style="overflow:auto">
<table class="popupTitleRight" style="position:absolute;left:0;top:0;z-index:1;overflow:hidden;" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr height="20">
		<td height="20" class="PopupTitle"><fmt:message key="ldap.ou.click" bundle="${ldaplocale}"/></td>
	</tr>
	<tr>
		<td  style="padding:3px" height="250">
			<div class="scrollList" style="overflow:hidden;">
			<script type="text/javascript">
				try{
					//var root = new WebFXTree();
					var iconImg = "<c:url value='/apps_res/doc/images/docIcon/corp_open.gif'/>";
					var root = new WebFXTree("root", "${rootDN}", "javascript:showRdn('${rootDN}')");
					root.setBehavior('classic');
					root.icon = iconImg;
					<c:forEach items="${userList}" var="root">
						var name = "${v3x:toHTML(root.name)}";
						var tree_${root.id} = new WebFXLoadTreeItem("${root.id}", "${v3x:toHTML(root.name)}", null, null, null, null, iconImg, iconImg);
					   	tree_${root.id}.src = encodeURI("<c:url value='/ldap/ldap.do?method=getOrgSubNode&parentDn=${root.dnName}&parentId=${root.id}&type=${root.type}'/>");
					   	tree_${root.id}.action = "javascript:showRdn('${v3x:toHTML(root.dnName)}')";
						root.add(tree_${root.id});
					</c:forEach>
					document.write(root);
				}catch(e){
					alert(e.name+" "+e.message);
				}
			</script>
			</div>
		</td>
	</tr>
	<tr>
		<td style="padding: 0px;" >
		</td>
	</tr>
</table>
</body>
</html>
