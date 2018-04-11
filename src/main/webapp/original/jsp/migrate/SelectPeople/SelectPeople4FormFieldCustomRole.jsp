<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="../INC/noCache.jsp" %>
<head>
<%@ include file="../header.jsp" %>
<title><fmt:message key="selectPeople.page.title" /></title>
<script type="text/javascript">
<!--
debugger;
alert(1111);
function showOriginalDate(originalData){
	addElementsToList3(originalData);
}

function getIsCheckSelectedData(){
	return true;
}

function selected(){
	var data = null;

	try{
		data = getSelectedPeoples();
	}
	catch(e){
		if(e != 'continue'){
			alert(e);
		}
		return;
	}

	//正常返回数据，如果没有人，则data是一个length为0的数组，即data = []

	window.returnValue = data;

	window.close();
}

function OK(){
	var data = null;
	try{
		data = getSelectedPeoples();
	}catch(e){
		if(e != 'continue'){
			alert(e);
		}
		return;
	}
	var retValue = [];
	var allValue = [];
	if(data){
		for(var i = 0 ; i<data.length; i++){
			var obj  = data[i];
			allValue[allValue.length] = obj.type+"|"+obj.id+"|"+obj.accountId;
		}
	}
	if(allValue.length!=0){
		retValue[0] = 	allValue;
	}
	return retValue;
}
//-->
</script>
<%@ include file="AbstractSelectPeople.jsp" %>
</table>
</body>
<script type="text/javascript">
<!--
debugger;
var originalDataStr = parent.paramValue;
var elements_portalSender = [];
if(originalDataStr){
	var arr = originalDataStr.split(",");
	for(var i = 0; i<arr.length;i++){
		var signArr = arr[i].split("|");
		var type = signArr[0];
		var id = signArr[1];
		var accountId = signArr[2];
	    var e = new Element(type,id,getName(type, id),"",accountId,"","");
		elements_portalSender[i] = e;
	}
}
showOriginalDate(elements_portalSender);
//-->
</script>
</html>

