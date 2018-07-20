<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=planManager"></script>
<!DOCTYPE html>
<script>
function downloadtemp(){
  var url = _ctxPath
  + "/plan/plan.do?method=downplantemplate";
  var exportExcelIframe = $("#exportExcelIframe");
  exportExcelIframe.attr("src", url);
}
</script>
<html>
<head>
<title></title>
</head>
<body>
<div align="right"><span class="hand color_blue" style="margin-left:100px" onclick="downloadtemp()">${ctp:i18n('plan.initdata.label.downloadtemplate')}</span></div>
<img  auto src="<c:url value="/apps_res/plan/images/viewSamplePlan.png" />">
 <iframe id="exportExcelIframe" name="exportExcelIframe" frameborder="0" marginheight="0" marginwidth="0" style="display:none;"></iframe>
</body>
</html>