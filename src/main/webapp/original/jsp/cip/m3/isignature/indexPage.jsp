<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../common/common.jsp"%>
<script type="text/javascript">
$().ready(function() {
    $("#tab1").click(function() {
        $("#tab4_iframe").attr('src','');
        $("#tab1_iframe").attr('src','${path}/m3/msignature.do?method=setIsignatureUserKey').show();
        $("#tab1").attr('class', 'current');
        $("#tab4").attr('class', '');
        $("#tab4_iframe").hide();
    });
    $("#tab4").click(function() {
        $("#tab1_iframe").attr('src','');
        $("#tab4_iframe").attr('src','${path}/m3/msignature.do?method=setIsignatureServer').show();
        $("#tab1").attr('class', '');
        $("#tab4").attr('class', 'current');
        $("#tab1_iframe").hide();
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
                    <li id="tab1" class="current"><a class="no_b_border" hidefocus="true" href="javascript:void(0)" tgt="tab1_iframe"><span>设置用户信息</span></a></li>
                    <li id="tab4"><a hidefocus="true" href="javascript:void(0)" tgt="tab4_iframe" class="last_tab no_b_border"><span>设置签章服务器地址</span></a></li>
                
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