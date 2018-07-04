<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<style type="text/css">
<!--
.iconArea {
	float: left;
	border: 1px solid #CCC;
	height: 75px;
	width: 75px;
}

.iconBtn {
	float: left;
	margin-top: 52px;
}

.tipssign {
	color: red;
}
-->
</style>

<body>
	<form name="addForm" id="addForm" method="post" target="addDeptFrame" action = "${path}/cmp/appMgr.do?method=saveAttachment">
		<div class="form_area">
			<div class="one_row">
				<p class="align_right">
					<font color="red">*</font>${ctp:i18n('org.form.must')}
				</p>
				<table border="0" cellspacing="0" cellpadding="0">
					<tbody>
						<input type = "hidden" id = "id" name = "id">
						<tr>
							<th nowrap="nowrap">
								<label class="margin_r_10" for="text"><span class="tipssign">*</span>${ctp:i18n('cmp.appMgr.form.label.appName')}:</label>
							</th>
							<td width="100%" colspan="2">
			            		<div class="common_txtbox_wrap">
				            		<input type="text" name="fullname" id="fullname" class="validate word_break_all"
				                 		validate="type:'string',name:'${ctp:i18n('cmp.appMgr.form.label.appName')}',
				                 		notNull:true,minLength:1,maxLength:40,avoidChar:'-!@#$%^&*()_+\'&quot;'"/>
				             	</div>
		             		</td>
						</tr>
						<tr>
			            	<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cmp.appMgr.form.label.shortAppName')}:</label></th>
			            	<td colspan="2">
			            		<div class="common_txtbox_wrap">
			            			<input type="text" name="shortname" id="shortname" class="validate word_break_all"
										validate="type:'string',name:'${ctp:i18n('cmp.appMgr.form.label.shortAppName')}',
										notNull:false,minLength:1,maxLength:20,avoidChar:'-!@#$%^&amp;*()_+'"/>
			            		</div>
			            	</td>
		        		</tr>
		        		<tr>
			            	<th nowrap="nowrap">
			            		<label class="margin_r_10" for="text">${ctp:i18n('cmp.appMgr.form.label.version')}:</label>
			            	</th>
			            	<td colspan="2">
			            		<div class="common_txtbox_wrap">
			            			<input type="text" name="version" id="version" class="validate word_break_all"
										validate="type:'string',name:'${ctp:i18n('cmp.appMgr.form.label.version')}',
										notNull:false,minLength:1,maxLength:20,avoidChar:'-!@#$%^&amp;*()_+'"/>
			            		</div>
			            	</td>
		        		</tr>
		        		<tr>
							<th nowrap="nowrap">
								<label class="margin_r_10" for="text"><span class="tipssign">*</span>${ctp:i18n('cmp.appMgr.form.label.thirdpartyApp')}:</label>
							</th>
							<td>
								<div class="common_radio_box clearfix">
									<label for="radio6" class="margin_r_10 hand">
										<input type="radio" value="1" id="thirdpartyApp" name="thirdpartyApp" 
											class="radio_com"/>${ctp:i18n('cmp.appMgr.thirdpartyApp.Yes')}
									</label>
								</div>
							</td>
							<td>
								<div class="common_radio_box clearfix">
									<label for="radio6" class="margin_r_10 hand">
										<input type="radio" value="2" id="thirdpartyApp" name="thirdpartyApp" 
											class="radio_com"/>${ctp:i18n('cmp.appMgr.thirdpartyApp.NO')}
									</label>
								</div>
							</td>
						</tr>
						<tr>
							<th nowrap="nowrap">
								<label class="margin_r_10" for="text"><span class="tipssign">*</span>${ctp:i18n('cmp.appMgr.form.label.statelabel')}:</label>
							</th>
							<td>
								<div class="common_radio_box clearfix">
									<label for="radio5" class="margin_r_10 hand">
										<input type="radio" value="1" id="status" name="status" 
											class="radio_com">${ctp:i18n('cmp.appMgr.state.start')}
									</label>
								</div>
							</td>
							<td>
								<div class="common_radio_box clearfix">
									<label for="radio6" class="margin_r_10 hand">
										<input type="radio" value="2" id="status" name="status" 
											class="radio_com">${ctp:i18n('cmp.appMgr.state.stop')}
									</label>
								</div>
							</td>
						</tr>
						<tr>
			            	<th nowrap="nowrap">
			            		<label class="margin_r_10" for="text"><span class="tipssign">*</span>${ctp:i18n('cmp.appMgr.form.label.appType')}:</label>
			            	</th>
			            	<td colspan="2">
			            		<div>
						            <select id="appType" name="appType" class="codecfg">
										<option value="1">${ctp:i18n('cmp.appMgr.appType.WEB')}</option>
										<option value="2" >${ctp:i18n('cmp.appMgr.appType.nativeApp')}</option>
									</select>
								</div>
							</td>
		        		</tr>
						<tr>
        		            <th nowrap="nowrap">
       		        <label class="margin_r_10" for="text">${ctp:i18n('cmp.appMgr.form.label.authorizedPerson')}:</label>
        		            </th>
        		            <td colspan="2">        		            	
        		            	<div class="common_txtbox  clearfix">
									<textarea rows="5" class="w100b" id="authedScopeNames" name="authedScopeNames">
									</textarea>
									<input type="hidden" id="authedScopeIds" name="authedScopeIds" value="-1">
								</div>
        		            </td>
        	            </tr>
		        		<!-- WEB Area Start -->
		        		<tr id="webPhoneDisplayArea">
					    	<th nowrap="nowrap">
					    		<label class="margin_r_10" for="text"><span class="tipssign">*</span>${ctp:i18n('cmp.appMgr.form.label.invokeAddrForWebPhone')}:</label>
					    	</th>
					        <td colspan="2">
			            		<div class="common_txtbox_wrap">
			            			<input type="text" name="invokeAddrForWeb" id="invokeAddrForWeb" class="validate word_break_all"/>
			            		</div>
			            	</td>
						</tr>
						<tr id="webPadDisplayArea">
					    	<th nowrap="nowrap">
					    		<label class="margin_r_10" for="text"><span class="tipssign">*</span>${ctp:i18n('cmp.appMgr.form.label.invokeAddrForWebPad')}:</label>
					    	</th>
					        <td colspan="2">
			            		<div class="common_txtbox_wrap">
			            			<input type="text" name="ext4" id="ext4" class="validate word_break_all"/>
			            		</div>
			            	</td>
						</tr>
						<!-- WEB Area End -->
						
						<!-- Native Area Start -->
						<!-- Android System Start -->
						<tr id="nativeDisplayArea">
							<td  width="100%" colspan="3">
								<fieldset>
					        		<legend>${ctp:i18n('cmp.appMgr.form.label.androiddSystem')}</legend>
									<table>
										<tr>
									    	<th nowrap="nowrap">
									    		<label class="margin_r_10" for="text">${ctp:i18n('cmp.appMgr.form.label.downloadAddrForPhone')}:</label>
									    	</th>
									        <td width="100%">
							            		<div class="common_txtbox_wrap">
							            			<input type="text" name="downloadAddrForAndroidPhone" id="downloadAddrForAndroidPhone" class="validate word_break_all"/>
							            		</div>
							            	</td>
										</tr>
										<tr>
									    	<th nowrap="nowrap">
									    		<label class="margin_r_10" for="text"><span class="tipssign">*</span>${ctp:i18n('cmp.appMgr.form.label.invokeAddrForPhone')}:</label>
									    	</th>
									        <td>
							            		<div class="common_txtbox_wrap">
							            			<input type="text" name="invokeAddrForAndroidPhone" id="invokeAddrForAndroidPhone" class="validate word_break_all"/>
							            		</div>
							            	</td>
										</tr>
										<tr>
									    	<th nowrap="nowrap">
									    		<label class="margin_r_10" for="text">${ctp:i18n('cmp.appMgr.form.label.downloadAddrForPad')}:</label>
									    	</th>
									        <td>
							            		<div class="common_txtbox_wrap">
							            			<input type="text" name="downloadAddrForAndroidPad" id="downloadAddrForAndroidPad" class="validate word_break_all"/>
							            		</div>
							            	</td>
										</tr>
										<tr>
									    	<th nowrap="nowrap">
									    		<label class="margin_r_10" for="text"><span class="tipssign">*</span>${ctp:i18n('cmp.appMgr.form.label.invokeAddrForPad')}:</label>
									    	</th>
									        <td>
							            		<div class="common_txtbox_wrap">
							            			<input type="text" name="invokeAddrForAndroidPad" id="invokeAddrForAndroidPad" class="validate word_break_all"/>
							            		</div>
							            	</td>
										</tr>
									</table>
								</fieldset>
							</td>
						</tr>
						<!-- Android System End -->
						
						<!-- IOS System Start -->
						<tr id="nativeDisplayArea"><td  width="100%" colspan="3">
							<fieldset>
				        		<legend>${ctp:i18n('cmp.appMgr.form.label.iosSystem')}</legend>
								<table>
								<tr>
							    	<th nowrap="nowrap">
							    		<label class="margin_r_10" for="text">${ctp:i18n('cmp.appMgr.form.label.downloadAddrForPhone')}:</label>
							    	</th>
							        <td  width="100%">
					            		<div class="common_txtbox_wrap">
					            			<input type="text" name="downloadAddrForIOSPhone" id="downloadAddrForIOSPhone" class="validate word_break_all"/>
					            		</div>
					            	</td>
								</tr>
								<tr>
							    	<th nowrap="nowrap">
							    		<label class="margin_r_10" for="text"><span class="tipssign">*</span>${ctp:i18n('cmp.appMgr.form.label.invokeAddrForPhone')}:</label>
							    	</th>
							        <td>
					            		<div class="common_txtbox_wrap">
					            			<input type="text" name="invokeAddrForIOSPhone" id="invokeAddrForIOSPhone" class="validate word_break_all"/>
					            		</div>
					            	</td>
								</tr>
								<tr>
							    	<th nowrap="nowrap">
							    		<label class="margin_r_10" for="text">${ctp:i18n('cmp.appMgr.form.label.downloadAddrForPad')}:</label>
							    	</th>
							        <td>
					            		<div class="common_txtbox_wrap">
					            			<input type="text" name="downloadAddrForIOSPad" id="downloadAddrForIOSPad" class="validate word_break_all"/>
					            		</div>
					            	</td>
								</tr>
								<tr>
							    	<th nowrap="nowrap">
							    		<label class="margin_r_10" for="text"><span class="tipssign">*</span>${ctp:i18n('cmp.appMgr.form.label.invokeAddrForPad')}:</label>
							    	</th>
							        <td>
					            		<div class="common_txtbox_wrap">
					            			<input type="text" name="invokeAddrForIOSPad" id="invokeAddrForIOSPad" class="validate word_break_all"/>
					            		</div>
					            	</td>
								</tr>
								</table>
							</fieldset>
						</td>
						</tr>
						<!-- IOS System End -->
						
						<!-- Native Area End -->
						<tr>
					    	<th nowrap="nowrap">
					    		<label class="margin_r_10" for="text">${ctp:i18n('cmp.appMgr.form.label.ICON')}:</label>
					    	</th>
							<td class="tdcontent" colspan="2">
								<div id="iconDiv" class="iconArea"></div>
								<input type = "hidden" id = "icon" name = "icon">
								<div class="iconBtn">
									<input id="iconInput" type="hidden" class="comp" comp="type:'fileupload', applicationCategory:'37',  
							        	extensions:'png,jpg,gif', isEncrypt:false,quantity:1, 
							            canDeleteOriginalAtts:true, originalAttsNeedClone:false, firstSave:true,callMethod:'iconUploadCallback'">
							        <input id="iconUploadBtn" type="button" onclick="insertAttachment();" value="${ctp:i18n('cmp.appMgr.form.label.uploadlabel')}"/>
								</div>
					        </td>
				    	</tr>
				    	<tr><td>&nbsp;</td></tr>
						<tr>
							<th nowrap="nowrap">
								<label class="margin_r_10" for="text">${ctp:i18n('cmp.appMgr.form.label.description')}:</label>
							</th>
							<td colspan="2">
								<div class="common_txtbox  clearfix">
									<textarea rows="5" class="w100b validate word_break_all" id="description" 
										validate="type:'string',name:'${ctp:i18n('cmp.appMgr.form.label.description')}',notNull:false,maxLength:512">
									</textarea>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</form>
</body>
</html>