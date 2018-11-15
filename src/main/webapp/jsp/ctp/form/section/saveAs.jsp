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
          if ($("#saveAsNameDIV").validate({errorAlert:true,errorIcon:false})){
              var name = $("#saveAsName").val();
              if(getTextLength(name)>255){
                  obj.success = false;
                  var label = "${ctp:i18n('formsection.config.name.show')}";
                  $.alert(label+"超过允许的最大长度255（1个汉字算3个字符）！");
              }else{
                  obj.success = true;
                  obj.value = name;
              }
          } else {
            obj.success = false;
          }
          return obj;
        }
        //获取字符串长度；中文算3个字符
        function getTextLength(value){
            if(value==null||value==""){
                return 0;
            }else{
                var result = 0;
                for(var i=0, len=value.length; i<len; i++){
                    var ch = value.charCodeAt(i);
                    if(ch<256){
                        result++;
                    }else{
                        result +=3;
                    }
                }
                return result;
            }
        }
        </script>
    </head>
    <body>
        <div id = "saveAsNameDIV" class="clearfix form_area margin_t_5 margin_l_5">
            <label class="margin_r_10 left" for="text">${ctp:i18n('formsection.config.name.show')}:</label>
            <div class="common_txtbox_wrap left" style="width:170px;">
                <input class="validate" id="saveAsName" name="saveAsName" value="" style="width:150px;" type="text" validate="name:'${ctp:i18n('formsection.config.name.show')}',type:'string',notNull:true,notNullWithoutTrim:true"/>
            </div>
        </div>
    </body>
</html>