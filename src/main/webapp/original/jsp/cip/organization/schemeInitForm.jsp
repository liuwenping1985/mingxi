<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

</head>
<body>

	<form name="addForm" id="addForm" method="post" target="delIframe">
	<div class="form_area" >
		<div class="one_row" style="width:60%;">
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<input type="hidden" name="id" id="id" value="" />			
					<input type="hidden" id="filterJson" value="" >
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.scheme.param.init.sync')}:</label></th>
						<td width="100%" colspan="3">
							<div class="common_selectbox_wrap">
								<select id="schemeId">
								</select>
							</div>
						</td>
					</tr>	
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.init.third')}:</label></th>
						<td width="100%" colspan="3">
							<div class="common_txtbox_wrap">
								<input type="text" id="thirdSystem" readonly="readonly">	
							</div>
						</td>
					</tr>				
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.scheme.param.init.sys')}:</label></th>
						<td width="100%" colspan="3">
							<div class="common_txtbox_wrap">
								<input type="text" id="entityId" class="comp validate" readonly="readonly" comp="type:'selectPeople',mode:'open',panels:'Account,Department',selectType:'Account,Department',maxSize:'1',showMe:false,returnValueNeedType:false,callback:entityCallBack"
									validate="type:'string',name:'${ctp:i18n('cip.scheme.param.init.sys')}',notNull:true,minLength:1,maxLength:85">
							</div>
							<input type="hidden" id="entityId_2" value="">
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.scheme.param.init.thirdsys')}:</label></th>
						<td width="100%" colspan="3">
							<div class="common_txtbox_wrap">
								<input type="text" id="thirdOrgname" class="validate word_break_all" readonly="readonly"
									validate="type:'string',name:'${ctp:i18n('cip.scheme.param.init.thirdsys')}',notNull:true,minLength:1,maxLength:85">	
							</div>
							<input type="hidden" id="thirdOrgid" value="">
							<!-- 第三方系统组织类型 -->
							<input type="hidden" id="extAttr1" value="">
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.scheme.param.init.range')}:</label></th>
						<td width="100%" colspan="3">
							<div class="common_checkbox_box clearfix ">
							    <label for="department" class="hand" style="margin-right: 25px;">
							        <input type="checkbox" value="1" id="department" name="scope" class="radio_com">${ctp:i18n('cip.scheme.param.init.dept')}</label>
							    <label for="people" class="hand" style="margin-right: 25px;">
							        <input type="checkbox" value="1" id="people" name="scope" class="radio_com">${ctp:i18n('cip.scheme.param.init.user')}</label>
							    <label for="post" class="hand" style="margin-right: 25px;">
							        <input type="checkbox" value="1" id="post" name="scope" class="radio_com">${ctp:i18n('cip.scheme.param.init.post')}</label>
							    <label for="level" class="hand">
							        <input type="checkbox" value="1" id="level" name="scope" class="radio_com">${ctp:i18n('cip.scheme.param.init.duty')}</label>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('cip.scheme.param.init.managerandsecond') }:</label></th>
						<td width="100%" colspan="3">
							<div class="common_selectbox_wrap">
								<select id="increortotal">
									<option value="1" selected="selected">${ctp:i18n('cip.scheme.param.init.mode.append') }</option>
									<option value="0">${ctp:i18n('cip.scheme.param.init.mode.override') }</option>
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"></label></th>
						<td width="100%" colspan="3">
							<div class="common_txtbox_wrap" style="border: 0px; margin-top: 5px;margin-bottom: 5px;">
								${ctp:i18n('cip.scheme.param.init.mode.message') }
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.init.filter')}:</label></th>
						<td width="100%" colspan="3">
							<span style="color: #62C4EF;margin-right: 20px;" id="filter_config">${ctp:i18n('cip.scheme.param.init.filter')}</span>
							<label for="isFilter" class="hand">
							<input type="checkbox" value="1" id="isFilter" name="isFilter" class="radio_com">${ctp:i18n('cip.scheme.param.init.ison')}</label>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap" valign="top"><label class="margin_r_10" for="text">${ctp:i18n('cip.scheme.param.init.userdef')}:</label></th>
						<td width="100%" colspan="3">
							<table border="0" cellspacing="0" cellpadding="0" class="only_table" style="margin-top: 5px; width: 100%;" >
								<tbody>
									<tr bgcolor="#B5DBEB">
						        		<td width="25%">${ctp:i18n('cip.scheme.param.init.postdef')}</td>
						        		<td width="25%">${ctp:i18n('cip.scheme.param.init.dutydef')}</td>
						        		<td width="25%">${ctp:i18n('cip.scheme.param.init.passdef')}</td>
						        		<td width="25%">${ctp:i18n('cip.scheme.param.init.affdef')}</td>
						        	</tr>
						        	<tr>
						        		<td>
						        			<div class="common_txtbox_wrap" style="border: 0px;">
												<input type="text" id="defPost" class="validate word_break_all"
													validate="type:'string',name:'${ctp:i18n('cip.scheme.param.init.postdef')}',notNull:false,minLength:1,maxLength:85">	
											</div>
						        		</td>
						        		<td>
						        			<div class="common_txtbox_wrap" style="border: 0px;">
												<input type="text" id="defLevel" class="validate word_break_all"
													validate="type:'string',name:'${ctp:i18n('cip.scheme.param.init.dutydef')}',notNull:false,minLength:1,maxLength:85">	
											</div>
						        		</td>
						        		<td>
						        			<div class="common_txtbox_wrap" style="border: 0px;">
												<input type="text" id="defPwd" class="validate word_break_all" 
													validate="type:'string',name:'${ctp:i18n('cip.scheme.param.init.passdef')}',notNull:false,minLength:1,maxLength:85,regExp:'^[0-9a-zA-Z_“_+&!#^~@”]+$'">	
											</div>
						        		</td>
						        		<td>
						        			<div class="common_txtbox_wrap" style="border: 0px;">
												<input type="text" id="defOwner" class="validate word_break_all"
													validate="type:'string',name:'${ctp:i18n('cip.scheme.param.init.affdef')}',notNull:true,minLength:1,maxLength:85">	
											</div>
										</td>
						        	</tr>
								</tbody>
							</table>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		</div>
	</form>
</body>
</html>