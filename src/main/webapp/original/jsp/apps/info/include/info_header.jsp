<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<!-- 
暂时没有用到这三个变量，打开会影响应用设置下面的信息模版新建页面的在ie9下面的样式
<html:link renderURL="/element/element.do" var="elementControllerURL" />
<html:link renderURL="/form/govform.do" var="govformControllerURL" />
<html:link renderURL="/category/category.do" var="categoryControllerURL" /> -->
<c:set value="${path}/doc.do" var="docURL" />
<c:set value="${path}/collaboration/collaboration.do" var="colURL" />
<c:set value="${path}/mtMeeting.do" var="mtMeetingURL" />
<c:set value="${path}/edocController.do" var="detailURL" />
<c:set value="${path}/info/infoMain.do" var="infoMainControllerURL" />
<c:set value="${path}/info/infoList.do" var="infoListControllerURL" />
<c:set value="${path}/info/info.do" var="infoControllerURL" />


<script type="text/javascript" src="${path}/ajax.do?managerName=infoLockManager"></script>
<c:set var="appType" value="32"></c:set>
<c:set var="appName" value="info"></c:set>

<script type="text/javascript">

var docURL = "${docURL}";
var colURL = "${colURL}";
var mtMeetingUrl = "${mtMeetingURL}";
var genericURL = '${detailURL}';
var edocDetailURL = genericURL;

var govformValidate = false;
var fullEditorURL = "info/info.do?method=openContentDialog";
var appType = 32;
var formType = 0;
var listType = "${listType}";
var _path = "${path}";
var _ctxPath ='${path}';
var hasInfoNewRole = '${hasInfoNewRole}'=='true';
var isGroup = "${ctp:getSystemProperty('system.ProductId')}"=="4" || "${ctp:getSystemProperty('system.ProductId')}"=="2";
var unitView = "infosend.listInfo.reportUnit";
if(!isGroup) {
	unitView = "infosend.listInfo.unitName";
}
</script>
<script type="text/javascript" src="${path}/apps_res/info/js/common/gov_common.js${ctp:resSuffix()}"></script>

