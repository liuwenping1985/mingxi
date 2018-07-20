<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.meeting.manager.MtMeetingManagerImpl"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">


<script type="text/javascript">
<!--
var statType ="${statType}";
window.onload = function(){
}
function displayMeetingDetail(meetingId,proxy,proxyId) {
  var userId = document.getElementById("userId").value;
  var currentUser = document.getElementById("currentUser").value;
  var userName = document.getElementById("userName").value;
  if(userId != currentUser && hasDisplayMeetingContent(meetingId,currentUser) != "true"){
    alert("你不在该会议中，不允许查看！");
    return ;
  }
  var frameObj = parent.document.getElementById("detailMainFrame");
  var address = '${mtMeetingURL}?method=mydetail&openfrom=report&id='+meetingId+'&proxy='+proxy+'&proxyId='+proxyId+'&statType='+statType;
  $(frameObj).attr("src", address);
  //frameObj.location.href = '${mtMeetingURL}?method=mydetail&id='+meetingId+'&proxy='+proxy+'&proxyId='+proxyId;
}

/**
 * 验证当前用户是否有权限查看详细信息（如果当前人=被统计人 那么就直接跳过） 根据当前人员是否在会议的参会人员中
 */
function hasDisplayMeetingContent(meetingId, userId){
  var requestCaller = new XMLHttpRequestCaller(this,"ajaxMtMeetingManager","isMeetingScopeByMeetingAndUser",false);
  requestCaller.addParameter(1,"String",meetingId);
  requestCaller.addParameter(2,"String",userId);
  var ds = requestCaller.serviceRequest();
  return ds;
}

/**
 * 打印
 */
function doExport(){
	document.hiddenIframe.location.href = "<html:link renderURL='/meeting.do?method=listMeetingExport&userid=${userId}&statType=${statType}&time=${time}&begindate=${begindate}&enddate=${enddate}&fieldType=${fieldType}&status=${status}'/>";
}

function transmitToCol(){
	//var title = parent.window.dialogArguments.pwindow.document.getElementById("reportName").innerHTML;
	//var title = "${reportName}";
	convertTable();
	var content = "<div style='height:300px;'>"+$('#listForm').html()+"</div>";
	//parent.window.dialogArguments.closeAndForwordToCol(content, title);
	getA8Top().up.throughListForwardCol(content,"");
	//formObj.action = "<html:link renderURL='/meeting.do?method=meetingReportToCol'/>";
	//formObj.submit();

}

function printReport(){
	var printSubject = "";
	//var printsub = parent.window.dialogArguments.pwindow.document.getElementById("reportName").innerHTML;
	var printsub = "${reportName}";
	document.getElementById("cDraglistTable").style.display = "none";
	document.getElementById("pagerTd").style.display = "none";
	printsub = "<center><span style='font-size:20px;line-height:24px;'>"+printsub+"</span></center>";
	var printSubFrag = new PrintFragment(printSubject, printsub);
	try{
		var printBody= "";
		var colcontext = document.getElementById("scrollListDiv").innerHTML;
		var re = /sort-select/g;
		colcontext = colcontext.replace(re, "");
		var colBody;
		if(colcontext != null){
			colBody='<input id="inputPosition" type="text" style="border:0px;width:1px;height:0.01px" onfocus="javascript:return false;" onclick="return false;"/>\r\n';
			colBody+='<div id="iSignatureHtmlDiv" name="iSignatureHtmlDiv"  width=\'1px\' height=\'1px\'></div>';
			colBody+= "<div class='contentText' style='margin:0 10px;width:100%'>"+colcontext+"</div>";
			//colBody = colcontext.innerHTML;
		}else{
			colBody="";
		}
		var colBodyFrag = new PrintFragment(printBody, colBody);
	}catch(e){}
	var tlist = new ArrayList();
	tlist.add(printSubFrag);
	//tlist.add(list1);
	tlist.add(colBodyFrag);
	var cssList=new ArrayList();
	printList(tlist,cssList);
	document.getElementById("cDraglistTable").style.display = "";
	document.getElementById("pagerTd").style.display = "";
}
function convertTable(){
	var mxtgrid = jQuery(".mxtgrid");
	if(mxtgrid.length > 0 ){
	jQuery(".hDivBox thead th div").each(function(){
	var _html = $(this).html();
		$(this).parent().html(_html);
	});
    var tableHeader = jQuery(".hDivBox thead");

    jQuery(".bDiv tbody td div").each(function(){
		var _html = $(this).html();
			$(this).parent().html(_html);
    });

    var tableBody = jQuery(".bDiv tbody");
    var str = "";
    var headerHtml =tableHeader.html();
    var bodyHtml = tableBody.html();
    if(headerHtml == null || headerHtml == 'null')
		headerHtml ="";
        if(bodyHtml == null || bodyHtml=='null'){
			bodyHtml="";
        }
        //if(mxtgrid.hasClass('dataTable')){
		//	str+="<table class='table-header-print table-header-print-dataTable' border='0' cellspacing='0' cellpadding='0'>"
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
		jQuery("#listForm table tbody tr td").removeAttr('onclick');
	}
}
    //-->
