<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="include/element_header.jsp"%>
<c:set value="${ctp:i18n('element.info.lable.defultDropDownV')}" var="defaultValue" /><!-- --选择下拉列表定义-- -->
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>元素查看</title>
<style>
	<c:if test="${param.editFlag=='true' }">
		.stadic_head_height { height:180px; }
    </c:if>
    <c:if test="${param.editFlag!='true' }">
    	.stadic_head_height { height:180px; }
    </c:if>
</style>
</head>
<script type="text/javascript">
$(document).ready(function () {

	if($("#enumName").val()=="") {
		$("#enumName").val('${defaultValue}');
	}
	$("#edit_confirm_button").click(function() {
		if("${ctp:escapeJavascript(param.editFlag)}" === 'true'){
			submitElement();
        }
	});
	$("#edit_cancel_button").click(refreshW);
	//OA-61731ie7下，新建、修改报送单元素没有确定取消按钮；by jianghu
	if($.v3x.isMSIE7){
		$("#bottomButton").attr("style","margin-bottom:20px;");
	}
});

function submitElement() {
	// 防止重复提交
	var fValidate = $("#elementForm").validate();
	if(fValidate){
		$("#edit_confirm_button").attr('disabled','disabled').attr("href","javascript:;").attr("onclick","javascript:;").css("color","#ccc");
	}
    //表单提交
    var form = $("#elementForm");
    var path = _ctxPath + "/element/element.do?method=updateElement";
    form.attr('action', path);
    form.jsonSubmit({
        validate : true,
        errorIcon : true,
        callback : function(args) {
        //OA-61676
         	if(args != "true" && args != "<PRE>true</PRE>") {//<PRE>true</PRE>兼容 ie7
         		alert(args);
         	}else{
				refreshW();
            }
        }
    });

}

//刷新父页面
function refreshW() {
	parent.location.reload();
}

function selectbind() {
	var obj = new Array();
  	obj[0] = window;
  	var dialog = $.dialog({
    	url:"${path}/enum.do?method=bindEnum&isfinal=0",
        title : '${ctp:i18n("form.field.bindenum.title.label")}',
        width:500,
    	height:520,
    	targetWindow:top,
   		transParams:obj,
        buttons : [{
          	text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",
          	btnType : 1,//按钮样式
          	id:"sure",
          	handler : function() {
              	var result = dialog.getReturnValue();
              	if(result){
              		$("#enumId").val(result.enumId);
              		$("#enumName").val(result.enumName);
                	dialog.close();
              	}
          	}
      	}, {
          	text : "${ctp:i18n('form.query.cancel.label')}",
          	id:"exit",
          	handler : function() {
            	 dialog.close();
          	}
        }]
	});
}

</script>
<body class="h100b ${param.editFlag!='true' ?'':'over_hidden'}">

<div class="stadic_layout_head stadic_head_height form_area  ${param.editFlag!='true' ?'over_hidden':''}" style="${param.editFlag!='true' ?'overflow:hidden;':'overflow:auto;'}" id="content">
<form id="elementForm" class="align_center">
<input id="id" name="id" value="${elementVO.element.id }" type="hidden" />
<input id="isSystem" name="isSystem" value="${elementVO.element.isSystem }" type="hidden" />
<input id="elementId" name="elementId" value="${elementVO.element.elementId }" type="hidden" />
<input id="inputMode" name="inputMode" value="${elementVO.element.inputMode }" type="hidden" />
<input id="type" name="type" value="${elementVO.element.type }" type="hidden" />
<input id="enumitemId" name="enumitemId" value="${elementVO.element.enumitemId }" type="hidden" />
<input id="domainId" name="domainId" value="${elementVO.element.domainId }" type="hidden" />
<input id="appType" name="appType" value="${elementVO.element.appType }" type="hidden" />

<c:set value='${elementVO.element.isSystem||param.editFlag!="true"}' var="canEditElement" />

