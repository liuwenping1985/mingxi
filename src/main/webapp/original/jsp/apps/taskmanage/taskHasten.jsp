<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html class="h100b">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<style type="text/css">
        .stadic_bottom_height{height:140px; bottom:0;}
        .stadic_body_top_bottom{bottom:140px;top:0px;}
        .tt_table { border-right:solid 1px #DDDDDD;}
        .tt_table td,.tt_table th { padding:5px; font-size: 12px; border-right:solid 1px #DDDDDD; border-bottom:solid 1px #DDDDDD;}
    </style>
	<title>${ctp:i18n('taskmanage.taskhasten')}</title>
</head>
<body class="h100b over_hidden">
	<div style="overflow: hidden; border_bottom: 1px solid #e3e3e3; height: 290px;">
		<div class="font_size12 padding_l_5 margin_t_10 margin_b_10">${ctp:i18n('taskmanage.taskhasten.selectpeople')}</div>
		<div id="parentDiv" style="height:250px;overflow:hidden">
			<table id="mytable" style="display: none"></table>
		</div>
	</div>
	<div id="contentDiv" class="" style="height: 140px;">
		<div class="font_size12 margin_5">${ctp:i18n('taskmanage.taskhasten.ps')}</div>
		<div class="border_all margin_5" style="height: 75px;">
			<textarea id="contentTextarea" style="height: 75px; overflow: auto; width: 99.9%; border: 0;" class="font_size12"></textarea>
		</div>
	</div>
</body>
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript">
	var cmmiting = false;
	var taskId = window.parentDialogObj["taskHasten"].getTransParams().taskId;
	function OK(params) {
		if(cmmiting){
			return;
		}
		cmmiting = true;
		params.dialog.disabledBtn("ok");
		//保存逻辑
		var users = $("#mytable").formobj({
			gridFilter : function(data, row) {
				return $("input:checkbox", row)[0].checked;
			}
		});
		if (users.length === 0) {
			$.alert("${ctp:i18n('taskmanage.error.nomember')}");
			params.dialog.enabledBtn("ok");
			cmmiting = false;
			return false;
		}
		var userIds = [];
		for (var i = 0; i < users.length; i++) {
			userIds.push(users[i].roleId);
		}
		//大于85提示
		var content = $("#contentTextarea").val();
		if (content.length > 85) {
			$.alert('${ctp:i18n("taskmanage.error.overmax")}' + content.length);
			params.dialog.enabledBtn("ok");
			cmmiting = false;
			return false;
		}

		new taskAjaxManager().saveHasten(userIds, content, taskId, {
			success : function(data) {
				if (data.success) {
					//保存后关闭窗口
					if (params.callback) {
						params.callback();
					} else {
						params.dialog.close();
					}
				} else {
					params.dialog.enabledBtn("ok");
					cmmiting = false;
					$.alert(data.msg);
				}
			},
			error : function(jqXHR, settings, e) {
				if(jqXHR.readyState != 4 ){
					params.dialog.enabledBtn("ok");
					cmmiting = false;
					$.alert('${ctp:i18n("taskmanage.error.failed")}');
				}
			}
		});
	}
	
	$(function() {
		$("#mytable").ajaxgrid({
			colModel : [ {
				display : 'id',
				name : 'id',
				width : '12%',
				hide:false,
				align : 'center',
				type : 'checkbox'
			}, {
				display : '${ctp:i18n("taskmanage.taskhasten.name")}',
				name : 'roleName',
				width : '35%',
				align : 'left'
			}, {
				display : '${ctp:i18n("taskmanage.taskhasten.roletype")}',
				name : 'roleTypeName',
				width : '50%',
				align : 'left'
			} ],
			usepager : false,
			height : 400,
			customize : false,
			slideToggleBtn : false,
			resizable : false,
			parentId : 'parentDiv',
			managerName : "taskAjaxManager",
			managerMethod : "findTaskRoles"
		});
		$("#mytable").ajaxgridLoad({
			"taskId" : taskId
		});
	});
</script>
</html>