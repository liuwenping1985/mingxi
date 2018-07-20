<%@page import="com.seeyon.ctp.organization.bo.V3xOrgEntity"%>
<%@page import="com.seeyon.ctp.organization.bo.V3xOrgPost"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="com.seeyon.ctp.common.AppContext" %>
<%@ page import="com.seeyon.ctp.util.Strings" %>
<%@ page import="com.seeyon.ctp.util.ListSearchHelper" %>
<%@ page import="com.seeyon.ctp.organization.manager.OrgManager" %>
<%@ page import="com.seeyon.ctp.organization.manager.OrgManagerDirect" %>
<%@ page import="com.seeyon.ctp.organization.bo.V3xOrgLevel" %>
<%@ page import="com.seeyon.ctp.organization.bo.V3xOrgAccount" %>
<%@ page import="com.seeyon.ctp.organization.webmodel.WebV3xOrgAccount" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources"           var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.localeselector.resources.i18n.LocaleSelectorResources" var="localeI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"                     var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources"                          var="v3xHRI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.plugin.ldap.resource.i18n.LDAPSynchronResources"       var="ldaplocale"/>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"     var="organizationI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource"                     var="edocI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.flowperm.resources.i18n.FlowPermResource"              var="flowpermI18N"/>
<!-- 搜索框开始 -->
<script type="text/javascript" src="<c:url value='/common/js/util/URI.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript">
<%
String expressionTypeParamName = StringUtils.trimToNull(request.getParameter("expressionTypeParamName"));
if (expressionTypeParamName == null) {
	expressionTypeParamName = ListSearchHelper.defaultExpressionTypeParamName;
}
String expressionValueParamName = StringUtils.trimToNull(request.getParameter("expressionValueParamName"));
if (expressionValueParamName == null) {
	expressionValueParamName = ListSearchHelper.defaultExpressionValueParamName;
}
%>
var windowToLoad = ${(empty param.windowToLoad)?"window" : param.windowToLoad};
var expressionTypeParamName = '<%=expressionTypeParamName%>';
var expressionValueParamName = '<%=expressionValueParamName%>';
var et2itMap = new Object();
<%
String expressionType = request.getParameter("expressionType");
String expressionValue = ListSearchHelper.decodeBase64(request.getParameter("expressionValueBase64"));
String currentInputType = null;
String inputTypeTemp;
String expressionTypes = request.getParameter("expressionTypes");
String[] ets = expressionTypes.split(";");
String[][] etArray = new String[ets.length][];
Set<String> inputTypeSet = new HashSet<String>();
//Map<String, String> et2itMap = new HashMap<String, String>();
for (int i=0; i<ets.length; i++) {
	etArray[i] = ets[i].split(":");
	inputTypeSet.add(etArray[i][2]);
//	et2itMap.put(etArray[i][0], etArray[i][2]);
	if (etArray[i][0].equals(expressionType)) {
		currentInputType = etArray[i][2];
	}
%>
et2itMap["<%=etArray[i][0]%>"] = "<%=etArray[i][2]%>";
<%
}
%>
/**
 * 切换搜索条件
 */
function showSpecialExpressionInput(etObj) {
	var options = etObj.options;
	for (var i = 1; i < options.length; i++) {
		var d = document.getElementById(et2itMap[options[i].value] + "Div");
		if (d) {
			d.style.display = "none";
		}
	}
	var eiToShow = document.getElementById(et2itMap[etObj.value] + "Div");
	if (eiToShow) {
		eiToShow.style.display = "block";
	}
}
/**
 * 搜索
 */
