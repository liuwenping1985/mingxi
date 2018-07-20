<%--
 $Author: muyx $ 
 $Rev: 1.0 $
 $Date:: 2012-9-7 上午10:55:54#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@page import="java.util.*"%>
<html>
<head>
<title></title>
<script type="text/javascript">
    
<%@ include file="/WEB-INF/jsp/apps/doc/js/personalStatus.js"%>
    
</script>
</head>
<%--个人知识状态 --%>
<body>
    <div class="font_size12 padding_l_10 padding_r_5 right" style="width: 251px;">
        <div class="border_all bg_color_white">
            <div class="font_size14 padding_l_10 margin_t_20">
                <strong>${CurrentUser.name}</strong><span class="ico16 margin_l_5"></span>
            </div>

            <div class="color_gray padding_l_10 margin_t_10">${personStaut.department.name}
                ${personStaut.orgPost.name}</div>
            <div class="clearfix padding_lr_10 margin_t_20">
                <a href="${path}/doc/knowledgeController.do?method=personalShare" class="common_button common_button_emphasize left">${ctp:i18n('doc.want.to.share')}</a> <span
                    class="line_height200 right">${ctp:i18n_1('doc.jsp.knowledge.have.share','${personStaut.shareNum}')}</span>
            </div>
            <div class="border_t margin_t_20 align_right padding_tb_5">
                <a href="javascript:void(0)" class="margin_r_10">${ctp:i18n('doc.jsp.knowledge.sharing ')}</a><a href="javascript:void(0)"
                    class="margin_r_10">${ctp:i18n('blog.myblog')}</a>
            </div>
        </div>
    </div>
</body>
</html>

