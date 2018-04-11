<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/phrase/commonphraseset.js.jsp" %>
<html>
<head>
	<script type="text/javascript" src="${path}/ajax.do?managerName=phraseManager"></script>
    <!-- 常用语 -->
    <title>${ctp:i18n('collaboration.common.commonLanguage')}</title>
</head>
<body>		
			<div style="float:right;">
                <!-- 常用语 -->
				<button id="cphrase" value="${ctp:i18n('collaboration.common.commonLanguage')}" 
                    text="${ctp:i18n('collaboration.common.commonLanguage')}" curUser="${CurrentUser.id}"></button>
           		 <input type="text" id="commp" />
            </div>
</body>
</html>

