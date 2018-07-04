<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>总数</title>
</head>
<body class="color_gray">
    <div class="clearfix">
        <h2 class="left"></h2>
        <div class="font_size12 left margin_t_20 margin_l_10">
            <div class="margin_t_10 font_size14">${ctp:i18n('colCube.common.total.text')}<%--总计 --%> 
                <span class="font_bold color_black">${ctp:toHTML(size)}</span> ${ctp:i18n('colCube.common.total.records')}<%--条 --%>
            </div>
        </div>
    </div>
    <div class="line_height160 font_size12 margin_l_10">
	
    </div>
</body>
</html>