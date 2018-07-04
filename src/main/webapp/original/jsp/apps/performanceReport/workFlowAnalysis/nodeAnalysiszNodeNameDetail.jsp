<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="common.node.analysis.label" bundle='${v3xMainI18N}' /></title>
</head>
<script type="text/javascript">
<!-- 
	function exportNodeNameDetailExcel() {
		var searchForm = document.getElementById("searchForm");
		searchForm.action = "${path}/performanceReport/WorkFlowAnalysisController.do?method=exportNodeNameDetailExcel";
		searchForm.target = "temp_iframe";
		searchForm.submit();
	}
	
	function popprint() {
		var printContentBody = "";
		var cssList = new ArrayList();
		var pl = new ArrayList();
		var contentBody = "" ;
		var contentBodyFrag = "" ;
		
		contentBody = document.getElementById("print").innerHTML;
		contentBodyFrag = new PrintFragment(printContentBody, contentBody);
		pl.add(contentBodyFrag);
		
		cssList.add("/seeyon/common/skin/default/skin.css");
		
		printList(pl,cssList);
	}
	$(document).ready(function(){//IE7下如果只是scroll=yes,会出无谓的横向滚动条,只能这样了
		if($.browser.msie&&$.browser.version=="7.0"){
			$("body").css({"overflow-x":"hidden","overflow-y":"auto",height:"100%"});
			}else{
			$("body").prop("scroll","yes");
			}
	})
function forwardToCol(){
    //var iframeobj = $("#detailIframe").contents();
    convertTable();
    //$('tfoot').remove();
    var content = "<div style='height:300px;'>"+$('.mxt-grid-header').html();+"</div>";
    if(getA8Top().dialogArguments){
        getA8Top().dialogArguments.parent.closeAndForwardToCol($(".PopupTitle").html(),content);
    }else if(getA8Top().opener){//Chrome Firfox 
        getA8Top().opener.parent.closeAndForwardToCol($(".PopupTitle").html(),content);
    }
    getA8Top().close();
}

function convertTable(){
    var mxtgrid = $(".sort");
    if(mxtgrid.length > 0 ){
    //$(".sort thead tr td").each(function(){
    //var _html = $(this).html();
    //    $(this).parent().html(_html);
    //});
    var tableHeader = $(".sort thead tr");
                
    //$(".sort tbody tr td").each(function(){
    //    var _html = $(this).html();
    //        $(this).parent().html(_html);
    //});
                
    var tableBody = $(".sort tbody");
    var str = "";
    var headerHtml =tableHeader.html();
    if(headerHtml){
        var re = /TD/g
        headerHtml = headerHtml.replace(re, "th");
    }
    var bodyHtml = tableBody.html();
    if(headerHtml == null || headerHtml == 'null')
        headerHtml ="";
        if(bodyHtml == null || bodyHtml=='null'){
            bodyHtml="";
        }
        //if(mxtgrid.hasClass('dataTable')){
        //  str+="<table class='table-header-print table-header-print-dataTable' border='0' cellspacing='0' cellpadding='0'>"
        //}else{
            str+="<table class='table-header-print' border='0' cellspacing='0' cellpadding='0'>"
        //}
        str+="<thead>";
        str+=headerHtml;
        str+="</thead>";
        str+="<tbody>";
        str+=bodyHtml;
        str+="</tbody>";
        str+="</table>";
        var parentObj = mxtgrid.parent();
        mxtgrid.remove();
        parentObj.html(str);
        //jQuery("#listForm table tbody tr td").removeAttr('onclick');
    }   
}
//-->
</script>
<body scroll="yes" onkeydown="listenerKeyESC()" class="h100b">
<form id="searchForm" action="" method="post">
	<input type="hidden" id=nodeId name="nodeId" value="${param.nodeId }"/>
	<input type="hidden" id="templeteId" name="templeteId" value="${param.templeteId }"/>
	<input type="hidden" id="beginDate" name="beginDate" value="${param.beginDate }"/>
	<input type="hidden" id="endDate" name="endDate" value="${param.endDate }"/>
</form>
<table class="popupTitleRight" width="100%" height="100%" cellpadding="0" cellspacing="0">
<tr>
<td class="PopupTitle">
	<fmt:message key="common.processing.analysis.label" /> - ${memberName }
</td>
</tr>
<tr height="26px;">
	<td>
		<div class="div-float-right" style="margin-right: 20px; display: block;" >
			<table>
				<tr>
					<td>
						<span id="printButton1Div" class="ico16 forwarding_16" style="display: block;" onclick='forwardToCol()'></span>
					</td>
					<td>
						<a onclick="forwardToCol()">${ctp:i18n('performanceReport.queryMain.tools.reportForwardCol')}</a>
						&nbsp;&nbsp;
					</td>
					<td>
						<span id="ExcportExcel1Div" title="<fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' />" style="width: 16px; height: 16px; display: block;" class="export_excel_16 ico16 margin_r_5" onclick='javascript:exportNodeNameDetailExcel()'></span>			
					</td>
					<td>
						<a onclick="exportNodeNameDetailExcel()"><fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' /></a>&nbsp;&nbsp;
					</td>
					<td>
						<span id="printButton1Div" title="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />" class="ico16 print_16 margin_r_5" style="display: block;" onclick='popprint()'></span>
					</td>
					<td>
						<a onclick="popprint()"><fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' /></a>
					</td>
				</tr>
			</table>
		</div>
	</td>
</tr>
<tr>
	<td>
		<div id="print" class="margin_lr_10 h100b" >
			<form action="" method="post" id="content" height="100%">
				<v3x:table data="memberList" var="data" width="100%" dragable="false"  pageSize="20" >
					<v3x:column width="20%" align="left" type="String" label="common.deal.people.label" value="${v3x:showMemberName(data.memberId)}"></v3x:column>
					<v3x:column width="15%" align="left" type="String" label="common.processing.times.label" value="${data.count}"></v3x:column>
					<v3x:column width="15%" align="left" type="String" label="common.overtime.rate.label" >${v3x:showNumber2Percent(data.overRadio)}</v3x:column>
					<v3x:column width="20%" align="left" type="String" label="common.processing.period.label" value="${v3x:showDateByNature(data.deadLine)}"></v3x:column>
                    <v3x:column width="30%" align="left" type="String" label="common.average.handling.time.label" value="${data.avgRunTime==0?ctp:i18n_1('performanceReport.time.minute',0):v3x:showDateByWork(data.avgRunTime)}" maxLength="36"></v3x:column>

				</v3x:table>
			</form>
		</div>
	</td>
</tr>
<%--
<tr height="26px;">
	<td>
		<table style="width: 100%;">
			<tr>
				<td style="padding-left: 20px" width="10%"><fmt:message key="common.processing.period.label" /></td>
				<td width="90%">例如：1天</td>
			</tr>
		</table>
	</td>
</tr>
 --%>
</table>
<br>
<iframe name="temp_iframe" id="temp_iframe" style="display: none;">&nbsp;</iframe>
<script type="text/javascript">
<!--
// showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.collaboration.listsent' bundle='${v3xMainI18N}' />", "/common/images/detailBannner/103.gif", pageQueryMap.get('count'), _("collaborationLang.detail_info_103"));
//-->
</script>
</body>
</html>