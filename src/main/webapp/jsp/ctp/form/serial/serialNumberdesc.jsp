<%--
 $Author:$
 $Rev:$
 $Date:: $:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
    <head>
        <title></title>
        <script type="text/javascript">

        </script>
    </head>
    <body>
        <div class="color_gray margin_l_20">
		    <div class="clearfix margin_t_20 margin_b_10">
		        <h2 class="left margin_0">${ctp:i18n('menu.flowidmanage.label') }</h2>
		        <div class="font_size12 left margin_l_10">
		            <div class="margin_t_10 font_size14">${ctp:i18n('form.helpinfo.total')} <span class="font_bold color_black" id = "listcount">${ctp:toHTML(size)}</span> ${ctp:i18n('formsection.infocenter.num')}</div>
		        </div>
		    </div>
		    <div class="line_height160 font_size14">
		        <p><span class="font_size12">●</span> ${ctp:i18n('form.serailNumber.desc.label1') }</p>
		    </div>
		</div>
    </body>
</html>