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
					<input type="hidden" name="linkSystemId" id="linkSystemId" value="" />
					<input type="hidden" name="loginAcl" id="loginAcl"/>
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
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.service.register.access')}:</label></th>
						<td>
							<div class="common_txtbox_wrap ">
								<input type="text" id="loginPattern" name="loginPattern" disabled>
								<input type="hidden" id="accessMethod" name="accessMethod" disabled>
							</div>

						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.service.enabled')}:</label></th>
						
						<td width="100%">
							<div class="common_selectbox_wrap">
								<select id="isEnable" name="isEnable" class="codecfg"
    							codecfg="codeType:'java',codeId:'com.seeyon.apps.cip.enums.CipEnableEnum'">
    								<option value="">${ctp:i18n('cip.select.choose')}</option>
								</select>
							</div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.portal.Authentication.pattern')}:</label></th>
                        <td width="100%">
							<div class="common_selectbox_wrap">
								<select id="authenticationMode" name="authenticationMode" class="codecfg"
    							codecfg="codeType:'java',codeId:'com.seeyon.apps.cip.enums.AuthenticationEnum'">
    								<option value="">${ctp:i18n('cip.select.choose')}</option>
								</select>
							</div>
						</td>
					</tr>
					<tr class="userPwdTr">
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.portal.character.encode') }:</label></th>
						<td>
							<div class="common_selectbox_wrap">
								<select id="charset">
									<option value="">${ctp:i18n('cip.select.choose')}</option>
									<option value="UTF-8">UTF-8</option>
									<option value="GB2312">GB2312</option>
								</select>
							</div>
						</td>
					</tr>
					<tr class="userPwdTr">
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.portal.transmethod') }:</label></th>
						<td>
							<div class="common_radio_box clearfix">
								<label for="transmethod1" class="margin_r_10 hand">        
									<input type="radio" value="GET" id="transmethod1" name="option" class="radio_com" checked="checked">GET</label>    
								<label for="transmethod2" class="margin_r_10 hand">        
									<input type="radio" value="POST" id="transmethod2" name="option" class="radio_com">POST</label>    
							</div> 
						</td>
					</tr>
					<tr class="userPwdTr">
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.portal.encrymethod') }:</label></th>
						<td>
							<div class="common_selectbox_wrap">
								<select id="encrymethod">
									<option value="">${ctp:i18n('cip.select.choose')}</option>
									<option value="MD5">${ctp:i18n('cip.portal.encrymethod.md5') }</option>
									<option value="customize">${ctp:i18n('cip.portal.encrymethod.customize') }</option>
								</select>
							</div>
						</td>
					</tr>
					<tr class="userPwdTr algorithm">
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.portal.encrymethod.algorithm') }:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="algorithm" class="validate word_break_all"
									validate="name:'自定义加密算法'">
							</div>
						</td>
					</tr>
					<tr class="userPwdTr">
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.portal.param.name') }:</label></th>
						<td>
							<div class="common_txtbox_wrap" style="width: 72%;float: left;">
								<input type="text" id="username" class="validate word_break_all" validate="name:'${ctp:i18n('cip.portal.param.name') }'">
							</div>
							<div class="common_checkbox_box clearfix ">    
								<label for="encryusername" class="margin_l_10 hand">        
									<input type="checkbox" value="1" id="encryusername" name="option" class="radio_com">${ctp:i18n('cip.portal.isencrypted') }</label>
							</div>
						</td>
					</tr>
					<tr class="userPwdTr">
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.portal.param.pwdname') }:</label></th>
						<td>
							<div class="common_txtbox_wrap" style="width: 72%;float: left;">
								<input type="text" id="pwd" class="validate word_break_all" validate="name:'${ctp:i18n('cip.portal.param.pwdname') }'">
							</div>
							<div class="common_checkbox_box clearfix ">    
								<label for="encrypwd" class="margin_l_10 hand">        
									<input type="checkbox" value="1" id="encrypwd" name="option" class="radio_com">${ctp:i18n('cip.portal.isencrypted') }</label>
							</div>
						</td>
					</tr>
					<tr id="groupLevelId_area">
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.sso.interface.label')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="ssoLoginUrl" class="validate word_break_all"
									validate="name:'${ctp:i18n('cip.sso.interface.label')}',regExp:/^(http|https):\/\/[a-zA-Z0-9]+[.]+[a-zA-Z0-9]+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])*$/">
							</div>

						</td>
					</tr>
					<tr id="tr_pc_url">
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.pc.login.addres.label')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="pcPageUrl" class="validate word_break_all"
									validate="name:'${ctp:i18n('cip.pc.login.addres.label')}',regExp:/^(http|https):\/\/[a-zA-Z0-9]+[.]+[a-zA-Z0-9]+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])*$/">
							</div>
						</td>
					</tr>
					
					<tr id="tr_h5_url">
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.H5.login.addres.label')}:</label></th>
						<td>
							<div class="common_txtbox_wrap ">
								<input type="text" id="h5PageUrl" class="validate word_break_all"
									validate="name:'${ctp:i18n('cip.H5.login.addres.label')}',regExp:/[a-zA-Z0-9]+[.]+[a-zA-Z0-9]+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])*$/">
							</div>
						</td>
					</tr>
					
					<tr id="tr1" style="display: none;" >
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.start.command.label')}:</label></th>
						<td>
							<div class="common_txtbox_wrap ">
								<input type="text" id="startCommand" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('cip.start.command.label')}',minLength:10,maxLength:1000">
							</div>
						</td>
					</tr>
				    <tr id="loginInterface">
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.sso.portal.display')}:</label></th>
						<td>
							<div class="common_txtbox_wrap ">
								<input type="text" id="thirdpartyAuthPortal" disabled="disabled" readonly="readonly">
							</div>
						</td>
					</tr> 
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.portal.acl')}:</label></th>
						<td>
							<div class="common_txtbox_wrap ">
								<input type="text" id="loginAclTxt"  readonly="readonly">
							</div>
						</td>
					</tr> 
					<%--
					<tr id="tr3">
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.ios.start.command.label')}:</label></th>
						<td>
							<div class="common_txtbox_wrap ">
								<input type="text" id="iosStartCommand" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('cip.ios.start.command.label')}',avoidChar:'\\\/|><:*?&%$|,&quot;-_+',minLength:10,maxLength:100">
							</div>
						</td>
					</tr>  --%>
					<th nowrap="nowrap" id="appText"><label class="margin_r_10" for="text">${ctp:i18n('cip.app.login.order')}：</label></th>
					<table id="appTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table" >
					<input type="hidden" name="assist_id" id="assist_id" value="1" />
					    <thead>
					        <tr>
					            <th width="30%">${ctp:i18n('cip.app.mobile.type')}</th>
					            <th width="70%">${ctp:i18n('cip.app.mobile.order')}</th>
					        </tr>
					    </thead>
					    <tbody id="mobody">
					        <tr class="assist" id = "1">
					            <td>
					            	<div class="common_selectbox_wrap">
										<select id="mobileType1" name="mobileType1" >
										<option value="iPhone">iPhone</option>
										<option value="iPad">iPad</option>
										<option value="androidPhone">androidPhone</option>
										<option value="androidPad">androidPad</option>
										<option value="WP">WP</option>
										</select>
									</div>
					            </td>
					            <td>
									<div class="common_txtbox_wrap ">
										<input type="text" id="mobileCommand" class="validate word_break_all"
											validate="type:'string',notNull:true,name:'${ctp:i18n('cip.start.command.label')}',minLength:10,maxLength:1000">
									</div>
								</td>
					        </tr>
					    </tbody>
					</table>
				</tbody>
			</table>
		</div>
	</div>
	<div class="hidden"   id="img" style="width: 16px; height: 30px;  position: relative;float: right; border: 1px; " name="img">
			<div id="addDiv" style="height: auto;">
				<span title="增加空行" class="ico16 repeater_plus_16" id="addImg" style="display: block;"></span></div><div id="addEmptyDiv" style="height: auto;">
				<!-- <span title="增加空行" class="ico16 blank_plus_16" id="addEmptyImg" style="display: block;"></span></div><div id="delDiv" style="height: auto;"> -->
				<span title="删除此行" class="ico16 repeater_reduce_16" id="delImg" style="display: block;"></span>
			</div>
	</div>
	</form>


</body>
</html>