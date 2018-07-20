<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head> 
<title>信息评分标准设置</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/apps_res/info/js/common/gov_common.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/common/magazine_publish_common.js${ctp:resSuffix()}"></script>
</head>
<body>
	<div id="magazinePublishForm" style="width:0px;height:0px;overflow:hidden; position: absolute;">
		<div id="publishMagazineDiv" style="display:none">
		    <input type="hidden" id="publish_user" name="publish_user" value="${publishVO.publishUserName}"/>
		    <input type="hidden" id="_publish_dept" name="_publish_dept" value="${publishVO.publishDeptName}"/>
		    <input type="hidden" id="_publish_account" name="_publish_account" value="${publishVO.publishAccountName}"/>
		    <input type="hidden" id="_publish_time" name="_publish_time" value="${publishVO.publishTime}"/>
		    
		    <input type="hidden" id="publish_user_id" name="publish_user_id" value="${publishVO.publishUserId}">
			<input type="hidden" id="openFromType" name="openFromType" value="${publishVO.openFromType }" />
			<input type="hidden" id="publishToViewRangeIds" name="publishToViewRangeIds" value="${publishVO.publishToViewRangeIds }" />
			<input type="hidden" id="publishToViewRangeNames" name="publishToViewRangeNames" value="${publishVO.publishToViewRangeNames }" />
			<input type="hidden" id="publishToViewRangeNamesOfAll" name="publishToViewRangeNamesOfAll" value="${publishVO.publishToViewRangeNamesOfAll }" />
			<input type="hidden" id="publishToPublicRangeIds" name="publishToPublicRangeIds" value="${publishVO.publishToPublicRangeIds }" />
			<input type="hidden" id="oldPublishToPublicRangeIds" name="oldPublishToPublicRangeIds" value="${publishVO.publishToPublicRangeIds }" />
			<input type="hidden" id="publishToPublicRangeNames" name="publishToPublicRangeNames" value="${publishVO.publishToPublicRangeNames }" />
			<input type="hidden" id="publishBullentinOrgRangeIds" name="publishBullentinOrgRangeIds" value="${publishVO.publishBullentinOrgRangeIds }" />
			<input type="hidden" id="publishBullentinUnitRangeIds" name="publishBullentinUnitRangeIds" value="${publishVO.publishBullentinUnitRangeIds }" />
			<input type="hidden" id="publishBullentinOrgRangeNames" name="publishBullentinOrgRangeNames" value="${publishVO.publishBullentinOrgRangeNames }" />
			<input type="hidden" id="publishBullentinUnitRangeNames" name="publishBullentinUnitRangeNames" value="${publishVO.publishBullentinUnitRangeNames }" />
			<input type="hidden" id="publishMagazineIds" name="publishMagazineIds" value="">
			<input type="hidden" id="publishAffairIds" name="publishAffairIds" value="">
		</div>
	</div>
</body>
</html>
