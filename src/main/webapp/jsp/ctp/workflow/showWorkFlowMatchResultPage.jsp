<%--
/**
 * $Author: wangchw $
 * $Rev: 51044 $
 * $Date:: 2015-08-06 15:40:58#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
<title>${ctp:i18n("workflow.commonpage.branchpeoplenewflow.select")}</title>
</head>
<body onkeydown="listenerKeyESC();" marginheight="0" marginwidth="0" class="h100b">
<input type="hidden" id="workflow_node_condition_input" name="workflow_node_condition_input" value="">
<input type="hidden" id="workflow_node_peoples_input" name="workflow_node_peoples_input" value="">
<input type="hidden" id="workflow_node_peoples_name_input" name="workflow_node_peoples_name_input" value="">
<input type="hidden" id="workflow_newflow_input" name="workflow_newflow_input" value="">
<table width="100%" cellspacing="5" border="0" class="padding_5" id="workflowMatchResultTable" >
<tr>
<td id="div_workflow_001"></td>
</tr>
<tr>
<td id="div_workflow_002"></td>
</tr>
</table>
</body>
</html>
<script type="text/javascript" src="${path}/common/workflow/workflowDesigner_ajax.js${ctp:resSuffix()}"></script>
<script type="text/javascript">  
<!--
var wfAjax= new WFAjax();
//var context1= window.dialogArguments.context;
//var cpMatchResult1= window.dialogArguments.cpMatchResult;
var paramObjs= window.parentDialogObj['workflow_dialog_showWorkFlowMatchResultPage_Id'].getTransParams();
var context1= paramObjs.context;
var cpMatchResult1= paramObjs.cpMatchResult;
var isNeedCheckLevelScope = paramObjs.isNeedCheckLevelScope;
var context = jQuery.extend(true, {}, context1);
var cpMatchResult = jQuery.extend(true, {}, cpMatchResult1);
var needSelectPeopleNodeNum= 0;//需要选择人员的节点数
var realSelectPeopleNodeNum= 0;//实际选择人员的节点数
var appName= context['appName'];
var matchRequestToken= context["matchRequestToken"];

$(function(){
  showWorkflowMatchResult(cpMatchResult);
  $("body").comp();
});

var nodeIdAndNodeNameMap= new Object();
function showWorkflowMatchResult(cpMatchResult){
  needSelectPeopleNodeNum= 0;//初始化
  realSelectPeopleNodeNum= 0;//初始化
  $("#div_workflow_001").html("");
  $("#div_workflow_002").html("");
  var $tObj= $("#workflowMatchResultTable");
  var t1="<div id=\"conditionDiv\">";
  t1 +="<fieldset style=\"padding-bottom: 4px;\">";
  t1 +=     "<legend id=\"workflow_branch_people\">";
  t1 +=         "<span style=\"color:black\">${ctp:i18n('workflow.commonpage.branchpeople.select')}</span>";
  t1 +=     "</legend>";
  t1 +=     "<table border=\"0\" id=\"workflow_select_people_or_branch\" cellpadding=\"5\" cellspacing=\"1\" style=\"width:100%;\">";
  t1 +=         "<tr id=\"workflow_select_people_or_branch_template\" style=\"display:none;\">";
  t1 +=             "<td id=\"workflow_branch_checkbox\" nowrap=\"nowrap\" class=\"padding_5\"></td>";
  t1 +=             "<td id=\"workflow_branch_tonodename\" width=\"230\" class=\"padding_5\"></td>";
  t1 +=             "<td id=\"workflow_branch_processmode\" nowrap=\"nowrap\" class=\"padding_5\"></td>";
  t1 +=             "<td id=\"workflow_branch_matchresult\" width=\"250\" class=\"padding_5 padding_tb_10\"></td>";
  t1 +=             "<td id=\"workflow_branch_banktd\" nowrap=\"nowrap\" class=\"padding_5\"></td>";
  t1 +=             "<td id=\"workflow_branch_selectpople_manual\" nowrap=\"nowrap\" class=\"padding_5\"></td>";
  t1 +=             "<td id=\"workflow_branch_selectpople\" nowrap=\"nowrap\" class=\"padding_5\"></td>";
  t1 +=             "<td id=\"workflow_branch_selectpople_multi\" nowrap=\"nowrap\" class=\"padding_5\"></td>";
  t1 +=             "<td id=\"workflow_branch_selectpople_msginfo\" nowrap=\"nowrap\" class=\"padding_5\"></td>";
  t1 +=         "</tr>";
  t1 +=      "</table>";
  t1 +="</fieldset>";
  t1 +="<table border=\"0\" width=\"100%\"><tr><td align=\"right\" class=\"font_size12 padding_5\" id=\"workflow_branch_show\"></td></tr></table>";
  t1 +="</div>";
  var $t1Obj= $(t1);
  var $template_table= $("#workflow_select_people_or_branch",$t1Obj);
  var $template_tr= $("#workflow_select_people_or_branch_template",$t1Obj);
  var $template_td_branch_show= $("#workflow_branch_show",$t1Obj);
  
  var t2="<div id=\"newflowDIV\">";
  t2 +="<fieldset style=\"padding-bottom: 4px;\">";
  t2 +=     "<legend id=\"workflow_subprocess_branch_people\">";
  t2 +=         "<span style=\"color:black\">${ctp:i18n('workflow.commonpage.newflow.select')}</span>";
  t2 +=     "</legend>";
  t2 +=     "<table border=\"0\" id=\"workflow_select_subprocess\" border=\"0\" cellpadding=\"1\" cellspacing=\"3\" style=\"width:100%;\">";
  t2 +=         "<tr id=\"workflow_select_subprocess_template\">";
  t2 +=             "<td id=\"workflow_subprocess_checkbox\" nowrap=\"nowrap\" class=\"padding_5\"></td>";
  t2 +=             "<td id=\"workflow_subprocess_name\" width=\"100%\"  class=\"padding_5\"></td>";
  //t2 +=             "<td id=\"workflow_subprocess_matchresult\" nowrap=\"nowrap\" class=\"padding_5\"></td>";
  //t2 +=             "<td id=\"workflow_subprocess_banktd\" width=\"100%\" nowrap=\"nowrap\" class=\"padding_5\"></td>";
  t2 +=             "<td id=\"workflow_subprocess_selectpople_manual\" align=\"right\" nowrap=\"nowrap\" class=\"padding_5\"></td>";
  t2 +=             "<td id=\"workflow_subprocess_selectpople\" nowrap=\"nowrap\" class=\"padding_5\"></td>";
  t2 +=             "<td id=\"workflow_subprocess_selectpople_multi\" nowrap=\"nowrap\" class=\"padding_5\"></td>";
  t2 +=         "</tr>";
  t2 +=      "</table>";
  t2 +="</fieldset>";
  t2 +="</div>";
  var $t2Obj= $(t2);
  var $template_sub_table= $("#workflow_select_subprocess",$t2Obj);
  var $template_sub_tr= $("#workflow_select_subprocess_template",$t2Obj);
  
  var bankHtmlContent= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
  bankHtmlContent += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
  
  //节点分支和人员选择部分,condtionMatchMap为null的话，$.each循环它会报错，所以如果为null赋为{}
  var condtionMatchMap= cpMatchResult["condtionMatchMap"] || {};
  var invalidateActivityMap= cpMatchResult["invalidateActivityMap"] || {};
  var has1= false;
  var has3= false;
  var isBranchShowSuccess= false;
  var isBranchShowFail= false;
  var isHasConditionType2= true;
  var allCanSeeTr = [];

  var condtionMatchMapKeyList = cpMatchResult["condtionMatchMapKeyList"];
  
  $.each(condtionMatchMapKeyList, function(i, key) {
	valueObject = condtionMatchMap[key];
    var conditionType= valueObject["conditionType"];
    var processMode= valueObject["processMode"];
    var processModeName= valueObject["processModeName"];
    var hasBranch= valueObject["hasBranch"];
    var isDefaultShow= valueObject["defaultShow"];
    var matchResult= valueObject["matchResult"];
    var matchResultName= valueObject["matchResultName"];
    var needSelectPeople= valueObject["needSelectPeople"];
    var peoples= valueObject["peoples"];
    var hand= valueObject["hand"];
    var fromNodeId= valueObject["fromNodeId"];
    var toNodeId= valueObject["toNodeId"];
    var toNodeName= escapeSpecialChar(valueObject["toNodeName"]);
	nodeIdAndNodeNameMap[toNodeId]= toNodeName;
    var conditionId= valueObject["id"];
    var isInformNode= valueObject["toNodeIsInform"];
    var conditionDesc= valueObject["conditionDesc"] || "";
    conditionDesc = conditionDesc.replace(/(\r\n*|\r*\n)/g,'<br/>');
    conditionDesc = conditionDesc==null?"":$.trim(conditionDesc);
    var conditionTitle= escapeSpecialChar(valueObject["conditionTitle"]+"");
    var nodePolicy = escapeSpecialChar(valueObject["nodePolicy"]);
    var na= valueObject["na"];
    var needPeopleTag= valueObject["needPeopleTag"];
    //alert("na:="+na+";needPeopleTag:="+needPeopleTag);
    //alert(isDefaultShow);
    //alert("hasBranch:="+hasBranch+";hand:="+hand+";needSelectPeople:="+needSelectPeople);
    var invalidateActivityMapStr= invalidateActivityMap[toNodeId];
    var isNodeValidate= (invalidateActivityMapStr!=null && invalidateActivityMapStr.trim()!="")?true:false;
    if(
        hasBranch//分支条件
        || hand//需要手工选择
        || needSelectPeople//需要选择人员
        ){
      if(hasBranch && conditionType!='2'){
        has3= true;
      }
      has1= true;
      var row = $template_tr.clone().css("display","");
      allCanSeeTr.push(row);
      if( hand && matchResult){
        isBranchShowSuccess= true;
        if(conditionType!='2'){
          isHasConditionType2= false;
        }
        var htmlContent= "<input onclick=showSelectPeoplePart(this,\""+toNodeId+"\",\""+processMode+"\",\""+needSelectPeople+"\",\""+na+"\",\""+needPeopleTag+"\") type=\"checkbox\"";
        htmlContent += " checked=\"checked\" na=\""+na+"\" processMode=\""+processMode+"\" needPeopleTag=\""+needPeopleTag+"\" id=\""+toNodeId+"\" name=\""+toNodeId+"\" isInform=\""+isInformNode+"\"";
        htmlContent += " nodeNamee=\""+toNodeName+"\" isForce=\""+!hand+"\" defaultShow=\""+isDefaultShow+"\" conditionType=\""+conditionType+"\">";
        row.find("#workflow_branch_checkbox").html(htmlContent);
        if(needSelectPeople){
          needSelectPeopleNodeNum ++;
        }
      }else if( hand && !matchResult ){
        if(!isDefaultShow){
          row.css("display","none");
          allCanSeeTr.pop();
          isBranchShowFail= true;
        }
        if(conditionType!='2'){
          isHasConditionType2= false;
        }
        var htmlContent= "<input onclick=showSelectPeoplePart(this,\""+toNodeId+"\",\"\",\""+processMode+"\",\""+needSelectPeople+"\",\""+na+"\",\""+needPeopleTag+"\") type=\"checkbox\"";
        htmlContent += "  id=\""+toNodeId+"\"  na=\""+na+"\"  processMode=\""+processMode+"\" needPeopleTag=\""+needPeopleTag+"\"  name=\""+toNodeId+"\" isInform=\""+isInformNode+"\"";
        htmlContent += " nodeNamee=\""+toNodeName+"\" isForce=\""+!hand+"\" defaultShow=\""+isDefaultShow+"\" conditionType=\""+conditionType+"\">";
        row.find("#workflow_branch_checkbox").html(htmlContent);
      }else if(!hand && matchResult){
        isBranchShowSuccess= true;
        if(hasBranch){
          var htmlContent= "<input onclick=showSelectPeoplePart(this,\""+toNodeId+"\",\""+processMode+"\",\""+needSelectPeople+"\",\""+na+"\",\""+needPeopleTag+"\") type=\"checkbox\"";
          htmlContent += " checked=\"checkbox\"  na=\""+na+"\"   processMode=\""+processMode+"\" needPeopleTag=\""+needPeopleTag+"\" disabled=\"disabled\" id=\""+toNodeId+"\" name=\""+toNodeId+"\"";
          htmlContent += " isInform=\""+isInformNode+"\" nodeNamee=\""+toNodeName+"\" isForce=\""+!hand+"\" defaultShow=\""+isDefaultShow+"\" conditionType=\""+conditionType+"\">";
          row.find("#workflow_branch_checkbox").html(htmlContent);
        }else{
          var htmlContent= "<input  type='hidden'";
          htmlContent += " id='common_branch_nodes' value='"+toNodeId+"' name='common_node_"+toNodeId+"'";
          htmlContent += " isInform='"+isInformNode+"' isSelect='true' nodeNamee='"+toNodeName+"' isForce='"+!hand+"' conditionType='"+conditionType+"'>";
          row.find("#workflow_branch_checkbox").html(htmlContent);
        }
        if(needSelectPeople){
          needSelectPeopleNodeNum ++;
        }
      }else if(!hand && !matchResult){
        if(hasBranch){
          isBranchShowFail= true;
          row.css("display","none"); 
          var htmlContent= "<input onclick=showSelectPeoplePart(this,\""+toNodeId+"\",\""+processMode+"\",\""+needSelectPeople+"\",\""+na+"\",'"+needPeopleTag+"') type=\"checkbox\"";
          htmlContent += " disabled=\"disabled\"  na=\""+na+"\"  processMode=\""+processMode+"\" needPeopleTag=\""+needPeopleTag+"\"  id=\""+toNodeId+"\" name=\""+toNodeId+"\" isInform=\""+isInformNode+"\"";
          htmlContent += " nodeNamee=\""+toNodeName+"\" isForce=\""+!hand+"\" defaultShow=\""+isDefaultShow+"\" conditionType=\""+conditionType+"\">";
          row.find("#workflow_branch_checkbox").html(htmlContent);
        }
      }
      var toNodeNameHtml= toNodeName;
      if(isNodeValidate){
        toNodeNameHtml= "<font color='red'>"+toNodeName+"</font>";
      }
      if(nodePolicy && nodePolicy!=''){
        toNodeNameHtml += '<font class="color_gray2">['+nodePolicy+']</font>';
      }else{
        toNodeNameHtml += '<font class="color_gray2"></font>';
      }
      if(!(!hand && !matchResult)){
        if(hasBranch){
          row.find("#workflow_branch_tonodename").html(toNodeNameHtml);
          row.find("#workflow_branch_processmode").text("("+processModeName+")");
          
          conditionTitle = formatConditionTitle(conditionTitle)
          row.find("#workflow_branch_matchresult").html("<textarea id=\"conditionTitle_"+toNodeId+"\" style=\"display:none\">"
              +conditionTitle+"</textarea><a  class=\"color_blue\"  id=\"conditionTitle_"+toNodeId+"_a\"  title=\""+conditionTitle+"\""
              +">"+matchResultName+"</a>"+(conditionDesc==""?'':'<br/><br/>')+'<font class="color_2b2b2b" style="line-height:16px;">'+conditionDesc+'</font>');
          
        }else{
          row.find("#workflow_branch_tonodename").html(toNodeNameHtml);
          row.find("#workflow_branch_processmode").text("("+processModeName+")");
          row.find("#workflow_branch_matchresult").text("");
        }
      }else{
        if(hasBranch){
          row.find("#workflow_branch_tonodename").html(toNodeNameHtml);
          row.find("#workflow_branch_processmode").text("("+processModeName+")");
          conditionTitle = formatConditionTitle(conditionTitle);
          row.find("#workflow_branch_matchresult").html("<textarea id=\"conditionTitle_"+toNodeId+"\" style=\"display:none\">"
              +conditionTitle+"</textarea><a  class=\"color_blue\" id=\"conditionTitle_"+toNodeId+"_a\"   title=\""+conditionTitle+"\""
              +">"+matchResultName+"</a>"+(conditionDesc==""?'':'<br/><br/>')+'<font class="color_2b2b2b" style="line-height:16px;">'+conditionDesc+'</font>');
        }else{
          row.find("#workflow_branch_tonodename").html(toNodeNameHtml);
          row.find("#workflow_branch_processmode").text("("+processModeName+")");
          row.find("#workflow_branch_matchresult").text("");
        }
      }
      row.find("#workflow_branch_banktd").text("");
      //alert(needSelectPeople);
      if(needSelectPeople){
        var htmlContent =  "<input type=\"hidden\" id=\"manual_select_node_id"+toNodeId+"\"";
        htmlContent += " name=\"manual_select_node_id"+toNodeId+"\" inputName=\""+toNodeName;
        htmlContent += "${ctp:i18n('workflow.commonpage.executor')}${ctp:i18n('workflow.commonpage.selectpeople.notnull')}\">";
        if(matchResult){
          htmlContent += "<div id=\"node_"+toNodeId+"_peoples_div\">${ctp:i18n('workflow.commonpage.executor')}:</div>";
        }else{
          htmlContent += "<div style=\"display:none\" id=\"node_"+toNodeId+"_peoples_div\">${ctp:i18n('workflow.commonpage.executor')}:</div>";
        }
        row.find("#workflow_branch_selectpople_manual").html(htmlContent);
        var htmlContent= "";
        if(null==peoples || peoples.length == 0){//节点上没有匹配到人员
          if(processMode=="single"){//单人,调用选人界面
            if(matchResult){
              htmlContent += "<input id=\"node_"+toNodeId+"_peoples\" name=\"node_"+toNodeId+"_peoples\"";
              htmlContent += " type=\"text\" readonly onclick=\"selectPeople(this,'1', 'manual_select_node_id"+toNodeId+"')\"";
              htmlContent += " style=\"width: 120px;cursor: hand;\" value=\"${ctp:i18n('workflow.commonpage.selectpeople.default')}\">";
              row.find("#workflow_branch_selectpople").html(htmlContent);
            }else{
              htmlContent += "<input id=\"node_"+toNodeId+"_peoples\" name=\"node_"+toNodeId+"_peoples\"";
              htmlContent += " type=\"text\" readonly onclick=\"selectPeople(this,'1', 'manual_select_node_id"+toNodeId+"')\"";
              htmlContent += " style=\"width: 120px;cursor: hand;display:none;\" value=\"${ctp:i18n('workflow.commonpage.selectpeople.default')}\">";
              row.find("#workflow_branch_selectpople").html(htmlContent);
            }
          }else{//多人,调用选人界面
            if(matchResult){ 
              /* var htmlContent= "<input type=\"text\" id=\"spc2\" name=\"spc1\" class=\"comp\" comp=\"type:'selectPeople',";
              htmlContent += "mode:'open',panels:'Account,Department,Team,Post,Level,Role,Outworker',";
              htmlContent += "selectType:'Account,Department,Team,Post,Level,Role,Outworker',showFlowTypeRadio: true\"/>"; */
              htmlContent += "<input id=\"node_"+toNodeId+"_peoples\" name=\"node_"+toNodeId+"_peoples\"";
              htmlContent += " type=\"text\" readonly onclick=\"selectPeople(this,'N', 'manual_select_node_id"+toNodeId+"')\"";
              htmlContent += " style=\"width: 120px;cursor: hand;\" value=\"${ctp:i18n('workflow.commonpage.selectpeople.default')}\">";
              row.find("#workflow_branch_selectpople").html(htmlContent);
            }else{
              htmlContent += "<input id=\"node_"+toNodeId+"_peoples\" name=\"node_"+toNodeId+"_peoples\"";
              htmlContent += " type=\"text\" readonly onclick=\"selectPeople(this,'N', 'manual_select_node_id"+toNodeId+"')\"";
              htmlContent += " style=\"width: 120px;cursor: hand;display:none;\" value=\"${ctp:i18n('workflow.commonpage.selectpeople.default')}\">";
              row.find("#workflow_branch_selectpople").html(htmlContent);
            }              
          }
        }else{//节点上匹配到人员
          if(processMode=="single"){//单人，下拉选择
            var $html_select;
            if(matchResult){
              htmlContent += "<select onchange=\"setSelectValue(this, 'manual_select_node_id"+toNodeId+"')\"";
              htmlContent += " id=\"node_"+toNodeId+"_peoples\" name=\"node_"+toNodeId+"_peoples\" style=\"width: 120px;\" class=\"comp\" comp=\"type:'autocomplete'\"></select>";
              $html_select= $(htmlContent);
            }else{
              htmlContent += "<select onchange=\"setSelectValue(this, 'manual_select_node_id"+toNodeId+"')\"";
              htmlContent += " id=\"node_"+toNodeId+"_peoples\" name=\"node_"+toNodeId+"_peoples\" style=\"width: 120px;display:none;\" class=\"comp\" comp=\"type:'autocomplete',visibility:false\"></select>";
              $html_select= $(htmlContent);
            }
            var $html_option= $("<option value=\"\"></option>");
            $html_option.appendTo($html_select);
            var pSize= peoples.length;
            for(var i=0; i<pSize; i++){
              var a_people= peoples[i];
              if(a_people!=null){
                  var people_id= a_people["id"];
                  var people_name= a_people["name"];
                  var title= a_people["title"];
                  var $html_option1= $("<option title=\""+title+"\" value=\""+people_id+"\">"+escapeSpecialChar(people_name)+"</option>");
                  $html_option1.appendTo($html_select);
              }
            }
            row.find("#workflow_branch_selectpople").html($html_select);
          }else {//多人，弹出人员选择列表
            var multiPeoplesTableHtml = "<div style=\"display:none\" id=\"workflow_multi_peoples_div_"+toNodeId+"\">";
            multiPeoplesTableHtml += "<div><table cellpadding=\"0\" cellspacing=\"0\"  border=\"0\" width=\"100%\">";
            multiPeoplesTableHtml += "<tr  class=\"page_color padding_5\"><td class=\"padding_5\"></td>";
            multiPeoplesTableHtml += "<td class=\"padding_5\" nowrap=\"nowrap\" align=\"right\">";
            multiPeoplesTableHtml += "${ctp:i18n('common.personnel.label')}: <input type=\"text\"";
            multiPeoplesTableHtml += " onkeypress=\"if(event.keyCode == 13) workflowPeoplesSearch('"+toNodeId+"')\"";
            multiPeoplesTableHtml += " name=\"workflow_multi_peoples_div_search_"+toNodeId+"\"";
            multiPeoplesTableHtml += " id=\"workflow_multi_peoples_div_search_"+toNodeId+"\">";
            multiPeoplesTableHtml += "<span class=\"ico16 search_16\"";
            multiPeoplesTableHtml += " id=\"workflow_multi_peoples_button"+toNodeId+"\"";
            multiPeoplesTableHtml += "  onclick=\"workflowPeoplesSearch('"+toNodeId+"')\" ></span>";
            multiPeoplesTableHtml += "</td></tr></table>";
            multiPeoplesTableHtml += "<table class=\"only_table edit_table\" border=\"0\" cellSpacing=\"0\"";
            multiPeoplesTableHtml += " cellPadding=\"0\" width=\"100%\">";
            multiPeoplesTableHtml += "<thead>";
            multiPeoplesTableHtml += "<tr class=\"padding_5\"><th style=\"text-align:right;\" width=\"10%\">";
            var parameters= "workflowSelectAll(this, 'preMatchPeople_"+toNodeId+"','"+toNodeId+"')";
            multiPeoplesTableHtml += "&nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' id=\"allCheckbox_"+toNodeId+"\" onclick=\""+parameters+"\" /></th>";
            multiPeoplesTableHtml += "<th>${ctp:i18n('common.personnel.label')}</th><th>${ctp:i18n('common.toolbar.department.label')}</th><th>${ctp:i18n('common.toolbar.post.label')}</th></tr>";
            multiPeoplesTableHtml += "</thead><tbody>";
            var pSize= peoples.length;
            for(var i=0; i<pSize; i++){
              var a_people= peoples[i];
              var people_id= a_people["id"];
              var depName = escapeSpecialChar(a_people["depName"]);
              if(depName.length>15){
                depName = depName.substr(0,14)+"...";
              }
              var postName = escapeSpecialChar(a_people["postName"]);
              if(postName.length>15){
                postName = postName.substr(0,14)+"...";
              }
              var people_name= escapeSpecialChar(a_people["name"]);
              if(people_name.length>15){
                people_name = people_name.substr(0,14)+"...";
              }
              var nametitle= escapeSpecialChar(a_people["name"]);
              var deptitle= escapeSpecialChar(a_people["depName"]);
              var posttitle= escapeSpecialChar(a_people["postName"]);
              var html_tr1= "<tr class=\"padding_5\"><td width=\"10%\" style=\"text-align:right;\">";
              html_tr1 += "&nbsp;&nbsp;&nbsp;&nbsp;<input id=\"CheckBox_"+people_id+"\" name=\"preMatchPeople_"+toNodeId+"\"";
              html_tr1 += " type=\"checkbox\" value=\""+people_id+"\" pname=\""+escapeSpecialChar(people_name)+"\" >";
              html_tr1 += "</td><td title=\""+nametitle+"\">"+people_name+"</td>";
              html_tr1 += "</td><td title=\""+deptitle+"\">"+depName+"</td>";
              html_tr1 += "</td><td title=\""+posttitle+"\">"+postName+"</td></tr>";
              multiPeoplesTableHtml += html_tr1;
            }
            multiPeoplesTableHtml +="</tbody></table></div></div>";
            row.find("#workflow_branch_selectpople_multi").html(multiPeoplesTableHtml);
            if(matchResult){
              htmlContent += "<input id=\"node_"+toNodeId+"_peoples\" name=\"node_"+toNodeId+"_peoples\"";
              htmlContent += " type=\"text\" readonly onclick=\"selectMatchPeople('"+toNodeId+"')\"";
              htmlContent += " style=\"width: 120px;cursor: hand;\"";
              htmlContent += " value=\"${ctp:i18n('workflow.commonpage.selectpeople.default')}\">";
              row.find("#workflow_branch_selectpople").html(htmlContent);
            }else{
              htmlContent += "<input id=\"node_"+toNodeId+"_peoples\" name=\"node_"+toNodeId+"_peoples\"";
              htmlContent += " type=\"text\" readonly onclick=\"selectMatchPeople('"+toNodeId+"')\"";
              htmlContent += " style=\"width: 120px;cursor: hand;display:none;\"";
              htmlContent += " value=\"${ctp:i18n('workflow.commonpage.selectpeople.default')}\">";
              row.find("#workflow_branch_selectpople").html(htmlContent);
            }                
          }
        }
        var matchMsgInfoHtmlContent= "<a href='javascript:void(0)' onclick=\"showMatchMsgInfo('"+toNodeId+"')\">查看原因</a>";
        row.find("#workflow_branch_selectpople_msginfo").html(matchMsgInfoHtmlContent);
      }else{
        if(null!=peoples && peoples.length == 1){
          var a_people= peoples[0];
          var people_id= a_people["id"];
          var people_name= a_people["name"];
          var title= a_people["title"];
          var htmlContent= "";
          var htmlContent1="";
          if(matchResult){
            htmlContent += "<div id=\"node_"+toNodeId+"_peoples_div\">${ctp:i18n('workflow.commonpage.executor')}:</div>";
            htmlContent1 += "<input id=\"node_"+toNodeId+"_peoples\" name=\"node_"+toNodeId+"_peoples\"";
            htmlContent1 += " type=\"text\" readonly ";
            htmlContent1 += " style=\"width: 120px;cursor: hand;\" value=\""+escapeSpecialChar(people_name)+"\" title=\""+title+"\">";
          }else{
            htmlContent += "<div style=\"display:none\" id=\"node_"+toNodeId+"_peoples_div\">${ctp:i18n('workflow.commonpage.executor')}:</div>";
            htmlContent1 += "<input id=\"node_"+toNodeId+"_peoples\" name=\"node_"+toNodeId+"_peoples\"";
            htmlContent1 += " type=\"text\" readonly ";
            htmlContent1 += " style=\"width: 120px;cursor: hand;display:none\" value=\""+escapeSpecialChar(people_name)+"\"  title=\""+title+"\">";
          }
          row.find("#workflow_branch_selectpople_manual").html(htmlContent);
          row.find("#workflow_branch_selectpople").html(htmlContent1);
        }else{
          if(na=="2"){
            row.find("#workflow_branch_selectpople_manual").html("<div id=\"workflow_branch_selectpople_manual_"+toNodeId+"\"></div>");
            row.find("#workflow_branch_selectpople").html("<div id=\"workflow_branch_selectpople_"+toNodeId+"\"></div>");
          }else{
            row.find("#workflow_branch_selectpople_manual").html("");
            row.find("#workflow_branch_selectpople").text(""); 
          }
        }
      }
      row.attr("id","workflow_select_people_or_branch_template_ready");
      row.attr("height","24");
      row.appendTo($template_table);
    }
  });
  if(allCanSeeTr.length>0){
  	for(var iii=0,iiilen=allCanSeeTr.length;iii<iiilen;iii++){
  		allCanSeeTr[iii].find("td").addClass("border_b");
  	}
  	allCanSeeTr[allCanSeeTr.length-1].find("td").removeClass("border_b");
  	allCanSeeTr.length=0;
  }
  //节点新流程触发部分
  var hasSubProcess= cpMatchResult["hasSubProcess"];
  var has2= false;
  if(hasSubProcess){
    var subProcessMatchMap= cpMatchResult["subProcessMatchMap"];
    var index = 0;
    $.each(subProcessMatchMap,function(key,valueObject){
      has2= true;
      index++;
      var isForce= valueObject["force"];
      var subProcessSender= valueObject["subProcessSender"];
      var peoples= valueObject["peoples"];
      var subProcessTempleteName= valueObject["subProcessTempleteName"];
      var triggerResult= valueObject["triggerResult"];
      var triggerResultName= valueObject["triggerResultName"];
      var subProcessId= valueObject["id"];
      var conditionTitle= escapeSpecialChar(valueObject["triggerConditionTitle"]||"");
      var row = $template_sub_tr.clone();
      if(triggerResult){
        if(isForce){
          var htmlContent= "<input onclick=\"showSubSelectPeoplePart(this,'"+subProcessId+"')\"  type='checkbox'";
          htmlContent += " checked='checked' disabled='disabled' id='"+subProcessId+"' name='"+subProcessId+"'";
          htmlContent += " isForce='"+isForce+"' triggerResult='"+triggerResult+"' >";
          row.find("#workflow_subprocess_checkbox").html(htmlContent);
        }else{
          var htmlContent= "<input onclick=\"showSubSelectPeoplePart(this,'"+subProcessId+"')\"  type='checkbox'";
          htmlContent += " checked='checked' id='"+subProcessId+"' name='"+subProcessId+"' isForce='"+isForce+"'";
          htmlContent += " triggerResult='"+triggerResult+"' >";
          row.find("#workflow_subprocess_checkbox").html(htmlContent);
        }
      }else{
        if(isForce){
          var htmlContent= "<input onclick=\"showSubSelectPeoplePart(this,'"+subProcessId+"')\"  type='checkbox'";
          htmlContent += " disabled='disabled' id='"+subProcessId+"' name='"+subProcessId+"' isForce='"+isForce+"'";
          htmlContent += " triggerResult='"+triggerResult+"' >";
          row.find("#workflow_subprocess_checkbox").html(htmlContent);
        }else{
          var htmlContent= "<input onclick=\"showSubSelectPeoplePart(this,'"+subProcessId+"')\"  type='checkbox'";
          htmlContent += " id='"+subProcessId+"' name='"+subProcessId+"' isForce='"+isForce+"'";
          htmlContent += " triggerResult='"+triggerResult+"' >";
          row.find("#workflow_subprocess_checkbox").html(htmlContent);
        }
      }
      //row.find("#workflow_subprocess_name").text(subProcessTempleteName+"           ["+triggerResultName+"]");
      
      conditionTitle = formatConditionTitle(conditionTitle);
      row.find("#workflow_subprocess_name").html("<textarea id=subflowtitle"+index+" style=\"display:none\">"
              +conditionTitle+"</textarea>"+subProcessTempleteName+"<a  class=\"color_blue\"  id=\"subflowtitle"+index+"_a\"  title=\""+conditionTitle+"\""
              +">           ["+triggerResultName+"]"+"</a>");
      //row.find("#workflow_subprocess_matchresult").html("["+triggerResultName+"]");
      //row.find("#workflow_subprocess_banktd").text("");
      //peoples= null;
      if(null== peoples || peoples.length== 0){//弹出选人界面
        var htmlContent= "<input id=\"senderId_"+subProcessId+"\" name=\"senderId_"+subProcessId+"\"";
        htmlContent += " type=\"hidden\" value=\"\" inputName=\""+subProcessTempleteName+"\" />";
        if(triggerResult){
          htmlContent += "<div id=\"senderLabel_"+subProcessId+"\">${ctp:i18n('workflow.branch.sender')}:<div>";
        }else{
          htmlContent += "<div style=\"display:none\" id=\"senderLabel_"+subProcessId+"\">${ctp:i18n('workflow.branch.sender')}:<div>";
        }
        row.find("#workflow_subprocess_selectpople_manual").html(htmlContent);
        if(triggerResult){
          var htmlContent= "<input name=\"senderId_"+subProcessId+"Name\" id=\"senderId_"+subProcessId+"Name\"";
          htmlContent += " type=\"text\" readonly onclick=\"selectPeople(this,'1', 'senderId_"+subProcessId+"')\"";
          htmlContent += " style=\"width: 120px;cursor: hand;\"";
          htmlContent += " value=\"${ctp:i18n('workflow.commonpage.selectpeople.default')}\">";
          row.find("#workflow_subprocess_selectpople").html(htmlContent);
        }else{
          var htmlContent= "<input name=\"senderId_"+subProcessId+"Name\" id=\"senderId_"+subProcessId+"Name\"";
          htmlContent += " type=\"text\" readonly onclick=\"selectPeople(this,'1', 'senderId_"+subProcessId+"')\"";
          htmlContent += " style=\"width: 120px;cursor: hand;display:none;\"";
          htmlContent += " value=\"${ctp:i18n('workflow.commonpage.selectpeople.default')}\">";
          row.find("#workflow_subprocess_selectpople").html(htmlContent);
        }
      }else{//下拉选择
        var htmlContent= "";
        if(triggerResult){
          htmlContent += "<div id=\"senderLabel_"+subProcessId+"\">${ctp:i18n('workflow.branch.sender')}:<div>";
        }else{
          htmlContent += "<div style=\"display:none\" id=\"senderLabel_"+subProcessId+"\">${ctp:i18n('workflow.branch.sender')}:<div>";
        }
        row.find("#workflow_subprocess_selectpople_manual").html(htmlContent);
        var $html_select;
        if(triggerResult){
          var htmlContent= "<select id=\"senderId_"+subProcessId+"\" name=\"senderId_"+subProcessId+"Name\"";
          htmlContent += " style=\"width: 120px;\" >";
          $html_select= $(htmlContent);
        }else{
          var htmlContent= "<select id=\"senderId_"+subProcessId+"\" name=\"senderId_"+subProcessId+"Name\"";
          htmlContent += " style=\"width: 120px;display:none\" >";
          $html_select= $(htmlContent);
        }
        var pSize= peoples.length;
        for(var i=0; i<pSize; i++){
          var a_people= peoples[i];
          var people_id= a_people["id"];
          var people_name= a_people["name"];
          var title= a_people["title"];
          var $html_option1= $("<option title=\""+title+"\" value=\""+people_id+"\">"+escapeSpecialChar(people_name)+"</option>");
          $html_option1.appendTo($html_select);
        }
        row.find("#workflow_subprocess_selectpople").html($html_select);
      }
      row.attr("id","workflow_select_subprocess_template_ready");//改变绑定好数据的行的id
      row.appendTo($template_sub_table);
    });  
  }
  if(has1){//有分支和人员选择
    $t1Obj.appendTo($("#div_workflow_001",$tObj));
  }
  if(has3){//有分支
    if(isBranchShowSuccess && isBranchShowFail){
      $template_td_branch_show.html("${ctp:i18n('workflow.commonpage.branch.click')}<span class='like_a hand' onclick='showFailedCondition(0)'><font class='color_blue'>${ctp:i18n('workflow.commonpage.branch.show.label')}</font></span>${ctp:i18n('workflow.commonpage.branch.show.executor.label')}");
    }else if(isBranchShowFail){
      $template_td_branch_show.html("${ctp:i18n('workflow.commonpage.branch.click')}<span class='like_a hand' onclick='showFailedCondition(1)'><font class='color_blue'>${ctp:i18n('workflow.commonpage.branch.hide.label')}</font></span>${ctp:i18n('workflow.commonpage.branch.hide.executor.label')}");
    }else if(isBranchShowSuccess && !isHasConditionType2){
      $template_td_branch_show.html("${ctp:i18n('workflow.commonpage.branch.click')}<span class='like_a hand' onclick='showFailedCondition(1)'><font class='color_blue'>${ctp:i18n('workflow.commonpage.branch.hide.label')}</font></span>${ctp:i18n('workflow.commonpage.branch.hide.executor.label')}");
    }
  }
  if(has2){//有子流程触发情况
    $t2Obj.appendTo($("#div_workflow_002",$tObj));
  }
  var isShow= isBranchShowSuccess && isBranchShowFail;
  if(!isBranchShowSuccess && isBranchShowFail){
    showFailedCondition(1,isShow);
  }
}

