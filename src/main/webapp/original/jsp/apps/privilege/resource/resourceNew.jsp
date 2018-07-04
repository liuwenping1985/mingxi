<%--
 $Author: lilong $
 $Rev: 32817 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page import="com.seeyon.ctp.privilege.enums.CustomResourceCategoryEnums"%>
<%@ page import="java.util.Map"%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/privilege/resource/resourceNew_js.jsp"%>
<%
    Map params = (Map) request.getAttribute("ffmyfrm");
    String resourceCategory = null;
    if (params != null) {
        resourceCategory = String.valueOf(params.get("resourceCategory"));
    }
%>
<html>
<head>
<title></title>
</head>
<body>
  <div id='layout' class="comp" comp="type:'layout'">
    <div class="layout_center" id="center" layout="border:false">
      <div class="form_area" id='form_area'>
        <div class="one_row">
          <form id="myfrm" name="myfrm" method="post" action="resource.do?method=save">
            <input type="hidden" id="id" />
            <table class="w80b over_hidden" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <th width="143px"><label class="margin_r_10" for="text">${ctp:i18n('privilege.resource.name.label')}:</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" id="resourceName" class="validate"
                      validate="type:'string',name:'${ctp:i18n('privilege.resource.name.label')}',notNull:true,minLength:2,maxLength:20" />
                  </div>
                </td>
              </tr>
              <tr style="display: none;">
                <th><label class="margin_r_10" for="text">${ctp:i18n('privilege.resource.sort.label')}:</label></th>
                <td><div class="common_txtbox_wrap">
                    <input type="text" id="resourceOrder" class="validate"
                      validate="isInteger:true, maxLength:10, name:'${ctp:i18n('privilege.resource.sort.label')}'" />
                  </div></td>
              </tr>
              <tr>
                <th><label class="margin_r_10" for="text">${ctp:i18n('privilege.resource.code.label')}:</label></th>
                <td><div class="common_txtbox_wrap">
                    <input type="text" id="resourceCode" class="validate"
                      validate="type:'string',name:'${ctp:i18n('privilege.resource.code.label')}',notNull:true" />
                  </div></td>
              </tr>
              <tr>
                <th><label class="margin_r_10" for="text">${ctp:i18n('privilege.resource.appResCategory.label')}:</label></th>
                <td>
                  <div class="common_txtbox clearfix">
                    <select id="ext4" name="ext4" class="codecfg w100b"
                      codecfg="codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.AppResourceCategoryEnums',defaultValue:0">
                    </select>
                  </div>
                </td>
              </tr>
              <tr class="belongTo">
                <th><label class="margin_r_10" for="text">${ctp:i18n('privilege.resource.enterresourcetype.label')}:</label></th>
                <td>
                  <div class="common_txtbox  clearfix">
                    <select id="ext1" name="ext1" class="codecfg w100b"
                      codecfg="codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.ResourceCategoryEnums',defaultValue:0">
                    </select>
                  </div>
                </td>
              </tr>
              <tr class="belongTo">
                <th><label class="margin_r_10" for="text">${ctp:i18n('privilege.resource.belongToRes.label')}:</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" disabled="disabled" id="belongto" /> <input
                      type="hidden" value="0" id="belongtoId" />
                  </div>
                  <input type="button" class="common_button common_button_emphasize" id="belongtoButton" value="${ctp:i18n('privilege.resource.select.label')}" />
                </td>
              </tr>
              <tr style="display: none;">
                <th><label class="margin_r_10" for="text">${ctp:i18n('privilege.resource.resCategory.label')}:</label></th>
                <td>
                  <div class="common_txtbox clearfix">
                    <%
                        if (isDevelop && !CustomResourceCategoryEnums.customfront.getValue().equals(resourceCategory)
                                && !CustomResourceCategoryEnums.customback.getValue().equals(resourceCategory)) {
                    %>
                    <select id="resourceCategory" name="resourceCategory"
                      class="codecfg w100b"
                      codecfg="codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.SystemResourceCategoryEnums',defaultValue:2">
                    </select>
                    <%
                        } else {
                    %>
                    <select id="resourceCategory" name="resourceCategory"
                      class="codecfg w100b"
                      codecfg="codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.CustomResourceCategoryEnums',defaultValue:0">
                    </select>
                    <%
                        }
                    %>
                  </div>
                </td>
              </tr>
              <tr class="belongTo">
                <th><label class="margin_r_10" for="text">${ctp:i18n('privilege.resource.iscontrol.label')}:</label></th>
                <td>
                  <div class="common_txtbox  clearfix">
                    <input type="radio" id="isControl" name="isControl"
                      value="1" checked="true">${ctp:i18n('privilege.resource.true.label')}
                    <input type="radio" id="isControl" name="isControl"
                      value="0">${ctp:i18n('privilege.resource.false.label')}
                  </div>
                </td>
              </tr>
              <tr>
                <th>
                  <label class="margin_r_10" for="text">${ctp:i18n('privilege.resource.devresourcetype.label')}:</label>
                </th>
                <td>
                  <div class="common_txtbox  clearfix">
                    <select id="resourceType" name="resourceType"
                      class="codecfg w100b"
                      codecfg="codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.ResourceTypeEnums',defaultValue:0">
                    </select>
                  </div>
                </td>
              </tr>
              <tr>
                <th><label class="margin_r_10" for="text">所属模块:</label></th>
                <td>
                  <div class="common_txtbox clearfix">
                    <select id="moduleid" name="moduleid"
                      class="codecfg w100b"
                      codecfg="codeType:'java',codeId:'com.seeyon.ctp.common.service.PluginCustomCode'">
                    </select>
                  </div>
                </td>
              </tr> 
              <tr>
                <th><label class="margin_r_10" for="text">是否允许分配:</label></th>
                <td>
                  <div class="common_txtbox clearfix">
                  <input type="radio" id="show" name="show"
                      value="1" checked="true">${ctp:i18n('privilege.resource.true.label')}
                    <input type="radio" id="show" name="show"
                      value="0">${ctp:i18n('privilege.resource.false.label')}
                  </div>
                </td>
              </tr>
              <tr>
                <th><label class="margin_r_10" for="text">${ctp:i18n('privilege.resource.navurl.label')}:</label></th>
                <td><div class="common_txtbox  clearfix">
                    <textarea id="navurl" rows="6"
                      class="w100b validate word_break_all"
                      validate="type:'string',name:'${ctp:i18n('privilege.resource.navurl.label')}',notNull:true,minLength:4,maxLength:200,func:validateUrl"></textarea>
                  </div></td>
              </tr>
              <tr style="display: none;" class="mainRes">
                <th><label class="margin_r_10" for="text">${ctp:i18n('privilege.resource.mainResName.label')}:</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="hidden" id="mainResId" />
                    <input type="text" id="mainResName" readonly="readonly" class="validate" validate="type:'string',name:'${ctp:i18n('privilege.resource.mainResName.label')}',notNull:true" />
                  </div>
                  <input type="button" class="common_button common_button_emphasize" id="mainResButton" value="${ctp:i18n('privilege.resource.select.label')}" /></td>
              </tr>
              
              <tr style="display: none;" class="mainRes">
                <th><label class="margin_r_10" for="text">${ctp:i18n('privilege.resource.mainResUrl.label')}:</label></th>
                <td>
                  <div class="common_txtbox clearfix word_break_all">
                    <textarea rows="6" readonly="readonly"
                      id="mainResUrl" class="w100b validate"
                      validate="type:'string',name:'${ctp:i18n('privilege.resource.mainResUrl.label')}',notNull:true"></textarea>
                  </div>
                </td>
              </tr>
            </table>
          </form>
        </div>
      </div>
    </div>
  </div>
</body>
</html>