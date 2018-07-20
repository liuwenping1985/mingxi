<%--
 $Author: weijh $
 $Rev: 509 $
 $Date:: 2012-07-21 00:08:40#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@page import="com.seeyon.ctp.common.flag.*"%>
<%@ include file="/WEB-INF/jsp/common/common4coll.jsp"%>
<html>
<head>
<title>
<c:if test="${isNew=='true'}">
新建
</c:if>
<c:if test="${isNew!='true'}">
修改
</c:if>
</title>
<script type="text/javascript">
    var cWindow;
    var saveProcessBar;
    var tips = true;
    var isNew = "${ctp:escapeJavascript(isNew)}";
    var _contentAllId = "${contentAllId}";
    var _fromSrc = '${fromSrc}';
</script>
<script type="text/javascript" src="${path}/common/form/common/newUnFlowFormData.js${ctp:resSuffix()}"></script>
</head>
<body scroll="no">
    <div class="comp" comp="type:'layout'" id="layout">
        <div class="layout_north" layout="height:30,maxHeight:30,minHeight:30,sprit:false" >
            <%-- 保存 --%>
            <a id="unflowbtnsave" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n("form.query.save.label")}</a>
        <c:if test="${isNew=='true'}">
            <%-- 保存新建 --%>
            <a id="btnsaveandnew" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n("form.newdata.saveAndNew.label")}</a>
        </c:if>
            <%-- 取消 --%>
            <a id="unflowbtncancel" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n("form.forminputchoose.cancel")}</a>
        </div>
        <div class="layout_center" style="overflow: hidden;">
            <c:if test="${isNew=='true'}">
                <iframe onload="checkLoad()" id="newFormDataFrame" width="100%" height="100%" frameBorder="no" src='${path }/content/content.do?isFullPage=true&_isModalDialog=true&moduleId=${ctp:toHTML(formTemplateId)}&moduleType=${ctp:toHTML(moduleType)}&rightId=${ctp:toHTML(rightId)}&contentType=20&viewState=1'></iframe>
            </c:if>
            <c:if test="${isNew!='true'}">
                <iframe onload="checkLoad()" id="newFormDataFrame" width="100%" height="100%" frameBorder="no" src='${path }/content/content.do?isFullPage=true&_isModalDialog=true&moduleId=${ctp:toHTML(contentAllId)}&moduleType=${ctp:toHTML(moduleType)}&rightId=${ctp:toHTML(rightId)}&contentType=20&viewState=1'></iframe>
            </c:if>
        </div>
    </div>
</body>
</html>