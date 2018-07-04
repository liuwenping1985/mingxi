<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<script type="text/javascript" charset="UTF-8"
  src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8"
  src="${path}/apps_res/office/js/auto/autoStcInfo.js${ctp:resSuffix()}"></script>
  <script type="text/javascript" charset="UTF-8"
  src="${path}/apps_res/office/js/pub/autoStcPub.js${ctp:resSuffix()}"></script>
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
        <div class="layout_north" id="layout_north" layout="height:180,maxHeight:180,minHeight:100,spiretBar:{show:true,handlerT:function(){layout.setNorth(0);},handlerB:function(){layout.setNorth(180);}}">
             <div id="tabs" class="margin_t_5 margin_r_5 ">
                <div class="border_alls">
                <div class="form_area"  id="queryCondition" >
                </div>
                <form action="#" id="resolveExecel">
                    <div id="execelCondition"></div>
                </form>
                </div>
            </div>
        </div>
        <div class="layout_center stadic_layout margin_l_5" layout="border:true" >
            <div class=" padding_lr_10  set_search align_left" id="oper">
                <table class="w100b">
                    <tr>
                        <td colspan="2">
                            <span class="left">${ctp:i18n('office.asset.assetInfoStc.ptjjg.js')}：
                            <a class="img-button margin_r_5" href="javascript:void(0)" id="reportToExcel" onclick="fnDownExcel()"><em class="ico16 export_excel_16"></em>${ctp:i18n('office.tbar.export.js')}</a> 
                            <a class="img-button margin_r_5" href="javascript:void(0)" id="printReport" onclick="printColl()"><em class="ico16 print_16"></em>${ctp:i18n('office.tbar.print.js')}</a> 
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                        <span id="queryTitle" class="font_size14" style="font-weight:bold"></span>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                        <span id="contFace"></span>
                        </td>
                        <td align="right">
                        <span id="countDate"></span>
                        </td>
                    </tr>
                      <tr>
                        <td align="left">
                        <span id="quertTime" class="marigin_t_5"></span>
                        </td>
                        <td align="right">
                        <span id=""></span>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="stadic_layout_body stadic_body_top_bottom" id="reportResult">
                <div id="tabs"  class="stadic_layout" style="*position:absolute;height:98%;width:100%">
                    <ul id="queryResult" class="align_center border_tb common_tabs_body stadic_layout_body stadic_body_top_bottom" style="top:60px;bottom:35px;overflow:auto; background:#fff;">
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
            <form id="exportAutoStc" action="${path }/office/autoStc?method=exportAutoStc" method="post"></form>
        </div>
    </div>
</body>
</html>