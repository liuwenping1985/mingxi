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
<html>
<head>
<script type="text/javascript">
    $(function() {
    });

    function OK() {       
        var data = $("#divIsOnlyListId").formobj();
        return $.toJSON(data);
    }
</script>
<title></title>
</head>
<body>
    <div id="divIsOnlyListId"  class="padding_10 align_center">
        <div class="w90b font_size12 common_center">
            <div class="common_checkbox_box align_left clearfix">
                <label class="padding_10 hand" for="isOnlyList"> <input id="isOnlyList" class="radio_com"
                    name="option" value="0" type="checkbox">${ctp:i18n('doc.knowledgeSquare.public.onlyName')}</label>
            </div>
            <div class="padding_10 color_gray align_left">${ctp:i18n('doc.alert.public.onlyName')}</div>
        </div>
    </div>
</body>
</html>