<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
  <title>${ctp:i18n("report.collector.title") }</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <meta name="renderer" content="webkit|ie-comp|ie-stand">
  <link rel="stylesheet" href="${path }/common/report/collector/collector-dashboard.css${ctp:resSuffix()}">
</head>
  <body>
  	<div class="content-area">
		
  		<%-- 在线人数趋势 --%>
  		<div class="shadow-box rd3 chart-area">
  			<div class="condition-area">
  				<span class="st-font chart-title">${ctp:i18n("report.collector.chart.title") }</span>
  				<select class="st-select rd3" name="select-date">
  					<option value="7">${ctp:i18n("report.collector.chart.day7") }</option>
  					<option value="30" selected>${ctp:i18n("report.collector.chart.day30") }</option>
  					<option value="365">${ctp:i18n("report.collector.chart.day365") }</option>
  				</select>
  			</div>
  			<div id="chart-area"></div>
  		</div>
  	
  		<%-- 设置调度时间 --%>
  		<div class="shadow-box rd3 setting-area">
  			<div style="text-align: center;margin: 5px auto;">调度时间设置</div>
  			<ul>
  			<c:forEach items="${datas }" var="cdate">
  				<li key="${cdate.type }" class="st-list">
  					${cdate.typeI18n }
					<select class="st-select rd3 select" name="${cdate.type }_hour">
						<c:forEach begin="0" end="23" step="1" var="hour_i">
							<option value="${hour_i }" ${hour_i == cdate.hour ? "selected":"" }>${hour_i }</option>
						</c:forEach>
					</select> ${ctp:i18n("report.collector.common.hour") }
					
					<select class="st-select rd3 select" name="${cdate.type }_minute">
						<c:forEach begin="0" end="59" step="1" var="minute_i">
							<option value="${minute_i }" ${minute_i == cdate.minute ? "selected":"" }>${minute_i }</option>
						</c:forEach>
					</select> ${ctp:i18n("report.collector.common.minute") }
					
					<select class="st-select rd3 select" name="${cdate.type }_second">
						<c:forEach begin="0" end="59" step="1" var="second_i">
							<option value="${second_i }" ${second_i == cdate.second ? "selected":"" }>${second_i }</option>
						</c:forEach>
					</select> ${ctp:i18n("report.collector.common.second") }
  				</li>
  			</c:forEach>
  			</ul>
  			<div style="text-align: center;">
	  			<input class="rd3 bt bt-save" type="button" value="${ctp:i18n("report.collector.common.save") }" />
  			</div>
		</div>
  		
		<%-- 是否显示立即调度 --%>
		<c:if test="${showRuntask }">
  		<div class="shadow-box rd3 task-run">
  			<input class="rd3 bt bt-runTaskNow " type="button" onclick="javascript:collectorDashboard.runTask(true,'')" value="立即执行全部调度" />
  			<c:forEach var="taskName" items="${taskNames }">
	  			<input class="rd3 bt bt-runTaskNow " type="button" onclick="javascript:collectorDashboard.runTask(false,'${taskName }')" value="立即执行(${taskName })调度" />
  			</c:forEach>
  		</div>
		</c:if>
		
  	</div>
  	
  </body>
  <%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
  <script type="text/javascript" src="${path }/common/js/echarts-all.js${ctp:resSuffix()}"></script>
  <script type="text/javascript" src="${path }/common/report/collector/collector-dashboard-debug.js${ctp:resSuffix()}"></script>
  <script type="text/javascript">
	  $(function(){
		  //初始化
		  collectorDashboard.init();
		});
  </script>
</html>