<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="header headerHR" title="${ctp:i18n('wfanalysis.return.home.page') }">
	<a class="headerImg" href="${path}/wfanalysis.do?method=overview" title="${ctp:i18n('wfanalysis.return.home.page') }"> <img src="${path}/apps_res/wfanalysis/css/images/dbImg.png"/>
	</a>
</div>
<div class="navList ">
	<ul class="navBar_ul">
		<li onclick="query('${path}/wfanalysis.do?method=overview');" title="${ctp:i18n("wfanalysis.home.data.screening") }" class="navLi <c:if test="${'overview' eq wfaParam.view}">current</c:if>"><span><em class="<c:if test="${'overview' eq wfaParam.view}">em_current</c:if>"></em>${ctp:i18n("wfanalysis.home.data.screening") }</span></li>
		<li onclick="query('${path}/wfanalysis.do?method=process');" title="${ctp:i18n("wfanalysis.home.process.efficiency") }" class="navLi <c:if test="${'process' eq wfaParam.view}">current</c:if>"><span><em class="<c:if test="${'process' eq wfaParam.view}">em_current</c:if>"></em>${ctp:i18n("wfanalysis.home.process.efficiency") }</span></li>
		<li onclick="query('${path}/wfanalysis.do?method=node');" title="${ctp:i18n("wfanalysis.home.node.efficiency") }" class="navLi <c:if test="${'node' eq wfaParam.view}">current</c:if>"><span><em class="<c:if test="${'node' eq wfaParam.view}">em_current</c:if>"></em>${ctp:i18n("wfanalysis.home.node.efficiency") }</span></li>
		<li onclick="query('${path}/wfanalysis.do?method=account');" title="${ctp:i18n("wfanalysis.unit.title") }" class="navLi <c:if test="${'account' eq wfaParam.view}">current</c:if>"><span><em class="<c:if test="${'account' eq wfaParam.view}">em_current</c:if>"></em>${ctp:i18n("wfanalysis.unit.title") }</span></li>
		<li onclick="query('${path}/wfanalysis.do?method=department');" title="${ctp:i18n("wfanalysis.department.title") }" class="navLi <c:if test="${'department' eq wfaParam.view}">current</c:if>"><span><em class="<c:if test="${'department' eq wfaParam.view}">em_current</c:if>"></em>${ctp:i18n("wfanalysis.department.title") }</span></li>
		<li onclick="query('${path}/wfanalysis.do?method=member');" title="${ctp:i18n("wfanalysis.member.title") }" class="navLi <c:if test="${'member' eq wfaParam.view}">current</c:if>"><span><em class="<c:if test="${'member' eq wfaParam.view}">em_current</c:if>"></em>${ctp:i18n("wfanalysis.member.title") }</span></li>
	</ul>
</div>