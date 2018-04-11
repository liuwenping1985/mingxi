<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${path}/apps_res/weixin/css/common.css"/>
<style>
	div.error-form{
		width: 380px !important;
	}
</style>
</head>
<body class="h100b over_hidden">
	<form id="myform" name="myform" method="post">
	<input type="hidden" id="id" name="id" value="${id}">
	<div class="crumbly">
	    <div class="before">${ctp:i18n('weixin.system.menu.basicSettings')}</div><span class="gap">/</span><span class="current">${ctp:i18n('weixin.system.menu.wechatConnectionSettings')}</span>
	</div>
	<div class="set">
		<div class="setContent" style="font-size: 14px;color: #000;">
			<span>${ctp:i18n("weixin.workbench.setinfo")}：</span>
		</div>
		<div class="setContent" style="margin-top: 17px;">
			<span>${ctp:i18n("weixin.system.connection.restdesc")}</span>
		</div>
        <div class="setContent" style="margin-top: 5px;">
            <span>${ctp:i18n('weixin.system.connection.restaccountdesc')}</span>
        </div>
		<div class="setContent" style="margin-top: 5px;">
			<span>${ctp:i18n('weixin.system.connection.restpassworddesc')}</span>
		</div>
	</div>
	<div id="wechatLinkSet" class="form_area">
	    <div class="block">
	        <div class="name">
	            <span style="color: #d0021b;">*</span><span>${ctp:i18n("weixin.system.connection.restaccount")}:</span>
	        </div>
			<div class="detail">
				<div class="tInput">
					<div>
						<input type="text" id="loginName" class="validate" value="${loginName}" validate="type:'string',name:'${ctp:i18n('usersystem.restUser.loginName')}',notNull:true,maxLength:50,avoidChar:'!@#$%^&amp;*+|,'"/>
					</div>
				</div>
			</div>
	        <div style="clear: both;"></div>
	    </div>
	    <div class="block">
	        <div class="name">
	            <span style="color: #d0021b;">*</span><span>${ctp:i18n('weixin.system.connection.restpassword')}:</span>
	        </div>
			<div class="detail">
				<div class="tInput">
					<div>
						<input type="password" id="passWord" name="passWord" class="validate" validate="type:'string',name:'${ctp:i18n('usersystem.restUser.passWord')}',notNull:true,minLength:6,maxLength:50"/>
					</div>
				</div>
			</div>
	        <div style="clear: both;"></div>
	    </div>
	    <div class="block">
	        <div class="name">
	            <span style="color: #d0021b;">*</span><span>${ctp:i18n('usersystem.newpassword.validate')}:</span>
	        </div>
	        <div class="tInput">
				<div>
					<input type="password" id="passWord2" name="passWord2" class="validate" validate="type:'string',name:'${ctp:i18n('usersystem.newpassword.validate')}',notNull:true,minLength:6,maxLength:50"/>
				</div>
	        </div>
	        <div style="clear: both;"></div>
	    </div>
	    
	    <div class="block"> 
	        <div class="submit">
	            <span>${ctp:i18n('weixin.system.connection.lable3')}</span>
	        </div>
	        <div class="cancel">
	            <span>${ctp:i18n('weixin.system.connection.lable4')}</span>
	        </div>
	        <div style="clear: both;"></div>
	    </div>
	</div>
	</form>
</body>
<script type="text/javascript">
    
	$().ready(function() {
		//初始化页面为浏览状态
		$("#passWord").val("~`@%^*#?");
		$("#passWord2").val("~`@%^*#?");
		$("#loginName").attr("disabled", "disabled");
		$("#passWord").attr("disabled", "disabled");
		$("#passWord2").attr("disabled", "disabled");

		//修改用户登录信息清空密码
		$("#loginName").click(function() {
			if ($("#passWord").val() != "" && $("#passWord2").val() != "") {
				$.confirm({
					'msg' : '${ctp:i18n("usersystem.restUser.info.login")}',
					ok_fn : function() {
						$("#passWord").val("");
						$("#passWord2").val("");
						$("#loginName").focus();
					},
					cancel_fn : function() {
						$("#loginName").blur();
					}
				});
			} else {
				$("#loginName").focus(); //将焦点设置给登录名
			}
		});

		$(".cancel").bind("click", function() {
			$("#loginName").removeAttr("disabled", "");
			$("#passWord").removeAttr("disabled", "");
			$("#passWord").val("");
			$("#passWord2").removeAttr("disabled", "");
			$("#passWord2").val("");
			//添加绑定事件
			$(".submit").bind("click", function() {
				OK();
			})
		});
	})

	function OK() {
		//登录名称不能含有中文名称
		var loginName = $("#loginName").val();
		if (/[\u4E00-\u9FA5]/i.test(loginName)) {
			ctpAlert("${ctp:i18n('weixin.system.connection.alert1')}", 1);
			return;
		}
		if ($("#passWord").val() != $("#passWord2").val()) {
			$.alert("${ctp:i18n('usersystem.newpassword.again.not.consistent')}");
			return;
		}
		var formobj = $("#myform").formobj();
		var valid = $._isInValid(formobj);
		$(".error-form").width(212);
		if (valid) {
			return;
		}
		$("#loginName").attr("disabled", "disabled");
		$("#passWord").attr("disabled", "disabled");
		$("#passWord2").attr("disabled", "disabled");

		submitForm(formobj);
	}

	function submitForm(formobj) {
		var ajax_saveWeChatConfig = new weixinSetManager();
		var data = {};
		data.loginName = formobj.loginName;
		data.passWord = formobj.passWord;
		data.id = formobj.id
		ajax_saveWeChatConfig.saveWeChatConfig(data, {
			success : function(result) {
				var type = 1;
				if (result.success) {
					type = 0;
				} 
				ctpAlert(result.msg, type);
			}
		});
		$(".submit").unbind();
	}
	
	function ctpAlert(msg, type) {
		$.messageBox({
			'type' : 100,
			'imgType' : type,
			'msg' : msg,
			buttons : [ {
				id : 'btn1',
				text : "${ctp:i18n('common.button.ok.label')}",
				handler : function() {
				}
			} ]
		});
	}
</script>
</html>