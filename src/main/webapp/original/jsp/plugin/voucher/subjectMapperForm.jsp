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
	
		<div class="one_row" style="width:50%;">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<table border="0" cellspacing="0" cellpadding="0">
			<tr >
				<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.subject.a8fexType')}:</label></th>
				<td width="100%" colspan="4">
					<div style="width:100%;">
						<input type="text" id="enumName" style="width:100%;" readonly="readonly" class="validate word_break_all" name="enumName"
						validate="notNull:true,name:'${ctp:i18n('voucher.plugin.cfg.subject.a8fexType')}',minLength:1,maxLength:255">
					</div>
				</td>
			</tr>
			<tr >
				<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.subject.enumPath')}:</label></th>
				<td width="100%" colspan="4">
					<div style="width:100%;">
						<input type="text" id="enumPath" style="width:100%;" disabled="disabled" class="validate word_break_all" name="enumPath">
					</div>
				</td>
			</tr>
			</table>
			<fieldset id="erpsubject" style="border:1px groove; width:98%;">
			<legend>${ctp:i18n('voucher.plugin.cfg.subject')}</legend>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<input type="hidden" name="id" id="id" value=""/>					
					<input type="hidden" name="accountId" id="accountId" value=""/>
					<input type="hidden" name="enumId" id="enumId" value=""/>
					<input type="hidden" name="subjectId" id="subjectId" value=""/>
					<input type="hidden" name="direction" id="direction" value=""/>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.subject.account')}:</label></th>
						<td width="100%" colspan="3">
							<div style="width:100%;">
								<input type="text" id="accountName" style="width:100%;"  readonly="readonly" class="validate word_break_all" name="accountName"
									validate="notNull:true,name:'${ctp:i18n('voucher.plugin.cfg.subject.account')}',minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr class="book" style="display:none;">
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.subject.book')}:</label></th>
						<td width="100%" colspan="3">
							<div class="common_txtbox_wrap">
								<input type="text" id="bookName"  name="bookName"  readonly="readonly" style="width:100%;" class="validate word_break_all"
                                                validate="type:'string',name:'${ctp:i18n('voucher.plugin.cfg.subject.book')}',notNull:true,minLength:1,maxLength:50">
							</div>
						</td>
					</tr>
					<tr class="book" style="display:none;">
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.subject.bookcode')}:</label></th>
						<td width="400px" >
							<div class="common_txtbox_wrap">
								<input type="text" id="bookCode" class="validate word_break_all" name="bookCode" disabled="disabled"
									validate="notNull:true,name:'${ctp:i18n('voucher.plugin.cfg.subject.bookcode')}',minLength:1,maxLength:255">
							</div>
						</td>					
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;${ctp:i18n('voucher.plugin.cfg.subject.bookorg')}:</label></th>
						<td width="400px">
							<div class="common_txtbox_wrap">
								<input type="text" id="erpUnitName" class="validate word_break_all" disabled="disabled" name="erpUnitName"
									validate="notNull:false,minLength:1,maxLength:50">
							</div>
						</td>
					</tr>
					<tr>	
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.subject.subname')}:</label></th>
						<td width="100%" colspan="3">
							<div class="common_txtbox_wrap">
								<input type="text" id="subjectName"  readonly="readonly" style="width:100%;"class="validate word_break_all" name="subjectName"
									validate="notNull:true,name:'${ctp:i18n('voucher.plugin.cfg.subject.subname')}',minLength:1,maxLength:50">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.subject.subcode')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="subjectCode" class="validate word_break_all" disabled="disabled" name="subjectCode"
									validate="notNull:false,minLength:1,maxLength:255">
							</div>
						</td>
						
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.subject.debit')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="directions" class="validate word_break_all" disabled="disabled" name="directions"
									validate="notNull:false,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>					
					
				</tbody>
			</table>
			</fieldset>
		</div>
		</div>
	</form>


</body>
</html>