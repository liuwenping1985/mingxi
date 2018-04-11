<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<html class="h100b over_hidden">
<head>
</head>
<body>
    <form name="conPostForm" id="conPostForm" method="post">
        <p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
        <div class="one_row">
            <table border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <input type="hidden" name="id" id="id" value="-1" />
                    <input type="hidden" name="cMemberId" id="cMemberId"/>
                    <input type="hidden" name="cAccountId" id="cAccountId"/>
                    <input type="hidden" name="cDeptId" id="cDeptId"/>
                    <input type="hidden" name="cPostId" id="cPostId"/>
                    <input type="hidden" name="cLevelId" id="cLevelId"/>
                    <input type="hidden" name="cRoleIds" id="cRoleIds"/>
                    <tr>
                        <th nowrap="nowrap">
                            <div class="hr-blue-font"><strong>${ctp:i18n('org.member_form.system_fieldset.label')}</strong></div>
                        </th>
                        <td width="100%">&nbsp;</td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap">
                        <label class="margin_r_10" for="cMember"><font color="red">*</font>${ctp:i18n('department.parttime.member')}</label>
                        </th>
                        <td width="100%">
                            <div class="common_txtbox_wrap">
                                <input type="text" id="cMember" name="cMember" readonly="readonly"/>
                            </div>
                        </td>
                    </tr>
                    <tr id="notGroup">
                        <th nowrap="nowrap">
                        <label class="margin_r_10" for="sortId"><font color="red">*</font>${ctp:i18n('org.account_form.sortId.label')}:</label>
                        </th>
                        <td width="100%">
                            <div class="common_txtbox_wrap">
                                <input type="text" id="sortId" name="sortId" maxlength="9" class="validate" validate="type:'string',name:'${ctp:i18n('org.account_form.sortId.label')}',notNull:true,isInteger:true,minValue:1" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap">
                        <label class="margin_r_10" for="code">${ctp:i18n('department.parttime.code')}:</label>
                        </th>
                        <td width="100%">
                            <div class="common_txtbox_wrap">
                                <input type="text" id="code" name="code" class="validate" validate="type:'string',name:'${ctp:i18n('department.parttime.code')}',maxLength:20" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap">
                        <label class="margin_r_10" for="primaryPost">${ctp:i18n('org.dept.main.duty')}:</label>
                        </th>
                        <td width="100%">
                            <div class="common_txtbox_wrap">
                                <input type="text" id="primaryPost" name="primaryPost" readonly="readonly" disabled/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap">
                        <label class="margin_r_10" for="cAccount"><font color="red">*</font>${ctp:i18n('department.parttime.dept')}:</label>
                        </th>
                        <td width="100%">
                            <div class="common_txtbox_wrap">
                                <input type="text" id="cAccount" name="cAccount" readonly="readonly"/>
                            </div>
                        </td>
                    </tr>
                    <tr height="34px">
                        <th nowrap="nowrap">
                        </th>
                        <td width="100%">
								<font color="#ff000">*${ctp:i18n('department.concurrent.validate.must')}</font>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap">
                        <label class="margin_r_10" for="cDept">${ctp:i18n('org.dept.parttime.department')}:</label>
                        </th>
                        <td width="100%">
                            <div class="common_txtbox_wrap">
                                <input type="text" id="cDept" name="cDept" readonly="readonly"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap">
                        <label class="margin_r_10" for="cPost">${ctp:i18n('org.dept.parttime.jobs')}:</label>
                        </th>
                        <td width="100%">
                            <div class="common_txtbox_wrap">
                                <input type="text" id="cPost" name="cPost" readonly="readonly"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap">
                        <label class="margin_r_10" for="cLevel">${ctp:i18n('department.parttime.level')}:</label>
                        </th>
                        <td width="100%">
                            <div class="common_txtbox_wrap">
                                <input type="text" id="cLevel" name="cLevel" readonly="readonly"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap">
                        <label class="margin_r_10" for="cRoles"><font color="red">*</font>${ctp:i18n('department.parttime.role')}:</label>
                        </th>
                        <td width="100%">
                            <div class="common_txtbox_wrap">
                                <input type="text" id="cRoles" name="cRoles" readonly="readonly"/>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </form>
</body>
</html>