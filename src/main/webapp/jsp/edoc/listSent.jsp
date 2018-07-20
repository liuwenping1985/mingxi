<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<html:link renderURL="/doc.do" var="pigeonholeDetailURL" />
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="edocHeader.jsp" %>
<%@ include file="/WEB-INF/jsp/edoc/lock/edocLock_js.jsp"%>
<script type="text/javascript">
var pigeonholeURL = "${pigeonholeDetailURL}";
var jsEdocType=${edocType};
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/listSent.js${v3x:resSuffix()}" />"></script>
<style>
SELECT{
		FONT-SIZE: 10pt;
		FONT-FAMILY: Times New Roman;
		MARGIN-TOP:1px;
}
</style>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<!-- <style>
.mxtgrid div.bDiv td div{
padding-bottom:2px;
padding-top:2px;
height:auto;
line-height:1.5;
} -->
</style>
</head>
<body scroll="no" onload="setMenuState('menu_sended');">
<input type="hidden" id="currentUserId" value="${currentUserId }"/>
<div class="main_div_row2">
  		<div class="right_div_row2">
    		     <div class="top_div_row2">
<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22" width="65%" class="webfx-menu-bar">
	    	<script type="text/javascript">
	    	var edocContorller="${detailURL}";
	    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");

			if(v3x.getBrowserFlag('hideMenu')){
				//lijl添加"分发"
				if(jsEdocType==1){
					//GOV-3330 （需求检查）【公文管理】-【收文管理】-【分发】-【已分发】，隐藏toolbar上功能按钮'分发'
					//myBar.add(new WebFXMenuButton("", "<fmt:message key='edoc.element.receive.distribute' />", "javascript:newEdoc('${edocType}')", [4,5], "", null));
				}
				myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.repeal.label' bundle='${v3xCommonI18N}'/>", "javascript:repealItems('pending')", [7,4], "", null));
	    		myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />", "pigeonholeForEdoc('sent',jsEdocType);", [1,9], "", null));
			}
	    	myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "javascript:deleteItems('sent')", [1,3], "", null));
    		//lijl添加"取回"
    		/* myBar.add(new WebFXMenuButton("", "<fmt:message key='takeBack.label' />", "javascript:sentTakeBack()", [4,5], "", null)); */
    		<%--puyc--%>
    		if('${edocType}'=='1'&& "${isG6Ver}"=="true") {//xiangfan 添加 发文管理 不需要 '转发文'功能
    			//多浏览器屏蔽
    			//if("${v3x:getBrowserFlagByRequest('HideBrowsers', pageContext.request)}"=="true") {
	    			var resourceKey = "F07_sendNewEdoc";
					if(hasEdocResourceCode(resourceKey)) {
						myBar.add(new WebFXMenuButton("", "<fmt:message key='edoc.new.type.forwardarticle'/>", "javascript:showForwardWDTwo('waitSent')", [1,7], "", null));
					}
    			//}
			}
	    	<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>

	    	document.write(myBar);
	    	document.close();
	    	</script>
		</td>
		<td class="webfx-menu-bar border-right"><form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
			<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			<input type="hidden" value="<c:out value='${param.listType}' />" name="listType">
			<input type="hidden" value="<c:out value='${param.track}' />" name="track">
			<input type="hidden" value="<c:out value='${edocType}' />" name="edocType">
			<input type="hidden" id="appName" name="appName" value='<%=ApplicationCategoryEnum.edoc.getKey()%>'/>
			<div class="div-float-right">
				<div class="div-float">
					<select id="condition" name="condition" onChange="showNextSpecialCondition(this)" class="condition" style="width:90px">
				    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
					    <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
					    <c:if test="${isG6Ver && edocType == 1}">
					        <option value="secretLevel"><fmt:message key="edoc.element.secretlevel.simple"/></option>
					    </c:if>
					    <option value="docMark"><fmt:message key="edoc.element.wordno.label" /></option>

					    <c:choose>
							<c:when test="${isG6Ver && edocType == 1}">
								<option value="docInMark"><fmt:message key="edoc.element.receive.serial_no" /></option>
								<option value="createDate">收文日期</option>
							</c:when>
							<c:otherwise>
								<option value="docInMark"><fmt:message key="edoc.element.wordinno.label" /></option>
								<option value="createDate"><fmt:message key="edoc.supervise.startdate" /></option>
							</c:otherwise>
						</c:choose>

					    <c:if test="${edocType==1 && !isG6Ver}">
					    	<option value="registerDate"><fmt:message key="edoc.element.register.date"/></option>
							<option value="recieveDate"><fmt:message key="edoc.element.receive.date"/></option>
                        </c:if>
                        <option value="deadlineDatetime"><fmt:message key="process.cycle.label"/></option>
                        <option value="workflowState"><fmt:message key="process.workFlowState.label"/></option>
                        <%--交换方式 --%>
                        <c:if test="${v3x:hasPlugin('sursenExchange') && isOpenRegister != 'true' && edocType == 1}"> 
							<option value="exchangeMode"  <c:if test="${condition == 'exchangeMode'}">selected</c:if>><fmt:message key="edoc.exchangeMode" /></option>  <%-- 交换方式 --%>
						</c:if>
				  	</select>
			  	</div>
			  	
			  	<div id="subjectDiv" class="div-float hidden"><input type="text" id="textfield" name="textfield" class="textfield"></div>
			  	<c:if test="${isG6Ver && edocType == 1}">
                    <div id="secretLevelDiv" class="div-float hidden">
                        <select name="textfield" class="condition" style="width:90px">
                            <option value=""><fmt:message key="common.pleaseSelect.label" /></option>
                            <c:forEach var="secret" items="${colMetadata['edoc_secret_level'].items}">
                                <option value="${secret.value}">
                                <c:choose>
                                <c:when test="${secret.i18n == 1 }">
                                ${v3x:_(pageContext, secret.label)}
                                </c:when>
                                <c:otherwise>
                                ${secret.label}
                                </c:otherwise>
                                </c:choose>

                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </c:if>
			  	<div id="docMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	<div id="docInMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	<div id="createDateDiv" class="div-float hidden">
			  		<input type="text" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
			  		-
			  		<input type="text" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
			  	</div>
			  	<div id="deadlineDatetimeDiv" class="div-float hidden">
			  		<input type="text" name="textfield" id="deadlineDateBegin" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
			  		-
			  		<input type="text" name="textfield1" id="deadlineDateEnd" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
			  	</div>
			  	<div id="workflowStateDiv" class="div-float hidden">
				  	<select name="textfield" class="condition" style="width:90px">
	                            <option value="0"><fmt:message key="edoc.unend"/></option>
	                            <option value="1"><fmt:message key="edoc.ended"/></option>
	                            <option value="2"><fmt:message key="edoc.terminated"/></option>
	                     </select>
			  	</div>
			  	<c:if test="${edocType==1 && !isG6Ver}">
			  	    <div id="registerDateDiv" class="div-float hidden">
	                    <input type="text" id="textfield" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
	                    -
	                    <input type="text" id="textfield1" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
	                </div>
	                <div id="recieveDateDiv" class="div-float hidden">
	                    <input type="text" id="textfield" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
	                    -
	                    <input type="text" id="textfield1" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
	                </div>
			  	</c:if>
			  	<c:if test="${v3x:hasPlugin('sursenExchange') && isOpenRegister != 'true' && edocType == 1}">
				  	<div id="exchangeModeDiv" class="div-float hidden">
						<select name="textfield">
							<option value=0><fmt:message key='edoc.exchangeMode.internal'/></option>   <%-- 内部公文交换 --%>
							<option value=1><fmt:message key='edoc.exchangeMode.sursen'/></option>  <%-- 书生公文交换 --%>
						</select>
				  	</div>
				</c:if>
			  	<div onclick="javascript:doSearch2()" class="condition-search-button"></div>
		  	</div></form>
		</td>
	</tr>
