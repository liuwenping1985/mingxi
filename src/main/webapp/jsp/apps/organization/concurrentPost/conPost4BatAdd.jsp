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
<html>
<head>
<script type="text/javascript" src="${path}/ajax.do?managerName=conPostManager"></script>
<script type="text/javascript">
$().ready(function() {
    var cpManager = new conPostManager();
    //兼职人员
    $("#cMemberBat").click(function() {
        var preMemberIds = $("#cMemberBatIds").val();
        $.selectPeople({
            type: 'selectPeople',
            panels: 'Department',
            selectType: 'Member',
            minSize: 1,
            returnValueNeedType: true,
            showConcurrentMember: false,
            params:{value:preMemberIds},
            callback: function(ret) {
                $("#cMemberBat").val(ret.text);
                $("#cMemberBatIds").val(ret.value);
            }
        });
    });
    //兼职单位
    $("#cAccountBat").click(function() {
        var preAccountIds = $("#cAccountBatIds").val();
        $.selectPeople({
            panels: 'Account',
            selectType: 'Account',
            minSize: 1,
            isCanSelectGroupAccount:false,
            returnValueNeedType: true,
            params:{value:preAccountIds},
            callback: function(ret) {
                $("#cAccountBat").val(ret.text);
                $("#cAccountBatIds").val(ret.value);
            }
        });
    });

    $("#submitbtnBat").click(function() {
	$("#submitbtnBat").disable();
        if ($("#cMemberBatIds").val() === '') {
            $.alert("${ctp:i18n('department.choose.parttime.staff')}");
			 $("#submitbtnBat").enable();
            return;
        }
        if ($("#cAccountBatIds").val() === '') {
            $.alert("${ctp:i18n('department.choose.parttime.dept')}");
			 $("#submitbtnBat").enable();
            return;
        }
        if($("#cMemberBatIds").val().indexOf(",") !== -1 && $("#cAccountBatIds").val().indexOf(",") !== -1) {
            $.alert("${ctp:i18n('department.choose.single.or.multiple.or.more')}");
			 $("#submitbtnBat").enable();
            return;
        }
        if(!cpManager.checkBatConpostAccount($("#cMemberBatIds").val(),$("#cAccountBatIds").val())) {
            $.alert("${ctp:i18n('department.parttime.this.external.not.same.bat')}");
			 $("#submitbtnBat").enable();
            return;
        }
        //cntPost.banch.same.account
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        $("#conPostFormBat").jsonSubmit();
    });
    $("#cancelbtnBat").click(function() {
        window.parent.dialog.close();
    });
});
</script>
</head>
<body>
    <div id="banch_form_area" class="form_area over_hidden" layout="width:240">
        <form name="conPostFormBat" id="conPostFormBat" method="post" action="conPost.do?method=batAddCon">
            <div class="align_center">
                <table border="0" cellspacing="0" cellpadding="0">
                    <input type="hidden" id="cMemberBatIds">
                    <input type="hidden" id="cAccountBatIds">
                    <tbody>
                        <br>
                        <tr>
                            <th nowrap="nowrap">
                            <label class="margin_r_10" for="cMemberBat">&nbsp;<font color="red">*</font>${ctp:i18n('department.parttime.member')}:</label>
                            </th>
                            <td width="80%">
                                <div class="common_txtbox_wrap">
                                    <input type="text" id="cMemberBat" name="cMemberBat"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap">
                            <label class="margin_r_10" for="cAccountBat">&nbsp;<font color="red">*</font>${ctp:i18n('department.parttime.dept')}:</label>
                            </th>
                            <td width="80%">
                                <div class="common_txtbox_wrap">
                                    <input type="text" id="cAccountBat" name="cAccountBat" />
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="align_left color_black font_size12">
                <br>&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('cnt.show1')}
                <br>
                <br>&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('cnt.show2')}
                <br>
                <br>
            </div>
            <div class="align_center">
                <a id="submitbtnBat" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('guestbook.leaveword.ok')}</a>&nbsp;&nbsp;
                <a id="cancelbtnBat" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('systemswitch.cancel.lable')}</a>
            </div>
        </form>
    </div>
</body>
</html>