<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="edocHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>

<script>
//puyc
function showDetail(id,affairId){
  		var url = "edocController.do?method=detail&canNotOpen=isYes&openEdocByForward=true&summaryId="+id+"&affairId="+affairId;
  		if(url == null || url == ""){
  			alert("<fmt:message key='edoc.resourse.notExist'/>");//alert("资源不存在！");
  	  		}else{
  		var rv = v3x.openWindow({
  	        url: url,
  	        workSpace: 'yes',
  	        dialogType: "open"
  	    });
  	  		}
  	} 
</script>
	</head>
	<body >
<div class="center_div_row2" id="scrollListDiv" style="top:0;">
<form name="listForm" id="listForm" method="post" style="margin: 0px">
	<v3x:table htmlId="listTable" data="newEdocList" var="bean"  className="sort ellipsis edocellipsis">  
        <c:set var="click" value="showDetail('${bean.id }','${bean.affairId }')"/>
		<v3x:column width="47%" type="String" label="edoc.element.wordno.label" onClick="${click}" 
			className="cursor-hand sort" alt="${bean.docMark}">
			<c:out value="${bean.docMark}" />
		</v3x:column>
		<v3x:column width="20%" type="String" label="edoc.element.subject" onClick="${click}" 
			className="cursor-hand sort" alt="${bean.subject}">	
			<c:out value="${bean.subject}" />		
		</v3x:column>
		
		<v3x:column width="20%" type="String" label="edoc.element.sendtounit" onClick="${click}" 
			className="cursor-hand sort" alt="${bean.sendTo}">
			<c:out value="${bean.sendTo}" />
		</v3x:column>
		<v3x:column width="20%" type="String" label="edoc.post.date" onClick="${click}" 
			className="cursor-hand sort" >
			
			<span title="<fmt:formatDate value="${bean.startTime}"  pattern="${datePattern}"/>">
			<fmt:formatDate value="${bean.startTime}"  pattern="${datePattern}"/>
			</span>
		</v3x:column>
	</v3x:table>
</form>
</div>

	
<iframe name=tempIframe id=tempIframe style="height:0px;width:0px;"></iframe>
	</body>
</html>