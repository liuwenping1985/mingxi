<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="over_hidden">
<head>
<style>
.stadic_body_top_bottom{
    bottom: 30px;
    top: 0px;
}
.stadic_footer_height{
    height:30px;
}
</style>
<script type="text/javascript" language="javascript">
var memberIds = window.dialogArguments;
$().ready(function() {
    var oManager = new orgManager();
    $("#ids").val(memberIds);
    //批量修改角色
    $("#roles").click(function() {
        var dialogBatchRole = $.dialog({
            url: "<c:url value='/organization/member.do' />?method=member2Role&accountId=${accountId}",
            title: "${ctp:i18n('member.authorize.role')}",
            width: 400,
            height: 300,
            targetWindow:window.top,
            transParams:"true",
            buttons: [{
                isEmphasize:true,
                id: "roleOK",
                text: "${ctp:i18n('guestbook.leaveword.ok')}",
                handler: function() {
                    var roleIds = dialogBatchRole.getReturnValue();
                    var roleStr = "";
                    for (var i = 0; i < roleIds.length; i++) {
                        var rObject = oManager.getRoleById(roleIds[i]);
                        roleStr = roleStr + rObject.showName;
                        if (i !== roleIds.length - 1) {
                            roleStr = roleStr + "、";
                        }
                    };
                    $("#roles").val(roleStr);
                    $("#roleIds").val(roleIds);
                    dialogBatchRole.close();
                }
            },
            {
                id: "roleConcel",
                text: "${ctp:i18n('systemswitch.cancel.lable')}",
                handler: function() {
                    dialogBatchRole.close();
                }
            }]

        });
    });
    var deptIds = new Array();
    var isDeptAdmin = false;
    if('${isDeptAdmin}' == 'true') {
        deptIds = ${deptIds};
        isDeptAdmin = true;
    }
    //部门
    $("#deptName").click(function() {
        $.selectPeople({
            type: 'selectPeople',
            panels: 'Department',
            selectType: 'Department',
            minSize: 1,
            maxSize: 1,
            onlyLoginAccount: true,
            accountId: "${accountId}",
            returnValueNeedType: false,
            callback: function(ret) {
                if(isDeptAdmin) {
                    var isCluded = $.inArray(ret.value, deptIds);
                    var tempDeptName = ret.text;
                    if(-1 == isCluded) {
                      $.alert($.i18n('member.dept.not.in.manager.depts.js').format(tempDeptName));
                      return true;
                    }
                }
                $("#deptName").val(ret.text);
                $("#orgDepartmentId").val(ret.value);
            }
        });
    });
    //主岗
    $("#primaryPost").click(function() {
        $.selectPeople({
            type: 'selectPeople',
            panels: 'Post',
            selectType: 'Post',
            minSize: 1,
            maxSize: 1,
            onlyLoginAccount: true,
            accountId: "${accountId}",
            returnValueNeedType: false,
            callback: function(ret) {
                $("#primaryPost").val(ret.text);
                $("#orgPostId").val(ret.value);
            }
        });
    });
    //职务
    $("#levelName").click(function() {
        $.selectPeople({
            type: 'selectPeople',
            panels: 'Level',
            selectType: 'Level',
            minSize: 1,
            maxSize: 1,
            onlyLoginAccount: true,
            accountId: "${accountId}",
            returnValueNeedType: false,
            callback: function(ret) {
                $("#levelName").val(ret.text);
                $("#orgLevelId").val(ret.value);
            }
        });
    });
    
    $("#btnok").click(function() {
    	if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        $("#btnok").disable();
        $("#btncancel").disable();
        $("#memberBatForm").submit();
    });
    $("#btncancel").click(function() {
        window.parent.dialog4Batch.close();
    });

});

</script>
</head>
<body>
<div class="form_area" id='form_area'>
    <form id="memberBatForm" name="memberBatForm" method="post" action="member.do?method=batchUpdate">
        <div class="align_center clearfix">
            <table width="90%" border="0" cellspacing="0" cellpadding="0" class="margin_l_15">
                <input type="hidden" id="ids" name="ids" value="-1">
                <input type="hidden" id=accountId name="accountId" value="${accountId}">
                <input type="hidden" id="roleIds" name="roleIds">
                <input type="hidden" id="orgDepartmentId" name="orgDepartmentId">
                <input type="hidden" id="orgPostId" name="orgPostId">
                <input type="hidden" id="orgLevelId" name="orgLevelId">
                <!-- 批量修改角色 -->
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member.roles')}:</label>
                    </th>
                    <td width="80%"><div class="common_txtbox_wrap">
                            <input type="text" id="roles" name="roles" class="w100b"/>
                        </div>
                    </td>
                <tr>
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.deptName.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="deptName" name="deptName" class="w100b"/>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.levelName.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="levelName" name="levelName" class="w100b"/>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.primaryPost.label')}:</label></th>
                    <td><div class="common_txtbox_wrap">
                            <input type="text" id="primaryPost" name="primaryPost" class="w100b"/>
                        </div>
                    </td>
                </tr>
                <!--gender-->
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.memberext_form.base_fieldset.sexe')}:</label>
                    </th>
                    <td>
                        <select id="gender" name="gender"  class="common_drop_down w100b">
                            <option value="" selected></option>
                            <option value="1">${ctp:i18n('org.memberext_form.base_fieldset.sexe.man')}</option>
                            <option value="2">${ctp:i18n('org.memberext_form.base_fieldset.sexe.woman')}</option>
                        </select>
                    </td>
                </tr>
                <!--member_type-->
                <tr>
                    <th><label class="margin_r_10" for="text">${ctp:i18n('org.metadata.member_type.label')}:</label></th>
                    <td>
                        <div class="common">
                            <select id="type" name="type" class="codecfg w100b" codecfg="codeId:'org_property_member_type'">  
                            </select>
                        </div>
                    </td>
                </tr>
                <!--primaryLanguange-->
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.member_form.primaryLanguange.label')}:</label>
                    </th>
                    <td>
                        <select id="primaryLanguange" name="primaryLanguange" class="common_drop_down w100b">
                            <option value="" selected></option>
                            <option value="zh_CN">${ctp:i18n('org.member_form.primaryLanguange.zh_CN')}</option>
                            <c:if test="${ctp:getSystemProperty('system.ProductId') != '3' && ctp:getSystemProperty('system.ProductId') != '4'}">
                            <option value="en">${ctp:i18n('org.member_form.primaryLanguange.en')}</option>
                            </c:if>
                            <option value="zh_TW">${ctp:i18n('org.member_form.primaryLanguange.zh')}</option>
                        </select>
                    </td>
                </tr>
                <!--enabled-->
                <tr>
                    <th><label class="margin_r_10" for="text">${ctp:i18n('organization.member.state')}:</label></th>
                    <td><select id="enabled" name="enabled" class="common_drop_down w100b">
                            <option value="" selected></option>
                            <option value="1">${ctp:i18n('common.state.normal.label')}</option>
                            <option value="0">${ctp:i18n('common.state.invalidation.label')}</option>
                        </select>
                    </td>
                </tr>
            </table>
        </div>
            <div id="button_area" class="align_center stadic_layout_footer stadic_footer_height">
            <a href="javascript:void(0)" id="btnok" class="common_button common_button_emphasize">${ctp:i18n('common.button.ok.label')}</a>
            <a href="javascript:void(0)" id="btncancel" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
        </div>
    </form>
</div>
</body>
</html>