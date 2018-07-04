<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.manager.StockStcManagerImpl.yplytj.js')} </title>
<style type="text/css">
.stadic_layout_body {
  bottom: 0px;
  top:60px;
  overflow: hidden;
}

</style>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/stockPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/stock/stockUseStc.js"></script>
</head>
<body class="h100b over_hidden">
  <div id='layout' class="comp" comp="type:'layout'">
    <div class="layout_north" layout="height:130,maxHeight:130,border:false,spiretBar:{show:true,handlerT:function(){pTemp.layout.setNorth(0);pTemp.tab.reSize();},handlerB:function(){pTemp.layout.setNorth(130);pTemp.tab.reSize();}}">
      <div id="stockInfoDiv" class="form_area common_center w90b">
        <table id="stockUseTab" class="w100b margin_t_5" border="0" cellSpacing="0" cellPadding="0" align="center">
          <tr>
            <th width="80" noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.book.bookStcInfo.tjd.js')}:</label></th>
            <td colspan="2" align="left">
             <div class="common_radio_box margin_l_5 clearfix">
                <label class="margin_r_10 hand" for="stcType0">
                <input id="stcType0" name="stcType" onclick="fnStcTypeClk('dept');" value="dept" checked="checked" class="radio_com" type="radio">${ctp:i18n('office.auto.autoStcInfo.bm.js')}</label>
                <label class="margin_r_10 hand" for="stcType1">
                <input id="stcType1"  name="stcType" onclick="fnStcTypeClk('user');" value="user" class="radio_com"  type="radio">${ctp:i18n('office.auto.bookStcInfo.ry.js')}</label>
                <input id="stcDept" class="comp font_size12" comp="type:'selectPeople', panels:'Department',selectType:'Department'">
                <input id="stcUser" class="comp font_size12 display_none" comp="type:'selectPeople',panels:'Department,Team,Post,Level',selectType:'Member'">
              </div>
            </td>
          </tr>
          
          <tr>
            <th noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.auto.autoStcInfo.bblx.js')}:</label></th>
            <td>
             <div class="common_radio_box margin_l_5 clearfix">
              <label class="margin_r_10 hand" for="reportType0">
                <input id="reportType0" name="reportType" onclick="fnReportTypeClk('general');" value="general" class="radio_com" checked="checked" type="radio">${ctp:i18n('office.stock.nomanl.report.js')}</label>
              <label class="margin_r_10 hand" for="reportType1">
                <input  id="reportType1" name="reportType" onclick="fnReportTypeClk('cross');" value="cross" class="radio_com" type="radio">${ctp:i18n('office.stock.jc.report.js')}</label>
             </div>
            </td>
          </tr>

          <tr id="generalTR">
            <th noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.auto.autoStcInfo.sj.js')}:</label></th>
            <td>
              <div class="clearfix margin_l_5">
                <div class="common_txtbox_wrap left">
                  <input id="stcTime0" class="comp font_size12" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d'" readonly>
                </div>
                <span class="margin_lr_5 margin_t_5 left">${ctp:i18n('office.asset.apply.to.js')}</span>
                <div class="common_txtbox_wrap left">
                  <input id="stcTime1" class="comp font_size12" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d'" readonly>
                </div>
              </div>
            </td>
          </tr>
          
          <tr id="crossTR" class="display_none">
            <th noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.auto.autoStcInfo.sj.js')}:</label></th>
            <td width="60"> 
              <div class="common_selectbox_wrap">
                <select class="h100b">
                  <option onclick="fnStcTypeYear2MonthClk('year')" value="0">${ctp:i18n('office.auto.autoStcInfo.an.js')}</option>
                  <option onclick="fnStcTypeYear2MonthClk('month')" value="1">${ctp:i18n('office.auto.autoStcInfo.ay.js')}</option>
                </select>
              </div>
            </td>
            <td>
              <div id="crossYearDiv">
                <div class="clearfix margin_l_5">
                  <div class="common_txtbox_wrap left">
                    <input id="stcTime2" class="comp font_size12" type="text" comp="type:'calendar',ifFormat:'%Y'" readonly>
                  </div>
                  <span class="margin_lr_5 margin_t_5 left">${ctp:i18n('office.asset.apply.to.js')}</span>
                  <div class="common_txtbox_wrap left">
                    <input id="stcTime3" class="comp font_size12" type="text" comp="type:'calendar',ifFormat:'%Y'" readonly>
                  </div>
                </div>
              </div>
              <div id="crossMonthDiv" class="display_none">
                <div class="clearfix margin_l_5">
                  <div class="common_txtbox_wrap left">
                    <input id="stcTime4" class="comp font_size12" type="text" comp="type:'calendar',ifFormat:'%Y-%m'" readonly>
                  </div>
                  <span class="margin_lr_5 margin_t_5 left">${ctp:i18n('office.asset.apply.to.js')}</span>
                  <div class="common_txtbox_wrap left">
                    <input id="stcTime5" class="comp font_size12" type="text" comp="type:'calendar',ifFormat:'%Y-%m'" readonly>
                  </div>
                </div>
              </div>
            </td>
          </tr>

          <tr>
            <td colspan="9" align="center">
              <div>
                <a id="btnok" onclick="fnStc();" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('office.auto.autoStcinfo.tj.js')}</a>
                <a id="btncancel" onclick="fnCancel();" class="common_button common_button_grayDark margin_r_10" href="javascript:void(0)">${ctp:i18n('office.auto.autoStcinfo.cz.js')}</a>
              </div>
            </td>
          </tr>
        </table>
      </div>
    </div>
    <div class="layout_center bg_color over_hidden" layout="border:false">
      <div class="stadic_layout border_t">
        <div class="stadic_layout_head stadic_head_height">
          <div id="toolbar"></div>
          <div class="common_center align_center bg_color">${ctp:i18n('office.stock.yplytj.stc.title.js')}</div>
          <div class="margin_r_10 right">${ctp:i18n('office.auto.autoStcInfo.tjrq.js')}：${now}</div>
        </div>
        <div id="stockInfoStcTabDiv" class="stadic_layout_body stadic_body_top_bottom over_hidden">
            <table id="stockInfoStcTab" class="flexme3" style="display: none;"></table>
        </div>
      </div>
    </div>
  </div>
</body>
</html>