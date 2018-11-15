<%@ page import="java.util.Map"%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/view/operationcenter/i18n/modifyi18n_js.jsp"%>
<html>
<head>
<title></title>
</head>
<body>
  <div>
    <div>
          <form id="myfrm" name="myfrm" method="post">
          <div class="form_area" id='form_area'>
          <input type="hidden" id="key" />
            <table border="0" cellspacing="0" cellpadding="0" class="margin_lr_10 margin_t_10" align="center" width="330">
              <tr>
                <th width="100px"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('i18nresource.chinese.info')}:</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" id="cnValue" class="validate"
                      validate="type:'string',name:'${ctp:i18n('i18nresource.chinese.info')}',notNull:true,maxLength:500,avoidChar:'!@#$%^&amp;*+|,'"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('i18nresource.english.info')}:</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" id="enValue" class="validate" validate="type:'string',name:'${ctp:i18n('i18nresource.english.info')}',notNull:true,maxLength:500,avoidChar:'!@#$%^&amp;*+|,'"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('i18nresource.taiwan.info')}:</label></th>
                <td>
                  <div class="common_txtbox_wrap">
                    <input type="text" id="twValue"  class="validate" validate="type:'string',name:'${ctp:i18n('i18nresource.taiwan.info')}',notNull:true,maxLength:500"/>
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