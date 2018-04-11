<%--
 $Author: zhaifeng $
 $Rev: 509 $
 $Date:: 2015-01-09 #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%-- 布局设置 --%>
<title>${ctp:i18n('form.bizmap.layout.setting.label')}</title>
<script type="text/javascript"
  src="${path}/common/form/bizmap/layoutSet.js${ctp:resSuffix()}"></script>
</head>
<body class="h100b">
  <div class="form_area margin_10">
    <form id="layoutSetId">
      <table border="0" cellSpacing="0" cellPadding="0" width="100%">
        <tbody>
          <tr>
            <th noWrap="nowrap">
              <%-- 导图名称 --%> <label class="margin_r_10" for="text"><span
                class="required">*</span>${ctp:i18n('form.bizmap.set.name.label')}:</label>
            </th>
            <td width="100%">
              <div class="common_txtbox_wrap">
                <input type="text" id="name" class="validate"
                  validate="name:'${ctp:i18n("form.bizmap.set.name.label")}',type:'string',maxLength:20,minLength:2,notNull:true,avoidChar:'\\\|\&\<\>\''">
              </div>
            </td>
          </tr>
          <tr>
            <th noWrap="nowrap">
              <%-- 展现位置 --%> <label class="margin_r_10" for="text">${ctp:i18n('form.bizmap.show.location.label')}:</label>
            </th>
            <td>
              <fieldset class="margin_t_10">
                <legend>
                  <label for="workspace" class="margin_r_10 hand"> <%-- 工作区 --%>
                    <input type="radio" value="1" id="workspace"
                    name="radioName" class="radio_com">${ctp:i18n('form.bizmap.workspace.label')}</label>
                </legend>
                <div class="common_checkbox_box clearfix " align="center">
                  <label for="workspace_1" class="margin_r_10 hand"> <%-- 一级菜单 --%>
                    <input type="checkbox" value="0" id="workspace_1"
                    name="option" class="radio_com">${ctp:i18n('form.bizmap.workspace.menu1.label')}</label>
                  <c:if test = "${ctp:hasPlugin('formBiz') }">
                     <label for="workspace_2" class="margin_r_10 hand"> <%-- 二级菜单 --%>
                        <input type="checkbox" value="1" id="workspace_2"
                            name="option" class="radio_com">${ctp:i18n('form.bizmap.workspace.menu2.label')}</label>
                   </c:if>
                </div>
              </fieldset>
            </td>
          </tr>
          <tr>
            <th noWrap="nowrap"></th>
            <td>
              <fieldset class="margin_t_10">
                <legend>
                  <label for="portal" class="margin_r_10 hand"> <%-- 栏目 --%>
                    <input type="radio" value="2" id="portal" name="radioName"
                    class="radio_com">${ctp:i18n('form.bizmap.portal.label')}</label>
                </legend>
                <div class="form_area relative margin_10">
                  <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr align="center" height="120px">
                      <td id="image1">
                        <div class="bizMap_layout bizMap_layout_1"></div>
                      </td>
                      <td id="image2">
                        <div class="bizMap_layout bizMap_layout_2"></div>
                      </td>
                      <td id="image3">
                        <div class="bizMap_layout bizMap_layout_3"></div>
                      </td>
                    </tr>
                    <tr align="center">
                      <td class="padding_tb_5"><input type="radio"
                        value="1" id="portal_1" name="radioPortal"
                        class="radio_com"></td>
                      <td class="padding_tb_5"><input type="radio"
                        value="2" id="portal_2" name="radioPortal"
                        class="radio_com"></td>
                      <td class="padding_tb_5"><input type="radio"
                        value="3" id="portal_3" name="radioPortal"
                        class="radio_com"></td>
                    </tr>
                    <tr align="center">
                      <%-- 选择图片宽度 --%>
                      <td colspan="3" class="padding_tb_5">${ctp:i18n('form.bizmap.portal.image.width.label')}</td>
                    </tr>
                  </table>
                </div>
              </fieldset>
            </td>
          </tr>
        </tbody>
      </table>
    </form>
  </div>
</body>
</html>