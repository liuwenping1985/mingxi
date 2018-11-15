<table class="popupTitleRight font_size12" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<%-- 		<tr>
			<td height="20" class="padding_10 font_bold border_b">${ctp:i18n(empty param.popupTitleKey ? 'fileupload.page.title' : param.popupTitleKey)}</td>
		</tr> --%>
		<tr>
			<td align="top" style="padding:0;">
				<div id="scroll_div" style="height:188px;overflow-y:auto;overflow-x:hidden;">
				<table width="385" border="0" cellspacing="0" cellpadding="0">
		<c:if test="${!empty param.selectRepeatSkipOrCover}">
			<tr >
				<td height="30"  class="padding_10">
					${ctp:i18n(empty param.selectRepeat ? 'fileupload.page.repeat' : param.selectRepeat)}&nbsp;
					<label for="skip">
						<input type="radio" id="skip" name="repeat" value="0" checked="checked">
						${ctp:i18n(empty param.selectRepeatSkip ? 'fileupload.page.skip' : param.selectRepeatSkip)}
					</label>
					<label for="cover">
						<input type="radio" id="cover" name="repeat" value="1">
						${ctp:i18n(empty param.selectRepeatCover ? 'fileupload.page.cover' : param.selectRepeatCover)}
					</label>
                        <c:if test="${!empty param.importExplain}" >
                            <a href="#" onclick="importExplain()" id="importExplain" style="margin-left: 100px;">
                                [${ctp:i18n('form.base.importexplain.label')}]
                            </a>
                        </c:if>
				</td>
			</tr>
		</c:if>
        <tr>
            <td height="20">
                <div class="margin_l_20">${ctp:i18n_1("fileupload.selectfile.label",maxSize)}</div>
            </td>
        </tr>
		<tr>
			<td id="upload1" class="bg-advance-middel padding_10" style="vertical-align: top; padding-left:20px; padding-right: 0;">
                <div class="file_box" >
			                <div id="fileInputDiv" style="height: 30px;float:right;width:70px;margin-left:5px;">
                    <div id="fileInputDiv1" style="" class="file_unload clearfix">
                        <a class="common_button common_button_icon file_click" href="###"><em class="ico16 affix_16"></em>${ctp:i18n("fileupload.addfile.label")}
                        <INPUT type="file" size="51" name="file1" id="file1" onchange="addNextInput(this)" onkeydown="return false" onkeypress="return false">
                        </a>
                    </div>
                </div>
                
                
			                <ul id="fileNameDiv" class="file_select  border_all clearfix bg_color_white" style="float:left;width:260px;padding:0px 5px;margin:0px;${!empty param.selectRepeatSkipOrCover?'height: 24px;overflow: hidden;':''}">
                    <li><a>&nbsp;</a></li>
                </ul>
                
                </div>
                
                
			</td>
		</tr>
		<tr id="uploadprocee" style="display:none;">
			<td  style="background:#fff;" align="center" class="bg-advance-middel padding_10">
				<table width="240" height="45" border="0" cellspacing="0" cellpadding="0" >
				  <tr>				    
				    <td align='center' height='30' valign='bottom'>${ctp:i18n("fileupload.uploading.label")}...</td>			    
				  </tr>
				  <tr> 
				    <td align='center'><span class='process'>&nbsp;</span></td>
				  </tr>
				</table>
			</td>
		</tr>	
					</table>
					</div>
				</td>
			</tr>
		<tr>
			<td align="right" valign="top" class="bg-advance-bottom padding_lr_10 border_t">
                <a id="b1" class="button-default_emphasize" style="cursor: pointer;vertical-align: top;" onclick="checks()">${ctp:i18n('common.button.ok.label')}</a><a id="b2" class="margin_l_10 button-default-2 margin_r_10" style="cursor: pointer; vertical-align: top;" onclick="windowClose()">${ctp:i18n('common.button.cancel.label')}</a>
                <%--
				<input type="submit" id="b1" name="b1" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
				<input type="button" id="b2" name="b2" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
                 --%>
			</td>
		</tr>
	</table>	
