<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>车辆申请</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
function getParam() {
  var o = new Object();
  var applyUserId = "${param.applyUserId}";
  var applyOuttime = $("#beginDate",window.parent.document).val();
  var applyBacktime = $("#endDate",window.parent.document).val();
  o.applyUserId=applyUserId;
  o.applyOuttime=applyOuttime;
  o.applyBacktime=applyBacktime;
  o.isAdmin = "${param.isAdmin}";
  return o;
 }
</script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoOrderList.js"></script>
</head>
<body class="h100b over_hidden">
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="autoOrderListDIV" class="layout_center page_color over_hidden" layout="border:false">
            <table id="autoOrderList" class="flexme3" style="display: none;">
            </table>
        </div>
    </div>
</body>
</html>