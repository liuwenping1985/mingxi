<%--
 $Author:
 $Rev: 
 $Date:: 
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/doc/docHeaderOnDocSubscribe.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>他人评论</title>
    <script type="text/javascript" src="${path}/apps_res/doc/js/doc.js"></script>
    <script type="text/javascript">
        <%@ include file="/WEB-INF/jsp/apps/doc/js/docUtil.js"%>
        <%@ include file="/WEB-INF/jsp/apps/doc/js/docForum.js"%>
    </script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
    <script type="text/javascript">
    $(function(){
        $(".tab_iframe li:odd").css({ background: "#F7F7F7" });
        //==========平分式页签================
        $(".common_tabs2").each(function (index) {
            var _this = $(this);
            _this.find(".common_tabs_head a").click(function () {
                _this.find(".common_tabs_head a").removeClass("current");
                $(this).addClass("current");
                _this.find(".tab_iframe").hide();
                _this.find("." + $(this).attr("tgt")).show();
            });
        });
	  });
    function test(o) {
        mySearchObj.flag = o;
        $('#myajaxgridbar').ajaxgridbarLoad(mySearchObj);
    }
    </script>
</head>
<body class="h100b over_hidden">
    <div class="page_color stadic_layout">
        <div class="stadic_layout_body stadic_body_top_bottom" layout="border:false">
            <div class="over_auto padding_b_10">
                <div class="clearfix padding_lr_10 padding_tb_5 border_t border_r bg_color_gray">
					<ul class="left">
						<li class="current"><a hideFocus="true"
							href="javascript:void(0)" onclick="javascript:test('0');"><span>${ctp:i18n('doc.title.comment.other')}</span></a></li>
						<li><a hideFocus="true" href="javascript:void(0)"
							onclick="javascript:test('1');"><span>${ctp:i18n('doc.title.comment.mine')}</span></a></li>
					</ul>
                    <div id="searchDiv" class="right"></div>
                </div>
                <ul id="ulwithlis" class="bg_color_white border_r border_b clearfix"></ul>
                <%@ include file="/WEB-INF/jsp/apps/doc/flipInfoBar.jsp"%>
            </div>
        </div>
    </div>
</body>
</html>