/**
 * 显示/隐藏不满足条件的分支
 * @type:0和1
 */
 function showFailedCondition(type,isShow){
   var hasChanged= false;
   var show= isShow== undefined?true:isShow;
   allCanSeeTr = [];
   $("#workflow_select_people_or_branch tr[id='workflow_select_people_or_branch_template_ready']").each(function(i){
     var $inputObjtemp= $("#workflow_branch_checkbox",$(this));
     var checked= $("input",$inputObjtemp).attr("CHECKED");
     var checked1= $("input",$inputObjtemp).attr("isSelect");
     var isDefaultShow= $("input",$inputObjtemp).attr("defaultShow");
     //alert(checked+";"+checked1+";"+isDefaultShow);
     if(checked || checked1 || isDefaultShow=='true'){
       $(this).css("display","");
       allCanSeeTr.push($(this));
     }else{
       hasChanged= true;
       var dis= $(this).css("display");
       if(dis=='none' || type==0){
         $(this).css("display","");
         allCanSeeTr.push($(this));
       }else{
         $(this).css("display","none");
       }
     }      
   });
   if(allCanSeeTr.length>0){
  	for(var iii=0,iiilen=allCanSeeTr.length;iii<iiilen;iii++){
  		allCanSeeTr[iii].find("td").addClass("border_b");
  	}
  	allCanSeeTr[allCanSeeTr.length-1].find("td").removeClass("border_b");
  	allCanSeeTr.length=0;
  }
   var hideTipStr= "${ctp:i18n('workflow.commonpage.branch.hide.executor.label')}";
   if(hasChanged && show){
     var $template_td_branch_show= $("#workflow_branch_show");
     if(type==0){
       $template_td_branch_show.html("${ctp:i18n('workflow.commonpage.branch.click')}<span class='like_a hand' onclick='showFailedCondition(1)'><font class='color_blue'>${ctp:i18n('workflow.commonpage.branch.hide.label')}</font></span>"+hideTipStr);
     }else{
       $template_td_branch_show.html("${ctp:i18n('workflow.commonpage.branch.click')}<span class='like_a hand' onclick='showFailedCondition(0)'><font class='color_blue'>${ctp:i18n('workflow.commonpage.branch.show.label')}</font></span>${ctp:i18n('workflow.commonpage.branch.show.executor.label')}");
     }
   }
 }
 
 var needPeopleTagObject= new Object();
 
 /** 
  * 是否显示分支后面的选人部分
  */
  function showSelectPeoplePart(checkObj,toNodeId,processMode,isNeedSelectPeople,na,needPeopleTag){
	var toNodeName= nodeIdAndNodeNameMap[toNodeId];
    if(na=="2" && needPeopleTag=="true"){
      if(checkObj.checked){
        var preAllSelectNodesForBranchCheck= new Array();
        var preAllSelectInformNodesForBranchCheck= new Array();
        var currentSelectInformNodesForBranchCheck= new Array();
        var preAllNotSelectNodesForBranchCheck= new Array();
        $("#workflow_select_people_or_branch input[type='checkbox']").each(function(i){//分支
          var nodeId= $(this).attr("id");
          var nodeName= $(this).attr("nodeNamee");
          var nodeIsInform= $(this).attr("isInform");
          var checked= $(this).attr("checked");
          var isForce= $(this).attr("isForce");
          if(checked){
            if(isForce=='false'){
              //cpMatchResult["allSelectNodes"].push(nodeId);
              preAllSelectNodesForBranchCheck.push(nodeId);
              if(nodeIsInform=='true'){
                //cpMatchResult["allSelectInformNodes"].push(nodeId);
                currentSelectInformNodesForBranchCheck.push(nodeId);
                //cpMatchResult["currentSelectInformNodes"].push(nodeId);
              }
              //else{
                //cpMatchResult["currentSelectNodes"].push(nodeId);
              //}
            }
          }else{
            if(isForce=='false'){
              preAllNotSelectNodesForBranchCheck.push(nodeId);
            }
          }
        });
      //把cpMatchResult中的加进来
        if(cpMatchResult["allSelectNodes"] && cpMatchResult["allSelectNodes"].length>0){
          $(cpMatchResult["allSelectNodes"]).each(function(i,value){
            preAllSelectNodesForBranchCheck.push(value);
          });
        }
        if(cpMatchResult["allNotSelectNodes"] && cpMatchResult["allNotSelectNodes"].length>0){
          $(cpMatchResult["allNotSelectNodes"]).each(function(i,value){
            preAllNotSelectNodesForBranchCheck.push(value);
          });
        }
        if(cpMatchResult["allSelectInformNodes"] && cpMatchResult["allSelectInformNodes"].length>0){
          $(cpMatchResult["allSelectInformNodes"]).each(function(i,value){
            preAllSelectInformNodesForBranchCheck.push(value);
          });
        }
        var isMyNeedSelectPeople= wfAjax.transCheckBrachSelectedWorkFlow(context,
            toNodeId,preAllSelectNodesForBranchCheck,
            preAllNotSelectNodesForBranchCheck,
            preAllSelectInformNodesForBranchCheck,currentSelectInformNodesForBranchCheck)|| false;
        if(isMyNeedSelectPeople){//需要选人，则在该节点后面显示选人对话框
          var htmlContent =  "<input type=\"hidden\" id=\"manual_select_node_id"+toNodeId+"\"";
          htmlContent += " name=\"manual_select_node_id"+toNodeId+"\" inputName=\""+toNodeName;
          htmlContent += "${ctp:i18n('workflow.commonpage.executor')}${ctp:i18n('workflow.commonpage.selectpeople.notnull')}\">";
          htmlContent += "<div id=\"node_"+toNodeId+"_peoples_div\">${ctp:i18n('workflow.commonpage.executor')}:</div>";
          $("#workflow_branch_selectpople_manual_"+toNodeId).html(htmlContent);
          var htmlContent1= "";
          if(processMode=="single"){//单人,调用选人界面
              htmlContent1 += "<input id=\"node_"+toNodeId+"_peoples\" name=\"node_"+toNodeId+"_peoples\"";
              htmlContent1 += " type=\"text\" readonly onclick=\"selectPeople(this,'1', 'manual_select_node_id"+toNodeId+"')\"";
              htmlContent1 += " style=\"width: 120px;cursor: hand;\" value=\"${ctp:i18n('workflow.commonpage.selectpeople.default')}\">";
          }else{//多人,调用选人界面
              htmlContent1 += "<input id=\"node_"+toNodeId+"_peoples\" name=\"node_"+toNodeId+"_peoples\"";
              htmlContent1 += " type=\"text\" readonly onclick=\"selectPeople(this,'N', 'manual_select_node_id"+toNodeId+"')\"";
              htmlContent1 += " style=\"width: 120px;cursor: hand;\" value=\"${ctp:i18n('workflow.commonpage.selectpeople.default')}\">";   
          }
          $("#workflow_branch_selectpople_"+toNodeId).html(htmlContent1);
		  needSelectPeopleNodeNum ++;
		  needPeopleTagObject[toNodeId]= toNodeId;
        }else{//去掉该节点后面显示的选人对话框
          $("#workflow_branch_selectpople_manual_"+toNodeId).html("");
          $("#workflow_branch_selectpople_"+toNodeId).html("");
        }
      }else{
        $("#workflow_branch_selectpople_manual_"+toNodeId).html("");
        $("#workflow_branch_selectpople_"+toNodeId).html("");
		if(needPeopleTagObject[toNodeId]){
			needSelectPeopleNodeNum --;
			needPeopleTagObject[toNodeId]="";
		}
      }
    }else{
      var tc = $("#node_"+toNodeId+"_peoples").attr("comp");
      var isAutocomplete = false;
      if(tc){
          var tj = $.parseJSON('{' + tc + '}');
          var tp = tj.type;
          if(tp != null && tp == "autocomplete"){
              isAutocomplete = true;
          }
      }
      if(checkObj.checked){
        if(isAutocomplete){
            $.autocomplete($("#node_"+toNodeId+"_peoples"),{visibility:true});
        } else {
          $("#node_"+toNodeId+"_peoples").css("display","");
        }
        $("#node_"+toNodeId+"_peoples_div").css("display","");
        if(isNeedSelectPeople=='true'){
          needSelectPeopleNodeNum ++;
        }
      }else{
        if(isAutocomplete){
            $.autocomplete($("#node_"+toNodeId+"_peoples"),{visibility:false});
        } else {
          $("#node_"+toNodeId+"_peoples").css("display","none");
        }
        $("#node_"+toNodeId+"_peoples_div").css("display","none");
        if(isNeedSelectPeople=='true'){
          needSelectPeopleNodeNum --;
        }
      }
    }
  }
 
  /**
   * 显示分支描述
   */
   function showConditionTitle(conditionDescId){
     var msgText= $("#"+conditionDescId).val();
     if(msgText!=null){
     	msgText = $.trim(msgText);
     }
     msgText= (msgText==null||msgText==""||msgText=="null" || msgText=="undefined")?"${ctp:i18n('workflow.matchResult.msg5')}":msgText;
     msgText = msgText.replace(/\n/g, '<br/>');
     if(msgText && msgText.length>500){
       msgText= msgText.substring(0,500)+"...";
     }
     $("#"+conditionDescId+"_a").tooltip({
       openAuto:true,
       width:300,
       msg: "<div class='font_size12'>"+msgText+"</div>"
     });
   }
  
  function formatConditionTitle(title){
	  var _title =   (title==null||title==""||title=="null" || title=="undefined")?"${ctp:i18n('workflow.matchResult.msg5')}":title;
	  return _title
  }
  
