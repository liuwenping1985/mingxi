<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript">
	function loadH5() {
		$.ajax({
			sync : true,
			type : "POST",
			url : "/seeyon/cip/appManagerController.do?method=reloadV5Apps",
			success : function(data) {
				if (data==1) {
					alert("${ctp:i18n('m3.deployment.alert')}");
				}else{
					alert("${ctp:i18n('m3.deployment.alert1')}");
				}
			}
		});
	}
</script>
<style type="text/css">
	.hotDepl_container{
		padding: 0px 40px;
		color: #333333;
	}
	.hotDepl_title{
		font-size: 18px;
		padding: 35px 0px 10px;
		border-bottom: 1px solid #C2C2C2;
	}
	.hotDepl_content{
		min-height: 130px;
		line-height: 30px;
		font-size: 16px;
		padding: 10px 0px 0px 40px;
	}
	.hotDepl_button{
		margin-top: 10px;
		text-align: center;
		height: 36px;
		line-height: 36px;
		width: 86px;
		background: #42b3e5;
	}
</style>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="comp" comp="type:'breadcrumb',code:'m3_hotDeployment'"></div>
		<div class="hotDepl_container">
			<div class="hotDepl_title">
				${ctp:i18n('m3.deployment.checkpath')}
			</div>
			<div class="hotDepl_content">
				<p>${ctp:i18n('m3.deployment.filepath')}:${H5Path}</p>	
				<p>${ctp:i18n('m3.deployment.monitor')}:${hasDic==true?ctp:i18n('m3.deployment.state'):ctp:i18n('m3.deployment.state1') }</p>	
			</div>
			<div class="hotDepl_title">
				${ctp:i18n('m3.deployment.app')}
			</div>
			<div class="hotDepl_content">
				<p>
					<a href="javascript:void(0)" onclick="loadH5();" class="hotDepl_button common_button common_button_emphasize">${ctp:i18n('m3.deployment.button')}</a>
				</p>
			</div>			
		</div>
	</div>
</body>
</html>