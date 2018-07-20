<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
	<%@ include file="../include/header.jsp" %>
	
<script type="text/javascript">
<!--
var status_0 = "0,*";
var status_1 = "30%,*";
var status_2 = "*,12";
var status_3 = "30%,*";

var indexFlag = 0;
function previewFrame(){
	var obj = parent.parent.document.all.sx;
	if(obj == null){
		obj = parent.document.all.sx;
	}
	
	if(obj == null){
		return;
	}
	
	if(indexFlag > 3){
		indexFlag = 0;
	}
	
	eval("obj.rows = status_" + indexFlag);
	indexFlag++;
}
//-->
</script>
</head>
<body class="detailBody">
<%@ include file="../include/dataDetail.jsp" %>
</body>
</html>