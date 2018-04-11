<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>报表模板查看</title>
</head>
<body>
  <form id="reportTemplate">
    <div class="form_area" id="formArea">
      <div class="one_row">
        <table border="0" cellSpacing="0" cellPadding="0">
          <tbody>
            <tr>
              <th noWrap="nowrap">
              	<label class="margin_r_10" for="text">
              		<%-- 模板名称 --%>
              		${ctp:i18n('seeyonreport.report.template.name.label')}:
              	</label>
              </th>
              <td width="83%">
                <div class="common_txtbox_wrap">
                  <input id="subject" type="text" readonly="readonly"/>
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="margin_r_10" for="text">
              		<%-- 模板文件 --%>
              		${ctp:i18n('seeyonreport.report.template.file.label')}:
              	</label>
              </th>
              <td>
              	  <div class="common_txtbox_wrap">
                  	  <input type="text" name="cptFiledir" id="cptFiledir" readonly="readonly" />
              	 </div> 
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="margin_r_10" for="text">
              		<%-- 排序号 --%>
              		${ctp:i18n('seeyonreport.report.template.newcategory.sortnumber.label')}:
              	</label>
              </th>
              <td>
                <div class="common_txtbox_wrap">
                  <input id="sort" type="text" readonly="readonly"/>
                </div>
              </td>
            </tr>

            <tr>
              <th noWrap="nowrap" valign="top">
              	<label class="margin_r_10" for="text">
              		<%-- 系统条件设置 --%>
              		${ctp:i18n('seeyonreport.report.template.system.conditon.label')}:
              	</label>
              </th>
              <td>
                <div class="common_txtbox clearfix">
                	<textarea id="systemCondition" class="w100b" cols="30" style="height:120px;" readonly="readonly"></textarea>
                </div>
              </td>
            </tr>
            <tr id="authTd">
              <th noWrap="nowrap">
              	<label class="margin_r_10" for="text">
              		<%-- 授权 --%>
              		${ctp:i18n('seeyonreport.report.template.newcategory.authorization.label')}:
              	</label>
              </th>
              <td>
                <div class="common_txtbox clearfix">
                  <textarea id="auth" cols="30" class="w100b" readonly="readonly"/></textarea>
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap" valign="top">
              	<label class="margin_r_10" for="text">
              		<%-- 描述 --%>
              		${ctp:i18n('seeyonreport.report.template.newcategory.describe.label')}:
              	</label>
              </th>
              <td id="descriptionTd">
                <div id="descriptionDiv" class="common_txtbox clearfix">
                  <textarea id="description" cols="30" class="w100b" style="height:120px;" readonly="readonly"></textarea>
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