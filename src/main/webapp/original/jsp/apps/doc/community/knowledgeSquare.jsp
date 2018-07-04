<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>$.i18n('doc.jsp.knowledge.knowledge.square')</title>
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
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/CollaborationApi.js${v3x:resSuffix()}"/>"></script>
<style type="text/css">
    .imgBanner { 
        overflow:hidden;
        *zoom:1;
        width:717px;
        height:117px;
        background:url(${path}/apps_res/doc/images/Knowledge_square_bj.jpg${v3x:resSuffix()}) no-repeat;
    }
    .clearMaxWidth { max-width: initial; }
    .common_font_rankingsTop1-3 { font-size: 18px; font-family: Arial, Helvetica, sans-serif; font-weight: bold; color: red; }
    .common_font_rankingsTop4-10 { font-size: 14px; font-family: Arial, Helvetica, sans-serif; }
    .zszx_file_list{margin-left:20px;}
    .zszx_file_list li { 
        margin-top:20px;
        margin-right:20px;
        height:50px; 
        width: 210px; 
        background:#f9f9f9; 
        border:1px solid #e9eaec;
        position:relative;
    }
    .zszx_file_list>li>span{
        position: absolute;
        top:50%;
        left:5px;
        margin-top:-16px;
    }
    .zszx_file_list>li>div{
        position: absolute;
        top:50%;
        left:42px;
        margin-top:-17px;
    }
    .zszx_file_list>li>div>p>a{
        display: inline-block;
        max-width:45px;
        overflow: hidden;
        white-space: nowrap;
        word-break: keep-all;
        text-overflow: ellipsis;
        position:relative;
        top:3px;
    }
    .zszx_file_list li .t{
        max-height:14px;
        max-width:134px;
        overflow: hidden;
        white-space: nowrap;
        word-break: keep-all;
        text-overflow: ellipsis;
    }
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
  width: 210px;
  border:1px solid #e9eaec;
}

.margin_r_42 {
  margin-right: 20px;
}

.area_page .area_main {
  width: 717px;
  float:left;
  padding:0;
  padding-bottom:50px;
  position: relative;
}

