<%--
 $Author: wangchw $
 $Rev: 51000 $
 $Date:: 2015-08-03 10:16:29#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>空间管理</title>
<style type="text/css">
#systemMenuTree {height:300px;overflow-y:auto;overflow-x:auto;}
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=spaceManager,spaceSecurityManager,pageManager"></script>
<script>
  var isToDefault = false;
  $(document).ready(function() {
      var msg = '${ctp:i18n("info.totally")}';
	  var searchobj = $.searchCondition({
			top:2,
			right:10,
	      searchHandler: function(){
	    	  var retJSON = searchobj.g.getReturnValue();
	    	  if(retJSON == null) {
	    		  refreshTable();
			  } else {
				  var params = new Object();
				  params.accountId = $("#accountId").val();
				  if(retJSON.condition == "spaceName"){
					params.spacename = retJSON.value;
				  } else {
					params.state = retJSON.value;
				  }
				  $("#mytable").ajaxgridLoad(params);
			  }
	      },
	      conditions: [{
              id: 'spaceName',
              name: 'spaceName',
              type: 'input',
              text: '${ctp:i18n("space.label.name")}',
              value: 'spaceName'
          }, {
              id: 'spaceState',
              name: 'spaceState',
              type: 'select',
              text: '${ctp:i18n("common.state.label")}',
              value: 'spaceState',
              items: [{
                  text: "${ctp:i18n('common.state.normal.label')}",
                  value: "0"
              }, {
                  text: "${ctp:i18n('common.state.invalidation.label')}",
                  value: "1"
              }]
          }]
	  });
	  
	  var mytable = $("#mytable").ajaxgrid({
      colModel : [ {
        display : 'id',
        name : 'id',
        width : '4%',
        sortable : false,
        align : 'center',
        type : 'checkbox'
      }, {
        display : '${ctp:i18n("space.label.name")}',
        name : 'spacename',
        sortable : true,
        width : '19%'
      }, {
        display : '${ctp:i18n("space.label.modelPage")}',
        name : 'pageName',
        width : '19%',
        sortable : true
      }, {
        display : '${ctp:i18n("common.state.label")}',
        name : 'state',
        sortable : true,
        width : '19%'
        //codecfg : "codeType:'form',codeId:'4171705351394184829'"
      },{
        display : '${ctp:i18n("common.sort.label")}',
        name : 'sortId',
        sortType:'number',
        sortable : true,
        width : '19%'
      },{
        display : '${ctp:i18n("space.label.isDefaultSpace")}',
        name : 'defaultspace',
        sortable : true,
        width : '19%'
      }],
      click : tclk,
      dblclick : dblclk,
      managerName : "spaceManager",
      managerMethod : "selectSpace",
      params : {
        accountId : $("#accountId").val()
      },
      render : rend,
      parentId:"center",
      slideToggleBtn : true,
      vChange: true,
      vChangeParam: {
          autoResize:true
      }
    });
	  
    $("#manual").show();
    //mytable.grid.resizeGridUpDown('middle');
    $("#count").html(msg.format(mytable.p.total));
    
    function rend(txt, data, r, c) {
      if(c == 1){
        return $.i18n(txt) || txt;
      } else if(c == 2){
        return $.i18n(txt) || txt ;
      } else if (c == 3) {
        if(data.state == "1"){
          return "${ctp:i18n('common.state.invalidation.label')}";
        } else if(data.state == "0"){
          return "${ctp:i18n('common.state.normal.label')}";
        } 
      } else if(c == 5){
        if(data.defaultspace == "0"){
          return "${ctp:i18n('space.type.isSystemSpace.false')}";
        } else if(data.defaultspace == "1"){
          return "${ctp:i18n('space.type.isSystemSpace.true')}";
        }
      } else {
        return txt;
      }
    }
	var myToolbar = $("#toolbar2").toolbar({
      	searchHtml: 'sss',
      	toolbar: [
      	<c:if test="${productId ne 'a6s'}">
		{
		    id: "new",
		    name: "${ctp:i18n('common.toolbar.new.label')}",
		    className: "ico16",
			click:function(){
			    isToDefault = false;
				$("#grid_detail").show();
				$("input,textarea,select,a", $("#grid_detail")).attr("disabled", false);
				$("#grid_detail .align_center").show();
			    $("#id").val("0");
			    $("#spaceDeptDes").hide();
			    $("#spacename").val("");
			    $("#pageName").empty();
			    $("#pageName").append("<option value='' path=''>${ctp:i18n('publicManager.select')}</option>");
			    <c:forEach items="${selectableSpaceTypes}" var="spaceTypeTmp" varStatus="spaceTypeStatus">
			        var pageNameTmp${spaceTypeStatus.index} = $.i18n("${spaceTypeTmp.value}") || "${spaceTypeTmp.value}"; 
			        $("#pageName").append("<option value='" + pageNameTmp${spaceTypeStatus.index} + "' path='${spaceTypeTmp.key}'>" + pageNameTmp${spaceTypeStatus.index} + "</option>");
		        </c:forEach>
			    $("#path").val("");
			    $("#trCanshare").hide();
			    $("#trCanmanage").hide();
			    $("#trSpaceState").show();
			    $("#canpush").attr("checked", false);
			    $("#trCanpush").hide();
			    $("#canpersonal").attr("checked", false);
			    $("#trCanpersonal").hide();
			    $("#state").attr("checked", true);
			    $("#spaceMenuEnable").attr("checked", false);
			    $("#trMenuTree").hide();
                $("#menuTR").hide();
			    //授权清空
			    $("#canshare").comp({value:'',text:'',minSize:0,showRecent:false});
			    $("#canmanage").comp({value:'',text:'',minSize:0,showRecent:false});
			    $("#editSpacePage").unbind("load");
			    $("#editSpacePage").attr("src","");
			    //初始化空间菜单
			    showSystemMenuTree(null,true);
			    $("#sortId").val(getMaxTableSort() + 1);
			    $("#toDefaultButton").hide();
			    mytable.grid.resizeGridUpDown('middle');
		 	}
		},
		</c:if>
		{
	      id: "modify",
	      name: "${ctp:i18n('link.jsp.modify')}",
	      className: "ico16 modify_text_16",
		  click:function(){
		      isToDefault = false;
			  var checkedIds = $("input:checked", $("#mytable"));
			  if (checkedIds.size() == 0) {
			    $.alert("${ctp:i18n('space.select.prompt')}");
			  } else if (checkedIds.size() > 1) {
			    $.alert("${ctp:i18n('space.select.selectone.prompt')}");
			  } else {
			    var checkedId = $(checkedIds[0]).attr("value");
			    $("#id").val(checkedId);
			    $("#grid_detail").show();
			    new spaceManager().selectSpaceById(checkedId, {
			      success : function(spaceAndPage) {			        
			        $("input,textarea, a", $("#grid_detail")).attr("disabled", false);
			        $("#pageName").empty();
			        var pageName = $.i18n(spaceAndPage.pageName) || spaceAndPage.pageName;
			        $("#pageName").append("<option value='" + spaceAndPage.pageName + "' path='" + spaceAndPage.path + "'>" + pageName + "</option>");
			        $("#pageName").attr("disabled",true);		        
			        $("#canpush").attr("checked", false);
			        $("#grid_detail .align_center").show();
			        $("#canshare_txt").val("");
			        $("#canmanage_txt").val("");
			        $("#trCanshare").hide();
			        $("#trCanmanage").hide();
			        $("#trCanpush").hide();
			        $("#trCanpersonal").hide();
			        $("#id").val(spaceAndPage.id);
			        var spaceName = $.i18n(spaceAndPage.spacename) || spaceAndPage.spacename;
			        $("#spacename").val(spaceName);
			        $("#path").val(spaceAndPage.path);
			        if($("#path").val().indexOf("/department/") != -1){
			            $("#spaceDeptDes").show();
			        }else{
			        	$("#spaceDeptDes").hide();
			        }
			        if(spaceAndPage.defaultspace == 1){
			          $("#toDefaultButton").show();
			        } else {
			          $("#toDefaultButton").hide();
			        }
			        if(spaceAndPage.canshare == 1){
			          $("#trCanshare").show();
			        }
			        if(spaceAndPage.canmanage == 1){
			          $("#trCanmanage").show();
			        }
			        new spaceSecurityManager().selectSecurityBOBySpaceId(checkedId, {
			          success : function(spaceSecuritys) {
			            $("#canshare").comp({value:spaceSecuritys[0],text:spaceSecuritys[1],minSize:0,showRecent:false});
			            $("#canmanage").comp({value:spaceSecuritys[2],text:spaceSecuritys[3],minSize:0,showRecent:false});
			            //更改授权模型
                        showSecurityType(spaceAndPage.path, spaceAndPage.pageId);
			          }
			        });
			        if(spaceAndPage.canpush == 1){
			          $("#trCanpush").show();
			          if(spaceAndPage.canpushCheck=="0"){
			        	  $("#canpush").attr("checked",true);
			          }
			        }
			        if(spaceAndPage.canpersonal == 1){
			          $("#trCanpersonal").show();
			          if(spaceAndPage.isAllowDefined == true){
			            $("#canpersonal").attr("checked",true);
    		          }else{
    		            $("#canpersonal").attr("checked",false);
    		          }
			        }else{
			          $("#trCanpersonal").hide();
			          $("#canpersonal").attr("checked",false);
			        }
			        if(spaceAndPage.canusemenu == 1){
			          $("#canusemenu").val(1);
			          $("#trCanusemenu").show();
			          $("#spaceMenuEnable").attr("checked", spaceAndPage.spaceMenuEnable == 1);
			          if(spaceAndPage.spaceMenuEnable == 1){
			            $("#trMenuTree").show();
			            $("#menuTR").show();
			            //显示系统菜单
			            showSystemMenuTree(spaceAndPage.id,true);
			          }else{
		                  $("#trMenuTree").hide();
		                  $("#menuTR").hide();
		              }
			        }else{
			          $("#canusemenu").val(0);
			          $("#trCanusemenu").hide();
			          $("#spaceMenuEnable").attr("checked", false);
			        }
			        if(spaceAndPage.state == 0){
			          $("input[name='state']:first").attr("checked", true);
			          $("input[name='state']:last").attr("checked", false);
			        } else{
			          $("input[name='state']:first").attr("checked", false);
			          $("input[name='state']:last").attr("checked", true);
			        }
			        //个人空间5;外部人员空间14
			        if(spaceAndPage.type == 5 || spaceAndPage.type == 14 || spaceAndPage.type >= 19){
			          $("#trSpaceState").hide();
			          $("input[name='state']:first").attr("disabled", true);
			          $("input[name='state']:last").attr("disabled", true);
			        }else{
			        	$("#trSpaceState").show();
			        }
			        $("#manual").hide();
			        $("#sortId").val(spaceAndPage.sortId);
			        $("#editSpacePage").unbind("load");
			        $("#editSpacePage").attr("src",spaceAndPage.path+"?showState=edit");
			        
			      }
			    });
			  	mytable.grid.resizeGridUpDown('middle');
			  }
		   }
		}
		<c:if test="${productId != 'a6s'}">
		,{
	       id: "delete",
	       name: "${ctp:i18n('link.jsp.del')}",
	       className: "ico16 del_16",
	       click:function(){
	    	 var checkedIds = $("input:checked", $("#mytable"));
	    	 if (checkedIds.size() == 0) {
	    	   $.alert("${ctp:i18n('space.select.prompt')}");
	    	 } else {
	    	   var params = new Array();
	    	   for(var i = 0; i < checkedIds.size(); i++){
	    	     var dataMap = new spaceManager().selectSpaceById($(checkedIds[i]).val());
	    	     if(dataMap.defaultspace == 1){
	               $.alert("${ctp:i18n('space.delete.prompt1')}");
	               return;
	             }
	    	     if(isCurrentSpaceDefault(dataMap.id, dataMap.type)){
	    	       $.alert("${ctp:i18n('space.delete.prompt3')}");
		           return;
	    	     }
	    	     params.push($(checkedIds[i]).val());
	    	   }
	    	   $.messageBox({
	    	     'title': "${ctp:i18n('common.prompt')}",
	    	     'type' : 1,
	    	     'msg' : "<span class='msgbox_img_4 left'></span><span class='margin_l_5'>${ctp:i18n('space.delete.prompt')}</span>",
	    	      ok_fn : function() {
	    	        new spaceManager().deleteSpaceByIds(params, {
	    	          success : function(data) {
	    	            refreshTable();
	    	          },
	    	          error : function(data){
	    	            var dataMessage = $.parseJSON(data.responseText);
	    	            $.alert(dataMessage.message);
	    	          }
	    	        });
	    	      }
	    	   });
	    	 } 	
		   }
	    }
		</c:if>
		,{
           id: "defaultSpaceSetting",
           name: "${ctp:i18n('space.defaultSpace.setting.label')}",
           className: "ico16 setting_16",
           click:function(){
        	   new spaceManager().getDefaultSpaceSettingForGroup({
        		   success:function(settingForGroup){
        			   if(getCtpTop().isCurrentUserAdministrator == "true" && settingForGroup.allowChangeDefaultSpace == "0"){
        			     <%-- 父级不允许设置默认空间 --%>
        			     if(settingForGroup.defaultSpace.length > 0){
        			       new spaceManager().selectSpaceById(settingForGroup.defaultSpace, {
        		             success:function(spaceAndPage){
        		               var spacename = escapeStringToHTML(spaceAndPage.spacename + "", false);
 							   spacename = $.i18n(spacename) || spacename;
                			   $.alert($.i18n("space.defaultSpace.groupNotAllow.prompt", spacename));
                			   return;
        		        	 }
        			       });
        			     } else {
            			   var spaceName = null;
            			   if(settingForGroup.spaceType == "5_0_14_16_9_10"){
            				 spaceName = "${ctp:i18n("space.default.personal.label")}";
              			   } else if(settingForGroup.spaceType == "2"){
              				 spaceName = "${ctp:i18n("space.default.corporation.label")}";
              			   } else {
              				 <c:if test="${ctp:getSystemProperty('system.ProductId') == 2}">
              				 spaceName = "${ctp:i18n("space.default.group.label")}";
              				 </c:if>
              				 <c:if test="${ctp:getSystemProperty('system.ProductId') == 4}">
              				 spaceName = "${ctp:i18n("seeyon.top.group.space.label.GOV")}";
              				 </c:if>
              			   }
            			   $.alert($.i18n("space.defaultSpace.groupNotAllow.prompt", spaceName));
            			   return;
        			     }
        			   } else {
        				   defaultSpaceSettingDialog = $.dialog({
            				   id: 'defaultSpaceSetting',
            				   url : "${path}/portal/spaceController.do?method=defaultSpaceSetting",
            				   title: "${ctp:i18n('space.defaultSpace.setting.label')}",
            				   width: 320,
            				   height: 260,
            				   targetWindow : getCtpTop(),
            				   buttons: [{
            					   id:"ok_",
            					   btnType : 1,
            					   text: "${ctp:i18n('common.button.ok.label')}",
            					   handler: function () {
            						   defaultSpaceSettingDialog.getReturnValue();
            						   defaultSpaceSettingDialog.close();
            					   }
            				   }, {
            					   id:"cancel_",
            					   text: "${ctp:i18n('common.button.cancel.label')}",
            					   handler: function () {
            						   defaultSpaceSettingDialog.close();
            					   }
            				   }]
            			   });  
        			   }
        		    }
        	    });
            }
          }
		]
	  });  
	  
	//双击列表中一行
    function dblclk(data, r, c) {
      $("#grid_detail").resetValidate();
      clkCount = 0;
      myToolbar.enabledAll();
      $("#modify_a").click();
	}

	//记录单击事件触发的次数
	var clkCount = 0;
	//单击列表中一行，下面form显示详细信息
  	function tclk(data, r, c) {
  	  $("#grid_detail").resetValidate();
      clkCount++;
      if(clkCount >= 2){
        return;
      }
      myToolbar.disabledAll();
      isToDefault = false;
  	  $("input:checked", $("#mytable")).attr("checked", false);
  	  $("#mytable").find("tr:eq(" + r + ")").find("td input").attr("checked", true);
  	  new spaceManager().selectSpaceById(data.id, {
        success : function(spaceAndPage) {
          $("#grid_detail").show();
          $("input,textarea,select,a", $("#grid_detail")).attr("disabled", true);
          $("#grid_detail .align_center").hide();
          $("#canpush").attr("checked", false);
          //授权清空
          $("#canshare").val("");
          $("#canshare_txt").val("");
          $("#canmanage").val("");
          $("#canmanage_txt").val("");
          $("#canshare").comp({value:'',text:'${ctp:i18n("common.default.selectPeople.value")}',minSize:0,showRecent:false});
          $("#canmanage").comp({value:'',text:'${ctp:i18n("common.default.selectPeople.value")}',minSize:0,showRecent:false});
          $("#trCanshare").hide();
          $("#trCanmanage").hide();
          $("#trCanpush").hide();
          $("#trCanpersonal").hide();
          $("#trCanusemenu").hide();
          $("#id").val(spaceAndPage.id);
          var spaceName = $.i18n(spaceAndPage.spacename) || spaceAndPage.spacename;
          $("#spacename").val(spaceName);
          $("#pageName ").empty();
          var pageName =  $.i18n(spaceAndPage.pageName) || spaceAndPage.pageName;
          $("#pageName").append("<option value='" + spaceAndPage.pageName + "' path='" + spaceAndPage.path + "'>" + pageName + "</option>");  
          $("#path").val(spaceAndPage.path);
          if($("#path").val().indexOf("/department/") != -1){
	        $("#spaceDeptDes").show();
          }else{
        	$("#spaceDeptDes").hide();
          }
          $("#manual").hide();
          if(spaceAndPage.canshare == 1){
            $("#trCanshare").show().disable();
          }
          if(spaceAndPage.canmanage == 1){
            $("#trCanmanage").show().disable();
          }
          if(spaceAndPage.canpush == 1){
            $("#trCanpush").show();
	          if(spaceAndPage.canpushCheck=="0"){
	        	  $("#canpush").attr("checked",true);
	          }
          }
          new spaceSecurityManager().selectSecurityBOBySpaceId(data.id, {
            success : function(spaceSecuritys) {
              $("#canshare").comp({value:spaceSecuritys[0],text:spaceSecuritys[1],minSize:0,showRecent:false});
              $("#canmanage").comp({value:spaceSecuritys[2],text:spaceSecuritys[3],minSize:0,showRecent:false});
              //更改授权模型
              showSecurityType(spaceAndPage.path, spaceAndPage.pageId);
            }
          });
          if(spaceAndPage.canpersonal == 1){
            $("#trCanpersonal").show();
            if(spaceAndPage.isAllowDefined == true){
              $("#canpersonal").attr("checked",true);
            }else{
              $("#canpersonal").attr("checked",false);
            }
          }
          if(spaceAndPage.canusemenu == 1){
            $("#trCanusemenu").show();
            if(spaceAndPage.spaceMenuEnable == 1){
              $("#trMenuTree").show();
              $("#menuTR").show();
              //显示系统菜单
              showSystemMenuTree(spaceAndPage.id,false);
            }else{
              $("#trMenuTree").hide();
              $("#menuTR").hide();
            }
          }
          if(spaceAndPage.state == 0){
            $("input[name='state']:first").attr("checked", true);
            $("input[name='state']:last").attr("checked", false);
          } else{
            $("input[name='state']:first").attr("checked", false);
            $("input[name='state']:last").attr("checked", true);
          }
          //个人空间0,5;外部人员空间14,16
          if(spaceAndPage.type == 5 || spaceAndPage.type == 14 || spaceAndPage.type >= 19){
            $("#trSpaceState").hide();
          }else{
        	$("#trSpaceState").show();
          }
          $("#spaceMenuEnable").attr("checked", spaceAndPage.spaceMenuEnable == 1);
          $("#sortId").val(spaceAndPage.sortId);
          $("#editSpacePage").load(function(){
            myToolbar.enabledAll();
            $("#editSpacePage").contents().find("input,textarea,a").attr("disabled", true);
          });
          setTimeout(function(){
            if(clkCount == 1){
              $("#editSpacePage").attr("src",spaceAndPage.path+"?showState=view");
            } else if(clkCount >= 2){
              myToolbar.enabledAll();
            }
            clkCount = 0;
          }, 300);
        }
      });
  	  mytable.grid.resizeGridUpDown('middle');
    }

    $("#submitbtn").click(function() {
      if($("#id").val() != "0"){
    	  var checked = $("input[name='state']:last").attr("checked");
    	  if(checked){
        	  var spaceAndPage =  new spaceManager().selectSpaceById($("#id").val());
        	  if(isCurrentSpaceDefault(spaceAndPage.id, spaceAndPage.type)){
        		  $("input[name='state']:first").attr("checked", true);
    		      $("input[name='state']:last").attr("checked", false);
    		      $.alert("${ctp:i18n('space.delete.prompt4')}");
    		      return;
    		  }
    	  }
      }
      if($("#pageName").val() == ""){
        $.alert("${ctp:i18n('space.type.select.prompt')}");
        return;
      }
      var checkResult = frames['editSpacePage'].sectionHandler.checkEditSection();
      if(checkResult == false){
    	  return;
      }
      var formobj = $("#grid_detail").formobj();
      if (!$._isInValid(formobj)) {
      	showMask();
        var spaceId = $("#id").val();
        frames['editSpacePage'].addLayoutDataToForm();
        if($("#spaceMenuEnable").attr("checked")=="checked"){
          //转换空间关联的菜单数据为Json格式并添加到隐藏域
          var result = toJsonSpaceMenus();
          if(!result){
        	hideMask();
            return;
          }
        }else{
          $("#sysMenuTree").val("");
        }
        new spaceManager().transSaveSpace($("#grid_detail").formobj(),{
          success : function(){
        	hideMask();
            $("#grid_detail").resetValidate();
            mytable.grid.resizeGridUpDown('down');
            $("#grid_detail").hide();
            $("#manual").show();
            $.messageBox({
              'title': "${ctp:i18n('common.prompt')}",
              'type': 0,
              'msg': "<span class='msgbox_img_0 left' ></span><span class='margin_l_5'>${ctp:i18n('common.successfully.saved.label')}</span>",
              ok_fn: function() {
            	$("#mytable").ajaxgridLoad();
              },
              close_fn:function(){
            	$("#mytable").ajaxgridLoad();
              }
            });
          }
        });
      }
    });
    
    $("#spaceMenuEnable").click(function(){
      var isChecked = $("#spaceMenuEnable").attr("checked");
      if(isChecked){
        $("#trMenuTree").show();
        $("#menuTR").show();
        var spaceId = $("#id").val();
        if(spaceId!=0 && !isToDefault){
          showSystemMenuTree(spaceId,true);
        }else{
          showSystemMenuTree(null,true);
        }
      }else{
        $("#trMenuTree").hide();
        $("#menuTR").hide();
      }
    });
  });
  
  //判断当前操作的空间是否是设置的默认空间
  function isCurrentSpaceDefault(currentSpaceId, currentSpaceType){
	var bool = false;
	var defaultSpaceSettingInfo = null;
	if(getCtpTop().isCurrentUserGroupAdmin == "true"){
		defaultSpaceSettingInfo = new spaceManager().getDefaultSpaceSettingForGroup();
	} else if(getCtpTop().isCurrentUserAdministrator == "true"){
		defaultSpaceSettingInfo = new spaceManager().getDefaultSpaceSettingForAccount($.ctx.CurrentUser.loginAccount);
	}
	if(defaultSpaceSettingInfo.defaultSpace.length > 0){
	  if(defaultSpaceSettingInfo.defaultSpace == currentSpaceId){
		bool = true;
	  }
	} else {
		if(currentSpaceType == "9"){
			bool = false;
		} else {
			var defaultSpaceTypeStringArray = defaultSpaceSettingInfo.spaceType.split("_");
			for(var i = 0; i < defaultSpaceTypeStringArray.length; i++){
				if(defaultSpaceTypeStringArray[i] != "" && defaultSpaceTypeStringArray[i] == currentSpaceType){
					bool = true;
					break;
				}
			}
		}
	}
	return bool;
  }
  
  //如果设置的默认空间停用，需要给出提示
  function spaceStopUseHandler(){
	if($("#id").val() != "0"){
	  new spaceManager().selectSpaceById($("#id").val(), {
        success:function(spaceAndPage){
		  if(isCurrentSpaceDefault(spaceAndPage.id, spaceAndPage.type)){
			$("input[name='state']:first").attr("checked", true);
	        $("input[name='state']:last").attr("checked", false);
			$.alert("${ctp:i18n('space.delete.prompt4')}");
	        return;
		  }
       	}
	  });
	}
  }
  
  //选择空间模板  
  function spaceTypeOnChangeHandler(spaceTypeObj) {
    $(spaceTypeObj).find("option[value='']").remove();
	var pathValue = $(spaceTypeObj).find("option:selected").attr("path");
	$("#path").val(pathValue);
	new pageManager().getPage(pathValue,{
      success : function(spacePage){
        if(spacePage != null){
	        $("#path").val(spacePage.path);
	        //授权清空
	        $("#trCanshare").hide();
	        $("#trCanmanage").hide();
	        $("#canshare").comp({value:'',text:'${ctp:i18n("common.default.selectPeople.value")}',minSize:0,showRecent:false});
            $("#canmanage").comp({value:'',text:'${ctp:i18n("common.default.selectPeople.value")}',minSize:0,showRecent:false});
	        $("#canpush").attr("checked", false);
	        $("#trCanpush").hide();
	        if(pathValue.indexOf("/personal_custom") != -1){
	          //如果是自定义个人空间，默认勾上前端用户自定义
	          $("#canpersonal").attr("checked", true);
	        } else {
	          $("#canpersonal").attr("checked", false);
	        }
	        $("#trCanpersonal").hide();
	        $("#spaceMenuEnable").attr("checked",false);
	        $("#trCanusemenu").hide();
	        
	        if(spacePage.canshare == 1){
	          $("#trCanshare").show();
	        }
	        if(spacePage.canmanage == 1){
	          $("#trCanmanage").show();
	        }
	        if(spacePage.canpush == 1){
	          $("#trCanpush").show();
	        }
	        if(spacePage.canpersonal == 1){
	          $("#trCanpersonal").show();
	        }
	        if(spacePage.canusemenu == 1){
	          $("#trCanusemenu").show();
	        }
	        //更改授权模型
	        showSecurityType(spacePage.path, spacePage.id);
	        $("#editSpacePage").unbind("load");
	        $("#editSpacePage").attr("src",spacePage.path+"?showState=edit");
        }
      }
    });
  }
  
  function getMaxTableSort(){
    return parseInt(new spaceManager().getMaxSort());
  }
  
  //刷新列表
  function refreshTable(){
	  window.location.reload(true);
  }
  
  function toDefault(){
    var editKeyId = frames['editSpacePage'].document.getElementById("editKeyId").value;
    var path = $("#path").val();
    var params = new Object();
    params['editKeyId']=editKeyId;
    params['pagePath']=path;
    new pageManager().transToDefaultSpace(params,{
      success : function(result){
        if(result!=null){
          $("#editSpacePage").unbind("load");
          $("#editSpacePage").attr("src",path+"?showState=edit&decorationId="+result+"&editKeyId="+editKeyId);
        }
      }
    });
    isToDefault = true;
    $("#spaceMenuEnable").attr("checked", false);
    $("#trMenuTree").hide();
    $("#menuTR").hide();
  }
  //显示系统菜单
  function showSystemMenuTree(spaceId,enable){
	    new spaceManager().getSpaceMenuIds(spaceId,{
	      success : function(portalSpaceMenus){
	        if(portalSpaceMenus){
	          $("#systemMenuTree").tree({
	            idKey : "idKey",
	            pIdKey : "pIdKey",
	            nameKey : "nameKey",
	            enableCheck : true,
	            enableEdit : enable,
	            enableRename : false,
	            enableRemove : false,
	            nodeHandler:function(n){
	              if(!n.data.icon){
	                n.isParent = true;
	              }
	              if(n.idKey=="menu_0"){
	                n.open = true;
	              }
	              n.checked = n.data.checked;
	              n.expand = n.data.expand;
	              n.chkDisabled = !enable;
	            }
	          });
	          var setting = $("#systemMenuTree").treeObj().setting;
	          setting.callback = {
	        	beforeDrag : beforeDrag,
	            beforeDrop : beforeDrop,
	      		beforeExpand: beforeExpand
	      	  };
	          setting.edit.drag.autoOpenTime = 99999999;
	          setting.edit.drag.inner = false;
	          $.fn.zTree.init($("#systemMenuTree"), setting, portalSpaceMenus);
	        }
	      }
	    });
    function beforeDrag(treeId, treeNodes) {
      if (treeNodes[0].drag === false) {
        return false;
      }
      return true;
    }
    function beforeDrop(treeId, treeNodes, targetNode, moveType) {
      //当前选中节点
      var selectedNode = treeNodes[0];
      if(selectedNode.pIdKey == targetNode.idKey && moveType == "inner"){
        return true;
      }
      if(selectedNode.pIdKey == targetNode.pIdKey && moveType != "inner"){
        return true;
      }
      return  false;
    }
    function beforeExpand(treeId, treeNode) {
    	return treeNode.expand;
    }
  }
  //显示空间授权模型
  function showSecurityType(path, pageId){
    var canshareOnlyLoginAccount = true;
    var canmanageOnlyLoginAccount = false;
    if(path.indexOf("/public_custom/") != -1 || path.indexOf("/custom/") != -1 || path.indexOf("/group/") != -1 || path.indexOf("/public_custom_group/") != -1){
      canshareOnlyLoginAccount = false;
    }
    if(path.indexOf("/corporation/") != -1 ||path.indexOf("/department/") != -1 || path.indexOf("/custom") != -1 || path.indexOf("/public_custom/") != -1){
      canmanageOnlyLoginAccount = true;
    }
    new pageManager().getPageSecurityModels(pageId,{
      success : function(list){
        if(list!=null){
          var sharePanelStrVal,shareSelectTypeStrVal,managePanelStrVal,manageSelectTypeStrVal;
          for(var i=0; i<list.length; i++){
            var securityModel = list[i];
            if(securityModel.securityType == 1){
              //管理授权模型
              if(securityModel.showType == "panels"){
                managePanelStrVal = securityModel.showValue;
              }else{
                manageSelectTypeStrVal = securityModel.showValue;
              }
            }else{
              //使用授权模型
              if(securityModel.showType == "panels"){
                sharePanelStrVal = securityModel.showValue;
              }else{
                shareSelectTypeStrVal = securityModel.showValue;
                //部门空间使用授权允许选择单位根节点
                if(path.indexOf("/department/") != -1 && shareSelectTypeStrVal.indexOf("Account") < 0){
                	shareSelectTypeStrVal = "Account,"+shareSelectTypeStrVal;
                }
              }
            }
          }
          $("#canshare").comp({panels:sharePanelStrVal,selectType:shareSelectTypeStrVal,onlyLoginAccount:canshareOnlyLoginAccount,minSize:0,showRecent:false});
                    
          $("#canmanage").comp({panels:managePanelStrVal,selectType:manageSelectTypeStrVal,onlyLoginAccount:canmanageOnlyLoginAccount,isCanSelectGroupAccount:false,minSize:0,showRecent:false});
          
        }
      }
    });
  }
