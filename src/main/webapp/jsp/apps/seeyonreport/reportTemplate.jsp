<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${path}/common/seeyonreport/reportTemplate.js${ctp:resSuffix()}"></script>
<title></title>
<script>
  $(function() {
	  
	  //定义模板文件点击事件，弹出cpt文件选择
	  $("#cptFiledirBtn").click(function(){
		  getCptFileFun($("#cptFiledir").val());
	  });
	  
	  //定义授权点击事件
	  $("#selectMember").click(function(){
		  authReportTemplate();
	  });
	  
	  //系统条件设置
	  $("#systemCondtionBtn").click(function(){
		  systemCondtionSet();
	  });
	 
	  //系统条件设置重置
	  $("#systemCondtionReset").click(function(){
		  systemCondtionReset();
	  });
  });
  
  
</script>
</head>

<body scroll="no">
  <form id="reportTemplateForm">
  	<!-- 模板分类ID -->
  	<input type="hidden" id="categoryId" name="categoryId" value="${categoryId}"> 
  	<!-- 模板Id，编辑模板时用于校验是否存在同名 -->
  	<input type="hidden" id="id" name="id"> 
    <div class="form_area" id="formArea">
      <div class="one_row">
        <table border="0" cellSpacing="0" cellPadding="0">
          <tbody>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text">
              		<!-- 模板文件 -->
              		${ctp:i18n('seeyonreport.report.template.file.label')}:
              	</label>
              </th>
              <td>
              	  <div class="common_txtbox_wrap">
                  	  <input type="text" class="validate" name="cptFiledir" id="cptFiledir" readonly="readonly" 
                  	  validate="name:'${ctp:i18n('seeyonreport.report.template.file.label')}',isDeaultValue:true,notNull:true,deaultValue:'\<${ctp:i18n('seeyonreport.report.template.newcategory.fillname.label')}\>'" />
              	 </div> 
              </td>
              <td class="padding_l_10">
              	  <!-- 选择 -->
              	  <a href="javascript:void(0)" class="common_button common_button_gray" id="cptFiledirBtn">${ctp:i18n('seeyonreport.report.choose.label')}</a>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text">
              		<!-- 模板名称 -->
              		${ctp:i18n('seeyonreport.report.template.name.label')}:
              	</label>
              </th>
              <td width="83%">
                <div class="common_txtbox_wrap">
                  <input id="subject" type="text" class="validate" maxlength="30"
                    validate="name:'${ctp:i18n('seeyonreport.report.template.name.label')}',maxLength:30,isDeaultValue:true,notNull:true,deaultValue:'\<${ctp:i18n('seeyonreport.report.template.newcategory.fillname.label')}\>'">
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="color_red">*</label>
              	<label class="margin_r_10" for="text">
              		<!-- 排序号 -->
              		${ctp:i18n('seeyonreport.report.template.newcategory.sortnumber.label')}:
              	</label>
              </th>
              <td>
                <div class="common_txtbox_wrap">
                  <input id="sort" type="text" class="validate"
                    validate="name:'${ctp:i18n('seeyonreport.report.template.newcategory.sortnumber.label')}',isInteger:true,notNull:true,max:9999,min:-9999" value="${maxSort}" />
                </div>
              </td>
            </tr>

            <tr>
              <th noWrap="nowrap" valign="top">
              	<label class="margin_r_10" for="text">
              		<!-- 系统条件设置 -->
              		${ctp:i18n('seeyonreport.report.template.system.conditon.label')}:
              	</label>
              </th>
              <td>
                <div class="common_txtbox clearfix">
                	<textarea id="systemCondition" class="w100b" cols="30" style="height:120px;" readonly="readonly"></textarea>
                	<input type="hidden" id="conditionInfoJson"> 
                	<input type="hidden" id="conditionHtml">
                	
                </div>
              </td>
              <td class="padding_l_10" valign="top">
              	  <!-- 设置 -->
              	  <a href="javascript:void(0)" class="common_button common_button_gray" id="systemCondtionBtn">${ctp:i18n('seeyonreport.report.setting.label')}</a>
              	  <br>
              	  <!-- 重置 -->
              	  <a href="javascript:void(0)" class="common_button common_button_gray margin_t_10" id="systemCondtionReset">${ctp:i18n('seeyonreport.report.setting.clear.label')}</a>
              </td>
            </tr>
            <tr id="authTd">
              <th noWrap="nowrap">
              	<label class="margin_r_10" for="text">
              		<!-- 授权 -->
              		${ctp:i18n('seeyonreport.report.template.newcategory.authorization.label')}:
              	</label>
              </th>
              <td>
                <div class="common_txtbox_wrap">
                  <input type="text" id="auth" readonly="readonly"/>
                  <input type="hidden" id="authValue"/>
                </div>
              </td>
              <td class="padding_l_10">
              	  <!-- 设置 -->
              	  <a href="javascript:void(0)" class="common_button common_button_gray" id="selectMember">${ctp:i18n('seeyonreport.report.setting.label')}</a>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap" valign="top">
              	<label class="margin_r_10" for="text">
              		<!-- 描述 -->
              		${ctp:i18n('seeyonreport.report.template.newcategory.describe.label')}:
              	</label>
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
</html>