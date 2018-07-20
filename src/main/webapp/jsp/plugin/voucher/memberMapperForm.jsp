<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">
	

</script>
</head>
<body>

	<form name="addForm" id="addForm" method="post" target="addDeptFrame">
	<div class="form_area" >
	
		<div class="one_row" style="width:600px;">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<br>
			<br>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>					
					<input type="hidden" name="id" id="id" value="" />
					<input type="hidden" name="erpPersonId" id="erpPersonId" value="" />
					<input type="hidden" name="accountId" id="accountId" value="" />
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountname.label')}:</label></th>
						<td width="100%" colspan="3">
							<div class="common_txtbox_wrap">
								<input type="text" id="accountName" style="width:100%;" readonly="readonly" class="validate word_break_all" name="${ctp:i18n('voucher.plugin.cfg.accountname.label')}"
									validate="notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.staffname.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap" style="width:179px;">
								<input type="text" id="orgMemberId"  name="orgMemberId" class="comp validate" comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:'1',showMe:false,returnValueNeedType:false,callback:memberCallBack"
                                                validate="type:'string',name:'${ctp:i18n('voucher.plugin.cfg.staffname.label')}',notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.erpstaffname.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap" style="width:179px;">
								<input type="text" id="erpPersonName" class="validate word_break_all" readonly="readonly" name="${ctp:i18n('voucher.plugin.cfg.erpstaffname.label')}"
									validate="notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.staffcode.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="memberCode" class="validate word_break_all" disabled="disabled" name="${ctp:i18n('voucher.plugin.cfg.staffcode.label')}"
									validate="notNull:false,minLength:1,maxLength:50">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('voucher.plugin.cfg.erpstaffcode.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="erpPersonCode" class="validate word_break_all" disabled="disabled" name="${ctp:i18n('voucher.plugin.cfg.erpstaffcode.label')}"
									validate="notNull:false,minLength:1,maxLength:50">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.dept.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="deptName" class="validate word_break_all" disabled="disabled" name="${ctp:i18n('voucher.plugin.cfg.dept.label')}"
									validate="notNull:false,minLength:1,maxLength:255">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('voucher.plugin.cfg.erpdept.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="erpDeptName" class="validate word_break_all" disabled="disabled" name="${ctp:i18n('voucher.plugin.cfg.erpdept.label')}"
									validate="notNull:false,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.unit.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="unitName" class="validate word_break_all" disabled="disabled" name="${ctp:i18n('voucher.plugin.cfg.unit.label')}"
									validate="notNull:false,minLength:1,maxLength:255">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('voucher.plugin.cfg.erpunit.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="erpUnitName" class="validate word_break_all" disabled="disabled" name="${ctp:i18n('voucher.plugin.cfg.erpunit.label')}"
									validate="notNull:false,minLength:1,maxLength:255">
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