<%--
 $Author: hetao $
 $Rev: 7 $
 $Date:: 2012-09-05 13:29:18#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<c:set var="url_ajax_performanceReportManager" value="${path}/ajax.do?managerName=performanceReportManager"></c:set>
<c:set var="url_ajax_collCubeManager" value="${path}/ajax.do?managerName=collCubeManager"></c:set>
<c:set var="url_ajax_collCubeIndexManager" value="${path}/ajax.do?managerName=collCubeIndexManager"></c:set>

<!-- 协同立方 -->
<c:set var="url_colCube_colCube" value="${path}/colCube/colCube.do?method=goColCubeAccess" />
<c:set var="url_colCube_colCube_currentUser" value="${path}/colCube/colCube.do?method=goColCube" />
<c:set var="url_colCube_IntroOfColCube" value="${path}/colCube/colCube.do?method=goIntroOfColCube" />

<!-- 协同360 -->
<c:set var="url_colCube_colAllRound" value="${path}/colCube/colCube.do?method=goColAllRoundAccess" />
<c:set var="url_colCube_IntroOfColAllRound" value="${path}/colCube/colCube.do?method=goIntroOfColAllRound" />
<c:set var="url_colCube_G6_colAllRound" value="${path}/colCube/colCube.do?method=goColAllRound" />

<!-- 授权设置 -->
<c:set var="url_colCube_auth" value="${path}/colCube/cubeAuth.do?method=goColCubeAuth" />
<c:set var="url_colCube_authDetail" value="${path}/colCube/cubeAuth.do?method=goColCubeAuthDetail" />
<c:set var="url_colCube_authDetailEdit" value="${path}/colCube/cubeAuth.do?method=goColCubeAuthDetailEdit" />
<c:set var="url_colCube_authDetailSave" value="${path}/colCube/cubeAuth.do?method=goColCubeAuthDetailSave" />
<c:set var="url_colCube_collCubeAuth" value="${path}/colCube/cubeAuth.do?method=authSet" />

<!-- 权重设置 -->
<c:set var="url_collCubeIndex_collCubeIndex" value="${path}/colCube/collCubeIndex.do?method=goCollCubeIndex" />
<c:set var="url_collCubeIndex_collCubeIndexSet" value="${path}/colCube/collCubeIndex.do?method=goCollCubeIndexSet" />
<c:set var="url_collCubeIndex_colCubeUpdate" value="${path}/colCube/collCubeIndex.do?method=update" />
<c:set var="url_colCube_introOfIndex" value="${path}/colCube/collCubeIndex.do?method=colCubeIntroOfIndex" />
<script type="text/javascript">
var url_ajax_collCubeIndexManager = "${url_ajax_collCubeIndexManager}";
//协同立方
var url_colCube_colCube = "${url_colCube_colCube}";
var url_colCube_colCube_currentUser = "${url_colCube_colCube_currentUser}";
var url_colCube_IntroOfColCube = "${url_colCube_IntroOfColCube}";

//协同360
var url_colCube_colAllRound = "${url_colCube_colAllRound}";
var url_colCube_IntroOfColAllRound = "${url_colCube_IntroOfColAllRound}";
var url_colCube_G6_colAllRound = "${url_colCube_G6_colAllRound}";
//授权设置
var url_colCube_collCubeAuth = "${url_colCube_collCubeAuth}";
var url_colCube_authDetailSave = "${url_colCube_authDetailSave}";

//权重设置
var url_collCubeIndex_collCubeIndex = "${url_collCubeIndex_collCubeIndex}";
var url_collCubeIndex_collCubeIndexSet = "${url_collCubeIndex_collCubeIndexSet}";
var url_collCubeIndex_colCubeUpdate = "${url_collCubeIndex_colCubeUpdate}";

var url_colCube_introOfIndex ="${url_colCube_introOfIndex}";
</script>