<%--
 $Author:  翟锋$
 $Rev: 1697 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<!DOCTYPE html>
<html class="h100b over_hidden" id='permisEdit' style='display:block;'>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>自定义续办方式</title>
    <script type="text/javascript" src="${path}/ajax.do?managerName=permissionManager"></script>
    <script type="text/javascript">
    	window.transParams = window.transParams || window.parent.transParams;//获取上一个页面传入参数
    	var customDealWith = window.transParams["customDealWith"];
    	var category =  "${category}";
    	var newEdoc = window.transParams["newEdoc"];
    	function OK(){
    		var arr = new Array();
    		if($("#permissionRange_check").attr("checked") == 'checked'){
    			if($("#permissionRange").val() == null || $("#permissionRange").val() == ""){
    				$.alert("请选择权限范围");
    				return;
    			}
    			arr.push($("#permissionRange").val());
    			arr.push($("#permissionRange_name").val());
    		}else{
    			arr.push("");
    			arr.push("");
    		}
    		if($("#returnTo_check").attr("checked") == "checked"){
    			arr.push($("input[name='returnTo']:checked").val());
    		}else{
    			arr.push("");
    		}
    		return arr.join("|");
    	}
    	$(document).ready(function(){
    		if(customDealWith != null && customDealWith != ''){
    			var arr = customDealWith.split("|");
    			if(arr[0] != null && arr[0] != ''){
    				$("#permissionRange_check").attr("checked",true);
    				$("#permissionRange").val(arr[0]);
    				$("#permissionRange_name").val(arr[1]);
    				$("#permissionRange_name").attr('disabled',false);
        			$("#permissionRange_name").bind("click",function(){
        				var dialog = $.dialog({
        	                url: _ctxPath + "/permission/permission.do?method=showPermisson&category="+category+"&newEdoc="+newEdoc+"&permissionRange="+$("#permissionRange").val(),
        	                width:670,
        	                height:450,
        	                title:"权限范围选择", 
        	                targetWindow:getCtpTop(),
        	                buttons : [{
        	                	text:"确定",
        	                	handler:function(){
        	                		var rv = dialog.getReturnValue();
        	                		if(rv != null){
        	                			$("#permissionRange").val(rv.id);
        	                			$("#permissionRange_name").val(rv.name);
    	    	                		dialog.close();
        	                		}
        	                	}
        	                },{
        	                    text : "${ctp:i18n('permission.close')}",//关闭
        	                    handler : function() {
        	                      dialog.close();
        	                    }
        	             	}]
        	           });
        			});
    			}
    			if(arr[2] != null && arr[2] != ''){
    				$("#returnTo_check").attr("checked",true);
    				$("input[name='returnTo'][value='"+arr[2]+"']").attr("checked",true);
    				$("input[name='returnTo']").each(function(){
    					$(this).attr("disabled",false);
    				});
    			}
    		}
    	});
    	function permissionRangeCheck(obj){
    		$("#permissionRange_name").attr('disabled',true);
    		$("#permissionRange_name").unbind("click");
    		if($(obj).attr("checked") == 'checked'){
    			$("#permissionRange_name").attr('disabled',false);
    			$("#permissionRange_name").bind("click",function(){
    				var dialog = $.dialog({
    	                url: _ctxPath + "/permission/permission.do?method=showPermisson&category="+category+"&newEdoc="+newEdoc+"&permissionRange="+$("#permissionRange").val(),
    	                width:670,
    	                height:450,
    	                title:"权限范围选择", 
    	                targetWindow:getCtpTop(),
    	                buttons : [{
    	                	text:"确定",
    	                	handler:function(){
    	                		var rv = dialog.getReturnValue();
    	                		if(rv != null){
    	                			$("#permissionRange").val(rv.id);
    	                			$("#permissionRange_name").val(rv.name);
	    	                		dialog.close();
    	                		}
    	                	}
    	                },{
    	                    text : "${ctp:i18n('permission.close')}",//关闭
    	                    handler : function() {
    	                      dialog.close();
    	                    }
    	             	}]
    	           });
    			});
    		}
    	}
    	function returnToChange(obj){
    		$("#returnTo_sendMember").attr('disabled',true);
    		$("#returnTo_currentMember").attr('disabled',true);
    		if($(obj).attr('checked') == 'checked'){
    			$("#returnTo_sendMember").attr('disabled',false);
        		$("#returnTo_currentMember").attr('disabled',false);
    		}
    	}
    	
    </script>
</head>
<body class="h100b over_hidden" >
	<table width="80%" class="font_size12 form_area margin_t_5 padding_t_5" style="table-layout: fixed;"  border="0" align="center">
		 <tr >
        	<td width="100" >
            	<input type="checkbox" onchange="permissionRangeCheck(this);" id="permissionRange_check" value="1" name="permissionRange_check" class="radio_com" >
            	<label for="permissionRange_check" class="margin_r_10 hand" >权限范围 :</label>
        	</td>
          	<td class="padding_5">
               	<input type="hidden" name="permissionRange" id = "permissionRange">
               	<textarea id="permissionRange_name" readonly="readonly" disabled="disabled" name="permissionRange_name" rows="4" cols="24"></textarea>
        	</td>
        </tr>
        <tr >
        	<td>
            	<input type="checkbox" id="returnTo_check" value="1" onchange="returnToChange(this);" name="returnTo_check" class="radio_com" >
            	<label for="returnTo_check" class="margin_r_10 hand" style="margin-right:0">提交后返回 </label>
        	</td>
          	<td class="padding_5">
          		<label>	<input type="radio" disabled="disabled" checked="checked" id="returnTo_sendMember"  name="returnTo" value="sendMember" class="radio_com">发起人 </label>
          		<label>	<input type="radio" disabled="disabled" name="returnTo" id="returnTo_currentMember" value="currentMember" class="radio_com">当前节点执行人</label>
        	</td>
        </tr>
	</table>
</body>
</html>
