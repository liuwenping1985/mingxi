<%--
/**
 * $Author: wangchw $
 * $Rev: 40258 $
 * $Date:: 2014-09-05 16:35:12#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/common/workflow/workflowDesigner_ajax.js${ctp:resSuffix()}"></script>
<html>
<head>
<title>${ctp:i18n('selectPolicy.please.select')}</title>
</head>
<body onload="compare()">
<div class="form_area align_center">
<form action="" name="selectPolicyForm" id ="selectPolicyForm">
<c:set var="isShowApplyToAll" value="${isShowApplyToAll eq 'true'}"/><%-- 是否显示'应用到所有' --%>
<c:set var="policyIdHtmlValue" value="${ctp:toHTML(policyId)}"></c:set>
<c:set var="policyIdHtmlValue_es" value="${policyId_es}"></c:set>
<c:set var="isCopyFrom" value="${param.copyFrom ne null && param.copyFrom ne '' && param.copyFrom ne 'null' &&  param.copyFrom ne 'undefined'}"/>
<c:set var="isCopyFromDisable" value="${isCopyFrom?'disabled':''}"/>
<c:if test="${!isShowMatchScope== true }">
<input type="hidden" id="defaultMatchScope"  name="matchScope" value="${matchScope}">
</c:if>
<input type="hidden" id="isProIncludeChild"  name="isProIncludeChild" value="${isProIncludeChild}">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td colspan="2" height="8" class="PopupTitle"></td>
    </tr>
    <tr>
    <td id="policyDiv" colspan="2" valign="top" style="padding:0 10px;">
        <div id="policyHTML">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <!-- 节点权限部分:开始 -->
            <tr>
                <td>
                <fieldset width="80%" align="center">
                    <legend>${ctp:i18n('workflow.designer.node.property.setting')}</legend>
                    <table align="center" width="100%" border="0">
                        <tr>
                            <td width="28%" height="28" align="right">${ctp:i18n('workflow.designer.node.name.label')}:</td>
                            <td width="50%" align="left"><input style="width:197px" id="nodeNamee" name="nodeNamee" class="input-100per margin_l_5" readonly value="${ctp:toHTML(nodeName)}" title="${ctp:toHTML(nodeName)}"></td>
                            <td align="left" width="22%" nowrap="nowrap"></td>
                        </tr>   
                        <tr>
                            <td width="28%" height="28" nowrap="nowrap" align="right">${ctp:i18n('workflow.designer.selectPolicy.please.select')}:</td>
                            <td  width="50%" height="28" nowrap="nowrap" align="left"><select style="width:200px" class="margin_l_5" onchange="disableORShow();changeIsDisplayStopNode(this);" name="policy" id="policy"  ${disable1}>
                                <c:forEach items='${nodeAuthorityList}' var="nodePolicy" varStatus="num">
                                    <option id="${nodePolicy.isEnabled == 0 and policyIdHtmlValue==nodePolicy.value ? 'stopNode' : ''}" value="${ctp:toHTML(nodePolicy.value)}" name="${ctp:toHTML(nodePolicy.name)}"  ${policyId==nodePolicy.value || (policyId==null && defaultPolicyId==nodePolicy.value)?"selected":"" }>${ctp:toHTML(nodePolicy.name)}</option>
                                </c:forEach>
                            </select>
                            </td>
                            <td align="right" width="22%" nowrap="nowrap">
                            <c:if test="${disable2==true}">
                                <a class="color_blue" href="#" onclick="${nodeType=='StartNode'?'':'policyExplain()' }" ${nodeType=='StartNode'?'disabled':'' } style="${nodeType=='StartNode'?'background: #ededed;color: #d2d2d2;cursor: default;':'' }text-decoration:none">
                                    [${ctp:i18n('workflow.designer.node.policy.explain')}]
                                </a> 
                            </c:if>
                            </td>
                        </tr>
                    </table>
                </fieldset>
              </td>
          </tr>
          <!-- 节点权限部分:结束 -->
          <tr height="10"><td colspan="3"></td></tr>
          <!-- 流转设置（容错模式和人工干预人员）:开始-->
          <tr>
            <td>
            <fieldset width="80%" align="center"><legend>${ctp:i18n('workflow.superTolerantModel.label') }</legend>
            <table align="center" width="100%" border="0">
            <c:if test="${isShowActionConfigUrl eq true }">
                <tr>
                    <td width="28%" height="28" align="right">${ctp:i18n('workflow.supernode.action.config.label') }:</td>
                    <td width="50%" height="28" colspan="2" align="left">
                    <a class="color_blue margin_l_5" href="#" onclick="showSuperNodeActionConfigPage();" style="text-decoration:none">
                    <c:choose>
                        <c:when test="${disable0=='' }">
                         ${ctp:i18n('workflow.supernode.action.config.set') }
                        </c:when>
                        <c:otherwise>
                        ${ctp:i18n('workflow.supernode.action.config.show') }
                        </c:otherwise>
                    </c:choose>
                    </a> 
                    </td>
                    <td align="left" width="22%" nowrap="nowrap"></td>
                </tr>
             </c:if>
                <tr>
                    <td width="28%" height="28" align="right">${ctp:i18n('workflow.tolerantModel.label') }:</td>
                    <td width="50%" height="28" colspan="2" align="left">
                        <select id="tolerantTerm" ${disable0} name="tolerantTerm" class="margin_l_5" style="width:200px">
                          <option value="1" title = "${ctp:i18n('workflow.tolerantModel.ignore') }" <c:if test="${'1' ==defaultTolerantModel}">selected</c:if>>${ctp:i18n('workflow.tolerantModel.ignore') }</option>
                          <option value="0" title = "${ctp:i18n('workflow.tolerantModel.waitPerson') }" <c:if test="${'0' ==defaultTolerantModel}">selected</c:if>>${ctp:i18n('workflow.tolerantModel.waitPerson') }</option>
                       </select>
                    </td>
                    <td align="left" width="22%" nowrap="nowrap"></td>
               </tr>
               <tr>
                    <td width="28%" height="28" align="right" nowrap="nowrap">${ctp:i18n("workflow.superPerson.label")}:</td>
                    <td align="left" width="50%" nowrap="nowrap">
                        <input ${disable0} readonly onclick="selectPeopleForTheNode();" type="text" value="&lt;${ctp:i18n('workflow.designer.startuser')}&gt;" id="workflowInfo" name="workflowInfo"  class="margin_l_5" style="width:197px"/>
                        <div id="workflowInfo_pepole_inputs" style="display: none"></div>
                </td>
            </tr>
            <tr height="5"><td colspan="3"></td></tr>
            </table>
            </fieldset>
          </td>
        </tr>
        <!-- 流转设置（容错模式和人工干预人员）:结束-->
       <!-- 执行模式部分:开始  -->
        <c:if test="${flag2== true}"><!-- 模版流程 -->
        <tr height="10"><td></td></tr>  
          <tr>
            <td>
               <fieldset width="80%" align="center"><legend>${ctp:i18n('workflow.designer.node.process.mode')}</legend>
               <table align="center">
                 <tr>
                    <td height="28" colspan="2">
                    <label for="zusai_mode" title="${ctp:i18n('workflow.commonpage.processmode.zusaiDetail')}">
                        <input type="radio" name="node_process_mode" id="zusai_mode" value="1" <c:if test="${processMode=='1'}">checked</c:if> >
                        ${ctp:i18n('workflow.commonpage.processmode.zusai')}
                    </label>
                    <label for="nozusai_mode" title="${ctp:i18n('workflow.commonpage.processmode.nozusaiDetail')}">
                        <input type="radio" name="node_process_mode" id="nozusai_mode" value="0" <c:if test="${processMode=='0'}">checked</c:if>>
                        ${ctp:i18n('workflow.commonpage.processmode.nozusai')}
                    </label>
                    </td>
                 </tr>
                </table>
                </fieldset>
                </td>
            </tr>
          </c:if>
          <!-- 执行模式部分:结束  -->
          <!-- 表单视图绑定部分:开始  -->
          <c:if test="${isFormTemplate== true}">
          <tr height="10"><td></td></tr>
          <tr>
             <td>
               <fieldset width="80%" align="center">
               <legend>${ctp:i18n('workflow.designer.form.bind.label')}</legend>
               <table align="center" width="100%" border="0">
                 <tr>
                    <td width="28%" height="28" align="right">${ctp:i18n('workflow.designer.form.bind.formAndOperation')}:</td>
                    <td width="50%" align="left">
                    <select style="width:200px" class="margin_l_5"  name="operations" id="operations" ${formAndOperationDisable} onchange="disableMyReadView(this);">
                    <c:forEach items="${nodeBindFormViewList }" var="nodeBindFormView" >
                      <option value="${nodeBindFormView.value}" title = "${nodeBindFormView.name }" <c:if test="${nodeBindFormView.value ==currentFormOperation}">selected</c:if>>${nodeBindFormView.name}</option>
                    </c:forEach>
                    </select>
                    </td>
                    <td align="left" width="22%" nowrap="nowrap"></td>
                 </tr>
                 <c:if test="${!empty nodeBindMutiFormViewMap && nodeType!='StartNode'}">
                    <tr>
                        <td align="right" width="28%">
                        <table align="center" width="100%" border="0">
                            <c:forEach items="${views}" var="entry">
                            <tr>
                                <td width="100%" align="right" height="20">
                                <input type="checkbox" onclick="enableMyOperations(this);"
                                <c:if test="${selectedFormViewMap[entry.id]!=null }">
                                checked
                                </c:if>
                                 name="formview_checkbox" id="formview_checkbox_${entry.id}" value="${entry.id}" ${formAndOperationDisable}/></td>
                                <td nowrap="nowrap" height="20" align="left">${entry.formViewName}</td>
                            </tr>
                            </c:forEach>
                        </table>
                        </td>
                        <td width="50%" align="left">
                        <table align="center" width="100%" border="0">
                            <c:forEach items="${views}" var="entry">
                            <tr>
                            <td height="20">
                            <select 
                                <c:if test="${selectedFormViewMap[entry.id]==null }">
                                    disabled
                                </c:if>
                                style="width:200px" class="margin_l_5"  name="operations_${entry.id}" id="operations_${entry.id}" ${formAndOperationDisable}>
                            <c:forEach items="${nodeBindMutiFormViewMap[entry.id].operations }" var="myOperation" >
                                <c:if test="${myOperation.value.type == 'readonly'}">
                                <option value="${myOperation.value.value}"
                                <c:if test="${myOperation.value.defaultTag == 'true' }">
                                selected
                                </c:if>
                                 title = "${myOperation.value.name }" >${myOperation.value.name}</option>
                                </c:if>
                            </c:forEach>
                            </select>
                            </td>
                            </tr>
                            </c:forEach>
                        </table>
                        </td>
                        <td align="left" width="22%" nowrap="nowrap"></td>
                    </tr>
                </c:if>
               </table>
               </fieldset>                 
              </td>
         </tr>
         </c:if>
         <!-- 表单视图绑定部分:结束  -->
         <c:if test="${isFromTemplete or _isTemplete}"><!-- 模版流程 -->
             <!-- 节点属性说明部分:开始  -->  
             <tr height="10"><td></td></tr>
             <tr><td class="font_size12" align="left">${ctp:i18n('workflow.designer.node.deal.explain')}</td></tr>
             <tr>
                <td>
                <div class="common_txtbox_wrap" style="padding:0px;">
                    <textarea id="desc" ${nodeState!="1"?"disabled":"" } name="desc"  rows="5" maxSize="200" class="validate border_no font_size12" validate="isWord:true,avoidChar:'!@#$%^*()<>\\',maxLength:200,name:&#x27;${ctp:i18n('workflow.nodeProperty.dealExplain') }<%-- 处理说明 --%> &#x27;" style="width:99.5%;"></textarea>
                </div>
                </td>
             </tr>
          </c:if>
        </table>
      </div>
     </td>
    </tr>
</table>
</form>
</div>
<script type="text/javascript">
var appName= '${appName}';
var paramObjs= window.parentDialogObj['workflow_dialog_setWorkflowNodeProperty_Id'].getTransParams();
//var dialogParentTransParams= window.dialogArguments;
var processXmlTemp= paramObjs.processXml;
var descOld= paramObjs.desc;
var tempProcessEvent = paramObjs.process_event;
if(tempProcessEvent){
    $("#process_event").val(tempProcessEvent);
}
if(descOld.trim()=="\t"){
  $("#desc").attr("value","");
}else{
   $("#desc").attr("value",descOld);
}
<c:if test="${(_isTemplete || isFromTemplete) && (param.nodeState eq '1' || param.nodeState eq '2')}">
if(paramObjs.hsbObj!=null){
    if(paramObjs.hsbObj.isHasHandCodition){
        $("#hs_type_td").html(paramObjs.hsbObj.optionStr);
    }
}
</c:if>
var wfAjax= new WFAjax();
//确定按钮响应方法
function OK(jsonArgs) {
  var innerButtonId= jsonArgs.innerButtonId;
  if(innerButtonId=='ok'){
    /* if(!checkForm(selectPolicyForm)) return; */
    <c:if test="${flag2== true}"><!-- 模版流程 -->
      var vresult= $("#selectPolicyForm").validate();
      if(!vresult){
        return false;
      }
    </c:if>
    //节点权限
    var policyOptionValue = $("#policy").attr("value");
    //节点权限名称
    var policyOptionName=$("#policy").find("option:selected").text();
    //超期期限
    var dealTerm = "0";
    //提前提醒
    var remindTime = "0";
    //处理说明
    var desc  = $("#desc").attr("value");
    var hasDesc = "1";
    if(!desc || ( desc.trim()=="" || desc.trim()=="\t")){
        hasDesc= "0";
    }
    //执行模式
    var processMode = "${processMode}";
    var node_process_mode = $('input:radio[name="node_process_mode"]');
    var disableORShowObj = $('#disableORShow')[0];
    //if(node_process_mode  && (disableORShowObj == null || (policyOptionValue != "inform" && policyOptionValue != "zhihui"))){
    if(node_process_mode){
        var val=$('input:radio[name="node_process_mode"]:checked').val();
        if(val!=null){
          processMode= val;
        }
    }
    //表单视图操作权限
    var formApp = "${formApp}";
    var formName = "";
    var operationName = "";
    var operationNameMutils= "";
    if($('#operations')[0]){
        var operationsValue= $("#operations").attr("value").split("|");
        if(operationsValue){
          formName = operationsValue[0];
          operationName = operationsValue[1];
        }
        var multiFormViewCheckboxs= document.getElementsByName("formview_checkbox");
        var formViewLength= multiFormViewCheckboxs.length;
        var j=0;
        for(var i=0;i<formViewLength;i++){
            var multiFormViewCheckbox= multiFormViewCheckboxs[i];
            if(multiFormViewCheckbox.checked){
                var multiFormViewOperation= document.getElementById("operations_"+multiFormViewCheckbox.value).value;
                if(j==0){
                    operationNameMutils += multiFormViewOperation;
                }else{
                    operationNameMutils += ","+multiFormViewOperation;
                }
                j++;
            }
        }
    }
    //岗位匹配范围类型
    var matchScope = 1;
    var defaultMatchScopeValue= $("#defaultMatchScope").attr("value");
    var selectMatchScopeValue=$('input:radio[name="matchScope"]:checked').val();
    if(selectMatchScopeValue){
      matchScope= selectMatchScopeValue;
    }else{
      matchScope= defaultMatchScopeValue;
    }
    //匹配范围由表单控件字段决定
    var formFieldValue = "";
    if($("#formFieldValue")[0]){
      formFieldValue= $("#formFieldValue").attr("value");
    }
    //表单控件决定匹配范围，则必须选择一个表单控件字段
    <c:if test="${isRootPost && isGroupVersion}">
    if(formFieldValue == "" && matchScope == "4"){
        showFlashAlert("${ctp:i18n('workflow.nodeProperty.formCreat_must_value')}");
        return false;
    }
    </c:if>
    //知会节点不能触发新流程
    if(policyOptionValue == "inform" || policyOptionValue == "zhihui"){
        if(${hasNewflow eq 'true'}){
            showFlashAlert("${ctp:i18n('workflow.nodeProperty.inform_alert_alreadyHasNewflow')}");
            return false;
        }
    }
    //是否将当前节点属性信息应用到其它所有节点
    var isApplyToAll = "false";
    if($("#applyToAll")[0]){
      if($("#applyToAll").attr("checked")){
        isApplyToAll = "true";
      }
    }
    //超期处理动作设置信息
    var dealTermType="";//到期处理类型
    var dealTermUserId="";
    var dealTermUserName="";
    if(${_isTemplete== true} || ((${scene == 4 || scene == 5}) && ${_isTemplete== true} )){//模板流程、督办和管控模式
        var dealObj = $("#workflowInfo_pepole_inputs").find("#dealTermUserId");
        if(dealObj.size()>0){//人工干预人员
            dealTermUserId=dealObj.val();
            dealTermUserName=dealObj.parent().find("#dealTermUserName").val();
        }else{//自动跳过
            dealTermUserId="";
            dealTermUserName="";
        }
        dealObj = null;
    }
    var isProIncludeChild= $("#isProIncludeChild").attr("value");
    var rAutoUp= "1";//角色是否自动向上查找，默认为1表示自动向上查找
    if($("#roleAutoUpMatch")[0]){
      var checked= $("#roleAutoUpMatch").attr("checked");
      if(checked){
        rAutoUp= "1";
      }else{
        rAutoUp= "0";
      }
    }else{//如果该input不存在，那么就设置为0
        rAutoUp= "0";
    }
    var pAutoUp= "1";//岗位是否自动向上查找，默认为1表示自动向上查找
    if($("#departmentPostAutoUpId")[0]){
       var checked= $("#departmentPostAutoUpId").attr("checked");
       if(checked){
         pAutoUp= "1";
       }else{
         pAutoUp= "0";
       }
    }
    var nuAction= "0";//匹配不到人时：默认0弹出选人界面
    if($("#nouserAction")[0]){
      nuAction= $("#nouserAction").attr("value");
    }
    //alert("r:="+rAutoUp+";p:="+pAutoUp+";n:="+nuAction);
    var nodeNameStr= $("#nodeNamee").attr("value");
    var tolerantModel = $("#tolerantTerm").val();
    var process_event = $("#process_event").val() || "";
    var queryIds="";
    var statisticsIds="";
    var result = [policyOptionValue, policyOptionName, dealTerm, remindTime, processMode, formApp, formName,
                  operationName, "", matchScope,"${hasNewflow}", isApplyToAll,formFieldValue,desc,dealTermType,
                  dealTermUserId,dealTermUserName,hasDesc,isProIncludeChild,"-1","-1",rAutoUp,pAutoUp,nuAction,process_event
                  ,operationNameMutils,tolerantModel,nodeNameStr,queryIds,statisticsIds];
    return result;
  }
}

