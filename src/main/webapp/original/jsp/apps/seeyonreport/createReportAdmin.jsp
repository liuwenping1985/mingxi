<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:2014-04-23
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增报表管理员</title>
</head>
<body scroll="no">
  <form id="reportAdminForm">
    <div class="form_area" id="formArea">
      <div class="one_row">
        <table border="0" cellSpacing="0" cellPadding="0" align="center" class="margin_10">
          <tbody>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text">
              		<!-- 姓名 -->
              		${ctp:i18n('seeyonreport.report.admin.name.label')}:
              	</label>
              </th>
              <td width="83%">
                <div class="common_txtbox_wrap" id="selectPeopleDiv">
                	<input type="text" id="name" name="name" readonly="readonly" style="cursor: pointer;" class="validate" validate="type: 'string',name :'${ctp:i18n("seeyonreport.report.admin.name.label")}', notNull:true"/>
                	<input type="hidden" id="memberId" name="memberId"/>
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text" title="${ctp:i18n('seeyonreport.report.admin.loginname.title') }">
                    <!-- 设计器登录名 -->
                    ${ctp:i18n('seeyonreport.report.admin.loginname.label')}:
                </label>
              </th>
              <td>
              	  <div class="common_txtbox_wrap">
                  	  <input id="loginName" name="loginName" placeholder="${ctp:i18n('seeyonreport.report.admin.loginname.title') }" disabled="disabled" value="${admin.loginName }" type="text" class="validate" maxlength="20" validate="type:'string',name:'${ctp:i18n('seeyonreport.report.admin.loginname.label')}',maxLength:20,isDeaultValue:true,notNull:true,deaultValue:'\<${ctp:i18n('seeyonreport.report.template.newcategory.fillname.label')}\>'">
              	 </div> 
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text" title="${ctp:i18n('seeyonreport.report.admin.password.title') }">
                    <!-- 登录密码 -->
                    ${ctp:i18n('seeyonreport.report.admin.password.label')}:
                </label>
              </th>
              <td>
                <div class="common_txtbox_wrap">
                  <input type="password" id="password" name="password" placeholder="${ctp:i18n('seeyonreport.report.admin.password.title') }"  autocomplete="off" class="validate" validate="type:'string',name:'${ctp:i18n('seeyonreport.report.admin.password.label')}',notNull:true,minLength:6,maxLength:50"/>
                </div>
              </td>
            </tr>
			<tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text">
              		<!-- 密码确认 -->
              		${ctp:i18n('seeyonreport.report.admin.password.confirm.label')}:
              	</label>
              </th>
              <td>
                <div class="common_txtbox_wrap">
                  <input type="password" autocomplete="off"  id="password2" name="password2" class="validate" validate="type:'string',name:'${ctp:i18n('seeyonreport.report.admin.password.confirm.label')}',notNull:true,minLength:6,maxLength:50"/>
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
             	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text" title="${ctp:i18n('seeyonreport.report.admin.workspace.title') }">
                    <!-- 工作目录 -->
                    ${ctp:i18n('seeyonreport.report.workspace.label')}:
                </label>
              </th>
              <td>
              	  <div class="common_txtbox_wrap">
                      <input id="workspace" name="workspace" value="${admin.workspace }" disabled="disabled" placeholder="${ctp:i18n('seeyonreport.report.admin.workspace.title') }" type="text" class="validate" maxlength="20"
                    validate="type:'string',name:'${ctp:i18n('seeyonreport.report.workspace.label')}',maxLength:20,isDeaultValue:true,notNull:true,deaultValue:'\<${ctp:i18n('seeyonreport.report.workspace.label')}\>'">
                 </div> 
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text" title="${ctp:i18n('seeyonreport.report.db.name.title') }">
                    <!-- 数据库用户名 -->
                    ${ctp:i18n('seeyonreport.report.db.name.label')}:
                </label>
              </th>
              <td>
              	  <div class="common_txtbox_wrap">
                      <input id="dbUserName" name="dbUserName" value="${admin.dbUserName }" disabled="disabled" placeholder="${ctp:i18n('seeyonreport.report.db.name.title') }" type="text" class="validate" maxlength="16" validate="type:'string',name:'${ctp:i18n('seeyonreport.report.db.name.label')}',maxLength:16,isDeaultValue:true,notNull:true,deaultValue:'\<${ctp:i18n('seeyonreport.report.db.name.label')}\>'">
                 </div>  
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </form>
<script type="text/javascript" src="${path}/common/seeyonreport/jquery.ui.placeholder-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('input, textarea').placeholder();
	//选择人员
	$("#name").on("click", function() {
		$.selectPeople({
			type : 'selectPeople',
			panels : 'Department',
			minSize : 1,
			maxSize : 1,
			selectType : 'Member',
			onlyLoginAccount : true,
			params : {
				text : $("#userName").val(),
				value : 'Member|' + $("#memberId").val()
			},
			callback : function(ret) {
				$("#name").val(ret.text);
				var memberId = ret.value.split("|")[1];
				$("#memberId").val(memberId);
				
				var sram = new seeyonReportAdminManager();
				sram.getMemberLoginName(memberId, {
					success : function(loginName) {
						$("#loginName").val(loginName);
						$("#workspace").val(loginName);
						$("#dbUserName").val(loginName);
					},
					error : function(request, settings, e) {
						$.alert($.parseJSON(request.responseText).message || e);
					}
				});
			}
		});
	});
	//登录名&工作目录&数据库用户名联动
	$("#loginName").on("keyup", function(e){
		var $t = $(this);
		$("#workspace").val($t.val());
        $("#dbUserName").val($t.val());
	});
});

function OK() {
	if (!$("#reportAdminForm").validate()) {
		return;
	}
	//校验密码是否一致
	var p = $("#password").val(), p2 = $("#password2").val();
	if (p !== p2) {
		$.alert("${ctp:i18n('seeyonreport.report.admin.pwd.error.label')}");
		return;
	}
	return $("#reportAdminForm").formobj();
}
</script>  
</body>
</html>