<%--
 $Author: muyx $
 $Rev: 1 $
 $Date:: 2013-06-20 下午2:08:33#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/officeTab.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/officePub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/office.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/officeSBar.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/officeTBar.js${ctp:resSuffix()}"></script>
<%-- 全局的js对象，缓存页面公共变量，以及需要处理的内容 --%>
<script type="text/javascript">
    var _path = "${path}";
    var pTemp = {jval:'${jval}',isCarsAdmin:'${isCarsAdmin}',_option:"${option}"};
</script>