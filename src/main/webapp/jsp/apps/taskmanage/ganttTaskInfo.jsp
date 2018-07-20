<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","webfx-menu-bar-gray");
	myBar.add(new WebFXMenuButton("listStyle", "<fmt:message key='task.viewstyle.list' />", "viewAsList('${param.projectId}', '${param.projectPhaseId}', '${param.listTypeName}');", [5,5], "", null));
	myBar.add(new WebFXMenuButton("printBtn", "<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />", "printGanttChart()", "<c:url value='/common/images/toolbar/printmain.gif' />", "", null));
	var count = ${fn:length(items)};

	function initLayout(){
		if(count > 0) {
			var theTable = document.getElementById('GanttChartDIV');
			if(v3x.isMSIE6){
				theTable.style.height = parseInt(parent.parent.document.body.offsetHeight)-165+"px";
				theTable.style.width = parseInt(parent.parent.document.body.offsetWidth)-2+"px";
			}else{
				theTable.style.height = parseInt(parent.parent.document.body.offsetHeight)-165+"px";
			}
		}
	}
	
	function viewAsList(projectId, projectPhaseId, listTypeName) {
	var beginDate = $("#beginDate").val();
	var endDate = $("#endDate").val();
    window.location.href = '/seeyon/taskmanage/taskinfo.do?method=projectTaskListFrame&from=ProjectAll&projectId=' + projectId + '&projectPhaseId=' + projectPhaseId + '&listTypeName=' + listTypeName + '&beginDate='+beginDate+'&endDate='+endDate;
    }

    function parseDateFmt(dateStr) {
        return Date.parse(dateStr.replace(/\-/g, '/'));
    }
    
	function myDoSearch() {
	    if($("#condition").val() == "plannedStartTime" || $("#condition").val() == "plannedEndTime") {
            if($("#startdate").val().length > 0 && $("#enddate").val().length > 0) {
                if (parseDateFmt($("#startdate").val()) > parseDateFmt($("#enddate").val())) {
                    alert('开始时间不能大于结束时间!');
                    return;
                }
            }
            if($("#startdate2").val().length > 0 && $("#enddate2").val().length > 0) {
                if (parseDateFmt($("#startdate2").val()) > parseDateFmt($("#enddate2").val())) {
                    alert('开始时间不能大于结束时间!');
                    return;
                }
            }
        }
	    doSearch();
	}	
</script>
</head>
<body onload="initLayout()">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<input type="hidden" name="beginDate" id="beginDate" value="${beginDate}">
<input type="hidden" name="endDate" id="endDate" value="${endDate}">
	<tr>
		<td height="22" valign="top" class="webfx-menu-bar-gray">
			<script type="text/javascript">
				document.write(myBar);	
			</script>
		</td>
		
		<td height="22" align="right" class="webfx-menu-bar-gray">
			<%@ include file="taskSearch.jsp"%>
		</td>
	</tr>
</table>
<v3x:gantt data="${items}" />
<script type="text/javascript">
	parent.document.getElementById('projectTaskCount').innerHTML = v3x.getMessage("TaskManage.project_all", "${taskCount}");
	showCondition("${param.condition}", "${v3x:escapeQuot(param.textfield)}", "${param.textfield1}");
</script>
</body>
</html>