//控制节点权限下拉列表
function disableORShow(){
  var form = document.getElementsByName("selectPolicyForm")[0];
  var value = $("#policy").attr("value");
  if(value == "inform" || value == "zhihui"){
    $("#zusai_mode").removeAttr("checked");
    $("#zusai_mode").attr("disabled","disabled");
    $("#nozusai_mode").removeAttr("disabled");
    $("#nozusai_mode").attr("checked","checked");
  }else{
    $("#zusai_mode").removeAttr("disabled");
    $("#zusai_mode").attr("checked","checked");
    $("#nozusai_mode").removeAttr("checked");
    $("#nozusai_mode").attr("disabled","disabled");
  }
}

/**
 * 设置表单控件匹配是否可选
 */
function disableFormFieldValue(value){
  if($("#formFieldValue")[0]){
      if(value == 'false'){
          $("#formFieldValue").removeAttr("disabled");
      }else{
          $("#formFieldValue").attr("value","");
          $("#formFieldValue").attr("disabled","disabled");
          $("#isProIncludeChild").attr("value","false");
          $("#isIncludeChildInfo").text("");
      }
  }
}

/**
 * 页面加载时初始化数据
 */
function compare(){
  //debugger;
  if(${_isTemplete== true}){
    if(${dealTermUserId !='' && dealTermUserName !='' && dealTermUserId !='null' && dealTermUserName !='null'}){
      $("#workflowInfo").attr("value","${dealTermUserName}");
      if($("#dealTermUserId")[0]){
          $("#dealTermUserId").attr("value","${dealTermUserId}");
      }else{
          var str="";
          str += '<input type="hidden" id="dealTermUserId" name="dealTermUserId" value="${dealTermUserId}" />';
          str += '<input type="hidden" id="dealTermUserName" name="dealTermUserName" value="${dealTermUserName}" />';
          $("#workflowInfo_pepole_inputs").html(str);
      }
      }        
  }
  var objvalue= $("#operations").val();
  if(objvalue){
    var myFormViewId= objvalue.split("|")[0];
    $("#formview_checkbox_"+myFormViewId).attr("disabled","disabled");
    $("#formview_checkbox_"+myFormViewId).removeAttr("checked");
    $("#operations_"+myFormViewId).attr("disabled","disabled");
  }
  <c:forEach items="${views}" var="entry">
      <c:forEach items="${nodeBindMutiFormViewMap[entry.id].operations }" var="myOperation" >
            <c:if test="${myOperation.value.type == 'readonly'}">
                 <c:if test="${ selectedFormViewOperationMap[myOperation.value.value] !=null}">
                       $("#operations_${entry.id}").attr("value","${myOperation.value.value}");
                 </c:if>
            </c:if>
      </c:forEach>
  </c:forEach>
  disableORShow();
  if(${scene == 4}){
	  $("#policy,#tolerantTerm,#workflowInfo,#zusai_mode,#nozusai_mode,#operations,#desc,input[id^=formview_checkbox_],select[id^=operations_]").each(function(){
		  $(this).prop("disabled", true).attr("disabled","disabled");
	  });
  }
}

