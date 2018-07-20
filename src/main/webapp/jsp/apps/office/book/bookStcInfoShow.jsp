<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>

<script type="text/javascript" charset="UTF-8"
  src="${path}/apps_res/office/js/book/bookStcInfoShow.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8"
  src="${path}/apps_res/office/js/pub/autoStcPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8"
  src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<html class="h100b over_hidden">
<head>
    <style type="text/css">
        .stadic_body_top_bottom{
            bottom:0px;
        }
    </style>
</head>
<body>    
     <div id='layout' class="comp bg_color" comp="type:'layout'">
        <div class="layout_center stadic_layout margin_l_5" layout="border:true" >
            <div class="stadic_layout_body stadic_body_top_bottom" id="reportResult">
                <div id="tabs"  class="stadic_layout" style="*position:absolute;height:100%;width:100%">
                    <ul id="queryResult" class="align_center border_tb common_tabs_body stadic_layout_body stadic_body_top_bottom" style="top:0px;bottom:35px;overflow:auto; background:#fff;">
                    </ul>
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
            </div>
        </div>
    </div>
</body>
</html>