<table border="0" cellSpacing="0" cellPadding="0" width="500" align="center">
	<tbody>
		<tr>
          	<th noWrap><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('element.column.name')}:</label></th>
          	<td class="w100b">
            	<div class="common_txtbox_wrap" ${canEditElement ? "disabled='true'":"" }>
            		<input id="name" name="name" type="text" ${canEditElement ? "readonly='true'":"" } value="${ctp:toHTMLWithoutSpace(elementVO.subject)}" ${(elementVO.element.isSystem||param.editFlag!="true")?"":" class='validate' "} validate="type:'string',name:'${ctp:i18n('element.column.name')}',notNull:true,maxLength:85,avoidChar:'!@#$%^&\'*+()'" /><!-- 元素名称 -->
            	</div>
          	</td>
        </tr>
        <tr>
          	<th noWrap><label class="margin_r_10" for="text">${ctp:i18n('element.column.code')}:</label></th>
          	<td class="w100b">
            	<div class="common_txtbox_wrap" disabled="true">
            		<input id="fieldName" type="fieldName" value="${elementVO.fieldName }" readonly="true"/>
            	</div>
          	</td>
        </tr>
        <tr>
          	<th noWrap><label class="margin_r_10" for="text">${ctp:i18n('element.column.currentstate')}:</label></th>
          	<td>
            	<div class="common_selectbox_wrap" ${param.editFlag=="true"?"":"disabled='true'" }>
              		<select id="status" name="status" class="w100b validate word_break_all" validate="name:'${ctp:i18n('element.column.currentstate')}',notNull:true"><!-- 当前状态 -->
                		<option ${elementVO.element.status==1 ? "selected='selected'" : "" } value="1">${ctp:i18n('infosend.status.enable')}<!-- 启用 --></option>
                		<option ${elementVO.element.status==0 ? "selected='selected'" : "" } value="0">${ctp:i18n('infosend.status.disable')}<!-- 停用 --></option>
              		</select>
            	</div>
          	</td>
 		</tr>
        <tr>
          	<th noWrap><label class="margin_r_10" for="text">${ctp:i18n('element.column.datatype')}:</label></th>
          	<td>
            	<div class="align_left">
            		<label class="margin_r_10" for="text">${elementVO.dataType }</label>
				</div>
          	</td>
        </tr>
        <c:if test="${elementVO.element.type=='5'}">
		<tr>
			<td class="bg-gray" align="right" width="25%"><font color="red">*</font>${ctp:i18n('infosend.label.defSelectOptions')}<!-- 下拉列表定义: --></td>
			<td class="value" align="left">
				<div class="common_txtbox_wrap">
					<input type="text"  id="enumName"  name="enumName" class="cursor-hand input-50per" onclick="selectbind()" value="${elementVO.enumName}" readonly="true" ${(elementVO.element.isSystem||param.editFlag!='true')?'disabled':'' }>
					<input type="hidden"  id="enumId" name="enumId" value = "${elementVO.element.enumitemId}">
				</div>
			</td>
		</tr>
		</c:if>
        <tr>
          	<th noWrap><label class="margin_r_10" for="text">${ctp:i18n('element.column.elementtype')}:</label></th>
          	<td>
            	<div class="common_txtbox_wrap" disabled="true">
            		<input type="text" value="${elementVO.elementType }" readonly="true" />
				</div>
          	</td>
        </tr>
      </tbody>
</table>
</form>
</div><!-- stadic_layout_body -->

<c:if test="${param.editFlag=='true' }">
<div class="stadic_layout_footer stadic_height_footer" id="bottomButton">
    <div id="button" align="center" class="page_color button_container">
        <a href="javascript:void(0)" class="common_button common_button_gray" id="edit_confirm_button">${ctp:i18n('permission.confirm')}</a>&nbsp;<%--确定 --%>
    	<a href="javascript:void(0)" class="common_button common_button_gray" id="edit_cancel_button">${ctp:i18n('permission.cancel')}</a><%--取消 --%>
	</div>
</div>
</c:if>

</body>
</html>