<%--
 $Author:  jiahl$
 $Rev:  $
 $Date:2014-01-21:#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page import="java.util.Map"%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/usersystem/restUserNew_js.jsp"%>
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
            <input type="hidden" id="createTime" />
            <input type="hidden" id="loginIp" />
            <input type="hidden" id="callType" />
            <input type="hidden" id="type" />
            <input type="hidden" id="resourceAuthority">
            <input type="hidden" id="validationip">
            <table border="0" cellspacing="0" cellpadding="0" class="margin_lr_10 margin_t_10" align="center" width="330">
              <tr>
                <th width="70px"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('usersystem.restUser.userName')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" id="userName" class="validate"
                      validate="type:'string',name:'${ctp:i18n('usersystem.restUser.userName')}',notNull:true,maxLength:50,avoidChar:'!@#$%^&amp;*+|,'"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('usersystem.restUser.loginName')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" id="loginName" class="validate" validate="type:'string',name:'${ctp:i18n('usersystem.restUser.loginName')}',notNull:true,maxLength:50,avoidChar:'!@#$%^&amp;*+|,'"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('usersystem.restUser.passWord')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="password" id="passWord" name="passWord" class="validate" validate="type:'string',name:'${ctp:i18n('usersystem.restUser.passWord')}',notNull:true,minLength:6,maxLength:50"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('usersystem.newpassword.validate')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="password" id="passWord2" name="passWord2" class="validate" validate="type:'string',name:'${ctp:i18n('usersystem.newpassword.validate')}',notNull:true,minLength:6,maxLength:50"/>
                  </div>
                </td>
              </tr>
 
              <tr>
                <th><label class="margin_r_10" for="text">${ctp:i18n('usersystem.restUser.enable')}</label></th>
                <td>
                  <div class="common_txtbox clearfix">
                    <input type="radio" id="enable" name="enable" value="1"
                      checked="true">${ctp:i18n('usersystem.restUser.enabled')} <input type="radio" id="enable"
                      name="enable" value="0">${ctp:i18n('usersystem.restUser.unenabled')}
                  </div>
                </td>
              </tr>
              
              <tr>
                <th><label class="margin_r_10" for="text">${ctp:i18n('usersystem.restUser.order')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" id="userOrder"name="userOrder" class="validate" validate="type:'number',isInteger:true,name:'${ctp:i18n('usersystem.restUser.order')}',minValue:1,minLength:1,maxValue:99999"/>
                  </div>
                </td>
              </tr> 
              
                <tr>
                <th><label class="margin_r_10" for="text">${ctp:i18n('usersystem.restUser.loginIp')}</label></th>
                <td>
                  <div class="text_overflow noClick">
                    <input type="checkbox" id="checkip" name="checkip" /> ${ctp:i18n('usersystem.restUser.description')}
                  </div>
                </td>
              </tr> 
            </table> 
            </div> 
             </form>

          <div class="form_area">
          <table border="0" cellspacing="0" cellpadding="0" class="margin_lr_10 margin_t_10" align="center" width="330">
             <tr>
                <th valign="top" width="70"><label class="margin_r_10" for="text">${ctp:i18n('usersystem.restUser.bindip')}</label></th>
                <td>
                  <div class="common_txtbox clearfix" id="ipinput">
                     <input type="text" id="ip" name="ip" class="validate" validate="type:'string',name:'${ctp:i18n('usersystem.restUser.loginIp')}',notNull:true,maxLength:30"/><a id="add" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('usersystem.restUser.add')} </a><br/>
                  </div>
                </td>
              </tr>  
        </table>
        </div>
    </div>  
  </div>
</body>
</html>