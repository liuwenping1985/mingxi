<%--
 $Author: wangchw $
 $Rev: 52298 $
 $Date:: 2016-06-08 16:24:37#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>layout</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=linkSystemManager,orgManager,linkSectionManager,linkCategoryManager,linkMenuManager"></script>
<script>
var currentCategoryId = 1;
var currentLinkSystemId = null;
var isSystemAdmin = ${isSystemAdmin};
var currentInstructionsDialog = null;
var addCategoryDialog = null;
var updateCategoryDialog = null;
//是否系统预制的关联系统
var isPreSystem = false;

//列表全选事件
function gridSelectAllPersonalFunction(flag){
  if(flag){
    $("#tree").treeObj().cancelSelectedNode($("#tree").treeObj().getSelectedNodes()[0]);
  }
}

$(document).ready(function() {
  $('#grid_detail').resize(function(){
    $('#linkSystem_div').height($(this).height()-26);
    $('#linkOptionValue_div').height($(this).height()-26);
  });
  
  $("#operationInstruction").bind("click",function(event){
    if(currentInstructionsDialog){
      currentInstructionsDialog.close();
    }
    currentInstructionsDialog = $.dialog({
      id:'menuAuth',
      width: 300,
      height: 393,
      type: 'panel',
      htmlId: 'divBaseDifinition',
      targetId: 'operationInstruction',
      shadow:false,
      panelParam:{
          'show':false,
          'margins':false
      }
    });
    $("#divBaseDifinition").find("a").attr("disabled", false);
    if(!isSystemAdmin){
      $("#divBaseDifinition").find("li:eq(5)").hide();
      $("#divBaseDifinition").find("li:eq(6)").hide();
    }
  })
  
  $("#spaceAuthInstruction").bind("click",function(event){
    if(currentInstructionsDialog){
      currentInstructionsDialog.close();
    }
    currentInstructionsDialog = $.dialog({
      id:'menuAuth',
      width: 100,
      height: 65,
      type: 'panel',
      htmlId: 'divSpaceAuth',
      targetId: 'spaceAuthInstruction',
      shadow:false,
      panelParam:{
          'show':false,
          'margins':false
      }
    });
  });
  
  $("#sectionAuthInstruction").bind("click",function(event){
    if(currentInstructionsDialog){
      currentInstructionsDialog.close();
    }
    currentInstructionsDialog = $.dialog({
        id:'menuAuth',
        width: 200,
        height: 170,
        type: 'panel',
        htmlId: 'divSectionAuth',
        targetId: 'sectionAuthInstruction',
        shadow:false,
        panelParam:{
            'show':false,
            'margins':false
        }
    });
  });
  
  $("#menuAuthInstruction").bind("click",function(event){
    if(currentInstructionsDialog){
      currentInstructionsDialog.close();
    }
    currentInstructionsDialog = $.dialog({
      id:'menuAuth',
      width: 100,
      height: 65,
      type: 'panel',
      htmlId: 'divMenuAuth',
      targetId: 'menuAuthInstruction',
      shadow:false,
      panelParam:{
          'show':false,
          'margins':false
      }
    });
  });  
  
  var msg = '${ctp:i18n("info.totally")}';
  var linktoolbar = $("#toolbar").toolbar({
    searchHtml: 'sss',
    toolbar: [
    {
        id: "newLink",
        name: "${ctp:i18n('common.toolbar.new.label')}",
        className: "ico16",
		click:function(){
			
		},
	    subMenu: [{
	      id : "addCategoryMenu",
	      name: "${ctp:i18n('link.jsp.menu.category')}",
	      click: function(){
	        addCategoryDialog = $.dialog({
				id: 'addCategory',
				html: "<table class=\"form_area\" id=\"tAddCategory\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"margin-top:20px;margin-left:10px;\"><tr><th><label class=\"margin_r_10\" for=\"text\"><font color=\"red\">*&nbsp;</font>${ctp:i18n('common.name.label')}:</label></th><td style='width:140px'><div class=\"common_txtbox_wrap\"><input type=\"text\" id=\"categoryName\" style=\"width:150\" class=\"validate\" validate=\"type:'string',name:'${ctp:i18n("common.name.label")}',notNull:true,minLength:1,maxLength:20\" onKeyUp=\"addCategoryNameKeyup()\" /></div></td></tr></table>",
				title: "${ctp:i18n('link.jsp.category.title.add')}",
				height: 70,
				width: 350,
				buttons: [{
					text: "${ctp:i18n('link.jsp.sure')}",
				    handler: function () {
				      var formobj = $("#tAddCategory").formobj();
				      if (!$._isInValid(formobj)) {
				        var nodes = $("#tree").treeObj().getSelectedNodes();
				        if(isSystemAdmin){
                          nodes =  $("#tree").treeObj().getNodes();
                        }
				        var parent = 6;
				        if(nodes.length>0){
				          parent = nodes[0].data.id;
				        }
				        new linkCategoryManager().saveCategory(-1, formobj.categoryName, isSystemAdmin, parent,{
				          success : function(category) {
				        	 
				            $("#tree").treeObj().addNodes(nodes[0], category);
				            addCategoryDialog.close();
				          }
				        });
					  }
				    }
				}, {
				    text: "${ctp:i18n('link.jsp.cancle')}",
				    handler: function () {
				      addCategoryDialog.close();
				    }
				}]
			});
	      }
	  	}, {	
	  	  id: "addLinkSystem",
	      name: isSystemAdmin?"${ctp:i18n('link.system.link')}":"${ctp:i18n('link.knowledge.link')}",
	      click: function(){
	    	isPreSystem = false;
	    	$("#name_td").children().remove();
	    	$("#url_td").children().remove();
	    	$("#sort_td").children().remove();
	    	
	    	$("#name_td").append("<div class='common_txtbox_wrap'>"+
	    	"<input type='text' id='lname' class='validate' name='nameInput' validate=\"type:'string',name:'名称',notNull:true,minLength:1,maxLength:20\" /></div>");
	       	$("#url_td").append("<div class='common_txtbox_wrap'>"+
	        		"<input type='text' id='url' onblur='linkUrlOnBlurHandler()' class='validate' name='urlInput' "+
	        		" validate=\"type:'string',name:'urlInput',"+
	        		"func:checkURL,minLength:1,maxLength:255,errorMsg:'${ctp:i18n('link.jsp.url.errorMsg')}'\" /></div>");
	    	$("#sort_td").append("<div class='common_txtbox_wrap'>"+
            		"<input type='text' id='sort' class='validate'  validate=\"name:'${ctp:i18n('link.jsp.add.order')}',notNull:true,isInteger:true,min:-9999,max:999999999,notNullWithoutTrim:true\" /></div>");
	    	var node=$("#tree").treeObj().getSelectedNodes();
	    	if(node.length==0){
	    		$("#spaceAuthInstruction").hide();
	    		$("#sectionAuthInstruction").hide();
	    	}else if(node[0].id=="1"){
	    		//当为常用链接时隐藏授权说明
	    		$("#spaceAuthInstruction").hide();
	    		$("#sectionAuthInstruction").hide();
	    	}else{
	    		$("#spaceAuthInstruction").show();
	    		$("#sectionAuthInstruction").show();
	    	}
	        $("#grid_detail").show();
            $("input,textarea, a", $("#form_area")).attr("disabled", false);
            $("input[name=aclInput]", $("#form_area")).val("");
            $("#contentForCheck").val("");
            $("textarea", $("#form_area")).val("");
            $("#image").attr("src","${path}/decorations/css/images/portal/defaultLinkSystemImage.png");
            $("#form_area .align_center").show();
            $("#menuArea").hide();
            $("#mainMenuOpenType1").parents("tr").hide();
            $("#linkSystemId").val(getUUID());
            $("#linkMainMenuId").val(getUUID());
            $("#linkMainMenuRole").val(getUUID());
            $("#agentUrl").val("");
            //$("#needContentCheck2").attr("checked", true);
            $("#sectionType").attr("disabled", false);
            //needContentCheckOnClickHandler();
            $("table[spaceTable][sample='false']").remove();
            $("table[sectionTable][sample='false']").remove();
            $("table[menuTable][sample='false']").remove();
            $("#sort").val(parseInt(new linkSystemManager().selectMaxSort(currentCategoryId)) + 1);
            var spaceTableClone = customClone($("table[spaceTable][sample='true']"), "spaceTable");
            spaceTableClone.attr("sample", "false");
            var uuid = getUUID();
            spaceTableClone.find("#linkSpaceId").val(uuid);
            spaceTableClone.find("input[name='openType']").attr("name", "openType" + uuid);
            var sectionTableClone = customClone($("table[sectionTable][sample='true']"), "sectionTable");
            sectionTableClone.attr("sample", "false");
            sectionTableClone.find("#linkSectionId").val(getUUID());
            $("#spaceArea").append(spaceTableClone);
            $("#sectionArea").append(sectionTableClone);
            $("#settingMenu").attr("checked",false);
            if(currentCategoryId == 1){
              //$("#needContentCheck1").parent().parent().parent().hide();
              $("#agentUrl").parent().parent().parent().hide();
              $("select option[value='0']", sectionTableClone).remove();
              $("select option[value='1']", sectionTableClone).remove();
              spaceTableClone.find("tr[category1]").hide();
              sectionTableClone.find("tr[category1]").hide();
              $("#advanceButton").parents("tr").hide();
              $("#linkTab_head li:eq(1)").hide();
              $("#settingMenu").parents("tr").hide();
              $("#linkTab_head li:eq(0) a").addClass("last_tab");
              $("#optionTable").hide();
              $("#charsetType").parents("tr").hide();
              $("#optionMethod1").parents("tr").hide();
              $("#addOptionButton").parent().parent().hide();
            } else {
              //$("#needContentCheck1").parent().parent().parent().show();
              $("#agentUrl").parent().parent().parent().show();
              $("select option[value='2']", sectionTableClone).remove();
              $("#advanceButton").parents("tr").show();
//               $("#linkTab_head li:eq(1)").show();
              $("#linkTab_head li:eq(0) a").removeClass("last_tab");
              $("#optionTab").show();
              if(currentCategoryId != 4){
                $("#settingMenu").parents("tr").show();
              }else{
                $("#settingMenu").parents("tr").hide();
              }
            }
            $("#allowedAsSpace").attr("checked", false);
            $("#allowedAsSection").attr("checked", false);
            if(isSystemAdmin){
              $("#linkSystem_tab").html("${ctp:i18n('link.jsp.new.linkSystem')}");
            }else{
              $("#settingMenu").parents("tr").hide();
              $("#linkSystem_tab").html("${ctp:i18n('link.jsp.new.knowledgeLink')}");
            }
            //参数列表处理
            $("#optionMethod1").parent().parent().parent().parent().hide();
            $("#charsetType").parents("tr").hide();
            $("#addOptionButton").parent().parent().hide();
            $("#optionTable").hide();
            $("#optionTable").find("tbody").find("tr").remove();
            showLinkTab();
            mytable.grid.resizeGridUpDown('middle');
	      }
	  	}]
 	},{
		id: "modifyLink",
		name: "${ctp:i18n('link.jsp.modify')}",
		className: "ico16 modify_text_16",
		click:function(){
		  if($(this).attr("disabled")==='disabled'){
			  return;
		  };
		  var checkbox=$("#mytable input[type='checkbox']");
		  $.each(checkbox,function(i,n){
			  var check=$(n);
			  if(check.attr("checked")==="checked"){
				  currentLinkSystemId=check.val();
			  }
		  })
		  $("#linkTab_head li:eq(1)").show();
		  var nodes = $("#tree").treeObj().getSelectedNodes();
	    	if(currentCategoryId=="1"){
	    		//当为常用链接时隐藏授权说明
	    		$("#spaceAuthInstruction").hide();
	    		$("#sectionAuthInstruction").hide();
	    	}else{
	    		$("#spaceAuthInstruction").show();
	    		$("#sectionAuthInstruction").show();
	    	}
		  var checkedIds = $("input:checked", $("#mytable"));
		  if(nodes != null && nodes[0] != null && checkedIds.size() == 0){
		    if(nodes[0].data.system == true){
		      $.alert("${ctp:i18n('link.jsp.cannot.modify.category')}");
		      return;
		    }
		    updateCategoryDialog = $.dialog({
				id: 'updateCategory',
				html: "<table class=\"form_area\" id=\"tUpdateCategory\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr><th><label class=\"margin_r_10\" for=\"text\"><font color=\"red\">*&nbsp;</font>${ctp:i18n('common.name.label')}:</label></th><td><div class=\"common_txtbox_wrap\"><input type=\"text\" id=\"categoryName\" value=\"" + nodes[0].cname + "\" style=\"width:150\" class=\"validate\" validate=\"type:'string',name:'${ctp:i18n("common.name.label")}',notNull:true,minLength:1,maxLength:20\" onKeyUp=\"updateCategoryNameKeyup()\" /></div></td></tr></table>",
				title: "${ctp:i18n('link.jsp.modify.category')}",
				height: 70,
				width:350,
				buttons: [{
					text: "${ctp:i18n('link.jsp.sure')}",
					handler: function () {
						var formobj = $("#tUpdateCategory").formobj();
					    if (!$._isInValid(formobj)) {
						    new linkCategoryManager().saveCategory(nodes[0].id, formobj.categoryName,isSystemAdmin,nodes[0].parentId, {
						    	success : function(category) {
						    	  nodes[0].data.cname = nodes[0].cname = escapeStringToHTML(category.cname);
						    	  $("#tree").treeObj().updateNode(nodes[0]);
						    	  updateCategoryDialog.close();
						        }
						    });
						}
					}
				}, {
					text: "${ctp:i18n('link.jsp.cancle')}",
					handler: function () {
					  updateCategoryDialog.close();
					}
				}]
			});
		  } else {
		    var checkedIds = $("input:checked", $("#mytable"));
		    if (checkedIds.size() == 0) {
		      $.alert("${ctp:i18n('link.jsp.select.modify.category')}");
		    } else if (checkedIds.size() > 1) {
		      $.alert("${ctp:i18n('link.jsp.select.onlyOne.category')}");
		    } else {
		      new linkSystemManager().selectLinkSystem($(checkedIds[0]).attr("value"), {
		        success : function(linkSystem) {
		          isPreSystem = linkSystem.system;
		          currentCategoryId = linkSystem.linkCategoryId;
		          if(isSystemAdmin){
		            $("#linkSystem_tab").html("${ctp:i18n('link.jsp.modify.systemLink')}");
		          }else{
		            $("#linkSystem_tab").html("${ctp:i18n('link.jsp.modify.knowledgeLink')}");
		          }
		          mytable.grid.resizeGridUpDown('middle');
		          $("#linkMainMenuId").val(getUUID());
		          $("#linkMainMenuRole").val(getUUID());
		          showDetail(linkSystem);
		          $("#form_area .align_center").show();
		          $("input,textarea,a,span,select,checkbox", $("#form_area")).attr("disabled", false);
		        } 
		      });
		    }
		  }
		} 	  
 	},{
		id: "del_sys_cat",
		name: "${ctp:i18n('link.jsp.del')}",
		className: "ico16 del_16",
		click:function(){
		  if($(this).attr("disabled")==='disabled'){
			  return;
		  }
		  var nodes = $("#tree").treeObj().getSelectedNodes();
		  if(nodes != null && nodes[0] != null){
		    if(nodes[0].data.system == true||nodes[0].id==0){
		      $.alert("${ctp:i18n('link.jsp.cannot.del.system.def.category')}");
		      return;
		    }
		    $.confirm({
	          'type' : 1,
	          'msg' : "${ctp:i18n('link.jsp.del.cateory.isOrno')}" + nodes[0].data.cname + "?",
	          ok_fn : function() {
	            new linkCategoryManager().deleteCategory(nodes[0].data.id, {
	              success : function(data) {
	                $("#tree").treeObj().removeNode(nodes[0]);
	              }   
	            });
	          }
	        });
		  } else {
		    var checkedIds = $("input:checked", $("#mytable"));
		    if (checkedIds.size() == 0) {
		      $.alert("${ctp:i18n('link.jsp.sel.del.item')}");
		    } else {
		      var params = new Array();
	          for(var i = 0; i < checkedIds.size(); i++){
	            params.push($(checkedIds[i]).val());
	          }
	          $.confirm({
	            'type' : 1,
	            'msg' : "${ctp:i18n('link.jsp.del.systemLink.isOrno')}",
	            ok_fn : function() {
	              new linkSystemManager().deleteLinkSystemByIds(params, {
	                success : function(data) {
	                  if(currentCategoryId != null){
		                var params = new Object();
		                params.categoryId = currentCategoryId;
		                $("#mytable").ajaxgridLoad(params);
		                $("#grid_detail").hide();
		                $("#manual").show();
		                mytable.grid.resizeGridUpDown('middle');
		                $("#count").html(msg.format(mytable.p.total));
	                  }
	                } 
	              });
	            }
	          });
		    }
		  }
		} 	  
 	},{
        id: "systemSort",
        name: "${ctp:i18n('link.jsp.sort')}",
        className: "ico16 sort_16",
        click:function(){
          var nodes = $("#tree").treeObj().getSelectedNodes();
          var dialog = $.dialog({
            url : '${path}/portal/linkSystemController.do?method=linkSystemOrder&doType=5&categoryId='+nodes[0].data.id,
            width : 260,
            height : 250,
            title : "${ctp:i18n('link.jsp.systemLink.sort')}",
            buttons : [ {
              text : "${ctp:i18n('link.jsp.sure')}",
              handler : function() {
                var linkMembers = new Array();
                var linkOptions = dialog.getReturnValue();
                  for(var i = 0;i < linkOptions.size();i++){
                    var linkMember = new Object();
                    linkMember.id = getUUID();
                    linkMember.linkSystemId = linkOptions[i].value;
                    linkMember.userLinkSort = i;
                    linkMembers.push(linkMember);
                  }
                  new linkSystemManager().saveLinkMember(linkMembers,{
                  success : function(linkMember){
                    dialog.close();
                    if(currentCategoryId != null){
                      var params = new Object();
                      params.categoryId = currentCategoryId;
                      if(!isSystemAdmin){
                        params.includeKnowledge = true;
                      }
                      $("#mytable").ajaxgridLoad(params);
                    }
                    $("#mytable").ajaxgridLoad();
                  }
                });
              }
            }, {
              text : "${ctp:i18n('link.jsp.cancle')}",
              handler : function() {
                dialog.close();
              }
            } ]
          });
        }     
    }]
  });
  
  $("#lname,#url,#sort").live("focus",function(){
	  var val=$(this).val();
	  if(val.indexOf("<")!="-1"||val.indexOf(">")!="-1"){
		  $(this).val("");
	  }
  })
  
  $("#grid_detail").hide();
  $("#toolbar").find("a:last").hide();
  if(isSystemAdmin){
    linktoolbar.disabledAll();
    linktoolbar.enabled("newLink");
    linktoolbar.enabled("addLinkSystem");
    linktoolbar.disabled("addCategoryMenu");
    linktoolbar.enabled("modifyLink");
    linktoolbar.enabled("del_sys_cat");
    $("#enabled").parents("tr").hide();
    $("#spaceArea").show();
    $("#sectionArea").show();
    $("#linkSystem_tab").html("${ctp:i18n('link.jsp.add.label.show')}");
  }else{
    linktoolbar.disabledAll();
    $("#enabled").parents("tr").show();
    $("#spaceArea").hide();
    $("#sectionArea").hide();
    $("#linkSystem_tab").html("${ctp:i18n('link.jsp.knowledgeLink.show')}");
  }
  
  $("#tree").tree({
    onClick : treeClk,
    idKey : "id",
    pIdKey : "parentId",
    nameKey : "cname",
    nodeHandler : function(n) {
      if (n.data.parentId == '-1') {
        //n.iconSkin = "treeMyKnowledge";
        n.open = true;
      } else {
        n.isParent = true;
      }
    },
    render : function(name, data) {
      if(data.id == 1){
        return "${ctp:i18n('link.category.common')}";
      }else if(data.id == 2){
    	  return "${ctp:i18n('link.category.in')}";
      }else if(data.id == 3){
    	  return "${ctp:i18n('link.category.out')}";
      }else if(data.id == 4){
    	  return "${ctp:i18n('link.category.knowledge')}";
      }else{
        data.cname = escapeStringToHTML(name);
     	return escapeStringToHTML(name);
      }
    }
  });

  var mytable = $("#mytable").ajaxgrid({
    colModel : [ {
      display : 'id',
      name : 'id',
      width : '40',
      sortable : false,
      align : 'center',
      type : 'checkbox'
    },{
      display : "${ctp:i18n('link.jsp.menu.name')}",
      name : 'lname',
      sortable : true,
      width : isSystemAdmin?'50%':'40%'
    }
    <c:if test="${!isSystemAdmin}">
    ,{
      display : "${ctp:i18n('link.jsp.menu.createperson')}",
      name : 'createUserId',
      sortable : true,
      width : isSystemAdmin?'0%':'15%',
      hide : isSystemAdmin,
      isToggleHideShow : !isSystemAdmin
    }
    </c:if>
    ,{
      display : "${ctp:i18n('link.jsp.menu.category')}",
      name : 'cname',
      sortable : true,
      width : isSystemAdmin?'20%':'15%'
    },{
      display : "${ctp:i18n('link.jsp.menu.createtime')}",
      name : 'createTime',
      sortable : true,
      width : isSystemAdmin?'20%':'15%'
    }
    <c:if test="${!isSystemAdmin}">
    ,{
      display : "${ctp:i18n('link.jsp.isUsed')}",
      name : 'enabled',
      sortable : true,
      width : isSystemAdmin?'0%':'9%',
      hide : isSystemAdmin,
      isToggleHideShow : !isSystemAdmin
    }
    </c:if>
    ],
    click : mytableClk,
    onSuccess: mytableSuccess,
    onNoDataSuccess : function(){
      //setTimeout(function(){mytable.grid.resizeGridUpDown('down');}, 1000);      
    },
    managerName : "linkSystemManager",
    managerMethod : "selectLinkSystem",
    render : mytableRend,
    height : 200,
    parentId : 'center',
    slideToggleBtn : true,
    vChange : true,
	callBackTotle:function(totle){
		$("#count").html(msg.format(totle));
	},
    vChangeParam: {
      'changeTar': 'grid_detail',
       overflow: "hidden",
      'subHeight': 0,
      autoResize:true
      }
  });

  
  function mytableRend(txt, data, r, c) {
    if(!isSystemAdmin){
      if(c == 2){
    	var entity = new orgManager().getMemberById(data.createUserId);
    	txt = entity.name;
      }else if(c == 5){
    	txt = data.enabled==1?"${ctp:i18n('link.jsp.yes')}":"${ctp:i18n('link.jsp.no')}";
      }
    }
  	return $.i18n(txt) || txt;
  }
  
  //单击列表中一行，下面form显示详细信息
  function mytableClk(data, r, c) {
    currentLinkSystemId = data.id;
	if(currentCategoryId=="1"){
  		//当为常用链接时隐藏授权说明
  		$("#spaceAuthInstruction").hide();
  		$("#sectionAuthInstruction").hide();
  	}else{
  		$("#spaceAuthInstruction").show();
  		$("#sectionAuthInstruction").show();
  	}
    var node = $("#tree").treeObj().getSelectedNodes()[0];
    $("#tree").treeObj().cancelSelectedNode(node);
    new linkSystemManager().selectLinkSystem(currentLinkSystemId, {
      success : function(linkSystem) {
    	$("#linkSystem_div").show();
        $("#linkOptionValue_div").hide();
        $("#showLinkTab").removeClass();
        $("#optionTab").removeClass();
        $("#showLinkTab").addClass("current");
        if(isSystemAdmin){
          $("#linkSystem_tab").html("${ctp:i18n('link.jsp.add.label.show')}");
        }else{
          $("#linkSystem_tab").html("${ctp:i18n('link.jsp.knowledge.show')}");
        }
        mytable.grid.resizeGridUpDown('middle');
        $("#form_area .align_center").hide();
        $("input,textarea,a,span,select,checkbox", $("#form_area")).attr("disabled", true);
      	$("#operationInstruction").attr("disabled",false);
      	$("#menuAuthInstruction").attr("disabled",false);
      	$("#spaceAuthInstruction").attr("disabled",false);
      	$("#sectionAuthInstruction").attr("disabled",false);
        showDetail(linkSystem);
      	//$("#linkOptionValueFrame").attr("src", "${path}/portal/linkSystemController.do?method=linkOptionValueMain&linkSystemId=" + linkSystem.id);
      	$("input,textarea,select", $("#grid_detail")).attr("disabled", true);
      	if(isSystemAdmin || linkSystem.createUserId == "${currentUserId}"){
      	  linktoolbar.enabled("modifyLink");
          linktoolbar.enabled("del_sys_cat");
          linktoolbar.disabled("newLink");
        }
      } 
    });
  }
  
  function treeClk(e, treeId, node) {
    currentCategoryId = node.data.id;
    if(node.id != 1 && node.id != 5){
      $("#tree li:eq(1)").find("a").removeClass("curSelectedNode");
    }
    if(!isSystemAdmin){
      if(currentCategoryId==0){
        linktoolbar.disabledAll();
        return;
      }else if(currentCategoryId == 5 || currentCategoryId == 6){
        //知识中心
        linktoolbar.disabledAll();
        if(currentCategoryId == 6){
          linktoolbar.enabled("newLink");
          linktoolbar.disabled("addLinkSystem");
          linktoolbar.enabled("addCategoryMenu");
        }
      }else{
        linktoolbar.enabled("newLink");
    	linktoolbar.enabled("modifyLink");
    	linktoolbar.enabled("del_sys_cat");
        linktoolbar.enabled("addLinkSystem");
        linktoolbar.disabled("addCategoryMenu");
      }
    }else{
      if(currentCategoryId == 0){
        linktoolbar.disabledAll();
        linktoolbar.enabled("newLink");
        linktoolbar.disabled("addLinkSystem");
        linktoolbar.enabled("addCategoryMenu");
        return;
      }else{
        linktoolbar.enabled("newLink");
        linktoolbar.enabled("addLinkSystem");
        linktoolbar.disabled("addCategoryMenu");
        linktoolbar.enabled("modifyLink");
        linktoolbar.enabled("del_sys_cat");
      }
    }
    
    var params = new Object();
    params.categoryId = currentCategoryId;
    if(!isSystemAdmin){
      params.includeKnowledge = true;
    }
    $("#mytable").ajaxgridLoad(params);
    $("#grid_detail").hide();
    $("#manual").show();
    mytable.grid.resizeGridUpDown('down');
  } 
  
  //显示详细信息
  function showDetail(linkSystem){
    $("#grid_detail").resetValidate();
  	$("#name_td").children().remove();
   	$("#url_td").children().remove();
   	$("#sort_td").children().remove();
   	
   	$("#name_td").append("<div class='common_txtbox_wrap'>"+
   	"<input type='text' id='lname' class='validate' name='nameInput'  validate=\"type:'string',name:'名称',notNull:true,minLength:1,maxLength:20\" /></div>");
   	$("#url_td").append("<div class='common_txtbox_wrap'>"+
    		"<input type='text' id='url' onblur='linkUrlOnBlurHandler()' class='validate' name='urlInput' "+
    		" validate=\"type:'string',name:'urlInput',"+
    		"func:checkURL,minLength:1,maxLength:255,errorMsg:'${ctp:i18n('link.jsp.url.errorMsg')}'\" /></div>");
   	$("#sort_td").append("<div class='common_txtbox_wrap'>"+
       		"<input type='text' id='sort' class='validate'  validate=\"name:'${ctp:i18n('link.jsp.add.order')}',notNull:true,isInteger:true,min:-9999,max:999999999,notNullWithoutTrim:true\" /></div>");
    	
    $("#manual").hide();
    if(!isSystemAdmin){
      $("#grid_detail").height("264px");
    }
    $("#grid_detail").show();
    $("#linkSystemId").val(linkSystem.id);
    $("#lname").val(linkSystem.lname);
    $("#url").val(linkSystem.url);
    $("#enabled").attr("checked",linkSystem.enabled==1);
    //if(linkSystem.needContentCheck == 1){
    //  $("#needContentCheck1").attr("checked", true);
    //} else {
    //  $("#needContentCheck2").attr("checked", true);
    //}
    $("#settingMenu").attr("checked", linkSystem.allowedAsMenu == 1);
    if(currentCategoryId != 1){
      $("#agentUrl").parent().parent().parent().show();
      //$("#needContentCheck1").parent().parent().parent().show();
      $("#advanceButton").parents("tr").show();
      $("#linkTab_head li:eq(1)").show();
      $("#linkTab_head li:eq(0) a").removeClass("last_tab");
      $("#settingMenu").parents("tr").show();
      if(currentCategoryId == 4 || !isSystemAdmin){
        $("#menuArea").hide();
        $("#mainMenuOpenType1").parents("tr").hide();
        $("#settingMenu").parents("tr").hide();
      }
    } else {
      //$("#needContentCheck1").parent().parent().parent().hide();
      $("#agentUrl").parent().parent().parent().hide();
      $("#advanceButton").parents("tr").hide();
      $("#linkTab_head li:eq(1)").hide();
      $("#linkTab_head li:eq(0) a").addClass("last_tab");
      $("#mainMenuOpenType1").parents("tr").hide();
      $("#settingMenu").parents("tr").hide();
      $("#optionTable").hide();
      $("#charsetType").parents("tr").hide();
      $("#optionMethod1").parents("tr").hide();
      $("#addOptionButton").parent().parent().hide();
    }
    $("#contentForCheck").val(linkSystem.contentForCheck);
    /*
    if(linkSystem.sameRegion == 1){
      $("#sameRegion1").attr("checked", true);
    } else {
      $("#sameRegion2").attr("checked", true);
    }
    if(currentCategoryId != 1 && linkSystem.needContentCheck == 1){
      $("#contentForCheck").parent().parent().parent().show();
      $("#sameRegion1").parent().parent().parent().parent().show();
    } else {
      $("#contentForCheck").parent().parent().parent().hide();
      $("#sameRegion1").parent().parent().parent().parent().hide();
    }
    */
    $("#agentUrl").val(linkSystem.agentUrl);
    /*
    if(currentCategoryId != 1 && linkSystem.needContentCheck == 1 && linkSystem.sameRegion == 0){
      $("#agentUrl").parent().parent().parent().show();
    } else {
      $("#agentUrl").parent().parent().parent().hide();
    }
    */
    $("#sort").val(linkSystem.orderNum);
    $("#description").val(linkSystem.description);
    $("#settingMenu").val(linkSystem.allowedAsMenu);
    $("#image").attr("src", linkSystem.image);
    var aclValues = "";
    var aclTxts = "";
    if(linkSystem.linkAcls.length > 0){
      for(var i = 0; i < linkSystem.linkAcls.length; i++){
        aclValues += (linkSystem.linkAcls[i].userType + "|" + linkSystem.linkAcls[i].userId + ",");
        var entity = new orgManager().getEntity(linkSystem.linkAcls[i].userType, linkSystem.linkAcls[i].userId);
        aclTxts += (entity.name + ",");
      }
      aclValues = aclValues.substr(0, aclValues.length - 1);
      aclTxts = aclTxts.substr(0, aclTxts.length - 1);
    }
    $("#linkSystemAcl").val(aclValues);
    $("#linkSystemAcl_txt").val(aclTxts);
    $("#charsetType").attr("value",linkSystem.targetCharset);
    if(linkSystem.method == "get"){
      $("input[name='optionMethod']:first").attr("checked", true);
    } else {
      $("input[name='optionMethod']:last").attr("checked", true);
    }
    $("#optionTable").find("tbody").find("tr").remove();
    if(linkSystem.linkOptions.length>0){
      for(var i = 0; i < linkSystem.linkOptions.length; i++){
        addOptionClickHandler(linkSystem.linkOptions[i]);
      }
      $("#optionMethod1").parent().parent().parent().parent().show();
      $("#charsetType").parents("tr").show();
      $("#addOptionButton").parent().parent().show();
      $("#optionTable").show();
    }
    //空间
    $("table[spaceTable][sample='false']").remove();
    for(var i = 0; i < linkSystem.linkSpaces.length; i++){
      var spaceTableClone = customClone($("table[spaceTable][sample='true']"), "spaceTable");
      $(spaceTableClone).attr("sample", "false");
      $(spaceTableClone).find("#linkSpaceId").val(linkSystem.linkSpaces[i].id);
      $(spaceTableClone).find("#spaceName").val(linkSystem.linkSpaces[i].spaceName);
      $(spaceTableClone).find("#targetPageUrl").val(linkSystem.linkSpaces[i].targetPageUrl);
      $(spaceTableClone).find("#contentForCheck").val(linkSystem.linkSpaces[i].contentForCheck);
      if(currentCategoryId != 1){
        $(spaceTableClone).find("#contentForCheck").parent().parent().parent().show();
      } else {
        $(spaceTableClone).find("#contentForCheck").parent().parent().parent().hide();
      }
      $(spaceTableClone).find("input[name='openType']").attr("name", "openType" + linkSystem.linkSpaces[i].id);
      if(linkSystem.linkSpaces[i].openType == "1"){
        $(spaceTableClone).find("input[name='openType" + linkSystem.linkSpaces[i].id + "']:first").attr("checked", true);
      } else {
        $(spaceTableClone).find("input[name='openType" + linkSystem.linkSpaces[i].id + "']:last").attr("checked", true);
      }
      if(currentCategoryId == 1){
        $(spaceTableClone).find("tr[category1]").hide();
      }
      aclValues = "";
      aclTxts = "";
      if(linkSystem.linkSpaces[i].linkSpaceAcls.length > 0){
        for(var j = 0; j < linkSystem.linkSpaces[i].linkSpaceAcls.length; j++){
          aclValues += (linkSystem.linkSpaces[i].linkSpaceAcls[j].userType + "|" + linkSystem.linkSpaces[i].linkSpaceAcls[j].userId + ",");
          var entity = new orgManager().getEntity(linkSystem.linkSpaces[i].linkSpaceAcls[j].userType, linkSystem.linkSpaces[i].linkSpaceAcls[j].userId);
          aclTxts += (entity.name + ",");
        }
        aclValues = aclValues.substr(0, aclValues.length - 1);
        aclTxts = aclTxts.substr(0, aclTxts.length - 1);
      }
      $(spaceTableClone).find("#linkSpaceAcl").val(aclValues);
      $(spaceTableClone).find("#linkSpaceAcl_txt").html(aclTxts);
      $("#spaceArea").append(spaceTableClone);
    }
    if(linkSystem.allowedAsSpace == 1){
      $("#allowedAsSpace").attr("checked", true);
      $("table[spaceTable][sample='false']").show();
    } else {
      $("#allowedAsSpace").attr("checked", false);
      $("table[spaceTable][sample='false']").hide();
    }
    
    //栏目
    $("table[sectionTable][sample='false']").remove();
    for(var i = 0; i < linkSystem.linkSections.length; i++){
      var sectionTableClone = customClone($("table[sectionTable][sample='true']"), "sectionTable");
      $(sectionTableClone).attr("sample", "false");
      $(sectionTableClone).find("#linkSectionId").val(linkSystem.linkSections[i].id);
      $(sectionTableClone).find("#sname").val(linkSystem.linkSections[i].sname);
      $(sectionTableClone).find("#sectionType").val(linkSystem.linkSections[i].type);
      $(sectionTableClone).find("#targetUrl").val(linkSystem.linkSections[i].targetUrl);
      $(sectionTableClone).find("#contentForCheck").val(linkSystem.linkSections[i].contentForCheck);
      if(currentCategoryId != 1){
        $(sectionTableClone).find("#contentForCheck").parent().parent().parent().show();
      } else {
        $(sectionTableClone).find("#contentForCheck").parent().parent().parent().hide();
      }
      $(sectionTableClone).find("#height").val(linkSystem.linkSections[i].height);
      if(currentCategoryId == 1){
        $("select option[value='0']", $(sectionTableClone)).remove();
        $("select option[value='1']", $(sectionTableClone)).remove();
        $(sectionTableClone).find("tr[category1]").hide();
      } else {
        $("select option[value='2']", $(sectionTableClone)).remove();
        $(sectionTableClone).find("tr[category1]").show();
      }
      $(sectionTableClone).find("#timeout").val(linkSystem.linkSections[i].timeout);
      if(linkSystem.linkSections[i].type == 0){
        $(sectionTableClone).find("#timeout").parent().parent().parent().show();
      } else {
        $(sectionTableClone).find("#timeout").parent().parent().parent().hide();
      }
      aclValues = "";
      aclTxts = "";
      if(linkSystem.linkSections[i].linkSectionSecurities.length > 0){
        for(var j = 0; j < linkSystem.linkSections[i].linkSectionSecurities.length; j++){
          aclValues += (linkSystem.linkSections[i].linkSectionSecurities[j].entityType + "|" + linkSystem.linkSections[i].linkSectionSecurities[j].entityId + ",");
          var entity = new orgManager().getEntity(linkSystem.linkSections[i].linkSectionSecurities[j].entityType, linkSystem.linkSections[i].linkSectionSecurities[j].entityId);
          aclTxts += (entity.name + ",");
        }
        aclValues = aclValues.substr(0, aclValues.length - 1);
        aclTxts = aclTxts.substr(0, aclTxts.length - 1);
      }
      $(sectionTableClone).find("#linkSectionAcl").val(aclValues);
      $(sectionTableClone).find("#linkSectionAcl_txt").html(aclTxts);
      $("#sectionArea").append(sectionTableClone);
    }
    if(linkSystem.allowedAsSection == 1){
      $("#allowedAsSection").attr("checked", true);
      $("table[sectionTable][sample='false']").show();
    } else {
      $("#allowedAsSection").attr("checked", false);
      $("table[sectionTable][sample='false']").hide();
    }
    //菜单
    $("table[menuTable][sample='false']").remove();
    for(var i = 0; i < linkSystem.linkMenus.length; i++){
      var linkMenu = linkSystem.linkMenus[i];
      if(linkMenu.parentId == 0){
        $("#linkMainMenuRole").val(linkMenu.roleId);
        $("#linkMainMenuId").val(linkMenu.id);
      }else{
        var menuTableClone = customClone($("table[menuTable][sample='true']"), "menuTable");
        $(menuTableClone).attr("sample", "false");
        $(menuTableClone).find("#linkMenuId").val(linkMenu.id);
        $(menuTableClone).find("#mname").val(linkMenu.mname);
        var uuid = getUUID();
        if(linkMenu.openType == 1){
          menuTableClone.find(":radio:first").replaceWith("<input type='radio' value='1' id='menuOpenType1' name='menuOpenType" + uuid + "' class='radio_com' checked='checked' />");
          menuTableClone.find(":radio:last").replaceWith("<input type='radio' value='2' id='menuOpenType2' name='menuOpenType" + uuid + "' class='radio_com' />");
        } else {
          menuTableClone.find(":radio:first").replaceWith("<input type='radio' value='1' id='menuOpenType1' name='menuOpenType" + uuid + "' class='radio_com' />");
          menuTableClone.find(":radio:last").replaceWith("<input type='radio' value='2' id='menuOpenType2' name='menuOpenType" + uuid + "' class='radio_com' checked='checked' />");
        }
        $(menuTableClone).find("#menuTargetUrl").val(linkMenu.targetUrl);
        $(menuTableClone).find("#contentForCheck").val(linkMenu.contentForCheck);
        $(menuTableClone).find("#linkMenuRoleId").val(linkMenu.roleId);
        aclValues = "";
        aclTxts = "";
        var linkMenuAcls = linkMenu.linkMenuAcls;
        if(linkMenuAcls!=null && linkMenuAcls.length > 0){
          for(var j = 0; j < linkMenuAcls.length; j++){
            var entityType = linkMenuAcls[j].userType;
            var entityId = linkMenuAcls[j].userId;
            aclValues += (entityType + "|" + entityId + ",");
            var entity = new orgManager().getEntity(entityType, entityId);
            aclTxts += (entity.name + ",");
          }
          aclValues = aclValues.substr(0, aclValues.length - 1);
          aclTxts = aclTxts.substr(0, aclTxts.length - 1);
        }
        $(menuTableClone).find("#linkMenuAcl").val(aclValues);
        $(menuTableClone).find("#linkMenuAcl_txt").html(aclTxts);
        $("#menuArea").append(menuTableClone);
      }
    }
    if(linkSystem.allowedAsMenu == 1 && linkSystem.linkMenus.length > 1){
      $("#menuArea").show();
      $("#allowedAsMenu").attr("checked", true);
      $("table[menuTable][sample='false']").show();
    } else {
      $("#menuArea").show();
      $("#allowedAsMenu").attr("checked", false);
      $("table[menuTable][sample='false']").hide();
    }
    if(currentCategoryId == "1" || currentCategoryId == "4" || !isSystemAdmin){
      $("#menuArea").hide();
    }
    if(linkSystem.allowedAsMenu == 0){
      $("#menuArea").hide();
      $("#mainMenuOpenType1").parents("tr").hide();
    }
  }
  
  //单击列表中一行，下面form显示详细信息
  function mytableSuccess() {
    $(".slideUpBtn").click(function(){
      setTimeout(function(){
        $("#linkOptionValueFrame").attr("src", "${path}/portal/linkSystemController.do?method=linkOptionValueMain&linkSystemId=" + currentLinkSystemId);
      },200);
    });
    $(".slideDownBtn").click(function(){
      setTimeout(function(){
        $("#linkOptionValueFrame").attr("src", "${path}/portal/linkSystemController.do?method=linkOptionValueMain&linkSystemId=" + currentLinkSystemId);
      },200);
    });
    $("input[type='checkbox']", $("#mytable")).click(function(){
      $("#tree").treeObj().cancelSelectedNode($("#tree").treeObj().getSelectedNodes()[0]);
    });
    setTimeout(function(){
      mytable.grid.resizeGridUpDown('middle');
    },200);
  }
  
  $("#submitbtn").live("click",function() {
	var formobj = $("#form_area").formobj();
    if (!$._isInValid(formobj)) {
      var bool=checkOptionDuplicateRepeat();
      if(!bool){
        $.alert("参数名称或标记不能重复");
        return false;
      }
      var linkSystem = new Object();
      linkSystem.id = $("#linkSystemId").val();
      var formobjTmp = null;
      if(typeof(formobj[0]) == "undefined"){
        formobjTmp = formobj;
      } else {
        formobjTmp = formobj[0];
      }
      linkSystem.system = isPreSystem;
      linkSystem.lname = formobjTmp.lname;
      linkSystem.url = $("#url").val();
      //linkSystem.needContentCheck = ($("#needContentCheck1").attr("checked") == "checked"? 1 : 0);
      //linkSystem.contentForCheck = $("#contentForCheck").val();
      //linkSystem.sameRegion = ($("#sameRegion1").attr("checked") == "checked"? 1 : 0);
      linkSystem.agentUrl = $("#agentUrl").val();
      linkSystem.orderNum = $("#sort").val();
      linkSystem.description = $("#description").val();
      linkSystem.image = $("#image").attr("src");
      linkSystem.method = ($("#optionMethod1").attr("checked") == "checked"? "get" : "post");
      linkSystem.targetCharset = ($("#charsetType").val());
      linkSystem.linkCategoryId = currentCategoryId;
      linkSystem.linkAcls = new Array();
      linkSystem.enabled = ($("#enabled").attr("checked") == "checked"? 1 : 0);
      linkSystem.creatorType = isSystemAdmin?0:1;
      var linkSystemAclStr = $("#linkSystemAcl").val();
      if(linkSystemAclStr != ""){
        var linkSystemAclArray = linkSystemAclStr.split(",");
        for(var i = 0; i < linkSystemAclArray.length; i++){
          var linkAcl = new Object();
          linkAcl.id = getUUID();
          linkAcl.userType = linkSystemAclArray[i].split("|")[0];
          linkAcl.userId = linkSystemAclArray[i].split("|")[1];
          linkAcl.linkSystemId = linkSystem.id;
          linkAcl.linkCategoryId = 0;
          linkSystem.linkAcls.push(linkAcl);
        }
      }
      linkSystem.linkOptions = new Array();
      var optionTrs = $("#optionTable").find("tbody").find("tr");
      var orderNum = 0;
      for(var i = 0; i < $(optionTrs).size(); i++){
        var linkOption = new Object();
        linkOption.id = $(optionTrs[i]).find("input[paramId]").val();
        linkOption.paramName = $(optionTrs[i]).find("input[paramName]").val();
        linkOption.paramSign = $(optionTrs[i]).find("input[paramSign]").val();
        linkOption.paramValue = $(optionTrs[i]).find("input[paramValue]").val();
        if(linkOption.paramValue){
          
        }
        linkOption.password = $(optionTrs[i]).find("input[isPassword]").attr("checked") == "checked"? true : false;
        linkOption.orderNum = orderNum++;
        linkOption.linkSystemId = linkSystem.id;
        linkSystem.linkOptions.push(linkOption);
      }
      //空间
      linkSystem.linkSpaces = new Array();
      linkSystem.allowedAsSpace = $("#allowedAsSpace").attr("checked") == "checked"? 1 : 0;
      if(linkSystem.allowedAsSpace == 1){
        var spaceTables = $("table[spaceTable][sample='false']");
        orderNum = 0;
        for(var i = 0; i < $(spaceTables).size(); i++){
          var linkSpace = new Object();
          linkSpace.id = $(spaceTables[i]).find("#linkSpaceId").val();
          linkSpace.spaceName = $(spaceTables[i]).find("#spaceName").val();
          linkSpace.targetPageUrl = linkSystem.url;
          if(linkSpace.targetPageUrl == ""){
            linkSpace.targetPageUrl = linkSystem.url;
          }
          linkSpace.contentForCheck = $(spaceTables[i]).find("#contentForCheck").val();
          linkSpace.openType = $(spaceTables[i]).find("input[name='openType" + linkSpace.id + "']:first").attr("checked") == "checked"? 1 : 2;
          linkSpace.sort = orderNum++;
          linkSpace.linkSystemId = linkSystem.id;
          linkSpace.linkSpaceAcls = new Array();
          var linkSpaceAclStr = $(spaceTables[i]).find("#linkSpaceAcl").val();
          if(currentCategoryId==1){
            //关联系统空间授权和关联系统授权范围保持一致
            linkSpaceAclStr = linkSystemAclStr;
            linkSpace.spaceName = linkSystem.lname;
          }
          if(linkSpaceAclStr != ""){
            var linkSpaceAclArray = linkSpaceAclStr.split(",");
            for(var k = 0; k < linkSpaceAclArray.length; k++){
              var linkSpaceAcl = new Object();
              linkSpaceAcl.id = getUUID();
              linkSpaceAcl.userType = linkSpaceAclArray[k].split("|")[0];
              linkSpaceAcl.userId = linkSpaceAclArray[k].split("|")[1];
              linkSpaceAcl.linkSpaceId = linkSpace.id;
              linkSpace.linkSpaceAcls.push(linkSpaceAcl);
            }
          }
          linkSystem.linkSpaces.push(linkSpace);
        }
      }
      //栏目
      linkSystem.linkSections = new Array();
      linkSystem.allowedAsSection = $("#allowedAsSection").attr("checked") == "checked"? 1 : 0;
      if(linkSystem.allowedAsSection == 1){
        var sectionTables = $("table[sectionTable][sample='false']");
        orderNum = 0;
        for(var i = 0; i < $(sectionTables).size(); i++){
          var linkSection = new Object();
          linkSection.id = $(sectionTables[i]).find("#linkSectionId").val();
          linkSection.sname = $(sectionTables[i]).find("#sname").val();
          linkSection.type = $(sectionTables[i]).find("#sectionType").val();
          /*
          if(linkSection.type == "0" && !$("#agentUrl").is(":visible")){
            $.alert("数据集成型栏目需要系统管理员设置网络代理后才可使用!");
            return false;
          }
          */
          linkSection.targetUrl = $(sectionTables[i]).find("#targetUrl").val();
          if(linkSection.targetUrl == ""){
            linkSection.targetUrl = linkSystem.url;
          }
          linkSection.contentForCheck = $(sectionTables[i]).find("#contentForCheck").val();
          linkSection.timeout = $(sectionTables[i]).find("#timeout").val();
          linkSection.height = $(sectionTables[i]).find("#height").val();
          linkSection.sort = orderNum++;
          linkSection.linkSystemId = linkSystem.id;
          linkSection.linkSectionSecurities = new Array();
          var linkSectionAclStr = $(sectionTables[i]).find("#linkSectionAcl").val();
          if(currentCategoryId==1){
            //关联系统空间授权和关联系统授权范围保持一致
            linkSectionAclStr = linkSystemAclStr;
            linkSection.sname = linkSystem.lname;
          }
          var sort = 0;
          if(linkSectionAclStr != ""){
            var linkSectionAclArray = linkSectionAclStr.split(",");
            for(var k = 0; k < linkSectionAclArray.length; k++){
              var linkSectionSecurity = new Object();
              linkSectionSecurity.id = getUUID();
              linkSectionSecurity.entityType = linkSectionAclArray[k].split("|")[0];
              linkSectionSecurity.entityId = linkSectionAclArray[k].split("|")[1];
              linkSectionSecurity.sectionDefinitionId = linkSection.id;
              linkSectionSecurity.sort = sort++;
              linkSection.linkSectionSecurities.push(linkSectionSecurity);
            }
          }
          linkSystem.linkSections.push(linkSection);
        }
      }
      //菜单
      linkSystem.linkMenus = new Array();
      //一级菜单
      var settingMenu = $("#settingMenu").attr("checked") == "checked"? 1 : 0;
      linkSystem.allowedAsMenu = settingMenu;
      if(settingMenu==1){
        var linkMenu = new Object();
        var orderNum = 0;
        var topMenuId = $("#linkMainMenuId").val();
        linkMenu.id = topMenuId;
        linkMenu.mname = linkSystem.lname;
        linkMenu.targetUrl = linkSystem.url;
        linkMenu.contentForCheck = "";
        linkMenu.sort = orderNum++;
        linkMenu.linkSystemId = linkSystem.id;
        linkMenu.roleId = $("#linkMainMenuRole").val();
        //linkMenu.openType = $("input:radio[name=mainMenuOpenType]:checked").val();
        linkMenu.openType = 1;
        linkMenu.parentId = 0;
        linkMenu.linkMenuAcls = new Array();
        var linkMenuAclStr = $("#linkSystemAcl").val();
        var sort = 0;
        if(linkMenuAclStr != ""){
          var linkMenuAclArray = linkMenuAclStr.split(",");
          for(var k = 0; k < linkMenuAclArray.length; k++){
            var linkMenuAcl = new Object();
            linkMenuAcl.id = getUUID();
            linkMenuAcl.userType = linkMenuAclArray[k].split("|")[0];
            linkMenuAcl.userId = linkMenuAclArray[k].split("|")[1];
            linkMenuAcl.linkMenuId = linkMenu.id;
            linkMenu.linkMenuAcls.push(linkMenuAcl);
          }
        }
        linkSystem.linkMenus.push(linkMenu);

        //二级菜单
        var allowedAsMenu = $("#allowedAsMenu").attr("checked") == "checked"? 1 : 0;
        if(allowedAsMenu == 1){
          var menuTables = $("table[menuTable][sample='false']");
          for(var i = 0; i < $(menuTables).size(); i++){
            var linkMenu = new Object();
            linkMenu.id = $(menuTables[i]).find("#linkMenuId").val();
            linkMenu.mname = $(menuTables[i]).find("#mname").val();
            linkMenu.targetUrl = $(menuTables[i]).find("#menuTargetUrl").val();
            linkMenu.contentForCheck = $(menuTables[i]).find("#contentForCheck").val();
            linkMenu.sort = orderNum++;
            linkMenu.linkSystemId = linkSystem.id;
            linkMenu.roleId = $(menuTables[i]).find("#linkMenuRoleId").val();
            linkMenu.openType = $(menuTables[i]).find("#menuOpenType1").attr("checked") == "checked"? 1 : 2;
            linkMenu.parentId = topMenuId;
            linkMenu.linkMenuAcls = new Array();
            var linkMenuAclStr = $(menuTables[i]).find("#linkMenuAcl").val();
            var sort = 0;
            if(linkMenuAclStr != ""){
              var linkMenuAclArray = linkMenuAclStr.split(",");
              for(var k = 0; k < linkMenuAclArray.length; k++){
                var linkMenuAcl = new Object();
                linkMenuAcl.id = getUUID();
                linkMenuAcl.userType = linkMenuAclArray[k].split("|")[0];
                linkMenuAcl.userId = linkMenuAclArray[k].split("|")[1];
                linkMenuAcl.linkMenuId = linkMenu.id;
                linkMenu.linkMenuAcls.push(linkMenuAcl);
              }
            }
            linkSystem.linkMenus.push(linkMenu);
          }
        }
      }
      //增加遮罩
      try{if(getCtpTop() && getCtpTop().startProc){getCtpTop().startProc()}}catch(e){};
      new linkSystemManager().saveLinkSystem(linkSystem, {
        success : function(data) {
          //去掉遮罩
          try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
          $("#grid_detail").hide();
          mytable.grid.resizeGridUpDown('down');
          if(currentCategoryId != null){
	        var params = new Object();
	        params.categoryId = currentCategoryId;
	        if(!isSystemAdmin){
	          params.includeKnowledge = true;
	        }
	        $("#mytable").ajaxgridLoad(params);
          }
        } 
      });
  	}
  });  
  
  //默认选中(树)
  $("#tree").treeObj().cancelSelectedNode($("#tree").treeObj().getNodes()[0]);
  $("#tree").treeObj().selectNode($("#tree").treeObj().getNodes()[0].children[0]);
  $("#linkOptionValue_div").hide();
  $("#linkSystem_div").show();  
  $("#grid_detail").hide();
  $("#manual").show();
  $("#count").html(msg.format(mytable.p.total));
});

