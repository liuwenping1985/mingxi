<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<script type="text/javascript">
var url = _ctxPath + "/i18NResource.do?method=i18nMain&showType=PC";
$(function(){
	var isAccountAdmin = '${isAccountAdmin }';
	$("#i18nMainFrame").attr("src",url);
});
function btn1Clk(){
    $("#tab1").removeClass("common_tabs A").addClass("current");
    $("#tab2").removeClass("current").addClass("common_tabs A");
    $("#i18nMainFrame").attr("src",url);
}
function btn12Clk (){
    $("#tab1").removeClass("current").addClass("common_tabs A");
    $("#tab2").removeClass("common_tabs A").addClass("current");
    $("#i18nMainFrame").attr("src","${path}/i18NResource.do?method=i18nMain&showType=M3");
}
</script>

</head>
<body>
    <div id='layout' class="comp" comp="type:'layout',border:false">
        <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F01_collappset'"></div>
        <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F01_colltemplate'"></div>
        <div class="layout_north page_color" layout="height:38,sprit:false,border:false">
            <div>
                <div id="tabs2_head" class="common_tabs clearfix margin_l_5 margin_t_5">
                    <ul class="left">
                    	<li id="tab1" class="current"><a id="btn1" href="javascript:btn1Clk()" tgt="tab1_div"><span>PC</span></a></li>
	                    <li id="tab2"><a id="btn2" href="javascript:btn12Clk(0)" tgt="tab2_div" class="last_tab no_b_border"><span>M3</span></a></li>
                    </ul>
                </div>
                <!-- <div class="hr_heng"></div> -->
            </div>
        </div>
        <div class="layout_center over_hidden" layout="border:false">
            <iframe id="i18nMainFrame" width="100%" height="100%" frameborder="0" src=""></iframe>
        </div>
    </div>
</body>
</html>