</table>
             </div>
    <div class="center_div_row2" id="scrollListDiv">

			<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
			<input type="hidden" value="" name="docBack" />
			<input type="hidden" value="" name="archiveId" id="archiveId" />
			<input type="hidden" id="pigeonholeType" name="pigeonholeType" value=""/>
			<v3x:table htmlId="pending" data="pendingList" var="col" className="sort ellipsis">
                <c:set value="${v3x:toHTML(col.summary.subject)}" var="subject"  />

                <v3x:column width="3%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
					<input type='checkbox' name='id' value="${col.summary.id}" affairId="${col.affairId}" processId="${col.summary.processId}"
					hasArchive="${col.summary.hasArchive}"  subject="${col.summary.subject}"  archiveId="${col.summary.archiveId}" nodePolicy="${col.nodePolicy}" finished="${col.finshed}" summaryBodyType="${col.bodyType}"/>
				</v3x:column>

				<c:set var="click" value="openDetail('', 'from=listSent&affairId=${col.affairId}&detailType=listSent&edocType=${edocType}&edocId=${col.summary.id}');"/>
				<c:set var="isRead" value="true"/>

				<v3x:column width="5%" type="String" label="edoc.element.secretlevel.simple" className="cursor-hand sort" read="${isRead}"
				  onClick="${click}">
				<span title="<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/>"><v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/></span>&nbsp;
				</v3x:column>

				<!-- 标题列标题 -->
				<v3x:column width="20%"   symbol="..." type="String" label="common.subject.label" className="cursor-hand sort mxtgrid_black" read="${isRead}"
				bodyType="${col.bodyType}" value="${col.summary.subject}" alt="${col.summary.subject}" hasAttachments="${col.summary.hasAttachments}" importantLevel="${col.summary.urgentLevel}"  onClick="${click}"
				flowState="${col.summary.state eq 112 ? 3 : col.summary.state}"/>

				<v3x:column width="13%" type="String" label="edoc.element.wordno.label" className="cursor-hand sort" read="${isRead}"
				value="${col.summary.docMark}" alt="${col.summary.docMark}"  onClick="${click}" />

				<c:choose>
					<c:when test="${isG6Ver && edocType == 1}">
						<v3x:column width="13%" type="String" label="edoc.element.receive.serial_no" className="cursor-hand sort" read="${isRead}"
						value="${col.summary.serialNo}" alt="${col.summary.serialNo}"  onClick="${click}" />
					</c:when>
					<c:otherwise>
						<v3x:column width="13%" type="String" label="edoc.element.wordinno.label" className="cursor-hand sort" read="${isRead}"
						value="${col.summary.serialNo}" alt="${col.summary.serialNo}"  onClick="${click}" />
					</c:otherwise>
				</c:choose>

				<v3x:column width="12%" type="Date" label="edoc.supervise.startdate" className="cursor-hand sort" read="${isRead}"
				 onClick="${click}">

					<span title="<fmt:formatDate value="${col.summary.createTime}" pattern="${datePattern}"/>"><fmt:formatDate value="${col.summary.createTime}" pattern="${datePattern}"/></span>&nbsp;
				</v3x:column>

				<c:if test="${col.isExcessTwoPerson}">
				 	<c:set var="currentNodesInfoAlt" value="${col.currentNodesInfo}..."/>
				</c:if>
				<c:if test="${!col.isExcessTwoPerson}">
				 	<c:set var="currentNodesInfoAlt" value="${col.currentNodesInfo}"/>
				</c:if>

				<v3x:column width="7%" type="String" symbol="..." alt="${currentNodesInfoAlt}" label="edoc.list.currentNodesInfo.label" className="cursor-hand sort" read="${isRead}">
				 <%--
				 <c:if test="${fn:length(col.currentNodesInfo)>8 }">
				 	<c:set var="currentNodesInfo" value="${fn:substring(col.currentNodesInfo, 0, 8)}..."/>
				 </c:if>
				 <c:if test="${fn:length(col.currentNodesInfo)<=8 }">
				 	<c:set var="currentNodesInfo" value="${col.currentNodesInfo}"/>
				 </c:if>
				 --%>
				 <c:set var="currentNodesInfo" value="${col.currentNodesInfo}"/>

				 <c:if test="${not empty col.summary.processId && (col.summary.processId!=0)}">
				 <a href="javascript:void(0)" onclick="showFlowChart('${col.summary.caseId }','${col.summary.processId }','${col.summary.templeteId }','${col.affair.activityId}');">
				 	${currentNodesInfo}
				 </a>
				</c:if>
				<c:if test="${empty col.summary.processId || (col.summary.processId==0)}">
					${currentNodesInfo}
				</c:if>
				</v3x:column>

				<v3x:column width="10%" type="String" label="process.cycle.label" className="cursor-hand sort deadline-${col.summary.worklfowTimeout}"
				read="${isRead}"  onClick="${click}" alt='${col.deadlineDisplay ne "" ? col.deadlineDisplay:v3x:_(pageContext, isOvertop)}}' >

				<c:choose>
					<c:when test="${ col.summary.worklfowTimeout }">
						<c:set var="process_status" value="${ctp:i18n('collaboration.listsent.overtime.title')}"/>
					</c:when>
					<c:otherwise>
						<c:set var="process_status" value="${ctp:i18n('collaboration.listsent.overtime.no.title')}"/>
					</c:otherwise>
				</c:choose>
				<font <c:if test="${col.summary.worklfowTimeout}"> color="red"</c:if>>
					<span id="deadline${col.affairId}" title="${process_status }">
						<c:if test='${col.deadlineDisplay ne ""}'>
							${col.deadlineDisplay}
						</c:if>
						<c:if test='${col.deadlineDisplay eq ""}'>
							<v3x:metadataItemLabel metadata="${colMetadata.collaboration_deadline}" value="${col.summary.deadline}"/>
						</c:if>
					</span>
					</font>
