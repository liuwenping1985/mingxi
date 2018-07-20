<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html id='commentHtml' style="height:100%;">
<head>
</head>
<style>
	.content_view .view_li_hasoverflow {
  		*zoom: 1;
  		width: 99%;
  		margin-left: auto;
  		margin-right: auto;
  		background: white;
	}
	.content_view .view_li{
		width:440px;
	}
</style>
<body style="height:100%;background:#D2D2D2;" onload="">
<div class='content_view' style="height:100%;">
    <!--附言区域-->
       	<jsp:include page="/WEB-INF/jsp/common/content/comment.jsp" />
    	
    	<textarea id='formTextId' class='hidden'>${repealRecordText}</textarea>
</div>
</body>
<script type="text/javascript">
var canMoveISignature = "${canMoveISignature}";
</script>
</html>
