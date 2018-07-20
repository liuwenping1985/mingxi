<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/colCube/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>绩效报表设置</title>
<script type="text/javascript">
  $().ready(function() {
    $("#btn1").click(function() {
    	$(this).parent().addClass('current').siblings().removeClass('current');
    });
    $("#btn2").click(function() {
    	window.location=url_collCubeIndex_collCubeIndex;
    });
    $("#btn3").click(function() {
    	window.location=url_collCubeIndex_collCubeIndexSet;
    });
    $("#authDetail").attr("src","${url_colCube_auth}&reportId=${defualtReportId }");
  });
</script>
</head>
<body class="h100b over_hidden page_color">
	<div id="index_layout" class="comp page_color" comp="type:'layout'">
        <div class="comp"comp="type:'breadcrumb',comptype:'location',code:'F08_cubeAuth'"></div>
        <div class="layout_center page_color over_hidden" layout="border:false" id="cubeAuthDiv">
        	<div id="tabs2" class="comp" comp="type:'tab',width:'100%',parentId:'cubeAuthDiv'">
			    <div id="tabs2_head" class="common_tabs clearfix padding_t_5 padding_l_5">
			        <ul class="left">
			            <li class="current"><a id="btn1" href="javascript:void(0)" tgt="tab1_div"><span>${ctp:i18n('colCube.common.crumbs.authSet')}</span></a></li>
			            <li><a id="btn3" href="javascript:void(0)" class="no_b_border" tgt="tab3_div"><span>${ctp:i18n('colCube.index.set')}</span></a></li>
			            <c:if test="${!isG6}">
			            <li><a id="btn2" href="javascript:void(0)" class="last_tab no_b_border" tgt="tab2_div" style="max-width: 100px;"><span>${ctp:i18n('colCube.common.crumbs.indexSet')}</span></a></li>
			        	</c:if>
			        </ul>
			    </div>
			    <div id='tabs2_body' class="common_tabs_body">
			        <div id="tab1_div">
			        	<iframe id="authDetail" src="" width="100%" height="100%" frameborder="0"></iframe>
        			</div>
			        <div id="tab2_div" class="hidden">
        			</div>
			    </div>
			</div>
        	
		</div> 
    </div> 
</body>
</html>

