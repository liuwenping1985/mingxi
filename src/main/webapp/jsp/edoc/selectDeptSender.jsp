<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="edocHeader.jsp"%>     
<html>
<head>
<title><fmt:message key='edoc.select.exchangeDept'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link href="<c:url value="/apps_res/edoc/css/edoc.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<script type="text/javascript">
window.transParams = window.transParams || window.parent.transParams;//弹出框参数传递
/**
 *内部方法，向上层页面返回参数
 */
function _returnValue(value){
    
    if(window.transParams){
        if(transParams.popCallbackFn){//该页面被两个地方调用
            transParams.popCallbackFn(value);
        }else{
            transParams.parentWin.checkExchangeRole_fromWaitSendCallback(value);
        }
    } else if(window.dialogArguments){//模态窗口打开方式
        window.returnValue = value;
    }
}

/**
 *内部方法，关闭当前窗口
 */
function _closeWin(){
    if(window.transParams){
        if(transParams.popWinName){//该页面被两个地方调用
            transParams.parentWin[transParams.popWinName].close();
        }else{
            transParams.parentWin.checkExchangeRole_fromWaitSendWin.close();
        }
    } else if(window.dialogArguments){//模态窗口打开方式
        window.close();
    }
}
function closeWindow(){
	_returnValue('cancel');
	_closeWin();
}
function init(){
	var deptStr=decodeURIComponent("${ctp:toHTML(param.memberList)}");
	var deptArr=deptStr.split("|");
	var obtn=document.getElementById("btns");
	var cbox="";
	for(var i=0;i<deptArr.length;i++){
		var dept=deptArr[i].split(",");
		var deptName=dept[1];
		if(i==0){
			cbox+="<input type='radio' checked name='memberName' value='"+dept[0]+"'/>"+deptName+"<br>";
		}else{
			cbox+="<input type='radio' name='memberName' value='"+dept[0]+"'/>"+deptName+"<br>";
		}
	}
	obtn.innerHTML=cbox;
}
function ok(){
	var result="";
	var btns=document.getElementsByName("memberName");
	for(var i=0;i<btns.length;i++){
		if(btns[i].checked){
			result+=btns[i].value;
		}
	}
	_returnValue(result);
	_closeWin();
}
</script>
</head>
<body style="overflow:hidden;" onload="init()" onkeypress="listenerKeyESC()">
<form name="selectNextAction" method="post" >
<table class="popupTitleRight" width="100%" height="162" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="PopupTitle" height="20">
			<fmt:message key='edoc.select.exchangeDept'/>
		</td>
	</tr>
	<tr>
		<td height="100" width="100%" style="overflow:auto">
			<div id="btns" style="padding-left:70px;padding-right:10px;height:100px;overflow:auto">
			</div>
		</td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom" >
			<input type="button" name="b1" id="b1" onclick="ok()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;&nbsp;
			<input type="button" name="b2" id="b2" onclick="closeWindow();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
</body>
</html>