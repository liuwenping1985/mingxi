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

<link href="<c:url value="/common/images/${v3x:getSystemProperty('portal.porletSelectorFlag')}/favicon${v3x:getSystemProperty('portal.favicon')}.ico${v3x:resSuffix()}" />" type="image/x-icon" rel="icon"/>
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
	var rFlag = bbsObj.document.getElementById("rFlag").value.escapeHTML()
	if(rFlag==1){
		title=title+bbsObj.document.getElementById("yuan").value.escapeHTML()
		
		
	}else if(rFlag==2){
		title = title+bbsObj.document.getElementById("zhuan").value.escapeHTML();
	}
	//团队名称
    var spaceName = bbsObj.document.getElementById("spaceName").value.escapeHTML();
	//发布部门
	var deptName = bbsObj.document.getElementById("publishDepartmentName").value.escapeHTML();
	//岗位
	var postName = bbsObj.document.getElementById("publishPostName").value.escapeHTML();
	//头像
	var issuerImage = bbsObj.document.getElementById("issuerImage").value.escapeHTML();
    var image = bbsObj.document.getElementById("image").value.escapeHTML();
	//bbstype_Name是1 为部门讨论。
	var bbstype_Name = bbsObj.document.getElementById("bbstype_Name").value;
    //发布范围
    var issueAreaNameObj = bbsObj.document.getElementById("issueAreaName");
    var issueAreaName = issueAreaNameObj.value;
    var boardName = "";
	if (bbstype_Name == "1") {
		boardName = deptName;
	} else if (bbstype_Name == "4") {
	    boardName = spaceName;
	} else {
		var typeOptions = bbsObj.document.getElementById("boardIdBlock").options;
		if(typeOptions){
			for ( var i = 0; i < typeOptions.length; i++) {
				if (typeOptions[i].selected) {
					boardName = typeOptions[i].text;
				}
			}
		}
		
		var defaultIssueAreaName = getDefaultValue(issueAreaNameObj);
		if(issueAreaName == defaultIssueAreaName){
			issueAreaName = "";
		}
	}
	//附件
	var attNumber = bbsObj.getFileAttachmentNumber(0);
    var att = "";
	if(attNumber != 0){
		att = "<table><tr><td valign='top' nowrap='nowrap'>" + 
			"<div class='div-float' style='font-weight: bolder; font-size: 12px;'>"
			+ '<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />' + "：</div></td>" + 
			"<td valign='top' style='color: #335186;'>" + bbsObj.getFileAttachmentName(0) + "</td></tr></table>";
	}
	//关联文档
	var attNumber2 = bbsObj.getFileAttachmentNumber(2);
    var att2 = "";
    if(attNumber2 != 0){
        att2 = "<table><tr><td valign='top' nowrap='nowrap'>" + 
          "<div class='div-float' style='font-weight: bolder; font-size: 12px;'>"
          + _("collaborationLang.print_mydocument") + "：</div></td>" + 
          "<td valign='top' style='color: #335186;'>" + bbsObj.getFileAttachmentName(2) + "</td></tr></table>";
    }  
	var bbstype_Name = bbsObj.document.getElementById("bbstype_Name").value;
	// 预览页面是否出现打印按钮
	var printButtons = false;
	if (bbsObj.document.all.b.checked) {
		printButtons = true;
	}
	//正文内容
  var content;
  if(v3x.useFckEditor){
    var oEditorFCK=bbsObj.FCKeditorAPI.GetInstance('content');  
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
<style type="text/css">
ol{margin: auto;}
</style>
</head>
<body scroll='no' onkeydown="listenerKeyESC()" style="margin: 0px; padding: 0px;">
	<%@include file="./showViewPage.jsp"%>
</body>
</html>
