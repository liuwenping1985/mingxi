<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

</head>
<body>

	<form name="addForm" id="addForm" method="post" target="addDeptFrame">
	<div class="form_area" >
	
		<div class="one_row">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>					
					<input type="hidden" name="id" id="id" value="" />					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ntp.user.account')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="name" class="validate word_break_all" name="${ctp:i18n('ntp.user.account')}"
									validate="notNull:true,minLength:1,maxLength:85">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ntp.org.user.password')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="password" id="pwd" class="validate word_break_all" name="${ctp:i18n('ntp.org.user.password')}"
									validate="notNull:true,minLength:1,maxLength:20">
							</div>

						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ntp.user.mapper.provider')}:</label></th>						
						<td width="100%">
							<div>
								<select id="account" name="account" class="codecfg">
									<c:forEach var="providerList" items="${providerList}">
										<option value="${providerList.id}">${providerList.name}</option>
									</c:forEach>
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('ntp.user.mapper.bindingType')}:</label></th>						
						<td width="100%">
							<div>
								<c:choose>
										<c:when test="${ncbusinessEnable == 'true'}">
										
											<select  class="cursor-hand input-25per" name="type" id="type">
												<option value="NC">${ctp:i18n('ntp.user.mapper.bindingType.nc')}</option>
												<option value="NCBusiness">${ctp:i18n('ntp.user.mapper.bindingType.ncbusiness')}</option>							
											</select>
										</c:when>
										<c:otherwise>
											<select  class="cursor-hand input-25per" name="type" id="type">
												<option value="NC">${ctp:i18n('ntp.user.mapper.bindingType.nc')}</option>																			
											</select>			   		
										</c:otherwise>														  
								</c:choose>								
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('ntp.user.mapper.description')}:</label></th>
						<td>
							<div class="common_txtbox clearfix">
								<textarea rows="5" class="w100b validate word_break_all" id="description" validate="type:'string',name:'${ctp:i18n('common.description.label')}',notNull:false,maxLength:50,avoidChar:'!@#$%^&amp;*+'"></textarea>
							     <font color="green">${ctp:i18n('ntp.user.mapper.description.num')}</font>
							</div>
						</td>
					</tr>	
					<tr>
						<td align="right"></td>
					</tr>
				</tbody>
			</table>
		</div>
		</div>
	</form>


</body>
</html>