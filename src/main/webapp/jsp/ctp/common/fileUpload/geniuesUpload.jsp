
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed;">
<%--         <tr>
            <td height="20" class="padding_10 font_bold border_b">${ctp:i18n(empty param.popupTitleKey ? 'fileupload.page.title' : param.popupTitleKey)}</td>
        </tr> --%>
        <tr>
        	<td style="background:#fff; " valign="top">
        		<div style="overflow:auto; overflow-x:hidden; height:210px;">
        		<table border="0" cellspacing="0" cellpadding="0" width="385">
					<c:if test="${!empty param.selectRepeatSkipOrCover}">
						<tr >
							<td class="padding_lr_10 padding_tb_5" colspan="2" align="left">
								${ctp:i18n(empty param.selectRepeat ? 'fileupload.page.repeat' : param.selectRepeat)}&nbsp;
								<c:if test="${empty param.hiddenSkipOrCover || param.hiddenSkipOrCover ne 'skip'}">
									<label for="skip">
										<input type="radio" id="skip" name="repeat" value="0" checked="checked">
										${ctp:i18n(empty param.selectRepeatSkip ? 'fileupload.page.skip' : param.selectRepeatSkip)}
									</label>
								</c:if>
								<c:if test="${empty param.hiddenSkipOrCover || param.hiddenSkipOrCover ne 'cover'}">
									<label for="cover">
										<input type="radio" id="cover" name="repeat" value="1">
										${ctp:i18n(empty param.selectRepeatCover ? 'fileupload.page.cover' : param.selectRepeatCover)}
									</label>
								</c:if>
							</td>
						</tr>
					</c:if>
			        <tr>
			            <td class="padding_lr_10 padding_tb_5" colspan="2">

			                <div>${ctp:i18n_1("fileupload.selectfile.label",maxSize)}</div>
			            </td>
			        </tr>
					<tr>
						<td id="upload1" class="bg-advance-middel padding_l_10">
			                <ul id="fileNameDiv" class="file_select border_all clearfix" style="float:left;width:270px;padding:0px 5px;margin:0px;">
			                    <li><a>&nbsp;</a></li>
			                </ul>
						</td>
						<td style="width:90px;" valign="top">
			                <div class="file_box padding_5" >
				                <div id="fileInputDiv" style="height: 30px;">
				                    <div id="fileInputDiv1" style="" class="file_unload clearfix">
				                        <a class="common_button common_button_icon file_click" href="###"><em class="ico16 affix_16"></em>${ctp:i18n("fileupload.addfile.label")}
				                        <INPUT type="text" size="51" name="file1" id="file1" onchange="addNextInput(this)" onkeydown="return false" onkeypress="return false">
				                        </a>
				                    </div>
				                </div>
			                </div>
						</td>
					</tr>
					<tr id="fileProcee" style="display:none;">
						<td  width="100%" align="center" class="bg-advance-middel" colspan="2">
							<table width="100%" height="2%" border="0" cellspacing="0" cellpadding="0">
							  <tr>
							    <td align='left' width="100%" valign='bottom'>
							    <div id="file_percent"></div>
							    </td>
							  </tr>
							</table>
						</td>
					</tr>
					<tr id="uploadprocee" style="display:none;">
						<td  width="100%" align="center" class="bg-advance-middel" colspan="2">
							<table width="100%" height="2%" border="0" cellspacing="0" cellpadding="0">
							  <tr>
							    <td align='left' width="100%" valign='bottom'>
							    <div id="percent"></div><div id="result"></div>
							    </td>
							  </tr>
							</table>
						</td>
					</tr>
        		</table>
        		</div>
        	</td>
        </tr>
		<tr>
			<td height="40" align="right" class="bg-advance-bottom" valign="middle">
				<input type="button" id="b1" name="b1" onclick="onUpload()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
				<input type="button" id="b2" name="b2" onclick="windowClose()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
	</table>
    <object classid="clsid:B314C411-E6EA-4019-B6BF-CB1A1D0EC61F" id="UFIDA_Upload1" data="DATA:application/x-oleobject;BASE64,EcQUs+rmGUC2v8saHQ7GHgADAABoLgAAzxIAABMAzc3NzRMAzc3NzQsA//8=" width="90%" height="0"></object>
<script type="text/javascript">
 $(document).ready(function() {
    $("#file1").click(function() {
       OpenBrowser();
    });
            });
</script>