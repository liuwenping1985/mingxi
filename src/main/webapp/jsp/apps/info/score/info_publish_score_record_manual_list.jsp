<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp"%>
<!DOCTYPE html>
<html>
<head> 
<script type="text/javascript">
var viewPage="${openScoreView}";
var hasScoreRole = "${hasScoreRole}";
var flagStatPage=false;//从统计结果穿透打开
var flagPublishPage=false;//从信息发布后结果集打开
 if(viewPage=='statManual'){
	 flagStatPage=true;
 }
 if(viewPage=='statManualView'){
	 flagPublishPage=true;
 }
</script>
<%-- 审核信息列表 --%>
<title>${ctp:i18n("infosend.listInfo.listPending")}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=infoPublishScoreManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/score/info_publish_score_record_manual_list.js${ctp:resSuffix()}"></script>
<script>
    var _infoId = "${infoId}";
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