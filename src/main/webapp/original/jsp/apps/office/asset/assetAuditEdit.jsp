<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.asset.assetAuditEdit.pbgsbsysq.js') }</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/asset/assetUse.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/asset/assetAuditEdit.js"></script>
<script type="text/javascript">
$(function() {
    $("#assetApplyIframe").attr("src", "${path}/office/assetUse.do?method=assetApplyIframe&operate=${ctp:escapeJavascript(param.operate)}&applyId=${applyId}&v=${ctp:digest_1(applyId)}");
});
</script>
</head>
<body class="h100b over_hidden">
<div id='layout'>
  <div id="east" class="layout_east over_hidden bg_color">
    <div id="deal_area_show" class="font_size12 align_center h100b hidden hand">
      <span class="ico16 arrow_2_l"></span>
      ${ctp:i18n('office.asset.assetAuditEdit.psbsp.js') }
    </div>
    <div id="deal_area" class="h100b">
      <div class="padding_lr_10 font_size12 h100b bg_color">
        <div id="auditDiv" class="common_radio_box margin_10 form_area clearfix">
          <div class="left">
            <label class="margin_r_10 hand" for="agree">
              <input id="id" type="hidden">
              <input id="affairId" name="affairId" value="${param.affairId}" type="hidden" >
              <input id="agree" class="radio_com" name="auditAttitude" value="0" type="radio" checked="checked">${ctp:i18n('office.asset.assetAuditEdit.pty.js') }
            </label>
            <label class="margin_r_10 hand" for="notagree">
              <input id="notagree" class="radio_com" name="auditAttitude" value="1" type="radio">${ctp:i18n('office.asset.assetAuditEdit.pbty.js') }
            </label>
          </div>
          <div class="common_txtbox  clearfix" style="zoom:0">
            <textarea id="auditOpinion" style="width:95%;height:200px;" class="padding_5 margin_5 validate" validate="name:'${ctp:i18n('office.asset.assetAuditEdit.pspyj.js') }',type:'string',maxLength:600"></textarea>
          </div>
          <div class="right margin_5"><a id="agreeHref" onclick="fnOK();" class="common_button common_button_emphasize left" href="javascript:void(0);">${ctp:i18n('office.asset.assetAuditEdit.ptj.js') }</a></div>
         </div>
          <!-- 工作流相关数据 -->
         <div id="workFlowDiv" class="display_none">
          <input type="hidden" id="readyObjectJSON" name="readyObjectJSON">
          <input type="hidden" id="workflow_newflow_input" name="workflow_newflow_input"/>
          <input type="hidden" id="workflow_node_peoples_input" name="workflow_node_peoples_input"/>
          <input type="hidden" id="workflow_node_condition_input" name="workflow_node_condition_input"/>
          <input type="hidden" id="process_rulecontent" name="process_rulecontent"/>
          <input type="hidden" id="process_message_data" name="process_message_data">
        </div>
      </div>
    </div>
  </div>
  <div id="center" class="layout_center over_hidden h100b">
    <iframe id="assetApplyIframe" border="0" src="" frameBorder="0" height="100%" width="100%"></iframe>
  </div>
</div>
</body>
</html>