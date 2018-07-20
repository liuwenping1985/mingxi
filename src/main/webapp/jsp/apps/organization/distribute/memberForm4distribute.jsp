<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<title>MemberForm4distribute</title>
</head>
<body>
    <form id="memberForm" name="memberForm" method="post" action="">
        <div class="stadic_left">
            <table width="90%" border="0" cellspacing="0" cellpadding="0">
                <input type="hidden" id="id" value="-1">
                <input type="hidden" id="orgAccountId" value="-1">
                <input type="hidden" id="orgDepartmentId" value="-1">
                <input type="hidden" id="orgPostId" value="-1">
                <input type="hidden" id="orgLevelId" value="-1">
                <input type="hidden" id="secondPostIds">
                <input type="hidden" id="isInternal" value="true">
                <input type="hidden" id="roleIds">
                <input type="hidden" id="extWorkScopeValue">
                <input type="hidden" id="isChangePWD" value="false">
                <tr>
                    <th>
                        <div class="hr-blue-font"><strong>${ctp:i18n('org.member_form.system_fieldset.label')}</strong></div>
                    </th>
                    <td>&nbsp;</td>
                </tr>
                <!--name-->
                <tr>
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.name.label')}:</label>
                    </th>
                    <td width="100%"><div class="common_txtbox_wrap">
                            <input type="text" id="name" name="name" class="validate" validate="type:'string',notNull:true,maxLength:40" />
                        </div>
                    </td>
                </tr>
                <!--loginName-->
                <tr>
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.loginName.label')}:</label>
                    </th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="loginName" name="loginName"/>
                        </div>
                    </td>
                </tr>
                <!--password-->
                <tr>
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.password.label')}:</label>
                    </th>
                    <td><div class="common_txtbox_wrap">
                            <input type="password" id="password" name="password" value="123456"/>
                        </div>
                    </td>
                </tr>
                <!--repeatPwd-->
                <tr>
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.account_form.adminPass1.label')}:</label>
                    </th>
                    <td><div class="common_txtbox_wrap">
                            <input type="password" id="password2" name="password2" value="123456" class="validate" validate="type:'string',name:'${ctp:i18n('org.account_form.adminPass1.label')}',notNull:true,minLength:6,maxLength:50"/>
                        </div>
                    </td>
                </tr>
                <!--primaryLanguange-->
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.primaryLanguange.label')}:</label>
                    </th>
                    <td><div class="w100b">
                        <select id="primaryLanguange" name="primaryLanguange" class="w100b">
                            <option value="zh_CN" selected>${ctp:i18n('org.member_form.primaryLanguange.zh_CN')}</option>
                            <option value="en">${ctp:i18n('org.member_form.primaryLanguange.en')}</option>
                            <option value="zh_TW">${ctp:i18n('org.member_form.primaryLanguange.zh')}</option>
                        </select>
                    </div>
                </td>
                </tr>
                <!--enabled-->
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('organization.member.state')}:</label>
                    </th>
                    <td>
                        <div class="common_radio_box clearfix">
                            <label for="radio1" class="margin_r_10 hand">
                                <input type="radio" value="true" id="enabled" name="enabled"
                                class="radio_com">${ctp:i18n('common.state.normal.label')}
                            </label>
                            <label for="radio2" class="margin_r_10 hand">
                                <input type="radio" value="false" id="enabled" name="enabled"
                                class="radio_com">${ctp:i18n('common.state.invalidation.label')}
                            </label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th nowrap="nowrap">
                        <div class="hr-blue-font"><strong>${ctp:i18n('member.move.phone')}</strong></div>
                    </th>
                    <td>&nbsp;</td>
                </tr>
                <!--telNumber-->
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('member.move.number')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="telnumber" name="telnumber" class="validate" validate="type:'string',name:'${ctp:i18n('member.move.number')}'"/>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="stadic_right">
            <div class="stadic_content">
                <table width="85%" border="0" cellspacing="0" cellpadding="0">
                <tr><th nowrap="nowrap">
                        <div class="hr-blue-font"><strong>${ctp:i18n('org.member_form.org_fieldset.label')}</strong></div>
                    </th>
                    <td>&nbsp;</td>
                </tr>
                <!--code-->
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.code')}:</label></th>
                    <td width="100%"><div class="common_txtbox_wrap">
                            <input type="text" id="code" name="code" class="validate" validate="name:'${ctp:i18n('org.member_form.code')}',maxLength:20" />
                        </div>
                    </td>
                </tr>
                <!--sortId-->
                <tr>
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.account_form.sortId.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="sortId" class="validate" validate="name:'${ctp:i18n('org.account_form.sortId.label')}',notNull:true,isInteger:true,minValue:1" />
                        </div>
                    </td>
                </tr>
                <!--oldAccountName原单位-->
                <tr>
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.distributeAccountName.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="sourceAccount" name="sourceAccount" class="validate" validate="type:'string',name:'${ctp:i18n('org.member_form.ExtDeptName.label')}',notNull:true"/>
                        </div>
                    </td>
                </tr>
                <!--deptName-->
                <tr>
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.deptName.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="deptName" name="deptName" class="validate" validate="type:'string',name:'${ctp:i18n('org.member_form.deptName.label')}',notNull:true"/>
                        </div>
                    </td>
                </tr>
                <!--primaryPost-->
                <tr>
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.primaryPost.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="primaryPost" name="primaryPost" class="validate" validate="type:'string',name:'${ctp:i18n('org.member_form.primaryPost.label')}',notNull:true,maxLength:50"/>
                        </div>
                    </td>
                </tr>
                <!--secondPost-->
                <tr class="forInter">
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.secondPost.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="secondPost" name="secondPost"/>
                        </div>
                    </td>
                </tr>
                <!--levelName-->
                <tr>
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.levelName.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="levelName" name="levelName" class="validate" validate="type:'string',name:'${ctp:i18n('org.member_form.ExtDeptName.label')}',notNull:true,maxLength:50"/>
                        </div>
                    </td>
                </tr>
                <!--memberType-->
                <tr>
                    <th><label class="margin_r_10" for="text">${ctp:i18n('org.metadata.member_type.label')}:</label></th>
                    <td><div class="common">
                            <select id="type" name="type" class="codecfg w100b" codecfg="codeId:'org_property_member_type'">  
                            </select>
                        </div>
                    </td>
                </tr>
                <!--state-->
                <tr>
                    <th><label class="margin_r_10" for="text">${ctp:i18n('org.metadata.member_state.label')}:</label></th>
                    <td><div class="common">
                            <select id="state" name="state" class="codecfg w100b" codecfg="codeId:'org_property_member_state'">  
                            </select>
                        </div>
                    </td>
                </tr>
                <!--descprition-->
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.descript_fieldset.label')}:</label></th>
                    <td><div class="common_txtbox clearfix">
                            <textarea id="description" rows="4" cols="50" class="validate w100b" validate="type:'string', name:'${ctp:i18n('org.member_form.descript_fieldset.label')}',maxLength:200"></textarea>
                        </div>
                    </td>
                </tr>
            </table>
            </div>
        </div>
	</form>
</body>
</html>