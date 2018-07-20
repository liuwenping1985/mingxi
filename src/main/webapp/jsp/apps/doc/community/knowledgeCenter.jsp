<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
    $(function() {
        $('#tab1').click(function() {
            $('#tabIframe').attr("src", "${path}/doc/knowledgeController.do?method=showKnowledgeNavigation");
        });
        $('#tab2').click(function() {
            $('#tabIframe').attr("src", "${path}/doc/knowledgeController.do?method=getDocOrgPush");
        });
        $('#tab3').click(function() {
            $('#tabIframe').attr("src", "${path}/doc/knowledgeController.do?method=getDocRecommend");
        });
        $('#tab4').click(function() {
            $('#tabIframe').attr("src", "${path}/doc/knowledgeController.do?method=getDocForum");
        });
        $('#tab5').click(function() {
            $('#tabIframe').attr("src", "${path}/doc/knowledgeController.do?method=getMySubscribe");
        });
        $('#tab6').click(function() {
            $('#tabIframe').attr("src", "${path}/doc/knowledgeController.do?method=getMyCollect");
        });
    });
</script>
</head>
<body class="page_color">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F04_showKnowledgeNavigation'"></div>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:26,border:false,sprit:false">
            <div class="font_size12 clearfix padding_lr_10 padding_tb_5">
                <span class="left"><strong>${ctp:i18n("doc.jsp.knowledge.center")}</strong></span> <span class="right"><a
                    href="#">${ctp:i18n("doc.jsp.knowledge.go.knowledge.square")}</a></span>
            </div>
            <div class="hr_heng"></div>
        </div>
        <div id="lc_layout_center" class="layout_center over_hidden" layout="border:false,sprit:false">
            <div id="tabs" class="comp" comp="type:'tab',parentId:'lc_layout_center'">
                <div id="tabs_head" class="common_tabs clearfix margin_t_5 margin_l_10">
                    <ul id="knowledgeCenter" class="left">
                        <li id="tab1" class="current"><a hidefocus="true" href="javascript:void(0)" tgt="tabIframe">${ctp:i18n("doc.jsp.knowledge.myLib")}</a></li>
                        <li id="tab2"><a hidefocus="true" href="javascript:void(0)" tgt="tabIframe">${ctp:i18n("doc.jsp.knowledge.orgPush")}</a></li>
                        <li id="tab3"><a hidefocus="true" href="javascript:void(0)" tgt="tabIframe">${ctp:i18n("doc.jsp.knowledge.others.recommend")}</a></li>
                        <li id="tab4"><a hidefocus="true" href="javascript:void(0)" tgt="tabIframe">${ctp:i18n("doc.jsp.knowledge.others.evaluation")}</a></li>
                        <li id="tab5"><a hidefocus="true" href="javascript:void(0)" tgt="tabIframe">${ctp:i18n("doc.jsp.knowledge.my.subscription")}</a></li>
                        <li id="tab6"><a hidefocus="true" href="javascript:void(0)" tgt="tabIframe" class="last_tab">${ctp:i18n("doc.jsp.knowledge.my.collection")}</a></li>
                    </ul>
                </div>
                <div id="tabs_body" class="common_tabs_body">
                    <iframe id="tabIframe" border="0"
                        src="${path}/doc/knowledgeController.do?method=showKnowledgeNavigation" frameBorder="no"
                        width="100%"></iframe>
                </div>
            </div>
        </div>
    </div>
</body>
</html>



