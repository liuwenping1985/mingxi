<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.portlet.auto.apply.js')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<style>
.imageBorder {
   border-radius:10px;
}
.stadic_layout_body{
   top:0px;
}

.stadic_right {
		float: right;
		width: 100%;
		height: 100%;
		position: absolute;
		z-index: 100;
		overflow: auto;
}

.stadic_right .stadic_content {
		margin-left: 27px;
		height: 100%;
}

.stadic_left {
		width: 120px;
		float: left;
		top: 45%;
		position: absolute;
		height: 100%;
		z-index: 300;
}

.zszx_file_list li {
		margin-top: 10px;
		margin-right: 10px;
		float: left;
		width: 48%;
		height: 250px;
}
</style>
<script type="text/javascript">
function getParam() {
  var o = new Object();
  var applyUserId = "${ctp:escapeJavascript(param.applyUserId)}";
  var applyOuttime = $("#beginDate",window.parent.document).val();
  var applyBacktime = $("#endDate",window.parent.document).val();
  o.applyUserId=applyUserId;
  o.applyOuttime=applyOuttime;
  o.applyBacktime=applyBacktime;
  o.isAdmin = "${ctp:escapeJavascript(param.isAdmin)}";
  return o;
 }
</script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoOrderImage.js"></script>
</head>
<body class="h100b over_hidden">
<div class="stadic_layout border_l border_r">
    <div class="stadic_layout_body stadic_body_top_bottom border_t margin_b_10" >
        <ul id="display_image" class="bg_color_white clearfix zszx_file_list">
        </ul>
    </div>
    <div class="stadic_layout_footer stadic_footer_height border_t margin_b_5">
        <div id="ajaxgridbar" class="common_over_page align_right margin_t_5 margin_r_10">
          ${ctp:i18n('doc.common.flipinfo.display.count')}<input id="_afpSize" class="common_over_page_txtbox" type="text" value="20">
          <span class="margin_r_20">${ctp:i18n('doc.common.flipinfo.records.every.page')}/${ctp:i18n('doc.common.flipinfo.records.total')}<span id="_afpTotal">0</span>${ctp:i18n('doc.common.flipinfo.records.unit')}</span> <a href="javascript:void(0);" id="_afpFirst"
          class="common_over_page_btn" title="${ctp:i18n('doc.common.flipinfo.first.page')}"><em class="pageFirst"></em> </a> <a href="javascript:void(0);"
          id="_afpPrevious" class="common_over_page_btn" title="${ctp:i18n('doc.common.flipinfo.last.page')}"><em class="pagePrev"></em> </a> <span
          class="margin_l_10">${ctp:i18n('doc.common.flipinfo.records.order')}</span><input id="_page_id" type="text" class="common_over_page_txtbox">${ctp:i18n('doc.common.flipinfo.records.page')}/<span
          id="_afpPages">0</span>${ctp:i18n('doc.common.flipinfo.pages.total')} <a href="javascript:void(0);" id="_afpNext" class="common_over_page_btn" title="${ctp:i18n('doc.common.flipinfo.next.page')}"><em
          class="pageNext"></em> </a> <a href="javascript:void(0);" id="_afpLast" class="common_over_page_btn" title="${ctp:i18n('doc.common.flipinfo.end.page')}"><em
          class="pageLast"></em> </a><a id="_page_btn" class="common_button common_button_grayDark margin_lr_10" href="javascript:void(0)">go</a>
          </div>
    </div>
</div>
</body>
</html>