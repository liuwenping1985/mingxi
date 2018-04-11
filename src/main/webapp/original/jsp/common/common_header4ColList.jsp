
<link href="/seeyon/common/images/${ctp:getSystemProperty('portal.porletSelectorFlag')}/favicon${ctp:getSystemProperty('portal.favicon')}.ico${ctp:resSuffix()}" type="image/x-icon" rel="icon"/>
<link rel="stylesheet" href="/seeyon/common/all-min.css${ctp:resSuffix()}">
<c:if test="${CurrentUser.skin != null}">
    <link rel="stylesheet" href="/seeyon/skin/${CurrentUser.skin}/skin${CurrentUser.fontSize}.css${ctp:resSuffix()}">
</c:if>
<c:if test="${CurrentUser.skin == null}">
    <link rel="stylesheet" href="/seeyon/skin/default/skin${CurrentUser.fontSize}.css${ctp:resSuffix()}">
</c:if>
<link rel="stylesheet" href="/seeyon/common/css/peoplecard.css${ctp:resSuffix()}">
<link rel="stylesheet" type="text/css"  href="/seeyon/common/css/dd.css${ctp:resSuffix()}">
<link rel="stylesheet" id="mainSkinCss" type="text/css"  href="${ctp:getUserDefaultCssPath()}">
<link rel="stylesheet" type="text/css"  href="/seeyon/main/skin/frame/default/default_common.css${ctp:resSuffix()}">
<link rel="stylesheet" href="/seeyon/common/image/css/touchTouch.css${ctp:resSuffix()}">
<link href="/seeyon/common/css/select2.css${ctp:resSuffix()}" type="text/css" rel="stylesheet" />
