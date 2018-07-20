<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<table>
<tr>
	<td rowspan="2" width="1%" nowrap="nowrap">
		<a id='sendId'  class="margin_lr_10 display_inline-block align_center new_btn">${ctp:i18n('infosend.draft.send')}<!-- 发送 --></a>
	</td>
	
	<th nowrap="nowrap" width="1%" class='bgcolor align_right'>${ctp:i18n('infosend.magazine.list.condition.subject')}<!-- 期刊名称 -->：</th>
	<td width="25%">
		<div class="common_txtbox_wrap margin_l_5">
             <input readonly="readonly" class="w100b validate" type="text" id="process_info"
	            defaultValue="${ctp:i18n('collaboration.default.workflowInfo.value')}"
	            <c:choose><c:when test="${((onlyViewWF && isSystemTemplete) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) && nonTextTemplete || subState eq '16'}">disabled</c:when><c:otherwise>style="color: black;"</c:otherwise></c:choose>
	            value="<c:out value='${contentContext.workflowNodesInfo}'></c:out>" name="process_info" title="${ctp:i18n('collaboration.newcoll.clickforprocess')}"/>
		</div>
	</td>
   
   <th nowrap="nowrap" width="1%" class='bgcolor padding_l_10 align_right'>${ctp:i18n('infosend.magazine.create.configuration')}<!-- 期刊内容： --></th>
	<td>
		<div class="common_txtbox_wrap margin_l_5">
             <input class="w100b validate" type="text" value=""/>
		</div>
	</td>
	
	<th nowrap="nowrap" width="1%" class='bgcolor padding_l_10 align_right'>${ctp:i18n('infosend.magazine.label.audit')}:<!-- 审核： --></th>
	<td class="padding_r_10">
		<div class="common_checkbox_box clearfix ">
			<label class="margin_r_10 hand" for="radio_notAudit">
                <input id="radio_notAudit" checked="checked" name="audit" value="0" type="radio" class="radio_com">${ctp:i18n('infosend.magazine.create.notAudited')}<!-- 不审核 -->
            </label>
            <label class="margin_r_10 hand" for="radio_Audit">
                <input id="radio_Audit" name="audit" value="0" type="radio" class="radio_com">${ctp:i18n('infosend.magazine.label.audit')}<!-- 审核 -->
            </label>
            <input id="auditer" name="auditer" type="text" value=""/>
		</div>
	</td>

</tr>

<tr>

	<th nowrap="nowrap" width="1%" class='bgcolor align_right'>${ctp:i18n('infosend.magazine.label.issue')}<!-- 期号 -->：</th>
	<td width="25%">
		<div class="common_txtbox_wrap margin_l_5">
			<input class="w100b validate" type="text" value=""/>
		</div>
	</td>
	
	<th nowrap="nowrap" width="1%" class='bgcolor align_right'>${ctp:i18n('infosend.magazine.create.publishingLayout')}<!-- 发布版式： --></th>
	<td>
		<div class="common_selectbox_wrap margin_l_5 ">
            <select>
            	<option>${ctp:i18n('infosend.magazine.create.selectPublishingLayout')}<!-- --请选择发布版式-- --></option>
            	<option>专刊版式</option>
            </select>
        </div>
	</td>
	
	<th nowrap="nowrap" width="1%" class='bgcolor padding_l_10 align_right'>${ctp:i18n('infosend.magazine.create.selectPublishRange')}<!-- 选择发布范围： --></th>
	<td class="padding_r_10">
		<div class="common_txtbox_wrap margin_l_5">
			<input class="w100b validate" type="text" value=""/>
		</div>
	</td>

</tr>
 

</table>
