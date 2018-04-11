<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">

</script>
<style type="text/css">
	.title{
		padding: 6pt;
	}
</style>
</head>
<body>

	<form name="addForm" id="addForm" method="post" target="addDeptFrame">
	<div class="form_area" >
		<div class="one_row" style="width:600px;">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<br>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>					
					<input type="hidden" name="id" id="id" value="" />
					<input type="hidden" name="statues" id="statues" value="" />
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('neigou.plugin.neigoucorpinfor.orgAccountName')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap" id="accountDiv">
								<input type="text" id="orgAccountId"  class="comp validate" comp="type:'selectPeople',mode:'open',panels:'Account',selectType:'Account',maxSize:'1',showMe:false,returnValueNeedType:false,isCanSelectGroupAccount:false" 
                                                validate="type:'string',notNull:true,minLength:1,maxLength:255,name:'${ctp:i18n('neigou.plugin.neigoucorpinfor.orgAccountName')}'">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('neigou.plugin.neigoucorpinfor.loginname') }:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="accountLogin" class="validate word_break_all" disabled="disabled" name="${ctp:i18n('neigou.plugin.neigoucorpinfor.loginname') }"
									validate="notNull:false,minLength:1,maxLength:50">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('neigou.plugin.neigoucorpinfor.contactName') }:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="contactName" class="validate word_break_all" name="${ctp:i18n('neigou.plugin.neigoucorpinfor.contactName') }"
									validate="notNull:true,minLength:1,maxLength:15">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="red">*</font>${ctp:i18n('neigou.plugin.neigoucorpinfor.contactPhone')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="contactPhone" class="validate word_break_all" name="${ctp:i18n('neigou.plugin.neigoucorpinfor.contactPhone')}"
									validate="notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('neigou.plugin.neigoucorpinfor.contactEmail') }:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="contactEmail" class="validate word_break_all" name="${ctp:i18n('neigou.plugin.neigoucorpinfor.contactEmail') }"
									validate="notNull:true,minLength:1,maxLength:50">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('neigou.plugin.neigoucorpinfor.worktimelimit') }:</label></th>
						<td width="45%">
							<div class="common_radio_box clearfix">
							    <label for="isControl" class="margin_r_10 hand" >
							        <input type="radio"   value="1" id="isControl" name="isControl" checked="checked"  class="radio_com isControl1">${ctp:i18n('neigou.plugin.neigoucorpinfor.isenable.on') }</label>
							    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="radio2" class="margin_r_10 hand">
							        <input type="radio" value="0" id="isControl" name="isControl" class="radio_com isControl2">${ctp:i18n('neigou.plugin.neigoucorpinfor.isenable.off') }</label>
							</div>
							
						</td>
					</tr>
					
					<tr>
						<td align="right" colspan="4"><span style="float: right;"><font color="#008000">${ctp:i18n('neigou.plugin.neigoucorpinfor.limitremark') }</font></span>
						</td>
					</tr>
				</tbody>
			</table>
			<br>
			<div  style="width: 90%;border: 0px; margin-left: 30px;" class="form_area" align="center">
							<table id="pointTable"  border="0" cellspacing="1" cellpadding="0" width="100%">
				        	<tr bgcolor="#B5DBEB">
				        		<td width="35%" class="title">${ctp:i18n('neigou.plugin.neigoucorpinfor.rechargepoint') }</td>
				        		<td width="35%" class="title" >${ctp:i18n('neigou.plugin.neigoucorpinfor.assignpoint') }</td>
				        		<td width="30%" class="title" >${ctp:i18n('neigou.plugin.neigoucorpinfor.useablepoint') }</td>
				        	</tr>
				        	<tr>
				        		<td width="35%"><div class="common_txtbox_wrap">
								<input type="text" id="rechargePoint" class=" word_break_all" disabled="disabled" value="" name="${ctp:i18n('neigou.plugin.neigoucorpinfor.rechargepoint') }">
								</div></td>
                                   <td width="35%"><div class="common_txtbox_wrap">
								<input type="text" id="grantPoint" class=" word_break_all" disabled="disabled" value="" name="${ctp:i18n('neigou.plugin.neigoucorpinfor.assignpoint') }">
								</div></td>
								<td width="30%"><div class="common_txtbox_wrap">
								<input type="text" id="companyPoint" class=" word_break_all" disabled="disabled" value="" name="${ctp:i18n('neigou.plugin.neigoucorpinfor.useablepoint') }">
								</div></td>
				        	</tr>
				        </table>
				        </div>
		</div>
		</div>
	</form>
	
	


</body>
</html>