<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

</head>
<body>

	<form name="addForm" id="addForm" method="post" target="addDeptFrame">
	<div class="form_area" >
	
		<div class="one_row" style="width:50%;">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<br>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<input type="hidden" name="id" id="id" value="" />					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountCfg.type')}:</label></th>
						<td width="50%">
							<div style="width:100%;">
								<select id="type" name="type" class="w100b">						
									<c:forEach var="type" items="${type}" varStatus="status">
										<c:choose>
       										<c:when test="${status.index==0}">
             									<option value="${type.value}" selected="selected">${type.value}</option>
       										</c:when>
									       <c:otherwise>
									            <option value="${type.value}">${type.value}</option> 
									       </c:otherwise>
										</c:choose>
									</c:forEach>
																	
								</select>								
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountCfg.name')}:</label></th>
						<td width="50%">
							<div class="common_txtbox_wrap">
								<input type="text" id="name" class="validate word_break_all" name="name"
									validate="notNull:true,minLength:1,name:'${ctp:i18n('voucher.plugin.cfg.accountCfg.name')}',maxLength:85">
							</div>
						</td>
					</tr>					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountCfg.url')}:</label></th>
						<td width="50%">
							<div class="common_txtbox_wrap">
								<input type="text" id="address" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('voucher.plugin.cfg.accountCfg.url')}',notNull:true,minLength:1,maxLength:85,avoidChar:'-!@#$%><^&amp;*()_+',regExp:/^(http|https):\/\/[a-zA-Z0-9]+[.]+[a-zA-Z0-9]+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])*$/">	
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountCfg.code')}:</label></th>
						<td width="50%">
							<div class="common_txtbox_wrap">
								<input type="text" id="code" class="validate word_break_all" name="code"
									validate="notNull:true,minLength:1,name:'${ctp:i18n('voucher.plugin.cfg.accountCfg.code')}',maxLength:16">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountCfg.exSystemCode')}:</label></th>
						<td width="50%">
							<div class="common_txtbox_wrap">
								<input type="text" id="extCode" class="validate word_break_all" name="extCode"
									validate="notNull:true,minLength:1,name:'${ctp:i18n('voucher.plugin.cfg.accountCfg.exSystemCode')}',maxLength:16">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountCfg.currencyCode')}:</label></th>
						<td width="50%">
							<div class="common_txtbox_wrap">
								<input type="text" id="currencyCode" class="validate word_break_all" name="currencyCode"
									validate="notNull:true,minLength:1,name:'${ctp:i18n('voucher.plugin.cfg.accountCfg.currencyCode')}',maxLength:16">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountCfg.dbType')}:</label></th>
						<td width="50%"> 
							<div class="common">
								<select id="dbType" name="dbType" class="w100b" validate="notNull:true,minLength:1,maxLength:85">
									<option value="" selected="selected">${ctp:i18n('voucher.plugin.cfg.accountCfg.pleaseSelect')}</option>
									<c:forEach var="dbType"  items="${driverType}">
										<option value="${dbType.driver}">${dbType.dbName}</option>
									</c:forEach>
								</select>
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountCfg.dbUrl')}:</label></th>
						<td width="50%">
							<div class="common_txtbox_wrap">
								<input type="text" id="dbUrl" class="validate word_break_all" name="dbUrl"
									validate="notNull:true,minLength:1,name:'${ctp:i18n('voucher.plugin.cfg.accountCfg.dbUrl')}',maxLength:160">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountCfg.dbUser')}:</label></th>
						<td width="50%">
							<div class="common_txtbox_wrap">
								<input type="text" id="dbUser" class="validate word_break_all" name="dbUser"
									validate="notNull:true,minLength:1,name:'${ctp:i18n('voucher.plugin.cfg.accountCfg.dbUser')}',maxLength:16">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountCfg.dbPwd')}:</label></th>
						<td width="50%">
							<div class="common_txtbox_wrap">
								<input type="password" id="dbPassword" name="dbPassword"
									validate="type:'string',notNull:true,name:'${ctp:i18n('voucher.plugin.cfg.accountCfg.dbPwd')}',maxLength:16">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red"></font>&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('voucher.plugin.cfg.accountCfg.isDefaultAccount')}:</label></th>
						<td>
							<div>
								<input type="checkbox" id="isDefault" name="isDefault">
								
							</div>
						</td>
					</tr>
					<tr id="bookTr">
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('voucher.plugin.cfg.accountCfg.isSupportMore')}:</label></th>
						<td width="50%">
							<div>
								<input type="checkbox" id="isSupportBooks" name="isSupportBooks">
							</div>
						</td>
						<th id="bookName1" nowrap="nowrap" style="display:none"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.accountCfg.defaultBook')}:</label></th>
						<td id="bookName2" width="50%" style="display:none">
							<div class="common_txtbox_wrap">
								<input type="text" id="bookName" readonly="readonly" class="validate word_break_all" name="bookName"
									validate="notNull:true,minLength:1,name:'${ctp:i18n('voucher.plugin.cfg.accountCfg.defaultBook')}',maxLength:85">
							</div>
						</td>
					</tr>
					<tr>
						<td > 
							<input type="hidden" id="bookCode" name="bookCode" value="">
							<input type="hidden" id="extAttr1" name="extAttr1" value="">
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		</div>
	</form>


</body>
</html>