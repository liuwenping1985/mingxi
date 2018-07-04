<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
	标题：应用或节点权限过滤
	应用场景：节点效率，部门效率，人员效率过滤
 --%>
<c:if test="${!empty permissionList}">
	<div class="button_node_access hide">
		<div>
			<div class="button_node_access_div">
				<div class="node_access_head">
					<div class="left">${ctp:i18n("wfanalysis.common.selectPermissionTitle") }</div>
					<div class="right">
						<em class="node_access_hide hand"></em>
					</div>
				</div>
				<div class="node_access_body">
					<div class="node_access_nav">
						<ul class="node_nav_ul">
							<%-- 节点权限分类 --%>
							<c:forEach var="pList" items="${permissionList}" varStatus="status">
								<li class="${status.index == 0 ? 'nav_current' : '' }">
									<c:set var="i18n" value="application.${pList.moduleType }.label"/>
									<span>${ctp:i18n(i18n) }</span>
								</li>
							</c:forEach>
						</ul>
						<div class="nav_ul_border"></div>
					</div>
					<div class="node_access_all">
						<%-- 节点权限分类项 --%>
						<c:forEach var="pList" items="${permissionList}" varStatus="status">
							<div class="node_access_list ${status.index != 0 ? 'hide' : ''}">
								<c:forEach var="p" items="${pList.permissions }">
									<ul class="node_list_ul">
										<li class="hand"><em moduleType="${pList.moduleType }" option="${p.name }" class="${p.selected ? 'em_current' : '' }"></em><span title="${p.label }">${p.label }</span></li>
									</ul>						
								</c:forEach>
							</div>
						</c:forEach>
					</div>
					<div class="node_access_footer ">
						<div class="node_access_button overflow">
							<a class="access_button button_cancel right" href="javascript:cancel()">${ctp:i18n("common.button.cancel.label") }</a>
							<a class="access_button button_sure right" href="javascript:ok()">${ctp:i18n("common.button.ok.label") }</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</c:if>