<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-09-18
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建业务配置</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager"></script>
</head>
<body>
<div style="position:absolute;overflow:auto;height:100%;width:100%">
<div id="formTemplateTree"></div>
</div>
<script type="text/javascript">
	$(document).ready(function() {
	    $("#formTemplateTree").tree({
	      idKey : "id",
	      pIdKey : "categoryId",
	      nameKey : "name",
	      onDblClick : function() {
	    	  parent.selectToCreateMenu();
	      },
	      nodeHandler : function(n) {
	    	  if(n.data.sourceType == -1){
	            //n.isParent = true;
	            n.open = true;
	    	  }
	    	  if(n.data.sourceType == 0){
	    	    n.isParent = true;
	    	  }
	    	  <c:if test="${needExpan}">
	            n.open = true;
	    	  </c:if>
	        }
	    });
	});
	
	function getSelectedNodes(){
		return $("#formTemplateTree").treeObj().getSelectedNodes()[0];
	}
</script>
</body>
</html>