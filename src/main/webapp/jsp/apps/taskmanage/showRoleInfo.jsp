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
        var defaultVal = "1,2,3";//默认值
        $(document).ready(function(){
          var pv = getA8Top().paramValue;
          var params = "";
          if(pv != null && pv.length > 0){
            params = pv.split(",");
          }else{
            params = defaultVal.split(",");
          }
          
          var roleVal = $("[name=ManagerList]");
          for(var j = 0;j < params.length;j ++){
            for(var k = 0;k < roleVal.length;k ++){
              if(params[j] == roleVal[k].value){
                roleVal[k].checked = true;
              }
            }
          }
          
        });
        
        
        function OK(){
         var rvArr = new Array();
         var array = new Array();
         
         var roleVal = "";//被选中的角色值
         
         $("[name=ManagerList]").each(function(){
           if(this.checked == true){
             roleVal += this.value+",";
           }
         });
         array[0] = roleVal;
         rvArr[0] = array;
         return rvArr;
        }
        
        
        function checkRole(objs){
          var i = 0;
          $("[name=ManagerList]").each(function(){
            if(this.checked == false){
              i ++;
            }
          });
          if(i == 3){
            alert("${ctp:i18n('taskmanage.alert.one_must')}");
            objs.checked = true;
          }
        }
        
        </script>
    </head>
    <body style="height:96%">
        <table style="font-size:12px;width:98%; height:100%;padding-top: 10px;padding-left: 10px">
            <tr style="line-height: 20px">
                <td width="15%">${ctp:i18n("taskmanage.role.label")}：</td>
                <td width="85%"><input type="checkbox" name="ManagerList" id="ManagerId" value="1" onclick="checkRole(this);">${ctp:i18n("taskmanage.manager")}</td>
            </tr>
            <tr style="line-height: 20px">
                <td width="15%"></td>
                <td width="85%"><input type="checkbox" name="ManagerList" id="ParticipatorId" value="2" onclick="checkRole(this);">${ctp:i18n("taskmanage.participator")}</td>
            </tr>
            <tr style="line-height: 20px">
                <td width="15%"></td>
                <td width="85%"><input type="checkbox" name="ManagerList" id="inspectorId" value="3" onclick="checkRole(this);">${ctp:i18n("taskmanage.inspector")}</td>
            </tr>
        </table>
    </body>
</html>