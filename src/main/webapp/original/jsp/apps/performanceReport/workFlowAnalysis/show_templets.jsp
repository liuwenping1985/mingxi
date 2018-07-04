<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.collaboration.resources.i18n.CollaborationResource"/>
<%@ include file="../common/INC/noCache.jsp"%>
<%
    int collaboration = com.seeyon.v3x.collaboration.templete.domain.TempleteCategory.TYPE.collaboration_templete.ordinal();
    int form = com.seeyon.v3x.collaboration.templete.domain.TempleteCategory.TYPE.form.ordinal();
    int edoc = com.seeyon.v3x.collaboration.templete.domain.TempleteCategory.TYPE.edoc.ordinal();
    int edoc_send = com.seeyon.v3x.collaboration.templete.domain.TempleteCategory.TYPE.edoc_send.ordinal();
    int edoc_rec = com.seeyon.v3x.collaboration.templete.domain.TempleteCategory.TYPE.edoc_rec.ordinal();
    int edoc_sginReport = com.seeyon.v3x.collaboration.templete.domain.TempleteCategory.TYPE.sginReport.ordinal();
    request.setAttribute("collaborationCate",collaboration);
    request.setAttribute("formCate",form);
    request.setAttribute("edocCate",edoc);
    request.setAttribute("edoc_sendCate",edoc_send);
    request.setAttribute("edoc_recCate",edoc_rec);
    request.setAttribute("edoc_sginReportCate",edoc_sginReport); 
