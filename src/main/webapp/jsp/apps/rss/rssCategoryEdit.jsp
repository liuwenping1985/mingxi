<%--
 $Author: muyx $ 
 $Rev: 1.0 $
 $Date:: 2012-9-7 上午10:55:54#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<script type="text/javascript">
    var _category_text_name = "<${ctp:i18n('rss.input.category.name')}>";
    $(function() {
        var isModify = true;
        if (!window.dialogArguments) {
            isModify = false;
            new inputChange($("#name"), _category_text_name);
        }
        initForm();
        //注册回车键
        $("#name").keydown(function(event){
            if (event.keyCode==13) {
                if(isModify){
                    getA8Top().frames['main'].fnModifyCategory();
                }else{
                    getA8Top().frames['main'].fnSubmitCategory();
                }
            }
        });
    })
    function OK() {
        var _this = $("#div_edit_category :text[id=name]");
        if (_this.val().trim() === _category_text_name
                || _this.val().trim().length === 0) {
            cancelCategory();
        }

        var isValidate = $("#div_edit_category").validate({
            validate : true
        });

        if (!isValidate) {
            if (_this.val().trim() === _category_text_name
                    || _this.val().trim().length === 0) {
                initCategoryText();
            }
            return null;
        } else {
            var data = $("#div_edit_category").formobj();
            return $.toJSON(data);
        }
    }

    function cancelCategory() {
        var data = new Object();
        data.name = "";
        $("#div_edit_category").fillform(data);
    }

    function initCategoryText() {
        $("#div_edit_category :text[id=name]").each(function() {
            $(this).val(_category_text_name);
            $(this).addClass("color_gray");
        });
    }

    function initForm() {
        if (window.dialogArguments) {
           var parentWindowData = window.parentDialogObj["categoryDialog"].getTransParams();
           $("#name").val(parentWindowData["name"]);
           $("#id").val(parentWindowData["id"]);        	        
        }
    }
</script>
<title></title>
</head>
<body class="h100b bg_color_white">
    <div class="form_area padding_5" id="div_edit_category">
        <table border="0" cellspacing="0" cellpadding="0">
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text"> <span class="color_red">*</span>${ctp:i18n('common.resource.body.name.label')}:</label>
                </th>
                <td width="100%"><div class="common_txtbox_wrap">
                        <input type="text" id="name" maxlength="25" class="validate font_size12"
                            validate="type:'string',name:'${ctp:i18n('common.resource.body.name.label')}',notNull:true,maxLength:25,avoidChar:'-!@#$%^~\\]=\'\{\}\\/;[&*()<>?_+',errorMsg:'${ctp:i18n('rss.category.alter.name.errorMsg')}'" />
                        <%--隐藏域 --%>
                        <input type="hidden" id="id">
                    </div>
                </td>
            </tr>
        </table>
    </div>
</body>
</html>

