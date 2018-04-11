<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/queryReport/formreport_chart.js.jsp"%>
<div id="guanlian_info_div" class="guanlian_info h100b">
<div class="guanlian">
  <span class="ico24 associatedData_24"></span>
</div>
<div class="guanlian_msg" style="display:none;">
  <div class="msg_title">
      <div class="msg_function" onclick="fundescription()" style="font-size: 12px;">${ctp:i18n('datarelation.descript.title.js')}</div>
      <div id="data_msg" style="font-weight: bold;font-size: 12px;margin-left: 60px;"></div>
  </div>
  <div class="msg_body">
    <div class="msg_body_info" style="position: relative; margin-bottom:20px;">
      <!-- 数据填充区域 -->
    </div>
  </div>
</div>
<!-- 普通列表模板 -->
<div id="listTpl" class="display_none">
  <ul class="dr_item">
    <li class="msg_ul_title" style="">
    <span class="title_span"></span>
    <span id="amore" class="amore_msg">${ctp:i18n('datarelation.open.win.more.js')}</span>
    <div id="copyFormNote" class="right font_size12 copyFormNote" style="height:32px;line-height:32px;"><span class="ico16 handling_of_16"></span></div>
    </li>
    <li class="loading_li" style="display: none"><img src="/seeyon/common/images/load.gif"></li>
    <div class="display_none">
      <li class="list_li">
        <span class="margin_lr_5">·</span>
        <span id="copyToForm" class="copyToLeftHover" onclick="copyFormData(this,event);" title="${ctp:i18n('datarelation.tab.copy.node.js')}">
          <span class="ico16 toback_16 right margin_t_5"></span>
        </span>
      </li>
    </div>
  </ul>
</div>
<!-- 表格模板 -->
<div id="tabTpl" class="display_none">
  <ul class="dr_item">
    <li class="msg_ul_title"><span class="title_span"></span> <a href="javascript:void(0);" id="amore" class="right font_size12">${ctp:i18n('datarelation.open.win.more.js')}</a></li>
    <li class="loading_li" style="display: none"><img src="/seeyon/common/images/load.gif"></li>
    <div id="tab" class="display_none">
       <li class="table_li">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table margin_b_20">
          <tr>
            <th nowrap="nowrap"></th>
          </tr>
          <tr >
            <td align="center" nowrap="nowrap"></td>
          </tr>
        </table>
      </li>
    </div>
    <!-- 转置显示tab -->
    <div id="vTab" class="display_none">
      <li class="table_li">
         <table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table margin_b_20" style="border-bottom:none;">
          <tr>
            <th width="40" nowrap="nowrap"></th>
            <td align="left" style="border-bottom:1px solid #D2D2D2;"></td>
          </tr>
        </table>
      </li>
    </div>
  </ul>
</div>

<!-- 图片模板 -->
<div id="chartTpl" class="display_none">
  <ul class="dr_item">
    <li class="msg_ul_title"><span class="title_span">板块名称</span> <a href="javascript:void(0);" id="amore" class="right font_size12">${ctp:i18n('datarelation.open.win.more.js')}</a></li>
    <li class="loading_li" style="display: none"><img src="/seeyon/common/images/load.gif"></li>
    <div class="display_none">
      <li class="chart_li">
        <div>
          <img class="chart_img" src="">
          <div class="chart_msg">
            <span class="class_span blue_class"></span> 
            <span class="class_name"></span> 
            <span class="class_span red_class"></span> 
            <span class="class_name"></span> 
            <span class="class_span yellow_class"></span> 
            <span class="class_name"></span> 
            <span class="class_span green_class"></span> 
            <span class="class_name"></span>
          </div>
          <p class="chart_title"></p>
        </div>
      </li>
    </div>
  </ul>
</div>

<div id="imgTpl" class="display_none">
  <ul class="dr_item">
    <li class="msg_ul_title"><span class="title_span"></span> <a href="javascript:void(0);" id="amore" class="right font_size12">${ctp:i18n('datarelation.open.win.more.js')}</a></li>
    <li class="loading_li" style="display: none"><img src="/seeyon/common/images/load.gif"></li>
    <div class="display_none">
      <li class="chart_li">
        <div class="out_syytem">
          <table class="w100b" border="0" cellspacing="0" cellpadding="0" style="border: 0;padding: 0;margin: 0;">
            <tr>
              <td class="chart_img_td" style="width: 60px;">
                <img class="chart_img">
              </td>
              <td>
                <p class="chart_title"></p>
              </td>
            </tr>
          </table>
         </div>
      </li>
    </div>
  </ul>
</div>

<!-- 表格和图形组合 -->
<div id="tab2img" class="display_none">
  <ul class="dr_item">
    <li class="msg_ul_title"><span class="title_span">板块名称</span> <a href="javascript:void(0);" id="amore" class="right font_size12">${ctp:i18n('datarelation.open.win.more.js')}</a></li>
    <li class="loading_li" style="display: none"><img src="/seeyon/common/images/load.gif"></li>
    <!-- 普通表格 -->
    <div id="tab" class="display_none">
       <li class="table_li">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table margin_b_20">
          <tr>
            <th width="40" nowrap="nowrap"></th>
          </tr>
          <tr >
            <td align="left" nowrap="nowrap"></td>
          </tr>
        </table>
      </li>
    </div>
    <!-- 转置显示tab -->
    <div id="vTab" class="display_none">
      <li class="table_li">
         <table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table margin_b_20" style="border-bottom:none;">
          <tr>
            <th width="40" nowrap="nowrap"></th>
            <td align="left" style="border-bottom:1px solid #D2D2D2;"></td>
          </tr>
        </table>
      </li>
    </div>
     <!-- 报表图模板 -->
    <div id="img" class="display_none">
      <li class="chart_li">
        <div style="overflow: auto;">
          <div id="chartIndex" class="chart_img"></div>
          <p class="chart_title"></p>
        </div>
      </li>
    </div>
  </ul>
</div>

</div>