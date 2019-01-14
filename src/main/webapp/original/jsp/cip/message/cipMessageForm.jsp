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
		<p class="align_right"><font color="red">*</font>${ctp:i18n('cip.form.must')}</p>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
				<input type="hidden" name="id" id="id" value="" />
				<input type="hidden" name="type" id="type" value="${type}" />
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.register.appname')}:</label></th>
						<td>
							<div class="common_selectbox_wrap">
								<select id="registerId" name="registerId" >
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.message.get.module')}:</label></th>
						<td>
							<div class="common_selectbox_wrap">
								<select id="getMode" name="getMode" class="codecfg"
    							codecfg="codeType:'java',codeId:'com.seeyon.apps.cip.enums.GetModeEnum'">
    								<option value="">${ctp:i18n('cip.select.choose')}</option>
								</select>
								
							</div>

						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.manager.register.access')}:</label></th>
						<td>
							<div class="common_txtbox_wrap ">
								<input type="text" id="accessMethodName" name="accessMethodName" disabled>
							</div>
						</td>
					</tr>
					<tr id="groupLevelId_area">
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.servcie.url')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="serviceUrl" class="validate word_break_all"
									validate="name:'${ctp:i18n('cip.servcie.url')}',regExp:/^(http|https):\/\/[a-zA-Z0-9]+[.]+[a-zA-Z0-9]+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])*$/">
							</div>

						</td>
					</tr>
					<tr id="timeInterval_area">
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.servcie.time_interval')}:</label></th>
						<td>
							<div class="common_selectbox_wrap">
						<!-- 		<input type="text" id="timeInterval" class="validate word_break_all"> -->
								<select id="timeInterval" name="timeInterval">
									 
								</select>
							</div>
						</td>
					</tr>
					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.manager.enabled')}:</label></th>
						
						<td width="100%">
							<div class="common_selectbox_wrap">
								<select id="isEnable" name="isEnable" class="codecfg"
    							codecfg="codeType:'java',codeId:'com.seeyon.apps.cip.enums.CipEnableEnum'">
    								<option value="">${ctp:i18n('cip.select.choose')}</option>
								</select>
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