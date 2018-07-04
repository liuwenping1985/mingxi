<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<form id="memberForm" name="memberForm" method="post" action="">
<input type="hidden" name="id" id="memberID" value = "-1"/>
<input type="hidden" name="id" id="pid" value = "-1"/>
   <div class="form_area" >
		
		<div class="one_row">
		<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('m3.bind.bind.memberNum')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="memberName"  name = "memberName"  readonly="readonly" class="validate word_break_all"
								validate="type:'string',name:'${ctp:i18n('m3.bind.bind.memberNum')}',notNull:true,minLength:1,maxLength:85,avoidChar:'\\\/|><*?&%$|,'">
							</div>
						</td>
					</tr>
					
					
					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('m3.bind.clientName')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="clientName"  name = "clientName" class="validate word_break_all"
								validate="type:'string',name:'${ctp:i18n('m3.bind.clientName')}',notNull:true,minLength:1,maxLength:85,avoidChar:'\\\/|><*?&%$|,'">
							</div>
						</td>
					</tr>
					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('m3.bind.binded.clientNum')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="clientNum"  name = "clientNum" class="validate word_break_all"
								validate="type:'string',name:'${ctp:i18n('m3.bind.binded.clientNum')}',notNull:true,minLength:1,maxLength:85,avoidChar:'\\\/|><*?&%$|,'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('m3.bind.clientType')}:</label></th>
						<td>
							<div>
								<select id="clientType" name="clientType" class="codecfg">
									<option id = "androidOption" value="android">android</option>
									<option value="iPhone" >iPhone</option>
									<!-- <option value="iPad" >iPad</option> -->
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('common.state.label')}:</label></th>
						<td>
							<div class="common_radio_box clearfix">
								<label class="margin_r_10 hand"> <input
									type="radio"  value="1"  id="stateFlag" name="stateFlag" 
									class="radio_com">${ctp:i18n('m3.bind.binded.starting')}
								</label> <label class="margin_r_10 hand"> <input
									type="radio"  value="2" id="stateFlag" name="stateFlag" 
									class="radio_com">${ctp:i18n('m3.bind.binded.forbidden')}
								</label>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
   </div>
</form>