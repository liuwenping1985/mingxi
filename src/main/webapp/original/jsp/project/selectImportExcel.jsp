<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<link type="text/css" rel="stylesheet" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
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
		  document.all("impURL").value = document.getElementById('file1').value;
		  //try{$.progressBar();}catch(e){}
			try{if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();}catch(e){}
		  var _url = "project.do";
		  form.action = "${path}/project/" + _url + "?method=doImport";
		  showProcDiv();
		  form.submit();
		  try {
			  if (getCtpTop() && getCtpTop().endProc) {
				  getCtpTop().endProc();
			  }
		  } catch (e) {
		  }
		  ;
	  } else {
		  $.alert("${ctp:i18n('choose_import_file')}");
		  return;
	  }
  }
	//显示流程
    function showProcDiv(){
        var width = 320;
        var height = 140;
        
        var left = (document.body.scrollWidth - width) / 2;
        var top = (document.body.scrollHeight - height) / 2;
        var title = "${ctp:i18n('org.member.import.process.label')}";    
        var str = "";
            str += '<div id="procDIV" style="position:absolute;left:'+left+'px;top:'+top+'px;width:'+width+'px;height:'+height+'px;z-index:50;border:solid 2px #DBDBDB;">';
            str += "<table width=\"100%\" height=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" bgcolor='#F6F6F6'>";
            str += "  <tr>";
            str += "    <td align='center' id='procText' height='50' valign='bottom' class='color_red font_bold'>&nbsp;</td>";
            str += "  </tr>";
            str += "  <tr>";
            str += "    <td align='center'><span class='process'>&nbsp;</span></td>";
            str += "  </tr>";
            str += "</table>";
            str += "</div>";
            
        document.getElementById("procDiv1").innerHTML = str;
        var procTextE = document.getElementById("procText");
        if(procTextE){
            procTextE.innerText = title;
        }
        document.close();
    } 
  function closeMe(){
	  var winId = 'importdialog';
	  window.parentDialogObj[winId].close();
  }
</script>
</head>
<body style="overflow: hidden;">
	<div style="overflow:hidden">
		
		<form enctype="multipart/form-data" name="uploadFormOrgImp" method="post">
			<table class="font_size12 bg_color_white" width="100%" height="100%"  align="center" border="0" cellspacing="0" cellpadding="0">
				<input type="hidden" id="impURL" name="impURL">
				<tr>
					<td  height="50" style="padding-left: 20px"><h2>${ctp:i18n('project.import')}</h2>
					</td>
				</tr>
				<tr>
					<td id="upload1" height="30" style="padding-left: 12px">${ctp:i18n('import.choose.file')}
					</td>
				</tr>
				<tr>
					<td id="upload1" height="30" style="padding-left: 12px">
					   <input type="file" name="file1" id="file1" style="width: 95%"/>
					</td>
				</tr>
				<tr height="143">
				</tr>
				<tr>
					<td height="42" align="right" class="bg-advance-bottom">
						<div class="align_right">
						<a id="btnok" onclick="submitform();" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a>
						<a id="btncancel" onclick="closeMe();" class="common_button common_button_grayDark margin_r_5" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
						</div>
					</td>
				</tr> 
			</table>
		</form>
			<!--</iframe>-->
	<div id="procDiv1"></div>
	</div>
</body>
</html>