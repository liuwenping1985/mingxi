<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setDateHeader("Expires", 0);
  
%>
<html>
<head>
<title>weather</title>
<script>
var fragmentId="${fragmentId}";
var ordinal="${ordinal}";
var x="${x}";
var y="${y}";
var spaceId="${spaceId}";
function changCity(){
	location.href="/seeyon/portal/weatherController.do?method=changeCity&fragmentId="+fragmentId+"&ordinal="+ordinal+"&x="+x+"&y="+y+"&spaceId="+spaceId+"&width=${param.width}";
}
</script>
<link rel="stylesheet" href="/seeyon/common/all-min.css${ctp:resSuffix()}">
<link rel="stylesheet" href="/seeyon/common/weather/css/weather.css${ctp:resSuffix()}">
<c:if test="${CurrentUser.skin != null}">
    <link rel="stylesheet" href="/seeyon/skin/${CurrentUser.skin}/skin${CurrentUser.fontSize}.css${ctp:resSuffix()}">
</c:if>
<c:if test="${CurrentUser.skin == null}">
    <link rel="stylesheet" href="/seeyon/skin/default/skin${CurrentUser.fontSize}.css${ctp:resSuffix()}">
</c:if>
</head>
<body class="bg_color_none">
<div id="weather" align="center">
<a id="switch" href="javascript:void(0);" title="切换城市" onclick="changCity();">${weather.cityName }</a>
<span class="portal_weather_icon ${weather.weatherIcon }" title="${weather.weather}"></span>
<c:if test="${param.width ne '2'}">${weather.weather}</c:if>
${weather.temperature }
</div>
</body>
</html>