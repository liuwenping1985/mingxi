<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="edocHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var jsEdocType=${edocType};
var listType = "${param.listType}";
</script>
<style>
SELECT{
		FONT-SIZE: 10pt; 
		FONT-FAMILY: Times New Roman;
		MARGIN-TOP:1px;
}
</style>
</head>
<body scroll="no" onload="setMenuState('menu_pending');">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2 webfx-menu-bar">
		<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="65%">
			    	<script type="text/javascript">
			    	var edocContorller="${detailURL}";
			    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");

			    	if(parent.edocType == 1) {
						
						if(listType == "listReading") {//待阅
			    			myBar.add(new WebFXMenuButton("", <fmt:message key="edoc.element.receive.batch.process" bundle="${v3xCommonI18N}" />, "javascript:newEdoc('${edocType}')", [4,5], "", null));/* 批处理 */
						} else if(list == "listReaded") {//已阅
							
						}

				    }

			    	<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>	
			    	document.write(myBar.toString());
			    	document.close();
			    	</script>			
				</td>
				<td><form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false">
					<input type="hidden" value="<c:out value='${param.method}' />" name="method">
					<input type="hidden" value="<c:out value='${edocType}' />" name="edocType">			
					<div class="div-float-right">
						<div class="div-float">
							<select name="condition" id="condition" onChange="showNextSpecialCondition(this)" class="condition" style="width:90px">
						    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							    <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
							    <c:if test="${edocType==0}">
							    <option value="docMark"><fmt:message key="edoc.element.wordno.label" /></option>
							    </c:if>	
							    <c:if test="${edocType==1}">
							    <option value="docMark"><fmt:message key="edoc.element.docmark" /></option>
							    </c:if>
							    <option value="docInMark"><fmt:message key="edoc.element.wordinno.label" /></option>
							    <option value="startMemberName"><fmt:message key="common.sender.label" bundle="${v3xCommonI18N}" /></option>
							    <option value="createDate"><fmt:message key="edoc.supervise.startdate"/></option>
							    
							    <c:if test="${edocType==1}">
							    	<option value="registerDate"><fmt:message key="edoc.element.register.date"/></option>
									<option value="recieveDate"><fmt:message key="edoc.element.receipt_date"/></option>
								    <option value="edocUnit"><fmt:message key="edoc.element.receive.edoc_unit"/></option>
							    </c:if>	
							    
						  	</select>
					  	</div>
					  	<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="startMemberNameDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="docMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="docInMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="createDateDiv" class="div-float hidden">
					  		<input type="text" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
					  		-
					  		<input type="text" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
					  	</div>
					  	
					  	<div id="edocUnitDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="recieveDateDiv" class="div-float hidden">
					  		<input type="text" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
					  		-
					  		<input type="text" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
					  	</div>
					  	<div id="registerDateDiv" class="div-float hidden">
					  		<input type="text" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
					  		-
					  		<input type="text" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
					  	</div>
					  	
					  	<div onclick="javascript:doSearch()" class=" div-float condition-search-button"></div>
				  	</div></form>
				</td>			
			</tr>  
		</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
		<c:url value='/common/images/overTime.gif' var="overTime" />
		<c:url value='/common/images/timeout.gif' var="timeOut" />
		<v3x:table htmlId="pending" data="pendingList" var="col" className="sort ellipsis edocellipsis">
			<c:set value="${v3x:toHTML(col.summary.subject)}" var="subject"  />
			
               <v3x:column width="35" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${col.summary.id}" affairId="${col.affairId}" subject="${subject}"/>
			</v3x:column>	
					
			<c:set var="click" value="openDetail('', 'from=Pending&affairId=${col.affairId}&from=Pending')"/>
			<c:set var="isRead" value="${col.state != 0}"/>
			<v3x:column width="10%" type="String" label="edoc.element.secretlevel.simple" className="cursor-hand sort" read="${isRead}"
			  onClick="${click}">
			<span title="<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/>"><v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/></span>&nbsp;
			</v3x:column>
			<v3x:column width="27%"   symbol="..." type="String" label="common.subject.label" className="cursor-hand sort proxy-${col.proxy} mxtgrid_black" read="${isRead}"
			bodyType="${col.bodyType}" value="${col.summary.subject}" hasAttachments="${col.summary.hasAttachments}"  onClick="${click}" 
			extIcons="${(col.deadLine ne null && col.deadLine ne ''&& col.deadLine ne '0') ? (col.overtopTime eq true ? timeOut : overTime) : null}"
			importantLevel="${col.summary.urgentLevel}" 
			/>	
			
			<v3x:column width="10%" type="String" label="edoc.element.wordno.label" className="cursor-hand sort" read="${isRead}"
			 onClick="${click}">
				<span title="${v3x:toHTML(col.summary.docMark)}">${v3x:toHTML(col.summary.docMark)}</span>&nbsp;
			</v3x:column>
			
			<v3x:column width="10%" type="String"  label="edoc.element.wordinno.label" className="cursor-hand sort" read="${isRead}"
			 onClick="${click}">
				<span title="${v3x:toHTML(col.summary.serialNo)}">${v3x:toHTML(col.summary.serialNo)}</span>&nbsp;
			</v3x:column>
							
			<v3x:column width="10%" type="String" label="common.sender.label"
			className="cursor-hand sort" read="${isRead}"
			 onClick="${click}" >
				<span title="${col.summary.startMember.name}">${col.summary.startMember.name}</span>&nbsp;
			</v3x:column>
			
			<v3x:column width="12%" type="Date" label="edoc.supervise.startdate" className="cursor-hand sort" align="left" read="${isRead}"
			 onClick="${click}">
				<span title="<fmt:formatDate value="${col.summary.createTime}"  pattern="${datePattern}"/>"><fmt:formatDate value="${col.summary.createTime}"  pattern="${datePattern}"/></span>&nbsp;
			</v3x:column>	
						
			<v3x:column width="8%" type="String" label="edoc.node.cycle.label" className="cursor-hand sort" 
			read="${isRead}"  onClick="${click}" alt="${v3x:_(pageContext, isOvertop)}" >
				<v3x:metadataItemLabel metadata="${colMetadata.collaboration_deadline}" value="${col.deadLine}"/>	
			</v3x:column>	
						
			<v3x:column type="Number" align="center" label="hasten.number.label" className="cursor-hand sort" read="${isRead}"
			 onClick="${click}" value="${col.hastenTimes}">					
			</v3x:column>
			<%--
			<v3x:column width="6%" type="String" align="center" label="processLog.list.title.label" >
				<img src="<c:url value='/apps_res/collaboration/images/workflowDetail.gif' />" onclick="showProcessLog('${col.summary.processId}');" class="cursor-hand sort">
			</v3x:column>
			--%>
		</v3x:table>
		</form>  
    </div>
  </div>
</div>
<script type="text/javascript">
<!--
initIpadScroll("scrollListDiv",550,870);
//showDetailPageBaseInfo("detailFrame", "<fmt:message key='edoc.workitem.state.pending' />", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_2013"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
//-->
</script>
</body>
</html>