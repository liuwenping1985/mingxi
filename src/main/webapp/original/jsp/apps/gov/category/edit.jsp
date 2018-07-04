<%--
 $Author:  xiangfan$
 $Rev:  $
 $Date:: 2012-09-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
</head>
<script type="text/javascript" src="${path}/ajax.do?managerName=categoryManager"></script>
<script type="text/javascript">
var cManager;
$(document).ready(function() {
	cManager = new categoryManager();
	$("#btncancel").click(function() {
		window.parent.$('#listCategory').ajaxgridLoad(); 
		window.parent.$('.slideDownBtn').trigger('click');
		window.parent.$('#summary').attr("src", _ctxPath+"/category/category.do?method=summaryDesc"+"&size="+window.parent.grid.p.total);
    });
    $("#btnok").click(function() {
    	var _cName = $("#name").val();
    	var currrent_categoryId = "${ctp:escapeJavascript(category_id)}";
    	if(_cName != "" && $("#isSystem").val()!='1') {//系统模版不需要做同名校验
	        var flag = cManager.hasRepeatNameByCategory(_cName, currrent_categoryId);
	        if(flag){
	            $.alert($.i18n('category.alert.existsName', _cName));
	            return ;
	        }
    	}
    	cManager.createCategory($("#addForm").formobj({
    	    includeDisabled: true
    	}), {
    		success: function(categoryBean) {
    			//parent.location.reload();
    			window.parent.$('#listCategory').ajaxgridLoad();
    			//window.parent.parent.$("#categoryTree").treeObj().reAsyncChildNodes(null, "refresh");
    			//window.parent.parent.location.reload();
    			window.parent.$('.slideDownBtn').trigger('click');
    			setTimeout(function(){
    				window.parent.$('#summary').attr("src", _ctxPath+"/category/category.do?method=summaryDesc"+"&size="+window.parent.grid.p.total);
        		},"500");
    	    }
   	    });
    });
});
function _init(){
    if("${ctp:escapeJavascript(action)}" == "doCreate"){
    	addForm();
    }else if("${ctp:escapeJavascript(action)}" == "show"){
    	findForm("${ctp:escapeJavascript(category_id)}");
    }else if("${ctp:escapeJavascript(action)}" == "doModify"){
    	modifyForm("${ctp:escapeJavascript(category_id)}");
    }
}
function modifyForm(id){
	cManager.getCategoryById(
		id,
		{success: function(rel) {
			$("#name").val(rel["name"]);
			$("#level").val(rel["level"]);
			$("#sort").val(rel["sort"]);
			$("#id").val(rel["id"]);	
	   		$("#createUserName").val(rel["createUserName"]);
	   		$("#createUserId").val(rel["createUserId"]);
	   		var formatDate = rel["createTime"].split(" ");    		
	   		$("#createTime").val(formatDate[0]);
	   		$("#desc").val(rel["desc"]);
	   		if(rel["isSystem"] == "1"){
	   			$("#isSystem").val("1");
	   			$("#name").disable();
	   			$("#level").disable();
	   			//$("#sort").disable();//系统分类只能修改排序号
	   			//$("#desc").disable();
	   			$("#button").show();
	   		}else {
	   			$("#name").enable();
	   			$("#level").enable();
	   			$("#sort").enable();
	   			$("#desc").enable();
	   			$("#button").show();
	   		}
	    }
	});
	$("#createTime").disable();
	$("#createUserName").disable();
}
function findForm(id){
	//$("#addForm").clearform({
	//	clearHidden: true
	//});
	cManager.getCategoryById(
		id,
		{success: function(rel) {
			$("#name").val(rel["name"]);
			$("#level").val(rel["level"]);
			$("#sort").val(rel["sort"]);
			$("#id").val(rel["id"]);	
    		$("#createUserName").val(rel["createUserName"]);
    		$("#createUserId").val(rel["createUserId"]);
    		var formatDate = rel["createTime"].split(" ");    		
    		$("#createTime").val(formatDate[0]);
    		$("#desc").val(rel["desc"]);
	    }
	});
	$("#createTime").disable();
	$("#createUserName").disable();
	$("#name").disable();
	$("#level").disable();
	$("#sort").disable();
	$("#desc").disable();
	$("#button").hide();
}
function addForm(){
	$("#addForm").clearform({
		clearHidden: true
	});
	cManager.addCategory({
	    success: function(rel) {
    		$("#createUserName").val(rel["createUserName"]);
    		$("#createUserId").val(rel["createUserId"]);
    		var formatDate = rel["createTime"].split(" ");    		
    		$("#createTime").val(formatDate[0]);    		
	    }
	});
	$("#createTime").disable();
	$("#createUserName").disable();
	$("#name").enable();
	$("#level").enable();
	$("#sort").enable();
	$("#desc").enable();
	$("#button").show();
}
</script>
<body class="h100b over_hidden" onload="_init();">
<div class="stadic_layout_body form_area" id="content">
  <form name="addForm" id="addForm" method="post" class="align_center">
    <input id="isSystem" name="isSystem" type="hidden" value="0">
  	<input id="createUserId" name="createUserId"  type="hidden" name="createUserName"/>
  	<input id="id" name="id"  type="hidden"/>
    <table border="0" cellSpacing="0" cellPadding="0" width="500" align="center">
      <tbody>
        <tr>
          <th noWrap><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n("category.column.name.app_32")}:</label></th>
          <td width="100%">
            <div class="common_txtbox_wrap"><input id="name" name="name" class="validate" type="text" validate="type:'string',name:'${ctp:i18n('category.column.name.app_32')}',notNull:true,maxLength:85,avoidChar:'\\\/|><:*?&%$|,'">
            </div>
          </td>
        </tr>
        <!--<tr>
          <th noWrap><font color="red">*</font><label class="margin_r_10" for="text">类型级别:</label></th>
          <td>
            <div class="common_txtbox_wrap"><input id="level" class="validate" type="text" name="level" validate="type:'int',isNumber:true,notNull:true,name:'类型级别'">
            </div>
          </td>
        </tr>
        --><tr>
          <th noWrap><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n("category.column.sort")}:</label></th>
          <td>
            <div class="common_txtbox_wrap"><input id="sort" class="validate" type="text" name="sort" validate="name:'${ctp:i18n('category.column.sort')}',notNull:true,type:'int',isInteger:true,maxLength:3,min:0">
            </div>
          </td>
        </tr>
        <tr>
          <th noWrap><label class="margin_r_10" for="text">${ctp:i18n("category.column.createtime")}:</label></th>
          <td>
            <div class="common_txtbox_wrap"><input id="createTime" name="createTime" class="comp validate " type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" comptype="calendar" _inited="1" _icoed="true" _autoFill="false" validate="name:'创建时间',notNull:true,type:'3'">
              <span style="CURSOR: hand" class="calendar_icon_area _autoBtn">
                <span style="POSITION: absolute; TOP: -1px; LEFT: -14px" class="calendar_icon"></span>
              </span> 
            </div>
          </td>
        </tr>
        <tr>
          <th noWrap><label class="margin_r_10" for="text">${ctp:i18n("category.column.creater")}:</label></th>
          <td>
            <div class="common_txtbox_wrap"><input id="createUserName" class="validate" type="text" name="createUserName" validate="name:'${ctp:i18n('category.column.creater')}', type:'long', dotNumber:2, integerDigits:4, notNull:true">
            </div>
          </td>
        </tr>
        <tr>
          <th noWrap><label class="margin_r_10" for="text">${ctp:i18n("category.column.desc")}:</label></th>
          <td>
            <div class="common_txtbox  clearfix">
              <textarea rows="5" class="w100b validate word_break_all" id="desc" name="desc" validate="type:'string',name:'${ctp:i18n('category.column.desc')}',notNull:false,maxLength:100"></textarea>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
</div>
<!-- <div class="align_center margin_t_10">
  <a id="tableSubmit" class="common_button common_button_gray" onclick="formSubmit();" href="javascript:void(0)">提交</a> 
  <a class="common_button common_button_gray" href="javascript:void(0)">取消</a>
</div> -->
<div class="stadic_layout_footer" id="bottomButton" style="height:35px;">
            <div id="button" align="center" class="page_color button_container">
                <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">
                   <a id="btnok" href="javascript:void(0)" class="common_button common_button_gray" id="edit_confirm_button">${ctp:i18n('permission.confirm')}</a>&nbsp;<%--确定 --%>
                    <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray" id="edit_cancel_button">${ctp:i18n('permission.cancel')}</a><%--取消 --%>
                </div>
            </div>
</div>
</body>
</html>