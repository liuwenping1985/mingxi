<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/govdocbody.js${ctp:resSuffix()}"></script>
	
</head>
<body>	
<input type="hidden" id="govdocContent" name="govdocContent" value="${content }"/><!-- 公文正文id-->
<input type="hidden" id="govdocContentType" name="govdocContentType" value="${govdocContentType  }"/><!-- 公文正文类型value，41,42,43-->
<input type="hidden" id="govdocBodyType" name="govdocBodyType" value="${govdocContentType }"/>
<input type="hidden" id="contentFileId" name="contentFileId" value="${content }"/>
<c:set var="defaultBodyType" value="${(govdocContentType==''||govdocContentType==null)?(param.defaultBodyType==null?'OfficeWord':param.defaultBodyType):'OfficeWord' }" />
<script type="text/javascript">
 var fullEditorURL="${path}/edocController.do?method=fullEditor";
 if('${connotEdit}' != null && '${connotEdit}' != ''){
	 fullEditorURL += "&connotEdit=${connotEdit}";
 }
</script>
<form id="sendForm" name="sendForm">
<div name="edocContentDiv" id="edocContentDiv" style="width:0px;height:0px;overflow:hidden; position: absolute;">
	<v3x:editor htmlId="content" editType="${editType }"
	  content="${content }"
	  originalNeedClone="false"
	  category="4"
	  createDate="${govdocContentCreateTime }"
	  type="${contentType == null ? defaultBodyType : contentType}"
	/>
</div>
</form>
</body>
<script type="text/javascript">
$(document).ready(function(){
	try{
		parent.window.document.getElementById("taohongBtn").disabled = false;
	}catch(e){}
});
</script>
</html>
