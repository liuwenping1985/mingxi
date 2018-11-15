<%--
/**
 * $Author: wangchw $
 * $Rev: 34307 $
 * $Date:: 2014-03-27 17:46:39#$:
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
<title><%-- 选择节点执行人 --%></title>
</head>
<body onkeydown="listenerKeyESC();" marginheight="0" marginwidth="0" class="h100b">
<div class="form_area">
	<div class="form_area_content" style="width:100%;" id="contentHtmlId">
	</div>
</div>
</body>
</html>
<script type="text/javascript">  
<!--
var paramObjs= window.parentDialogObj['workflow_dialog_showWorkFlowMultiPeopleSelectPage_Id'].getTransParams();
//var contentHtmlObj= window.dialogArguments.contentHtmlObj;
//var toNodeId= window.dialogArguments.toNodeId;

var contentHtmlObj= paramObjs.contentHtmlObj;
var toNodeId= paramObjs.toNodeId;
var selectedPeopleIds= paramObjs.selectedPeopleIds;
$(function(){
  $("#contentHtmlId").html(contentHtmlObj.html());
  var inputName= "preMatchPeople_"+toNodeId;
  $("input[name='"+inputName+"']").each(function(i) {
        var value= $(this).attr("value");
        if(selectedPeopleIds && selectedPeopleIds.indexOf(value)!=-1){
            $(this).attr("checked","checked");
        }
  });
});

function OK(jsonArgs) {
  var innerButtonId= jsonArgs.innerButtonId;
  if(innerButtonId=='ok'){
    var inputName= "preMatchPeople_"+toNodeId;
    var toNodeIdSize= $("input[name='"+inputName+"']:checked").length;
    if(toNodeIdSize==0){
      $.alert("请选择人员!");
    }else{
      var userIdsStr = "";
      var userNamesStr = "";
      $("input[name='"+inputName+"']:checked").each(function(i) {
        var pId= $(this).attr("value");
        var pName= $(this).attr("pname");
        //alert("pId:="+pId+";pName:="+pName);
        if(userIdsStr.indexOf(pId)==-1){
          userIdsStr += pId;
          userNamesStr += pName;
          if(i < toNodeIdSize-1){
            userIdsStr += ",";
            userNamesStr += "、";
          }
        }
        $(this).removeAttr("checked");
      });
      if(userIdsStr.lastIndexOf(",")==userIdsStr.length-1){
        userIdsStr= userIdsStr.substring(0,userIdsStr.length-2);
      }
      if(userNamesStr.lastIndexOf("、")==userNamesStr.length-1){
        userNamesStr= userNamesStr.substring(0,userNamesStr.length-1);
      }
      var returnValue= new Array();
      returnValue.push(userIdsStr);
      returnValue.push(userNamesStr);
      return returnValue;
    }
  }
}

/**
 * 多人列表选择页面检索函数
 */
 function workflowPeoplesSearch(toNodeId){
   var searchInputText= $("#workflow_multi_peoples_div_search_"+toNodeId).attr('value');
   var inputName= "preMatchPeople_"+toNodeId;
   var toNodeIdSize= $("input[name='"+inputName+"']").length;
   $("input[name='"+inputName+"']").each(function(i) {
     var pName= $(this).attr("pname");
     if((pName.toLowerCase()).indexOf(searchInputText.trim().toLowerCase())!=-1){
       $(this).parent().parent().css("display","");
       if($("#allCheckbox_"+toNodeId).attr("checked")){
         $(this).attr("checked","checked");
       }
     }else{
       $(this).parent().parent().css("display","none");
       //var checked= $(this).attr("checked");
       //if(checked){
         //$(this).removeAttr("checked");
       //}
     }
   });
 }
 
 /**
  * 是否全部选中
  */
  function workflowSelectAll(allButton, targetName,toNodeId){
	  var checkboxObjs= document.getElementsByName(targetName+"");
	  for(var i=0;i<checkboxObjs.length;i++){
		  var checkObj= checkboxObjs[i];
		  if($(allButton).attr("checked")){
			  if($(checkObj).parent().parent().css("display")=='none'){
				$(checkObj).removeAttr("checked");
			  }else{
				$(checkObj).attr("checked",true);
			  }
	      }else{
              $(checkObj).removeAttr("checked");
          }
	  }
  }
//-->
</script>