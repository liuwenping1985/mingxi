<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="./header.jsp"%> 
<script type="text/javascript">
	$(document).ready(function(){
	$("#pageclose").click(function(){
			
			window.close();
		});
		
	});
</script>

</head>

<body >
<center>
<table border ='0' width='80%' height="90%">
	<tr height="98%">
		<td align="center"  valign="center" width="36%">
		<div id="ipad_v1" style="position:relative;z-index:0;width:450px;height:320px;text-align:center;display:'';">
			<img id="ipad_bgv" src="${m1vbg}" style="position:absolute;left:0;top:0;width:100%;height:100%;z-Index:-1;"/>
			<div id="ipad_v2" style="position:absolute;z-index:0;left:10%;top:14%;width:80%;height:75%;text-align:center;display:'';">
				<img id="ipad_loginpage" src="${bgimg}" style="position:absolute;left:0px;top:0px;width:100%;height:100%;z-Index:-1;" />
				<div id="ipad_v3" style="position: absolute;z-index:0;left:10%;top:35%;width:27%;height:26%;text-align:center;display:'';">
					<img id="ipad_logo" src="${limg}" style="position:absolute;left:0px;top:0px;width:100%;height:100%;z-Index:-1;" />
				</div>
			</div>
		</div>
		</td>
	</tr>
	<tr>
		<td align="center"  valign="top" height="10%" width="40%"></br>
			<input type="button" value="<fmt:message key='m1.skin.showImg.cancel' bundle='${mobileManageBundle}'/>" id="pageclose"/>
			
		</td>
	</tr>
</table>

</body>
</html>