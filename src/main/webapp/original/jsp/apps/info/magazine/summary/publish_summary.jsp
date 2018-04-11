<%--
 $Author:  zhaifeng$
 $Rev:  $
 $Date:: 2012-09-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../include/info_header.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<title>${ctp:toHTML(infoMagazine.subject)}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<script>
var openFrom = "${openFrom}";
var isDealPageShow = "${isDealPageShow}";
var commentCount = '${fn:length(commentList)}';
var  magazineId="${magazineId}";
var _currentUserId = "${CurrentUser.id}";
</script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/info/js/magazine/summary/audit_summary.js${ctp:resSuffix()}"></script>
<style type="text/css">
.title_area {
	max-width: 80px;
}

.stadic_layout_body{
    position: static;/*覆盖all-main.css的定位方式*/
    margin-top: 10px;
}
</style>
</head>

<body class="h100b over_hidden page_color"  onunload="">

	<div id='layout' class="comp" comp="type:'layout'">
        
		<div class="layout_center over_hidden h100b" id="center">
			
			<div class="h100b stadic_layout">             	
  				<div id="content_workFlow" class="stadic_layout_body stadic_body_top_bottom processing_view align_center border_t w100b content_view" style="width: 100%;top:0px;visibility: visible;">
                   
                    <ul class="view_ul align_left content_view" id='display_content_view'>
                    	<li id="cc" class="view_li" style="margin-bottom: 2px;min-width:786px;">
					        <jsp:include page="/WEB-INF/jsp/common/content/content.jsp" />
					    </li>
					    <!--附言区域-->
					    <jsp:include page="/WEB-INF/jsp/common/content/comment.jsp" />
					</ul>
					
             	</div><!-- stadic_layout_body -->
                        
        	</div><!-- stadic_layout -->
			
		</div><!-- layout_center -->
		
	</div><!-- layout -->
	
</body>
	