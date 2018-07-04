<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../common/common.jsp"%>
<script type="text/javascript" >
$().ready(function() {
	showCtpLocation('M1_clientBind');
    $("#tab1").click(function() {
        $("#tab4_iframe").attr('src','');
        $("#tab1_iframe").attr('src','${path}/m3/mobileAuthController.do?method=toOrgLoginAuth').show();
        $("#tab1").attr('class', 'current');
        $("#tab4").attr('class', '');
        $("#tab4_iframe").hide();
    });
    $("#tab4").click(function() {
        $("#tab1_iframe").attr('src','');
        $("#tab4_iframe").attr('src','${path}/m3/mobileAuthController.do?method=toOrgXiaoZhiAuth').show();
        $("#tab1").attr('class', '');
        $("#tab4").attr('class', 'current');
        $("#tab1_iframe").hide();
    });
    
    $("#tab1").click();
    var hasxiaozhi = ${hasxiaozhi};
    if('0' == hasxiaozhi){
    	$("#tab4").remove();
    	$("#tab4_iframe").remove();
    }
});
</script>
</head>
<body class="h100b over_hidden">
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:28,maxHeight:100,minHeight:30,sprit:false">
            <div class="comp" comp="type:'breadcrumb',code:'m3_orgAuth'"></div>
            <div class="common_tabs clearfix page_color">
                <ul class="left">
                    <li id="tab1" class="current"><a  class="no_b_border" hidefocus="true" href="javascript:void(0)" ><span>${i18nMapper.m3_auth_type_login_label_i18n}</span></a></li>
                    <li id="tab4"><a class="last_tab no_b_border" style="max-width:150px;"><span>${i18nMapper.m3_auth_type_xiaozhi_label_i18n}</span></a></li>
                
                </ul>
            </div>
        </div>
        <div class="layout_center over_hidden" layout="border:false">
            <iframe id="tab1_iframe" width="100%" height="100%" src="" frameborder="no" border="0" ></iframe>
            <iframe id="tab4_iframe" width="100%" height="100%" src="" frameborder="no" border="0" class="hidden"></iframe>
        </div>
    </div>
</body>
</html>