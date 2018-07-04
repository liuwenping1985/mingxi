<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.apps.performancereport.enums.ReportsEnum" %>
<%@ page import="com.seeyon.ctp.common.taglibs.functions.Functions" %>
<script type="text/javascript">
var WORKDAILYSTATISTICS = "<%=ReportsEnum.WorkDailyStatistics.getKey()%>";
var PLANRETURNSTATISTICS= "<%=ReportsEnum.PlanReturnStatistics.getKey()%>";
var PLANRETURNSTATISTICSGROUP="<%=ReportsEnum.PlanReturnStatisticsGroup.getKey()%>";
var	MEETINGJOINSTATISTICS= "<%=ReportsEnum.MeetingJoinStatistics.getKey()%>";
var	MEETINGJOINROLESTATISTICS= "<%=ReportsEnum.MeetingJoinRoleStatistics.getKey()%>";
var	TASKBURNDOWNSTATISTICS= "<%=ReportsEnum.TaskBurndownStatistics.getKey()%>";
var	KNOWLEDGEINCREASESTATISTICS= "<%=ReportsEnum.KnowledgeIncreaseStatistics.getKey()%>";
var	KNOWLEDGESCORESTATISTICS= "<%=ReportsEnum.KnowledgeScoreStatistics.getKey()%>";
var	KNOWLEDGEACTIVITYSTATISTICS= "<%=ReportsEnum.KnowledgeActivityStatistics.getKey()%>";
var	ONLINESTATISTICS= "<%=ReportsEnum.OnlineStatistics.getKey()%>";
var	ONLINEMONTHSTATISTICS= "<%=ReportsEnum.OnlineMonthStatistics.getKey()%>";
var	ONLINETIMESTATISTICS= "<%=ReportsEnum.OnlineTimeStatistics.getKey()%>";
var	EVENTSTATISTICS= "<%=ReportsEnum.EventStatistics.getKey()%>";
var EVENTSTATISTICSGROUP="<%=ReportsEnum.EventStatisticsGroup.getKey()%>";
var	PROJECTSCHEDULESTATISTICS= "<%=ReportsEnum.ProjectScheduleStatistics.getKey()%>";
var	STORAGESPACESTATISTICS= "<%=ReportsEnum.StorageSpaceStatistics.getKey()%>";
var	FLOWSENTANDCOMPLETEDSTATISTICS= "<%=ReportsEnum.FlowSentAndCompletedStatistics.getKey()%>";
var	FLOWSENTANDCOMPLETEDSTATISTICSFORM= "<%=ReportsEnum.FlowSentAndCompletedStatisticsForm.getKey()%>";
var	FLOWSENTANDCOMPLETEDSTATISTICSEDOC= "<%=ReportsEnum.FlowSentAndCompletedStatisticsEdoc.getKey()%>";
var	FLOWOVERTIMESTATISTICS= "<%=ReportsEnum.FlowOverTimeStatistics.getKey()%>";
var	FLOWOVERTIMESTATISTICSFORM= "<%=ReportsEnum.FlowOverTimeStatisticsForm.getKey()%>";
var	FLOWOVERTIMESTATISTICSEDOC= "<%=ReportsEnum.FlowOverTimeStatisticsEdoc.getKey()%>";
var	NODEANALYSIS= "<%=ReportsEnum.NodeAnalysis.getKey()%>";
var	IMPROVEMENTANALYSIS= "<%=ReportsEnum.ImprovementAnalysis.getKey()%>";
var	OVERTIMEANALYSIS= "<%=ReportsEnum.OverTimeAnalysis.getKey()%>";
var	EFFICIENCYANALYSIS= "<%=ReportsEnum.EfficiencyAnalysis.getKey()%>";
var	COMPREHENSIVEANALYSIS= "<%=ReportsEnum.ComprehensiveAnalysis.getKey()%>";
var	PROCESSPERFORMANCEANALYSIS= "<%=ReportsEnum.ProcessPerformanceAnalysis.getKey()%>";
//取产品安装时间
//Functions.getProductInstallDate4WF()
</script>