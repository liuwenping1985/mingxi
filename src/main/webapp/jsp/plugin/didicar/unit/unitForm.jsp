<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<form name="addForm" id="addForm" method="post" target="">
<div class="form_area" >
	<div class="one_row" style="width:50%;">
		<br>
		<table border="0" cellspacing="0" cellpadding="0">
			<tbody>					
				<tr>
					<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font><c:if test="${from=='group'}">${ctp:i18n('didicar.plugin.unit.authorization.account.name')}</c:if><c:if test="${from!='group'}">${ctp:i18n('didicar.plugin.unit.authorization.dept.name')}</c:if>:</label></th>
					<td width="100%">
						<div class="common_txtbox  clearfix">
                               <textarea rows="5" id="unitName" style="width:60%" class="validate" readonly="readonly" validate="notNull:true,name:'<c:if test="${from=='group'}">${ctp:i18n('didicar.plugin.unit.authorization.account.name')}</c:if><c:if test="${from!='group'}">${ctp:i18n('didicar.plugin.unit.authorization.dept.name')}</c:if>'"></textarea>
                               <input type="hidden" id="id" name="id" value="-1">
						</div>
					</td>
				</tr>
				<tr id="optiontr" class="hidden">
					<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('didicar.plugin.unit.option')}:</label></th>
					<td width="100%" nowrap="nowrap">
						<div class="common_radio_box clearfix">
							<label for="recharge" class="margin_r_30 hand"><input type="radio" value="0" id="recharge" name="option" class="radio_com" checked="checked">${ctp:i18n('didicar.plugin.unit.recharge')}</label>
							<label for="back" class="hand"><input type="radio" value="1" id="back" name="option" class="radio_com">${ctp:i18n('didicar.plugin.unit.take.back') }</label>     
						</div> 
					</td>
				</tr>
				<tr>
					<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('didicar.plugin.unit.allocated.amount')}:</label></th>
					<td width="100%">
                        <div style="width: 30%;margin-left: 0px;">
                        	<div class="common_txtbox clearfix">
	                        	<div class="common_txtbox_wrap">
		                         	<input type="text" style ='height:18px' id="money" class="validate" validate="isInteger:true,min:0,notNull:true,name:'${ctp:i18n('didicar.plugin.unit.allocated.amount')}'" />
	                        	</div>
                        	</div>
                        </div>
					</td>
				</tr>
				<tr>
					<td align="left"></td>
				</tr>
			</tbody>
		</table>
	</div>
	</div>
</form>