//刷新
function refreshPage(){
  $("#grid_detail").hide();
  mytable.grid.resizeGridUpDown('down');
}

function linkUrlOnBlurHandler(){
	if(currentCategoryId == 1){
  	  	var linkURL = $("#url").val();
  	  	$("table[sectionTable][sample='false']").find("#targetUrl").val(linkURL);
  	}
}

function getUUID(){
  var retValue = new linkSystemManager().getUUID().replace("L", "");
  return retValue;
}

function selectPeople(obj){
  var objValue = $(obj).next().val();
  var objTxt = $(obj).html();
  var panels = 'Account,Department,Team,Outworker';
  var selectType = 'Account,Department,Team,Outworker,Member';
  var thisAccount = false;
  var showMe = true;
  if(!isSystemAdmin){
    panels = 'Department,Team,Outworker';
    selectType = 'Account,Department,Team,Outworker,Member';
    thisAccount = true;
    showMe = false;
  }
  $.selectPeople({
    mode:'open',
    minSize:0,
    panels:panels,
    selectType:selectType,
    showFlowTypeRadio: false,
    showMe: showMe,
    onlyLoginAccount : thisAccount,
    params : {
      text : objTxt,
      value : objValue
    },
    callback : function(ret) {
      $(obj).next().val(ret.value);
      $(obj).val(ret.text);
    }
  });
}

