<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="docHeader.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<script type="text/javascript">
//隐藏左边
if(getA8Top()){
    if(getA8Top().hideLeftNavigation){
        getA8Top().hideLeftNavigation();
    }
}
var alertNotExist = '${alertNotExist}';
if(alertNotExist == 'true'){
	alert(v3x.getMessage('DocLang.doc_source_folder_no_exist'));
}
var docLibAlert = '${param.docLibAlert}';
if(docLibAlert != '') {
	alert(v3x.getMessage('DocLang.' + docLibAlert));
}
</script>
</head>
<frameset cols="137,*" id="layout" border="1" frameBorder="10" frameSpacing="5" class="border_all bg_color">
    <frame src="${detailURL}?method=listRoots" frameborder="no" name="treeFrame" id="treeFrame" scrolling="auto">
	<c:choose>
		<c:when test="${shareOrBorrowFlag == true}">
			<frame id="rightFrame" name="rightFrame" src="${detailURL}?method=rightNew&resId=${id}&frType=${frType}&docLibId=${docLibId}&docLibType=${docLibType}&isShareAndBorrowRoot=true&all=false&edit=false&add=false&readonly=true&browse=false&list=false&v=${v}" framespacing="0" frameborder="no" border="0" scrolling="no">
		</c:when>
		<c:otherwise>
			<frame id="rightFrame" name="rightFrame" src="${detailURL}?method=rightNew&resId=${root.docResource.id}&frType=${root.docResource.frType}&projectTypeId=${projectTypeId}&docLibId=${docLibId}&docLibType=${docLibType}&isShareAndBorrowRoot=false&all=${root.allAcl}&edit=${root.editAcl}&add=${root.addAcl}&readonly=${root.readOnlyAcl}&browse=${root.browseAcl}&list=${root.listAcl}&v=${v}" framespacing="0" frameborder="no" border="0" scrolling="no">
		</c:otherwise>
	</c:choose>
	<noframes>
	<body topmargin="0" leftmargin="0">
	</body>
	</noframes>
</frameset>
</html>