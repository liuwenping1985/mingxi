<%--
 $Author: zhout $
 $Rev: 22868 $
 $Date:: 2013-05-16 13:36:56#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>空间模板管理</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=pageManager"></script>
<script>
  $(document).ready(function() {
	  var searchobj = $.searchCondition({
			top:2,
			right:10,
        searchHandler: function(){
      	  var retJSON = searchobj.g.getReturnValue();
      	  if(retJSON == null || retJSON == "") {
      		  refreshTable();
		  } else {
			  var params = new Object();
			  if(retJSON.condition == "spacePageName"){
				params.pageName = retJSON.value;
			  }
			  $("#mytable").ajaxgridLoad(params);
		  }
        },
        conditions: [{
            id: 'spacePageName',
            name: 'spacePageName',
            type: 'input',
            text: '模板名称',
            value: 'spacePageName'
        }]
    });
	  
	  $("#toolbar2").toolbar({
        searchHtml: 'sss',
        toolbar: [
		{
		    id: "new",
		    name: "${ctp:i18n('common.toolbar.new.label')}",
		    className: "ico16",
			click:function(){
				mytable.grid.resizeGridUpDown('middle');
				$("#grid_detail").show();
				$("#grid_detail .align_center").show();
				$("input,textarea, a", $("#grid_detail")).attr("disabled", false);
			    $("#id").val("0");
			    $("#pageName").val("");
			    $("#canshare").attr("checked", false);
			    $("#canmanage").attr("checked", false);
			    $("#canpush").attr("checked", false);
			    $("#canpersonal").attr("checked", false);
			    $("#canusemenu").attr("checked",false);
			    $("#editSpacePage").unbind("load");
			    $("#editSpacePage").attr("src","/seeyon/template/default-page.psml?showState=edit");
			    $("#sort").val(new pageManager().selectMaxSort() + 1);
		 	}
		},{
	      	  id: "modify",
	          name: "修改",
	          className: "ico16 modify_text_16",
			  click:function(){
				  var checkedIds = $("input:checked", $("#mytable"));
				    if (checkedIds.size() == 0) {
				      alert("请选择1个空间模板！");
				    } else if (checkedIds.size() > 1) {
				      alert("只能选择1个空间模板！");
				    } else {
				      var checkedId = $(checkedIds[0]).attr("value");
				      $("#id").val(checkedId);
				      $("#grid_detail input").attr("disabled", false);
				      new pageManager().selectSpacePageById(checkedId, {
				        success : function(spacePage) {
				          if(spacePage.pageType == 0){
				            alert("不能修改系统预置空间模板！");
				          } else {
				        	  $("input,textarea, a", $("#grid_detail")).attr("disabled", false);
				        	  $("#grid_detail .align_center").show();
				        	  mytable.grid.resizeGridUpDown('middle');
				              $("#grid_detail").show();
				              var pageName = $.i18n(spacePage.pageName) || spacePage.pageName;
				              $("#pageName").val(pageName);
					          $("#path").val(spacePage.path);
					          //显示授权模型信息
				              showSecurityModels(spacePage.id,spacePage.canshare,spacePage.canmanage);
					          
					          if(spacePage.canshare == 1){
    				              $("#canshare").attr("checked",true);
    				              $("#sharePanel").show();
    				              $("#shareTypes").show();
                              }else{
                                  $("#canshare").attr("checked",false);
                                  $("#sharePanel").hide();
                                  $("#sharePanelStr").val("");
                                  $("#sharePanelStrVal").val("");
                                  $("#shareTypes").hide();
                                  $("#shareSelectTypeStr").val("");
                                  $("#shareSelectTypeStrVal").val("");
                              }
                              if(spacePage.canmanage == 1){
                                  $("#canmanage").attr("checked",true);
                                  $("#managePanel").show();
                                  $("#manageTypes").show();
                              }else{
                                  $("#canmanage").attr("checked",false);
                                  $("#managePanel").hide();
                                  $("#managePanelStr").val("");
                                  $("#managePanelStrVal").val("");
                                  $("#manageTypes").hide();
                                  $("#manageSelectTypeStr").val("");
                                  $("#manageSelectTypeStrVal").val("");
                              }
					          $("#canpush").attr("checked", spacePage.canpush == 1);
					          $("#canpersonal").attr("checked", spacePage.canpersonal == 1);
					          $("#sort").val(spacePage.sort);
					          $("#editSpacePage").attr("src",spacePage.path+"?showState=edit");
					          $("#editSpacePage").load(function(){ 
								$("input,textarea, a", $(window.frames['editSpacePage'].document)).attr("disabled", false);
							  });
				          }
				        }
				      });
				    }	  			
			  }
	    },{
            id: "delete",
            name: "删除",
            className: "ico16 del_16",
            click:function(){
            	var checkedIds = $("input:checked", $("#mytable"));
                if (checkedIds.size() == 0) {
                  alert("请选择空间模板！");
                } else {
                  var params = new Array();
                  for(var i = 0; i < checkedIds.size(); i++){
                    params.push($(checkedIds[i]).val());
                  }
                  $.messageBox({
                    'type' : 1,
                    'msg' : "<span class='msgbox_img_4 left'></span><span class='margin_l_5'>是否要删除空间模板？</span>",
                    ok_fn : function() {
                      new pageManager().deletePageByIds(params, {
                        success : function(data) {
                          refreshTable();
                        }
                      });
                    }
                  });
                }
		    }
        },{
            id: "import",
            name: "导入",
            className: "ico16 import_16",
			click:function(){
			  $("#uploadFile").click();
		 	}
        },{
            id: "export",
            name: "导出",
            className: "ico16 export_16",
		    click:function(){
		    	var checkedIds = $("input:checked", $("#mytable"));
		        if (checkedIds.size() == 0) {
		          alert("请选择空间模板！");
		        } else {
		        	var pageIds = "";
		        	for(var i = 0; i < checkedIds.size(); i++){
		        		pageIds = pageIds + $(checkedIds[i]).val() + ","
		        	}
		        	pageIds = pageIds.substr(0, pageIds.length - 1);
		          $("#downLoadIFrame").attr("src", "${path}/portal/spaceController.do?method=exportPage&pageIds=" + pageIds);
		        }	
			}
        }]
    });
	  
	var mytable = $("#mytable").ajaxgrid({
      colModel : [ {
        display : 'id',
        name : 'id',
        width : '40',
        sortable : false,
        align : 'center',
        type : 'checkbox'
      }, {
        display : '空间模板名称',
        name : 'pageName',
        sortable : true,
        width : '32%'
      }, {
        display : '是否系统预置',
        name : 'pageType',
        sortable : true,
        width : '32%'
        //codecfg : "codeType:'java',codeId:'com.seeyon.ctp.portal.po.PortalSpacePage.PageTypeEnum'"
      }, {
        display : '排序号',
        name : 'sort',
        sortType:'number',
        sortable : true,
        width : '31%'
      } ],
      click : tclk,
      managerName : "pageManager",
      managerMethod : "selectDefaultSpacePage",
      render : rend,
      parentId : 'center',
      slideToggleBtn : true,
      vChange : true,
      vChangeParam: {
        autoResize:true
    }
    });
    
    function rend(txt, data, r, c) {
      if(c == 1){
        return $.i18n(txt)||txt ;
      }else if (c == 2) {
        if(data.pageType == "0"){
          return "${ctp:i18n('space.isSystem.true')}";
        } else if(data.pageType == "1"){
          return "${ctp:i18n('space.isSystem.false')}";
        }
      } else {
        return txt;
      }
    }

    //单击列表中一行，下面form显示详细信息
  	function tclk(data, r, c) {
  	  $("input:checked", $("#mytable")).attr("checked", false);
  	  $("#mytable").find("tr:eq(" + r + ")").find("td input").attr("checked", true); 
      $("#grid_detail input").attr("disabled", true);
      new pageManager().selectSpacePageById(data.id, {
        success : function(spacePage) {
        	$("input,textarea, a", $("#grid_detail")).attr("disabled", true);
        	mytable.grid.resizeGridUpDown('middle');
        	$("#grid_detail .align_center").hide();
        	$("#grid_detail").show();
			$("#id").val(spacePage.id);
			var pageName = $.i18n(spacePage.pageName) || spacePage.pageName;
			$("#pageName").val(pageName);
			//显示授权模型信息
			showSecurityModels(spacePage.id,spacePage.canshare,spacePage.canmanage);
			
			if(spacePage.canshare == 1){
			  $("#canshare").attr("checked",true);
			  $("#sharePanel").show();
			  $("#shareTypes").show();
			}else{
			  $("#canshare").attr("checked",false);
			  $("#sharePanel").hide();
			  $("#sharePanelStr").val("");
			  $("#sharePanelStrVal").val("");
			  $("#shareTypes").hide();
			  $("#shareSelectTypeStr").val("");
			  $("#shareSelectTypeStrVal").val("");
			}
			if(spacePage.canmanage == 1){
                $("#canmanage").attr("checked",true);
                $("#managePanel").show();
                $("#manageTypes").show();
            }else{
                $("#canmanage").attr("checked",false);
                $("#managePanel").hide();
                $("#managePanelStr").val("");
                $("#managePanelStrVal").val("");
                $("#manageTypes").hide();
                $("#manageSelectTypeStr").val("");
                $("#manageSelectTypeStrVal").val("");
            }
      		$("#canpush").attr("checked", spacePage.canpush == 1);
      		$("#canpersonal").attr("checked", spacePage.canpersonal == 1);
      		$("#canusemenu").attr("checked", spacePage.canusemenu == 1);
			$("#sort").val(spacePage.sort);
			$("#editSpacePage").attr("src",spacePage.path+"?showState=view");
			$("#editSpacePage").load(function(){ 
				$("input,textarea, a", $(window.frames['editSpacePage'].document)).attr("disabled", true);
		    });
        }
      });
    }

    $("#submitbtn").click(function() {
      var obj = $("#grid_detail").formobj();
      obj.canshare = obj.canshare == null? 0 : obj.canshare;
      obj.canmanage = obj.canmanage == null? 0 : obj.canmanage;
      obj.canpush = obj.canpush == null? 0 : obj.canpush;
      obj.canpersonal = obj.canpersonal == null? 0 : obj.canpersonal;
      obj.canusemenu = obj.canusemenu == null ? 0 : obj.canusemenu;
      if (!$._isInValid(obj)) {
        frames['editSpacePage'].addLayoutDataToForm();
        var pageId = $("#id").val();
        if(pageId == "0"){
          new pageManager().insertSpacePage($("#grid_detail").formobj(),{
            success : function(){
              $.messageBox({
                'title': "${ctp:i18n('common.prompt')}",
                'type': 0,
                'imgType' : 0,
                'msg': "${ctp:i18n('common.successfully.saved.label')}",
                 ok_fn: function() {
                  location.reload();
                }
              });
            }
          });
        } else {
          new pageManager().updateSpacePage($("#grid_detail").formobj(),{
            success : function(){
              $.messageBox({
                'title': "${ctp:i18n('common.prompt')}",
                'type': 0,
                'imgType' : 0,
                'msg': "${ctp:i18n('common.successfully.saved.label')}",
                 ok_fn: function() {
                  location.reload();
                }
              });
            }
          });
        }
      }
    });
    //使用授权选择控制
    $("#canshare").click(function(){
      if(this.checked == true){
        $("#sharePanel").show();
        $("#shareTypes").show();
      }else{
        $("#sharePanel").hide();
        $("#sharePanelStr").val("");
        $("#sharePanelStrVal").val("");
        $("#shareTypes").hide();
        $("#shareSelectTypeStr").val("");
        $("#shareSelectTypeStrVal").val("");
      }
    });
    //选择选人组件的页签-使用授权
    $("#sharePanelStr").click(function(){
      var panelDialog = $.dialog({
        id: 'peoplePanel',
        url: _ctxPath+'/portal/spaceController.do?method=selectPeoplePanel&securityType=0&pageId='+$("#id").val(),
        title: '选择选人组件页签',
        buttons: [{
            text: $.i18n('common.button.ok.label'),
            handler: function () {
              var returnVal = panelDialog.getReturnValue();
              if(returnVal != null){
                $("#sharePanelStr").val(returnVal[1]);
                $("#sharePanelStrVal").val(returnVal[0]);
              }
              panelDialog.close();
            }
        }, {
            text: $.i18n('common.button.cancel.label'),
            handler: function () {
                panelDialog.close();
            }
        }]
      });
    });
    
    //选择选人组件的选择类型-使用授权
    $("#shareSelectTypeStr").click(function(){
      var typeDialog = $.dialog({
        id: 'peoplePanel',
        url: _ctxPath+'/portal/spaceController.do?method=selectPeopleSelectType&securityType=0&pageId='+$("#id").val(),
        title: '选择选人组件页签',
        buttons: [{
            text: $.i18n('common.button.ok.label'),
            handler: function () {
              var returnVal = typeDialog.getReturnValue();
              if(returnVal != null){
                $("#shareSelectTypeStr").val(returnVal[1]);
                $("#shareSelectTypeStrVal").val(returnVal[0]);
              }
              typeDialog.close();
            }
        }, {
            text: $.i18n('common.button.cancel.label'),
            handler: function () {
                typeDialog.close();
            }
        }]
      });
    });
    
    //使用授权选择控制
    $("#canmanage").click(function(){
      if(this.checked == true){
        $("#managePanel").show();
        $("#manageTypes").show();
      }else{
        $("#managePanel").hide();
        $("#managePanelStr").val("");
        $("#managePanelStrVal").val("");
        $("#manageTypes").hide();
        $("#manageSelectTypeStr").val("");
        $("#manageSelectTypeStrVal").val("");
      }
    });
    //选择选人组件的页签-管理授权
    $("#managePanelStr").click(function(){
      var panelDialog = $.dialog({
        id: 'peoplePanel',
        url: _ctxPath+'/portal/spaceController.do?method=selectPeoplePanel&securityType=1&pageId='+$("#id").val(),
        title: '选择选人组件页签',
        buttons: [{
            text: $.i18n('common.button.ok.label'),
            handler: function () {
              var returnVal = panelDialog.getReturnValue();
              if(returnVal != null){
                $("#managePanelStr").val(returnVal[1]);
                $("#managePanelStrVal").val(returnVal[0]);
              }
              panelDialog.close();
            }
        }, {
            text: $.i18n('common.button.cancel.label'),
            handler: function () {
                panelDialog.close();
            }
        }]
      });
    });
    
    //选择选人组件的选择类型-管理授权
    $("#manageSelectTypeStr").click(function(){
      var typeDialog = $.dialog({
        id: 'peoplePanel',
        url: _ctxPath+'/portal/spaceController.do?method=selectPeopleSelectType&securityType=1&pageId='+$("#id").val(),
        title: '选择选人组件页签',
        buttons: [{
            text: $.i18n('common.button.ok.label'),
            handler: function () {
              var returnVal = typeDialog.getReturnValue();
              if(returnVal != null){
                $("#manageSelectTypeStr").val(returnVal[1]);
                $("#manageSelectTypeStrVal").val(returnVal[0]);
              }
              typeDialog.close();
            }
        }, {
            text: $.i18n('common.button.cancel.label'),
            handler: function () {
                typeDialog.close();
            }
        }]
      });
    });
    
  });
  
  function canmanageOnClickHandler(obj){
    if($(obj).attr("checked") == "checked"){
      $("#canshare").attr("checked", true);
    }
  }
  function canshareOnClickHandler(obj){
    if($(obj).attr("checked") != "checked"){
      $("#canmanage").attr("checked", false);
    }
  }
  //刷新列表
  function refreshTable(){
	window.location.reload(true);
  }
  
  function uploadCallBack(fileid){
    //处理文件逻辑的action
    //location.href="portal/spaceController.do?method=importPage&fileid="+fileid;
    AjaxDataLoader.load(_ctxPath+"/portal/spaceController.do?method=importPage&fileid="+fileid, null, function(str){
      if(str != null && $.trim(str) != ""){
        $.alert(str);
      } else {
	      $.messageBox({
	        'title': "${ctp:i18n('common.prompt')}",
	        'type': 0,
	        'msg': "<span class='msgbox_img_0' style='float:left'></span><span style='font-size:14px;'>${ctp:i18n('space.import.ok.label')}</span>",
	         ok_fn: function() {
	          location.reload();
	        }
	      });
      }
    });
  }
  function showSecurityModels(id,canshare,canmanage){
    new pageManager().getPageSecurityModels(id,{
      success : function(list){
        if(list!=null){
          var sharePanelStrVal,shareSelectTypeStrVal,managePanelStrVal,manageSelectTypeStrVal;
          var sharePanelStr,shareSelectTypeStr,managePanelStr,manageSelectTypeStr;
          for(var i=0; i<list.length; i++){
            var securityModel = list[i];
            if(securityModel.securityType == 1){
              //管理授权模型
              if(securityModel.showType == "panels"){
                managePanelStrVal = securityModel.showValue;
                managePanelStr = showValueToDisplay(managePanelStrVal);
              }else{
                manageSelectTypeStrVal = securityModel.showValue;
                manageSelectTypeStr = showValueToDisplay(manageSelectTypeStrVal);
              }
            }else{
              //使用授权模型
              if(securityModel.showType == "panels"){
                sharePanelStrVal = securityModel.showValue;
                sharePanelStr = showValueToDisplay(sharePanelStrVal);
              }else{
                shareSelectTypeStrVal = securityModel.showValue;
                shareSelectTypeStr = showValueToDisplay(shareSelectTypeStrVal);
              }
            }
          }
          if(canshare == 1){
            $("#sharePanelStr").val(sharePanelStr);
            $("#sharePanelStrVal").val(sharePanelStrVal);
            $("#shareSelectTypeStr").val(shareSelectTypeStr);
            $("#shareSelectTypeStrVal").val(shareSelectTypeStrVal);
          }
          if(canmanage == 1){
            $("#managePanelStr").val(managePanelStr);
            $("#managePanelStrVal").val(managePanelStrVal);
            $("#manageSelectTypeStr").val(manageSelectTypeStr);
            $("#manageSelectTypeStrVal").val(manageSelectTypeStrVal);
          }
        }
      }
    });
  }
  function showValueToDisplay(str){
    var s = "";
    if(str.indexOf("Account")>=0){
      s +=$.i18n('org.account.label')+",";
    }
    if(str.indexOf("Department")>=0){
      s +=$.i18n('org.department.label')+",";
    }
    if(str.indexOf("Team")>=0){
      s +=$.i18n('org.team.label')+",";
    }
    if(str.indexOf("Post")>=0){
      s +=$.i18n('org.post.label')+",";
    }
    if(str.indexOf("Level")>=0){
      s +=$.i18n('org.level.label')+",";
    }
    if(str.indexOf("Role")>=0){
      s +=$.i18n('org.role.label')+",";
    }
    if(str.indexOf("Outworker")>=0){
      s +=$.i18n('org.outworker.label')+",";
    }
    if(str.indexOf("Member")>=0){
      s +=$.i18n('org.member.label')+",";
    }
    return s.substring(0,s.length-1);
  }
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
    	<div class="layout_north" id="north" layout="height:30,sprit:false,border:false">
            <div class="comp" comp="type:'breadcrumb',code:'T03_spaceTemplateList'"></div>
        	<div id="toolbar2"></div>
        </div>
        <!-- 
        <div class="layout_west" id="west" layout="width:200">
            <div id="tree"></div>
        </div>
         -->
        <div class="layout_center over_hidden" id="center" layout="border:false" style="display: none;">
            <table id="mytable" class="flexme3" style="display: none"></table>
            <div class="form_area" id='grid_detail' style="display: none;">
            	<input type="hidden" id="id" value="0"/>
                <input type="hidden" id="decoration" value=""/>
                <input type="hidden" id="showState" value=""/>
                <input type="hidden" id="editKeyId" value=""/>
                <input type="hidden" id="toDefault" value=""/>
                <input type="hidden" id="path" value=""/>
                <div class="two_row">
                <fieldset class="padding_10 margin_t_10">
                <legend><b>空间模板信息</b></legend>
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <th><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>空间模板名称:</label></th>
                            <td>
                            	<div class="common_txtbox_wrap">
                                    <input type="text" id="pageName" class="validate"
                                        validate="type:'string',name:'空间模板名称',notNull:true,minLength:1,maxLength:100,character:'!@#$%^*()<>'" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><label class="margin_r_10" for="text">开启使用授权:</label></th>
                            <td>
                            	<div class="common_checkbox_box clearfix ">
								    <input id="canshare" class="radio_com" type="checkbox" value="1"/>
								</div>
                            </td>
                        </tr>
                        <tr id="sharePanel" class="hidden">
                            <th><label class="margin_r_10" for="text">授权组件页签控制:</label></th>
                            <td>
                                <div class="common_txtbox_wrap">
                                    <input type="text" id="sharePanelStr" readonly="readonly"/>
                                    <input type="hidden" id="sharePanelStrVal" />
                                </div>
                            </td>
                        </tr>
                        <tr id="shareTypes" class="hidden">
                            <th><label class="margin_r_10" for="text">授权组件类型控制:</label></th>
                            <td>
                               <div class="common_txtbox_wrap">
                                    <input type="text" id="shareSelectTypeStr" readonly="readonly"/>
                                    <input type="hidden" id="shareSelectTypeStrVal" />
                               </div>
                            </td>
                        </tr>
                        <tr id="trCanmanage" >
                            <th><label class="margin_r_10" for="text">开启管理授权:</label></th>
                            <td>
                            	<div class="common_checkbox_box clearfix ">
								    <input id="canmanage" class="radio_com" type="checkbox" value="1"/>
								</div>
                            </td>
                        </tr>
                        <tr id="managePanel" class="hidden">
                            <th><label class="margin_r_10" for="text">授权组件页签控制:</label></th>
                            <td>
                                <div class="common_txtbox_wrap">
                                    <input type="text" id="managePanelStr" readonly="readonly"/>
                                    <input type="hidden" id="managePanelStrVal" />
                                </div>
                            </td>
                        </tr>
                        <tr id="manageTypes" class="hidden">
                            <th><label class="margin_r_10" for="text">授权组件类型控制:</label></th>
                            <td>
                               <div class="common_txtbox_wrap">
                                    <input type="text" id="manageSelectTypeStr" readonly="readonly"/>
                                    <input type="hidden" id="manageSelectTypeStrVal" />
                               </div>
                            </td>
                        </tr>
                        <tr id="trCanpush" >
                            <th><label class="margin_r_10" for="text">开启推送:</label></th>
                            <td>
                            	<div class="common_checkbox_box clearfix ">
								    <input id="canpush" class="radio_com" type="checkbox" value="1">
								</div>
                            </td>
                        </tr>
                        <tr id="trCanpersonal">
                            <th><label class="margin_r_10" for="text">开启前端用户个性化:</label></th>
                            <td>
                            	<div class="common_checkbox_box clearfix ">
								    <input id="canpersonal" class="radio_com" type="checkbox" value="1">
								</div>
                            </td>
                        </tr>
                        <tr id="trCanusemenu">
                            <th><label class="margin_r_10" for="text">启用个性化菜单配置:</label></th>
                            <td>
                                <div class="common_checkbox_box clearfix ">
                                    <input id="canusemenu" class="radio_com" type="checkbox" value="1">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>排序号:</label></th>
                            <td>
                            	<div class="common_txtbox_wrap">
                                    <input type="text" id="sort" class="validate"
                                        validate="name:'排序号',notNull:true,isInteger:true,min:-9999,max:9999" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </fieldset>
                </div>
                <div class="two_row">
                <fieldset class="padding_10 margin_t_10">
                    <legend><b>空间栏目配置</b></legend>
                    <iframe width="100%" height="500px" id="editSpacePage" name="editSpacePage" src="/seeyon/template/default-page.psml?showState=edit" frameborder="0"></iframe>
                </fieldset>
                </div>
                <div class="align_center">
                    <a href="javascript:void(0)" id="submitbtn" class="common_button common_button_gray">${ctp:i18n("common.button.ok.label")}</a>
                    <a href="javascript:refreshTable()" class="common_button common_button_gray">${ctp:i18n("common.button.cancel.label")}</a>
                </div>
            </div>
        </div>
    </div>
    <input id="myfile" type="text" class="comp" style="display: none" comp="type:'fileupload',quantity:1,applicationCategory:'1',canDeleteOriginalAtts:true,originalAttsNeedClone:false,extensions:'xml'" />
    <input id="uploadFile" type="button" onclick="insertAttachment('uploadCallBack')" style="display: none" value="上传附件" />
    <iframe id="downLoadIFrame" name="downLoadIFrame" src="" style="display: none;"/>
</body>
</html>