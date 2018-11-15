	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" class="PopupTitle"><fmt:message key="${empty param.popupTitleKey ? 'fileupload.page.title' : param.popupTitleKey}" /></td>
		</tr>	
		<tr>
			<td id="upload1" class="bg-advance-middel" style="vertical-align: middle">
				<div><fmt:message key="fileupload.selectfile.label">
					<fmt:param value="${v3x:outConditionExpression(!empty param.maxSize, param.maxSize, maxSize)}" />
				</fmt:message></div>
				<div id="fileInputDiv" style="height: 30px">
					<div id="fileInputDiv1" style="">
						<INPUT type="file" name="file1" id="file1" onchange="addNextInput(this)" onkeydown="return false" onkeypress="return false" style="width: 100%">
					</div>
				</div>
				<div id="fileNameDiv" style="height: 40px;"></div>
			</td>
		</tr>
		<tr>
			<td id="uploadprocee" style="display:none" align="center" class="bg-advance-middel">
				<table width="240" height="45" border="0" cellspacing="0" cellpadding="0" bgcolor='#F6F6F6'>
				  <tr>				    
				    <td align='center' height='30' valign='bottom'><fmt:message key="fileupload.uploading.label" />...</td>			    
				  </tr>
				  <tr> 
				    <td align='center'><span class='process'>&nbsp;</span></td>
				  </tr>
				</table>
			</td>
		</tr>	
		<tr>
			<td height="42" align="right" class="bg-advance-bottom">
				<input type="submit"  name="b1" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
				<input type="button" name="b2" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
	</table>	
