<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%
    int exchangeType = com.seeyon.apps.edoc.enums.EdocEnum.edocType.recEdoc.ordinal();
    request.setAttribute("exchangeType",exchangeType);
    request.setAttribute("href", com.seeyon.ctp.portal.section.templete.BaseSectionTemplete.OPEN_TYPE.href);
    request.setAttribute("open", com.seeyon.ctp.portal.section.templete.BaseSectionTemplete.OPEN_TYPE.openWorkSpace);
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>Insert title here</title>
<style type="text/css">
.nowrap{
    white-space: nowrap;
}
</style>
<%@ include file="edocHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
//if(parent.statFrame.currentTD != null){
//	parent.statFrame.document.getElementById(parent.statFrame.currentTD).className = "manageTD-sel";
//}
function doExport(){
	var title = encodeURI("${reportName}");
	document.hiddenIframe.location.href = "<html:link renderURL='/edocWorkManage.do?method=listEdocExport&title="+title+"&type=${type}&userId=${userId}&typeStr=${typeStr}&startTime=${startTime}&endTime=${endTime}&coverTime=${coverTime}&Checkbox1=${Checkbox1}&Checkbox2=${Checkbox2}'/>";
}


function openEdocStatWorkManagerDetail(url,openType){
	if(openType == 'href'){
		parent.location.href = url;
	}else {	
	    //绩效考核进来
		var returnValue = v3x.openWindow({url : url, workSpace : "yes", dialogType: 'open'});
		if(returnValue){
			if(returnValue =='true' || returnValue == true){
				document.location.reload();
				//parent.statFrame.location.href=parent.statFrame.location.href+"&init=false";
			}
		}
	}
}
function transmitToCol(){
	var _parent;
	if(window.dialogArguments){
		_parent = window.dialogArguments;
	}else if(parent.window.dialogArguments){
		_parent = parent.window.dialogArguments;
	}
	if(_parent){
		var title;
		try{
			title = parent.window.dialogArguments.pwindow.document.getElementById("reportName").innerHTML;
		}catch(e){
			title="${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";
		}
		convertTable();
		var content = "<div style='height:300px;'>"+$('#listForm').html()+"</div>";
		_parent.closeAndForwordToCol(content, title);
		//formObj.action = "<html:link renderURL='/edocWorkManage.do?method=edocReportToCol'/>";
		//formObj.submit();
	}else{
		transmitCol_self();
	}
}



//转发协同
function transmitCol_self(){
	var reportTitle="${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";
	var _content =$('#hDivnull')[0].outerHTML;
	var _tableContent = $("#bDivnull")[0].outerHTML;
    _tableContent = _tableContent.replace(/href="[^"]*"/ig,href=""); 
    var contentHtml = _content+_tableContent;
    contentHtml = contentHtml;
    try{getA8Top().up.throughListForwardCol(contentHtml.replace(/<(br|BR)\s*\/\s*>/g,""),reportTitle);}catch(e){}
}


