<%--
 $Author: wangh $
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
<title>栏目树</title>
</head>
<body>
<div style="position:absolute;overflow:auto;height:100%;width:100%">
<div id="sectionTree"></div>
</div>
<script type="text/javascript">
	$(document).ready(function() {
	    $("#sectionTree").tree({
	      idKey : "id",
	      pIdKey : "categoryId",
	      nameKey : "name",
			title : "title",
	      onDblClick : function() {
	          if("${param.type}" == "generalSection"){
	              //通用栏目没有中间一层页面，所以直接调用最外层的方法
                parent.selectSection();
              }else{
                  parent.selectToRightDiv();
              }
	      },
	      nodeHandler : function(n) {
			  n.name= n.data.name;
			  if(typeof n.title == "undefined"){
				  n.title = n.name;
				  n.data.formCreator = "";
			  }
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
		return $("#sectionTree").treeObj().getSelectedNodes()[0];
	}
</script>
</body>
</html>