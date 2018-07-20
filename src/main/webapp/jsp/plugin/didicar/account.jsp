<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>账号管理</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=didicarManager">
</script>
<script type="text/javascript">
$().ready(function(){
	var dManager = new didicarManager();
	if("${errmsg}"!=null && "${errmsg}"!=""){
		$.alert("${errmsg}");
	}
	if("${balance}"!="" && parseFloat("${balance}")<=300){
		$("#message").show();
	}
	if("${isChild}"=="true"){
		$("#accountInfo").hide();
		$("#accountAmount").show();
		$("#btnok").hide();
		$("#btnmodify").hide();
		$("#btncancel").hide();
	}else{
		$("#accountInfo").show();
		$("#accountAmount").hide();
		if("${enterpriseKey}"!=""){
			$("table").disable();
			$("#btnok").hide();
			$("#btnmodify").show();
			$("#btncancel").hide();
		}else{
			$("table").enable();
			$("#btnok").show();
			$("#btnmodify").hide();
			$("#btncancel").hide();
		}
	}
	
	$("#btnok").click(function() {
	    if(!($("#addForm").validate())){		
	      return;
	    }
	    var tel = $("#phone").val(); //获取手机号
	    var telReg = !!tel.match(/^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/);
	    //如果手机号码不能通过验证
	    /* if(telReg == false){
	    	$.alert("${ctp:i18n('didicar.plugin.account.phone.error')}");
	    	return;
	    } */
	    if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
	    dManager.saveEnterpriseKey($("#addForm").formobj(), {
	        success: function(rel) {
				try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
				location.reload();
	        }
	    });
	});
	$("#btnmodify").click(function() {
		$("table").enable();
		$("#btnok").show();
		$("#btnmodify").hide();
		$("#btncancel").show();
	});
	$("#btncancel").click(function() {
		$("#enterpriseKey").val("${enterpriseKey}");
		$("#enterpriseSecret").val("${enterpriseSecret}");
		$("#singkey").val("${singkey}");
		$("#phone").val("${phone}");
		$("table").disable();
		$("#btnok").hide();
		$("#btnmodify").show();
		$("#btncancel").hide();
	});
});

