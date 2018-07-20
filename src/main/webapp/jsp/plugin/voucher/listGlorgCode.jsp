<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>BillTempForm</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=baseVoucherManager"></script>
<script type="text/javascript" language="javascript">
$().ready(function(){
	if("${accountConfig}"!=null){
		$("#accountId").val("${accountConfig.id}");
		$("#accountName").val("${accountConfig.name}");
		if("${accountConfig.isSupportBooks}"=="true" && "${accountConfig.type}"!="EAS"){
 		    $("#book_tr").show();
 		    $("#bookCode").val("${accountConfig.bookCode}");
   	   	    $("#bookName").val("${accountConfig.bookName}"); 
 	   }
		if($("#accountId").val()!=""){
			var vManager = new baseVoucherManager();
		 	var isSupportGroup = vManager.isSupportGroup($("#accountId").val());
		 	if(isSupportGroup==true){
		 		$("#group_tr").show();
		 	}
		}
	}
	var date=new Date(); 
    var billdate=date.print("%Y-%m-%d"); 
    $("#billdate").val(billdate);//默认显示当前时间 
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
			        	   var oldAccountId = $("#accountId").val();
			        	   $("#accountId").val(rv.accountId);
			        	   var vManager = new baseVoucherManager();
			        	   var isSupportGroup = vManager.isSupportGroup(rv.accountId);
			        	   if(isSupportGroup==true){
			        		   $("#group_tr").show();
			        		   if(oldAccountId!=rv.accountId){
			        			   $("#groupName").val("");
				        		   $("#groupCode").val("");
				        		   $("#pk_group").val("");
			        		   }
			        	   }else{
			        		   $("#group_tr").hide();
			        		   $("#groupName").val("");
			        		   $("#groupCode").val("");
			        		   $("#pk_group").val("");
			        	   }
			        	   if(rv.isSupportBooks==true && rv.type!="EAS"){
			        		   $("#book_tr").show();
				        	   $("#addForm").fillform(rv);
			        	   }else{
			        		   $("#book_tr").hide();
				        	   $("#bookCode").val("");
				        	   $("#bookName").val(""); 
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
	$("#bookName").click(function() {
		if($.trim($("#accountId").val())===""){
			return;
		}
   		var dialog = getA8Top().$.dialog({
   			url:"${path}/voucher/voucherController.do?method=selectErpBook&accountId="+$("#accountId").val(),
       	    width: 800,
       	    height: 450,
       	    title: "${ctp:i18n('voucher.plugin.cfg.accountCfg.book.selectBook')}",
       	    buttons: [{
       	        text: "${ctp:i18n('common.button.ok.label')}", //确定
       	        handler: function () {
       	            var rv = dialog.getReturnValue();
       				if(rv!=false){
       	           	    $("#bookName").val(rv.name);
       	           	    $("#bookCode").val(rv.code);
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
	$("#groupName").click(function() {
		if($.trim($("#accountId").val())===""){
			return;
		}
   		var dialog = getA8Top().$.dialog({
   			url:"${path}/voucher/voucherController.do?method=selectErpGroup&accountId="+$("#accountId").val(),
       	    width: 800,
       	    height: 450,
       	    title: "${ctp:i18n('voucher.plugin.group.select')}",
       	    buttons: [{
       	        text: "${ctp:i18n('common.button.ok.label')}", //确定
       	        handler: function () {
       	            var rv = dialog.getReturnValue();
       				if(rv!=false){
       					$("#addForm").fillform(rv);
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
	    return {"accountId":$("#accountId").val(),"bookCode":$("#bookCode").val(),"billdate":$("#billdate").val(),"groupCode":$("#groupCode").val()};
	}
</script>
</head>
<body>
	<form name="addForm" id="addForm" method="post" target="addDeptFrame">
	<div class="form_area" >
		<div class="one_row" style="width:70%;">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<br>
			<br>
			<table border="0" cellspacing="0" cellpadding="0" style="margin-top: 40px;">
				<input type="hidden" id="accountId" name="accountId" value=""/>
				<input type="hidden" id="bookCode" name="bookCode" value=""/>
				<input type="hidden" id="groupCode" name="groupCode" value=""/>
				<input type="hidden" id="pk_group" name="pk_group" value=""/>
				<tbody>					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountname.label')}:</label></th>
						<td width="100%">
							<div style="width:100%;">
								<input type="text" id="accountName" readonly="readonly" style="width:100%;" class="validate word_break_all" name="${ctp:i18n('voucher.plugin.cfg.accountname.label')}"
									validate="notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr id="book_tr" style="display: none;">
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountCfg.book.name')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="bookName" readonly="readonly"  name="bookName" class="validate word_break_all" name="bookName"
									validate="notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr id="group_tr" style="display: none;">
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.group.name')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="groupName" readonly="readonly"  name="groupName" class="validate word_break_all" name="groupName"
									validate="notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.name.billdate')}</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input id="billdate" type="text" class="comp validate" readonly="readonly" comp="type:'calendar',ifFormat:'%Y-%m-%d'" validate="notNull:true,minLength:1,maxLength:255,name:'${ctp:i18n('voucher.plugin.name.billdate')}'">
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