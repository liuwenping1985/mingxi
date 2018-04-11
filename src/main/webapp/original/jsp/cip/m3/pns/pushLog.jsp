<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html class="h100b">
<head>
	<title>移动M3消息推送日志</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/m3/css/pushlog.css" />
	<script type="text/javascript" src="${path}/ajax.do?managerName=m3PnsMessageLogManager"></script>
	<script type="text/javascript" src="${path}/apps_res/m3/js/pushlog.js"></script>
	
	
</head>
<body class="h100b">
	<table class="mainTable">
		
		<tbody>
			<tr>
				<td class="queryTd txtAlign-center" rowspan="2" style="width: 10%">查询条件</td>
				<td class="queryTd txtAlign-right" style="width: 5%">消息内容</td>
				<td class="queryTd txtAlign-left" style="width: 10%"><input type="text" id="content"/></td>
				<td class="queryTd txtAlign-right" style="width: 5%">发送人</td>
				<td class="queryTd txtAlign-left" style="width: 10%"><input type="text" id="sendMemeber"/></td>
				<td class="queryTd txtAlign-right" style="width: 5%">接收人</td>
				<td class="queryTd txtAlign-left" style="width: 10%"><input type="text" id="receiverMember"/></td>
				<td class="queryTd txtAlign-left" style="width: 45%" rowspan="2"><button id="queryLog" class="common_button common_button_gray">查询</button>&nbsp;&nbsp;<button id="reset" class="common_button common_button_gray">重置</button></td>
			</tr>
			<tr>
				<td class="queryTd txtAlign-right" >发送时间</td>
				<td class="queryTd txtAlign-left" colspan=5><input type="text" id="startTime" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:true,
cache:false,isClear:true,clearBlank:false"/>至<input type="text" id="endTime" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:true,
cache:false,isClear:true,clearBlank:false"/></td>
			</tr>
			<tr>
				<td colspan="8" vAlign="top">
					<table class="dataTable" id="dataTable"></table>
				</td>
			</tr>
		</tbody>
	</table>
</body>
</html>