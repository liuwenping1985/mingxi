<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
.stadic_layout_body{
    bottom: 10px;
    margin-top: 35px;
}
.stadic_layout_head{
    height:35px;
}
#toolbar .common_toolbar_box {
    background: none;
    margin-right: 5px;
    height:30px;
    padding-top:0
}
</style>
<title>${ctp:i18n('office.app.auto.use.apply.js')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoAuditEdit.js"></script>
</head>
<body id="body" class="h100b over_hidden">
<div id='layout'>
    <div id="east" class="layout_east over_hidden">
        <div id="deal_area_show" class="font_size12 align_center h100b hidden hand">
            <span class="ico16 arrow_2_l"></span>
            <br />${ctp:i18n('office.auto.pclsp.js')}<br />
        </div>
        <div id="deal_area" class="h100b">
            <div class="padding_lr_10 font_size12 h100b bg_color">
              <div id="auditDiv" class="common_radio_box margin_10 form_area clearfix">
                  <div class="left">
                      <label class="margin_r_10 hand" for="agree">
                          <input id="id" type="hidden">
                          <input id="affairId" value="${param.affairId}" type="hidden">
                          <input id="agree" class="radio_com" name="auditAttitude" value="0" type="radio" checked="checked">${ctp:i18n('office.agree.js')}
                      </label>
                      <label class="margin_r_10 hand" for="notagree">
                          <input id="notagree" class="radio_com" name="auditAttitude" value="1" type="radio">${ctp:i18n('office.disagree.js')}
                      </label>
                  </div>
                  <div class="common_txtbox  clearfix" style="zoom:0">
                      <textarea id="auditOpinion" style="width:95%;height:200px;" class="padding_5 margin_5 validate" validate="name:'${ctp:i18n('office.auto.audit.content.js')}',type:'string',maxLength:600"></textarea>
                  </div>
                  <div class="right margin_5"><a id="agreeHref" onclick="fnOK();" class="common_button common_button_emphasize left" href="javascript:void(0);">${ctp:i18n('office.submit.js') }</a></div>
               </div>
            </div>
        </div>
    </div>
    <div class="layout_center over_hidden h100b" id="center">
        <!--查看区域-->
        <div id="auditArea" class="h100b stadic_layout font_size12">
            <div class="stadic_layout_head stadic_head_height h100b">
                <!--标题+附件区域-->
                <div class="newinfo_area title_view">
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                      <tr><td colspan="2">
                      <table border="0" cellspacing="0" cellpadding="0" width="100%">
                          <tr>
                            <td width="65">
                                <div class="title_area">${ctp:i18n('office.autoaudit.sender.js') }:</div>
                            </td>
                            <td align="left"><a href="javascript:void(0)" onclick="fnPeopleCardPub('${startMemberId}');">${startMemberIdName}</a>（${applyDate}）</td>
                            <td align="right" nowrap="nowrap" width="80">
                                <div class="clearfix right" id="toolbar"></div>
                            </td>
                          </tr>
                        </table>
                        </td></tr>
                        <tr>
                            <td width="90%">
                               <div id="tabs_head" class="common_tabs clearfix" style="height: 33px">
                                  <ul class="left">
                                      <li id="applyLi" class="current" onclick="fnToggleTabs('apply');"><a hideFocus="true" class="no_b_border" href="javascript:void(0)"><span>${ctp:i18n('office.app.auto.use.apply.bill.js') }</span></a></li>
                                      <li id="workFlowLi" onclick="fnToggleTabs('workFlow');"><a hideFocus="true" class="no_b_border" href="javascript:void(0)"><span>${ctp:i18n('office.app.auto.use.apply.flow.js') }</span> </a></li>
                                  </ul>
                              </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <!--正文区域-->
            <div id="applyDiv" class="stadic_layout_body stadic_body_top_bottom">
              <div id="autoApplyDiv" class="margin_t_10">
                <%@include file="autoUseInfor.jsp" %>
              </div>
              <div id="autoWorkFlowDiv" class="display_none" style="height: 100%; overflow: hidden;">
                  <iframe id="autoWorkFlowIframe" frameborder="0" scrolling="no" width="100%" height="100%"></iframe>
              </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>