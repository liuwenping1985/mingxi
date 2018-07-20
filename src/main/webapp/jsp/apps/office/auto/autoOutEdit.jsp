<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<style type="text/css">
.stadic_layout_body {
  top: 0px;
  bottom: 30px;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>还车编辑</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoOutEdit.js"></script>
</head>
<body class="h100b over_hidden">
 <div class="stadic_layout h100b font_size12">
    <div class="stadic_layout_body stadic_body_top_bottom margin_b_10" style="_overflow-y:auto;_overflow-x:hidden;_height: 100%;">
      <!--中间区域-->
      <div id="autoUseTab" class="form_area set_search align_center w100b">
        <%@include file="autoUseInfor.jsp" %>
      </div>
    </div>
    <c:if test="${param.isEdit eq 'true' and (state eq 10)}">
      <div id="btnDiv" class="stadic_layout_footer stadic_footer_height border_t padding_tb_5 align_right bg_color_black">
        <!--下边区域-->
        <c:if test="${(param.isEdit eq 'true')and isAdmin and (state eq 10)}">
          <a id="btnEdit" onclick="fnOK('save');" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('office.auto.save.js')}</a> 
        </c:if>
        <a id="btnOut" onclick="fnOK('out');" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('office.tbar.out.js')}</a> 
        <a id="btncancel" onclick="fnCancel();" class="common_button common_button_grayDark margin_r_10" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
      </div>
    </c:if>
 </div>
</body>
</html>