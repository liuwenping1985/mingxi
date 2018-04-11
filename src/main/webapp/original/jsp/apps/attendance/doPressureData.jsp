<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
     <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body class="h100b over_hidden">
	<div>${ctp:i18n("attendance.label.progress")}</div>
	<div id="process"></div>
</body>
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript">
	$(function(){
		setInterval(runBigData,2000);
	});
	var process;
	function runBigData(){
		var ajax = new attendanceManager();
		ajax.doRunBigData({
			success:function(result){
				if(process == undefined){
					process = $("#process");
				}
				process.html(result);
			}
		});
	}
</script>
</html>

