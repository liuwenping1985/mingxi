<%@page import="com.seeyon.ctp.organization.OrgConstants"%>
<%@page import="com.seeyon.ctp.organization.bo.V3xOrgEntity"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%-- 组织模型分支条件设置 --%></title>
</head>
<script type="text/javascript">
var groupId = "${v3x:getGroup().id}";
$().ready(function() {
    if("${ctp:escapeJavascript(conditionBase)}"=="start"){
        $("#conditionBase2").attr("checked","checked");
        $("#conditionBase1").removeAttr("checked");
    }else{
        $("#conditionBase1").attr("checked","checked");
        $("#conditionBase2").removeAttr("checked");
    }
    $("a.workflow_branch").click(function() {//左括号
        appendOperationMarkToCreateCode($(this).attr("defaultMark"),$(this).attr("realMark"));
    });
});

/**
 * 添加操作符号到表达式中
 */
function appendOperationMarkToCreateCode(defaultMark,realMark){
    var createCode = getFormConditionTextArea();
    var createCodeValue = createCode.value.trim();
    var startPos = 0, endPos = 0;
    var addedValue = "";
    if(createCodeValue==""){
        addedValue = defaultMark;
    }else{
        addedValue = realMark;
    }
    addToTextArea(createCode, addedValue);
    var result = getTextAreaPosition(createCode);
    startPos = result.startPos;
    endPos = result.endPos;
    var index = addedValue.indexOf("()");
    if(addedValue!=null && index>=0){
        var newIndex = startPos - (addedValue.length-index)+1;
        setTextAreaPosition(createCode,newIndex);
    }
    createCode.focus();
}
/**
 * 显示组织模型字段页面
 */
function showOrgfield(selectId){
    var createCode = getFormConditionTextArea();
    var result = getTextAreaPosition(createCode);
    var sel = $("#"+selectId)[0];
     var ops = sel.options;
    for(var i=0;i<ops.length;i++){
        if(ops[i].selected==true){
            var seltext = ops[i].text;
            var selvalue = ops[i].value;
            if(selvalue==""){ops[i].selected = false;return;}
            var dialog = $.dialog({
                url : '<c:url value="/workflow/designer.do?method=listOrg&isAutoCondition=true&orgType="/>'+ selvalue,
                width : 350,
                height : 250,
                title : "${ctp:i18n('workflow.branch.form.bind.selectorg.label')}",
                targetWindow: window.parent.parent,
                buttons : [ {
                    text : "${ctp:i18n('workflow.designer.page.button.ok')}",
                    handler : function() {
                    var orgCondition = dialog.getReturnValue({"innerButtonId":"ok"});
                    //alert(orgCondition);
                    if(orgCondition!=false){
                        handleOrgCondition(orgCondition, selvalue, result);
                        setTimeout(function(){
                            dialog.close();
                        }, 10)
                    }
                }
                }, {
                    text : "${ctp:i18n('workflow.designer.page.button.cancel')}",
                    handler : function() {
                        dialog.close();
                    }
                } ]
            });
            break;
        }
    }
    sel = ops = null;
}

/**
 * 处理组织模型分支，产生组织模型分支表达式
 */
