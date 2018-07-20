<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>E人E本</title>
<%@ include file="./header.jsp"%> 

<script type="text/javascript">
	$(document).ready(function(){
	$("#pageclose").click(function(){
			
			window.close();
		});
		
	});
</script>

</head>

<body ><center>
<table border ='0' width='80%' height="95%">
	<tr height="80%">
		<td align="center" valign="bottom" width="36%"></br></br></br>
		<div id="eben_v1" style="position: relative;z-index:0;left:0;width:340px;height:450px;display:'';">
			<img id="eben_bgv" src="${m1vbg}" style="position:absolute;left:0;top:0;width:100%;height:100%;z-Index:-1;"/>
			<div id="eben_v2" style="position:absolute;left:13%;top:11%;width:68%;height:71%;display:'';">
				<img id="eben_loginpage" src="${bgimg}" style="position:absolute;left:0px;top:0px;width:100%;height:100%;z-Index:-1;" />
				<div id="eben_v3" style="position:absolute;z-index:0;left:30%;top:15%;width:40%;height:28%;text-align:center;display:'';">
					<img id="eben_logo" src="${limg}" style="position:absolute;left:0px;top:0px;width:100%;height:100%;z-Index:-1;" />
				</div>
			</div>
		</div>
		</td>
	</tr>
	<tr>
		<td align="center"  height="5%" width="40%">
			<input type="button" value="&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key='m1.skin.showImg.cancel' bundle='${mobileManageBundle}'/>&nbsp;&nbsp;&nbsp;&nbsp;" id="pageclose"/>
			
		</td>
	</tr>
</table>

</body>
</html>