<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%--引入正文内容打印功能扩展js文件 --%>
<c:if test="${printContentJSPath ne null and  printContentJSPath ne ''}">
	<script type="text/javascript" src="${printContentJSPath}${ctp:resSuffix()}"></script>
</c:if>
    <%---------------------------------------准备需要EL表达式输出的变量 引入content.js start-----------------------------------------%>
	<script type="text/javascript">
		var isContentType_office = ${contentList[0].contentType == 20};
		var isContentType_html = ${contentList[0].contentType == 10};
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
		<c:if test="${printContentMethodName ne null}">
			var printContentMethodName = ${printContentMethodName};
		</c:if>
	</script>
	<%---------------------------------------准备需要EL表达式输出的变量 引入content.js end-----------------------------------------%>
<script type="text/javascript" src="${ctp_contextPath}/common/content/content.js${ctp:resSuffix()}"></script>
	