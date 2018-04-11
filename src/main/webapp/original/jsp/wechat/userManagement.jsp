<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${path}/apps_res/weixin/css/common.css" />
</head>
<body class="h100b over_hidden">
	<div class="crumbly">
		<span class="current">${ctp:i18n('weixin.system.menu.userManagement')}</span>
	</div>
	<div class="address">
		<div class="name">
			<span>${ctp:i18n('weixin.system.userManagement.lable1')}：</span>
		</div>
		<div class="detail">
			<div>
				<input type="hidden" id="userIds">
				<textarea rows="5" cols="50" id="users" readonly="readonly"></textarea>
			</div>
			<div>
				<span>${ctp:i18n('weixin.system.userManagement.lable2')}</span>
			</div>
		</div>
	</div>
	<div class="bbtn">
		<div class="submit-btn">${ctp:i18n('common.button.ok.label')}</div>
		<div class="cancel-btn">${ctp:i18n('common.button.cancel.label')}</div>
	</div>
</body>
<script type="text/javascript">
	$().ready(function() {
		$("#users").bind("click", function() {
			selectPerson();
		});
		$(".submit-btn").bind("click", function() {
			deleteMember();
		});
		$(".cancel-btn").bind("click", function() {
			location.reload();
		});
	})

	function selectPerson() {
		$.selectPeople({
			type : 'selectPeople',
			panels : 'Department,Outworker',
			selectType : 'Member',
			maxSize : 1000,
			params : {
				text : $("#users").val(),
				value : $("#userIds").val()
			},
			callback : function(ret) {
				$("#users").val(ret.text);
				$("#userIds").val(ret.value);
			}
		});
	}
	//删除人员
	function deleteMember() {
		var userIds = $("#userIds").val();
		if (userIds == "" || userIds == null) {
			ctpAlert("${ctp:i18n('weixin.system.userManagement.alert')}", 1);
			return;
		}

		var ajax_weixinSetManager = new weixinSetManager();
		ajax_weixinSetManager.deleteMembers(userIds, "", "", {
			success : function(result) {
				ctpAlert(result.msg, result.type);
			}
		});
	}

	//type:0,成功;1,失败
	function ctpAlert(msg, type) {
		$.messageBox({
			'type' : 100,
			'imgType' : type,
			'msg' : msg,
			cancel_fn : function() {
				if (type == 0) {
					location.reload();
				}
			},
			buttons : [ {
				id : 'btn1',
				text : "${ctp:i18n('common.button.ok.label')}",
				handler : function() {
					if (type == 0) {
						location.reload();
					}
				}
			} ]
		});
	}
</script>
</html>