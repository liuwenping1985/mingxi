<%@ page import="java.util.Map"%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/common/signin/signinset_js.jsp"%>
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
          <input type="hidden" id="sort" />
          <table border="0" cellspacing="0" cellpadding="0" class="margin_lr_10 margin_t_10" align="center" width="330">
               <tr>
                <th width="80px"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('signinmanage.application.name')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" id="name_signin" class="validate"
                      validate="type:'string',name:'${ctp:i18n('signinmanage.application.name')}',notNull:true,maxLength:50,avoidChar:'!@#$%^&amp;*+|,'"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th width="80px"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('signinmanage.application.parameter')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" id="param_signin" class="validate"
                      validate="type:'string',name:'${ctp:i18n('signinmanage.application.parameter')}',notNull:true,maxLength:50,avoidChar:'!@#$%^&amp;*+|,'"/>
                  </div>
                </td>
              </tr>
             <tr>
                <th width="80px"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('signinmanage.application.checkconnection')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" id="urlcheck_signin" class="validate"
                      validate="type:'string',name:'${ctp:i18n('signinmanage.application.checkconnection')}',notNull:true,maxLength:50,avoidChar:'!@#$%^&amp;*+|,'"/>
                  </div>
                </td>
              </tr>
             <tr>
                <th width="80px"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('signinmanage.application.targetconnection')}</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" id="targetUrl_signin" class="validate"
                      validate="type:'string',name:'${ctp:i18n('signinmanage.application.targetconnection')}',notNull:true,maxLength:5000,avoidChar:'!@#^;*+|,'"/>
                  </div>
                </td>
              </tr>
               <tr>
                <th><label class="margin_r_10" for="text">${ctp:i18n('signinmanage.application.poppage')}</label></th>
                <td>
                  <div class="common_txtbox clearfix">
                    <input type="radio" id="OpenTypeOk" name="OpenTypeOk" value="1"
                      checked="true">${ctp:i18n('signinmanage.application.yes')}<input type="radio" id="OpenTypeNo"
                      name="OpenTypeNo" value="0">${ctp:i18n('signinmanage.application.no')}
                  </div>
                </td>
              </tr>
           </table>
            </div> 
             </form>
    </div>  
  </div>
</body>
</html>