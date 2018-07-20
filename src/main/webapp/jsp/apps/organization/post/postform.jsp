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
					<input type="hidden" name="id" id="id" value="" />
					<input type="hidden" name="posttype" id="posttype" value="" />
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('org.post_form.name')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="name" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('org.post_form.name')}',notNull:true,minLength:1,maxLength:85,avoidChar:'\'&quot\\\/|><:*?&%$|,'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.post_form.type.code')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="code" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('org.post_form.type.code')}',notNull:false,minLength:1,maxLength:20,avoidChar:'-!@#$%><^&amp;*()\'&quot_+'">
							</div>

						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.metadata.post_typeId.label')}:</label></th>
						
						<td width="100%">
							<div>
								<select id="typeId" name="typeId" class="codecfg"
									codecfg="codeId:'organization_post_types'">
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('common.sort.label')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="sortId" class="validate word_break_all"
									validate="type:'number',isInteger:true,name:'${ctp:i18n('common.sort.label')}',notNull:true,minValue:1,minLength:1,maxValue:99999">
							</div>

						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.sort.repeat.deal')}:</label></th>
						<td>
							<div class="common_radio_box clearfix">
								<label class="margin_r_10 hand"> <input
									type="radio"  value="1" id="sortIdtype" name="sortIdtype"
									class="radio_com">${ctp:i18n('org.sort.insert')}
								</label> <label class="margin_r_10 hand"> <input
									type="radio"  value="0" id="sortIdtype" name="sortIdtype"
									class="radio_com">${ctp:i18n('org.sort.repeat')}
								</label>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('common.state.label')}:</label></th>
						<td>
							<div class="common_radio_box clearfix">
								<label class="margin_r_10 hand"> <input
									type="radio"  value="true"  id="enabled" name="enabled" 
									class="radio_com">${ctp:i18n('common.state.normal.label')}
								</label> <label class="margin_r_10 hand"> <input
									type="radio"  value="false" id="enabled" name="enabled" 
									class="radio_com">${ctp:i18n('common.state.invalidation.label')}
								</label>
							</div>
						</td>
					</tr>
					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('common.description.label')}:</label></th>
						<td>
							<div class="common_txtbox  clearfix">
								<textarea rows="5" class="w100b validate word_break_all" id="description" validate="type:'string',name:'${ctp:i18n('common.description.label')}',notNull:false,maxLength:1000"></textarea>
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