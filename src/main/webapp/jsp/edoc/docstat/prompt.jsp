<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="w100b h100b">
<head>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>prompt页面</title>
<script type="text/javascript">
    
    $(function(){
        window.transParams = window.transParams || {};   
        
        var initValue = transParams.initValue;
        var msg = transParams.msg;
        
        if(initValue){
            $("#promptContent").val(initValue);
        }
        $("#msg_div").text(msg);
    });
    
    function OK(){
        return $("#promptContent").val();
    }
</script>
</head>
<body class="h100b w100b" style="background-color: #fafafa">
    <div class="font_size12" style="padding: 42px 26px 16px 26px;">
        <div class="w100b" id="msg_div" style="margin-bottom: 10px;"></div>
        <div class="w100b">
            <input id="promptContent" value="" style="height: 20px" class="w100b"/>
        </div>
    </div>
</body>
</html>