</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_didi_${param.from}'"></div>
		<form name="addForm" id="addForm" method="post" target="">
			<div class="form_area">
				<div class="one_row"
					style="width: 60%; margin-top: 40px; padding: 0px; height: 360px; background-color: #F4F4F4;">
					<div style="float: left; width: 40%; height: 100%;">
						<img src="/seeyon/common/images/accountinfor.jpg" width="100%"
							height="100%">
					</div>
					<div
						style="width: 55%; float: right; height: 100%; margin-top: 5px;">
						<br>
						<div id="accountInfo">
							<div
								style="width: 90%; border-bottom: solid 1px #C7C7C7; padding-bottom: 5px;">
								<span style="border-bottom: solid 2px; padding-bottom: 5px;"><font
									size="4t">${ctp:i18n('didicar.plugin.account')}</font></span>
							</div>
							<table border="0" cellspacing="0" cellpadding="0"
								style="width: 90%; margin-top: 10px;">
								<tbody>
									<tr>
										<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
												color="red">*</font>${ctp:i18n('didicar.plugin.account.enterpriseKey')}:</label></th>
										<td width="90%">
											<div class="common_txtbox_wrap" style="width: 100%;">
												<input type="text" id="enterpriseKey" style="width: 100%;"
													class="validate word_break_all" name="enterpriseKey"
													validate="notNull:true,name:'${ctp:i18n('didicar.plugin.account.enterpriseKey')}',minLength:1,maxLength:255,type:'string'"
													value="${enterpriseKey}">
											</div>
										</td>
									</tr>
									<tr>
										<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
												color="red">*</font>${ctp:i18n('didicar.plugin.account.enterpriseSecret')}:</label></th>
										<td>
											<div class="common_txtbox_wrap" style="width: 100%;">
												<input type="text" id="enterpriseSecret"
													style="width: 100%;" class="validate word_break_all"
													name="enterpriseSecret"
													validate="notNull:true,name:'${ctp:i18n('didicar.plugin.account.enterpriseSecret')}',minLength:1,maxLength:255,type:'string'"
													value="${enterpriseSecret}">
											</div>
										</td>
									</tr>
									<tr>
										<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
												color="red">*</font>${ctp:i18n('didicar.plugin.account.singkey')}:</label></th>
										<td>
											<div class="common_txtbox_wrap" style="width: 100%;">
												<input type="password" id="singkey" style="width: 100%;"
													class="validate word_break_all" name="singkey"
													validate="notNull:true,name:'${ctp:i18n('didicar.plugin.account.singkey')}',minLength:1,maxLength:255,type:'string'"
													value="${singkey}">
											</div>
										</td>
									</tr>
									<tr>
										<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
												color="red">*</font>${ctp:i18n('didicar.plugin.account.phone')}:</label></th>
										<td>
											<div class="common_txtbox_wrap" style="width: 100%;">
												<input type="text" id="phone" style="width: 100%;"
													class="validate word_break_all" name="phone"
													validate="notNull:true,name:'${ctp:i18n('didicar.plugin.account.phone')}',minLength:1,maxLength:255,type:'string'"
													value="${phone}">
											</div>
										</td>
									</tr>
								</tbody>
							</table>
							<div
								style="margin-top: 40px; background-color: #F4F4F4; width: 100%;">
								<div
									style="width: 90%; border-bottom: solid 1px #C7C7C7; padding-bottom: 5px;">
									<span style="border-bottom: solid 2px; padding-bottom: 5px;"><font
										size="4t">${ctp:i18n('didicar.plugin.account.balance')}</font></span>
								</div>
								<span class="margin_r_10" id="balance" name="balance"><font
									color="#474E5E" size="7t" id="balanceFont"><strong>${balance}</strong></font></span>
								<span style="display: inline-block;"><font size="3t">${ctp:i18n('didicar.plugin.account.yuan')}</font></span>
								<div id="message" class="hidden"
									style="padding: 10px; width: 90%; border: 0px; background-color: #F4F4F4;">
									<span class="margin_r_10"><font color="#008000">${ctp:i18n('didicar.plugin.account.message.label')}</font></span>
								</div>

							</div>
						</div>
						<div id="accountAmount">
							<div style="width: 90%; border-bottom: solid 1px #C7C7C7; padding-bottom: 5px;">
								<span style="border-bottom: solid 2px; padding-bottom: 5px;"><font
									size="4t">${ctp:i18n('didicar.plugin.account.info')}</font></span>
							</div>
								<table border="0" cellspacing="0" cellpadding="0"
									style="width: 90%; margin-top: 10px;">
									<tbody>
										<tr>
											<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('didicar.plugin.account.distribution.total') }:</label></th>
											<td width="90%">
												<label style="font-size: large;font-weight: bold;" class="margin_r_10" for="text">${didicarunit.aggregateAmount}${ctp:i18n('didicar.plugin.account.yuan') }</label>
											</td>
										</tr>
										<tr>
											<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('didicar.plugin.account.distributable.money')}:</label></th>
											<td width="90%">
												<label style="font-size: large;font-weight: bold;" class="margin_r_10" for="text">${didicarunit.availableAmount}${ctp:i18n('didicar.plugin.account.yuan') }</label>
											</td>
										</tr>
									</tbody>
								</table>
								<div style="width: 90%; border-bottom: solid 1px #C7C7C7; padding-bottom: 5px;">
									<span style="border-bottom: solid 2px; padding-bottom: 5px;"><font
										size="4t">${ctp:i18n('didicar.plugin.account.distribution.detail') }</font></span>
								</div>
								<div style="overflow: auto;max-height: 200px;">
									<table border="1" cellspacing="0" cellpadding="0" 
									    border-collapse="collapse"  border-spacing="1px"
										style="width: 90%; margin-top: 10px;text-align: center;">
										<thead>
											<tr  height="25" align="center" bgcolor="#7EC0EE">
											<td>${ctp:i18n('didicar.plugin.account.distribution.time') }</td>
											<td>${ctp:i18n('didicar.plugin.account.distribution.money') }</td>
											<td>${ctp:i18n('didicar.plugin.admin') }</td>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="detail" items="${details}">
												<tr height="25"><td>${detail.createTime}</td><td>${detail.money}</td><td>${detail.creator}</td></tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
						</div>
					</div>

				</div>
			</div>
		</form>
		<div class="stadic_layout_footer stadic_footer_height" style="height: 40px;">
          <div id="button" align="center" class="page_color button_container" >
              <div class="common_checkbox_box clearfix  stadic_footer_height padding_t border_t">                           
                  <a id="btnok" style="background-color: #1483B1;color: white; height: 40px; width: 60px; padding-top: 8px;" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.ok.label')}</a>
                  <a id="btnmodify" style="background-color: #1483B1;color: white; height: 40px; width: 60px; padding-top: 8px;" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.modify.label')}</a>
                  <a id="btncancel" style="background-color: #1483B1;color: white; height: 40px; width: 60px; padding-top: 8px;" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
              </div>
          </div>
    </div>
</div>
</body>
</html>