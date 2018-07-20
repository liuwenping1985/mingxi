<%--
 $Author:  $
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<script type="text/javascript">
    function OK() {
        var isValidate = $("#div_edit_properties").validate({
            validate : true
        });
        if (!isValidate) {
            return null;
        } else {
            return $.toJSON($("#div_edit_properties").formobj());
        }
    }
</script>
<title></title>
</head>
<body class="page_color h100b">
    <div class="form_area padding_5" id="div_edit_properties">
        <table border="0" cellspacing="0" cellpadding="0">
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('doc.jsp.knowledge.query.key')}：</label>
                </th>
                <td width="100%"><div class="common_txtbox_wrap">
                        <input type="text" id="keyword" maxlength="25" class="validate" value="${keyword}"
                             validate="name:'${ctp:i18n('doc.jsp.knowledge.query.key')}',notNull:true,maxLength:500,avoidChar:'-!@#$%^~\\]=\{\}\\/;[&*()<>?_+'" />
                        <%--隐藏域 --%>
                        <input type="hidden" id="id">
                    </div>
                </td>
            </tr>
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('doc.metadata.def.desc')}：</label>
                </th>
                <td width="100%"><div class="common_txtbox_wrap">
                         <textarea id="description" class="validate"
                                                style="width: 310px; height: 60px; border: 0;"
                                                validate="name:'${ctp:i18n('doc.metadata.def.desc')}',notNull:true,maxLength:500,avoidChar:'-!@#$%^~\\]=\{\}\\/;[&*()<>?_+'">${description}</textarea>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</body>
</html>
