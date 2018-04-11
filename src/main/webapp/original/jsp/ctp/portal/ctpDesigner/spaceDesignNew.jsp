<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>空间设计</title>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" type="text/css"
	href="${path}/common/designer/css/layout-default-latest.css${ctp:resSuffix()}" />
<link rel="stylesheet" type="text/css"
	href="${path}/common/designer/css/jquery-ui.css${ctp:resSuffix()}">
<link rel="stylesheet" type="text/css"
	href="${path}/common/designer/css/default_model.css${ctp:resSuffix()}" />
<link rel="stylesheet" type="text/css"
	href="${path}/common/designer/css/icon-pic.css${ctp:resSuffix()}" />
<link rel="stylesheet" type="text/css"
	href="${path}/common/designer/css/widgetDefault.css" />
</head>
<script type="text/javascript"
	src="${path}/common/designer/js/jquery-1.11.3.js${ctp:resSuffix()}"></script>
<script type="text/javascript"
	src="${path}/common/designer/js/jquery-ui.js${ctp:resSuffix()}"></script>
<SCRIPT type="text/javascript"
	src="${path}/common/designer/js/jquery.layout-latest.js${ctp:resSuffix()}"></SCRIPT>
<script type="text/javascript"
	src="${path}/common/designer/js/jquery.json.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/js/misc/Moo-debug.js"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/js/misc/jsonGateway-debug.js"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/js/ui/seeyon.ui.checkform-debug.js"></script>
	
<script type="text/javascript"
	src="${path}/common/designer/js/space-component.js${ctp:resSuffix()}"></script>
<script type="text/javascript"
	src="${path}/common/designer/js/space-component-pic.js${ctp:resSuffix()}"></script>
<script type="text/javascript"
	src="${path}/common/designer/js/component_option.js${ctp:resSuffix()}"></script>

<script type="text/javascript"
	src="${path}/common/designer/js/spaceDesignNew.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=pageComponentManager"></script>	
<script type="text/javascript">
	var _ctxPath = "${path}";
	
	$(function() {
		var panels = new Array();
		<c:forEach items="${sections}" var="section">
	     	var typeObj = new Object();
	     	typeObj.type = "${section.type}";
	     	typeObj.name = "${section.name}";
	     	
	     	var arr = new Array();
	     	<c:forEach items="${section.nodes}" var="node">
				var nodeObj = new Object();
				nodeObj.sectionName = "${node.sectionName}";
	     		nodeObj.sectionBeanId = "${node.sectionBeanId}";
	     		nodeObj.entityId = "${node.entityId}";
	     		nodeObj.singleBoardId = "${node.singleBoardId}";
	     		arr.push(nodeObj);
	     	</c:forEach>
	     	typeObj.nodes = arr;
	     	panels.push(typeObj);
	    </c:forEach>
		$("#sectionsId").initSectionType(panels);
		initSpaceLayout();
		
		
	})
</script>
<body>
	<form id="spaceForm" method="post">
		<div class="ui-layout-north">
			<button>预览</button>
			<button onclick="saveSpace()">保存</button>
			空间名称：<input type='input' name="name" id="spaceName"> 
			空间编号：<input type='input' name="code" id="spaceCode">
		</div>
		<div class="ui-layout-center font12"
			style="background-color: #FBD850;">
			<div class="pure-g">
				<div class="pure-u-1-1 pureflag">
					<div id="normalDiv"
						class="portal-layout portal-layout-ThreeColumns layout-edit">
						<div class="pure-g">
							<div class="pure-u-1-1 pureflag">
								<div id="banner"
									class="portal-layout-column margin_r_15 ui-sortable">
									<div class="fragment" x="0" y="0" id="fragment_0_0" swidth="10"
										celladd="true" maxsection="-1"></div>
									<div class="placeholder">
										<p>此位置可添加栏目！</p>
									</div>
								</div>
							</div>
						</div>
						<div class="pure-g">
							<div class="pure-u-4-5 pureflag">
								<div class="pure-g">
									<div class="pure-u-1-1 pureflag">
										<div id="column-0"
											class="portal-layout-column margin_r_15 ui-sortable">
											<div class="fragment" x="0" y="1" id="fragment_1_0"
												swidth="8" celladd="true" maxsection="-1"></div>
											<div class="placeholder">
												<p>此位置可添加栏目！</p>
											</div>
										</div>
									</div>
								</div>
								<div class="pure-g">
									<div class="pure-u-2-5 pureflag">
										<div id="column-0"
											class="portal-layout-column margin_r_15 ui-sortable">
											<div class="fragment" x="0" y="3" id="fragment_3_0"
												swidth="4" celladd="true" maxsection="-1"></div>
											<div class="placeholder">
												<p>此位置可添加栏目！</p>
											</div>
										</div>
									</div>
									<div class="pure-u-3-5 pureflag">
										<div id="column-1"
											class="portal-layout-column margin_r_15 ui-sortable">
											<div class="fragment" x="0" y="4" id="fragment_3_0"
												swidth="4" celladd="true" maxsection="-1"></div>
											<div class="placeholder">
												<p>此位置可添加栏目！</p>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="pure-u-1-5 pureflag">
								<div class="pure-g">
									<div class="pure-u-1-1 pureflag">
										<div id="column-1"
											class="portal-layout-column margin_r_15 ui-sortable">
											<div class="fragment" x="0" y="2" id="fragment_2_0"
												swidth="2" celladd="true" maxsection="-1"></div>
											<div class="placeholder">
												<p>此位置可添加栏目！</p>
											</div>
										</div>
									</div>
								</div>
								<div class="pure-g">
									<div class="pure-u-1-1 pureflag">
										<div id="column-2"
											class="portal-layout-column margin_r_15 ui-sortable">
											<div class="fragment" x="0" y="5" id="fragment_5_0"
												swidth="2" celladd="true" maxsection="-1"></div>
											<div class="placeholder">
												<p>此位置可添加栏目！</p>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="pure-g">
							<div class="pure-u-1-1 pureflag">
								<div id="banner"
									class="portal-layout-column margin_r_15 ui-sortable">
									<div class="fragment" x="0" y="6" id="fragment_6_0" swidth="10"
										celladd="true" maxsection="-1"></div>
									<div class="placeholder">
										<p>此位置可添加栏目！</p>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="ui-layout-east font12">
			<div id="tabs">
				对齐方向:
				<div class="conponent_option"
					style="width: 50%; height: 210px; margin-left: 28%; background: rgba(255, 255, 255, 0.4); color: blue; font-size: 16px;">
				</div>
			</div>
		</div>
		<div class="ui-layout-west font12" style="width: 150px;">
			<div id="sectionsId"></div>
		</div>
	</form>
</body>
</html>
