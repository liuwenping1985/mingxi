<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script>

$().ready(function() {
  var imgStr = "<img src="+"${ctp:avatarImageUrl(1)}"+" width='100px' height='120px'>";
  $("#viewImageIframe").get(0).innerHTML = imgStr;
});
//上传头像
function imageUpload() {
  dymcCreateFileUpload("dyncid", "13", "gif,jpg,jpeg,png,bmp", "1", false, 'imageCallback', null, true, true, null, true, false, '512000');
  insertAttachment();
}
function imageCallback(id) {
  //隐藏图片下面的垃圾回收站的图标
  $("#attachmentArea").hide();
  var fileUrl = id.get(0).fileUrl;
  //精灵上传返回小写createdate，为了降低风险，不动精灵先处理这里
  var createDate = id.get(0).createDate || id.get(0).createdate;
  var url1 = '/fileUpload.do?method=showRTE&fileId=' + fileUrl + '&createDate=' + createDate + '&type=image';
  var path = _ctxServer;
  var url = " ";
  url = url + path + url1;
  $("#imageid").val(url1);
  var imgStr = "<img src='" + url + "' width='100px' height='120px'>";
  $("#viewImageIframe").get(0).innerHTML = imgStr;
}
</script>
<form id="memberForm" name="memberForm" method="post" action="">
    <div class="left" style="width:45%;">
        <p class="align_right">&nbsp;</p>
        <table width="90%" border="0" cellspacing="0" cellpadding="0" class="margin_l_10">
            <input type="hidden" id="id" value="-1">
            <input type="hidden" id="orgAccountId" value="-1">
            <input type="hidden" id="orgDepartmentId" value="-1">
            <input type="hidden" id="orgPostId" value="-1">
            <input type="hidden" id="orgLevelId" value="-1">
            <input type="hidden" id="secondPostIds">
            <input type="hidden" id="isInternal" value="true">
            <input type="hidden" id="roleIds">
            <input type="hidden" id="extRoleIds">
            <input type="hidden" id="extWorkScopeValue">
            <input type="hidden" id="isChangePWD" value="false">
            <input type="hidden" id="isLoginNameModifyed" value="false">
            <input type="hidden" id="isNewLdap" value="false">
            <input type="hidden" id="isNewMember" value="false">
            <input type="hidden" id="checkOnlyLoginName" value="false">
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
                        <input type="text" id="name" name="name" class="validate" validate="type:'string',name:'${ctp:i18n('org.member_form.name.label')}',notNull:true,maxLength:40,avoidChar:'><\'|,&quot'" />
                    </div>
                </td>
            </tr>
            <!--loginName-->
            <tr>
                <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.loginName.label')}:</label>
                </th>
                <td><div class="common_txtbox_wrap">
                        <input type="text" id="loginName" name="loginName" value="" class="validate" validate="type:'string',name:'${ctp:i18n('org.member_form.loginName.label')}', notNullWithoutTrim:true, maxLength:100,avoidChar:'\'\\/|><:*?&quot&%$'" />
                    </div>
                </td>
            </tr>
            <!--ldap/ad 区域 涉及新建状态和修改状态-->
            <tr id="ldapSet_tr0" class="ldapClass">
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('ldap.lable.type')}:</label>
                </th>
                <td><div class="common_radio_box clearfix">
                        <label class="margin_r_10 hand">
                            <input type="radio" name="ldapSetType" value="new"
                            class="radio_com">${ctp:i18n('ldap.lable.new')}
                        </label>
                        <label class="margin_r_10 hand">
                            <input type="radio" name="ldapSetType" value="select"
                            class="radio_com">${ctp:i18n('ldap.lable.select')}
                        </label>
                    </div>
                </td>
            </tr>
            <tr id="ldapSet_tr1" class="ldapClass">
                <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="ldapUserCodes">${ctp:i18n('ldap.lable.entry')}:</label>
                </th>
                <td><div class="common_txtbox_wrap">
                        <input type="text" id="ldapUserCodes" name="ldapUserCodes"/>
                    </div>
                </td>
            </tr>
            <tr id="ldapSet_tr2" class="ldapClass">
                <th nowrap="nowrap"><label class="margin_r_10" for="selectOU">${ctp:i18n('ldap.lable.node')}:</label>
                </th>
                <td><div class="common_txtbox_wrap">
                        <input type="text" id="selectOU" name="selectOU"/>
                    </div>
                </td>
            </tr>
            <!--password-->
            <tr>
                <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="password">${ctp:i18n('org.member_form.password.label')}:</label>
                </th>
                <td><div class="common_txtbox_wrap">
                        <input type="password" id="password" name="password" value="123456" class="validate" validate="type:'string',name:'${ctp:i18n('org.member_form.password.label')}',notNull:true,minLength:6,maxLength:50"/>
                    </div>
                </td>
            </tr>
            <!--repeatPwd-->
            <tr>
                <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="password2">${ctp:i18n('org.account_form.adminPass1.label')}:</label>
                </th>
                <td><div class="common_txtbox_wrap">
                        <input type="password" id="password2" name="password2" value="123456" class="validate" validate="type:'string',name:'${ctp:i18n('org.account_form.adminPass1.label')}',notNull:true,minLength:6,maxLength:50"/>
                    </div>
                </td>
            </tr>
            <tr id="pswpromotetr">
                <th nowrap="nowrap">&nbsp;</th>
                <td>
                    <font color="green">${ctp:i18n('manager.vaildate.length.org')}</font>
                </td>
            </tr>
            <!--primaryLanguange-->
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.primaryLanguange.label')}:</label>
                </th>
                <td><div class="w100b">
                        <select id="primaryLanguange" name="primaryLanguange" class="w100b">
                            <option value="zh_CN" selected>${ctp:i18n('org.member_form.primaryLanguange.zh_CN')}</option>
                            <%
                                int productId = com.seeyon.ctp.common.constants.ProductEditionEnum.getCurrentProductEditionEnum().getKey();
                                if(productId == 3 || productId == 4) {
                                } else {
                            %>
                            <option value="en">${ctp:i18n('org.member_form.primaryLanguange.en')}</option>
                            <%
                                }
                            %>
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
                        <label class="margin_r_10 hand">
                            <input type="radio" value="true" id="enabled" name="enabled"
                            class="radio_com m_enable">${ctp:i18n('common.state.normal.label')}
                        </label>
                        <label class="margin_r_10 hand">
                            <input type="radio" value="false" id="enabled" name="enabled"
                            class="radio_com m_enable">${ctp:i18n('common.state.invalidation.label')}
                        </label>
                    </div>
                </td>
            </tr>
            <!--securityNames 原有系统权限修改成为人员角色设置-->
            <!--roles-->
            <tr class="forInter">
                <th nowrap="nowrap"><!-- <font color="red">*</font> --><label class="margin_r_10" for="text">${ctp:i18n('org.member.roles')}:</label>
                </th>
                <td><div class="common_txtbox">
                        <textarea id="roles" name="roles" rows="3" class="w100b validate" validate="type:'string',name:'${ctp:i18n('org.member.roles')}'" readonly="true"></textarea>
                    </div>
                </td>
            </tr>
            <!--extRoles-->
            <tr class="forOuter">
                <th nowrap="nowrap"><!-- <font color="red">*</font> --><label class="margin_r_10" for="text">${ctp:i18n('org.member.roles')}:</label>
                </th>
                <td><div class="common_txtbox">
                        <textarea id="extRoles" name="extRoles" rows="3" class="w100b validate" validate="type:'string',name:'${ctp:i18n('org.member.roles')}'" readonly="true"></textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <th nowrap="nowrap">&nbsp;</th><td>
                    <font color="green">${ctp:i18n('org.member.roles.info')}</font>
                </td>
            </tr>
            <tr class="forInter">
                <th nowrap="nowrap">
                    <div class="hr-blue-font"><strong>${ctp:i18n('member.move.info')}</strong></div>
                </th>
                <td>&nbsp;</td>
            </tr>
            <tr class="forOuter">
                <th nowrap="nowrap">
                    <div class="hr-blue-font"><strong>${ctp:i18n('member.move.phone')}</strong></div>
                </th>
                <td>&nbsp;</td>
            </tr>
            <!--gender-->
            <tr class="forInter">
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.memberext_form.base_fieldset.sexe')}:</label>
                </th>
                <td><div class="common">
                        <select id="gender" name="gender" class="w100b">
                            <option value="-1"></option>
                            <option value="1">${ctp:i18n('org.memberext_form.base_fieldset.sexe.man')}</option>
                            <option value="2">${ctp:i18n('org.memberext_form.base_fieldset.sexe.woman')}</option>
                        </select>
                    </div>
                </td>
            </tr>
            <!--birthday-->
            <tr class="forInter">
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.memberext_form.base_fieldset.birthday')}:</label></th>
                <td><div class="common_txtbox_wrap">
                        <input id="birthday" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'"/>
                    </div>
                </td>
            </tr>
            <!--officeNum-->
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('member.office.number')}:</label></th>
                <td><div class="common_txtbox_wrap">
                        <input type="text" id="officenumber" name="officenumber" class="validate" validate="type:'string',name:'${ctp:i18n('member.office.number')}',maxLength:65"/>
                    </div>
                </td>
            </tr>
            <!--telNumber-->
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('member.move.number')}:</label></th>
                <td><div class="common_txtbox_wrap">
                        <input type="text" id="telnumber" name="telnumber" class="validate" validate="type:'string', name:'${ctp:i18n('member.move.number')}',maxLength:70, regExp:'^[\\d-]*$', errorMsg:'${ctp:i18n('telnumber_notvalid')}'"/>
                    </div>
                </td>
            </tr>
            <!--email-->
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member.emailaddress')}:</label></th>
                <td><div class="common_txtbox_wrap">
                        <input type="text" id="emailaddress" name="emailaddress" class="validate" validate="type:'email',name:'${ctp:i18n('org.member.emailaddress')}',maxLength:50"/>
                    </div>
                </td>
            </tr>
            <%
                if(productId == 3 || productId == 4) {
            %>
            <!-- G6区隔四个属性 叶延芳确认下面的两个下拉，不用枚举 -->
            <!-- 身份证 -->
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('member.form.idnum.label.GOV')}:</label></th>
                <td><div class="common_txtbox_wrap">
                        <input type="text" id="idnum" name="idnum" class="validate" validate="type:'string',name:'${ctp:i18n('member.form.idnum.label.GOV')}',maxLength:50"/>
                    </div>
                </td>
            </tr>
            <!-- 最高学历 -->
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('member.form.eduBack.label.GOV')}:</label></th>
                <td><div class="common_selectbox_wrap">
                        <select id="eduBack" class="w100b">
                            <option value="0"></option>
                            <option value="1">${ctp:i18n('member.form.eduBack.label.1.GOV')}</option>
                            <option value="2">${ctp:i18n('member.form.eduBack.label.2.GOV')}</option>
                            <option value="3">${ctp:i18n('member.form.eduBack.label.3.GOV')}</option>
                            <option value="4">${ctp:i18n('member.form.eduBack.label.4.GOV')}</option>
                            <option value="5">${ctp:i18n('member.form.eduBack.label.5.GOV')}</option>
                            <option value="6">${ctp:i18n('member.form.eduBack.label.6.GOV')}</option>
                            <option value="7">${ctp:i18n('member.form.eduBack.label.7.GOV')}</option>
                            <option value="8">${ctp:i18n('member.form.eduBack.label.8.GOV')}</option>
                            <option value="9">${ctp:i18n('member.form.eduBack.label.9.GOV')}</option>
                            <option value="10">${ctp:i18n('member.form.eduBack.label.10.GOV')}</option>
                        </select>
                    </div>
                </td>
            </tr>
            <!-- 最高学位 -->
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('member.form.degree.label.GOV')}:</label></th>
                <td><div class="common_txtbox_wrap">
                        <input type="text" id="degree" name="degree" class="validate" validate="type:'string',name:'${ctp:i18n('member.form.degree.label.GOV')}',maxLength:50"/>
                    </div>
                </td>
            </tr>
            <!-- 政治面貌 -->
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('member.form.politics.label.GOV')}:</label></th>
                <td><div class="common_selectbox_wrap">
                        <select id="politics" class="w100b">
                            <option value="0"></option>
                            <option value="1">${ctp:i18n('member.form.politics.label.1.GOV')}</option>
                            <option value="2">${ctp:i18n('member.form.politics.label.2.GOV')}</option>
                            <option value="3">${ctp:i18n('member.form.politics.label.3.GOV')}</option>
                            <option value="4">${ctp:i18n('member.form.politics.label.4.GOV')}</option>
                        </select>
                    </div>
                </td>
            </tr>
            <%
                }
            %>
            
            <!--descprition-->
            <tr class="forInter">
                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.descript_fieldset.label')}:</label></th>
                <td><div class="common_txtbox clearfix word_break_all">
                        <textarea id="description" rows="4" class="validate w100b" validate="type:'string', name:'${ctp:i18n('org.member_form.descript_fieldset.label')}',maxLength:200"></textarea>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div class="right" style="width:45%">
        <div class="">
            <p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
            <table width="90%" border="0" cellspacing="0" cellpadding="0">
                <tr><th nowrap="nowrap">
                        <div class="hr-blue-font"><strong>${ctp:i18n('org.member_form.org_fieldset.label')}</strong></div>
                    </th>
                    <td>&nbsp;</td>
                </tr>
                <!--deptName-->
                <tr class="forInter">
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.deptName.label')}:</label></th>
                    <td width="100%"><div class="common_txtbox_wrap">
                            <input type="text" id="deptName" name="deptName" class="validate" validate="type:'string',name:'${ctp:i18n('org.member_form.deptName.label')}',notNull:true,maxLength:255"/>
                        </div>
                    </td>
                </tr>
                <!--extAccountName-->
                <tr class="forOuter">
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.external.member.form.dept')}:</label></th>
                    <td width="100%"><div class="common_txtbox_wrap">
                            <input type="text" id="extAccountName" name="extAccountName" class="validate" validate="type:'string',name:'${ctp:i18n('org.external.member.form.dept')}',notNull:true,maxLength:255"/>
                        </div>
                    </td>
                </tr>
                <!--code-->
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.code')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="code" name="code" class="validate" validate="name:'${ctp:i18n('org.member_form.code')}',maxLength:20" />
                        </div>
                    </td>
                </tr>
                <!--sortId-->
                <tr>
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.account_form.sortId.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="sortId" maxlength="9" class="validate" validate="name:'${ctp:i18n('org.account_form.sortId.label')}',notNull:true,isInteger:true,minValue:1" />
                        </div>
                    </td>
                </tr>
                <!--sortIdtype-->
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.sort.repeat.deal')}:</label></th>
                    <td>
                        <div class="common_radio_box clearfix">
                            <label class="margin_r_10 hand"> <input
                                id="sortIdtype1" type="radio" value="0" name="sortIdtype"
                                class="radio_com">${ctp:i18n('org.sort.insert')}
                            </label>
                            <label class="margin_r_10 hand"> <input
                                id="sortIdtype2" type="radio" value="1" name="sortIdtype"
                                class="radio_com">${ctp:i18n('org.sort.repeat')}
                            </label>
                        </div>
                    </td>
                </tr>
                <!--primaryPost-->
                <tr class="forInter">
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.primaryPost.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="primaryPost" name="primaryPost" class="validate" validate="type:'string',name:'${ctp:i18n('org.member_form.primaryPost.label')}',notNull:true,maxLength:255" readonly="readonly"/>
                        </div>
                    </td>
                </tr>
                <tr class="forOuter">
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.primaryPost.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="extprimaryPost" name="extprimaryPost" class="validate" validate="type:'string',name:'${ctp:i18n('org.member_form.primaryPost.label')}',maxLength:255"/>
                        </div>
                    </td>
                </tr>
                <!--secondPost-->
                <tr class="forInter">
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.secondPost.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="secondPost" name="secondPost" readonly="readonly"/>
                        </div>
                    </td>
                </tr>
                <!--levelName-->
                <tr class="forInter">
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.levelName.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="levelName" name="levelName" class="validate" validate="type:'string',name:'${ctp:i18n('org.member_form.levelName.label')}',notNull:true,maxLength:255" readonly="readonly"/>
                        </div>
                    </td>
                </tr>
                <tr class="forOuter">
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.levelName.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="extlevelName" name="extlevelName" class="validate" validate="type:'string',name:'${ctp:i18n('org.member_form.levelName.label')}',maxLength:255"/>
                        </div>
                    </td>
                </tr>
                <!--extWorkScope-->
                <tr class="forOuter">
                    <th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('org.external.member.form.work')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="extWorkScope" name="extWorkScope" class="validate" validate="type:'string',name:'${ctp:i18n('org.external.member.form.work')}',notNull:true" readonly="readonly"/>
                        </div>
                    </td>
                </tr>
                <!--memberType-->
                <tr class="forInter">
                    <th><label class="margin_r_10" for="text">${ctp:i18n('org.metadata.member_type.label')}:</label></th>
                    <td><div class="common">
                            <select id="type" name="type" class="codecfg w100b" codecfg="codeId:'org_property_member_type'">  
                            </select>
                        </div>
                    </td>
                </tr>
                <!--state-->
                <tr class="forInter">
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.metadata.member_state.label')}:</label></th>
                    <td><div class="common">
                            <select id="state" name="state" class="codecfg w100b" codecfg="codeId:'org_property_member_state'">  
                            </select>
                        </div>
                    </td>
                </tr>
                <!--conPosts info-->
                <tr id="conPostsTr" class="forInter">
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.cnt.label')}:</label></th>
                    <td><div class="common_txtbox clearfix">
                            <textarea id="conPostsInfo" rows="6" class="w100b" readonly="readonly"></textarea>
                        </div>
                    </td>
                </tr>
                <!--photo-->
				<tr class="forInter">
					<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('member.photo')}:</label></th>
					<td> 
						<table cellspadding="0" border="0" cellspacing="1">
							<tr>
								<td><input id="imageid" name="imageid" value="" type="hidden" />
									<div id="viewImageIframe"></div>
									<div id="dyncid"></div></td>
								<td>&nbsp;&nbsp;&nbsp;</td>
								<td>
									<div style="color: green">100*120px</div><br/>
                                    <input type="button" id="imageFile" name="imageFile" onClick="imageUpload()" value="${ctp:i18n('member.photo.upload')}" />
								</td>
							</tr>
						</table>
					</td>
				</tr>
                <tr class="forOuter">
                    <th nowrap="nowrap"></th>
                    <td>&nbsp;
                    </td>
                </tr>
                <tr class="forOuter">
                    <th nowrap="nowrap"></th>
                    <td>&nbsp;
                    </td>
                </tr>
                <tr class="forOuter">
                    <th nowrap="nowrap"></th>
                    <td>&nbsp;
                    </td>
                </tr>
                <tr class="forOuter">
                    <th nowrap="nowrap"></th>
                    <td>&nbsp;
                    </td>
                </tr>
                <tr class="forOuter">
                    <th nowrap="nowrap"></th>
                    <td>&nbsp;
                    </td>
                </tr>
                <tr class="forOuter">
                    <th nowrap="nowrap"></th>
                    <td>&nbsp;
                    </td>
                </tr>
                <!--extgender-->
                <tr class="forOuter">
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.memberext_form.base_fieldset.sexe')}:</label>
                    </th>
                    <td><div class="common">
                            <select id="extgender" name="extgender" class="w100b">
                                <option value="-1"></option>
                                <option value="1">${ctp:i18n('org.memberext_form.base_fieldset.sexe.man')}</option>
                                <option value="2">${ctp:i18n('org.memberext_form.base_fieldset.sexe.woman')}</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <!--extbirthday-->
                <tr class="forOuter">
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.memberext_form.base_fieldset.birthday')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input id="extbirthday" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'"/>
                        </div>
                    </td>
                </tr>
                <!--extdescprition-->
                <tr class="forOuter">
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.descript_fieldset.label')}:</label></th>
                    <td><div class="common_txtbox clearfix">
                            <textarea id="extdescription" rows="4" class="validate w100b" validate="type:'string', name:'${ctp:i18n('org.member_form.descript_fieldset.label')}',maxLength:200"></textarea>
                        </div>
                    </td>
                </tr>
			</table>
        </div>
    </div>
</form>