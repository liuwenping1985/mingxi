<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body>
	<form name="addForm" id="addForm" method="post" target="delIframe">
	<div class="form_area" >
		<div class="one_row" style="width:40%;">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<br>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<input type="hidden" name="id" id="id" value="" />			
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('multicall.plugin.config.type')}:</label></th>
						<td width="100%">
							<div class="common_selectbox_wrap">
								<select id="type" name="type" class="codecfg"
    							codecfg="codeType:'java',codeId:'com.seeyon.apps.multicall.util.ConfigTypeEnum'">
    								<%-- <option value="">${ctp:i18n('cip.select.choose')}</option> --%>
								</select>
							</div>
						</td>
					</tr>					
					<tr class="companyTr">
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('multicall.plugin.config.company.name') }:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="hidden" id="orgAccountId">
								<input type="text" id="companyName"  name="companyName" class="validate" readonly="readonly"
                                                validate="type:'string',name:'${ctp:i18n('multicall.plugin.config.company.name') }',notNull:true,minLength:1,maxLength:85">
							</div>
						</td>
					</tr>
					<tr class="companyTr">
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('multicall.plugin.config.company.code')}:</label></th>
						<td width="100%">
							<div class="common_txtbox_wrap">
								<input type="text" id="companyCode" readonly="readonly" class="validate word_break_all" validate="name:'${ctp:i18n('multicall.plugin.config.company.code')}',notNull:true">	
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('multicall.plugin.config.systemaccount')}:</label></th>
						<td width="100%">
							<div class="common_txtbox_wrap">
								<input type="text" id="systemAccount" readonly="readonly" class="validate word_break_all" validate="name:'${ctp:i18n('multicall.plugin.config.systemaccount')}',notNull:true">	
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('multicall.plugin.config.state')}:</label></th>
						<td width="100%">
							<div class="common_selectbox_wrap">
								<select id="state" name="state" class="codecfg"
    							codecfg="codeType:'java',codeId:'com.seeyon.apps.multicall.util.ConfigStateEnum'">
    								<%-- <option value="">${ctp:i18n('cip.select.choose')}</option> --%>
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