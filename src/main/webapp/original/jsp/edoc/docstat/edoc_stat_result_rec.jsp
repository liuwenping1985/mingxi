<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="w100b h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=edocStatNewManager"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/docstat/edoc_stat_result.js${v3x:resSuffix()}" />"></script>
<title></title>
<script type="text/javascript">
	var edocStatUrl = _ctxPath+"/edocStatNew.do";
	var edocType = "${param.edocType}";
	var isG6Version = "${isG6Version}"=="true";
	var showBanwenYuewen = "${showBanwenYuewen}"=="true";
</script>
</head>
<body scroll="no" class="w100b h100b">
<div id='layout'>
    <div class="layout_north" id="north">
        <div id="statTitle" align="center" class="padding_tb_5" style="font-size:13px;"></div>
        <c:if test="${param.statConditionId!='' && statCondition!=null}">
            <form id="statConditionForm" style="display:none">
                <input type="hidden" id="condition_statTitle" name="condition_statTitle" value="${fn:escapeXml(statCondition.title)}" />
                <input type="hidden" id="condition_rangeIds" name="condition_rangeIds" value="${statCondition.organizationId }" />
                <input type="hidden" id="condition_displayType" name="condition_displayType" value="${statCondition.statisticsDimension }" />
                <input type="hidden" id="condition_displayTimeType" name="condition_displayTimeType" value="${statCondition.timeType }" />
                <input type="hidden" id="condition_startRangeTime" name="condition_startRangeTime" value="${statCondition.starttime }" />
                <input type="hidden" id="condition_endRangeTime" name="condition_endRangeTime" value="${statCondition.endtime }" />
                <input type="hidden" id="condition_sendType" name="condition_sendType" value="${statCondition.sendType }" />
                <input type="hidden" id="condition_unitLevel" name="condition_unitLevel" value="${statCondition.unitLevel }" />
                <input type="hidden" id="condition_operationType" name="condition_operationType" value="${statCondition.operationType }" />
                <input type="hidden" id="condition_operationTypeIds" name="condition_operationTypeIds" value="${statCondition.operationTypeIds }" />
            </form>
        </c:if>

        <iframe id="hiddenIframe" name="hiddenIframe" style="display:none"></iframe>
    </div>
    <div class="layout_center over_hidden" id="center">
    	<table  class="flexme3" id="edocStatResultRec"></table>
	</div>
</div>
</body>
</body>
</html>