function handleOrgCondition(condition, selvalue, result){
    if(condition!=null){
        if(selvalue == '<%=V3xOrgEntity.ORGENT_TYPE_TEAM%>'){//组
            var name = condition[3].substring(1,condition[3].length-1);
			var orgType = condition[6];
			var conditionExpress= "";
			if(condition[0]=="=="){
                conditionExpress= "include('" + orgType + "','" + condition[2] + "')";
			}else{
                conditionExpress= "exclude('" + orgType + "','" + condition[2] + "')";
			}
            setConditionExpressToTextArea(result, conditionExpress);
        }else if(selvalue == '<%=OrgConstants.RelationshipType.Member_Post%>'){//兼职岗位（没用）
            var name = condition[3].substring(1,condition[3].length-1);
            var conditionExpress= "";
            if(condition[0]=="=="){
                conditionExpress= "include('secondpost','" + condition[2] + "')";
            }else{
                conditionExpress= "exclude('secondpost','" + condition[2] + "')";
            }
            setConditionExpressToTextArea(result, conditionExpress);
      }else if(selvalue == '<%=V3xOrgEntity.ORGENT_TYPE_ROLE%>'){//角色
            var name = condition[3].substring(1,condition[3].length-1);
            var conditionExpress= "";
            /* var DEPT_ROLES = ["DepManager", "DepLeader", "DepAdmin", "Departmentexchange"];
            var isSysDeptRole = false;
            for(var i = 0; i < DEPT_ROLES.length; i++){
                if(DEPT_ROLES[i].toLocaleLowerCase() == condition[2].toLocaleLowerCase()){
                    isSysDeptRole = true;
                    break;
                }
            }
             if(isSysDeptRole){  */
                if(condition[0]=="=="){
                    conditionExpress= "isRole('" + condition[2] + "'," + condition[11] + "," + condition[12] + "," + condition[13] + "," + condition[22] + ")";
                }else{
                    conditionExpress= "isNotRole('" + condition[2] + "'," + condition[11] + "," + condition[12] + "," + condition[13] + "," + condition[22] + ")";
                }
            /* } else {
                if(condition[0]=="=="){
                    conditionExpress= "isRole('" + condition[2] + "')";
                }else{
                    conditionExpress= "isNotRole('" + condition[2] + "')";
                }
            } */
            setConditionExpressToTextArea(result, conditionExpress);
      }else if(selvalue == '<%=V3xOrgEntity.ORGENT_TYPE_POST%>'){//岗位
            var name = condition[3].substring(1,condition[3].length-1);
            var isStandardPost= "false";
            if(condition[5]==groupId){//集团基准岗位
                //name= "集团基准岗位:"+name;
                isStandardPost= "true";
            }else{//
                //name= "单位自建岗位:"+name;
                isStandardPost= "false";
            }
            var conditionExpress= "";
            if(condition[0]=="=="){
                conditionExpress= "isPost(" + isStandardPost + ","+condition[7]+","+condition[8]+","+condition[9]+","+condition[22]+",'"+condition[2]+"')";
            }else{
                conditionExpress= "isNotPost(" + isStandardPost + ","+condition[7]+","+condition[8]+","+condition[9]+","+condition[22]+",'"+condition[2]+"')";
            }
            setConditionExpressToTextArea(result, conditionExpress);
        }else if(selvalue == '<%=V3xOrgEntity.ORGENT_TYPE_DEPARTMENT%>'){//部门
            var name = "";
            var id_str= "";
            var ids,names;
            if(condition[2] && condition[3]){
                ids = condition[2].split("↗");
                names = condition[3].split("↗");
                if(ids && names && ids.length == names.length){
                    for(var i=0;i<ids.length;i++){
                        if(i==ids.length-1){
                            id_str += ids[i];
                            name += names[i].substring(1,names[i].length-1)+"("+ids[i]+")";
                        }else{
                            id_str += ids[i]+",";
                            name += names[i].substring(1,names[i].length-1)+"("+ids[i]+"),";
                        }
                    }
                }else{
                    //$.alert("分支设置错误，请重新设置");
                    $.alert("${ctp:i18n('workflow.label.dialog.wrongBranch')}");
                    return;
                }
            }
            var conditionExpress= "";
            if(condition[0]=="=="){
	            conditionExpress= "isDep("+condition[11]+","+condition[12]+","+condition[13]+",'"+id_str+"')";
            }else{
                conditionExpress= "isNotDep("+condition[11]+","+condition[12]+","+condition[13]+",'"+id_str+"')";
            }
            setConditionExpressToTextArea(result, conditionExpress);
        }else if(selvalue == '<%=V3xOrgEntity.ORGENT_TYPE_ACCOUNT%>'){//单位
            var name = condition[3].substring(1,condition[3].length-1);
            var conditionExpress= "";
            if(condition[0]=="=="){
              conditionExpress= "isAccount("+condition[16]+","+condition[17]+",'"+condition[2]+"')";
            }else{
              conditionExpress= "isNotAccount("+condition[16]+","+condition[17]+",'"+condition[2]+"')";
            }
            setConditionExpressToTextArea(result, conditionExpress);
        }else if(selvalue == '<%=V3xOrgEntity.ORGENT_TYPE_LEVEL%>'){//职务级别
            var name = condition[3].substring(1,condition[3].length-1);
            var isStandardLevel= "false";
            if(condition[5]==groupId){//集团职务级别
              //name= "集团职务级别:"+name;
              isStandardLevel= "true";
            }else{//单位职务级别
              //name= "单位职务级别:"+name;
              isStandardLevel= "false";
            }
            var conditionExpress= "";
            if(condition[0]=="=="){
              conditionExpress= "isLevel("+isStandardLevel+","+condition[19]+","+condition[20]+","+condition[22]+",'"+condition[2]+"')";
            }else if(condition[0]=="<>"){
              conditionExpress= "isNotLevel("+isStandardLevel+","+condition[19]+","+condition[20]+","+condition[22]+",'"+condition[2]+"')";
            }else{
            	conditionExpress= "compareLevel('"+condition[0]+"',"+condition[19]+","+condition[20]+","+condition[22]+",'"+condition[2]+"')";
            }
            setConditionExpressToTextArea(result, conditionExpress);
        }else if(selvalue == 'LoginAccount'){//发起人登录单位
            var name = condition[3].substring(1,condition[3].length-1);
            var conditionExpress= "";
            if(condition[0]=="=="){
              conditionExpress= "isLoginAccount('"+condition[2]+"')";
            }else{
              conditionExpress= "isNotLoginAccount('"+condition[2]+"')";
            }
            setConditionExpressToTextArea(result, conditionExpress);
        }else{
            //$.alert("类型不支持!");
            $.alert("${ctp:i18n('workflow.label.dialog.notSupportedType')}");
        }
    }
}

/**
 * 拼接和展现分支条件
 */
