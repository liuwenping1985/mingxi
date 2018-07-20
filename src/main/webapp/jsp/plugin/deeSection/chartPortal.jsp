<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/report/chart/chart_common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style type='text/css'>
.deeSort{
	border-bottom: solid 1px #ddd;
	word-break: break-all;
	font-size: 12px;
	height: 24px;
	vertical-align: middle;
}

.chartBorder{
	border-left:solid 1px #e5e5e5;
}

.displayNone{
	display:none;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/skin/default/skin.css" />">
</head>
<body>
<div id="deeDiv" style="position:absolute; z-index:1;overflow-y:hidden;height:100%;width:100%" >
	<table height="100%" cellpadding="0" cellspacing="0" border="0" width="100%">
		<tbody>
			<tr>
				<td id="deeTable" valign="top" nowrap="nowrap" height="100%" width="100%">
				
					<table class="sort ellipsis" width="100%" cellpadding="0" cellspacing="0">
					<THEAD class="mxt-grid-thead" >
					<tr class="sort" height="25px">
						<c:forEach items="${fieldKeys}" var="key">
							<c:forEach items="${defaultShowProps}" var="item">
								<c:if test="${item.key==key}">
									<td align="center" type="String" height="25px">${item.value}</td>
								</c:if>
							</c:forEach>
						</c:forEach>
					</tr>
					</THEAD>
					<TBODY>
					
						<c:forEach items="${deeData}" var="row">
						<tr class="sort erow" height="25px">
							<c:forEach items="${row}" var="field">
								<c:if test="${field.value==''}">
									<td align="center" class="deeSort" height="25px">&nbsp;</td>
								</c:if>
								<c:if test="${field.value!=''}">
									<td align="center" class="deeSort" height="25px">${field.value}</td>
								</c:if>
							</c:forEach>
						</tr>
						</c:forEach>
					
					</TBODY>
					</table>
					
				</td>
				<td id="deeChart" valign="top" align="center" nowrap="nowrap" height="100%" width="50%" class="border_l_gray2 diplayNone">
					<div name="deeChart" style="height:100%;"></div>
				</td>
			</tr>
		</tbody>
	</table>

</div>



</body>
</html>

<script type="text/javascript">
$(function(){
var parentWindowHeight = $(parent).height();
var parentWindowWidth = $(parent).width();
var deeColumnSize = "${deeColumnSize}";
parent.document.getElementById("deeIframe").height=parentWindowHeight;
parent.document.getElementById("deeIframe").width=parentWindowWidth;

if(deeColumnSize*200>parentWindowWidth)
	{
		$("#deeDiv").width(deeColumnSize*200);
	}

parentWindowHeight=null;
parentWindowWidth=null;
deeColumnSize=null;
var charXml="${chartXML}";
if(charXml!=null&&charXml!="")
	{
		$("#deeTable").width("50%");	
		$("#deeChart").removeClass("displayNone");
		chart1 = new SeeyonChart({
		    htmlId : "deeChart",
		    width : "100%",
		    heigth : "100%",
		    xmlData : charXml
		  });	
	}
charXml=null;
});
</script>

