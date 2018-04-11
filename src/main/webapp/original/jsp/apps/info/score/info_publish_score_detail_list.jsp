<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp"%>
<!DOCTYPE html>
<html>
<head> 
<%-- 信息积分表 --%>
<title>${ctp:i18n("infosend.listInfo.listPending")}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=infoPublishScoreManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/score/info_publish_score_detail_list.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
    var hasScoreRole = "${hasScoreRole}";
</script>
</head>
<body>
<div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div style="float: left" id="toolbars"></div>
            <div style="float: right">
                <a id="combinedQuery" onclick="openQueryViews('${listType}');" style="margin-right: 5px;margin-top:2px;" class="common_button common_button_gray">${ctp:i18n('infosend.listInfo.combinedQuery')}<!-- 组合查询 --></a>
            </div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listInfoPublishScoreDetail"></table>
        </div>
    </div>
    <iframe id="hiddenIframe" name="hiddenIframe" style="display:none"></iframe>
</body>
</html>