<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
.stadic_layout_body{
  top:0px;
  <c:if test="${param.isEdit eq 'true'}">
    bottom: 40px;
  </c:if>
  <c:if test="${param.isEdit ne 'true'}">
    bottom: 10px;
  </c:if>
}
.stadic_footer_height{
  _height:40px;
}
</style>
<title>派车-编辑</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoSendEdit.js"></script>
</head>
<body class="h100b over_hidden">
 <div id='layout'>
  <div class="layout_center over_hidden h100b" id="center">
      <!--查看区域-->
      <div id="auditArea" class="h100b stadic_layout">
          <!--正文区域-->
          <div id="applyDiv" class="form_area stadic_layout_body stadic_body_top_bottom">
            <div id="autoApplyDiv">
              <%@include file="autoUseInfor.jsp" %>
            </div>
            <div id="autoWorkFlowDiv" class="display_none" style="height: 100%; overflow: hidden;">
                <iframe id="autoWorkFlowIframe" frameborder="0" scrolling="no" width="100%" height="100%"></iframe>
            </div>
          </div>
      </div>
  </div>
  <c:if test="${param.isEdit eq 'true'}">
    <div id="btnDiv" class="stadic_layout_footer stadic_footer_height border_t padding_tb_10 align_right bg_color_black" style="z-index: 100">
      <!--下边区域-->
      <a id="btnok" onclick="fnOK('sendOut');" class="common_button common_button_emphasize" href="javascript:void(0);">${ctp:i18n('office.auto.ppcbcc.js')}</a> 
      <a id="btnok" onclick="fnOK('onlySend');" class="common_button common_button_emphasize" href="javascript:void(0);">${ctp:i18n('office.tbar.send.js')}</a> 
      <a id="btncancel" onclick="fnCancel();" class="common_button common_button_grayDark margin_r_10" href="javascript:void(0);">${ctp:i18n('office.auto.not.send.car.js')}</a>
    </div>
  </c:if>
</div>
</body>
</html>