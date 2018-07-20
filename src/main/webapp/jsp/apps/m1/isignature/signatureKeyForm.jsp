<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<form id="addForm" name="addForm" method="post" action="">
<input type="hidden" name="userID" id="userID" value = "-1"/>
<input type="hidden" name="id" id="id" value = "-1"/>
<input type="hidden" name ="formType" id ="formType" value = "add"/>
   <div class="form_area" >
		<div class="one_row">
		<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('m1.isignature.userkey.userName')}:</label></th>
						<td>
							<div>
								<input type="text" id="userName"  name = "userName"  readonly="readonly" class="validate word_break_all"
								validate="type:'string',name:'${ctp:i18n('m1.isignature.userkey.userName')}',notNull:true,minLength:1,maxLength:85,avoidChar:'\\\/|><*?&%$|,'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('m1.isignature.userkey.keysn')}:</label></th>
						<td>
							<div>
								<input type="text" id="key"  name = "key"   class="validate word_break_all"
								validate="type:'string',name:'${ctp:i18n('m1.isignature.userkey.keysn')}',notNull:true,minLength:1,maxLength:85,avoidChar:'\\\/|><*?&%$|,'">
							</div>
						</td>
					</tr>
				
				
				</tbody>
			</table>
		</div>
   </div>
</form>