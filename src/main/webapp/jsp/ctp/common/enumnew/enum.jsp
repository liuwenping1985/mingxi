<%--
 $Author: wangwy $
 $Rev: 49168 $
 $Date:: 2015-04-29 17:28:18#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>枚举页面</title>
</head>
<body scrolling="no" class="h100b">
	<div class="form_area align_center" style="position:absolute; bottom:50px; top:0; width:100%;left:0;overflow:auto;">
	<!--  <h><c:if test="${nodeType == 1}">${ctp:i18n('metadata.manager.typename.new')}</c:if></h>-->
	<form id="tableForm" class="align_center" method="post" action="${path}/enum.do?method=saveOrUpdateEnum&tabType=${tabType}&nodeType=${nodeType}&roleType=${roleType}&parentId=${parentId}" onsubmit="return false">
	    <table border="0" id="enumArea" cellSpacing="0" cellPadding="0"  height="100%" align="center">
	        <tbody><tr>
	            <th noWrap="nowrap">
	            	<label class="margin_r_5" for="text"><span class="required">*</span><c:if test="${nodeType == 1}">${ctp:i18n('common.resource.body.name.label')}:</c:if><c:if test="${nodeType == 2}">${ctp:i18n('metadata.select.enum.name')}:</c:if></label>
	            </th>
	            <td><div class="common_txtbox_wrap">
	            	<input type="hidden" id="id" name = "id" value="">
	            	<c:if test="${nodeType == 1}">
	            	<input id="name" class="validate" name="name" value="" type="text" validate="name:'${ctp:i18n("metadata.new.select.enumtype.name.notnull.label")}',notNullWithoutTrim:true,notNull:true,maxLength:85">
	            	</c:if>
	            	<c:if test="${nodeType == 2}">
	            	<input id="name" class="validate" name="name" value="" type="text" validate="name:'${ctp:i18n("metadata.select.enum.name")}',notNullWithoutTrim:true,notNull:true,maxLength:85">
	            	</c:if>
	            </div></td>
	        </tr>
	        <tr>
	            <th noWrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n("common.sort.label")}:</label></th>
	            <td><div class="common_txtbox_wrap">
	            	<input id="sortnumber" class="validate" name="sortnumber" value="" type="text" validate="name:'${ctp:i18n("common.sort.label")}',maxValue:99999999,notNull:true,isInteger:true">
	            </div></td>
	        </tr>
	        <tr>
	            <th noWrap="nowrap"><label class="margin_r_5" for="text">${ctp:i18n("common.description.label")}:</label></th>
	            <td>
	            	<textarea id="description" class="validate" name="description" rows="5" cols="30" validate="name:'${ctp:i18n("common.description.label")}',maxLength:255"></textarea>
	            </td>
	        </tr>
		</tbody></table>
	</form>
    </div>
    <c:if test="${pageType != 'browse' && nodeType !=1}">
    <div class="align_center dialog_main_footer page_color" style="bottom:0; position:absolute; width:100%;">
        <a id="tableSubmit" class="common_button common_button_emphasize margin_5"  href="javascript:void(0)">${ctp:i18n("common.button.ok.label")}</a>
        <a class="common_button common_button_gray margin_5" id="cancel" href="javascript:void(0)">${ctp:i18n("common.toolbar.cancelmt.label")}</a>
    </div>
    </c:if>
    
    <script type="text/javascript">
	    $().ready(function() {
	    	if("${ctp:escapeJavascript(pageType)}" != 'browse'){
	    		if($("#name").attr("disabled") != "disabled" && $("#name").attr("readonly") != "readonly"){
	    			$("#name")[0].focus();
	    		}
	    		if("${nodeType}" != "1"){
		    	    //绑定页面回车事件
		    	    $("#tableForm :input").keydown(function(e){
		    			if(e.keyCode == 13) {
		    				$("#tableSubmit").focus();
		    				saveEnum();
		    		 	}
		     		});
	    		}
	    	}
	    	disabledAll();
	    	$("#tableSubmit").click(function (){
	    		$(this).prop('disabled',true);
				//if("${pageType}" == "new"){
					saveEnum();
				//}else if("${pageType}" == "editor"){
				//	updateEnum();
				//}
		    });
	    	$("#cancel").click(function (){
	    		if("${nodeType}" == 1){
	    			window.dialogArguments[0].window.close();
	    		}else{
	    			parent.cancelPage();
	    		}
	    	});
	    	//系统枚举，名称不能修改
	    	if("${tabType}" == 1){
	    		$("#name").attr("disabled",true);
	    		$("#name").attr("readonly",true);
	    	}
	    });
	    //禁用所有的input
	    function disabledAll(){
	    	if("${ctp:escapeJavascript(pageType)}" == "browse"){
	    		$("#enumArea").find("input:text,textarea").each(function (){
	    			$(this).attr("disabled",true);
	    			$(this).attr("readonly",true);
	    		});
	    	}
	    }
	    function saveEnum(){
	        $("#tableSubmit").prop('disabled', true);
	    	if($("#tableForm").validate()){
				var progress = $.progressBar();//显示滚动条，锁定页面，防止重复提交
		    	var em = new enumManagerNew();
	    		em.checkName($("#id").val(),$("#name").val(),"${parentId}",0,"${tabType}","${nodeType}",{success:
					function(obj){
						if(!obj){
							submitEnum(progress);
							$("#name").blur();
							$(window.document).keydown(function(e){
								if(e.keyCode == 13) {
									return false;
								}
						 	});
						}else{
							progress.close();
							$.alert("${ctp:i18n('metadata.enumname.exist.error.label')}!");
							$("#name")[0].blur();
							$("#tableSubmit").prop('disabled',false);
						}
					}
				});
	    	}else{
	    		$("#tableSubmit").prop('disabled',false);
	    	}
	    }
	    function updateEnum(){
	    	if($("#tableForm").validate()){
	    		submitEnum();
	    	}
	    }
	    function submitEnum(processBar){
	    	$("#tableForm").jsonSubmit({callback : function(data) {
				if(processBar!=undefined&&processBar!=null)
				{
					try
					{
						processBar.close();
					}
					catch(err)
					{
						//出错时，不要影响主功能的正常使用
					}
				}
                if(data!=undefined&&data!=null&&data!="")
				{
					alert(data);
					$("#tableSubmit").prop('disabled',false);
					return;
				}					
    			$.infor({
    			    'msg': '${ctp:i18n("common.successfully.saved.label")}!',
    			     ok_fn: function () {
	    			    	 if("${nodeType}" == 1){
	    			    		 //window.dialogArguments[0].window.parent.location.reload();
	    	    			 }else{
	    	    				parent.refreshPage();
	    	    			 } 
    			    	}
    			    });
    			}
	    	});
	    }
	    //该方法兼容弹出框
	    function OK(){
	    	var returnValue = false;
	    	if($("#tableForm").validate()){
		    	var em = new enumManagerNew();
	    		var obj = em.checkName($("#id").val(),$("#name").val(),"${parentId}",0,"${tabType}","${nodeType}");
	    		if(!obj){
	    			$("#tableForm").jsonSubmit({ajax:true});
					returnValue = true;
				}else{
					$.alert("${ctp:i18n('metadata.enumname.exist.error.label')}!");
					$("#name").focus();
				}
	    	}
	    	return returnValue;
	    }
    </script>
</body>
</html>