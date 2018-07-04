<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common/organizationHeader.jsp"%>
<%@ include file="../../../common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Expires" CONTENT="0">
<title>${ctp:i18n('org.file.upload.doc.photo')}</title>
<script type="text/javascript">
	var loginAccountId = null;
	$().ready(function() {
		loginAccountId = "${loginAccountId}";
	});
	
	function listenerKeyPress(){
		if(event.keyCode == 27){
			window.parent.uploadDialog.close();
		}
	}
	function submitform(){
		$("#b1").attr("disabled","disabled");
		var fileURL = document.getElementById('file1').value;
		if("" == fileURL) {
			$.alert("${ctp:i18n('choose_import_file')}");
			$("#b1").removeAttr("disabled");
			return;
		}
		var filePostfix = fileURL.substring(fileURL.lastIndexOf('.')+1);
		if(filePostfix.toLowerCase()!='zip'){//如果不是zip压缩文件
			alert("${ctp:i18n_1('fileupload.exception.UnallowedExtension','zip')}");
			$("#b1").removeAttr("disabled");
			return;
		}
		var form = document.all("uploadzipPic");
		var file1 = document.getElementById('file1');
		if(file1.value!=""&&file1.value.length!=0){
			try{if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();}catch(e){}
			document.all("impURL").value = file1.value;
			var rep = document.all("repeat");
			var repvalue;
			if(rep[0].checked){
				repvalue = rep[0].value;
			}else{
				repvalue = rep[1].value;
			}
			form.action="${path}/organization/member.do?method=doUploadFile&repeat=" + repvalue+"&loginAccountId="+loginAccountId;
	        showProcDiv();
			form.submit();
			try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
		}else{
			$.alert("${ctp:i18n('choose_import_file')}");
			$("#b1").removeAttr("disabled");
			return;
		}
	}
    function showProcDiv(){
        var width = 280;
        var height = 120;
        
        var left = (document.body.scrollWidth - width) / 2;
        var top = (document.body.scrollHeight - height) / 2;
        var title = "${ctp:i18n('org.member.import.process.label')}";    
        var str = "";
            str += '<div id="procDIV" style="position:absolute;left:'+left+'px;top:'+top+'px;width:'+width+'px;height:'+height+'px;z-index:50;border:solid 2px #DBDBDB;">';
            str += "<table width=\"100%\" height=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" bgcolor='#F6F6F6'>";
            str += "  <tr>";
            str += "    <td align='center' id='procText' height='40' valign='bottom' class='color_red font_bold'>&nbsp;</td>";
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
 	function closeMe() {
 		window.parentDialogObj['uploadZipDialog'].close();
 	}
 	 
</script>
</head>
<body class="w100b h100b over_hidden" onkeydown="listenerKeyPress()" >
	<div style="overflow:hidden">
<form enctype="multipart/form-data" name="uploadzipPic" method="post">
	<table class="popupTitleRight bg_color_white" width="100%" height="100%"  align="center" border="0" cellspacing="0" cellpadding="0">
		<input type="hidden" id="impURL" name="impURL">
		<tr class="bg-imges2"  id="importOptions">
			<td  class="bg-imges2"  style="padding-left: 12px;height:30px;align:left" colspan="3">
				${ctp:i18n('import.option')}:&nbsp;
				<label for="overleap">
					<input type="radio" name="repeat" value="1" checked="checked" id="overleap">
					${ctp:i18n('import.repeatitem.overleap')}
				</label>
				<label for="overcast">
					<input type="radio" name="repeat" value="0" id="overcast">
					${ctp:i18n('import.repeatitem.overcast')}&nbsp;&nbsp;
				</label>
			</td>
		</tr>
		<tr>
			<td id="upload1" height="15px" style="padding-left: 12px">
			   	${ctp:i18n('import.choose.file')}
			   	(${ctp:i18n_1('member.photo.upload.size.limit',maxSize)})
			</td>
		</tr>
		<tr>
			<td id="upload2" height="30" style="padding-left: 12px">
				<input type="file" name="file1" id="file1" style="width: 95%" />
			</td>
		</tr>
		<tr>
			<td id="instruction" height="30px" style="padding-left: 12px">
				<font color="red">${ctp:i18n('member.photo.upload.instruction')}</font>
			</td>
		</tr>
		<tr>
		<td align="left" class="bg-imges2" style="padding-left: 15px;" colspan="3">
				<div  style="display: none;"></div>
			</td>
		</tr>
		<tr>
			<td height="42" align="right" class="bg-advance-bottom">
				<input type="button" name="b1" id="b1" onclick="submitform()"value="${ctp:i18n('common.button.ok.label')}" class="button-default-2 common_button_emphasize">&nbsp;
				<input id="submintCancel" type="button" onclick="closeMe()" value="${ctp:i18n('common.button.cancel.label')}" class="button-default-2">
			</td>
		</tr>
	</table>
</form>
	<!--</iframe>-->
	<div id="procDiv1"></div>
	<div>
<iframe width="0" height="0" name="fileUpload"id="fileUpload"></iframe>
	</div>
</div>
</body>
</html>