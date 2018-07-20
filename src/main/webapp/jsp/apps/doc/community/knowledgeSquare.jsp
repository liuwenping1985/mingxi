<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>知识广场</title>
<script type="text/javascript" src="${path}/apps_res/doc/js/doc.js"></script>
<%@ include file="/WEB-INF/jsp/apps/doc/public/queryBar.jsp"%>
<script type="text/javascript">
    <%@ include file="/WEB-INF/jsp/apps/doc/js/squarePublicity.js"%>
    <%@ include file="/WEB-INF/jsp/apps/doc/js/docUtil.js"%>
    <%@ include file="/WEB-INF/jsp/apps/doc/js/knowledgeSquare.js"%>
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/doc/js/docFavorite.js?V=V5_0_product.build.date"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/webmail/js/webmail.js${v3x:resSuffix()}" />"></script>
<style type="text/css">
    .imgBanner { overflow:hidden;*zoom:1;  padding:64px 5px 10px 5px; background:url(${path}/skin/default/images/zszx_img.png);}
    .clearMaxWidth { max-width: initial; }
    .common_font_rankingsTop1-3 { font-size: 18px; font-family: Arial, Helvetica, sans-serif; font-weight: bold; color: red; }
    .common_font_rankingsTop4-10 { font-size: 14px; font-family: Arial, Helvetica, sans-serif; }
    .zszx_file_list li { height:50px; width: 220px }
    .lvl1 .lvlIcon { position:relative;top:-3px;left:-5px;}
    .common_button, .form_btn {
            max-width: 170px;
    }
</style>
<style type="text/css">
.area_page {
  width: 965px;
}
.file_box_area {
  width: 233px;
}

.margin_r_42 {
  margin-right: 10px;
}

.area_page .area_main {
  width: 725px;
  padding: 0 8px 0  0;
}

.area_page .area_sub {
  margin: 0 0px;
  width: 230px;
}
.border_all .border_b_gray2 {
background: #daeaf1;
}

</style>
</head>
<body class="per_center">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F04_knowledgeSquareFrame'"></div>
    <div class="area_page">
        <div class="area_main">
            <div class="imgBanner">
                <a href="javascript:toDocLib()" class="common_button common_button_gray right margin_l_10 resCode" resCode="F04_docIndex" title="${ctp:i18n('doc.jsp.knowledge.go.knowledge.doclib')}">${ctp:i18n('doc.jsp.knowledge.go.knowledge.doclib')}</a>
                <a href="javascript:toPersonalKnowledgeCenter()" class="common_button common_button_gray right clearMaxWidth resCode" resCode="F04_showKnowledgeNavigation" title="${ctp:i18n('doc.to.personal.knowledge.center')}">${ctp:i18n('doc.to.personal.knowledge.center')}</a>
            </div>
            <div class="margin_t_10 font_bold font_size14 border_b">
                 ${ctp:i18n('doc.account.learning')}<br />
                <em class="title_ico margin_t_5"></em>
            </div>
            <ul class="zszx_file_list" id="propagandaUL">
            </ul>
            <div id="divPropagandaId"></div>
            <div class="margin_t_10 font_bold font_size14 border_b">
                 ${ctp:i18n('doc.knowledge.square.hot')}<br /> <em class="title_ico margin_t_5"></em>
            </div>
            <div class="clearFlow margin_t_10">
                <a index="0" href="javascript:void(0);" title="${ctp:i18n('doc.knowledge.square.most.hot')}" onclick="fnSwith(this);"> 
                    <span id="spanBtn0" class="left padding_lr_10 padding_tb_5 hand margin_l_5 page_color color_black">${ctp:i18n('doc.knowledge.square.most.hot')}</span>
                </a> 
                <a index="1" href="javascript:void(0);" title="${ctp:i18n('doc.knowledge.square.most.new')}" onclick="fnSwith(this);"> 
                    <span id="spanBtn1" class="left padding_lr_10 padding_tb_5 hand margin_l_5">${ctp:i18n('doc.knowledge.square.most.new')}</span>
                </a> 
                <a index="2" href="javascript:void(0);" title="${ctp:i18n('doc.jsp.knowledge.evaluation')}" onclick="fnSwith(this);"> 
                    <span id="spanBtn2" class="left padding_lr_10 padding_tb_5 hand margin_l_5">${ctp:i18n('doc.jsp.knowledge.evaluation')}</span>
                </a>
                <div id="searchDiv" class="right"></div>
            </div>
            <div id="divDocContent" class="clearFlow">
                <%-- 知识展现区 --%>
            </div>
            <div id="divLookUpId" class="margin_t_10 padding_tb_5 align_center border_all hand">
                <a href="javascript:void(0);" onClick="fnGetMore(this);">${ctp:i18n('doc.jsp.knowledge.personal.viewMore')}</a>
            </div>
        </div>
      <div class="area_sub">
            <div class="border_all">
                <div class="padding_tb_5 padding_lr_10 border_b_gray2"><strong>${ctp:i18n('doc.knowledge.square.contribution.list')}</strong></div>
                <div class="padding_tb_5 padding_lr_10 border_b_gray2" style="margin-top:1px;">${rankingInfo.scoreInfo}</div>
                <div id="rankScope" class="clearFlow padding_tb_5 padding_lr_10">
                    <div id="week" class="left hand padding_tb_5 padding_lr_10 page_color">${ctp:i18n('doc.knowledge.square.current.week')}</div>
                    <div id="month" class="left hand padding_tb_5 padding_lr_10">${ctp:i18n('doc.knowledge.square.current.month')}</div>
                    <div id="total" class="left hand padding_tb_5 padding_lr_10">${ctp:i18n('doc.jsp.knowledge.all')}</div>
                </div>
                <ul id="knowledgeRanking">
                </ul>
                <div id="knowledgeRankingMore" class="border_t_gray2 padding_tb_5 padding_lr_10 align_right"><a href="${path}/doc/knowledgeController.do?method=moreKnowledgeRanking">${ctp:i18n('doc.jsp.knowledge.more')}</a></div>
            </div>
            <div class="border_all margin_t_5">
                <div id="docTotalLable" class="padding_tb_5 border_b_gray2"><strong class="padding_lr_10">${ctp:i18n('doc.knowledge.square.knowldge.count')}</strong> <a href="${path}/doc/knowledgeController.do?method=moreKnowlegeStatistics" style="padding-left: 50px">${ctp:i18n('doc.knowledge.add.trend')}</a></div>
                <div id="divDocTotal" class="clearFlow padding_tb_5 padding_lr_10">
                     ${ctp:i18n('doc.knowledge.square.already.have')}<span id="spanDocTotal" class="color_orange padding_lr_5 font_bold font_size14"></span>${ctp:i18n('doc.jsp.knowledge.have.share.pieces')}
                </div>
                <ul id="knowlegeStatistics">
                </ul>
            </div>
        </div>
    </div>
    <iframe id="iframe_empty" name="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>