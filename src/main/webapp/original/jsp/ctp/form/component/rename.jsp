<%--
  Created by IntelliJ IDEA.
  User: daiye
  Date: 2015-12-21
  Time: 17:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
    <title>重命名单元格名称</title>
</head>
<body>
<div>
    <div style="width: 100%;height: 100%;font-size: 12px;">
        <div style="margin: 5px;line-height: 25px;">
            <span style="display: inline-block;width: 60px;">${ctp:i18n('form.forminputchoose.renamedata')}：</span>
            <span><label id="rowheader"></label></span>
        </div>
        <div class="clearfix" style="margin: 5px;line-height: 25px;">
            <div class="left" style="width: 60px;text-align: right;">
                ${ctp:i18n('form.forminputchoose.rename')}：
            </div>
            <div class="left">
                <div class="font_size12 common_txtbox_wrap" style="width: 150px;text-align: left;">
                    <input type="text" id="title" name="title" class="validate" validate='avoidChar:"\\/|()<>:*?#$%&\^\",",type:"string",name:"${ctp:i18n('form.forminputchoose.title') }",notNull:true,maxLength:255,notNullWithoutTrim:true'>
                </div>
            </div>
        </div>
        <div style="margin: 5px;line-height: 25px;">
            <span style="color: red; ">${ctp:i18n('form.forminputchoose.titleerror')}</span>
        </div>
    </div>
</div>
<script type="text/javascript">
    var dialogArg = window.dialogArguments;
    $(document).ready(function(){
        var value = dialogArg.value;
        var label = value;
        if (value.indexOf("(") != -1) {
            label = value.substring(0,value.indexOf("("));
            value = value.substring(value.indexOf("(")+1,value.indexOf(")"));
        }
        $("#rowheader").html(label);
        $("#title").val(value);
    });

    function isMark(str) {
        var myReg = /[\\:,()<>\/|\'\"?#$%&\^\*]/;
        if (myReg.test(str)) {
            return true;
        }
        return false;
    }

    String.prototype.Trim = function() {
        return this.replace(/(^\s*)|(\s*$)/g, "");
    }
    function OK(){
        var title = $("#title");
        var result = {
            newName: title.val()
        };
        result.success = title.validate();
        if (title.val().Trim() == ""){
            $.alert("${ctp:i18n('form.forminputchoose.renametitlecantnull')}");
        }

        if (isMark(title.val().Trim()) == true) {
            $.alert("${ctp:i18n('form.forminputchoose.inputerror')}" + " \: () \/ | > < : \* ? \' \" , & % $ # \^");
        }
        return result;
    }
</script>
</body>
</html>