/**
 * 删除被停用的 option 节点
 * 前提：当一个自定义节点被停用后，修改有这个节点的模版流程
 * 要求：进入页面时在设置节点权限中显示这个被停用的节点，当选择其它节点后被停用的这个节点自动消失
 */
function changeIsDisplayStopNode(obj) {
    for (var i = 0 ; i < obj.options.length ; i ++) {
        if (obj.options[i].id == 'stopNode'){
          obj.remove(i);
        }
    }
    if(obj.value=="inform"){
        var temp1 = $("#hs_type_area1"),temp2 = $("#hs_type_area2");
        if(temp1.size()>0){
            temp1.css("display","none");
            temp2.css("display","none");
        }
        temp1 = temp2 = null;
    }else{
        var temp1 = $("#hs_type_area1"),temp2 = $("#hs_type_area2");
        if(temp1.size()>0){
            temp1.css("display","");
            temp2.css("display","");
        }
        temp1 = temp2 = null;
    }
}

/**
 * 超期处理动作切换
 */
function doDealTermActionChange(obj){
    if(obj.value=='1'){
        $("#workflowInfo").show();
    }else{
        $("#workflowInfo").hide();
    }
    var form = document.getElementById("selectPolicyForm");
    //checkForm(selectPolicyForm);
    var policyOptionValue = $("#policy").attr("value");
    if(policyOptionValue == "vouch"){//核定节点不允许设置自动跳过
        if(obj.value=='2'){
           showFlashAlert("${ctp:i18n('workflow.nodeProperty.policy_edoc_dealterm_skip_not_support_vouch')}");
           obj.value='0';
        }
    }else{
        var isPass= true;
        if(obj.value=='2'){
            //var result= wfAjax.hasConditionAfterSelectNode(processXmlTemp,'${nodeId}');
            //if(result[0]=='true'){
              //showFlashAlert("${ctp:i18n('workflow.nodeProperty.policy_edoc_dealterm_skip_not_support_branch')}");
              //obj.value='0';
              //isPass= false;
            //}
            if(isPass){
              if( appName!='collaboration' && appName!='form' ){
                var result= wfAjax.isExchangeNode(appName,policyOptionValue,'${flowPermAccountId}');
                if(result[0]=='true'){//公文交换类型的节点，不允许自动跳过
                  showFlashAlert("${ctp:i18n('workflow.nodeProperty.policy_edoc_dealterm_skip_not_support_fengfa')}");
                  $("#dealTermAction").attr("value","0");
                }
              }
            }
        }
    }
}

