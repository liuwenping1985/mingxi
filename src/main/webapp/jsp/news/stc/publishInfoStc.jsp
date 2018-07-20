<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<style type="text/css">
.stadic_head_height {
	height: 70px;
}

.stadic_body_top_bottom {
	bottom: 5px;
	top: 70px;
}
.hand{
cursor: default;
}
.common_toolbar_box{
  background-color: rgb(250, 250, 250);
}
</style>
<script type="text/javascript">
  var _path = "${path}";
  var pTemp = {jval : '${jval}'};
</script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/news/js/publishInfoStc.js${ctp:resSuffix()}"></script>
</head>
<body class="h100b over_hidden bg_color">
  <div id='layout' class="comp" comp="type:'layout'">
    <div class="layout_north" layout="height:125,maxHeight:170,minHeight:100,spiretBar:{show:true,handlerT:function(){$('#layout').layout().setNorth(0);pTemp.table.grid.resizeGridUpDown('up');fnOK();},handlerB:function(){$('#layout').layout().setNorth(125);pTemp.table.grid.resizeGridUpDown('middle');fnOK();}}">
      <div id="cndAreaDiv" class="form_area align_center">
        <table border="0" cellSpacing="0" cellPadding="0" width="630" align="center">
          <tbody>
            <tr>
              <th noWrap="nowrap"><label class="margin_r_5" for="text">${ctp:i18n('news.stc.stcSelct.js')}:</label></th>
              <td align="left" width="240"><select id="stcWay" class="common_drop_down w100b" onchange="fnStcWayOnChange()">
                  <option value="publishNum">${ctp:i18n('news.stc.publishNum.js')}</option>
                  <option value="publishMember">${ctp:i18n('news.stc.publish.user.js')}</option>
                  <c:if test="${param.mode ne 'inquiry'}">
                    <option value="clickNum">${ctp:i18n('news.stc.clickNum.js')}</option>
                  </c:if>
                  <c:if test="${param.mode eq 'bbs'}">
                    <option value="replyNum">${ctp:i18n('news.stc.replayNum.js')}</option>
                  </c:if>
                  <c:if test="${param.mode eq 'inquiry'}">
                    <option value="voteNum">${ctp:i18n('news.stc.voteNum.js')}</option>
                  </c:if>
                  <option value="state">${ctp:i18n('news.stc.state.js')}</option>
              </select></td>
              <th noWrap="nowrap" class="stcToTh hidden"><label class="margin_l_10 margin_r_5" for="text">${ctp:i18n('news.stc.stcTo.js')}:</label></th>
              <td align="left" class="stcToTh hidden">
                <div id="stcTo" class="common_radio_box clearfix">
                  <label class="margin_r_10 hand stcMember" for="stcMember"> <input id="stcMember" class="radio_com" name="stcTarget" value="0" type="radio" checked="checked">${ctp:i18n('news.stc.memberName.js')}</label> 
                  <label class="margin_r_10 hand stcDept" for="stcDept"> <input id="stcDept" class="radio_com" name="stcTarget" value="1" type="radio">${ctp:i18n('news.stc.deptName.js')}</label> 
                  <label class="margin_r_10 hand stcAcc" for="stcAcc"> <input id="stcAcc" class="radio_com" name="stcTarget" value="2" type="radio">${ctp:i18n('news.stc.accName.js')}</label>
                </div>
              </td>
              <th noWrap="nowrap" width="65" class="stcToThNull" >&nbsp;</th>
              <td align="left"  width="210" class="stcToThNull">&nbsp;</td>
            </tr>
            <tr>
              <th noWrap="nowrap"></th>
              <td align="left">
                <div id="stcTypeDiv" class="common_radio_box clearfix">
                  <label class="margin_r_10 hand" for="stcBy"><input id="stcBy" class="radio_com" name="stcType" value="0" type="radio" onclick="fnStcTypeRadioToggle();" checked="checked">${ctp:i18n('news.stc.stcBy.js')}</label> 
                  <label class="margin_r_10 hand" for="stcByMonth"><input id="stcByMonth" class="radio_com" name="stcType" value="1" onclick="fnStcTypeRadioToggle();" type="radio">${ctp:i18n('news.stc.stcByMonth.js')}</label> 
                  <label class="margin_r_10 hand" for="stcByYear"><input id="stcByYear" class="radio_com" name="stcType" onclick="fnStcTypeRadioToggle();" value="2" type="radio">${ctp:i18n('news.stc.stcByYear.js')}</label>
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap"><label class="margin_r_5" for="text">${ctp:i18n('news.stc.publishTime.js')}:</label></th>
              <td id="publishDateParentTab" colspan="3" align="left">
                <div id="publishDateTab">
                  <table class="w90b">
                    <td>
                      <div class="common_txtbox_wrap">
                        <input id="publishDateStart" readonly="readonly" class="comp mycal" style="width:225px;" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d'">
                      </div>
                    </td>
                    <td width="8">-</td>
                    <td>
                      <div class="common_txtbox_wrap">
                        <input id="publishDateEnd" readonly="readonly" class="comp mycal" style="width:225px;" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d'">
                      </div>
                    </td>
                  </table>
                </div>
                <div id="publishDateSelectTab" class="hidden">
                  <table id="publishDateSelectTab" class="w90b" border="0">
                    <td>
                      <div id="publishDateStartDiv" class="common_selectbox_wrap">
                        <select id="publishDateStart" style="width:238px;">
                             <option></option>
                        </select>
                      </div>
                    </td>
                    <td width="8">-</td>
                    <td>
                      <div id="publishDateEndDiv" class="common_selectbox_wrap">
                        <select id="publishDateEnd" style="width:238px;">
                             <option></option>
                        </select>
                      </div>
                    </td>
                  </table>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="align_center margin_t_10">
        <a id="btnOK" class="common_button common_button_emphasize" onclick="fnOK()" href="javascript:void(0)">${ctp:i18n('news.stc.stcName.js')}</a> <a class="common_button common_button_gray" onclick="fnCancel()" href="javascript:void(0)">${ctp:i18n('common.button.reset.label')}</a>
      </div>
    </div>
    <div id="stcTitleDiv" class="layout_center stadic_layout margin_l_5 over_hidden" layout="border:true">
      <div class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height">
          <table class="w100b margin_tb_5" border="0" cellSpacing="0" cellPadding="0">
            <tr>
              <td><table border="0" cellSpacing="0" cellPadding="0">
                  <tr id="prindClearTr">
                    <td align="left" width="75" nowrap="nowrap"><span class="margin_lr_10">${ctp:i18n('news.stc.stcResult.js')}:</span></td>
                    <td align="left" width="275"><div id="toolBar"></div></td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td align="center"><span id="stcTitle" class="font_size14 font_bold"></span></td>
            </tr>
            <tr>
              <td align="right"><span class="margin_r_5 font_size12">${ctp:i18n('news.stc.stcDate.js')}:</span><span id="strTime" class="margin_r_10 font_size12">${today}</span></td>
            </tr>
          </table>
        </div>
        <div id="staticBodyDiv" class="stadic_layout_body stadic_body_top_bottom" style="overflow: hidden;">
        </div>
      </div>
    </div>
  </div>
  <div id="stcTabDiv" class="hidden">
    <table id="stcTab" class="flexme3" style="display: none;"></table>
  </div>
  <div id="formDiv" class="hidden">
    <form action="${path}/newsData.do?method=stcSendToColl" method="post" id="sendToCol" name="sendToCol">
      <input id="formTitle"  name="formTitle" type="hidden">
      <input id="formContent" name="formContent" type="hidden">
    </form>
  </div>
   <!-- 转发协同的标题头 -->
  <div id="sendToCollTitleDiv" class="hidden">
      <table class="w100b margin_tb_5" border="0" cellSpacing="0" cellPadding="0">
        <tr>
          <td align="center"><span id="stcTitle4sendToColl" class="font_size14 font_bold"></span></td>
        </tr>
        <tr>
          <td align="right"><span class="margin_r_5 font_size12">${ctp:i18n('news.stc.stcDate.js')}:</span><span id="strTime" class="margin_r_10 font_size12">${today}</span></td>
        </tr>
      </table>
  </div>
</body>
</html>