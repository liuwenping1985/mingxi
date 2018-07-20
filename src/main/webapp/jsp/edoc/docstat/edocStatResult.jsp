<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.office.auto.resources.i18n.SeeyonAutoResource" var="seeyonOfficeI18N"/>
<!DOCTYPE html>
<html style="overflow:hidden;height:100%;" width="100%" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='edoc.statistical.results'/></title> 
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<script>
	
	try {
	    getA8Top().endProc();
	}
	catch(e) {
	}


	function popprint() {		
		var printEdocBody = "";
		//document.getElementById("printButtonDiv").className = "hidden";
		var edocBody = document.getElementById("print").innerHTML;
		var edocBodyFrag = new PrintFragment(printEdocBody, edocBody);
		var cssList = new ArrayList();
	
		var pl = new ArrayList();
		pl.add(edocBodyFrag);
		printList(pl,cssList);
		//document.getElementById("printButtonDiv").className = "";
	}

	function exportExcel(year,morecond,morecondition,season,month,groupType){
		var url = "<c:url value='/edocStat.do'/>?method=exportToExcel&statisticsDimension=${statisticsDimension}"+
					"&organizationType=${organizationType}&organizationId=${organizationId}&timeType=${timeType}"+
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

	function openOrgPersonWindow(orgId,orgName){
		var url = "<c:url value='/edocStat.do'/>?method=doStat&statisticsDimension=${statisticsDimension}"+
		"&organizationType=5&organizationId="+orgId+"&timeType=${timeType}"+
		"&sendContentId=${sendContentId}&sendNodeCode=${sendNodeCode}&recNodeCode=${recNodeCode}"+
		"&processSituationId=${processSituationId}&yeartype-startyear=${yeartype_startyear}&yeartype-endyear=${yeartype_endyear}"+
		"&seasontype-startyear=${seasontype_startyear}&seasontype-endyear=${seasontype_endyear}&seasontype-startseason=${seasontype_startseason}"+
		"&seasontype-endseason=${seasontype_endseason}&monthtype-startyear=${monthtype_startyear}&monthtype-endyear=${monthtype_endyear}"+
		"&monthtype-startmonth=${monthtype_startmonth}&monthtype-endmonth=${monthtype_endmonth}&daytype-startday=${daytype_startdate}"+
		"&daytype-endday=${daytype_enddate}&organizationName="+orgName+
		"&processSituation=${processSituation}&openType=${param.openType}&ndate="+new Date(); 

		//GOV-4920 公文统计页面，统计内容过多，打印页面的左右滚动条拖不动
		var winWidth = 1200; 
		var winHeight = 700;

		var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
		feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
		feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";
		try{
			var retObj = window.showModalDialog(encodeURI(url),window ,feacture);
		}catch(e){
			//当window.showModalDialog报错时，只能通过window.open打开
			retObj = window.open(encodeURI(url),'',feacture);
		}
	}
	
	window.onload = function() {
	   // OA-28375  公文统计，推送到首页。然后在公文统计栏目中打开，报js错误。  
	    if(parent && parent.content){
	       parent.content.style = "border:0px;";
	    }
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
 .scrollList {
 	overflow: no;
 }
-->
</style>
</head>
<body width="100%" height="100%" style="background:#F3F3F3;padding:0 5px;" scroll="no">
 

<form name="statForm" id="statForm" method="post" style="margin-top:-5px;">
<input type="hidden" name="organizationName" value="${v3x:toHTML(organizationName)}"/>		
<input type="hidden" name="sendContent" value="${v3x:toHTML(sendContent)}"/>	
<input type="hidden" name="workflowNode" value="${workflowNode}"/>	
<input type="hidden" name="processSituation" value="${processSituation}"/>

<c:if test="${param.openType != 'firstPage' }">
<div class="border_all" id="printButtonDiv">
	<table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
		<tr>
			<td class="sectionTitleLine">
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td align="left">
							<span class="hand" onclick="exportExcel('${year}','${morecond}','${morecondition}','${season}','${month}','${groupType}');">
								<span class="ico16 export_excel_16 margin_l_10"></span><a href="###"><fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' /></a>
							</span>
							<span class="hand" onclick="popprint();">
								<span class="hand ico16 print_16 margin_l_10"></span><a href="###"><fmt:message key='edoc.element.print'/></a>
							</span>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div> 
</c:if>
<div id="print" class="border_lr" style="overflow:scroll">
<table width="100%" height="100%" border="0" cellspacing="5" cellpadding="2" align="center" style="margin:0px;overflow:auto;background-color:white;">   
	<tr>	
		<td align="center">
			<%@ include file="stat_title.jsp"%>
		</td>
	</tr>
	<tr valign="top">
		 <td align="center" valign="top">
			 <TABLE cellSpacing=0 cellPadding=0 width="100%" style="border-top: solid 1px #999999;border-left: solid 1px #999999;" >
			 <thead>
					<tr class="sort"> 
						<td width="15%" style="border-right:solid 1px #999999;border-bottom:solid 1px #999999;" > 
							<table width="100%">
                                <tr>
                                   <td align="center">
                                        <fmt:message key="edoc.stat.content"/>
                                   </td>
                                </tr>
                                <tr>
                                   <td>
                                    <c:if test="${statisticsDimension==1}">
                                        <fmt:message key="edoc.stat.time"/>
                                    </c:if>
                                    <c:if test="${statisticsDimension==2}">
                                        <fmt:message key="edoc.stat.org"/>
                                    </c:if>
                                   </td>
                                </tr>
                            </table>
                            
                            
						</td> 
						<c:forEach  items="${statisticsContent}" var="content">
							<td align="center" height="25px" style="border-right:solid 1px #999999;border-bottom:solid 1px #999999;">${v3x:toHTML(content.contentName)}</td>			
						</c:forEach>
					
						
					 </tr>		
			</thead>
			<tbody>		 	
				<c:forEach  items="${results}" var="content" varStatus="status">
					<tr class="sort" height="25px">	
						<td align="center" style="border-right:solid 1px #999999;border-bottom:solid 1px #999999;">
						
						<c:if test="${status.index < fn:length(results)-1}">
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
								<span <c:if test="${orgArr[status.index] != 5}"> style="cursor:hand;color:blue;" onclick="openOrgPersonWindow('${orgIds[status.index]}','${v3x:toHTML(organizations[status.index]) }');" </c:if>>
									${v3x:toHTML(organizations[status.index]) }
								</span> 
							</c:if>
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
	<!-- 
	<tr>
		<td>
        <c:if test="${param.openType != 'firstPage' }">
		<div id="printButtonDiv">
		<input type="button" name="btn1" value="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />" onclick="popprint();" class="button-default_emphasize">&nbsp;&nbsp;
		<input type="button" name="btn2" value="<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />" onclick="exportExcel('${year}','${morecond}','${morecondition}','${season}','${month}','${groupType}');" class="button-default-2-long"></td>		
		</div>
        </c:if>
	</tr> -->
</table>
</form>
</div>
<div class="hidden">
<iframe name="temp_iframe" id="temp_iframe">&nbsp;</iframe>
</div>


</body>
</html>
<script>

$(function(){
	$("#print").height($("html").height()-$("#printButtonDiv").height())
})
</script>