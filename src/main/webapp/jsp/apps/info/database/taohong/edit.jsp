<%--
 $Author:  xiangfan$
 $Rev:  $
 $Date:: 2012-09-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../include/info_header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
</head>
<script type="text/javascript">
$(document).ready(function() {
	$("#btncancel").click(function() {
		window.parent.$('.slideDownBtn').trigger('click');
		window.parent.$('#summary').attr("src", _ctxPath+"/info/taohong.do?method=listDesc"+"&size="+window.parent.grid.p.total);
    });
    $("#btnok").click(function() {
       
    	/****
    	if(!validataForm())
            return ;
        var _action = _ctxPath+"/info/taohong.do?method=create";
        if("${ctp:escapeJavascript(action)}" == "doModify"){
        	_action = _ctxPath+"/info/taohong.do?method=modify&id="+$("#id").val();
        }
    	$("#addForm").attr("action", _action);
    	saveAttachment();
    	$("#addForm").submit();
    	*****/
    	
    	//表单提交
    	saveAttachment();
    	
        var form = $("#addForm");
        var path = _ctxPath+"/info/taohong.do?method=create";
        if("${ctp:escapeJavascript(action)}" == "doModify"){
        	path = _ctxPath+"/info/taohong.do?method=modify&id="+$("#id").val();
        }
        
        //$("#template").html("");
        //var domains = [];
        //domains.push("template");
        //saveAttachmentPart("template");   
        
        form.attr('action', path);
        form.jsonSubmit({
            validate : true,
            errorIcon : true,
            //domains: domains;
            callback : function(args) {
            	if(args != "true" && args != "<PRE>true</PRE>") {//"<PRE>true</PRE>" ie7可能返回这样的值
            		$.alert(args);
            	}else{
            		window.parent.$('#listTaohong').ajaxgridLoad();
            		setTimeout(function(){
            			window.parent.$('#summary').attr('src', _ctxPath+'/info/taohong.do?method=listDesc&size='+window.parent.grid.p.total);
            		},'200');
            		window.parent.$('.slideDownBtn').trigger('click');
            	}
            }
        });
    });

    $("#upload_button").click(function() {
        if("${ctp:escapeJavascript(action)}" == "create" || "${ctp:escapeJavascript(action)}" == "doModify"){
        	var attachments = fileUploadAttachments;
   	   		var oldSize = fileUploadAttachments.size();
   	   		window.inserAttParams = {};
   	   	    inserAttParams.oldSize = oldSize;
    		insertAttachment();
        }
    });
    
    $("#departmentNames").bind('click',function(){
    	var paramsValue =  parseIds4Panles();
    	$.selectPeople({
	        type:'selectPeople'
	        ,panels:'Department'
	        ,selectType:'Account,Department'
	        ,minSize:1
	        ,text:$.i18n('common.default.selectPeople.value')
	        ,returnValueNeedType: false
	        ,showFlowTypeRadio: false
	        ,maxSize:10
	        ,params:{
	           value: paramsValue
	        }
	        ,targetWindow:getCtpTop()
	        ,callback : function(res){
		        var _objs = res.obj;
		        var depValues = "";
		        for(var i=0; i<_objs.length; i++){
			        if(i==_objs.length-1){
			        	depValues = depValues+_objs[i].type+"|"+_objs[i].id;
			        }else {
			        	depValues = depValues+_objs[i].type+"|"+_objs[i].id+",";
			        }
		        }
               $("#departmentNames").val(res.text);
               $("#departmentIds").val(depValues);
	        }
	    });
    });
});

/**
 * 插入版式后回调
 */
function insertAtt_Callback(){
    var oldSize = 0;
    if(inserAttParams){
        oldSize = inserAttParams.oldSize;
    }
    var newSize = fileUploadAttachments.size();
    if(oldSize != 0 && newSize > oldSize){
        var theList = fileUploadAttachments.keys();
        var _fileUrl = theList.get(0);
        deleteAttachment(_fileUrl,false);
    }
    var newFileUrl = fileUploadAttachments.keys().get(0);
    if(newFileUrl != null && fileUploadAttachments.instance[newFileUrl]){
        $("#fileName").val(fileUploadAttachments.instance[newFileUrl].filename);
        $("#fileName").hide();
    }else {
        $("#fileName").show();
    }
    $(".margin_r_5").hide();
    $(".margin_r_5").next().attr("href", "javascript:void(0);");
    $(".margin_r_5").next().attr("style", "color:#000;");
    $(".affix_del_16").hide();
}

function parseIds4Panles(){
	var panlesValue = "";
    var ids = $("#departmentIds").val().split(',');
    if(ids[0] != ""){
        for(var i = 0;i < ids.length;i++){
            if(i == ids.length -1){
            		panlesValue = panlesValue + ids[i] ;
            }else {
            		panlesValue = panlesValue + ids[i] +",";
            }
        }
    }
    return panlesValue;
 }

