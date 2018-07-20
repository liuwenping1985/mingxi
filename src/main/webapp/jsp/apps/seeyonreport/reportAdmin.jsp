<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:2014-04-23
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=seeyonReportAdminManager"></script>
<script type="text/javascript" src="${path}/common/seeyonreport/reportAdmin.js${ctp:resSuffix()}"></script>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>报表系统条件设置</title>
<script type="text/javascript">
	$(document).ready(function(){
		var password = "${password}";
		//password 不为空，说明是编辑页面
		if(password != ""){
			$("#password1").val(password);
			$("#password2").val(password);
		}
		
		//初始化
		init();
		
	});
	
</script>
</head>
<body scroll="no">
	
  <form id="reportAdminForm">
    <div class="form_area" id="formArea">
      <div class="one_row">
        <table border="0" cellSpacing="0" cellPadding="0" align="center" class="margin_10">
        	<!-- 编辑时隐藏域 -->
        	<input type="hidden" id="oriLoginName">
        	<input type="hidden" id="id">
        	<%-- 操作类型 新建、编辑 --%>
        	<input type="hidden" id="operaType" value="${operaType}">
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
                <input type="text" id="userNameID" readonly="readonly" class="comp"
                    comp="type:'selectPeople',panels:'Department',minSize:'1',maxSize:'1',selectType:'Member',mode:'open',onlyLoginAccount:true,text:'${name}',value:'${memberId}',callback:callFunc" />
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text" title="用户在远程设计报表时，登录所需要的用户名">
              		<!-- 设计器登录名 -->
              		${ctp:i18n('seeyonreport.report.admin.loginname.label')}:
              	</label>
              </th>
              <td>
              	  <div class="common_txtbox_wrap">
                  	  <input id="loginName" type="text" class="validate" maxlength="20"
                    validate="type:'string',name:'${ctp:i18n('seeyonreport.report.admin.loginname.label')}',maxLength:20,isDeaultValue:true,notNull:true,deaultValue:'\<${ctp:i18n('seeyonreport.report.template.newcategory.fillname.label')}\>'">
              	 </div> 
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text" title="用户在远程设计报表时，登录所需要的密码">
              		<!-- 登录密码 -->
              		${ctp:i18n('seeyonreport.report.admin.password.label')}:
              	</label>
              </th>
              <td>
                <div class="common_txtbox_wrap">
                  <input type="password" id="password1" name="password1" class="validate" validate="type:'string',name:'${ctp:i18n('seeyonreport.report.admin.password.label')}',notNull:true,minLength:6,maxLength:50"/>
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
                  <input type="password" id="password2" name="password2" class="validate" validate="type:'string',name:'${ctp:i18n('seeyonreport.report.admin.password.confirm.label')}',notNull:true,minLength:6,maxLength:50"/>
                </div>
              </td>
            </tr>
           
            <tr>
              <th noWrap="nowrap">
             	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text" title="用户在远程设计报表时，制作的模板保存的目录">
              		<!-- 工作目录 -->
              		${ctp:i18n('seeyonreport.report.workspace.label')}:
              	</label>
              </th>
              <td>
              	  <div class="common_txtbox_wrap">
                  	  <input id="workspace" type="text" class="validate" maxlength="20"
                    validate="type:'string',name:'${ctp:i18n('seeyonreport.report.workspace.label')}',maxLength:20,isDeaultValue:true,notNull:true,deaultValue:'\<${ctp:i18n('seeyonreport.report.workspace.label')}\>'">
              	 </div> 
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text" title="用户在远程设计报表时，连接的数据库用户">
              		<!-- 数据库用户名 -->
              		${ctp:i18n('seeyonreport.report.db.name.label')}:
              	</label>
              </th>
              <td>
              	  <div class="common_txtbox_wrap">
                  	  <input id="dbUserName" type="text" class="validate" maxlength="16"
                    validate="type:'string',name:'${ctp:i18n('seeyonreport.report.db.name.label')}',maxLength:16,isDeaultValue:true,notNull:true,deaultValue:'\<${ctp:i18n('seeyonreport.report.db.name.label')}\>'">
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