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
    var inputFolderLable = "<${ctp:i18n('doc.alert.input.folderName')}>";
    $(function() {
        if (!window.dialogArguments) { 
            new inputChange($("#title"), inputFolderLable);
        }
        initForm();
        $("#title").keydown(function(event){
            if (event.keyCode==13) {
                getA8Top().frames['main'].fnNewDocFolderBtn();
            }
        });
    })
    function OK() {
        var _this = $("#divNewFolderId :text[id=title]");
        if (_this.val().trim() === inputFolderLable
                || _this.val().trim().length === 0) {
            cancelCategory();
        }
        _this.val(_this.val().trim());
        
        var isValidate = $("#divNewFolderId").validate({
            validate : true
        });

        if (!isValidate) {
            if (_this.val().trim() === inputFolderLable
                    || _this.val().trim().length === 0) {
                initCategoryText();
            }
            return null;
        } else {
            var data = $("#divNewFolderId").formobj();
            return $.toJSON(data);
        }
    }

    function cancelCategory() {
        var data = new Object();
        data.name = "";
        $("#divNewFolderId").fillform(data);
    }

    function initCategoryText() {
        $("#divNewFolderId :text[id=name]").each(function() {
            $(this).val(inputFolderLable);
            $(this).addClass("color_gray");
        });
    }

    function initForm() {
        if (window.dialogArguments) {
            var data = $.parseJSON(window.dialogArguments.replace(/\\/g, ''));
            $("#divNewFolderId").fillform(data);
        }
    }
</script>
<title></title>
</head>
<body class="h100b">
    <div class="form_area padding_5" id="divNewFolderId">
        <table border="0" cellspacing="0" cellpadding="0">
            <tr>
                <th nowrap="nowrap"><label class="margin_r_5" for="text"> <span class="color_red">*</span>${ctp:i18n('common.resource.body.name.label')}:</label>
                </th>
                <td class="w90b"><div class="common_txtbox_wrap">
                        <input type="text" id="title" maxlength="80" class="validate font_size12"
                            validate="type:'string',name:'${ctp:i18n('doc.jsp.createf.name')}',notNull:true,maxLength:80,avoidChar:'-!@#$%^~\\]=\'\{\}\\/;[&*()<>?_+'" />
                        <%--隐藏域 --%>
                        <input type="hidden" id="id">
                    </div></td>
            </tr>
        </table>
    </div>
</body>
</html>

