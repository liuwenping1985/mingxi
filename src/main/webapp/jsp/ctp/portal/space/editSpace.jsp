<%--
 $Author: sifr $
 $Rev: 11475 $
 $Date:: 2013-01-05 13:48:51#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>空间管理</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=spaceManager,spaceSecurityManager,pageManager"></script>
<style>
    .stadic_head_height{
        height:0px;
    }
    .stadic_body_top_bottom{
        bottom: 30px;
        top: 0px;
    }
    .stadic_footer_height{
        height:30px;
    }
</style>

<script>
  var isToDefault = false;
  $(document).ready(function() {
        $("input,textarea, a", $("#grid_detail")).attr("disabled", false);
        $("#editSpacePage").contents().find("input,textarea,a,div").attr("disabled", false);
        $("#pageName").attr("disabled",true);
        //隐藏空间关联的模板
        $("#pageNameTr").hide();
        $("#trCanshare").hide();
        $("#trCanmanage").hide();
        $("#trCanpush").hide();
        $("#trCanpersonal").hide();
        $("#id").val("${spaceAndPage.id}");
        //部门空间不允许更改空间名称
        var spaceType = "${spaceAndPage.type}";
        if(spaceType == "1"){
          $("#spacename").attr("disabled",true);
        }
        $("#pageName").val("${spaceAndPage.pageName}");
        $("#path").val("${spaceAndPage.path}");
        if($("#path").val().indexOf("/department/") != -1){
          $("#spaceDeptDes").show();
        }
        if("${spaceAndPage.canshare}" == 1){
          $("#trCanshare").show();
        }
        if("${spaceAndPage.canmanage}" == 1){
          $("#trCanmanage").show();
        }
        //更改授权模型
        showSecurityType("${spaceAndPage.path}", "${spaceAndPage.pageId}");
        if("${spaceAndPage.canpush}" == 1){
          $("#trCanpush").show();
        }
        if("${spaceAndPage.canpersonal}" == 1){
          $("#trCanpersonal").show();
          if("${spaceAndPage.isAllowDefined}" == "true"){
            $("#canpersonal").attr("checked",true);
          }else{
            $("#canpersonal").attr("checked",false);
          }
        }else{
          $("#trCanpersonal").hide();
          $("#canpersonal").attr("checked",false);
        }
        if("${spaceAndPage.canusemenu}" == 1){
          $("#canusemenu").val(1);
          $("#trCanusemenu").show();
          $("#spaceMenuEnable").attr("checked", "${spaceAndPage.spaceMenuEnable}" == 1);
          if("${spaceAndPage.spaceMenuEnable}" == 1){
            $("#trMenuTree").show();
            $("#menuTR").show();
            //显示系统菜单
            showSystemMenuTree("${spaceAndPage.id}",true);
          }
        }else{
          $("#canusemenu").val(0);
          $("#trCanusemenu").hide();
          $("#spaceMenuEnable").attr("checked", false);
        }
        if("${spaceAndPage.state}" == 0){
          $("input[name='state']:first").attr("checked", true);
          $("input[name='state']:last").attr("checked", false);
        } else{
          $("input[name='state']:first").attr("checked", false);
          $("input[name='state']:last").attr("checked", true);
        }
        $("input[name='state']:first").attr("disabled", true);
        $("input[name='state']:last").attr("disabled", true);
        $("#sortId").val("${spaceAndPage.sortId}");
        $("#editSpacePage").attr("src","${spaceAndPage.path}"+"?showState=edit");
        
        
	    new spaceSecurityManager().selectSecurityBOBySpaceId("${spaceAndPage.id}", {
	      success : function(spaceSecuritys) {
	        $("#canshare").comp({value:spaceSecuritys[0],text:spaceSecuritys[1],isNeedCheckLevelScope:false,showRecent:false});
	        $("#canmanage").comp({value:spaceSecuritys[2],text:spaceSecuritys[3],isNeedCheckLevelScope:false,showRecent:false});
	        //自定义团队空间、单位空间、集团空间、自定义单位空间、自定义集团空间管理授权不能修改
	        if(spaceType == "4" || spaceType == "2" || spaceType == "3" || spaceType == "17" || spaceType == "18"){
	          $("#trCanmanage").disable();
	        }
	      }
	    });
        $("#grid_detail .align_center").show();
	  
    //save 
    $("#submitbtn").click(function() {
      isToDefault = false;
      var formobj = $("#grid_detail").formobj();
      if (!$._isInValid(formobj)) {
        showMask();
        var spaceId = $("#id").val();
        if(frames['editSpacePage'].addLayoutDataToForm){
        	var checkResult = frames['editSpacePage'].sectionHandler.checkEditSection();
            if(checkResult == false){
              hideMask();
          	  return;
            }
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
	        var formobjNew = $("#grid_detail").formobj();
	        new spaceManager().transSaveSpace(formobjNew,{
	          success : function(){
	            hideMask();
	            $.messageBox({
	              'title': "${ctp:i18n('common.prompt')}",
	              'type': 0,
	              'msg': "<span class='msgbox_img_0 left' ></span><span class='margin_l_5'>${ctp:i18n('common.successfully.saved.label')}</span>",
	              ok_fn: function() {
	                getCtpTop().refreshNavigation(formobjNew.id);
	                location.reload();
	              }
	            });
	          }
	        });
        }
      }
    });
    
    //menu enable
    $("#spaceMenuEnable").click(function(){
      var isChecked = $("#spaceMenuEnable").attr("checked");
      if(isChecked){
        $("#trMenuTree").show();
        $("#menuTR").show();
        var spaceId = $("#id").val();
        if(spaceId!=0){
          showSystemMenuTree(spaceId,true);
        }else{
          showSystemMenuTree(null,true);
        }
      }else{
        $("#trMenuTree").hide();
        $("#menuTR").hide();
      }
    });
    
    //toDefault
    $("#todefaultbtn").click(function(){
      toDefault();
    });
    
    //cancelEdit
    $("#cancelbtn").click(function(){
      getCtpTop().refreshNavigation('${spaceAndPage.id}');
      isToDefault = false;
    });
    
  });
  
  function toDefault(){
    var editKeyId = frames['editSpacePage'].document.getElementById("editKeyId").value;
    var path = $("#path").val();
    var params = new Object();
    params['editKeyId']=editKeyId;
    params['pagePath']=path;
    new pageManager().transToDefaultSpace(params,{
      success : function(result){
        if(result!=null){
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
    if(spaceId){
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
    }else{
      $("#systemMenuTree").tree({
        idKey : "idKey",
        pIdKey : "pIdKey",
        nameKey : "nameKey",
        enableCheck : true,
        enableEdit : enable,
        enableRename : false,
        enableRemove : false,
        beforeDrag : beforeDrag,
        beforeDrop : beforeDrop,
        nodeHandler:function(n){
          if(!n.data.icon){
            n.isParent = true;
          }
          if(n.idKey=="menu_0"){
            n.open = true;
          }
          n.checked = false;
          n.expand = n.data.expand;
          n.chkDisabled = !enable;
        }
      });
    }
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
    if(path.indexOf("/department/") != -1 || path.indexOf("/custom") != -1 || path.indexOf("/public_custom/") != -1){
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
<body class="h100b over_hidden bg_color">
    <div class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height">
            <div class="comp" comp="type:'breadcrumb',code:'T3_spaceEditMenu_label'"></div>
        </div>
        
        <div id="grid_detail" class="stadic_layout_body stadic_body_top_bottom padding_10">
            <input type="hidden" id="id" value="${spaceAndPage.id}"/>
            <input type="hidden" id="defaultspace" value="0"/>
            <input type="hidden" id="decoration" value=""/>
            <input type="hidden" id="showState" value=""/>
            <input type="hidden" id="editKeyId" value=""/>
            <input type="hidden" id="toDefault" value=""/>
            <input type="hidden" id="canusemenu" value=""/>
            <input type="hidden" id="sysMenuTree" value="">
            <input type="hidden" id="accountType" value="${accountType}">
            <input type="hidden" id="accountId" value="${accountId}">
            <div class="">
            <fieldset>
            <legend><b>${ctp:i18n("space.title.baseInfo")}</b></legend>            
            <div class="form_area">
                <table border="0" cellspacing="0" cellpadding="0" width="800">
                    <tr>
                        <th width="300"><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n("space.label.name")}:</label></th>
                        <td>
                            <div class="common_txtbox_wrap">
                                <input type="text" id="spacename" class="validate" value="<c:out value="${spaceAndPage.spacename}" default="null" escapeXml="true"/>"
                                    validate="type:'string',name:'${ctp:i18n("space.label.name")}',notNull:true,minLength:1,maxLength:100" />
                            </div>
                        </td>
                    </tr>
                    <tr id="pageNameTr">
                        <th width="300"><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n("space.label.type")}:</label></th>
                        <td>
                            <div class="common_txtbox_wrap">
                                <input type="text" id="pageName" class="validate"
                                    validate="type:'string',name:'${ctp:i18n("space.label.type")}',notNull:true" readonly="readonly" onclick="selectSpacePage()"/>
                            </div>
                            <input type="hidden" id="path" value="" />
                        </td>
                    </tr>
                    <tr id="trCanmanage" style="display: none">
                        <th width="300"><label class="margin_r_10" for="text">${ctp:i18n("space.manage.auth.label")}:</label></th>
                        <td>
                            <div class="common_txtbox_wrap">
                                <input id="canmanage" value="" type="text" class="comp" comp="type:'selectPeople',mode:'open',panels:'Account,Department,Team,Post,Level,Role,Outworker',selectType:'Account,Department,Team,Post,Level,Role,Outworker,Member',showFlowTypeRadio: false,hiddenPostOfDepartment:true">
                            </div>
                        </td>
                    </tr>
                    <tr id="trCanshare" style="display: none">
                        <th width="300"><label class="margin_r_10" for="text">${ctp:i18n("space.use.auth.label")}:</label></th>
                        <td>
                            <div class="common_txtbox_wrap">
                                <input id="canshare" value="" type="text" class="comp" comp="type:'selectPeople',mode:'open',panels:'Account,Department,Team,Post,Level,Role,Outworker',selectType:'Account,Department,Team,Post,Level,Role,Outworker,Member',showFlowTypeRadio: false,hiddenPostOfDepartment:true">
                            </div>
                        </td>
                    </tr>
                    <tr id="trCanpush" style="display: none">
                        <th width="300"><label class="margin_r_10" for="text">${ctp:i18n("space.default.todefault.label")}:</label></th>
                        <td>
                            <div class="common_checkbox_box clearfix">
                                <label class="margin_r_10 hand" style="color: green;" for="canpush"><input id="canpush" class="radio_com" name="option" value="0" type="checkbox">${ctp:i18n("space.default.msg")}</label>
                            </div>
                        </td>
                    </tr>
                    <tr id="trCanpersonal" style="display: none">
                        <th width="300"><label class="margin_r_10" for="text">${ctp:i18n("space.customize.prompt")}:</label></th>
                        <td>
                            <div class="common_checkbox_box clearfix">
                                <label class="margin_r_10 hand" for="canpersonal"><input id="canpersonal" class="radio_com" name="canpersonal" value="0" type="checkbox"></label>
                            </div>
                        </td>
                    </tr>                    
                    <tr>
                        <th width="300"><label class="margin_r_10" for="text">${ctp:i18n("space.label.isEnabled")}:</label></th>
                        <td>
                            <div class="common_radio_box clearfix">
                                <label for="state" class="margin_r_10 hand"><input type="radio" id="state" name="state" class="radio_com" checked="checked" value="0" />${ctp:i18n("common.state.normal.label")}</label>
                                <label for="state" class="hand"><input type="radio" value="1" id="state" name="state" class="radio_com"/>${ctp:i18n("common.state.invalidation.label")}</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th width="300"><label class="margin_r_10" for="text"><font color="red">*&nbsp;</font>${ctp:i18n("sortnum.label")}:</label></th>
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
            </div>    
            </fieldset>
            </div>
            <div class="two_row" id="trCanusemenu" style="display:none">
                    <fieldset class="padding_10 margin_t_10">
                        <legend><b>${ctp:i18n("space.title.menu")}</b></legend>
                        <table border="0" cellspacing="0" cellpadding="0" width="">
                            <tr>
                                <td>
                                    <div class="common_checkbox_box clearfix" style="margin-left: 210px; margin-bottom: 10px">
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
            <fieldset>
                <legend><b>${ctp:i18n("space.section.setting")}</b></legend>
                <iframe width="100%" height="500px" id="editSpacePage" name="editSpacePage" src="${spacePage.path}?decoration=${decoration}&showState=${param.showFlag!='show'?'edit':'show'}&showFlag=${param.showFlag}&editKeyId=${editKeyId}" frameborder="0"></iframe>
            </fieldset>
            </div>
        </div>
        <div class="stadic_layout_footer stadic_footer_height">
            <div class="common_center align_center">
                <span id="submitbtn" class="common_button common_button_emphasize" >${ctp:i18n("common.button.ok.label")}</span>
                <span id="todefaultbtn"  class="common_button common_button_gray">${ctp:i18n("space.button.toDefault")}</span>
                <span id="cancelbtn" class="common_button common_button_gray">${ctp:i18n("common.button.cancel.label")}</span>
            </div>
        </div>
    </div>  
<script>
var RTEEditorDivWidth = document.documentElement.clientWidth - 20;
document.getElementById('grid_detail').style.width= RTEEditorDivWidth +'px';
</script>
</body>
</html>