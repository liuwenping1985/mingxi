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
<title>业务配置</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager"></script>
<script type="text/javascript">
$(document).ready(function(){
  <c:if test = "${bizConfig eq null}">
  $.alert({
    'msg':"${ctp:i18n('formsection.config.view.delete.label')}",
    'ok_fn':function(){
      top.showMenu("${path}/form/business.do?method=listBusiness");
    }
  });
  </c:if>
});
</script>
</head>
<body style="width: 100%;">
    <div class="font_size12" style="width: 100%;margin-top: 20px;">
        <div class="clearfix" style="width: 200px;line-height: 20px;margin-left: 35%">
            <div class="left" style="width: 80px;text-align: right;">${ctp:i18n("formsection.config.name.label") }：</div>
            <div class="left" style="width: 100px;"><input type="text" id="bizConfigName" name="bizConfigName" value="${bizConfig.name}"  title="${bizConfig.name}"  class="input-disabled" readonly ></div>
        </div>
        <div class="clearfix" style="width: 240px;line-height: 20px;margin-left: 35%;vertical-align: middle;margin-top: 5px;">
            <div class="left" style="width: 80px;text-align: right;">${ctp:i18n("bizconfig.use.authorize.label") }：</div>
            <div class="left" style="width: 100px;"><input type="text" name="shareScope" id="shareScope" value="${scopeNames}"  title="${scopeNames}"   class="input-disabled" readonly   /></div>
        </div>
        <c:forEach items="${bizConfig.items}" var="item">
        <%String random = "flowMenuType"+com.seeyon.ctp.util.UUIDLong.absLongUUID();%>
        <div class="clearfix" style="line-height: 20px;margin-left: 35%;vertical-align: middle;margin-top: 5px;">
            <div class="left" style="width: 75px;text-align: right;padding-right: 5px;">
                [${item.sourceTypeName}]
            </div>
            <div class="left" style="">
                <INPUT name="menuName" value="${item.name}"  id="${item.sourceId}" title="${item.name}"  type="text" class="input-disabled" readonly />
	            <INPUT name="sourceType" value="${item.sourceType}" type="hidden" />
	            <INPUT name="sourceId" value="${item.sourceId}" type="hidden" />
	            <INPUT name="formAppmainId" value="${item.formAppmainId}" type="hidden" />
	            <c:if test="${item.sourceType==1}">
	                <label for="<%=random%>1" style="margin-right: 20px;"><input type='radio' id="<%=random%>1" name='<%=random%>' value='1' <c:if test="${item.flowMenuType==1}"> checked='checked' </c:if> disabled/>${ctp:i18n('common.toolbar.new.label')}</label>
	                <label for="<%=random%>2"><input type='radio' id="<%=random%>2" name='<%=random%>' value='2' <c:if test="${item.flowMenuType==2}"> checked='checked' </c:if> disabled/>${ctp:i18n("imagenews.list.label") }</label>
	            </c:if>
	            <c:if test="${item.sourceType!=1}">
	                <input type='hidden' name="<%=random%>" value='' />
	            </c:if>
	            <input type='hidden' name='flowMenuTypeName' value='<%=random%>' />
            </div>
        </div>
        </c:forEach>
    </div>
</BODY>
</HTML>

