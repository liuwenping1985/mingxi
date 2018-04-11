<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="bizRedirectUtil.jsp" %>
<html style="width: 100%;height: 100%;">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
    <script type="text/javascript">
        var resultObj = {};
        var redirectGrid;
        $(document).ready(function() {
            var redirectJSON = parent.getData();
            resultObj.completeRedirect = false;
            resultObj.bizObj = redirectJSON;
            var redirectData = $.parseJSON(redirectJSON);
            redirectGrid = new RedirectGrid({
                data: redirectData,
                headType: 7
            });
            parent.window.endLoadingData();
        });

        /**
         * 切换页签回掉函数，返回obj对象
         * obj.complateRedirect 是否完成当前页面所有重定向
         * obj.bizObj 当前页面返回的json对象
         */
        function getResultJSON() {
            resultObj.completeRedirect = redirectGrid.checkRedirectRight();
            resultObj.bizObj = redirectGrid.getResultJSON();
            return resultObj;
        }
    </script>
</head>
<body style="width: 100%;height: 100%">
</body>
</html>