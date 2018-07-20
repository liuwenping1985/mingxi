<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp" %>
<!DOCTYPE html>
<html>
<head> 
<%-- 待发布期刊列表 --%>
<title>${ctp:i18n("infosend.score.magazine.publishPending.title")}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=magazineListManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/info_list.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/magazine/magazine_publish_list_pending.js${ctp:resSuffix()}"></script>
<script>var listType = "${listType}";</script>
</head>
<body>
<div id='layout'>
        <div class="layout_north bg_color" id="north" style="background:#f0f0f0">
            <div style="float: left" id="toolbars"></div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listPending"></table>
        </div>
        <div id="magazinePublishRange">
        	<%@ include file="../common/magazine_publish_common.jsp" %>
	        <input class="w100b validate" type="text" value="${infoMagazineVO.publishRangeNames}" id="publishRange"  readonly="readonly" name="publishRange"/>
	        <!-- 隐藏显示查看页面人员的Account|id -->
			<input type="hidden" id="viewPeopleId" name="viewPeopleId" value="${infoMagazineVO.viewPeopleId}">
			<!-- 隐藏显示组织\单位查看人员的Account|id -->
			<input type="hidden" id="publicViewPeopleId" name="publicViewPeopleId" value="${infoMagazineVO.publicViewPeopleId}">
			<input type="hidden" id="orgSelectedTree" name="orgSelectedTree" value="${infoMagazineVO.orgSelectedTree}">
			<input type="hidden" id="UnitSelectedTree" name="UnitSelectedTree" value="${infoMagazineVO.unitSelectedTree}">
			<!-- 隐藏显示查看人员的中文 -->
			<input type="hidden" id="viewPeople" name="viewPeople" value="${infoMagazineVO.viewPeople}">
			<!-- 隐藏显示组织\单位查看人员的中文-->
			<input type="hidden" id="publicViewPeople" name="publicViewPeople" value="${infoMagazineVO.publicViewPeople}">
			<!-- 隐藏显示所选的ID-->
			<input type="hidden" id="selectIds" name="selectIds" value="">
			<!-- 后台传递参数，组件显示范围不受权限控制 0代表后台，1代表台 -->
			<input type="hidden" id="openFromType" name="openFromType" value="1">
        </div>
    </div>
    <iframe id="hiddenIframe" name="hiddenIframe" style="display:none"></iframe>
    <iframe id="magazinePublishIframe" name="magazinePublishIframe" src="" width="0" height="0" style="display: none;"></iframe>
</body>
</html>