<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>报表管理员查看</title>
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
                <div class="common_txtbox_wrap">
                    <input id="loginName" type="text" disabled="disabled" value="${reportAdmin.name}">
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
                      <input id="loginName" type="text" disabled="disabled" value="${reportAdmin.loginName}">
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