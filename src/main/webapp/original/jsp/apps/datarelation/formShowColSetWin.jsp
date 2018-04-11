<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<style type="text/css">
  .stadic_body_top_bottom {
  	bottom: 0px;
  	top: 0px;
  }
</style>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/datarelation/js/formShowColSetWin.js"></script>
</head>
<body class="h100b over_hidden">
<div class="stadic_layout_body stadic_body_top_bottom border_t page_color">
  <table align="center" class="margin_t_10 font_size12">
      <tr>
        <td>${ctp:i18n('ctp.dr.show.col1.js')}
          <br/> 
          <select id="leftSelect" ondblclick="fnMove('right')" name="reserve" multiple="multiple" class="margin_t_10" style="width: 300px; height: 390px;">
          </select>
        </td>
        <td>
            <em class="ico16 select_selected" id="toRight" onclick="fnMove('right')"></em><br/>
            <em class="ico16 select_unselect" id="toLeft" onclick="fnMove('left')"></em>
        </td>
        <td>${ctp:i18n('ctp.dr.show.col2.js')}
          <br/>
        <select id="rightSelect" ondblclick="fnMove('left')" name="selected" multiple="multiple" class="margin_t_10" style="width: 300px; height: 390px;">
        </select>
        </td>
        <td><em class="ico16 sort_up" id="toUp" onclick="fnUpDown('up')"></em><br /> 
        <em class="ico16 sort_down" id="toDown" onclick="fnUpDown('down')"></em></td>
      </tr>
    </table>
</div>
</body>
</html>
