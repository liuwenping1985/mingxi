<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="include/form_taglib.jsp" %>
<%@ include file="create.js.jsp" %>
<html class="h100b over_hidden">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=govformAjaxManager"></script>
<c:set value="${currentUser.loginAccount==formVO.domainId}" var="isMyDomain" />
<style>
<c:if test="${param.editFlag=='true' }">
.stadic_body_top_bottom{
    top: 0px;
    bottom: 40px;
}
.stadic_footer_height{
    height:40px;
}
</c:if>
<c:if test="${param.editFlag!='true' }">
.stadic_body_top_bottom{
    top: 0px;
    bottom: 0px;
}
</c:if>
.stadic_right{
    float:right;
    width:100%;
    height:100%;
    position:absolute;
    z-index:100;
    min-width: 1070px;
}
.stadic_right .stadic_content{
    overflow:auto;
    margin-left:230px;
    height:100%;
}
.stadic_left{
    float:left; 
    width:225px; 
    height:100%;
    position:absolute;
    z-index:300;
    border:1px;
}
.stadic_right {
	height:100%;
}

.categorySet-body-govform{
	border-left: solid 1px #a0a0a0;
	border-right: solid 1px #a0a0a0;
	border-bottom: solid 1px #a0a0a0;
	border-top: solid 1px #a0a0a0;
	padding: 10px;
	margin: 0px;
	float: left;
	clear: left;
}
.h100b{height:100%;}