function checkURL(obj){
  if($(obj).attr("id") == "agentUrl" && $.trim($(obj).val()) == ""){
    return true;
  } else {
    var url = $(obj).val().toUpperCase();
    if(url.length<10){
        return false;
    }else if(url.length>500){
        return false
    }else if(url.length >= 10 && (url.indexOf("HTTP://") !=-1 || url.indexOf("HTTPS://") !=-1 || url.indexOf("FTP://")!=-1)){
        return true;
    }else{
        return false;
    } 
  }		
}

function needContentCheckOnClickHandler() {
  var bool = $("#needContentCheck1").attr("checked");
  if (currentCategoryId != 1 && bool == "checked") {
    $("#contentForCheck").parent().parent().parent().show();
    $("#sameRegion1").parent().parent().parent().parent().show();
    var b2 = $("#sameRegion1").attr("checked");
    if (currentCategoryId != 1 && b2 == "checked") {
      $("#agentUrl").parent().parent().parent().hide();
    } else {
      $("#agentUrl").parent().parent().parent().show();
    }
  } else {
    $("#contentForCheck").parent().parent().parent().hide();
    $("#sameRegion1").parent().parent().parent().parent().hide();
    $("#agentUrl").parent().parent().parent().hide();
  }
}

function allowedMainMenu(){
  var checkbox = $("#settingMenu").attr("checked");
  if(checkbox=="checked"){
    $("#menuArea").show();
    $("#allowedAsMenu").attr("checked",false);
    $("table[menuTable][sample='false']").hide();
    if(currentCategoryId != 1){
      if(currentCategoryId == 4 || !isSystemAdmin){
        $("#mainMenuOpenType1").parents("tr").hide();
      } else {
        $("#mainMenuOpenType1").parents("tr").show();
      }
    } else {
      $("#mainMenuOpenType1").parents("tr").hide();
    }
  }else{
    $("#menuArea").hide();
    $("#mainMenuOpenType1").parents("tr").hide();
  }
}