%>
<fmt:setBundle basename="com.seeyon.v3x.collaboration.resources.i18n.CollaborationResource" var="collI18N"/>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/agent/js/agent.js${v3x:resSuffix()}" />"></script>
<title></title>
</head>
<body>
<script type="text/javascript">
	var ICON_TEMPLETE = "<c:url value='/apps_res/collaboration/images/text_wf.gif' />";			   	   <%-- 菜单/栏目-表单模板 --%>
	var img_text = "<c:url value='/apps_res/collaboration/images/text.gif' />";
	var img_workflow = "<c:url value='/apps_res/collaboration/images/workflow.gif' />";
	var img_templete = "<c:url value='/apps_res/collaboration/images/text_wf.gif' />";
	
	//判断添加公文 
	<c:if test="${v3x:isEnableEdoc() && (faTemplete != null || shouTemplete != null  || qianTemplete != null )}">
		var newtree${edocCate} = new WebFXTree('', "<fmt:message key='templete.category.type.${edocCate}' />");
		newtree${edocCate}.setBehavior('classic');
		newtree${edocCate}.icon = "<c:url value='/apps_res/collaboration/images/templete.gif'/>";
		newtree${edocCate}.openIcon = "<c:url value='/apps_res/collaboration/images/templete.gif'/>";
		<c:if test="${faTemplete != null}">
		var newtree${edoc_sendCate} = new WebFXTreeItem('send', "<fmt:message key='templete.category.type.${edoc_sendCate}' />", '', 'javascript:parent.isMultiSelect(${param.isMultiSelect })', '', webFXTreeConfig.folderIcon, webFXTreeConfig.openFolderIcon);
		newtree${edocCate}.add(newtree${edoc_sendCate});
		<c:forEach items="${faTemplete}" var="t">
			<c:set value="${col:showTempleteCreatorAlt(t.memberId)}" var="theCreatorAlt"/>
			<c:set var="edocSubject" value="${t.subject}"/>
		  	var	newtree${fn:replace(t.id, '-', '_')} = new WebFXTreeItem("${t.id}", "${v3x:escapeJavascript(edocSubject)}",'', 'javascript:parent.isMultiSelect(${param.isMultiSelect })', '', ICON_TEMPLETE);
		    newtree${fn:replace(t.id, '-', '_')}.isTemplete = true;
		    newtree${fn:replace(t.id, '-', '_')}.templeteType = "${edoc_sendCate}";
			newtree${edoc_sendCate}.add(newtree${fn:replace(t.id, '-', '_')});
		</c:forEach>
		</c:if>
		<c:if test="${shouTemplete != null}">
			//收文模板
			var newtree${edoc_recCate} = new WebFXTreeItem('rec', "<fmt:message key='templete.category.type.${edoc_recCate}' />", '', 'javascript:parent.isMultiSelect(${param.isMultiSelect })', '', webFXTreeConfig.folderIcon, webFXTreeConfig.openFolderIcon);
			newtree${edocCate}.add(newtree${edoc_recCate});
			<c:forEach items="${shouTemplete}" var="t">
				<c:set value="${col:showTempleteCreatorAlt(t.memberId)}" var="theCreatorAlt"/>
				<c:set var="edocSubject" value="${t.subject}"/>
				var newtree${fn:replace(t.id, '-', '_')} = new WebFXTreeItem("${t.id}", "${v3x:escapeJavascript(edocSubject)}",'', "javascript:parent.isMultiSelect(${param.isMultiSelect })", '', ICON_TEMPLETE);
			    newtree${fn:replace(t.id, '-', '_')}.isTemplete = true;
			    newtree${fn:replace(t.id, '-', '_')}.templeteType = "${edoc_recCate}";
				newtree${edoc_recCate}.add(newtree${fn:replace(t.id, '-', '_')});
			</c:forEach>
		</c:if>
		<c:if test="${qianTemplete != null}">
			//签报模板
			var newtree${edoc_sginReportCate} = new WebFXTreeItem('qianbao', "<fmt:message key='templete.category.type.${edoc_sginReportCate}' />",'', "javascript:parent.isMultiSelect(${param.isMultiSelect })", '',webFXTreeConfig.folderIcon, webFXTreeConfig.openFolderIcon);
			newtree${edocCate}.add(newtree${edoc_sginReportCate});
			<c:forEach items="${edocTemplete}" var="t">
				<c:set value="${col:showTempleteCreatorAlt(t.memberId)}" var="theCreatorAlt"/>
				<c:set var="edocSubject" value="${t.subject}"/>
				var newtree${fn:replace(t.id, '-', '_')} = new WebFXTreeItem("${t.id}", "${v3x:escapeJavascript(edocSubject)}", '',"javascript:parent.isMultiSelect(${param.isMultiSelect })",  '',ICON_TEMPLETE);
		    	newtree${fn:replace(t.id, '-', '_')}.isTemplete = true;
			    newtree${fn:replace(t.id, '-', '_')}.templeteType = "${edoc_sginReportCate}";
				newtree${edoc_sginReportCate}.add(newtree${fn:replace(t.id, '-', '_')});
			</c:forEach>
		</c:if>
		document.write(newtree${edocCate});

		<c:if test="${param.expand=='true'}">
			<c:if test="${faTemplete != null}">
				newtree${edoc_sendCate}.expand();
			</c:if>
			<c:if test="${shouTemplete != null}">
				newtree${edoc_recCate}.expand();
			</c:if>
			<c:if test="${qianTemplete != null}">
				newtree${edoc_sginReportCate}.expand();
			</c:if>
		</c:if>
	</c:if>
	<c:if test="${collTemplete != null}">
	//添加协同表单模板
	var tree = new WebFXTree('0', "<fmt:message key='templete.category.type.common' bundle='${collI18N }'/>", '');
	tree.setBehavior('classic');
	tree.icon = "<c:url value='/apps_res/collaboration/images/templete.gif'/>";
	tree.openIcon = "<c:url value='/apps_res/collaboration/images/templete.gif'/>";

	<c:forEach items="${categorysModel.categorys}" var="c">
		var system${fn:replace(c.id, '-', '_')} =  new WebFXTreeItem("${c.id}", "${v3x:escapeJavascript(c.name)}", '', 'javascript:parent.isMultiSelect(${param.isMultiSelect })' , '',webFXTreeConfig.folderIcon, webFXTreeConfig.openFolderIcon);
	</c:forEach>
	<c:forEach items="${categorysModel.categorys}" var="c">
		<c:choose>
			<c:when test="${c.parentId == 4 || c.parentId == 0}">
				tree.add(system${fn:replace(c.id, '-', '_')});
			</c:when>
			<c:otherwise>
				system${fn:replace(c.parentId, '-', '_')}.add(system${fn:replace(c.id, '-', '_')});
			</c:otherwise>
		</c:choose>
	</c:forEach>

	<c:forEach items="${collTemplete}" var="t">
	<c:set value="${col:showTempleteCreatorAlt(t.memberId)}" var="theCreatorAlt"/>
	  	var tempete${fn:replace(t.id, '-', '_')} = new WebFXTreeItem("${t.id}", "${v3x:escapeJavascript(t.subject)}",'',"javascript:parent.isMultiSelect(${param.isMultiSelect })", '', ICON_TEMPLETE);
	    tempete${fn:replace(t.id, '-', '_')}.isTemplete = true;
	    tempete${fn:replace(t.id, '-', '_')}.templeteType = "${collaborationCate}";
	    <c:choose>
	    <c:when test="${t.categoryId != 0}">
			system${fn:replace(t.categoryId, '-', '_')}.add(tempete${fn:replace(t.id, '-', '_')});
		</c:when>
		<c:otherwise>
			tree.add(tempete${fn:replace(t.id, '-', '_')});
		</c:otherwise>
		</c:choose>
	</c:forEach>

	document.write(tree);
	document.close();
	<c:if test="${param.expand=='true'}">
		<c:forEach items="${categorysModel.categorys}" var="c">
			system${fn:replace(c.id, '-', '_')}.expand();
		</c:forEach>
	</c:if>
	</c:if>
	
	<c:if test="${param.expand!='true'}">
		parent.initSelectedFormTempletes();
	</c:if>
</script>
</body>
</html>