<%-- 					<script>
					try{
						var nowMinitueValue=${col.summary.deadline};
						if(document.getElementById("deadline${col.affairId}").innerHTML.length==0 && nowMinitueValue>0){
							var nowDayValue=Math.floor(nowMinitueValue/60/24);
							var minitueValue_mod=nowMinitueValue%(60*24);
							var nowHourValue=Math.floor(minitueValue_mod/60);
							var minitueValue_mod_2=minitueValue_mod%60;
							var nowDayValueStr=nowDayValue!=0?(nowDayValue+"天"):"";
							var nowHourValueStr=nowHourValue!=0?(nowHourValue+"小时"):"";
							var minitueValue_mod_2_str=minitueValue_mod_2!=0?(minitueValue_mod_2+"分钟"):"";
							document.getElementById("deadline${col.affairId}").innerHTML=nowDayValueStr+nowHourValueStr+minitueValue_mod_2_str;
						}
					}catch(e){}
					</script> --%>
					<script>
					 if(document.getElementById("deadline${col.affairId}").innerHTML.length==0){document.getElementById("deadline${col.affairId}").innerHTML="无";}
					</script>
				</v3x:column>
				<%--流程期限时间   V5和G6都不显示了 --%>
				<%--
				<v3x:column width="11%" type="String" label="process.deadlineTime.label" className="cursor-hand sort deadline-${col.summary.worklfowTimeout}"
				read="${isRead}"  onClick="${click}" alt="${v3x:_(pageContext, isOvertop)}" >
					<span id="deadlineTime${col.affairId}">${v3x:showDeadlineTime(col.summary.createTime,col.summary.deadline)!=null?(v3x:showDeadlineTime(col.summary.createTime,col.summary.deadline)):"无"}</span>
					<script>
					 if(document.getElementById("deadline${col.affairId}").innerHTML!="无"){document.getElementById("deadlineTime${col.affairId}").innerHTML="无";}
					</script>
                </v3x:column>
                --%>

				<v3x:column width="9%" type="String" align="center" label="edoc.isTrack.label">
					<div class="link-blue" onclick="preChangeTrack('${col.affairId}', '${col.track}','${col.finshed}')">
			    		<span id="track${col.affairId}">
						<c:if test="${col.track==0}"><fmt:message key='edoc.form.no' /></c:if>
						<c:if test="${col.track==1 or col.track==2}"><fmt:message key='edoc.form.yes' /></c:if>

						</span>
			    	</div>
				</v3x:column>
				<!-- lijl添加如果isArchive等于true则隐藏div -->
				<v3x:column width="9%" type="String" align="center" label="edoc.edoctitle.ispig.label">
				    <span>
				      <c:if test="${col.summary.hasArchive}"><fmt:message key='edoc.form.yes' /></c:if>
                         <c:if test="${!col.summary.hasArchive}"><fmt:message key='edoc.form.no' /></c:if>					      
				    </span>
				</v3x:column>

				<v3x:column width="7%" type="String" align="center" label="processLog.list.title.label" >
					<span onclick="showDetailAndLog('${col.summary.id}','${col.summary.processId}','','${col.summary.edocTypeEnum}','<fmt:message key="edoc.list.done.processLog.label" />');" class="ico16 view_log_16 cursor-hand" align="center"></span>
				</v3x:column>
				<%--交换方式 --%>
				<c:if test="${v3x:hasPlugin('sursenExchange') && isOpenRegister != 'true' && edocType == 1}"> 
					<v3x:column width="10%" type="String" onClick="${click}" 
						label="edoc.exchangeMode" className="cursor-hand sort" symbol="...">  <%-- 交换方式 --%> 
						<c:if test="${col.exchangeMode==0 || col.bodyType != 'gd'}"><fmt:message key='edoc.exchangeMode.internal'/></c:if> <%-- 内部公文交换 --%> 
						<c:if test="${col.exchangeMode==1  || col.bodyType == 'gd'}"><fmt:message key='edoc.exchangeMode.sursen'/></c:if> <%-- 书生公文交换 --%>
					</v3x:column>
				</c:if>

			</v3x:table>
			</form>
		</div>
  </div>
</div>

<%--puyc添加收文转发文 --%>
    <input type="hidden" value="0" name="forwardCheckOption" id="forwardCheckOption"/>
    <input type="hidden" name="newContactReceive" id="newContactReceive"/>
<%--puyc添加收文转发文  结束--%>

<%--<c:if test="${not empty flash}" >
    <c:out value="${flash}" escapeXml="false" />
</c:if>--%>
<iframe name=tempIframe id=tempIframe style="height:0px;width:0px;"></iframe>
<script type="text/javascript">
<!--
initIpadScroll("scrollListDiv",550,870);
//showDetailPageBaseInfo("detailFrame", "<fmt:message key='edoc.workitem.state.sended' />", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_2012"));
showCondition("${v3x:escapeJavascript(param.condition)}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
//-->
initIpadScroll("scrollListDiv",550,870);
</script>
${v3x:showAlert(pageContext)}
</body>
</html>