function sameRegionOnClickHandler() {
  var bool = $("#sameRegion1").attr("checked");
  if (currentCategoryId != 1 && bool != "checked") {
    $("#agentUrl").parent().parent().parent().show();
  } else {
    $("#agentUrl").parent().parent().parent().hide();
  }
}

function advanceOnclickHandler(){
  var bool = (!$("#optionMethod1").parent().parent().parent().parent().is(":visible"));
  if(bool){
    $("#optionMethod1").parent().parent().parent().parent().show();
    $("#charsetType").parents("tr").show();
    $("#addOptionButton").parent().parent().show();
    $("#optionTable").show();
  } else {
    $("#optionMethod1").parent().parent().parent().parent().hide();
    $("#charsetType").parents("tr").hide();
    $("#addOptionButton").parent().parent().hide();
    $("#optionTable").hide();
  }
}

function uploadCallBack(attachment){
  $("#image").attr("src", "${path}/fileUpload.do?method=showRTE&fileId=" + attachment.instance[0].fileUrl + "&type=image");
}

function resetToDefaultPic(){
  $("#image").attr("src", "${path}/decorations/css/images/portal/defaultLinkSystemImage.png");
}

function addOptionClickHandler(option){
  var optionId = option != null? option.id : getUUID();
  var paramName = option != null? option.paramName : "";
  var paramSign = option != null? option.paramSign : "";
  var paramValue = '';
  if(option!=null){
	if(option.paramValue==null||option.paramValue==''){
		paramValue="";
	}else{
		paramValue=option.paramValue;
	}
  }
  var checked = "";
  var type = "text";
  if(option != null && option.password){
    checked = "checked";
    type = "password";
  } 
  var html = "<tr>";
  html += "<td><input paramId='' type='checkbox' value='" + optionId + "' /></td>";
  html += "<td width='135'><div class='common_txtbox_wrap'><input paramName='' id='paramName" + optionId + "' type='text' value='" + paramName + "' class='validate paramName' validate=\"name:'参数名称',notNull:true,maxLength:128\" /></div></td>";
  html += "<td width='135'><div class='common_txtbox_wrap'><input  paramSign='' id='paramSign" + optionId + "' type='text' value='" + paramSign + "' class='validate paramSign' validate=\"name:'参数标记',notNull:true,maxLength:128\" /></div></td>";
  html += "<td><div class='common_txtbox_wrap'><input  paramValue='' id='paramValue" + optionId + "' type='"+type+"' value='" + paramValue + "' class='validate paramValue' validate=\"name:'参数默认值',maxLength:1000\" /></div></td>";
  html += "<td style='width: 35px' align='center'><input type='checkbox' isPassword='' id='isPassword"+optionId+"' onclick='passwordClickHandler(\""+optionId+"\")' "+checked+"></td>";
  html += "</tr>";
  $($("#optionTable tbody")).append(html);
  $("#optionTable").find("tr").attr("height","25px");
}

