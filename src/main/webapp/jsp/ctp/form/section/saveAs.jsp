<%--
 $Author:$
 $Rev:$
 $Date:: $:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
    <head>
        <title>Insert title here</title>
        <script type="text/javascript">
        function OK(){
          var obj = {};
          if ($("#saveAsNameDIV").validate()){
            obj.success = true;
            obj.value = $("#saveAsName").val();
          } else {
            obj.success = false;
          }
          return obj;
        }
        </script>
    </head>
    <body>
        <div id = "saveAsNameDIV" class="clearfix form_area margin_t_5 margin_l_5">
            <label class="margin_r_10 left" for="text">${ctp:i18n('formsection.config.name.label')}:</label>
            <div class="common_txtbox_wrap left" style="width:170px;">
                <input class="validate" id="saveAsName" name="saveAsName" value="" style="width:150px;" type="text" validate="name:'${ctp:i18n('formsection.config.name.label')}',type:'string',notNull:true,notNullWithoutTrim:true,maxLength:255,errorMsg:'${ctp:i18n('formsection.config.name.error')}'"/>
            </div>
        </div>
    </body>
</html>