.area_page .area_sub {
  margin: 0 0px;
  width: 238px;
  float: right;
}
.border_all .border_b_gray2 {
background: #f7f8f9;
}
.clearfix {
    clear:both;
}
.common_button:active {
    border: solid 1px #0088FF;
    background: #fff;
    color: #656565;
}
.unitLearningArea{
    display:inline-block;
    padding:0 14px;
    border-bottom:2px solid #0088ff;
}
#knowledgeRankingMore{
    display:inline-block;
    float:right;
}
.set_height_40{
    height:40px;
    line-height:40px;
    background:#f7f8f9;
}
#rankScope>em{
    display: inline-block;
    width:0;
    height:14px;
    border-left:1px solid #d5d8db;
    float:left;
}
#rankScope>div{
    color:#296fbe;
}
#docTotalLable>a{
    float:right;
}
#divDocTotal{
    background:#f7f8f9;
    margin-top:2px;
}
#docEdge{
    background:#f9f9f9;
    margin-top:20px;
}
#docEdge>.clearfix{
    padding-left:5px;
}
a.text_overflow{
    padding:2px 5px;
}
#divPropagandaId{
    display: inline-block;
    float:right;
    position: absolute;
    font-size:12px;
    right:0;
    top:50%;
    margin-top:-8px;
}
#divLookUpId{
    width:100%;
    height:30px;
    background:#f7f8f9;
    position: absolute;
    bottom:0;
}
#divLookUpId>a{
    position: absolute;
    top:50%;
    left:50%;
    margin-top:-9px;
    margin-left:-28px;
}
.file_box_area_title{
    max-height:14px;
    overflow: hidden;
    white-space: nowrap;
    word-break: keep-all;
    text-overflow: ellipsis;
}
#rankScope>div.font_color{
    color:#333;
}
.area_page{
    background: none;
}
.bj_color_w{
    background: #fff;
}
</style>
</head>
<body style="background:#e9eaec;">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F04_knowledgeSquareFrame'"></div>
    <div class="area_page">
        <div class="area_main bj_color_w">
            <div class="imgBanner">
            <c:if test="${ctp:hasResourceCode('F04_docIndex') == true}">
               <a href="javascript:toDocLib()" class="common_button right margin_l_5 margin_r_20 margin_t_20 resCode" title="${ctp:i18n('doc.jsp.knowledge.go.knowledge.doclib')}">${ctp:i18n('doc.jsp.knowledge.go.knowledge.doclib')}</a>
            </c:if>
            <c:if test="${ctp:hasResourceCode('F04_showKnowledgeNavigation') == true}">
               <a href="javascript:toPersonalKnowledgeCenter()" class="common_button right margin_t_20 clearMaxWidth resCode" title="${ctp:i18n('doc.to.personal.knowledge.center')}">${ctp:i18n('doc.to.personal.knowledge.center')}</a>
            </c:if>
            </div>
            <div class="margin_t_15 font_size14 padding_l_20 padding_r_20">
                <div class="border_b" style="position:relative;">
                    <span class="unitLearningArea">${ctp:i18n('doc.account.learning')}</span>
                    <div id="divPropagandaId"></div>
                </div>
            </div>
            <ul class="zszx_file_list" id="propagandaUL">
            </ul>
            
            <div class="margin_t_10 font_size14 padding_lr_20">
                <div class="border_b">
                    <span style="padding:0 14px;border-bottom:2px solid #0088ff">${ctp:i18n('doc.knowledge.square.hot')}</span>
                </div>
            </div>
            <div class="margin_t_10 margin_l_5 padding_r_20">
                <a index="0" href="javascript:void(0);" title="${ctp:i18n('doc.knowledge.square.most.hot')}" onclick="fnSwith(this);"> 
                    <span id="spanBtn0" class="left padding_lr_10 padding_t_5 hand margin_t_5 margin_l_5 color_black">${ctp:i18n('doc.knowledge.square.most.hot')}</span>
                </a> 
                <a index="1" href="javascript:void(0);" title="${ctp:i18n('doc.knowledge.square.most.new')}" onclick="fnSwith(this);"> 
                    <span id="spanBtn1" class="left padding_lr_10 padding_t_5 margin_t_5 hand margin_l_5">${ctp:i18n('doc.knowledge.square.most.new')}</span>
                </a> 
                <a index="2" href="javascript:void(0);" title="${ctp:i18n('doc.jsp.knowledge.evaluation')}" onclick="fnSwith(this);"> 
                    <span id="spanBtn2" class="left padding_lr_10 padding_t_5 margin_t_5 hand margin_l_5">${ctp:i18n('doc.jsp.knowledge.evaluation')}</span>
                </a>
                <div id="searchDiv" class="right"></div>
            </div>
            <div id="divDocContent" class="clearfix padding_lr_20">
                <%-- 知识展现区 --%>
            </div>
            <div id="divLookUpId" class="margin_t_20 align_center hand font_size14">
                <a href="javascript:void(0);" onClick="fnGetMore(this);">${ctp:i18n('doc.jsp.knowledge.personal.viewMore')}</a>
            </div>
        </div>
      <div class="area_sub">
            <div class="border_all bg_color_white">
                <div class="set_height_40 padding_lr_10">
                    <strong style="font-weight:normal;font-size:14px;">${ctp:i18n('doc.knowledge.square.contribution.list')}</strong>
                    <div id="knowledgeRankingMore" class="border_t_gray2">
                        <c:if test="${ctp:hasPlugin('performanceReport')}">
                        <a class="font_size12" href="${path}/doc/knowledgeController.do?method=moreKnowledgeRanking">
                            ${ctp:i18n('doc.jsp.knowledge.more')}
                        </a>
                        </c:if>
                    </div>
                </div>
                <div class="padding_tb_5 padding_lr_10" style="margin-top:2px;background:#f7f8f9;">${rankingInfo.scoreInfo}</div>
                <div id="rankScope" class="clearFlow padding_tb_5 padding_lr_10">
                    <div id="week" class="left hand font_size12 padding_lr_10 font_color">${ctp:i18n('doc.knowledge.square.current.week')}</div>
                    <em></em>
                    <div id="month" class="left hand font_size12 padding_lr_10">${ctp:i18n('doc.knowledge.square.current.month')}</div>
                    <em></em>
                    <div id="total" class="left hand font-size12 padding_lr_10">${ctp:i18n('doc.jsp.knowledge.all')}</div>
                </div>
                <ul id="knowledgeRanking">
                </ul>
                
            </div>
            <div class="border_all margin_t_10 bg_color_white">
                <div id="docTotalLable" class="set_height_40 padding_lr_10">
                    <strong style="font-weight:normal;font-size:14px;padding-left:0;padding-right:0;" class="padding_lr_10">${ctp:i18n('doc.knowledge.square.knowldge.count')}</strong>
                    <c:if test="${ctp:hasPlugin('performanceReport')}">
                    <a class="font_size12" href="${path}/doc/knowledgeController.do?method=moreKnowlegeStatistics" style="padding-left: 50px">${ctp:i18n('doc.knowledge.add.trend')}</a>
                    </c:if>
                </div>
                <div id="divDocTotal" class="clearFlow padding_tb_5 padding_lr_10">
                     ${ctp:i18n('doc.knowledge.square.already.have')}<span id="spanDocTotal" class="color_orange padding_lr_5 font_bold font_size14"></span>${ctp:i18n('doc.jsp.knowledge.have.share.pieces')}
                </div>
                <ul id="knowlegeStatistics" class="margin_t_15">
                </ul>
            </div>
        </div>
    </div>
    <iframe id="iframe_empty" name="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>