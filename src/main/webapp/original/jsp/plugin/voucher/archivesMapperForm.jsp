<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">
	$().ready(function() {	
	var archivesMapper=new archivesMapperManager();
	
	$("#name").blur(function (){
    if(archivesMapper.checkName($("#name").val(),$("#id").val())){
		$.alert("${ctp:i18n('voucher.plugin.cfg.archivesMapper.double.name')}");
        $("#name").attr("value","");
		$("#name").focus();
   }});
	});
</script>
</head>
<body>

	<form name="addForm" id="addForm" method="post" target="addDeptFrame">
	<div class="form_area">	
		<div class="one_row" style="width: 40%">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<br>
			<br>
			<table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
				<tbody>					
					<input type="hidden" name="id" id="id" value="" />
					<tr>
						
						<th nowrap="nowrap" width="5%"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.archivesMapper.name')}:</label></th>
						<td colspan="3">
							<div class="common_txtbox_wrap" >
								<input type="text" id="name" class="validate word_break_all"  value="" name="${ctp:i18n('voucher.plugin.cfg.archivesMapper.name')}"
									validate="notNull:true,minLength:1,maxLength:80"   >
							</div>
						</td>
					
					</tr>
					<tr>
					<th nowrap="nowrap" width="5%"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.archivesMapper.code')}:</label></th>
						<td  colspan="3">
							<div class="common_txtbox_wrap" >
								<input type="text" id="code" class="validate word_break_all" name="${ctp:i18n('voucher.plugin.cfg.archivesMapper.code')}"
								validate="notNull:false,minLength:1,maxLength:15">
							</div>
						</td>
					
					</tr>
					<tr>
						
						<th nowrap="nowrap" width="5%"><label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('voucher.plugin.cfg.archivesMapper.formName')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap" style="width: 195px">
								<input type="text" id="formName" class="validate word_break_all" name="${ctp:i18n('voucher.plugin.cfg.archivesMapper.formName')}"
									validate="notNull:false,minLength:1,maxLength:80">
							</div>
						</td>
						
						<th nowrap="nowrap" width="5%"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.archivesMapper.tableName')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap" style="width: 195px">
								<input type="text" id="tableName" class="validate word_break_all" name="${ctp:i18n('voucher.plugin.cfg.archivesMapper.tableName')}"
									validate="notNull:true,minLength:1,maxLength:80">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap" width="5%"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.archivesMapper.accountField')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap" style="width: 195px">
								<input type="text" id="accountField" class="validate word_break_all" name="${ctp:i18n('voucher.plugin.cfg.archivesMapper.accountField')}"
									validate="notNull:true,minLength:1,maxLength:80">
							</div>
						</td>
						<th nowrap="nowrap" width="5%"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.archivesMapper.bookField')}:</label></th>
					   <td width="45%">
							<div class="common_txtbox_wrap" style="width: 195px">
								<input type="text" id="bookField" class="validate word_break_all" name="${ctp:i18n('voucher.plugin.cfg.archivesMapper.bookField')}"
								validate="notNull:false,minLength:1,maxLength:80"	>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap" width="5%"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.archivesMapper.dataItemMapped')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap" style="width: 195px">
								<input type="text" id="dataItemMapped" class="validate word_break_all" name="${ctp:i18n('voucher.plugin.cfg.archivesMapper.dataItemMapped')}"
									validate="notNull:true,minLength:1,maxLength:80">
							</div>
						</td>
						<th nowrap="nowrap" width="5%"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.archivesMapper.dataItemTarget')}:</label></th>
						<td width="45%" id="append">
							
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		</div>
	</form>


</body>
</html>