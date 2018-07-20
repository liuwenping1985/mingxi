<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>${ctp:i18n('taskmanage.msg.show.label')}</title>
</head>
<body style="height:1000px;overflow-y:hidden;background:${bgColor} url(${path}/${bgPic})">
	<script type="text/javascript">
		$(function(){
			var detailUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskDetailPage&category=${category}&from=${from}&drillDown=${drillDown}&taskId=${taskId}";
			var contentUrl=_ctxPath+"/taskmanage/taskinfo.do?method=openTaskContentPage&from=${from}&drillDown=${drillDown}&taskId=${taskId}";
			var taskDetailDialog=new projectTaskDetailDialog(
	    		{
		    		'url1':detailUrl,
		    		'url2':contentUrl,
		    		'url3':'',
		    		"openB":true,
		    		"animate":true,
		    		"offsetRight":getOffsetRight(),
		    		'showMask': false,
		    		"hideBtnC":true,
		    		"hideBtnB":true
	    		}
	    	);
	    	$(".projectTask_detailDialog_box").css({"top":"10px"});
		})
		
		function getOffsetRight(){
			var clientWidth=$(window).width();
			var offsetRight=(clientWidth-820)/2;
			return offsetRight>0?offsetRight:0;
		}
	</script>
</body>
</html>