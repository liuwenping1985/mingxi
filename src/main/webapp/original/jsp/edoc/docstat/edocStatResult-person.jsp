<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.office.auto.resources.i18n.SeeyonAutoResource" var="seeyonOfficeI18N"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='edoc.statistical.results'/></title> 
<script>
	function popprint() {		
		var printEdocBody = "";
		document.getElementById("printButtonDiv").className = "hidden";
		var edocBody = document.getElementById("print").innerHTML;
		var edocBodyFrag = new PrintFragment(printEdocBody, edocBody);
		var cssList = new ArrayList();
	
		var pl = new ArrayList();
		pl.add(edocBodyFrag);
		//5.0页面框架不能只用老版本的打印，需要调用v3x.js同一打印组件的方法
		printList(pl,cssList);
		//printList2(pl,cssList);
		document.getElementById("printButtonDiv").className = "";
	}

	function exportExcel(year,morecond,morecondition,season,month,groupType){
		var url = "<c:url value='/edocStat.do'/>?method=exportToExcel&statisticsDimension=${statisticsDimension}"+
					"&organizationType=5&organizationId=${organizationId}&timeType=${timeType}&organizationName=${organizationName}"+
					"&sendContentId=${sendContentId}&sendNodeCode=${sendNodeCode}&recNodeCode=${recNodeCode}"+
					"&processSituationId=${processSituationId}&yeartype-startyear=${yeartype_startyear}&yeartype-endyear=${yeartype_endyear}"+
					"&seasontype-startyear=${seasontype_startyear}&seasontype-endyear=${seasontype_endyear}&seasontype-startseason=${seasontype_startseason}"+
					"&seasontype-endseason=${seasontype_endseason}&monthtype-startyear=${monthtype_startyear}&monthtype-endyear=${monthtype_endyear}"+
					"&monthtype-startmonth=${monthtype_startmonth}&monthtype-endmonth=${monthtype_endmonth}&daytype-startday=${daytype_startdate}"+
					"&daytype-endday=${daytype_enddate}"; 

		statForm.action = url;
		statForm.target = "temp_iframe";
		statForm.submit();
	}
	
</script>
<style>
<!--
.tableclass{
    border-top: solid 1px #999999;
	border-left: solid 1px #999999;
 }
 .tdclass{
   border-right:solid 1px #999999;
   border-bottom:solid 1px #999999;
 }
 .tdfirstclass{
	border-right:solid 1px #999999;
	border-bottom:solid 1px #999999;
 } 
-->
</style>
</head>
<body>

	
 
<div id="print" class="scrollList">
<form name="statForm" method="post">
<input type="hidden" name="organizationName" value="${organizationName}"/>		
<input type="hidden" name="sendContent" value="${sendContent}"/>		
<input type="hidden" name="workflowNode" value="${workflowNode}"/>	
<input type="hidden" name="processSituation" value="${processSituation}"/>
<table width="100%" height="100%" border="0" cellspacing="5" cellpadding="2" align="center" style="margin:0 auto;">   
	<tr>
		<td align="center">
			<%@ include file="stat_title.jsp"%>
		</td> 
	</tr>
	<tr valign="top">
		 <td align="center">
			 <TABLE cellSpacing=0 cellPadding=0 width="100%" style="border-top: solid 1px #999999;border-left: solid 1px #999999;">
			 <thead>
					<tr class="sort"> 
						<td width="15%" style="border-right:solid 1px #999999;border-bottom:solid 1px #999999;"> 
							<!--统计内容  -->
							<div style="margin-left:100px;"><fmt:message key='edoc.stat.content' /></div>
							<div style="margin-left:10px;">
								${v3x:toHTML(organizationName)}
							</div>  
						</td> 
						<c:forEach  items="${statisticsContent}" var="content">
							 
							<td align="center" height="25px" style="border-right:solid 1px #999999;border-bottom:solid 1px #999999;">${content.contentName}</td>			
						</c:forEach>
					
						
					 </tr>		
			</thead>
			<tbody>		 		 
				<c:forEach  items="${results}" var="content" varStatus="status">
					<tr class="sort" height="25px">	
						<td align="center" style="border-right:solid 1px #999999;border-bottom:solid 1px #999999;">
						<c:if test="${statisticsDimension==1}">
							
							<c:if test="${timeType==1}">
								${yearArr[status.index] }<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />
							</c:if>
							<c:if test="${timeType==2}">
								${yearArr[status.index] }<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />
								${seasonArr[status.index]}<fmt:message key='common.quarter.label' bundle='${v3xCommonI18N}' />
							</c:if>
							<c:if test="${timeType==3}">
								${yearArr[status.index] }<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />
								${monthArr[status.index]}<fmt:message key='menu.tools.calendar.yue' bundle='${v3xMainI18N}' />
							</c:if>
							<c:if test="${timeType==4}">
								${dateArr[status.index] }
							</c:if>
							
						</c:if>
						<c:if test="${statisticsDimension==2}">
							${organizations[status.index] }
						</c:if>
						<c:if test="${fn:length(results)-1 == status.index}">
						<fmt:message key='edoc.stat.sum.label' />
						</c:if>
						
						</td> 
						<c:forEach  items="${content.value}" var="num">
						<td align="center" style="border-right:solid 1px #999999;border-bottom:solid 1px #999999;">
							${num}
						</td>						
						</c:forEach> 
					 </tr>
				</c:forEach>
				
				
				</tbody>
			</table> 
		</td>	
	</tr>
	<tr>
		<td>
        <c:if test="${param.openType != 'firstPage' }">
		<div id="printButtonDiv">
		<input type="button" name="btn1" value="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />" onclick="popprint();" class="button-default_emphasize">&nbsp;&nbsp;
		<input type="button" name="btn2" value="<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />" onclick="exportExcel('${year}','${morecond}','${morecondition}','${season}','${month}','${groupType}');" class="button-default-2"></td>		
		</div>
        </c:if>
	</tr>
</table>
</form>
</div>
<div class="hidden">
<iframe name="temp_iframe" id="temp_iframe">&nbsp;</iframe>
</div>
</body>
</html>