</script>
</head>
<body onload="">
<div class="main_div_row2">
<div class="right_div_row2">
<div class="top_div_row2 webfx-menu-bar">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   	<tr>
			<td>
	   			<script type="text/javascript">
	   				var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","gray");
					myBar.add(new WebFXMenuButton("transmitToCol", "<fmt:message key='mt.listToCol.lable'/>", "transmitToCol()", [1,7], "", null));
					myBar.add(new WebFXMenuButton("doExport", "<fmt:message key='mt.button.export'/>Excel", "doExport()", "/seeyon/common/images/toolbar/importExcel.gif"));
					myBar.add(new WebFXMenuButton("printReport", "<fmt:message key='meeting.print'/>", "printReport()", [1,8], "", null));
	   				document.write(myBar);
				    document.close();
	  			</script>
	   		</td>
	  	</tr>
	</table>
</div>
<div class="center_div_row2" id="scrollListDiv">
<form name="listForm" id="listForm" method="post" style="margin: 0px">
<input type="hidden" id="userId" value="${userId}" /><%-- 被统计人ID--%>
<input type="hidden" id="currentUser" value="${currentUser}" /><%--当前人员ID --%>
<input type="hidden" id="userName" value="${v3x:showMemberNameOnly(userId)}" />
<input type="hidden" id="statType" name="statType" /><%--报表统计名称--%>
<input type="hidden" id="statContent" name="statContent" /><%--统计内容--%>
<v3x:table htmlId="listTable" data="list" var="bean" >
    <c:set value="displayMeetingDetail('${bean.id}','-1','-1');" var="click" />
	<v3x:column width="60%" onClick="${click}" bodyType="${bean.dataFormat}" hasAttachments="${bean.hasAttachments}" type="String" label="mt.list.column.mt_name" className="cursor-hand sort" maxLength="45" symbol="...">
        ${bean.title}
        <c:if test="${bean.meetingType eq  '2' }">
            <span class="bodyType_videoConf inline-block"></span>
        </c:if>
	</v3x:column>

	<v3x:column width="20%" onClick="${click}" type="String" label="mt.mtMeeting.beginDate" className="cursor-hand sort" maxLength="45" symbol="...">
		<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />
	</v3x:column>

	<v3x:column width="20%" onClick="${click}" type="String" label="common.date.endtime.label" className="cursor-hand sort" maxLength="45" symbol="...">
		<fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />
	</v3x:column>

</v3x:table>
</form>
</div>
</div>
</div>
<%--
<%@ include file="../../doc/pigeonholeHeader.jsp"%>
 //TODO
 --%>
<jsp:include page="../include/deal_exception.jsp" />
<script type="text/javascript">
<!--
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='mt.mtMeeting' /><fmt:message key='mt.list' />", [1,5], pageQueryMap.get('count'), "");
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	initIpadScroll("scrollListDiv",550,870);
//-->
</script>
<iframe name="hiddenIframe" style="display:none"></iframe>
</body>
</html>