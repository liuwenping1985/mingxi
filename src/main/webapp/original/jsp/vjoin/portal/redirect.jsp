<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<%@ include file="/main/common/portal_header.jsp"%>
<title></title>
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<script type="text/javascript">
    var isCtpTop = true;
    var isV5Member = false;
    var isVJRedirect = true;//VJ中转标识，A8兼容判断
    var v3x = new V3X();
    v3x.init("${pageContext.request.contextPath}", "<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");

    //兼容方法
    function hideLocation() {
    }
    function showMoreSectionLocation(text) {
    }

    function showMenu(url) {
        var _openUrl = _ctxPath + "/vjoin/portal.do?method=redirect&url=" + encodeURIComponent(url);
        openCtpWindow({
            "url" : _openUrl
        });
    }
</script>
</head>
<body scroll="no" class="w100b h100b">
    <iframe src="${url}" id="main" name="main" frameborder="0" class="w100b h100b" style="position: fixed;"></iframe>
</body>
<script type="text/javascript">
    //iframe 加载完成后执行
    var oFrm = document.getElementById('main');
    oFrm.onload = oFrm.onreadystatechange = function() {
        if (this.readyState && this.readyState != 'complete')
            return;
        else {
            document.title = window.frames["main"].document.title;
        }
    }
</script>
</html>