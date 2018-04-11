<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<%@ include file="header.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
    showCtpLocation("F09_meetingRoom");
</script>
<script type="text/javascript">
		
$(function() {
	setTimeout(function() {
		if($("#headIDlistTable") != null) {
			$("#headIDlistTable").find("th").eq(0).find("div").attr("title", v3x.getMessage("meetingLang.meeting_choose_all"));
		}
	}, 100);
});

function doSearch(){
	var fromDate = $('#startDatetime').val();
          var toDate = $('#endDatetime').val();
          if(fromDate != "" && toDate != "" && fromDate > toDate){
          	alert(document.getElementById("endDatetime").getAttribute("inputName") + "<fmt:message key='mr.alert.cannotbefore'/>" + document.getElementById("startDatetime").getAttribute("inputName"));
              return;
          }
          if(checkForm(document.searchForm)){
		document.searchForm.submit();
	}
}

function doExport(){
	alert('<fmt:message key='mr.alert.pleasewait'/>');
	document.getElementById("hiddenIframe").contentWindow.location.href = "<html:link renderURL='/meetingroomList.do?method=listTotalExport&startDatetime=${startDatetime}&endDatetime=${endDatetime}'/>";
}
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>

<body srcoll="no" style="overflow: hidden" style="padding: 0px">

<div class="main_div_row2">

<div class="right_div_row2">

<div class="top_div_row2 webfx-menu-bar">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
 <tr>
	<td>
 		<script type="text/javascript">
			var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","gray");
			myBar.add(new WebFXMenuButton("create", "<fmt:message key='mr.button.export'/>Excel", "doExport()", "/seeyon/common/images/toolbar/importExcel.gif"));
			document.write(myBar);
		    document.close();
 		</script>
	</td>
	<td class="webfx-menu-bar-gray">
		<form name="searchForm" action="${mrListUrl }?method=listTotal" method="post" onsubmit="">
 			<div class="div-float-right">
 				<div class="div-float"></div>
 				<div id="condition_div" class="div-float">
 				<fmt:message key='mr.label.start'/><input type='text' id="startDatetime" name='startDatetime' value='${startDatetime }' inputName="<fmt:message key='mr.label.start'/>" validate="notNull" style='width: 80px;' onclick='whenstart("${pageContext.request.contextPath}",this,175, 140,"date");' readonly/>&nbsp;&nbsp;
 				<fmt:message key='mr.label.end'/><input type='text' id="endDatetime" name='endDatetime' value='${endDatetime }' inputName="<fmt:message key='mr.label.end'/>" validate="notNull" style='width: 80px;' onclick='whenstart("${pageContext.request.contextPath}",this,175, 140,"date");' readonly />
 				</div>
 				<div onclick="javascript:doSearch();" class="condition-search-button">&nbsp;</div>
 			</div>
		</form>
	</td>
</tr>
</table>

</div><!-- top_div_row2 -->

<div class="center_div_row2" id="scrollListDiv">
    
<form name="listForm" id="listForm" method="post" style="margin: 0px">
    
<fmt:message key="mr.label.from" var='datefrom'/>
<fmt:message key="mr.label.to" var='dateto'/>

<v3x:table htmlId="listTable" data="list" var="bean" pageSize="${pageSize }" size="${size }" showHeader="true" showPager="true" isChangeTRColor="true">
	
	<v3x:column width="4%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
		<input type='checkbox' name='id' value="<c:out value=''/>" />
	</v3x:column>
		
	<v3x:column width="36%" type="String" 
		label="mr.label.meetingroomname" className="cursor-hand sort mxtgrid_black" alt="">
		<c:out value="${bean.room.name }" />
		<c:if test="${bean.room.needApp == 0 }">※</c:if>
	</v3x:column>
		
	<v3x:column width="15%" type="String" 
		label="mr.label.nowmonth" className="cursor-hand sort" alt="">
		${bean.MonthTotal}<fmt:message key='mr.label.hour'/>
	</v3x:column>
		
	<v3x:column width="15%" type="String" 
		label="mr.label.total" className="cursor-hand sort" alt="">
		${bean.AllTotal}<fmt:message key='mr.label.hour'/>
	</v3x:column>
		
	<v3x:column width="30%" type="String" align="center" label="${datefrom }${startDatetime }${dateto }${endDatetime }" className="cursor-hand sort" alt="">
		${bean.SectionTotal}<fmt:message key='mr.label.hour'/>
	</v3x:column>
	
</v3x:table>

</form>

</div><!-- center_div_row2 -->

</div><!-- right_div_row2 -->

</div><!-- main_div_row2 -->

<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='mr.tab.total'/>", [2,3], pageQueryMap.get('count'), _("officeLang.detail_info_meetingroom_count"));	
</script>

<iframe name="hiddenIframe" id="hiddenIframe" style="display:none"></iframe>

</body>
</html>
	