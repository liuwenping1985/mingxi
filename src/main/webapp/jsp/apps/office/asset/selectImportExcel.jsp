<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
	var from  = '${from}';
	function submitform(){
		var fileURL = document.getElementById('file1').value;
		if("" == fileURL) {
			$.alert("${ctp:i18n('choose_import_file')}");
			return;
		}
		var filePostfix = fileURL.substring(fileURL.lastIndexOf('.')+1);
		if(filePostfix.toLowerCase()!='xls' && filePostfix.toLowerCase() != 'xlsx'){
			$.alert("${ctp:i18n('file_error_choose_excel')}");
			return;
		}
		var form = document.all("uploadFormOrgImp");
		if(document.getElementById('file1').value!=""&&document.getElementById('file1').value.length!=0){
			var rep = document.getElementsByName("repeat");
			var repvalue;
			if(from!='apply'){
				if(rep[0].checked){
					repvalue = rep[0].value;
				}else{
					repvalue = rep[1].value;
				}
			}
			
		  document.all("impURL").value = document.getElementById('file1').value;
		  try{$.progressBar();}catch(e){}
		  var _url = (from != 'apply') ? "assetSet.do" : "assetUse.do";
		  form.action = "${path}/office/" + _url + "?method=doImport&repeat=" + repvalue;
		  form.submit();
		  try {
			  if (getCtpTop() && getCtpTop().endProc) {
				  //getCtpTop().endProc()
			  }
		  } catch (e) {
		  }
		  ;
	  } else {
		  $.alert("${ctp:i18n('choose_import_file')}");
		  return;
	  }
  }
  function closeMe(){
	  var winId = 'imp';
	  if (from != 'info') {
		  winId = 'importAssetApply';
	  }
	  window.parentDialogObj[winId].close();
  }
</script>
</head>
<body scroll="no"  >
	<div style="overflow:hidden">
		<form enctype="multipart/form-data" name="uploadFormOrgImp" method="post">
			<table class="font_size12 bg_color_white" width="100%" height="100%"  align="center" border="0" cellspacing="0" cellpadding="0">
				<input type="hidden" id="impURL" name="impURL">
				<tr>
					<td id="upload1" height="30" style="padding-left: 12px">${ctp:i18n('import.choose.file')}
					</td>
				</tr>
				<tr>
					<td id="upload1" height="30" style="padding-left: 12px">
					   <input type="file" name="file1" id="file1" style="width: 95%"/>
					</td>
				</tr>
                <c:if test="${from eq 'info'}">
      				<tr class="bg-imges2">
      					<td  class="bg-imges2" height="30" align="left" style="padding-left: 12px" colspan="3">${ctp:i18n('import.option')}:
      						<label for="overleap">
      							<input type="radio" name="repeat" value="1" checked="checked" id="overleap">${ctp:i18n('import.repeatitem.overleap')}
      						</label>
      						<label for="overcast">
      							<input type="radio" name="repeat" value="0" id="overcast">${ctp:i18n('import.repeatitem.overcast')}
      						</label>
      					</td>
      				</tr>
                </c:if>
				<tr>
					<td height="32" align="right" class="border_t">
						<div class="align_right">
						<a id="btnok" onclick="submitform();" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a>
						<a id="btncancel" onclick="closeMe();" class="common_button common_button_grayDark margin_r_5" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
						</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>