<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp"%>
<!DOCTYPE html>
<html>
<head> 
<%-- 审核信息列表 --%>
<title>${ctp:i18n("infosend.listInfo.listPending")}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=infoPublishScoreManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/score/info_stat_publish_score_record_list.js${ctp:resSuffix()}"></script>
<script>
    var listType = "${listType}";
    var _infoId = "${infoId}";
    var infoIds = "${param.infoIds}";
</script>
</head>
<body>
<div id='layout'>
      <div class="layout_center over_hidden" id="center">
          <table  class="flexme3" id="listInfoPublishScoreRecord"></table>
      </div>
      <iframe id="hiddenIframe" name="hiddenIframe" style="display:none"></iframe>
</div>
    
</body>
</html>