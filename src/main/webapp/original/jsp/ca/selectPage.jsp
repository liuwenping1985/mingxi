<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>selectPage</title>
<script type="text/javascript">
var parentWindow = window.dialogArguments;

function showCertsList(){//展现CA证书列表
	var table_tag = document.getElementById("selectCerts");
	for(var i = 0; i<parentWindow.arrayCerts.length; i++){
		var tr_tag = document.createElement("tr");
		var td_tag = document.createElement("td");
		var input_radioTag = document.createElement("input");
		var input_tag = document.createElement("input");
		input_radioTag.setAttribute("type","radio");
		input_radioTag.setAttribute("id","certRadio");
		input_radioTag.setAttribute("name","certRadio");
		input_radioTag.setAttribute("value",i);
		input_radioTag.setAttribute("onclick","selectCerts(this)");
		input_tag.setAttribute("type","text");
		input_tag.setAttribute("id","cert"+i);
		input_tag.setAttribute("name","cert"+i);
		input_tag.setAttribute("value",parentWindow.arrayCerts[i].CommonName);
		input_tag.setAttribute("readOnly","readonly");
		td_tag.appendChild(input_radioTag);
		td_tag.appendChild(input_tag);
		tr_tag.appendChild(td_tag);
		table_tag.appendChild(tr_tag);
	}
}

function selectCerts(certsListNumber){
	if(certsListNumber.checked){
		parentWindow.document.getElementById("userName").value = parentWindow.arrayCerts[certsListNumber.value].CommonName;
		parentWindow.certName = parentWindow.arrayCerts[certsListNumber.value].CommonName;
		parentWindow.curCert = parentWindow.arrayCerts[certsListNumber.value];
		window.close();
	}else{
		alert("未选中CA证书，重新选择");
	}
}

function defaultCert(){
	parentWindow.document.getElementById("userName").value = parentWindow.arrayCerts[0].CommonName;
	parentWindow.certName = parentWindow.arrayCerts[0].CommonName;
	parentWindow.curCert = parentWindow.arrayCerts[0];
}
</script>
</head>
<body onload="defaultCert();showCertsList();">
	<table name="selectCerts" id="selectCerts">
	</table>
</body>
</html>