<%--
 $Author: wuym $
 $Rev: 1697 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title></title>
    <script>
      $(function(){
        var submitStyle = "${submitStyle}";
        if(submitStyle == "1"){
          $("#checkbox2").attr("checked","checked");
        }else if(submitStyle == "2"){
          $("#checkbox1").attr("checked","checked");
          $("#checkbox2").attr("checked","checked");
        }else {
          $("#checkbox1").attr("checked","checked");
        }
      });
      function OK(){
        if($("input:checked").length == 0){
          $.alert("${ctp:i18n('permission.setting.leastOne')}");
          return;
        }
        var result = "";
        if($("input:checked").length == 2){
          result = "2";
        }else{
          $("input:checked").each(function(index,elem){
            result = $(elem).val();
          });
        }
        return result;
      }
    </script>
</head>
<body>
    <div class="left line_height160 font_size12" style="margin-left: 20px;margin-top: 20px;">
                ${ctp:i18n('permission.setting.subType')}<!-- 回退后被回退节点提交方式 -->：<br>
        <input id="checkbox1" type="checkbox" value="0"></input>&nbsp;&nbsp;<label for="checkbox1">${ctp:i18n('collaboration.appointStepBack.ProcessTheHeavy')}&nbsp;&nbsp;&nbsp;&nbsp;</label>
        <input id="checkbox2" type="checkbox" value="1"></input>&nbsp;&nbsp;<label for="checkbox2">${ctp:i18n('collaboration.appointStepBack.CommitRollback')}</label>
    </div>
</body>
</html>