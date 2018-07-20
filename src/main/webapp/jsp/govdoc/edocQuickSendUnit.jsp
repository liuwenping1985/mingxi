<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="bg_color_white">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
<!--
window.transParams = window.transParams || window.parent.transParams;//弹出框参数传递
$(function(){
	//初始化部门参数
	var sendUnitVal = window.transParams.sendUnitVal;
	var sendUnitTxt = window.transParams.sendUnitTxt;
	$("#sendUnitTxtArea").comp({value:sendUnitVal, text:sendUnitTxt});
});

function OK(){
	var compObj = eval("({" + $("#sendUnitTxtArea").attr("comp") + "})");
	return compObj.value;
}
//-->
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<div class="margin_l_10">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="bg-advance-middel" valign="top">
			<textarea name="sendUnitTxtArea" title="" class="comp validate" id="sendUnitTxtArea"
					  style="width: 100%;height: 200px" readOnly="readonly"
					  comp='"type":"selectPeople","showBtn":true,"extendWidth":true,"mode":"open","panels":"Account,Department,OrgTeam","minSize":0,"maxSize":0,"selectType":"Account,Department,OrgTeam","value":"","text":""'
					  comptype="selectPeople" _inited="1" data-role="none" inCondition="false"
					  validate='name:"送往单位",type:"string",china3char:true,maxLength:4000,notNull:false' inCalculate="false"
					  unique="false"></textarea>
		</td>
	</tr>
	<tr>
	</tr>
</table>
</div>
</body>
</html>