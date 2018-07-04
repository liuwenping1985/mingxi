<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

</head>
<body>

	<form name="addForm" id="addForm" method="post" target="addDeptFrame" >
	<div class="form_area" >
	
		<div class="one_row">
	
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<input type="hidden" name="id" id="memberID"  />
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('m3.bind.apply.memberNum')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="userName" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('org.post_form.type.code')}',notNull:false,minLength:1,maxLength:85,avoidChar:'-!@#$%><^&amp;*()_+'">
							</div>

						</td>
					</tr>
					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('m3.bind.clientName')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="clientName" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('org.post_form.type.code')}',notNull:false,minLength:1,maxLength:85,avoidChar:'-!@#$%><^&amp;*()_+'">
							</div>

						</td>
					</tr>
					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('m3.bind.clientType')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="clientType" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('org.post_form.type.code')}',notNull:false,minLength:1,maxLength:85,avoidChar:'-!@#$%><^&amp;*()_+'">
							</div>

						</td>
					</tr>
					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('m3.bind.apply.applyClientNum')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="clientNum" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('org.post_form.type.code')}',notNull:false,minLength:1,maxLength:85,avoidChar:'-!@#$%><^&amp;*()_+'">
							</div>

						</td>
					</tr>
					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('m3.bind.apply.applyDate')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="applyDate" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('org.post_form.type.code')}',notNull:false,minLength:1,maxLength:85,avoidChar:'-!@#$%><^&amp;*()_+'">
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