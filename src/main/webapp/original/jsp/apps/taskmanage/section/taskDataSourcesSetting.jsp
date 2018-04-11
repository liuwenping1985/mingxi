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
<html class="h100b">
<head>
<title>${ctp:i18n("taskmanage.task_source.label")}</title>
</head>
<body style="height:96%">
  <table class="margin_l_10" style="font-size:14px;width:95%;">
    <%--重要程度--%> 
    <tr>
    <td colspan="4" class="padding_t_15">${ctp:i18n("common.importance.label")}:</td>
    </tr>
    <tr>
      <c:forEach var="list" items="${importantLevelEnums }" varStatus="status">
        <c:choose>
          <c:when test="${status.last}">
            <td colspan="2"><input type="checkbox" name="checkboxImportance" value="${list.key}" onclick="checkNotNull(this);">${list.text}</td>
          </c:when>
          <c:otherwise>
            <td><input type="checkbox" name="checkboxImportance" value="${list.key}" onclick="checkNotNull(this);">${list.text}</td>
          </c:otherwise>
        </c:choose>
      </c:forEach>
    </tr>
    <%--任务状态--%>
    <tr>
    <td colspan="4" class="padding_t_15">${ctp:i18n("taskmanage.status")}:</td>
    </tr>
    <tr >
      <c:forEach var="se" items="${statusEnums }">
        <td><input type="checkbox" name="checkboxState" value="${se.key }" onclick="checkNotNull(this);">${se.text}</td>
      </c:forEach>
    </tr>
	<%--是否超期--%>
	<tr>
	<td colspan="4" class="padding_t_15">${ctp:i18n("taskmanage.overdue")}:</td>
	</tr>
	<tr>
      <td colspan="1"><input type="checkbox" name="checkboxOverdue" value="1" onclick="checkNotNull(this)">${ctp:i18n("taskmanage.overdue.yes")}</td>
      <td colspan="3"><input type="checkbox" name="checkboxOverdue" value="0" onclick="checkNotNull(this)">${ctp:i18n("taskmanage.overdue.no")}</td>
    </tr>
    <%--风险--%>
    <tr>
    <td colspan="4" class="padding_t_15">${ctp:i18n("taskmanage.risk")}:</td>
    </tr>
    <tr>
      <c:forEach var="re" items="${riskEnums }">
        <td><input type="checkbox" name="checkboxRisk" value="${re.key }" onclick="checkNotNull(this);">${re.text}</td>
      </c:forEach>
    </tr>
    <%--里程碑--%>
    <tr>
    <td colspan="4" class="padding_t_15">${ctp:i18n("taskmanage.milestone.label")}:</td>
    </tr> 
    <tr>
      <td colspan="2"><input type="checkbox" name="checkboxMilestone" value="1" onclick="checkNotNull(this)">${ctp:i18n("taskmanage.mark.milestone.label")}</td>
      <td colspan="2"><input type="checkbox" name="checkboxMilestone" value="0" onclick="checkNotNull(this)">${ctp:i18n("taskmanage.not_marked.milestone")}</td>
    </tr>
  </table>

<%--脚本放最后，提高页面渲染速度--%>
<script type="text/javascript">
  $(document).ready(function() {
    //V5.6新功能：默认值增加“是否超期”，默认两个全选
    var defaultOverdue = "overdue=0,1&,";
    <c:choose>
    <c:when test="${informFlag == 1}">
    var defaultVal = "important=1,2,3&,state=1,2,4&,risk=0,1,2,3&,milestion=0,1&,"+defaultOverdue;
    </c:when>
    <c:otherwise>
    var defaultVal = "important=1,2,3&,state=1,2&,risk=0,1,2,3&,milestion=0,1&,"+defaultOverdue;
    </c:otherwise>
  </c:choose>
    var pv = getA8Top().paramValue;
    var params = "";
    if (pv != null && pv.length > 0) {
      //升级防护：是否超期字段是V5.6新增的，旧版本是没有这个字段，所以要判断防护
      if(pv.indexOf("overdue=") == -1){
        pv = pv + defaultOverdue;
      }
      params = pv.split("&,");
    } else {
      params = defaultVal.split("&,");
    }
    var important = params[0].substring(10, params[0].length);
    var state = params[1].substring(6, params[1].length);
    var risk = params[2].substring(5, params[2].length);
    var milestion = params[3].substring(10, params[3].length);
	var overdue = params[4].substring(8, params[4].length);
	
    var importants = important.split(",");
    var states = state.split(",");
    var risks = risk.split(",");
    var milestions = milestion.split(",");
	var overdues = overdue.split(",");
	
	initCheckboxValue($("[name=checkboxImportance]"),importants);
	initCheckboxValue($("[name=checkboxState]"),states);
	initCheckboxValue($("[name=checkboxRisk]"),risks);
	initCheckboxValue($("[name=checkboxMilestone]"),milestions);
    initCheckboxValue($("[name=checkboxOverdue]"),overdues);
  });
  
  /**
  *回填多选框数据
  */
  function initCheckboxValue(checkboxDom,domValue){
    $(checkboxDom).each(function() {
      for(var i = 0;i < domValue.length; i++){
        if(this.value == domValue[i]){
          this.checked = true;
        }
      }
    });
  }

  /**
  *检查多选项不能为空，若为空则提示并自动勾选该项
  *@clickDom 点击项
  **/
  function checkNotNull(clickDom){
    //检查是否有一项被选择
    var hasChecked = false;
    $("input[name="+clickDom.name+"]").each(function() {
      if (this.checked == true) {
        hasChecked = true;
      }
    });
    //如果一项都未选择，弹出提示并默认勾选
    if (!hasChecked) {
      alert("${ctp:i18n('taskmanage.alert.one_must')}");
      clickDom.checked = true;
    }
  }

  function OK() {
    var rvArr = new Array();
    var array = new Array();

    var important = getCheckboxValues($("[name=checkboxImportance]"));//重要程度
    var state     = getCheckboxValues($("[name=checkboxState]"));//状态
    var risk      = getCheckboxValues($("[name=checkboxRisk]"));//风险
    var milestone = getCheckboxValues($("[name=checkboxMilestone]"));//里程碑
    var overdue   = getCheckboxValues($("[name=checkboxOverdue]"));//是否超期
	
    var importants = important.substring(0, important.length - 1);
    var states     = state.substring(0, state.length - 1);
    var risks      = risk.substring(0, risk.length - 1);
    var milestones = milestone.substring(0, milestone.length - 1);
    var overdues   = overdue.substring(0, overdue.length - 1);
    
    array[0] = "important=" + importants + "&";
    array[1] = "state=" + states + "&";
    array[2] = "risk=" + risks + "&";
    array[3] = "milestone=" + milestones + "&";
    array[4] = "overdue=" + overdues + "&,";
    rvArr[0] = array;
    return rvArr;
  }
  
  /**
  *获取多选项被选中的值，返回字符串，多项用逗号区隔
  */
  function getCheckboxValues(checkboxDom){
    var checkedValues = "";
    $(checkboxDom).each(function() {
      if (this.checked == true) {
        checkedValues += this.value + ",";
      }
    });
    return checkedValues;
  }
    
</script>

</body>
</html>