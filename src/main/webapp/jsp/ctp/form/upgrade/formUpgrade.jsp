
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
	<head>
		<title>表单动态数据表字段类型更改</title>
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
	<body><br><br>
		<form action='${path}/form/formUpgrade.do?method=viewUpgrade' 
				id='upgradeForm' name='upgradeForm' method="post" target='spaceIframe'>
			<table align='center' style='width:50%'>
				<tr>
					<th style='width:50%' align='left'>表单样式(含业务生成器)升级:</th>
					<th align='center'></th>
				</tr>
				<tr>
					<td align='center' colspan=2>
						<c:if test="${viewUpgrade}">
							<label><font color='green'>表单已经升级成功</font></label>
						</c:if>
						<c:if test="${viewUpgradeing}">
							<label><font color='yellow'>表单升级中，请稍候</font></label>
						</c:if>
						<c:if test="${not viewUpgrade and not viewUpgradeing}">
							<input  type="button" onclick="toUpgrade()" value='表单样式升级' />
						</c:if>
					</td>
				</tr>
			</table>
		</form><br>
		<c:if test="${viewUpgrade}">
		<form action='${path}/form/formUpgrade.do?method=upgradeColumType' method="post" target='spaceIframe'>
			<table align='center' style='width:50%'>
				<tr>
					<th style='width:50%' align='left'>数据库字段类型更改:</th>
					<th align='center'></th>
				</tr>
				<tr>
					<td align='right'><font color='red'>*</font>数据库类型：</td>
					<td>
						<select name='dbType' id='dbType' >
							<option value="">请选择</option>
							<option value=MySQL>MySQL</option>
							<option value="SQLServer">SQLServer</option>
							<option value="Other">其他</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align='right'><font color='red'>*</font>表 单名 称：</td>
					<td><input type='text' name='formName' id='formName' /></td>
				</tr>
				<tr>
					<td align='right'><font color='red'>*</font>数据域名称：</td>
					<td><input type='text' name='cloumName' id='cloumName' /></td>
				</tr>
				<tr>
					<td align='right'><font color='red'>*</font>目 标类 型：</td>
					<td>
						<select name='cloumType' id='cloumType' class='select'>
							<!--  <option value="">请选择</option>
							<option value="varchar">文本</option>
							<option value="number">数值</option>-->
							<option value="timestamp">日期</option>
							<option value="datetime">日期时间</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan=2 align='center'>
						<input type='submit' value='提交' />
						<input type='reset' value='重置'/>
					</td>
				</tr>
			</table>
		</form><br>
		</c:if>
		<c:if test="${ not viewUpgradeing}">
		<form action='${path}/form/formUpgrade.do?method=updateFormCatch' method="post" target='spaceIframe'>
			<table align='center' style='width:50%'>
				<tr>
					<th style='width:50%' align='left'>更新表单缓存:</th>
					<th align='center'></th>
				</tr>
				<tr>
					<td align='right'><font color='red'>*</font>表 单名 称：</td>
					<td><input type='text' name='formName' id='formName' /></td>
				</tr>
				<tr>
					<td colspan=2 align='center'>
						<input type='submit' value='更新表单缓存' />
					</td>
				</tr>
			</table>
		</form>
		</c:if>
		<iframe id="spaceIframe" name="spaceIframe" marginheight="0" marginwidth="0" width="0" height="0"></iframe>
	</body>
	
</html>