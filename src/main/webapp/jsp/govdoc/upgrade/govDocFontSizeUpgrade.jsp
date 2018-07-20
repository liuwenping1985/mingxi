
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
	<head>
		<title>公文字数升级</title>
		<style type="text/css">
			td p{
				line-height:25px;
				font-family: 微软雅黑;
			}
			dt{
				font-family: 微软雅黑;
			}
			dd{
				font-family: 微软雅黑;
			}
		</style>
<script type="text/javascript">
	function _reflush(){
		if(window.parent)
			window.parent.location.reload();
		else
			window.location.reload();
	}

	function toUpgrade(){
		document.getElementById("upgradeForm").submit();
		$.progressBar();
	}
	
</script>
	</head>
	<body>
		<form action='${path}/govDoc/upgradeFontSizeControllor.do?method=upgrade' 
				id='upgradeForm' name='upgradeForm' method="post" target='spaceIframe' style="padding-top:50px">
			<table align='center' style='width:900px'>
				<tr>
					<th align='center' style="font-family: 微软雅黑;font-size:18px;padding-bottom:30px">公文字数统计旧版本升级（持续时间与数据大小成正比，请耐心等待。。。）</th>
				</tr>				
				<tr>
					<td align='center' colspan=2 style="padding-top:30px;">
							<script type="text/javascript">
								var userAgent = navigator.userAgent;
								var rMsie = /(msie\s|trident.*rv:)([\w.]+)/;
								var ua = userAgent.toLowerCase();
								var match = rMsie.exec(ua);  
								if(match != null){  
									document.write("<input type='button' onclick='toUpgrade()' value='确定升级' class='common_button common_button_emphasize'/>");
								}else{
									document.write("<span style='color:red'>需要升级，请使用IE浏览器进行升级。<span>");
								}
							</script>					
					</td>
				</tr>
			</table>
		</form><br>
		<iframe id="spaceIframe" name="spaceIframe" marginheight="0" marginwidth="0" width="0" height="0"></iframe>
	</body>
	