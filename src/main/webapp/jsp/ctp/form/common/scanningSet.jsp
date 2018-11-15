<%--
  Created by IntelliJ IDEA.
  User: wangh
  Date: 2016-2-1 0001
  Time: 17:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title>Title</title>
</head>
<body>
<div style='width: 230px;' class='clearfix margin_t_20 margin_l_30'>
    <div style='width: 100px;' class='left'>
        <select id='qType' name='qType' style='width: 100px;'>
            <option value='newLand'>Newland HR200</option>
            <option value='com'>Symbol DS6708</option>
        </select>
    </div>
    <div class='padding_lr_5 left'>-</div>
    <div style='width: 100px;' class='left'>
        <select id='comType' name='comType' style='width: 100px;'></select>
    </div>
</div>
</body>
<script>
    var dialogArg = window.dialogArguments;
    $(document).ready(function() {
        var htmlStr = "";
        for (var i = 1; i < 12; i++) {
            htmlStr = htmlStr + "<option value='" + i +"' "+((i + '') == c ? "selected" : "")+">COM"+i+"</option>";
        }
        $("#comType").append(htmlStr);
        var q = dialogArg.qType || "com";
        var c = dialogArg.comType || "1";
        $("#qType").val(q);
        $("#comType").val(c);
//        var qd = $.dropdown({id:"qType"});
//        qd.setValue(q);
//        var cd = $.dropdown({id:"comType"});
//        cd.setValue(c);
    });
    function OK(){
        var qType = $("#qType").val();
        var comType = $("#comType").val();
        return {qType:qType,comType:comType};
    }
</script>
</html>
