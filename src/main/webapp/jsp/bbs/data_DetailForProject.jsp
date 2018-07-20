<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="./boarduse/taglib.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>

<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/bbs" prefix="bbs"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>

<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.bulletin.resources.i18n.BulletinResource" var="bulI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.inquiry.resources.i18n.InquiryResources" var="surveyI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.bbs.resources.i18n.BBSResources" />

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/bbs/css/bbs.css${v3x:resSuffix()}" />">

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/bulletin/js/bulletin.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/bbs/js/bbs.js${v3x:resSuffix()}" />"></script>

<fmt:message key="common.datetime.pattern" var="dataPattern" bundle="${v3xCommonI18N}"/>

<html:link renderURL="/bbs.do" var="detailURL" />
<html:link renderURL="${pageContext.request.contextPath}/apps_res/bbs/data_Detail.jsp" var="previewURL" />
<html:link renderURL='/genericController.do' var="genericController" />
<script type="text/javascript">
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>");
v3x.loadLanguage("/apps_res/bbs/js/i18n");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
_ = v3x.getMessage;
</script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="bbs.preview.label" /></title>
<link
	href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>"
	rel="stylesheet" type="text/css">
<script type="text/javascript">
	//获取前一页面传来的对象
	var bbsObj = window.opener;

	//讨论标题
	var articleName = bbsObj.document.getElementById("articleName");
	var title = articleName.value.escapeHTML();
	var defaultTitle = getDefaultValue(articleName).escapeHTML();
	if(title == defaultTitle){
		title = "";
	}

	//判断原创转发
	var rFlag = bbsObj.document.all.rFlag.value.escapeHTML()
	if(rFlag==1){
		title=title+bbsObj.document.all.yuan.value.escapeHTML()
		
		
	}else if(rFlag==2){
		title = title+bbsObj.document.all.zhuan.value.escapeHTML();
	}

	//发布部门
	var deptName = bbsObj.document.all.deptName.value.escapeHTML();
	//岗位
	var postName = bbsObj.document.all.postName.value.escapeHTML();
	//头像
	var issuerImage = bbsObj.document.all.issuerImage.value.escapeHTML();
    var image = bbsObj.document.all.image.value.escapeHTML();

	var boardName = bbsObj.document.all.bbsTypeName.value.escapeHTML();
	
	//发布范围
	var issueAreaNameObj = bbsObj.document.getElementById("issueAreaName");
	var issueAreaName = issueAreaNameObj.value;
	var defaultIssueAreaName = getDefaultValue(issueAreaNameObj);
	if(issueAreaName == defaultIssueAreaName){
		issueAreaName = "";
	}


	//附件
	var attNumber = bbsObj.getFileAttachmentNumber(0);
    var att = "",att2="";
	if(attNumber != 0){
		att = "<table style='margin-left:1px;'><tr><td valign='top'>" + 
			"<div class='div-float' style='font-weight: bolder; font-size: 12px;'>"
			+ '<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />' + "：</div></td>" + 
			"<td valign='top' style='color: #335186;'>" + bbsObj.getFileAttachmentName(0) + "</td></tr></table>";
	}
	
	attNumber = bbsObj.getFileAttachmentNumber(2);
	if(attNumber != 0){
		att2 = "<table style='margin-left:1px;'><tr><td valign='top'>" + 
		"<div class='div-float' style='font-weight: bolder; font-size: 12px;'>"
		+ '<fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />' + "：</div></td>" + 
		"<td valign='top' style='color: #335186;'>" + bbsObj.getFileAttachmentName(2) + "</td></tr></table>";
	}
	
        
	// 预览页面是否出现打印按钮
	var printButtons = false;
	if (bbsObj.document.all.b.checked) {
		printButtons = true;
	}
	//正文内容
    var content = '';
    if(v3x.useFckEditor){
	    try {
			content = oEditorFCK.EditingArea.Document.body.innerHTML;
		} catch (E) {
		}
        content = oEditorFCK.EditingArea.Document.body.innerHTML;
    }else{
        content = bbsObj.CKEDITOR.instances['content'].getData(); 
    }

	
	function printResult() {
		var mergeButtons = document.getElementsByName("mergeButton");
		for ( var s = 0; s < mergeButtons.length; s++) {
			var mergeButton = mergeButtons[s];
			mergeButton.style.display = "none";
		}
		var p = document.getElementById("printThis");
		var aa = "";
		var mm = p.innerHTML;
		var list1 = new PrintFragment(aa, mm);
		var tlist = new ArrayList();
		tlist.add(list1);
		printList(tlist, new ArrayList());
		for ( var s = 0; s < mergeButtons.length; s++) {
			var mergeButton = mergeButtons[s];
			mergeButton.style.display = "";
		}
	}
</script>
</head>
<body scroll='no' onkeydown="listenerKeyESC()" style="margin: 0px; padding: 0px;">
	<%@include file="./showViewPage.jsp"%>
</body>
</html>