function validataForm(){
	var name = $("#name").val();
	var format_file = $("#fileName").val();
	//var rangs = $("#departmentNames").val();
	if(name == ""){
		$.error($.i18n("infosend.alert.format.nameNotNull"));
		return false;
	}else if(format_file == ""){
		$.error($.i18n("infosend.alert.format.templateNotNull"));
		return false;
	}
	/**else if(rangs == ""){
		$.alert($.i18n("infosend.alert.format.rangNotNull"));
		return false;
	}**/
	else if(!(/^[^\/|"'<>]*$/.test(name))){
		$.error($.i18n("infosend.alert.format.nameSpecialChar"));
		return false;
	}else if(name.length > 85){
		$.error($.i18n("infosend.alert.lenght85"));
		return false;
	}
	return true;
}
function _init(){
	if("${ctp:escapeJavascript(action)}" == "create"){
		$("#status2").attr("checked","true");
		$("#button").show();
	}else if("${ctp:escapeJavascript(action)}" == "find"){
    	$("#name").disable();
    	$("#template").disable();
    	$("#upload_button").disable();
    	$("#upload_button").removeAttr("href");
    	$("#status2").attr("disabled","true");
    	$("#status1").attr("disabled","true");
    	//隐藏附件图标
    	$(".margin_r_5").hide();
    	$(".affix_del_16").remove();
    	$(".unstore_16").hide();
    	$(".stored_16").hide();
    	$(".margin_r_5").next().attr("href", "javascript:void(0);");
    	$(".margin_r_5").next().attr("style", "color:#575656;");
    	$("#fileName").hide();
    	$("#button").hide();
    	$("#button").hide();
    	$("#departmentNames").disable();
    }else if("${ctp:escapeJavascript(action)}" == "doModify"){
    	$("#name").enable();
    	$("#template").enable();
    	$("#upload_button").enable();
    	$(".affix_del_16").remove();
    	$(".unstore_16").hide();
    	$(".stored_16").hide();
    	$(".margin_r_5").hide();
    	$(".margin_r_5").next().attr("href", "javascript:void(0);");
    	$(".margin_r_5").next().attr("style", "color:#000;");
    	$("#fileName").hide();
    	$("#button").show();
    }
}
</script>
<body class="h100b over_hidden" onload="_init();">
<div class="stadic_layout_body form_area" id="content">
  <form name="addForm" id="addForm" method="post" class="align_center">
  	<input id="id" name="id"  type="hidden" value="${bean.id}"/>
  	<div id="attachmentInputs"></div>
    <table border="0" cellSpacing="0" cellPadding="0" width="500" align="center">
      <tbody>
        <tr>
          <th noWrap><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n("infosend.label.template")}:</label></th>
          <td width="100%">
            <div class="common_txtbox_wrap">
                <input id="name" name="name" class="validate" type="text" value="${ctp:toHTML(bean.name)}" validate="type:'string',name:'${ctp:i18n('infosend.label.template')}',notNull:true,maxLength:85,avoidChar:'-!@#$%^&amp;*()_+'">
            </div>
          </td>
          <td></td>
        </tr>
        <tr>
          <th noWrap><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n("infosend.label.formatfile")}:</label></th>
          <td>
          	<div class="common_txtbox_wrap h100b">
          		<input id="fileName" readonly="readonly" class="validate" name="fileName" type="text" value="${fileName}"  validate="type:'string',name:'${ctp:i18n('infosend.label.formatfile')}',notNull:true">
            	<input style="display: none;" id="template" class="comp" type="text" name="template" comp="type:'fileupload',applicationCategory:'32',quantity:'1',canDeleteOriginalAtts:true,originalAttsNeedClone:false,extensions:'doc,docx',callMethod:'insertAtt_Callback',takeOver:false"  attsdata='${attachmentsJSON}' validate="name:'${ctp:i18n('infosend.label.formatfile')}',notNull:true">
            	</div>
          </td>
          <td>
          <div class="padding_l_10 margin_tb_5">
	                    <a id="upload_button" href="javascript:void(0);"  style="height:20px;" class="common_button common_button_icon file_click"><!-- <em class="ico16 affix_16"></em> -->${ctp:i18n('infosend.label.doSelect')}<!-- 选择 --></a>
			</div></td>
        </tr>
        <tr>
          <th noWrap><label class="margin_r_10" for="text">${ctp:i18n("infosend.label.authorization")}:</label></th>
          <td>
            <div class="common_txtbox_wrap">
            	<input id="departmentNames" name="departmentNames" readonly="readonly" value="${bean.range}" type="text" validate="name:'${ctp:i18n('infosend.label.authorization')}',notNull:'true'">
            	<input id="departmentIds" name="departmentIds" value="${bean.rangeIds}" style="display: none;">
            </div>
          </td>
          <td></td>
        </tr>
        <tr>
          <th noWrap><label class="margin_r_10" for="text">${ctp:i18n("infosend.label.status")}:</label></th>
          <td>
          	<div class="common_checkbox_box clearfix align_left">
          		<label for="status2">
			 		<input type="radio" id="status2" name="status" value="1" <c:if test="${bean.status_flag == 1}"> checked </c:if> /> ${ctp:i18n("infosend.status.enable")}
			 	</label>
          	
          		<label for="status1" style="margin-right:10px;">
					<input type="radio" id="status1" name="status" value="0" <c:if test="${bean.status_flag == 0}"> checked </c:if> /> ${ctp:i18n("infosend.status.disable")}
				</label>
			 </div>
            </td>
          <td></td>
        </tr>
      </tbody>
    </table>
  </form>
</div>

<c:if test="${action!='find'}">
<style>
	.stadic_body_top_bottom{
	    top: 0px;
	    bottom: 40px;
	}
	.stadic_footer_height{
	    height:40px;
	}
</style>
</c:if>
<div class="stadic_layout_footer stadic_footer_height" id="bottomButton">
            <div id="button" align="center" class="page_color button_container">
                <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">
                   <a id="btnok" href="javascript:void(0)" class="common_button common_button_gray" id="edit_confirm_button">${ctp:i18n('permission.confirm')}</a>&nbsp;<%--确定 --%>
                    <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray" id="edit_cancel_button">${ctp:i18n('permission.cancel')}</a><%--取消 --%>
                </div>
            </div>
</div>
</body>
</html>