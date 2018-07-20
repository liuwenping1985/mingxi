<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript"
	src="${path}/ajax.do?managerName=userMapperManager"></script>
<%@ include file="../../common/common.jsp"%>
<script type="text/javascript">
$().ready(function(){
	var vManager = new userMapperManager();
	var userMapper = vManager.viewUserMapper();
	if(userMapper!=null){
		$("#userPwd").val(userMapper.userPwd);
	}
	$("#addForm").fillform(userMapper);
	$("#btnok").click(function() {
	    if(!($("#addForm").validate())){
	      return;
	    }
	    if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
	    vManager.saveUserMapper($("#addForm").formobj(), {
	        success: function(rel) {
				try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
				location.reload();
	        }
	    });
	});
	$("#btncancel").click(function() {
		if(userMapper!=null){
			$("#userPwd").val(userMapper.userPwd);
		}
		$("#addForm").fillform(userMapper);
	});
});
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_10104_userMapper'"></div>
	<form name="addForm" id="addForm" method="post" target="">
	<div class="form_area" >
	
		<div class="one_row" style="width:25%; margin-top: 100px;">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<table border="0" cellspacing="0" cellpadding="0">
				<tr >
					<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.usermapper.account') }:</label></th>
					<td width="100%">
						<div style="width:100%;" class="common_txtbox_wrap">
							<input type="text" id="userCode" style="width:100%;" class="validate word_break_all" name="usercode"
							validate="notNull:true,name:'${ctp:i18n('voucher.plugin.usermapper.account') }',minLength:1,maxLength:255">
						</div>
					</td>
				</tr>
				<tr>
					<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.usermapper.username') }:</label></th>
					<td width="100%">
						<div style="width:100%;" class="common_txtbox_wrap">
							<input type="text" id="userName" style="width:100%;" class="validate word_break_all" name="username"
							validate="notNull:true,name:'${ctp:i18n('voucher.plugin.usermapper.username') }',minLength:1,maxLength:255">
						</div>
					</td>
				</tr>
				<tr>
					<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.usermapper.userpwd') }:</label></th>
					<td width="100%">
						<div style="width:100%;" class="common_txtbox_wrap">
							<input type="password" id="userPwd" style="width:100%;" class="validate word_break_all" name="userPwd"
							validate="notNull:false,name:'${ctp:i18n('voucher.plugin.usermapper.userpwd') }',minLength:1,maxLength:255">
						</div>
					</td>
				</tr>
			</table>
		</div>
		</div>
	</form>
	
	<div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">                           
                            <a id="btnok" href="javascript:void(0)" class="common_button common_button_gray margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
                            <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                        </div>
                    </div>
    </div>
</div>
</body>
</html>