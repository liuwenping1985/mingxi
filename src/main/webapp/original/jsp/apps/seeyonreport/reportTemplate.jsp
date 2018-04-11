<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/select2.js.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>报表模板-新建</title>
</head>
<body>
  <form id="reportTemplateForm">
  	<%-- 模板分类ID --%>
  	<input type="hidden" id="categoryId" name="categoryId" value="${categoryId}"> 
  	<%-- 模板Id，编辑模板时用于校验是否存在同名 --%>
  	<input type="hidden" id="id" name="id"> 
    <div class="form_area" id="formArea">
      <div class="one_row">
        <table border="0" cellSpacing="0" cellPadding="0">
          <tbody>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<%-- 模板文件 --%>
              	<label class="margin_r_10" for="text">${ctp:i18n('seeyonreport.report.template.file.label')}:</label>
              </th>
              <td>
              	  <div class="common_txtbox_wrap">
                  	  <input type="text" class="validate" name="cptFiledir" id="cptFiledir" readonly="readonly" validate="name:'${ctp:i18n('seeyonreport.report.template.file.label')}',isDeaultValue:true,notNull:true,deaultValue:'\<${ctp:i18n('seeyonreport.report.template.newcategory.fillname.label')}\>'" />
              	 </div> 
              </td>
              <td class="padding_l_10">
              	  <%-- 选择 --%>
              	  <a href="javascript:void(0);" class="common_button common_button_gray" id="cptFiledirBtn">${ctp:i18n('seeyonreport.report.choose.label')}</a>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<%-- 模板名称 --%>
              	<label class="margin_r_10" for="text">${ctp:i18n('seeyonreport.report.template.name.label')}:</label>
              </th>
              <td width="83%">
                <div class="common_txtbox_wrap">
                  <input id="subject" type="text" class="validate" maxlength="30" validate="name:'${ctp:i18n('seeyonreport.report.template.name.label')}',maxLength:30,isDeaultValue:true,notNull:true,deaultValue:'\<${ctp:i18n('seeyonreport.report.template.newcategory.fillname.label')}\>'">
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<%-- 排序号 --%>
              	<label class="margin_r_10" for="text">${ctp:i18n('seeyonreport.report.template.newcategory.sortnumber.label')}:</label>
              </th>
              <td>
                <div class="common_txtbox_wrap">
                  <input id="sort" type="text" class="validate" validate="name:'${ctp:i18n('seeyonreport.report.template.newcategory.sortnumber.label')}',isInteger:true,notNull:true,max:9999,min:-9999" value="${maxSort}" />
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap" valign="top">
              	<%-- 系统条件设置 --%>
              	<label class="margin_r_10" for="text">${ctp:i18n('seeyonreport.report.template.system.conditon.label')}:</label>
              </th>
              <td>
                <div class="common_txtbox clearfix">
                	<textarea id="systemCondition" class="w100b" cols="30" style="height:120px;" readonly="readonly"></textarea>
                	<input type="hidden" id="conditionInfo"> 
                	<input type="hidden" id="conditionHtml">
                </div>
              </td>
              <td class="padding_l_10" valign="top">
              	  <%-- 设置 --%>
              	  <a href="javascript:void(0)" class="common_button common_button_gray" id="systemCondtionBtn">${ctp:i18n('seeyonreport.report.setting.label')}</a>
              	  <br>
              	  <%-- 重置 --%>
              	  <a href="javascript:void(0)" class="common_button common_button_gray margin_t_10" id="systemCondtionReset">${ctp:i18n('seeyonreport.report.setting.clear.label')}</a>
              </td>
            </tr>
            <tr id="authTd">
              <th noWrap="nowrap">
              	<%-- 授权 --%>
              	<label class="margin_r_10" for="text">${ctp:i18n('seeyonreport.report.template.newcategory.authorization.label')}:</label>
              </th>
              <td>
                <div class="common_txtbox_wrap">
                  <input type="text" id="auth" readonly="readonly"/>
                  <input type="hidden" id="authValue"/>
                </div>
              </td>
              <td class="padding_l_10">
              	  <%-- 设置 --%>
              	  <a href="javascript:void(0)" class="common_button common_button_gray" id="selectMember">${ctp:i18n('seeyonreport.report.setting.label')}</a>
              </td>
            </tr>
            <%--类型 --%>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text">${ctp:i18n("seeyonreport.report.template.type") }:</label>
              </th>
              <td>
                <div class="common_txtbox_wrap" style="border: none">
                  <select id="type" name="type" class="codecfg" codecfg="codeType:'java',codeId:'com.seeyon.apps.seeyonreport.enums.ReportTemplateEnum$TypeEnum'" style="width: 103%;margin-left: -5px;"></select>
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text">${ctp:i18n("seeyonreport.report.template.notice") }:</label>
              </th>
              <td>
                <div class="common_txtbox_wrap" style="border: none"><label style="width: 100%;height: 24px;line-height: 24px;">${ctp:i18n("seeyonreport.report.template.noticeMsg") }</label></div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap" valign="top">
              	<%-- 描述 --%>
              	<label class="margin_r_10" for="text">${ctp:i18n('seeyonreport.report.template.newcategory.describe.label')}:</label>
              </th>
              <td id="descriptionTd">
                <div id="descriptionDiv" class="common_txtbox clearfix">
                  <textarea id="description" class="w100b validate" cols="30" style="height:120px;" validate="name:'${ctp:i18n('seeyonreport.report.template.newcategory.describe.label')}',maxLength:60"></textarea>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </form>
</body>
<script type="text/javascript" src="${path}/common/seeyonreport/reportTemplate.js${ctp:resSuffix()}"></script>
<script>
  $(document).ready(function(){
	  initSelectCtpFileBtn();
	  initSystemConditionBtn();
	  resetSystemConditionBtn();
	  initAuthBtn();
  });
</script>
</html>