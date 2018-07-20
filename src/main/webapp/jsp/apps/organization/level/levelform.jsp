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
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('org.level_form.name.label')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="name" class="validate"
									validate="type:'string',name:'${ctp:i18n('org.level_form.name.label')}',notNull:true,minLength:1,maxLength:255,avoidChar:'\\/|><:*!@#$%^&amp;*+|,\'&quot'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.level_form.code.label')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="code" class="validate" validate="type:'string',name:'${ctp:i18n('org.level_form.code.label')}',notNull:false,maxLength:140,avoidChar:'!@#$%^&amp;*+|,'">
							</div>

						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('org.level_form.levelId.label')}:</label></th>
						
						<td width="100%">
							<div class="common_txtbox_wrap">
								<input type="text" id="levelId" class="validate"
									validate="type:'number',isInteger:true,name:'${ctp:i18n('org.level_form.levelId.label')}',minValue:1,notNull:true,minLength:1,maxValue:999">
							</div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap">
                        </th>
                        <td width="100%">
							<div style="color:green">${ctp:i18n("org.level_form.integer.input")}</div>
						</td>
					</tr>
					<tr id="groupLevelId_area">
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.level_form.groupLevelId.label')}:</label></th>
						<td>
							<div class="common_selectbox_wrap">
								<select id="groupLevelId" name="groupLevelId" class="codecfg"
    							codecfg="codeType:'java',codeId:'com.seeyon.ctp.organization.enums.GroupLevelIdEnum'">
    								<option value="">${ctp:i18n('level.select.choose')}</option>
								</select>	
							</div>

						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('common.state.label')}:</label></th>
						<td>
							<div class="common_radio_box clearfix">
								<label class="margin_r_10 hand"> <input
									type="radio"  value="true" name="enabled" id="enabled"
									class="radio_com">${ctp:i18n('common.state.normal.label')}
								</label> <label class="margin_r_10 hand"> <input
									type="radio"  value="false" name="enabled" id="enabled"
									class="radio_com">${ctp:i18n('common.state.invalidation.label')}
								</label>
							</div>
						</td>
					</tr>
					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('common.description.label')}:</label></th>
						<td>
							<div class="common_txtbox clearfix">
								<textarea rows="5" class="w100b validate word_break_all" id="description" validate="type:'string',name:'${ctp:i18n('common.description.label')}',notNull:false,maxLength:255,avoidChar:'!@#$%^&amp;*+'"></textarea>
							</div>
						</td>
					</tr>
					<tr class="cGroup">
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><strong>${ctp:i18n('common.job.level.mapping.instruction')}:</strong></label></th>
						<td>
							<div class="common_txtbox  clearfix">
								<font color="green">${ctp:i18n("common.job.level.mapping.description")}</font>
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