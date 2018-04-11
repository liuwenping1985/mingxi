<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-09-18

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/common/supervise/supervise.js.jsp" %> 
<html style="width: 100%;height: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务重定向</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager"></script>
<!-- 工具方法 -->
<script>
var resultObj = {};
var currentSet;

var startOperationId = "${startOperation}";//默认开始节点表单权限
var nomorlOperationId = "${nomorlOperation}";//默认处理节点表单权限

$.fn.fillform = function(fillData) {
  if (this[0] == null)
    return;
  this.each(function(i) {
    var frm = $(this);
    frm.resetValidate();
    for ( var fi in fillData) {
      $("#" + fi, frm).each(function(i) {
        $(this).fill(fillData[fi], fi, frm);
      });
    }
    frm = null;
  });
}

$.fn.fill = function(v, fi, frm) {
  var el = this[0], eq = $(el), tag = el.tagName.toLowerCase();
  if (v && typeof v == "string")
    v = v.replace(/<\/\/script>/gi, "<\/script>");
  var t = el.type, val = el.value;
  switch (tag) {
    case "input":
      switch (t) {
        case "text":
          eq.val(v);
          break;
        case "hidden":
          var cp = eq.attrObj("_comp"), ctp;
          if (cp) {
            ctp = cp.attr("compType");
            if (ctp === "selectPeople") {
              var pv = "", pt = "";
              if (v && v.startsWith("{")) {
                v = $.parseJSON(v);
                cp.comp(v);
                pv = v.value;
                pt = v.text;
              }
              cp.val(pt);
              eq.val(pv);
              break;
            }
          }
          eq.val(v);
          break;
        case "checkbox":
          if (v == val)
            el.checked = true;
          else
            el.checked = false;
          break;
        case "radio":
          if (frm) {
            $("input[type=radio]", frm).each(
                function() {
                  if ((this.id == fi || this.name == fi) && v == this.value
                      && !this.checked)
                    this.checked = true;
                });
          } else if (v == el.value && !el.checked) {
            el.checked = true;
          }
      }
      break;
    case "textarea":
      eq.val(v);
      break;
    case "select":
      switch (t) {
        case "select-one":
          eq.val(v);
          break;
        case "select-multiple":
          var ops = el.options;
          var sv = v.split(",");
          for ( var i = 0; i < ops.length; i++) {
            var op = ops[i];
            // extra pain for IE...
            var opv = $.browser.msie && !(op.attributes['value'].specified) ? op.text
                : op.value;
            for ( var j = 0; j < sv.length; j++) {
              if (opv == sv[j]) {
                op.selected = true;
              }
            }
          }
      }
      break;
    default:
      if (!((!v || v == '') && $(this)[0].innerHTML.indexOf('&nbsp;') != -1)) {
        if(v && eq.parent('.text_overflow').length == 1) {
          eq.attr('title', v);
        }
        if (v && typeof v == "string")
          v = v.replace(/\n/g, '<br/>');
        el.innerHTML = v;
      }
  }
};

/**
 * 切换页签回掉函数,返回obj 对象
 * obj.complateRedirect 是否完成当前页面所有重定向
 * obj.bizObj 当前页面返回的 json 对象
 */
 function getResultJSON(){
   var obj = $("#first").formobj();
   obj.superviseDiv = $("#superviseDiv").formobj();
   resultObj.complateRedirect = validateData();
   resultObj.bizObj = (obj);
   return resultObj;
 }
 
 function validateData(){
   return $("#first").validate() && $("#need_redirect").val() == 'false';
 }