function doSearch(formId) {
	var searchForm = document.getElementById(formId);
	var et = searchForm.expressionType.value;
	var ev;
	if (et === "") {
		ev = "";
	} else {
		ev = searchForm.elements[et2itMap[et]].value;
		//if (ev === "") {
		//	alert(_("V3XLang.index_input_error"));
		//	return;
		//}
	}
	var newUri = windowToLoad.location.href;
	newUri = processUriParam(newUri, expressionTypeParamName,  et);
	newUri = processUriParam(newUri, expressionValueParamName, ev);
	newUri = processUriParam(newUri, "page", "");
	newUri = processUriParam(newUri, "pageSize", "");
	windowToLoad.location.href = newUri;
}
</script>
<div class="div-float-right" style="vertical-align:middle;">
<form id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
	<div class="div-float">
		<select id="<%=expressionTypeParamName%>" name="expressionType" onChange="showSpecialExpressionInput(this)" class="condition" style="width: 120px;">
	    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
			<%
			for (int i=0; i<ets.length; i++) {
				pageContext.setAttribute("expressionTypeName", etArray[i][1]);
				if ("post".equals(etArray[i][0]) && "false".equals(request.getParameter("isEnablePost"))) {
				    continue;
				}
				if ("level".equals(etArray[i][0]) && "false".equals(request.getParameter("isEnableLevel"))) {
                    continue;
                }
				if ("companyPhone".equals(etArray[i][0]) && "false".equals(request.getParameter("isEnablePhone"))) {
                    continue;
                }
				if ("mobilePhone".equals(etArray[i][0]) && "false".equals(request.getParameter("isEnableMobile"))) {
                    continue;
                }
			%>
			<option value="<%=etArray[i][0]%>" <%=(etArray[i][0].equals(expressionType)?"selected":"")%>><fmt:message key="${expressionTypeName}" bundle="${v3xMainI18N}"/></option>
			<%
			}
			%>
	  	</select>
  	</div>
  	<!-- 自由文本 -->
  	<%
  	inputTypeTemp = "freeText";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  		pageContext.setAttribute("expressionValue", f ? expressionValue : "");
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
		<input type="text" name="<%=inputTypeTemp%>" maxLength="20" class="textfield-search" value="<c:out value="${expressionValue}"/>" onkeydown="javascript:if(event.keyCode==13)doSearch('searchForm');">
  	</div>
  	<%
  	}
  	%>
  	<!-- 组状态 -->
  	<%
  	inputTypeTemp = "teamIfEnabled";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
  		<select name="<%=inputTypeTemp%>" class="textfield-search">
  			<option value="1" <%=f&&"1".equals(expressionValue)?"selected":""%>><fmt:message key="common.state.normal.label" bundle="${v3xCommonI18N}"/></option>
  			<option value="0" <%=f&&"0".equals(expressionValue)?"selected":""%>><fmt:message key="common.state.invalidation.label" bundle="${v3xCommonI18N}"/></option>
  		</select>
  	</div>
  	<%
  	}
  	%>
  	<!-- 组权限属性 -->
  	<%
  	inputTypeTemp = "teamIfPrivate";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
  		<select name="<%=inputTypeTemp%>" class="textfield-search">
  			<option value="1" <%=f&&"1".equals(expressionValue)?"selected":""%>><fmt:message key="org.team_form.privateteam" bundle="${organizationI18N}"/></option>
  			<option value="0" <%=f&&"0".equals(expressionValue)?"selected":""%>><fmt:message key="org.team_form.openteam" bundle="${organizationI18N}"/></option>
  		</select>
  	</div>
  	<%
  	}
  	%>
	<!-- 岗位。如果selectPeople的参数可以在js中控制（例如在selectPeopleFun_xxx中加个参数），那么这几个就可以合为一个了 -->
  	<%
  	if ("true".equals(request.getParameter("isEnablePost"))) {
  	inputTypeTemp = "orgPost";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  		pageContext.setAttribute("expressionValue", f ? expressionValue : "");
  		Long accountId = AppContext.currentAccountId();
  		if (Strings.isNotBlank(request.getParameter("accountId"))) {
            accountId = Long.parseLong(request.getParameter("accountId"));
        }
  		pageContext.setAttribute("accountId", accountId);
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
		<script type="text/javascript">
		function setSearchPost(elements){
			if (elements) {
				document.getElementById("orgPostId").value = getIdsString(elements, false);
				document.getElementById("orgPostName").value = getNamesString(elements);
			}
		}
		<c:if test="${not empty accountId}">
		accountId_post = "${accountId}";
		</c:if>
		onlyLoginAccount_post = true;
		</script>
		<v3x:selectPeople id="post" minSize="0" maxSize="20" panels="Post" selectType="Post" jsFunction="setSearchPost(elements)" originalElements="${v3x:parseElementsOfIds(expressionValue, 'Post')}" />
		<input type="hidden" id="orgPostId" name="<%=inputTypeTemp%>" value="<c:out value="${expressionValue}"/>" />
  		<input type="text" id="orgPostName" class="textfield-search" readonly="readonly" size="18" onclick="selectPeopleFun_post()" onkeydown="javascript:if(event.keyCode==13)doSearch('searchForm');"
			value="${v3x:showOrgEntitiesOfIds(expressionValue, 'Post', pageContext)}" />
  	</div>
  	<%
  	}}
  	%>
  	<!-- 集团基准岗  -->
  	<%
  	inputTypeTemp = "groupPostList";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  		pageContext.setAttribute("expressionValue", f ? expressionValue : "");
  		OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
  		V3xOrgAccount rootAccount = orgManager.getRootAccount();
  		List<V3xOrgPost> bPostList = orgManager.getAllPosts(rootAccount.getId());
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
  		<select name="<%=inputTypeTemp%>" class="textfield-search">
  			<%
  			for (V3xOrgPost bPost : bPostList) {
  				pageContext.setAttribute("bPost", bPost);
  			%>
  			<option value="<c:out value="${bPost.id}"/>" <%=f&&bPost.getId().toString().equals(expressionValue)?"selected":""%>><c:out value="${bPost.name}"/></option>
  			<%
  			}
  			%>
  		</select>
  	</div>
  	<%
  	}
  	%>
  	<!-- 集团职务级别  -->
  	<%
  	inputTypeTemp = "groupLevelList";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  		pageContext.setAttribute("expressionValue", f ? expressionValue : "");
  		OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
  		V3xOrgAccount rootAccount = orgManager.getRootAccount();
  		List<V3xOrgLevel> bLevelList = orgManager.getAllLevels(rootAccount.getId());
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
  		<select name="<%=inputTypeTemp%>" class="textfield-search">
  			<%
  			for (V3xOrgLevel bLevel : bLevelList) {
  				pageContext.setAttribute("bLevel", bLevel);
  			%>
  			<option value="<c:out value="${bLevel.id}"/>" <%=f&&bLevel.getId().toString().equals(expressionValue)?"selected":""%>><c:out value="${bLevel.name}"/></option>
  			<%
  			}
  			%>
  		</select>
  	</div>
  	<%
  	}
  	%>
  	<!-- 职务级别（弹出窗口） -->
  	<%
  	inputTypeTemp = "orgLevel";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  		pageContext.setAttribute("expressionValue", f ? expressionValue : "");
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
		<script type="text/javascript">
		function setSearchLevel(elements){
			if (elements) {
				document.getElementById("orgLevelId").value = getIdsString(elements, false);
				document.getElementById("orgLevelName").value = getNamesString(elements);
			}
		}
		</script>
		<v3x:selectPeople id="level" minSize="0" maxSize="20" panels="Level" selectType="Level" jsFunction="setSearchLevel(elements)" originalElements="${v3x:parseElementsOfIds(expressionValue, 'Level')}" />
		<input type="hidden" id="orgLevelId" name="<%=inputTypeTemp%>" value="<c:out value="${expressionValue}"/>" />
  		<input type="text" id="orgLevelName" class="textfield-search" readonly="readonly" size="18" onclick="selectPeopleFun_level()" onkeydown="javascript:if(event.keyCode==13)doSearch('searchForm');"
			value="${v3x:showOrgEntitiesOfIds(expressionValue, 'Level', pageContext)}" />
  	</div>
  	<%
  	}
  	%>
  	<!-- 职务级别（下拉列表） -->
  	<%
  	if ("true".equals(request.getParameter("isEnableLevel"))) {
  	inputTypeTemp = "orgLevelList";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  		pageContext.setAttribute("expressionValue", f ? expressionValue : "");
  		OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
        Long accountId = AppContext.currentAccountId();
        if (Strings.isNotBlank(request.getParameter("accountId"))) {
            accountId = Long.parseLong(request.getParameter("accountId"));
        }
  		List<V3xOrgLevel> levelList = orgManager.getAllLevels(accountId);
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
  		<select name="<%=inputTypeTemp%>" class="textfield-search">
  			<%
  			for (V3xOrgLevel level : levelList) {
  				pageContext.setAttribute("level", level);
  			%>
  			<option value="<c:out value="${level.id}"/>" <%=f&&level.getId().toString().equals(expressionValue)?"selected":""%>><c:out value="${level.name}"/></option>
  			<%
  			}
  			%>
  		</select>
  	</div>
  	<%
  	}}
  	%>
  	<!-- 单位（下拉列表） -->
  	<%
  	inputTypeTemp = "orgAccountList";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  		pageContext.setAttribute("expressionValue", f ? expressionValue : "");
  		OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
  		OrgManagerDirect orgManagerDirect = (OrgManagerDirect) AppContext.getBean("orgManagerDirect");
        Integer maxSortNum = orgManagerDirect.getMaxSortNum(V3xOrgAccount.class.getSimpleName(),AppContext.getCurrentUser().getLoginAccount());
        V3xOrgAccount account = new V3xOrgAccount();
        account.setSortId(maxSortNum.longValue() + 1);
        account.setEnabled(true);
        WebV3xOrgAccount webaccount = new WebV3xOrgAccount();
        webaccount.setV3xOrgAccount(account);        
        pageContext.setAttribute("account", webaccount);
        List<V3xOrgAccount> accountList = orgManager.getAllAccounts();
  		pageContext.setAttribute("accountList", accountList);
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
  		<select name="<%=inputTypeTemp%>" class="textfield-search">
			<c:forEach var="a" items="${accountList}">
				<c:if test="${a.superior == null || a.superior == -1}">
					<option value="${a.id}"><c:out value="${a.name}"/></option>
					<%-- TODO fenghao ${main:accountList2Tree(accountList, a.id, account.v3xOrgAccount.superior, 1, pageContext)} --%>
				</c:if>
			</c:forEach>
  		</select>
  	</div>
  	<%
  	}
  	%>
  	<!-- 单位，单选 -->
  	<%
  	inputTypeTemp = "orgAccount";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  		pageContext.setAttribute("expressionValue", f ? expressionValue : "");
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
		<script type="text/javascript">
		function setSearchAccount(elements){
			if (elements) {
				document.getElementById("orgAccountId").value = getIdsString(elements, false);
				document.getElementById("orgAccountName").value = getNamesString(elements);
			}
		}
		</script>
		<v3x:selectPeople id="account" minSize="0" maxSize="1" panels="Account" selectType="Account" jsFunction="setSearchAccount(elements)" originalElements="${v3x:parseElementsOfIds(expressionValue, 'Account')}" />
		<input type="hidden" id="orgAccountId" name="<%=inputTypeTemp%>" value="<c:out value="${expressionValue}"/>" />
  		<input type="text" id="orgAccountName" class="textfield-search" readonly="readonly" size="18" onclick="selectPeopleFun_account()" onkeydown="javascript:if(event.keyCode==13)doSearch('searchForm');"
			value="${v3x:showOrgEntitiesOfIds(expressionValue, 'Account', pageContext)}" />
  	</div>
  	<%
  	}
  	%>
  	<!-- 部门 -->
  	<%
  	inputTypeTemp = "orgDepartment";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  		pageContext.setAttribute("expressionValue", f ? expressionValue : "");
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
		<script type="text/javascript">
		function setSearchDepartment(elements){
			if (elements) {
				document.getElementById("orgDepartmentId").value = getIdsString(elements, false);
				document.getElementById("orgDepartmentName").value = getNamesString(elements);
			}
		}
		</script>
		<v3x:selectPeople id="dept" minSize="0" maxSize="20" panels="Department" selectType="Department" jsFunction="setSearchDepartment(elements)" originalElements="${v3x:parseElementsOfIds(expressionValue, 'Department')}" />
		<input type="hidden" id="orgDepartmentId" name="<%=inputTypeTemp%>" value="<c:out value="${expressionValue}"/>" />
  		<input type="text" id="orgDepartmentName" class="textfield-search" readonly="readonly" size="18" onclick="selectPeopleFun_dept()" onkeydown="javascript:if(event.keyCode==13)doSearch('searchForm');"
			value="${v3x:showOrgEntitiesOfIds(expressionValue, 'Department', pageContext)}" />
  	</div>
  	<%
  	}
  	%>
  	<!-- 部门及岗位 -->
  	<%
  	inputTypeTemp = "orgDepartmentAndPost";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  		pageContext.setAttribute("expressionValue", f ? expressionValue : "");
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
		<script type="text/javascript">
		function setSearchDepartmentAndPost(elements){
			if (elements) {
				document.getElementById("orgDepartmentAndPostId").value = getIdsString(elements, false);
				document.getElementById("orgDepartmentAndPostName").value = getNamesString(elements);
			}
		}
		</script>
		<v3x:selectPeople id="deptAndPost" minSize="0" maxSize="20" panels="Department" selectType="Post" jsFunction="setSearchDepartmentAndPost(elements)" originalElements="${v3x:parseElementsOfIds(expressionValue, 'Department')}" />
		<input type="hidden" id="orgDepartmentAndPostId" name="<%=inputTypeTemp%>" value="<c:out value="${expressionValue}"/>" />
  		<input type="text" id="orgDepartmentAndPostName" class="textfield-search" readonly="readonly" size="18" onclick="selectPeopleFun_deptAndPost()" onkeydown="javascript:if(event.keyCode==13)doSearch('searchForm');"
			value="${v3x:showOrgEntitiesOfIds(expressionValue, 'Department', pageContext)}" />
  	</div>
  	<%
  	}
  	%>
  	
  	<!-- 单位管理员，公文应用设置，文单定义类型查询 -->
  	<%
  	inputTypeTemp = "edocFormType";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
  		<select name="<%=inputTypeTemp%>" class="textfield-search">
  			<option value="0" <%=f&&"0".equals(expressionValue)?"selected":""%>><fmt:message key="edoc.formstyle.dispatch" bundle="${edocI18N}"/></option>
  			<option value="1" <%=f&&"1".equals(expressionValue)?"selected":""%>><fmt:message key="edoc.formstyle.receipt" bundle="${edocI18N}"/></option>
  			<option value="2" <%=f&&"2".equals(expressionValue)?"selected":""%>><fmt:message key="edoc.formstyle.qianbao" bundle="${edocI18N}"/></option>
  		</select>
  	</div>
  	<%
  	}
  	%>
  	
  	<!-- 单位管理员，公文应用设置，套红模板模板类型 -->
  	<%
  	inputTypeTemp = "edocTemplateType";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
  		<select name="<%=inputTypeTemp%>" class="textfield-search">
  			<option value="0" <%=f&&"0".equals(expressionValue)?"selected":""%>><fmt:message key="edoc.doctemplate.text" bundle="${edocI18N}"/></option>
  			<option value="1" <%=f&&"1".equals(expressionValue)?"selected":""%>><fmt:message key="edoc.doctemplate.wendan" bundle="${edocI18N}"/></option>
  		</select>
  	</div>
  	<%
  	}
  	%>
  	
  	<!-- 公文节点权限-权限类型 -->
  	<%
  	inputTypeTemp = "edocPolicyCatogry";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
  		<select name="<%=inputTypeTemp%>" class="textfield-search">
  			<option value="edoc_send_permission_policy" <%=f&&"edoc_send_permission_policy".equals(expressionValue)?"selected":""%>><fmt:message key="flowperm.type.send" bundle="${flowpermI18N}"/></option>
  			<option value="edoc_rec_permission_policy" <%=f&&"edoc_rec_permission_policy".equals(expressionValue)?"selected":""%>><fmt:message key="flowperm.type.receipt" bundle="${flowpermI18N}"/></option>
  			<option value="edoc_qianbao_permission_policy" <%=f&&"edoc_qianbao_permission_policy".equals(expressionValue)?"selected":""%>><fmt:message key="flowperm.type.qianbao" bundle="${flowpermI18N}"/></option>
  		</select>
  	</div>
  	<%
  	}
  	%>
  	
	<!-- 信息节点权限-权限类型 -->
  	<%
  	inputTypeTemp = "type";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  	%>
  	<div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
  		<select name="<%=inputTypeTemp%>" class="textfield-search">
  			<option value="0" <%=f&&"0".equals(expressionValue)?"selected":""%>><fmt:message key="flowperm.type.system" bundle="${flowpermI18N}"/></option>
  			<option value="1" <%=f&&"1".equals(expressionValue)?"selected":""%>><fmt:message key="flowperm.type.custome" bundle="${flowpermI18N}"/></option>
  		</select>
  	</div>
  	<%
  	}
  	%>  	
  	
  	<!--节点权限-引用查询 -->
  	<%
  	inputTypeTemp = "isRef";
  	if (inputTypeSet.contains(inputTypeTemp)) {
  		boolean f = inputTypeTemp.equals(currentInputType);
  		String s = f ? "block" : "none";
  	%>
  <div id="<%=inputTypeTemp%>Div" class="div-float hidden" style="display:<%=s%>">
  		<select name="<%=inputTypeTemp%>" class="textfield-search">
  			<option value="1" <%=f&&"1".equals(expressionValue)?"selected":""%>><fmt:message key="picture.move.lable.true" bundle="${v3xMainI18N}"/></option>
  			<option value="0" <%=f&&"0".equals(expressionValue)?"selected":""%>><fmt:message key="picture.move.lable.false" bundle="${v3xMainI18N}"/></option>
  		</select>
  	</div>
  	<%
  	}
  	%>
  	
	<!-- 搜索按钮 -->
	<div id="grayButton" onclick="javascript:doSearch('searchForm')" class="div-float condition-search-button"></div>
</form>
</div>
<!-- 搜索框结束 -->