/**
 * 指定给人员：调用选人控件
 */
function selectPeopleForTheNode(){
  $.selectPeople({
    type:'selectPeople',
    targetWindow:getCtpTop(),
    panels:'Department,Post,Team',
    selectType:'Member',
    showFlowTypeRadio: false,
    maxSize:1,
    minSize:1,
    params : {
      value: ''
    },
    callback:function(ret){
      if(ret.obj){
        setPeopleFieldsOfDealTerm(ret.obj);
      }
    }
  });
}

/**
 * 将选人控件返回的值写到当前页面隐藏域中
 */
function setPeopleFieldsOfDealTerm(elements){
    if (!elements) {
        return false;
    }
    var person = elements[0] || [];
    var str="";
    //alert(person.type+";"+person.id+";"+person.name);
    str += '<input type="hidden" name="dealTermUserType" value="' + person.type + '" />';
       str += '<input type="hidden" id="dealTermUserId" name="dealTermUserId" value="' + person.id + '" />';
       str += '<input type="hidden" id="dealTermUserName" name="dealTermUserName" value="' + escapeStringToHTML(person.name) + '" />';
       str += '<input type="hidden" name="dealTermAccountId" value="' + person.accountId + '" />';
       str += '<input type="hidden" id="dealTermAccountShortname" name="dealTermAccountShortname" value="' + escapeStringToHTML(person.accountShortname) + '" />';
       
    document.getElementById("workflowInfo_pepole_inputs").innerHTML= str;
    if(escapeStringToHTML(person.accountShortname)!=''){
        document.getElementById("workflowInfo").value=escapeStringToHTML(person.name)+"("+escapeStringToHTML(person.accountShortname)+")";
    }else{
        document.getElementById("workflowInfo").value=escapeStringToHTML(person.name);
    }
}
    
