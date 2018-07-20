<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@include file="header.jsp"%>
<%@include file="pageCustom_iphone.js.jsp"%>

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>iphone</title>

<script type="text/javascript">
   // var succ = "<fmt:message key='m1.skin.save.success' bundle='${mobileManageBundle}' />";
	
	$(document).ready(function(){
		$('#cansleupload').click(function(){
		cansleImage();
		});
		$('#showImage').click(function(){
			showimg();
		});
		$('#saveChangeImg').click(function(){
			sub();
		});
		$('#restoreDefault').click(function(){
			restore_default();
		});
		

		$('#blogo').click(function(){
			changeImage(3);
		});
		$('#slogo').click(function(){
			changeImage(4);
		});
		$('#bbg').click(function(){
			changeImage(1);
		});
		$('#bbg5').click(function(){
			changeImage(5);
		});
		$('#dv2').click(function(){
			changeImage(1);
		});
		$('#dv2').mousemove(function(){
			this.style.filter="alpha(opacity=30)";
		});
		$('#dv2').mouseout(function(){
			this.style.filter="alpha(opacity=70)";
		});
		//
		$('#dv5').click(function(){
		changeImage(3);
		});
		$('#dv5').mousemove(function(){
			this.style.filter="alpha(opacity=30)";
		});
		$('#dv5').mouseout(function(){
			this.style.filter="alpha(opacity=70)";
		});
		
		
	});
	//点击红色框中区域,进行编辑.图片支持PNG格式,大小不超过500k<a id="hbgi"><u>登录页背景图片</u></a>尺寸为640*920像素
</script>

</head>
<body  onbeforeunload="return tix();"><center>
<form id="form1" action="<html:link renderURL='/clientBind.do'/>?method=uploadImg" method="post">
<input type="hidden" name="fileId1" value="-1">
<input type="hidden" name="fileCreateDate1" value="-1">
<input type="hidden" name="fileId2" value="-1">
<input type="hidden" name="fileCreateDate2" value="-1">
<input type="hidden" name="fileId4" value="-1">
<input type="hidden" name="fileCreateDate4" value="-1">
<input type="hidden" name="bgpath5" value="${bgpath5}">
<input type="hidden" name="bgpath" value="${bgpath}">

<input type="hidden" name="logopath" value="${logopath}">

<table width="78%" height="90%" align="left" border="0">

	<tr><td width="5%"></td><td>
	<table  width="100%"  border="0">
    <tr><td align="right"  width="20%">
	Logo:
	</td><td align="left">
	<input type="text" id="blogoname" value=""/>&nbsp;<input type="button" id="blogo" value="<fmt:message key='button.mm.upload' bundle='${mobileManageBundle}' />"  class="button-default-2"/>&nbsp;<fmt:message key='m1.skin.ihone.log' bundle='${mobileManageBundle}'/>
	</td></tr><tr><td align="right">
	<fmt:message key='m1.skin.background.label' bundle='${mobileManageBundle}'/>:
	<td align="left">
	<input type="text" id="bgname" value="">&nbsp;<input type="button" id="bbg" value="<fmt:message key='button.mm.upload' bundle='${mobileManageBundle}' />"  class="button-default-2"/>&nbsp;
	<fmt:message key='m1.skin.background.iPhone.prompt' bundle='${mobileManageBundle}'/>
	</td></tr><tr><td align="right">
	<fmt:message key='m1.skin.background.iphone.label' bundle='${mobileManageBundle}'/>:
	<td align="left">
	<input type="text" id="bgname5" value="">&nbsp;<input type="button" id="bbg5" value="<fmt:message key='button.mm.upload' bundle='${mobileManageBundle}' />"  class="button-default-2"/>&nbsp;
	<fmt:message key='m1.skin.background.iPhone5.prompt' bundle='${mobileManageBundle}'/></td></tr><tr><td align="right">
</td><td align="left"><input type="button" value="<fmt:message key='button.mm.restore_default' bundle='${mobileManageBundle}' />" id="restoreDefault" class="button-default-2"/>
</td></tr>
	</table>
	</td></tr>
<tr><td width="5%"></td><td align="left" width="36%" height="90%">
    <div id="dv1">
		<img id="bgv" src="${bgvpath}" />
		<div id="dv2" >
			<img id="loginpage" src="${bgpath}" />
			
		</div>
		<div id="dv5" >
			<img id="logo" src="${logopath}" />
		</div>
	</div>
	</td>
	
	</tr>
	<tr><td width="5%"></td><td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" value="<fmt:message key='button.mm.preview' bundle='${mobileManageBundle}' />" id="showImage" class="button-default-2"/>&nbsp;
		<input type="button" value="<fmt:message key='button.mm.save' bundle='${mobileManageBundle}' />"id="saveChangeImg" class="button-default-2"/>&nbsp;
		<input type="button" value="<fmt:message key='button.mm.cansle' bundle='${mobileManageBundle}' />" id="cansleupload" class="button-default-2"/>
</td></tr>
</table>
</form>
</body>
</html>