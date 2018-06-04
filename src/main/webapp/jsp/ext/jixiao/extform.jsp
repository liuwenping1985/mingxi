<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
 <head> 
  <title>测试</title> 
  <script> 
      function OK(){
          // 通过window.dialogArguments可以调用父窗口的方法，变量等，例如window.dialogArguments.$('#field0013')
          // 使用dataValue回填
          return  {dataValue:$("#unselect").val()};
      }
  </script> 
 </head>
 <body>
  <div style="height: 40px;">
    &nbsp; 
  </div> 
  <table class="margin_t_5 margin_l_5 font_size12" align="center" width="380" height="70%" style="table-layout:fixed;"> 
   <tbody> 
    <tr height="310"> 
     <td valign="top" width="260" height="100%"> <p align="left" class="margin_b_5">选择银行</p> 
     <select class="w100b" style="width:260px;height: 300px;" size="20" multiple="" id="unselect"> <option value="中国央行">中国央行</option> <option value="瑞士央行">瑞士央行</option> <option value="法国央行">法国央行</option> </select> </td> 
    </tr> 
    <tr height="310"> 
     <td> <a id="tableSubmit" class="common_button common_button_gray margin_5" href="javascript:void(0)">${ctp:i18n("common.button.ok.label")}</a> <a class="common_button common_button_gray margin_5" id="cancel" href="javascript:void(0)">${ctp:i18n("common.toolbar.cancelmt.label")}</a></td> 
    </tr> 
   </tbody> 
  </table>  
 </body>
</html>