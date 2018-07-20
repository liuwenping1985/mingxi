<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>ImportMember</title>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=accountCfgManager"></script>
<script type="text/javascript" language="javascript">
$().ready(function(){
	var cfgManager=new accountCfgManager();
    var accountBean = cfgManager.getDefaultAccountCfg();
    if(accountBean!=null){
    	$("#accountId").val(accountBean.id);
    	$("#accountName").val(accountBean.name);
    }
	$("#accountName").click(function(){
    	var dialog = getA8Top().$.dialog({
    		url:"${path}/voucher/accountCfgController.do?method=showAccountList",
			    width: 800,
			    height: 500,
			    title: "${ctp:i18n('voucher.plugin.cfg.chose2.account')}",//选择账套
			    buttons: [{
			        text: "${ctp:i18n('common.button.ok.label')}", //确定
			        handler: function () {
			           var rv = dialog.getReturnValue();
			           if(rv!=false){
			        	   $("#accountName").val(rv.accountName);
			        	   $("#accountId").val(rv.accountId);
			        	   dialog.close();
			           }
			        }
			    }, {
			        text: "${ctp:i18n('common.button.cancel.label')}", //取消
			        handler: function () {
			            dialog.close();
			        }
			    }]
    	});
    });
});
	function OK() {
		if(!($("#addForm").validate())){	
	         return false;
	    }
	    return {"accountId":$("#accountId").val()};
	}
</script>
</head>
<body>
	<form name="addForm" id="addForm" method="post">
	<div class="form_area" >
		<div class="one_row" style="width:70%;">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<br>
			<table border="0" cellspacing="0" cellpadding="0" style="margin-top: 40px;">
				<input type="hidden" id="accountId" name="accountId" value=""/>
				<tbody>					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.automatch.account')}:</label></th>
						<td width="100%">
							<div  class="common_txtbox_wrap">
								<input type="text" id="accountName" readonly="readonly" style="width:100%;" class="validate word_break_all" name="${ctp:i18n('voucher.plugin.cfg.automatch.account')}"
									validate="notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<td align="right"></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	</form>
</body>
</html>