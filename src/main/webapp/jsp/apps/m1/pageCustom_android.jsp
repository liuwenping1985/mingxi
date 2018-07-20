<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@include file="header.jsp"%>
<%@include file="pageCustom_android.js.jsp"%>

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>android</title>
<script type="text/javascript">
$(document).ready(function(){
	//$('#changeword').click(function(){
		//$('#editwordbg').show();
		//$('#editword').show();
	//});
	$('#cansleupload').click(function(){
		cansleImage();
	});
	$('#blogo').click(function(){
		changeImage(2);
	});
	$('#slogo').click(function(){
		changeImage(3);
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

	$('#d3').click(function(){
		changeImage(1);
	});
	$('#d3').mousemove(function(){
		this.style.filter="alpha(opacity=30)";
	});
	$('#d3').mouseout(function(){
		this.style.filter="alpha(opacity=70)";
	});
	
	$('#dd4').click(function(){
		changeImage(2);
	});
	$('#dd4').mousemove(function(){
		this.style.filter="alpha(opacity=30)";
	});
	$('#dd4').mouseout(function(){
		this.style.filter="alpha(opacity=100)";
	});

	
});
//点击红色框中区域,进行编辑.图片支持PNG格式,大小不超过1M,<a id="changeLoginbg"><u>登录页背景图片</u></a>&nbsp;,尺寸为768*1004像素;<a id="changelogo"><u>首页logo图片</u></a>&nbsp;，//透明背景，尺寸为64*64像素;<a id="changeword"><u>首页顶部文字</u></a>，字数不超过24个。
</script>

</head>

<body  onbeforeunload="return tix();"><center>
<form id="form1" action="<c:url value='/m1/changeImgController.do'/>?method=uploadImg" method="post">
<input type="hidden" name="fileId1" value="-1">
<input type="hidden" name="fileCreateDate1" value="-1">
<input type="hidden" name="fileId2" value="-1">
<input type="hidden" name="fileCreateDate2" value="-1">
<input type="hidden" name="bgpath" value="${bgpath}">

<input type="hidden" name="logopath" value="${logopath}">

<table width="70%" align="left" border="0"  height="90%">

	<tr><td width="5%"></td><td>
	<table  width="100%"  border="0"  height="100%">
    
    <tr><td align="right">
	Logo:
	</td><td align="left">
	<input type="text" id="logoname" value=""/> <input type="button" id="blogo" value="<fmt:message key='button.mm.upload' bundle='${mobileManageBundle}' />"  class="button-default-2"/>
	
	<fmt:message key='m1.skin.android.log' bundle='${mobileManageBundle}' />
	</td></tr><tr><td align="right">
	<fmt:message key='m1.skin.background.label' bundle='${mobileManageBundle}' />:
	</td><td align="left">
	<input type="text" id="bgname" value=""> <input type="button" id="bbg" value="<fmt:message key='button.mm.upload' bundle='${mobileManageBundle}' />"  class="button-default-2"/>
	<fmt:message key='m1.skin.background.android.label' bundle='${mobileManageBundle}' />
	</td></tr>
		<tr><td align="right">
	</td><td align="left">
	<input type="button" value="<fmt:message key='button.mm.restore_default' bundle='${mobileManageBundle}' />" id="restoreDefault" class="button-default-2"/>
	</td></tr>
		</table>
	</td>
    </tr>
    <tr><td width="5%"></td><td align="left"  valign="middle" width="45%" height="90%">
    <div id="d1" >
		<img id="bgv" src="${bgvpath}" />
		<div id="dd4"  >
			<img id="logo" src="${logopath}" />
		</div>
	<div id="d3"  >
			 <img id="loginpageimg" src="${bgpath}"/> 
		</div>
	</div>

	</td>
	</tr>
	<tr><td width="5%"></td><td  align="left"></br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" value="<fmt:message key='button.mm.preview' bundle='${mobileManageBundle}' />" id="showimage" class="button-default-2"/>&nbsp;
		<input type="button" value="<fmt:message key='button.mm.save' bundle='${mobileManageBundle}' />"  id="saveimage" class="button-default-2"/>&nbsp;
		<input type="button" value="<fmt:message key='button.mm.cansle' bundle='${mobileManageBundle}' />" id="cansleupload" class="button-default-2"/>
</td>
	</tr>
</table>
</form>
</body>
</html>