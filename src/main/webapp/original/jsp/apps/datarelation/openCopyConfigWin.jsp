<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link rel="stylesheet" href="${path}/apps_res/datarelation/css/dataRelationConfig.css${ctp:resSuffix()}">
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/datarelation/js/openCopyConfigWin.js"></script> 
<script type="text/javascript">
   var pTemp = {jval:'${jval}', "templateImgSrc":"${path}/apps_res/datarelation/image/"};
</script>
</head>
<body class="h100b over_hidden">
  <div id="link_window">
    <div class="link_wrap comp" id='layout' comp="type:'layout'">
      <div class="link_up"></div>
      <div class="link_left left" style="overflow: auto;">
        <div id="drConfigTree"></div>
      </div>
      <div class="link_right left" id="rightDiv">
        <!-- <div class="layout_center" id="layoutCenterDiv" layout="border:false">
        </div>  -->
      </div>
    </div>
  </div>
  <!-- 模板 -->
<div id="copyTemplate" class="display_none">
  <div class="infopic">
     <div class="pictitle">
        <span class="title"></span>
        <span class="picclose"></span>
     </div>
     <img src="" ondragstart="return false">
  </div>
</div>
</body>
</html>