function passwordClickHandler(uuid){
  var checked = $("#isPassword" + uuid).attr("checked");
  var paramValue = $("#paramValue" + uuid).val();
  if(checked == "checked"){
    $("#paramValue" + uuid).replaceWith("<input paramValue='' id='paramValue" + uuid + "' type='password' class='validate paramValue' validate=\"name:'参数默认值',maxLength:1000\" />");
  } else {
    $("#paramValue" + uuid).replaceWith("<input paramValue='' id='paramValue" + uuid + "' type='text' class='validate paramValue' validate=\"name:'参数默认值',maxLength:1000\" />");
  }
  $("#paramValue" + uuid).val(paramValue);
}

function delOptionClickHandler(){
  var checkedList = $("#optionTable").find("tbody").find("tr").find("td:first").find("input:checked");
  if($(checkedList).size() > 0){
    $(checkedList).parent().parent().remove();
  }else{
    $.alert("${ctp:i18n('link.jsp.del.param')}");
  }
}

function checkOptionDuplicateRepeat(){
    var paramName=$("input[paramName]");
	var paramSign=$("input[paramSign]");
	var paramValue=$("input[paramValue]");
    var info = $(".checkNull");
	var bool=true;
	for(var i=0;i<paramName.length;i++){
		var vi=$(paramName[i]).val();
		for(var j=i+1;j<paramName.length;j++){
			var vj=$(paramName[j]).val();
			if(vi==vj){
				bool=false;
			}
		}
	}
	for(var i=0;i<paramSign.length;i++){
		var vi=$(paramSign[i]).val();
		for(var j=i+1;j<paramSign.length;j++){
			var vj=$(paramSign[j]).val();
			if(vi==vj){
				bool=false;
			}
		}
	}
	return bool;
}
function optionTableCheckAllClickHandler(){
  var checked = $("#optionTableCheckAll").attr("checked");
  if(checked == "checked"){
    $("#optionTable").find("tbody").find("tr").find("td:first").find("input").attr("checked", true);
  } else {
    $("#optionTable").find("tbody").find("tr").find("td:first").find("input").attr("checked", false);
  }
}

