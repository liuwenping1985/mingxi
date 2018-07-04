<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>iPhone</title>
<%@include file="./header.jsp"%>

<script type="text/javascript">

	$(document).ready(function(){
		
		$("#closewindow").click(function(){
			window.close();
			});
		});
</script>
</head>
<body>
<input type="hidden" id="state" name="state" value="0">
<center>
		 <table  border ='0' width='100%' height="90%">
	<!--<tr>	
		
		<td align="center" >
			<table border="0" width="65%" bgcolor="#888888"><tr><td align="center" width="50%"><font size="5"><b>预览</b></font></td><td align="right" width="15%"><input type="button" value="&nbsp;&nbsp;&nbsp;X&nbsp;&nbsp;&nbsp;" onClick="closeWin();"/></td></tr></table>
		</td>
	</tr>-->
	<tr  >
		<td align="center"  width="36%" valign="bottom" height="90%"></br></br></br>
			<div id="iphone_v1" style="position: relative;z-index:0;left:10;width:220px;height:400px;text-align:center;display:'';">
				<img id="iphone_bgv" src="${m1vbg}" style="position:absolute;left:0;top:0;width:100%;height:100%;z-Index:-1;" />
			<div id="iphone_v2" style="position:absolute;left:12%;top:22%;width:78%;height:58%;display:'';">
				<img id="iphone_loginpage" src="${bgimg}" style="position:absolute;left:0;top:0;width:100%;height:100%;z-Index:-1;" />
				<div id="iphone_v3" style="position:absolute;z-index:0;left:25%;top:14%;width:45%;height:25%;text-align:center;display:'';">
					<img id="iphone_logo" src="${limg}" style="position:absolute;left:0;top:0;width:100%;height:100%;z-Index:-1;" />
				</div>
			</div>
			
		</div>
	
		</td>
	</tr>
	<tr>	
		
		<td align="center"  valign="top"></br>
			
			<input type="button" id="closewindow" value="<fmt:message key='m1.skin.showImg.cancel' bundle='${mobileManageBundle}' />"/>
		</td>
	</tr>
	
</table>
	</center>

</body>
</html>