$(document).ready(function(){
  redirectJSON = parent.getData("${param.templateId}");
  resultObj.complateRedirect = false;
  resultObj.bizObj = redirectJSON;
  if(!redirectJSON){
    showNoNeedRedirectMsg();
    return;
  }
  var redirectJSON = (redirectJSON);
  $("#saveForm").fillform(redirectJSON);
  $("#superviseDiv").fillform(redirectJSON);
  $("a","#editArea").removeClass("common_button_disable").removeClass("common_button").addClass("common_button");
  $("#subject").prop("readonly",false);
  $("#templateNumber").prop("readonly",false);
  $(":disabled","#editArea").prop("disabled",false);
  
  $("#updateFlowSet").click(function(){
    if($(this).hasClass("common_button_disable")){
        return false;
    }
    if($("#process_xml").val()==""){
        $("#process_xml").val($("#process_xml_clone").val());
    }

    $("#process_xml_clone2flowCopy").val($("#process_xml").val());
    modifyWFTemplateForEgg(getCtpTop(),"collaboration", "${formBean.id}", "${formBean.formViewList[0].id}",$("#process_id").val(),window,"collaboration","${CurrentUser.id}","${CurrentUser.name}","${CurrentUser.loginAccountName}","${CurrentUser.loginAccount}",nomorlOperationId,startOperationId,"${ctp:i18n("collaboration.newColl.collaboration")}");
});
  
  $("#archiveId").change(function(){
    var options = $("option",$(this));
    var ids = options.length==3?(options.eq(2).val()+"."+options.eq(2).text()):null;
    if($(this).val()=="1"){
        var pige = pigeonhole(2,null,false,false,"fromTempleteManage");
        if("cancel"!=pige&&""!=pige){
            var p = pige.split(",");
            if(ids!=null){
                options.eq(2).remove();
            }
            $("<option selected value='"+p[0]+"'>"+p[1]+"</option>").appendTo($(this));
            $("#authDetail").removeClass("hidden");
            $(":checked","#authDetail").prop("checked",false);
        }else{
            if(ids!=null){
                options.eq(2).prop("selected",true);
            }else{
                options.eq(0).prop("selected",true);
            }
        }
    }else if("" == $(this).val()){
        if(ids!=null){
            $("option:eq(2)",$(this)).remove();
        }
        $("#authDetail").removeClass("hidden").addClass("hidden");
    }else{
        $("#authDetail").removeClass("hidden");
    }
    if($.browser.msie){//clone出来的选择框 在IE9的情况下 重新赋值后会有问题
        for(var i=0; i<this.options.length; i++){
            this.options[i].innerText = this.options[i].text+(i==0?" ":"");
            this.options[i].text = this.options[i].text+(i==0?" ":"");
        }
    }
});
  
  $("#authSet").click(function(){
    if($(this).hasClass("common_button_disable")){
        return false;
    }
    var par = new Object();
    par.value = $("#auth").val();
    par.text = $("#auth_txt").val();
    $.selectPeople({
        panels: 'Account,Department,Team,Post,Level,Outworker',
        selectType: 'Account,Department,Team,Post,Level,Member',
        hiddenPostOfDepartment:true,
        isNeedCheckLevelScope:false,
        params : par,
        minSize:0,
        callback : function(ret) {
          $("#auth").val(ret.value);
          $("#auth_txt").val(ret.text);
        }
      });
});
  
  $("#relationAuthSet").click(function(){
    if($(this).hasClass("common_button_disable")){
        return false;
    }
    var par = new Object();
    par.value = $("#authRelation").val();
    par.text = $("#authRelation_txt").val();
    $.selectPeople({
        panels: 'Account,Department,Team,Post,Level,Node,FormField,Outworker',
        selectType: 'Account,Department,Team,Post,Level,Role,Member,FormField,Node',
        extParameters:'${CurrentUser.id},333',
        isNeedCheckLevelScope:false,
        hiddenFormFieldRole:true,
        hiddenPostOfDepartment:true,
        hiddenRoleOfDepartment:true,
        excludeElements: "Node|NodeUser,Node|BlankNode,Node|NodeUserSuperDept",
        minSize:0,
        params : par,
        callback : function(ret) {
            $("#authRelation").val(ret.value);
            $("#authRelation_txt").val(ret.text);
        }
      });
});
  
  $("#supervisorSet").click(function(){
    if($(this).hasClass("common_button_disable")){
        return false;
    }
    /**
     组件：督办设置窗口
     参数1：superviseType   superviseEnum枚举 0是模板 1是协同 2是公文
     参数2：isSubmit 是否直接提交 true or false 
     参数3：moduleId 主运用ID
    参数4：templateId 模板Id
     */
    openSuperviseWindow(0,false,null,"22",editSuperVise);
});
});

function showRedirectInfo(obj){
  
}

