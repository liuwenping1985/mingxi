<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../edocHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<link href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>
<script>
		function chageIframe(edocType){
			parent.listFrame.location.href="edocSupervise.do?method=list&edocType="+edocType;   
		}
		</script>
</head>
<body>
	<div>
		<script type="text/javascript">
					var supervise ="${v3x:getSystemProperty('edoc.Supervise')}";
					var posting = new WebFXTree("posting", "<fmt:message key='edoc.supervise.transacted.posting' />", "javascript:chageIframe('0')");
					var receiving = new WebFXTree("receiving", "<fmt:message key='edoc.supervise.transacted.receiving' />", "javascript:chageIframe('1')");
					//GOV-4769.公文管理-公文督办，漏了签报督办 start
					var sign = new WebFXTree("receiving", "<fmt:message key='edoc.supervise.transacted.sign' />", "javascript:chageIframe('2')");
					//GOV-4769.公文管理-公文督办，漏了签报督办 end
					if(supervise!='false'){
						document.write(posting);
						document.write(receiving);
						//GOV-4769.公文管理-公文督办，漏了签报督办 start
						document.write(sign);
						//GOV-4769.公文管理-公文督办，漏了签报督办 end
					}
					<c:choose>
					<c:when test="${param.edocType=='0'}">
						webFXTreeHandler.select(posting);
					</c:when>
					<c:when test="${param.edocType=='2'}">
						webFXTreeHandler.select(sign);
					</c:when>
					<c:otherwise>
						webFXTreeHandler.select(receiving);
					</c:otherwise>
					</c:choose>
		</script>
	</div>
</body>
</noframes>
</html>