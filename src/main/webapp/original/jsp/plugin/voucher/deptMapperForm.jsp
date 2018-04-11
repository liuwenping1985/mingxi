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
					<input type="hidden" name="accountId" id="accountId" value="" />
					<input type="hidden" name="erpDeptId" id="erpDeptId" value=""/>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountCfg.name')}:</label></th>
						<td width="100%" colspan="3">
							<div class="common_txtbox_wrap">
								<input type="text" id="accountName" style="width:100%;" readonly="readonly" class="validate word_break_all" name="accountName"
									validate="notNull:true,name:'${ctp:i18n('voucher.plugin.cfg.accountCfg.name')}',minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.deptmapper.oadeptName')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap" style="width:177.5px;">
								<input type="text" id="orgDepartmentId"  name="orgDepartmentId" class="comp validate" readonly="readonly" comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Department',maxSize:'1',showMe:false,returnValueNeedType:false,callback:deptCallBack"
                                                validate="type:'string',name:'${ctp:i18n('voucher.plugin.cfg.deptmapper.oadeptName')}',notNull:true,minLength:1,maxLength:85">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.deptmapper.erpdeptname')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap" style="width:177.5px;">
								<input type="text" id="erpDeptName" class="validate word_break_all" readonly="readonly" name="erpDeptName"
									validate="notNull:true,name:'${ctp:i18n('voucher.plugin.cfg.deptmapper.erpdeptname')}',minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.deptmapper.oadeptCode')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="orgDepartmentCode" class="validate word_break_all" disabled="disabled" name="orgDepartmentCode"
									validate="notNull:false,minLength:1,maxLength:50">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('voucher.plugin.cfg.deptmapper.erpdeptcode')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="erpDeptCode" class="validate word_break_all" disabled="disabled" name="erpDeptCode"
									validate="notNull:false,minLength:1,maxLength:50">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.deptmapper.oadocname')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="unitName" class="validate word_break_all" disabled="disabled" name="unitName"
									validate="notNull:false,name:'${ctp:i18n('voucher.plugin.cfg.deptmapper.oadocname')}',minLength:1,maxLength:255">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('voucher.plugin.cfg.deptmapper.erpdocname')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="erpUnitName" class="validate word_break_all" disabled="disabled" name="erpUnitName"
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