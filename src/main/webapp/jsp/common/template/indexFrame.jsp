<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<script type="text/javascript">
$(function(){
	var isAccountAdmin = '${isAccountAdmin }';
	var url = _ctxPath + "/collTemplate/collTemplate.do?method=templateSysMgr&categoryType=1";
	$("#templateSysMgr").attr("src",url);
    $("#btn1").click(function(){
        $("#tab1").removeClass("common_tabs A").addClass("current");
        $("#tab2").removeClass("current").addClass("common_tabs A");
        $("#templateSysMgr").attr("src",url);
    });
    $("#btn2").bind("click",function(){
        $("#tab1").removeClass("current").addClass("common_tabs A");
        $("#tab2").removeClass("common_tabs A").addClass("current");
        $("#templateSysMgr").attr("src","${path}/permission/permission.do?method=list&category=col_flow_perm_policy");
    });
});
</script>

</head>
<body>
    <div id='layout' class="comp" comp="type:'layout',border:false">
        <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F01_collappset'"></div>
        <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F01_colltemplate'"></div>
        <div class="layout_north page_color" layout="height:33,sprit:false,border:false">
            <div>
                <div id="tabs2_head" class="common_tabs clearfix margin_l_5 margin_t_5">
                    <ul class="left">
                    	<c:choose>
                    		<c:when test="${isAccountAdmin }">
                    			<li id="tab1" class="current"><a id="btn1" href="javascript:void(0)" tgt="tab1_div"><span>${ctp:i18n('collaboration.template.manager')}</span></a></li>
	                            <li id="tab2"><a id="btn2" href="javascript:void(0)" tgt="tab2_div" class="last_tab no_b_border"><span>${ctp:i18n('collaboration.nodePerm.option')}</span></a></li>
                    		</c:when>
                    		<c:otherwise>
                    			<li id="tab1" class="current last_tab"><a id="btn1" href="javascript:void(0)" tgt="tab1_div"><span>${ctp:i18n('collaboration.template.manager')}</span></a></li>
                    		</c:otherwise>
                    	</c:choose>
                    </ul>
                </div>
                <div class="hr_heng"></div>
            </div>
        </div>
        <div class="layout_center over_hidden" layout="border:false">
            <iframe id="templateSysMgr" width="100%" height="100%" frameborder="0" src=""></iframe>
        </div>
    </div>
</body>
</html>