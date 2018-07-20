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
<style>
.stadic_head_height {
  height: 35px;
}

.stadic_body_top_bottom {
  bottom: 35px;
  top: 35px;
}

.stadic_footer_height {
  height: 35px;
}
</style>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script type="text/javascript" src="${path}/apps_res/doc/js/doc.js"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/doc/js/docFavorite.js?V=V5_0_product.build.date"></script>
	<script type="text/javascript">
		<%@ include file="/WEB-INF/jsp/apps/doc/js/docUtil.js"%>
		<%@ include file="/WEB-INF/jsp/apps/doc/js/docRecommend.js"%>
	</script>
</head>
<body class="h100b over_hidden">
<script language="javascript">
 showCtpLocation('F04_getDocRecommend');
</script>
<div class="stadic_layout border_l border_r">
    <div class="stadic_layout_head stadic_head_height ">
        <div id="searchDiv" class="right margin_5"></div>
    </div>
    <div class="stadic_layout_body stadic_body_top_bottom border_t">
        <ul id="ulwithlis_recommend" class="bg_color_white  clearfix"></ul>
    </div>
    <div class="stadic_layout_footer stadic_footer_height border_t margin_b_5">
        <%@ include file="/WEB-INF/jsp/apps/doc/flipInfoBar.jsp"%>
    </div>
</div>
<div id='toBorrowId' style="display:none;">
    <textarea id='borrowMsg' style='overflow:hidden'  class="validate w100b"
                    validate="notNull:true,regExp:/^-?\d+$/,errorMsg:'${ctp:i18n('doc.input.recommend.warning')}'"
                    cols="30" rows="7">${ctp:i18n('doc.jsp.knowledge.borrow.default.message')}</textarea>
</div>
</body>
</html>