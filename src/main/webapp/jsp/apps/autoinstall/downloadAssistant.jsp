<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
</head>
<body scroll="no">
<fieldset class="margin_10">
	<legend class="font_bold">${ctp:i18n('autoinstall.must.label')}</legend>
    <table cellspacing="0" cellpadding="0" border="0" width="600" height="100%" class="font_size12">
       	<c:forEach var="must" items="${mustList}">
       		<c:set var="name1" value="autoinstall.${must}.name"/>
       		<c:set var="desc1" value="autoinstall.${must}.desc"/>
       		<c:set var="url1" value="autoinstall.${must}.url"/>
       		<c:if test="${must == 'commonactivex' || must == 'wizard'}">
       		<c:set var="url1" value="autoinstall.${must}.url.${ctp:getSystemProperty('system.geniusFolder')}"/>
       		</c:if>
        	<tr height="30">
                <td width="150">${ctp:i18n(name1)}</td>
                <td><div style="width: 350px;" class="text_overflow">${ctp:i18n(desc1)}</div></td>
                <td width="100" align="right">
                	<c:if test="${must != 'flash' && must != 'quicktime'}">
		        		<a class="common_button common_button_emphasize margin_r_10" target="_blank" href="<c:url value='${ctp:i18n(url1)}' />">${ctp:i18n('autoinstall.download.label')}</a>
		        	</c:if>
				</td>
            </tr>
		</c:forEach>
    </table>
</fieldset>
<fieldset class="margin_10">
	<legend class="font_bold">${ctp:i18n('autoinstall.choose.label')}</legend>
    <table cellspacing="0" cellpadding="0" border="0" width="600" height="100%" class="font_size12">
		<c:forEach var="choose" items="${chooseList}">
			<c:set var="name2" value="autoinstall.${choose}.name"/>
       		<c:set var="desc2" value="autoinstall.${choose}.desc"/>
       		<c:set var="url2" value="autoinstall.${choose}.url"/>
       		<c:if test="${must == 'commonactivex' || must == 'wizard'}">
       		<c:set var="url2" value="autoinstall.${choose}.url.${ctp:getSystemProperty('system.geniusFolder')}"/>
       		</c:if>
			<tr height="30">
		        <td width="150">${ctp:i18n(name2)}</td>
		        <td><div style="width: 350px;" class="text_overflow">${ctp:i18n(desc2)}</div></td>
		        <td width="100" align="right">
		        	<c:if test="${must != 'flash' && must != 'quicktime'}">
		        		<a class="common_button common_button_emphasize margin_r_10" target="_blank" href="<c:url value='${ctp:i18n(url2)}' />">${ctp:i18n('autoinstall.download.label')}</a>
		        	</c:if>
		        </td>
		    </tr>
		</c:forEach>
    </table>
</fieldset>
</body>
</html>