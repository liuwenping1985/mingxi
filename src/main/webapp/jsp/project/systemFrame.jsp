<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>mainframe</title>
<%@include file="projectHeader.jsp"%>
</head>
<script type="text/javascript">
$().ready(function(){
	showCtpLocation("F02_projectSystemPage");
});
var toolbar;
var disabledMyBar=function(name,enabled){//true 可用  false禁用
	if(!!!enabled){
		toolbar.disabled(name);
	}else{
		toolbar.enabled(name);
	}
};
</script>
<frameset rows="30,*" framespacing="0" cols="*">
	<frame src="<html:link renderURL='/project.do' />?method=showToolBar" name="toolBarFrame" id="toolBarFrame"
		frameborder="no" scrolling="no" noresize/>
	<frameset cols="22%,*" id="treeFrameset" framespacing="5" frameborder="yes" bordercolor="#ececec">
		<frame src="<html:link renderURL='/project.do' />?method=showSystemTree" name="systemTreeFrame" frameborder="0"
			scrolling="no" id="systemTreeFrame" />
		<frame src="<html:link renderURL='/project.do' />?method=showDetali" name="detaliFrame" id="detaliFrame" frameborder="no"
			scrolling="no" />
		<!-- 
			 <frameset rows="35%,*" id='sx' cols="*"  frameborder="no" border="0">	
			 		<frame src="<html:link renderURL='/project.do' />?method=systemList" name="listFrame" id="listFrame" frameborder="no"
			         scrolling="no" />
				<frame src="<c:url value="/common/detail.jsp" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no" />
			</frameset>
		-->
	</frameset>
</frameset>
<noframes>
<body scroll="no"></body>
</noframes>
</html>
