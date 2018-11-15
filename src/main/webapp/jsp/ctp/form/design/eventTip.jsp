<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <script type="text/javascript">
    var content = "${v3x:toHTML(param.content)}";
        $(document).ready(function () {
            $("#content").html(content);
        });
        function OK() {
            try {
                return $("#content").html();
            } catch (e) {
                alert(e.message)
            }
            // window.dialogArguments.eventBind.name=document.getElementById("name").value;
        }
    </script>
</head>
<body>
<div style="font-size:12px; padding:10px; line-height:21px; word-break:break-all;">
    <p id="content"></p>
</div>
</body>
</html>