function addOrDelExtention(addOrDel, objButton){
  var objTable = $(objButton).parent().parent().parent().parent();
  var attr = $(objTable).attr("name");
  if(addOrDel == "add"){
    if(attr == "spaceTable"){
      var cloneTable = customClone($(objTable), "spaceTable");
      $(objTable).after(cloneTable);
      var uuid = getUUID();
      cloneTable.find("#linkSpaceId").val(uuid);
      var clonedChecked = cloneTable.find(":radio:first").attr("checked");
      if(clonedChecked == "checked"){
        cloneTable.find(":radio:first").replaceWith("<input type='radio' value='1' id='openType1' name='openType" + uuid + "' class='radio_com' checked='checked' />");
        cloneTable.find(":radio:last").replaceWith("<input type='radio' value='2' id='openType2' name='openType" + uuid + "' class='radio_com' />");
        $(objTable).find(":radio:first").attr("checked", true);
      } else {
        cloneTable.find(":radio:first").replaceWith("<input type='radio' value='1' id='openType1' name='openType" + uuid + "' class='radio_com' />");
        cloneTable.find(":radio:last").replaceWith("<input type='radio' value='2' id='openType2' name='openType" + uuid + "' class='radio_com' checked='checked' />");
        $(objTable).find(":radio:last").attr("checked", true);
      }
      cloneTable.show();
    } 
    if(attr == "sectionTable") {
      var cloneTable = customClone($(objTable), "sectionTable");
      $(objTable).after(cloneTable);
      $(cloneTable).find("#linkSectionId").val(getUUID());
      cloneTable.show();
    }
    if(attr == "menuTable") {
      var cloneTable = customClone($(objTable), "menuTable");
      $(objTable).after(cloneTable);
      $(cloneTable).find("#linkMenuId").val(getUUID());
      $(cloneTable).find("#linkMenuRoleId").val(getUUID());
      var uuid = getUUID();
      var clonedChecked = cloneTable.find(":radio:first").attr("checked");
      if(clonedChecked == "checked"){
        cloneTable.find(":radio:first").replaceWith("<input type='radio' value='1' id='menuOpenType1' name='menuOpenType" + uuid + "' class='radio_com' checked='checked' />");
        cloneTable.find(":radio:last").replaceWith("<input type='radio' value='2' id='menuOpenType2' name='menuOpenType" + uuid + "' class='radio_com' />");
        $(objTable).find(":radio:first").attr("checked", true);
      } else {
        cloneTable.find(":radio:first").replaceWith("<input type='radio' value='1' id='menuOpenType1' name='menuOpenType" + uuid + "' class='radio_com' />");
        cloneTable.find(":radio:last").replaceWith("<input type='radio' value='2' id='menuOpenType2' name='menuOpenType" + uuid + "' class='radio_com' checked='checked' />");
        $(objTable).find(":radio:last").attr("checked", true);
      }
      cloneTable.show();
    }
  } else {
    var size = 0;
    if(attr == "spaceTable"){
      size = $("table[spaceTable][sample='false']").size();
    } 
    if(attr == "sectionTable") {
      size = $("table[sectionTable][sample='false']").size();
    }
    if(attr == "menuTable") {
      size = $("table[menuTable][sample='false']").size();
    }
    if(size > 1){
      $(objTable).remove();
    }
  }
}

function allowedAsSpaceClickHandler(){
  var checked = $("#allowedAsSpace").attr("checked");
  var size = $("table[spaceTable][sample='false']").size();
  var linkURL = $("#url").val();
  $("table[spaceTable][sample='false']").find("#targetPageUrl").val(linkURL);
  if(size == 0){
    var spaceTableClone = customClone($("table[spaceTable][sample='true']"), "spaceTable");
    spaceTableClone.attr("sample", "false");
    var uuid = getUUID();
    spaceTableClone.find("#linkSpaceId").val(uuid);
    spaceTableClone.find("input[name='openType']").attr("name", "openType" + uuid);
    $("#spaceArea").append(spaceTableClone);
  }
  if(currentCategoryId == 1){
  	var lname = $("#lname").val();
    $("table[spaceTable][sample='false']").find("#spaceName").val(lname);
    $("table[spaceTable][sample='false']").find("#contentForCheck").parent().parent().parent().hide();
    $("table[spaceTable][sample='false']").find("tr[category1]").hide();
  } else {
    $("table[spaceTable][sample='false']").find("#contentForCheck").parent().parent().parent().show();
    $("table[spaceTable][sample='false']").find("tr[category1]").show();
  }
  if(checked == "checked"){
    $("table[spaceTable][sample='false']").show();
  } else {
    $("table[spaceTable][sample='false']").hide();
  }
}

function allowedAsMenuClickHandler(){
  var checked = $("#allowedAsMenu").attr("checked");
  var size = $("table[menuTable][sample='false']").size();
  var linkURL = $("#url").val();
  $("table[menuTable][sample='false']").find("#menuTargetUrl").val(linkURL);
  if(size == 0){
    var menuTableClone = customClone($("table[menuTable][sample='true']"), "menuTable");
    $(menuTableClone).attr("sample", "false");
    $(menuTableClone).find("#linkMenuId").val(getUUID());
    $(menuTableClone).find("#linkMenuRoleId").val(getUUID());
    $("#menuArea").append(menuTableClone);
  }
  if(checked == "checked"){
	if(size==2){
	    $("table[menuTable][sample='false']").eq(1).remove();
	}
    $("table[menuTable][sample='false']").show();
  } else {
    $("table[menuTable][sample='false']").hide();
  }
}

function allowedAsSectionClickHandler(){
  var checked = $("#allowedAsSection").attr("checked");
  var size = $("table[sectionTable][sample='false']").size();
  var linkURL = $("#url").val();
  $("table[sectionTable][sample='false']").find("#targetUrl").val(linkURL);
  if(size == 0){
    var sectionTableClone = customClone($("table[sectionTable][sample='true']"), "sectionTable");
    $(sectionTableClone).attr("sample", "false");
    $(sectionTableClone).find("#linkSectionId").val(getUUID());
    $("#sectionArea").append(sectionTableClone);
  }
  if(currentCategoryId == 1){
  	var lname = $("#lname").val();
  	$("table[sectionTable][sample='false']").find("#sname").val(lname);
  	$("table[sectionTable][sample='false']").find("select option[value='0']").remove();
  	$("table[sectionTable][sample='false']").find("select option[value='1']").remove();
  	$("table[sectionTable][sample='false']").find("tr[category1]").hide();
  	$("#advanceButton").parents("tr").hide();
  	$("#linkTab_head li:eq(1)").hide();
    $("#linkTab_head li:eq(0) a").addClass("last_tab");
    $("table[sectionTable][sample='false']").find("#contentForCheck").parent().parent().parent().hide();
  } else {
    $("table[sectionTable][sample='false']").find("select option[value='2']").remove();
    $("table[sectionTable][sample='false']").find("tr[category1]").show();
    $("#advanceButton").parents("tr").show();
    $("#linkTab_head li:eq(1)").show();
    $("#linkTab_head li:eq(0) a").removeClass("last_tab");
    $("table[sectionTable][sample='false']").find("#contentForCheck").parent().parent().parent().show();
  }
  if(checked == "checked"){
    $("table[sectionTable][sample='false']").show();
  } else {
    $("table[sectionTable][sample='false']").hide();
  }
}

function sectionTypeOnChangeHandler(objSelect){
  var selectedValue = $(objSelect).val();
  var objTable = $(objSelect).parent().parent().parent();
  if(selectedValue == "0"){
    $(objTable).find("#timeout").parent().parent().parent().show();
  } else {
    $(objTable).find("#timeout").parent().parent().parent().hide();
  }
}

function checkSameLinkSection(obj){
	var sectionNames = $("table[sectionTable][sample='false']").find("#sname:visible");
	var sectionTypes = $("table[sectionTable][sample='false']").find("#sectionType:visible");
	var objTable = $(obj).parent().parent().parent().parent();
	var linkSectionId = $(objTable).find("#linkSectionId").val();	
	var sectionType = $(objTable).find("#sectionType").val();	
	var sectionOptionText = $(objTable).find("option:selected").text();
	var sectionName = $(obj).val();
	for(var i = 0; i < sectionNames.length; i++){
		if(obj[0] == sectionNames[i]){
		    return true;
		} else if(sectionName == $(sectionNames[i]).val() && sectionType == $(sectionTypes[i]).val()){
			$.alert("${ctp:i18n('link.jsp.hasExit.name')}" + sectionName + "${ctp:i18n('link.jsp.de')}" + sectionOptionText + "${ctp:i18n('link.jsp.set.name')}");
			$(obj).focus();
			return false;
		}
	}  	
	var bool = new linkSectionManager().checkSameLinkSection(linkSectionId, sectionName, sectionType);
	if(bool){
		$.alert("${ctp:i18n('link.jsp.hasExit.name')}" + sectionName + "${ctp:i18n('link.jsp.de')}" + sectionOptionText + "${ctp:i18n('link.jsp.set.name')}");
		$(obj).focus();
		return false;
	} else {
	  return true;
	}
}

function checkSameLinkMenu(obj){
  return true;
}

function linkOptionValueManage(){
  if(currentInstructionsDialog){
    currentInstructionsDialog.close();
    currentInstructionsDialog = null;
  }
  $("#linkSystem_div").hide();
  $("#optionTab").addClass("current");
  $("#showLinkTab").removeClass("current");
  $("#optionTab_a").addClass("border_b");
  $("#linkOptionValueFrame").attr("src", "${path}/portal/linkSystemController.do?method=linkOptionValueMain&linkSystemId=" + currentLinkSystemId);
  $("#linkOptionValue_div").show();
}

function showLinkTab(){
  $("#linkOptionValue_div").hide();
  $("#optionTab").removeClass("current");
  $("#linkSystem_div").show();
  $("#showLinkTab").addClass("current");
}

//自定义克隆方法，jquery的clone方法在IE7下有问题
function customClone(jqueryObj, type){
  var clonedObj = jqueryObj.clone(true);
  var clonedObjHtml = clonedObj.html();
  var newObj = null;
  if(type == "menuTable"){
    newObj = $("<table menuTable=\"true\" sample=\"false\" name=\"menuTable\" cellspacing=\"0\" cellpadding=\"0\" class=\"border_b padding_t_10\" style=\"width: 550px; display: none\">" + clonedObjHtml + "</table>");
    newObj.find("#menuOpenType2").attr("checked", true);
  } else if(type == "spaceTable"){
    newObj = $("<table spaceTable=\"true\" sample=\"false\" name=\"spaceTable\" cellspacing=\"0\" cellpadding=\"0\" class=\"border_b padding_t_10\" style=\"width: 550px; display: none\">" + clonedObjHtml + "</table>");
    newObj.find("#openType1").attr("checked", true);
  } else if(type == "sectionTable"){
    newObj = $("<table sectionTable=\"true\" sample=\"false\" name=\"sectionTable\" cellspacing=\"0\" cellpadding=\"0\" class=\"border_b padding_t_10\" style=\"width: 550px; display: none\">" + clonedObjHtml + "</table>");
    newObj.find("#sectionType").val("0");
  }
  return newObj;
}

function hideInstruction(){
  if(currentInstructionsDialog){
    currentInstructionsDialog.close();
  }
}

