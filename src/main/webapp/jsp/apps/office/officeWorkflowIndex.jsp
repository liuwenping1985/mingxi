<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.template.process.set.js')}</title>
<script type="text/javascript">
var isClickOkBtn = false;
$(document).ready(function() {
    if ("${param.prompt}" == "success") {
      $.infor($.i18n('office.auto.savesuccess.js'));
    }

    $('#btnok').click(function() {
    	isClickOkBtn = true;
      $("#workflowIframe")[0].contentWindow.saveWFContent();
    });

    $('#btncancel').click(function() {
      window.location.href = "${path}/office/officeTemplate.do?method=index&officeApp=${ctp:escapeJavascript(officeApp)}";
    });
  });

  function saveWorkflowContent(rv) {
  	if(isClickOkBtn){
  		var processXml = rv[1];
  	    var workflowRule = rv[3];
  	    $("#processXml").val(processXml);
  	    $("#workflowRule").val(workflowRule);
  	    $("#processForm")[0].submit();
  	}
  	isClickOkBtn = false;
  }
</script>
<style>
  .stadic_body_top_bottom {
    top: 0px;
    bottom: 30px;
  }

  .stadic_footer_height {
    height: 30px;
  }
</style>

</head>
<body class="h100b over_hidden">
  <form id="processForm" name="processForm" action="/seeyon/office/officeTemplate.do?method=save" method="post">
    <input type="hidden" id="officeApp" name="officeApp" value="${ctp:toHTML(officeApp)}" />
    <input type="hidden" id="processTemplateId" name="processTemplateId" value="${workflowId}" />
    <input type="hidden" id="processXml" name="processXml" value="" />
    <input type="hidden" id="workflowRule" name="workflowRule" value="" />
  </form>
  <div class="stadic_layout">
    <div class="stadic_layout_body stadic_body_top_bottom" style="text-align: center;">
      <iframe id="workflowIframe" width="90%" height="400" frameborder="0" scrolling="no" src="<c:url value='/workflow/designer.do?method=showDiagram&isDebugger=false&scene=0&isModalDialog=false&processId='/>${workflowId}&appName=office&san=${ctp:urlEncoder(subAppName)}&currentUserId=${CurrentUser.id}&currentUserName=${ctp:urlEncoder(CurrentUser.name)}&currentUserAccountName=${ctp:urlEncoder(CurrentUser.loginAccountName)}&defaultPolicyId=${defaultPolicyId}&defaultPolicyName=${ctp:urlEncoder(defaultPolicyName)}&flowPermAccountId=${CurrentUser.loginAccount}&isvalidate=false"></iframe>
    </div>
    <div class="stadic_layout_footer stadic_footer_height align_center padding_tb_5 bg_color_black">
      <div id="btnDiv" class="margin_b_5">
        <a id="btnok" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a>
        <a id="btncancel" class="common_button common_button_grayDark margin_l_10 maring_b_5" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
      </div>
    </div>
  </div>
</body>
</html>