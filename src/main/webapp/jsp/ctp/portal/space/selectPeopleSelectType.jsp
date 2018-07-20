<%--
 $Author: zhout $
 $Rev: 5643 $
 $Date:: 2012-10-18 18:45:15#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>选择选人组件选择类型</title>
<script>
$(document).ready(function(){
  var showValue = $("#showValue").val();
  if(showValue!=null&&showValue!=""){
    $.each($(":checkbox", $("#typesTable")),function(i,obj){
      if(showValue.indexOf($(obj).val())>=0){
        $(obj).attr("checked",true);
      }
    });
  }
});
function OK() {
  var checkedIds = $("input:checked", $("#typesTable"));
  if (checkedIds.size() == 0) {
    alert("请选择1个页签！");
    return null;
  }else{
    var typeStr = "";
    var typeTxt = "";
    for(var i=0; i<checkedIds.size();i++){
      var typeId = $(checkedIds[i]).attr("value");
      var typeVal = $("#"+typeId).text();
      if(i==checkedIds.size()-1){
        typeStr += typeId;
        typeTxt += typeVal;
      }else{
        typeStr += typeId+",";
        typeTxt += typeVal+",";
      }
    }
    var returnVal = [];
    returnVal[0] = typeStr;
    returnVal[1] = typeTxt;
    return returnVal;
  } 
}

function selectPeoplePanelCheckAllOnclickHandler(){
  var checked = $("#selectPeoplePanelCheckAll").attr("checked");
  if(checked == "checked"){
    $("#typesTable").find("tbody").find("input[type=checkbox]").attr("checked", true);
  } else {
    $("#typesTable").find("tbody").find("input[type=checkbox]").attr("checked", false);
  }
}
</script>
</head>
<body>
    <input type="hidden" id="showValue" value="${securityModel.showValue}">
    <table id="typesTable" class="only_table edit_table no_border" border="0" cellspacing="0" cellpadding="0" width="100%">
        <thead>
            <tr>
                <th width="20"><input id="selectPeoplePanelCheckAll" type="checkbox" onclick="selectPeoplePanelCheckAllOnclickHandler()" /></th>
                <th>选人组件页签</th>
            </tr>
        </thead>
        <tbody>
        <!-- 
                          与Constants中的SelectPeopleSelectType枚举同步
        Account,//单位
        Department,//部门
        Team,//组
        Post,//岗位
        Level,//职级
        Role,//角色
        Outworker,//外部人员
        Member,//人员
         -->
            <tr class="erow">
                <td><input type="checkbox" value="Account"/></td>
                <td id="Account">${ctp:i18n('org.account.label')}</td>
            </tr>
            <tr class="erow">
                <td><input type="checkbox" value="Department"/></td>
                <td id="Department">${ctp:i18n('org.department.label')}</td>
            </tr>
            <tr class="erow">
                <td><input type="checkbox" value="Post"/></td>
                <td id="Post">${ctp:i18n('org.post.label')}</td>
            </tr>
            <tr class="erow">
                <td><input type="checkbox" value="Level"/></td>
                <td id="Level">${ctp:i18n('org.level.label')}</td>
            </tr>
            <tr class="erow">
                <td><input type="checkbox" value="Team"/></td>
                <td id="Team">${ctp:i18n('org.team.label')}</td>
            </tr>
            <tr class="erow">
                <td><input type="checkbox" value="Role"/></td>
                <td id="Role">${ctp:i18n('org.role.label')}</td>
            </tr>
            <tr class="erow">
                <td><input type="checkbox" value="Outworker"/></td>
                <td id="Outworker">${ctp:i18n('org.outworker.label')}</td>
            </tr>
            <tr class="erow">
                <td><input type="checkbox" value="Member"/></td>
                <td id="Member">${ctp:i18n('org.member.label')}</td>
            </tr>
        </tbody>
    </table>
</body>
</html>