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
</script>
<style>
SELECT{
		FONT-SIZE: 10pt;
		FONT-FAMILY: Times New Roman;
		MARGIN-TOP:1px;
}
</style>
</head>
<body scroll="no" onload="setMenuState('menu_zcdb');">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2 webfx-menu-bar">
		<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
			    	<script type="text/javascript">
			    	var edocContorller="${detailURL}";
			    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");

			    	if(v3x.getBrowserFlag('hideMenu')){
			    		myBar.add(new WebFXMenuButton("batch", "<fmt:message key='batch.title' bundle='${v3xCommonI18N}'/>", "javascript:parent.parent.parent.batchEdoc(document.getElementsByName('id'),document.getElementById('listType').value,'${edocType}')", [10,1], "", null));
					}

			    	//GOV-4749 收文待办列表，【全部】和【待办】页签下均有"转发文"操作，唯独【在办】页签下没有，而实际上在办收文也是可以转发文的，不符合逻辑。
		    		if('${edocType}'=='1') {//xiangfan 添加 发文管理 不需要 '转发文'功能
		    			//多浏览器屏蔽
		    			//if("${v3x:getBrowserFlagByRequest('HideBrowsers', pageContext.request)}"=="true") {
			    			//var resourceKey = "F07_sendNewEdoc";
			    			var resourceKey = "F07_sendManager";
							if(hasEdocResourceCode(resourceKey)) {
					    	    myBar.add(new WebFXMenuButton("", "<fmt:message key='${newForwardaRrticle}' />", "javascript:showForwardWDTwo()", [1,7], "", null));
						   	}
		    			//}
		    		}
			    	<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
			    	</script>
			    	<span id="toolbarLocation"></span>
				</td>
				<td><form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false">
					<input type="hidden" value="<c:out value='${param.method}' />" name="method">
					<input type="hidden" value="<c:out value='${param.listType}' />" name="listType">
					<input type="hidden" value="<c:out value='${param.track}' />" name="track">
					<input type="hidden" value="<c:out value='${edocType}' />" name="edocType">
					<div class="div-float-right">
						<div class="div-float">
							<select name="condition" id="condition" onChange="showNextSpecialCondition(this)" class="condition" style="width:90px">
						    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							    <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
							    <option value="docMark"><fmt:message key="edoc.element.wordno.label" /></option>
							    <option value="docInMark"><fmt:message key="edoc.element.wordinno.label" /></option>
							    <option value="startMemberName"><fmt:message key="common.sender.label" bundle="${v3xCommonI18N}" /></option>
							    <option value="createDate"><fmt:message key="edoc.supervise.startdate"/></option>

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
                                 <option value="expectprocesstime"><fmt:message key="process.expectprocesstime.label"/></option>
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
						<div id="expectprocesstimeDiv" class="div-float hidden">
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

	                                        ${v3x:_(pageContext,urgent.label)}

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
                                        <c:if test="${urgent.outputSwitch == 1}">
                                        <option value="${urgent.value}">
                                        <c:choose>
                                            <c:when test="${urgent.i18n == 1 }">

                                            ${v3x:_(pageContext,urgent.label)}

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
                        </c:if>
					  	<div onclick="javascript:searchDateCheck(searchForm);" class=" div-float condition-search-button"></div>
				  	</div></form>
				</td>
				<td class="webfx-menu-bar border-right" width="3%" >
				<form name="combForm" id="combForm" method="post" onsubmit="return false" style="margin: 0px">
				  <input type="hidden" value="<c:out value='${param.listType}' />" name="listType" id="listType">
				  <input type="hidden" value="<c:out value='${param.track}' />" name="track">
				  <input type="hidden" value="<c:out value='${edocType}' />" name="edocType">
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
				<!-- <input type="button"  style="height:22px;" name="btn"  onclick="combQueryEvent(${edocType},5)" value="<fmt:message key='common.combsearch.label'/>">--> 
				  <div style="font-size: 15px;	">
						<a id="combinedQuery" onclick="combQueryEvent(${edocType},5)" ><fmt:message key='edoc.advanced.lable'/></a>
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
		<c:url value='/common/images/overTime.gif' var="overTime" />
		<c:url value='/common/images/timeout.gif' var="timeOut" />
		<v3x:table htmlId="pending" data="pendingList" var="col" className="sort ellipsis edocellipsis">
			<c:set value="${v3x:toHTML(col.summary.subject)}" var="subject"  />

               <v3x:column width="35" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${col.summary.id}" affairId="${col.affairId}" subject="${subject}"  summaryBodyType="${col.bodyType}"/>
			</v3x:column>

			<c:set var="click" value="openDetail('', 'from=Pending&affairId=${col.affairId}&from=Pending')"/>
			<c:set var="isRead" value="${col.state != 0}"/>
			<v3x:column width="10%" type="String" label="edoc.element.secretlevel.simple" className="cursor-hand sort" read="${isRead}"
			  onClick="${click}">
			<span title="<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/>"><v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/></span>&nbsp;
			</v3x:column>

            <%--
			<v3x:column width="27%"   symbol="..." type="String" label="common.subject.label" className="cursor-hand sort proxy-${col.proxy} mxtgrid_black" read="${isRead}"
			bodyType="${col.bodyType}" value="${col:showSubjectOfEdocSummary(col.summary, col.proxy, -1, col.proxyName,false)}" hasAttachments="${col.summary.hasAttachments}"  onClick="${click}"
			extIcons="${(col.deadLine ne null && col.deadLine ne ''&& col.deadLine ne '0') ? (col.overtopTime eq true ? timeOut : overTime) : null}"
			importantLevel="${col.summary.urgentLevel}"
			/>
            --%>

            <v3x:column width="27%"   symbol="..." type="String" label="common.subject.label" className="cursor-hand sort proxy-${col.proxy}" read="${isRead}"
            bodyType="${col.bodyType}"  hasAttachments="${col.summary.hasAttachments}"  onClick="${click}"
            extIcons="${(col.deadLine ne null && col.deadLine ne '' && col.deadLine ne '0') ? (col.overtopTime eq true ? timeOut : overTime) : null}"
            importantLevel="${col.summary.urgentLevel}"   alt="${col.summary.subject}" flowState="${col.summary.state}"
			>
				<c:if test="${col.proxy}">
					<font color="blue">${v3x:toHTML(col.summary.subject)}</font>
				</c:if>
				<c:if test="${!col.proxy}">
					${v3x:toHTML(col.summary.subject) }
				</c:if>
			</v3x:column>

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

			<v3x:column width="8%" type="String" label="edoc.node.cycle.label" className="cursor-hand sort" read="${isRead}"  onClick="${click}" alt="${v3x:_(pageContext, isOvertop)}" >
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
			
			<v3x:column width="12%" type="Number" align="center" label="edoc.supervise.surplusTime" className="cursor-hand sort" read="${isRead}"  onClick="${click}">
				<c:choose>
					<c:when test="${col.surplusTime == null}">
						<span title="<fmt:message key ='common.none' bundle ='${v3xCommonI18N}'/>"><fmt:message key ="common.none" bundle ="${v3xCommonI18N}"/></span>&nbsp;
					</c:when>
					<c:when test="${col.surplusTime[0] == '0' && col.surplusTime[1] == '0' && col.surplusTime[2] == '0'}">
						<span title="<fmt:message key ='node.isovertime' />"><font color="red"><fmt:message key ="node.isovertime" /></font></span>&nbsp;
					</c:when>
					<c:when test="${col.surplusTime[0] <= 0 && col.surplusTime[1] <=0 && col.surplusTime[2] <=0}">
						<span title="<fmt:message key ='node.isovertime' />"><font color="red"><fmt:message key ="node.isovertime" /></font></span>&nbsp;
					</c:when>
					<c:otherwise>
						<c:if test="${col.surplusTime[0] != 0}">
							${col.surplusTime[0]} <fmt:message key ="common.time.day" bundle="${v3xCommonI18N}"/>
						</c:if>
						<c:if test="${col.surplusTime[1] != 0}">
							${col.surplusTime[1]} <fmt:message key ="common.time.hour" bundle="${v3xCommonI18N}"/>
						</c:if>
						<c:if test="${col.surplusTime[2] != 0}">
							${col.surplusTime[2]} <fmt:message key ="common.time.minute" bundle="${v3xCommonI18N}"/>
						</c:if>
					</c:otherwise>
				</c:choose>
			</v3x:column>

			<v3x:column width="7%" type="Number" align="center" label="hasten.number.label" className="cursor-hand sort" read="${isRead}"
			 onClick="${click}" value="${col.hastenTimes}">
			</v3x:column>

			<v3x:column width="12%" type="Date" label="edoc.zcdbremindtime.label" className="cursor-hand sort" align="center" read="${isRead}"
			 onClick="${click}">
				<span title="<fmt:formatDate value="${col.zcdbTime}"  pattern="${datePattern}"/>"><fmt:formatDate value="${col.zcdbTime}"  pattern="${datePattern}"/></span>&nbsp;
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

<%--GOV-4749 收文待办列表，【全部】和【待办】页签下均有"转发文"操作，唯独【在办】页签下没有，而实际上在办收文也是可以转发文的，不符合逻辑。 --%>
    <input type="hidden" value="0" name="forwardCheckOption" id="forwardCheckOption"/>
    <input type="hidden" name="newContactReceive" id="newContactReceive"/>
<script type="text/javascript">
<!--
initIpadScroll("scrollListDiv",550,870);
showDetailPageBaseInfo("detailFrame", "<fmt:message key='edoc.workitem.state.pending' />", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_2013"));
showCondition("${v3x:escapeJavascript(param.condition)}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
//-->
</script>
</body>
</html>