function setConditionExpressToTextArea(result, conditionExpress){
	var createCode = getFormConditionTextArea();
	startPos = result.startPos;
    endPos = result.endPos;
    setTextAreaPosition(createCode,startPos);
    addToTextArea(createCode, conditionExpress);
    createCode.focus();
    createCode = null;
    if($.browser.chrome && parent.translateBranchInfo){//chrome浏览器，手动调用下这个方法
        parent.translateBranchInfo();
    }
}
/**
 * 获取到条件设置框
 */
function getFormConditionTextArea(){
    return $("#creatcode",window.parent.document)[0];
}
/**
 * 设置参考对象
 */
function setConditionBaseValue(obj){
  if(obj.checked){
    $("#conditionBase",window.parent.document).attr("value",obj.value);
    parent.conditionBase = $(obj).val();
  }
}

</script>
<%@ include file="/WEB-INF/jsp/ctp/workflow/operateTextAreaApi.jsp"%>
<body>
<table width="100%" border="0" align="center">
    <tr>
        <td class="font_size12" colspan="2" height="30">
        <div class="common_radio_box clearfix">
            <label for="radio1" class="margin_r_10 hand">
            <input type="radio" onclick="setConditionBaseValue(this);" value="currentNode" checked id="conditionBase1" name="conditionBase" class="radio_com"/>${ctp:i18n('workflow.branch.currentnode')}</label>
            <label for="radio2" class="margin_r_10 hand">
            <input type="radio" onclick="setConditionBaseValue(this);" value="start" id="conditionBase2" name="conditionBase" class="radio_com"/>${ctp:i18n('workflow.branch.sender')}</label>
        </div>
        </td>
    </tr>
    <tr>
        <td width="60%">
            <select name="sheetselect" id="sheetselect" size="10" onclick="showOrgfield('sheetselect')" style="width: 300px; height: 200px;" multiple="multiple">
                <c:if test="${isGroup == true }">
                <option value="<%=V3xOrgEntity.ORGENT_TYPE_ACCOUNT%>">${ctp:i18n('org.account.label')}</option>
                </c:if>
                <option value="<%=V3xOrgEntity.ORGENT_TYPE_DEPARTMENT%>">${ctp:i18n('org.department.label')}</option>
                <option value="<%=V3xOrgEntity.ORGENT_TYPE_POST%>">${ctp:i18n('org.post.label')}</option>
                <option value="<%=V3xOrgEntity.ORGENT_TYPE_LEVEL%>">${ctp:i18n('org.level.label')}</option>
                <option value="<%=V3xOrgEntity.ORGENT_TYPE_TEAM%>">${ctp:i18n('org.team.label')}</option>
                <option value="<%=V3xOrgEntity.ORGENT_TYPE_ROLE%>">${ctp:i18n('org.role.label')}</option>
                <c:if test="${isGroup == true }">
                <option value="LoginAccount">${ctp:i18n('workflow.branchGroup.1.3')}</option>
                </c:if>
                <option value=""></option>
            </select>
        </td>
        <td width="40%" >
            <table align="center" class="margin_tb_10">
              <tr>
                  <td><a id="bracklBtn" class="form_btn workflow_branch" href="javascript:void(0)" defaultMark="(" realMark=" ( "><span class="brackl_16"></span></a></td>
                  <td width="10"></td>
                  <td><a id="brackrBtn" class="form_btn workflow_branch" href="javascript:void(0)" defaultMark=")" realMark=" ) "><span class="brackr_16"></span></a></td>
              </tr>
              <tr height="10"><td colspan="3"></td></tr>
              <tr>
                  <td><a id="andBtn" class="form_btn workflow_branch" href="javascript:void(0)" defaultMark=" && " realMark=" && ">and</a></td>
                  <td width="10"></td>
                  <td><a id="orBtn" class="form_btn workflow_branch" href="javascript:void(0)" defaultMark=" || " realMark=" || ">or</a></td>
              </tr>
              <c:if test="${hasUserDefinedFunction == true && appName=='collaboration'}">
              <tr height="3"><td colspan="5" align="center"></td></tr>
              <tr>
                <td colspan="4"><a id="userDefinedFunction" class="form_btn w89" title="${ctp:i18n('workflow.formCondition.customfunctionLabel')}" href="javascript:void(0)">${ctp:i18n('workflow.formCondition.customfunctionLabel')}</td>
              </tr>
              </c:if>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
<script type="text/javascript">
$("#userDefinedFunction").click(function(){
    var createCode = getFormConditionTextArea();
    var result = getTextAreaPosition(createCode), startPos = 0, endPos = 0;
    startPos = result.startPos;
    endPos = result.endPos;
    $.callFormula({
    	appName:'collaboration',
    	catagory:'1',
    	templateCode:'${templateCode}',
    	returnType:'Bool',
        formulaType:'GroovyFunction,JavaFunction',
        formApp : "${formAppId}",
        showFormVariables: "false",
        onOk:function(v){
            setTextAreaPosition(createCode,startPos);
            addToTextArea(getFormConditionTextArea(), v);
            createCode.focus();
            handInvokeTranslate();
            createCode = null;
        }
    });
});
</script>