<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%-- <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> --%>
<%@ page %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../../common/common.jsp"%>
<title>${ctp:i18n('voucher.plugin.generate.prepage')}</title>
<style>
	td{
		text-align: left;
		padding-left:10px;
	}
	#mytable{
		border-top:1px;
		border-left:1px;
	}
	#mytable td{
		padding:8px;
		border-right:1px;
		border-bottom:1px;
	}
</style>
<script type="text/javascript" language="javascript">
$().ready(function(){
	if("${errorMsg}"!=''){
		$.alert("${errorMsg}");
		return;
	}
	if("${viewVoucher}"){
		$(".entryTr").disable();
		$("#voucherNOTr").show();
	}else{
		$("#voucherNOTr").hide();
	}
 	
 	$(".debitMoney").blur(function(){
 		var total = 0;
 		$(".debitMoney").each(function(){
 	 		if($(this).val()!=""){
 	 			total = numAdd( total , $(this).val());
 	 		}
 	 	});
 		$("#total").val(total);
 	});
 	$(".debitMoney").trigger("blur");
 	
 	$(".voucher_assis").click(function(){
 		if($(this).val()===""){
			return;
		}
 		var ass = $(this);
 		var index = ass.attr("index");
 		var accountCode = $("#accountCode_"+index).val();
   		var dialog = getA8Top().$.dialog({
   			url:"${path}/voucher/voucherController.do?method=showVoucherAssists&accountId="+$("#accountId").val()+"&assists="+encodeURIComponent(ass.val())+"&accountCode="+encodeURIComponent(accountCode)+"&bookCode="+$("#bookCode").val(),
       	    width: 400,
       	    height: 150,
       	    title: "${ctp:i18n('voucher.plugin.generate.setassist')}",
       	    buttons: [{
       	        text: "${ctp:i18n('common.button.ok.label')}", //确定
       	        handler: function () {
       	            var rv = dialog.getReturnValue();
       				if(rv!=false){
       					ass.val(rv);
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


	function numAdd(num1, num2) {
		var baseNum, baseNum1, baseNum2;
		try {
			baseNum1 = num1.toString().split(".")[1].length;
		} catch (e) {
			baseNum1 = 0;
		}
		try {
			baseNum2 = num2.toString().split(".")[1].length;
		} catch (e) {
			baseNum2 = 0;
		}
		baseNum = Math.pow(10, Math.max(baseNum1, baseNum2));
		var precision = (baseNum1 >= baseNum2) ? baseNum1 : baseNum2;//精度  
		return ((num1 * baseNum + num2 * baseNum) / baseNum).toFixed(precision);
		;
	};
	function OK(){
		if("${errorMsg}"!=''){
			return false;
		}
		var flag = true;
		$("input[name='accountCode']").each(function(){
			if($(this).val().trim()==''){
				$.alert("${ctp:i18n('voucher.plugin.generate.notnull.subject')}");
				flag = false;
				return false;
			}
		});
		if(!flag){
			return false;
		}
		$("input[name='abstract']").each(function(){
			if($(this).val().trim()==''){
				$.alert("${ctp:i18n('voucher.plugin.generate.notnull.abstract')}");
				flag = false;
				return false;
			}
		});
		if(!flag){
			return false;
		}
		var credittotal = 0;
 		$(".creditmoney").each(function(){
 	 		if($(this).val()!=""){
 	 			credittotal = numAdd( credittotal , $(this).val());
 	 		}
 	 	});
 		var amount =  numAdd($("#total").val()*(-1),Math.abs(credittotal));
 		if(amount*1!=0){
 			$.alert("${ctp:i18n('voucher.plugin.generate.notbalance.1')}"+$("#total").val()+"${ctp:i18n('voucher.plugin.generate.notbalance.2')}"+credittotal);
 			return false;
 		}
		return $("#addForm").formobj();
	}
</script>
</head>
<body>
	<form name="addForm" id="addForm" method="post" target="">
	<div class="form_area">
		<div class="one_row" style="width:90%;">
			
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="90%" colspan="8">
						<input type="hidden" id="uuid" value="${uuid}"/>
						<input type="hidden" id="summaryIdStr" value="${voucherMap.summaryIdStr}"/>
						<input type="hidden" id="bookCode" value="${voucherMap.bookCode}"/>
						<input type="hidden" id="accountId" value="${voucherMap.accountId}"/>
						<div class="common_txtbox_wrap"   style="border: 0px;" align="center">
							<span style="font-size: 30px;font-weight: bold" >${ctp:i18n('voucher.plugin.generate.accounting')}</span><br/>
							<span style="font-weight: bold">==================</span>
						</div>
					</td>
				</tr>
				<tr id="voucherNOTr">
					<td colspan="4" width="77%"></td>
					<th nowrap="nowrap"><label class="margin_r_10" for="text" style="color: black;font-weight: bold;">${ctp:i18n('voucher.plugin.generate.voucher_no')}: </label></th>
					<td width="23%">${voucherNO }</td>
				</tr>
				<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text" style="color: red;font-weight: bold;">${ctp:i18n('voucher.formmapper.accountingunit')}: </label></th>
						<td width="36%">${accountName}</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text" style="color: black;font-weight: bold;">${ctp:i18n('voucher.formmapper.localcurrency')}: </label></th>
						<td width="41%">${currencyCode}</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text" style="color: black;font-weight: bold;">${ctp:i18n('voucher.plugin.name.billdate')}: </label></th>
						<td width="23%">${billdate}</td>
					</tr>
			</table>
			
					<div  style="width: 100%;border: 0px;" align="left">				        
				        <table id="mytable" border="0" cellspacing="0" cellpadding="0" width="100%">
					        	<tr bgcolor="#B5DBEB" style="font-weight: bold;" align="center">
					        		<td width="5%">${ctp:i18n('voucher.formmapper.number')}</td>
					        		<td width="17%">${ctp:i18n('voucher.formmapper.abstract')}</td>
					        		<td width="14%">${ctp:i18n('voucher.formmapper.subject')}</td>
					        		<td width="20%">${ctp:i18n('voucher.formmapper.assist')}</td>
					        		<td width="9%">${ctp:i18n('voucher.formmapper.debitmoney')}</td>
					        		<td width="9%">${ctp:i18n('voucher.formmapper.creditmoney')}</td>
					        		<td width="12%">${ctp:i18n('voucher.formmapper.cashproject')}</td>
					        		<td width="12%">${ctp:i18n('voucher.formmapper.settlement')}</td>				        		
					        	</tr>
					        	
					        	<c:forEach	items="${voucherInfo}" var="vouchers" varStatus="status">					        		
						        	<tr align="center" class="entryTr">
						        		<td  class="common_txtbox_wrap"><span>${status.count}</span></td>
						        		<td  class="common_txtbox_wrap">
						        			<input type="hidden" id="entryId_${status.count}" value="${vouchers.entryId}"/>
											<input type="text" id="abstract_${status.count}" class="validate word_break_all" value="${vouchers.voucherAbstract}" name="abstract"
												validate="minLength:1,maxLength:255" style="border: 0px;">
										</td>
						        		<td  class="common_txtbox_wrap">
											<input type="text" id="accountCode_${status.count}" class="validate word_break_all" value="${vouchers.accountCode}" name="accountCode"
												validate="minLength:1,maxLength:255" style="border: 0px;">
										</td>
		                    			<td  class="common_txtbox_wrap">
											<input type="text" id="voucher_assis_${status.count}" index="${status.count}"  class="voucher_assis"  readonly="readonly" value="" name="${ctp:i18n('voucher.formmapper.assist')}"
											validate="minLength:1,maxLength:255" style="border: 0px;">
											<script type="text/javascript">
												var assStr = "";
			                    				<c:forEach	items="${vouchers.assists}" var="as">
			                    					assStr = assStr + "${as.asstType}"+": "+"${as.asstValue};  ";
			                    				</c:forEach>
			                    				$("#voucher_assis_${status.count}").val(assStr);
		                    			</script>
										</td>
										<c:if test="${vouchers.entryDC==1}">			
											<td  class="common_txtbox_wrap">										
												<input style="border: 0px;" type="text" id="debit_money_${status.count}" class="debitMoney"  value="${vouchers.money}" name="debit_money"	validate="minLength:1,maxLength:255">
											</td>
											<td  class="common_txtbox_wrap">
												<input style="border: 0px;" type="text" id="credit_money_${status.count}" readonly="readonly" class="creditmoney" value="" name="credit_money"	validate="minLength:1,maxLength:255">
											</td>
										</c:if>
										<c:if test="${vouchers.entryDC ==-1}">	
										  	<td  class="common_txtbox_wrap">									
												<input style="border: 0px;" type="text" id="debit_money_${status.count}" readonly="readonly" class="debitMoney"  value="" name="debit_money"	validate="minLength:1,maxLength:255">
											</td>
											<td  class="common_txtbox_wrap">
												<input style="border: 0px;" type="text" id="credit_money_${status.count}" class="creditmoney" value="${vouchers.money}" name="credit_money" validate="minLength:1,maxLength:255">
											</td>	
										</c:if>	
										<td  class="common_txtbox_wrap">									
											<input style="border: 0px;" type="text" id="cashproject_${status.count}" class="validate word_break_all" readonly="readonly"  value="${vouchers.cashproject}" name="${ctp:i18n('voucher.formmapper.cashproject')}"
												validate="minLength:1,maxLength:255">
										</td>
										<td class="common_txtbox_wrap">
											<input style="border: 0px;" type="text" id="settlement_${status.count}" class="validate word_break_all" value="${vouchers.settlement}" name="${ctp:i18n('voucher.formmapper.settlement')}"
												validate="minLength:1,maxLength:255">
										</td>									
						        </tr>
					        </c:forEach>
					         </table>					       
				        <table  border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px;">
				        	<div  style="width: 100%;border: 0px;" >
				        		<tr bgcolor="#B5DBEB" style="font-weight: bold; margin: 20px;" >
				    	   			<th nowrap="nowrap" ><label  for="text" style="color: red;font-weight: bold;height: auto;">&nbsp;&nbsp;${ctp:i18n('voucher.plugin.generate.total')}(total):</label></th>
									<td width="50%"><input style="padding-left: 5px;" type="text" id="total"  readonly="readonly" value=""  name="total"></td>
					      			<th nowrap="nowrap" align="left"><label   style="color: red;font-weight: bold;">${ctp:i18n('voucher.plugin.generate.enter')}:</label></th>
									<td width="50%">
										<input style="margin: 6px;padding-left: 5px;" type="text" id="enter"  readonly="readonly" value="${voucherCreator}"  name="enter" width="90%">
									</td>
					      		</tr>
					      </div>	
				        </table>
				    </div>
		</div>
	</div>
	</form>
</body>
</html>