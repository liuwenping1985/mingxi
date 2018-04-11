<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
	/* 部门/人员名称 */
	.orgName {display: inline-block; width: 85%; text-overflow: ellipsis; overflow: hidden; white-space: nowrap; vertical-align: middle;cursor: pointer;}
</style>
<div class="overflow">
	<div class="left nav_img " title="返回首页">
		<a class="headerImg" href="${path}/behavioranalysis.do?method=${method}" title="返回首页"> <img
			src="${path}/apps_res/behavioranalysis/image/${wfParam.dptType == 3 ? 'personal.png' : 'orgin.png'}" width="48"
			height="40" alt=""/>
		</a>
	</div>
	<div class="right">
		<div class="query_msg_div">
			<%--组织绩效(部门/机构) --%>
			<div class="query_msg left <c:if test='${wfParam.dptType == 3 }'>hidden</c:if>">
				<span class="color99 search_span">部门/人员</span>
				<div>
					<span class="color99 orgName" id="orgName" onclick="behaviorUtil.selectOrganization()">${wfParam.orgName}</span> <span
						class="ico16 selection_16" onclick="behaviorUtil.selectOrganization()"></span>
				</div>
			</div>
			<div class="query_msg left">
				<span class="color99 search_span">时间</span>
				<div id="selectDateDiv">
					<span class="color99" id="selectDate"
					style="display: inline-block; width: 80%;">${wfParam.rptYear}年${wfParam.rptMonthDisplay}</span> <span
						class="ico16 form_temp_16"></span>
				</div>
			</div>
			<%-- 
			<div class="left">
				<a href="javascript:void(0)" onclick="query();" class="common_button">查询</a>
			</div>
			--%>
			
		</div>
	</div>
	<input type="hidden" id="orgIdStr" value="${wfParam.orgIdStr}" />
	<input type="hidden" id="rptYear" value="${wfParam.rptYear}" />
	<input type="hidden" id="rptMonth" value="${wfParam.rptMonth}" />
	<input type="hidden" id="includeElements" value="${wfParam.includeElements}" />
	<input type="hidden" id="moduleType" value="${wfParam.moduleType}"/>
	<input type="hidden" id="menuType" value="${wfParam.menuType}"/>
	<input type="hidden" id="method" value="${method}" />
	<input type="hidden" id="dptType" value="1"/>
	<input type="hidden" id="orderKey" value=""/>
	<input type="hidden" id="orderBy" value=""/>
	<input type="hidden" id="tabType" value="collaboration"/>
</div>
<script type="text/javascript" src="${path}/apps_res/behavioranalysis/js/jquery.htdate-debug.js${ctp:resSuffix()}"></script>