function addCategoryNameKeyup(){
  var e = event || window.event;
  var keyCode = e.keyCode || e.which;
  if(keyCode == 13){
    addCategoryDialog.buttons[0].handler();
  }
}

function updateCategoryNameKeyup(){
  var e = event || window.event;
  var keyCode = e.keyCode || e.which;
  if(keyCode == 13){
    updateCategoryDialog.buttons[0].handler();
  }
}
</script>
<style>
.form_area table.only_table th{line-height:16px; text-align:left;}
</style>
</head>
<body>
    <div class="comp" comp="type:'breadcrumb',code:'T03_linkSystemManage'"></div>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" id="north" layout="height:30,sprit:false,border:false">
        	<div id="toolbar"></div>
        </div>
        <div class="layout_west" id="west" layout="width:200">
            <div id="tree"></div>
        </div>
        <div class="layout_center over_hidden" id="center" layout="border:true" style="border-top:0; border-bottom:0;">
            <table id="mytable" class="flexme3" style="display: none;*margin-left:-5px;"></table>            
			<div id="grid_detail" class="comp" comp="type:'tab',width:'w100b'">
				<div id="linkTab_head" class="common_tabs clearfix">
					<ul class="left">
						<li id="showLinkTab" class="current"><a class="border_b" id="showLinkTab_a" href="javascript:showLinkTab()" tgt="linkSystem_div"><span id="linkSystem_tab">${ctp:i18n('link.jsp.add.label.show')}</span></a></li>
						<li id="optionTab"><a id="optionTab_a" class="last_tab" href="javascript:linkOptionValueManage()" tgt="linkOptionValue_div"><span>${ctp:i18n('link.jsp.param.manage')}</span></a></li>
					</ul>
				</div>
				<div id='linkTab_body' class="common_tabs_body">
					<div id="linkSystem_div" style="overflow-y:scroll">
						<div class="form_area" id="form_area" style="width:565px; margin:0 auto;">
			            	<input type="hidden" id="linkSystemId" value="0"/>
			                <fieldset id="base" class="margin_t_10">
			                <legend><b>${ctp:i18n('link.jsp.base.def')}</b>&nbsp;<a id="operationInstruction" href="#" tooltip="tooltip">${ctp:i18n('link.jsp.oper.explain')}</a></legend>
			                    <div id="divBaseDifinition" class="hidden" onclick="hideInstruction()">
				       			    <ul>
					        		${ctp:i18n('link.jsp.baseDifinition.instruction') }
					        		</ul>
				      			</div>
			                    <table border="0" cellspacing="0" cellpadding="0" style="width: 550px">
			                        <tr>
			                            <th><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n('link.jsp.menu.name')}:</label></th>
			                            <td id='name_td'>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>URL:</label></th>
			                            <td id='url_td'>
			                            </td>
			                        </tr>
			                        <!-- 
			                        <tr>
			                            <th><label class="margin_r_10 hand" for="text">${ctp:i18n('link.jsp.isNeedContentCheck.label')}:</label></th>
			                            <td>
			                            	<div class="common_radio_box">
                                                <label for="needContentCheck1" class="margin_r_10 hand"><input type="radio" value="1" id="needContentCheck1" name="needContentCheck" class="radio_com" onclick="needContentCheckOnClickHandler();" />${ctp:i18n('common.yes')}</label>
                                                <label for="needContentCheck2" class="hand"><input type="radio" value="0" id="needContentCheck2" name="needContentCheck" class="radio_com" checked="checked" onclick="needContentCheckOnClickHandler();" />${ctp:i18n('common.no')}</label>
                                            </div>
			                            </td>
			                        </tr>
			                        <tr class="hidden">
			                            <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.check.content')}:</label></th>
			                            <td>
			                            	<div class="common_txtbox_wrap">
			                            		<input type="text" id="contentForCheck" class="validate" 
			                            		validate="type:'string',name:'${ctp:i18n('link.jsp.isNeedContentCheck.label')}',notNull:true,minLength:1,maxLength:500" />
			                            	</div>
			                            </td>
			                        </tr>
			                        <tr class="hidden">
			                            <th><label class="margin_r_10 hand" for="text">${ctp:i18n('link.jsp.isSameRegion.label')}:</label></th>
			                            <td>
			                            	<div class="common_radio_box">
                                                <label for="sameRegion1" class="margin_r_10 hand"><input type="radio" value="1" id="sameRegion1" name="sameRegion" class="radio_com" onclick="sameRegionOnClickHandler();" />${ctp:i18n('common.yes')}</label>
                                                <label for="sameRegion2" class="hand"><input type="radio" value="0" id="sameRegion2" name="sameRegion" class="radio_com" checked="checked" onclick="sameRegionOnClickHandler();" />${ctp:i18n('common.no')}</label>
                                            </div>
			                            </td>
			                        </tr>
                                    -->
			                        <tr>
			                            <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.agentUrl.label')}:</label></th>
			                            <td>
			                            	<div class="common_txtbox_wrap">
			                            		<input id="agentUrl" class="validate" name="urlInput"
			                                        validate="type:'string',name:'${ctp:i18n('link.jsp.agentUrl.label')}',func:checkURL,minLength:10,maxLength:500" />
			                            	</div>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n('link.jsp.add.order')}:</label></th>
			                            <td id='sort_td'>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th><label class="margin_r_10" for="textarea">${ctp:i18n('link.jsp.add.desc')}:</label></th>
			                            <td>
			                            	<div class="common_txtbox">
			                            		<textarea id="description" class="w100b validate"
			                                        validate="type:'string',name:'${ctp:i18n('link.jsp.add.desc')}',minLength:1,maxLength:85" ></textarea>
			                            	</div>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.add.img')}:</label></th>
			                            <td>
			                            	<input id="uploadPic" type="hidden" class="comp" comp="type:'fileupload',quantity:1,applicationCategory:'1',canDeleteOriginalAtts:true,originalAttsNeedClone:false,extensions:'jpg,jpeg,gif,bmp,png',firstSave:true " />
			                            	<img id="image" style="width:32px; height:32px" src="${path}/decorations/css/images/portal/defaultLinkSystemImage.png" />&nbsp;<a onClick="javascript:insertAttachment('uploadCallBack');">[${ctp:i18n('link.jsp.add.img.upload')}]</a>&nbsp;<a onClick="javascript:resetToDefaultPic();">[${ctp:i18n('link.jsp.add.img.delete')}]</a>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.accredit.to')}:</label></th>
			                            <td>
			                            	<div class="common_txtbox">
			                            		<textarea id="linkSystemAcl_txt" class="w100b" rows="3" readonly="readonly" onclick="selectPeople(this)" ></textarea>
			                            		<input type="hidden" id="linkSystemAcl" name="aclInput"/>
			                            	</div>
			                            </td>
			                        </tr>
                                    <tr>
                                        <th><label class="margin_r_10 hand" for="text">${ctp:i18n('link.jsp.isUsed')}:</label></th>
                                        <td>
                                            <div class="common_checkbox_box">
                                                <input type="checkbox" id="enabled" class="radio_com" checked="true"/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr category1>
                                        <th><label class="margin_r_10 hand" for="text">${ctp:i18n('link.jsp.isAllowed.configuration.homePage')}:</label></th>
                                        <td>
                                            <div class="common_checkbox_box">
                                                <input type="checkbox" id="settingMenu" class="radio_com" onclick="allowedMainMenu()"/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr class="hidden">
                                        <th></th>
                                        <td>
                                            <input type="hidden" id="linkMainMenuId" value="0"/>
                                        </td>
                                    </tr>
                                    <tr class="hidden">
                                        <th></th>
                                        <td>
                                            <input type="hidden" id="linkMainMenuRole" value="0"/>
                                        </td>
                                    </tr>
                                    <!-- 
                                    <tr>
                                        <th><label class="margin_r_10" for="text">${ctp:i18n("link.jsp.opentype")}:</label></th>
                                        <td>
                                            <div class="common_radio_box">
                                                <label for="radio1" class="margin_r_10 hand"><input type="radio" value="1" id="mainMenuOpenType1" name="mainMenuOpenType" class="radio_com"/>${ctp:i18n('link.jsp.opentype.newwindow')}</label>
                                                <label for="radio2" class="hand"><input type="radio" value="2" id="mainMenuOpenType2" name="mainMenuOpenType" class="radio_com" checked="checked"/>${ctp:i18n('link.jsp.opentype.workspace')}</label>
                                            </div>
                                        </td>
                                    </tr>
                                    -->
			                        <tr>
			                            <th></th>
			                            <td align="right">
			                            	<input id="advanceButton" type="button" value="${ctp:i18n('link.jsp.high.level')}" onclick="advanceOnclickHandler()"/>
			                            </td>
			                        </tr>
                                    <tr class="hidden">
                                        <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.edcoding.type')}:</label></th>
                                        <td>
                                            <div class="common_radio_box">
                                                <select id="charsetType" name = "charsetType" class="common_drop_down" style="width: 100%; height: 24px">
                                                    <option value="UTF-8" selected="selected">UTF-8</option>
                                                    <option value="GBK">GBK</option>
                                                    <option value="ISO-8859-1">ISO-8859-1</option>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
			                        <tr class="hidden">
			                            <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.paramTran.type')}:</label></th>
			                            <td>
			                            	<div class="common_radio_box">
											    <label for="radio1" class="margin_r_10 hand"><input type="radio" value="get" id="optionMethod1" name="optionMethod" class="radio_com" checked="checked"/>GET</label>
											    <label for="radio2" class="hand"><input type="radio" value="post" id="optionMethod2" name="optionMethod" class="radio_com" />POST</label>
                                            </div>
			                            </td>
			                        </tr>
			                        <tr class="hidden">
			                            <th></th>
			                            <td align="right">
			                            	<input type="button" id="addOptionButton" value="${ctp:i18n('link.jsp.add')}" onclick="addOptionClickHandler()"/>&nbsp;&nbsp;<input type="button" id="delOptionButton" value="${ctp:i18n('link.jsp.del')}" onclick="delOptionClickHandler()"/>
			                            </td>
			                        </tr>
			                        
			                    </table>
			                    <table id="optionTable" class="only_table hidden" style="margin-left: 40px; margin-top:5px; width: 510px" border="0" cellSpacing="0" cellPadding="0">
									<thead>
									    <tr>
									        <th><input id="optionTableCheckAll" type="checkbox" onclick="optionTableCheckAllClickHandler();" /></th>
									        <th>${ctp:i18n('link.jsp.add.param.name')}</th>
									        <th>${ctp:i18n('link.jsp.add.param.sign')}</th>
									        <th>${ctp:i18n('link.jsp.add.param.default')}</th>
									        <th style="width: 35px" align="center">${ctp:i18n('link.jsp.add.param.password')}</th>
									    </tr>
									</thead>
									<tbody>
									<!-- 
									    <tr>
									        <td><input type="checkbox" /></td>
									        <td><input type="text" /></td>
									        <td><input type="text" /></td>
									        <td><input type="text" /></td>
									        <td><input type="checkbox" /></td>
									    </tr>
									 -->
									</tbody>
								</table>
			                </fieldset>
                            <fieldset id="menuArea" class="margin_t_10">
                                <legend><b>${ctp:i18n('link.jsp.menu.show')}</b>&nbsp;<a id="menuAuthInstruction" href="#" tooltip="tooltip">[${ctp:i18n('link.jsp.accredit.explain')}]</a></legend>
                                <div id="divMenuAuth" class="hidden" onclick="hideInstruction()">
								<ul>
								${ctp:i18n('link.jsp.space.personal.description') }
								</ul>
								</div>
                                <table border="0" cellspacing="0" cellpadding="0" style="width: 550px">
                                    <tr>
                                        <td align="center" colspan="2">
                                            <div class="common_checkbox_box">
                                                <input type="checkbox" id="allowedAsMenu" class="radio_com" onclick="allowedAsMenuClickHandler();" />${ctp:i18n('link.allowed.to.twoMenu')}
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <table menuTable="true" sample="true" name="menuTable" cellspacing="0" cellpadding="0" class="border_b padding_t_10" style="width: 550px; display: none">
                                    <tbody>
                                        <tr class="hidden">
                                            <th></th>
                                            <td>
                                                <input type="hidden" id="linkMenuId" value="0"/>
                                            </td>
                                        </tr>
                                        <tr class="hidden">
                                            <th></th>
                                            <td>
                                                <input type="hidden" id="linkMenuRoleId" value="0"/>
                                            </td>
                                        </tr>
                                        <tr category1>
                                            <th><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n('link.jsp.menuName')}:</label></th>
                                            <td>
                                                <div class="common_txtbox_wrap">
                                                    <input type="text" id="mname" class="validate" name="nameInput"
                                                        validate="type:'string',name:'${ctp:i18n('link.jsp.menuName')}',func:checkSameLinkMenu,notNull:true,minLength:1,maxLength:20" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr category1>
                                            <th><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n('link.jsp.targetPageUrl.label')}:</label></th>
                                            <td>
                                                <div class="common_txtbox_wrap">
                                                    <input type="text" id="menuTargetUrl" class="validate" name="urlInput"
                                                        validate="type:'string',name:'${ctp:i18n('link.jsp.targetPageUrl.label')}',func:checkURL,minLength:10,maxLength:500" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
	                                        <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.check.content')}:</label></th>
	                                        <td>
	                                            <div class="common_txtbox_wrap">
	                                                <input type="text" id="contentForCheck" class="validate" 
	                                                validate="type:'string',name:'${ctp:i18n('link.jsp.isNeedContentCheck.label')}',notNull:false,minLength:1,maxLength:500" />
	                                            </div>
	                                        </td>
	                                    </tr>
                                        <tr>
                                            <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.opentype')}:</label></th>
                                            <td>
                                                <div class="common_radio_box">
                                                    <label for="radio1" class="margin_r_10 hand"><input type="radio" value="1" id="menuOpenType1" name="menuOpenType" class="radio_com"/>${ctp:i18n('link.jsp.opentype.newwindow')}</label>
                                                    <label for="radio2" class="hand"><input type="radio" value="2" id="menuOpenType2" name="menuOpenType" class="radio_com" checked="checked"/>${ctp:i18n('link.jsp.opentype.workspace')}</label>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr category1>
                                            <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.accredit.to')}:</label></th>
                                            <td>
                                                <div class="common_txtbox">
                                                    <textarea type="text" id="linkMenuAcl_txt" class="w100b" rows="3" readonly="readonly" onclick="selectPeople(this)" ></textarea>
                                                    <input type="hidden" id="linkMenuAcl" name="aclInput"/>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr category1>
                                            <td colspan="2">
                                                <span class="ico16 table_add_16 add" onclick="addOrDelExtention('add', this)"></span>
                                            </td>
                                        </tr>
                                        <tr category1>
                                            <td colspan="2">
                                                <span class="ico16 table_delete_16 remove" onclick="addOrDelExtention('del', this)"></span>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </fieldset>
                            <fieldset id="spaceArea" class="margin_t_10">
                                <legend><b>${ctp:i18n('link.jsp.space.show')}</b>&nbsp;<a id="spaceAuthInstruction" href="#" tooltip="tooltip">[${ctp:i18n('link.jsp.accredit.explain')}]</a></legend>
                                <div id="divSpaceAuth" class="hidden" onclick="hideInstruction()">
								<ul>
								${ctp:i18n('link.jsp.space.auth.description') }
								</ul>
								</div>	
                                <table border="0" cellspacing="0" cellpadding="0" style="width: 550px">
                                    <tr>
                                        <td align="center" colspan="2">
                                            <div class="common_checkbox_box">
                                                <input type="checkbox" id="allowedAsSpace" class="radio_com" onclick="allowedAsSpaceClickHandler();" />${ctp:i18n('link.jsp.isallowed.configuredas.spacenavigation')}
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <table spaceTable="true" sample="true" name="spaceTable" cellspacing="0" cellpadding="0" class="border_b padding_t_10" style="width: 550px; display: none">
                                    <tr class="hidden">
                                        <th></th>
                                        <td>
                                            <input type="hidden" id="linkSpaceId" value="0"/>
                                        </td>
                                    </tr>
                                    <tr category1>
                                        <th><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n('link.jsp.spaceName.label')}:</label></th>
                                        <td>
                                            <div class="common_txtbox_wrap">
                                                <input type="text" id="spaceName" class="validate" name="nameInput"
                                                    validate="type:'string',name:'${ctp:i18n('link.jsp.spaceName.label')}',notNull:true,minLength:1,maxLength:120" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr category1>
                                        <th><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n('link.jsp.targetPageUrl.label')}:</label></th>
                                        <td>
                                            <div class="common_txtbox_wrap">
                                                <input type="text" id="targetPageUrl" class="validate" name="urlInput"
                                                    validate="type:'string',name:'${ctp:i18n('link.jsp.targetPageUrl.label')}',func:checkURL,minLength:10,maxLength:500" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.check.content')}:</label></th>
                                        <td>
                                            <div class="common_txtbox_wrap">
                                               <input type="text" id="contentForCheck" class="validate" 
                                               validate="type:'string',name:'${ctp:i18n('link.jsp.isNeedContentCheck.label')}',notNull:false,minLength:1,maxLength:500" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.opentype')}:</label></th>
                                        <td>
                                            <div class="common_radio_box">
                                                <label for="radio1" class="margin_r_10 hand"><input type="radio" value="1" id="openType1" name="openType" class="radio_com" checked="checked" />${ctp:i18n('link.jsp.opentype.newwindow')}</label>
                                                <label for="radio2" class="hand"><input type="radio" value="2" id="openType2" name="openType" class="radio_com" />${ctp:i18n('link.jsp.opentype.workspace')}</label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr category1>
                                        <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.accredit.to')}:</label></th>
                                        <td>
                                            <div class="common_txtbox">
                                                <textarea type="text" id="linkSpaceAcl_txt" class="w100b" rows="3" readonly="readonly" onclick="selectPeople(this)" ></textarea>
                                                <input type="hidden" id="linkSpaceAcl" name="aclInput"/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr category1>
                                        <td colspan="2">
                                            <span class="ico16 table_add_16 add" onclick="addOrDelExtention('add', this)"></span>
                                        </td>
                                    </tr>
                                    <tr category1>
                                        <td colspan="2">
                                            <span class="ico16 table_delete_16 remove" onclick="addOrDelExtention('del', this)"></span>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
			                <fieldset id="sectionArea" class="margin_t_10">
                               	<legend><b>${ctp:i18n('link.jsp.spaceSectionShow.label')}</b>&nbsp;<a id="sectionAuthInstruction" href="#" tooltip="tooltip">[${ctp:i18n('link.jsp.accredit.explain')}]</a></legend>
                                <div id="divSectionAuth" class="hidden" onclick="hideInstruction()">
									<ul>
										${ctp:i18n('link.jsp.section.auth.description') }
									</ul>
								</div>
                                <table border="0" cellspacing="0" cellpadding="0" style="width: 550px">
                                    <tr>
                                        <td align="center" colspan="2">
                                            <div class="common_checkbox_box">
                                                <input type="checkbox" id="allowedAsSection" class="radio_com" onclick="allowedAsSectionClickHandler();" />${ctp:i18n('link.jsp.isallowed.configuredas.section')}
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <table sectionTable="true" sample="true" name="sectionTable" cellspacing="0" cellpadding="0" class="border_b padding_t_10" style="width: 550px; display: none">
                                    <tbody>
                                        <tr class="hidden">
                                            <th></th>
                                            <td>
                                                <input type="hidden" id="linkSectionId" value="0"/>
                                            </td>
                                        </tr>
                                        <tr category1>
                                            <th><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n('link.jsp.sectionName.label')}:</label></th>
                                            <td>
                                                <div class="common_txtbox_wrap">
                                                    <input type="text" id="sname" class="validate" name="nameInput"
                                                        validate="type:'string',name:'${ctp:i18n('link.jsp.sectionName.label')}',func:checkSameLinkSection,notNull:true,minLength:1,maxLength:120" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.category')}:</label></th>
                                            <td>
                                                <select id="sectionType" class="common_drop_down" style="width: 400px; height: 24px" onchange="sectionTypeOnChangeHandler(this)" >
                                                    <option value="1" selected="selected">${ctp:i18n('link.jsp.fuc.Section')} (SSOIframeSection)</option>
                                                    <option value="0">${ctp:i18n('link.jsp.data.Section')} (SSOWebContentSection)</option>
                                                    <option value="2">${ctp:i18n('link.jsp.home.Section')} (IframeSection)</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr category1>
                                            <th><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n('link.jsp.targetPageUrl.label')}:</label></th>
                                            <td>
                                                <div class="common_txtbox_wrap">
                                                    <input type="text" id="targetUrl" class="validate" name="urlInput"
                                                        validate="type:'string',name:'${ctp:i18n('link.jsp.targetPageUrl.label')}',func:checkURL,minLength:10,maxLength:500" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
	                                        <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.check.content')}:</label></th>
	                                        <td>
	                                            <div class="common_txtbox_wrap">
	                                               <input type="text" id="contentForCheck" class="validate" 
	                                               validate="type:'string',name:'${ctp:i18n('link.jsp.isNeedContentCheck.label')}',notNull:false,minLength:1,maxLength:500" />
	                                            </div>
	                                        </td>
	                                    </tr>
                                        <tr category1 style="display: none">
                                            <th><label class="margin_r_10" for="text">Session${ctp:i18n('link.jsp.timeOut.label')}(${ctp:i18n('link.jsp.minutie.label')}):</label></th>
                                            <td>
                                                <div class="common_txtbox_wrap">
                                                    <input type="text" id="timeout" class="validate" value="30"
                                                        validate="name:'Session${ctp:i18n('link.jsp.timeOut.label')}',notNull:true,isInteger:true,min:-9999,max:9999" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.web.height')}:</label></th>
                                            <td>
                                                <div class="common_txtbox_wrap">
                                                    <input type="text" id="height" class="validate" value="200"
                                                        validate="name:'${ctp:i18n('link.jsp.web.height')}',notNull:true,isInteger:true,min:0,max:9999,errorMsg:'${ctp:i18n("link.jsp.height.prompt")}'" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr category1>
                                            <th><label class="margin_r_10" for="text">${ctp:i18n('link.jsp.accredit.to')}:</label></th>
                                            <td>
                                                <div class="common_txtbox">
                                                    <textarea type="text" id="linkSectionAcl_txt" class="w100b" rows="3" readonly="readonly" onclick="selectPeople(this)" ></textarea>
                                                    <input type="hidden" id="linkSectionAcl" name="aclInput"/>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr category1>
                                            <td colspan="2">
                                                <span class="ico16 table_add_16 add" onclick="addOrDelExtention('add', this)"></span>
                                            </td>
                                        </tr>
                                        <tr category1>
                                            <td colspan="2">
                                                <span class="ico16 table_delete_16 remove" onclick="addOrDelExtention('del', this)"></span>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </fieldset>
			                <div class="align_center hidden">
			                    <a href="javascript:void(0)" id="submitbtn" class="common_button common_button_gray">${ctp:i18n('common.button.ok.label')}</a>
			                    <a href="javascript:refreshPage()" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
			                </div>
			            </div>
					</div>
					<div id="linkOptionValue_div">
						<iframe id="linkOptionValueFrame" src="" style="width: 100%; height: 100%; border: none;" scrolling="no"></iframe>
					</div>
				</div>
			</div>
            <div id="manual" class="color_gray margin_l_20 display_none">
              <div class="clearfix">
				 <table>
				 	<tr>
				 		<td>
					 		<h2>
			                <c:choose>
			                <c:when test="${isSystemAdmin}">
			                	${ctp:i18n('link.system.management')}
			                </c:when>
			                <c:otherwise>
			                	${ctp:i18n('link.knowledge.setting')}<!-- 如果是个人知识中心 或关联系统-->
			                </c:otherwise>
			                </c:choose>
			                </h2>
		                </td>
		                <td>&nbsp;&nbsp;</td>
				 		<td>
				 			<span id="count"></span>
				 		</td>
				 	</tr>
				 </table>
              <div class="line_height160 font_size14">
                  <c:choose>
		                <c:when test="${isSystemAdmin}">
		                	${ctp:i18n('link.system.detailinfo')}
		                </c:when>
		                <c:otherwise>
		                	${ctp:i18n('link.system.linkSystem.detailInfo')}<!-- 如果是个人知识中心 或关联系统-->
		                </c:otherwise>
			      </c:choose>
              </div>
            </div>
        </div>
    </div>
    <div>
    </div>
</body>
</html>
