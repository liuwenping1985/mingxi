<%--
 $Author: muyx $ 
 $Rev: 1.0 $
 $Date:: 2012-9-7 上午10:55:54#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@page import="java.util.*"%>
<script type="text/javascript">
$(function(){
    var random = $.messageBox({
        'type': 100,
        'imgType':2,
        'title':"${ctp:i18n('doc.system.message')}",
        'msg': "${ctp:i18n('rss.enable.alert')}",
        buttons: [{
        id:'btn1',
            text: "${ctp:i18n('metadata.manager.ok')}",
            handler: function () { 
                window.location.href = "${path}/systemopen.do?method=showSystemOpenSpace&userType=system";
            }
        }]
    });
});
</script>