/**
 * 将字符串转换成HTML代码
 */
function escapeStringToHTML(str, isEscapeSpace){
    if(!str){
        return "";
    }
    str = str.replace(/&/g, "&amp;");
    str = str.replace(/</g, "&lt;");
    str = str.replace(/>/g, "&gt;");
    str = str.replace(/\r/g, ""); 
    str = str.replace(/\n/g, "<br/>"); 
    str = str.replace(/\'/g, "&#039;");
    str = str.replace(/"/g, "&#034;");
    
    if(typeof(isEscapeSpace) != 'undefined' && (isEscapeSpace == true || isEscapeSpace == "true")){
        str = str.replace(/ /g, "&nbsp;");
    }
    return str;
}

/**
 * 处理期限超期提醒选择事件函数
 */
function doDealRemindOnChange(obj){
  //超期期限
  var dealTerm = $("#dealTerm").attr("value");
  //提前提醒
  var remindTime = obj.value;
  var deal = new Number(dealTerm);
  var remind = new Number(remindTime);
  if(deal <= remind){
    showFlashAlert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanDealDeadLine')}");
    $("#remindTime").get(0).selectedIndex=0;
    if(deal==0){
      $("#dealTermTR").hide();
      if(obj.value=='0'){
          if($("#dealTermAction")[0]){
              $("#dealTermAction").attr("value","");
          }
          if($("#dealTermUserId")[0]){
              $("#dealTermUserId").attr("value","");
          }
          if($("#workflowInfo")[0]){
              $("#workflowInfo").attr("value","");
          }
      }
    }
    return false;
  }
}

/**
 * 处理期限选择事件函数
 */
function doDealTermOnchange(obj){
    var form = document.getElementById("selectPolicyForm");
    //checkForm(selectPolicyForm);
    //var form = document.getElementsByName("selectPolicyForm")[0];
    //超期期限
    var dealTerm = $("#dealTerm").attr("value");
    //提前提醒
    var remindTime = $("#remindTime").attr("value");
    var deal = new Number(dealTerm);
    var remind = new Number(remindTime);
    if(deal < remind || ( deal == remind &&  deal!=0 && remind!=0 ) ){
      showFlashAlert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanDealDeadLine')}");
      $("#remindTime").get(0).selectedIndex=0;
      if(deal==0){
        $("#dealTermTR").hide();
        if(obj.value=='0'){
            if($("#dealTermAction")[0]){
                $("#dealTermAction").attr("value","");
            }
            if($("#dealTermUserId")[0]){
                $("#dealTermUserId").attr("value","");
            }
            if($("#workflowInfo")[0]){
                $("#workflowInfo").attr("value","");
            }
        }
      }
      return false;
    }
    var policyOptionValue = $("#policy").attr("value");
    if( obj.value!='0' && ( ${_isTemplete} || ((${scene == 4 || scene == 5}) && ${_isTemplete== true}) ) ){
        if(policyOptionValue == "inform" || policyOptionValue == "zhihui"){
            $("#dealTermTR").hide();
        }else{
            $("#dealTermTR").show();
            if($("#dealTermAction")[0]){
              $("#dealTermAction").attr("value","0");
            }
            if($("#workflowInfo")[0]){
              $("#workflowInfo").hide();
            }
        }
    }else{
        $("#dealTermTR").hide();
        if(obj.value=='0'){
            if($("#dealTermAction")[0]){
                $("#dealTermAction").attr("value","");
            }
            if($("#dealTermUserId")[0]){
                $("#dealTermUserId").attr("value","");
            }
            if($("#workflowInfo")[0]){
                $("#workflowInfo").attr("value","");
            }
        }
    }
}

/**
 * 显示节点权限说明页面
 */
function policyExplain(){
    var dialog = $.dialog({
        url : '<c:url value="${nodePolicyExplainUrl}"/>',
        transParams : window,
        width : 295,
        height : 275,
        minParam:{show:false},
        maxParam:{show:false},
        title : '${ctp:i18n("node.policy.explain")}',
        buttons : [
            {
                text : '${ctp:i18n("common.button.ok.label") }',
                handler : function(){
                    dialog.transParams = null;
                    dialog.close();
            }}
        ],
        targetWindow: getCtpTop()
    });
}

function showMatchScopeExplain(type){
  var dialog = $.dialog({
    url : '<c:url value="/workflow/designer.do?method=showMatchScopeExplain&isGroup=${isGroupVersion}&type="/>'+type,
    transParams : window,
    width : 295,
    height : 275,
    minParam:{show:false},
    maxParam:{show:false},
    title : '${ctp:i18n("node.policy.match.scope.explain")}',
    buttons : [
        {
            text : '${ctp:i18n("common.button.ok.label") }',
            handler : function(){
                dialog.transParams = null;
                dialog.close();
        }}
    ],
    targetWindow: getCtpTop()
});
}

function isIncludeChildDepartment(obj){
  var value= obj.value;
  var fType= $(obj).find("option:selected").attr("formFieldType");
  if(value==''){
    $(obj).attr('title','');
  }else{
    $(obj).attr('title',$(obj).find("option:selected").attr("title"));
  }
  if(fType=='department'||fType=='multidepartment'){//单部门和多部门时，弹出确认对话框
    var random = $.messageBox({
      'title':"${ctp:i18n('workflow.label.dialog.confimTitle')}",//'确认对话框',
      'type': 100,
      'msg': '${ctp:i18n('workflow.designer.isIncludeChild')}',//是否包含子部门?
      'imgType':'4',
      buttons: [{
      id:'include',
          text: "${ctp:i18n('workflow.designer.include')}",//包含
          handler: function () { 
            $("#isProIncludeChild").attr("value","true");
            $("#isIncludeChildInfo").text("(${ctp:i18n('workflow.branch.includeChildren')})"); //包含子部门
          }
      }, {
      id:'exclude',
          text: "${ctp:i18n('workflow.designer.exclude')}",//不包含
          handler: function () {
            $("#isProIncludeChild").attr("value","false");
            $("#isIncludeChildInfo").text("(${ctp:i18n('workflow.branch.excludeChildren')})");//不包含子部门
          }
      }, {
        id:'cancle',
        text: "${ctp:i18n('workflow.designer.button.cancel')}",//取消
        handler: function () {
          $("#isProIncludeChild").attr("value","false");
          $("#isIncludeChildInfo").text("");
          obj.value= "";
        }
    }]
    });
  }else{
    $("#isProIncludeChild").attr("value","false");
    $("#isIncludeChildInfo").text("");
  }
}

/**
 * 显示提示信息
 */
function showFlashAlert(args) {
  try{
    var alert = $.alert(args);
  }catch(e){
    alert(args);
  }
}

function showDepartmentPostAutoUpIdLabel(){
  document.getElementById("departmentPostAutoUpIdLabel").style.display="";
}

function hiddenDepartmentPostAutoUpIdLabel(){
  document.getElementById("departmentPostAutoUpIdLabel").style.display="none";
}

function showNouserActionTitle(){
  //do nothing
}
function openEventAdvancedSetting(){
    var nodeId = "${nodeId}";
    var dialogWidth = "500";
    if(nodeId != "start"){
        dialogWidth = "700";
    }
    var dialog = $.dialog({
        id:"workflow_dialog_advancedSetting_id",
        url: _ctxPath + "/workflow/designer.do?method=advancedSetting&appName=${appName}&from=node&nodeId=${nodeId}",
        title : "${ctp:i18n('workflow.advance.event.name')}",
        width :800,
        height:400,
        transParams:{
            "process_event":$("#process_event").val()
        },
        targetWindow:getCtpTop(),
        buttons : [ {
            text : $.i18n("common.button.ok.label"),
            id:"workflowEventAdvancedSetting",
            handler : function() {
                var returnValue=dialog.getReturnValue();
                if(returnValue == "error"){
                    return;
                }
                $("#process_event").val(returnValue);
                dialog.close();
            }
        }, {
            text : $.i18n("common.button.delete.label"),
            handler : function(){
                $("#process_event").val("");
                dialog.close();
            }
        }, {
              text : $.i18n("common.button.cancel.label"),
              id:"exit",
              handler : function() {
                dialog.close();
              }
        }]
    });
}

function disableMyReadView(obj){
    <c:if test="${!empty nodeBindMutiFormViewMap && nodeType!='StartNode'}">
        <c:forEach items="${nodeBindMutiFormViewMap}" var="entry">
            $("#formview_checkbox_${entry.key}").removeAttr("disabled");
            $("#operations_${entry.key}").removeAttr("disabled");
            enableMyOperations($("#formview_checkbox_${entry.key}")[0]);
        </c:forEach>
    </c:if>
    if(obj && obj.value){
      var objvalue= obj.value;
      var myFormViewId= objvalue.split("|")[0];
      $("#formview_checkbox_"+myFormViewId).attr("disabled","disabled");
      $("#formview_checkbox_"+myFormViewId).removeAttr("checked");
      $("#operations_"+myFormViewId).attr("disabled","disabled");
    }
}

function enableMyOperations(obj){
  var myId= obj.value;
  if(obj.checked){
    $("#operations_"+myId).removeAttr("disabled");
  }else{
    $("#operations_"+myId).attr("disabled","disabled");
  }
  
}

function escapeSpecialChar(str){
  if(!str){
      return str;
  }
  str= str.replace(/\&/g, "&amp;").replace(/\</g, "&lt;").replace(/\>/g, "&gt;").replace(/\"/g, "&quot;");
  str= str.replace(/\'/g,"&#039;").replace(/"/g,"&#034;");
  return str;
}

function showSuperNodeActionConfigPage(){
  var myUrl= _ctxPath + escapeSpecialChar("${actionConfigUrl}");
  <c:if test="${isOutsideUrl eq true}">
  myUrl= escapeSpecialChar("${actionConfigUrl}");
  </c:if>
  var dialog = $.dialog({
    id:"workflow_dialog_suprnode_action_id",
    url: myUrl,
    title : "${actionConfigTitle}",
    width : '${actionConfigUrlWidth}',
    height: '${actionConfigUrlHeight}',
    targetWindow:getCtpTop(),
    buttons : [ {
        text : $.i18n("common.button.ok.label"),
        handler : function() {
            var returnValue = dialog.getReturnValue();
            if(returnValue){
              if(returnValue[0]){
                $("#nodeNamee").attr("value",returnValue[0]);
              }
            }
            dialog.close();
        }
    },{
          text : $.i18n("common.button.cancel.label"),
          handler : function() {
            dialog.close();
          }
    }]
});
}
</script>
</body>
</html>