<%--
 $Author:  $
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
</head>
<body>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div class="layout_north" layout="height:35,sprit:false,border:false">
            <div id="toolbar"></div>
        </div>
        <div  id="center" class="layout_center page_color over_hidden" layout="border:false">
            <div style="width: 100%;height: 100%">
            <iframe id="colListIframe" src="${path }/form/formSection.do?method=list${param.column }&templateId=${templateId}" scrolling="no"  frameborder="0" width="100%" height="100%"></iframe>
            </div>
        </div>
    </div>
    <%@ include file="formSectionFlow.js.jsp" %>
    <script type="text/javascript" src="${path}/ajax.do?managerName=formSectionManager"></script>
    <div id="jsonSubmit"/>
</body>
</html>