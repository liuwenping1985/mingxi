<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html style="height: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EDGE">
<%@include file="../exchangeHeader.jsp"%>
<link href="<c:url value="/common/images/${v3x:getSystemProperty('portal.porletSelectorFlag')}/favicon${v3x:getSystemProperty('portal.favicon')}.ico${v3x:resSuffix()}" />" type="image/x-icon" rel="icon"/>
<script>
	window.onload=function(){ 
		var error = "${error}";
		if(error != null && error !=""){
			alert(parent.v3x.getMessage(''+error+''));
			window.returnValue = "true";
			getA8Top().returnValue = "true";
			window.close();
		}
	}
</script>
</head>

<body style="overflow:hidden;height: 100%;">
  <c:set value="${(from=='supervise' || !empty from) ? from : param.from}" var="f"/>
  <c:set value="${(empty param.affairId || isEdocRecDistribute) ? affairId : param.affairId}" var="affId"/>
	<iframe width="100%" height="100%" src="${exchange}?method=edit&upAndDown=${param.upAndDown}&id=${id}&modelType=${modelType}&reSend=${reSend}&affairId=${affairId}&fromlist=${param.fromlist}&affairState=${affairState}" name="detailMainFrame" id="detailMainFrame" scrolling="no" >
	</iframe>
</body>
</noframes>
</html>