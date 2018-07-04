<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%-- 审核信息列表 --%>
<title>${ctp:i18n("infosend.listInfo.listPending")}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=infoPublishScoreManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/score/info_stat_publish_score_record_manual_list.js${ctp:resSuffix()}"></script>
<script>
    var infoIds = "${infoIds}";
    var hasScoreRole = "${hasScoreRole}"=="true";
</script>
</head>
<body>
<div id='layout'>
 		<div class="layout_north bg_color" id="north">
	       <div style="float: left" id="toolbars"></div>
	    </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listInfoPublishScoreRecordManual"></table>
        </div>
</div>
    <iframe id="hiddenIframe" name="hiddenIframe" style="display:none"></iframe>
</body>
</html>