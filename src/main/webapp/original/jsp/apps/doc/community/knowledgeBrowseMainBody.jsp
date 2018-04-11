<%--
 $Author: muyx $ 
 $Rev: 1.0 $
 $Date:: 2012-12-12 上午10:55:54#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html style="border-left: solid 10px #EDEDED; border-right: solid 10px #EDEDED; height: 100%; overflow: hidden;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>正文</title>
<script type="text/javascript" charset="utf-8">
    
<%@include file="/WEB-INF/jsp/apps/doc/js/knowledgeBrowseMainBody.js"%>
    
</script>
</head>
<body style="height: 100%; overflow-y: scroll;">
    <div class="content_view processing_view align_center" style="padding:1px 0;">
        <ul class="view_ul align_left">
            <li class="view_li content_text margin_b_10">
                <jsp:include page="/WEB-INF/jsp/common/content/content.jsp"/>
            </li>
        </ul>
    </div>
</body>
</html>