function editSuperVise(map){
  /*$("#supervisorsId").val(map.supervisorsId);
  $("#supervisors").val(map.supervisorNames);
  $("#awakeDate").val(map.superviseDate);
  $("#superviseTitle").val(map.title);
  $("#role").val(map.role);
  $("#roleNames").val(map.roleNames);*/
  var supervisorStr = "";
  if(map.roleNames != ""){
      supervisorStr = map.roleNames;
  }
  if(map.supervisorNames != "" ){
      supervisorStr = (supervisorStr==""?"":(supervisorStr+"、")) + decodeURIComponent(map.supervisorNames);
      $("#supervisorNames").val(decodeURIComponent(map.supervisorNames));
  }
  /*if(map.roleNames!=null && map.roleNames!=""){
      supervisorStr = (supervisorStr==""?"":(supervisorStr+"、"))+map.roleNames;
  }*/
  $("#showSupervisors").val(supervisorStr);
}

function changeCurrentPage(obj,id){
  
  $("#tab1_iframe").prop("src","${path}/form/business.do?method=redirect54FlowTempalte&templateId="+id);
}

function showNoNeedRedirectMsg(){
  resultObj.complateRedirect = true;
  //$("#first").text("当前页面没有需要重定向的设置！");
}

function validateWorkFlow(obj){
  return $("#need_redirect").val() == 'false';
}
</script>
</head>
<body >
    <div id = "first" class="font_size12 form_area">
        <form action="${path }/form/bindDesign.do?method=saveFlowTemplate" id="saveForm">
                    <div class="col2" id="editArea" style="float: left;width:59%">
                                <table width="100%" border="0" cellpadding="2" cellspacing="0" id="templateNameSet">
                                    <tr height="30px">
                                        <td width="20%" align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red">*</font>${ctp:i18n('form.seeyontemplatename.label')} ：</label></td>
                                        <td nowrap="nowrap" width="100%">
                                            <DIV class=common_txtbox_wrap>
                                            <input id="id" name="id" class="w100b" type="hidden">
                                            <input readonly="readonly" id="subject" name="${ctp:i18n('form.seeyontemplatename.label')}" class="w100b validate" type="text" maxlength="60" validate="notNullWithoutTrim:true,type:'string',notNull:true,maxLength:60,avoidChar:'&&quot;&lt;&gt;'">
                                            </DIV>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr height="30px" >
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red">*</font>${ctp:i18n('form.bind.flow.label')}：</label></td>
                                        <td>
                                            <div class=common_txtbox_wrap>
                                            <input id="isFlowCopy" name="isFlowCopy" type="hidden" value='0'>
                                            <input id="process_id" name="process_id" type="hidden">
                                            <input id="process_xml" name="process_xml" type="hidden">
                                            <input id="process_desc_by" name="process_desc_by" type="hidden">
                                            <input id="process_subsetting" name="process_subsetting" type="hidden">
                                            <input id="process_rulecontent" name="process_rulecontent" type="hidden">
                                            <input id="workflow_newflow_input" name="workflow_newflow_input" type="hidden">
                                            <input id="workflow_node_peoples_input" name="workflow_node_peoples_input" type="hidden">
                                            <input id="workflow_node_condition_input" name="workflow_node_condition_input" type="hidden">
                                            <input id="process_xml_clone" name="process_xml_clone" type="hidden">
                                            <input id="process_xml_clone2flowCopy" name="process_xml_clone2flowCopy" type="hidden">
                                            <input id="process_event" name="process_event" type="hidden">
                                            <input id="need_redirect" name="need_redirect" type="hidden">
                                            <input readonly="readonly" id="process_info" name="${ctp:i18n('form.bind.flow.label')}" class="w100b validate" validate="func:validateWorkFlow,errorMsg:'流程模板需要重定向',type:'string',notNull:true">
                                            </div>
                                        </td>
                                        <td nowrap="nowrap">
                                        <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="updateFlowSet">${ctp:i18n('form.bind.editFlow')}</a>
                                        </td>
                                    </tr>
                                    <tr height="30px" >
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>${ctp:i18n('form.bind.formFlowTitle')}：</label></td>
                                        <td nowrap="nowrap" >
                                            <div class=" common_txtbox_wrap">
                                            <input readonly="readonly" id="colSubject" name="colSubject" type="text" class="w100b validate" validate="type:'string',china3char:true,maxLength:255,name:'${ctp:i18n('form.bind.formFlowTitle')}'">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr height="30px">
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>${ctp:i18n('form.input.extend.document.label')}：</label></td>
                                        <td nowrap="nowrap" >
                                         <div class=" common_txtbox_wrap" id="rel_doc_div" style="min-height: 24px;">
                                            <div id="rel_doc" class="comp" comp="type:'assdoc',attachmentTrId:'rel_doc',canFavourite:false,modids:'2,3'"></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr height="30px">
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>${ctp:i18n('common.toolbar.insert.localfile.label')}：</label></td>
                                        <td nowrap="nowrap" >
                                             <div class=" common_txtbox_wrap" id="fileArea" isGrid="true" style="min-height: 24px;">
                                             <input id="uploadFile" name="uploadFile" type="text" class="comp" comp="type:'fileupload',applicationCategory:'1',canFavourite:false,canDeleteOriginalAtts:true,originalAttsNeedClone:false">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr height="30px">
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>${ctp:i18n('common.importance.label')}：</label></td>
                                        <td nowrap="nowrap" >
                                            <div class=" common_selectbox_wrap">
                                            <select disabled="disabled" id="importantLevel" name="importantLevel" class="w100b codecfg" codecfg="codeId:'common_importance'">
                                            </select>
                                            </div>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr height="30px">
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>${ctp:i18n('form.base.relationProject.title')}：</label></td>
                                        <td nowrap="nowrap" >
                                            <div class=" common_selectbox_wrap">
                                            <select disabled="disabled" id="projectId" name="projectId" class="w100b">
                                            <option selected="selected" value="">${ctp:i18n('form.timeData.none.lable')}</option>
                                            <c:forEach var="p" items="${project }">
                                                <option value="${p.id }">${fn:escapeXml(p.projectName)}</option>
                                            </c:forEach>
                                            </select>
                                            </div>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr height="30px"><!-- 流程期限 -->
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>${ctp:i18n('form.bind.flowCycle')}：</label></td>
                                        <td nowrap="nowrap" >
                                            <div class=" common_selectbox_wrap">
                                            <input type="hidden" id="oldDeadlineValue">
                                            <select disabled="disabled" id="deadline" name="deadline" class="w100b codecfg" codecfg="codeId:'collaboration_deadline'">
                                            </select>
                                            </div>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr height="30px">
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>${ctp:i18n('common.reference.time.label')}：</label></td>
                                        <td nowrap="nowrap" >
                                            <div class=" common_selectbox_wrap">
                                            <select disabled="disabled" id="standardDuration" name="standardDuration" class="w100b codecfg" codecfg="codeId:'collaboration_deadline'">
                                            </select>
                                            </div>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr height="30px"><!-- 提醒 -->
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>${ctp:i18n('common.remind.time.label')}：</label></td>
                                        <td nowrap="nowrap" >
                                            <div class=" common_selectbox_wrap">
                                            <select disabled="disabled" id="advanceremind" name="advanceremind" class="w100b codecfg" codecfg="codeId:'common_remind_time'">
                                            </select>
                                            </div>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr height="30px">
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>${ctp:i18n('form.bind.pigeonhole.label')}：</label></td>
                                        <td nowrap="nowrap" >
                                            <div class=" common_selectbox_wrap">
                                            <select disabled="disabled" id="archiveId" class="w100b">
                                            <option selected="selected" value="">${ctp:i18n('form.timeData.none.lable')}</option>
                                            <option value="1">${ctp:i18n('form.bind.selectTo')}</option>
                                            </select>
                                            </div>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr height="30px">
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>是否追溯流程：</label></td>
                                        <td nowrap="nowrap" >
                                            <div class=" common_selectbox_wrap">
                                            <select disabled="disabled" id="canTrackWorkFlow" name="canTrackWorkFlow" class="w100b">
                                            <option selected="selected" value="0">由撤销/回退人决定</option>
                                            <option value="1">追溯</option>
                                            <option value="2">不追溯</option>
                                            </select>
                                            </div>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr height="30px" class="hidden" id="authDetail">
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>${ctp:i18n('form.query.showdetails.label')}：</label></td>
                                        <td nowrap="nowrap">
                                        <table width="100%">
                                        <c:forEach items="${formBean.formViewList}" var="formView">
                                            <tr>
                                            <td  width="30%">
                                            <input type="checkbox" id="view_${formView.id }" value="${formView.id }"/><label for="view_${formView.id }">${formView.formViewName }</label>
                                            </td>
                                            <td width="70%">
                                            <div class=" common_selectbox_wrap" >
                                            <select id="auth_${formView.id }" style="width: 100">
                                            <c:forEach items="${formView.operations}" var="auth">
                                                <option value="${auth.id }">${auth.name }</option>
                                            </c:forEach>
                                            </select>
                                            </div>
                                            </td>
                                            </tr>
                                        </c:forEach>
                                        </table>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr height="30px">
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font></label></td>
                                        <td>
                                            <fieldset>
                                            <div class="common_checkbox_wrap" >
                                            <LABEL class="margin_r_10 hand" for=canForward><INPUT disabled="disabled" checked="checked" id=canForward class=radio_com value=1 type=checkbox name=canForward>${ctp:i18n('collaboration.allow.transmit.label')}</LABEL>
                                            <LABEL class="margin_r_10 hand" for=canModify><INPUT disabled="disabled" checked="checked" id=canModify class=radio_com value=1 type=checkbox name=canModify>${ctp:i18n('collaboration.allow.chanage.flow.label')}</LABEL>
                                            <LABEL class="margin_r_10 hand" for=canArchive><INPUT disabled="disabled" checked="checked" id=canArchive class=radio_com value=1 type=checkbox name=canArchive>${ctp:i18n('collaboration.allow.pipeonhole.label')}</LABEL>
                                            <LABEL class="margin_r_10 hand" for=canEditAttachment><INPUT disabled="disabled" id=canEditAttachment class=radio_com value=1 type=checkbox name=canEditAttachment>${ctp:i18n('collaboration.allow.edit.attachment.label')}</LABEL>
                                            </div>
                                            </fieldset>
                                        </td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr height="30px">
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>${ctp:i18n('form.bind.template.number.label')}：</label></td>
                                        <td >
                                            <div class=" common_txtbox_wrap">
                                            <input readonly="readonly" id="templateNumber" name="templateNumber" type="text" class="w100b validate" validate="errorMsg:'${ctp:i18n('form.bind.template.number.alert.label')}',type:'string',maxLength:20,regExp:/^[A-Za-z0-9_]*$/">
                                            </div>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td colspan="2">
                                         <div style="font_size12">
                                            <font color="green">${ctp:i18n('form.bind.template.number.description.label')}</font>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr height="30px">
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>${ctp:i18n('form.flow.templete.super')}：</label></td>
                                        <td nowrap="nowrap" >
                                            <div class=" common_txtbox_wrap">
                                            <input readonly="readonly" id="showSupervisors" name="showSupervisors" type="text" class="w100b">
                                            <!--  <input readonly="readonly" id="supervisor" name="supervisor" type="hidden"> -->
                                            
                                            </div>
                                        </td>
                                        <td>
                                        <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="supervisorSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
                                        </td>
                                    </tr>
                                    <tr>
                                       <td></td>
                                       <td colspan="2">
                                        <div class="common_checkbox_wrap">
                                        <LABEL class="margin_r_10 hand" for=canSupervise><input disabled="disabled" id="canSupervise" class="radio_com" name="canSupervise" value="1" type="checkbox" checked="checked">${ctp:i18n('form.bind.allowToSupervise')}</LABEL>
                                        </div>
                                       </td>
                                    </tr>
                                    <tr height="30px" id="authRelationTR">
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>${ctp:i18n('form.bind.relationform.auth.set.label')}：</label></td>
                                        <td nowrap="nowrap" >
                                            <div class=" common_txtbox_wrap">
                                            <input readonly="readonly" id="authRelation_txt" name="authRelation_txt" type="text" class="w100b">
                                            <input readonly="readonly" id="authRelation" name="authRelation" type="hidden">
                                            </div>
                                        </td>
                                        <td>
                                        <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="relationAuthSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
                                        </td>
                                    </tr>
                                    <tr id="authRelationAlertTR">
                                        <td>
                                        </td>
                                        <td colspan="2">
                                         <div style="font_size12">
                                            <font color="green">${ctp:i18n('form.bind.relation.auth.alert.label')}</font>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr height="30px">
                                        <td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                                            color="red"></font>${ctp:i18n('common.toolbar.auth.label')}：</label></td>
                                        <td nowrap="nowrap" >
                                            <div class=" common_txtbox_wrap">
                                            <input readonly="readonly" id="auth_txt" name="auth_txt" type="text" class="w100b">
                                            <input readonly="readonly" id="auth" name="auth" type="hidden">
                                            </div>
                                        </td>
                                        <td>
                                        <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="authSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
                                        </td>
                                    </tr>
                                </table>
                    </div>
                    </form>
    </div>
</body>
</html>