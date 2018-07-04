<%--
 $Author:
 $Rev: 
 $Date:: 
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('doc.tree.move.pigeonhole')}</title>
<script type="text/javascript">
  $().ready(function() {
      var defaultNameText = "<${ctp:i18n('doc.log.recommend.postscript')}>";
      new inputChange($("#description"), defaultNameText);
      
      $("#btnok").one("click",fnBtnOK);
      
      function fnBtnOK(){
    	$("#tableForm").resetValidate();
        var val = $("#description").val().trim();
        if (val === defaultNameText) {
            $("#description").val("");
        }
        var isAgree =  $("#tableForm").validate();
      	if (!isAgree){
      		$("#btnok").one("click",fnBtnOK);
      		return;	
      	}
        $("#tableForm").jsonSubmit({
            callback :function(sReturn){
                var oReturn = $.parseJSON(sReturn);
                if(oReturn.success){
                    getCtpTop().$.infor(oReturn.msg);
                }else{
                    getCtpTop().$.alert(oReturn.msg);
                }
                reloadPage();
                closeThisDialog();
            }
        });          
    }
      
      $("#btncancel").click(closeThisDialog);
  });
  
  function closeThisDialog(){
  	  var _dialog = null;
  	  if(!getA8Top().frames['main']){
  	  	_dialog = getA8Top()._dialog;
  	  	getA8Top()._dialog = null;
  	  }else{
  	  	_dialog = getA8Top().frames['main']._dialog;
  	  	getA8Top().frames['main']._dialog = null;
  	  }
      _dialog.close();
  }
  
  function reloadPage(){
      if(!fnKnowledgeBrowseReload()){
          fnReloadSquarePublicity();
          fnReloadLeastCollectMore();
      }
      //老界面刷新
      var oldIframe = $(".mxt-window-body-iframe",getA8Top().document.body);
      if(oldIframe[0]&&oldIframe[0].contentWindow.fnReloadKnowledgeBrowse){
          oldIframe[0].contentWindow.fnReloadKnowledgeBrowse();
      }
  }
  
  //刷新知识查看
  function fnKnowledgeBrowseReload(){
      if(getA8Top().docOpenDialogOnlyId_main_iframe && getA8Top().docOpenDialogOnlyId_main_iframe.fnReloadKnowledgeBrowse){
          return true;
      }
      return false;
  }
  //知识广场
  function fnReloadSquarePublicity(){
      if(getA8Top().main && getA8Top().main.window.fnPageDataLoad){
          getA8Top().main.window.fnPageDataLoad(true);
      }
  }
  
  //刷新个人知识中心最近收藏
  function fnReloadLeastCollectMore(){
      if(getA8Top().main && getA8Top().main.window.fnReload){
          getA8Top().main.window.fnReload();
      }
  }
</SCRIPT>

</head>
<body  class="h100b over_hidden page_color">
<div class="form_area h100b " style="background:rgb(250,250,250);padding:0px 20px;">
  <FORM id=tableForm action="${path}/doc/knowledgeController.do?method=docRecommend">
	    <table class="font_size12 bg_color_white w100b "style="height:170px;padding-top:5px;background:#fafafa;" border="0" cellspacing="0" cellpadding="0" align="center">
	          <tr>
	            <td nowrap="nowrap" class="align_right padding_r_5" style="width:20%;background:rgb(250,250,250)"><font class="color_red" style="color:red;">*</font>${ctp:i18n('doc.log.recommend.toSomebody')}:</td>
	            <td style="width:80%;"><div class="common_txtbox_wrap w90b" style="margin-left:0;background:rgb(250,250,250)">
	            	<input type="text" id="person" name="person" style="border:0;color:#999;" class="comp validate w100b font_size12"
      comp="type:'selectPeople',mode:'open',panels:'Department,Team,Post,Level',
      selectType:'Member,Department,Post,Team,Level,Account',excludeElements:'Member|${CurrentUser.id}||'
      ,hiddenPostOfDepartment:true,hiddenRoleOfDepartment:true"
      validate="name:'${ctp:i18n('doc.recommend.warn.person')}',notNull:true"/>
	            </div></td>
	        </tr>
	        <tr>
	            <td nowrap="nowrap" class="align_right padding_t_5 padding_r_5 margin_t_5" valign="top"  style="background:rgb(250,250,250);width:20%;"><font class="color_red" style="color:red;">*</font>${ctp:i18n('doc.description')}:</td>
	            <td style="width:80%;background:rgb(250,250,250)"><div class="common_txtbox_wrap w90b " style="margin-left:0;margin-top:5px;">
	            	<textarea id='description' style="height:120px;font-size:12px;border:0;" class="validate w100b" 
	            		name="description" validate="name:'${ctp:i18n('doc.description')}',isWord:true,maxLength:200,notNull:true,type:'string',avoidChar:'&quot;\'&lt;&gt;'"></textarea>
	            </div>
	            </td>
	        </tr>
	        <tr>
	            <td></td>
	            <td><font class="color_gray2">(${ctp:i18n('doc.recommend.count.limit')})</font></td>
	        </tr>
	    </table>
  <input type='hidden' id="sourceId" value='${param.sourceId}'>
  <div class="align_right bg_color_black" style="height: 40px;padding: 10px;margin: 10px 0;width:380px;position: relative;left: -20px;top:-7px;">
     <a id="btnok" class="common_button common_button_emphasize margin_r_5">${ctp:i18n('common.button.ok.label')}</a>
     <a id="btncancel" class="common_button common_button_gray  margin_r_10" style="margin-right:30px;">${ctp:i18n('common.button.cancel.label')}</a>
  </div>
  </FORM>
</div>
</body>
</html>