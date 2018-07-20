
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
	<head>
		<title>旧版本升级</title>
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
		<form action='${path}/govDoc/upgradeControllor.do?method=upgrade' 
				id='upgradeForm' name='upgradeForm' method="post" target='spaceIframe' style="padding-top:50px">
			<table align='center' style='width:900px'>
				<tr>
					<th align='center' style="font-family: 微软雅黑;font-size:18px;padding-bottom:30px">旧版本升级（持续时间与数据大小成正比，请耐心等待。。。）</th>
				</tr>
				<tr>
					<td align='center' style="border:1px solid red; padding:10px 0; font-family: 微软雅黑; ">模板分支条件须重新手动设置，升级说明
					</td>
				</tr>
				<tr>
					<td align='left' style="border:1px solid red; padding:10px 10px;  ">
						<p>一、公文升级</p>
						<p>1.首页栏目分类老公文不支持点击查看详情，也就是不高亮。</p>
						<p>2.老公文归档后  没有实现 推送到门户。</p>
						<p>二、角色权限升级</p>
						<p>1.删除了所有单位的单位公文收发员、归档公文修改、收文分发，添加了三个单位角色：单位公文送文员，单位公文收文员，单位公文统计员，四个部门角色：部门公文收文员，部门公文送文员，部门督办联络员，部门会议联络员。</p>
						<p>2.新版本人员如需发文拟文、签报拟文，需要给人员分配发文拟文、签报拟文角色，而不是给人员已有的角色分配发文拟文、签报拟文资源。如果某人的发文拟文资源权限只来自于组织角色，那么升级之后该人员的拟文权限将会取消，需手动分配给该人员发文拟文角色。</p>
						<p>本次升级并没有给以前具有发文拟文资源的人员分配发文拟文角色。签报拟文、收文登记同理。</p>
						<p>三、模板升级</p>
						<p>1.流程模板和格式模板不升级。</p>
						<p>2.模板升级，公文元素的值不进行升级。</p>
						<p>3.公文模板文单中的内容无法升级。</p>
						<p>四、流程升级</p>
						<p>1.手动分支:条件保留。</p>
						<p>2.自动分支：条件全部清除，需要重新设置。</p>
						<dl>
							<dt>五、待办公文处理 跳转规则</dt>
							<dd>1.首页待办进入涉及到页面跳转的（老公文登记和分发），如果有二级菜单权限，跳转到二级菜单列表，没有则默认跳到对应的（收文或发文）公文管理的待办界面。</dd>
							<dd>2.二级菜单进入，进入涉及到页面跳转的（老公文登记和分发），跳转到二级菜单的待办公文 界面。</dd>
							<dd>3.三级菜单进入，进入涉及到页面跳转的（老公文登记和分发），跳转到三级菜单的 （收文或发文）公文管理的待办界面。</dd>
						</dl>
					</td>
				</tr>
				<tr>
					<td align='center' colspan=2 style="padding-top:30px;">
						<c:if test="${govdocUpgrad == 2}">
							<label><font color='green' style="font-family: 微软雅黑">无需升级</font></label>
						</c:if>
						<c:if test="${govdocUpgrad == 3}">
							<label><font color='red' style="font-family: 微软雅黑">升级中，请稍候</font></label>
						</c:if>
						<c:if test="${govdocUpgrad == 4}">
							<label><font color='red' style="font-family: 微软雅黑">升级出错，请联系致远客服、研发</font></label>
						</c:if>
						<c:if test="${govdocUpgrad == 5}">
							<label><font color='green' style="font-family: 微软雅黑">升级已经完成</font></label>
						</c:if>
						<c:if test="${govdocUpgrad == 1}">
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
						</c:if>
					</td>
				</tr>
			</table>
		</form><br>
		<iframe id="spaceIframe" name="spaceIframe" marginheight="0" marginwidth="0" width="0" height="0"></iframe>
	</body>
	