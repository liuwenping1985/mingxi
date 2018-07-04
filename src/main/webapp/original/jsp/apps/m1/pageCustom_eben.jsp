<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@include file="header.jsp"%>
<%@include file="pageCustom_eben.js.jsp"%>

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>E人E本</title>
<script type="text/javascript">
$(document).ready(function(){
	$('#cansleupload').click(function(){
		cansleImage();
	});
	$('#blogo').click(function(){
		changeImage(2);
	});
	$('#bbg').click(function(){
		changeImage(1);
	});
	
	$('#showimage').click(function(){
		showimg();
	});
	$('#saveimage').click(function(){
		sub();
	});
	$('#restoreDefault').click(function(){
		restore_default();
	});
	//dv2 onClick="changeImage(1)" onmousemove="this.style.filter='alpha(opacity=30)'" onmouseout="this.style.filter='alpha(opacity=75)'"
	$('#dv2').click(function(){
		changeImage(1);
	});
	$('#dv2').mousemove(function(){
		this.style.filter="alpha(opacity=30)";
	});
	$('#dv2').mouseout(function(){
		this.style.filter="alpha(opacity=75)";
	});
	$('#dv3').click(function(){
		changeImage(2);
	});
	$('#dv3').mousemove(function(){
		this.style.filter="alpha(opacity=30)";
	});
	$('#dv3').mouseout(function(){
		this.style.filter="alpha(opacity=75)";
	});
	
});
</script>

</head>

<body onbeforeunload="return tix();">
<form id="form1" action="<c:url value='/mobilemanage/clientBindController.do'/>?method=uploadImg" method="post">
<input type="hidden" name="fileId1" value="-1">
<input type="hidden" name="fileCreateDate1" value="-1">
<input type="hidden" name="fileId2" value="-1">
<input type="hidden" name="fileCreateDate2" value="-1">
<input type="hidden" name="fileId3" value="-1">
<input type="hidden" name="fileCreateDate3" value="-1">
<input type="hidden" name="bgpath" value="${bgpath}">
<input type="hidden" name="logopath" value="${logopath}">
<table   width="70%" align="left" border="0"  height="90%">
	<tr><td width="5%"></td><td>
	<table  width="100%"  border="0"  height="100%">
    <tr><td align="right">
	Logo:
	</td><td align="left">
	<input type="text" id="logoname" value=""/> <input type="button" id="blogo" value="<fmt:message key='button.mm.upload' bundle='${mobileManageBundle}' />"  class="button-default-2"/>	
	<fmt:message key='m1.skin.eben.log' bundle='${mobileManageBundle}' />
	</td></tr><tr><td align="right">
	<fmt:message key='m1.skin.background.label' bundle='${mobileManageBundle}' />:
	</td><td align="left">
	<input type="text" id="bgname" value=""> <input type="button" id="bbg" value="<fmt:message key='button.mm.upload' bundle='${mobileManageBundle}' />" class="button-default-2"/>
	
	<fmt:message key='m1.skin.background.eben.label' bundle='${mobileManageBundle}' /></td></tr>
	 <tr><td align="right">
	</td><td align="left">
	<input type="button" value="<fmt:message key='button.mm.restore_default' bundle='${mobileManageBundle}' />" id="restoreDefault" class="button-default-2"/>
	</td></tr>
	</table>
	</td>
	</tr>
	<tr><td width="5%"></td><td align="left"  valign="middle" width="36%" height="80%">
	
     <div id="dv1" >
		<img id="bgv" src="${bgvpath}" />
		<div id="dv2"  >
			<img id="loginpageimg" src="${bgpath}" />
			
		</div>
		<div id="dv3"  >
			<img id="logo" src="${logopath}" />
		</div>
	</div>
	
	</tr>
	<tr><td width="5%"></td><td  align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" value="<fmt:message key='button.mm.preview' bundle='${mobileManageBundle}' />" id="showimage" class="button-default-2"/>&nbsp;
		<input type="button" value="<fmt:message key='button.mm.save' bundle='${mobileManageBundle}' />"  id="saveimage" class="button-default-2 button-default_emphasize"/>&nbsp;
		<input type="button" value="<fmt:message key='button.mm.cansle' bundle='${mobileManageBundle}' />" id="cansleupload" class="button-default-2"/>
</td>
	</tr>
</table>
</form>
</body>
</html>