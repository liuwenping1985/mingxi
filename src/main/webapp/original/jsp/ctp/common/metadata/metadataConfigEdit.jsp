<%--
 $Author:  xiangq$
 $Rev:  280$
 $Date:: 2015-10-29 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<form id="metadata_column_form" name="metadata_column_form" method="post" action="">
	<div id="domain_metadata_column">
		<input type="hidden" id="column_id" name="column_id" value="-1"/>
		<input type="hidden" id="data_type" name="data_type" value=""/>
		<input type="hidden" id="column_rule" name="column_rule" value=""/>
		<input type="hidden" id="component" name="component" value=""/>
		<input type="hidden" id="table_id" name="table_id" value=""/>
		<input type="hidden" id="table_name" name="table_name" value=""/>
		<input type="hidden" id="create_user" name="create_user" value=""/>
		<input type="hidden" id="create_time" name="create_time" value=""/>
				
	    <table border="0" cellspacing="0" cellpadding="0" width="450px" align="center" class="font_size12">
            <tbody>
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text"><span class="color_red">*</span>${ctp:i18n('metadata.column.label')}：</label></th>
                <td width="100%">
                	<div class="common_txtbox_wrap">
                    	<input id="column_label" type="text" name="column_label" class="validate" validate="type:'string',name:'${ctp:i18n('metadata.column.label')}',notNull:true,minLength:1,maxLength:250,character:'-!@#$%^&*()_+'">
                	</div>
                </td>
            </tr>
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text"><span class="color_red">*</span>${ctp:i18n('metadata.column.name')}：</label></th>
                <td>
	                <div class="common_txtbox_wrap" id="column_name_div">
	                    <input id="column_name" type="text" name="column_name" class="validate" onfocus='this.blur();' validate="type:'string',name:'${ctp:i18n('metadata.column.name')}',notNull:true,minLength:1,maxLength:250,character:'-!@#$%^&*()+'">
	                </div>
                </td>
            </tr>
            <tr>
                <th nowrap="nowrap"><label class="margin_r_10" for="text"><span class="color_red">*</span>${ctp:i18n('metadata.column.alias')}：</label></th>
                <td>
	                <div class="common_txtbox_wrap">
	                    <input id="column_alias" type="text" name="column_alias" class="validate" validate="type:'string',name:'${ctp:i18n('metadata.column.alias')}',notNull:true,minLength:1,maxLength:250,character:'-!@#$%^&*()+'" />
	                </div>
                </td>
            </tr>
            <tr>
                <th nowrap="nowrap"> <label class="margin_r_10" for="text">${ctp:i18n('metadata.column.type')}：</label></th>
                <td>
	                <div class="common_selectbox_wrap">
	                    <select id="column_type" name="column_type" class="codecfg" codecfg="codeType:'java',codeId:'com.seeyon.ctp.common.metadata.enums.ColumnTypeEnum'"></select>
	                </div>
                </td>
            </tr>
            <tr id="tr_digit" class="data_type">
            	<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('metadata.column.decimal')}：</label></th>
	            <td>
	                <div class="common_txtbox_wrap">
						<input id="digit" type="text" name="digit" class="validate" value="0" validate="type:'number',name:'${ctp:i18n('metadata.column.decimal')}',notNull:true,isInteger:true">
		            </div>
	            </td>
        	</tr>
        	<tr id="tr_date_type" class="data_type">
            	<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('metadata.column.dateType')}：</label></th>
	            <td>
	                <div class="common_radio_box clearfix">
					    <label for="date_rd" class="margin_r_10 hand"><input type="radio" id="date_rd" name="date_type" class="radio_com" value="4" checked="checked">日期</label>
					    <label for="datetime_rd" class="margin_r_10 hand"><input type="radio" id="datetime_rd" name="date_type" class="radio_com" value="5">日期时间</label>
					</div>
	            </td>
        	</tr>
        	<tr id="tr_selected_enum" class="data_type">
            	<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('metadata.column.selected.enum')}：</label></th>
	            <td>
	                <div class="common_txtbox_wrap">
						<input id="enum_txt" type="text" name="enum_txt" value=""/>
						<input type="hidden" id="enum_value" name="enum_value" value=""/>
		            </div>
	            </td>
        	</tr>
        	<tr id="tr_person_control" class="data_type">
            	<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('metadata.column.controlType')}：</label></th>
	            <td>
	                <div class="common_radio_box clearfix">
					    <label for="person_rd" class="margin_r_10 hand"><input type="radio" id="person_rd" name="select_people_controltype" class="radio_com" value="6" checked="checked">${ctp:i18n('metadata.column.select.person')}</label>
					    <label for="department_rd" class="margin_r_10 hand"><input type="radio" id="department_rd" name="select_people_controltype" class="radio_com" value="7">${ctp:i18n('metadata.column.select.deparment')}</label>
						<label for="unit_rd" class="margin_r_10 hand"><input type="radio" id="unit_rd" name="select_people_controltype" class="radio_com" value="8">${ctp:i18n('metadata.column.select.unit')}</label>
					</div>
	            </td>
        	</tr>
        	<tr>
            	<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('metadata.column.status')}：</label></th>
	            <td>
	                <div class="common_radio_box clearfix">
					    <label for="normal_rd" class="margin_r_10 hand"><input type="radio" id="normal_rd" name="column_status" class="radio_com" value="1" checked="checked">${ctp:i18n('common.state.normal.label')}</label>
					    <label for="invalidation_rd" class="margin_r_10 hand"><input type="radio" id="invalidation_rd" name="column_status" class="radio_com" value="0">${ctp:i18n('common.state.invalidation.label')}</label>
					</div>
	            </td>
        	</tr>
        	<tr>
            	<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('metadata.column.isseach')}：</label></th>
	            <td>
	                <div class="common_radio_box clearfix">
					    <label for="yes_rd" class="margin_r_10 hand"><input type="radio" id="yes_rd" name="is_seach" class="radio_com" value="1">${ctp:i18n('common.yes')}</label>
					    <label for="no_rd" class="margin_r_10 hand"><input type="radio" id="no_rd" name="is_seach" class="radio_com" value="0" checked="checked">${ctp:i18n('common.no')}</label>
					</div>
	            </td>
        	</tr>
        	<tr>
                <th nowrap="nowrap"> <label class="margin_r_10" for="text">${ctp:i18n('metadata.column.category')}：</label></th>
                <td>
	                <div class="common_selectbox_wrap">
	                    <select id="category" name="category">
	                    </select>
	                    <input type="hidden" id="old_category" name="old_category" value=""/>
                    </div>
                </td>
            </tr>
            <tr>
            	<th nowrap="nowrap"><label class="margin_r_10" for="text"><span class="color_red">*</span>${ctp:i18n('metadata.column.sort')}：</label></th>
	            <td>
	                <div class="common_txtbox_wrap">
						<input id="sort_txt" type="text" name="sort_txt" class="validate" validate="type:'number',name:'${ctp:i18n('metadata.column.sort')}',notNull:true,isInteger:true,maxLength:3" value="1"/>
		            </div>
	            </td>
        	</tr>
        	<tr>
            	<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('metadata.column.repeat.number')}：</label></th>
	            <td>
	                <div class="common_radio_box clearfix">
					    <label for="insert_rd" class="margin_r_10 hand"><input type="radio" id="insert_rd" name="sort_type" class="radio_com" value="1" checked="checked">${ctp:i18n('common.toolbar.insert.label')}</label>
					    <label for="repeat_rd" class="margin_r_10 hand"><input type="radio" id="repeat_rd" name="sort_type" class="radio_com" value="0">${ctp:i18n('common.toolbar.repeat.label')}</label>
					</div>
	            </td>
        	</tr>
        	<tr>
        		<th nowrap="nowrap" valign="top" style="padding: 0px"><label class="margin_r_10" for="text">${ctp:i18n('metadata.column.description')}：</label></th>
        		<td>
					<div class="common_txtbox clearfix">
						<textarea id="description" name="description" rows="7" class="w100b validate" validate="type:'string',name:'${ctp:i18n('metadata.column.description')}',maxLength:100"></textarea>
					</div>
				</td>
            </tr>
        </tbody>
        </table>
	</div>
</form>