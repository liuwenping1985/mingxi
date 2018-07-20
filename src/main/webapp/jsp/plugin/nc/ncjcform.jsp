<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
	<form name="addForm" id="addForm" method="post" target="addDeptFrame">
	<div class="form_area" >
	
		<div class="one_row">
		<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<input type="hidden" name="orgAccountId" id="orgAccountId" value="" />
				
					<input type="hidden" name="posttype" id="posttype" value="" />
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ntp.multi.code')}:</label></th>
						<td width="100%">
							<div class="common_txtbox_wrap">
								<input type="text" id="id" class="validate word_break_all"
									validate="type:'number',isInteger:true,name:'${ctp:i18n('ntp.multi.code')}',notNull:true,minValue:1,minLength:1,maxLength:4">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ntp.multi.name')}:</label></th>
						<td width="100%">
							<div class="common_txtbox_wrap">
								<input type="text" id="name" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('ntp.multi.name')}',notNull:true,minLength:1,maxLength:10,avoidChar:'\\\/|><:*?&%$|,'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>URL:</label></th>
						<td width="100%">
							<div class="common_txtbox_wrap">
								<input type="text" id="url" class="validate word_break_all"
									validate="type:'string',name:'URL',notNull:true,minLength:1,maxLength:255,avoidChar:'-!@#$%><^&amp;*()_+',regExp:/^(http|https):\/\/[a-zA-Z0-9]+[.]+[a-zA-Z0-9]+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])*$/">
							</div>

						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ntp.multi.accountcode')}:</label></th>
						<td width="100%">
							<div class="common_txtbox_wrap">
								<input type="text" id="accountCode" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('ntp.multi.accountcode')}',notNull:true,minLength:1,maxLength:20,avoidChar:'\\\/|><:*?&%$|,'">
							</div>

						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ntp.multi.sort')}:</label></th>
						<td width="100%">
							<div class="common_txtbox_wrap">
								<input type="text" id="sort" class="validate word_break_all"
									validate="type:'number',isInteger:true,name:'${ctp:i18n('ntp.multi.sort')}',notNull:true,minValue:1,minLength:1,maxLength:5">
							</div>

						</td>
					</tr>

					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('ntp.multi.enable')}:</label></th>
						<td width="100%">
							<div class="common_radio_box clearfix">
								<label class="margin_r_10 hand"> <input
									type="radio"  value="true"  id="enable" name="enable" 
									class="radio_com">${ctp:i18n('ntp.multi.able')}
								</label> <label class="margin_r_10 hand"> <input
									type="radio"  value="false" id="enable" name="enable" 
									class="radio_com">${ctp:i18n('ntp.multi.disable')}
								</label>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('ntp.multi.description')}:</label></th>
						<td width="100%">
							<div class="common_txtbox  clearfix">
								<textarea rows="5" class="w100b validate word_break_all" id="description" validate="type:'string',name:'${ctp:i18n('ntp.multi.description')}',notNull:false,maxLength:1000"></textarea>
							</div>
						</td>
					</tr>  
						<input type="hidden" id="codeflg">
				</tbody>
			</table>
		</div>
		</div>
	</form>


</body>
</html>