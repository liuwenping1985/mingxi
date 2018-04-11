<%--
 $Author: leikj $
 $Rev: 4195 $
 $Date:: 2012-09-19 18:18:30#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>菜单排序</title>
<script type="text/javascript" src="${path}/decorations/js/shortcut.js"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=spaceManager"></script>
<script>
  $(document).ready(function() {
  });
  function save(){
	showMask();
    var menuTarget = [];
    $.each($("#menuTargetSelect").find("option"),function(i,obj){
      menuTarget[menuTarget.length]=obj.value;
    });
    if(menuTarget.length<=0){
      $.alert("${ctp:i18n('menu.oneLeast.label')}");
      hideMask();
      return;
    }
    new spaceManager().saveMenuSort($.toJSON(menuTarget),{
      success:function(){
    	hideMask();
        $.messageBox({
          'title': "${ctp:i18n('common.prompt')}",
          'type': 0,
          'msg': "<span class='msgbox_img_0 left'></span><span class='margin_l_5 padding_5'>${ctp:i18n('common.successfully.saved.label')}</span>",
           ok_fn: function() {
        	   getCtpTop().refreshMenus();
               getCtpTop().refreshNavigation();
          }
        });
    }});
  }
  
  /**
   * @description dialog组件回调此方法
   */
  function OK(jsonArgs) {
	  var innerButtonId= jsonArgs.innerButtonId;
	  if(innerButtonId=='saveNew'){
		  var result= saveNew();
		  return result;
	  }else if(innerButtonId=='saveNew1'){
		  var result= saveNew1();
		  return result;
	  }
  }
  
  
  /**
  * 新保存方法
  */
  function saveNew(){
		showMask();
	    var menuTarget = [];
	    $.each($("#menuTargetSelect").find("option"),function(i,obj){
	      menuTarget[menuTarget.length]=obj.value;
	    });
	    if(menuTarget.length<=0){
	      $.alert("${ctp:i18n('menu.oneLeast.label')}");
	      hideMask();
	      return 0;
	    }
	    new spaceManager().saveMenuSort($.toJSON(menuTarget));
	    hideMask();
	    return 1;
  }
  
  function saveNew1(){
		showMask();
	    var menuTarget = [];
	    var menuTargetName = new Array();
	    $.each($("#menuTargetSelect").find("option"),function(i,obj){
	      menuTarget[menuTarget.length]=obj.value;
	      menuTargetName.push($(obj).text());
	    });
	    if(menuTarget.length<=0){
	      $.alert("${ctp:i18n('menu.oneLeast.label')}");
	      hideMask();
	      return 0;
	    }
	    new spaceManager().saveMenuSort($.toJSON(menuTarget));
	    hideMask();
	    return menuTargetName;
}
  
  function cancel(){
    window.location.reload();
  }
</script>
</head>
<body class="h100b over_auto  align_center" style="background:#fafafa;">
    <fieldset class="shortcut_set" style="width: 480px;border:none;padding:0;">
        <legend>
        <%-- ${ctp:i18n('personalSetting.menu.label')}--%>
        </legend>
        <table id="selectTable" width="80%" height="100%" align="center">
            <input type="hidden" id="menuTargetSelectInput" />
            <tr>
            <td width="40%" valign="top" height="100%">
                <p align="center" class="margin_b_5">${ctp:i18n('shortcut.all.label')}</p>
                <select id="menuSourceSelect" size="10" multiple="" style='width:200px;' ondblclick="addThisItem('menu')">
                    <c:forEach items="${unSelectedMenus}" var="menu">
                        <option  value="${menu.id}" title="${v3x:toHTML(menu.name)}">${v3x:toHTML(menu.name)}</option>
                    </c:forEach>
                </select>
                </td>
                <td width="15%" valign="middle">
                    <span class="select_selected" onClick="addThisItem('menu')"> </span><br><br>
                    <span class="select_unselect" onClick="removeThisItem('menu')"> </span>
                </td>
                <td width="45%" valign="top" height="100%">
                    <p align="center" class="margin_b_5">${ctp:i18n('selectPeople.selected.label')}</p>
                    <select id="menuTargetSelect" size="22" multiple="" style='width:200px;' ondblclick="removeThisItem('menu')">
                        <c:forEach items="${customizeMenus}" var="menu">
                            <option  value="${menu.id}" title="${v3x:toHTML(menu.name)}">${v3x:toHTML(menu.name)}</option>
                        </c:forEach>
                    </select>
                </td>
                <td width="50" valign="middle">
                    <span id="sort_up" class="sort_up" onclick="moveUp('menu')"> </span><br><br>
                    <span id="sort_down" class="sort_down" onclick="moveDown('menu')"> </span>
                </td>
            </tr>
        </table>
    </fieldset>
</body>
</html>