<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>直接派车-新建，出车共用界面</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoDSendEdit.js"></script>
</head>
<body class="h100b over_hidden bg_color">
<div id='layout'>
  <div class="stadic_layout" style="height: ${param.isFromMsg eq 'true' ? '100%': (param.isEdit eq 'true') ? '460px':'490px'};overflow: auto;">
   <div id="autoUseTab" class="form_area set_search align_center" style="width:97%;">
     <%@include file="autoUseInfor.jsp" %>
   </div>
  </div>
  <c:if test="${param.isEdit eq 'true'}">
    <div class="stadic_layout_footer stadic_footer_height">
      <div id="btnDiv" class="stadic_layout_footer stadic_footer_height border_t padding_tb_10 align_right bg_color_black">
        <!--下边区域-->
        <c:if test="${(param.isEdit eq 'true') and (param.isDEdit eq 'true')}">
          <a id="btnok" onclick="fnOK('sendOut');" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('office.auto.ppcbcc.js')}</a>
          <a id="btnok" onclick="fnOK('onlySend');" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('office.tbar.send.js')}</a>
        </c:if>
        <c:if test="${(param.isEdit eq 'true')and isAdmin and (state eq 10)}">
          <a id="btnok" onclick="fnOutOK('save');" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('office.auto.save.js')}</a>
        </c:if>
        <c:if test="${(param.isEdit eq 'true') and (state eq 10)}">
          <a id="btnOut" onclick="fnOutOK('out');" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('office.auto.out.car.js')}</a>
        </c:if>
        <c:if test="${(param.isEdit eq 'true') and ((state eq 10) or (param.isDEdit eq 'true'))}">
          <a id="btncancel" onclick="fnCancel();" class="common_button common_button_grayDark margin_r_10" href="javascript:void(0)">${ctp:i18n('office.auto.cancel.js')}</a>
        </c:if>
      </div>
    </div>
  </c:if>
</div>
</body>
</html>