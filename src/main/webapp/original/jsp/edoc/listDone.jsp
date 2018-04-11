<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Insert title here</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp" %>
<%@ include file="/WEB-INF/jsp/edoc/lock/edocLock_js.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript">
var jsEdocType=${edocType};
var alert_cannotTakeBack = "<fmt:message key='edoc.takeBack.flowEnd.alert' />";
var isGourpBy = "${isGourpBy}";
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/listDone.js${v3x:resSuffix()}" />"></script>
<style>
SELECT{
		FONT-SIZE: 10pt; 
		FONT-FAMILY: Times New Roman;
		MARGIN-TOP:1px;
}
.mxtgrid Div.bDiv td div{
padding-bottom:2px;
}
.mxtgrid Div.bDiv td div.link-blue{
padding-top:0;
}
</style>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body scroll="no" onload="setMenuState('menu_done');">
<input type="hidden" id="currentUserId" value="${currentUserId }"/>
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td id="toolbarTd" height="26" width="50" class="webfx-menu-bar">
			    	<script type="text/javascript">
			    	var userResources = '<c:out value="${CurrentUser.resourceJsonStr}" default="null" escapeXml="false"/>';
			    	var edocContorller="${detailURL}";
			    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			    	//myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />", "pigeonholeForEdoc('finish',jsEdocType);", [1,9], "", null));
			    	if("${v3x:hasPlugin('doc')}"=='true'){
				    	var pigeonholemain=new WebFXMenu;
				    	pigeonholemain.add(new WebFXMenuItem("","<fmt:message key='edoc.action.companypigeonhole.label'/>","pigeonholeForEdoc('finish','','0')",""));
				    	<%-- pigeonholemain.add(new WebFXMenuItem("","<fmt:message key='edoc.action.DepartPigeonhole.label'/>","pigeonholeForEdoc('<%=ApplicationCategoryEnum.edoc.getKey()%>','',1)","")); --%>
				        pigeonholemain.add(new WebFXMenuItem("","<fmt:message key='edoc.action.DepartPigeonhole.label'/>","listDepartPigeonhole('<%=ApplicationCategoryEnum.edoc.getKey()%>','true')","")); 
				        //多浏览器屏蔽
				       // if("${v3x:getBrowserFlagByRequest('HideBrowsers', pageContext.request)}"=="true") {
							myBar.add(new WebFXMenuButton("pigeonhole","<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />",null,[1,9],"",pigeonholemain));
				      }
			    //	}
			    	//具有公文发起权的角色拥有“转发文”操作
		    		if('${edocType}'=='1') {//xiangfan 添加 发文管理 不需要 '转发文'功能
		    			//多浏览器屏蔽
		    			//if("${v3x:getBrowserFlagByRequest('HideBrowsers', pageContext.request)}"=="true") {
			    			//var resourceKey = "F07_sendNewEdoc";
			    			var resourceKey = "F07_sendManager";
			    			
							if(hasEdocResourceCode(resourceKey)) {
					    	    myBar.add(new WebFXMenuButton("", "<fmt:message key='edoc.new.type.forwardarticle' />", "javascript:showForwardWDTwo()", [1,7], "", null));
							}
		    			//}
					}
			    		
			    	if(v3x.getBrowserFlag('hideMenu')){
			    		myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.takeBack.label' bundle='${v3xCommonI18N}' />", "javascript:takeBack('finish')", [4,1], "", null));
			    	}
		    	
					<c:if test="${ctp:hasPlugin('doc')}">
						if((userResources.indexOf("F07_sendModArch") > 0  && jsEdocType==0)||
				    	   (userResources.indexOf("F07_signModArch") > 0 &&jsEdocType==2))
				    	{
				    	   myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "javascript:editFromArchived('${edocType}')", [1,2], "", null));    	
				    	   myBar.add(new WebFXMenuButton("", "<fmt:message key='toolbar.updatehistory.label'/>", "javascript:showArchiveModifyLog_iframe()", [18,5], "", null));    	
				    	}
					</c:if>
			    	
			    	
			    	   myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "javascript:deleteItems('finish')", [1,3], "", null));    
			    	   
					<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
			    	</script>	
			    	<span id="toolbarLocation"></span>
				</td>
				<%--同一流程只显示最后一条 --%> 
				<td height="26" class="webfx-menu-bar">
					&nbsp;&nbsp;<label class="isGourpBy"><input type="checkbox" ${isGourpBy == "true" ? 'checked="checked"' : '' } name="isGourpBy" id="isGourpBy" value="1" /><fmt:message key="edoc.list.isGroupBy"/></label>
				</td>
				<td class="webfx-menu-bar"><form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
					<input type="hidden" value="<c:out value='${param.method}' />" name="method">
					<input type="hidden" id="deduplication" name="deduplication" value="" />
					<input type="hidden" id="appName" name="appName" value='<%=ApplicationCategoryEnum.edoc.getKey()%>'/>
					<!-- 单位归档  部门归档 -->
					<input type="hidden" value="<c:out value='${edocType}' />" name="edocType">		
					<input type="hidden" id="listType" name="listType" value="${param.listType }"/>	
					<input type="hidden" name="track" value="${param.track}" />
					<div class="div-float-right">
						<div class="div-float">
							<select name="condition" id= "condition" onChange="showNextSpecialCondition(this)" class="condition" style="width:90px">
						    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							    <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
							    <option value="docMark"><fmt:message key="edoc.element.wordno.label" /></option>
							    <option value="docInMark"><fmt:message key="edoc.element.wordinno.label" /></option>
							    <option value="startMemberName"><fmt:message key="common.sender.label" bundle="${v3xCommonI18N}" /></option>
							    <option value="createDate"><fmt:message key="edoc.supervise.startdate" /></option>
							    
							    <c:if test="${edocType==0 or edocType==2}">
								    <option value="receiveTime"><fmt:message key="node.receivetime"/></option>
								    <%-- 根据国家行政公文规范,去掉主题词
								    <option value="keywords"><fmt:message key="edoc.element.keyword"/></option> --%>
								    <option value="secretLevel"><fmt:message key="edoc.element.secretlevel.simple"/></option>
								    <option value="urgentLevel"><fmt:message key="edoc.element.urgentlevel"/></option>
							    </c:if>	
							    
							    <c:if test="${edocType==1}">
								    <option value="registerDate"><fmt:message key="edoc.element.register.date"/></option>
									<option value="recieveDate"><fmt:message key="edoc.element.receipt_date"/></option>
                                    <c:if test="${isG6=='true'}">
								        <option value="edocUnit"><fmt:message key="edoc.element.receive.edoc_unit"/></option>
                                    </c:if>
								    <option value="urgentLevel"><fmt:message key="edoc.element.urgentlevel"/></option>
								    <option value="secretLevel"><fmt:message key="edoc.element.secretlevel.simple"/></option>
							    </c:if>	
						  	</select>
					  	</div>
					  	<div id="subjectDiv" class="div-float hidden"><input type="text" id="textfield" name="textfield" class="textfield"></div>
					  	<div id="startMemberNameDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="docMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="docInMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="createDateDiv" class="div-float hidden">
					  		<input type="text" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
					  		-
					  		<input type="text" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
					  	</div>
					  	<c:if test="${edocType==0 or edocType==2}">
						  	<div id="receiveTimeDiv" class="div-float hidden">
						  		<input type="text" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
						  		-
						  		<input type="text" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
						  	</div>
						  	<div id="secretLevelDiv" class="div-float hidden">
						  		<select name="textfield" class="condition" style="width:90px">
						  			<option value=""><fmt:message key="common.pleaseSelect.label" /></option>
						  			<c:forEach var="secret" items="${colMetadata['edoc_secret_level'].items}"> 
						  				<c:if test="${secret.outputSwitch == 1}">
						  				<option value="${secret.value}">
						  					<c:choose>
											<c:when test="${secret.i18n == 1 }">
											${v3x:_(pageContext, secret.label)}
											</c:when>
											<c:otherwise>
											${ctp:toHTML(secret.label)}
											</c:otherwise>
											</c:choose>
						  				</option>
						  				</c:if>
						  			</c:forEach>
						  		</select>	
						  	</div>
						  	<div id="urgentLevelDiv" class="div-float hidden">
						  		<select name="textfield" class="condition" style="width:90px">
						  			<option value=""><fmt:message key="common.pleaseSelect.label" /></option>
						  			<c:forEach var="urgent" items="${colMetadata['edoc_urgent_level'].items}"> 
						  				<c:if test="${urgent.outputSwitch == 1}">
						  				<option value="${urgent.value}">
						  				<c:choose>
											<c:when test="${urgent.i18n == 1 }">
											${v3x:_(pageContext, urgent.label)}
											</c:when>
											<c:otherwise>
											${ctp:toHTML(urgent.label)}
											</c:otherwise>
											</c:choose>
						  				</option>
						  				</c:if>
						  			</c:forEach>
						  		</select>
						  	</div>
					  	</c:if>	
					  	
					  	<c:if test="${edocType==1}">
					  	    <div id="registerDateDiv" class="div-float hidden">
                                <input type="text" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
                                -
                                <input type="text" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
                            </div>
                            <div id="recieveDateDiv" class="div-float hidden">
                                <input type="text" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
                                -
                                <input type="text" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
                            </div>
	                        <c:if test="${isG6=='true'}">
						  	   <div id="edocUnitDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
						  	</c:if>
						  	<div id="urgentLevelDiv" class="div-float hidden">
                                <select name="textfield" class="condition" style="width:90px">
                                    <option value=""><fmt:message key="common.pleaseSelect.label" /></option>
                                    <c:forEach var="urgent" items="${colMetadata['edoc_urgent_level'].items}"> 
                                        <option value="${urgent.value}">
                                        <c:choose>
                                            <c:when test="${urgent.i18n == 1 }">
                                            ${v3x:_(pageContext, urgent.label)}
                                            </c:when>
                                            <c:otherwise>
                                            ${ctp:toHTML(urgent.label)}
                                            </c:otherwise>
                                            </c:choose>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
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
											${ctp:toHTML(secret.label)}
											</c:otherwise>
											</c:choose>
									</option>
						  			</c:forEach>
						  		</select>	
						  	</div>
					  	</c:if>
					  	<div onclick="javascript:searchDateCheck(searchForm);" class="div-float condition-search-button"></div>
				  	</div></form>
				</td>	
				<td  class="webfx-menu-bar border-right" width="3%">
				<form name="combForm" id="combForm" method="post" onsubmit="return false" style="margin: 0px">
				  <input type="hidden" name="listType" value="${param.listType }"/>	
				  <input type="hidden" name="track" value="${param.track}" />
				  <input type="hidden" name="deduplication" value="${isGourpBy}" />
				  <INPUT TYPE="hidden" name="comb_condition" id="comb_condition" value="${combCondition}" />
				  <INPUT TYPE="hidden" name="subject" id="comb_subject" value="${v3x:toHTML(combQueryObj.subject)}" />
				  <INPUT TYPE="hidden" name="docMark" id="comb_docMark" value="${v3x:toHTML(combQueryObj.docMark)}" />
				  <INPUT TYPE="hidden" name="serialNo" id="comb_serialNo" value="${v3x:toHTML(combQueryObj.serialNo)}" />
				  <INPUT TYPE="hidden" name="createPerson" id="comb_createPerson" value="${v3x:toHTML(combQueryObj.createPerson)}" />
				  <INPUT TYPE="hidden" name="createTimeB" id="comb_createTimeB" value="<fmt:formatDate value="${combQueryObj.createTimeB}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="createTimeE" id="comb_createTimeE" value="<fmt:formatDate value="${combQueryObj.createTimeE}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="secretLevel" id="comb_secretLevel" value="${combQueryObj.secretLevel}" />
				  <INPUT TYPE="hidden" name="urgentLevel" id="comb_urgentLevel" value="${combQueryObj.urgentLevel}" />
				  <INPUT TYPE="hidden" name="keywords" id="comb_keywords" value="${v3x:toHTML(combQueryObj.keywords)}" />
				  <INPUT TYPE="hidden" name="receiveTimeB" id="comb_receiveTimeB" value="<fmt:formatDate value="${combQueryObj.receiveTimeB}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="receiveTimeE" id="comb_receiveTimeE" value="<fmt:formatDate value="${combQueryObj.receiveTimeE}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="sendUnit" id="comb_sendUnit" value="${v3x:toHTML(combQueryObj.sendUnit)}" />
				  <INPUT TYPE="hidden" name="registerDateB" id="comb_registerDateB" value="<fmt:formatDate value="${combQueryObj.registerDateB}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="registerDateE" id="comb_registerDateE" value="<fmt:formatDate value="${combQueryObj.registerDateE}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="recieveDateB" id="comb_recieveDateB" value="<fmt:formatDate value="${combQueryObj.recieveDateB}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="recieveDateE" id="comb_recieveDateE" value="<fmt:formatDate value="${combQueryObj.recieveDateE}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="expectprocesstimeB" id="comb_expectprocesstimeB" value="<fmt:formatDate value="${combQueryObj.expectprocesstimeB}" pattern="yyyy-MM-dd" />" />
				  <INPUT TYPE="hidden" name="expectprocesstimeE" id="comb_expectprocesstimeE" value="<fmt:formatDate value="${combQueryObj.expectprocesstimeE}" pattern="yyyy-MM-dd" />" />
				  <!--<input type="button"  style="height:22px;" name="btn"  onclick="combQueryEvent(${edocType},4)" value="<fmt:message key='common.combsearch.label'/>">-->
				  <input type="hidden" id="isCombSearchFlag" name="isCombSearchFlag" value="${combQueryObj.isCombSearchFlag}"/>	
				  <div style="font-size: 15px;	">
						<a id="combinedQuery" onclick="combQueryEvent(${edocType},4)" ><fmt:message key='edoc.advanced.lable'/></a>
                   </div>
				</form>
				</td>		
			</tr>   
		</table>
    
     <script type="text/javascript">
         //toolbar
         document.getElementById("toolbarLocation").outerHTML = myBar.toString();
     </script>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
		<input type="hidden" id="archiveId" name="archiveId" value=""/>	
		<c:url value='/common/images/overTime.gif' var="overTime" />
		<c:url value='/common/images/timeout.gif' var="timeOut" />
		<input type="hidden" id="pigeonholeType" name="pigeonholeType" value=""/>
		<v3x:table htmlId="pending" data="pendingList" var="col" className="sort ellipsis">
                
            <v3x:column width="3%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${col.summary.id}" affairId="${col.affairId}" processId="${col.summary.processId}" 
				nodePolicy="${col.nodePolicy}" hasArchive="${col.summary.hasArchive}" subject="${col.summary.subject}" finished="${col.finshed}" archiveId="${col.summary.archiveId}" workitemId="${col.affair.subObjectId}" caseId="${col.caseId}" activityId="${col.affair.activityId}" summaryBodyType="${col.bodyType}"/>
			</v3x:column>			

			<c:set var="click" value="openDetail('', 'from=Done&affairId=${col.affairId}')"/>
			<c:set var="isRead" value="true"/>
			<v3x:column width="6%" type="String" label="edoc.element.secretlevel.simple" className="cursor-hand sort" read="${isRead}"
			  onClick="${click}">
			<span title="<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/>"><v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/></span>&nbsp;
			</v3x:column>
			
			<v3x:column width="6%" type="String" label="edoc.element.urgentlevel" className="cursor-hand sort" read="${isRead}"
			  onClick="${click}">
			<span title="<v3x:metadataItemLabel metadata="${colMetadata.edoc_urgent_level}" value="${col.summary.urgentLevel}"/>"><v3x:metadataItemLabel metadata="${colMetadata.edoc_urgent_level}" value="${col.summary.urgentLevel}"/></span>&nbsp;
			</v3x:column>  

            <v3x:column width="25%" type="String"  label="common.subject.label" className="cursor-hand sort proxy-${col.proxy}"
                    bodyType="${col.bodyType}" hasAttachments="${col.summary.hasAttachments}" importantLevel="${col.summary.urgentLevel}" 
                    onClick="${click}"  value="${col.summary.subject}" alt="${col.summary.subject}" 
                    symbol="..." flowState="${col.summary.state}">
                    </v3x:column>
			
			<%--<c:if test='${col.deadLine>0}'>
			<v3x:column width="26%" maxLength="38"  symbol="..." type="String" label="common.subject.label" className="cursor-hand sort mxtgrid_black" read="${isRead}"
			bodyType="${col.bodyType}" value="${col.summary.subject}" hasAttachments="${col.summary.hasAttachments}"  onClick="${click}" 
			extIcons="${(col.deadLine ne null && col.deadLine ne ''&& col.deadLine ne '0') ? (col.overtopTime eq true ? timeOut : overTime) : null}"
			/></c:if>
			<c:if test='${col.deadLine<=0}'>
			<v3x:column width="26%" maxLength="34"  symbol="..." type="String" label="common.subject.label" className="cursor-hand sort mxtgrid_black" read="${isRead}"
			bodyType="${col.bodyType}" value="${col.summary.subject}" hasAttachments="${col.summary.hasAttachments}"  onClick="${click}" 
			/></c:if>--%>
			
			<v3x:column width="15%" type="String" label="edoc.element.wordno.label" className="cursor-hand sort" read="${isRead}"
			 onClick="${click}">
				<span title="${v3x:toHTML(col.summary.docMark)}">${v3x:toHTML(col.summary.docMark)}</span>&nbsp;
			</v3x:column>
			<v3x:column width="12%" type="String" label="edoc.element.wordinno.label" className="cursor-hand sort" read="${isRead}"
			 onClick="${click}">
				<span title="${v3x:toHTML(col.summary.serialNo)}">${v3x:toHTML(col.summary.serialNo)}</span>&nbsp;
			</v3x:column>
			<v3x:column width="7%" type="String" label="common.sender.label"
			className="cursor-hand sort" read="${isRead}"
			 onClick="${click}">
				<span title="${col.summary.startMember.name}">${col.summary.startMember.name}</span>&nbsp;
			</v3x:column>
			<v3x:column width="12%" type="Date" label="edoc.supervise.startdate"  className="cursor-hand sort" read="${isRead}"
			 onClick="${click}">
				<span title="<fmt:formatDate value="${col.summary.createTime}" pattern="${datePattern}"/>"><fmt:formatDate value="${col.summary.createTime}" pattern="${datePattern}"/></span>&nbsp;
			</v3x:column>	
			<v3x:column width="14%" type="Date" label="edoc.supervise.managedate"  className="cursor-hand sort" read="${isRead}"
			 onClick="${click}">
				<span title="<fmt:formatDate value="${col.dealTime}" pattern="${datePattern}"/>"><fmt:formatDate value="${col.dealTime}" pattern="${datePattern}"/></span>&nbsp;
			</v3x:column>
			<v3x:column width="11%" type="String" symbol="..."  alt="${col.currentNodesInfo}" label="edoc.list.currentNodesInfo.label" className="cursor-hand sort" read="${isRead}"
			 >
			 <a href="javascript:void(0)" onclick="showFlowChart('${col.summary.caseId }','${col.summary.processId }','${col.summary.templeteId }','${col.affair.activityId}');">${col.currentNodesInfo}</a>
			</v3x:column>	
			
            <v3x:column width="8%" type="String" label="edoc.node.cycle.label" className="cursor-hand sort"  read="${isRead}"  onClick="${click}" alt="${v3x:_(pageContext, isOvertop)}" >
				<c:choose>
				   <c:when test="${col.surplusTime[0] == '0' && col.surplusTime[1] == '0' && col.surplusTime[2] == '0'}">
				 	<span title=" ${col.dealLineDateTime}"  pattern="${datePattern}"/><font color="red">${col.dealLineDateTime}</font></span>&nbsp;
				   </c:when>
				   <c:when test="${col.surplusTime[0] <=0 && col.surplusTime[1] <=0 && col.surplusTime[2] <=0}">
						<span title=" ${col.dealLineDateTime}"  pattern="${datePattern}"/><font color="red">${col.dealLineDateTime}</font></span>&nbsp;
					</c:when>
					<c:otherwise>
						<span title=" ${col.dealLineDateTime}"  pattern="${datePattern}"/>${col.dealLineDateTime}</span>&nbsp;
					</c:otherwise>
				</c:choose>	
			</v3x:column>
			
			<v3x:column width="6%" type="String" align="center" label="edoc.isTrack.label">
				<div class="link-blue" style="display:inline" onclick="preChangeTrack('${col.affairId}', '${col.track}')">
		    			<span id="track${col.affairId}">
						<c:if test="${col.track==0}"><fmt:message key='edoc.form.no' /></c:if>
						<c:if test="${col.track==1 || col.track ==2}"><fmt:message key='edoc.form.yes' /></c:if> 
							
						</span>
		    	</div>
			</v3x:column>
			<v3x:column width="8%" type="Number" align="center" label="hasten.number.label" className="cursor-hand sort" read="${isRead}"
			 onClick="${click}" value="${col.hastenTimes}">					
			</v3x:column>
			<!-- lijl添加流程日志 -->
			<v3x:column width="9%" type="String" align="center" label="processLog.list.title.label" >
				<span onclick="showDetailAndLog('${col.summary.id}','${col.summary.processId}','','${col.summary.edocTypeEnum}','<fmt:message key="edoc.list.done.processLog.label" />');" class="ico16 view_log_16 cursor-hand"></span>
			</v3x:column>  
			    
                
			<%--
			<v3x:column width="10%" type="String" align="center" label="processLog.list.title.label" >
				<img src="<c:url value='/apps_res/collaboration/images/workflowDetail.gif' />" onclick="showProcessLog('${col.summary.processId}');" class="cursor-hand sort">
			</v3x:column>
			--%>
		</v3x:table>
		</form>  
    </div>
  </div>
</div>
<%--
<!-- 转发文Form author:wangwei-->
<form name="checkElementForm" action="edocController.do?method=newEdoc" method="post">  
    <input type="hidden" value="" name="edocId" id="edocId"/>
    <input type="hidden" value="0" name="edocType"/>
     <input type="hidden" value="forwordtosend" name="comm" id="comm"/>
    <input type="hidden" value="0" name="checkOption" id="checkOption"/>
</form>
<!-- 转发文Form -->
 --%>
<%--puyc添加收文转发文 --%>
    <input type="hidden" value="0" name="forwardCheckOption" id="forwardCheckOption"/>
    <input type="hidden" name="newContactReceive" id="newContactReceive"/>
<%--puyc添加收文转发文  结束--%>
<iframe name=tempIframe id=tempIframe style="height:0px;width:0px;"></iframe>
<script type="text/javascript">
<!--
initIpadScroll("scrollListDiv",550,870);
//showDetailPageBaseInfo("detailFrame", "<fmt:message key='edoc.workitem.state.done' />", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_2014"));
showCondition("${v3x:escapeJavascript(param.condition)}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
//-->
initIpadScroll("scrollListDiv",550,870);
</script>
${v3x:showAlert(pageContext)}

</body>
</html>