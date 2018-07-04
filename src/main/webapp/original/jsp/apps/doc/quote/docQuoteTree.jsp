<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<c:set var="current_user_id" value="${sessionScope['com.seeyon.current_user'].id}"/>
</head>
<body style="background: white">
<div class="scrollList">
<script type="text/javascript">
    var paramFrom ="${v3x:escapeJavascript(param.from)}";
    webFXTreeConfig.defaultText = "<fmt:message key='selectPeople.page.title' bundle='${v3xMainI18N}' />";
    var root = new WebFXTree();
    var commonDocSections = parent.docSections;
    root.action = "javascript:void(0)";

    if(commonDocSections && commonDocSections.size() > 0){
    	var common_doc = new WebFXTreeItem("", "<fmt:message key='channel.common.node.label' bundle='${v3xMainI18N}' />");
    	root.add(common_doc);
    	for(var i = 0; i < commonDocSections.size(); i ++){
    		var doc_section = commonDocSections.get(i);
    		var doc_node = new WebFXTreeItem(doc_section.id, doc_section.name, "", "parent.selectOne()");
    		doc_node.properties.put("sectionCategory", "common");
    		common_doc.add(doc_node);
    	}
    }

    <c:forEach items="${roots}" var="root">
    	<c:choose>
    		<c:when test="${root.otherAccountId!=0}" >
    			<c:set value="(${v3x:toHTML(v3x:getAccount(root.otherAccountId).shortName)})" var="otherAccountShortName" />
    		</c:when>
    		<c:otherwise>
    			<c:set value="" var="otherAccountShortName" />
    		</c:otherwise>
    	</c:choose>
    
    	var tree_${root.docResource.id} = new WebFXLoadTreeItem("${root.docResource.id}", "${v3x:escapeJavascript(root.frName)}${otherAccountShortName}", null, null, null, null, "<c:url value='/apps_res/doc/images/docIcon/${root.closeIcon}'/>", "<c:url value='/apps_res/doc/images/docIcon/${root.openIcon}'/>");	
    	tree_${root.docResource.id}.src = "<c:url value='/doc.do?method=xmlJspQuote&resId=${root.docResource.id}&frType=${root.docResource.frType}'/>";
    	tree_${root.docResource.id}.fileIcon = "<c:url value='/apps_res/doc/images/docIcon/${root.closeIcon}'/>";
    	tree_${root.docResource.id}.action = "javascript:showSrcAndAction4Quote('${root.docResource.id}','${root.docResource.frType}','${root.docResource.docLibId}','${root.docLibType}','${root.isBorrowOrShare}','${root.allAcl}','${root.editAcl}','${root.addAcl}','${root.readOnlyAcl}','${root.browseAcl}','${root.listAcl}','${v3x:escapeJavascript(param.referenceId)}')";
    	
    	root.add(tree_${root.docResource.id});
    </c:forEach>
    document.write(root);
</script>
</div>
</body>
</html>