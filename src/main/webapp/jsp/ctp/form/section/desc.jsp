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
		        <h2 class="left margin_0">${ctp:i18n('menu.formcolumnconfig.label') }</h2>
		        <div class="font_size12 left  margin_l_10">
		            <div class="margin_t_10 font_size14">总计 <span id="listcount" class="font_bold color_black">${ctp:toHTML(param.size) }</span> 条</div>
		        </div>
		    </div>
		    <div class="line_height160 font_size14">
		        <p><span class="font_size12">●</span> ${ctp:i18n('formsection.list.desc.label1') }</p>
		        <p><span class="font_size12">●</span> ${ctp:i18n('formsection.list.desc.label2') }</p>
		        <p><span class="font_size12">●</span> ${ctp:i18n('formsection.list.desc.label3') }</p>
		        <p><span class="font_size12">●</span> ${ctp:i18n('formsection.list.desc.label4') }</p>
		        <p><span class="font_size12">●</span> ${ctp:i18n('formsection.list.desc.label5') }</p>
		        <p><span class="font_size12">●</span> ${ctp:i18n('formsection.list.desc.label6') }</p>
		    </div>
		</div>
    </body>
</html>