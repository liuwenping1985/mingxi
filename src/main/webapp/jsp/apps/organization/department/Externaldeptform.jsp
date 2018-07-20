<%@ page language="java" contentType="text/html; charset=UTF-8"%>

	<form name="addForm" id="addForm" method="post" target="addDeptFrame"
		action="${path}/organization/department.do?method=createDept&islist=${islist}">
		<div class="one_row">
		<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<input type="hidden" name="orgAccountId" id="orgAccountId" value="" />
					<input type="hidden" name="id" id="id" value="" />
					<input type="hidden" name="isInternal" id="isInternal" value="false" />
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><strong>${ctp:i18n('org.external.dept.info')}</strong></label></th>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('org.external.dept.form.name')}</label></th>
						<td width="100%">
							<div class="common_txtbox_wrap">
								<input type="text" id="name" class="validate"
									validate="type:'string',name:'${ctp:i18n('org.external.dept.form.name')}', notNullWithoutTrim:true, minLength:1, maxLength:100, avoidChar:'><\'|,&quot'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.external.dept.form.code')}</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="code" class="validate"
									validate="type:'string',name:'${ctp:i18n('org.dept_form.code.label')}',notNull:false,minLength:1,maxLength:100,avoidChar:'<!@#$%\^&amp;*+'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('common.sort.label')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="sortId" class="validate"
									validate="type:'number',isInteger:true,name:'${ctp:i18n('common.sort.label')}',notNull:true,minValue:1,minLength:1,maxValue:99999">
							</div>

						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.sort.repeat.deal')}:</label></th>
						<td>
							<div class="common_radio_box clearfix">
								<label class="margin_r_10 hand"> <input
									type="radio"  value="1" name="sortIdtype" id="sortIdtype"
									class="radio_com">${ctp:i18n('org.sort.insert')}
								</label> <label class="margin_r_10 hand"> <input
									type="radio"  value="0" name="sortIdtype" id="sortIdtype"
									class="radio_com">${ctp:i18n('org.sort.repeat')}
								</label>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('org.dept_form.membership.department')}</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="superDepartment" class="comp validate" comp="type:'selectPeople',panels:'Department',selectType:'Department,Account',maxSize:'1',onlyLoginAccount:true" 
								validate="type:'string',name:'${ctp:i18n('org.dept_form.membership.department')}',notNull:true,minLength:1,maxLength:500"/> 
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('common.state.label')}:</label></th>
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
							<div class="common_txtbox clearfix word_break_all">
								<textarea id="description" rows="4" cols="60%" class="validate" validate="type:'string', name:'${ctp:i18n('common.description.label')}',maxLength:200"></textarea>
							</div>
						</td>
					</tr>
					<tr>
						<td align="right"></td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>

</html>