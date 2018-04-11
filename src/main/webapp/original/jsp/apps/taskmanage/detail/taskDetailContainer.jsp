<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>${ctp:i18n('taskmanage.msg.show.label')}</title>
</head>
<body style="height:1000px;overflow-y:hidden;background:${bgColor} url(${path}/${bgPic})">
	<script type="text/javascript">
		$(function(){
			var taskId = '${taskId}';
			/* 校验任务是否存在+是否有权限查看+是否有树形结构 */
	        var m = new taskAjaxManager().validateViewTaskInfo(taskId);
	        var errorMsg = !m.exist ? $.i18n("taskmanage.task_deleted") : (!m.view ? $.i18n("taskmanage.alert.no_auth_view_task") : '');
	        if (errorMsg) {
	            $.messageBox({
	                'type' : 100,
	                'msg' : "<span class='msgbox_img_2 margin_r_5 left'></span>" + errorMsg,
	                close_fn : function() {
	                    callback && callback();
	                },
	                buttons : [ {
	                    id : 'btn1',
	                    text : $.i18n('common.button.ok.label'),
	                    handler : function() {
	                        callback && callback();
	                    }
	                } ]
	            });
	            return;
	        }
			var taskDetailDialog=new projectTaskDetailDialog(
	    		{
	    			'url1' : _ctxPath + "/taskmanage/taskinfo.do?method=openTaskDetailPage&taskId=" + taskId,
	                'url2' : _ctxPath + "/taskmanage/taskinfo.do?method=openTaskContentPage&taskId=" + taskId,
	                'url3' : _ctxPath + "/taskmanage/taskinfo.do?method=openTaskTreePage&taskId=" + taskId,
		    		"openB" : true,
		    		"animate" : true,
		    		"offsetRight" : getOffsetRight(),
		    		'showMask' : false,
		    		"hideBtnC" : !m.tree,
		    		"hideBtnB" : false
	    		}
	    	);
	    	$(".projectTask_detailDialog_box").css({"top":"10px"});
	    	$(".projectTask_detailDialogBtn").css({"top":"10px"});
		})
		
		function getOffsetRight(){
			var offsetRight = ($(window).width() - 920)/2;
			return offsetRight > 0 ? offsetRight : 0;
		}
	</script>
</body>
</html>