<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=postManager"></script>
<script type="text/javascript" language="javascript">
$().ready(function() {
    $("#tab1").click(function() {
        $("#tab4_iframe").attr('src','');
        $("#tab1_iframe").attr('src','${path}/organization/department.do?method=showDepartmentFrame&style=external').show();
        $("#tab1").attr('class', 'current');
        $("#tab4").attr('class', '');
        $("#tab4_iframe").hide();
    });
    $("#tab4").click(function() {
        $("#tab1_iframe").attr('src','');
        $("#tab4_iframe").attr('src','${path}/organization/member.do?method=listExtMember').show();
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
            <div class="comp" comp="type:'breadcrumb',code:'T02_showExternalframe'"></div>
            <div class="common_tabs clearfix page_color">
                <ul class="left">
                    <li id="tab1" class="current"><a class="no_b_border" hidefocus="true" href="javascript:void(0)" tgt="tab1_iframe"><span>${ctp:i18n('org.external.dept.basic.info')}</span></a></li>
                    <li id="tab4"><a hidefocus="true" href="javascript:void(0)" tgt="tab4_iframe" class="last_tab no_b_border"><span>${ctp:i18n('org.external.member.info')}</span></a></li>
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