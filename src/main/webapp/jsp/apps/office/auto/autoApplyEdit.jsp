<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp"%>
<html class="h100b over_hidden">
<head>
<style type="text/css">
.stadic_layout_body {
  top: 0px;
  bottom: 30px;
}
.stadic_footer_height{
  _height:59px;
}
</style>
<script type="text/javascript">
$(function() {
  if("${ctp:escapeJavascript(param.fnTabClk)}"=="true"){
    $("#autoApplyDiv").disable();
    $("#btnok").hide();
  }
  
  $(window).load(function() {
    if($("#selfDriving").is(':checked')){
      var driverDiv = $("#applyDriverDiv");
      driverDiv.clearform();
      driverDiv.disable();//初始化自驾禁用驾驶员div
    }
    $("#shadowapplyDriver").val($("#applyDriver").val());
    $("#shadowapplyDriverName").val($("#applyDriverName").val());
    $("#shadowapplyDriverPhone").val($("#applyDriverPhone").val());
  });
  //初始化用车开始时间
  var toDay = new Date();
  var fromDate=toDay.print("%Y-%m-%d %H:%M");
  $("#applyOuttime").val(fromDate);
});

var officeData = "";
var officeWorkFlowTemp = {workflowId:"${workflowId}"};//工作流
function preSubmit() {
  var UseMember = $("#applyUser").val().split("|")[1];//用车人
  var UseDept = $("#applyDept").val().split("|")[1];//用车部门
  var UseType = $("#applyDepartType option:selected").attr("enumId");//用车性质
  var UseReason = $("#applyOrigin").val().escapeJavascript();//用车事由
  var UseAutoNum = $("#applyAutoIdName").val().escapeJavascript();//车辆
  officeData = "{\"UseMember\":\"" + UseMember + "\",\"UseDept\":\"" + UseDept + "\",\"UseType\":\"" + UseType + "\",\"UseReason\":\"" + UseReason + "\",\"UseAutoNum\":\"" + UseAutoNum + "\"}";
  preSendOrHandleWorkflow(window,"-1",officeWorkFlowTemp.workflowId,"-1","start", "${CurrentUser.id}","-1","${CurrentUser.loginAccount}",officeData,"office",null,window,null, officeSubmitForm);
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>车辆申请-编辑</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoApplyEdit.js"></script>
</head>
<body class="h100b over_hidden">
  <div class="stadic_layout h100b font_size12">
    <div class="stadic_layout_body stadic_body_top_bottom margin_b_10">
        <!--中间区域-->
        <div id="autoApplyDiv" class="form_area set_search align_center w100b">
          <%@ include file="autoUseInfor.jsp" %>
        </div>
    </div>
    <c:if test="${param.fnTabClk ne 'true' and (not empty param.fnTabClk)}">
      <div id="btnDiv" class="stadic_layout_footer stadic_footer_height border_t padding_tb_10 align_right bg_color_black">
        <!--下边区域-->
        <a id="applyOk" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a> 
        <a id="btncancel" class="common_button common_button_grayDark margin_r_10" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
      </div>
    </c:if>
  </div>
</body>
</html>