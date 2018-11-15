<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${ctp:i18n('form.flow.show')}</title>
</head>
<body>
	<table class="margin_t_5 font_size12" style="border: 1px;" width="100%" height="100%" >
		<tr style="background: rgb(144,181,217);">
			<th height="40"  width="40%" ><label>${ctp:i18n('form.export.workflow.fileName')}</label></th> <!-- 文件名 -->
			<th height="20%" width="40%"  style="float: center;">${ctp:i18n('form.export.workflow.compressResult')}</th> <!-- 执行结果 -->
			<th height="20%" width="20%" align="center"></th>
		</tr>
		<tr>
			<c:if test="${url ne null}">
				<td height="40" width="40%" align="center">${fileName}</label></td>
				<td height="20%" width="40%" align="center">
					<c:if test="${state eq true}">${ctp:i18n('form.export.workflow.compressDone')}</c:if> <!-- 已完成 -->
					<c:if test="${state eq false}">${ctp:i18n('form.export.workflow.beingCompressed')}</c:if> <!-- 打包中 -->
				</td>
				<td height="20%" width="20%" align="center">
					<c:if test="${state eq true}"><a id="downloadUrl" href="">${ctp:i18n('form.export.workflow.download')}</a></c:if> <!-- 下载 -->
				</td>
			</c:if>
		</tr>
	</table>
</body>
<script type="text/javascript">
$(function(){
	$("#downloadUrl").attr("href",encodeURI("${url}"));
});
</script>
</html>