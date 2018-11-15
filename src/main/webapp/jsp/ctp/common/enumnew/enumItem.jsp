<%--
 $Author: wangwy $
 $Rev: 49631 $
 $Date:: 2015-05-27 15:45:57#$:
  
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
<title>枚举项</title>
</head>
<body  class="h100b">
	<div class="form_area align_center" style="position:absolute; bottom:35px; top:0; height:85%; width:100%;left:0;overflow:auto;">
	<form id="tableForm" class="align_center" action="${path}/enum.do?method=saveOrUpdateEnumItem&parentType=${parentType}&parentId=${parentId}&tabType=${tabType}">
	    <table id="enumItemArea" border="0" cellSpacing="0" cellPadding="0"  align="center">
	        <tbody><tr>
	            <th noWrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n('metadata.enumvalue.showvalue.label')}:</label></th>
	            <td width="60%"><div class="common_txtbox_wrap">
	            	<input type="hidden" id="id" name = "id" value="">
	            	<input id="showvalue" class="validate" name="showvalue" value="" type="text" validate="name:'${ctp:i18n("metadata.enumvalue.showvalue.label")}',notNullWithoutTrim:true,notNull:true,maxLength:85,isWord:true">
	            </div></td>
	        </tr>
	        <tr>
	            <th noWrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n('metadata.enumValue.label')}:</label></th>
	            <td><div class="common_txtbox_wrap">
	            	<input id="enumvalue" class="validate" name="enumvalue" value="" type="text" validate="name:'${ctp:i18n("metadata.enumValue.label")}',isInteger:true,notNull:true,maxLength:15">
	            </div></td>
	        </tr>
	        <tr>
	            <th noWrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n("common.sort.label")}:</label></th>
	            <td><div class="common_txtbox_wrap">
	            	<input id="sortnumber" class="validate" name="sortnumber" value="" type="text" validate="name:'${ctp:i18n("common.sort.label")}',minValue:-9999,maxValue:9999,notNull:true,isInteger:true">
	            </div></td>
	        </tr>
            <c:if test="${tabType != 5}">
                <tr>
                    <th noWrap="nowrap"><label class="margin_r_5" for="text">${ctp:i18n("metadata.input.state.label")}:</label></th>
                    <td>
                            <div id="inputRadio">
                            <input id="inputSwitch" class="radio_com" name="inputSwitch" value="1" checked="checked" type="radio">${ctp:i18n("common.state.normal.label")}
                            <input id="inputSwitch" class="radio_com" name="inputSwitch" value="0" type="radio">${ctp:i18n("common.state.invalidation.label")}
                            </div>
                    </td>
                </tr>
                <tr>
                    <th noWrap="nowrap"><label class="margin_r_5" for="text">${ctp:i18n("metadata.output.state.label")}:</label></th>
                    <td>
                        <div id="outputRadio">
                            <input id="outputSwitch" class="radio_com" name="outputSwitch"  value="1" checked="checked" disabled="true" type="radio">${ctp:i18n("common.state.normal.label")}
                            <input id="outputSwitch" class="radio_com" name="outputSwitch"  value="0" disabled="true" type="radio">${ctp:i18n("common.state.invalidation.label")}
                        </div>
                    </td>
                </tr>
            </c:if>
            <c:if test="${tabType == 5}">
                <tr>
                    <th noWrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n("metadata.unitImageEnum.imageUrl.label")}:</label></th>
                    <td>
                    <input id="imageUrl" class="validate" name="imageUrl" style="width:75%;height:20;" value="" readOnly="readonly" type="text" validate="name:'${ctp:i18n("metadata.unitImageEnum.imageUrl.label")}',notNull:true,maxLength:4000">
                    <a href="javascript:void(0)" class="common_button" id="imageUpload">${ctp:i18n("metadata.unitImageEnum.imageUpload.label")}</a>
                    <input type="hidden" id="imageId" value="">
                    <input id="myfile" type="hidden" class="comp hidden" comp="type:'fileupload',applicationCategory:'1',extensions:'jpg,jpeg,gif,bmp,png',quantity:1,isEncrypt:false,maxSize:1048576,firstSave:true,attachmentTrId:'enumImage',callMethod:'enumImageCallBk'">
                    </td>
                </tr>
                <tr>
                    <th noWrap="nowrap" valign="top"><label class="margin_r_5" for="text">${ctp:i18n("metadata.unitImageEnum.imageBrowse.label")}:</label></th>
                    <td>
                        <iframe id="enumImageBrowse" src="" style="width:50;height:20;overflow:auto;"></iframe>
                    </td>
                </tr>
                <tr><td colspan="2" align="right"><font color="#006400"><b>${ctp:i18n("metadata.unitImageEnum.beizhu.label")}</b></font></td></tr>
            </c:if>
		</tbody></table>
	</form>
    </div>
    <c:if test="${pageType != 'browse'}">
    <div class="align_center dialog_main_footer page_color" style="bottom:0; position:absolute; width:100%;height:35px;">
        <a id="tableSubmit" class="common_button common_button_emphasize margin_5" href="javascript:void(0)">${ctp:i18n("common.button.ok.label")}</a>
        <a class="common_button common_button_gray margin_5" id="cancel" href="javascript:void(0)">${ctp:i18n("common.toolbar.cancelmt.label")}</a>
   		<c:if test="${pageType != 'editor'}">
    	<label class="font_size12 left margin_l_10 hand margin_t_10" for="checkAdd"><input id="checkAdd" class="radio_com" checked="checked" name="option" value="0" type="checkbox">${ctp:i18n("metadata.enumitem.continue.add")}</label>
        </c:if>
    </div>
    </c:if>
    
     <script type="text/javascript">
	    $().ready(function() {
	    	if("${ctp:escapeJavascript(pageType)}" != 'browse'){
	    		window.setTimeout(function (){
	    			if($("#showvalue").attr("disabled") != "disabled" && $("#showvalue").attr("readonly") != "readonly"){
	    				$("#showvalue")[0].focus();
	    			}
	    		},500);
	    	}
	    	disabledAll();
	    	$("#tableSubmit").click(function (){
	    		saveEnumItem();
	    	});
	    	if("${ctp:escapeJavascript(pageType)}" != "browse"){
                if("${tabType}" == 5){
		    	     $("#imageUpload").click(function (){
                        insertAttachmentPoi('enumImage');
		    	     });
                }
            }
            if("${tabType}" == 5){
                if($("#imageId").val() != "") {
                    $("#enumImageBrowse").attr("src", "${path}/main/common/showImg.html?src=${path}/fileUpload.do?method=showRTE&fileId=" + $("#imageId").val() + "&expand=0&type=image");
                }
            }
	    	$("#cancel").click(function (){
	    		parent.cancelPage();
	    	});
	    	$("#inputRadio").find("input:radio").eq(0).click(function (){
	    		fixOuputRadio(true);
	    	});
			$("#inputRadio").find("input:radio").eq(1).click(function (){
				fixOuputRadio(false);
	    	});
	    	if("${ctp:escapeJavascript(pageType)}" == "browse"){
	    		fixInputRadio(true);
	    		fixOuputRadio(true);
	    	}else if("${ctp:escapeJavascript(pageType)}" == "editor"){
	    		//如果被引用枚举值不能 修改。其他可以修改
	    		if("${isRef}" == "Y"){
	    			$("#enumvalue").attr("disabled",true);
	    		}
	    		//系统枚举，修改的时候枚举显示名称和枚举显示值都不能修改(系统预置的不能修改)
	    		if("${tabType}" == 1 && "${isSysSet}" == "true"){
		    		$("#showvalue").attr("disabled",true);
		    		$("#enumvalue").attr("disabled",true);
		    		$("#showvalue").attr("readonly",true);
		    		$("#enumvalue").attr("readonly",true);
	    		}
	    		if($('input:radio[name="inputSwitch"]:checked').val() == 0){
	    			fixOuputRadio(false);
	    		}
	    	}
	    });
      //枚举图片回调函数
        function enumImageCallBk(filemsg){
            if(filemsg.instance!=null && filemsg.instance.length>0){
                var fileId = filemsg.instance[0].fileUrl;
                var fileName = filemsg.instance[0].filename;
                $("#imageUrl").attr("value",fileName);
                $("#imageId").val(fileId);
                $("#enumImageBrowse").attr("src","${path}/main/common/showImg.html?src=${path}/fileUpload.do?method=showRTE&fileId="+fileId+"&expand=0&type=image");
            }
        }
	  //禁用所有的input
	    function disabledAll(){
	    	if("${ctp:escapeJavascript(pageType)}" == "browse"){
	    		$("#enumItemArea").find("input:text").each(function (){
	    			$(this).attr("readonly",true);
	    			$(this).attr("disabled",true);
	    		});
                $("#imageUpload").prop("disabled",true);
	    	}
	    }
	  //禁用启用output按钮
	    function fixOuputRadio(obj){
	    	$("#outputRadio").find("input:radio").each(function (){
	    		$(this).attr("disabled",obj);
	    	});
	    	if($('input:radio[name="inputSwitch"]:checked').val() == 1){
	    		$("#outputRadio").find("input:radio").eq(0).attr("checked",true);
	    	}
	    }
	  //禁用启用input按钮
	    function fixInputRadio(obj){
	    	$("#inputRadio").find("input:radio").each(function (){
	    		$(this).attr("disabled",obj);
	    	});
	    }
	    //保持枚举项方法
	    function saveEnumItem(){
            if(chkstrlen($("#showvalue").val()) > 255){
                $.alert("枚举显示名称长度不能超过255！");
                $("#showvalue").focus();
                return false;
            }
	    	if($("#tableForm").validate()){
				var progress = $.progressBar();//显示滚动条，锁定页面，防止重复提交
	    		var em = new enumManagerNew();
	    		em.checkName($("#id").val(),$("#showvalue").val(),"${parentId}","${parentType}",0,3,{success:
					function(obj){
						if(!obj){
							em.checkItemValue($("#id").val(),$("#enumvalue").val(),"${parentId}","${parentType}",{success:
				    			function(obj1){
				    				if(!obj1){
				    					$("#tableForm").jsonSubmit({callback : function(data) { 
										    if(data!=undefined&&data!=null&&data!="")
											{
												progress.close();//无法提交，停止滚动条
												alert(data);
												return;
											}
				    						if($("#checkAdd").attr("checked")){
				    							parent.refreshPage($("#checkAdd").attr("checked"));
				    							 $("#showvalue").focus();
				    						}else{
												progress.close();//无法提交，停止滚动条
					    						$.infor({
					    		    			    'msg': '${ctp:i18n("common.successfully.saved.label")}!',
					    		    			     ok_fn: function () {
					    		    			    	 parent.refreshPage($("#checkAdd").attr("checked"));
					    		    			     }
					    		    			});
				    						}
				    					}});
				    					if(!$("#checkAdd").attr("checked")){
				    						$("#showvalue").blur();
				    					}
				    				}else{
										progress.close();//无法提交，停止滚动条
				    					$.alert("${ctp:i18n('metadata.enumitem.value.exist.message')}");
				    					$("#enumvalue").focus();
				    				}
				    			}	
				    		});
						}else{
							progress.close();//无法提交，停止滚动条
							$.alert("${ctp:i18n('metadata.enumname.exist.error.label')}!");
							$("#showvalue").focus();
						}
					}
				});
    		}
	    }
	    //更新枚举项
	    function updateEnumItem(){
	    	if($("#tableForm").validate()){
	    		var em = new enumManagerNew();
	    		em.checkItemValue($("#id").val(),$("#enumvalue").val(),"${parentId}","${parentType}",{success:
	    			function(obj1){
	    				if(!obj1){
	    					$("#tableForm").jsonSubmit({callback : function() { 
	    						$.infor({
	    		    			    'msg': '${ctp:i18n("common.successfully.saved.label")}!',
	    		    			     ok_fn: function () {
	    		    			    	 parent.refreshPage();
	    		    			     }
	    						});
				    		}});
	    				}else{
	    					$.alert("${ctp:i18n('metadata.enumitem.value.exist.message')}!");
	    					$("#enumvalue").focus();
	    				}
	    		}});
	    	}
	    }
	    //绑定页面回车事件
	    $("#tableForm :input").keydown(function(e){
			if(e.keyCode == 13) {
				$("#tableSubmit").focus();
				saveEnumItem();
		 	}
 		});
        //返回实际长度
        function chkstrlen(str){
            var strlen = 0;
            for(var i = 0;i < str.length; i++){
                if(str.charCodeAt(i) > 255)
                    strlen += 2;
                else strlen++;
            }
            return strlen;
        }
     </script>
</body>
</html>
