<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
    <%---------------------------------------准备需要EL表达式输出的变量 引入content.js start-----------------------------------------%>
	<script type="text/javascript">
		var isContentType_office = ("${contentList[0].contentType}" === "20" ? true : false);
		var isContentType_html = ("${contentList[0].contentType}" === "10" ? true : false);
		var style = "${style}";
		var styleName = "${styleName}";
		var mtCfg = ${contentCfg != null?contentCfg.mainbodyTypeListJSONStr:'[]'};
		var CurrentUserId = '${CurrentUser.id}';
		var useWorkflow = "${contentCfg.useWorkflow}";
		<c:if test="${contentCfg.useWorkflow}">
			var wfItemId = '${contentContext.wfItemId}';
			var wfProcessId = '${contentContext.wfProcessId}';
			var wfActivityId = '${contentContext.wfActivityId}';
			var wfCaseId = '${contentContext.wfCaseId}';
			var loginAccount = '${CurrentUser.loginAccount}';
			var moduleTypeName = '${contentContext.moduleTypeName}';
		</c:if>
		var accountId = '${CurrentUser.loginAccount}';
	</script>
	<%---------------------------------------准备需要EL表达式输出的变量 引入content.js end-----------------------------------------%>
<script type="text/javascript" src="${ctp_contextPath}/common/content/content.js${ctp:resSuffix()}"></script>
	