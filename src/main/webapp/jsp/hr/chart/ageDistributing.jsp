<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" var="v3xHRI18N"/>
<html>
	<head>
	<%@ include file="simpleheader.jsp" %>
		<title>chart</title>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/chart/MochiKit.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/chart/Base.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/chart/Layout.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/chart/Canvas.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/chart/SweetCanvas.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/chart/excanvas.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/chart/EasyPlot.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript">
			var hrStatisticURL = "<html:link renderURL='/hrStatistic.do' />";
		</script>
		<script>
		<!--
		
		window.onresize = function () {
			if (document.body.clientHeight - 92 > 0) {
				document.getElementById('graphFm').style.height = document.body.clientHeight - 92 +"px";
			}
			document.getElementById('graphFm').style.overflow = "auto";
		}
		var elements = ['article', 'nav', 'section', 'header', 'aside', 'footer','canvas','shape','fill'];
  		for (var i=elements.length-1; i>=0; i--) {
   			document.createElement(elements[i]);
  		}
		var sxUpConstants = {
			status_0 : "0,*",
			status_1 : "35%,*"
		}
		var sxDownConstants = {
			status_0 : "*,12",
			status_1 : "35%,*"
		}
		var sxMiddleConstants = {
			status_0 : "35%,*",
			status_1 : "35%,*"
		}
		var indexFlag = 0;
		

        var xTicks = [{label: "<fmt:message key='hr.statistic.tweentyFiveHereinafter.label' bundle='${v3xHRI18N}' />", v: 0}, 
        			  {label: "<fmt:message key='hr.statistic.tweentySixToThirty.label' bundle='${v3xHRI18N}' />", v: 1},
                      {label: "<fmt:message key='hr.statistic.thirtyOneToThirtyFive.label' bundle='${v3xHRI18N}' />", v: 2},
                      {label: "<fmt:message key='hr.statistic.thirtySixToForty.label' bundle='${v3xHRI18N}' />", v: 3},
                      {label: "<fmt:message key='hr.statistic.fortyOneToFifty.label' bundle='${v3xHRI18N}' />", v: 4},
                      {label: "<fmt:message key='hr.statistic.fiftyOneToSixty.label' bundle='${v3xHRI18N}' />", v: 5},
                      {label: "<fmt:message key='hr.statistic.sixtyHereinbefore.label' bundle='${v3xHRI18N}' />", v: 6}
                      ];
        
		function easyDrawGraph() {
			var hasCanvas = CanvasRenderer.isSupported();
			var opts = {
   				"pieRadius": 0.4,
   				"colorScheme": PlotKit.Base.palette(PlotKit.Base.baseColors()[5]), 
   				"backgroundColor": PlotKit.Base.baseColors()[4].lighterColorWithLevel(0.5),
   				"xTicks": xTicks
   			};
   			var data1 = [[0, ${age[0]}], [1, ${age[1]}], [2, ${age[2]}], [3, ${age[3]}], [4, ${age[4]}], [5, ${age[5]}], [6, ${age[6]}]];
   			if (hasCanvas) {
   				var graph = new EasyPlot("${type}", opts, $('graph'), [data1]);
   				$('graph').innerHTML = '';
   				var graph = new EasyPlot("${type}", opts, $('graph'), [data1]);
   			}
		}
		addLoadEvent(easyDrawGraph);
		//-->
		</script>
		<script type="text/javascript">
			function changeType(){
				document.statisticForm.submit();
			}
		//-->
		</script>

	</head>
<body scroll="no" style="overflow: no">
<form id="statisticForm" name="statisticForm" method="post" action="${hrStatisticURL}?method=ageDistributing&newOrChanged=changed">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr bgcolor="rgb(237, 237, 237)" align="center">
		<td height="8" class="detail-top">
<script type="text/javascript">	
			getDetailPageBreak(true) ;		
</script>
		</td>
	</tr>
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="hr.statistic.age.label" bundle="${v3xHRI18N}" /></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head" height="20">
		 <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		   <tr>
		    <td class="categorySet-body" align="center" style="padding-top: 5px;padding-bottom: 5px;">
				<label><fmt:message key='hr.statistic.chooseShape.label' bundle='${v3xHRI18N}' /></label>
				<select name="shapeType" onchange="changeType()">
				<c:choose>
					<c:when test="${type == 'pie'}">
					<option value="pie" selected="selected"><fmt:message key='hr.statistic.caky.label' bundle='${v3xHRI18N}' /></option>
					<option value="bar" ><fmt:message key='hr.statistic.histogram.label' bundle='${v3xHRI18N}' /></option>
					</c:when>
					<c:otherwise>
					<option value="pie" ><fmt:message key='hr.statistic.caky.label' bundle='${v3xHRI18N}' /></option>
					<option value="bar" selected="selected"><fmt:message key='hr.statistic.histogram.label' bundle='${v3xHRI18N}' /></option>
					</c:otherwise>
				</c:choose>
				</select>
			</td>
			</tr>
		  </table>	
		</td>
    </tr>
	<tr>
	  <td class="categorySet-head">
		 <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		   <tr>
		    <td class="categorySet-body" align="center">
		    <div class="scrollList padding_t_10" id="graphFm" style="height:160px;overflow:auto;">
	 		 <div id="graph" height="250" width="400" ></div>
	 		 </div>
	 		</td>
		   </tr>
		 </table> 
	  </td>
	</tr>
</table>
</form>
</body>
</html>