function isHandSelectOk(){
  var hst= paramObjs.cpMatchResult.hst;
  if(hst!=null){//指定数目
    hst = Number(hst);
    if(hst<=0){
    	return true;
    }
    //获得所有人工选中的分支数目
    var cCount = 0;
    $("input[conditionType=2]").each(function(i){
      var checked= $(this).attr("checked");
      if(checked){
        cCount++;
      }
    });
    if(cCount> hst){
      $.alert("${ctp:i18n('workflow.matchResult.msg1')}"+hst+"，${ctp:i18n('workflow.matchResult.msg2')}");
      return false;
    }
    checkboxs = null;
    return true;
  }
  return true;
}
   function OK(jsonArgs) {
     realSelectPeopleNodeNum= 0;//初始化
     var innerButtonId= jsonArgs.innerButtonId;
     if(innerButtonId=='ok'){
     	if(!isHandSelectOk()){
     		return false;
     	}
       var checkedNum= 0;
       $("#workflow_select_people_or_branch input[type='checkbox']").each(function(i){
         var checked= $(this).attr("checked");
         if(checked){
           checkedNum++;
         }
       });
       var checkedNum1= $("#workflow_select_people_or_branch input[type='checkbox']").size();
       var currentSelectNodes= cpMatchResult["currentSelectNodes"];
       var currentSelectInformNodes= cpMatchResult["currentSelectInformNodes"];
       var allSelectNodes1= cpMatchResult["allSelectNodes"];
       var allNotSelectNodes1= cpMatchResult["allNotSelectNodes"];
       var condtionMatchMap1= cpMatchResult["condtionMatchMap"];
       if(checkedNum<=0 
           && ( null==currentSelectNodes || currentSelectNodes.length<=0) 
           && ( null==currentSelectInformNodes || currentSelectInformNodes.length<=0)
           && ( checkedNum1 > 0)){
         showFlashAlert("${ctp:i18n('workflow.commonpage.branch.notselect')}");
       }else{//校验：选中的分支是否有执行人员,没有则提示选择人员
         var nodeId;
         var inputName;
         var isPass= true;
         $("#workflow_select_people_or_branch tr[id='workflow_select_people_or_branch_template_ready']").each(function(i){
           var $inputObjtemp= $("#workflow_branch_checkbox",$(this));
           var checked= $("input",$inputObjtemp).attr("checked");
           if(checked){
             nodeId= $("input",$inputObjtemp).attr("id");
             if($("#manual_select_node_id"+nodeId)[0]){
               var pIds= $("#manual_select_node_id"+nodeId).attr("value");
               if(pIds==null || pIds==''){
                 inputName= $("#manual_select_node_id"+nodeId).attr("inputName");
                 isPass= false;
                 return false;
               }
             }
           }
         });
         if(isPass){
           $("#workflow_select_people_or_branch input[id='common_branch_nodes']").each(function(i){//选人
             nodeId= $(this).attr("value");
             if($("#manual_select_node_id"+nodeId)[0]){
               var pIds= $("#manual_select_node_id"+nodeId).attr("value");
               if(pIds==null || pIds==''){
                 inputName= $("#manual_select_node_id"+nodeId).attr("inputName");
                 isPass= false;
                 return false;
               }
             }
           }); 
         }
         if(!isPass){
           //showFlashAlert(inputName);
           var random = $.messageBox({
             'type': 100,
             'msg': inputName,
             imgType:"2",
             title: '${ctp:i18n("workflow.systemtip.title") }',
             buttons: [{
             id:'btn1',
                 text: "确定",
                 handler: function () { $("input[name='node_"+nodeId+"_peoples']").click(); }
             }]
           });
           return false;
         }
         //校验：选中的新流程是否有执行人员，没有则提示选择人员
         var subProcessId;
         var subProcessTempleteName;
         $("#workflow_select_subprocess input[type='checkbox']").each(function(i){
           var myChecked= $(this).attr("checked");
           if(myChecked){
             subProcessId= $(this).attr("id");
             var newFlowSenderIdStr= $("#senderId_"+subProcessId).attr("value");
             subProcessTempleteName= $("#senderId_"+subProcessId).attr("inputName");
             if(newFlowSenderIdStr==null || newFlowSenderIdStr==''){
               isPass= false;
               return false;
             }
           }
         });
         if(!isPass){
           //showFlashAlert("${ctp:i18n_1('workflow.commonpage.selectpeople.subprocesssender','"+subProcessTempleteName+"')}");
           var random = $.messageBox({
             'type': 100,
             imgType:"2",
             title: '${ctp:i18n("workflow.systemtip.title") }',
             'msg': "${ctp:i18n_1('workflow.commonpage.selectpeople.subprocesssender','"+subProcessTempleteName+"')}",
             buttons: [{
             id:'btn1',
                 text: "确定",
                 handler: function () { $("#senderId_"+subProcessId+"Name").click(); }
             }]
           });
           return false;
         }
         var invalidateActivityMap= cpMatchResult["invalidateActivityMap"] || {};
         var nodeNameStr= "";
         $(cpMatchResult["allSelectNodes"]).each(function(i,value){
           var nodeNameStr1= invalidateActivityMap[value];
           var isNodeValidate= (nodeNameStr1!=null && nodeNameStr1.trim()!="")?true:false;
           if(isNodeValidate){
             isPass= false;
             nodeNameStr += (nodeNameStr!=null && nodeNameStr.trim()=="")?nodeNameStr1:"、"+nodeNameStr1;
           }
         });
         $("#workflow_select_people_or_branch input[type='checkbox']").each(function(i){//分支
           var checked= $(this).attr("checked");
           var nodeId= $(this).attr("id");
           if(checked){
             var nodeNameStr1= invalidateActivityMap[nodeId];
             var isNodeValidate= (nodeNameStr1!=null && nodeNameStr1.trim()!="")?true:false;
             if(isNodeValidate){
               isPass= false;
               nodeNameStr += (nodeNameStr!=null && nodeNameStr.trim()=="")?nodeNameStr1:"、"+nodeNameStr1;
             }
           }
         });
         if(!isPass){
           $.alert($.i18n('workflow.invalidateActivity.label',nodeNameStr));
           return;
         }
         var selectPeopleNames = {};
         var node_str = "{\"nodeAdditon\":[";
         var isbeforehas= false;
         $("#workflow_select_people_or_branch input[type='checkbox']").each(function(i){//分支
           var nodeId= $(this).attr("id");
           var nodeName= $(this).attr("nodeNamee");
           var nodeIsInform= $(this).attr("isInform");
           var checked= $(this).attr("checked");
           var isForce= $(this).attr("isForce");
           var na= $(this).attr("na");
           if(checked){
             //看是否需要选择人员
             var $workflow_Slelect_Obj= $("#manual_select_node_id"+nodeId);
             //alert(nodeId+";"+$workflow_Slelect_Obj+";"+$workflow_Slelect_Obj[0]);
             var isDoSelectPeople= false;
             if($workflow_Slelect_Obj[0]){
            	 
               var pIdStr= $workflow_Slelect_Obj.attr("value");
                var selectPeopleName = $("#node_"+nodeId+"_peoples_txt").val();
                if(!selectPeopleName){
            	  selectPeopleName = $("#node_"+nodeId+"_peoples").attr('value');
                }
                  selectPeopleNames[nodeId]=selectPeopleName;
               if( pIdStr && pIdStr!=''){
                 node_str += "{\"nodeId\":\""+nodeId+"\",\"pepole\":["+pIdStr +"]},";
                 isbeforehas= true;
                 realSelectPeopleNodeNum ++;
                 isDoSelectPeople= true;
               }
             }
             if(isForce=='false'){
               cpMatchResult["allSelectNodes"].push(nodeId);
               if(nodeIsInform=='true'){
                 if( na=='00' && isDoSelectPeople){
                   cpMatchResult["currentSelectNodes"].push(nodeId);
                 }else{
                   cpMatchResult["allSelectInformNodes"].push(nodeId);
                   cpMatchResult["currentSelectInformNodes"].push(nodeId);
                 }
               }else{
                 cpMatchResult["currentSelectNodes"].push(nodeId);
               }
             }
           }else{
             if(isForce=='false'){
               cpMatchResult["allNotSelectNodes"].push(nodeId);
             }
           }
         });
         
         if(node_str.lastIndexOf(",")==(node_str.length-1)){
           node_str= node_str.substring(0,node_str.length-1);
         }
         $("#workflow_select_people_or_branch input[id='common_branch_nodes']").each(function(i){//选人
           nodeId= $(this).attr("value");
           var $workflow_Slelect_Obj= $("#manual_select_node_id"+nodeId);
           if($workflow_Slelect_Obj[0]){
        	   
             var pIdStr= $workflow_Slelect_Obj.attr("value");
             var selectPeopleName = $("#node_"+nodeId+"_peoples_txt").val();
             if(!selectPeopleName){
         	 	 selectPeopleName = $("#node_"+nodeId+"_peoples").attr('value');
             }
             selectPeopleNames[nodeId]=selectPeopleName;
             if( pIdStr && pIdStr!='' ){
               if(isbeforehas){
                 node_str += ",{\"nodeId\":\""+nodeId+"\",\"pepole\":["+pIdStr +"]}";
                 realSelectPeopleNodeNum ++;
               }else{
                 node_str += "{\"nodeId\":\""+nodeId+"\",\"pepole\":["+pIdStr +"]}";
                 isbeforehas= true;
                 realSelectPeopleNodeNum ++;
               }
             }
           }
         });
         node_str +="]}";
        
         //if(realSelectPeopleNodeNum!=needSelectPeopleNodeNum){//有需要选人的节点，但没有选择，则提示
           //$.alert("校验不通过：请为节点选择执行人员！");
           //return;
         //}
         var oldPopNodeSelected= $("#workflow_node_peoples_input").attr("value");
         if(oldPopNodeSelected.lastIndexOf("nodeAdditon")!=-1 
             && oldPopNodeSelected.lastIndexOf("]}")!=-1 
             && oldPopNodeSelected.lastIndexOf("pepole")!=-1){
           oldPopNodeSelected= oldPopNodeSelected.substring(0,oldPopNodeSelected.lastIndexOf("]}"));
           if(node_str.lastIndexOf("nodeAdditon")!=-1 && node_str.lastIndexOf("]}")!=-1 && node_str.lastIndexOf("pepole")!=-1 ){
               var beginStr= "{\"nodeAdditon\":[";
               node_str= node_str.substring(beginStr.length);
               oldPopNodeSelected +=","+node_str;
               $("#workflow_node_peoples_input").attr("value",oldPopNodeSelected);
           }else{
               oldPopNodeSelected +="]}";
               $("#workflow_node_peoples_input").attr("value",oldPopNodeSelected);
           }
         }else{
           $("#workflow_node_peoples_input").attr("value",node_str);
         }
         //alert("node_str:="+node_str);
         //节点的子流程触发信息
         var hasSubProcess1= cpMatchResult["hasSubProcess"];
         var flow_Str ="";
         var selectSize= 0;
         if(hasSubProcess1){
           $("#workflow_select_subprocess input[type='checkbox']").each(function(i){
             var checked= $(this).attr("checked");
             if(checked){
               selectSize++;
             }
           });
		   var j=0;
           if(selectSize>0){
             $("#workflow_select_subprocess input[type='checkbox']").each(function(i){
               var subProcessId= $(this).attr("id");
               var checked= $(this).attr("checked");
               if(checked){
                 if(j==0){
                   flow_Str += "{\"hasNewflow\":\"true\",\"newFlows\":[";
                 }
             	 var selectPeopleName = $("#senderId_"+subProcessId+"Name").attr('value');
                 selectPeopleNames[subProcessId]=selectPeopleName;
                 var newFlowSenderIdStr= $("#senderId_"+subProcessId)[0].value;
                 if(j==(selectSize-1)){
                   flow_Str +="{\"newFlowId\":\""+subProcessId+"\",\"newFlowSender\":\""+newFlowSenderIdStr+"\"}]}";
                 }else{
                   flow_Str +="{\"newFlowId\":\""+subProcessId+"\",\"newFlowSender\":\""+newFlowSenderIdStr+"\"},";
                 }
				 j++;
               }
             });
           }
           //alert("flow_Str:="+flow_Str);
           cpMatchResult["hasSubProcess"]= false;
           if(flow_Str.length>0 && flow_Str.lastIndexOf(",")==flow_Str.length-1){//fixed OA-60903cxj001--发起一个带有触发子流程的表单，满足条件后处理触发子流程--但是实际查看并未触发出来呢
             flow_Str= flow_Str.substring(0, flow_Str.length-1)+"]}";
           }
           $("#workflow_newflow_input").attr("value",flow_Str);
         }
         var currentSelectInformNodes= cpMatchResult["currentSelectInformNodes"];
         var currentSelectNodes= cpMatchResult["currentSelectNodes"];
		 var allSelectInformNodes= cpMatchResult["allSelectInformNodes"];
		 var realCurrentSelectInformNodes= new Array();
		 var realAllSelectInformNodes= new Array();
		 if(currentSelectInformNodes && currentSelectInformNodes!=null){
		   for(var k=0;k<currentSelectInformNodes.length;k++){
             if(needPeopleTagObject[currentSelectInformNodes[k]]){//可以自动跳过的非知会节点转为不能自动跳过的非知会节点，且变为选中的非知会节点了。
                 currentSelectNodes.push(currentSelectInformNodes[k]);
             }else{
                 realCurrentSelectInformNodes.push(currentSelectInformNodes[k]);
             }
           }
		 }
		 if(allSelectInformNodes && allSelectInformNodes!=null){
		   for(var k=0;k<allSelectInformNodes.length;k++){
             if(needPeopleTagObject[allSelectInformNodes[k]]){//可以自动跳过的非知会节点转为不能自动跳过的非知会节点，且变为选中的非知会节点了。
                 
             }else{
                 realAllSelectInformNodes.push(allSelectInformNodes[k]);
             }
           }
		 }
		 $("#workflow_node_peoples_name_input").val($.toJSON(selectPeopleNames));
		 cpMatchResult["allSelectInformNodes"]= realAllSelectInformNodes;
		 cpMatchResult["currentSelectNodes"]= currentSelectNodes;
	     cpMatchResult["currentSelectInformNodes"]= realCurrentSelectInformNodes;
		 var currentSelectInformNodes= cpMatchResult["currentSelectInformNodes"];
		 if((currentSelectInformNodes!=null && currentSelectInformNodes.length>0) || flow_Str!=""){
           cpMatchResult["pop"]= false;
           cpMatchResult["isPop"]= false;
           cpMatchResult["token"]= "";
           cpMatchResult["last"]= "false";
           var node_str= $("#workflow_node_peoples_input").attr("value");
           context["selectedPeoplesOfNodes"]= node_str;
           var flow_Str= $("#workflow_newflow_input").attr("value");
           if(flow_Str && flow_Str!=""){
        	   context["popNodeSubProcessJson"]= flow_Str;
           }
           cpMatchResult = wfAjax.transBeforeInvokeWorkFlow(context,cpMatchResult)||{};
         
           var result= cpMatchResult["pop"];
           var requestToken= cpMatchResult["token"];
           var humenNodeMatchAlertMsg = cpMatchResult["humenNodeMatchAlertMsg"];
           
           if(humenNodeMatchAlertMsg && humenNodeMatchAlertMsg!=""){
           		$.alert(humenNodeMatchAlertMsg);
               	return;
           }
           
           if(requestToken && requestToken=="WORKFLOW"){
             
           }else{
             $.alert($.i18n('workflow.wapi.exception.msg002'));
             return;
           }
           if(result==true){//显示
             showWorkflowMatchResult(cpMatchResult);
             $(".comp").each(function(i) {
               $(this).compThis();
             });
           }else{//提交流程
             var invalidateActivityMap= cpMatchResult["invalidateActivityMap"] || {};
             var isPass= true;
             var nodeNameStr= "";
             $(cpMatchResult["allSelectNodes"]).each(function(i,value){
               var nodeNameStr1= invalidateActivityMap[value];
               var isNodeValidate= (nodeNameStr1!=null && nodeNameStr1.trim()!="")?true:false;
               if(isNodeValidate){
                 isPass= false;
                 nodeNameStr += (nodeNameStr!=null && nodeNameStr.trim()=="")?nodeNameStr1:"、"+nodeNameStr1;
               }
             });
             if(!isPass){
               $.alert($.i18n('workflow.invalidateActivity.label',nodeNameStr));
               return;
             }else{
               return submitWorkFlow();
             }
           }
         }else{//提交流程
           return submitWorkFlow();
         }
       }
     }
   }
   
   function submitWorkFlow(){
     //转换成350中的json字符串格式，提交至后台
     //所有选中的分支节点和没选中的节点
     var conditon_Str="";
     $(cpMatchResult["allSelectNodes"]).each(function(i,value){
       if(i==0){
         conditon_Str +="{\"condition\":[";
         conditon_Str +="{\"nodeId\":\""+value+"\",";
         conditon_Str +="\"isDelete\":\"false\"}";
       }else{
         conditon_Str +=",{\"nodeId\":\""+value+"\",";
         conditon_Str +="\"isDelete\":\"false\"}";
       }
     });
     if(cpMatchResult["allNotSelectNodes"] && cpMatchResult["allNotSelectNodes"].length>0){
       var last= cpMatchResult["allNotSelectNodes"].length-1;
       $(cpMatchResult["allNotSelectNodes"]).each(function(i,value){
         conditon_Str +=",{\"nodeId\":\""+value+"\",";
         conditon_Str +="\"isDelete\":\"true\"}";
       });
     }
     if(conditon_Str!=""){
       conditon_Str +="]}";
     }
     var flow_Str= $("#workflow_newflow_input").attr("value");
     var node_str= $("#workflow_node_peoples_input").attr("value");
     var node_name_str= $("#workflow_node_peoples_name_input").attr("value");
     var returnObject= new Array();
     returnObject.push(conditon_Str);
     returnObject.push(node_str);
     returnObject.push(flow_Str);
     returnObject.push(cpMatchResult["last"]);
     returnObject.push(node_name_str);
     return returnObject;
   }
   
   function showFlashAlert(args) {
     try{
       var alert = $.alert(args);
       //alert(args);
     }catch(e){
       alert(args);
     }
   }
   
   /**
    * 弹出多人列表页面
    */
    function selectMatchPeople(toNodeId){
      var inputName= "preMatchPeople_"+toNodeId;
      $("input[name='"+inputName+"']").each(function(i) {
        $(this).parent().parent().css("display","");
      });
      var $myObj = $("#workflow_multi_peoples_div_"+toNodeId).clone();
      var selectedPeopleIds= $("#manual_select_node_id"+toNodeId).attr('value');
      $("div",$myObj).attr("id","workflow_multi_peoples_div1_"+toNodeId);
      var dialog = $.dialog({
        id: 'workflow_dialog_showWorkFlowMultiPeopleSelectPage_Id',
        isFromModle: true,
        url : '<c:url value="/workflow/designer.do?method=showWorkFlowMultiPeopleSelectPage"/>',
        width : 500,
        height : 400,
        title : '选择节点执行人',
        transParams : {
          contentHtmlObj:$myObj,
          toNodeId:toNodeId,
          selectedPeopleIds:selectedPeopleIds
        },
        targetWindow:getCtpTop(),
        buttons : [ {
          text : '${ctp:i18n("common.button.ok.label")}',
          handler : function() {
            var returnValue= dialog.getReturnValue({"innerButtonId":"ok"});
            if(returnValue){
              $("#manual_select_node_id"+toNodeId).attr('value',returnValue[0]);
              $("#node_"+toNodeId+"_peoples").attr("title",returnValue[1]);
              $("#node_"+toNodeId+"_peoples").attr('value',returnValue[1]);
              dialog.close();
            }
          }
        },{
          text : '${ctp:i18n("common.button.cancel.label")}',
          handler : function() {        
            dialog.close();
          }
        }]
      });
    }
   
    /**
     * 将下拉列表中选择的值赋给隐藏域中
     */
     function setSelectValue(selectObj, id){
       $("#"+id).attr("value",selectObj.value);
     }
    
     /**
      * 是否显示子流程选人部分
      */
      function showSubSelectPeoplePart(checkObj,subProcessId){
        if(checkObj.checked){
          $("#senderId_"+subProcessId).css("display","");
          $("#senderLabel_"+subProcessId).css("display","");
          $("#senderId_"+subProcessId+"Name").css("display","");
        }else{
          $("#senderId_"+subProcessId).css("display","none");
          $("#senderLabel_"+subProcessId).css("display","none");
          $("#senderId_"+subProcessId+"Name").css("display","none");
        }
      }
     
    /**
     * 弹出选人界面,调用T1提供的选人控件
     */
     function selectPeople(inputObj,singleOrMany, nodeId){
       var currentNodeId = nodeId;
       var maxSize= 1;
       var minSize= 1;
       if(singleOrMany=='1'){
         maxSize= 1;
       }else{
         maxSize= -1;
       }
       var selectPanels= "Department,Team,Post,RelatePeople,Outworker,JoinOrganization";
       if(appName == 'sendEdoc' ||appName == 'edocSend' 
           || appName=='signReport' || appName=='edocSign' 
           || appName=='recEdoc' || appName=='edocRec' 
           || appName == 'edoc' || appName=='sendInfo' || appName=='info'){
         selectPanels= "Department,Team,Post,RelatePeople";
       }
       $.selectPeople({
         type:'selectPeople',
         /* mode:'open', */
         panels: selectPanels,
         selectType:'Member',
         showFlowTypeRadio: false,
         maxSize:maxSize,
         minSize:minSize,
         isNeedCheckLevelScope:isNeedCheckLevelScope,
         params : {
           value: ''
         },
         callback:function(ret){
           if(ret.obj){
             inputObj.value= ret.text;
             inputObj.title= ret.text;
             $("#"+nodeId).attr("value",getIdsString(ret.obj,false));
           }
         }
       });
     }
    
     function escapeSpecialChar(str, cannotConvertltgt){
       if(!str){
           return str;
       }
       if(cannotConvertltgt==true){
    	   str= str.replace(/\&/g, "&amp;").replace(/\"/g, "&quot;");
       }else{
    	   str= str.replace(/\&/g, "&amp;").replace(/\</g, "&lt;").replace(/\>/g, "&gt;").replace(/\"/g, "&quot;");
       }
       str= str.replace(/\'/g,"&#039;").replace(/"/g,"&#034;");
       return str;
     }
     
     function showMatchMsgInfo(myNodeId){
    	 var dialog = $.dialog({
   	        id: 'workflow_dialog_showMatchMsgInfoPage_Id',
   	        isFromModle: true,
   	        url : '<c:url value="/workflow/designer.do?method=showCanotAutoSkipMsgPage"/>&key='+matchRequestToken+'&nodeId='+myNodeId,
   	        width : 1000,
   	        height : 400,
   	        title : '选人原因',
   	        targetWindow:getCtpTop(),
   	        buttons : [ {
   	          text : '${ctp:i18n("common.button.close.label")}',
   	          handler : function() {
   	        	  dialog.close();
   	          }
   	        }]
   	      });
     }
//-->
</script>