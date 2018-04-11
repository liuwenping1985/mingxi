<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<form id="M1LbsAuthor" name="M1LbsAuthor" method="post" action="">
	<input type="hidden" name="id" id="id" value="-1"/>
	<input type="hidden" name="oprType" id="oprType" value="1"/>
	<input type="hidden" name="authorUserId" id="authorUserId" value="-1"/>
	<input type = "hidden" name="editAuthorUser" id="editAuthorUser" value="false"/>
	<input type="hidden" name="scopesIds" id="scopesIds" value="-1"/>
   <div class="form_area" >
		<div class="one_row">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('m1.lbs.authorUser')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="authorUserName"  name ="authorUserName" readonly="readonly"   class="validate word_break_all" 
								validate="type:'string',name:'${ctp:i18n('m1.lbs.authorUser')}',notNull:true,minLength:1,avoidChar:'\\\/|><?&%$|'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('m1.lbs.authorScope')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<textarea id="scopes"  name = "scopes" rows="5" cols="60"  style="color:gray;overflow-y:auto" class="validate" 
								validate="type:'string',name:'${ctp:i18n('m1.lbs.authorScope')}',notNull:true,minLength:1,avoidChar:'\\\/|><?&%$|'"></textarea>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
   </div>
</form>