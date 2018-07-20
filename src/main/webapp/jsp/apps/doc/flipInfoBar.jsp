<%--
 $Author: muyx $
 $Rev: 1 $
 $Date:: 2012-11-20 下午2:08:33#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<div id="ajaxgridbar" class="common_over_page align_right margin_t_10 margin_r_10">
${ctp:i18n('doc.common.flipinfo.display.count')}<input id="_afpSize" class="common_over_page_txtbox" type="text" value="20">
<span class="margin_r_20">${ctp:i18n('doc.common.flipinfo.records.every.page')}/${ctp:i18n('doc.common.flipinfo.records.total')}<span id="_afpTotal">0</span>${ctp:i18n('doc.common.flipinfo.records.unit')}</span> <a href="javascript:void(0);" id="_afpFirst"
        class="common_over_page_btn" title="${ctp:i18n('doc.common.flipinfo.first.page')}"><em class="pageFirst"></em> </a> <a href="javascript:void(0);"
        id="_afpPrevious" class="common_over_page_btn" title="${ctp:i18n('doc.common.flipinfo.last.page')}"><em class="pagePrev"></em> </a> <span
        class="margin_l_10">${ctp:i18n('doc.common.flipinfo.records.order')}</span><input id="_page_id" type="text" class="common_over_page_txtbox">${ctp:i18n('doc.common.flipinfo.records.page')}/<span
        id="_afpPages">0</span>${ctp:i18n('doc.common.flipinfo.pages.total')} <a href="javascript:void(0);" id="_afpNext" class="common_over_page_btn" title="${ctp:i18n('doc.common.flipinfo.next.page')}"><em
        class="pageNext"></em> </a> <a href="javascript:void(0);" id="_afpLast" class="common_over_page_btn" title="${ctp:i18n('doc.common.flipinfo.end.page')}"><em
        class="pageLast"></em> </a><a id="_page_btn" class="common_button common_button_gray margin_lr_10" href="javascript:void(0)">go</a>
</div>