<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.apps.m1.authorization.resouces.i18n.MobileManageResources" var="mobileManageBundle"/>
<script type="text/javascript" language="javascript">
$().ready(function() {
	showCtpLocation('M1_clientBind');
    $("#tab1").click(function() {
        $("#tab4_iframe").attr('src','');
        $("#tab7_iframe").attr('src','');
        $("#tab1_iframe").attr('src','${path}/m1/mClientBindController.do?method=toBindManage').show();
        $("#tab1").attr('class', 'current');
        $("#tab4").attr('class', '');
        $("#tab7").attr('class', '');
        $("#tab4_iframe").hide();
        $("#tab7_iframe").hide();
    });
    $("#tab4").click(function() {
        $("#tab1_iframe").attr('src','');
        $("#tab7_iframe").attr('src','');
        $("#tab4_iframe").attr('src','${path}/m1/mClientBindController.do?method=toSetSafeLevel').show();
        $("#tab1").attr('class', '');
        $("#tab7").attr('class', '');
        $("#tab4").attr('class', 'current');
        $("#tab1_iframe").hide();
        $("#tab7_iframe").hide();
    });
    $("#tab7").click(function() {
        $("#tab1_iframe").attr('src','');
        $("#tab4_iframe").attr('src','');
        $("#tab7_iframe").attr('src','${path}/m1/mClientBindController.do?method=toSetBindNum').show();
        $("#tab1").attr('class', '');
        $("#tab4").attr('class', '');
        $("#tab7").attr('class', 'current');
        $("#tab1_iframe").hide();
        $("#tab4_iframe").hide();
    });
    
    $("#tab1").click();
});
</script>
</head>
<body class="h100b over_hidden">
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:28,maxHeight:100,minHeight:30,sprit:false">
            <div class="comp" comp="type:'breadcrumb',code:'M01_orgAuth'"></div>
            <div class="common_tabs clearfix page_color">
                <ul class="left">
                    <li id="tab1" class="current"><a title="设备绑定管理" class="no_b_border" hidefocus="true" href="javascript:void(0)" tgt="tab1_iframe"><span><fmt:message key="label.mm.orgbind.bindmanage" bundle="${mobileManageBundle}"/></span></a></li>
                    <li id="tab4"><a title="安全级别设置" hidefocus="true" href="javascript:void(0)" tgt="tab4_iframe" class="last_tab no_b_border"><span><fmt:message key="label.mm.orgbind.setsafelevel" bundle="${mobileManageBundle}"/></span></a></li>
                	<li id="tab7"><a title="绑定设备数设置" hidefocus="true" href="javascript:void(0)" tgt="tab7_iframe" class="last_tab no_b_border" style="max-width:150px;"><span><fmt:message key="label.mm.orgbind.setbindnum" bundle="${mobileManageBundle}"/></span></a></li>
                
                </ul>
            </div>
        </div>
        <div class="layout_center over_hidden" layout="border:false">
            <iframe id="tab1_iframe" width="100%" height="100%" src="" frameborder="no" border="0" ></iframe>
            <iframe id="tab4_iframe" width="100%" height="100%" src="" frameborder="no" border="0" class="hidden"></iframe>
            <iframe id="tab7_iframe" width="100%" height="100%" src="" frameborder="no" border="0" class="hidden"></iframe>
        </div>
    </div>
</body>
</html>