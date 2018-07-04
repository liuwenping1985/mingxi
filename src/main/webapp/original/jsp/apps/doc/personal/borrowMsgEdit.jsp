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
    var borrowDaysLabel = "<${ctp:i18n('doc.input.borrow.days')}>";
    var borrowRefuseLabel = "<${ctp:i18n('doc.input.msg.content')}>";
    var isAgree = ('${param.isAgree}');
    var id = "#borrowAgreeTopId";

    $(function() {
        new inputChange($("#days"), borrowDaysLabel);
        new inputChange($("#replyMsg"), borrowRefuseLabel);
        if (isAgree === 'true' || isAgree === true) {
            isAgree = true;
           $("#borrowAgreeTable").removeClass("display_none");
           var sValidate = $("#replyMsg").attr("validate");
           sValidate=sValidate.replace(",notNull:true","");
           $("#replyMsg").attr("validate",sValidate)
        } else {
            id = "#borrowRefuseTopId";
            $("#borrowAgreeTable").addClass("display_none");
            //拒绝2
            $("#status").val(2);
            $("#replyMsg").attr("rows", 5);
        }
        $("#days").removeClass("color_gray").val(180);
    });

    function OK() {
        var val = $("#replyMsg").val().trim();
        if (val === borrowRefuseLabel) {
            $("#replyMsg").val("");
        }
        
        var isPass = $(id).validate({
            validate : true
        });
        
        if (!isPass) {
            return null;
        }
        var data = $(id).formobj();
        // alert($.toJSON(data));
        return $.toJSON(data);
    } 
</script>
<title></title>
</head>
<body class="h100b">
    <div id="borrowAgreeTopId" class="form_area padding_5 margin_lr_5">
        <table id="borrowAgreeTable" border="0" cellspacing="0" cellpadding="0" width="100%">
            <tr>
                <td nowrap="nowrap" width="70">
                    <label class="margin_r_5" for="text"><span class="color_red">*</span>${ctp:i18n('doc.borrow.deadline')}:</label>
                </td>
                <td align="left" colspan="3">
                    <div class="common_txtbox_wrap left">
                        <input id="days" type="text" maxlength="4" class="validate font_size12"
                            validate="type:'string',name:'${ctp:i18n('doc.borrow.deadline')}',notNull:true,maxLength:4,regExp:/^[1-9]\d*$/,errorMsg:'${ctp:i18n('doc.borrow.time.limit')}'" />
                    </div><span class="valign_m margin_l_5">${ctp:i18n('doc.createtime.days')}</span>
                </td>
            </tr>
            <tr>
                <td colspan="3"><div class="padding_tb_5">
                        <label class="margin_r_10 hand" for="readOnly"> <input id="readOnly" class="radio_com font_size12"
                            name="option" value="1" type="radio" >${ctp:i18n('doc.jsp.properties.share.acl.readonly')}（${ctp:i18n('doc.input.title.contain')}${ctp:i18n('doc.menu.print.label')}、${ctp:i18n('doc.menu.download.label')}、${ctp:i18n('doc.menu.forward.label')}）</label>
                    </div></td>
            </tr>
            <tr>
                <td colspan="3"><div class="padding_tb_5 font_size12">
                        <label class="margin_r_10 hand" for="list"> <input id="list" class="radio_com" checked
                            name="option" value="1" type="radio">${ctp:i18n('doc.jsp.properties.share.acl.browse')}</label>
                    </div></td>
            </tr>
        </table>
        <c:if test="${param.isAgree ne 'true'}"><font class="color_red">*</font></c:if>
            ${ctp:i18n('doc.description')}:<br>
            <div id="borrowRefuseTopId">
                        <textarea id="replyMsg" class="validate font_size12 margin_t_5"
                            validate="name:'${ctp:i18n('doc.description')}',maxLength:160,notNull:true,avoidChar:'-!@#$%^~\\]=\{\}\\/;[&*()<>?_+'"
                            style="width:355px;height:70px;*width:340px;height:55px"></textarea>
                <input type="hidden" id="status" value="1">
            </div>
    </div>
</body>
</html>