//前台提交用到的树对象
  function nodeObj(id,parentId,name,url,icon,checked,sort){
    this.id = id;
    this.parentId = parentId;
    this.name = name;
    this.url = url;
    this.icon = icon;
    this.checked = checked;
    this.sort = sort;
  }
  function toJsonSpaceMenus(){
    var treeObj = $("#systemMenuTree").treeObj();
    var nodesArray = treeObj.transformToArray(treeObj.getNodes());
    var nodes = new Array();
    var checkedNodes = 0;
    for(var i=0 ; i<nodesArray.length; i++){
      var node = nodesArray[i];
      if(node.idKey == "menu_0"){
        continue;
      }else{
        var n = new nodeObj(node.idKey,node.pIdKey,node.nameKey,node.data.urlKey,node.data.iconKey,node.checked,i);
        nodes.push(n);
      }
      if(node.idKey != "menu_0" && node.pIdKey == "menu_0" && node.checked){
        checkedNodes++;
      }
    }
    if(checkedNodes<=0){
      $.alert($.i18n("portal.space.menu.least",1));
      return false;
    }
    $("#sysMenuTree").val($.toJSON(nodes));
    return true;
  }
</script>
</head>
<body>
    <c:set var="noLocationCode" value="${accountType == 'group'?'T03_groupSpaceList':'T03_spaceList'}"></c:set>
    <div id='layout' class="comp" comp="type:'layout'">
		<div class="layout_north" id="north" layout="height:30,sprit:false,border:false">
            <div class="comp" comp="type:'breadcrumb',code:'${noLocationCode}'"></div>
        	<div id="toolbar2"></div>
        </div>
        <div class="layout_center over_hidden" id="center" layout="border:false">
            <table id="mytable" class="flexme3" style="display: none"></table>
            <div class="form_area" id="grid_detail" style="display: none; background: none;">
                <input type="hidden" id="id" value="0"/>
            	<input type="hidden" id="defaultspace" value="0"/>
                <input type="hidden" id="decoration" value=""/>
                <input type="hidden" id="showState" value=""/>
                <input type="hidden" id="editKeyId" value=""/>
                <input type="hidden" id="toDefault" value=""/>
                <input type="hidden" id="canusemenu" value=""/>
                <input type="hidden" id="sysMenuTree" value="">
                <input type="hidden" id="accountType" value="${ctp:toHTML(accountType)}">
                <input type="hidden" id="accountId" value="${ctp:toHTML(accountId)}">
                <div class="two_row">
                <fieldset class="padding_10 margin_t_10">
                <legend><b>${ctp:i18n("space.title.baseInfo")}</b></legend>
                    <table border="0" cellspacing="0" cellpadding="0" width="80%">
                        <tr>
                            <th nowrap="nowrap" width="35%"><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n("space.label.name")}:</label></th>
                            <td>
                            	<div class="common_txtbox_wrap">
                                    <input type="text" id="spacename" class="validate"
                                        validate="type:'string',name:'${ctp:i18n("space.label.name")}',notNull:true,minLength:1,maxLength:100" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n("space.label.type")}:</label></th>
                            <td>
                            	<select id="pageName" style="width: 100%; height: 24px" onchange="spaceTypeOnChangeHandler(this)" >
                                    <option value="" selected="selected">${ctp:i18n("assistantSetup.select.label")}</option>                                    
                                </select>
								<input type="hidden" id="path" value="" />
                            </td>
                        </tr>
                        <tr id="trCanmanage" style="display: none">
                            <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("space.manage.auth.label")}:</label></th>
                            <td>
                                <div class="common_txtbox_wrap">
                                    <input id="canmanage" value="" type="text" class="comp" comp="type:'selectPeople',mode:'open',panels:'Account,Department,Team,Post,Level,Role,Outworker',selectType:'Account,Department,Team,Post,Level,Role,Outworker,Member',showFlowTypeRadio: false,hiddenPostOfDepartment:true">
                                </div>
                            </td>
                        </tr>
                        <tr id="trCanshare" style="display: none">
                            <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("space.use.auth.label")}:</label></th>
                            <td>
                            	<div class="common_txtbox_wrap">
                            		<input id="canshare" value="" type="text" class="comp" comp="type:'selectPeople',mode:'open',panels:'Account,Department,Team,Post,Level,Role,Outworker',selectType:'Account,Department,Team,Post,Level,Role,Outworker,Member',showFlowTypeRadio: false,hiddenPostOfDepartment:true">
                            	</div>
                            </td>
                        </tr>
                        <tr id="trCanpush" style="display: none">
                            <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("space.default.todefault.label")}:</label></th>
                            <td>
                            	<div class="common_checkbox_box clearfix">
								    <label class="margin_r_10 hand" style="color: green;" for="canpush"><input id="canpush" class="radio_com" name="option" value="0" type="checkbox">${ctp:i18n("space.default.msg")}</label>
								</div>
                            </td>
                        </tr>
                        <tr id="trCanpersonal" style="display: none">
                            <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("space.customize.prompt")}:</label></th>
                            <td>
                            	<div class="common_checkbox_box clearfix">
								    <label class="margin_r_10 hand" for="canpersonal"><input id="canpersonal" class="radio_com" name="canpersonal" value="0" type="checkbox"></label>
								</div>
                            </td>
                        </tr>                    
                        <tr id="trSpaceState">
                            <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("space.label.isEnabled")}:</label></th>
                            <td>
                            	<div class="common_radio_box clearfix">
								    <label for="state" class="margin_r_10 hand"><input type="radio" id="state" name="state" class="radio_com" checked="checked" value="0" />${ctp:i18n("common.state.normal.label")}</label>
								    <label for="state" class="hand"><input type="radio" value="1" id="state" name="state" class="radio_com" onclick="spaceStopUseHandler()"/>${ctp:i18n("common.state.invalidation.label")}</label>
								</div>
                            </td>
                        </tr>
                        <tr>
                            <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n("sortnum.label")}:</label></th>
                            <td>
                            	<div class="common_txtbox_wrap">
                                    <input type="text" id="sortId" class="validate"
                                        validate="name:'${ctp:i18n("sortnum.label")}',notNull:true,isInteger:true,min:-9999,max:9999" />
                                </div>
                            </td>
                        </tr>
                        <tr id="spaceDeptDes" style="display: none; color: green"> 
                       		<th><label class="margin_r_10" for="text"><b>${ctp:i18n("common.description.label")}</b> : </label></th>
                       		<td>${ctp:i18n("space.dept.description")}</td>
                   	    </tr>
                    </table>
                </fieldset>
                </div>
                <div class="two_row" id="trCanusemenu" style="display:none">
	                <fieldset class="padding_10 margin_t_10">
	                    <legend><b>${ctp:i18n("space.title.menu")}</b></legend>
	                    <table border="0" cellspacing="0" cellpadding="0" width="">
	                    	<tr>
	                            <td>
	                            	<div class="common_checkbox_box clearfix" style="margin-left: 260px; margin-bottom: 10px">
	                            	    <label class="margin_r_10" for="text">${ctp:i18n("space.menu.enabled")}:</label>
									    <label class="margin_r_10 hand" for="spaceMenuEnable"><input id="spaceMenuEnable" class="radio_com" name="spaceMenuEnable" value="1" type="checkbox"></label>
									</div>
	                            </td>
	                        </tr>
	                        <tr id="trMenuTree" style="display:none">
	                           <td>
	                               <div class="common_checkbox_box clearfix" style="margin-left: 260px;">
	                               <fieldset style="margin: 10">
	                                    <legend><b>${ctp:i18n('space.title.menu')}</b></legend>
	                                    <table border="0" width="100%">
	                                        <tr id="menuTR">
	                                            <td><font color="red">*</font>${ctp:i18n('menuManager.menuTree.root.label')}: <font color="gray">(${ctp:i18n('menuTree.sort.descoraption.label')})</font></td>
	                                        </tr>
	                                        <tr>
	                                            <td>
	                                                <div id="systemMenuTree"></div>
	                                            </td>
	                                        </tr>
	                                    </table>
	                                </fieldset>
	                                </div>
	                           </td>
	                        </tr>
	                    </table>
	                </fieldset>
                </div>
                <div class="two_row">
	                <fieldset class="padding_10 margin_t_10">
	                    <legend><b>${ctp:i18n("space.section.setting")}</b></legend>
	                    <iframe width="100%" height="500px" id="editSpacePage" name="editSpacePage" src="${spacePage.path}?decoration=${decoration}&showState=${param.showFlag!='show'?'edit':'show'}&showFlag=${param.showFlag}&editKeyId=${editKeyId}" frameborder="0"></iframe>
	                </fieldset>
                </div>
                <div class="align_center padding_t_10 padding_b_10">
                    <span id="submitbtn" class="common_button common_button_emphasize">${ctp:i18n("common.button.ok.label")}</span>
                    <span id="toDefaultButton"  class="common_button common_button_gray" onclick="toDefault();">${ctp:i18n("space.button.toDefault")}</span>
                    <span class="common_button common_button_gray" onclick="refreshTable();">${ctp:i18n("common.button.cancel.label")}</span>
                </div>
            </div>
            <div id="manual" class="color_gray margin_l_20 display_none">
              <div class="clearfix">
                <h2 class="left">${ctp:i18n('space.setting')}</h2>
                <div class="font_size12 left margin_t_20 margin_l_10">
                    <div class="margin_t_10 font_size14">
                        <span id="count"></span>
                    </div>
                </div>
              </div>
            </div>
        </div>
    </div>
</body>
</html>