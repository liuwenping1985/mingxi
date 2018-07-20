<%--
 $Author: sunzhemin $
 $Rev: 50789 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page import="com.seeyon.ctp.privilege.enums.CustomResourceCategoryEnums"%>
<%@ page import="java.util.Map"%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/organization/role/roleNew_js.jsp"%>
<html>
<head>
<title></title>
</head>
<body>
  <div>
    <div>
      
          <form id="myfrm" name="myfrm" method="post">
          <div class="form_area" id='form_area'>
            <input type="hidden" id="id" />
            <input type="hidden" id="accountId" /> 
            <input type="hidden" id="isBenchmark" />          
            <table border="0" cellspacing="0" cellpadding="0" class="margin_lr_10 margin_t_10" align="center" width="330">
              <tr>
                <th width="80" nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('role.name')}</label></th>
                <td width="240">
                  <div class="common_txtbox_wrap">
                    <input type="text" id="name" class="validate"
                      validate="type:'string',name:'${ctp:i18n('role.name')}',notNull:true,minLength:2,maxLength:100,avoidChar:'!@#$%^&amp;*+|,'"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th width="80"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('role.code')}</label></th>
                <td width="240">
                  <div class="common_txtbox_wrap">
                    <input type="text" id="code" class="validate" validate="type:'string',name:'${ctp:i18n('role.code')}',notNull:true,maxLength:100"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th width="80"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('role.display.serial.number')}</label></th>
                <td width="240">
                  <div class="common_txtbox_wrap">
                    <input type="text" id="sortId" class="validate"
                      validate="type:'number',isInteger:true,name:'${ctp:i18n('common.sort.label')}',notNull:true,minValue:1,minLength:1,maxValue:99999"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th width="80"><label class="margin_r_10" for="text">${ctp:i18n('role.state')}</label></th>
                <td width="240"> 
                  <div class="common_txtbox clearfix">
                    <input type="radio" id="enable" name="enable" value="1"
                      checked="true">${ctp:i18n('role.start')}<input type="radio" id="enable"
                      name="enable" value="0">${ctp:i18n('role.stop')}
                  </div>
                </td>
              </tr>
              <c:if test="${v3x:getSysFlagByName('hr_notShow')!='true'}">
	              <tr id="categorydiv">
	                <th width="80"><label class="margin_r_10" for="text">${ctp:i18n('role.allowapp')}</label></th>
	                <td width="240">
	                  <div  class="common_txtbox clearfix">
	                    <input type="radio" id="category" name="category" value="1"
	                      checked="true">${ctp:i18n('privilege.resource.true.label')}<input type="radio" id="category"
	                      name="category" value="0">${ctp:i18n('privilege.resource.false.label')}
	                  </div>
	                </td>
	              </tr>
              </c:if>
              <tr id="statusdiv">
                <th width="80"><label class="margin_r_10" for="text">${ctp:i18n('role.allowselectpeople')}</label></th>
                <td width="240">
                  <div  class="common_txtbox clearfix">
                    <input type="radio" id="status" name="status" value="1"
                      checked="true">${ctp:i18n('privilege.resource.true.label')}<input type="radio" id="status"
                      name="status" value="0">${ctp:i18n('privilege.resource.false.label')}
                  </div>
                </td>
              </tr>
              <tr style="display: none;">
                <th width="80"><label class="margin_r_10" for="text"></label></th>
                <td width="240">
                  <div class="common_txtbox clearfix">
                    <input type="text" id="type"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th width="80"><label class="margin_r_10" for="text">${ctp:i18n('role.type.bond')}</label></th>
                <td width="240">
                  <div class="common_txtbox  clearfix">
                    <select id="bond" name="bond">
                      <c:if test="${CurrentUser.groupAdmin==true}">
                      <option value="0">${ctp:i18n('role.group')}</option>
                      </c:if>
                      <option value="1">${ctp:i18n('role.unit')}</option>
                      <option value="2">${ctp:i18n('role.dept')}</option>
                    </select>
                  </div>
                </td>
              </tr>
              <tr>
                <th width="80"><label class="margin_r_10" for="text">${ctp:i18n('role.description')}</label></th>
                <td width="240">
                  <div class="common_txtbox  clearfix">
                    <textarea cols="30" rows="5" id="description" class="w100b validate word_break_all"
                      validate="type:'string',name:'角色说明',maxLength:500"></textarea>
                  </div>
                </td>
              </tr>
              <tr height="5px">
              </tr>
              <c:if test="${v3x:getSysFlagByName('hr_notShow')!='true'}">
	              <tr id="frontdescription" valign="bottom" height="20px">
	                  <td colspan="4" class="description-lable margin_t_10"><font color="red">${ctp:i18n('role.frontdescription')}</font></td>
	              </tr>
              </c:if>
            </table>
            
            </div>
          </form>
        
    </div>
  </div>
</body>
</html>