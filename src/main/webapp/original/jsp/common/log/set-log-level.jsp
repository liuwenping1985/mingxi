<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>

<html>
<head>
	<meta charset="utf-8">
	<title>log level set</title>
	<script>
		function setLevel(name,level) {
			window.location="${path}/ctp/sysmgr/monitor/log.do?method=editLevel&loggerName="+name+"&loggerLevel="+level;
        }
        function backInit() {
			window.location="${path}/ctp/sysmgr/monitor/log.do?method=backInitLevel";
        }
    </script>
</head>
<body>
	
	<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;运行态改变日志级别
	<br/><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="一建恢复到初始状态" onclick="backInit()"/>
	<br/><br/>
	<table style="color: #333333;" cellspacing="0" cellpadding="0" border="1" align="center">
		<tbody>
			<tr bgcolor="#CCCCFE">
				<th align="left" width="30%">Logger</th>
				<th align="left" width="15%">Init Level</th>
				<th align="left" width="15%">Now Level</th>
				<th align="left" width="40%">Set Level</th>
			</tr>
			<c:forEach items="${loggers}" var="bean" varStatus="status">
				<c:if test="${not empty bean.level}">
					<tr <c:if test="${status.count%2==0}">bgcolor="#d8d8d8"</c:if>>
						<td width="30%">${bean.name}</td>
						<td width="15%">${bean.initLevel}</td>
						<td width="15%">${bean.level}</td>
							<td width="40%">
								<input type="radio" name="${bean.name}" value="TRACE" onclick="setLevel('${bean.name}', 'TRACE')" ${bean.level=='TRACE' ? 'checked' : '' }/>TRACE&nbsp;
								<input type="radio" name="${bean.name}" value="DEBUG" onclick="setLevel('${bean.name}', 'DEBUG')" ${bean.level=='DEBUG' ? 'checked' : '' }/>DEBUG&nbsp;
								<input type="radio" name="${bean.name}" value="INFO" onclick="setLevel('${bean.name}', 'INFO')" ${bean.level=='INFO' ? 'checked' : '' }/>INFO&nbsp;
								<input type="radio" name="${bean.name}" value="WARN" onclick="setLevel('${bean.name}', 'WARN')" ${bean.level=='WARN' ? 'checked' : '' }/>WARN&nbsp;
								<input type="radio" name="${bean.name}" value="ERROR" onclick="setLevel('${bean.name}', 'ERROR')" ${bean.level=='ERROR' ? 'checked' : '' }/>ERROR&nbsp;
								<input type="radio" name="${bean.name}" value="FATAL" onclick="setLevel('${bean.name}', 'FATAL')" ${bean.level=='FATAL' ? 'checked' : '' }/>FATAL&nbsp;
								<input type="radio" name="${bean.name}" value="OFF" onclick="setLevel('${bean.name}', 'OFF')" ${bean.level=='OFF' ? 'checked' : '' }/>OFF&nbsp;
							</td>
						</tr>
				</c:if>
			</c:forEach>
		</tbody>
	</table>
	<br/><br/>
</body>
</html>