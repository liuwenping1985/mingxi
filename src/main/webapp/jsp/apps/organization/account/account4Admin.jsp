<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/organization/account/account4Admin_js.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<title>AccountManager</title>
<style>
    .stadic_head_height{
        height:30px;
    }
    .stadic_body_top_bottom{
        top: 30px;
        bottom: 30px;
    }
    .stadic_footer_height{
        height:30px;
    }
    .stadic_right{
        float:right;
        width:100%;
        height:100%;
        position:absolute;
        z-index:100;
    }
    .stadic_right .stadic_content{
        overflow:auto;
        margin-left:50%;
        height:100%;
    }
    .stadic_left{
        float:left; 
        width:50%; 
        height:100%;
        position:absolute;
        z-index:300;
    }
    table{table-layout:fixed;}
</style>
</head>
<body class="h100b over_hidden">

	<div id='layout' class="stadic_layout">
		<div class="stadic_layout_head stadic_head_height">
    		<div class="comp" comp="type:'breadcrumb',code:'T02_viewAccount'"></div>
            <div id="toolbar"></div>
		</div>
		<div id="form_area" class="stadic_layout_body stadic_body_top_bottom clearfix form_area">
		<form id="accountForm" name="accountForm" method="post" class="h100b">
			<input type="hidden" id="orgAccountId" value="-1">
			<input type="hidden" id="id" value="-1">
			<input type="hidden" id="path" value="-1">
			<input type="hidden" id="adminMemberId" value="-1">
			<input type="hidden" id="oldAdminName" value="">
			<input type="hidden" id="levelScope" value="-1">
			<input type="hidden" id="superior" name="superior" value="-1">
			<input type="hidden" id="isLdapEnabled" name="isLdapEnabled" value="false">
			<div class="stadic_right">
				<div class="stadic_content">
					<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
							<table width="95%" border="0" cellspacing="0" cellpadding="0"
								align="left">
								<!--单位扩展信息-->
								<tr>
									<th width="100" nowrap="nowrap"><label for="text"><strong>${ctp:i18n('org.account_form.fieldset4Name.label')}</strong></label>
									</th>
									<td>&nbsp;</td>
								</tr>
								<!--account_category-->
								<tr>
									<th><label for="text" class="margin_r_10 hand">${ctp:i18n('org.metadata.account_category.label')}:</label></th>
									<td><select id="unitCategory" name="unitCategory"
										class="codecfg w100b"
										codecfg="codeId:'org_property_account_category'">
											<option value=""></option>
										</select>
									</td>
								</tr>
								<!--chiefLeader-->
								<tr>
									<th><label for="text" class="margin_r_10 hand">${ctp:i18n('org.account_form.manager.label')}:</label></th>
									<td><div class="common_txtbox_wrap">
											<input type="text" id="chiefLeader" class="validate"
												validate="type:'string',name:'${ctp:i18n('org.account_form.manager.label')}',maxLength:50" />
										</div></td>
								</tr>
								<!--address-->
								<tr>
									<th><label for="text" class="margin_r_10 hand">${ctp:i18n('org.account_form.address.label')}:</label></th>
									<td><div class="common_txtbox_wrap">
											<input type="text" id="address" class="validate"
												validate="type:'string',name:'${ctp:i18n('org.account_form.address.label')}',maxLength:50" />
										</div></td>
								</tr>
								<!--zipCode-->
								<tr>
									<th><label for="text" class="margin_r_10 hand">${ctp:i18n('org.account_form.zipCode.label')}:</label></th>
									<td><div class="common_txtbox_wrap">
											<input type="text" id="zipCode" class="validate"
												validate="type:'string',name:'${ctp:i18n('org.account_form.zipCode.label')}',maxLength:50" />
										</div></td>
								</tr>
								<!--telephone-->
								<tr>
									<th><label for="text" class="margin_r_10 hand">${ctp:i18n('org.account_form.telephone.label')}:</label></th>
									<td><div class="common_txtbox_wrap">
											<input type="text" id="telephone" class="validate"
												validate="type:'string',name:'${ctp:i18n('org.account_form.telephone.label')}',maxLength:50" />
										</div></td>
								</tr>
								<!--fax-->
								<tr>
									<th><label for="text" class="margin_r_10 hand">${ctp:i18n('org.account_form.fax.label')}:</label></th>
									<td><div class="common_txtbox_wrap">
											<input type="text" id="fax" class="validate"
												validate="type:'string',name:'${ctp:i18n('org.account_form.fax.label')}',maxLength:50" />
										</div></td>
								</tr>
								<!--ipAddress-->
								<tr>
									<th><label for="text" class="margin_r_10 hand">${ctp:i18n('org.account_form.ipAddress.label')}:</label></th>
									<td><div class="common_txtbox_wrap">
											<input type="text" id="ipAddress" class="validate"
												validate="type:'string',name:'${ctp:i18n('org.account_form.ipAddress.label')}',maxLength:50" />
										</div></td>
								</tr>
								<!--unitMail-->
								<tr>
									<th><label for="text" class="margin_r_10 hand">${ctp:i18n('org.account_form.accountMail.label')}:</label></th>
									<td><div class="common_txtbox_wrap">
											<input type="text" id="unitMail" class="validate"
												validate="type:'email',name:'${ctp:i18n('org.account_form.accountMail.label')}',maxLength:50" />
										</div>
									</td>
								</tr>
								<!--description-->
								<tr>
									<th nowrap="nowrap" valign="top"><label for="text" class="margin_r_10 hand"><strong>${ctp:i18n('org.account_form.decription.label')}</strong></label></th>
									<td>
										<div class="common_txtbox clearfix word_break_all"><textarea id="description" name="description" rows="5" class="validate w100b"
												validate="type:'string',name:'${ctp:i18n('org.account_form.decription.label')}',maxLength:200,avoidChar:'!@#$%^&amp;\&#39;*+'"></textarea>
										</div>
									</td>
								</tr>
							</table>
				</div>
			</div>
			<div class="stadic_left">
				<p class="align_right">&nbsp;</p>
						<table width="95%" border="0" cellspacing="0" cellpadding="0"
							align="rigtht">
							<tr>
								<th width="120"><label for="text"><strong>${ctp:i18n('org.account_form.fieldset1Name.label')}</strong></label>
								</th>
								<td>&nbsp;</td>
							</tr>
							<!--name-->
							<tr>
								<th><font color="red">*</font><label for="text" class="margin_r_10 hand">${ctp:i18n('org.account_form.name.label')}:</label></th>
								<td><div class="common_txtbox_wrap">
										<input type="text" id="name" class="validate"
											validate="type:'string',name:'${ctp:i18n('org.account_form.name.label')}',notNull:true,maxLength:80,avoidChar:'\\\/|><:*?&%$|,\&#39;\&#34;'" />
									</div>
								</td>
							</tr>
							<!--secondName-->
							<tr>
								<th><label for="text" class="margin_r_10 hand">${ctp:i18n('org.account_form.secondName.label')}:</label></th>
								<td><div class="common_txtbox_wrap">
										<input type="text" id="secondName" class="validate"
											validate="type:'string',name:'${ctp:i18n('org.account_form.secondName.label')}',maxLength:84" />
									</div></td>
							</tr>
							<!--shortName-->
							<tr>
								<th><font color="red">*</font><label for="text" class="margin_r_10 hand">${ctp:i18n('org.account_form.shortname.label')}:</label></th>
								<td><div class="common_txtbox_wrap">
										<input type="text" id="shortName" class="validate"
											validate="type:'string',name:'${ctp:i18n('org.account_form.shortname.label')}',notNull:true,maxLength:50,avoidChar:'\\\/|><:*?&%$\&#39;'" />
									</div></td>
							</tr>
							<!--code-->
							<tr>
								<th><font color="red">*</font><label  
									for="text" class="margin_r_10 hand">${ctp:i18n('org.account_form.code.label')}:</label></th>
								<td><div class="common_txtbox_wrap">
										<input type="text" id="code" class="validate"
											validate="type:'string',name:'${ctp:i18n('org.account_form.code.label')}',notNull:true,maxLength:50" />
									</div></td>
							</tr>
							<!--ldap/ad-->
							<tr id="ldapSet" class="nonGroup">
								<th><font color="red">*</font><label  
									for="text" class="margin_r_10 hand">${ctp:i18n('ldap.lable.node')}:</label></th>
								<td><div class="common_txtbox_wrap">
										<input type="text" id="ldapOu" name="ldapOu"/>
									</div>
								</td>
							</tr>
							<tr>
								<th nowrap="nowrap"><label
									  for="text"><strong>${ctp:i18n('org.account_form.fieldset3Name.label')}</strong></label>
								</th>
								<td>&nbsp;</td>
							</tr>
							<!--adminName-->
							<tr>
								<th nowrap="nowrap"><font color="red">*</font><label
									  for="text" class="margin_r_10 hand">${ctp:i18n('org.account_form.adminName.label')}:</label></th>
								<td><div class="common_txtbox_wrap">
										<input type="text" id="adminName" maxLength="40" class="validate"
											validate="type:'string',name:'${ctp:i18n('org.account_form.adminName.label')}',notNull:true, maxLength:40, regExp:'^[\\w-]+$', errorMsg:'${ctp:i18n('loginName_isCriterionWord')}'" />
									</div>
								</td>
							</tr>
							<!--adminSourcePassword 用于单位管理员修改密码先输入原始密码确认-->
                            <tr id="adminSourcePasswordtr">
                                <th nowrap="nowrap"><font color="red">*</font><label
                                    class="margin_r_10" for="text">${ctp:i18n('account.system.oldpassword')}:</label>
                                </th>
                                <td><div class="common_txtbox_wrap">
                                        <input type="password" id="adminSourcePass" value=""
                                            class="validate"
                                            validate="type:'string',name:'${ctp:i18n('account.system.oldpassword')}',notNull:true,minLength:6,maxLength:50" />
                                    </div>
                                </td>
                            </tr>
							<!--adminPassword-->
							<tr id="adminPasswordtr">
								<th nowrap="nowrap"><font color="red">*</font><label
									  for="text" class="margin_r_10 hand">${ctp:i18n('account.system.newpassword')}:</label>
								</th>
								<td><div class="common_txtbox_wrap">
										<input type="password" id="adminPass" value=""
											class="validate"
											validate="type:'string',name:'${ctp:i18n('account.system.newpassword')}',notNull:true,minLength:6,maxLength:50" />
									</div>
								</td>
							</tr>
							<!--validatepassword-->
							<tr id="validatepasswordtr">
								<th nowrap="nowrap"><font color="red">*</font><label
									  for="text" class="margin_r_10 hand">${ctp:i18n('account.system.validatepassword')}:</label>
								</th>
								<td><div class="common_txtbox_wrap">
										<input type="password" id="adminPass1" value=""
											class="validate"
											validate="type:'string',name:'${ctp:i18n('account.system.validatepassword')}',notNull:true,minLength:6,maxLength:50" />
									</div>
								</td>
							</tr>
							<tr id="pswpromotetr">
								<th nowrap="nowrap">&nbsp;</th>
								<td class='green'>${ctp:i18n('manager.vaildate.length.org')}
								</td>
							</tr>
							<tr id="pswchecktr">
								<th nowrap="nowrap">&nbsp;</th>
								<td><label for="checkManager"><input id="checkManager" type="checkbox" name="checkManager" value="0" />&nbsp;${ctp:i18n('account.message')}</label>
								</td>
							</tr>
							<!--serverPermission-->
							<tr class="nonGroup">
								<th nowrap="nowrap"><label for="text" class="margin_r_10 hand">
									${ctp:i18n('org.account_form.permission.server.account')}:
								</label></th>
								<td><span id="serverPermission"></span>
								</td>
							</tr>
							<!--m1Permission-->
							<tr class="nonGroup">
								<th nowrap="nowrap"><label for="text" class="margin_r_10 hand">
									${ctp:i18n('org.account_form.permission.m1.account')}:
								</label></th>
								<td><span id="m1Permission"></span>
								</td>
							</tr>
						</table>
			</div>
 </form>
		</div>
		<div id="button_area" class="stadic_layout_footer stadic_footer_height align_center bg_color">
			<a id="btnok" href="javascript:void(0)"
							class="common_button common_button_gray margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
						&nbsp; <a id="btncancel" href="javascript:void(0)"
							class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
		</div>
	</div>
</body>
</html>