function printReport(){
	var printSubject = "";
	var printsub = "${reportName}";
	document.getElementById("cDragnull").style.display = "none";
	document.getElementById("pagerTd").style.display = "none";
	printsub = "<center><span style='font-size:20px;line-height:24px;'>"+printsub+"</span></center>";
	var printSubFrag = new PrintFragment(printSubject, printsub);
	try{
		var printBody= "";
		var colcontext = document.getElementById("scrollListDiv").innerHTML;
		var re = /sort-select/g;
		colcontext = colcontext.replace(re, "");
		//re = /table-body/g
		//colcontext = colcontext.replace(re, "only_table");
		//re = /hDiv/g
		//colcontext = colcontext.replace(re, "only_table");
		if(colcontext.indexOf("inline-block bodyType_OfficeWord") > 0){
			re = /inline-block bodyType_OfficeWord/g;
			colcontext = colcontext.replace(re, "");
		}
		var colBody;
		if(colcontext != null){
			//colBody='<input id="inputPosition" type="text" style="border:0px;width:1px;height:0.01px" onfocus="javascript:return false;" onclick="return false;"/>\r\n';
			//colBody+='<div id="iSignatureHtmlDiv" name="iSignatureHtmlDiv"  width=\'1px\' height=\'1px\'></div>';
			//colBody+= "<div class='contentText' style='margin:0 10px;width:100%'>"+colcontext+"</div>";
			colBody = colcontext;
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
	document.getElementById("cDragnull").style.display = "";
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

	jQuery(".bDiv tbody td div a").each(function(){
		var _html = $(this).html();
			$(this).parent().html(_html);
    });
				
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
            str+="<table class='table-header-print' style='white-space: nowrap;' border='0' cellspacing='0' cellpadding='0'>"
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
</script>
</head>
<body srcoll="no">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2 webfx-menu-bar">
    
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<%--<c:choose>
				<c:when test="${param.type != null}">
					${param.title}
				</c:when>
				<c:otherwise>
					<fmt:message key='application.1.label' bundle='${v3xCommonI18N}'/> ( <fmt:message key='col.coltype.Pending.label' /> )
				</c:otherwise>
			</c:choose>--%>
			<script type="text/javascript">
	   				var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","gray");
					myBar.add(new WebFXMenuButton("transmitToCol", "转发协同", "transmitToCol()", [1,7], "", null));
					myBar.add(new WebFXMenuButton("doExport", "导出Excel", "doExport()", "/seeyon/common/images/toolbar/importExcel.gif"));
					myBar.add(new WebFXMenuButton("printReport", "打印", "printReport()", [1,8], "", null));
	   				document.write(myBar.toString());
				    document.close();
	  		</script>
		</td>
	</tr>
	</table> 
    
    </div>
    <div class="center_div_row2" id="scrollListDiv">
      <form id="listForm" name="listForm" method="POST">
	  <input type="hidden" id="statType" name="statType" /><%--报表统计名称--%>
	  <input type="hidden" id="statContent" name="statContent" /><%--统计内容--%>
			<v3x:table data="colList" var="col" className="sort">
			 	<c:set var="openType" value="${open}" />
			 	<c:set value="${v3x:toString(v3x:getApplicationCategoryEnum(col.affair.app))}" var="appCategory"/>
				<c:set value="${v3x:escapeJavascript(col.summary.subject)}" var="subject"  />
				<c:set var="isRead" value="true"/>
				<v3x:column width="4%" type="String" label="edoc.element.secretlevel.simple" className="sort" read="${isRead}">
				<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/>
				</v3x:column>
				<v3x:column width="34%"  type="String" label="common.subject.label"  className="<c:if test='${isCurrentUser==true}'>cursor-hand</c:if> sort proxy-${col.proxy} nowrap" read="${isRead}"
				bodyType="${col.bodyType}" hasAttachments="${col.summary.hasAttachments}"  importantLevel="${col.summary.importantLevel}" >
					<%--<c:choose> 验证是否能查看公文，在打开公文后的安全验证中进行
						<c:when test="${isCurrentUser==true}">--%>
						    <%-- 如果当前人员ID等于affair.memberId，并且type=0或1 （即为待办或暂存待办）则都以待办状态打开查看 --%>
						    <c:set var="status" value="Done"/>
						    <c:if test='${isCurrentUser && (type == 1 || type ==0 || col.affair.state == 3)}'><c:set var="status" value="Pending"/></c:if>
						    
						    <%-- 用于工作详情页面 --%>
						    <c:set var="_openFrom" value=""/>
						    <c:if test="${pageType=='edocPerformanceList'}"><c:set var="_openFrom" value="&openFrom=edocPerformanceList"/></c:if>
						    
						    <%-- 待办,其他情况如已办还是采用最初的那种模态对话框的打开方式。--%>
							<c:set var="url" value="${edoc}?method=detailIFrame&from=${status}&affairId=${col.affair.id}${_openFrom}"/>
							<c:choose>
				      			<%--待发送（22）--%>
				    			<c:when test="${appCategory == 'exSend'}">
				     				<c:set var="url" value="${exchageEdoc}?method=sendDetail&modelType=toSend&id=${col.affair.subObjectId}${_openFrom}"/>	
				     			</c:when>
				     			
				     			<%--待签收（23）--%>
				       			<c:when test="${appCategory == 'exSign'}">
					      			<c:set var="url" value="${exchageEdoc}?method=receiveDetail&modelType=toReceive&id=${col.affair.subObjectId}${_openFrom}"/>	
								</c:when>
								
								<%--待登记（24）--%>
					   			<c:when test="${appCategory == 'edocRegister'}">
				   					<c:set var="openType" value="${href}" />
			      					<c:set var="url" value="${edoc}?method=entryManager&entry=newEdoc&comm=register&edocType=${exchangeType}&exchangeId=${col.affair.subObjectId}&edocId=${col.affair.objectId}&recieveId=${col.affair.subObjectId}${_openFrom}" />					   				
			      				</c:when>
							</c:choose>
							
							<%-- GOV-5012  工具栏-工作管理-工作统计，选择公文，任意已发数据打开后，界面节点显示显示为空。    --%>
							<%-- 这里改为当是已发公文时，文单上面的按钮就不显示了 --%>
							<c:if test ="${v3x:getSysFlagByName('sys_isGovVer')=='true'}">
							<c:choose>
								<c:when test="${(appCategory == 'edoc' || appCategory == 'edocSend')&& col.affair.state == 2}">
				     				<c:set var="url" value="${edoc}?method=detailIFrame&from=sended&affairId=${col.affair.id}${_openFrom}"/>
				     			</c:when>
								<c:when test="${appCategory == 'edocRec'&& col.affair.state == 2}">
				      				<c:set var="url" value="${edoc}?method=detailIFrame&from=sended&affairId=${col.affair.id}${_openFrom}"/>	
				      			</c:when>
							</c:choose>
							</c:if>
							<a class="title-more" title="${v3x:toHTML(col.summary.subject)}" href="javascript:openEdocStatWorkManagerDetail('${url}','${openType}')">${v3x:toHTML(col.summary.subject)}</a>
						<%--</c:when>
						<c:otherwise>
						${v3x:toHTML(col.summary.subject)}
						</c:otherwise>
					</c:choose>--%>
				</v3x:column>
				<v3x:column width="10%" type="String" label="edoc.element.wordno.label" className="sort nowrap" read="${isRead}"
				value="${col.summary.docMark}"/>
				<v3x:column width="10%" type="String" label="edoc.element.wordinno.label" className="sort nowrap" read="${isRead}"
				value="${col.summary.serialNo}"/>				
				<v3x:column width="5%" type="String" label="common.sender.label" value="${col.summary.startMember.name}"
				className="sort nowrap" read="${isRead}"
				 />
				<v3x:column width="11%" type="Date" label="edoc.supervise.startdate" className="sort nowrap" read="${isRead}"
				>
					<fmt:formatDate value="${col.summary.createTime}"  pattern="${datePattern}"/>
				</v3x:column>
				<%--<c:if test='${type == 2 || type == 4 || type == 6 || type == 8 || type == 22}'>--%>
					<v3x:column width="11%" type="Date" label="edoc.supervise.managedate" className="sort nowrap" read="${isRead}"
					>
						<fmt:formatDate value="${col.dealTime}"  pattern="${datePattern}"/>
					</v3x:column>
				<%--</c:if>--%>
				<v3x:column width="6%" type="String" label="edoc.node.cycle.label" className="sort nowrap" read="${isRead}"  alt="${v3x:_(pageContext, isOvertop)}" value="${col.deadlineDisplay}">
				</v3x:column>
				<%--<c:if test='${type == 2 || type == 4 || type == 6 || type == 8 || type == 22}'>--%>
					<v3x:column width="5%" type="String" label="edoc.isTrack.label" className="sort">
						<c:if test="${col.track==0}"><fmt:message key='edoc.form.no' /></c:if>
						<c:if test="${col.track==1}"><fmt:message key='edoc.form.yes' /></c:if> 
					</v3x:column>
				<%--</c:if>--%>				
				<v3x:column width="5%" type="Number" align="center" label="hasten.number.label" className="sort nowrap" read="${isRead}"
				 value="${col.hastenTimes}">					
				</v3x:column>	
			</v3x:table>
      </form>
    </div>
  </div>
</div>
<iframe name="hiddenIframe" style="display:none"></iframe>
</body>
</html>