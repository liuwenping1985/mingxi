<%--
 $Author: hetao $
 $Rev: 7 $
 $Date:: 2012-11-22 10:55:18#$:
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<!-- anyChart configure 
<script type="text/javascript" src="${path}/ajax.do?managerName=drawChartManager"></script>
<script type="text/javascript" src="${path}/common/report/chart/js/AnyChart.js"></script>
<script type="text/javascript" src="${path}/common/report/chart/js/AnyChartHTML5.js"></script>
<script type="text/javascript" src="${path}/common/report/chart/js/seeyon.ui.chart.js"></script>
 -->
 
<!-- 
 	name: Baidu Echarts 
 	link: http://echarts.baidu.com/index.html
-->

<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/report/chart/js/seeyon.ui.chart2-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/report/chart/echarts/source/echarts.js${ctp:resSuffix()}"></script>