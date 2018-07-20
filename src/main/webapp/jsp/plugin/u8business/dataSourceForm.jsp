<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

</head>
<body>

	<form name="addForm" id="addForm" method="post" target="addDeptFrame">
	<div class="form_area">
		<div class="one_row">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<input type="hidden" name="id" id="id" value="" />		
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('u8business.datasource.accountcode')}:</label></th>
						<td width="100%" colspan="2">
							<div class="common_txtbox_wrap">
								<input type="text" id="accountCode" class="validate word_break_all" name="accountCode"
									validate="type:'string',name:'${ctp:i18n('u8business.datasource.accountcode')}',notNull:true,minLength:1,maxLength:10,avoidChar:'-!@#$%><^&amp;*()_+',regExp:/^[0-9]\d{2}$/">	
							</div>
						</td>
					</tr>
					<tr>
                		<th nowrap="nowrap">&nbsp;</th>
                		<td width="100%" colspan="2" valign="top">
                    		<font color="green">${ctp:i18n('u8business.datasource.accountcodedesc')}</font>
                		</td>
            		</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('u8business.datasource.dbtype')}:</label></th>						
							<td width="30%">
							<select id="db" name="db" class="w100b" readonly="readonly">
								<option value=1>SQLServer</option>
							</select>
							</td>
							<td width="100%">
							<div class="common_txtbox_wrap">
								<input type="text" id="dbType" readonly="readonly" class="validate word_break_all" name="dbType" value="jdbc:jtds:sqlserver://[ip]:1433/[datebase]">	
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('u8business.datasource.url')}:</label></th>
						<td width="100%" colspan="2">
							<div class="common_txtbox_wrap">
								<input type="text" id="dbUrl" class="validate word_break_all" name="dbUrl"
									validate="type:'string',name:'${ctp:i18n('u8business.datasource.url')}',notNull:true,minLength:1,maxLength:160">	
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('u8business.datasource.user')}:</label></th>
						<td width="100%" colspan="2">
							<div class="common_txtbox_wrap">
								<input type="text" id="dbUser" class="validate word_break_all" name="dbUser"
									validate="notNull:true,name:'${ctp:i18n('u8business.datasource.user')}',minLength:1,maxLength:85">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('u8business.datasource.pwd')}:</label></th>
						<td width="100%" colspan="2">
							<div class="common_txtbox_wrap">
								<input type="password" id="dbPassword" class="validate word_break_all" name="dbPassword"
									validate="notNull:true,name:'${ctp:i18n('u8business.datasource.pwd')}',minLength:1,maxLength:85">
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		</div>
	</form>
</body>
</html>