.my-x-fieldset{border:1px solid #B5B8C8;padding:10px;margin-bottom:10px;display:block;}

</style>
</head>

<body class="h100b over_hidden page_color">
<div id='layout' class="comp" comp="type:'layout'">
<div class="layout_center" layout="border:false">
<form id="dataForm" name="dataForm" method="post" action="">
<input type="hidden" name="att_fileUrl" id="att_fileUrl" value="${ctp:toHTML(att_fileUrl)}">
<input type="hidden" name="att_createDate" id="att_createDate" value="${ctp:toHTML(att_createDate)}">
<input type="hidden" name="att_mimeType" id="att_mimeType" value="${ctp:toHTML(att_mimeType)}">
<input type="hidden" name="att_filename" id="att_filename" value="${ctp:toHTML(att_filename)}">
<input type="hidden" name="att_needClone" id="att_needClone" value="${ctp:toHTML(att_needClone)}">
<input type="hidden" name="att_description" id="att_description" value="${ctp:toHTML(att_description)}">
<input type="hidden" name="att_type" id="att_type" value="${ctp:toHTML(att_type)}">
<input type="hidden" name="att_size" id="att_size" value="${ctp:toHTML(att_size)}">
<input type="hidden" id="file_name" name="file_name" value="">
<input type="hidden" id="attachmentStr" name="attachmentStr" value="">
<input type="hidden" id="formId" name="formId" value="${formVO.id }" />
<input type="hidden" id="content" name="content" value="" />
<input type="hidden" id="appType" name="appType" value="${appType }" /> 	
<input type="hidden" id="isSystem" name="isSystem" value="${formVO.isSystem }" />
<input type="hidden" id="element_id_list" name="element_id_list" value="${element_id_list}" />
<input type="hidden" id="editFlag" name="editFlag" value="${ctp:toHTML(param.editFlag)}" />
<input type="hidden" id="optionFormatSet" name="optionFormatSet" value="${ctp:toHTML(formVO.optionFormatSet)}" />

<div id="attachmentInputs" style="display:none"></div>

<div class="stadic_layout_body stadic_body_top_bottom clearfix" style="height: 100%;">
	
	<div class="stadic_left">
  		<%@ include file="form_property.jsp" %>
	</div><!-- stadic_left -->
       	
    <div class="stadic_right" style="overflow:hidden">
    	<div class="stadic_content" style="overflow:hidden;width:80%;">
           <div class="common_tabs clearfix">
				<ul class="left border_r">
					<li id="formShow" class="current"><a class="no_b_border" style="max-width:120px;" hidefocus="true" href="javascript:void(0)">${ctp:i18n('govform.label.formcreat.formpre')}<!-- 报送单样式预览 --></a></li>
                    <li id="formSet"><a class="no_b_border" style="max-width:120px;" hidefocus="true" href="javascript:void(0)">${ctp:i18n('govform.label.formcreat.flowperm.bound')}<!-- 意见元素设置 --></a></li>
				</ul>
			</div>
			
			<div id="formDiv" style="margin-right:10px;">
				<div id="fieldOne" class="border_all bg_color_white over_hidden">
				<table id="formTable1" class="font_size12 form_area margin_l_5 margin_r_5 margin_t_5 w100b" align="center">
					<tr>
				    	<td class="align_left">
				    		 <span id="downFormDiv"></span>
				    		<span id="shu" style="padding:5px;">|</span>
				    		<span id="upFormDiv">
				    			<a id="upForm" class="color_blue margin_l_5" onmouseout="onmouseoutA(this)" onmouseover="onmouseoverA(this)" onClick="newUploadForm();" href="javascript:void(0)">${ctp:i18n('fileupload.infoform.send')}<!-- 上传报送单 --></a>
				    		</span>
					    	<div id="attachmentTRAtt" style="display:none;">
					        	<table border="0" cellspacing="0" cellpadding="0" width="100%" class="line_height180">
					            	<tr id="attList" style="display:none;">
					                	<td width="3%">&nbsp;</td>
					                    <td class="align_right"  style="display:none;" valign="top" width="88" nowrap="nowrap"><div class="div-float" >${ctp:i18n('common.attachment.label')}：(<span id="attachmentNumberDivAtt"></span>) </div></td>
					                    <td class="align_left" style="display:none;">
					                    	<div id="attFileDomain"  class="comp" comp="type:'fileupload',attachmentTrId:'Att',applicationCategory:'${appType }',extensions:'xsn',quantity:'1',callMethod:'insertAtt_attEditCallback',takeOver:false"></div>
					                    </td>
					            	</tr>
					            </table>
					         </div>
				        </td><%--权限名称 --%>
				   	</tr>
				    <tr>
				    	<td>
					    	<div id="fieldset" style="position: relative;top: 0;left: 0; z-index: 10" class="margin_l_5 margin_r_5 margin_t_10 margin_b_10 my-x-fieldset" align="center">
					    	<div style="text-align: left;position: absolute;top: -10px;left: 10px;z-index: 11px;filter:alpha(opacity=100);opacity: 1.0;background-color: #fff;"><span><strong>${ctp:i18n('govform.label.formcreat.infoform')}<!-- 报送单 -->${ctp:i18n(msgType)}${ctp:i18n('common.lable.preview.prefix')}</strong></span></div>
					      		<%@ include file="form_show.jsp" %>
							</div>
						</td>
				   	</tr>
				</table>
				</div>
				
				<div id="fieldTwo" style="display:none" class="border_all bg_color_white over_hidden w100b">
					<%@ include file="form_setting.jsp" %>
				</div>
				
			</div>
        </div><!-- stadic_content -->
    </div><!-- stadic_right -->
       	
</div><!-- stadic_layout_body -->
</form>
</div><!-- layout_center div -->
<div class="layout_south" layout="height:40,maxHeight:40,minHeight:40,border:false,sprit:false">
<c:if test="${param.editFlag =='true' }">
<div class="stadic_layout_footer stadic_footer_height">
	<div class="common_checkbox_box align_center clearfix padding_t_5 border_t">
	   <a href="javascript:void(0)" class="common_button common_button_gray" id="edit_confirm_button">${ctp:i18n('permission.confirm')}</a>&nbsp;<%--确定 --%>
	   <a href="javascript:void(0)" class="common_button common_button_gray" id="edit_cancel_button">${ctp:i18n('permission.cancel')}</a><%--取消 --%>
	</div>
</div><!-- stadic_layout_footer -->
</c:if>

<div class="hidden">
	<iframe id="temp_iframe" name="temp_iframe">&nbsp;</iframe>
</div>
</div><!-- layout_south -->
</div><!-- layout div -->
</body>
</html>

