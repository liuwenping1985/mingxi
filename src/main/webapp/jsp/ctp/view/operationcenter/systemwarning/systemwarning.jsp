<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>info</title>
        <%@ include file="/WEB-INF/jsp/ctp/view/platview_header.jsp" %>
        <%@ include file="/WEB-INF/jsp/ctp/view/platview_common.jsp" %>
        <script type="text/javascript" src="pc_index.js"></script>
    </head>
    <body class="body_infos">
        <div class="second_index_body">
	        <div class="info_body">
	            <div class="servise_info">
	                <span class="servise_info_span">安全预警</span>
	                <table class="info_table" border="0" cellspacing="0" cellpadding="0" width="100%">
	                    <tr>
	                        <td class="blue_td" width="20%">分类</td>
	                        <td class="blue_td" width="40%">预警描述</td>
	                        <td class="blue_td" width="40%">建议方案</td>
	                    </tr>
	                    <!-- 
	                    <tr>
	                        <td class="blue_td">账号安全</td>
	                        <td>账号：*****密码复杂度较低</td>
	                        <td>建议开启密码强度验证及密码过期期限</td>
	                    </tr>
	                    <tr>
	                        <td class="blue_td">系统端口</td>
	                        <td>已使用端口：80（HTTP端口）、8951（AJP端口）</td>
	                        <td>8951......端口若不使用，不需对外开放</td>
	                    </tr>
	                     -->
	                    <tr>
	                        <td class="blue_td">系统开关</td>
	                        <td>附件加密：${attachEncryptText }</td>
	                        <td>${attachEncryptWarn }</td>
	                    </tr>
	                </table>
	            </div>
	            <div class="servise_info">
	                <span class="servise_info_span">系统配置预警</span>
	                <table class="info_table" border="0" cellspacing="0" cellpadding="0">
	                    <tr>
	                        <td class="blue_td" width="20%">分类</td>
	                        <td class="blue_td" width="40%">预警描述</td>
	                        <td class="blue_td" width="40%">建议方案</td>
	                    </tr>
	                    <tr>
	                        <td class="blue_td">系统开关</td>
	                        <td>性能跟踪开关：${performanceText } </td>
	                        <td>${performanceWarn }</td>
	                    </tr>
	                    <tr>
	                        <td class="blue_td">系统开关</td>
	                        <td>重建索引设置：${rebuildIndexFlag}&nbsp;${rebuildIndexText }</td>
	                        <td>${rebuildIndexWarn }</td>
	                    </tr>
	                    
	                </table>
	            </div>
	            <div class="servise_info">
	                <span class="servise_info_span">容量预警</span>
	                <table class="info_table" border="0" cellspacing="0" cellpadding="0" width="100%">
	                    <tr>
	                        <td class="blue_td" width="20%">分类</td>
	                        <td class="blue_td" width="40%">预警描述</td>
	                        <td class="blue_td" width="40%">建议方案</td>
	                    </tr>
	                    <c:forEach items="${attmsglist }" var="attmsg">
	                    <tr>
	                        <td class="blue_td">${attmsg[0] }</td>
	                        <td>${attmsg[1] }</td>
	                        <td>${attmsg[2] }</td>
	                    </tr>
	                    </c:forEach>
	                </table>
	            </div>
	        </div>
        </div>
    </body>
</html>