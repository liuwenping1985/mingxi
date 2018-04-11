<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>ImportDept</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=baseVoucherManager,accountCfgManager"></script>
<script type="text/javascript" language="javascript">
$().ready(function(){
	var cfgManager=new accountCfgManager();
	var baseManager = new baseVoucherManager();
    var accountBean = cfgManager.getDefaultAccountCfg();
    if(accountBean!=null){
    	$("#accountId").val(accountBean.id);
    	$("#accountName").val(accountBean.name);
    	checkIsSupportUnit(accountBean.id);
    }
	if("${ctp:getSysFlag('sys_isGroupVer')}"=="true"){
		$("#orgAccountTr").show();
	}
	$("#accountName").click(function(){
    	var dialog = getA8Top().$.dialog({
    		url:"${path}/voucher/accountCfgController.do?method=showAccountList",
		    width: 800,
		    height: 500,
		    title: "${ctp:i18n('voucher.plugin.cfg.chose2.account')}",//选择账套
		    buttons: [{
		    	isEmphasize:true,
		        text: "${ctp:i18n('common.button.ok.label')}", //确定
		        handler: function () {
		           var rv = dialog.getReturnValue();
		           if(rv!=false){
		        	   $("#accountName").val(rv.accountName);
		        	   var oldAccountId = $("#accountId").val();
		        	   $("#accountId").val(rv.accountId);
		        	   checkIsSupportUnit(rv.accountId);
		        	   if(oldAccountId!=rv.accountId){
		        		   $("#erpUnitName").val("");
			        	   $("#erpUnitId").val("");
		        	   }
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
	
	$("#erpUnitName").click(function(){
		if($("#accountId").val()==""){
			$.alert("${ctp:i18n('voucher.plugin.cfg.chose.account')}");
			return;
		}
    	var dialog = getA8Top().$.dialog({
    		url:"${path}/voucher/deptMapperController.do?method=showErpUnitTree&accountId="+encodeURIComponent($("#accountId").val()),
		    width: 400,
		    height: 450,
		    title: "${ctp:i18n('voucher.plugin.cfg.automatch.erpunit.select')}",//选择财务系统单位
		    buttons: [{
		        text: "${ctp:i18n('common.button.ok.label')}", //确定
		        handler: function () {
		           var rv = dialog.getReturnValue();
		           if(rv!=false){
		        	   $("#erpUnitId").val(rv.unitId);
		        	   $("#erpUnitName").val(rv.erpUnit);
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
	function checkIsSupportUnit(accountId){
		var flag = baseManager.isSupportMultiUnit(accountId);
		if(flag==false){
			$("#erpUnitTr").hide();
		}else{
			$("#erpUnitTr").show();
		}
	}
});
	function OK() {
		if(!($("#addForm").validate())){	
	         return false;
	    }
	    return {"accountId":$("#accountId").val(),"erpUnitId":$("#erpUnitId").val(),"orgAccountId":$("#orgAccountId").val()};
	}
</script>
</head>
<body>
	<form name="addForm" id="addForm" method="post">
	<div class="form_area" >
		<div class="one_row" style="width:80%;">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<br>
			<br>
			<table border="0" cellspacing="0" cellpadding="0" style="margin-top: 10px;">
				<input type="hidden" id="accountId" name="accountId" value=""/>
				<input type="hidden" id="erpUnitId" name="erpUnitId" value=""/>
				<tbody>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.automatch.account')}:</label></th>
						<td width="100%">
							<div class="common_txtbox_wrap">
								<input type="text" id="accountName" readonly="readonly" style="width:100%;" class="validate word_break_all" name="${ctp:i18n('voucher.plugin.cfg.automatch.account')}"
									validate="notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr class="hidden" id="orgAccountTr">
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.automatch.oaunit')}:</label></th>
						<td width="100%">
							<div class="common_txtbox_wrap">
								<input type="text" style="width:100%;" id="orgAccountId"  name="orgAccountId" class="comp validate" comp="type:'selectPeople',mode:'open',panels:'Account',selectType:'Account',maxSize:'1',showMe:false,returnValueNeedType:false"
                                                validate="type:'string',name:'${ctp:i18n("voucher.plugin.cfg.automatch.oaunit")}',notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr id="erpUnitTr">
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.automatch.erpunit')}:</label></th>
						<td width="100%">
							<div class="common_txtbox_wrap">
								<input type="text" id="erpUnitName" readonly="readonly" style="width:100%;" class="validate" name="${ctp:i18n('voucher.plugin.cfg.automatch.erpunit')}"
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